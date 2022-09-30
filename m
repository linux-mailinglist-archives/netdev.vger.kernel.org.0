Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434C45F03FE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 07:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiI3FD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 01:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiI3FD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 01:03:28 -0400
Received: from cstnet.cn (smtp23.cstnet.cn [159.226.251.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 855473C143;
        Thu, 29 Sep 2022 22:03:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-03 (Coremail) with SMTP id rQCowACHOVmWeDZjhiuKAg--.4078S2;
        Fri, 30 Sep 2022 13:03:18 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     kuba@kernel.org
Cc:     pabeni@redhat.com, davem@davemloft.net, tchornyi@marvell.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>
Subject: Re: Re: [PATCH] net: prestera: acl: Add check for kmemdup
Date:   Fri, 30 Sep 2022 13:03:17 +0800
Message-Id: <20220930050317.32706-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowACHOVmWeDZjhiuKAg--.4078S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW8Gr1xGFy3CF15JFy7ZFb_yoW8CFy3p3
        yYkr13CFyktryxAw47Cw1UuasYga1UKF15Xrs5uayI9wnIqrs8GrWFyF429r1UGFWrWa43
        tr42g3Z5Ka1UXa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        WwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUP5rcUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 00:15:27 +0800 Jakub Kicinski wrote:
> On Wed, 28 Sep 2022 17:20:24 +0800 Jiasheng Jiang wrote:
>> As the kemdup could return NULL, it should be better to check the return
>> value and return error if fails.
>> Moreover, the return value of prestera_acl_ruleset_keymask_set() should
>> be checked by cascade.
>> 
>> Fixes: 604ba230902d ("net: prestera: flower template support")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> You must CC the authors of patch you're fixing. 
> get_maintainer will do that for you I don't understand why people can't
> simply run that script :/ You CC linux-kernel for no apparent reason
> yet you don't CC the guy who wrote the original patch.
> If you could please explain what is going on maybe we can improve the
> tooling or something.

Actually, I used get_maintainer scripts and the results is as follow:
"./scripts/get_maintainer.pl -f drivers/net/ethernet/marvell/prestera/prestera_acl.c"
Taras Chornyi <tchornyi@marvell.com> (supporter:MARVELL PRESTERA ETHERNET SWITCH DRIVER)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

Therefore, I submitted my patch to the above addresses.

And this time I checked the fixes commit, and found that it has two
authors:
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

Maybe there is a problem of the script that misses one.
Anyway, I have already submitted the same patch and added
"vmytnyk@marvell.com" this time.

Thanks,
Jiang

