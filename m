Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304B558000C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiGYNnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiGYNnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:43:52 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E003C14087
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 06:43:50 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id n133so3352159oib.0
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 06:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iyzaoWHc8KWQLTES8JxPtVNX05fcfDKMpVveMPJGYvo=;
        b=ENQpnru/jvUA3RaavgEgezAQoTz2Yc4xoMn8vkvS/cGyuZI1TFqeX3Vy3M3IwZjFdw
         YjVuTS73GB/RHojIFn0xSPRAhAjNHMcsPkJYpdEA76RCliIXrkoBDX9dQmYLkrGxB2Fn
         pQnxAy2x6DvKLZISgrUeD2In8wg2Ywyxp1yu4338QV2dMp0eJj7EJAUsX3RgBDtYCKsn
         yAUaXG1Cd52IbY2Kb9W+cT4e71/ZJjB56zhRrWn0DzrGu4BdXT+MrKjpGPdgNOXSbKf0
         TjnGq5mheGXahuoWepzXFPPHR0pelatTAl8GbOHHfZN4gT1PAtENJFjZ2/X/Q6ozimWB
         kyng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iyzaoWHc8KWQLTES8JxPtVNX05fcfDKMpVveMPJGYvo=;
        b=HoPejP8s8+IipzbGNFcyFSxx/bFtofkoVBkZtf7fNME0LaQUvwtkd1vSRSt8Sqgw6v
         F01LTWwF4F1ikvT5eLE1ej+8Zb74I9ys2hBKXQV6TVGm7wdpQFJfQzYEZziq9BKZ4vZW
         8S2jutXj9D/mPqLjZrAnieF8rRmW77ugVwX6aa5NVZI56H/ikJEZe/Lon+45wIK9dFjW
         5CXMNEjcdbI0fq89jvcgZ6EEAGCkxsJV+RMQPKNPw2sRr1hZGK/Z9pHfEtBgwDxg3UN+
         i+QmGdbJZjmmkE3j07KVj+h8elEctoWIT/MPLqtdmHZr+5I1MCAlJS8WqaqA24I12Igm
         Mwmg==
X-Gm-Message-State: AJIora9UorFEZVj5xaC+qI3KxPWX7/FOtGQ5jNmkJ3CzLswvGhg1QezX
        uUEc9FA3fHD134gutOFI8kXSpwXVPjcE8PFbgj3NDg==
X-Google-Smtp-Source: AGRyM1v51xKgyMMgL8ANE/+9VT2rP0/i1wDYjlc8L4QYIQzYQt4U56TRiIfdbPWLd7Q2INnCmQYplWWVz2FxkhxNlNk=
X-Received: by 2002:a05:6808:4d7:b0:33a:9437:32d with SMTP id
 a23-20020a05680804d700b0033a9437032dmr5648691oie.97.1658756630079; Mon, 25
 Jul 2022 06:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220714010021.1786616-1-mw@semihalf.com> <20220724233807.bthah6ctjadl35by@skbuf>
 <CAPv3WKdFNOPRg45TiJuAVuxM0LjEnB0qZH70J1rMenJs7eBJzw@mail.gmail.com>
 <20220725122144.bdiup756mgquae3n@skbuf> <Yt6bcnnMr7UAUFPk@shell.armlinux.org.uk>
In-Reply-To: <Yt6bcnnMr7UAUFPk@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 25 Jul 2022 15:43:39 +0200
Message-ID: <CAPv3WKfXi8eLsdnuix=gHWivfMigzaKDJMcD==1RjNOXPkwyqA@mail.gmail.com>
Subject: Re: [net-next: PATCH] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 25 lip 2022 o 15:32 Russell King (Oracle)
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Mon, Jul 25, 2022 at 03:21:44PM +0300, Vladimir Oltean wrote:
> > On Mon, Jul 25, 2022 at 02:18:45AM +0200, Marcin Wojtas wrote:
> > > I can of course apply both suggestions, however, I am wondering if I
> > > should resend them at all, as Russell's series is still being
> > > discussed. IMO it may be worth waiting whether it makes it before the
> > > merge window - if not, I can resend this patch after v5.20-rc1,
> > > targetting the net branch. What do you think?
> >
> > I just don't want a fix for a known regression to slip through the crac=
ks.
> > You can resend whenever you consider, but I believe that if you do so n=
ow
> > (today or in the following few days), you won't conflict with anybody's=
 work,
> > considering that this has been said:
> >
> > On Fri, Jul 15, 2022 at 11:57:20PM +0100, Russell King (Oracle) wrote:
> > > Well, at this point, I'm just going to give up with this kernel cycle=
.
> > > It seems impossible to get this sorted. It seems impossible to move
> > > forward with the conversion of Marvell DSA to phylink_pcs.
>
> That is correct - I'm not intending to submit it, because there's not
> enough time to sort out the mess that has been created by comments
> on the approach coming way too late.
>
> And in fact, I'm now _scared_ to submit a revision of it. I don't want
> to get into writing lots more replies that take hours to compose only
> to have responses that require yet more multi-hour sessions to reply
> to, which only then lead to the cycle repeating with no sign of an end
> to it. Something is very wrong with email as a communication tool when
> things get to that point.
>
> So, I won't be working on this. Someone else can sort the problem.
>

Thank you for the heads-up, I understand your concerns. I'll resubmit
this patch then and rebase my 'fwnode_' v3 onto it.

Best regards,
Marcin
