Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8840A48E8BD
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 11:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbiANK6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 05:58:24 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:53624 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240638AbiANK6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 05:58:24 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 800F520CD7DE
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] bcmgenet: add WOL IRQ check
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>
References: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
 <YeCS6Ld93zCK6aWh@lunn.ch> <184f55fb-c73b-989b-973e-e9562f511116@gmail.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <3bc2809a-b8b1-b6bd-139f-2a6000b6f8d1@omp.ru>
Date:   Fri, 14 Jan 2022 13:58:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <184f55fb-c73b-989b-973e-e9562f511116@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 1/14/22 12:37 AM, Florian Fainelli wrote:

>>> The driver neglects to check the result of platform_get_irq_optional()'s
>>> call and blithely passes the negative error codes to devm_request_irq()
>>> (which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
>>> Stop calling devm_request_irq() with the invalid IRQ #s.
>>>
>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>>
>>> ---
>>> This patch is against DaveM's 'net.git' repo.
>>
>> Since this is for net, it needs a Fixes: tag.
>>
>> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
> 
> I don't have strong objections whether we want to consider this a bug fix or not,

   Formally, it's a fix -- as you shouldn't call devm_request_irq() with "negative" IRQ #s.

> but since the code only acts upon devm_request_irq() returning 0 meaning success, this seems more like an improvement rather than fixing an actual issue.

   More like a cleanup (no, not improvement).

MBR, Sergey
