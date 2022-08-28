Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BDB5A3D36
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiH1Koc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 06:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiH1Koa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 06:44:30 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8634613CDB
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 03:44:28 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso6716614wmc.0
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 03:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=85rO0BXnVLcRaqiYDdjzNr1g4uH0voSH4cu9w//tBVc=;
        b=R71+93xpR/gNVc40Aesq8usMDWDhuRubeaTvUt5stGxlyPjw6VTLxM6nqBm/Evbw0t
         RPST3T6K0S2WEE9al8aMdfM7XWETD+LcEYLUTbfRX67rpuwtSkMKIja5voi79fC5rd83
         V9SV2YJTyqeRvxP1RdE0ymvYZjO7jCfSCRXYmLr8iCLAeB4MZZ6jPkF3RjMpfmIksL0P
         JJGK2XJkbsvg+l24gNp+7HnboGLpkU7PS1k3gbkhLYLy5wpIU3WSQVca8retsJCxsZEQ
         K89cTRHl6hvqCulyzvCZ7bK8ddPG9R7RXYp2YoibiwJN3d3ghD1ST8wLlVUi2a2hTUw+
         10jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=85rO0BXnVLcRaqiYDdjzNr1g4uH0voSH4cu9w//tBVc=;
        b=oBHjiuWFiDWqKRLtgmPr77hj08QD9IeifjxAxe4hOP5yW6pHIXqEE+GlNPK9KawBl0
         FkSk2E1Yg+Qv30c3cJWf/DyNuMolEcZDsI+yZgxdksJ4++mQ2Wo3A77SgTdCsmtOqsOr
         JEaB2bTWQDITqZrgnYWSaPGFRMoFA6r7r6K4fmullhcr5D3bXZb41+sQrzBiUG1bfZNJ
         uM5pj8tfUEWqavoOkrS526yvD4KrwmeIDZPMroMADW0hmkK+q8W9gbIENvtG623vlFc3
         bojrFUoOtHSLXubuuw1Lhz14R4rvHTqi9KOdIqDo9vdpBVUOzT7DVwOIjjk8U+3Enxh1
         /nYw==
X-Gm-Message-State: ACgBeo13Cfd/jTRES3SudF4cIBy7RRGHCvV2LK2GdQenHaD4f9yYKZDM
        4tnf79xCkbLOB087eq32VF3uRg==
X-Google-Smtp-Source: AA6agR5pJB1ycqIn1E2FAvrQUq+bYeyS5CvdIKtscf0H0i//AtxYNVhMJH975ePw5ly8d7dyKX7h7A==
X-Received: by 2002:a05:600c:4e8b:b0:3a5:f5bf:9c5a with SMTP id f11-20020a05600c4e8b00b003a5f5bf9c5amr4331825wmq.85.1661683467029;
        Sun, 28 Aug 2022 03:44:27 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id r38-20020a05600c322600b003a536d5aa2esm5196364wmp.11.2022.08.28.03.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 03:44:26 -0700 (PDT)
Date:   Sun, 28 Aug 2022 11:44:24 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Alexander Potapenko <glider@google.com>,
        ath9k-devel@qca.qualcomm.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
Message-ID: <YwtHCDTRMtXe/VTt@equinox>
References: <000000000000c98a7f05ac744f53@google.com>
 <000000000000734fe705acb9f3a2@google.com>
 <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com>
 <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
 <1a0b4d24-6903-464f-7af0-65c9788545af@I-love.SAKURA.ne.jp>
 <CAG_fn=Wq51FMbty4c_RwjBSFWS1oceL1rOAUzCyRnGEzajQRAg@mail.gmail.com>
 <46fee955-a5fa-fbd6-bcc4-d9344e6801d9@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46fee955-a5fa-fbd6-bcc4-d9344e6801d9@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 10:35:43AM +0900, Tetsuo Handa wrote:
> On 2022/08/26 0:09, Alexander Potapenko wrote:
> > On Thu, Aug 25, 2022 at 4:34 PM Tetsuo Handa
> > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >>
> >> Hello.
> > Hi Tetsuo,
> > 
> >> I found that your patch was applied. But since the reproducer tested only 0 byte
> >> case, I think that rejecting only less than sizeof(struct htc_frame_hdr) bytes
> >> is not sufficient.
> >>
> >> More complete patch with Ack from Toke is waiting at
> >> https://lkml.kernel.org/r/7acfa1be-4b5c-b2ce-de43-95b0593fb3e5@I-love.SAKURA.ne.jp .
> > 
> > Thanks for letting me know! I just checked that your patch indeed
> > fixes the issue I am facing.
> > If it is more complete, I think we'd indeed better use yours.
> 
> I recognized that "ath9k: fix an uninit value use in ath9k_htc_rx_msg()" is
> local to KMSAN tree.
> https://github.com/google/kmsan/commit/d891e35583bf2e81ccc7a2ea548bf7cf47329f40
> 
> That patch needs to be dropped, for I confirmed that passing pad_len == 8 below
> still triggers uninit value at ath9k_htc_fw_panic_report(). (My patch does not
> trigger at ath9k_htc_fw_panic_report().)
> 
>         fd = syz_usb_connect_ath9k(3, 0x5a, 0x20000800, 0);
>         *(uint16_t*)0x20000880 = 0 + pad_len;
>         *(uint16_t*)0x20000882 = 0x4e00;
>         memmove((uint8_t*)0x20000884, "\x99\x11\x22\x33\x00\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF", 16);
>         syz_usb_ep_write(fd, 0x82, 4 + pad_len, 0x20000880);
> 
> 
> 
> Also, that patch has a skb leak bug; according to comment for ath9k_htc_rx_msg()
> 
>  * Service messages (Data, WMI) passed to the corresponding
>  * endpoint RX handlers, which have to free the SKB.
> 
> , I think that this function is supposed to free skb if skb != NULL.
> 
> If dev_kfree_skb_any(skb) needs to be used when epid is invalid and pipe_id != USB_REG_IN_PIPE,
> why it is OK to use kfree_skb(skb) if epid == 0x99 and pipe_id != USB_REG_IN_PIPE ?
> 
> We don't call kfree_skb(skb) if 0 < epid < ENDPOINT_MAX and endpoint->ep_callbacks.rx == NULL.
> Why it is OK not to call kfree_skb(skb) in that case?
> 
> Callers can't pass such combinations? I leave these questions to ath9k developers...
>

Hi Tetsuo,

Thank you for this improved patch. My original one was somewhat naive
attempt at a resolution.

Regards,
Phil
