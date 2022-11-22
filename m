Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB0863344D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiKVECe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiKVECS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:02:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DED72ED56
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:02:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68E6DB818E6
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B1FC433D6;
        Tue, 22 Nov 2022 04:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669089734;
        bh=ySc9yE7sRqafCmBz9njkpyoaKXUtntGscYAZ6y7t+uE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ISBXS417/SNRqvl7oN8djTyOrb9a8mX6vGdon2wevULz4OY1bQfC6lVJoI1d4e4Xx
         dpQw6rook1xEeMbwwP5vUlIgy8Vm9zl3ONiCdYWIB0salzLBkTWFSi9DIOgPxzcRys
         nv10dXHFp2FaQ5rdtZYNcNAjnVPJ1qIityVZ8Q7bIrptFJ+cDjtNHkWa1fQkt4QV5r
         iWSp8UGVqzLeBPZG5AbZU+wPJnbyYiwxhOwbUv/820TNsUHeZAKRp2XlETORF3xPcf
         ZrUVB9upKPdwTzshFgUBlCvLyoi6TSsLIwU7qAhYm/g+9CzenTE17DfWR2FYI4HS/h
         vRqZiNVh18gmQ==
Date:   Mon, 21 Nov 2022 20:02:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [EXT] Re: [PATCH net-next] sandlan: Add the sandlan virtual
 network interface
Message-ID: <20221121200212.77fb9a63@kernel.org>
In-Reply-To: <CALHoRjctagiFOWi8OWai5--m+sezaMHSOpKNLSQbrKEgRbs-KQ@mail.gmail.com>
References: <20221116222429.7466-1-steve.williams@getcruise.com>
        <20221117200046.0533b138@kernel.org>
        <CALHoRjctagiFOWi8OWai5--m+sezaMHSOpKNLSQbrKEgRbs-KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Nov 2022 18:59:11 -0800 Steve Williams wrote:
> > As a general rule we don't accept any test/emulation code upstream
> > unless it comes with some tests that actually use it.
> > We have had bad experience with people adding virtual interfaces and
> > features which then bit rot or become static checker fodder and we
> > don't know whether anyone is actually using them and how.
> >
> > Is there something here that you can't achieve with appropriately
> > combined veths? =20
>=20
> I use the sandlan virtual interfaces to test my hanic driver, which I als=
o just
> posted as a patch. The hanic driver implements redundant links and sets
> ethernet mac addresses, and also uses those mac addresses to infer streams
> for deduplication. The veth driver only creates pairs of nics, and it doe=
sn't
> seem to support setting  the mac address

Understood, perhaps extending netdevsim to teach it to do packet
forwarding is an option then? I hope you'll understand that we can't
accept an extra harness driver for every protocol implementation we
accept. That is the short and the long of it.

> *Confidentiality=C2=A0Note:*=C2=A0We care about protecting our proprietar=
y=20
> information,=C2=A0confidential=C2=A0material, and trade secrets.=C2=A0Thi=
s message may=20
> contain some or all of those things. Cruise will suffer material harm if=
=20
> anyone other than the intended recipient disseminates or takes any action=
=20
> based on this message. If you have received this message (including any=20
> attachments) in error, please delete it immediately and notify the sender=
=20
> promptly.

You absolutely _must_ get rid of this privacy notice when posting
upstream.
