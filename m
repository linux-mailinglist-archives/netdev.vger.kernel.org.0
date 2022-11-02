Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3736161A7
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 12:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiKBLWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 07:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiKBLWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 07:22:14 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1190F23EB1
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 04:22:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id d26so44354451eje.10
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 04:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6ZOQ8ap65FDoZvGO4LbJzIKfcErn6tnfDue9+sjxaA=;
        b=nALBY/Szg03CdUX9J5scrrugMi/hc9QnWoTAnXvkmoASytzQT281v7s0zMTF8ZO7kf
         RDnwg+inWzrSIh3CInvQLuAek0/QN+JsJVwanstDXKFuyhf6Asb86yRdXQIXP/Fj16fJ
         vByF7/yFtNnAZtuCr7T6Z00nmMZUeALUUjm1W0NMkGCFc1qftyGCkphi89E8UaqIaw2I
         187EXhNhdHY6KotN+I9N2EG3stg9DedqyHds+SxqLOOjmbWOmwfWihC76IgrteeDscxh
         XbikYybiJ1ep3ILqKWbPqwLXxjLazKEXLUhERPf3JBAkbZwIr/RTSDEqNl7qwAAF87br
         HMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6ZOQ8ap65FDoZvGO4LbJzIKfcErn6tnfDue9+sjxaA=;
        b=emEOMKMqCtFWCZbJTQwaf9Q2Imb3UtQK6aauNjiDc+c1AJiTmS6sea5hrl6Z9MO6N8
         AReISyzkhpp6B/Fm+X61zSh+otXw5pp9mMB00OEwoBjvYQ7j8IbIUzsmSgH2z47zdrwZ
         8Zn/14dwk54rf0XDiryYtxnnlIV1wYfF9l9lXUygPSdwNpGTYZLLtz9OiKJsqrjsIB9x
         12aW2mPfHiuF8N4uzYhpCFnsez+WpBMJC1WA3Yx3lfWzSdxrA1Vnd3MDqCBABcXMJcry
         JCNgqeT5iL2yjeu7WFjxdj+nyD4ec0dZk8Q1yQ9uUbBtXhq6PzQQKcYp07y2//cxw255
         VcCw==
X-Gm-Message-State: ACrzQf3ScJ5CZuqq083LXl1McqPKdetTja0dfzxEp7S50Q0lClOXmluc
        7DBv6iycURwa/PeMT9YXgz07KQ==
X-Google-Smtp-Source: AMsMyM7xgRR5ZW68+lq+XTwTqMPRnANhKpdviiN5PNrXqBQztSB1zPQQ8pZI9KrZVvMcclFHbdg8eA==
X-Received: by 2002:a17:907:8a23:b0:78d:b042:eece with SMTP id sc35-20020a1709078a2300b0078db042eecemr22318651ejc.494.1667388131591;
        Wed, 02 Nov 2022 04:22:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h8-20020a17090634c800b00731582babcasm5389428ejb.71.2022.11.02.04.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 04:22:10 -0700 (PDT)
Date:   Wed, 2 Nov 2022 12:22:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over rtnetlink
Message-ID: <Y2JS4bBhPB1qbDi9@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
 <20221031124248.484405-14-jiri@resnulli.us>
 <20221101091834.4dbdcbc1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101091834.4dbdcbc1@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 01, 2022 at 05:18:34PM CET, kuba@kernel.org wrote:
>On Mon, 31 Oct 2022 13:42:48 +0100 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Expose devlink port handle related to netdev over rtnetlink. Introduce a
>> new nested IFLA attribute to carry the info. Call into devlink code to
>> fill-up the nest with existing devlink attributes that are used over
>> devlink netlink.
>
>> +int devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port)
>> +{
>> +	if (devlink_nl_put_handle(msg, devlink_port->devlink))
>> +		return -EMSGSIZE;
>> +	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
>> +		return -EMSGSIZE;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_nl_port_handle_fill);
>> +
>> +size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
>> +{
>> +	struct devlink *devlink = devlink_port->devlink;
>> +
>> +	return nla_total_size(strlen(devlink->dev->bus->name) + 1) /* DEVLINK_ATTR_BUS_NAME */
>> +	     + nla_total_size(strlen(dev_name(devlink->dev)) + 1) /* DEVLINK_ATTR_DEV_NAME */
>> +	     + nla_total_size(4); /* DEVLINK_ATTR_PORT_INDEX */
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_nl_port_handle_size);
>
>Why the exports? devlink is a boolean now IIRC.

Right, removed.


>
>> +static int rtnl_fill_devlink_port(struct sk_buff *skb,
>> +				  const struct net_device *dev)
>> +{
>> +	struct nlattr *devlink_port_nest;
>> +	int ret;
>> +
>> +	devlink_port_nest = nla_nest_start(skb, IFLA_DEVLINK_PORT);
>> +	if (!devlink_port_nest)
>> +		return -EMSGSIZE;
>> +
>> +	if (dev->devlink_port) {
>
>Why produce the empty nest if port is not set?

Empty nest indicates that kernel supports this but there is no devlink
port associated. I see no other way to indicate this :/


>
>> +		ret = devlink_nl_port_handle_fill(skb, dev->devlink_port);
>> +		if (ret < 0)
>> +			goto nest_cancel;
>> +	}
>> +
>> +	nla_nest_end(skb, devlink_port_nest);
>> +	return 0;
>> +
>> +nest_cancel:
>> +	nla_nest_cancel(skb, devlink_port_nest);
>> +	return ret;
>> +}
