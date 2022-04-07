Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECF64F892D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiDGVbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 17:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiDGVbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 17:31:01 -0400
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B331A3AC1
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 14:28:59 -0700 (PDT)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.121])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6674A1A007B;
        Thu,  7 Apr 2022 21:28:57 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 238E64C0085;
        Thu,  7 Apr 2022 21:28:57 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B10C413C2B0;
        Thu,  7 Apr 2022 14:28:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B10C413C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1649366936;
        bh=TeADXBrWDlLv4npLX9gXr02YU78lLeH4grDogWZV6/o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CGSeZYnepeV8AoPqBWtfpmMIi8XnTaJYv+w9PUgxGFbVycCJcFsQ+/wwxvIyvjlSC
         wa6tGbTS8QeGdT9qZwGPa1wDIqGxtYv1IGin2ammRx/5qUWDJpglTRhQg5BgONJLvJ
         t7rfoIWCMH66qYJrNz7GeceRSbJQ/qF9EYRIqww0=
Subject: Re: Matching unbound sockets for VRF
To:     David Ahern <dsahern@gmail.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20220324171930.GA21272@EXT-6P2T573.localdomain>
 <7b5eb495-a3fe-843f-9020-0268fb681c72@gmail.com>
 <YkBfQqz66FxYmGVV@ssuryadesk>
 <2bbfde7b-7b67-68fd-f62b-f9cd9b89d2ad@gmail.com>
 <20220404124104.GA18315@EXT-6P2T573.localdomain>
 <f174108c-67c5-3bb6-d558-7e02de701ee2@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <a4bf2fb7-b9a4-55c5-339e-baf84dc9b241@candelatech.com>
Date:   Thu, 7 Apr 2022 14:28:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f174108c-67c5-3bb6-d558-7e02de701ee2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1649366937-hUGAv1h7Buod
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/22 7:32 AM, David Ahern wrote:
> On 4/4/22 6:41 AM, Stephen Suryaputra wrote:
>> On Sun, Apr 03, 2022 at 10:24:36AM -0600, David Ahern wrote:
>>> On 3/27/22 6:57 AM, Stephen Suryaputra wrote:
>>>>
>>>> The reproducer script is attached.
>>>>
>>>
>>> h0 has the mgmt vrf, the l3mdev settings yet is running the client in
>>> *default* vrf. Add 'ip vrf exec mgmt' before the 'nc' and it works.
>>
>> Yes. With "ip vrf exec mgmt" nc would work. We know that. See more
>> below.
>>
>>> Are you saying that before Mike and Robert's changes you could get a
>>> client to run in default VRF and work over mgmt VRF? If so it required
>>> some ugly routing tricks (the last fib rule you installed) and is a bug
>>> relative to the VRF design.
>>
>> Yes, before Mike and Robert's changes the client ran fine because of the
>> last fib rule. We did that because some of our applications are:
>> 1) Pre-dates "ip vrf exec"
>> 2) LD_PRELOAD trick from the early days doesn't work
>>
>> On the case (2) above, one concrete example is NFS mounting our images:
>> applications and kernel modules. We had to run less than full-blown
>> utilities and also the mount command uses glibc RPC functions
>> (pmap_getmaps(), clntudp_create(), clnt_call(), etc, etc.). We analyzed
>> it back then that because these functions are in glibc and call socket()
>> from within glibc, the LD_PRELOAD doesn't work.
>>
>>  From the thread of Mike and Robert's changes, the conclusion is that the
>> previous behavior is a bug but we have been relying on it for a while,
>> since the early days of VRFs, and an upgrade that includes the changes
>> caused some applications to not work anymore.
>>
>> I'm asking if Mike and Robert's changes should be controlled by an
>> option, e.g. sysctl, and be the default. But can be reverted back to the
>> previous behavior.
>>
> 
> It has been 3-1/2 years since that patch. Rather than add more checks to
> try to manage unintended app behavior, why not work on making your apps
> consistent with the intent of the VRF design? If adding `ip vrf exec
> VRF` before commands works, that is a very simple solution and the
> reason for the command (handle code that is not VRF aware).
> 
> I'm guessing that option will not work for all cases (e.g., NFS which I
> think Ben has asked about as well, cc'ed), but working towards making
> the code align with VRF design is the longer term win.

NFS certainly wouldn't work.  It builds its sockets in the kernel in a convoluted
call path.  I tried to make NFS work with VRF at one time, found it very painful
and not worth the effort, especially since I figured patches would never make it
upstream.

We have out-of-tree patches to at least make NFS work with source based routing,
but those patches were not accepted upstream (2011 timeframe may be last I tried),
so stock kernels + NFS plus interesting routing
pretty much doesn't work at all as far as I can tell.

If binding NFS to source IPs is interesting in this day and time, I can try reposting
my patches, or you can grab them from one of my trees:

Somewhere around 800 patches down from HEAD, first few patches after the upstream
rebase point:

https://github.com/greearb/linux-ct-5.17

https://github.com/greearb/nfs-utils-ct

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

