Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1E46A0BCF
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 15:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbjBWOVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 09:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234733AbjBWOVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 09:21:14 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CEF58493;
        Thu, 23 Feb 2023 06:21:12 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ee7so27560461edb.2;
        Thu, 23 Feb 2023 06:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6RpqOio9VsHGGYciTDd5PSmc5pq4f3YIFZ35Ae98Z4=;
        b=GqmGTfD25aSut4K8gSwKfZahhn8N/4BCJ2obCEU2EufIwj+v/sIwet43VFozhvG+YJ
         NxeTBe2pSEpdOrDabLaCoiXJP5jX3tYmltlt7bZA1ECIluSRN8vAYTkWbcapE/rcEWxD
         PrOeALV1pYLiM1AFCm7cqIwzBJZ1ygj4qIDUys0I85cd4ynspG9ouIOUMpc9cCpkYfrN
         RzS1s90o8+n1bda/4X1DWbb4Bk0qvsCMnQFhjBM387eMlmccpnxyYatLJrXE/bcss4CX
         DWaGwfNZ7cXmGdaCu0NWizcDcaKHj2WGEC16FijmR1cnMjZASJ5doMywgZYc++lyxyey
         oA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u6RpqOio9VsHGGYciTDd5PSmc5pq4f3YIFZ35Ae98Z4=;
        b=S/mlQs9fzUibIJOG8hbJPJOnhQH7aRWXmggNNcvu/LlLMlQamTGCombNiPiF08tKq5
         oz6DIgRklR4MbDXPsyv+Xb7brJL9UXZ7oH2FxoAuGQfOvLXkPKxJ3sRLbBsa9o9DwdC6
         mYYKlAlC1dvXk2Fj/aQSQdPUQmRgPdHxFPVNN8KwVtyOzeJ0hsjePUXo7XIZIg1P/+bi
         yHZLUwHlt18/jKwY/NN/XZI3v/vrfgMA5CUi8bEGGJsHjecve5c50fYHbyR4FNIB4+Dz
         NWwvanJd9lplGzqEu3zdNLD94++Ujj/loiVv2tXLfL3WW/VQsvD0G3YY5Vkh1AGBKvBt
         lO/Q==
X-Gm-Message-State: AO0yUKUwyeqLdjDllvFrMlTC2Us+9JFTSGIRY3rrJDsXrMLCSb6ix0VF
        dhOx55KzBFJpD0B3rOyuF0iynN8mUDKgWMfhjj+AAhNIp7NjdA==
X-Google-Smtp-Source: AK7set86lp0C5a7rO1kmF8QVOLVioaVEEYpBa+egIWJom71GosTlEge5NeNkXtMq2a81Lg6IMm4HqlGWrkYK107oxoo=
X-Received: by 2002:a05:6402:3216:b0:4ad:738b:66ff with SMTP id
 g22-20020a056402321600b004ad738b66ffmr7667860eda.2.1677162070521; Thu, 23 Feb
 2023 06:21:10 -0800 (PST)
MIME-Version: 1.0
References: <20230222031738.189025-1-marex@denx.de> <20230222210853.pilycwhhwmf7csku@skbuf>
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de> <20230222223141.ozeis33beq5wpkfy@skbuf>
 <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de> <20230222232112.v7gokdmr34ii2lgt@skbuf>
 <35a4df8a-7178-20de-f433-e2c01e5eaaf7@denx.de> <20230223002224.k5odesikjebctouc@skbuf>
 <2a7696ff-eceb-2feb-0cce-d9910b5ad81f@denx.de>
In-Reply-To: <2a7696ff-eceb-2feb-0cce-d9910b5ad81f@denx.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 23 Feb 2023 16:20:59 +0200
Message-ID: <CA+h21hpQwhExOO3cbU8RvYo6ENurf7_o8wh+0yxUrgyD2_2jEA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function for KSZ87xx
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 06:17:28AM +0100, Marek Vasut wrote:
> No, it does not say it fixes gigabit on KSZ87xx, the commit message says =
it
> fixes gigabit accessor functions, but what it really fixes (and what is t=
he
> bulk of the commit message) is the incorrectly double-remapped register 0=
x56
> used in those gigabit accessor functions and which is also used in the
> ksz_[gs]et_xmii function.
>=C2=B7
> > but the gigabit bug which *was pointed out to you by others* is still
> > there. Your patch fixes something else, but *it says* it fixes a gigabi=
t
> > bug. What I want is for you to describe exactly what it fixes, or if yo=
u
> > just don't know, say you noticed the bug during code review and you
> > don't know what is its real life impact (considering pin strapping).
>=C2=B7
> I believe I wrote what the problem is in my previous email, the incorrect=
ly
> double-remapped XMII_1 register . The register wasn't updated in my case =
in
> ksz_set_xmii() with RGMII delays.
>=C2=B7
> Why I picked the is_1Gbit bit for the commit message, probably was tired
> after lengthy debugging session of this problem.

All that is requested from you is to stop being overly defensive about
the commit message that you wrote, and to write another one, which is
more representative of the real life impact that your change has, in
light of the facts that were pointed out during review. Nobody is out to
get you. Open source projects are a collaborative effort, and your part
is to accept that your work can be improved, when given clear and
specific indications from reviewers who have looked at the same problem
as you from an angle independent from yours. If you're so sure that you
cannot improve your work by yourself and ask for this passive-aggressive
hand holding from reviewers, I don't know why you don't just set up your
git trees where there's no review, and that's that.

I don't know why I'm wasting my time to point this out to you, you have
more experience with open source projects than I do, so you should know
better, yet your attitude is completely unproductive.

To me, this topic is closed. You have accused me of having an improper
tone towards you, but you have not explained what was wrong with it,
even when pressed to. I am wasting my time.
