Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2D64B986
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 17:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiLMQWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 11:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbiLMQW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:22:27 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536D9218A6
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:22:26 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f3so185738pgc.2
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zaap5+6k9xnl2/ObCLfBO94WYcDkHNOkC0txiUrIgO4=;
        b=euXZR4jH9nYMgAAGI1LEi/VsADpnRoqacT9f+78IVn6QA3dnjcHBcKFx+Oy65eE7R4
         SgOBCWdMm1kmOpZzRnmwIMvPy1EI0hTIyKEd9Y7SXTX+sj4arVFyK4SZXpACDjPrQPA9
         wDpz4JkAyfT+b+du4h2CTumj4C5pHaAwJHcXNJSY1iA05Qxv+H9e288SFE8zc9rfg+T/
         cX+ymydBJO4+V5PPkABQyyC0aAD1wdSrS4Z0lS8Ol2w+wFbmrMA5TEMNZ3jCa+JP8BZj
         DYpd4jWX+9zJtevO7IdHuA3H4JYdO1orPdADFK37K9smMkrJ3bostS2VL0xIbXz9K5wf
         epNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaap5+6k9xnl2/ObCLfBO94WYcDkHNOkC0txiUrIgO4=;
        b=3MDmKNh3PTOndmec5K2TG3UJa9QYORDKTvB8SdVrMK7KKUq00Uh9r7ScIamRZHtBOp
         zgD2EGUWZWA+VBCw01M78VSOVHU1+YL+pGLJFPplFMzsMBFPld5PzeFMEl6N276hqBLc
         Xc2ywIJ28JOgfIuLJGQzs14Vjvf7mcKNz+Z763A/z4UjXKAqinl+bwWpOHoitIIAuftj
         oyha6vldwBvb6A+JCYcAnnNccEObkqbLBQphivpMVKjiidjg60M25bqCDFoSgQl8CuJB
         48aEMpuSEuxzU5khuigSE10dSE6fBfS83yiVwEqqlGd3gfNzFy3vT+CtsJ1uhfMbLbiV
         tf+w==
X-Gm-Message-State: ANoB5pl6cnceDQpsuptTr7KrgFrup/Ig72iGpRzZAK10aydgaYapiuSw
        V1yjkbHLEyaNDhfQwWHloiCGVw==
X-Google-Smtp-Source: AA0mqf7myH0hLqmUJUprjanvVSZ8bftVut4ZN2MXprdtle75C+9cN/NFkwRDKvicphVjLW4pY75qgg==
X-Received: by 2002:a05:6a00:26c5:b0:576:fb7c:7aa3 with SMTP id p5-20020a056a0026c500b00576fb7c7aa3mr19534636pfw.14.1670948545770;
        Tue, 13 Dec 2022 08:22:25 -0800 (PST)
Received: from medve-MS-7D32 ([165.132.118.52])
        by smtp.gmail.com with ESMTPSA id k1-20020aa79721000000b00574f83c5d51sm7861239pfg.198.2022.12.13.08.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 08:22:25 -0800 (PST)
Date:   Wed, 14 Dec 2022 01:22:20 +0900
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr, Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: Re: [PATCH net v2] nfc: pn533: Clear nfc_target before being used
Message-ID: <20221213162220.GB109198@medve-MS-7D32>
References: <20221213142746.108647-1-linuxlovemin@yonsei.ac.kr>
 <decda09c-34ed-ce22-13c4-2f12085e99bd@linaro.org>
 <cd3a1383-9d6a-19ad-fd6e-c45da7e646b4@linaro.org>
 <20221213160358.GA109198@medve-MS-7D32>
 <0fb173e7-8810-6e3f-eff2-446cbfcc2eab@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fb173e7-8810-6e3f-eff2-446cbfcc2eab@linaro.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 05:05:27PM +0100, Krzysztof Kozlowski wrote:
> On 13/12/2022 17:03, Minsuk Kang wrote:
> > On Tue, Dec 13, 2022 at 03:41:36PM +0100, Krzysztof Kozlowski wrote:
> >> On 13/12/2022 15:38, Krzysztof Kozlowski wrote:
> >>> On 13/12/2022 15:27, Minsuk Kang wrote:
> >>>> Fix a slab-out-of-bounds read that occurs in nla_put() called from
> >>>> nfc_genl_send_target() when target->sensb_res_len, which is duplicated
> >>>> from an nfc_target in pn533, is too large as the nfc_target is not
> >>>> properly initialized and retains garbage values. Clear nfc_targets with
> >>>> memset() before they are used.
> >>>>
> >>>> Found by a modified version of syzkaller.
> >>>>
> >>>> BUG: KASAN: slab-out-of-bounds in nla_put
> >>>> Call Trace:
> >>>>  memcpy
> >>>>  nla_put
> >>>>  nfc_genl_dump_targets
> >>>>  genl_lock_dumpit
> >>>>  netlink_dump
> >>>>  __netlink_dump_start
> >>>>  genl_family_rcv_msg_dumpit
> >>>>  genl_rcv_msg
> >>>>  netlink_rcv_skb
> >>>>  genl_rcv
> >>>>  netlink_unicast
> >>>>  netlink_sendmsg
> >>>>  sock_sendmsg
> >>>>  ____sys_sendmsg
> >>>>  ___sys_sendmsg
> >>>>  __sys_sendmsg
> >>>>  do_syscall_64
> >>>>
> >>>> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
> >>>> Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
> >>>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> >>>
> >>> How did it happen? From where did you get it?
> >>
> >> I double checked - I did not send it. This is some fake tag. Please do
> >> not add fake/invented/created tags with people's names.
> > 
> > Sorry for my confusion.
> > 
> > https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L505
> > 
> > I missed the definition of the tag as I did not read the document
> > carefully and misunderstood that the tag simply means I have got a
> > reply from maintainers and I should manually attach it if that is
> > the case. I will rewrite the patch after I make sure I fully
> > understand the whole rules.
> 
> The document says:
> "By offering my Reviewed-by: tag, I state that:"
> 
> You need to receive it explicitly from the reviewer. Once received, but
> only then, add to the patch.

Thank you for your comment.
I won't forget it.

Best regards,
Minsuk
