Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925102AF73F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbgKKROV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbgKKROT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 12:14:19 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C26EC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:14:19 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b9so3078084edu.10
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DJPo9AErnWcrp3zz1/wLtf0Pi/Gk2wugzOoosq2kUeY=;
        b=cqGcauJrK/bhBtMhZdU+uXDVmB3ymWj4LoQ5DK6RK5eHZYp+qPVvvw6i99JO0tWmMp
         6b4jQ9TLR793cb8GZPgX3NrUL7iO9bTMKDQNixJPhMlUHk5YGIiKCsHQq+TGydrTuyCn
         9CFIVyEGgvqd2zZilpWybZs2yQqZANLJxq9Qfx1EVpI5zLP1+s30brT3YJYT+Xxnzooh
         icy4xgB1OKaUYD0oPTjSP74edF5KdsY3CuAXOngbqBfo8KFVYABA3RLI5IAWdRJy6sRq
         Nc10xT6TMpxrpFlrUUc6mDD9Iw6JAkgC+49LYFz0yzEExnFnNiGAwm3JheyzX0jrYhqT
         u78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DJPo9AErnWcrp3zz1/wLtf0Pi/Gk2wugzOoosq2kUeY=;
        b=Xb9THDATAUHo4jP36SCfNYefntgVl2baD4k81lxyE0VBBVS3eqMTNhLtFeC92X59xV
         z+PR2CFfNmT6lDeZ3MUuMZMP2Wkp75bVizOtCd3t+8Sb1TC7q7mhkf5L61pDk+wKzY4P
         KgukdgPT1PJd66/PFKr/QE22omIlwqNrvYaPloqdy5hbkA+uJGA/UTCOJarKThKt33Z8
         TxJcLY4VqOt6IBgsUOOfu6sGl2d8Ox9RtEf3iL5iiWOjeQnkCUmTffI0eefZhhoUXYFa
         ksiqDModa3uGfDzyW9Sagh2ClDgeMXs9ZlB9IFPN51Uk+PpTn5JcdEE92SA6THNSmG1t
         EOzQ==
X-Gm-Message-State: AOAM5307sHpMErEY+3exL5/ch9hD3umNJdnkp/Te6uQUWClqE/ggKlV0
        MtLfj9scMUoe5ayKEY62iyAFiqWHsjc=
X-Google-Smtp-Source: ABdhPJwFMkVBMDOLvIbbjhCuAe82qs4b5Xd8tfDdoQN8EgrGl8zgIlPLfFqAV28eEJYay0qtRsSv0Q==
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr538468edb.52.1605114858260;
        Wed, 11 Nov 2020 09:14:18 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id hp27sm1066884ejc.2.2020.11.11.09.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 09:14:17 -0800 (PST)
Date:   Wed, 11 Nov 2020 19:14:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Markus =?utf-8?Q?Bl=C3=B6chl?= <markus.bloechl@ipetronik.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201111171416.ns4lysezemurdipo@skbuf>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
 <20201111164727.pqecvbnhk4qgantt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201111164727.pqecvbnhk4qgantt@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 06:47:27PM +0200, Vladimir Oltean wrote:
> On Wed, Nov 11, 2020 at 07:56:58AM -0800, Florian Fainelli wrote:
> > The semantics of promiscuous are pretty clear though, and if you have a
> > NIC with VLAN filtering capability which could prevent the stack from
> > seeing *all* packets, that would be considered a bug. I suppose that you
> > could not disable VLAN filtering but instead install all 4096 - N VLANs
> > (N being currently used) into the filter to guarantee receiving those
> > VLAN tagged frames?
> 
> Are they?
> 
> IEEE 802.3 clause 30.3.1.1.16 aPromiscuousStatus says:
> 
> APPROPRIATE SYNTAX:
> BOOLEAN
> 
> BEHAVIOUR DEFINED AS:
> A GET operation returns the value “true” for promiscuous mode enabled, and “false” otherwise.
> 
> Frames without errors received solely because this attribute has the value “true” are counted as
> frames received correctly; frames received in this mode that do contain errors update the
> appropriate error counters.
> 
> A SET operation to the value “true” provides a means to cause the LayerMgmtRecognizeAddress
> function to accept frames regardless of their destination address.
> 
> A SET operation to the value “false” causes the MAC sublayer to return to the normal operation
> of carrying out address recognition procedures for station, broadcast, and multicast group
> addresses (LayerMgmtRecognizeAddress function).;
> 
> 
> As for IEEE 802.1Q, there's nothing about promiscuity in the context of
> VLAN there.
> 
> Sadly, I think promiscuity refers only to address recognition for the
> purpose of packet termination. I cannot find any reference to VLAN in
> the context of promiscuity, or, for that matter, I cannot find any
> reference coming from a standards body that promiscuity would mean
> "accept all packets".

I realize I did not tell you what the LayerMgmtRecognizeAddress function
does.

function LayerMgmtRecognizeAddress(address: AddressValue): Boolean;
begin
	if {promiscuous receive enabled} then LayerMgmtRecognizeAddress := true;
	if address = ... {MAC station address} then LayerMgmtRecognizeAddress := true;
	if address = ... {Broadcast address} then LayerMgmtRecognizeAddress := true;
	if address = ... {One of the addresses on the multicast list and multicast reception is enabled} then LayerMgmtRecognizeAddress := true;
	LayerMgmtRecognizeAddress := false
end; {LayerMgmtRecognizeAddress}

Markus complained about the tcpdump program in particular. Well, tcpdump
is a complex beast, and far too often, people seem to conflate tcpdump
with promiscuity, even though:
- promiscuity is not what enables tcpdump to see "all packets" being
  sent/received by the network stack on that interface, but ETH_P_ALL
  sockets are what do the magic there
- tcpdump also has a --no-promiscuous-mode option.

I would expect that tcpdump could gain a feature to disable (even if
temporarily) the rx-vlan-filter offload, through an ethtool netlink
message. Then users could get what they expect.
