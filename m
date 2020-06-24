Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2744F2069E4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 03:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbgFXB44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 21:56:56 -0400
Received: from mail.loongson.cn ([114.242.206.163]:51132 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388035AbgFXB44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 21:56:56 -0400
Received: from [10.130.0.66] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxb2ngsvJe9gdJAA--.10046S3;
        Wed, 24 Jun 2020 09:56:49 +0800 (CST)
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
To:     David Miller <davem@davemloft.net>
References: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
 <20200623.143311.995885759487352025.davem@davemloft.net>
 <20200623.152626.2206118203643133195.davem@davemloft.net>
Cc:     benve@cisco.com, _govind@gmx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lixuefeng@loongson.cn,
        yangtiezhu@loongson.cn
From:   Kaige Li <likaige@loongson.cn>
Message-ID: <7533075e-0e8e-2fde-c8fa-72e2ea222176@loongson.cn>
Date:   Wed, 24 Jun 2020 09:56:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20200623.152626.2206118203643133195.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dxb2ngsvJe9gdJAA--.10046S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYf7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
        6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
        kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8I
        cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7
        Mxk0xIA0c2IEe2xFo4CEbIxvr21lc2xSY4AK67AK6w4l42xK82IYc2Ij64vIr41l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
        0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0
        rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr
        0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VU1ItC7UUUUU==
X-CM-SenderInfo: 5olntxtjh6z05rqj20fqof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/24/2020 06:26 AM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 23 Jun 2020 14:33:11 -0700 (PDT)
>
>> Calling a NIC driver open function from a context holding a spinlock
>> is very much the real problem, so many operations have to sleep and
>> in face that ->ndo_open() method is defined as being allowed to sleep
>> and that's why the core networking never invokes it with spinlocks
>                                                        ^^^^
>
> I mean "without" of course. :-)
>
>> held.

Did you mean that open function should be out of spinlock? If so, I will
send V2 patch.

Thank you.

