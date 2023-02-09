Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6621668FC76
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjBIBLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjBIBLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:11:33 -0500
Received: from cstnet.cn (smtp80.cstnet.cn [159.226.251.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 868A59ED6;
        Wed,  8 Feb 2023 17:11:27 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-01 (Coremail) with SMTP id qwCowACXn0s6SORjXuQoBA--.46975S2;
        Thu, 09 Feb 2023 09:11:22 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     stf_xl@wp.pl
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH 1/2] iwl4965: Add missing check for create_singlethread_workqueue
Date:   Thu,  9 Feb 2023 09:11:21 +0800
Message-Id: <20230209011121.45509-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowACXn0s6SORjXuQoBA--.46975S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFyxAF48AFWkZw15Cw4Uurg_yoW3ZwcEga
        47ZF1Uu3ySqrn7G3ZxGr12y395KwnIgFW29r1Fkrn0yas3WayI9Fn5CrnYyrZ2v3ySkF9I
        9w10vrWrGF4UZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
        1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
        n2IY04v7MxkIecxEwVAFwVWkMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VU1ItC7UUUUU==
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:16:58AM +0800, Stanislaw Gruszka wrote:
> On Wed, Feb 08, 2023 at 02:30:31PM +0800, Jiasheng Jiang wrote:
>> Add the check for the return value of the create_singlethread_workqueue
>> in order to avoid NULL pointer dereference.
>> 
>> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
>>  static void
>> @@ -6618,7 +6622,11 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  		goto out_disable_msi;
>>  	}
>>  
>> -	il4965_setup_deferred_work(il);
>> +	err = il4965_setup_deferred_work(il);
>> +	if (err) {
>> +		goto out_free_irq;
>> +	}
> 
> {} not needded.

I have submitted a v2 removing the "{}" with your Ack.

Thanks,
Jiang

