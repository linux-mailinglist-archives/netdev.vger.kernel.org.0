Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A8D4AEA74
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 07:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiBIGl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 01:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiBIGlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 01:41:24 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1A9C043181;
        Tue,  8 Feb 2022 22:41:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4-CaI3_1644388883;
Received: from 30.225.28.54(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4-CaI3_1644388883)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 14:41:24 +0800
Message-ID: <9ba496e1-daf1-57d2-318e-bfcd4f57755c@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 14:41:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v5 4/5] net/smc: Dynamic control auto fallback by
 socket options
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <20f504f961e1a803f85d64229ad84260434203bd.1644323503.git.alibuda@linux.alibaba.com>
 <74e9c7fb-073c-cd62-c42a-e57c18de3404@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <74e9c7fb-073c-cd62-c42a-e57c18de3404@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Some of our servers have different service types on different ports.
A global switch cannot control different service ports individually in 
this case。In fact, it has nothing to do with using netlink or not. 
Socket options is the first solution comes to my mind in that case，I 
don't know if there is any other better way。

Looks for you suggestions.
Thanks.


在 2022/2/9 上午1:08, Karsten Graul 写道:
> On 08/02/2022 13:53, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This patch aims to add dynamic control for SMC auto fallback, since we
>> don't have socket option level for SMC yet, which requires we need to
>> implement it at the same time.
> 
> In your response to the v2 version of this series you wrote:
> 
>> After some trial and thought, I found that the scope of netlink control
>> is too large, we should limit the scope to socket. Adding a socket option
>> may be a better choice, what do you think?
> 
> I want to understand why this socket option is required, who needs it and why.
> What were your trials and thoughts, did you see any problems with the global
> switch via the netlink interface?
