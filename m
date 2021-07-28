Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CD33D9582
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhG1Srt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1Srs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:47:48 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E817C061757;
        Wed, 28 Jul 2021 11:47:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id e19so6163875ejs.9;
        Wed, 28 Jul 2021 11:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rw1im/4KKTL6GDAfF73CRmLTIbz+OF0JjH7lHeKRYlQ=;
        b=hWEENPPhfpw22zsbzZ+sNGX02aq9HWzFfb5S7Ijrz+11UNSRxaa9/ecl0m+g9VEP2Y
         rKIqH/43TbQdMF1LM4YmM0g5/9r+KTJpZPotC7M0ZoODR7QFYX4Ofb72bKk9SO/GZUN6
         BNN9xgO88X2kMLgdplL6z8TQ3w8Oi2MnhSriiXejlK4grTZEDpoTnJwDI68O6obM2gna
         bVntCdmHPZaljVwCLCRIHSyf27AR9iS51V8hoLMzg1mQ2m33GqAk/d+HcqRhUdsURAOd
         fqQlUawCvnZfoOKOdoY0R0Jy8DgOaMzEgMbNlu0QPjJzu+SM8M58zrPOUEyxgO/wnup3
         k7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rw1im/4KKTL6GDAfF73CRmLTIbz+OF0JjH7lHeKRYlQ=;
        b=icYpOuuJeHdNSJDXmJe0NJLw3oZTSJQfdv5urbUAm0KijNzz+MnB27sfLaGcit2t31
         K5q10RuKSpcPNd8so/4qd0vmUVIulgHx2LJyxKM/rEAbzckr33ncQUAQKlAeQo+ILuAp
         bry3maOuEdXUHtirJOJK3S1iUd3Zj+M/rJKIHyg0WZcaRbW5vcAhul4BmANv4VWy+gfD
         RlFnB/B878zEzKuAKEdCqMj8erilKGSSaP23rNKgrJer9d5HQMnrnzvHPJ1uh2j8uj4e
         S9/cKj6ZqkBffN38NnGHOlvsWUOZfjLk2ipduYW97Ap81F+cL/zlcN6pW1E2I7pGlgsl
         JCbg==
X-Gm-Message-State: AOAM530krHmxNg1Zh4IiXsds23QWc87vSh0dzKPxhT888WQe/YTdL4zw
        bfu3br/xfMAzlhSCe5wmhto=
X-Google-Smtp-Source: ABdhPJyrA1FU5+Q1j3pmfXnRdR9xvKtg4sq1W9c+KbbUMEyrWKfBM3aem+xcjtncDkPRLpxOUbVyrA==
X-Received: by 2002:a17:907:2d28:: with SMTP id gs40mr815302ejc.193.1627498064631;
        Wed, 28 Jul 2021 11:47:44 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id i11sm175324ejx.82.2021.07.28.11.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:47:44 -0700 (PDT)
Date:   Wed, 28 Jul 2021 21:47:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from
 standalone ports to the CPU
Message-ID: <20210728184742.cyoh7ucvxwlbdpnu@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-3-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728175327.1150120-3-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:53:26AM +0800, DENG Qingfang wrote:
>  /* Register for setup vlan and acl write data */
> @@ -153,6 +162,35 @@ enum mt7530_vlan_cmd {
>  #define  PORT_MEM_SHFT			16
>  #define  PORT_MEM_MASK			0xff
>  
> +/* ACL rule pattern */
> +#define  BIT_CMP(x)			(((x) & 0xffff) << 16)
> +#define  CMP_PAT(x)			((x) & 0xffff)

not used

> +
> +/* ACL rule action */
> +#define  ACL_MANG			BIT(29)
> +#define  ACL_INT_EN			BIT(28)
> +#define  ACL_CNT_EN			BIT(27)
> +#define  ACL_CNT_IDX(x)			(((x) & 0x7) << 24)
> +#define  VLAN_PORT_EN			BIT(23)
> +#define  DA_SWAP			BIT(22)
> +#define  SA_SWAP			BIT(21)
> +#define  PPP_RM				BIT(20)
> +#define  LKY_VLAN			BIT(19)
> +#define  ACL_EG_TAG(x)			(((x) & 0x7) << 16)
> +#define  ACL_PORT(x)			(((x) & 0xff) << 8)
> +#define  ACL_PORT_EN			BIT(7)
> +#define  PRI_USER(x)			(((x) & 0x7) << 4)
> +#define  ACL_MIR_EN			BIT(3)
> +#define  ACL_PORT_FW(x)			((x) & 0x7)
> +
> +enum mt7530_to_cpu_port_fw {
> +	PORT_FW_DEFAULT,
> +	PORT_FW_EXCLUDE_CPU = 4,
> +	PORT_FW_INCLUDE_CPU,
> +	PORT_FW_CPU_ONLY,
> +	PORT_FW_DROP,
> +};

not used

> +
>  #define MT7530_VAWD2			0x98
>  /* Egress Tag Control */
>  #define  ETAG_CTRL_P(p, x)		(((x) & 0x3) << ((p) << 1))
> @@ -164,6 +202,23 @@ enum mt7530_vlan_egress_attr {
>  	MT7530_VLAN_EGRESS_STACK = 3,
>  };
>  
> +/* ACL rule pattern */
> +#define  ACL_TABLE_EN			BIT(19)
> +#define  OFST_TP(x)			(((x) & 0x7) << 16)
> +#define  ACL_SP(x)			(((x) & 0xff) << 8)
> +#define  WORD_OFST(x)			(((x) & 0x7f) << 1)
> +#define  CMP_SEL			BIT(0)

not used

> +
> +enum mt7530_acl_offset_type {
> +	MT7530_ACL_MAC_HEADER,
> +	MT7530_ACL_L2_PAYLOAD,
> +	MT7530_ACL_IP_HEADER,
> +	MT7530_ACL_IP_DATAGRAM,
> +	MT7530_ACL_TCP_UDP_HEADER,
> +	MT7530_ACL_TCP_UDP_DATAGRAM,
> +	MT7530_ACL_IPV6_HEADER,
> +};

not used

> +
>  /* Register for address age control */
>  #define MT7530_AAC			0xa0
>  /* Disable ageing */
> @@ -192,6 +247,7 @@ enum mt7530_stp_state {
>  
>  /* Register for port control */
>  #define MT7530_PCR_P(x)			(0x2004 + ((x) * 0x100))
> +#define  PORT_ACL_EN			BIT(10)
>  #define  PORT_TX_MIR			BIT(9)
>  #define  PORT_RX_MIR			BIT(8)
>  #define  PORT_VLAN(x)			((x) & 0x3)
> -- 
> 2.25.1
> 

