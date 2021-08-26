Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C043F8B9D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhHZQQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:16:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42200 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhHZQQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 12:16:54 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:50700)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mJI2v-00Dn3R-Rw; Thu, 26 Aug 2021 10:16:05 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:57710 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mJI2u-00BzM3-F2; Thu, 26 Aug 2021 10:16:05 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Andrey Ignatov <rdna@fb.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <kernel-team@fb.com>
References: <20210826002540.11306-1-rdna@fb.com>
Date:   Thu, 26 Aug 2021 11:15:22 -0500
In-Reply-To: <20210826002540.11306-1-rdna@fb.com> (Andrey Ignatov's message of
        "Wed, 25 Aug 2021 17:25:40 -0700")
Message-ID: <8735qwi3mt.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mJI2u-00BzM3-F2;;;mid=<8735qwi3mt.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18O0MHBnGBms9iJGdbWEfxJYjsADzP7rog=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrey Ignatov <rdna@fb.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 786 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 9 (1.1%), b_tie_ro: 7 (0.9%), parse: 1.00 (0.1%),
        extract_message_metadata: 20 (2.6%), get_uri_detail_list: 3.1 (0.4%),
        tests_pri_-1000: 26 (3.4%), tests_pri_-950: 1.29 (0.2%),
        tests_pri_-900: 1.03 (0.1%), tests_pri_-90: 223 (28.4%), check_bayes:
        221 (28.1%), b_tokenize: 11 (1.4%), b_tok_get_all: 10 (1.2%),
        b_comp_prob: 3.1 (0.4%), b_tok_touch_all: 193 (24.5%), b_finish: 1.17
        (0.1%), tests_pri_0: 492 (62.5%), check_dkim_signature: 0.58 (0.1%),
        check_dkim_adsp: 2.7 (0.3%), poll_dns_idle: 0.74 (0.1%), tests_pri_10:
        2.0 (0.3%), tests_pri_500: 8 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH net] rtnetlink: Return correct error on changing device netns
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Ignatov <rdna@fb.com> writes:

> Currently when device is moved between network namespaces using
> RTM_NEWLINK message type and one of netns attributes (FLA_NET_NS_PID,
> IFLA_NET_NS_FD, IFLA_TARGET_NETNSID) but w/o specifying IFLA_IFNAME, and
> target namespace already has device with same name, userspace will get
> EINVAL what is confusing and makes debugging harder.
>
> Fix it so that userspace gets more appropriate EEXIST instead what makes
> debugging much easier.
>
> Before:
>
>   # ./ifname.sh
>   + ip netns add ns0
>   + ip netns exec ns0 ip link add l0 type dummy
>   + ip netns exec ns0 ip link show l0
>   8: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/ether 66:90:b5:d5:78:69 brd ff:ff:ff:ff:ff:ff
>   + ip link add l0 type dummy
>   + ip link show l0
>   10: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/ether 6e:c6:1f:15:20:8d brd ff:ff:ff:ff:ff:ff
>   + ip link set l0 netns ns0
>   RTNETLINK answers: Invalid argument
>
> After:
>
>   # ./ifname.sh
>   + ip netns add ns0
>   + ip netns exec ns0 ip link add l0 type dummy
>   + ip netns exec ns0 ip link show l0
>   8: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/ether 1e:4a:72:e3:e3:8f brd ff:ff:ff:ff:ff:ff
>   + ip link add l0 type dummy
>   + ip link show l0
>   10: l0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/ether f2:fc:fe:2b:7d:a6 brd ff:ff:ff:ff:ff:ff
>   + ip link set l0 netns ns0
>   RTNETLINK answers: File exists
>
> The problem is that do_setlink() passes its `char *ifname` argument,
> that it gets from a caller, to __dev_change_net_namespace() as is (as
> `const char *pat`), but semantics of ifname and pat can be different.
>
> For example, __rtnl_newlink() does this:
>
> net/core/rtnetlink.c
>     3270	char ifname[IFNAMSIZ];
>      ...
>     3286	if (tb[IFLA_IFNAME])
>     3287		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
>     3288	else
>     3289		ifname[0] = '\0';
>      ...
>     3364	if (dev) {
>      ...
>     3394		return do_setlink(skb, dev, ifm, extack, tb, ifname, status);
>     3395	}
>
> , i.e. do_setlink() gets ifname pointer that is always valid no matter
> if user specified IFLA_IFNAME or not and then do_setlink() passes this
> ifname pointer as is to __dev_change_net_namespace() as pat argument.
>
> But the pat (pattern) in __dev_change_net_namespace() is used as:
>
> net/core/dev.c
>    11198	err = -EEXIST;
>    11199	if (__dev_get_by_name(net, dev->name)) {
>    11200		/* We get here if we can't use the current device name */
>    11201		if (!pat)
>    11202			goto out;
>    11203		err = dev_get_valid_name(net, dev, pat);
>    11204		if (err < 0)
>    11205			goto out;
>    11206	}
>
> As the result the `goto out` path on line 11202 is neven taken and
> instead of returning EEXIST defined on line 11198,
> __dev_change_net_namespace() returns an error from dev_get_valid_name()
> and this, in turn, will be EINVAL for ifname[0] = '\0' set earlier.
>
> Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
> Signed-off-by: Andrey Ignatov <rdna@fb.com>

The analysis and the fix looks good to me.

The code calling do_setlink is inconsistent.  One caller of do_setlink
passes a NULL to indicate not name has been specified.  Other callers
pass a string of zero bytes to indicate no name has been specified.

I wonder if we might want to fix the callers to uniformly pass NULL,
instead of a string of length zero.

There is a slight chance this will trigger a regression somewhere
because we are changing the error code but this change looks easy enough
to revert in the unlikely event this breaks existing userspace.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>  net/core/rtnetlink.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index f6af3e74fc44..662eb1c37f47 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2608,6 +2608,7 @@ static int do_setlink(const struct sk_buff *skb,
>  		return err;
>  
>  	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
> +		const char *pat = ifname && ifname[0] ? ifname : NULL;
>  		struct net *net;
>  		int new_ifindex;
>  
> @@ -2623,7 +2624,7 @@ static int do_setlink(const struct sk_buff *skb,
>  		else
>  			new_ifindex = 0;
>  
> -		err = __dev_change_net_namespace(dev, net, ifname, new_ifindex);
> +		err = __dev_change_net_namespace(dev, net, pat, new_ifindex);
>  		put_net(net);
>  		if (err)
>  			goto errout;
