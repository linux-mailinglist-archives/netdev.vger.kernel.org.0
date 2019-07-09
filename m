Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B903A62D9D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfGIBop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:44:45 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46666 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfGIBoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:44:44 -0400
Received: by mail-qk1-f195.google.com with SMTP id r4so14813931qkm.13
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZvuQo6evsVCUlDEsNzH37NojCewlv73AG70+WQmLr4c=;
        b=ga/SunY/p1WWr4ZysR/ivY26jKT1KD8q9KDIOCndKrp6hl5oEvpSRtHMD5VoIub6NM
         YE1JSDCR8o9JpN3Q7XSIR4be/OYAu0U3unv5lwWtSZPaCkUTB/HYCHtAMXT3xFKycopS
         uwOMNW+T2foduGaSjaxJUhjoB4SaJw6fL2lwz0jyM0gf9jzKwxI3oiip7dN6BVknAe1/
         8zpf1YCONHDHpgofVHg7Pzpl25GbwpmEb7l+oDC+kNzFsxf8+1S36B9SQXqMKZSzBNO9
         5HhYz2kYm59sA7dEEjAUuA6kDbd1Dn3eMCkAbLlX8cpm0ZIHEsnOHW+LmJ/KozGiL0xe
         PrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZvuQo6evsVCUlDEsNzH37NojCewlv73AG70+WQmLr4c=;
        b=NjnNNcQCyFWvjRZlTwKdepdgMN2jvjk03yOS1K6UFvxMvvjuzrcxlegmwG2HcgtoRC
         oxZcNTp7u/m+eafo7KHPYnRGul3oglgTdyTr0xKuUvv6HxuhUwUf9eWf8ueldgX369WR
         5iJfPrgiOVmpKk0edos3RyHvUm6bE/Jmvya5m1b3ObUuXtCtK7Xwry1X8dd0VgIno5WZ
         xHcL3MxHcUZWMzve2u8FbjAyfFuUqrDmiV41KpGABaW0C/vk+5ZgK0HKRiH80Olw2xCk
         wyAI5WTH5+FxucGEp20gyVwPFJeP9C9mYj9xxm48nwDMZGYbzuHHLc3lvaGw41mgmmVJ
         a0cg==
X-Gm-Message-State: APjAAAWAFMYhpfboospYkgBShYj/9fefLt8tTyopic8Mm/UT2F5qVPXX
        ToByc/MUtq/RdV5/IPnuokyYqw==
X-Google-Smtp-Source: APXvYqxsDnt2MdLzJayLyeHUcjX6rwz7H/ShvonENWZNfDkTqiFniQq5aiVptinAv4sFRDV2CsydhQ==
X-Received: by 2002:a37:e506:: with SMTP id e6mr17619550qkg.229.1562636684065;
        Mon, 08 Jul 2019 18:44:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q56sm9371475qtq.64.2019.07.08.18.44.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 18:44:43 -0700 (PDT)
Date:   Mon, 8 Jul 2019 18:44:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        linux-net-drivers@solarflare.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        maxime.chevallier@bootlin.com, cphealy@gmail.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 11/11] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190708184437.4d29648a@cakuba.netronome.com>
In-Reply-To: <20190708160614.2226-12-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
        <20190708160614.2226-12-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Jul 2019 18:06:13 +0200, Pablo Neira Ayuso wrote:
> This patch adds hardware offload support for nftables through the
> existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
> classifier and the flow rule API. This hardware offload support is
> available for the NFPROTO_NETDEV family and the ingress hook.
>=20
> Each nftables expression has a new ->offload interface, that is used to
> populate the flow rule object that is attached to the transaction
> object.
>=20
> There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
> an entire table, including all of its chains.
>=20
> This patch supports for basic metadata (layer 3 and 4 protocol numbers),
> 5-tuple payload matching and the accept/drop actions; this also includes
> basechain hardware offload only.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Any particular reason to not fence this off with a device feature
(ethtool -k)?  Then you wouldn't need that per-driver list abomination
until drivers start advertising it..  IDK if we want the per-device
offload enable flags or not in general, it seems like a good idea in
general for admin to be able to disable offload per device =F0=9F=A4=B7

> +static int nft_flow_offload_rule(struct nft_trans *trans,
> +				 enum tc_fl_command command)
> +{
> +	struct nft_flow_rule *flow =3D nft_trans_flow_rule(trans);
> +	struct nft_rule *rule =3D nft_trans_rule(trans);
> +	struct tc_cls_flower_offload cls_flower =3D {};
> +	struct nft_base_chain *basechain;
> +	struct netlink_ext_ack extack;
> +	__be16 proto =3D ETH_P_ALL;
> +
> +	if (!nft_is_base_chain(trans->ctx.chain))
> +		return -EOPNOTSUPP;
> +
> +	basechain =3D nft_base_chain(trans->ctx.chain);
> +
> +	if (flow)
> +		proto =3D flow->proto;
> +
> +	nft_flow_offload_common_init(&cls_flower.common, proto, &extack);
> +	cls_flower.command =3D command;
> +	cls_flower.cookie =3D (unsigned long) rule;
> +	if (flow)
> +		cls_flower.rule =3D flow->rule;
> +
> +	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flower);
> +}

Are we 100% okay with using TC cls_flower structures and defines in nft
code?
