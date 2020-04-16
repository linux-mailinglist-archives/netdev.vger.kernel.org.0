Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B1F1AB7C2
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 08:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436510AbgDPGKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 02:10:25 -0400
Received: from mx.0dd.nl ([5.2.79.48]:55054 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407402AbgDPGKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 02:10:21 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 276A05FBB5;
        Thu, 16 Apr 2020 08:10:14 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="kD6sh925";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id D97992A03EA;
        Thu, 16 Apr 2020 08:10:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D97992A03EA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1587017413;
        bh=nsUoDdbxuJyBFOL3kaUcgefxmeJY9720rZIwMxaY2EM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=kD6sh9255OsEt+FUrF98MDpi27Q11sfgqbaMLr4boQ/r+/y/KzsSRP0mSAGoVxPid
         BfdWlVhJjAkOnL8XlTQNL3/6So9hqWsiHaTJ68WdPIV39fF0K7yl6jTFXgc2pXBghQ
         cHDzPFw0VbOsvZ6+c9NSYfCvVMFAzO3LI9Owpdspidqh+JdXYnFz5iBafVJPisenuv
         hRKiyM8Xm2LI4Nl9f98nNLH6lJqcknntpEwC7LiSESx9l4+1mzNHD3PMR5CobEJDoY
         kYSfEC9OzXMSOlXksfQHgq39c04m424PDaNdT6WHNIZU+PUgBluqBt5kfggZP0o0Dg
         aJHj7SQOxurtw==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Thu, 16 Apr 2020 06:10:13 +0000
Date:   Thu, 16 Apr 2020 06:10:13 +0000
Message-ID: <20200416061013.Horde.Np5evwFOb2fNckWIEDCbhBI@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Stijn Segers <foss@volatilesystems.org>,
        Chuanhong Guo <gch981213@gmail.com>, riddlariddla@hotmail.com,
        Szabolcs Hubai <szab.hu@gmail.com>,
        CHEN Minqiang <ptpt52@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: fix tagged frames
 pass-through in VLAN-unaware mode
In-Reply-To: <20200414063408.4026-1-dqfext@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,


Quoting DENG Qingfang <dqfext@gmail.com>:

> In VLAN-unaware mode, the Egress Tag (EG_TAG) field in Port VLAN
> Control register must be set to Consistent to let tagged frames pass
> through as is, otherwise their tags will be stripped.

Thanks for fixing the vlan issues!

Tested-by: René van Dorst <opensource@vdorst.com>

Greats,

René
>
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> Changes since v1:
> - Fix build error
>
> ---
>  drivers/net/dsa/mt7530.c | 18 ++++++++++++------
>  drivers/net/dsa/mt7530.h |  7 +++++++
>  2 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 2d0d91db0ddb..951a65ac7f73 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -846,8 +846,9 @@ mt7530_port_set_vlan_unaware(struct dsa_switch  
> *ds, int port)
>  	 */
>  	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
>  		   MT7530_PORT_MATRIX_MODE);
> -	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
> -		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT));
> +	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
> +		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
> +		   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>
>  	for (i = 0; i < MT7530_NUM_PORTS; i++) {
>  		if (dsa_is_user_port(ds, i) &&
> @@ -863,8 +864,8 @@ mt7530_port_set_vlan_unaware(struct dsa_switch  
> *ds, int port)
>  	if (all_user_ports_removed) {
>  		mt7530_write(priv, MT7530_PCR_P(MT7530_CPU_PORT),
>  			     PCR_MATRIX(dsa_user_ports(priv->ds)));
> -		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT),
> -			     PORT_SPEC_TAG);
> +		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT), PORT_SPEC_TAG
> +			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>  	}
>  }
>
> @@ -890,8 +891,9 @@ mt7530_port_set_vlan_aware(struct dsa_switch  
> *ds, int port)
>  	/* Set the port as a user port which is to be able to recognize VID
>  	 * from incoming packets before fetching entry within the VLAN table.
>  	 */
> -	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
> -		   VLAN_ATTR(MT7530_VLAN_USER));
> +	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
> +		   VLAN_ATTR(MT7530_VLAN_USER) |
> +		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
>  }
>
>  static void
> @@ -1380,6 +1382,10 @@ mt7530_setup(struct dsa_switch *ds)
>  			mt7530_cpu_port_enable(priv, i);
>  		else
>  			mt7530_port_disable(ds, i);
> +
> +		/* Enable consistent egress tag */
> +		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
> +			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>  	}
>
>  	/* Setup port 5 */
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index ef9b52f3152b..2528232d3325 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -172,9 +172,16 @@ enum mt7530_port_mode {
>  /* Register for port vlan control */
>  #define MT7530_PVC_P(x)			(0x2010 + ((x) * 0x100))
>  #define  PORT_SPEC_TAG			BIT(5)
> +#define  PVC_EG_TAG(x)			(((x) & 0x7) << 8)
> +#define  PVC_EG_TAG_MASK		PVC_EG_TAG(7)
>  #define  VLAN_ATTR(x)			(((x) & 0x3) << 6)
>  #define  VLAN_ATTR_MASK			VLAN_ATTR(3)
>
> +enum mt7530_vlan_port_eg_tag {
> +	MT7530_VLAN_EG_DISABLED = 0,
> +	MT7530_VLAN_EG_CONSISTENT = 1,
> +};
> +
>  enum mt7530_vlan_port_attr {
>  	MT7530_VLAN_USER = 0,
>  	MT7530_VLAN_TRANSPARENT = 3,
> --
> 2.26.0



