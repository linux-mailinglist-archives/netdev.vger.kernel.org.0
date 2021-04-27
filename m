Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2584C36BD62
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhD0CgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:36:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60037 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbhD0CgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:36:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EAAC85C01A4;
        Mon, 26 Apr 2021 22:35:17 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute4.internal (MEProxy); Mon, 26 Apr 2021 22:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hmh.eng.br; h=
        mime-version:message-id:in-reply-to:references:date:from:to
        :subject:content-type; s=fm2; bh=vBVTQ1sbBsQfPYqIXqCK4Jv/CFy4Gq4
        uQLWVxvxQRJU=; b=VIuBHyCvI32XasUXpVQ+THVqFZg6Z12Z5UAbWKR/SVWGtWI
        YmW3qVMEuIiwK3g7+ApWYMsrbyPWw2/G7Cnb4d9zfevz92aef025s2LIVXHkjcc+
        sbJPrgYryt4lVOzbD6fc2SC5Rm49Sfe1RpKuB6BUc5hNFlGdVRi8Eg4RSN/lOFwT
        AtXGEUZnuNMxMF7eUopmQngveZ5XHQm/PxJZ3z30dW5slm5Qu1cqa+X3oQx5bU3d
        kVCvzCN4HLhXyO36ewzuijVab7XG2ny2RqGCfr7Z8YFalH3aqwutv2BUsLSNsSGv
        QaFF3iomaZL9irfgIAkZWSqQS1BA6Dzfre8kZrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vBVTQ1
        sbBsQfPYqIXqCK4Jv/CFy4Gq4uQLWVxvxQRJU=; b=ZW0TAQ915dsNWarhUYBMg4
        OBL3oERjAy5Zu+MOdhPWWkRWCwpBuD7Rqligp1piFzc7xbGfa+95Tif3/2nIG23V
        DjYG7jHJSWaWbc473CRDDiIJ+j1rRlOL1KSpV2A1FdheLhVlt+OkufX9/8XzhJPv
        YzDhCvgeRx5ZrGogkbL7RBJt5E9oyRmMWZwsBMJjLokp5brFNlnXSY4bTv0Cloj8
        OFuU70nT3ja14f4Wj+Eocpae0EN31IUpEpQdHs6Jn8gV5BCC6p64a5HZh7s1GO6q
        Xtr2RBXlrT1ZceZNlzpJ61dPRVT4MTXrm9hnEEytDy9oFSLVXRmUTIDZkTBxJurA
        ==
X-ME-Sender: <xms:ZXiHYDzcCKdyG6wwObQHf3Vrl16r4FXSl8eindaaf3b_siZG52sIig>
    <xme:ZXiHYLTJ6WvIfqFPWxG9Xo2SFFXsqCOqwFY3beCx-QEoaFEqVS_akHfU_AcJHqXvV
    8DfBkXXsnV3WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfjvghn
    rhhiqhhuvgcuuggvucfoohhrrggvshcujfholhhstghhuhhhfdcuoehhmhhhsehhmhhhrd
    gvnhhgrdgsrheqnecuggftrfgrthhtvghrnhepuddvgfeikefgieehkeevveduhfevteeu
    heevtdduueduffekuddtffelkefftddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhephhhmhheshhhmhhdrvghnghdrsghr
X-ME-Proxy: <xmx:ZXiHYNXxEv-pKlPC4LgdMHpZeJA3-vb8lhAzE0-5qu4ZHDuRPa_1Uw>
    <xmx:ZXiHYNjBlYtlmtB-OoSyAWWDrijk3AAzMMtm7rIM-cvSvCAmvfQDeg>
    <xmx:ZXiHYFBdTzrp00SpjuemViLXege_ysLAg3tzG9xuAelUSX7Q6W0aKQ>
    <xmx:ZXiHYA__MYA7GaaUR_7utYgJCNAIHRD65Y4v29jIdKOhCgzJ1S265Q>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 75CCE51C005F; Mon, 26 Apr 2021 22:35:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-403-gbc3c488b23-fm-20210419.005-gbc3c488b
Mime-Version: 1.0
Message-Id: <52f1b7a1-ff3b-41d3-a84b-badcda8a6ad6@www.fastmail.com>
In-Reply-To: <8e0aa5a6-0457-ccd0-8984-9c9aaeab2228@gmail.com>
References: <d3a4afd7-a448-4310-930d-063b39bde86e@www.fastmail.com>
 <8e0aa5a6-0457-ccd0-8984-9c9aaeab2228@gmail.com>
Date:   Mon, 26 Apr 2021 23:34:55 -0300
From:   "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To:     "Eric Dumazet" <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Unexpected timestamps in tcpdump with veth + tc qdisc netem delay
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021, at 14:07, Eric Dumazet wrote:
> On 4/26/21 4:35 PM, Henrique de Moraes Holschuh wrote:
[...]
> > [root netns]: tcpdump -i vec0 -s0 -n -p net 192.168.233.0/30
> > listening on vec0, link-type EN10MB (Ethernet), capture size 262144 bytes
> > 17:09:09.740681 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 1, length 64
> 
> Here you see the packet _after_ the 250ms delay
> > 17:09:09.990891 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 1, length 64
> Same here.
[...]
> > Adding more namespaces and VETH pairs + routing "in a row" so that the packet "exits" one veth tunnel and enters another one (after trivial routing) doesn't fix the tcpdump timestamps in the capture at the other end of the veth-veth->routing->veth-veth->routing->... chain.
> > 
> > It looks like some sort of bug to me, but maybe I am missing something, in which case I would greatly appreciate an explanation of where I went wrong... 
> 
> That is only because you expect to see something, but you forgot that tcpdump captures TX packet _after_ netem.

That was it!  Thank you very much for the quick reply, and direct, precise explanation.

I had completely forgotten about the qdisc running before interface timestamping, and I overlooked the fact that I did not try three netns in-a-chain with the qdiscs *in the middle netns*: I tried them in the two opposite edge netns, only.

Again, thank you!

-- 
  Henrique Holschuh
