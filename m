Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8F657CDFC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiGUOoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGUOoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:44:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964568688C;
        Thu, 21 Jul 2022 07:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=VgD+JbbwS6XVssBVKi+pnkYIiuY6lXE5LgvAjAlwrmI=;
        t=1658414650; x=1659624250; b=oj+p4G8KjuwpvCtUA3E/5QscBKWsAkSlUGNEJTU43DtwITT
        TPE27yt8ltpIZjVArQvrU2SBrxA6Ju3TzSb7t8Lh+i4MW/Ijp9HB/EMDcuIZQItjUnMyqpXt95j75
        oaKLVcqYg1njL/DNQxxsE4XXOdupWbXhMHrhOvl2yiDb/GavN2A2KDKs7kbsItr+BtHT8n6GN1fBN
        Z4eiSCTzzZQ14iW8rKgCQxIJ6iAqniERXpuAWmy4YL9tCLPH71oaw1Mpr8JDLSdfyFZvL5/qg7skz
        vCtGuTTzXq1gV1yf5SKDaYXyBGWqNlt1AmcDEzod9yEiNdvA5CD7CztWUL5V6XHA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oEXP1-004N5l-37;
        Thu, 21 Jul 2022 16:43:48 +0200
Message-ID: <76e53d3ef853fc963e7243194d7538d34a224a3a.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Fix wrong channel bandwidths reported for
 aggregates
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus =?ISO-8859-1?Q?L=FCssing?= <ll@simonwunderlich.de>
Date:   Thu, 21 Jul 2022 16:43:46 +0200
In-Reply-To: <20220718222804.21708-1-linus.luessing@c0d3.blue>
References: <20220718222804.21708-1-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-19 at 00:28 +0200, Linus L=C3=BCssing wrote:
>=20
> Therefore fixing this within mac80211: For an aggergated AMPDU only
> update the RX "last_rate" variable from the last sub-frame of an
> aggregate. In theory, without hardware bugs, rate/bandwidth info
> should be the same for all sub-frames of an aggregate anyway.
>=20

What if other drivers do it only on the first? :)

I'd be more inclined to squeeze in a "RATE_INVALID" flag or so somewhere
there in the rx status, and make it depend on that.

johannes
