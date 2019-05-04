Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32E913C42
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfEDXXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:23:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39081 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfEDXXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 19:23:48 -0400
Received: by mail-ed1-f68.google.com with SMTP id e24so10683216edq.6
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 16:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5FzYPzVUjDBYhu9xG7wYF/QuW6GPTEeGPSf5NqmTrQ=;
        b=V0G5I1JZ+LEDTSxSASB5bc/eBkr/dh3O443IJQN5+5GqUmmhQ46oIQK+rDkT2VolsE
         ShGz2lwXOvjhSnkbyAG1186qWqdrs+Lhjpj+tLwXA01YhioKc5MXaD1wNVifIaheayHi
         dexnENKLjCInKUoOoJcDY2qGFmGfmVLlgGUl8nxjW6CCJ72ykh3+pkF8guJgAexnlNBV
         +FEtn5Q3YNH3qKdr9Gb8Gjldgbxts5c8T8e/zBVwIdK0YVncms3SIQD+70kCf4DStGW2
         KEka1WyiUxXdG+oekzfFDGKRFzFup4uFGZohRIiWIZCtPjP402MYB3zVDIVBpvwmIO/D
         nJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5FzYPzVUjDBYhu9xG7wYF/QuW6GPTEeGPSf5NqmTrQ=;
        b=HCIBQfT5SltBRZfBKDanD3j8PviIagC34NZnYFdbALO8eXjY09A9gVBREmwxLp+nrn
         idm3jTbkh89QIivYe2d9bVkcm0A9Mv5JzZ8ExM4fNS2RclZJeDuBA60xHVbsbkP4YljG
         1b/B2wf5BdkfBpBSfE9LpS7B654+RYvDCE7sMVlloCkqobP81f8TgRyOcErvPyOIbXsO
         yACZ0n64H/d1Ilt/uT4ck4TMC3YQPNzij6YgMbX3q8Z2wGUpxdx+ApadrCU7X+E33V2D
         IjEHJ89yn6Yn2xcOrkNsiLlBTn+uhqoMJnOoIvv7SzuSQwp18ep29SrXQVBBITKTXUrq
         6a6w==
X-Gm-Message-State: APjAAAWs4TFpSWB+uYuBRCbsGXh2viYLqwWqs6phRzHBIsp1vZXp8uzP
        +y2SzWr0h1gmebjiNVyCBqWawwdgTBVQ22y2Tfw=
X-Google-Smtp-Source: APXvYqwzvkZfslfICG3n1vytnhBxEy517gtpy4c7LvINwYxwMq2jqRKM2jsROM0J7sqhHJVh54d7PwWtwAZkhYzHF7w=
X-Received: by 2002:a50:9177:: with SMTP id f52mr17450690eda.18.1557012226290;
 Sat, 04 May 2019 16:23:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190504135919.23185-1-olteanv@gmail.com> <20190504135919.23185-4-olteanv@gmail.com>
 <20190504184935.GE25185@t480s.localdomain>
In-Reply-To: <20190504184935.GE25185@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 5 May 2019 02:23:35 +0300
Message-ID: <CA+h21hrUhts6OWC6e7EtyaapTJGb1f1xO_ybuSn949rBqfUcag@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/9] net: dsa: Allow drivers to filter packets
 they can decode source port from
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 May 2019 at 01:49, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Sat,  4 May 2019 16:59:13 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Frames get processed by DSA and redirected to switch port net devices
> > based on the ETH_P_XDSA multiplexed packet_type handler found by the
> > network stack when calling eth_type_trans().
> >
> > The running assumption is that once the DSA .rcv function is called, DSA
> > is always able to decode the switch tag in order to change the skb->dev
> > from its master.
> >
> > However there are tagging protocols (such as the new DSA_TAG_PROTO_SJA1105,
> > user of DSA_TAG_PROTO_8021Q) where this assumption is not completely
> > true, since switch tagging piggybacks on the absence of a vlan_filtering
> > bridge. Moreover, management traffic (BPDU, PTP) for this switch doesn't
> > rely on switch tagging, but on a different mechanism. So it would make
> > sense to at least be able to terminate that.
> >
> > Having DSA receive traffic it can't decode would put it in an impossible
> > situation: the eth_type_trans() function would invoke the DSA .rcv(),
> > which could not change skb->dev, then eth_type_trans() would be invoked
> > again, which again would call the DSA .rcv, and the packet would never
> > be able to exit the DSA filter and would spiral in a loop until the
> > whole system dies.
> >
> > This happens because eth_type_trans() doesn't actually look at the skb
> > (so as to identify a potential tag) when it deems it as being
> > ETH_P_XDSA. It just checks whether skb->dev has a DSA private pointer
> > installed (therefore it's a DSA master) and that there exists a .rcv
> > callback (everybody except DSA_TAG_PROTO_NONE has that). This is
> > understandable as there are many switch tags out there, and exhaustively
> > checking for all of them is far from ideal.
> >
> > The solution lies in introducing a filtering function for each tagging
> > protocol. In the absence of a filtering function, all traffic is passed
> > to the .rcv DSA callback. The tagging protocol should see the filtering
> > function as a pre-validation that it can decode the incoming skb. The
> > traffic that doesn't match the filter will bypass the DSA .rcv callback
> > and be left on the master netdevice, which wasn't previously possible.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>
> Looks promising, I'll try to give this a try soon!
>
> Thanks,
> Vivien

Hi Vivien,
Thanks but what do you mean by trying it out?
-Vladimir
