Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70984C9792
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbiCAVLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiCAVLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:11:42 -0500
X-Greylist: delayed 1211 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 13:11:00 PST
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964E180918
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 13:11:00 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:42438)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nP9SE-005Abw-0I; Tue, 01 Mar 2022 13:50:42 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:46522 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nP9SC-001ghx-N7; Tue, 01 Mar 2022 13:50:41 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        NeilBrown <neilb@suse.de>, Vasily Averin <vvs@virtuozzo.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
        <YhzeCkXEvga7+o/A@bombadil.infradead.org>
        <20220301180917.tkibx7zpcz2faoxy@google.com>
        <Yh5lyr8dJXmEoFG6@bombadil.infradead.org>
Date:   Tue, 01 Mar 2022 14:50:06 -0600
In-Reply-To: <Yh5lyr8dJXmEoFG6@bombadil.infradead.org> (Luis Chamberlain's
        message of "Tue, 1 Mar 2022 10:28:26 -0800")
Message-ID: <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nP9SC-001ghx-N7;;;mid=<87wnhdwg75.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18lmp4fBJoK+TGAwQ653r/OCJOTfCXd/3Q=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Luis Chamberlain <mcgrof@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 648 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.7%), b_tie_ro: 10 (1.5%), parse: 1.61
        (0.2%), extract_message_metadata: 8 (1.3%), get_uri_detail_list: 6
        (0.9%), tests_pri_-1000: 4.7 (0.7%), tests_pri_-950: 1.24 (0.2%),
        tests_pri_-900: 1.07 (0.2%), tests_pri_-90: 75 (11.6%), check_bayes:
        73 (11.3%), b_tokenize: 13 (2.1%), b_tok_get_all: 15 (2.3%),
        b_comp_prob: 4.6 (0.7%), b_tok_touch_all: 36 (5.6%), b_finish: 0.80
        (0.1%), tests_pri_0: 527 (81.2%), check_dkim_signature: 0.59 (0.1%),
        check_dkim_adsp: 2.6 (0.4%), poll_dns_idle: 0.79 (0.1%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 7 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luis Chamberlain <mcgrof@kernel.org> writes:

> On Tue, Mar 01, 2022 at 10:09:17AM -0800, Shakeel Butt wrote:
>> On Mon, Feb 28, 2022 at 06:36:58AM -0800, Luis Chamberlain wrote:
>> > On Mon, Feb 28, 2022 at 10:17:16AM +0300, Vasily Averin wrote:
>> > > Following one-liner running inside memcg-limited container consumes
>> > > huge number of host memory and can trigger global OOM.
>> > >
>> > > for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ; done
>> > >
>> > > Patch accounts most part of these allocations and can protect host.
>> > > ---[cut]---
>> > > It is not polished, and perhaps should be splitted.
>> > > obviously it affects other kind of netdevices too.
>> > > Unfortunately I'm not sure that I will have enough time to handle it
>> > properly
>> > > and decided to publish current patch version as is.
>> > > OpenVz workaround it by using per-container limit for number of
>> > > available netdevices, but upstream does not have any kind of
>> > > per-container configuration.
>> > > ------
>> 
>> > Should this just be a new ucount limit on kernel/ucount.c and have veth
>> > use something like inc_ucount(current_user_ns(), current_euid(),
>> > UCOUNT_VETH)?
>> 
>> > This might be abusing ucounts though, not sure, Eric?
>> 
>> 
>> For admins of systems running multiple workloads, there is no easy way
>> to set such limits for each workload.
>
> That's why defaults would exist. Today's ulimits IMHO are insane and
> some are arbitrarily large.

My perspective is that we have two basic kinds of limits.

Limits to catch programs that go out of control hopefully before they
bring down the entire system.  This is the purpose I see of rlimits and
ucounts.  Such limits should be set by default so large that no one has
to care unless their program is broken.

Limits to contain programs and keep them from having a negative impact
on other programs.  Generally this is the role I see the cgroups
playing.  This limits must be much more tightly managed.

The problem with veth that was reported was that the memory cgroup
limits fails to contain veth's allocations and veth manages to affect
process outside the memory cgroup where the veth ``lives''.  The effect
is an OOM but the problem is that it is affecting processes out of the
memory control group.

Part of the reason for the recent ucount work is so that ordinary users
can create user namespaces and root in that user namespace won't be able
to exceed the limits that were set when the user namespace was created
by creating additional users.

Part of the reason for my ucount work is my frustration that cgroups
would up something completely different than what was originally
proposed and solve a rather problem set.  Originally the proposal was
that cgroups would be the user interface for the bean-counter patches.
(Roughly counts like the ucounts are now).  Except for maybe the pid
controller you mention below cgroups look nothing like that today.
So I went and I solved the original problem because it was still not
solved.

The network stack should already have packet limits to prevent a global
OOM so I am a bit curious why those limits aren't preventing a global
OOM in for the veth device.


I am not saying that the patch is correct (although from 10,000 feet the
patch sounds like it is solving the reported problem).  I am answering
the question of how I understand limits to work.

Luis does this explanation of how limits work help?


>> From admin's perspective it is preferred to have minimal
>> knobs to set and if these objects are charged to memcg then the memcg
>> limits would limit them. There was similar situation for inotify
>> instances where fs sysctl inotify/max_user_instances already limits the
>> inotify instances but we memcg charged them to not worry about setting
>> such limits. See ac7b79fd190b ("inotify, memcg: account inotify
>> instances to kmemcg").
>
> Yes but we want sensible defaults out of the box. What those should be
> IMHO might be work which needs to be figured out well.
>
> IMHO today's ulimits are a bit over the top today. This is off slightly
> off topic but for instance play with:
>
> git clone https://github.com/ColinIanKing/stress-ng
> cd stress-ng
> make -j 8
> echo 0 > /proc/sys/vm/oom_dump_tasks                                            
> i=1; while true; do echo "RUNNING TEST $i"; ./stress-ng --unshare 8192 --unshare-ops 10000;  sleep 1; let i=$i+1; done
>
> If you see:
>
> [  217.798124] cgroup: fork rejected by pids controller in
> /user.slice/user-1000.slice/session-1.scope
>                                                                                 
> Edit /usr/lib/systemd/system/user-.slice.d/10-defaults.conf to be:
>
> [Slice]                                                                         
> TasksMax=MAX_TASKS|infinity
>
> Even though we have max_threads set to 61343, things ulimits have a
> different limit set, and what this means is the above can end up easily
> creating over 1048576 (17 times max_threads) threads all eagerly doing
> nothing to just exit, essentially allowing a sort of fork bomb on exit.
> Your system may or not fall to its knees.

What max_threads are you talking about here?  The global max_threads
exposed in /proc/sys/kernel/threads-max?  I don't see how you can get
around that.  Especially since the count is not decremented until the
process is reaped.

Or is this the pids controller having a low limit and
/proc/sys/kernel/threads-max having a higher limit?

I really have not looked at this pids controller.

So I am not certain I understand your example here but I hope I have
answered your question.

Eric
