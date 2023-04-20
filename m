Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EE16E88D2
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjDTDnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjDTDnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:43:51 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1F944A2;
        Wed, 19 Apr 2023 20:43:50 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b781c9787so178511b3a.1;
        Wed, 19 Apr 2023 20:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681962230; x=1684554230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGcjJrKVdJthT5jHtVz62KZrTMfTo60gqcHwgky1M9o=;
        b=FCc/qGm6+G29tUJLe4kGCp99nHizxhCyIoVmVdv9gG1AGgxzNNG0Ym4ElJAPEDwqAf
         LFSpdcBlvcNC7DAGVSkKaHgmkzBLuBaWbVIk/XqnZ02VsyK9ZHX03FmIpF0D0xtfJ6li
         kH9kv5pcbl10bjBQvSducRMlhGqisnwu5FB2ZBsUKj/piISeCtlZIhcTItXJLYmLwUYy
         wf3CgoDrqKIoSUQtORCVopqo2sjQbpr7o79TsZzsWaD/KAHOub1dG9kCFmUI49LcTlUa
         5rs7GEoftI1tzdf3k2CdgOyxLdKQehsJHOv/010o5a/MBtAHYNZRHfmqEs0qIJmdCfY1
         8jMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681962230; x=1684554230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGcjJrKVdJthT5jHtVz62KZrTMfTo60gqcHwgky1M9o=;
        b=OtxzCrwdDLG0j9JgqdIXAl/qPIHw03iHjvedLCc1BHHlnDjJOkNxP+lV/SwdAGjmW3
         SEljFw6eWu5d1ds/YIo2nWE605TUZBYVb5m7iG/F3K1aASrikJJ4y2TYMOxiW8Aat4jk
         dGKNL2TZu4uOvTbPHyVz765aTuR/4QRxDUqVYqNP0NWcl7deDLWTxzHOTbt45hzJhJaf
         4IH0xc6nEhvXkuDlIiRQQ2GUk0J3FscxMwVYYrE9b6EF5MwI1Bj1paVlffS2jOvVLgBD
         lhzl1gPCkdXLYc3vi0VWFfTJMPB5KFwbw+m4ltRx0h9tDMh7bzpdBEQbb/Z+FH3zf6I/
         ZwTg==
X-Gm-Message-State: AAQBX9eerQCtJ6Ln8CC6rOLXrVO1rwEtIYVojOf72d9G1aDgR0a07tc1
        QwlrdkDam+IoXKxrVlYc9cU9Vil/B+g=
X-Google-Smtp-Source: AKy350YejakM543wXQPxP1eOvxQL1PSZzPWEdgrmCpGun8QQ8D66VT6iXwuH8Yu8e6fnr84gKm4SpA==
X-Received: by 2002:a05:6a20:914a:b0:f0:38a7:dc71 with SMTP id x10-20020a056a20914a00b000f038a7dc71mr78867pzc.4.1681962229801;
        Wed, 19 Apr 2023 20:43:49 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o1-20020a654581000000b0051fa7704c1asm139644pgq.47.2023.04.19.20.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 20:43:49 -0700 (PDT)
Date:   Wed, 19 Apr 2023 20:43:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Greenman, Gregory" <gregory.greenman@intel.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Stern, Avraham" <avraham.stern@intel.com>
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org>
 <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 01:35:50PM +0000, Greenman, Gregory wrote:

> Just a few clarifications. These two notifications are internal to iwlwifi, sent
> by the firmware to the driver.

Obviously.

> Then, the timestamps are added to the rx/tx status
> via mac80211 api.

Where?  I don't see that in the kernel anywhere.

Your WiFi driver would need to implement get_ts_info, no?

> Actually, we already have a functional implementation of ptp4l
> over wifi using this driver support.

Why are changes needed to user space at all?

Thanks,
Richard
