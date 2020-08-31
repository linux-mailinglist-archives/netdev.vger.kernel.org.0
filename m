Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09043257F11
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgHaQwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbgHaQwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:52:08 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F623C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 09:52:08 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id j188so3598153vsd.2
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 09:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v2wssN0DfVl0Q5ulsK8rehD0qys9A1UTSyxawRAlJec=;
        b=PKX3NGBdootImldgizkUZ9JNq2aRTpLy+LDPXgaGjN67aJZcX5pKbxjF6UCyW/HP/1
         1xIphJEPk/1dlpzCnvwdr8psoRTZ4SQXSMEmtmvUrQlJjlhEMVNcqa79KrQe88WEXmBS
         Tu8vgti347fq8k6r++gj5T7TkTnDDswBF6FeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v2wssN0DfVl0Q5ulsK8rehD0qys9A1UTSyxawRAlJec=;
        b=D7zcPXcZLgCOa9XDWhlN/4PLpJjQorCEzFIFnvjvroa4yD4hLxDUaWBUB+ObsTNsQh
         HaUsy3q4LSZAolJkq6wrudFBHqoPFtpEqk90aF6MDEpOws6P1RNZg66U/kup1hr3ocu1
         cexPRkTcajm8pSMGdYv+/lShd1BNKJRQ28iCsd2lz86i679XqQhSdYgEzDNNIP5A98PN
         RJsUQbF80yl/CvckjQBONpHoXixnxSaEXdRlpLo3Gk00uCzznJn9C8HuXlcLMiayiiTy
         xsUf3iaCFgi8c8gT0p5TYteTeEnGTcB3V5Eg+cxEenefkwtsMHu/cvPs+V/ok1FDC2GZ
         xRWA==
X-Gm-Message-State: AOAM531wTuc5dASDqIwMU8v8IT52ExvuYou04Tj54yxYopd9nyjRnT3n
        DxCShk196CX8ZcZg1dzss0qWE8YzpLAOojkDRazjFw==
X-Google-Smtp-Source: ABdhPJzRl4IzM+/5e+TD8Pd7j+A6SmKTwYoGY5YNvdrKb+tJbT1J0kMH3uJc5Yi9i1lQvDnOm0uTXj7cCiaXUmoq3bo=
X-Received: by 2002:a05:6102:1045:: with SMTP id h5mr2083568vsq.42.1598892727414;
 Mon, 31 Aug 2020 09:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200826154719.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
 <A69701BE-FBB3-4053-8187-618C0BD4B380@holtmann.org>
In-Reply-To: <A69701BE-FBB3-4053-8187-618C0BD4B380@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 31 Aug 2020 09:51:56 -0700
Message-ID: <CANFp7mXY7--Mziduq69gUj5cgCiZCZ-47JOpBNL6H0bLpN2bbQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Clear suspend tasks on unregister
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 sent with fix.

On Mon, Aug 31, 2020 at 8:49 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > While unregistering, make sure to clear the suspend tasks before
> > cancelling the work. If the unregister is called during resume from
> > suspend, this will unnecessarily add 2s to the resume time otherwise.
> >
> > Fixes: 4e8c36c3b0d73d (Bluetooth: Fix suspend notifier race)
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> > This was discovered with RT8822CE using the btusb driver. This chipset
> > will reset on resume during system suspend and was unnecessarily adding
> > 2s to every resume. Since we're unregistering anyway, there's no harm in
> > just clearing the pending events.
> >
> > net/bluetooth/hci_core.c | 11 +++++++++++
> > 1 file changed, 11 insertions(+)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 68bfe57b66250f..ed4cb3479433c0 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -3442,6 +3442,16 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
> >       }
> > }
> >
> > +static void hci_suspend_clear_tasks(struct hci_dev *hdev)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < __SUSPEND_NUM_TASKS; ++i)
> > +             clear_bit(i, hdev->suspend_tasks);
>
> I prefer i++ instead of ++i.
>
> Regards
>
> Marcel
>
