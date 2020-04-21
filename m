Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13671B27CB
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgDUN2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:28:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44015 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726018AbgDUN2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587475682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FaBleP7ZtTkdctw89M5D8b1sQ+2K7CSAlP0ftyn9KA0=;
        b=B987zTetlltlEuJfrYm5rpVqAVFnl2JU+TfQI8kZBpIzz0OcHFZMgDOx0OzS+jzCjEJoSt
        UhcLjSRfkaGOS0IZ/RJyhMvTnS17LLgiKjW3TjcGyeOs/cdF6vOPk0jLWXy3XzuBuPAZE3
        RDDSx512K5cM+mmhT1NewvteAuLQB/M=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-_W0SR1ngMcqYKwI2BBUO8Q-1; Tue, 21 Apr 2020 09:28:01 -0400
X-MC-Unique: _W0SR1ngMcqYKwI2BBUO8Q-1
Received: by mail-lj1-f198.google.com with SMTP id d25so2019672ljo.4
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FaBleP7ZtTkdctw89M5D8b1sQ+2K7CSAlP0ftyn9KA0=;
        b=AX04sIL++t2+61ZM6tFrtA9Wka6GdOjP8b8ZJ6XagLUKGw6RENJYP5hlvGr0DjG33q
         Vd5+OYSjWRHCynphoh+2837YGPij6s1Q/D1OIhI62XbYplXoHlWWtpLcSmTawVw3zQYI
         izkNupEXaB1a6RdWhMLdpbdLI9xbEzJsCXXfjH+0K0DFPwvE4UqES3mWyv915l6xc8Ji
         ntldEggZi8a0nHa3+OavLQq3w36sQjhS6zoF6f8uAoTu+kU0D712Ltm7Iu5vpFbPLttm
         S8acl7egQW+8uEY/Gm6o4zT6pBmGeXZBKvUbMvObx3b6cK/QicJYDdbJ+jg7QVXP2+Je
         TF0w==
X-Gm-Message-State: AGi0PuZLe2Gg5HAoThMyT7A6ock4luoAUURar1iAlchPX2mSLJyc5QgI
        3F9x26hUAFFH0Tr0xQpL460NY+k3KnH3VJln3QYGikls8+G2eQ//azNHcSFDriz0urAwWvd3buw
        FNJ/NWAlxtnlRGAKa
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr13557543lji.44.1587475677890;
        Tue, 21 Apr 2020 06:27:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypLU7hJ2IzBltyS4w+aQn9NOPe8rw4JVYhLyJpsbxH45FLLkFztnoth/CdBApal/wzp54MPBww==
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr13557518lji.44.1587475677573;
        Tue, 21 Apr 2020 06:27:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l8sm1915129ljo.5.2020.04.21.06.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:27:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3C51D18157F; Tue, 21 Apr 2020 15:27:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 06/16] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <aa39f863-a833-0f57-d09f-8bd1d0259123@gmail.com>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-7-dsahern@kernel.org> <87d0819m7u.fsf@toke.dk> <aa39f863-a833-0f57-d09f-8bd1d0259123@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Apr 2020 15:27:56 +0200
Message-ID: <87mu757yub.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/21/20 4:17 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@kernel.org> writes:
>>=20
>>> From: David Ahern <dahern@digitalocean.com>
>>>
>>> Running programs in the egress path, on skbs or xdp_frames, does not
>>> require driver specific resources like Rx path. Accordingly, the
>>> programs can be run in core code, so add xdp_egress_prog to net_device
>>> to hold a reference to an attached program.
>>>
>>> For UAPI, add IFLA_XDP_EGRESS to if_link.h to specify egress programs,
>>> add a new attach flag, XDP_ATTACHED_EGRESS_CORE, to denote the
>>> attach point is at the core level (as opposed to driver or hardware)
>>> and add IFLA_XDP_EGRESS_CORE_PROG_ID for reporting the program id.
>>>
>>> Add egress argument to do_setlink_xdp to denote processing of
>>> IFLA_XDP_EGRESS versus IFLA_XDP, and add a check that none of the
>>> existing modes (SKB, DRV or HW) are set since those modes are not
>>> valid. The expectation is that XDP_FLAGS_HW_MODE will be used later
>>> (e.g., offloading guest programs).
>>>
>>> Add rtnl_xdp_egress_fill and helpers as the egress counterpart to the
>>> existing rtnl_xdp_fill.
>>>
>>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>>> ---
>>>  include/linux/netdevice.h          |  1 +
>>>  include/uapi/linux/if_link.h       |  3 +
>>>  net/core/rtnetlink.c               | 96 ++++++++++++++++++++++++++++--
>>>  tools/include/uapi/linux/if_link.h |  3 +
>>>  4 files changed, 99 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index d0bb9e09660a..3133247681fd 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>>> @@ -1995,6 +1995,7 @@ struct net_device {
>>>  	unsigned int		real_num_rx_queues;
>>>=20=20
>>>  	struct bpf_prog __rcu	*xdp_prog;
>>> +	struct bpf_prog __rcu	*xdp_egress_prog;
>>>  	unsigned long		gro_flush_timeout;
>>>  	rx_handler_func_t __rcu	*rx_handler;
>>>  	void __rcu		*rx_handler_data;
>>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>>> index 127c704eeba9..b3c6cb2f0f0a 100644
>>> --- a/include/uapi/linux/if_link.h
>>> +++ b/include/uapi/linux/if_link.h
>>> @@ -170,6 +170,7 @@ enum {
>>>  	IFLA_PROP_LIST,
>>>  	IFLA_ALT_IFNAME, /* Alternative ifname */
>>>  	IFLA_PERM_ADDRESS,
>>> +	IFLA_XDP_EGRESS, /* nested attribute with 1 or more IFLA_XDP_ attrs */
>>>  	__IFLA_MAX
>>>  };
>>>=20=20
>>> @@ -988,6 +989,7 @@ enum {
>>>  	XDP_ATTACHED_SKB,
>>>  	XDP_ATTACHED_HW,
>>>  	XDP_ATTACHED_MULTI,
>>> +	XDP_ATTACHED_EGRESS_CORE,
>>>  };
>>>=20=20
>>>  enum {
>>> @@ -1000,6 +1002,7 @@ enum {
>>>  	IFLA_XDP_SKB_PROG_ID,
>>>  	IFLA_XDP_HW_PROG_ID,
>>>  	IFLA_XDP_EXPECTED_FD,
>>> +	IFLA_XDP_EGRESS_CORE_PROG_ID,
>>>  	__IFLA_XDP_MAX,
>>>  };
>>>=20=20
>>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>>> index dc44af16226a..e9bc5cee06c8 100644
>>> --- a/net/core/rtnetlink.c
>>> +++ b/net/core/rtnetlink.c
>>> @@ -1030,7 +1030,7 @@ static noinline size_t if_nlmsg_size(const struct=
 net_device *dev,
>>>  	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_PORT_ID */
>>>  	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_SWITCH_ID =
*/
>>>  	       + nla_total_size(IFNAMSIZ) /* IFLA_PHYS_PORT_NAME */
>>> -	       + rtnl_xdp_size() /* IFLA_XDP */
>>> +	       + rtnl_xdp_size() * 2 /* IFLA_XDP and IFLA_XDP_EGRESS */
>>>  	       + nla_total_size(4)  /* IFLA_EVENT */
>>>  	       + nla_total_size(4)  /* IFLA_NEW_NETNSID */
>>>  	       + nla_total_size(4)  /* IFLA_NEW_IFINDEX */
>>> @@ -1395,6 +1395,42 @@ static int rtnl_fill_link_ifmap(struct sk_buff *=
skb, struct net_device *dev)
>>>  	return 0;
>>>  }
>>>=20=20
>>> +static u32 rtnl_xdp_egress_prog(struct net_device *dev)
>>> +{
>>> +	const struct bpf_prog *prog;
>>> +
>>> +	ASSERT_RTNL();
>>> +
>>> +	prog =3D rtnl_dereference(dev->xdp_egress_prog);
>>> +	if (!prog)
>>> +		return 0;
>>> +	return prog->aux->id;
>>> +}
>>> +
>>> +static int rtnl_xdp_egress_report(struct sk_buff *skb, struct net_devi=
ce *dev,
>>> +				  u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
>>> +				  u32 (*get_prog_id)(struct net_device *dev))
>>> +{
>>> +	u32 curr_id;
>>> +	int err;
>>> +
>>> +	curr_id =3D get_prog_id(dev);
>>> +	if (!curr_id)
>>> +		return 0;
>>> +
>>> +	*prog_id =3D curr_id;
>>> +	err =3D nla_put_u32(skb, attr, curr_id);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	if (*mode !=3D XDP_ATTACHED_NONE)
>>> +		*mode =3D XDP_ATTACHED_MULTI;
>>> +	else
>>> +		*mode =3D tgt_mode;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static u32 rtnl_xdp_prog_skb(struct net_device *dev)
>>>  {
>>>  	const struct bpf_prog *generic_xdp_prog;
>>> @@ -1486,6 +1522,42 @@ static int rtnl_xdp_fill(struct sk_buff *skb, st=
ruct net_device *dev)
>>>  	return err;
>>>  }
>>>=20=20
>>> +static int rtnl_xdp_egress_fill(struct sk_buff *skb, struct net_device=
 *dev)
>>> +{
>>> +	u8 mode =3D XDP_ATTACHED_NONE;
>>> +	struct nlattr *xdp;
>>> +	u32 prog_id =3D 0;
>>> +	int err;
>>> +
>>> +	xdp =3D nla_nest_start_noflag(skb, IFLA_XDP_EGRESS);
>>> +	if (!xdp)
>>> +		return -EMSGSIZE;
>>> +
>>> +	err =3D rtnl_xdp_egress_report(skb, dev, &prog_id, &mode,
>>> +				     XDP_ATTACHED_EGRESS_CORE,
>>> +				     IFLA_XDP_EGRESS_CORE_PROG_ID,
>>> +				     rtnl_xdp_egress_prog);
>>> +	if (err)
>>> +		goto err_cancel;
>>> +
>>> +	err =3D nla_put_u8(skb, IFLA_XDP_ATTACHED, mode);
>>> +	if (err)
>>> +		goto err_cancel;
>>> +
>>> +	if (prog_id && mode !=3D XDP_ATTACHED_MULTI) {
>>> +		err =3D nla_put_u32(skb, IFLA_XDP_PROG_ID, prog_id);
>>> +		if (err)
>>> +			goto err_cancel;
>>> +	}
>>> +
>>> +	nla_nest_end(skb, xdp);
>>> +	return 0;
>>> +
>>> +err_cancel:
>>> +	nla_nest_cancel(skb, xdp);
>>> +	return err;
>>> +}
>>> +
>>>  static u32 rtnl_get_event(unsigned long event)
>>>  {
>>>  	u32 rtnl_event_type =3D IFLA_EVENT_NONE;
>>> @@ -1743,6 +1815,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>>>  	if (rtnl_xdp_fill(skb, dev))
>>>  		goto nla_put_failure;
>>>=20=20
>>> +	if (rtnl_xdp_egress_fill(skb, dev))
>>> +		goto nla_put_failure;
>>> +
>>>  	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
>>>  		if (rtnl_link_fill(skb, dev) < 0)
>>>  			goto nla_put_failure;
>>> @@ -1827,6 +1902,7 @@ static const struct nla_policy ifla_policy[IFLA_M=
AX+1] =3D {
>>>  	[IFLA_ALT_IFNAME]	=3D { .type =3D NLA_STRING,
>>>  				    .len =3D ALTIFNAMSIZ - 1 },
>>>  	[IFLA_PERM_ADDRESS]	=3D { .type =3D NLA_REJECT },
>>> +	[IFLA_XDP_EGRESS]	=3D { .type =3D NLA_NESTED },
>>>  };
>>>=20=20
>>>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] =3D {
>>> @@ -2482,7 +2558,8 @@ static int do_set_master(struct net_device *dev, =
int ifindex,
>>>  #define DO_SETLINK_NOTIFY	0x03
>>>=20=20
>>>  static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
>>> -			  int *status, struct netlink_ext_ack *extack)
>>> +			  int *status, bool egress,
>>> +			  struct netlink_ext_ack *extack)
>>>  {
>>>  	struct nlattr *xdp[IFLA_XDP_MAX + 1];
>>>  	u32 xdp_flags =3D 0;
>>> @@ -2498,6 +2575,10 @@ static int do_setlink_xdp(struct net_device *dev=
, struct nlattr *tb,
>>>=20=20
>>>  	if (xdp[IFLA_XDP_FLAGS]) {
>>>  		xdp_flags =3D nla_get_u32(xdp[IFLA_XDP_FLAGS]);
>>> +		if (egress && xdp_flags & XDP_FLAGS_MODES) {
>>> +			NL_SET_ERR_MSG(extack, "XDP_FLAGS_MODES not valid for egress");
>>> +			goto out_einval;
>>> +		}
>>>  		if (xdp_flags & ~XDP_FLAGS_MASK)
>>>  			goto out_einval;
>>>  		if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1)
>>> @@ -2515,7 +2596,7 @@ static int do_setlink_xdp(struct net_device *dev,=
 struct nlattr *tb,
>>>=20=20
>>>  		err =3D dev_change_xdp_fd(dev, extack,
>>>  					nla_get_s32(xdp[IFLA_XDP_FD]),
>>> -					expected_fd, xdp_flags, false);
>>> +					expected_fd, xdp_flags, egress);
>>>  		if (err)
>>>  			return err;
>>>=20=20
>>> @@ -2821,7 +2902,14 @@ static int do_setlink(const struct sk_buff *skb,
>>>  	}
>>>=20=20
>>>  	if (tb[IFLA_XDP]) {
>>> -		err =3D do_setlink_xdp(dev, tb[IFLA_XDP], &status, extack);
>>> +		err =3D do_setlink_xdp(dev, tb[IFLA_XDP], &status, false, extack);
>>> +		if (err)
>>> +			goto errout;
>>> +	}
>>> +
>>> +	if (tb[IFLA_XDP_EGRESS]) {
>>> +		err =3D do_setlink_xdp(dev, tb[IFLA_XDP_EGRESS], &status, true,
>>> +				     extack);
>>>  		if (err)
>>>  			goto errout;
>>>  	}
>>=20
>> This means that IFLA_XDP and IFLA_XDP_EGRESS can be present in the same
>> netlink message, right? But then installation of the RX program could
>> succeed, but userspace would still get an error if the egress program
>> installation fails? That is probably not good?
>
> That's a good catch.
>
>>=20
>> Since I don't think we can atomically make sure both operations fail or
>> succeed, maybe it's better to disallow both entries being present in the
>> same netlink message?
>>=20
>
> I think so since there is no way to undo the setlink for IFLA_XDP if
> IFLA_XDP_EGRESS fails - exisitng program references are gone.

Yeah, and also even if we could undo it, there would be a window where
the new program could process packets before the revert. I'm fine with
just rejecting the combination; I guess the most common thing would be
to set these separately anyway.

> Although, existing do_setlink leaves the device in an incomplete state
> on any failure...

Hmm, ideally we should fix that as well (if possible)? Probably out of
scope for this patch series, though :)

-Toke

