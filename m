Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83EF1B26F7
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgDUM7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728934AbgDUM7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:59:22 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199BDC061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:59:22 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k6so249244iob.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kjVfvkObV5FaItY8HdtH4yOrMBWrZntlHSNTkrUVjys=;
        b=gvTgOdB/djPxIlvNo++Y5A+erqzJzKVVnFv8jdo+fAutMT8MsA4dJNM7RodvGCLtq2
         7MnOCOF26I32en/wv4/NNdt/zRYIkwVgqrj6CpvQRZo/TkzAdDOkhfON1vOMhLWnsu9Y
         m4GWcm2taxZyOEAoYkaXe2QHeR+MXI2ajWaRgQC7QExyAKhUnCAOJ/aKeOeP1WXBOqf9
         9+MEC/dY93GrYh7Bc10mYWbL2gOgU0EaHZJAEjnS394j4IZMIfG63uhUMeZ2JzQjPO/m
         JYZh7V/YhOcBt/KHRm6WsGVcOOUz+hUJxmEhnXeJ+eewZ38x/NfTg6eP9f/8nSPvmNtg
         RskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kjVfvkObV5FaItY8HdtH4yOrMBWrZntlHSNTkrUVjys=;
        b=H74i4jHtyCBnSIdyp8UNNLB+J+5C/iNzewy6jYZimdxG1Kev3cZ0v/PzcPaiA+sfGZ
         vkEjchW4Zbu4YAuggrFdF6U0+HISPw0Xybz6UwPEjl8Vb4gWeK/xnbGAYYVdQY61JlLD
         4J2+gneIzr+T1NfVssRF5Zf8dw2CalxGGuLkbpbwKb+cxiu7Hfsr/AVQmsbeDiDZRehh
         aPRyqQ9cV8EYgTTVZHwlKIq2WfcdorpwucYT8oBaMTz7du+NT9thRfdjEvSA6Qn90XJD
         PfWEgdcP+IM8X2F2Hc6GwcPZ3AWbZHvTM4ds/8WeGY2Q499ciMj6A1bpWepXDjVIcunM
         eEqQ==
X-Gm-Message-State: AGi0PuaH4mK4gfLcqmzNHSLB1aScFP2yY50TVQObOdtZpxkM3qDa9fXy
        6F83ufKGLh6xwAHD8kNqhKk=
X-Google-Smtp-Source: APiQypJW82V7wVQsOP+A6dgB73hhSlIWObNUMHrmYBlpCUvGHcC2Dl8voI8pt7NwYByr4uTL378ZvQ==
X-Received: by 2002:a5d:91c1:: with SMTP id k1mr19582923ior.8.1587473961387;
        Tue, 21 Apr 2020 05:59:21 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id j5sm719587iom.22.2020.04.21.05.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 05:59:20 -0700 (PDT)
Subject: Re: [PATCH bpf-next 06/16] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-7-dsahern@kernel.org> <87d0819m7u.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <aa39f863-a833-0f57-d09f-8bd1d0259123@gmail.com>
Date:   Tue, 21 Apr 2020 06:59:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87d0819m7u.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/20 4:17 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> From: David Ahern <dahern@digitalocean.com>
>>
>> Running programs in the egress path, on skbs or xdp_frames, does not
>> require driver specific resources like Rx path. Accordingly, the
>> programs can be run in core code, so add xdp_egress_prog to net_device
>> to hold a reference to an attached program.
>>
>> For UAPI, add IFLA_XDP_EGRESS to if_link.h to specify egress programs,
>> add a new attach flag, XDP_ATTACHED_EGRESS_CORE, to denote the
>> attach point is at the core level (as opposed to driver or hardware)
>> and add IFLA_XDP_EGRESS_CORE_PROG_ID for reporting the program id.
>>
>> Add egress argument to do_setlink_xdp to denote processing of
>> IFLA_XDP_EGRESS versus IFLA_XDP, and add a check that none of the
>> existing modes (SKB, DRV or HW) are set since those modes are not
>> valid. The expectation is that XDP_FLAGS_HW_MODE will be used later
>> (e.g., offloading guest programs).
>>
>> Add rtnl_xdp_egress_fill and helpers as the egress counterpart to the
>> existing rtnl_xdp_fill.
>>
>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>> ---
>>  include/linux/netdevice.h          |  1 +
>>  include/uapi/linux/if_link.h       |  3 +
>>  net/core/rtnetlink.c               | 96 ++++++++++++++++++++++++++++--
>>  tools/include/uapi/linux/if_link.h |  3 +
>>  4 files changed, 99 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index d0bb9e09660a..3133247681fd 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -1995,6 +1995,7 @@ struct net_device {
>>  	unsigned int		real_num_rx_queues;
>>  
>>  	struct bpf_prog __rcu	*xdp_prog;
>> +	struct bpf_prog __rcu	*xdp_egress_prog;
>>  	unsigned long		gro_flush_timeout;
>>  	rx_handler_func_t __rcu	*rx_handler;
>>  	void __rcu		*rx_handler_data;
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index 127c704eeba9..b3c6cb2f0f0a 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -170,6 +170,7 @@ enum {
>>  	IFLA_PROP_LIST,
>>  	IFLA_ALT_IFNAME, /* Alternative ifname */
>>  	IFLA_PERM_ADDRESS,
>> +	IFLA_XDP_EGRESS, /* nested attribute with 1 or more IFLA_XDP_ attrs */
>>  	__IFLA_MAX
>>  };
>>  
>> @@ -988,6 +989,7 @@ enum {
>>  	XDP_ATTACHED_SKB,
>>  	XDP_ATTACHED_HW,
>>  	XDP_ATTACHED_MULTI,
>> +	XDP_ATTACHED_EGRESS_CORE,
>>  };
>>  
>>  enum {
>> @@ -1000,6 +1002,7 @@ enum {
>>  	IFLA_XDP_SKB_PROG_ID,
>>  	IFLA_XDP_HW_PROG_ID,
>>  	IFLA_XDP_EXPECTED_FD,
>> +	IFLA_XDP_EGRESS_CORE_PROG_ID,
>>  	__IFLA_XDP_MAX,
>>  };
>>  
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index dc44af16226a..e9bc5cee06c8 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -1030,7 +1030,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
>>  	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_PORT_ID */
>>  	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_SWITCH_ID */
>>  	       + nla_total_size(IFNAMSIZ) /* IFLA_PHYS_PORT_NAME */
>> -	       + rtnl_xdp_size() /* IFLA_XDP */
>> +	       + rtnl_xdp_size() * 2 /* IFLA_XDP and IFLA_XDP_EGRESS */
>>  	       + nla_total_size(4)  /* IFLA_EVENT */
>>  	       + nla_total_size(4)  /* IFLA_NEW_NETNSID */
>>  	       + nla_total_size(4)  /* IFLA_NEW_IFINDEX */
>> @@ -1395,6 +1395,42 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
>>  	return 0;
>>  }
>>  
>> +static u32 rtnl_xdp_egress_prog(struct net_device *dev)
>> +{
>> +	const struct bpf_prog *prog;
>> +
>> +	ASSERT_RTNL();
>> +
>> +	prog = rtnl_dereference(dev->xdp_egress_prog);
>> +	if (!prog)
>> +		return 0;
>> +	return prog->aux->id;
>> +}
>> +
>> +static int rtnl_xdp_egress_report(struct sk_buff *skb, struct net_device *dev,
>> +				  u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
>> +				  u32 (*get_prog_id)(struct net_device *dev))
>> +{
>> +	u32 curr_id;
>> +	int err;
>> +
>> +	curr_id = get_prog_id(dev);
>> +	if (!curr_id)
>> +		return 0;
>> +
>> +	*prog_id = curr_id;
>> +	err = nla_put_u32(skb, attr, curr_id);
>> +	if (err)
>> +		return err;
>> +
>> +	if (*mode != XDP_ATTACHED_NONE)
>> +		*mode = XDP_ATTACHED_MULTI;
>> +	else
>> +		*mode = tgt_mode;
>> +
>> +	return 0;
>> +}
>> +
>>  static u32 rtnl_xdp_prog_skb(struct net_device *dev)
>>  {
>>  	const struct bpf_prog *generic_xdp_prog;
>> @@ -1486,6 +1522,42 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
>>  	return err;
>>  }
>>  
>> +static int rtnl_xdp_egress_fill(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +	u8 mode = XDP_ATTACHED_NONE;
>> +	struct nlattr *xdp;
>> +	u32 prog_id = 0;
>> +	int err;
>> +
>> +	xdp = nla_nest_start_noflag(skb, IFLA_XDP_EGRESS);
>> +	if (!xdp)
>> +		return -EMSGSIZE;
>> +
>> +	err = rtnl_xdp_egress_report(skb, dev, &prog_id, &mode,
>> +				     XDP_ATTACHED_EGRESS_CORE,
>> +				     IFLA_XDP_EGRESS_CORE_PROG_ID,
>> +				     rtnl_xdp_egress_prog);
>> +	if (err)
>> +		goto err_cancel;
>> +
>> +	err = nla_put_u8(skb, IFLA_XDP_ATTACHED, mode);
>> +	if (err)
>> +		goto err_cancel;
>> +
>> +	if (prog_id && mode != XDP_ATTACHED_MULTI) {
>> +		err = nla_put_u32(skb, IFLA_XDP_PROG_ID, prog_id);
>> +		if (err)
>> +			goto err_cancel;
>> +	}
>> +
>> +	nla_nest_end(skb, xdp);
>> +	return 0;
>> +
>> +err_cancel:
>> +	nla_nest_cancel(skb, xdp);
>> +	return err;
>> +}
>> +
>>  static u32 rtnl_get_event(unsigned long event)
>>  {
>>  	u32 rtnl_event_type = IFLA_EVENT_NONE;
>> @@ -1743,6 +1815,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>>  	if (rtnl_xdp_fill(skb, dev))
>>  		goto nla_put_failure;
>>  
>> +	if (rtnl_xdp_egress_fill(skb, dev))
>> +		goto nla_put_failure;
>> +
>>  	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
>>  		if (rtnl_link_fill(skb, dev) < 0)
>>  			goto nla_put_failure;
>> @@ -1827,6 +1902,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>>  	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
>>  				    .len = ALTIFNAMSIZ - 1 },
>>  	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
>> +	[IFLA_XDP_EGRESS]	= { .type = NLA_NESTED },
>>  };
>>  
>>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
>> @@ -2482,7 +2558,8 @@ static int do_set_master(struct net_device *dev, int ifindex,
>>  #define DO_SETLINK_NOTIFY	0x03
>>  
>>  static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
>> -			  int *status, struct netlink_ext_ack *extack)
>> +			  int *status, bool egress,
>> +			  struct netlink_ext_ack *extack)
>>  {
>>  	struct nlattr *xdp[IFLA_XDP_MAX + 1];
>>  	u32 xdp_flags = 0;
>> @@ -2498,6 +2575,10 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
>>  
>>  	if (xdp[IFLA_XDP_FLAGS]) {
>>  		xdp_flags = nla_get_u32(xdp[IFLA_XDP_FLAGS]);
>> +		if (egress && xdp_flags & XDP_FLAGS_MODES) {
>> +			NL_SET_ERR_MSG(extack, "XDP_FLAGS_MODES not valid for egress");
>> +			goto out_einval;
>> +		}
>>  		if (xdp_flags & ~XDP_FLAGS_MASK)
>>  			goto out_einval;
>>  		if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1)
>> @@ -2515,7 +2596,7 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
>>  
>>  		err = dev_change_xdp_fd(dev, extack,
>>  					nla_get_s32(xdp[IFLA_XDP_FD]),
>> -					expected_fd, xdp_flags, false);
>> +					expected_fd, xdp_flags, egress);
>>  		if (err)
>>  			return err;
>>  
>> @@ -2821,7 +2902,14 @@ static int do_setlink(const struct sk_buff *skb,
>>  	}
>>  
>>  	if (tb[IFLA_XDP]) {
>> -		err = do_setlink_xdp(dev, tb[IFLA_XDP], &status, extack);
>> +		err = do_setlink_xdp(dev, tb[IFLA_XDP], &status, false, extack);
>> +		if (err)
>> +			goto errout;
>> +	}
>> +
>> +	if (tb[IFLA_XDP_EGRESS]) {
>> +		err = do_setlink_xdp(dev, tb[IFLA_XDP_EGRESS], &status, true,
>> +				     extack);
>>  		if (err)
>>  			goto errout;
>>  	}
> 
> This means that IFLA_XDP and IFLA_XDP_EGRESS can be present in the same
> netlink message, right? But then installation of the RX program could
> succeed, but userspace would still get an error if the egress program
> installation fails? That is probably not good?

That's a good catch.

> 
> Since I don't think we can atomically make sure both operations fail or
> succeed, maybe it's better to disallow both entries being present in the
> same netlink message?
> 

I think so since there is no way to undo the setlink for IFLA_XDP if
IFLA_XDP_EGRESS fails - exisitng program references are gone.

Although, existing do_setlink leaves the device in an incomplete state
on any failure...
