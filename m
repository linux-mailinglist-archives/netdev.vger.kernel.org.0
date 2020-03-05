Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7511717A273
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 10:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCEJr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 04:47:58 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:39092 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgCEJr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 04:47:57 -0500
Received: by mail-vs1-f68.google.com with SMTP id a19so3136048vsp.6
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 01:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E+rHjRTI+X5hZj+5FAflDmqzbGlpDyoukXhDePpwkw8=;
        b=cUJlys4XlBzO23FhTHTCunNEwaxvXaoM6hZrnCjsZoSgiF4iuBjB6xdJnI8PoeKRAk
         5mPv1nPisvzLqeef42ALCHn5CQsTKWQIWCBKmBdLh5Sxhrdp4IgGElo72Q9+x2mEmlbb
         VPjBOPxZhqYCN6uHJR6jvoK/UjaZXIfq7kqff7CUm+WgstTJatoQE23VlwQYuf6IAWOE
         X/EQ6ifB4QmCoxexcvvxK7xoHGZOguZ/+U9XwN2Lo/PPca1heIKIoBVJ+ThVwhkN3Wtd
         Q2ce0p3T2vUaXweRNmLeImpJz3HQmwJuep3AnOHATLK2ZuyILqCBm5uuD74qj+YbCDtl
         mzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E+rHjRTI+X5hZj+5FAflDmqzbGlpDyoukXhDePpwkw8=;
        b=c64GpCgIjCJ6nbZ+56S+Rye++LcyVm393d5ThPRpdSv5OwPQCTdnHU80+wwdtbdPA4
         s7ddP0npOpkKmGSBw+Z3TeIN44aH72JwSh+pZ/CF24J1FxySekmW7d1HxCiyuudy25Ch
         osDuAtfNLA/a+aZXuYETufNlGIhMb/FtO6wk3W7Ks0+cByR8Sd95Cvr86nyICbahOxHK
         /VceuRHXS69uKKOVz+L3w9PVLfFD9HovOnDk0nRSjEwO0+dJcZWfRIMbEMnUE2FYX4Mi
         mMSBA0M1hmOoqeo/j4hai7akyvA2VIZ3SlMz8iWlVKlu3SuxNgdx2rPChzUPkpc9hk/A
         Oe3A==
X-Gm-Message-State: ANhLgQ0vH5Or4XKElbU588E+hfO1LKnzAQ/Es6NQSlouTYuXPLlmRXVE
        wdpKl3MfMuMvgFOoo79SXc0++64hMGjEaDXc9jlnvA==
X-Google-Smtp-Source: ADFU+vv2z10ptPoVhyQbguI9+euhHsrM3YUOyqf2EvcelJ/BT2wzn2zpyy3Emqt1W3Bfwc1x3q55j/JnJL/RhFIFgsw=
X-Received: by 2002:a67:df97:: with SMTP id x23mr4695241vsk.160.1583401676527;
 Thu, 05 Mar 2020 01:47:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Thu, 5 Mar 2020 01:47:55 -0800 (PST)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <c5cd0349-69b3-41e9-7fb1-d7909e659717@suse.com>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
 <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com> <CAOJe8K28BZCW7JDejKgDELR2WPfBgvj-0aJJXX9uCRnryGY+xg@mail.gmail.com>
 <c5cd0349-69b3-41e9-7fb1-d7909e659717@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 5 Mar 2020 12:47:55 +0300
Message-ID: <CAOJe8K0HuKyAi5YJwsWMcAJEp-Vkhbgvvg=RRcZZ8V6uqGzczw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     netdev@vger.kernel.org,
        "ilias.apalodimas" <ilias.apalodimas@linaro.org>,
        wei.liu@kernel.org, paul@xen.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> On 04.03.20 14:10, Denis Kirjanov wrote:
>> On 3/2/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>>> On 02.03.20 15:21, Denis Kirjanov wrote:
>>>> the patch adds a basic xdo logic to the netfront driver
>>>>
>>>> XDP redirect is not supported yet
>>>>
>>>> v2:
>>>> - avoid data copying while passing to XDP
>>>> - tell xen-natback that we need the headroom space
>>>
>>> Please add the patch history below the "---" delimiter
>>>
>>>>
>>>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>>>> ---
>>>>    drivers/net/xen-netback/common.h |   1 +
>>>>    drivers/net/xen-netback/rx.c     |   9 ++-
>>>>    drivers/net/xen-netback/xenbus.c |  21 ++++++
>>>>    drivers/net/xen-netfront.c       | 157
>>>> +++++++++++++++++++++++++++++++++++++++
>>>>    4 files changed, 186 insertions(+), 2 deletions(-)
>>>
>>> You are modifying xen-netback sources. Please Cc the maintainers.
>>>
>
> ...
>
>>>>
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +
>>>> +abort_transaction:
>>>> +	xenbus_dev_fatal(np->xbdev, err, "%s", message);
>>>> +	xenbus_transaction_end(xbt, 1);
>>>> +out:
>>>> +	return err;
>>>> +}
>>>> +
>>>> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog
>>>> *prog,
>>>> +			struct netlink_ext_ack *extack)
>>>> +{
>>>> +	struct netfront_info *np =3D netdev_priv(dev);
>>>> +	struct bpf_prog *old_prog;
>>>> +	unsigned int i, err;
>>>> +
>>>> +	old_prog =3D rtnl_dereference(np->queues[0].xdp_prog);
>>>> +	if (!old_prog && !prog)
>>>> +		return 0;
>>>> +
>>>> +	if (prog)
>>>> +		bpf_prog_add(prog, dev->real_num_tx_queues);
>>>> +
>>>> +	for (i =3D 0; i < dev->real_num_tx_queues; ++i)
>>>> +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
>>>> +
>>>> +	if (old_prog)
>>>> +		for (i =3D 0; i < dev->real_num_tx_queues; ++i)
>>>> +			bpf_prog_put(old_prog);
>>>> +
>>>> +	err =3D talk_to_netback_xdp(np, old_prog ?
>>>> NETBACK_XDP_HEADROOM_DISABLE:
>>>> +				  NETBACK_XDP_HEADROOM_ENABLE);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>> +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
>>>
>>> What is happening in case the backend doesn't support XDP?
>> Here we just ask xen-backend to make a headroom, that's it.
>> It's better to send xen-backend changes in a separate patch.
>
> Okay, but what do you do if the backend doesn't support XDP (e.g. in
> case its an older kernel)? How do you know it is supporting XDP?
We can check a xenbus reply to xenbus state change.

>
>>
>>>
>>> Is it really a good idea to communicate xdp_set via a frontend state
>>> change? This will be rather slow. OTOH I have no idea how often this
>>> might happen.
>>
>> I don't think that it's going to switch often and more likely it's a one
>> shot
>> action.
>
> What do you do in case of a live migration? You need to tell the backend
> about XDP again.

Yep I haven't thought about that. Thanks for pointing out.

>
>
> Juergen
>
