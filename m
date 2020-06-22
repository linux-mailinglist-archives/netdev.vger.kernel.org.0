Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00466203E4D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgFVRsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:48:24 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:42042 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729886AbgFVRsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:48:23 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jnQYL-0003Fi-Bu; Mon, 22 Jun 2020 11:48:17 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jnQYJ-0006uf-KI; Mon, 22 Jun 2020 11:48:16 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
Date:   Mon, 22 Jun 2020 12:43:53 -0500
In-Reply-To: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
        (Jason A. Donenfeld's message of "Sun, 21 Jun 2020 02:58:49 -0600")
Message-ID: <87imfjt2qu.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jnQYJ-0006uf-KI;;;mid=<87imfjt2qu.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/f9sgkmlVbSetNxxaxtlEzgzzgwMc07kU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMGappySubj_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.5 XMGappySubj_01 Very gappy subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 0; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: ; sa07 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Jason A. Donenfeld" <Jason@zx2c4.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 566 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 11 (1.9%), b_tie_ro: 10 (1.7%), parse: 1.27
        (0.2%), extract_message_metadata: 13 (2.4%), get_uri_detail_list: 3.4
        (0.6%), tests_pri_-1000: 5 (0.9%), tests_pri_-950: 1.31 (0.2%),
        tests_pri_-900: 1.08 (0.2%), tests_pri_-90: 71 (12.6%), check_bayes:
        70 (12.3%), b_tokenize: 12 (2.2%), b_tok_get_all: 13 (2.3%),
        b_comp_prob: 4.7 (0.8%), b_tok_touch_all: 35 (6.2%), b_finish: 0.99
        (0.2%), tests_pri_0: 410 (72.3%), check_dkim_signature: 0.59 (0.1%),
        check_dkim_adsp: 2.4 (0.4%), poll_dns_idle: 0.91 (0.2%), tests_pri_10:
        2.9 (0.5%), tests_pri_500: 45 (8.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: missing retval check of call_netdevice_notifiers in dev_change_net_namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi,

Adding Herbert Xu who added support for failing notifications in
fcc5a03ac425 ("[NET]: Allow netdev REGISTER/CHANGENAME events to fail").

He might have some insight but 2007 was a long time ago.

All I remember is the ability of NETDEV_CHANGENAME to fail was abused by
sysfs to add a userspace ABI regression, and sysfs had to be fixed
not to do that.


> In register_netdevice, there's a call to
> call_netdevice_notifiers(NETDEV_REGISTER), whose return value is
> checked to determine whether or not to roll back the device
> registration. The reason checking that return value is important is
> because this represents an opportunity for the various notifiers to
> veto the registration, or for another error to happen. It's good that
> the error value is checked when that function is called from
> register_netdevice. But from other functions, the error value is not
> always checked.
>
> The notification is split up into two stages:
>
>         ret = raw_notifier_call_chain(&net->netdev_chain, val, info);
>         if (ret & NOTIFY_STOP_MASK)
>                 return ret;
>         return raw_notifier_call_chain(&netdev_chain, val, info);
>
> One is per-net and the other is global. So there's ample space for
> something in either chain to abort the whole process.
>
> The wireguard module uses the notifier to keep track of netns changes
> in order to do some reference count bookkeeping. If this bookkeeping
> goes wrong, there's UaF potential. However, I noticed that the call to
> call_netdevice_notifiers(NETDEV_REGISTER) at the end of
> dev_change_net_namespace doesn't check its return value and doesn't
> implement any sort of rollback like register_netdevice does:
>
> int dev_change_net_namespace(struct net_device *dev, struct net *net,
> const char *pat)
> {
>        struct net *net_old = dev_net(dev);
>        int err, new_nsid, new_ifindex;
>
>        ASSERT_RTNL();
> [...]
>         /* Add the device back in the hashes */
>         list_netdevice(dev);
>
>         /* Notify protocols, that a new device appeared. */
>         call_netdevice_notifiers(NETDEV_REGISTER, dev);
> [...]
> }
>
> Notice that call_netdevice_notifiers isn't checking it's return value there.
>
> It seems like if any device vetoes the notification chain, it's bad
> news bears for modules that depend on getting a netns change
> notification.

In general we are talking a subsystem not a device that will veto
the change.  Implementations of devices should not need notifiers,
as they have enough methods.

It requires a level above a network device to care about your network
namespace.  Now wireguard happens to be both. So you care but I don't
believe an ordinary device will.

Nitpicks aside, if we are going to make sense of this we need to find
actualy notifiers that veto the change and look at them.

> I've been trying to audit the various registered notifiers to see if
> any of them pose a risk for wireguard. There are also unexpected
> errors that can happen, such as OOM conditions for kmalloc(GFP_KERNEL)
> or vmalloc and suchlike, which might be influenceable by attackers. In
> other words, relying on those notifications always being delivered
> seems kind of brittle. Not _super_ brittle, but brittle enough that
> it's at the moment making me a bit nervous. (See: UaF potential.)
>
> I've been trying to come up with a good solution to this.

The entire code consists of walking a linked list and calling the
callback function at each node on the list.   There is nothing
bad that can happen except list corruption and callback functions
that do silly things.  AKA implementation bugs.

There are no expected failures in walking a linked list.  So it should
be perfectly valid to rely on receiving your notification.

If callback function allocates memory or does something that is not 100%
reliable in a notifier that is a different issue and it is that
subystems problem.

> I'm not sure how reasonable it'd be to implement rollback inside of
> dev_change_net_namespace, but I guess that could technically be
> possible. The way that'd work would be that when vetoed, the function
> would complete, but then would start over again (a "goto top" sort of
> pattern), with oldnet and newnet reversed. But that could of course
> fail too and we could get ourselves in some sort of infinite loop. Not
> good.

Semantically it can't happen.  Once we reach dev_close we have caused
userspace visible effects that simply can not be undone.  So the code
has to validate that the change can happen before we it reaches
dev_close.

Which unfortunately makes the code incompatible with the concept of
black boxes on the notification chain adding failure cases.

It wouldn't hurt to add a warning:

	err = call_netdevice_notifiers(NETDEV_REGISTER, dev)
        WARN_ON_ONCE(err).

Just to validate the assumption that nothing ever happens.

> Finally, it could be the solution is that modules that use the netdev
> notifier never really rely too heavily upon getting notifications, and
> if they need something reliable, then they rearchitect their code to
> not need that. I could imagine this attitude holding sway here
> somehow, but it's also not very appealing from a code writing and
> refactoring perspective.

Perhaps we can architect the failure case out of NETDEV_REGISTER so
people don't have to worry about it.

> I figured before I go to town coding one of these up, maybe I should
> bring up the issue here, in case anybody has more developed thoughts
> than me about it.

I hope this gives you some insight.  I think this may be a case where
the code allows more than anyone has actually taken advantage of.

Eric
