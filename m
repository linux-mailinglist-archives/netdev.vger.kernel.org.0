Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C605F4FA037
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbiDHXqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiDHXqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:46:12 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FCA3284D2;
        Fri,  8 Apr 2022 16:44:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id w21so15052935wra.2;
        Fri, 08 Apr 2022 16:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YNQXgXF4a+AhQ5fk56t1rPp4GV4Eh6u4vBLfJhuC6Ys=;
        b=iTRU9sdAsgx9eWRliBtBRr63Z5e8AyHmLzBsYaphNbucwkdJkhfTsbMRa10o5/uTRx
         527BqGDl0qWnAxrsDFvYx9R+NwBNbAdCm6Gh2zqgsAg9DKyhgtLk5EA8cnCNx89SEAC9
         +PGfvdr2LXPyRCmnrsYQkfVfiO+Zt8C/pcz7M+B4dvoMkE69NOk7v9fefgXFiz6f+r6k
         45imaU5PyMhOMdTKceEw92MUgh4fc5iXRSjJrRqM8WhTlk9wDqOfM7GpsNH4UlHVDfbz
         0uKzuviz+FElrM1Y4jAH91tRyrn0D8h6amZ0zNswRi9dzea0dvbtzZDjJKp5JILL7AbV
         2RBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YNQXgXF4a+AhQ5fk56t1rPp4GV4Eh6u4vBLfJhuC6Ys=;
        b=hvQAB9aHRP3AcVzIIN0NgyoKpF0cjawlLzRl2PbIKJOhWvhppoXNSAGrRC8Je2Q7MB
         Kki8rXC5gP0zMqySA1cAioRZ1+wQ3u/EYWQheRJSGEZk8G4hlxi5DJyZUehCKb5j+a/L
         D9Egft7aBAteA8fe1ppk0kYfvDGrCl8dVknYbYzyzS9+Q3gCQB/UkwzWZJ5yeJBKDQSc
         RUAgWXPyszpDn23WOtp/p+WxUE1bNYk4mSo/G3mPMLdaCvmaACSY9EFufcQFQpdMFMQ1
         OZovJjJIFmlfazMgRTlJ1HipgOHsGO8LBemaBVNG0pKE/iofS4Va8QwUOgWI1FHHDA84
         TiqA==
X-Gm-Message-State: AOAM530ia4gk/nlRW90q3fG3LpwSYFmpYPyx/ubdUVPdwkDEKOU0tMDO
        Uu3U3oSgUxWzY4jT3z2P1tSHxNSzCFpNVQ==
X-Google-Smtp-Source: ABdhPJzzLLnXf2ONfrh6vC07vhyIaQnj82N/7MyyvAuh0zOKcQSQs1IEMtYxncGiJqhX7MnvnzAqiw==
X-Received: by 2002:a05:6000:18a3:b0:204:1f84:287e with SMTP id b3-20020a05600018a300b002041f84287emr16771491wri.184.1649461444869;
        Fri, 08 Apr 2022 16:44:04 -0700 (PDT)
Received: from smtpclient.apple ([185.238.38.242])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c359300b0038c7d1086a7sm12496919wmq.1.2022.04.08.16.44.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 16:44:04 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 03/15] net: dsa: mv88e6xxx: Replace usage of
 found with dedicated iterator
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220408123101.p33jpynhqo67hebe@skbuf>
Date:   Sat, 9 Apr 2022 01:44:00 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2AFC0FB-08EC-4421-AF44-8C485BF48879@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-4-jakobkoschel@gmail.com>
 <20220408123101.p33jpynhqo67hebe@skbuf>
To:     Vladimir Oltean <olteanv@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> On 8. Apr 2022, at 14:31, Vladimir Oltean <olteanv@gmail.com> wrote:
>=20
> Hi Jakob,
>=20
> On Thu, Apr 07, 2022 at 12:28:48PM +0200, Jakob Koschel wrote:
>> To move the list iterator variable into the list_for_each_entry_*()
>> macro in the future it should be avoided to use the list iterator
>> variable after the loop body.
>>=20
>> To *never* use the list iterator variable after the loop it was
>> concluded to use a separate iterator variable instead of a
>> found boolean [1].
>>=20
>> This removes the need to use a found variable and simply checking if
>> the variable was set, can determine if the break/goto was hit.
>>=20
>> Link: =
https://lore.kernel.org/all/CAHk-=3DwgRr_D8CB-D9Kg-c=3DEHreAsk5SqXPwr9Y7k9=
sA6cWXJ6w@mail.gmail.com/ [1]
>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>> ---
>> drivers/net/dsa/mv88e6xxx/chip.c | 21 ++++++++++-----------
>> 1 file changed, 10 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c =
b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 64f4fdd02902..f254f537c357 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1381,28 +1381,27 @@ static int mv88e6xxx_set_mac_eee(struct =
dsa_switch *ds, int port,
>> /* Mask of the local ports allowed to receive frames from a given =
fabric port */
>> static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, =
int port)
>> {
>> +	struct dsa_port *dp =3D NULL, *iter, *other_dp;
>> 	struct dsa_switch *ds =3D chip->ds;
>> 	struct dsa_switch_tree *dst =3D ds->dst;
>> -	struct dsa_port *dp, *other_dp;
>> -	bool found =3D false;
>> 	u16 pvlan;
>>=20
>> 	/* dev is a physical switch */
>> 	if (dev <=3D dst->last_switch) {
>> -		list_for_each_entry(dp, &dst->ports, list) {
>> -			if (dp->ds->index =3D=3D dev && dp->index =3D=3D =
port) {
>> -				/* dp might be a DSA link or a user =
port, so it
>> +		list_for_each_entry(iter, &dst->ports, list) {
>> +			if (iter->ds->index =3D=3D dev && iter->index =3D=3D=
 port) {
>> +				/* iter might be a DSA link or a user =
port, so it
>> 				 * might or might not have a bridge.
>> -				 * Use the "found" variable for both =
cases.
>> +				 * Set the "dp" variable for both cases.
>> 				 */
>> -				found =3D true;
>> +				dp =3D iter;
>> 				break;
>> 			}
>> 		}
>> 	/* dev is a virtual bridge */
>> 	} else {
>> -		list_for_each_entry(dp, &dst->ports, list) {
>> -			unsigned int bridge_num =3D =
dsa_port_bridge_num_get(dp);
>> +		list_for_each_entry(iter, &dst->ports, list) {
>> +			unsigned int bridge_num =3D =
dsa_port_bridge_num_get(iter);
>>=20
>> 			if (!bridge_num)
>> 				continue;
>> @@ -1410,13 +1409,13 @@ static u16 mv88e6xxx_port_vlan(struct =
mv88e6xxx_chip *chip, int dev, int port)
>> 			if (bridge_num + dst->last_switch !=3D dev)
>> 				continue;
>>=20
>> -			found =3D true;
>> +			dp =3D iter;
>> 			break;
>> 		}
>> 	}
>>=20
>> 	/* Prevent frames from unknown switch or virtual bridge */
>> -	if (!found)
>> +	if (!dp)
>> 		return 0;
>>=20
>> 	/* Frames from DSA links and CPU ports can egress any local port =
*/
>> --=20
>> 2.25.1
>>=20
>=20
> Let's try to not make convoluted code worse. Do the following 2 =
patches
> achieve what you are looking for? Originally I had a single patch =
(what
> is now 2/2) but I figured it would be cleaner to break out the =
unrelated
> change into what is now 1/2.

I do agree with not making convoluted code worse, but I was reluctant =
with
e.g. introducing new functions for this because others essentially
have the opposite opinion on this.

I however like solving it that way, it makes it a lot cleaner.

>=20
> If you want I can submit these changes separately.

Sure if you want to submit them separately, go ahead. Otherwise I can
integrate it into a v2, whatever you prefer essentially.

>=20
> -----------------------------[ cut here ]-----------------------------
> =46rom 2d84ecd87566b1535a04526b4ebb2764e764625f Mon Sep 17 00:00:00 =
2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Fri, 8 Apr 2022 15:15:30 +0300
> Subject: [PATCH 1/2] net: dsa: mv88e6xxx: remove redundant check in
> mv88e6xxx_port_vlan()
>=20
> We know that "dev > dst->last_switch" in the "else" block.
> In other words, that "dev - dst->last_switch" is > 0.
>=20
> dsa_port_bridge_num_get(dp) can be 0, but the check
> "if (bridge_num + dst->last_switch !=3D dev) continue", rewritten as
> "if (bridge_num !=3D dev - dst->last_switch) continue", aka
> "if (bridge_num !=3D something which cannot be 0) continue",
> makes it redundant to have the extra "if (!bridge_num) continue" =
logic,
> since a bridge_num of zero would have been skipped anyway.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> drivers/net/dsa/mv88e6xxx/chip.c | 3 ---
> 1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c =
b/drivers/net/dsa/mv88e6xxx/chip.c
> index 64f4fdd02902..b3aa0e5bc842 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1404,9 +1404,6 @@ static u16 mv88e6xxx_port_vlan(struct =
mv88e6xxx_chip *chip, int dev, int port)
> 		list_for_each_entry(dp, &dst->ports, list) {
> 			unsigned int bridge_num =3D =
dsa_port_bridge_num_get(dp);
>=20
> -			if (!bridge_num)
> -				continue;
> -
> 			if (bridge_num + dst->last_switch !=3D dev)
> 				continue;
>=20
> -----------------------------[ cut here ]-----------------------------
>=20
> -----------------------------[ cut here ]-----------------------------
> =46rom dabafdbe38b408f7c563ad91fc6e57791055fed7 Mon Sep 17 00:00:00 =
2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Fri, 8 Apr 2022 14:57:45 +0300
> Subject: [PATCH 2/2] net: dsa: mv88e6xxx: refactor =
mv88e6xxx_port_vlan()
>=20
> To avoid bugs and speculative execution exploits due to type-confused
> pointers at the end of a list_for_each_entry() loop, one measure is to
> restrict code to not use the iterator variable outside the loop block.
>=20
> In the case of mv88e6xxx_port_vlan(), this isn't a problem, as we =
never
> let the loops exit through "natural causes" anyway, by using a "found"
> variable and then using the last "dp" iterator prior to the break, =
which
> is a safe thing to do.
>=20
> Nonetheless, with the expected new syntax, this pattern will no longer
> be possible.
>=20
> Profit off of the occasion and break the two port finding methods into
> smaller sub-functions. Somehow, returning a copy of the iterator =
pointer
> is still accepted.
>=20
> This change makes it redundant to have a "bool found", since the "dp"
> from mv88e6xxx_port_vlan() now holds NULL if we haven't found what we
> were looking for.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> drivers/net/dsa/mv88e6xxx/chip.c | 54 ++++++++++++++++++--------------
> 1 file changed, 31 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c =
b/drivers/net/dsa/mv88e6xxx/chip.c
> index b3aa0e5bc842..1f35e89053e6 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1378,42 +1378,50 @@ static int mv88e6xxx_set_mac_eee(struct =
dsa_switch *ds, int port,
> 	return 0;
> }
>=20
> +static struct dsa_port *mv88e6xxx_find_port(struct dsa_switch_tree =
*dst,
> +					    int sw_index, int port)
> +{
> +	struct dsa_port *dp;
> +
> +	list_for_each_entry(dp, &dst->ports, list)
> +		if (dp->ds->index =3D=3D sw_index && dp->index =3D=3D =
port)
> +			return dp;
> +
> +	return NULL;
> +}
> +
> +static struct dsa_port *
> +mv88e6xxx_find_port_by_bridge_num(struct dsa_switch_tree *dst,
> +				  unsigned int bridge_num)
> +{
> +	struct dsa_port *dp;
> +
> +	list_for_each_entry(dp, &dst->ports, list)
> +		if (dsa_port_bridge_num_get(dp) =3D=3D bridge_num)
> +			return dp;
> +
> +	return NULL;
> +}
> +
> /* Mask of the local ports allowed to receive frames from a given =
fabric port */
> static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, =
int port)
> {
> 	struct dsa_switch *ds =3D chip->ds;
> 	struct dsa_switch_tree *dst =3D ds->dst;
> 	struct dsa_port *dp, *other_dp;
> -	bool found =3D false;
> 	u16 pvlan;
>=20
> -	/* dev is a physical switch */
> 	if (dev <=3D dst->last_switch) {
> -		list_for_each_entry(dp, &dst->ports, list) {
> -			if (dp->ds->index =3D=3D dev && dp->index =3D=3D =
port) {
> -				/* dp might be a DSA link or a user =
port, so it
> -				 * might or might not have a bridge.
> -				 * Use the "found" variable for both =
cases.
> -				 */
> -				found =3D true;
> -				break;
> -			}
> -		}
> -	/* dev is a virtual bridge */
> +		/* dev is a physical switch */
> +		dp =3D mv88e6xxx_find_port(dst, dev, port);
> 	} else {
> -		list_for_each_entry(dp, &dst->ports, list) {
> -			unsigned int bridge_num =3D =
dsa_port_bridge_num_get(dp);
> -
> -			if (bridge_num + dst->last_switch !=3D dev)
> -				continue;
> -
> -			found =3D true;
> -			break;
> -		}
> +		/* dev is a virtual bridge */
> +		dp =3D mv88e6xxx_find_port_by_bridge_num(dst,
> +						       dev - =
dst->last_switch);
> 	}
>=20
> 	/* Prevent frames from unknown switch or virtual bridge */
> -	if (!found)
> +	if (!dp)
> 		return 0;
>=20
> 	/* Frames from DSA links and CPU ports can egress any local port =
*/
> -----------------------------[ cut here ]-----------------------------

Thanks,
Jakob

