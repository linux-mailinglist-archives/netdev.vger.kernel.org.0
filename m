Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B7F32C413
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379467AbhCDAKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbhCCK2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:28:34 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE16BC06178A
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:27:53 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id a9so8843812qkn.13
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 02:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w3iu+FPZ2AQzegLPXY/KDKL+9Oc/6sekpAqi6o7HuJI=;
        b=iEGrkfqbIjy7TAtG6ZAITpccSyN9/W2r2t5hbzfvr9lLSOTTVEfIVnVchRJAI8AZwJ
         imrk1T44duG21Zt5Ju8BAUPDJeiiGJilPv70pByvhMPxZC0tTqoyg611p0rBbXrtH1fC
         QmH1JqpKxduAr5r/txEupbyCyAUOpvxdL0WweMROrs/+YqfAwhLPNGPXsPZ2xPce+tIG
         j6/qWkCgQRJjapH6g7cguDcyonlWtitPQRGeq02LWuN8dfnRL9+9X5wBWm7MRX8XPbg0
         Xb82rdYWV49rAAfrd6W5/Vl4FqpMh3lAFiKUJo4U8y4EyVfbhQCNCrOPtxr8g3Vzphqu
         9o+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w3iu+FPZ2AQzegLPXY/KDKL+9Oc/6sekpAqi6o7HuJI=;
        b=A5OjkFC0R9wevtvp4ZrEOVhO1JupqBBBYHkLzC5Lf4/mUXJQ+Zr4/F6fhNH8qKAeNy
         5hwbFgJcNtHp5Qc+oHWnPxMoM3FhQ1QN1KuAMN5shnUxXdYiCHVuY9kQfVzoPjYowcnJ
         W80jR+ZVbBCCVGZjBELpOEi5dDY6gJBqM6G7Hf4LLeIQ+LBNIQidPuX3C/8UFijkzHWi
         2zKtLO5UjtExL0/oE15Q0mOeHySGMi3x6v3ti2/lk7KBELj+3h3RAO6fC1vNWEX/HQQm
         k/hsUUxUVDAe263mclyWsg0wmuhuzCpV9/y/Xm5chcev2IPjsv1t0ZoAPaFRNzY8vjF9
         vfMg==
X-Gm-Message-State: AOAM533TnLh1ZrwVtuVNV9NuHAXzstu1XTf+/smoxxducGfSFORuLOtS
        sE3pVLrNmIxtPRuzzX2vHm9AshYtcZczlHmxQy+WKw==
X-Google-Smtp-Source: ABdhPJz4zeZijSXmd2tIZ8Sz21Pfc9SkCP2ddPDhF//3BI0zJ8VIiF3Bpy0cZps+fQVBiWasY126gcNsZ9qBT2MqJl0=
X-Received: by 2002:a37:96c4:: with SMTP id y187mr25321093qkd.231.1614767272807;
 Wed, 03 Mar 2021 02:27:52 -0800 (PST)
MIME-Version: 1.0
References: <20200808040440.255578-1-yepeilin.cs@gmail.com>
 <CACT4Y+b6m7kRS82iRNcmaEPKN8fbvOUmztuGJSw6OketyxM8Kw@mail.gmail.com> <1576870386.32806253.1614766300531.JavaMail.zimbra@redhat.com>
In-Reply-To: <1576870386.32806253.1614766300531.JavaMail.zimbra@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 3 Mar 2021 11:27:41 +0100
Message-ID: <CACT4Y+Y090LkpY=PcuG_VGhaah1uPduO+dHww3uERP_x1MEUMQ@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net] Bluetooth: Fix NULL pointer
 dereference in amp_read_loc_assoc_final_data()
To:     Gopal Tiwari <gtiwari@redhat.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+f4fb0eaafdb51c32a153@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 11:11 AM Gopal Tiwari <gtiwari@redhat.com> wrote:
>
> Hi,
>
> I tried to search the patch for one of the bugzilla reported (Internal) h=
ttps://bugzilla.redhat.com/show_bug.cgi?id=3D1916057 with the traces
>
> [  405.938525] Workqueue: hci0 hci_rx_work [bluetooth]
> [  405.941360] RIP: 0010:amp_read_loc_assoc_final_data+0xfc/0x1c0 [blueto=
oth]
> [  405.944740] Code: 89 44 24 29 48 b8 00 00 00 00 00 fc ff df 0f b6 04 0=
2 84 c0 74 08 3c 01 0f 8e 9d 00 00 00 0f b7 85 c0 03 00 00 66 89 44 24 2b <=
f0> 41 80 4c 24 30 04 4c 8d 64 24 68 48 89 ee 4c 89 e7 e8 3d 48 fe
> [  405.952396] RSP: 0018:ffff88802ea0f838 EFLAGS: 00010246
> [  405.955368] RAX: 0000000000000000 RBX: 1ffff11005d41f08 RCX: dffffc000=
0000000
> [  405.958669] RDX: 1ffff110254cc878 RSI: ffff88802eeee000 RDI: ffff88812=
a6643c0
> [  405.961980] RBP: ffff88812a664000 R08: 0000000000000000 R09: 000000000=
0000000
> [  405.965319] R10: ffff88802ea0fd00 R11: 0000000000000000 R12: 000000000=
0000000
> [  405.968624] R13: 0000000000000041 R14: ffff88802b836800 R15: ffff88812=
50570c0
> [  405.971989] FS:  0000000000000000(0000) GS:ffff888055a00000(0000) knlG=
S:0000000000000000
> [  405.975645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  405.978755] CR2: 0000000000000030 CR3: 000000002d200000 CR4: 000000000=
0340ee0
> [  405.982150] Call Trace:
> [  405.984768]  ? amp_read_loc_assoc+0x170/0x170 [bluetooth]
> [  405.987875]  ? rcu_read_unlock+0x50/0x50
> [  405.990663]  ? deref_stack_reg+0xf0/0xf0
> [  405.993403]  ? __module_address+0x3f/0x370
> [  405.996184]  ? hci_cmd_work+0x180/0x330 [bluetooth]
> [  405.999170]  ? hci_conn_hash_lookup_handle+0x1a1/0x270 [bluetooth]
> [  406.002354]  hci_event_packet+0x1476/0x7e00 [bluetooth]
> [  406.005407]  ? arch_stack_walk+0x8f/0xf0
> [  406.008206]  ? ret_from_fork+0x27/0x50
> [  406.010887]  ? hci_cmd_complete_evt+0xbf70/0xbf70 [bluetooth]
> [  406.013933]  ? stack_trace_save+0x8a/0xb0
> [  406.016618]  ? do_profile_hits.isra.4.cold.9+0x2d/0x2d
> [  406.019483]  ? lock_acquire+0x1a3/0x970
> [  406.022092]  ? __wake_up_common_lock+0xaf/0x130
>
>
> I didn't found any solution upstream. After the vmcore analysis I found w=
hat is wrong. And took reference from the following patch, which seems to b=
e on the similar line
>
> commit 6dfccd13db2ff2b709ef60a50163925d477549aa
>     Author: Anmol Karn <anmol.karan123@gmail.com>
>     Date:   Wed Sep 30 19:48:13 2020 +0530
>
>         Bluetooth: Fix null pointer dereference in hci_event_packet()
>
>         AMP_MGR is getting derefernced in hci_phy_link_complete_evt(), wh=
en called
>         from hci_event_packet() and there is a possibility, that hcon->am=
p_mgr may
>         not be found when accessing after initialization of hcon.
>
>         - net/bluetooth/hci_event.c:4945
>
> How we can avoid this scenario. So I made the chages and tested. It worke=
d or avoided the kernel panic. But I really don't know that some one has al=
ready posted the patch. I would have love to backport the patch, I was more=
 of looking for the fix. That's where I didn't applied the reported-by tag =
as I thought it reported internal only.

Hi Gopal,

I think it's somewhat inherent to the current kernel unstructured
processes with bugs being reported on mailing lists, bugzilla,
distro-specific trackers.
One useful thing, though, is searching Lore, e.g. searching for just
the crashing function:
https://lore.kernel.org/lkml/?q=3Damp_read_loc_assoc_final_data
gives the report and the patch (if we filter out all entries produced
by your patch, which obviously wasn't yet there before you wrote it
:)):

12. [Linux-kernel-mentees] [PATCH net] Bluetooth: Fix NULL pointer
dereference in amp_read_loc_assoc_final_data()
    - by Peilin Ye @ 2020-08-08  4:04 UTC [21%]

13. KASAN: null-ptr-deref Write in amp_read_loc_assoc_final_data
    - by syzbot @ 2020-07-31 17:04 UTC [13%]


> Thanks & regards,
> Gopal Tiwari
>
>
>
> ----- Original Message -----
> From: "Dmitry Vyukov" <dvyukov@google.com>
> To: "Peilin Ye" <yepeilin.cs@gmail.com>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Johan Hedberg" <johan.hedbe=
rg@gmail.com>, "Andrei Emeltchenko" <andrei.emeltchenko@intel.com>, "Greg K=
roah-Hartman" <gregkh@linuxfoundation.org>, "David S. Miller" <davem@daveml=
oft.net>, "Jakub Kicinski" <kuba@kernel.org>, linux-kernel-mentees@lists.li=
nuxfoundation.org, "syzkaller-bugs" <syzkaller-bugs@googlegroups.com>, "lin=
ux-bluetooth" <linux-bluetooth@vger.kernel.org>, "netdev" <netdev@vger.kern=
el.org>, "LKML" <linux-kernel@vger.kernel.org>, gtiwari@redhat.com, syzbot+=
f4fb0eaafdb51c32a153@syzkaller.appspotmail.com
> Sent: Wednesday, March 3, 2021 1:51:41 PM
> Subject: Re: [Linux-kernel-mentees] [PATCH net] Bluetooth: Fix NULL point=
er dereference in amp_read_loc_assoc_final_data()
>
> On Sat, Aug 8, 2020 at 6:06 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > Prevent amp_read_loc_assoc_final_data() from dereferencing `mgr` as NUL=
L.
> >
> > Reported-and-tested-by: syzbot+f4fb0eaafdb51c32a153@syzkaller.appspotma=
il.com
> > Fixes: 9495b2ee757f ("Bluetooth: AMP: Process Chan Selected event")
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > ---
> >  net/bluetooth/amp.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
> > index 9c711f0dfae3..be2d469d6369 100644
> > --- a/net/bluetooth/amp.c
> > +++ b/net/bluetooth/amp.c
> > @@ -297,6 +297,9 @@ void amp_read_loc_assoc_final_data(struct hci_dev *=
hdev,
> >         struct hci_request req;
> >         int err;
> >
> > +       if (!mgr)
> > +               return;
> > +
> >         cp.phy_handle =3D hcon->handle;
> >         cp.len_so_far =3D cpu_to_le16(0);
> >         cp.max_len =3D cpu_to_le16(hdev->amp_assoc_size);
>
> Not sure what happened here, but the merged patch somehow has a
> different author and no Reported-by tag:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3De8bd76ede155fd54d8c41d045dda43cd3174d506
> so let's tell syzbot what fixed it manually:
> #syz fix:
> Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data
>
