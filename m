Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12B96E13F9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjDMSTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 14:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDMSTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 14:19:49 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3B4E6F;
        Thu, 13 Apr 2023 11:19:48 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 857315C00DF;
        Thu, 13 Apr 2023 14:19:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 13 Apr 2023 14:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681409987; x=1681496387; bh=Kh4f8LOv/N05w
        e0ingeowtI9oIpu6/dYXCFm4olQziw=; b=GtkijS530SN0bfZi1gNOnrfH3GICi
        NQJ3rNhhFMefopocSkog5wqCHL9fOc4MIVdYAxi9Zb6SFBcZKRpqNSS1M3x9EI2m
        xe7iEXn80cY7TzfrpayDmRVc51E3wQdjasJ46kW9D0iYNOvxpJK7R8KXu8e83Nty
        +AsMNIg3locCcAOHZa6WE5Unkuq5c0THjPXpJpgw1qJYNo+iOddRaum0Xez7aBxp
        11rKFyEnpS4c3JB8p5zMw1CNJs8DjX//mbEIrqrIJFMemYwbNR9z0lJq/gqqCqBn
        WZDqiA54yynqyEvn+MpDXZM5flNEUDiE4fPL0u+RwXEFhfURTxy6ajgzg==
X-ME-Sender: <xms:wkc4ZPiYE6uPOml8mrvjMZWki9SNq1cbmq-YGm2zEHbXOiOvC_9dRQ>
    <xme:wkc4ZMANXc91d213JjWYnYL1WgP33sQ501YdHzjrv0M6v95GblpLbJDlNabRhbsP9
    zy9SDaEVH4TZ-8>
X-ME-Received: <xmr:wkc4ZPGyWQkxYuYBAq-d_Fp4w9YMzwz0K-tDWEPrMvBPHGpfDYj2H4U828Zx1fycFVZ-0AUfrqcFZwpWOPpioDyi3GM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekkedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeevieevgfeuleejgfeghefhuddviefhgeejhfehgeekgeevfefggefgudef
    hfelgfenucffohhmrghinhepihhpvhegrdhpihhnghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wkc4ZMQiBcst42AZLOfVV6OE_SNPj9OAMsKmQYFSS1uufjgycRS1sg>
    <xmx:wkc4ZMypX0-Ryq4nZKKLQaUtrZBARAvK8KBkkX05VlbmjgrujwfBww>
    <xmx:wkc4ZC4wP69ORHXfRFEhsD2LRhAkRkcc3if8ViWSfZqqmatZzy8k8g>
    <xmx:w0c4ZAlCdU3UHHFCZquoxV7TCjtNKBaqG6-G6fG63MnLWbEmCjETLg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Apr 2023 14:19:45 -0400 (EDT)
Date:   Thu, 13 Apr 2023 21:19:41 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [BUG] [FIXED: TESTED] kmemleak in rtnetlink_rcv() triggered by
 selftests/drivers/net/team in build cdc9718d5e59
Message-ID: <ZDhHvUrkua8gLMfZ@shredder>
References: <78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr>
 <ZDLyZX545Cw+aLhE@shredder>
 <67b3fa90-ad29-29f1-e6f3-fb674d255a1e@alu.unizg.hr>
 <7650b2eb-0aee-a2b0-2e64-c9bc63210f67@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7650b2eb-0aee-a2b0-2e64-c9bc63210f67@alu.unizg.hr>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 07:34:09PM +0200, Mirsad Goran Todorovac wrote:
> I've ran "make kselftest" with vanilla torvalds tree 6.3-rc5 + your patch.
> 
> It failed two lines after "enslaved device client - ns-A IP" which passed OK.
> 
> Is this hang for 5 hours in selftests: net: fcnal-test.sh test, at the line
> (please see to the end):

It's not clear to me if the test failed for you or just got stuck. The
output below is all "[ OK ]".

I ran the test with my patch and got:

Tests passed: 875
Tests failed:   5

I don't believe the failures are related to my patch given the test
doesn't use bonding.

See more below.

> 
> # ###########################################################################
> # IPv4 address binds
> # ###########################################################################
> # 
> # 
> # #################################################################
> # No VRF
> # 
> # SYSCTL: net.ipv4.ping_group_range=0 2147483647
> # 
> # TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
> # TEST: Raw socket bind to local address after device bind - ns-A IP            [ OK ]
> # TEST: Raw socket bind to local address - ns-A loopback IP                     [ OK ]
> # TEST: Raw socket bind to local address after device bind - ns-A loopback IP   [ OK ]
> # TEST: Raw socket bind to nonlocal address - nonlocal IP                       [ OK ]
> # TEST: TCP socket bind to nonlocal address - nonlocal IP                       [ OK ]
> # TEST: ICMP socket bind to nonlocal address - nonlocal IP                      [ OK ]
> # TEST: ICMP socket bind to broadcast address - broadcast                       [ OK ]
> # TEST: ICMP socket bind to multicast address - multicast                       [ OK ]
> # TEST: TCP socket bind to local address - ns-A IP                              [ OK ]
> # TEST: TCP socket bind to local address after device bind - ns-A IP            [ OK ]
> # 
> # #################################################################
> # With VRF
> # 
> # SYSCTL: net.ipv4.ping_group_range=0 2147483647
> # 
> # TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
> # TEST: Raw socket bind to local address after device bind - ns-A IP            [ OK ]
> # TEST: Raw socket bind to local address after VRF bind - ns-A IP               [ OK ]
> # TEST: Raw socket bind to local address - VRF IP                               [ OK ]
> # TEST: Raw socket bind to local address after device bind - VRF IP             [ OK ]
> # TEST: Raw socket bind to local address after VRF bind - VRF IP                [ OK ]
> # TEST: Raw socket bind to out of scope address after VRF bind - ns-A loopback IP  [ OK ]
> # TEST: Raw socket bind to nonlocal address after VRF bind - nonlocal IP        [ OK ]
> # TEST: TCP socket bind to nonlocal address after VRF bind - nonlocal IP        [ OK ]
> # TEST: ICMP socket bind to nonlocal address after VRF bind - nonlocal IP       [ OK ]
> # TEST: ICMP socket bind to broadcast address after VRF bind - broadcast        [ OK ]
> # TEST: ICMP socket bind to multicast address after VRF bind - multicast        [ OK ]
> # TEST: TCP socket bind to local address - ns-A IP                              [ OK ]
> # TEST: TCP socket bind to local address after device bind - ns-A IP            [ OK ]
> # TEST: TCP socket bind to local address - VRF IP                               [ OK ]
> # TEST: TCP socket bind to local address after device bind - VRF IP             [ OK ]
> # TEST: TCP socket bind to invalid local address for VRF - ns-A loopback IP     [ OK ]
> # TEST: TCP socket bind to invalid local address for device bind - ns-A loopback IP  [ OK ]
> # 
> # ###########################################################################
> # Run time tests - ipv4
> # ###########################################################################
> # 
> # TEST: Device delete with active traffic - ping in - ns-A IP                   [ OK ]
> # TEST: Device delete with active traffic - ping in - VRF IP                    [ OK ]
> # TEST: Device delete with active traffic - ping out - ns-B IP                  [ OK ]
> # TEST: TCP active socket, global server - ns-A IP                              [ OK ]
> # TEST: TCP active socket, global server - VRF IP                               [ OK ]
> # TEST: TCP active socket, VRF server - ns-A IP                                 [ OK ]
> # TEST: TCP active socket, VRF server - VRF IP                                  [ OK ]
> # TEST: TCP active socket, enslaved device server - ns-A IP                     [ OK ]
> # TEST: TCP active socket, VRF client - ns-A IP                                 [ OK ]
> # TEST: TCP active socket, enslaved device client - ns-A IP                     [ OK ]
> # TEST: TCP active socket, global server, VRF client, local - ns-A IP           [ OK ]
> # TEST: TCP active socket, global server, VRF client, local - VRF IP            [ OK ]
> # TEST: TCP active socket, VRF server and client, local - ns-A IP               [ OK ]
> # TEST: TCP active socket, VRF server and client, local - VRF IP                [ OK ]
> # TEST: TCP active socket, global server, enslaved device client, local - ns-A IP  [ OK ]
> # TEST: TCP active socket, VRF server, enslaved device client, local - ns-A IP  [ OK ]
> # TEST: TCP active socket, enslaved device server and client, local - ns-A IP   [ OK ]
> # TEST: TCP passive socket, global server - ns-A IP                             [ OK ]
> # TEST: TCP passive socket, global server - VRF IP                              [ OK ]
> # TEST: TCP passive socket, VRF server - ns-A IP                                [ OK ]
> # TEST: TCP passive socket, VRF server - VRF IP                                 [ OK ]
> # TEST: TCP passive socket, enslaved device server - ns-A IP                    [ OK ]
> # TEST: TCP passive socket, VRF client - ns-A IP                                [ OK ]
> # TEST: TCP passive socket, enslaved device client - ns-A IP                    [ OK ]
> # TEST: TCP passive socket, global server, VRF client, local - ns-A IP          [ OK ]
> 
> Hope this helps.
> 
> I also have a iwlwifi DEADLOCK and I don't know if these should be reported independently.
> (I don't think it is related to the patch.)

If the test got stuck, then it might be related to the deadlock in
iwlwifi. Try running the test without iwlwifi and see if it helps. If
not, I suggest starting a different thread about this issue.

Will submit the bonding patch over the weekend.

Thanks for testing
