Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AAD52A0B4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345440AbiEQLtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiEQLtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:49:22 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF4E377E0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1652788156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yjDZzYRlOEXaTeXKeiZ3BoDk5vWbzSf4BpCkz7w3naQ=;
        b=jZbXTZ3/5SfUMbKEfhbQrWkTEcL8yFUx+ikl6g30Nlu2m76LUTuOUBnBpqHhSbtDX1D8Vv
        vfDNbfsov68KP3/VLLSrOoMwgnaJrVRC6b/qSLdN1/Y89pk6cLuAgkNXUIH2Isg1WeIDQD
        5ns148IgTVYW9qR130PUOy7zoApyzx8=
From:   Sven Eckelmann <sven@narfation.org>
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, johannes@sipsolutions.net,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct net_device
Date:   Tue, 17 May 2022 13:49:13 +0200
Message-ID: <2780967.JztxfRx3z1@ripper>
In-Reply-To: <20220516215638.1787257-1-kuba@kernel.org>
References: <20220516215638.1787257-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart53318918.RGKOpMJsdz"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart53318918.RGKOpMJsdz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>, johannes@sipsolutions.net, alex.aring@gmail.com, stefan@datenfreihafen.org, mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc, linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct net_device
Date: Tue, 17 May 2022 13:49:13 +0200
Message-ID: <2780967.JztxfRx3z1@ripper>
In-Reply-To: <20220516215638.1787257-1-kuba@kernel.org>
References: <20220516215638.1787257-1-kuba@kernel.org>

On Monday, 16 May 2022 23:56:38 CEST Jakub Kicinski wrote:
> diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
> index 83fb51b6e299..15d2bb4cd301 100644
> --- a/net/batman-adv/hard-interface.c
> +++ b/net/batman-adv/hard-interface.c
> @@ -307,9 +307,11 @@ static bool batadv_is_cfg80211_netdev(struct net_device *net_device)
>         if (!net_device)
>                 return false;
>  
> +#if IS_ENABLED(CONFIG_WIRELESS)
>         /* cfg80211 drivers have to set ieee80211_ptr */
>         if (net_device->ieee80211_ptr)
>                 return true;
> +#endif
>  
>         return false;
>  }

Acked-by: Sven Eckelmann <sven@narfation.org>


On Tuesday, 17 May 2022 09:48:24 CEST Johannes Berg wrote:
> Something like the patch below might do that, but I haven't carefully
> checked it yet, nor checked if there are any paths in mac80211/drivers
> that might be doing this check - and it looks from Jakub's patch that
> batman code would like to check this too.

Yes, if something like netdev_is_wireless would be available then we could 
change it to:

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 35fadb924849..50a53e3364bf 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -294,26 +294,6 @@ static bool batadv_is_wext_netdev(struct net_device *net_device)
 	return false;
 }
 
-/**
- * batadv_is_cfg80211_netdev() - check if the given net_device struct is a
- *  cfg80211 wifi interface
- * @net_device: the device to check
- *
- * Return: true if the net device is a cfg80211 wireless device, false
- *  otherwise.
- */
-static bool batadv_is_cfg80211_netdev(struct net_device *net_device)
-{
-	if (!net_device)
-		return false;
-
-	/* cfg80211 drivers have to set ieee80211_ptr */
-	if (net_device->ieee80211_ptr)
-		return true;
-
-	return false;
-}
-
 /**
  * batadv_wifi_flags_evaluate() - calculate wifi flags for net_device
  * @net_device: the device to check
@@ -328,7 +308,7 @@ static u32 batadv_wifi_flags_evaluate(struct net_device *net_device)
 	if (batadv_is_wext_netdev(net_device))
 		wifi_flags |= BATADV_HARDIF_WIFI_WEXT_DIRECT;
 
-	if (batadv_is_cfg80211_netdev(net_device))
+	if (netdev_is_wireless(net_device))
 		wifi_flags |= BATADV_HARDIF_WIFI_CFG80211_DIRECT;
 
 	real_netdev = batadv_get_real_netdevice(net_device);
@@ -341,7 +321,7 @@ static u32 batadv_wifi_flags_evaluate(struct net_device *net_device)
 	if (batadv_is_wext_netdev(real_netdev))
 		wifi_flags |= BATADV_HARDIF_WIFI_WEXT_INDIRECT;
 
-	if (batadv_is_cfg80211_netdev(real_netdev))
+	if (netdev_is_wireless(real_netdev))
 		wifi_flags |= BATADV_HARDIF_WIFI_CFG80211_INDIRECT;
 
 out:

--nextPart53318918.RGKOpMJsdz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmKDi7kACgkQXYcKB8Em
e0bh6g//ZaUMB74zvBCKHql+pln4FQ/wyUsj7/HF3gSU9MNG1qlDgzZn0kfAXplR
ZlfIXj566nw7fezMDYzMoeJ+U4qrmAoa5gg1W2+4QlLXi08Z/7JjqoQjMgGpFWpS
EqCT3L/qFpMkbV+iqSD9fsRC+4VWWA6quinU3tohEApW5Ibx5CDK1sDwjl+uVwJP
eMegY4IixvtnH6xiZwZdhHIoXnAbJxnCMFpxWPzCk9DBkHtEgnS5G2iN2qVgJvlQ
++ePF9edttDqwFeGdjuQTvyiLyVEPwlJ1VC3DvoHJmBEwLcCxYcu1Vxm3nqiDECi
Ok6bbHn+s7P7q+tSAsnaL9NqfZmZA57RV/MHlrPgCyXEgA7zeF4PjLsaJBMVmfha
Cv/PVf6/GmFYwk9pSQ1iM5rwgfDToh+d/UXARY+iI+iRmkNwt9+GQQIXAErYDu1d
ryGHKhyWHzA/FEMmirpM/ZNoF/5/FPvUyBLDeu0s9am12IvWsYnFG/fmY/DO4Rbp
/kKkX6WMpeUXz/go3THp4KReClydP322fYHfsJYtmG1Yo+cjQ3CFPhKvXqeA8jno
aqkqN7k4nAvgRY112IExUrLeT/433y4c2vnAeFv3ShxSgbG/nFyN0puPRasqcVWk
uoJGwGAZ5bkVzGTkRI/iY2qTj2PXxPnzMDJev6KWww7Bq+ir0U8=
=HphN
-----END PGP SIGNATURE-----

--nextPart53318918.RGKOpMJsdz--



