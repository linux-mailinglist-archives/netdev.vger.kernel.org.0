Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D0D6F3D4F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 08:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjEBGTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 02:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjEBGTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 02:19:37 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4A74692;
        Mon,  1 May 2023 23:19:10 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D666A3200958;
        Tue,  2 May 2023 02:19:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 02 May 2023 02:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1683008348; x=1683094748; bh=dR
        obIkFcnohuw8rzEUyVR4GTSTBhqRrZ5QZv2BLzLaE=; b=bBakIbq6oEgG7UPEnq
        +mMZy6zZaJfcQHPekoxpY9Prlewb2B7ad4CTaasZ6LsoUIrqA1LaUSkNU3uWGqXf
        WsAVdf6l21jyDlDAYtbujtnJc16l8ICKVga9Q1sTPeh2zrTcR6C5sQ0/qhlRA4FG
        hbg3c7IYHI3BwYlkLkVWLX0iZ2TZ/f6fA/xWgmOqf7JDi0i3ElXdvhIKtYami4Eh
        g5AmhBFmeC3xQEocFdwkY0ar/tHYTsopy8SUJTlURtzTFWazXeM6ASfA29IhTwln
        EQTKBgpyi+f0zrx0OGx7rnrSccscKzUevVAkkC/nhg8OfQdt4zJ1y7uZki6QfSRJ
        B3PQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1683008348; x=1683094748; bh=dRobIkFcnohuw
        8rzEUyVR4GTSTBhqRrZ5QZv2BLzLaE=; b=YEI+IKk5zhvOH+vrzxCmuEWYj3Urr
        q/YjgHthIMH3J9LvE3OV1nwRw+tbYVjpFSSZLjn3S8rx5bHlT2Kz3ukjKq2fx4+v
        hYZvVCOVpTIeRrlbK9iFFNYtccVavrEz9cXLa8fuPJmeGkAKAwQLuTvwBrpVc9st
        p+S2kbNRR+UJlfaNYd6y24jlvf+xEAmKIZdKlssgcCkmRS6dZodwjxuUBpoUU+5k
        K9T0porV3tFk/WtZguELaM5o5yGo38x7/OaS1KK4htTdww6GUH/YyL4POPe4v7gx
        bfI2OP+Zo40jRbiUi/Q6GGBrn6oY1kMaNw40z4CBQwMDHhz3zKAahJAig==
X-ME-Sender: <xms:XKtQZPEdqL6P6G3ViV0Un-rPFbrNT90LlvcOLMRPmurxfgRWt675jg>
    <xme:XKtQZMVhnRgqeMo7ArOKsXF8kW16qwrNPlmxyTOUEANQyBegJtWpeKXd2fWk-C3f-
    l5wLh-yqZ8nfhb4yGw>
X-ME-Received: <xmr:XKtQZBL31c_RxKQZoob8dw4qWb5Zs_zByk_WGsKMAESnUwxFG8kpYcmeT12SmVNJJYaaLNZP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvhedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdejmdenucfjughrpehffgfhvfevufffjgfkgggtsehttdertddt
    redtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhishhhkhhinhcuoehvlhgrughimh
    hirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrghtthgvrhhnpeeigfdvgeeiieel
    udehueeuueejieeiheegudevhffggeeguddvveduueehueefgeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhi
    shhhkhhinhdrphif
X-ME-Proxy: <xmx:XKtQZNHKj1_jWT95c1ZGjJzBYSMnkn7ldtlLYAzhJBf628-xbL48yQ>
    <xmx:XKtQZFXlYFNYfv4WTplXw0Tyb19K2mdIrD8wPtO-oVC83kcRIObE0A>
    <xmx:XKtQZIOfji876NNcYihLwlQHkgfcBSRk8dtBhRqTRkcJs1aij0mBVQ>
    <xmx:XKtQZKXAqIcv6GHakvKTvZ7A8dRT9EVURATYT_w9nojPNMfQnMrSzA>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 2 May 2023 02:19:04 -0400 (EDT)
References: <20230501162530.26414-1-vladimir@nikishkin.pw>
 <20230501101215.46682967@hermes.local>
User-agent: mu4e 1.8.14; emacs 30.0.50
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
        eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v7 1/2] Add nolocalbypass option to vxlan.
Date:   Tue, 02 May 2023 13:50:38 +0800
In-reply-to: <20230501101215.46682967@hermes.local>
Message-ID: <87ednz9rxn.fsf@laptop.lockywolf.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Tue,  2 May 2023 00:25:29 +0800
> Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:
>
>> If a packet needs to be encapsulated towards a local destination IP and
>> a VXLAN device that matches the destination port and VNI exists, then
>> the packet will be injected into the Rx path as if it was received by
>> the target VXLAN device without undergoing encapsulation. If such a
>> device does not exist, the packet will be dropped.
>> 
>> There are scenarios where we do not want to drop such packets and
>> instead want to let them be encapsulated and locally received by a user
>> space program that post-processes these VXLAN packets.
>> 
>> To that end, add a new VXLAN device attribute that controls whether such
>> packets are dropped or not. When set ("localbypass") these packets are
>> dropped and when unset ("nolocalbypass") the packets are encapsulated
>> and locally delivered to the listening user space application. Default
>> to "localbypass" to maintain existing behavior.
>> 
>> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
>
> Is there some way to use BPF for this. Rather than a special case
> for some userspace program?

Well, in the first patch this was not a special case, but rather change
to the default behaviour. (Which, I guess has been a little too
audacious.)

I am not sure about BPF, but the concrete use-case I have is solvable by
dedicating a packet to a bogus IP, and doing an nftables double-NAT
(source and destination) to 127.0.0.1, which is the way I am solving
this problem now, and I suspect, what most sysadmins who need this
feature would be doing this without this patch.

In fact, among all the people I have talked to about this issue (on
#networking@libera.chat, and elsewhere), nobody considered dropping
packets to be an intuitive thing. The "intuitive logic" here is the
following:

1) I am sending packets to an ip and a port,
2) I have a process listening to packets on this IP and port,
3) Why on Earth are packets not arriving?
4) Even further, why does local behaviour differ from remote behaviour?

So the "special case" is already there by design. The new option is
turning off the special case.

I am aware of the fact that heavy-duty network processing people have a
different perspective on this issue, and that in high-load environments
every tiny bit of performance is of crucial importance, hence "local
bypass" is seen not as a dirty heuristic, but rather as an essential
feature which vastly increases performance, but for "kitchen sink"
sysadmins the current (not documented) behaviour is just baffling.

So I would argue that having an option that, even though it might not be
the most frequently used one, is clearly documented as enabling the most
straightforward behaviour, would be worth it.

And although having a userspace process listening to a vxlan "for
processing" might not be the most frequently used thing (although I do
need it), at least being able to see the packets being sent to local
ports, with, say, tcpdump, in exactly the same way as the packets being
sent to remote addresses, would help sysadmins debug their setups better
even when only the most basic tools available.

I hope that this is convincing enough.

P.S. A apologise for not adding the vxlan: and testing/selftests/net:
prefixes to the patches. I will add them to the next attempt, in
addition to fixing the other issues that might be discovered.

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.

