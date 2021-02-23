Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143BF3231D7
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhBWUIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:08:22 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:38615 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbhBWUGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 15:06:38 -0500
Received: from [192.168.1.155] ([77.9.11.4]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MjSHa-1lhxDs1SHa-00kzQO; Tue, 23 Feb 2021 20:54:18 +0100
Subject: Re: [PATCH] lib: vsprintf: check for NULL device_node name in
 device_node_string()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        linux@rasmusvillemoes.dk, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210217121543.13010-1-info@metux.net>
 <YC0fCAp6wxJfizD7@smile.fi.intel.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <1a010bef-4b13-06ea-e153-e76c4afe0ad1@metux.net>
Date:   Tue, 23 Feb 2021 20:54:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC0fCAp6wxJfizD7@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:YArMsHWW8jRv/C9fmYWhQh5832I+zbo3b4sJZ+Kji3zOWKTF5qJ
 F+3UJWlMcxIz05Z8xghblfwXa5/Ya/GhCGFQjxK2oyzy+1BN/G18Lo2hqQjWBVLf7X9vk1l
 471KYi6PVGLAEE8r9tjU3Gm/UutBPxFlWliPCBevOjF5e4lFDSoVClZq9v3xcYjhHkWzCqd
 0HuQvdlNxwobVrdodbX9g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ApSgkXDKLug=:myUB82SlknbqEKvr3bQCXL
 bm6DgRYOF4GP5zpTkqChvX1ttjZovPU45MeTYYjKCIP7E6maerdyDXCDIuirAhhLzqKQdb6mc
 zab/NEOw23pNWSH9f6h3zvfn/ABeYzwscXLfmpcJXomF0XNFkR9M0tbP4BDr0FTk6ZxHBXK25
 2WOWNobfJGquJL/ULjpvgdOrxPRxfOcm7vVZ03hVGTB83umemdKvZ5LMd4rXC8j/WmU3UOa4O
 FXWGUHeQH75DKwKyjknYd9iNUYy3AadP/H+vjZblae1MBs6L0OGHbSBZWqAstCt3bpaa12Vdi
 bymro8tKK4EfhPMXZ/7yLZ5GujcuSFgwy27DahCYeYHUl2p7Utoma7xeQ8E6KCKQNTBFmGyzn
 gRCyChLS/Dxd46IcEOcGJ24ZYL0/1ALUSKfa7GCj1FZB5dZTz9dEaacKu7kIQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.21 14:50, Andy Shevchenko wrote:
> On Wed, Feb 17, 2021 at 01:15:43PM +0100, Enrico Weigelt, metux IT consult wrote:
>> Under rare circumstances it may happen that a device node's name is NULL
>> (most likely kernel bug in some other place).
> 
> What circumstances? How can I reproduce this? More information, please!

Observed it when applying a broken overlay. (sorry, didn't keep that
broken code :o). In this case, the device_node was left without a name
(pointing to NULL).

>> +				pr_warn("device_node without name. Kernel bug ?\n");
> 
> If it's not once, then it's possible to have log spammed with this, right?

It only has occoured once for me. I don't think spamming could happen,
unless one's hacking deeply in the oftree code.

>> +				p = "<NULL>";
> 
> We have different standard de facto for NULL pointers to be printed. Actually
> if you wish, you may gather them under one definition (maybe somewhere under
> printk) and export to everybody to use.

Seen it in Petr's reply ... going to use that in v2.

--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
