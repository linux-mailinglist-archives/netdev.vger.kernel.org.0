Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242504D8A34
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiCNQ6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbiCNQ6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:58:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75073A73B;
        Mon, 14 Mar 2022 09:56:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r13so35440590ejd.5;
        Mon, 14 Mar 2022 09:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=63A+VQ/NUEeDaJW7pNGXfcNFAy8DF92o6Jzg0oVXuE4=;
        b=bLlpoaIizi9w3UjGu1TRPkRkHLgPf6oYVkqZWI2khR0kHkk3u04vcv1O8WJMtUqoxV
         99B9FR+PioiSsynsRNsE6QFtnlvm+Xj5dH34iH9GlBmn6++ZXau3EED6kY3J+hAEdbL4
         6XvpbJMXNdp5ZfUy5hujk3Vb+tH4K7lZEAA0K1VUHGTorOS47cPw6eTJP36+Nen6h9kt
         Rpvzm96daPnQuEl1cJnQKip3IihU9R5UftSOdffgGkJpZbxZYooxKNCxQil0BpG9O5a4
         MsCtR96HyerXpBZk0C4uERrPw4f/n3yU+y0eD51xhWOlGhXoz0yZljPMLAYu8YgxaF+0
         vDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=63A+VQ/NUEeDaJW7pNGXfcNFAy8DF92o6Jzg0oVXuE4=;
        b=7bDyTtf0XkKhwLVoU2z9Pw1iEi4e/ADWZoL9hYsN7WPg3iEhA2unVUfaF+Y/R97DnN
         hj/yI5Y3KOKsC3sXG0IgkbVoBe0/QQGs45bZDmrdh1QqDlZIFzYbIw4vl4C3/oYXzKFi
         AfE3KcHT+vRrpiw+CLvrSc5TYwUo3B+TyQAOSOuMLrIeEemrMb6sVAnHjkVbCBrLnAW7
         VKdUvJPvOFBhc+s5eYKkG4c4K4NO40iwARub4r/AR9UfmMsobdEk4T411RRfs4TSjk8B
         bxnJEChByWo7Rbl8wHxvqrgYQXaLN/83w0oSIOHwY+bc5KxwjQYW9EmkCfgSEnOT8mPQ
         FUcw==
X-Gm-Message-State: AOAM530Gcrnc9M3uAdgDowzjBXFvfDhsNywGIYpdMITpZkTiUqBXfTXj
        yMfUP4DYkBabjUhQFly/4i0=
X-Google-Smtp-Source: ABdhPJy4iP7W3VPKzGvFW/dTiEMVOGUqKn5TPQdRZRefbfStQyIy115mZyar8J0FrnQFf4zbZb8I5A==
X-Received: by 2002:a17:907:7254:b0:6db:ad8f:27b4 with SMTP id ds20-20020a170907725400b006dbad8f27b4mr12828197ejc.599.1647277011251;
        Mon, 14 Mar 2022 09:56:51 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id js24-20020a170906ca9800b006c8aeca8fe8sm7029530ejb.58.2022.03.14.09.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 09:56:50 -0700 (PDT)
Date:   Mon, 14 Mar 2022 18:56:49 +0200
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
Message-ID: <20220314165649.vtsd3xqv7htut55d@skbuf>
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

Sadly this will break down because we don't have unwinding on error in
place (sorry). We'd end up with an unoffloaded bridge port with
partially synced bridge port attributes. Could you please add a patch
previous to this one that handles this, and unoffloads those on error?

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
