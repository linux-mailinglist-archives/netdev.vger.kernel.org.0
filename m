Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767E76624DA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbjAIL5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbjAIL5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:57:01 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9172D12083;
        Mon,  9 Jan 2023 03:56:57 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z11so12174407ede.1;
        Mon, 09 Jan 2023 03:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/pT23tJD4oTt91rYqRLukayxZ3L3T77mmbN65HM1ng=;
        b=Ua7tqnmz76QuyglO1osJpuYr+bgSHGx1SUhy9z7kPTzzillWXVYwuu3x4UQrgzc539
         lBTDj1CsnpAZccHPWU6T1VGv8Wtm3df9updiX3VWX68jatXyYrcI0oB7C2B+gG8kPjYG
         QWhGgb8Au8oa0K2db+FwCP78MGf2UiqT3DIrioBJidIYg2SpgzrKAZJn8uX04Us5DgpY
         9SESgaRE3UwVLiqGaMQ+NcAGCq3jgvrFu5/yL1iCUp7X7cDtHQ1dlcULZQQt8V0Ox+4a
         XbL+DUp1X8MeSKqjzXIEH8s9MT2Oodqy0uHatvzIa/P+PkXC0K4jjQnJ9lwxgPEoiPJw
         Vamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/pT23tJD4oTt91rYqRLukayxZ3L3T77mmbN65HM1ng=;
        b=lEBdbQIUAZuxXT3jPRmOFn+I+3h/UuXnyR1Jn7dTSddDeoHKGEESs1X7nynkDlzcLV
         Qc0Ujn827i9gDwOVxDo1Sgb3l0GJTSnI2e/G7MnNyJocFZw+9XBLz6H1H8yYvRX3E6yS
         plk7xY/+77RxIVCS3F+vqcmfrjp6GI7y1I5sHqcQjavFbL59jrQW4qg9KLYA5hzOaDnt
         4cxmEdo8dxhwQ9LOps0Cd0Yzl7Pa8PeA6LDkXlJ3LwIlymZCBbwVkQu+q1aqZk+6lNI+
         wEh2NDuievJWohEO7sEgIK3iFalPgbyFJFVLab+ywbEA/MUE6Q8Zy7g210Y1hRR6QW8C
         JbkQ==
X-Gm-Message-State: AFqh2kq41I39VKkQXgQvU4I5EGzjmrLMceSql4fhotUhttaGUWinX+sE
        kbir/l1YTk8MF6YdapxOOmY=
X-Google-Smtp-Source: AMrXdXupavywksOzsGvJd+G6X2+bu6gHlKAHWmcHS/M09LcC+/A+TIPVjFvCTyKAFkaLD9KNgwB6Yw==
X-Received: by 2002:a05:6402:8cc:b0:499:8849:5fb2 with SMTP id d12-20020a05640208cc00b0049988495fb2mr3991753edz.28.1673265416050;
        Mon, 09 Jan 2023 03:56:56 -0800 (PST)
Received: from skbuf ([188.27.185.38])
        by smtp.gmail.com with ESMTPSA id g11-20020a056402428b00b004722d7e8c7csm3614118edc.14.2023.01.09.03.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 03:56:55 -0800 (PST)
Date:   Mon, 9 Jan 2023 13:56:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v5 net-next 01/15] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Message-ID: <20230109115653.6yjijaj63n2v35lw@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-2-tobias@waldekranz.com>
 <Y7vK4T18pOZ9KAKE@shredder>
 <20230109100236.euq7iaaorqxrun7u@skbuf>
 <Y7v98s8lC1WUvsSO@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7v98s8lC1WUvsSO@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 01:43:46PM +0200, Ido Schimmel wrote:
> OK, thanks for confirming. Will send a patch later this week if Tobias
> won't take care of it by then. First patch will probably be [1] to make
> sure we dump the correct MST state to user space. It will also make it
> easier to show the problem and validate the fix.
> 
> [1]
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 4f5098d33a46..f02a1ad589de 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -286,7 +286,7 @@ int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
>  	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
>  		return br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED);
>  	case BR_BOOLOPT_MST_ENABLE:
> -		return br_opt_get(br, BROPT_MST_ENABLED);
> +		return br_mst_is_enabled(br);

Well, this did report the correct MST state despite the incorrect static
branch state, no? The users of br_mst_is_enabled(br) are broken, not
those of br_opt_get(br, BROPT_MST_ENABLED).

Anyway, I see there's a br_mst_is_enabled() and also a br_mst_enabled()?!
One is used in the fast path and the other in the slow path. They should
probably be merged, I guess. They both exist probably because somebody
thought that the "if (!netif_is_bridge_master(dev))" test is redundant
in the fast path.

>  	default:
>  		/* shouldn't be called with unsupported options */
>  		WARN_ON(1);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 75aff9bbf17e..7f0475f62d45 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1827,7 +1827,7 @@ static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
>  /* br_mst.c */
>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>  DECLARE_STATIC_KEY_FALSE(br_mst_used);
> -static inline bool br_mst_is_enabled(struct net_bridge *br)
> +static inline bool br_mst_is_enabled(const struct net_bridge *br)
>  {
>  	return static_branch_unlikely(&br_mst_used) &&
>  		br_opt_get(br, BROPT_MST_ENABLED);
> @@ -1845,7 +1845,7 @@ int br_mst_fill_info(struct sk_buff *skb,
>  int br_mst_process(struct net_bridge_port *p, const struct nlattr *mst_attr,
>  		   struct netlink_ext_ack *extack);
>  #else
> -static inline bool br_mst_is_enabled(struct net_bridge *br)
> +static inline bool br_mst_is_enabled(const struct net_bridge *br)
>  {
>  	return false;
>  }
