Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F6D3D579
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407076AbfFKS1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:27:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37856 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406804AbfFKS1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:27:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id y57so15761917qtk.4
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 11:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XTSl1X3TVusNnBwvpfSKetQ7KFSoxgL/x9tvPN4y51Q=;
        b=CRAEEdTtEd/R/ClPRCAiQrGs353d6Tbo3jIKj42fETxvxpoFht2citqwCizu+33E4B
         +JP4HyZtGaV+ojzUSANo2JTxN9uZJuVTCIdB5VDwxaajMa4IdsmZqr2iMOOdkQug4CPO
         D4HrAY5X+k+OfpDZIqflFncGBPA/BYEeK5fkJKZiTpnIXjHJE8C8C9Gw1Q1r6y0ZsMer
         1ih33ubjy3e80OUbS/QmPjKW+iqSeJzTiyB7yn2brAaZZSQ4KGgtAKsJl2SBbVAm0zAB
         P37irrMi8CrkU4pwyEi6yC+kFXGeOXHQbZXEfQdwkhvBSLzQ4z71mRd4ouAld+i1/yRN
         EZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XTSl1X3TVusNnBwvpfSKetQ7KFSoxgL/x9tvPN4y51Q=;
        b=RezyEERuAdMQyZme8TvKt1U0oh4FrGeOZfCaoHk34so2j6RqzuKzb7JI3X+Hou5yMS
         5UDBUx+rl2IX92cPrBfVW1ncTjcJjt46u1QnXTjE9mOC8C7AENmzXVoEgj9920zNCDnZ
         iyv84QtOgujlbOGoj3WX2jVTK9VO4+hQvxdFwHLRDtyLBgWq5ixQ8+4qWUpCBRhmMZkA
         8xUIE0aB55R3hCcwdP4OPS5C6Seyc0ZVkwwz4V80+xD3/EWofKpKNMzJojjAqe0HxUBW
         abd6Ak8pFjFZCY4ympKcYFSwHkWJUPEkGBn8WT2ZFvVtJQbRYRL6ZVarlQJnS6Gwc7tg
         i7QQ==
X-Gm-Message-State: APjAAAVLr/F/u8V3pTjwm3OXUsHXbpMDDzA85VPc+iJY/xF86ZmTTsjF
        3hZ+QQPN9nkoPSZQLg2D90j3OfL5Iv0=
X-Google-Smtp-Source: APXvYqxOJlQrkKCKNeZVMer/ppqUM3GcMD8BwtnZWk7n591FH4TR2dpB9T5BB74xMJinUiXzrdjheA==
X-Received: by 2002:ac8:7545:: with SMTP id b5mr56892127qtr.234.1560277635418;
        Tue, 11 Jun 2019 11:27:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u7sm6731244qkm.62.2019.06.11.11.27.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 11:27:15 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:27:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH net] net: ethtool: Allow matching on vlan CFI bit
Message-ID: <20190611112710.211e218b@cakuba.netronome.com>
In-Reply-To: <20190611155456.15360-1-maxime.chevallier@bootlin.com>
References: <20190611155456.15360-1-maxime.chevallier@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 17:54:56 +0200, Maxime Chevallier wrote:
> Using ethtool, users can specify a classification action matching on the
> full vlan tag, which includes the CFI bit.
>=20
> However, when converting the ethool_flow_spec to a flow_rule, we use
> dissector keys to represent the matching patterns.
>=20
> Since the vlan dissector key doesn't include the CFI bit, this
> information was silently discarded when translating the ethtool
> flow spec in to a flow_rule.
>=20
> This commit adds the CFI bit into the vlan dissector key, and allows
> propagating the information to the driver when parsing the ethtool flow
> spec.
>=20
> Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule stru=
cture translator")
> Reported-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> Hi all,
>=20
> Although this prevents information to be silently discarded when parsing
> an ethtool_flow_spec, this information doesn't seem to be used by any
> driver that converts an ethtool_flow_spec to a flow_rule, hence I'm not
> sure this is suitable for -net.
>=20
> Thanks,
>=20
> Maxime
>=20
>  include/net/flow_dissector.h | 1 +
>  net/core/ethtool.c           | 5 +++++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 7c5a8d9a8d2a..9d2e395c6568 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -46,6 +46,7 @@ struct flow_dissector_key_tags {
> =20
>  struct flow_dissector_key_vlan {
>  	u16	vlan_id:12,
> +		vlan_cfi:1,
>  		vlan_priority:3;
>  	__be16	vlan_tpid;
>  };
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index d08b1e19ce9c..43df34c1ebe1 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -3020,6 +3020,11 @@ ethtool_rx_flow_rule_create(const struct ethtool_r=
x_flow_spec_input *input)
>  			match->mask.vlan.vlan_id =3D
>  				ntohs(ext_m_spec->vlan_tci) & 0x0fff;
> =20
> +			match->key.vlan.vlan_cfi =3D
> +				!!(ntohs(ext_h_spec->vlan_tci) & 0x1000);
> +			match->mask.vlan.vlan_cfi =3D
> +				!!(ntohs(ext_m_spec->vlan_tci) & 0x1000);

nit: since you're only using the output as a boolean, you can apply the
     byteswap to the constant and have it performed at build time.
     Another option is be16_get_bits() from linux/bitfield.h.

>  			match->key.vlan.vlan_priority =3D
>  				(ntohs(ext_h_spec->vlan_tci) & 0xe000) >> 13;
>  			match->mask.vlan.vlan_priority =3D
