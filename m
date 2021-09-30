Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8F341E429
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 00:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347860AbhI3W6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 18:58:01 -0400
Received: from novek.ru ([213.148.174.62]:57582 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhI3W6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 18:58:00 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 3A697500E42;
        Fri,  1 Oct 2021 01:52:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 3A697500E42
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1633042360; bh=pBmbYEvSQ2igeao6j7ZKLKLjcqocxsHAZzhH56XiBP0=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=r0ltOYaibK2S0oWytemd+c6lULUqcZqo0guVZkTlplPXgLBh1OavhAxKzqM2Kb6Zt
         Y+dSp/4fbdzwRnyyaTGRQFnvgJePBgErZU7fmNtnm2Fuvt96HpkoWBvftKYcNJV1JH
         +8ltMlQsvXNMe/qa9E4me0tRS8ZnGqr723dt3bT8=
Subject: Re: [PATCH] net/tls: support SM4 CCM algorithm
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210928062843.75283-1-tianjia.zhang@linux.alibaba.com>
 <1761d06d-0958-7872-04de-cde6ddf8a948@novek.ru>
 <1195374a-a9d4-0431-015b-60d986e29881@linux.alibaba.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <16a76d3e-910f-4fdf-5b2d-9f3355cce4ca@novek.ru>
Date:   Thu, 30 Sep 2021 23:56:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1195374a-a9d4-0431-015b-60d986e29881@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2021 04:34, Tianjia Zhang wrote:
> Hi Vadim,
> 
> On 9/29/21 5:24 AM, Vadim Fedorenko wrote:
>> On 28.09.2021 07:28, Tianjia Zhang wrote:
>>> The IV of CCM mode has special requirements, this patch supports CCM
>>> mode of SM4 algorithm.
>>>
>> Have you tried to connect this implementation to application with
>> user-space implementation of CCM mode? I wonder just because I have an
>> issue with AES-CCM Kernel TLS implementation when it's connected to
>> OpenSSL-driven server, but still have no time to fix it correctly.
> 
> I did not encounter any issue when using KTLS with AES-CCM algorithm, but the 
> KTLS RX mode on the OpenSSL side does not seem to be supported.
> 
> I encountered some problems when using the SM4-CCM algorithm of KTLS. Follow the 
> RFC8998 specification, the handshake has been successful, and the first data 
> transmission can be successful. After that, I will encounter the problem of MAC 
> verification failure, but this is issue on the OpenSSL side. because the problem 
> is still being investigated, I have not opened the code for the time being.
> 
Are you sure that this is an issue on the OpenSSL side? Because absolutely the 
same problem is reported for AES-CCM algo and only when it's offloaded to 
kernel. Looks like encryption of CCM could be broken somehow.

I will try to investigate it a bit later from the AES-CCM side.

