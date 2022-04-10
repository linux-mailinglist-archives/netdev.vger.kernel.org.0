Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4AE4FB01A
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 22:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242207AbiDJUcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 16:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiDJUcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 16:32:46 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF9D4B86B;
        Sun, 10 Apr 2022 13:30:34 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id t11so98248eju.13;
        Sun, 10 Apr 2022 13:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gUD5EhRwFvBmLktOS5nOEnCBK4Sai9l7XhsoofswNUc=;
        b=KpjDZvDRxqER1EswlLgFSnxQANZugwBRxOtmC41gnd0Uryz4qSPC1na+niPwLITs1Q
         f4VxtCFXnSfj2cMmXR3IYwc8sPbzRqzTYXap1f6r7Re1J5j9CziCtdlT0kapnBmURE5P
         wRpuW+dsgOzAMA6gmMVJVIB/SXwusu1rEFuPQ/Hg3/wsHgkcYNY9jj/UldaVdVpJjitR
         NsrX1/26OeynSGHT6oEvkGNJ0L+dNLhWL6mN7CSByFTJXUdZMmDo2SOHy4gK5Z8pf0Nb
         FSGRJtc3dLJtcbAP7fFwm5k7ZSYOpzukA+YzlJDMPjGLZ2aSKbXsgpkrp8ZVoxuqz7Bf
         bHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gUD5EhRwFvBmLktOS5nOEnCBK4Sai9l7XhsoofswNUc=;
        b=JuocEJtBwgIax+NqTQoeUk3ZibIX9EINtLOA5y8xfizqIpO3+drzo/0OQH69th30SA
         uj/SxLCef5vYb/YNoHRe5M/5OrTDY+P0/IBSZeDHaQBaXXPEPFCeWDoYbz/hotSDk/8j
         FOGNPE+O5BFSNIt4HPqdqu0Kav8xpL4Wa7u0Yjob2UCxn2NnPBaDxcK4f1BZTDPThGTk
         oWYmMhYinJJcgd6akQ7I0jXpYEORe6fiU9hmVtJsQ/Efk12egrX9wzjbQGfTy1xoRB5l
         bVNQjwE72d890ylouBlJqtexFD4KaaPidV0Y/v86UQu7r9YQi8ZZh8yHRyoEw+z9xerf
         QN9g==
X-Gm-Message-State: AOAM530iYfAEJ9S8BdR8cGHd7sfpQ/xJgXJUcxz5fhDxTgwaAsUHKDf0
        FN4qUv3/IH6ppNnabDNfVG8=
X-Google-Smtp-Source: ABdhPJwmrMKGUQSQ2qHn4JYa/+mcP5Wj0Rz4HzzH5ErMxaZRpVJ0h2eMDNZT9ne8FZ4BV1319aD2Cg==
X-Received: by 2002:a17:907:7f9e:b0:6e0:d34b:7d98 with SMTP id qk30-20020a1709077f9e00b006e0d34b7d98mr26836972ejc.574.1649622633088;
        Sun, 10 Apr 2022 13:30:33 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id l10-20020a170906938a00b006e88c811016sm910597ejx.145.2022.04.10.13.30.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Apr 2022 13:30:32 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220410200235.6mtdkd2f73ijxknn@skbuf>
Date:   Sun, 10 Apr 2022 22:30:31 +0200
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
Message-Id: <A8286EF1-4C38-4ACD-884A-6D1C64769DAE@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220408114120.tvf2lxvhfqbnrlml@skbuf>
 <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
 <C9081CE3-B008-48DA-A97C-76F51D4F189F@gmail.com>
 <20220410110508.em3r7z62ufqcbrfm@skbuf>
 <935062D0-C657-4C79-A0BE-70141D052EC0@gmail.com>
 <C88FE232-417C-4029-A79E-9A7E807D2FE7@gmail.com>
 <20220410200235.6mtdkd2f73ijxknn@skbuf>
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



> On 10. Apr 2022, at 22:02, Vladimir Oltean <olteanv@gmail.com> wrote:
>=20
> On Sun, Apr 10, 2022 at 08:24:37PM +0200, Jakob Koschel wrote:
>> Btw, I just realized that the if (!pos) is not necessary. This should =
simply do it:
>>=20
>> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
>> index b7e95d60a6e4..2d59e75a9e3d 100644
>> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
>> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
>> @@ -28,6 +28,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>> 		list_add(&e->list, &gating_cfg->entries);
>> 	} else {
>> +		struct list_head *pos =3D &gating_cfg->entries;
>> 		struct sja1105_gate_entry *p;
>>=20
>> 		list_for_each_entry(p, &gating_cfg->entries, list) {
>> 			if (p->interval =3D=3D e->interval) {
>> @@ -37,10 +38,12 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>> 				goto err;
>> 			}
>>=20
>> -			if (e->interval < p->interval)
>> +			if (e->interval < p->interval) {
>> +				pos =3D &p->list;
>> 				break;
>> +			}
>> 		}
>> -		list_add(&e->list, p->list.prev);
>> +		list_add(&e->list, pos->prev);
>> 	}
>>=20
>> 	gating_cfg->num_entries++;
>> --=20
>> 2.25.1
>=20
> I think we can give this a turn that is actually beneficial for the =
driver.
> I've prepared and tested 3 patches on this function, see below.
> Concrete improvements:
> - that thing with list_for_each_entry() and list_for_each()
> - no more special-casing of an empty list
> - simplifying the error path
> - that thing with list_add_tail()
>=20
> What do you think about the changes below?

Thanks for all the good cooperation and help. The changes look great.
I'll include them in v2 unless you want to do that separately, then I'll
just remove them from the patch series.

>=20
> =46rom 5b952b75e239cbe96729cf78c17e8d9725c9617c Mon Sep 17 00:00:00 =
2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Sun, 10 Apr 2022 22:21:41 +0300
> Subject: [PATCH 1/3] net: dsa: sja1105: remove use of iterator after
> list_for_each_entry() loop
>=20
> Jakob Koschel explains in the link below that there is a desire to
> syntactically change list_for_each_entry() and list_for_each() such =
that
> it becomes impossible to use the iterator variable outside the scope =
of
> the loop.
>=20
> Although sja1105_insert_gate_entry() makes legitimate use of the
> iterator pointer when it breaks out, the pattern it uses may become
> illegal, so it needs to change.
>=20
> It is deemed acceptable to use a copy of the loop iterator, and
> sja1105_insert_gate_entry() only needs to know the list_head element
> before which the list insertion should be made. So let's profit from =
the
> occasion and refactor the list iteration to a dedicated function.
>=20
> An additional benefit is given by the fact that with the helper =
function
> in place, we no longer need to special-case the empty list, since it =
is
> equivalent to not having found any gating entry larger than the
> specified interval in the list. We just need to insert at the tail of
> that list (list_add vs list_add_tail on an empty list does the same
> thing).
>=20
> Link: =
https://patchwork.kernel.org/project/netdevbpf/patch/20220407102900.308625=
5-3-jakobkoschel@gmail.com/#24810127
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> drivers/net/dsa/sja1105/sja1105_vl.c | 46 ++++++++++++++++++----------
> 1 file changed, 29 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
> index b7e95d60a6e4..369be2ac3587 100644
> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> @@ -7,6 +7,27 @@
>=20
> #define SJA1105_SIZE_VL_STATUS			8
>=20
> +static struct list_head *
> +sja1105_first_entry_longer_than(struct list_head *entries,
> +				s64 interval,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct sja1105_gate_entry *p;
> +
> +	list_for_each_entry(p, entries, list) {
> +		if (p->interval =3D=3D interval) {
> +			NL_SET_ERR_MSG_MOD(extack, "Gate conflict");
> +			return ERR_PTR(-EBUSY);
> +		}
> +
> +		if (interval < p->interval)
> +			return &p->list;
> +	}
> +
> +	/* Empty list, or specified interval is largest within the list =
*/
> +	return entries;
> +}
> +
> /* Insert into the global gate list, sorted by gate action time. */
> static int sja1105_insert_gate_entry(struct sja1105_gating_config =
*gating_cfg,
> 				     struct sja1105_rule *rule,
> @@ -14,6 +35,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
> 				     struct netlink_ext_ack *extack)
> {
> 	struct sja1105_gate_entry *e;
> +	struct list_head *pos;
> 	int rc;
>=20
> 	e =3D kzalloc(sizeof(*e), GFP_KERNEL);
> @@ -24,25 +46,15 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
> 	e->gate_state =3D gate_state;
> 	e->interval =3D entry_time;
>=20
> -	if (list_empty(&gating_cfg->entries)) {
> -		list_add(&e->list, &gating_cfg->entries);
> -	} else {
> -		struct sja1105_gate_entry *p;
> -
> -		list_for_each_entry(p, &gating_cfg->entries, list) {
> -			if (p->interval =3D=3D e->interval) {
> -				NL_SET_ERR_MSG_MOD(extack,
> -						   "Gate conflict");
> -				rc =3D -EBUSY;
> -				goto err;
> -			}
> -
> -			if (e->interval < p->interval)
> -				break;
> -		}
> -		list_add(&e->list, p->list.prev);
> +	pos =3D sja1105_first_entry_longer_than(&gating_cfg->entries,
> +					      e->interval, extack);
> +	if (IS_ERR(pos)) {
> +		rc =3D PTR_ERR(pos);
> +		goto err;
> 	}
>=20
> +	list_add(&e->list, pos->prev);
> +
> 	gating_cfg->num_entries++;
>=20
> 	return 0;
> --=20
> 2.25.1
>=20
> =46rom b6385f62d730b69007ea218e885461542ca4c44c Mon Sep 17 00:00:00 =
2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Sun, 10 Apr 2022 22:34:35 +0300
> Subject: [PATCH 2/3] net: dsa: sja1105: reorder
> sja1105_first_entry_longer_than with memory allocation
>=20
> sja1105_first_entry_longer_than() does not make use of the full struct
> sja1105_gate_entry *e, just of e->interval which is set from the =
passed
> entry_time.
>=20
> This means that if there is a gate conflict, we have allocated e for
> nothing, just to free it later. Reorder the memory allocation and the
> function call, to avoid that and simplify the error unwind path.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> drivers/net/dsa/sja1105/sja1105_vl.c | 17 +++++------------
> 1 file changed, 5 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
> index 369be2ac3587..e5ea8eb9ec4e 100644
> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> @@ -36,7 +36,11 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
> {
> 	struct sja1105_gate_entry *e;
> 	struct list_head *pos;
> -	int rc;
> +
> +	pos =3D sja1105_first_entry_longer_than(&gating_cfg->entries,
> +					      entry_time, extack);
> +	if (IS_ERR(pos))
> +		return PTR_ERR(pos);
>=20
> 	e =3D kzalloc(sizeof(*e), GFP_KERNEL);
> 	if (!e)
> @@ -45,22 +49,11 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
> 	e->rule =3D rule;
> 	e->gate_state =3D gate_state;
> 	e->interval =3D entry_time;
> -
> -	pos =3D sja1105_first_entry_longer_than(&gating_cfg->entries,
> -					      e->interval, extack);
> -	if (IS_ERR(pos)) {
> -		rc =3D PTR_ERR(pos);
> -		goto err;
> -	}
> -
> 	list_add(&e->list, pos->prev);
>=20
> 	gating_cfg->num_entries++;
>=20
> 	return 0;
> -err:
> -	kfree(e);
> -	return rc;
> }
>=20
> /* The gate entries contain absolute times in their e->interval field. =
Convert
> --=20
> 2.25.1
>=20
> =46rom 8aa272b8a3f53aba7b80f181b275e040b9aaed8d Mon Sep 17 00:00:00 =
2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Sun, 10 Apr 2022 22:37:14 +0300
> Subject: [PATCH 3/3] net: dsa: sja1105: use list_add_tail(pos) instead =
of
> list_add(pos->prev)
>=20
> When passed a non-head list element, list_add_tail() actually adds the
> new element to its left, which is what we want. Despite the slightly
> confusing name, use the dedicated function which does the same thing =
as
> the open-coded list_add(pos->prev).
>=20
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> drivers/net/dsa/sja1105/sja1105_vl.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
> index e5ea8eb9ec4e..7fe9b18f1cbd 100644
> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> @@ -49,7 +49,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
> 	e->rule =3D rule;
> 	e->gate_state =3D gate_state;
> 	e->interval =3D entry_time;
> -	list_add(&e->list, pos->prev);
> +	list_add_tail(&e->list, pos);
>=20
> 	gating_cfg->num_entries++;
>=20
> --=20
> 2.25.1
>=20

