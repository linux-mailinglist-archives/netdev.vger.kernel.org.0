Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A95547465
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 13:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfFPLuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 07:50:50 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56399 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfFPLuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 07:50:50 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hcTgN-0001c7-5f; Sun, 16 Jun 2019 05:50:47 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hcTgM-00045G-4G; Sun, 16 Jun 2019 05:50:46 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, avagin@virtuozzo.com,
        ktkhai@virtuozzo.com, "Serge E. Hallyn" <serge@hallyn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20180429104412.22445-1-christian.brauner@ubuntu.com>
        <20180429104412.22445-3-christian.brauner@ubuntu.com>
        <CAKdAkRTtffEQfZLnSW9CwzX_oYzHdOE816OvciGadqV7RHaV1Q@mail.gmail.com>
Date:   Sun, 16 Jun 2019 06:50:20 -0500
In-Reply-To: <CAKdAkRTtffEQfZLnSW9CwzX_oYzHdOE816OvciGadqV7RHaV1Q@mail.gmail.com>
        (Dmitry Torokhov's message of "Fri, 14 Jun 2019 15:49:30 -0700")
Message-ID: <875zp5rbpf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hcTgM-00045G-4G;;;mid=<875zp5rbpf.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/ysRzW/DjZLfSr+JJImozwhbNa5pFmzHw=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_XMDrugObfuBody_14 autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4827]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 T_XMDrugObfuBody_14 obfuscated drug references
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 625 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 4.1 (0.7%), b_tie_ro: 2.9 (0.5%), parse: 1.24
        (0.2%), extract_message_metadata: 17 (2.6%), get_uri_detail_list: 3.5
        (0.6%), tests_pri_-1000: 6 (1.0%), tests_pri_-950: 1.40 (0.2%),
        tests_pri_-900: 1.15 (0.2%), tests_pri_-90: 29 (4.7%), check_bayes: 27
        (4.4%), b_tokenize: 9 (1.5%), b_tok_get_all: 9 (1.4%), b_comp_prob:
        3.3 (0.5%), b_tok_touch_all: 3.6 (0.6%), b_finish: 0.65 (0.1%),
        tests_pri_0: 550 (88.0%), check_dkim_signature: 0.81 (0.1%),
        check_dkim_adsp: 2.3 (0.4%), poll_dns_idle: 0.36 (0.1%), tests_pri_10:
        2.3 (0.4%), tests_pri_500: 8 (1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH net-next 2/2 v5] netns: restrict uevents
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> Hi Christian,
>
> On Sun, Apr 29, 2018 at 3:45 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
>>
>> commit 07e98962fa77 ("kobject: Send hotplug events in all network namespaces")
>>abhishekbh@google.com
>> enabled sending hotplug events into all network namespaces back in 2010.
>> Over time the set of uevents that get sent into all network namespaces has
>> shrunk. We have now reached the point where hotplug events for all devices
>> that carry a namespace tag are filtered according to that namespace.
>> Specifically, they are filtered whenever the namespace tag of the kobject
>> does not match the namespace tag of the netlink socket.
>> Currently, only network devices carry namespace tags (i.e. network
>> namespace tags). Hence, uevents for network devices only show up in the
>> network namespace such devices are created in or moved to.
>>
>> However, any uevent for a kobject that does not have a namespace tag
>> associated with it will not be filtered and we will broadcast it into all
>> network namespaces. This behavior stopped making sense when user namespaces
>> were introduced.
>>
>> This patch simplifies and fixes couple of things:
>> - Split codepath for sending uevents by kobject namespace tags:
>>   1. Untagged kobjects - uevent_net_broadcast_untagged():
>>      Untagged kobjects will be broadcast into all uevent sockets recorded
>>      in uevent_sock_list, i.e. into all network namespacs owned by the
>>      intial user namespace.
>>   2. Tagged kobjects - uevent_net_broadcast_tagged():
>>      Tagged kobjects will only be broadcast into the network namespace they
>>      were tagged with.
>>   Handling of tagged kobjects in 2. does not cause any semantic changes.
>>   This is just splitting out the filtering logic that was handled by
>>   kobj_bcast_filter() before.
>>   Handling of untagged kobjects in 1. will cause a semantic change. The
>>   reasons why this is needed and ok have been discussed in [1]. Here is a
>>   short summary:
>>   - Userspace ignores uevents from network namespaces that are not owned by
>>     the intial user namespace:
>>     Uevents are filtered by userspace in a user namespace because the
>>     received uid != 0. Instead the uid associated with the event will be
>>     65534 == "nobody" because the global root uid is not mapped.
>>     This means we can safely and without introducing regressions modify the
>>     kernel to not send uevents into all network namespaces whose owning
>>     user namespace is not the initial user namespace because we know that
>>     userspace will ignore the message because of the uid anyway.
>>     I have a) verified that is is true for every udev implementation out
>>     there b) that this behavior has been present in all udev
>>     implementations from the very beginning.
>
> Unfortunately udev is not the only consumer of uevents, for example on
> Android there is healthd that also consumes uevents, and this
> particular change broke Android running in a container on Chrome OS.
> Can this be reverted? Or, if we want to keep this, how can containers
> that use separate user namespace still listen to uevents?

The code has been in the main tree for over a year so at a minimum
reverting this has the real chance of causing a regression for
folks like lxc.

I don't think Android running in a container on Chrome OS was even
available when this change was merged.  So I don't think this falls
under the ordinary no regression rules.

I may be wrong but I think this is a case of developing new code on an
old kernel and developing a dependence on a bug that had already been
fixed in newer kernels.  I know Christian did his best to reach out to
everyone when this change came through, so only getting a bug report
over a year after the code was merged is concerning.

That said uevents should be completely useless in a user namespace
except as letting you know something happened.  Is that what healthd
is using them for?


One solution would be to tweak the container userspace on ChromeOS to
listen to the uevents outside the container and to relay them into the
Android container.

Eric
