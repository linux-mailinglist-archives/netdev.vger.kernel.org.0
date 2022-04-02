Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3014EFFBA
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 10:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbiDBIoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 04:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiDBIod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 04:44:33 -0400
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB3B1B7638;
        Sat,  2 Apr 2022 01:42:36 -0700 (PDT)
Received: from [165.16.203.119] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1naZKz-0007Eo-41; Sat, 02 Apr 2022 10:42:25 +0200
Received: from [192.168.42.201]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1naZKx-0008NW-6w; Sat, 02 Apr 2022 10:42:23 +0200
Message-ID: <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
Date:   Sat, 2 Apr 2022 10:42:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Neal Cardwell <ncardwell@google.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>
References: <E1nZMdl-0006nG-0J@plastiekpoot>
 <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
 <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
 <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neal,

On 2022/04/01 17:39, Neal Cardwell wrote:
> On Tue, Mar 29, 2022 at 9:03 PM Jaco <jaco@uls.co.za> wrote:
> ...
>> Connection setup:
>>
>> 00:56:17.055481 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450:400c:c07::1b.25: Flags [S], seq 956633779, win 62580, options [mss 8940,nop,nop,TS val 3687705482 ecr 0,nop,wscale 7,tfo  cookie f025dd84b6122510,nop,nop], length 0
>>
>> 00:56:17.217747 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110: Flags [S.], seq 726465675, ack 956633780, win 65535, options [mss 1440,nop,nop,TS val 3477429218 ecr 3687705482,nop,wscale 8], length 0
>>
>> 00:56:17.218628 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110: Flags [P.], seq 726465676:726465760, ack 956633780, win 256, options [nop,nop,TS val 3477429220 ecr 3687705482], length 84: SMTP: 220 mx.google.com ESMTP e16-20020a05600c4e5000b0038c77be9b2dsi226281wmq.72 - gsmtp
>>
>> 00:56:17.218663 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450:400c:c07::1b.25: Flags [.], ack 726465760, win 489, options [nop,nop,TS val 3687705645 ecr 3477429220], length 0
>>
>> This is pretty normal, we advertise an MSS of 8940 and the return is 1440, thus
>> we shouldn't send segments larger than that, and they "can't".  I need to
>> determine if this is some form of offloading or they really are sending >1500
>> byte frames (which I know won't pass our firewalls without fragmentation so
>> probably some form of NIC offloading - which if it was active on older 5.8
>> kernels did not cause problems):
> Jaco, was there some previous kernel version on these client machines
> where this problem did not show up? Perhaps the v5.8 version you
> mention here? Can you please share the exact version number?
5.8.14
>
> If so, a hypothesis would be:
>
> (1) There is a bug in netfilter's handling of TFO connections where
> the server sends a data packet after a TFO SYNACK, before the client
> ACKs anything (as we see in this trace).
>
> This bug is perhaps similar in character to the bug fixed by Yuchung's
> 2013 commit that Eric mentioned:
>
> 356d7d88e088687b6578ca64601b0a2c9d145296
> netfilter: nf_conntrack: fix tcp_in_window for Fast Open
>
> (2) With kernel v5.8, TFO blackhole detection detected that in your
> workload there were TFO connections that died due to apparent
> blackholing (like what's shown in the trace), and dynamically disabled
> TFO on your machines. This allowed mail traffic to flow, because the
> netfilter bug was no longer tickled. This worked around the netfilter
> bug.
>
> (3) You upgraded your client-side machine from v5.8 to v5.17, which
> has the following commit from v5.14, which disables TFO blackhole
> logic by default:
>   213ad73d0607 tcp: disable TFO blackhole logic by default
>
> (4) Due to (3), the blackhole detection logic was no longer operative,
> and when the netfilter bug blackholed the connection, TFO stayed
> enabled. This caused mail traffic to Google to stall.
>
> This hypothesis would explain why:
>   o disabling TFO fixes this problem
>   o you are seeing this with a newer kernel (and apparently not with a
> kernel before v5.14?)
Agreed.
>
> With this hypothesis, we need several pieces to trigger this:
>
> (a) client side software that tries TFO to a server that supports TFO
> (like the exim mail transfer agent you are using, connecting to
> Google)
>
> (b) a client-side Linux kernel running buggy netfilter code (you are
> running netfilter)
>
> (c) a client-side Linux kernel with TFO support but no blackhole
> detection logic active (e.g. v5.14 or later, like your v5.17.1)
>
> That's probably a rare combination, so would explain why we have not
> had this report before.
>
> Jaco, to provide some evidence for this hypothesis, can you please
> re-enable fastopen but also enable the TFO blackhole detection that
> was disabled in v5.14 (213ad73d0607), with something like:
>
>   sysctl -w net.ipv4.tcp_fastopen=1
>   sysctl -w tcp_fastopen_blackhole_timeout=3600

Done.

Including sysctl net.netfilter.nf_conntrack_log_invalid=6- which
generates lots of logs, something specific I should be looking for?  I
suspect these relate:

[Sat Apr  2 10:31:53 2022] nf_ct_proto_6: SEQ is over the upper bound
(over the window of the receiver) IN= OUT=bond0
SRC=2c0f:f720:0000:0003:d6ae:52ff:feb8:f27b
DST=2a00:1450:400c:0c08:0000:0000:0000:001a LEN=2928 TC=0 HOPLIMIT=64
FLOWLBL=867133 PROTO=TCP SPT=48920 DPT=25 SEQ=2689938314 ACK=4200412020
WINDOW=447 RES=0x00 ACK PSH URGP=0 OPT (0101080A2F36C1C120EDFB91) UID=8
GID=12
[Sat Apr  2 10:31:53 2022] nf_ct_proto_6: SEQ is over the upper bound
(over the window of the receiver) IN= OUT=bond0
SRC=2c0f:f720:0000:0003:d6ae:52ff:feb8:f27b
DST=2a00:1450:400c:0c08:0000:0000:0000:001a LEN=2928 TC=0 HOPLIMIT=64
FLOWLBL=867133 PROTO=TCP SPT=48920 DPT=25 SEQ=2689941170 ACK=4200412020
WINDOW=447 RES=0x00 ACK PSH URGP=0 OPT (0101080A2F36C1C120EDFB91) UID=8
GID=12

(There are many more of those, and the remote side is Google in this case)

>
> And then after a few hours, check to see if this blackholing behavior
> has been detected:
>   nstat -az | grep -i blackhole
> And see if TFO FastOpenActive attempts have been cut to a super-low rate:
>   nstat -az | grep -i fastopenactive

uriel [06:10:03] ~ # nstat -az | grep -i fastopen
TcpExtTCPFastOpenActive         0                  0.0
TcpExtTCPFastOpenActiveFail     3739               0.0
TcpExtTCPFastOpenPassive        0                  0.0
TcpExtTCPFastOpenPassiveFail    0                  0.0
TcpExtTCPFastOpenListenOverflow 0                  0.0
TcpExtTCPFastOpenCookieReqd     3378               0.0
TcpExtTCPFastOpenBlackhole      0                  0.0
TcpExtTCPFastOpenPassiveAltKey  0                  0.0

uriel [09:54:54] ~ # nstat -az | grep -i fastopen
TcpExtTCPFastOpenActive         0                  0.0
TcpExtTCPFastOpenActiveFail     3742               0.0
TcpExtTCPFastOpenPassive        0                  0.0
TcpExtTCPFastOpenPassiveFail    0                  0.0
TcpExtTCPFastOpenListenOverflow 0                  0.0
TcpExtTCPFastOpenCookieReqd     3391               0.0
TcpExtTCPFastOpenBlackhole      3                  0.0
TcpExtTCPFastOpenPassiveAltKey  0                  0.0

I'm fairly certain that strongly supports your theory.  So I *suspect*
the next test would be something like:

Disable the blackhole again, let the queue build up a few minutes until
we have something from google.  Shut down exim so we can isolate SMTP
traffic.  tcpdump again, capturing the traffic, and correlate the FW
logs with the connection?

Kind Regards,
Jaco

