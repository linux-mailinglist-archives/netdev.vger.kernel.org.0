Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5532C69F509
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjBVNBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 08:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjBVNBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 08:01:00 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7D53B0FC
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 05:00:59 -0800 (PST)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 37C9D3F4B9
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677070856;
        bh=C4QlkJoMBe7Zb07BzaU2hfX0+/7r6YQ7RN1cp6tdTkI=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=ckarSCzCNF6O5uw/9WDqpdu12/b9M3OYnu6ysN+axEh9Tt9GKS6OP1ynRhCwZcsPZ
         Dv3B3o/2us/GsrBNDjhV5JCskr9NfFRL65qrN9S2WrZT/PivIa6COOq2DBPm/2opze
         /31SQprPaf4Uz2ciriaVdhVm00slDLF7mHHeDd/UadB/e3BQBC01oQ2Yiu4Pzq8wH8
         7CjZ4ToVX6E9S03Y0XrwSDlx+20nLuJKq0OseyPt1W8B+MpEKlgeCocw3e0I4f6DZt
         /xg6K4O1OyVcFHnAIuQjdPtOnT79kqjuxFjdff9KZY1m7E/x7KvQ93hwp0Is9e+OON
         tKDzSeHNNgthw==
Received: by mail-pj1-f69.google.com with SMTP id cx12-20020a17090afd8c00b002366e47e91bso3526824pjb.7
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 05:00:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C4QlkJoMBe7Zb07BzaU2hfX0+/7r6YQ7RN1cp6tdTkI=;
        b=xAkeIUEFqngrJhRKK8dL/wgrc6fhIYzYnwUGOSGNQBZFPNuzblfU/Ob+N5Rz7WbXgg
         BU0Icrs64Pna17O8rZfKe7qO7QuxKB09CzGQaT18BGqoiQ007pkYETCH+8WcKVLNOX+p
         OEd2l36kgH75UeSFQ/L6bJdUC3lpozCd5mSVUuZZgXswOCOnlJhPw5wkSVHhc8DN6FQB
         eMmATlePhYiQwDDzpZNNIc9rPpIbRHsenVbV5TAuGM8Ppr/ueonw439qduzZFYjD22PA
         KCjWJ7jkMTN2ScAm5YrcdmxNuleQGztLLMWrBy6JUz/9gr3bkWrAPrsSEdDJEPszGa4n
         2vkg==
X-Gm-Message-State: AO0yUKVQ538KWFhaLmJBXksjwPovfykn2VYRmpSPVimLcRkIkH7llFeW
        LFELjyhYniMZ5Q0RkDnrhfl9SZcTp3Laq1Lhcs38UyMSen7jU3dkasaF52xBur6tFXIc3s3D9c+
        /kZK/OXLbYeBBv+bWvCqDQf361FGCYuJkv0h3j5O6561GfDwfcA==
X-Received: by 2002:a17:90b:1f87:b0:237:1892:2548 with SMTP id so7-20020a17090b1f8700b0023718922548mr1309664pjb.44.1677070852632;
        Wed, 22 Feb 2023 05:00:52 -0800 (PST)
X-Google-Smtp-Source: AK7set+Hcu3PpBDVIEJrAMyn16xRp5IGRD9MfaoCbBE14JFRfyGRE20r++e6YnhsvorwYnP3mjsyR4szgSwPyCZs8Pg=
X-Received: by 2002:a17:90b:1f87:b0:237:1892:2548 with SMTP id
 so7-20020a17090b1f8700b0023718922548mr1309649pjb.44.1677070852230; Wed, 22
 Feb 2023 05:00:52 -0800 (PST)
MIME-Version: 1.0
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
 <20230221023849.1906728-2-kai.heng.feng@canonical.com> <86136114-a451-c485-ade2-cfa79d5124e1@gmail.com>
In-Reply-To: <86136114-a451-c485-ade2-cfa79d5124e1@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 22 Feb 2023 21:00:41 +0800
Message-ID: <CAAd53p4L3eUWH183RJAfcQ1vDrwuMJ4pL--w9OgAJzg0ghnpwA@mail.gmail.com>
Subject: Re: [PATCH v8 RESEND 1/6] r8169: Disable ASPM L1.1 on 8168h
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, bhelgaas@google.com, koba.ko@canonical.com,
        acelan.kao@canonical.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, vidyas@nvidia.com,
        rafael.j.wysocki@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 7:09 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 21.02.2023 03:38, Kai-Heng Feng wrote:
> > ASPM L1/L1.1 gets enabled based on [0], but ASPM L1.1 was actually
> > disabled too [1].
> >
> > So also disable L1.1 for better compatibility.
> >
> > [0] https://bugs.launchpad.net/bugs/1942830
> > [1] https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/commit/?id=c9b3736de48fd419d6699045d59a0dd1041da014
> >
> These references are about problems with L1.2 (which is disabled
> per default in mainline). They don't allow any statement about whether
> L1.1 is problematic too (and under which circumstances).
> At least on my system with RTL8168h there's no problem with L1.1
> when running iperf.

There are some systems have performance issue with L1.1 too.
But since the series will disable chip-side ASPM during NAPI poll,
maybe we can keep both L1.1 and L1.2 enabled?

Kai-Heng

>
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v8:
> >  - New patch.
> >
> >  drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index 45147a1016bec..1c949822661ae 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -5224,13 +5224,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >
> >       /* Disable ASPM L1 as that cause random device stop working
> >        * problems as well as full system hangs for some PCIe devices users.
> > -      * Chips from RTL8168h partially have issues with L1.2, but seem
> > -      * to work fine with L1 and L1.1.
> > +      * Chips from RTL8168h partially have issues with L1.1 and L1.2, but
> > +      * seem to work fine with L1.
> >        */
> >       if (rtl_aspm_is_safe(tp))
> >               rc = 0;
> >       else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
> > -             rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
> > +             rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_1 | PCIE_LINK_STATE_L1_2);
> >       else
> >               rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> >       tp->aspm_manageable = !rc;
>
