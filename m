Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2064D2FA06A
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 13:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391839AbhARMvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 07:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404376AbhARMvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 07:51:10 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD27C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 04:50:29 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 91so16353804wrj.7
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 04:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yVlj6qMS5WE817KDmDiJ8EtuKvteOoLxnBjXit5gjgE=;
        b=ZTD4dmG99JjNkoxuXkJKhj8wThVWenIUScaquMtnKsojDD6ejn7geXx+qhEtrPRatB
         xO2iZ3XtqsUItt5HtbgNsCAa1EA/nS+yv0HQfc2QqjdNPxeN6XVvOR27qKiGsGsWu7Mm
         /B9ycK9UfEAKpmP0vytce7294X04nt8jTbIHJcwWx0kXSYvIa6tUD9204Ou1OIXY8Djt
         ZDX1R/hsk0+RN/KI91l3t9g6fplIgXFNRY+6uaHdmLV/hifD0OIsGWxDmWoljFt9vPzv
         Mu6gIGByR8ydaSyOG8zYIiyP6Umd1Z0JT1segJyKii0qE0SfvlLgT06sIPjNTw02mAgB
         qK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yVlj6qMS5WE817KDmDiJ8EtuKvteOoLxnBjXit5gjgE=;
        b=QlWBMiCswTyvK4fgaCUdIDFVDOZa6YYFNcLfVev2UuEk8JKl6ogVeG3x4m1wFlnWRT
         qmMkFINvai20Jnf2H4aGWpCx8f4c7IsY6qU58dMBYyKeUnpVWcbw9dd1TguHxZUTQPDQ
         nKGMrbd0JGksb7U18uCgiyD9enYoPoyOCSqEqfT/dpovy4s+9R9+lF/GUswP+jNzTU2b
         8pU5fQGe6/rw1VVey59hehTi/4R5PNbtCwSrsntus+npilIds8jqqi35Ymey8WOAKNON
         9FDKgB0tLORwkgtTPRsDhL+uYVepsoogDWFJKIe6oxI5yC87JbjuCCGwxYG30FGsRmrp
         dP/w==
X-Gm-Message-State: AOAM532c+3kaEaIeUSupRXE6E6/6b7b03yPXkqLvXU4c920EkfuWcjbB
        JQ2yFZeBuxXAyD0m+osxsmCYeA==
X-Google-Smtp-Source: ABdhPJzdApUi95b2y8F0oD1GqiMsI68I8DHfUlLdkrH36rpUtUaSaCUl4YYiS+vBnhRNI0PsvlNf+A==
X-Received: by 2002:a5d:5255:: with SMTP id k21mr23809435wrc.145.1610974227819;
        Mon, 18 Jan 2021 04:50:27 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id k1sm28876579wrn.46.2021.01.18.04.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 04:50:27 -0800 (PST)
Date:   Mon, 18 Jan 2021 13:50:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 02/10] devlink: implement line card
 provisioning
Message-ID: <20210118125026.GT3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-3-jiri@resnulli.us>
 <20210115160319.GC2064789@shredder.lan>
 <20210115165157.GO3565223@nanopsycho.orion>
 <20210115180944.GB2074023@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115180944.GB2074023@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 07:09:44PM CET, idosch@idosch.org wrote:
>On Fri, Jan 15, 2021 at 05:51:57PM +0100, Jiri Pirko wrote:
>> Fri, Jan 15, 2021 at 05:03:19PM CET, idosch@idosch.org wrote:
>> >On Wed, Jan 13, 2021 at 01:12:14PM +0100, Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> 
>> >> In order to be able to configure all needed stuff on a port/netdevice
>> >> of a line card without the line card being present, introduce line card
>> >> provisioning. Basically provisioning will create a placeholder for
>> >> instances (ports/netdevices) for a line card type.
>> >> 
>> >> Allow the user to query the supported line card types over line card
>> >> get command. Then implement two netlink commands to allow user to
>> >> provision/unprovision the line card with selected line card type.
>> >> 
>> >> On the driver API side, add provision/unprovision ops and supported
>> >> types array to be advertised. Upon provision op call, the driver should
>> >> take care of creating the instances for the particular line card type.
>> >> Introduce provision_set/clear() functions to be called by the driver
>> >> once the provisioning/unprovisioning is done on its side.
>> >> 
>> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> >> ---
>> >>  include/net/devlink.h        |  31 +++++++-
>> >>  include/uapi/linux/devlink.h |  17 +++++
>> >>  net/core/devlink.c           | 141 ++++++++++++++++++++++++++++++++++-
>> >>  3 files changed, 185 insertions(+), 4 deletions(-)
>> >> 
>> >> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> >> index 67c2547d5ef9..854abd53e9ea 100644
>> >> --- a/include/net/devlink.h
>> >> +++ b/include/net/devlink.h
>> >> @@ -139,10 +139,33 @@ struct devlink_port {
>> >>  	struct mutex reporters_lock; /* Protects reporter_list */
>> >>  };
>> >>  
>> >> +struct devlink_linecard_ops;
>> >> +
>> >>  struct devlink_linecard {
>> >>  	struct list_head list;
>> >>  	struct devlink *devlink;
>> >>  	unsigned int index;
>> >> +	const struct devlink_linecard_ops *ops;
>> >> +	void *priv;
>> >> +	enum devlink_linecard_state state;
>> >> +	const char *provisioned_type;
>> >> +};
>> >> +
>> >> +/**
>> >> + * struct devlink_linecard_ops - Linecard operations
>> >> + * @supported_types: array of supported types of linecards
>> >> + * @supported_types_count: number of elements in the array above
>> >> + * @provision: callback to provision the linecard slot with certain
>> >> + *	       type of linecard
>> >> + * @unprovision: callback to unprovision the linecard slot
>> >> + */
>> >> +struct devlink_linecard_ops {
>> >> +	const char **supported_types;
>> >> +	unsigned int supported_types_count;
>> >> +	int (*provision)(struct devlink_linecard *linecard, void *priv,
>> >> +			 u32 type_index, struct netlink_ext_ack *extack);
>> >> +	int (*unprovision)(struct devlink_linecard *linecard, void *priv,
>> >> +			   struct netlink_ext_ack *extack);
>> >>  };
>> >>  
>> >>  struct devlink_sb_pool_info {
>> >> @@ -1414,9 +1437,13 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
>> >>  				   u16 pf, bool external);
>> >>  void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
>> >>  				   u16 pf, u16 vf, bool external);
>> >> -struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
>> >> -						 unsigned int linecard_index);
>> >> +struct devlink_linecard *
>> >> +devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
>> >> +			const struct devlink_linecard_ops *ops, void *priv);
>> >>  void devlink_linecard_destroy(struct devlink_linecard *linecard);
>> >> +void devlink_linecard_provision_set(struct devlink_linecard *linecard,
>> >> +				    u32 type_index);
>> >> +void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
>> >>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>> >>  			u32 size, u16 ingress_pools_count,
>> >>  			u16 egress_pools_count, u16 ingress_tc_count,
>> >> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> >> index e5ed0522591f..4111ddcc000b 100644
>> >> --- a/include/uapi/linux/devlink.h
>> >> +++ b/include/uapi/linux/devlink.h
>> >> @@ -131,6 +131,9 @@ enum devlink_command {
>> >>  	DEVLINK_CMD_LINECARD_NEW,
>> >>  	DEVLINK_CMD_LINECARD_DEL,
>> >>  
>> >> +	DEVLINK_CMD_LINECARD_PROVISION,
>> >> +	DEVLINK_CMD_LINECARD_UNPROVISION,
>> >
>> >I do not really see the point in these two commands. Better extend
>> >DEVLINK_CMD_LINECARD_SET to carry these attributes.
>> 
>> Yeah, I was thinking about that. Not sure it is correct though. This is
>> single purpose command. It really does not change "an attribute" as the
>> "_SET" commands are usually doing. Consider extension of "_SET" by other
>> attributes. Then it looks wrong.
>
>It is setting the type of the linecard, which is an attribute of the
>linecard.

Hmm. Still, consider the async nature. Do you have any example of attr
set with async nature? I expect the attr to be set when cmd returns 0.
IDK. Does not feel correct...


>
>> 
>> 
>> >
>> >> +
>> >>  	/* add new commands above here */
>> >>  	__DEVLINK_CMD_MAX,
>> >>  	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>> >> @@ -329,6 +332,17 @@ enum devlink_reload_limit {
>> >>  
>> >>  #define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
>> >>  
>> >> +enum devlink_linecard_state {
>> >> +	DEVLINK_LINECARD_STATE_UNSPEC,
>> >> +	DEVLINK_LINECARD_STATE_UNPROVISIONED,
>> >> +	DEVLINK_LINECARD_STATE_UNPROVISIONING,
>> >> +	DEVLINK_LINECARD_STATE_PROVISIONING,
>> >
>> >Can you explain why these two states are necessary? Any reason the
>> >provision operation can't be synchronous? This is somewhat explained in
>> >patch #8, but it should really be explained here. Changelog says:
>> >
>> >"To avoid deadlock and to mimic actual HW flow, use workqueue
>> >to add/del ports during provisioning as the port add/del calls
>> >devlink_port_register/unregister() which take devlink mutex."
>> >
>> >The deadlock is not really a reason to have these states.
>> 
>> It is, need to avoid recursice locking
>> 
>> >'DEVLINK_CMD_PORT_SPLIT' also calls devlink_port_register() /
>> >devlink_port_unregister() and the deadlock is solved by:
>> >
>> >'internal_flags = DEVLINK_NL_FLAG_NO_LOCK'
>> 
>> Yeah, however, there, the port_index is passed down to the driver, not
>> the actual object pointer. That's why it can be done like that.
>> 
>> >
>> >A hardware flow the requires it is something else...
>> 
>> Hardware flow in case of Spectrum is async too.
>
>OK, so the changelog needs to state that these states are necessary
>because the nature of linecard provisioning is asynchronous.

Ok.


>
>> 
>> 
>> >
>> >> +	DEVLINK_LINECARD_STATE_PROVISIONED,
>> >> +
>> >> +	__DEVLINK_LINECARD_STATE_MAX,
>> >> +	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
>> >> +};
>> >> +
>> >>  enum devlink_attr {
>> >>  	/* don't change the order or add anything between, this is ABI! */
>> >>  	DEVLINK_ATTR_UNSPEC,
>> >> @@ -535,6 +549,9 @@ enum devlink_attr {
>> >>  	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
>> >>  
>> >>  	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
>> >> +	DEVLINK_ATTR_LINECARD_STATE,		/* u8 */
>> >> +	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>> >> +	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>> >>  
>> >>  	/* add new attributes above here, update the policy in devlink.c */
>> >>  
>> >> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >> index 564e921133cf..434eecc310c3 100644
>> >> --- a/net/core/devlink.c
>> >> +++ b/net/core/devlink.c
>> >> @@ -1192,7 +1192,9 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
>> >>  				    u32 seq, int flags,
>> >>  				    struct netlink_ext_ack *extack)
>> >>  {
>> >> +	struct nlattr *attr;
>> >>  	void *hdr;
>> >> +	int i;
>> >>  
>> >>  	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
>> >>  	if (!hdr)
>> >> @@ -1202,6 +1204,22 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
>> >>  		goto nla_put_failure;
>> >>  	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
>> >>  		goto nla_put_failure;
>> >> +	if (nla_put_u8(msg, DEVLINK_ATTR_LINECARD_STATE, linecard->state))
>> >> +		goto nla_put_failure;
>> >> +	if (linecard->state >= DEVLINK_LINECARD_STATE_PROVISIONED &&
>> >
>> >This assumes that every state added after provisioned should report the
>> >type. Better to check for the specific states
>> 
>> Yes, that is correct assumption.
>
>It is correct now, but what if tomorrow someone adds a new state? It
>can't be added before the provisioned state because it will break uapi.

Then this check will need to be changed...


>
>> 
>> 
>> >
>> >> +	    nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE,
>> >> +			   linecard->provisioned_type))
>> >> +		goto nla_put_failure;
