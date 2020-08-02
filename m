Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B153235793
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 16:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgHBO0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 10:26:54 -0400
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:58570
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726058AbgHBO0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 10:26:53 -0400
Received: from [101.5.209.60] (unknown [101.5.209.60])
        by app-1 (Coremail) with SMTP id DwQGZQA3PeUJzSZfLxPrAw--.8196S2;
        Sun, 02 Aug 2020 22:26:19 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: [BUG] net: rocker: accessing the data mapped to streaming DMA
To:     jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <a89769ea-67fd-89ce-d8fc-c12d98538065@tsinghua.edu.cn>
Date:   Sun, 2 Aug 2020 22:26:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: DwQGZQA3PeUJzSZfLxPrAw--.8196S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYI7k0a2IF6w1UM7kC6x804xWl14x267AK
        xVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGw
        A2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj
        6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gc
        CE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxI
        r21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87
        Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS
        07AlzVAYIcxG8wCY02Avz4vE14v_Xryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyU
        JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjxUcWrWUUUUU
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rocker_dma_test_offset(), "buf" is mapped to streaming DMA on line 203:
   dma_handle = pci_map_single(..., buf, ...);

Then, "buf" is accessed on line 229:
   expect[i] = ~buf[i];

This access may cause data inconsistency between CPU cache and hardware.

I am not sure how to properly fix this problem, and thus I only report it.


Best wishes,
Jia-Ju Bai

