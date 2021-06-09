Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ABD3A0868
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 02:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhFIA3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 20:29:01 -0400
Received: from novek.ru ([213.148.174.62]:33944 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232384AbhFIA27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 20:28:59 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 8D2E550048B;
        Wed,  9 Jun 2021 03:25:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 8D2E550048B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1623198323; bh=raYgrC7iYGAAHbmFTCbdldA7R4Nz93S6dtLj7TJHBec=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=xIANxlUUCq2Pt0r4pdzB8bKjNqorDzpSAiGZaG5Jk4uGS5RLQn6N1Ou3BLLbAI3nx
         N+oJvOrxAz0z9rNSkdg92zUJkY3Zf5Y2MkEi5lNVXCSLnvvc/TKtUgVg5Fw4Ojm/le
         yzfmVFsta+7DQCjczIe8yaNlrAKZXrS9ze4jDaa4=
Subject: Re: quic in-kernel implementation?
To:     Alexander Aring <aahringo@redhat.com>
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, smfrench@gmail.com,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <6b4027c4-7c25-fa98-42bc-f5b3a55e1d5a@novek.ru>
 <CAK-6q+gm0C2t50myG=qNJMOOBnM7-UjfNMHK_cyPdWY5nSudHQ@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <9ce530f5-cfe7-b1d4-ede6-d88801a769ba@novek.ru>
Date:   Wed, 9 Jun 2021 01:27:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAK-6q+gm0C2t50myG=qNJMOOBnM7-UjfNMHK_cyPdWY5nSudHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2021 22:06, Alexander Aring wrote:
> Hi Vadim,
> 
> On Tue, Jun 8, 2021 at 4:59 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>>
>> On 07.06.2021 16:25, Alexander Ahring Oder Aring wrote:
>>> Hi,
>>>
>>> as I notice there exists several quic user space implementations, is
>>> there any interest or process of doing an in-kernel implementation? I
>>> am asking because I would like to try out quic with an in-kernel
>>> application protocol like DLM. Besides DLM I've heard that the SMB
>>> community is also interested into such implementation.
>>>
>>> - Alex
>>>
>>
>> Hi!
>> I'm working on test in-kernel implementation of quic. It's based on the
>> kernel-tls work and uses the same ULP approach to setup connection
>> configuration. It's mostly about offload crypto operations of short header
>> to kernel and use user-space implementation to deal with any other types
>> of packets. Hope to test it till the end of June with some help from
>> Jakub.
> 
> Thanks, sounds interesting. Does this allow the kernel to create a quic socket?
> 

Not exactly. It's based on top of UDP socket and is configured by setsockopt
like it's done for Kernel TLS implementation. The main point of this work is to
offload cryptography only without implementing special address family.


