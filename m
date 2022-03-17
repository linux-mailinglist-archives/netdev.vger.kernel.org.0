Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E034DC7C2
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbiCQNnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbiCQNny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:43:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E77041C7E8F
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647524557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ueXvlZpWtlGiaFvzA83kng7q7xujVy+EbQ/5+UkMGH4=;
        b=IGw83nlX4Pkl1CAJ145tlY6Yuu2ToDZEf0xgvik6jvEUixnqQnrR3wHgWAMMRldSA0q3dh
        YZzN2btXk773jcpCc42AKWyWkM3CjvXD/U9Ob7xKWav7KYNsKCF1e0GFp3XpQ6e8cI8aOe
        3/cXlyKEAjwf0euubzwZTS6Z2ivCop4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-g_-o6hIDMKa6HDf8xZivCQ-1; Thu, 17 Mar 2022 09:42:35 -0400
X-MC-Unique: g_-o6hIDMKa6HDf8xZivCQ-1
Received: by mail-ed1-f72.google.com with SMTP id cf6-20020a0564020b8600b00415e9b35c81so3127465edb.9
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueXvlZpWtlGiaFvzA83kng7q7xujVy+EbQ/5+UkMGH4=;
        b=yAO6+YH9L2/qArmhUZMg9ab0MQ4dHlCEhDynIBxUBVji3KrlFb5MHbK6H95LurtJ/d
         m5ePYgm6riNMN3tawALV2cEfqazjupOZLFhuc8ARLEZITX94pwBCPM+PcVoX0C9Pcfo1
         2IiLTgQp11QPB31cVWIpwlmaCdtuG4vc04QCKF9+wFrvqqTmMSrMQESmKHuK1A3QyljY
         rM+lJQXYkNACH+If3S0y00HKVMzT1GuFlH2eIv1ctGBJvCN+aw4z8xfnJ84w+QtoSN8g
         IgK6ZN6rYlLFNIOi/5ADmhZKTDs/5nSWxh2/wNJ30MGMrEg7/5l+/MIlbt8lcXOtCVvW
         tFyg==
X-Gm-Message-State: AOAM533NUos0zvBVKPZZuXtfUYlhOwOxV5AlD62pvbMNc0tjRln/6g4u
        /XjBqImTmair+7QZIrn04s98h68iw2J0LKVUga4QIaqJ1dBo1ziLT2Af/A42J5KXtYGMlgCdbGz
        Jnqirr2YpQelUp00G
X-Received: by 2002:a50:fd09:0:b0:416:1a9c:d7b with SMTP id i9-20020a50fd09000000b004161a9c0d7bmr4509150eds.78.1647524554665;
        Thu, 17 Mar 2022 06:42:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRSVgVlEg9GBgsXmQsf2qe++Wa/xMMwdv0UEXuEEUrmrOubeEcxuH7sLlA1n/d0ODexURncQ==
X-Received: by 2002:a50:fd09:0:b0:416:1a9c:d7b with SMTP id i9-20020a50fd09000000b004161a9c0d7bmr4509114eds.78.1647524554301;
        Thu, 17 Mar 2022 06:42:34 -0700 (PDT)
Received: from [10.39.193.107] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id p14-20020a05640210ce00b00413211746d4sm2679237edu.51.2022.03.17.06.42.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Mar 2022 06:42:33 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Dumitru Ceara <dceara@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: always update flow key after NAT
Date:   Thu, 17 Mar 2022 14:42:33 +0100
X-Mailer: MailMate (1.14r5875)
Message-ID: <E3DEE4BD-F8BB-4B41-8310-9214B1431614@redhat.com>
In-Reply-To: <20220317121729.2810292-1-aconole@redhat.com>
References: <20220317121729.2810292-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 Mar 2022, at 13:17, Aaron Conole wrote:

> During NAT, a tuple collision may occur.  When this happens, openvswitc=
h
> will make a second pass through NAT which will perform additional packe=
t
> modification.  This will update the skb data, but not the flow key that=

> OVS uses.  This means that future flow lookups, and packet matches will=

> have incorrect data.  This has been supported since
> commit 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").
>
> That commit failed to properly update the sw_flow_key attributes, since=

> it only called the ovs_ct_nat_update_key once, rather than each time
> ovs_ct_nat_execute was called.  As these two operations are linked, the=

> ovs_ct_nat_execute() function should always make sure that the
> sw_flow_key is updated after a successful call through NAT infrastructu=
re.
>
> Fixes: 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack")
> Cc: Dumitru Ceara <dceara@redhat.com>
> Cc: Numan Siddique <nusiddiq@redhat.com>
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---
>  net/openvswitch/conntrack.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index c07afff57dd3..461dbb3b7090 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -104,6 +104,10 @@ static bool labels_nonzero(const struct ovs_key_ct=
_labels *labels);
>
>  static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info);
>
> +static void ovs_nat_update_key(struct sw_flow_key *key,
> +			       const struct sk_buff *skb,
> +			       enum nf_nat_manip_type maniptype);
> +

nit?: Rather than adding this would it be simpler to swap the order of ov=
s_nat_update_key and ovs_ct_nat_execute?

Also, the function is defined by =E2=80=9C#if IS_ENABLED(CONFIG_NF_NAT)=E2=
=80=9D not sure if this will generate warnings if the function is not pre=
sent?

>  static u16 key_to_nfproto(const struct sw_flow_key *key)
>  {
>  	switch (ntohs(key->eth.type)) {
> @@ -741,7 +745,7 @@ static bool skb_nfct_cached(struct net *net,
>  static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,=

>  			      enum ip_conntrack_info ctinfo,
>  			      const struct nf_nat_range2 *range,
> -			      enum nf_nat_manip_type maniptype)
> +			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
>  {
>  	int hooknum, nh_off, err =3D NF_ACCEPT;
>
> @@ -813,6 +817,10 @@ static int ovs_ct_nat_execute(struct sk_buff *skb,=
 struct nf_conn *ct,
>  push:
>  	skb_push_rcsum(skb, nh_off);
>
> +	/* Update the flow key if NAT successful. */
> +	if (err =3D=3D NF_ACCEPT)
> +		ovs_nat_update_key(key, skb, maniptype);
> +
>  	return err;
>  }
>
> @@ -906,7 +914,7 @@ static int ovs_ct_nat(struct net *net, struct sw_fl=
ow_key *key,
>  	} else {
>  		return NF_ACCEPT; /* Connection is not NATed. */
>  	}
> -	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);=

> +	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, =
key);
>
>  	if (err =3D=3D NF_ACCEPT && ct->status & IPS_DST_NAT) {
>  		if (ct->status & IPS_SRC_NAT) {
> @@ -916,17 +924,13 @@ static int ovs_ct_nat(struct net *net, struct sw_=
flow_key *key,
>  				maniptype =3D NF_NAT_MANIP_SRC;
>
>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
> -						 maniptype);
> +						 maniptype, key);
>  		} else if (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL) {
>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
> -						 NF_NAT_MANIP_SRC);
> +						 NF_NAT_MANIP_SRC, key);
>  		}
>  	}
>
> -	/* Mark NAT done if successful and update the flow key. */
> -	if (err =3D=3D NF_ACCEPT)
> -		ovs_nat_update_key(key, skb, maniptype);
> -
>  	return err;
>  }
>  #else /* !CONFIG_NF_NAT */

The rest of the patch looks fine to me...

