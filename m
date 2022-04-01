Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313D64EEC70
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345547AbiDALim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiDALil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:38:41 -0400
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70441D66F6;
        Fri,  1 Apr 2022 04:36:48 -0700 (PDT)
Received: from [2c0f:f720:fe16:c400::1] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1naFa9-0005b8-R9; Fri, 01 Apr 2022 13:36:45 +0200
Received: from [192.168.42.201]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1naFa8-0001Tr-R7; Fri, 01 Apr 2022 13:36:45 +0200
Message-ID: <628a909d-1090-dc62-a730-fd9514079218@uls.co.za>
Date:   Fri, 1 Apr 2022 13:36:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
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
 <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
 <4b4ff443-f8a9-26a8-8342-ae78b999335b@uls.co.za>
 <CANn89iL203ZuRdcyxh16yKXqxXJW2u+4559DsDFmW=8S+_n7fg@mail.gmail.com>
 <CANn89i+6LCWOZahAi_vPf9H=SKw-4vdMTj5T0dYsp1Se4g9-yw@mail.gmail.com>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <CANn89i+6LCWOZahAi_vPf9H=SKw-4vdMTj5T0dYsp1Se4g9-yw@mail.gmail.com>
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

Hi Eric,

On 2022/04/01 02:54, Eric Dumazet wrote:
> On Thu, Mar 31, 2022 at 5:41 PM Eric Dumazet <edumazet@google.com> wrote:
>> On Thu, Mar 31, 2022 at 5:33 PM Jaco Kroon <jaco@uls.co.za> wrote:
>>
>>> I'll deploy same on a dev host we've got in the coming week and start a
>>> bisect process.
>> Thanks, this will definitely help.
> One thing I noticed in your pcap is a good amount of drops, as if
> Hystart was not able to stop slow-start before the drops are
> happening.
>
> TFO with one less RTT at connection establishment could be the trigger.
>
> If you are still using cubic, please try to revert.
Sorry, I understand TCP itself a bit, but I've given up trying to
understand the various schedulers a long time ago and am just using the
defaults that the kernel provides.  How do I check what I'm using, and
how can I change that?  What is recommended at this stage?
>
>
> commit 4e1fddc98d2585ddd4792b5e44433dcee7ece001
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Tue Nov 23 12:25:35 2021 -0800
>
>     tcp_cubic: fix spurious Hystart ACK train detections for
> not-cwnd-limited flows
Ok, instead of starting with bisect, if I can reproduce in dev I'll use
this one first.

Kind Regards,
Jaco
