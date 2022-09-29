Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B271D5EFFF5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiI2WPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 18:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiI2WPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 18:15:52 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D655FE066;
        Thu, 29 Sep 2022 15:15:51 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:55560)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oe1oq-002lCZ-1p; Thu, 29 Sep 2022 16:15:48 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:45284 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oe1op-000Pl2-7Q; Thu, 29 Sep 2022 16:15:47 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
        <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
        <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV>
        <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
        <YzXzXNAgcJeJ3M0d@ZenIV> <YzYK7k3tgZy3Pwht@ZenIV>
        <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
Date:   Thu, 29 Sep 2022 17:14:15 -0500
In-Reply-To: <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 29 Sep 2022 14:29:03 -0700")
Message-ID: <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oe1op-000Pl2-7Q;;;mid=<871qrt4ymg.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/Kgg40InDQOLmiJmmc2A5ti3S+yB3YXvs=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 305 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 10 (3.2%), b_tie_ro: 8 (2.7%), parse: 1.05 (0.3%),
         extract_message_metadata: 13 (4.1%), get_uri_detail_list: 0.91 (0.3%),
         tests_pri_-1000: 9 (3.0%), tests_pri_-950: 1.06 (0.3%),
        tests_pri_-900: 0.80 (0.3%), tests_pri_-90: 114 (37.2%), check_bayes:
        111 (36.4%), b_tokenize: 4.7 (1.5%), b_tok_get_all: 5 (1.8%),
        b_comp_prob: 1.72 (0.6%), b_tok_touch_all: 96 (31.4%), b_finish: 0.99
        (0.3%), tests_pri_0: 145 (47.4%), check_dkim_signature: 0.45 (0.1%),
        check_dkim_adsp: 10 (3.2%), poll_dns_idle: 0.74 (0.2%), tests_pri_10:
        2.0 (0.7%), tests_pri_500: 7 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Sep 29, 2022 at 2:15 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> FWIW, what e.g. debian profile for dhclient has is
>>   @{PROC}/@{pid}/net/dev      r,
>>
>> Note that it's not
>>   @{PROC}/net/dev      r,
>
> Argh. Yeah, then a bind mount or a hardlink won't work either, you're
> right. I was assuming that any Apparmor rules allowed for just
> /proc/net.
>
> Oh well. I guess we're screwed any which way we turn.

I actually think there is a solution.

Instead of going to /proc/self/net -> /proc/tgid/net
or /proc/thread-self/net -> /proc/tgid/task/tid/net

We should be able to go to: /proc/tid/net

That directory does not show up in readdir, but the tid directories were
put in /proc because of how our pthread support evolved and gdb which
made gdb expect them to be their.

That should continue to work with the incomplete apparmor rules that
don't allow accessing /proc/tgid/tid/net for some reason.

Eric
