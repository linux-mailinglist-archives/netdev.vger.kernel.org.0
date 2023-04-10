Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548136DC239
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 02:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDJA54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 20:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJA5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 20:57:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F20D3599;
        Sun,  9 Apr 2023 17:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFE560C56;
        Mon, 10 Apr 2023 00:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D74CC433A4;
        Mon, 10 Apr 2023 00:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681088273;
        bh=x1wkYPtNmo6RtB5ZfBrhqXue4vXZpCgJBIU2FPBOGYY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YXcgx0ToKlhlQjO2KjWGr0ePjqgA0S+IpJjENVF3RtI8T5uQbzGCHJlbi6jSIhiNJ
         7Fsk3TSENFAVOFKUQoQeOo5CKa2nEoBeZ//YYgXnLkrYcAT/0J2cXxdX9KGmDZtcfS
         Hb5It45U+w0qXjK4sH7QCO2Q5PamKIrdcI+h4j+k6rtfnui3M1g+bbDsmJIUXOMicb
         oAT2fVexHb+dbT7Qa5c+HloXV6SrINa+LT7FrOfZVlU9NnRbSCWfAobU0igERkOys0
         brl+QSByO3zmp7m8VnMI4PMkMzX7JYSZ55NPC1BQGsOsLnt0XdIKZ1fvhqES0iHyxR
         wXFJZCs6+JAVQ==
Received: by mail-lf1-f43.google.com with SMTP id z8so6542555lfb.12;
        Sun, 09 Apr 2023 17:57:53 -0700 (PDT)
X-Gm-Message-State: AAQBX9cao9KzXcnVbpZF5Hf2AaD8BObMa0ds256erFHePSR0yeB2tX/c
        6dDq/lOBWAynUDcCTcYdRGbnvsuuWrGFcSAkr7I=
X-Google-Smtp-Source: AKy350bGuMItwf91ELSkpTyF9NTc1nsh5zMn14Rcfih66uAv/CLQBUeJc/PXY4C+URSH0CRWRT6ujIgC3V9ghu6/E/I=
X-Received: by 2002:a05:6512:25e:b0:4eb:540f:2bf6 with SMTP id
 b30-20020a056512025e00b004eb540f2bf6mr2517888lfo.11.1681088271396; Sun, 09
 Apr 2023 17:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230329195758.7384-1-mario.limonciello@amd.com>
 <CAGp9LzrkX4uFAtLwvjH+uUuRgT_YDg3eE8SqgWEXOFmw5r=aMQ@mail.gmail.com>
 <cdf612bf-96f6-9b4e-a32c-50007892083c@amd.com> <MN0PR12MB61012EEFC07D4FAE534C1323E2929@MN0PR12MB6101.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB61012EEFC07D4FAE534C1323E2929@MN0PR12MB6101.namprd12.prod.outlook.com>
From:   Sean Wang <sean.wang@kernel.org>
Date:   Sun, 9 Apr 2023 17:57:38 -0700
X-Gmail-Original-Message-ID: <CAGp9LzqWna+BU_F-=zxCmo62616Jjn2pXQG-Zk43Ax13zRjF0Q@mail.gmail.com>
Message-ID: <CAGp9LzqWna+BU_F-=zxCmo62616Jjn2pXQG-Zk43Ax13zRjF0Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] wifi: mt76: mt7921e: Set memory space enable in
 PCI_COMMAND if unset
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "nbd@nbd.name" <nbd@nbd.name>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "ryder.lee@mediatek.com" <ryder.lee@mediatek.com>,
        "shayne.chen@mediatek.com" <shayne.chen@mediatek.com>,
        "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Tsao, Anson" <anson.tsao@amd.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 6:42=E2=80=AFAM Limonciello, Mario
<Mario.Limonciello@amd.com> wrote:
>
> [Public]
>
> > On 3/29/2023 18:24, Sean Wang wrote:
> > > Hi,
> > >
> > > On Wed, Mar 29, 2023 at 1:18=E2=80=AFPM Mario Limonciello
> > > <mario.limonciello@amd.com> wrote:
> > >>
> > >> When the BIOS has been configured for Fast Boot, systems with mt7921=
e
> > >> have non-functional wifi.  Turning on Fast boot caused both bus mast=
er
> > >> enable and memory space enable bits in PCI_COMMAND not to get
> > configured.
> > >>
> > >> The mt7921 driver already sets bus master enable, but explicitly che=
ck
> > >> and set memory access enable as well to fix this problem.
> > >>
> > >> Tested-by: Anson Tsao <anson.tsao@amd.com>
> > >> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > >> ---
> > >> Original patch was submitted ~3 weeks ago with no comments.
> > >> Link: https://lore.kernel.org/all/20230310170002.200-1-
> > mario.limonciello@amd.com/
> > >> ---
> > >>   drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
> > >>   1 file changed, 6 insertions(+)
> > >>
> > >> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> > b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> > >> index cb72ded37256..aa1a427b16c2 100644
> > >> --- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> > >> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
> > >> @@ -263,6 +263,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev=
,
> > >>          struct mt76_dev *mdev;
> > >>          u8 features;
> > >>          int ret;
> > >> +       u16 cmd;
> > >>
> > >>          ret =3D pcim_enable_device(pdev);
> > >>          if (ret)
> > >> @@ -272,6 +273,11 @@ static int mt7921_pci_probe(struct pci_dev
> > *pdev,
> > >>          if (ret)
> > >>                  return ret;
> > >>
> > >> +       pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> > >> +       if (!(cmd & PCI_COMMAND_MEMORY)) {
> > >> +               cmd |=3D PCI_COMMAND_MEMORY;
> > >> +               pci_write_config_word(pdev, PCI_COMMAND, cmd);
> > >> +       }
> > >
> > > If PCI_COMMAND_MEMORY is required in any circumstance, then we
> > don't
> > > need to add a conditional check and OR it with PCI_COMMAND_MEMORY.
> >
> > Generally it seemed advantageous to avoid an extra PCI write if it's no=
t
> > needed.  For example that's how bus mastering works too (see
> > __pci_set_master).
> >
> >
> > > Also, I will try the patch on another Intel machine to see if it work=
ed.
> >
> > Thanks.
>
> Did you get a chance to try this on an Intel system?

Hi,

Sorry for the late response. We have tested the related Intel platform
and it worked fine. You can add the tag from me like
Acked-by: Sean Wang <sean.wang@mediatek.com>


>
> >
> > >
> > >       Sean
> > >
> > >>          pci_set_master(pdev);
> > >>
> > >>          ret =3D pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES=
);
> > >> --
> > >> 2.34.1
> > >>
