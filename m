Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C196EDD94
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjDYIEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbjDYIEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:04:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B8F170D
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:04:51 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-507bdc5ca2aso9634389a12.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1682409890; x=1685001890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NjpvhDlUzs+FH6psAy6L7Qnb3qb5q6XYt4SuREIyvuo=;
        b=x/qDgxFZdquJgvVuoNG+pNaTL92jic7Eanbca1ZdZReiQXlMI29baH3v+qPXuohcdE
         8hYQNWArhq+TV20aJloFcvpsYUDc1XYtq8pfGYawLOvi926U83kZVrTrbSsqMvdDLy+i
         ceaXVI3DYXXHZU7VELiWPuugpCJ5YdGwgyg26U6mnIvYvXy4fIyFYWo0iQiyZVGI3Shs
         4eHSIVH+QJDzjIA0gdjpL/BB2vH/efLph/XpQwgH8rjBDtn9bRGhZRDVLMIzyNpUYzm5
         5kGuCu1Oy7Fy5CgFLy4tmrcik0+O/xEQGk8PTp50586SInTXeIcogLywQJZIdTgD0nhO
         1r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682409890; x=1685001890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NjpvhDlUzs+FH6psAy6L7Qnb3qb5q6XYt4SuREIyvuo=;
        b=gR+gpdWjsG+8F9LqGiCNTvmzb7f4zWHnOxvaXIAKMQ1n2xer7rsk797IYnZLTRkcr5
         YsgQdATGEtkMR7jOcbI87RQqgkFZ3pHzd8Vn7eA2y4SOj77y3XUi3yhn/+E+9Xft/pLC
         Eti/cme23fJGP5UEbIjInLFP/drnmJ87mJctZ/5D/HHZBQ/73IAtsB+Tz+DjdW2DXdFI
         JnoRRBw6D5THs6NcsOVxNTFOaLCMjVMv/d9VVZ/oEWFBsILD5dxlfA3w3fKRJULJLdi4
         +LcD3XBM0bBH7+q33iUFFeMxn9uPYCLkfpq7Hf4D1AfJYPRB8Las/rGRaeHceVpfz/VT
         44PQ==
X-Gm-Message-State: AAQBX9cFs8D47RxQlWXnmDBFtS7u3m7HX3EWV+UFg0v+bA8wtvTzsgSF
        PTQWb1USuLxWTkZh1Z0fgNmsjQ==
X-Google-Smtp-Source: AKy350ZbgTZxZCZWhg17IJ7dGX8SG51JSAQOeVeHrpC+C3zzMNhfWdKJWnvy2jX3UzWozSIPKdi/+Q==
X-Received: by 2002:a05:6402:3d1:b0:506:be3f:ebb1 with SMTP id t17-20020a05640203d100b00506be3febb1mr13449039edw.26.1682409889626;
        Tue, 25 Apr 2023 01:04:49 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id d18-20020aa7ce12000000b00509d375a0c0sm2753193edv.49.2023.04.25.01.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 01:04:48 -0700 (PDT)
Message-ID: <5ddac447-c268-e559-a8dc-08ae3d124352@blackwall.org>
Date:   Tue, 25 Apr 2023 11:04:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Question] Any plan to write/update the bridge doc?
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org, Jakub Kicinski <kuba@kernel.org>
References: <ZEZK9AkChoOF3Lys@Laptop-X1> <ZEakbR71vNuLnEFp@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZEakbR71vNuLnEFp@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2023 18:46, Ido Schimmel wrote:
> On Mon, Apr 24, 2023 at 05:25:08PM +0800, Hangbin Liu wrote:
>> Hi,
>>
>> Maybe someone already has asked. The only official Linux bridge document I
>> got is a very ancient wiki page[1] or the ip link man page[2][3]. As there are
>> many bridge stp/vlan/multicast paramegers. Should we add a detailed kernel
>> document about each parameter? The parameter showed in ip link page seems
>> a little brief.
> 
> I suggest improving the man pages instead of adding kernel
> documentation. The man pages are the most up to date resource and
> therefore the one users probably refer to the most. Also, it's already
> quite annoying to patch both "ip-link" and "bridge" man pages when
> adding bridge port options. Adding a third document and making sure all
> three resources are patched would be a nightmare...
> 
>>
>> I'd like to help do this work. But apparently neither my English nor my
>> understanding of the code is good enough. Anyway, if you want, I can help
>> write a draft version first and you (bridge maintainers) keep working on this.
> 
> I can help reviewing man page patches if you want. I'm going to send
> some soon. Will copy you.
> 
>>
>> [1] https://wiki.linuxfoundation.org/networking/bridge
>> [2] https://man7.org/linux/man-pages/man8/bridge.8.html
>> [3] https://man7.org/linux/man-pages/man8/ip-link.8.html
>>
>> Thanks
>> Hangbin

Always +1 for keeping the man pages up-to-date, but I tend to agree with Jakub as well
that it'd be nice to have an in-kernel doc which explains the uapi and potentially
at least some more obscure internals (if not all), we can insist on updating it
for new changes

I'd be happy to help fill such doc, but at the moment I don't have the
time to write the basis for it. As Hangbin nicely offered, I think we can start
there. For a start it'd be nice to make an initial outline of the different sections
and go on filling them from there.

E.g. as a starter something like (feel free to edit):
Introduction
Bridge internals (fdb, timers, MTU handling, fwding decisions, ports, synchronization)
STP (mst, rstp, timers, user-space stp etc)
Multicast (mdb, igmp, eht, vlan-mcast etc)
VLAN (filtering, options, tunnel...)
Switchdev
Netfilter
MRP/CFM (?)
FAQ

Each of these having uapi sections with descriptions. We can include references
to the iproute2 docs for cmd explanations and examples, but in this doc we'll have
the uapi descriptions and maybe some helpful information about internal implementation
that would save future contributors time.

At the very least we can do the uapi part for each section so options are described
and uapi nl attribute structures are explained.

Cheers,
 Nik

