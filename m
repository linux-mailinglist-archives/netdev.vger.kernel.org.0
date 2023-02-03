Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F357268A642
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 23:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbjBCWfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 17:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCWf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 17:35:29 -0500
X-Greylist: delayed 2273 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Feb 2023 14:35:24 PST
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC025D114;
        Fri,  3 Feb 2023 14:35:24 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:43600)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1pO3RI-00AQv9-7R; Fri, 03 Feb 2023 14:17:44 -0700
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:45058 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1pO3RG-003wl5-Lr; Fri, 03 Feb 2023 14:17:43 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Alok Tiagi <aloktiagi@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <Y9q8Ec1CJILZz7dj@ip-172-31-38-16.us-west-2.compute.internal>
        <20230202014810.744-1-hdanton@sina.com>
        <Y9wVNF5IBCYVz5jU@ip-172-31-38-16.us-west-2.compute.internal>
        <CANn89iLWZb-Uf_9a41ofBtVsHjBwHzbOVn+V_QrksnB9y80m6w@mail.gmail.com>
        <Y9xOQPPGDrSN0IBu@ip-172-31-38-16.us-west-2.compute.internal>
        <CANn89iL-RtzMdVuBeM_c4PPqZxk28hVwNhs9vMhwTyJwVhqS9A@mail.gmail.com>
        <Y91JduiSy6mDCQ2a@ip-172-31-38-16.us-west-2.compute.internal>
Date:   Fri, 03 Feb 2023 15:17:06 -0600
In-Reply-To: <Y91JduiSy6mDCQ2a@ip-172-31-38-16.us-west-2.compute.internal>
        (Alok Tiagi's message of "Fri, 3 Feb 2023 17:50:46 +0000")
Message-ID: <87tu0278kt.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1pO3RG-003wl5-Lr;;;mid=<87tu0278kt.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX198RYg11xXt6TXOu9sVTY062knsanLCSQA=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alok Tiagi <aloktiagi@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 671 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.7 (0.7%), b_tie_ro: 3.2 (0.5%), parse: 1.28
        (0.2%), extract_message_metadata: 6 (0.9%), get_uri_detail_list: 3.8
        (0.6%), tests_pri_-2000: 3.4 (0.5%), tests_pri_-1000: 2.0 (0.3%),
        tests_pri_-950: 1.12 (0.2%), tests_pri_-900: 0.82 (0.1%),
        tests_pri_-200: 0.69 (0.1%), tests_pri_-100: 4.1 (0.6%),
        tests_pri_-90: 196 (29.2%), check_bayes: 194 (28.9%), b_tokenize: 9
        (1.3%), b_tok_get_all: 11 (1.6%), b_comp_prob: 2.4 (0.4%),
        b_tok_touch_all: 169 (25.1%), b_finish: 0.80 (0.1%), tests_pri_0: 433
        (64.5%), check_dkim_signature: 0.43 (0.1%), check_dkim_adsp: 3.2
        (0.5%), poll_dns_idle: 1.81 (0.3%), tests_pri_10: 2.8 (0.4%),
        tests_pri_500: 7 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] net: add new socket option SO_SETNETNS
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alok Tiagi <aloktiagi@gmail.com> writes:

> On Fri, Feb 03, 2023 at 04:09:12PM +0100, Eric Dumazet wrote:
>> On Fri, Feb 3, 2023 at 12:59 AM Alok Tiagi <aloktiagi@gmail.com> wrote:
>> >
>> > On Thu, Feb 02, 2023 at 09:10:23PM +0100, Eric Dumazet wrote:
>> > > On Thu, Feb 2, 2023 at 8:55 PM Alok Tiagi <aloktiagi@gmail.com> wrote:
>> > > >
>> > > > On Thu, Feb 02, 2023 at 09:48:10AM +0800, Hillf Danton wrote:
>> > > > > On Wed, 1 Feb 2023 19:22:57 +0000 aloktiagi <aloktiagi@gmail.com>
>> > > > > > @@ -1535,6 +1535,52 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
>> > > > > >             WRITE_ONCE(sk->sk_txrehash, (u8)val);
>> > > > > >             break;
>> > > > > >
>> > > > > > +   case SO_SETNETNS:
>> > > > > > +   {
>> > > > > > +           struct net *other_ns, *my_ns;
>> > > > > > +
>> > > > > > +           if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6) {
>> > > > > > +                   ret = -EOPNOTSUPP;
>> > > > > > +                   break;
>> > > > > > +           }
>> > > > > > +
>> > > > > > +           if (sk->sk_type != SOCK_STREAM && sk->sk_type != SOCK_DGRAM) {
>> > > > > > +                   ret = -EOPNOTSUPP;
>> > > > > > +                   break;
>> > > > > > +           }
>> > > > > > +
>> > > > > > +           other_ns = get_net_ns_by_fd(val);
>> > > > > > +           if (IS_ERR(other_ns)) {
>> > > > > > +                   ret = PTR_ERR(other_ns);
>> > > > > > +                   break;
>> > > > > > +           }
>> > > > > > +
>> > > > > > +           if (!ns_capable(other_ns->user_ns, CAP_NET_ADMIN)) {
>> > > > > > +                   ret = -EPERM;
>> > > > > > +                   goto out_err;
>> > > > > > +           }
>> > > > > > +
>> > > > > > +           /* check that the socket has never been connected or recently disconnected */
>> > > > > > +           if (sk->sk_state != TCP_CLOSE || sk->sk_shutdown & SHUTDOWN_MASK) {
>> > > > > > +                   ret = -EOPNOTSUPP;
>> > > > > > +                   goto out_err;
>> > > > > > +           }
>> > > > > > +
>> > > > > > +           /* check that the socket is not bound to an interface*/
>> > > > > > +           if (sk->sk_bound_dev_if != 0) {
>> > > > > > +                   ret = -EOPNOTSUPP;
>> > > > > > +                   goto out_err;
>> > > > > > +           }
>> > > > > > +
>> > > > > > +           my_ns = sock_net(sk);
>> > > > > > +           sock_net_set(sk, other_ns);
>> > > > > > +           put_net(my_ns);
>> > > > > > +           break;
>> > > > >
>> > > > >               cpu 0                           cpu 2
>> > > > >               ---                             ---
>> > > > >                                               ns = sock_net(sk);
>> > > > >               my_ns = sock_net(sk);
>> > > > >               sock_net_set(sk, other_ns);
>> > > > >               put_net(my_ns);
>> > > > >                                               ns is invalid ?
>> > > >
>> > > > That is the reason we want the socket to be in an un-connected state. That
>> > > > should help us avoid this situation.
>> > >
>> > > This is not enough....
>> > >
>> > > Another thread might look at sock_net(sk), for example from inet_diag
>> > > or tcp timers
>> > > (which can be fired even in un-connected state)
>> > >
>> > > Even UDP sockets can receive packets while being un-connected,
>> > > and they need to deref the net pointer.
>> > >
>> > > Currently there is no protection about sock_net(sk) being changed on the fly,
>> > > and the struct net could disappear and be freed.
>> > >
>> > > There are ~1500 uses of sock_net(sk) in the kernel, I do not think
>> > > you/we want to audit all
>> > > of them to check what could go wrong...
>> >
>> > I agree, auditing all the uses of sock_net(sk) is not a feasible option. From my
>> > exploration of the usage of sock_net(sk) it appeared that it might be safe to
>> > swap a sockets net ns if it had never been connected but I looked at only a
>> > subset of such uses.
>> >
>> > Introducing a ref counting logic to every access of sock_net(sk) may help get
>> > around this but invovles a bigger change to increment and decrement the count at
>> > every use of sock_net().
>> >
>> > Any suggestions if this could be achieved in another way much close to the
>> > socket creation time or any comments on our workaround for injecting sockets using
>> > seccomp addfd?
>> 
>> Maybe the existing BPF hook in inet_create() could be used ?
>> 
>> err = BPF_CGROUP_RUN_PROG_INET_SOCK(sk);
>> 
>> The BPF program might be able to switch the netns, because at this
>> time the new socket is not
>> yet visible from external threads.
>> 
>> Although it is not going to catch dual stack uses (open a V6 socket,
>> then use a v4mapped address at bind()/connect()/...
>
> We thought of a similar approach by intercepting the socket() call in seccomp
> and injecting a new file descritpor much earlier but as you said we run into the
> issue of handling dual stack sockets since we do not know in advance if its
> going to be used for a v4mapped address.

I would suggest adding a default ipv4 route from your ipv6 network
namespaces to your ipv4 network namespace, but that only works for
outbound traffic.  The inbound traffic problem is classically solved
via nat.

That you are not suggesting using nat has me thinking there is something
subtle in what you are trying to do that I am missing.

Perhaps your userspace can do:

	previous_netns = open("/proc/self/ns/net");
	setns(ipv4_netns);
	socket();
	setns(previous_netns);


As the network namespace is per thread this is atomic if you add
the logic to block signals around it.

Eric
