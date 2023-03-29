Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B896CF6FB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 01:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjC2XYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 19:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjC2XYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 19:24:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEC91BCD;
        Wed, 29 Mar 2023 16:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 319E5B81F86;
        Wed, 29 Mar 2023 23:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACC4C433D2;
        Wed, 29 Mar 2023 23:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680132265;
        bh=Rp1Tc/zBg/eGy+DYh8BKIyM5vVkV/sZOYZqqAi2orag=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lzePg4GAAmd7rnfVIQsJ71F1Oo+OPfUCQCfdN1QPRAFnLEBKIwXR6P2ydv9GV7L+V
         pVkV3IY3bkpztEbsEdtuK3S7a1D6Q0gL3yuMw2DlhkVRHQKhmzTXWVHFkgFikDS87Y
         6Vcf1unmdqS84ZBZrC8iG/HOA94Y3REubTxmufyMmm/ADEv0KP7S9mgQWnyzX/2HkE
         6JO87bo96CVv4xwGqMu7y0UAVJIdI147N3CmsXfNrVuCzeEKwQpR314KOFXyWq2gWP
         Hebt20GLDewDRvXHmKaA2+kObwsvTVu6KrKFVxZWtAh6PVdKr8gaWsFjGJ0R4ybHu3
         6fGlbubmp+v8Q==
Received: by mail-lf1-f49.google.com with SMTP id br6so22256061lfb.11;
        Wed, 29 Mar 2023 16:24:24 -0700 (PDT)
X-Gm-Message-State: AAQBX9dDpfeYWChFfsz5DJoegAmR+vlfrt0h64oOM8Um0w/IrSZGtDe8
        TdIKoln7TrinfoZqzjtQIVeu2GQUkFa0IFCQyZY=
X-Google-Smtp-Source: AKy350aYdH7tROyF3XOm8uuzzLzjWbjSOZORccxAOMS4pMfzH65Plbch5/pQVVJN8qlG/l83JvOJ+ZYT6rGiJDSn0Yo=
X-Received: by 2002:ac2:5448:0:b0:4e9:bcf5:a0b6 with SMTP id
 d8-20020ac25448000000b004e9bcf5a0b6mr6002093lfn.11.1680132262943; Wed, 29 Mar
 2023 16:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230329195758.7384-1-mario.limonciello@amd.com>
In-Reply-To: <20230329195758.7384-1-mario.limonciello@amd.com>
From:   Sean Wang <sean.wang@kernel.org>
Date:   Wed, 29 Mar 2023 16:24:10 -0700
X-Gmail-Original-Message-ID: <CAGp9LzrkX4uFAtLwvjH+uUuRgT_YDg3eE8SqgWEXOFmw5r=aMQ@mail.gmail.com>
Message-ID: <CAGp9LzrkX4uFAtLwvjH+uUuRgT_YDg3eE8SqgWEXOFmw5r=aMQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Anson Tsao <anson.tsao@amd.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Mar 29, 2023 at 1:18=E2=80=AFPM Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
> When the BIOS has been configured for Fast Boot, systems with mt7921e
> have non-functional wifi.  Turning on Fast boot caused both bus master
> enable and memory space enable bits in PCI_COMMAND not to get configured.
>
> The mt7921 driver already sets bus master enable, but explicitly check
> and set memory access enable as well to fix this problem.
>
> Tested-by: Anson Tsao <anson.tsao@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> Original patch was submitted ~3 weeks ago with no comments.
> Link: https://lore.kernel.org/all/20230310170002.200-1-mario.limonciello@=
amd.com/
> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7921/pci.c
> index cb72ded37256..aa1a427b16c2 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> @@ -263,6 +263,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
>         struct mt76_dev *mdev;
>         u8 features;
>         int ret;
> +       u16 cmd;
>
>         ret =3D pcim_enable_device(pdev);
>         if (ret)
> @@ -272,6 +273,11 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
>         if (ret)
>                 return ret;
>
> +       pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> +       if (!(cmd & PCI_COMMAND_MEMORY)) {
> +               cmd |=3D PCI_COMMAND_MEMORY;
> +               pci_write_config_word(pdev, PCI_COMMAND, cmd);
> +       }

If PCI_COMMAND_MEMORY is required in any circumstance, then we don't
need to add a conditional check and OR it with PCI_COMMAND_MEMORY.
Also, I will try the patch on another Intel machine to see if it worked.

     Sean

>         pci_set_master(pdev);
>
>         ret =3D pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
> --
> 2.34.1
>
