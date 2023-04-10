Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72CF6DC7E2
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDJOb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDJOb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:31:56 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750DF7EF3;
        Mon, 10 Apr 2023 07:31:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VfoZHgQ_1681137088;
Received: from 30.221.131.183(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VfoZHgQ_1681137088)
          by smtp.aliyun-inc.com;
          Mon, 10 Apr 2023 22:31:29 +0800
Message-ID: <8eb156ce-1c3a-3d1b-a490-309a9403a795@linux.alibaba.com>
Date:   Mon, 10 Apr 2023 22:31:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
To:     Wenjia Zhang <wenjia@linux.ibm.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, wintera@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
 <709cbd7d-7bc6-d039-a814-cbc8d50b861b@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <709cbd7d-7bc6-d039-a814-cbc8d50b861b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.2 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/4/5 22:48, Wenjia Zhang wrote:

> 
> Hi Wen,
> 
> Thank you for the new version. The discussion on the open issue is still on-going in our organisation internally. I 
> appreciate your patience!
> 
> One thing I need to mention during testing the loopback device on our platform is that we get crash, because 
> smc_ism-signal_shutdown() is called by smc_1gr_free_work(), which is called indirectly by smc_conn_free(). Please make 
> sure that it would go to the path of the loopback device cleanly. Any question and consideration is welcome!
> 
> Thanks,
> Wenjia

Thank you! Wenjia. Testing on s390 is really helpful.

Since most of the path in smc_ism_signal_shutdown() is inside the preprocessing
macro '#if IS_ENABLED(CONFIG_ISM) ... #endif', so they are not executed in my
test environment, therefore I didn't realized the interface of ops->signal_event
in loopback device and missed the crash.

I will fix this and check for the other parts wrapped by '#if IS_ENABLED(CONFIG_ISM)
... #endif' which I ignored before. Then I will send out a new version.

Thanks,
Wen Gu
