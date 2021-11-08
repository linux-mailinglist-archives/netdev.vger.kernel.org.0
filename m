Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B901449E56
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240481AbhKHVmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240475AbhKHVmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 16:42:23 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3193CC061714
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 13:39:39 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id f10so18519765ilu.5
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 13:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qytYReYi2DeUI7hCFbbAa02ZiVc0pq8Kh5KE+hVc89c=;
        b=H3USv1SxyfFzlVpWLI1rBldttje8XhrfpQIes1iEdAxsPes6sc10Ckzgj/hAPEfN14
         O3PEIq4cLUYJddeH1GJH7Gms3+YalJ/8HOvft++EAHwhST4SmsEpSRehE328qv6WsEid
         qEwob/tgjU/yjJtK14zugDR0/qbglhOFALAVx6+rUyyl2KLi2M7K1r5E7cfgKZqw2WOj
         VO/NRbrORIsD9uwUmJDmXcywQS1kd/z2GWgcif6wonJfHzAfR7aYMgpyga5sW2ZXzcjE
         hxttz9Tg3e6GEe87veFodYwHxTLadS9CEokrVSFebaCet99dCJ9RrXyX17y0mGni/3iU
         IWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qytYReYi2DeUI7hCFbbAa02ZiVc0pq8Kh5KE+hVc89c=;
        b=OAijW2+VLf6OOP8s+LJRh1boSBlz1z/tlWyphvW4wwRT+6LKqXxgg1gd+tOub8BX4s
         1muu9GhIBZdQVUW4B7djFhtiG8cFXVWv/HxSLVIKo3il5boVdncGPYrEdeKGkwYY/spT
         KBs3cMvrS+cn61S16saU5SVIflKbL2U4zYGWE/iRrgiqPBCr2gSUk7V+54jadCJhXPdO
         is5eNUCz01Qn/yJ9QfbCKZeXg0buBgQRs87dzC3/p5cAUdpZgnDD2pitjMaUBbL02GWK
         zIdQNrP8nhjd5h520VIrfOnqDDZrE5l9vmQHe0PRNSNlKyPykDSoDbYbsfAfk58fNKOr
         1GGg==
X-Gm-Message-State: AOAM530ngTKRpVDKuNhhYP/GWO+iVhtZhpgozO+F5miwYNbVOA2RaACT
        3p+hpiWY69pw5V5F8ZoNELmj7aB0vZ6mWIQxkmngUQ==
X-Google-Smtp-Source: ABdhPJyohNilOe6CSCxSa6otuYhyXaBrosmVaxYXY0HfEfNsGc3l7tziImiZ4gruW3kQdM5CnQTUzIrtvT59QdcUgt4=
X-Received: by 2002:a05:6e02:1a85:: with SMTP id k5mr1669051ilv.27.1636407578605;
 Mon, 08 Nov 2021 13:39:38 -0800 (PST)
MIME-Version: 1.0
References: <20211104124927.364683-1-robert.marko@sartura.hr>
 <20211108202058.th7vjq4sjca3encz@skbuf> <CA+HBbNE_jh_h9bx9GLfMRFz_Kq=Vx1pu0dE1aK0guMoEkX1S5A@mail.gmail.com>
 <20211108211811.qukts37eufgfj4sc@skbuf>
In-Reply-To: <20211108211811.qukts37eufgfj4sc@skbuf>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Mon, 8 Nov 2021 22:39:27 +0100
Message-ID: <CA+HBbNGvg43wMNbte827wmK_fnWuweKSgA-nWW+UPGCvunUwGA@mail.gmail.com>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabor Juhos <j4g8y7@gmail.com>, John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 10:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 08, 2021 at 10:10:19PM +0100, Robert Marko wrote:
> > On Mon, Nov 8, 2021 at 9:21 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > Timed out waiting for ACK/NACK from John.
> > >
> > > On Thu, Nov 04, 2021 at 01:49:27PM +0100, Robert Marko wrote:
> > > > From: Gabor Juhos <j4g8y7@gmail.com>
> > > >
> > > > The MIB module needs to be enabled in the MODULE_EN register in
> > > > order to make it to counting. This is done in the qca8k_mib_init()
> > > > function. However instead of only changing the MIB module enable
> > > > bit, the function writes the whole register. As a side effect other
> > > > internal modules gets disabled.
> > >
> > > Please be more specific.
> > > The MODULE_EN register contains these other bits:
> > > BIT(0): MIB_EN
> > > BIT(1): ACL_EN (ACL module enable)
> > > BIT(2): L3_EN (Layer 3 offload enable)
> > > BIT(10): SPECIAL_DIP_EN (Enable special DIP (224.0.0.x or ff02::1) broadcast
> > > 0 = Use multicast DP
> > > 1 = Use broadcast DP)
> > >
> > > >
> > > > Fix up the code to only change the MIB module specific bit.
> > >
> > > Clearing which one of the above bits bothers you? The driver for the
> > > qca8k switch supports neither layer 3 offloading nor ACLs, and I don't
> > > really know what this special DIP packet/header is).
> > >
> > > Generally the assumption for OF-based drivers is that one should not
> > > rely on any configuration done by prior boot stages, so please explain
> > > what should have worked but doesn't.
> >
> > Hi,
> > I think that the commit message wasn't clear enough and that's my fault for not
> > fixing it up before sending.
>
> Yes, it is not. If things turn out to need changing, you should resend
> with an updated commit message.
>
> > MODULE_EN register has 3 more bits that aren't documented in the QCA8337
> > datasheet but only in the IPQ4019 one but they are there.
> > Those are:
> > BIT(31) S17C_INT (This one is IPQ4019 specific)
> > BIT(9) LOOKUP_ERR_RST_EN
> > BIT(10) QM_ERR_RST_EN
>
> Are you sure that BIT(10) is QM_ERR_RST_EN on IPQ4019? Because in the
> QCA8334 document I'm looking at, it is SPECIAL_DIP_EN.

Sorry, QM_ERR_RST_EN is BIT(8) and it as well as LOOKUP_ERR_RST_EN should
be exactly the same on QCA833x switches as well as IPQ4019 uses a
variant of QCA8337N.
>
> > Lookup and QM bits as well as the DIP default to 1 while the INT bit is 0.
> >
> > Clearing the QM and Lookup bits is what is bothering me, why should we clear HW
> > default bits without mentioning that they are being cleared and for what reason?
>
> To be fair, BIT(9) is marked as RESERVED and documented as being set to 1,
> so writing a zero is probably not very smart.
>
> > We aren't depending on the bootloader or whatever configuring the switch, we are
> > even invoking the HW reset before doing anything to make sure that the
> > whole networking
> > subsystem in IPQ4019 is back to HW defaults to get rid of various
> > bootloader hackery.
> >
> > Gabor found this while working on IPQ4019 support and to him and to me it looks
> > like a bug.
>
> A bug with what impact? I don't have a description of those bits that
> get unset. What do they do, what doesn't work?

LOOKUP_ERR_RST_EN:
1b1:Enableautomatic software reset by hardware due to
lookup error.

QM_ERR_RST_EN:
1b1:enableautomatic software reset by hardware due to qm
error.

So clearing these 2 disables the built-in error recovery essentially.

To me clearing the bits even if they are not breaking something now
should at least have a comment in the code that indicates that it's intentional
for some reason.
I wish John would explain the logic behind this.

Regards,
Robert
>
> > I hope this clears up things a bit.
> > Regards,
> > Robert
> > >
> > > >
> > > > Fixes: 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family")
> > > > Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
> > > > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > > > ---
> > > >  drivers/net/dsa/qca8k.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > > index a984f06f6f04..a229776924f8 100644
> > > > --- a/drivers/net/dsa/qca8k.c
> > > > +++ b/drivers/net/dsa/qca8k.c
> > > > @@ -583,7 +583,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
> > > >       if (ret)
> > > >               goto exit;
> > > >
> > > > -     ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
> > > > +     ret = qca8k_reg_set(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
> > > >
> > > >  exit:
> > > >       mutex_unlock(&priv->reg_mutex);
> > > > --
> > > > 2.33.1
> > > >
> >
> >
> >
> > --
> > Robert Marko
> > Staff Embedded Linux Engineer
> > Sartura Ltd.
> > Lendavska ulica 16a
> > 10000 Zagreb, Croatia
> > Email: robert.marko@sartura.hr
> > Web: www.sartura.hr



-- 
Robert Marko
Staff Embedded Linux Engineer
Sartura Ltd.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
