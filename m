Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449FD52164D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242200AbiEJNHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242223AbiEJNHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:07:19 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD74261971;
        Tue, 10 May 2022 06:03:20 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VCrRGve_1652187797;
Received: from 30.43.104.207(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VCrRGve_1652187797)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 May 2022 21:03:17 +0800
Message-ID: <a43ef532-17fb-43f8-35fb-8e40fdaae472@linux.alibaba.com>
Date:   Tue, 10 May 2022 21:03:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net 2/2] net/smc: align the connect behaviour with TCP
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220509115837.94911-1-guangguan.wang@linux.alibaba.com>
 <20220509115837.94911-3-guangguan.wang@linux.alibaba.com>
 <b826a78efa5e015b93038f5f8564ca7e98e1240a.camel@redhat.com>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <b826a78efa5e015b93038f5f8564ca7e98e1240a.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/10 19:05, Paolo Abeni wrote:
>>  	} else {
>>  		rc = __smc_connect(smc);
>> -		if (rc < 0)
>> +		if (rc < 0) {
>>  			goto out;
>> -		else
>> +		} else {
>>  			rc = 0; /* success cases including fallback */
>> +			sock->state = SS_CONNECTED;
> 
> 'else' is not needed here, you can keep the above 2 statements dropping
> an indentation level.
> 
>> +		}
>>  	}
>>  
> 
> You can avoid a little code duplication adding here the following:
> 
> connected:
>    sock->state = SS_CONNECTED;
> 
> and using the new label where appropriate.
> 

Got it, I will modify it in the next version.
Thanks.
