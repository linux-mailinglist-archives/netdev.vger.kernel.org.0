Return-Path: <netdev+bounces-925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5056FB652
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB851C20A40
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8490A10975;
	Mon,  8 May 2023 18:32:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C724411
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:32:24 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094CD59F3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:32:21 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B78E33F118
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683570739;
	bh=RVA7E2idYZmfOuPsonNtASd8IEFH9f+eLBQs34z1u3Q=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=fxyHpWLByCSLVm04xJOg6yDUm4Lz2PeBDknKYuzj+OM6t2PoloFxGSFk8mwkzeXud
	 cbkUAsw+BZ0FzI1ax4xhJJv49pbr6K5UIqCXWSUwXkLFrHHn5hLLj2eGvtlxJnD9U4
	 gb3+Z4uonDlIFdZR8x0onNtrX+CIkZ7tAPufGfRgQSLFfULfHWzDyNEOg5038/Vnxz
	 OemwumR0Jq4Yr4la86FMKqnG+486yCiZbK3PMjjoLu7J1NlA5sLcyVNkoeEUIm/Syl
	 vtbPXcD61Yczm+KT7N2Mu5wt9qT3s/GQDB3t3r9td8C0Xmm+sPUnIvicZCYI9dWKOJ
	 4s7mbA51JestA==
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-24dfc3c668dso2531077a91.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 11:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683570738; x=1686162738;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVA7E2idYZmfOuPsonNtASd8IEFH9f+eLBQs34z1u3Q=;
        b=gnTm5QZYA2QUsKDZNuSDFXxqrJ6czz4gAW35T4jafSR+6mNzX23pS452w3Mz30G68O
         Uz7IJ1nWo7pn5Zov9mvcvVnSYar/EdaSF2m3TjIk3yAVekliPyW+/r4CbzdSPuhsdVZ8
         RKffhE6JUz2UZFVjewqZQ888+FuMBP+svOpbW0BYNJ7TFGKaP86ixELZoeXoDFp788Aa
         Wp923Q+1YKUthEnqUSXF2HlcL+2jfySFnv6kzBdcyrzC2s/delFDCtZzx6lDeJAy6Sgh
         Vg4VHv/yTCQ0VUz2GHEKPLodBhS3XjfDFqsef4d/pG7GFIiW1iJ4djkYPxewwycj9nYO
         8Tzg==
X-Gm-Message-State: AC+VfDxfQpBfXpI0RDm6Uy1pmr2JCvu9fzzBoUxCvoBOBgAMOuzY2ydk
	AldjDaqIv6/ZqjlRf7xaO76rhJ0pkn5uTN1XvFkr6VOH1al3WNk+IjfDAOlFWGvBOkRRhGCY8cX
	9Y0g/sAu9wikSLMcWb21M5cSlg58yjoLksrtyPLcH1g==
X-Received: by 2002:a17:90b:1d02:b0:24d:fb2c:1ae0 with SMTP id on2-20020a17090b1d0200b0024dfb2c1ae0mr11351055pjb.17.1683570737985;
        Mon, 08 May 2023 11:32:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4EemBUqdUZgIEsRu+9z42hw2VTBh+UwGwADhdmEqvRUDvjUnRaj83Xe4HmKeazQ8XCR4yzMw==
X-Received: by 2002:a17:90b:1d02:b0:24d:fb2c:1ae0 with SMTP id on2-20020a17090b1d0200b0024dfb2c1ae0mr11351043pjb.17.1683570737647;
        Mon, 08 May 2023 11:32:17 -0700 (PDT)
Received: from vermin.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090ad14f00b0024b6a90741esm10074537pjw.49.2023.05.08.11.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 11:32:17 -0700 (PDT)
Received: by vermin.localdomain (Postfix, from userid 1000)
	id B178B1C038A; Mon,  8 May 2023 20:32:16 +0200 (CEST)
Received: from vermin (localhost [127.0.0.1])
	by vermin.localdomain (Postfix) with ESMTP id AF5271C0094;
	Mon,  8 May 2023 11:32:16 -0700 (PDT)
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: Hangbin Liu <liuhangbin@gmail.com>
cc: netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is bond 802.3ad
In-reply-to: <ZFjAPRQNYRgYWsD+@Laptop-X1>
References: <ZEt3hvyREPVdbesO@Laptop-X1> <15524.1682698000@famine> <ZFjAPRQNYRgYWsD+@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Mon, 08 May 2023 17:26:21 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7+dev; Emacs 29.0.50
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <84547.1683570736.1@vermin>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 08 May 2023 11:32:16 -0700
Message-ID: <84548.1683570736@vermin>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Fri, Apr 28, 2023 at 09:06:40AM -0700, Jay Vosburgh wrote:
>> Hangbin Liu <liuhangbin@gmail.com> wrote:
>> =

>> >A user reported a bonding issue that if we put an active-back bond on =
top of a
>> >802.3ad bond interface. When the 802.3ad bond's speed/duplex changed
>> >dynamically. The upper bonding interface's speed/duplex can't be chang=
ed at
>> >the same time.
>> >
>> >This seems not easy to fix since we update the speed/duplex only
>> >when there is a failover(except 802.3ad mode) or slave netdev change.
>> >But the lower bonding interface doesn't trigger netdev change when the=
 speed
>> >changed as ethtool get bonding speed via bond_ethtool_get_link_ksettin=
gs(),
>> >which not affect bonding interface itself.
>> =

>> 	Well, this gets back into the intermittent discussion on whether
>> or not being able to nest bonds is useful or not, and thus whether it
>> should be allowed or not.  It's at best a niche use case (I don't recal=
l
>> the example configurations ever being anything other than 802.3ad under
>> active-backup), and was broken for a number of years without much
>> uproar.
>> =

>> 	In this particular case, nesting two LACP (802.3ad) bonds inside
>> an active-backup bond provides no functional benefit as far as I'm awar=
e
>> (maybe gratuitous ARP?), as 802.3ad mode will correctly handle switchin=
g
>> between multiple aggregators.  The "ad_select" option provides a few
>> choices on the criteria for choosing the active aggregator.
>> =

>> 	Is there a reason the user in your case doesn't use 802.3ad mode
>> directly?
>
>Hi Jay,
>
>I just back from holiday and re-read you reply. The user doesn't add 2 LA=
CP
>bonds inside an active-backup bond. He add 1 LACP bond and 1 normal NIC i=
n to
>an active-backup bond. This seems reasonable. e.g. The LACP bond in a swi=
tch
>and the normal NIC in another switch.
>
>What do you think?

	That case should work fine without the active-backup.  LACP has
a concept of an "individual" port, which (in this context) would be the
"normal NIC," presuming that that means its link peer isn't running
LACP.

	If all of the ports (N that are LACP to a single switch, plus 1
that's the non-LACP "normal NIC") were attached to a single bond, it
would create one aggregator with the LACP enabled ports, and then a
separate aggregator for the indvidual port that's not.  The aggregator
selection logic prefers the LACP enabled aggregator over the individual
port aggregator.  The precise criteria is in the commentary within
ad_agg_selection_test().

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

