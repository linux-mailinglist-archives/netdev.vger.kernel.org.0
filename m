Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9E6963F7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjBNMzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjBNMzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:55:06 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BF516AEE;
        Tue, 14 Feb 2023 04:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=kd8Tkpw2geIhdESAwykD0ZVGRSJYIx/HqjzlFVd0yxI=;
        t=1676379305; x=1677588905; b=AvZLEPFS1HaXLki/BsL9rF9Bz0YqwL+nEpxGjXtF10kXiAb
        P6l/D203CuK1wazu06supRkAEtGAJGIAIHjVLEhZcBf57gA2lf3Vpd5uGO8d6UFp6hrftdX1VRmxm
        bih2FB+6D2NWKe4JW1r+Y2i061jukE5IXEzbzYdPCRhqujQacLqJ81YGB/LXi28pdrz1JBbHSIqxA
        0GmDfQ3+Y2pzMjSeNchBdlGzIbOCOpq+YwTXtEq6O7RLEyhLa+6wa1rGGwEZooJAqgU/AMcHbl0+1
        ASBCzDOpQhND7NWt1XOXIX7sJqpSNzk6ZsJpCOJjGWYDo54L4har86AhyXlJaFeA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pRupY-00C91H-3B;
        Tue, 14 Feb 2023 13:54:45 +0100
Message-ID: <aef83367258771b3e71c6043f4cc0661473fd58b.camel@sipsolutions.net>
Subject: Re: [PATCH v3] Set ssid when authenticating
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marc Bornand <dev.mbornand@systemb.ch>,
        linux-wireless@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Date:   Tue, 14 Feb 2023 13:54:43 +0100
In-Reply-To: <20230213210521.1672392-1-dev.mbornand@systemb.ch>
References: <20230213210521.1672392-1-dev.mbornand@systemb.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

Hi,

Please provide a proper subject/commit message for this. The
"authenticating" is no longer true anyway.

See
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#commit_messages

On Mon, 2023-02-13 at 21:05 +0000, Marc Bornand wrote:
> changes since v2:
> - The code was tottaly rewritten based on the disscution of the
>   v2 patch.
> - the ssid is set in __cfg80211_connect_result() and only if the ssid is
>   not already set.
> - Do not add an other ssid reset path since it is already done in
>   __cfg80211_disconnected()
>=20
> When a connexion was established without going through

connection

> NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
> Now we set it in __cfg80211_connect_result() when it is not already set.
>=20
> Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
> Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
> Cc: linux-wireless@vger.kernel.org
> Cc: stable@vger.kernel.org
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216711
> Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
> ---
>  net/wireless/sme.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 4b5b6ee0fe01..629d7b5f65c1 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
>=20
> @@ -723,6 +723,7 @@ void __cfg80211_connect_result(struct net_device *dev=
,
>  			       bool wextev)
>  {
>  	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> +	const struct element *ssid;
>  	const struct element *country_elem =3D NULL;
>  	const u8 *country_data;
>  	u8 country_datalen;
> @@ -883,6 +884,21 @@ void __cfg80211_connect_result(struct net_device *de=
v,
>  				   country_data, country_datalen);
>  	kfree(country_data);
>=20
> +	if (wdev->u.client.ssid_len =3D=3D 0) {
> +		rcu_read_lock();
> +		for_each_valid_link(cr, link) {
> +			ssid =3D ieee80211_bss_get_elem(cr->links[link].bss,
> +						      WLAN_EID_SSID);
> +
> +			if (ssid->datalen =3D=3D 0)

need to check also that it exists

> +				continue;
> +
> +			memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
> +			wdev->u.client.ssid_len =3D ssid->datalen;

you can break here.

johannes
