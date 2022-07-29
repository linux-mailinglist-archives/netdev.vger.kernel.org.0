Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E54584CE8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbiG2Hso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235367AbiG2Hsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:48:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE56983F04;
        Fri, 29 Jul 2022 00:47:50 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id va17so7222627ejb.0;
        Fri, 29 Jul 2022 00:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vb/4xNqjjpgzF1kxJ1LCdsXJmP1WMxVMwDr6haBvOao=;
        b=R8jJHdo8DqByRYGuQ7hqkEcTlA536GFVlR22Il6kcDcltGsooa+1tG3VOxi4Ttvayh
         pMhsbBWZW3AyIaZhc+0cyIkeC0eP+D0Hz6EbWWmx/URZLq1KZ05LJL7rb04NKbee2Xl4
         2VOynm7uhylcT/N/e/FDKmVqQ5qMEYEOc1gcAe/tRaCih6q2hYwgDl1fpEHUQhtTHBvl
         1kT+0b/PNC34e8mZj6sP2gbHjZAatTHipBslfxfivAH/MMEVdyaaM1Fc/3OOxTCPybia
         7AGe0zSUs0pvERe9F2hTlEgfYhmZ6yFqAfjbKHNDyZjuTKE6cxq24NcSCYBzjXFauNK/
         LCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vb/4xNqjjpgzF1kxJ1LCdsXJmP1WMxVMwDr6haBvOao=;
        b=gKcTXSt1nM36C/HiLyEyknquTgW6+Z5RwpC07GL/T7UcVrWZ3YgDzdImHcM3xNQIUI
         T5MHiqx3Z36PQYNWun7EHoaByzyGyqJKR0RwQOhhLVvI3kmhi7Xh33G6OtVhofYGkWCr
         6fcR04kdrL9+ysmUsqALNK3i6ol/9KNNoqePjzz4viMdoy7FjdZubo9qCSPDKKsGpQ+C
         W5dYNX9wgHw1emJ3zZn2qTc52L6bXTfBFl+UjLQ0DcaD5ZQmmomo1SPav3p76JmcrQ3e
         +Q4P21F36gNb0UMsgzlw5SrLjK3pKQ5/4vVZXozSNtZphF+JNKqL8TN871y+AGQmABHc
         eUQw==
X-Gm-Message-State: AJIora/HaZhMP1/Tc6taE2kbD6lxFvSvWs3qhFFrZmLeLJQxRg/9frrM
        zDuB+mmO9bApfduLbaWxFAauczieoSX6yB0N/9uq7gp72qBV3g==
X-Google-Smtp-Source: AGRyM1uwBdsw1iX/WTMY0kjNaJaOQu8Kup9yYduOZMqb/wy2ap2dJX1EZFp6BHDy8Jon7kjZa7wPqkX93Y7fdYJ0wl0=
X-Received: by 2002:a17:907:6092:b0:72f:575:722d with SMTP id
 ht18-20020a170907609200b0072f0575722dmr2045654ejc.19.1659080868955; Fri, 29
 Jul 2022 00:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
 <Ytzy9IjGXziLaVV0@kroah.com> <CANX2M5bxA5FF2Z8PFFc2p-OxkhOJQ8y=8PGF1kdLsJo+C92_gQ@mail.gmail.com>
 <Yt1MX1Z6z0y82i1I@kroah.com> <CANX2M5aX=JnKD-8kPyAN0Q64HvLoSO+3LvNvuaxkexCgeDWZHA@mail.gmail.com>
 <YuOP6Swa2E/npjWz@kroah.com>
In-Reply-To: <YuOP6Swa2E/npjWz@kroah.com>
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Fri, 29 Jul 2022 00:47:37 -0700
Message-ID: <CANX2M5YeOHGnNYhMsOLPg28_3tQXTCs=vLY2CFMXDxWR_g8P+Q@mail.gmail.com>
Subject: Re: general protection fault in sock_def_error_report
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sashal@kernel.org, edumazet@google.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 12:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> As you must have tested this, can you provide a properly backported
> version of this commit for the 5.4.y and 5.10.y trees, as it does not
> apply cleanly as-is.
>
> Please submit it to stable@vger.kernel.org and we will be glad to apply
> it.

Of course. Please allow us to take a couple of days. We will get back
with a backported patch.

-- 
Thanks and Regards,

Dipanjan
