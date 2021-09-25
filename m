Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E7D417E8B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 02:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344809AbhIYAJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 20:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345121AbhIYAJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 20:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B9160FDC;
        Sat, 25 Sep 2021 00:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632528481;
        bh=crxwpYKbUubLJxhueYAre+/6yZR+/fN973Te1KA+OCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GQ93QDbXrwcRchaTYY+twMTNdJjDdlrcRI7eiJ/wZzgzlGAt6wRTcvAhkgbcbJwU6
         PUnpNP3KP8IkbuTUYWWfhNAyiXwijksUs8p5LwQg6TRtJ1qKIW23SH3IyF4d0QoJes
         TuX5e+6Y1KGUcdDsuyWLYDRfR3WKJ/p2HNmqadhEpPbLUnABqrGCUdkO0w2xcmkiBb
         rxivKRjeU61d/nkxVgNONfuV5x+wLEP8brmMqtIxa8veYltHePzY7xD63PLszR+JAW
         YnlprQURQ/Qd9fjNhnHn2vKie4wq0R0YLziNuEmEgZlUCqXTFQoCulI1EXKsX5oHQr
         gwL0i7FKfTuiA==
Date:   Fri, 24 Sep 2021 17:08:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 3/6 v5] net: dsa: rtl8366rb: Rewrite weird VLAN
 filering enablement
Message-ID: <20210924170800.2f707dbe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210924233628.2016227-4-linus.walleij@linaro.org>
References: <20210924233628.2016227-1-linus.walleij@linaro.org>
        <20210924233628.2016227-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Sep 2021 01:36:25 +0200 Linus Walleij wrote:
> +static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
> +				    bool vlan_filtering,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct realtek_smi *smi =3D ds->priv;
> +	int ret;

drivers/net/dsa/rtl8366rb.c: In function =E2=80=98rtl8366rb_vlan_filtering=
=E2=80=99:
drivers/net/dsa/rtl8366rb.c:1221:6: warning: unused variable =E2=80=98ret=
=E2=80=99 [-Wunused-variable]
 1221 |  int ret;
      |      ^~~

> +	dev_dbg(smi->dev, "port %d: %s VLAN filtering\n", port,
> +		vlan_filtering ? "enable" : "disable");
> +
> +	/* If the port is not in the member set, the frame will be dropped */
> +	return regmap_update_bits(smi->map, RTL8366RB_VLAN_INGRESS_CTRL2_REG,
> +				  BIT(port), vlan_filtering ? BIT(port) : 0);
> +}
