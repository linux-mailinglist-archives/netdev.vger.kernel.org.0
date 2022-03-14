Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601824D8B19
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243462AbiCNRwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242506AbiCNRwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:52:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF1B13F28;
        Mon, 14 Mar 2022 10:51:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m12so20993647edc.12;
        Mon, 14 Mar 2022 10:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K+QzBYfwm0KBPQGCnXunte5ZDjBtvy4RzhVp5w57kMg=;
        b=M/RgnQtyHwMeBGs6ZTShnPjz0GwpDCtlAk8qLTaCj3CBf3lqkVGgBUfYjW/5rnhj6w
         F471RcppKHuyJOL43RvWaNPZl7vKfBE5xbkh33zJQFVVxpMl0UnALnMEKRtT9a2jQane
         xuLDh5HN6EvmrSuOlGtT2P6D9vGmaAUDZ92k2//CGuGtpHvYXDGCr9O3UZZP26Zqsr5W
         BDBd71AkBAPiUW3yMN1A18XYZVyHfXr6Moh/uffalzPzOLEprYuOO8ey879wYry3Y02I
         y2GHHmCjuMcvX+exgR46gfZQXbxqL5ErW5Ty3h/GDkGt39qm8OPKB021tktb0OiReuUW
         JC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K+QzBYfwm0KBPQGCnXunte5ZDjBtvy4RzhVp5w57kMg=;
        b=shgZUgy1T5FofVxnlsJQQIzLqvNz3oJcHxX5HKCId666IUcHhaiZ4b79Lm0wfbfPuM
         Xc++ipHd0po89iANJuNfY0SEOUThjZAM3XU+sBhS11AZDO+ZDiwe5F1udsSCNiQ5uE2I
         PCVWkZIUTTWc1+WGuwhz0KnRz84vPGBHB+NoCg2lk8znK4PM31+TMZzSiXf7Ww87BmMr
         LMKA37CSPBDBJEXxv56Q3tUfT7TRJ9iuDpv/PbKPkj/jwEql49hvN1WUfmrzRrE2pBxi
         DEzLxs7xcNBbSw4uNv+axELmQgzxmc3zjv12xb9ExPw/00nbKIcPeC/EEdhjGfIpRz+z
         qmcQ==
X-Gm-Message-State: AOAM532MBaUDRb97lsYvOpEs//tRxAOn96jGu9xBrNH8DvvL7PSOLLJF
        xz02ZI0ZxmEj0KKBgtJ+oCI=
X-Google-Smtp-Source: ABdhPJzZ7adnceVULLcpDzwBytwFNDA6cwAaMluqHekt/uFLE4gDihE6mCj1a9IEQdaxfIdH9HHp8Q==
X-Received: by 2002:a05:6402:5208:b0:416:ce01:f9b5 with SMTP id s8-20020a056402520800b00416ce01f9b5mr16224792edd.275.1647280280357;
        Mon, 14 Mar 2022 10:51:20 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id z92-20020a509e65000000b00416466dc220sm8414953ede.87.2022.03.14.10.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:51:19 -0700 (PDT)
Date:   Mon, 14 Mar 2022 19:51:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 09/14] net: dsa: Validate hardware support
 for MST
Message-ID: <20220314175118.w4plirtshhzgujn3@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-10-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314095231.3486931-10-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 10:52:26AM +0100, Tobias Waldekranz wrote:
> When joining a bridge where MST is enabled, we validate that the
> proper offloading support is in place, otherwise we fallback to
> software bridging.
> 
> When then mode is changed on a bridge in which we are members, we
> refuse the change if offloading is not supported.
> 
> At the moment we only check for configurable learning, but this will
> be further restricted as we support more MST related switchdev events.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/dsa_priv.h |  2 ++
>  net/dsa/port.c     | 20 ++++++++++++++++++++
>  net/dsa/slave.c    |  6 ++++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index f20bdd8ea0a8..2aba420696ef 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -234,6 +234,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  			    struct netlink_ext_ack *extack);
>  bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
>  int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
> +int dsa_port_mst_enable(struct dsa_port *dp, bool on,
> +			struct netlink_ext_ack *extack);
>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
>  			bool targeted_match);
>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 58291df14cdb..1a17a0efa2fa 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -240,6 +240,10 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
>  	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
> +	err = dsa_port_mst_enable(dp, br_mst_enabled(br), extack);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;

The "err && err != -EOPNOTSUPP" scheme is in place for compatibility
with drivers that don't all support the bridge port attributes, but used
to work prior to dsa_port_switchdev_sync_attrs()'s existence.

I don't think this scheme is necessary for dsa_port_mst_enable(), you
can just return -EOPNOTSUPP and remove the special handling for this code.

> +
>  	return 0;
>  }
>  
> @@ -735,6 +739,22 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
>  	return 0;
>  }
>  
> +int dsa_port_mst_enable(struct dsa_port *dp, bool on,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!on)
> +		return 0;
> +
> +	if (!dsa_port_can_configure_learning(dp)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
>  			      struct switchdev_brport_flags flags,
>  			      struct netlink_ext_ack *extack)
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index a61a7c54af20..333f5702ea4f 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -463,6 +463,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>  
>  		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
>  		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_MST:
> +		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
> +			return -EOPNOTSUPP;
> +
> +		ret = dsa_port_mst_enable(dp, attr->u.mst, extack);
> +		break;
>  	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
>  		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
>  			return -EOPNOTSUPP;
> -- 
> 2.25.1
> 
