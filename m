Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2826C21D1
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCTTot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCTToW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:44:22 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3E818AA2;
        Mon, 20 Mar 2023 12:41:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o11so13707163ple.1;
        Mon, 20 Mar 2023 12:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679341284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VSdOb2idY0A4Wf9RBZ5/rjHAMbzrbF5fjVVZTsfyd9s=;
        b=CPt7FWsnH49LquByB+53jB/KWPraNgpEwyHpSYGfsKhkrliEIAq+yqGnjCWwfEV925
         qaub9h1dK1H+ExzsDjJf7SSKsJt2kCgX5O/Wh1xuuYN/dBmGWb2yr/axb/Dx9Fr/8m/Y
         XJk6g0NP1AY/KNoFFAZK4ufTUFdmsGjZ5bPtUTFOchtDlxlDS0USyh3HDlK3tapPoQHg
         9OA+/oYHjXr7UKftBRNjGjd00ri/+WuyviFkympvnKEtfz44D2ixGAoiY+U3uBC6lA9h
         vlvvv3KOqaR0tfdEToGECfJJZV6gAlg5fGaewzBsU14yKPVpkZUld7vwjDCwPGwEjZG0
         b71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679341284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSdOb2idY0A4Wf9RBZ5/rjHAMbzrbF5fjVVZTsfyd9s=;
        b=ru0ghEqjh0L6vJ+Orldp4VPxLVp1KgeIOO9Fpyueh9bVS18J9I0S0gJPcc0V6CpKjB
         r6/NNNw6iUkEPNkrOlFWlcuGnBiJtEfmfqUizn9g7esx5GEeEs+Oox/ADzp8bM8i0xDj
         ofmQ8/qxVEYa1Y+u8owWPFDdV3yYESXig9SXv4qzBVIQfR5dWgXQPo+kXnJPfzVPNDe4
         rvavoxOzdttBXWL4ww1h/NLNvRbWXxJb0z8K9SyA7lfWAD0Q31t6L4elptielIQ0vPAs
         xixAKdAFxQVcs52MhSbLnaHjOLK0lQsKBZtL5KGGdKP3WYdw+bP3jyCfRDJoDPiCBh0N
         cL0w==
X-Gm-Message-State: AO0yUKXgb9dsX+b+ARD2iUp+HtQYEM5yRUbhyRxo0B7K2s2iLxPcDIom
        gjCgO/pZxtiey4fDsdy2M+E=
X-Google-Smtp-Source: AK7set9tP2oTGPI6ls3wbIuCivxze2/j6fxKHCVRvfjZNDlskxNxDgrmI7XREVGCTHz6CHKbOCRUuw==
X-Received: by 2002:a17:903:2308:b0:19a:7060:948 with SMTP id d8-20020a170903230800b0019a70600948mr18654132plh.1.1679341283973;
        Mon, 20 Mar 2023 12:41:23 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902ee5500b0019aafc422fcsm7066584plo.240.2023.03.20.12.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 12:41:23 -0700 (PDT)
Date:   Mon, 20 Mar 2023 12:41:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Nicolas Pitre <nico@fluxnic.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
 <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
 <ZBDPKA7968sWd0+P@hoboy.vegasvil.org>
 <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
 <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
 <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:43:30AM -0400, Nicolas Pitre wrote:

> Alternatively the above commit can be reverted if no one else 
> cares. I personally gave up on the idea of a slimmed down Linux kernel a 
> while ago.

Does this mean I can restore the posix clocks back into the core
unconditionally?

That would be awesome.

Thanks,
Richard


