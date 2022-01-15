Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A766248F4A1
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 05:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiAOEBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 23:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbiAOEBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 23:01:04 -0500
Received: from mail-ot1-x362.google.com (mail-ot1-x362.google.com [IPv6:2607:f8b0:4864:20::362])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FB4C06173E
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 20:01:03 -0800 (PST)
Received: by mail-ot1-x362.google.com with SMTP id a12-20020a0568301dcc00b005919e149b4cso12441749otj.8
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 20:01:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:content-transfer-encoding;
        bh=nh4o6XQm9tR0N195qdrYZ8+lan2fXEvj16Vw678Ovcw=;
        b=02Od3JGRAU45NJcgHllfS5RsgZwZRPrUhDtQaeXH7b1l2Hd7E8z18FdCJYEZdJtqin
         xkzl9YtDtPHfZr29Nm0z7Q9eaNNAMUGjAzqd9ZUu/tXff01ycQlrSiEyty0dOK2+dLb2
         Pm4lHr35dZFij12vbD65xafJIHU3b1Blx9qKFXahBL51BASy4Snu1f5aHwmmRjLlGlr1
         rg/GiejQqU0voU2AtApeHWS8YoB9tA/c/GHV9jpcWetG05b3QCLtzWX6mzFDotjJtQgu
         v4t5IohJBvHQweg8yGIqz5uKtc9jEohYNLxoQK5qMmnd1uqyDMMjya6bu1CH0epz01Ey
         sXHg==
X-Gm-Message-State: AOAM530VW2tTLby5yR+Dz9fTtKAZyQfY+dJyAKKWRdQjf+72It0+JzhQ
        2l9AsrcbCQK6DNC/3ZpeXbIuBHCT12F7zkPeEiibJB5c/8wb
X-Google-Smtp-Source: ABdhPJw77JwOULtfHeEIG/MmWXyl9YtxtQVBD+jc5b0qJ4VdqJslSpncp2iFo1KyGEw+WPn5DWem5ZzIP2x4
X-Received: by 2002:a05:6830:31a4:: with SMTP id q4mr675575ots.345.1642219262377;
        Fri, 14 Jan 2022 20:01:02 -0800 (PST)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id m17sm464074oop.18.2022.01.14.20.01.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jan 2022 20:01:02 -0800 (PST)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.70.41])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 73614301B604;
        Fri, 14 Jan 2022 20:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1642219261;
        bh=nh4o6XQm9tR0N195qdrYZ8+lan2fXEvj16Vw678Ovcw=;
        h=From:To:Cc:Subject:Date:From;
        b=XbOP3bbbd7CB6C5+TEM/QVwAmcVhK9SFZzQl+vXK28Wuw72PE31qWYF97zmmxOEfq
         /a919t9Yr30Ef7CtPenpUzPYTADuzkgis605IB57MCoFOolbkkkWH/h9CmT23HgFZf
         3FfQnxzzstOcejioAaNz3b1aaECfr3pA596jtnfyQR+cqd/GUg4MRdaONeyDQ5mXDh
         LTZgEJ8KJdsY6HqYJvBHXQolCN0yUxKvbBhcJqHp9eD2xusrLrlfcL/db6vzAxIPXt
         zn8uIHiTbvUZbJzgQytRmJ1JaUgqJxxC7rlM7c0eR8+pV2p4OvUh/ZcZuq8QYolmTs
         /oDkk9DN+nPaQ==
Received: from kevmitch by chmeee with local (Exim 4.95)
        (envelope-from <kevmitch@chmeee>)
        id 1n8aFQ-000mub-1e;
        Fri, 14 Jan 2022 20:01:00 -0800
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     kevmitch@arista.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] UDP traceroute packets with no checksum
Date:   Fri, 14 Jan 2022 20:00:49 -0800
Message-Id: <20220115040050.187972-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have run into some trouble with third-party devices whose traceroute
implementation sends UDP packets with empty checksums. Since the
checksum is optional for UDP inside an IPv4 packet, this is perfectly
legal, even if slightly strange. However, we found that such a packet
ends up getting silently ignored by our switch instead of eliciting the
expected ICMP response. The reason is that we handle UDP traceroute
packets are with the iptables rule

-A INPUT -p udp -m udp --dport 33434:33636 -j REJECT --reject-with icmp-port-unreachable

Such packets therefore get an iptables reject normally eliciting the
desired ICMP_DEST_UNREACH response from nf_send_unreach(). However, it
seems that before sending the ICMP response, this function determines
whether it needs to verify the checksum on the incoming packet by
checking if skb->ip_summed == CHECKSUM_UNNECESSARY or
skb->csum_valid. If this is not the case, then it proceeds to verify the
checksum. However, no provision is made here for an empty checksum,
which of course will fail to verify. In this case, netfilter declines
to send the ICMP response on the assumption that the packet is garbage
and the source address cannot be trusted.

As our front panel ports do not perform layer 4 hardware checksum
verification before sending packets to the kernel, the struct skb passed
to netif_recieve_skb by the driver are unconditionally marked
CHECKSUM_NONE.

The udp_error function makes accommodation for UDP packets with empty
checksum by declining to run nf_checksum on them and instead indicating
the packet acceptable. Since nf_checksum already alters the
skb->ip_summed member by marking it as CHECKSUM_COMPLETE when there is a
checksum to verify, it seems reasonable that udp_error similarly mark it
as CHECKSUM_UNNECESSARY when it determines there is no checksum. This is
supported by the note in skbuff.h that explicitly suggests such a value
for packets with empty checksum.

It seems that this issue was almost fixed by 7fc38225363d ("netfilter:
reject: skip csum verification for protocols that don't support it"),
which addressed protocols other than UDP. I considered adding a
IPPROTO_UDP branch to the nf_reject_verify_csum switch statement,
however it would necessarily be more complex than all of the existing
cases since it would require extracting the UDP header and checking the
checksum value. I'm open to doing that as well if requested, but it
doesn't appear to be necessary from what I can tell with the simpler
one-liner I have proposed here.

Finally, I have made no attempt to distinguish between IPv4 and IPv6 in
spite of the fact that empty checksums are not strictly allowed for UDP
inside IPv6. However, this decision to be more permissive appears to
have already been made since udp_error already declared such packets
error free. The aforementioned skbuff.h comment also explicitly mentions
setting empty checksum UDP in IPv6 as CHECKSUM_UNNECESSARY.


