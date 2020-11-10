Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309C22ADFE2
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbgKJTiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:38:09 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:1711 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731297AbgKJTiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:38:09 -0500
Received: from [10.193.177.165] (sicon-nithya-lt.asicdesigners.com [10.193.177.165] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0AAJbuRQ000679;
        Tue, 10 Nov 2020 11:37:57 -0800
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
 <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
 <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
 <20201105104658.4f96cc90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a9d6ec03-1638-6282-470a-3a6b09b96652@chelsio.com>
 <20201106122831.5fccebe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8c7a1bab-3c7b-e3bf-3572-afdf2abd2505@chelsio.com>
 <20201109105851.41417807@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <0cd430df-167a-be86-66c5-f0838ed24641@chelsio.com>
 <20201110082832.4ef61eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <4fdc9dd2-fbdf-2d5e-9836-74cb8dd3062c@chelsio.com>
Date:   Wed, 11 Nov 2020 01:19:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201110082832.4ef61eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2020 9:58 PM, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 10:37:11 +0530 Vinay Kumar Yadav wrote:
>> It is not incompatible. It fits in k.org tls infrastructure (TLS-TOE
>> mode). For the current issue we have proposed a fix. What is the issue
>> with proposed fix, can you elaborate and we will address that?
> 
> Your lack of understanding of how netdev offloads are supposed to work
> is concerning. Application is not supposed to see any difference
> between offloaded and non-offloaded modes of operation.
> 
For application point of view there won't be any difference.
kernel tls in tcp offload mode works exactly similar to software
kTLS.

> Your offload was accepted based on the assumption that it works like
> the software kernel TLS mode. Nobody had the time to look at your
> thousands lines of driver code at the time.
> 
> Now you're telling us that the uAPI for the offload is completely
> different - it only works on listening sockets while software tls
> only works on established sockets. Ergo there is no software fallback
> for your offload.
>
We can consider adding the capability to working with established 
sockets.The TOE has not needed that capability to date since it can 
establish the socket itself, but it makes sense to provide uniformity 
with the kTLS approach so we will look into that.  For now, as you 
suggested replacing stack listen with toe listen makes more sense.

> Furthermore the severity of the bugs you just started to fix now, after
> the code has been in the kernel for over a year suggests there are no
> serious users and we can just remove this code.
> 
It’s been a slow process but with the new team it is picking up speed
and the quality of the code will continue to get better.
