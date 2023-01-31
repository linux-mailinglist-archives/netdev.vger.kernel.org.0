Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DFD682BDB
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjAaLvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjAaLvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:51:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFB7CDF6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69A196147C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FE8C433EF;
        Tue, 31 Jan 2023 11:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675165911;
        bh=mdwIEHXz48ciN4NgiNy9rwuG58UZqXAu/Y6NNH6H6Nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NiYqdXjIl1NOgOZq+Mttt1QwNpn8RonV/ApHhx4GeZ72XuildDejlX8AiRLtFNM6/
         4Xnt970sZ3Q0G/t9kbfhMe57nv+Hua8rvyKr2P1ZHCP5AChlLau0dESdgdDNnQbJBd
         aF+QhPoi7uea+DpmxZ8GZMXusmOoKnA9bEhe+lRjfL34VeIM+NPdBDeDeur6RxdzwQ
         2gJoMua+Q1e63WdTs0OmhY98LXaczed5waVTsE0SEFHU3KtGGpcMhaEfIB3VTjcJfn
         xY6AiRE8ZkI9F/W4l5VZlfFIIWipZyKt3ulndcVVQiFWJsXfOx8BFzac4gt/dZrJnm
         gknnv2NOc0gqQ==
Date:   Tue, 31 Jan 2023 13:51:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 2/3] devlink: remove "gen" from struct
 devlink_gen_cmd name
Message-ID: <Y9kA01okvtKYLDZ2@unreal>
References: <20230131090613.2131740-1-jiri@resnulli.us>
 <20230131090613.2131740-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131090613.2131740-3-jiri@resnulli.us>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 10:06:12AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> No need to have "gen" inside name of the structure for devlink commands.
> Remove it.

And what about devl_gen_* names? Should they be renamed too?

Thanks

> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  net/devlink/devl_internal.h | 36 ++++++++++++++++++------------------
>  net/devlink/leftover.c      | 32 ++++++++++++++++----------------
>  net/devlink/netlink.c       |  4 ++--
>  3 files changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index dd4366c68b96..3910db5547fe 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -115,7 +115,7 @@ struct devlink_nl_dump_state {
>  	};
>  };
>  
> -struct devlink_gen_cmd {
> +struct devlink_cmd {
>  	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
>  			struct netlink_callback *cb);
>  };
> @@ -139,22 +139,22 @@ devlink_dump_state(struct netlink_callback *cb)
>  	return (struct devlink_nl_dump_state *)cb->ctx;
>  }
>  
> -/* gen cmds */
> -extern const struct devlink_gen_cmd devl_gen_inst;
> -extern const struct devlink_gen_cmd devl_gen_port;
> -extern const struct devlink_gen_cmd devl_gen_sb;
> -extern const struct devlink_gen_cmd devl_gen_sb_pool;
> -extern const struct devlink_gen_cmd devl_gen_sb_port_pool;
> -extern const struct devlink_gen_cmd devl_gen_sb_tc_pool_bind;
> -extern const struct devlink_gen_cmd devl_gen_selftests;
> -extern const struct devlink_gen_cmd devl_gen_param;
> -extern const struct devlink_gen_cmd devl_gen_region;
> -extern const struct devlink_gen_cmd devl_gen_info;
> -extern const struct devlink_gen_cmd devl_gen_health_reporter;
> -extern const struct devlink_gen_cmd devl_gen_trap;
> -extern const struct devlink_gen_cmd devl_gen_trap_group;
> -extern const struct devlink_gen_cmd devl_gen_trap_policer;
> -extern const struct devlink_gen_cmd devl_gen_linecard;
> +/* Commands */
> +extern const struct devlink_cmd devl_gen_inst;
> +extern const struct devlink_cmd devl_gen_port;
> +extern const struct devlink_cmd devl_gen_sb;
> +extern const struct devlink_cmd devl_gen_sb_pool;
> +extern const struct devlink_cmd devl_gen_sb_port_pool;
> +extern const struct devlink_cmd devl_gen_sb_tc_pool_bind;
> +extern const struct devlink_cmd devl_gen_selftests;
> +extern const struct devlink_cmd devl_gen_param;
> +extern const struct devlink_cmd devl_gen_region;
> +extern const struct devlink_cmd devl_gen_info;
> +extern const struct devlink_cmd devl_gen_health_reporter;
> +extern const struct devlink_cmd devl_gen_trap;
> +extern const struct devlink_cmd devl_gen_trap_group;
> +extern const struct devlink_cmd devl_gen_trap_policer;
> +extern const struct devlink_cmd devl_gen_linecard;
>  
>  /* Ports */
>  int devlink_port_netdevice_event(struct notifier_block *nb,
> @@ -182,7 +182,7 @@ struct devlink_linecard *
>  devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
>  
>  /* Rates */
> -extern const struct devlink_gen_cmd devl_gen_rate_get;
> +extern const struct devlink_cmd devl_gen_rate_get;
>  
>  struct devlink_rate *
>  devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 1461eec423ff..16cb5975de1a 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -1236,7 +1236,7 @@ devlink_nl_cmd_rate_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_rate_get = {
> +const struct devlink_cmd devl_gen_rate_get = {
>  	.dump_one		= devlink_nl_cmd_rate_get_dump_one,
>  };
>  
> @@ -1303,7 +1303,7 @@ devlink_nl_cmd_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  			       cb->nlh->nlmsg_seq, NLM_F_MULTI);
>  }
>  
> -const struct devlink_gen_cmd devl_gen_inst = {
> +const struct devlink_cmd devl_gen_inst = {
>  	.dump_one		= devlink_nl_cmd_get_dump_one,
>  };
>  
> @@ -1359,7 +1359,7 @@ devlink_nl_cmd_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_port = {
> +const struct devlink_cmd devl_gen_port = {
>  	.dump_one		= devlink_nl_cmd_port_get_dump_one,
>  };
>  
> @@ -2137,7 +2137,7 @@ static int devlink_nl_cmd_linecard_get_dump_one(struct sk_buff *msg,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_linecard = {
> +const struct devlink_cmd devl_gen_linecard = {
>  	.dump_one		= devlink_nl_cmd_linecard_get_dump_one,
>  };
>  
> @@ -2392,7 +2392,7 @@ devlink_nl_cmd_sb_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_sb = {
> +const struct devlink_cmd devl_gen_sb = {
>  	.dump_one		= devlink_nl_cmd_sb_get_dump_one,
>  };
>  
> @@ -2530,7 +2530,7 @@ devlink_nl_cmd_sb_pool_get_dump_one(struct sk_buff *msg,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_sb_pool = {
> +const struct devlink_cmd devl_gen_sb_pool = {
>  	.dump_one		= devlink_nl_cmd_sb_pool_get_dump_one,
>  };
>  
> @@ -2738,7 +2738,7 @@ devlink_nl_cmd_sb_port_pool_get_dump_one(struct sk_buff *msg,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_sb_port_pool = {
> +const struct devlink_cmd devl_gen_sb_port_pool = {
>  	.dump_one		= devlink_nl_cmd_sb_port_pool_get_dump_one,
>  };
>  
> @@ -2973,7 +2973,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dump_one(struct sk_buff *msg,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_sb_tc_pool_bind = {
> +const struct devlink_cmd devl_gen_sb_tc_pool_bind = {
>  	.dump_one		= devlink_nl_cmd_sb_tc_pool_bind_get_dump_one,
>  };
>  
> @@ -4785,7 +4785,7 @@ devlink_nl_cmd_selftests_get_dump_one(struct sk_buff *msg,
>  					 cb->extack);
>  }
>  
> -const struct devlink_gen_cmd devl_gen_selftests = {
> +const struct devlink_cmd devl_gen_selftests = {
>  	.dump_one		= devlink_nl_cmd_selftests_get_dump_one,
>  };
>  
> @@ -5271,7 +5271,7 @@ devlink_nl_cmd_param_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_param = {
> +const struct devlink_cmd devl_gen_param = {
>  	.dump_one		= devlink_nl_cmd_param_get_dump_one,
>  };
>  
> @@ -5978,7 +5978,7 @@ devlink_nl_cmd_region_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  	return 0;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_region = {
> +const struct devlink_cmd devl_gen_region = {
>  	.dump_one		= devlink_nl_cmd_region_get_dump_one,
>  };
>  
> @@ -6625,7 +6625,7 @@ devlink_nl_cmd_info_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_info = {
> +const struct devlink_cmd devl_gen_info = {
>  	.dump_one		= devlink_nl_cmd_info_get_dump_one,
>  };
>  
> @@ -7793,7 +7793,7 @@ devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
>  	return 0;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_health_reporter = {
> +const struct devlink_cmd devl_gen_health_reporter = {
>  	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
>  };
>  
> @@ -8311,7 +8311,7 @@ devlink_nl_cmd_trap_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_trap = {
> +const struct devlink_cmd devl_gen_trap = {
>  	.dump_one		= devlink_nl_cmd_trap_get_dump_one,
>  };
>  
> @@ -8524,7 +8524,7 @@ devlink_nl_cmd_trap_group_get_dump_one(struct sk_buff *msg,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_trap_group = {
> +const struct devlink_cmd devl_gen_trap_group = {
>  	.dump_one		= devlink_nl_cmd_trap_group_get_dump_one,
>  };
>  
> @@ -8817,7 +8817,7 @@ devlink_nl_cmd_trap_policer_get_dump_one(struct sk_buff *msg,
>  	return err;
>  }
>  
> -const struct devlink_gen_cmd devl_gen_trap_policer = {
> +const struct devlink_cmd devl_gen_trap_policer = {
>  	.dump_one		= devlink_nl_cmd_trap_policer_get_dump_one,
>  };
>  
> diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
> index 11666edf5cd2..33ed3984f3cb 100644
> --- a/net/devlink/netlink.c
> +++ b/net/devlink/netlink.c
> @@ -177,7 +177,7 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
>  	devlink_put(devlink);
>  }
>  
> -static const struct devlink_gen_cmd *devl_gen_cmds[] = {
> +static const struct devlink_cmd *devl_gen_cmds[] = {
>  	[DEVLINK_CMD_GET]		= &devl_gen_inst,
>  	[DEVLINK_CMD_PORT_GET]		= &devl_gen_port,
>  	[DEVLINK_CMD_SB_GET]		= &devl_gen_sb,
> @@ -201,7 +201,7 @@ int devlink_nl_instance_iter_dumpit(struct sk_buff *msg,
>  {
>  	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
>  	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
> -	const struct devlink_gen_cmd *cmd;
> +	const struct devlink_cmd *cmd;
>  	struct devlink *devlink;
>  	int err = 0;
>  
> -- 
> 2.39.0
> 
