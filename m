Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25994AEE3F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiBIJlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:41:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241007AbiBIJif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:38:35 -0500
Received: from out199-8.us.a.mail.aliyun.com (out199-8.us.a.mail.aliyun.com [47.90.199.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D355E016CC4;
        Wed,  9 Feb 2022 01:38:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4-ikX7_1644397278;
Received: from 30.225.28.54(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4-ikX7_1644397278)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 17:01:19 +0800
Message-ID: <93bb89c6-8a35-b5e8-2c3b-54a5dfecb062@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 17:01:18 +0800
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
 <9ba496e1-daf1-57d2-318e-bfcd4f57755c@linux.alibaba.com>
 <e19f2c6a-0429-7e33-4083-caf58414d453@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <e19f2c6a-0429-7e33-4083-caf58414d453@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


When a large number of connections are influx, the long-connection 
service has a much higher tolerance for smc queuing time than the 
short-link service. For the long-connection service, more SMC 
connections are more important than faster connection establishment, the 
auto fallback is quite meaningless and unexpected to them, while the 
short-link connection service is in the opposite. When a host has both 
types of services below, a global switch cannot works in that case. what 
do you think?

Hope for you reply.

Thanks.

在 2022/2/9 下午3:59, Karsten Graul 写道:
> On 09/02/2022 07:41, D. Wythe wrote:
>>
>> Some of our servers have different service types on different ports.
>> A global switch cannot control different service ports individually in this case。In fact, it has nothing to do with using netlink or not. Socket options is the first solution comes to my mind in that case，I don't know if there is any other better way。
>>
> 
> I try to understand why you think it is needed to handle different
> service types differently. As you wrote
> 
>> After some trial and thought, I found that the scope of netlink control is too large
> 
> please explain what you found out. I don't doubt about netlink or socket option here,
> its all about why a global switch for this behavior isn't good enough.
