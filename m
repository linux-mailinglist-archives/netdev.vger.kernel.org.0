Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6697203B6C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgFVPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 11:47:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41669 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729250AbgFVPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 11:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592840846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WSF8UMj0qG7jLVHbYktfjNnfEK9wsId39MxDX59I23o=;
        b=gfkpd0ZHZrZnZlsvk27rh3NQcdJMjC3w8cfaS+B+6puKzg0gobeCNp2Xc36fkc1KabRELO
        FEzlzuSo+umkvTp9kH5OWsSvPAp57/g+3uBVzrdU5MxKXYPo7560p//5bkU0sGObokUikt
        KRqzVrs1+1bqmwG/C5lvGVWnPwya/bo=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-uKAD75PxNfaMG56QYDShwg-1; Mon, 22 Jun 2020 11:47:24 -0400
X-MC-Unique: uKAD75PxNfaMG56QYDShwg-1
Received: by mail-ot1-f69.google.com with SMTP id d2so2722709otk.9
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 08:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WSF8UMj0qG7jLVHbYktfjNnfEK9wsId39MxDX59I23o=;
        b=Ih6Dk0DJYpn+TtHiJ/LyN800wONpHpRyX4u5w7RqRMhy+uCBFX3n246G+x4Xdtl8TT
         x3UfXMvmUhx/DR+C3jTMs8shaHWCJS9nLKNhyZ9YHVAazgM3yEaOX84qxmf9RnkUfvgl
         4dLEsjKxKzxjgt1jGyJ2sR5r9DPAAXxQA9rAADJJIHt+tNlTijIba+GV55kfCUV8Iy9i
         Cr1P9cwKbAJXBgpJtZjKesUvfCTiE/FVTi0p9QOO8V0UzwZXkbtkkLTd0UN0qGQylwiD
         t719Jlx8XotImfqbNT/inaeaSQB20RVrdJapCF8sySkfaMaB7M7Pi8rS5ygCqtWzw1V6
         r/Vw==
X-Gm-Message-State: AOAM532t0Gq3PJ3wb7HsTdXQd/DQLr17LAccQLOy0867Ws5LkmZuGIP0
        FRHgrSItbhZLhbQWoM/sHRqtC9wvgHgw0oPkfxO/9BFAhm1ljEkERh/wpvB1JvkC6623s9okejH
        uYZjdTB1irSrNPZx3CjvwquqB9rEuzHf0
X-Received: by 2002:aca:3841:: with SMTP id f62mr12481359oia.73.1592840843776;
        Mon, 22 Jun 2020 08:47:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBhgHwGj1eiXfkBF+0eixO3+eR7Q3mDOxpcP81LLNNTZ6PrhQY/bBTskBdBKEEzM8q3mO6eXhRshbbN0Q2cjU=
X-Received: by 2002:aca:3841:: with SMTP id f62mr12481346oia.73.1592840843518;
 Mon, 22 Jun 2020 08:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200618090556.pepjdbnba2gqzcbe@butterfly.localdomain>
 <20200618111859.GC698688@lore-desk.lan> <20200619150132.2zrc3ojqhtbn432u@butterfly.localdomain>
 <20200621205412.GB271428@localhost.localdomain> <CAHcwAbR4govGK3RPyfKWRgFRhFanWtpJLrB_PEjcoiBDJ3_Adg@mail.gmail.com>
 <20200622145338.GB27892@localhost.localdomain>
In-Reply-To: <20200622145338.GB27892@localhost.localdomain>
From:   Oleksandr Natalenko <oleksandr@redhat.com>
Date:   Mon, 22 Jun 2020 17:47:12 +0200
Message-ID: <CAHcwAbR1W_aOaozr=m48UCWKPr1m71bk-c+kwkGd6A2GTLGF6A@mail.gmail.com>
Subject: Re: mt7612 suspend/resume issue
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 4:53 PM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
> > On Sun, Jun 21, 2020 at 10:54 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > > +static int __maybe_unused
> > > > > +mt76x2e_suspend(struct pci_dev *pdev, pm_message_t state)
> > > > > +{
> > > > > +   struct mt76_dev *mdev = pci_get_drvdata(pdev);
> > > > > +   struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
> > > > > +   int i, err;
> > >
> > > can you please double-check what is the PCI state requested during suspend?
> >
> > Do you mean ACPI S3 (this is the state the system enters)?  If not,
> > what should I check and where?
>
> yes, right. Just for debugging, can you please force the card in PCI_D0 during the
> suspend?

Do you want me to do this:

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 5543e242fb9b..e558342cce03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -119,9 +119,8 @@ mt76x2e_suspend(struct pci_dev *pdev, pm_message_t state)

     mt76x02_dma_reset(dev);

-    pci_enable_wake(pdev, pci_choose_state(pdev, state), true);
     pci_save_state(pdev);
-    err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
+    err = pci_set_power_state(pdev, PCI_D0);
     if (err)
         goto restore;

?

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Principal Software Maintenance Engineer

