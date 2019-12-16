Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E6E120825
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfLPOH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:07:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54814 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727965AbfLPOH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q6xfs5d0sUaAOLG2FMbBQ5nuZn6Q3LreuQaI/PtssqI=;
        b=e0OuEop80kxYoXkA1ZgEe53Q1WZeJtm/hZTRddbwARozJcPxKWVk7ujyk+jv3sOROLABEE
        +7aVwxcQFd2xTiHhLIohlVh0GkPOJhwCZEkjOfTn3wC/WWeHgCgjx9hwXE2wmsL0zExOIZ
        wiNMUHqvA5EmeM6IxOEB9TVyaMj7IQo=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-DV4_6a02NjWb3z8LHo94hQ-1; Mon, 16 Dec 2019 09:07:27 -0500
X-MC-Unique: DV4_6a02NjWb3z8LHo94hQ-1
Received: by mail-ua1-f71.google.com with SMTP id r17so1580081uak.14
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 06:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6xfs5d0sUaAOLG2FMbBQ5nuZn6Q3LreuQaI/PtssqI=;
        b=QLe6BzgBNGsLYWHD6t4d+ihGOquLrrwLVRSShqSxBopknGDuD8mnRX7B+5DnA/VZQ7
         cyqPM5SJPDAQq5i2Etuz7xy8ShjHDvsnoZM1AtxJR+Z4q0lQNWoKVhf4OG3+D1cV5pKK
         TapWT+CMEWT2Ti8aeIZelhG2jDlNBoW1q+JvuZDuJPGm/YNnrdBFq/tFdRqkxLNuaQHc
         gSw/iSoSk9j/kVfps913Vl3ADiDrqbnk4BHkcm6bJ/I5/koha5LlxOtMl0NdBSB/yfin
         O0wbSV3BQDUnjM3GEgv5ryo1nta4qYqRdeyH3r7U5mwVIzQ2hFGUIBuT65Lci4hsnHzm
         n93Q==
X-Gm-Message-State: APjAAAUjo/BePogm6mOpDUk6UlCHxn00j648YNrA6c8GmthVQ+q++IFC
        zG1NXi2/S5EnHxqg/+G2pn6VSFyDckMWoDBicRTJbMAI/qUmIUo04mMouGy3yBPyVkUsg8DHsSx
        a+4DPRZuznn/CcMamccS1xv5ZaDrLH7vV
X-Received: by 2002:a67:ed07:: with SMTP id l7mr19491114vsp.47.1576505246093;
        Mon, 16 Dec 2019 06:07:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOxFOghhoHFPJUjds+UqzmW8x3ScdL8Im/pHWCndVhIiV1TYcaCDkHYzHk5G8xIdmY7CXM/tshOac1rzzFRs0=
X-Received: by 2002:a67:ed07:: with SMTP id l7mr19491076vsp.47.1576505245636;
 Mon, 16 Dec 2019 06:07:25 -0800 (PST)
MIME-Version: 1.0
References: <20191211162107.4326-1-ptalbert@redhat.com> <20191215.124119.1034274845955800225.davem@davemloft.net>
In-Reply-To: <20191215.124119.1034274845955800225.davem@davemloft.net>
From:   Patrick Talbert <ptalbert@redhat.com>
Date:   Mon, 16 Dec 2019 15:07:14 +0100
Message-ID: <CAPRrrxVJjKJ0eE_Xd78DNfyixjr=iTSfVQ1FsAssek-+XMWKUQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Use rx_nohandler for unhandled packets
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 9:41 PM David Miller <davem@davemloft.net> wrote:
>
> From: Patrick Talbert <ptalbert@redhat.com>
> Date: Wed, 11 Dec 2019 17:21:07 +0100
>
> > Since caf586e5f23c ("net: add a core netdev->rx_dropped counter") incoming
> > packets which do not have a handler cause a counter named rx_dropped to be
> > incremented. This can lead to confusion as some see a non-zero "drop"
> > counter as cause for concern.
> >
> > To avoid any confusion, instead use the existing rx_nohandler counter. Its
> > name more closely aligns with the activity being tracked here.
> >
> > Signed-off-by: Patrick Talbert <ptalbert@redhat.com>
>
> I disagree with this change.

Thank you for the review and consideration.

>
> When deliver_exact is false we try to deliver the packet to an appropriate
> ptype handler.  And we end up in the counter bump if no ptype handler
> exists.

If we get to this point in __netif_receive_skb_core() it means the
packet was not passed on to any handler or socket but it is not
because anything went wrong. It simply means no one cared about it. I
suppose a counter named rx_nothandled or rx_ignored would fit better
but for now, the existing rx_nohandler counter much more closely
describes what has happened. Lumping these discards into rx_dropped
along with buffer errors and that ilk is misleading at best.

>
> Therefore, the two counters allow to distinguish two very different
> situations and providing that distinction is quite valuable.

As is, we have packets which are not handled due to no fault and
packets which were discarded due to some fault lumped into rx_dropped.
I think it is much more useful to clarify that distinction by
utilizing separate counters versus worrying that someone might miss
the distinction between an inactive slave drop and any other drop.

>
> I think this distinction was very much intentional.  Having people
> understand that rx_dropped can have this meaning is merely a matter of
> education.

From what I recall, the patch to add rx_nohandler was a reaction to
caf586e5f23c ("net: add a core netdev->rx_dropped counter") being
backported to RHEL7 and customers suddenly seeing rx_dopped piling up
on inactive bond slaves. I wish it had been more broad to trap all the
unhandled traffic, not just inactive slave traffic, but it wasn't.

I appreciate netdev rx_dropped by itself should not be considered a
count of errors but I argue that is not at all common knowledge. At
Red Hat it is a weekly, if not daily, occurrence that a customer opens
a case to ask about a non-zero rx_dropped counter. Whether they
noticed it themselves or some 3rd party monitoring software
highlighted it. Sometimes it reflects a real problem but more often
than not it turns out there is some benign LLC traffic (or the like)
arriving on the interface. That's a seemingly simple and nice answer
but it often takes a good bit of time to convince people they can
ignore a non-zero rx_dropped (if not ignore, at least appreciate it is
not a fault of the NIC/OS). For example, with pcaps and by monitoring
the counter you can show a 1:1 correlation between specific types of
traffic which do not match /proc/net/ptype and increases in
rx_dropped. Its neat but it takes time and often distracts from
whatever the real problem is.

>
> I'm not applying this patch, sorry.
>

If you do not agree with adjusting the purpose of rx_nohandler to
track these events then would you agree to a new counter?

