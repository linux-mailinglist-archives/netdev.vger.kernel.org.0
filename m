Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B14AC726
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348665AbiBGRSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353386AbiBGRDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:03:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44196C0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B2F60AE7
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 17:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA521C004E1;
        Mon,  7 Feb 2022 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644253425;
        bh=MFlCIk0nex7qoch6fv2307q8js6pkDaBmho9HMJmxuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oDpquQRGaXfDNMK6zzOqcnkEl2yJP4aND7aL12ziUdv7O821ceNSybYa1y56iXz4F
         7mNi3bD7Jyo2ExNgtGgQOMbqASaeKnYA3B0fYXhph5wjg16bW3nt7sENtmMpXIU7Zw
         d0G4S5YzG7L8IdvDE0PPF6KyGetyQIILxthB8EqvX7+B/9rPgSKuiz3X5O6HSpnawT
         alUGVOhKjOe+b4WbPv3NhNSnAdzqhxP9shmy6bMZiWebAZVqtNxNSZm+6Vi5+ac1bd
         QDaG+cOq0kg4LJVQAQLkudtYfQ1fixIsKmXsbwIRW3YJoUL5yrdT5rYDcxCX5ZGX8c
         Aiu0iAT1C9avw==
Date:   Mon, 7 Feb 2022 09:03:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mahesh Bandewar (=?UTF-8?B?4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+CktQ==?=
        =?UTF-8?B?4KS+4KSw?=) " <maheshb@google.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH v3 net-next] bonding: pair enable_port with
 slave_arr_updates
Message-ID: <20220207090343.3af1ff59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF2d9jjLdLjrOAwPR8JZNPTNyy44vxYei0X7NW_pKkzkCt5WSA@mail.gmail.com>
References: <20220204000653.364358-1-maheshb@google.com>
        <20792.1643935830@famine>
        <20220204195949.10e0ed50@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jjLdLjrOAwPR8JZNPTNyy44vxYei0X7NW_pKkzkCt5WSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Feb 2022 21:52:11 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0) wrote:
> On Fri, Feb 4, 2022 at 7:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Quacks like a fix, no? It's tagged for net-next and no fixes tag,
> > is there a reason why? =20
>=20
> Though this fixes some corner cases, I couldn't find anything obvious
> that I can report as "fixes" hence decided otherwise. Does that make
> sense?

So it's was not introduced in the refactorings which added
update_slave_arr? If the problem existed forever we can put:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

it's just an indication how far back the backporting should go.
For anything older than oldest LTS (4.9) the exact tag probably
doesn't matter all that much.
