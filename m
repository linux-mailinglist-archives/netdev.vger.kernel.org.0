Return-Path: <netdev+bounces-2001-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 304256FFE79
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59DD72818B8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596D17FE;
	Fri, 12 May 2023 01:38:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D57F0
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:38:56 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1590DE6D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 18:38:53 -0700 (PDT)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6F9353F118
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683855531;
	bh=9YshHwgjlyidS73/p+ggiiB6bKB7h+6pNCgKf/7wsFc=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=k+j6RQ1pWFigFybq9hl1U95Dg5SJLc7moAsGxroNNFxcUe4y9JGyvNs4qE0o0h2sV
	 Jt2F66gQO2eci2Y0S/I2VLW7EtOS1FI1HKyVxAVN5Kjhk6u4whjRdpiXUP6dysUczk
	 fdwAlRLRMb19H5ukJwVGCJGOL9xi0c152/vvbvaGTvwhGmLO6za0exjIgVx567dnLj
	 sX+xk9MhnahY3RZTW2ie1xTNImrRSbBgEjrSkq8xYk3XEvjPG5PZC2iu6upa7/8eqi
	 SUziwygzjIfftFbUZRmpCi9uu163jqh3Eduh9LknEF3ADMT32cwEUt7QQbm6J43s5n
	 a1WtfWG7AX4+A==
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ac6193a1e3so42790015ad.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 18:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683855530; x=1686447530;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9YshHwgjlyidS73/p+ggiiB6bKB7h+6pNCgKf/7wsFc=;
        b=a2QXnTpP0cnKxh6ce6ZS+HcUMs7MoW1cSWZUp8StcRYPtHj2179YKvsIIHC/z0uZHT
         s2Gj9B48dyWxfXM9rToqWTmmb2AGjzFLcxuwQ9KR5vIzH/q/JNrD+rAZev4GuUbXTIjM
         /bHPd1bHaJajRBTTYB3xhR7u+lbrfhsuPfoa+RAIv7QkGDkA1Xd58YNBRj31tuBAbb93
         eZe5yZwrDFQNKSEje5peRjStjJaXqKrDS2osXuURvps7HRQ9ZaERg370ReqQeBIu6HjQ
         OqmdD9xqeCUInwGUvdjRFnQ5TT36zJVnwd31hAy4g2mmoSu6yeavexN80kLaZNmv5EeZ
         kEZg==
X-Gm-Message-State: AC+VfDzUDa+NdhDXrl+M8kdB1W1XWgp5wU/wsCNJ9+L0D+dgFfHWDyCM
	6O6D5Bfi1axJfJWKjMDhnDNHbZXyEk0NAY9QbiH6Aim92YOoB4WJ15wY7VeC6O3lhFMYdHApKnO
	7EumU3oqqdTQhrxEcPPYM+secaJT++mIEuQ==
X-Received: by 2002:a17:902:7881:b0:19e:6cb9:4c8f with SMTP id q1-20020a170902788100b0019e6cb94c8fmr19311002pll.41.1683855530068;
        Thu, 11 May 2023 18:38:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ltPUuyKrvOhgqlH5N1tKymFzdbxmvNDEgcOYkDXMx8jKJm8i7st/Fm1a42EoZZdLG0xkxxw==
X-Received: by 2002:a17:902:7881:b0:19e:6cb9:4c8f with SMTP id q1-20020a170902788100b0019e6cb94c8fmr19310984pll.41.1683855529713;
        Thu, 11 May 2023 18:38:49 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id l16-20020a170902f69000b001a6d08eb054sm6604156plg.78.2023.05.11.18.38.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 May 2023 18:38:49 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
	id C59A75FEAC; Thu, 11 May 2023 18:38:48 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
	by famine.localdomain (Postfix) with ESMTP id BE9749FAA4;
	Thu, 11 May 2023 18:38:48 -0700 (PDT)
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: "Andrew J. Schorr" <aschorr@telemetry-investments.com>
cc: Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is bond 802.3ad
In-reply-to: <20230510171436.GA27945@ti139.telemetry-investments.com>
References: <ZEt3hvyREPVdbesO@Laptop-X1> <15524.1682698000@famine> <ZFjAPRQNYRgYWsD+@Laptop-X1> <84548.1683570736@vermin> <ZFtMyi9wssslDuD0@Laptop-X1> <20230510165738.GA23309@ti139.telemetry-investments.com> <20230510171436.GA27945@ti139.telemetry-investments.com>
Comments: In-reply-to "Andrew J. Schorr" <aschorr@telemetry-investments.com>
   message dated "Wed, 10 May 2023 13:14:36 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13564.1683855528.1@famine>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 May 2023 18:38:48 -0700
Message-ID: <13565.1683855528@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Andrew J. Schorr <aschorr@telemetry-investments.com> wrote:

>Sorry -- resending from a different email address to fix a problem
>with gmail rejecting it.
>
>On Wed, May 10, 2023 at 12:57:38PM -0400, Andrew J. Schorr wrote:
>> Hi Hangbin & Jay,
>> =

>> On Wed, May 10, 2023 at 03:50:34PM +0800, Hangbin Liu wrote:
>> > On Mon, May 08, 2023 at 11:32:16AM -0700, Jay Vosburgh wrote:
>> > > 	That case should work fine without the active-backup.  LACP has
>> > > a concept of an "individual" port, which (in this context) would be=
 the
>> > > "normal NIC," presuming that that means its link peer isn't running
>> > > LACP.
>> > > =

>> > > 	If all of the ports (N that are LACP to a single switch, plus 1
>> > > that's the non-LACP "normal NIC") were attached to a single bond, i=
t
>> > > would create one aggregator with the LACP enabled ports, and then a
>> > > separate aggregator for the indvidual port that's not.  The aggrega=
tor
>> > > selection logic prefers the LACP enabled aggregator over the indivi=
dual
>> > > port aggregator.  The precise criteria is in the commentary within
>> > > ad_agg_selection_test().
>> > > =

>> > =

>> > cc Andrew, He add active-backup bond over LACP bond because he want t=
o
>> > use arp_ip_target to ensure that the target network is reachable...
>> =

>> That's correct. I prefer the ARP monitoring to ensure that the needed
>> connectivity is actually there instead of relying on MII monitoring.
>> =

>> I also confess that I was unaware of the possibility of using an indivi=
dual
>> port inside an 802.3ad bond without having to stick that individual por=
t into a
>> port-channel group with LACP enabled. I want to avoid enabling LACP on =
that
>> link because I'd like to be able to PXE boot over it, not to mention th=
e switch
>> configuration hassle.  Is that individual port configuration without LA=
CP
>> detected automatically by the kernel, or do I need to configure somethi=
ng to do
>> that? I see the logic in drivers/net/bonding/bond_3ad.c to set is_indiv=
idual,
>> but it appears to depend on whether duplex is enabled. At that point, I=
 got
>> lost, since I see duplex mentioned only in ad_user_port_key, and that s=
eems to
>> be a property of the bond master, not the slaves. Is there any document=
ation of
>> how this configuration works?

	The individual port behavior is part of the LACP standard (IEEE
802.1AX, recent editions call this "Solitary"), and is done
automatically by the kernel.  One of the reasons for it is to permit
exactly the situation you mention: to enable PXE or "fallback"
communication to work even if LACP negotiation fails or is not
configured or implemented at one end.  This is called out explicitly in
802.1AX, 6.1.1.j.

	The duplex test is only part of the "individual" logic; it comes
up because LACP negotiation requires the peers to be point-to-point
links, i.e., full duplex (IEEE 802.1AX-2014, 6.4.8).  That's the norm
for most everything now, but historically a port in half duplex could be
on a multiple access topology, e.g., 802.3 CSMA/CD 10BASE2 on a coax
cable, which is incompatible with LACP aggregation.  This situation
doesn't come up a lot these days.

	The important part of the "individual" logic is whether or not
the port successfully completes LACP negotiation with a link partner.
If not, the port is an individual port, which acts essentially like an
aggregator with just one port in it.  This is separate from
"is_individual" in the bonding code, and happens in
ad_port_selection_logic(), after the comment "check if current
aggregator suits us".  "is_individual" is one element of this test, the
remaining tests compare the various keys and whether the partner MAC
address has been populated.

	As far as documentation goes, the bonding docs[0] describe some
of the parameters, but doesn't describe the specifics of bonding's
ability to manage multiple aggregators; I should write that up, since
this comes up periodically.  The IEEE standard (to which the bonding
implementation conforms) describes how the whole system works, but
doesn't really have a simple overview.

[0] https://www.kernel.org/doc/Documentation/networking/bonding.rst

>> But in any case, I still prefer active-backup on top of 802.3ad so that=
 I can
>> have the ARP monitoring.
>> =

>> If it's too much trouble to get the top-level bond to report duplex/spe=
ed
>> correctly when the underlying bond speed changes, then I think it would
>> be an improvement to set duplex/speed to N/A (or -1) for a bond of
>> bonds configuration instead of potentially having incorrect information=
.
>> I imagine such a fix might be much easier than updating dynamically
>> when the lower-level 802.3ad bond changes speed.

	I'll have to give this some thought.  The best long term
solution would be to decouple the link monitoring stuff from the mode,
and thus allow ARP and MII in a wider variety of modes.  I've prototyped
that out in the past, along with changing the MII monitor to respond to
carrier state changes in real time instead of polling, and it's fairly
complicated.

	In any event, this does sound like a valid use case for nesting
the bonds, so simply disabling that facility seems to be off the table.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

