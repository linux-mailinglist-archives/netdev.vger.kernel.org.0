Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909BF2039E7
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgFVOtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:49:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729146AbgFVOtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592837347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=naZjlXqAUuz9QFqq0p2KUyyeqf2h2ajScjOSS4MNLek=;
        b=cKDecmSqrH2L8eLlcuAfey66vg0RM6Y4ppst5TXIAv1xl2m4W62Sv+mmjHa9MBtNiDqQdg
        uI6UauVOhCIyfzqSK+a+0bKUVJM6RFa8bwli686DNPdwbJr1k4x0g9GfyZ7ox9fL4Y6sY9
        9wU76T5VNYmIyTB5pQCl/+Ips0o2/DU=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-IPFy0g6rMNipDDYpEJGinA-1; Mon, 22 Jun 2020 10:49:05 -0400
X-MC-Unique: IPFy0g6rMNipDDYpEJGinA-1
Received: by mail-oi1-f198.google.com with SMTP id w26so8153286oic.4
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 07:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=naZjlXqAUuz9QFqq0p2KUyyeqf2h2ajScjOSS4MNLek=;
        b=ILAQYb+7sQVIUoER3baobEuHGBhYNjP32icUtvc7rfNcR8hs1QmiZerNH/jt0ZVSUc
         wKFshblZELcwS+jWDOmW6o/SZnd11gEh7yccAX8uJSEiVamd/ABm0NJVXY4Eu1RY/Kw+
         Ji/UwBBMLktIuJ6pz3NUJHAOd9LPSVAWB4OpVDfbhdwq8uIGILMsYgdDqdzLuwUJru2K
         45VzWT+LvQS8UUlCSnZ1BGbwHrfKEGfZHU5NDus/Gr8VkdsKq3rCVow3eZ/VEpZWIncr
         nc8NONB1f8xlS2fR7zCBMVhs/cvnWszCUdpmE3XbXwHGuLTcb9aq2lXYVENkHsYDe4Oh
         O1OA==
X-Gm-Message-State: AOAM532ckO5rENLJ/Zyp9PxDLkup6wYr5Yd4iKG9bZBCsJKXWlEDBex5
        c+uuf+UYtUL7n3uquf92+bGpiqeNdbFiW4/Ko4TXJgGdNtXf5Lo5pRur5EDnn3QOeayjY60Blp7
        NOEiT3fji92eh64xhdqpjf1J9AmsLcpyi
X-Received: by 2002:a9d:39b6:: with SMTP id y51mr12985159otb.175.1592837344595;
        Mon, 22 Jun 2020 07:49:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6oTCLYY5ewTtAXQxagLn65iRqRaS/ifJ30YW9dcHRfGmRzdPnCFDN3sUXNC+/uj6SNSIpnbpPZl7QUh97fIk=
X-Received: by 2002:a9d:39b6:: with SMTP id y51mr12985144otb.175.1592837344375;
 Mon, 22 Jun 2020 07:49:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200618090556.pepjdbnba2gqzcbe@butterfly.localdomain>
 <20200618111859.GC698688@lore-desk.lan> <20200619150132.2zrc3ojqhtbn432u@butterfly.localdomain>
 <20200621205412.GB271428@localhost.localdomain>
In-Reply-To: <20200621205412.GB271428@localhost.localdomain>
From:   Oleksandr Natalenko <oleksandr@redhat.com>
Date:   Mon, 22 Jun 2020 16:48:53 +0200
Message-ID: <CAHcwAbR4govGK3RPyfKWRgFRhFanWtpJLrB_PEjcoiBDJ3_Adg@mail.gmail.com>
Subject: Re: mt7612 suspend/resume issue
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
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

Hello, Lorenzo.

On Sun, Jun 21, 2020 at 10:54 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > +static int __maybe_unused
> > > +mt76x2e_suspend(struct pci_dev *pdev, pm_message_t state)
> > > +{
> > > +   struct mt76_dev *mdev = pci_get_drvdata(pdev);
> > > +   struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
> > > +   int i, err;
>
> can you please double-check what is the PCI state requested during suspend?

Do you mean ACPI S3 (this is the state the system enters)?  If not,
what should I check and where?

Thanks.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Principal Software Maintenance Engineer

