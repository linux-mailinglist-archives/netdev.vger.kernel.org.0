Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21136BCBBF
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCPJ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCPJ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:58:56 -0400
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 907737C3FF;
        Thu, 16 Mar 2023 02:58:36 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-03 (Coremail) with SMTP id rQCowAAXHws96BJkWeB+EA--.1410S2;
        Thu, 16 Mar 2023 17:58:21 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     michal.swiatkowski@linux.intel.com
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH] octeontx2-vf: Add missing free for alloc_percpu
Date:   Thu, 16 Mar 2023 17:58:20 +0800
Message-Id: <20230316095820.17889-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAAXHws96BJkWeB+EA--.1410S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF13Zw4xZFWxtF1fXrWfGrg_yoW8WrWkpa
        1vvFy7CF18JF47GwnrJryrWrn8Gayqk34rK3409w4Yvw13tFn3uFyqkr4F9w1xKrWkW3W7
        tFW5u3yfGFn5ZaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUjMmh5UUUUU==
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:39:11AM +0800, Jiasheng Jiang wrote:
> On Thu, Mar 16, 2023 at 10:39:11AM +0800, Jiasheng Jiang wrote:
>> Add the free_percpu for the allocated "vf->hw.lmt_info" in order to avoid
>> memory leak, same as the "pf->hw.lmt_info" in
>> `drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c`.
>> 
>> Fixes: 5c0512072f65 ("octeontx2-pf: cn10k: Use runtime allocated LMTLINE region")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
>> index 7f8ffbf79cf7..9db2e2d218bb 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
>> @@ -709,6 +709,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  err_ptp_destroy:
>>  	otx2_ptp_destroy(vf);
>>  err_detach_rsrc:
>> +	if (vf->hw.lmt_info)
>> +		free_percpu(vf->hw.lmt_info);
>>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>>  		qmem_free(vf->dev, vf->dync_lmt);
> I wonder if it wouldn't be more error prune when You create a function
> to unroll cn10k_lmtst_init() like cn10k_lmtst_deinit(). These two if can
> be there, maybe also sth else is missing.
> 
> Otherwise it is fine
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

I try my best and find nothing else missing.

Thanks,
Jiang

