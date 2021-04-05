Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE6635416B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 13:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhDELJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 07:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbhDELJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 07:09:49 -0400
X-Greylist: delayed 12587 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Apr 2021 04:09:43 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E219C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 04:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1617620979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wwe/0hb6s2cUAQY7NxLrjPy5VpMNLQNY/4quBidv9P0=;
        b=hF5YepMRInKtpYCCpVvI7LQRgWSldcs4E0bCRG+Rk59IsiWQjZEYSBKOrXbPoMPSwJKUQW
        4TKq+pCewxxI04mgAjNFd7JJD9Ru2P5JT+NDzT8e4az63Xs3VqPMi1l+TBgqY7tNCD20Fv
        Z2l8q4s5BTYwV7UZvNJLqjxoBFNRjbw=
From:   Sven Eckelmann <sven@narfation.org>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH v2] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date:   Mon, 05 Apr 2021 13:09:36 +0200
Message-ID: <5561744.yYbohhxq0P@sven-l14>
In-Reply-To: <20210405101650.6779-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <8010915.lm9TqgPHxW@sven-l14> <20210405101650.6779-1-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2406507.j6KcVWh5vx"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2406507.j6KcVWh5vx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: netdev@vger.kernel.org, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH v2] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date: Mon, 05 Apr 2021 13:09:36 +0200
Message-ID: <5561744.yYbohhxq0P@sven-l14>
In-Reply-To: <20210405101650.6779-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <8010915.lm9TqgPHxW@sven-l14> <20210405101650.6779-1-penguin-kernel@I-love.SAKURA.ne.jp>

On Monday, 5 April 2021 12:16:50 CEST Tetsuo Handa wrote:
> KMSAN found uninitialized value at batadv_tt_prepare_tvlv_local_data()
> [1], for commit ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16
> in TT code") inserted 'reserved' field into "struct batadv_tvlv_tt_data"
> and commit 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN
> specific") moved that field to "struct batadv_tvlv_tt_vlan_data" but left
> that field uninitialized.
> 
> [1] https://syzkaller.appspot.com/bug?id=07f3e6dba96f0eb3cabab986adcd8a58b9bdbe9d
> 
> Reported-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
> Tested-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16 in TT code")
> Fixes: 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN specific")
> ---
>  net/batman-adv/translation-table.c | 2 ++
>  1 file changed, 2 insertions(+)

Thanks,

Acked-by: Sven Eckelmann <sven@narfation.org>

> diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
> index f8761281aab0..434b4f042909 100644
> --- a/net/batman-adv/translation-table.c
> +++ b/net/batman-adv/translation-table.c
> @@ -890,6 +890,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
>  	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
>  		tt_vlan->vid = htons(vlan->vid);
>  		tt_vlan->crc = htonl(vlan->tt.crc);
> +		tt_vlan->reserved = 0;
>  
>  		tt_vlan++;
>  	}
> @@ -973,6 +974,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
>  
>  		tt_vlan->vid = htons(vlan->vid);
>  		tt_vlan->crc = htonl(vlan->tt.crc);
> +		tt_vlan->reserved = 0;
>  
>  		tt_vlan++;
>  	}
> 


--nextPart2406507.j6KcVWh5vx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmBq7/AACgkQXYcKB8Em
e0aKDw/9FsWpGw0xrZsono49gy4SXiOCTCKMIHq2EaGUq630shBZgimUqoM8opty
WrmfLYqvOfYhaDTWUatzyG4wYt8BoCoDb4viUy9i55Vk0n/3ChXCby3OyB7L4ZRO
hnBSGIcodb9R0IJiR+Z+8fv5uA6yCNQzaPkLTzVqK4vAJTIplb3q03u8zqxUF98B
/nanfA59MjVTwwYK/wg3Kmxr1xvA/Hu5m9vYCvnqogz6kZ8h+u2hBm5eSLDuZofp
y/oiYiJpQeAx6ugvs/QKow+Mrt8sGhDUn2MQvmK6EeLfZi+8ETvLDPlj0+GQH78U
Hf9ZFt18Cuzx2oNy3DF4Aw8wDngcYyq9Vh7BxQEeEz5bvGG+9ovUvnC5KYgfpeTT
MhsXxMalQC4cC0R0EwEBAaHer05T0QvajeTLFkZmBwWI7WBxOb2oNpqmzyrFaytD
mztc4Pvx0dcRWTyTJoOP6MsKKnTDLAKUu2nbq+u8VCm4JP50WzDrWerbY5SW4SVs
Y6TOs0bcbe4+6xgc+kXQNTYBbi3C5Re1qmxPY/30QnwUwY1a7mDJkY9NFBl+2wAH
W5MJYrS1UJtmXxI1MDdhsy3J6vLnfZuOyYSLIjhLfN9AYzHHuIcdfGB8WJJkEakr
VgsNcTkqC1/npUb6moDhPu+WFuk/4TGPIAMiusY6PEDIH17b72E=
=I0Ll
-----END PGP SIGNATURE-----

--nextPart2406507.j6KcVWh5vx--



