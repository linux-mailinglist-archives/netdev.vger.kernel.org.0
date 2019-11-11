Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C181F823D
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 22:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKKVaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 16:30:10 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44047 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbfKKVaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 16:30:10 -0500
Received: by mail-ed1-f67.google.com with SMTP id a67so13112461edf.11;
        Mon, 11 Nov 2019 13:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KW7XkByR3IFmIjB/AoV0GUU6UKT5NbFAL1hyLDNZdjE=;
        b=Lklfp1mV7cL6MNx9XGPWy6xZEPOs69RdW9svMOfNDCEvcgPByOIKLcMsQCkddzQmAx
         y1c+dDJ48Y1zlVaAyYXRsncyhpb+gf8sysOfAHjKLBBA26h1929vOI8AUBw7zh5JGRe8
         kQ5iUPMkmG6vXak5bhY54FvIWTMjfSA91zUNNeFfhiwSdKllr3Uh4PdPCHVly7rQHrt6
         GN5B/v8w9HogFpMSrbjMlDs0kp8zt1xe0eksbGh7QDCYntSiJ4QbuDUqmJPK4mHQzCi1
         h3r+UGlpb18Ue1w/NrEQUw3/pBB934l89g4ivNv2SIKGLL9BwGGVAO4lESQqI/dPI7Iv
         jsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KW7XkByR3IFmIjB/AoV0GUU6UKT5NbFAL1hyLDNZdjE=;
        b=tRXVVjGflKZkMah9n2aEbJDjhG99LVU54KUvf0XjB2HJ8IPJvxrhfDjvdhL8hJe7gv
         iw426a94VWEHrKaYSXMCtUv9q1pC7PNndAnzmcut+T25u/K5XzGBHHi8b5C2Cp6kaT5Y
         555sku5Vm97LzIIPVypdffIQuXjx4n1wyWO4vtbsRVGuocAWOxG2TXFle2JNYpo3hTaf
         vGtdIkK4Up1/e3SWJ+A0Wa29DdqtWrkYGwnOnIVyagb/tSRZuvu83Ltk7KpuuiA0N/gZ
         iH9o/lvUrnDDlsPeY3bvsMkbgEhxLYMJzt040jAvqHs5NfziQIbL+jFWDIkA8/yUbmS0
         p8xQ==
X-Gm-Message-State: APjAAAUcuG4dIlygSHq0SeBt1/hzdioq5R0IxMzFSgWb2mzxYzAebi2I
        WRDx+rFRwnHWHAm9CriygFNYve/KYY+5UUZOkP8=
X-Google-Smtp-Source: APXvYqzW930yn9vaelxEC8nE+S3tPXvdnq2a6HDTD24PGljvY+l/g3947RQCyyqn0kEX1JEc6I07TF2NGrkAXevf1zs=
X-Received: by 2002:aa7:c7c1:: with SMTP id o1mr29128925eds.123.1573507806883;
 Mon, 11 Nov 2019 13:30:06 -0800 (PST)
MIME-Version: 1.0
References: <20191111195421.11619-1-f.fainelli@gmail.com> <1f653232-c877-069d-8412-ef141dcf0dab@gmail.com>
In-Reply-To: <1f653232-c877-069d-8412-ef141dcf0dab@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 11 Nov 2019 23:29:55 +0200
Message-ID: <CA+h21hpgM69KF3cCLQJshaQ9poJ1y9RDpvH9J+gBkS+D_7Bb+A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Prevent usage of NET_DSA_TAG_8021Q as
 tagging protocol
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 at 21:55, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 11/11/19 11:54 AM, Florian Fainelli wrote:
> > It is possible for a switch driver to use NET_DSA_TAG_8021Q as a valid
> > DSA tagging protocol since it registers itself as such, unfortunately
> > since there are not xmit or rcv functions provided, the lack of a xmit()
> > function will lead to a NPD in dsa_slave_xmit() to start with.
> >
> > net/dsa/tag_8021q.c is only comprised of a set of helper functions at
> > the moment, but is not a fully autonomous or functional tagging "driver"
> > (though it could become later on). We do not have any users of
> > NET_DSA_TAG_8021Q so now is a good time to make sure there are not
> > issues being encountered by making this file strictly a place holder for
> > helper functions.
> >
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
>
> [snip]
>
> > -static const struct dsa_device_ops dsa_8021q_netdev_ops = {
> > -     .name           = "8021q",
> > -     .proto          = DSA_TAG_PROTO_8021Q,
> > -     .overhead       = VLAN_HLEN,
> > -};
> > -
> > -MODULE_LICENSE("GPL v2");
>
> I probably need to keep that around to avoid complaints about the module
> tainting the kernel, expect a v2 based on that and/or reviewer comments.
> --
> Florian

Actually I wanted to see the tainting in action. But it's worse than
that, due to the use of exported GPL symbols.

insmod tag_8021q.ko
[   68.205843] tag_8021q: module license 'unspecified' taints kernel.
[   68.212183] Disabling lock debugging due to kernel taint
[   68.217876] tag_8021q: Unknown symbol skb_pull_rcsum (err -2)
[   68.223781] tag_8021q: Unknown symbol br_vlan_get_info (err -2)
[   68.229675] tag_8021q: Unknown symbol br_vlan_get_pvid (err -2)
insmod: ERROR: could not insert module tag_8021q.ko: Unknown symbol in module

So you can add on v2:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
