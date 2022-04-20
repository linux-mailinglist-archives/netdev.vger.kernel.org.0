Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27831508889
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 14:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354788AbiDTM5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 08:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiDTM5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 08:57:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D44C3CA4A;
        Wed, 20 Apr 2022 05:54:44 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j8so1675847pll.11;
        Wed, 20 Apr 2022 05:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cfKEQXfvPhG1kZ+YpMF2hReHRJMEZQRtVI8gWHNwJsE=;
        b=SJ9wrEqPvYtvq6u4My/rceS5j/aS5O0TKpsoPpclCoMwLTUcTsXrjY6k58GgXgJDjk
         tz01T2qFPAHZcwZXJgAwa/uoXApT+ETBGfmmTjkYZ9d86v15pp2JSMJBlS0X/emLIUnL
         FfaBsG1olGj+ebvEzoG/tMRz6g3iydpNPuDMUWlcJE2yd+4v/SWBiXyLES6jNIDlHD5l
         61Z4eLrfFF8CDN43J7Tz5JjM0Q/1AYgpPCyv7abRl+quV72pVPxZxKv/x7sKMu9XzVL5
         SWOxNuWj84mkapk9TS6KdbIbwNAjO5B36W7ddQDXFwsqyW2fnMzNSfySVXaXW0AshHBv
         GGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cfKEQXfvPhG1kZ+YpMF2hReHRJMEZQRtVI8gWHNwJsE=;
        b=CB5waa/HRh+d+PEZOBTarWNAVVd+jutVltwYQ/syYhdP1ahzJWS/Yd8CWc+0tUpxhi
         apIuHL8TT8wve1bT/bQjlAN2XCg0KdIDZzKJ3b7TtP33fw/Lde5/5brBMtjwrdbT92hk
         3n4UMQLzZo4aUGAVHMenPiiuti9HPFYUgeTjtW2Mvl+ees1w1yO0d0iqUEuGv0GWxCcf
         CU80fc0OiuB2mmHy8c0O+vTJAWPHC7m9eXQAmy2NExidbshT2sarWbEPNQd8FM4RTv06
         HaLDcReYldCvm1DoFrUtnQUDpgB9LJ8ghUfoUkAI7da0TIjNSNc/6F1Glv3CYhfdzxqv
         cC5Q==
X-Gm-Message-State: AOAM531KbE7+se02YKxJhGhBusIC+x85chjBTsCWwUEW9r68AfMo2BUu
        ZTByFwxa1wn/BekMuy9rH/w=
X-Google-Smtp-Source: ABdhPJyBl7o+zKhHc4HtlQRcXGENqCIJ11onw+S/lwrewiHQtnsX2ruF+ZGjWz971D6YhQis7geogw==
X-Received: by 2002:a17:90b:4f42:b0:1d2:d1fa:4df5 with SMTP id pj2-20020a17090b4f4200b001d2d1fa4df5mr4297398pjb.81.1650459284069;
        Wed, 20 Apr 2022 05:54:44 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o22-20020a17090a9f9600b001d0d20fd674sm15955961pjp.40.2022.04.20.05.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:54:42 -0700 (PDT)
Date:   Wed, 20 Apr 2022 05:54:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add fsleep() in HW Rx timestamp
 checking loop
Message-ID: <20220420125439.GA1401@hoboy.vegasvil.org>
References: <20220413040115.2351987-1-tee.min.tan@intel.com>
 <20220413125915.GA667752@hoboy.vegasvil.org>
 <20220414072934.GA10025@linux.intel.com>
 <20220414104259.0b928249@kernel.org>
 <20220419005220.GA17634@linux.intel.com>
 <20220419132853.GA19386@hoboy.vegasvil.org>
 <20220420051508.GA18173@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420051508.GA18173@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 01:15:08PM +0800, Tan Tee Min wrote:
> No. The context descriptor (frame) is possibly still owned by the
> DMA controller in this situation.

So that is a problem.  The solution is to postpone this logic until
the driver owns the buffer.  Doesn't the HW offer some means of
notification, like an interrupt for example?

Thanks,
Richard

