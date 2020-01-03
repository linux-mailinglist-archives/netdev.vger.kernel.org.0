Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF512F216
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgACAUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:20:11 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37055 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgACAUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:20:11 -0500
Received: by mail-ed1-f67.google.com with SMTP id cy15so40459123edb.4;
        Thu, 02 Jan 2020 16:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FV5X7fA+rrUeDnXZ5UiKMokLx1xAJtoG3k2CK746+60=;
        b=Be1Z4lKrrI8RtYjq/BzQfrsrCUA2UJPv3VAYzJae/rKQQP4Mi+149d9Yfc4ozDEFnb
         Zk8lQf019qLG1AXIqKFCL0h84IaKBpxEFDMdoLOB+KtZC8hcNg27wvwd6H4boJJUuVwJ
         p06otaRRzArTVUjHQB80gpgk9NqfS8sn9WrJAqlGRZfRnzhgjHXsl7WH3TgmsjC/loS1
         WRQE2gex7s4Z0hTVMOgYJMHsXVl8HfZzqMX1Q2JPYaM7L2pP6Y2M6SBICtxchYmXn7v0
         NkvIFR+5N8zDAC+NT1XtLku0AXonKX+rgIRYheh7gNXyQhAamyBQvq1W0yyYgo68zdd6
         nSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FV5X7fA+rrUeDnXZ5UiKMokLx1xAJtoG3k2CK746+60=;
        b=TfOcssMA7nXXKQkVtvQ6C4Ckrc5XJPv/dOHlMV+VNrjjSs+wrBUNSys1CqzY7ttVBK
         3jioYOHb9MgGogW5QiJC9SBMI8zdfKfXAYAD04pNTRDARzJSa1Nr6rd5CkYb8vBQNT2O
         NMcHeBFUEOBei54fF4uhkaB6rg5UNu2oPRXifXc01Enk1MoaGhT+uaw4/C5r5JSPwcfP
         7RVUO86uuZ2jqkdInRhbeyCtVKtWbcoi/yINFm0y5Faeu1ntE0o0n+sKV2n6IWATtezD
         6YeWRt7QoNL1VA5YoyUj/yXBYzy//Ku3vFPA3Sexpjh+TLVrifvbyAPMVE53q1PS+zii
         Tf5A==
X-Gm-Message-State: APjAAAV9qKNs83tqezNHijJsIBXrcKnR8bkDZA9FxoPDfKhMkiVQh7dp
        6AGjCHpjqlTDSRfj+RWYBfmO3cWyDjlLxrgnm4U=
X-Google-Smtp-Source: APXvYqyneY6vp7MndZY2IHVlAnYW2Ny5AcY4pl2xKrupts1lB1ozOUhHi1uWOz20Rt6s9+dkTrmWhTv4viThJydhKuA=
X-Received: by 2002:aa7:d34d:: with SMTP id m13mr89428224edr.140.1578010809821;
 Thu, 02 Jan 2020 16:20:09 -0800 (PST)
MIME-Version: 1.0
References: <20200102233657.12933-1-f.fainelli@gmail.com>
In-Reply-To: <20200102233657.12933-1-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 3 Jan 2020 02:19:58 +0200
Message-ID: <CA+h21hrLO2Nfryu74Joj-T3-ithgoSFOQZsw4Z5QWOnhttvGiA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Remove indirect function call for flow dissection
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, 3 Jan 2020 at 01:39, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> We only need "static" information to be given for DSA flow dissection,
> so replace the expensive call to .flow_dissect() with an integer giving
> us the offset into the packet array of bytes that we must de-reference

packet array? packed array?

> to obtain the protocol number. The overhead was alreayd available from

already

> the dsa_device_ops structure so use that directly.
>
> The presence of a flow_dissect callback used to indicate that the DSA
> tagger supported returning that information,we now encode this with a
> proto_off value of DSA_PROTO_OFF_UNPSEC if the tagger does not support

UNSPEC

> providing that information yet.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Unfortunately I don't really understand the DSA implementations of flow_dissect.
Is proto_off supposed to mean "the __be16 pointer difference A - B
between A. the position of the real EtherType and B. the current
skb->data (aka ETH_HLEN bytes into the frame, aka 2 bytes after the
normal EtherType was supposed to be)"?
Otherwise said, the offset in bytes between the real EtherType
position and skb->data is 2 * (proto_off + 1).
Furthermore, the offset in bytes is exactly equal to the tagger
overhead in bytes, unless it's a tag that doesn't push the EtherType
to the right, such as the trailer tag.

If the above is indeed correct, can you just skip DSA_PROTO_OFF_UNSPEC
and add proper proto_off values "in blind" for all taggers? I think
it's rather safe to assume that they all push the EtherType to the
right with the exception of the trailer tag, which will have an offset
of -1 in terms of __be16 pointers, by the way (so your -1 encoding of
DSA_PROTO_OFF_UNSPEC won't work for it anyway).

Also, documenting the unit of measurement for proto_off would really
go a long way.

What is a good test that the flow_dissector does what it's supposed to
do with DSA?

Regards,
-Vladimir
