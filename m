Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570846EF035
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbjDZIZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbjDZIZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:25:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13973C0F;
        Wed, 26 Apr 2023 01:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=fr6SUQxoC/8u9dg+rT54woScWFBPHqDXPsE53mCRKdU=;
        t=1682497502; x=1683707102; b=jtbminiPTEN89EeeSsDfwDaIQ2racyiMr3D8P0XzJF3x4GB
        o+T76/LTeFHO6ufof3fZaeODZzLo1HO7ETtArem1srObDTMxc842hKvQUhbXI5laP2HtddJ1IBTlb
        F8P0QUFEO9IzQyWE+QBSZFVH7AaR/ZZeCctYH6AJm6RuFCY2hDzaGllyio6FCIesnjNAtf3rL9lEr
        3CfZy6OuoabzrwLe/N+m/i+uwBMa7Ux2a4PBvcp58pBcIFLbXSCV8ZMvnCCGsWxrZvxXLU+qm+O1/
        o07MESlP+JSOAD9UWMhEU7KW0QheRDCWDTg1YHXJE9x3oUFz2iuFMwOiopbpJ7QQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1praSM-0092u4-1v;
        Wed, 26 Apr 2023 10:24:54 +0200
Message-ID: <7214a6a800e4af80b9319c30b13cc52286bba50a.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2023-04-21
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Wed, 26 Apr 2023 10:24:53 +0200
In-Reply-To: <1a38a4289ef34672a2bc9a880e8608a8@realtek.com>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
         <20230421075404.63c04bca@kernel.org>
         <e31dae6daa6640859d12bf4c4fc41599@realtek.com> <87leigr06u.fsf@kernel.org>
                 <20230425071848.6156c0a0@kernel.org>
         <77cf7fa9de20be55d50f03ccbdd52e3c8682b2b3.camel@sipsolutions.net>
         <c69f151c77f34ae594dc2106bc68f2ac@realtek.com>
         <1a38a4289ef34672a2bc9a880e8608a8@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-26 at 03:30 +0000, Ping-Ke Shih wrote:
> > >=20

> >=20
> > I think the extra work Kalle meant is what I mentioned previously --
> > need functions to convert old tables v1, v2, ... to current. Like,
> >=20
>=20
> struct table_v1 { // from file
>    __le32 channel_tx_power[10];
> };
>=20
> struct table_v2 { // from file
>    __le32 channel_tx_power[20];
> };
>=20
> struct table {    // from file, the latest version of current use
>    __le32 channel_tx_power[30];
> };
>=20
> struct table_cpu {  // current table in cpu order
>    u32 channel_tx_power[30];
> };
>=20
> To make example clearer, I change the name of fields, because the thing I
> want to mention is not register table that wouldn't need conversion.

Right, the file format would have to be __le32 (or __be32), but that's
pretty easy to handle while writing it to the device?

Not sure I understand the other thing about conversion.

> > If loading a table_v1 table, for example, we need to convert to table_c=
pu by
> > some rules. Also, maybe we need to disable some features relay on the v=
alues
> > introduced by table_cpu. I think it will work, but just add some flags =
and
> > rules to handle them.

But wouldn't this basically be tied to a driver? I mean you could have a
file called "rtlwifi/rtlxyz.v1.tables" that the driver in kernel 6.4
loads, and ...v2... that the driver in 6.5 loads, and requires for
operation?

Then again - it'd be better if the driver in 6.5 can deal with it if a
user didn't install the v2 file yet, is that what you meant?


> > Another question is about number of files for single device. Since firm=
ware and
> > tables (e.g. TX power, registers) are released by different people, and=
 they
> > maintain their own version, if I append tables to firmware, it's a litt=
le hard
> > to have a clear version code. So, I would like to know the rule if I ca=
n just
> > add additional one file for these tables?

Oh, I certainly wasn't trying to say that it should be done by combining
the file, just that it might be _easier_ to distribute this stuff then.
If not, then not!

johannes
