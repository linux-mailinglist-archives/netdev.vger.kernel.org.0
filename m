Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34AD6EA955
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDULgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 07:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjDULgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 07:36:25 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C636CCC0E;
        Fri, 21 Apr 2023 04:35:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id F1E15600F2;
        Fri, 21 Apr 2023 13:35:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682076952; bh=IGXmsfuT92LLRa2whQYPoOabsM4yoa1huIum4sr6paY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UMUmw7H1tbiK8/TCoS9hO9JwdWIZGWB/ELhzbpo0lTr/Fup5TWgNOaa2z8ESkMo4U
         kZfW0bZIU+ujtyaEjLS8YhAEbECelrsHHcU1c8LVW4N+oTPeB0i72GbgSbcY65/CxJ
         yjq+f5/BGlRbUQg+qJOFVmzq/xKpPRdfDNkuyAm6Lz6hmmZBQXBLnUPClsvMDnVMor
         i0//xHJ2KFNQXpzVQTJfEHnVA0mBnB9WiYVWkZosXBs+p0/4Ye5RNaPrRmUwDm9Qnv
         JZHsbByfpB8YEovdesZk5gq5z2sNuY5CVYVu6CJIx8b2DLCn9oaPD/jbYtA2mgLoGg
         W2q/Ic5T7dAFg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fIc5lsbTSreK; Fri, 21 Apr 2023 13:35:49 +0200 (CEST)
Received: from [10.0.1.117] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id 07681600E9;
        Fri, 21 Apr 2023 13:35:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682076949; bh=IGXmsfuT92LLRa2whQYPoOabsM4yoa1huIum4sr6paY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=xRxG1emW3QdvM8PKii4T+o7xqJ+LY1OYWGsJndx8RMTTwfNsc26dDz7AL/n+bpaRC
         hTDcraBZWaCwAlQ7x+G9JHgj11uEiE6Rj1Eu5heiTEZ9GZ35KjDKo4VksHr1wj4cc+
         9ijqxGiGLPIbPQ84z+dEL7GFRtFzvZ87pnf+1qLLpLXqWvB9EfjQdG9EPo+KZpK9QD
         AAd5WdL2yxc/NAyvLDBmzsQ9GI0kqmhpQ0V5swTvNlUQ8HgzrXRL+lwhjT6V0KHaGN
         jbba9/wpfB4ePfOmyDkBxqH0D8dfwPxjb//PT9ryyPhdYEVZo0dWeBmzwef21ffQXE
         AyRD5HcHYxN7g==
Message-ID: <060ff7a3-126f-3da5-4d93-0139e8fc4a9b@alu.unizg.hr>
Date:   Fri, 21 Apr 2023 13:35:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [BUG] [FIXED: TESTED] kmemleak in rtnetlink_rcv() triggered by
 selftests/drivers/net/team in build cdc9718d5e59
Content-Language: en-US, hr
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr>
 <ZDLyZX545Cw+aLhE@shredder>
 <67b3fa90-ad29-29f1-e6f3-fb674d255a1e@alu.unizg.hr>
 <7650b2eb-0aee-a2b0-2e64-c9bc63210f67@alu.unizg.hr>
 <ZDhHvUrkua8gLMfZ@shredder>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZDhHvUrkua8gLMfZ@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.4.2023. 20:19, Ido Schimmel wrote:
> On Mon, Apr 10, 2023 at 07:34:09PM +0200, Mirsad Goran Todorovac wrote:
>> I've ran "make kselftest" with vanilla torvalds tree 6.3-rc5 + your patch.
>>
>> It failed two lines after "enslaved device client - ns-A IP" which passed OK.
>>
>> Is this hang for 5 hours in selftests: net: fcnal-test.sh test, at the line
>> (please see to the end):
> 
> It's not clear to me if the test failed for you or just got stuck. The
> output below is all "[ OK ]".
> 
> I ran the test with my patch and got:
> 
> Tests passed: 875
> Tests failed:   5
> 
> I don't believe the failures are related to my patch given the test
> doesn't use bonding.
> 
> See more below.
> 
>>
>> # ###########################################################################
>> # IPv4 address binds
>> # ###########################################################################
>> #
>> #
>> # #################################################################
>> # No VRF
>> #
>> # SYSCTL: net.ipv4.ping_group_range=0 2147483647
>> #
>> # TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
>> # TEST: Raw socket bind to local address after device bind - ns-A IP            [ OK ]
>> # TEST: Raw socket bind to local address - ns-A loopback IP                     [ OK ]
>> # TEST: Raw socket bind to local address after device bind - ns-A loopback IP   [ OK ]
>> # TEST: Raw socket bind to nonlocal address - nonlocal IP                       [ OK ]
>> # TEST: TCP socket bind to nonlocal address - nonlocal IP                       [ OK ]
>> # TEST: ICMP socket bind to nonlocal address - nonlocal IP                      [ OK ]
>> # TEST: ICMP socket bind to broadcast address - broadcast                       [ OK ]
>> # TEST: ICMP socket bind to multicast address - multicast                       [ OK ]
>> # TEST: TCP socket bind to local address - ns-A IP                              [ OK ]
>> # TEST: TCP socket bind to local address after device bind - ns-A IP            [ OK ]
>> #
>> # #################################################################
>> # With VRF
>> #
>> # SYSCTL: net.ipv4.ping_group_range=0 2147483647
>> #
>> # TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
>> # TEST: Raw socket bind to local address after device bind - ns-A IP            [ OK ]
>> # TEST: Raw socket bind to local address after VRF bind - ns-A IP               [ OK ]
>> # TEST: Raw socket bind to local address - VRF IP                               [ OK ]
>> # TEST: Raw socket bind to local address after device bind - VRF IP             [ OK ]
>> # TEST: Raw socket bind to local address after VRF bind - VRF IP                [ OK ]
>> # TEST: Raw socket bind to out of scope address after VRF bind - ns-A loopback IP  [ OK ]
>> # TEST: Raw socket bind to nonlocal address after VRF bind - nonlocal IP        [ OK ]
>> # TEST: TCP socket bind to nonlocal address after VRF bind - nonlocal IP        [ OK ]
>> # TEST: ICMP socket bind to nonlocal address after VRF bind - nonlocal IP       [ OK ]
>> # TEST: ICMP socket bind to broadcast address after VRF bind - broadcast        [ OK ]
>> # TEST: ICMP socket bind to multicast address after VRF bind - multicast        [ OK ]
>> # TEST: TCP socket bind to local address - ns-A IP                              [ OK ]
>> # TEST: TCP socket bind to local address after device bind - ns-A IP            [ OK ]
>> # TEST: TCP socket bind to local address - VRF IP                               [ OK ]
>> # TEST: TCP socket bind to local address after device bind - VRF IP             [ OK ]
>> # TEST: TCP socket bind to invalid local address for VRF - ns-A loopback IP     [ OK ]
>> # TEST: TCP socket bind to invalid local address for device bind - ns-A loopback IP  [ OK ]
>> #
>> # ###########################################################################
>> # Run time tests - ipv4
>> # ###########################################################################
>> #
>> # TEST: Device delete with active traffic - ping in - ns-A IP                   [ OK ]
>> # TEST: Device delete with active traffic - ping in - VRF IP                    [ OK ]
>> # TEST: Device delete with active traffic - ping out - ns-B IP                  [ OK ]
>> # TEST: TCP active socket, global server - ns-A IP                              [ OK ]
>> # TEST: TCP active socket, global server - VRF IP                               [ OK ]
>> # TEST: TCP active socket, VRF server - ns-A IP                                 [ OK ]
>> # TEST: TCP active socket, VRF server - VRF IP                                  [ OK ]
>> # TEST: TCP active socket, enslaved device server - ns-A IP                     [ OK ]
>> # TEST: TCP active socket, VRF client - ns-A IP                                 [ OK ]
>> # TEST: TCP active socket, enslaved device client - ns-A IP                     [ OK ]
>> # TEST: TCP active socket, global server, VRF client, local - ns-A IP           [ OK ]
>> # TEST: TCP active socket, global server, VRF client, local - VRF IP            [ OK ]
>> # TEST: TCP active socket, VRF server and client, local - ns-A IP               [ OK ]
>> # TEST: TCP active socket, VRF server and client, local - VRF IP                [ OK ]
>> # TEST: TCP active socket, global server, enslaved device client, local - ns-A IP  [ OK ]
>> # TEST: TCP active socket, VRF server, enslaved device client, local - ns-A IP  [ OK ]
>> # TEST: TCP active socket, enslaved device server and client, local - ns-A IP   [ OK ]
>> # TEST: TCP passive socket, global server - ns-A IP                             [ OK ]
>> # TEST: TCP passive socket, global server - VRF IP                              [ OK ]
>> # TEST: TCP passive socket, VRF server - ns-A IP                                [ OK ]
>> # TEST: TCP passive socket, VRF server - VRF IP                                 [ OK ]
>> # TEST: TCP passive socket, enslaved device server - ns-A IP                    [ OK ]
>> # TEST: TCP passive socket, VRF client - ns-A IP                                [ OK ]
>> # TEST: TCP passive socket, enslaved device client - ns-A IP                    [ OK ]
>> # TEST: TCP passive socket, global server, VRF client, local - ns-A IP          [ OK ]
>>
>> Hope this helps.
>>
>> I also have a iwlwifi DEADLOCK and I don't know if these should be reported independently.
>> (I don't think it is related to the patch.)
> 
> If the test got stuck, then it might be related to the deadlock in
> iwlwifi. Try running the test without iwlwifi and see if it helps. If
> not, I suggest starting a different thread about this issue.
> 
> Will submit the bonding patch over the weekend.

Tested it again, with only the net selftest subtree:

tools/testing/selftests/Makefile:
TARGETS += drivers/net/bonding
TARGETS += drivers/net/team
TARGETS += net
TARGETS += net/af_unix
TARGETS += net/forwarding
TARGETS += net/hsr
# TARGETS += net/mptcp
TARGETS += net/openvswitch
TARGETS += netfilter

and it failed to reproduce the hang. (NOTE: In fact, it was only a script stall forever,
not a "kill -9 <PID>" non-killable process.)

With or without iwlwifi module, now it appears to work as a standalone test.

The problem might indeed be a spurious lockup in iwlwifi. I've noticed an attempt to
lock a locked lock from within the interrupt in the journalctl logs, but I am really
not that familiar with the iwlwifi driver's code ... It is apparently not a deterministic
error bound to repeat with every test.

I reckon the tests prior to the net subtree have done something to my kernel but thus far
I could not isolate the culprit test.

# tools/testing/selftests/net/fcnal-test.sh alone passes OK.

> Thanks for testing

Not at all. I apologise for the false alarm.

Thanks for patching at such short notice.

The patch closes the memory leak, and the latest change was obviously the most suspected one,
but now it doesn't seem so.

It would require more work to isolate the particular test that caused the hang, but I don't
know if I have enough resources, mainly the time. And the guiding idea that I am going in the
right direction. :-/

Best regards,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union

Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

