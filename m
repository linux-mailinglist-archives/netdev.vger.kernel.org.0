Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504454D0D02
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245316AbiCHAvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245400AbiCHAvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:51:18 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC17329B4
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:50:21 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id r13so35721147ejd.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 16:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dbJpaOu/7xZ/bf4UCikgzAXZOJfFrMxYSG2Z5vNrDBI=;
        b=nQOEm1XQrASHzLPWYSNKp5uxS7raV2Xrr/QL60mtFRq0HPSH2fwlhXHItduWmhqhRg
         gUC031MpBStyvBQ2jZR+bEUfDR2p9p37sv4oJUX86m3P+8Iq+4RhT3+BTyyp4DGshE9D
         KDVfXeHGjIt9j8FdMfsI7Gf0IqudwdFPWuyJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dbJpaOu/7xZ/bf4UCikgzAXZOJfFrMxYSG2Z5vNrDBI=;
        b=Bv6tTDSmUCwusfovMQt9q7YzxIrAEzVOmZ0eHWnzxGmGkzCZgn37BClXFcWBpxIoyQ
         vrHHn9Q7WQJZ47MqHDvx/9tRCTMmOl4GDFlWxZc7uq/UhBJZc/eH0+/wS6FWsZ+VOf5U
         M+I3BcPv+dG9d7UP5RVUARBiTRES9mK1o39dDgCZzRqHKL2d4FZrGU1w+Euvw09oS2Db
         ngj15xiIY9g3ItaSuV2fnWMQONsa5gw12mOoi7QlNFawIuVLtNeNcQtuNc6TfQ1qWKmR
         lfrf/FmIHfL8Cgr/4Wl7dvynmSLbYXPsA5YeWQCLPyxhYAB9eMKTwbpOTS3AYnvuABxt
         8nhw==
X-Gm-Message-State: AOAM530ckOiZBsmccoMiO7bFf26SfVQ3Y2UYdL9HoUJPtuickFgKikSZ
        6bodopp8RdLNYFtbSZNj0fgndyEHWCqcfZHC
X-Google-Smtp-Source: ABdhPJwlRO4MzQ5itApaThPxZzySixAZKMEgUjgs3Ep/jWBLRcPEIcXtUzJKNNZTaEBOfZ9xWFSfIg==
X-Received: by 2002:a17:906:6a02:b0:6d7:cda:2cf7 with SMTP id qw2-20020a1709066a0200b006d70cda2cf7mr10945294ejc.53.1646700619977;
        Mon, 07 Mar 2022 16:50:19 -0800 (PST)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id o14-20020a170906774e00b006d5b915f27dsm5252261ejn.169.2022.03.07.16.50.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 16:50:19 -0800 (PST)
Received: by mail-wm1-f54.google.com with SMTP id n31-20020a05600c3b9f00b003898fc06f1eso470509wms.1
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 16:50:19 -0800 (PST)
X-Received: by 2002:a7b:c0c1:0:b0:385:be1b:e6a with SMTP id
 s1-20020a7bc0c1000000b00385be1b0e6amr1277359wmh.73.1646700618519; Mon, 07 Mar
 2022 16:50:18 -0800 (PST)
MIME-Version: 1.0
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
 <202201110851.5qAxfQJj-lkp@intel.com> <CACTWRwtCjXbpxkixAyRrmK5gRjWW7fMv5==9j=YcsdN-mnYhJw@mail.gmail.com>
 <87y23is7cp.fsf@kernel.org>
In-Reply-To: <87y23is7cp.fsf@kernel.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 7 Mar 2022 16:50:05 -0800
X-Gmail-Original-Message-ID: <CAD=FV=W-kJQwBPStsGpNu09dN+QHTEZOgb5sZwZYzWnn_Zhv4A@mail.gmail.com>
Message-ID: <CAD=FV=W-kJQwBPStsGpNu09dN+QHTEZOgb5sZwZYzWnn_Zhv4A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Abhishek Kumar <kuabhs@chromium.org>,
        kernel test robot <lkp@intel.com>,
        ath10k <ath10k@lists.infradead.org>, kbuild-all@lists.01.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle,

On Fri, Jan 14, 2022 at 6:46 AM Kalle Valo <kvalo@kernel.org> wrote:
>
> Abhishek Kumar <kuabhs@chromium.org> writes:
>
> > On this patch I have a kernel bot warning, which I intend to fix along
> > with all the comments and discussion and push out V3. So, any
> > comments/next steps are appreciated.
>
> Please wait my comments before sending v3, I think this is something
> which is also needed in ath11k and I need to look at it in detail.

I'm wondering if you have a timeframe for when you might post your
comments. We've landed this patch locally in the Chrome OS kernel
tree, but we are always also interested in it landing upstream. If you
have ideas for a path forward that'd be keen!

-Doug
