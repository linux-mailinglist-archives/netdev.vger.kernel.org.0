Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DC059C216
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiHVPCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbiHVPCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:02:36 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DE239B8B;
        Mon, 22 Aug 2022 08:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=lhCp3gazHoqKuo+KxPlFiFXB4bVV+NWLkmVgJm8ISfs=;
        t=1661180553; x=1662390153; b=VoeHtuEV3nEO6VPHeCJSmc4SevyieyAix0LfuyKG0pL8o8f
        +rxqDlylJyJq/lHFWzhYC7HqumR18QtNRHJC/2O2BGcSNx2Z3OTHSh8LLJcNATtypcn3caITbCLxS
        E2rC1z5d2JExA5YQKf6oWbiu3GtB1PkM6dJpHprIl8A/qyuzGDis1430s8f0Ag9ScqGoQOCrFWjMT
        skLzabRRX/dcEczxyZYl0I4C55KV5EAvP1IPhQpwNIXoubUrNWPl8yrSgEzYCIPNR40py5PE9pWTx
        YMlcs4EjwuiHakOLkepssY/7FWBLbfqn0pGJl7rYWwki+J9cyKTPO1BBakeGL7EA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oQ8wZ-00EZ1L-30;
        Mon, 22 Aug 2022 17:02:24 +0200
Message-ID: <b081ef6eb978070740f31f48a1f4be1807f51168.camel@sipsolutions.net>
Subject: Re: help for driver porting - missing member preset_chandef in
 struct wireless_dev
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Frank Wunderlich <frank-w@public-files.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 22 Aug 2022 17:02:21 +0200
In-Reply-To: <trinity-de687d18-b2a2-4cde-9383-a4d6ddba6a77-1661177057496@3c-app-gmx-bap06>
References: <trinity-de687d18-b2a2-4cde-9383-a4d6ddba6a77-1661177057496@3c-app-gmx-bap06>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-08-22 at 16:04 +0200, Frank Wunderlich wrote:
> hi,
>=20
> i'm working on porting an old/huge wireless driver (mt6625l) [2] to linux=
 6.0 [1]
>=20
> i hang on missing member preset_chandef in struct wireless_dev
>=20
> 	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> 	struct cfg80211_chan_def *chandef =3D &wdev->preset_chandef;
>=20
> it looks like this member is moved from the wdev into some mesh structure=
...my driver does not support mesh. any chance to fix this?
>=20

Yes. Make sure the driver doesn't access it, it should get stuff through
other APIs.

johannes
