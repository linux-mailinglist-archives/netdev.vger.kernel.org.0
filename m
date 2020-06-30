Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC2720FFA5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgF3V4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgF3V4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:56:01 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1904EC03E97A
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 14:56:01 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id t9so12331491lfl.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 14:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tmOZ0XuG4g2eZl+4ZC4AL+xOIxaD6EMfVCRTLIIYYGE=;
        b=Vyf6XWz5jRcDww52yc4d4Oq+roFuuZKNq/BHB+ZWpxojfUqNPllihDN3f5lJ8Y/T9Z
         mwZ+lFjbe/hrfezCl+gc8clJtr574NRs/xP5o/wtJ8y+u91ep3VP16u8K22A7ej7qLdC
         ehvTBg23bF+6odhA/tdesc/Y3povKcjIUODms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tmOZ0XuG4g2eZl+4ZC4AL+xOIxaD6EMfVCRTLIIYYGE=;
        b=YSDOVAqq8IbwhBNGoA0HRthyjEvMlwnukuTWnovd/jOw83ffH6uR/F0u/V5f4X6Rxz
         wDbrFiOQstJA1w6GbWjnNQoY0IuqUgs5rlLY8OnziifcHaRgx4WpoFRCOHyaFIhNzd0r
         Wqymp/RFc+LCIPOg2HopMrleUjoiycZpfH/+chQUVQV8ViD/xGcKD//xAkgtb2UnF47I
         5TMrxLjCNl9kH5/m35C2zeBIU/WhTNk1T1NMXUvzmTbzb2zj+31+0KsM5OYFDi/lLVwO
         nDmRZK1oFIsAuOPbYaKal7g1TLweF6cW6tkAcThfvwdHONgOkHXSTKhaE5r42tP3a8AK
         maUQ==
X-Gm-Message-State: AOAM531+JXXgujVYcNnqI1Hq0cuxS3TeMSWBGTSV5vhSQfz/gsQRNWjM
        8lBSWgcl8PLJXKVko4EEBb7DVilFh3XuJm6doioDbA==
X-Google-Smtp-Source: ABdhPJwR94n+7xH83mHqidczu9CR0DjnMKdnF/jaaPKl94g8fG7h0fWVOeEftBCONCQWeAKI/tJPnTqCAI/9SJ7Gstg=
X-Received: by 2002:a19:8407:: with SMTP id g7mr13225699lfd.61.1593554159514;
 Tue, 30 Jun 2020 14:55:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200629201441.v1.1.I162e3c6c4f4d963250c37733c3428329110c5989@changeid>
 <968D6753-8ACB-4298-91A4-F2C9438EAC06@holtmann.org>
In-Reply-To: <968D6753-8ACB-4298-91A4-F2C9438EAC06@holtmann.org>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Tue, 30 Jun 2020 14:55:48 -0700
Message-ID: <CABmPvSFq36OA-dxXxjhhocZjoJ1ZMZXZ4TULRYyTxcpksuXA7g@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Pavel Machek <pavel@ucw.cz>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

hci_unregister_dev() is invoked when the controller is intended to be
removed by btusb driver. In other words, there should not be any
activity on hdev's workqueue, so the destruction of the workqueue
should be the first thing to do to prevent the clear helpers from
issuing any work. So my suggestion is to revert the patch re-arranging
the workqueue and apply this instead.
I should have uploaded this earlier, but I encountered some troubles
while verifying the changes. Sorry for the inconvenience.

Regards,
Miao

On Mon, Jun 29, 2020 at 11:51 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Miao-chen,
>
> > This fixes the kernel oops by removing unnecessary background scan
> > update from hci_adv_monitors_clear() which shouldn't invoke any work
> > queue.
> >
> > The following test was performed.
> > - Run "rmmod btusb" and verify that no kernel oops is triggered.
> >
> > Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > ---
> >
> > net/bluetooth/hci_core.c | 2 --
> > 1 file changed, 2 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 5577cf9e2c7cd..77615161c7d72 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -3005,8 +3005,6 @@ void hci_adv_monitors_clear(struct hci_dev *hdev)
> >               hci_free_adv_monitor(monitor);
> >
> >       idr_destroy(&hdev->adv_monitors_idr);
> > -
> > -     hci_update_background_scan(hdev);
> > }
>
> I am happy to apply this as well, but I also applied another patch re-arranging the workqueue destroy handling. Can you check which prefer or if we should include both patches.
>
> Regards
>
> Marcel
>
