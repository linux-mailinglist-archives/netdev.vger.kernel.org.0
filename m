Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4F15B48DD
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 22:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiIJUsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 16:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIJUsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 16:48:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7D04056B;
        Sat, 10 Sep 2022 13:48:12 -0700 (PDT)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ4b037bDz67KPR;
        Sun, 11 Sep 2022 04:43:56 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Sat, 10 Sep 2022 22:48:09 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 21:48:09 +0100
Message-ID: <c99ea33e-3aac-fe60-da1c-22acbf1392dc@huawei.com>
Date:   Sat, 10 Sep 2022 23:48:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 13/18] seltests/landlock: add AF_UNSPEC family test
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-14-konstantin.meskhidze@huawei.com>
 <707210e7-eaee-1b56-25fc-a50530fe5c12@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <707210e7-eaee-1b56-25fc-a50530fe5c12@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:09 AM, Mickaël Salaün пишет:
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> Adds two selftests for connect() action with AF_UNSPEC family flag.
>> The one is with no landlock restrictions allows to disconnect already
>> connected socket with connect(..., AF_UNSPEC, ...):
>>      - connect_afunspec_no_restictions;
> 
> Typo: "restrictions" (everywhere)
> 
   My mistake. Thanks.
> 
>> The second one refuses landlocked process to disconnect already
>> connected socket:
>>      - connect_afunspec_with_restictions;
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * None.
>> 
>> Changes since v5:
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors code with self->port, self->addr4 variables.
>> * Adds bind() hook check for with AF_UNSPEC family.
>> 
>> Changes since v3:
>> * Adds connect_afunspec_no_restictions test.
>> * Adds connect_afunspec_with_restictions test.
>> 
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 113 ++++++++++++++++++++
>>   1 file changed, 113 insertions(+)
>> 
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index 9c3d1e425439..40aef7c683af 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -351,4 +351,117 @@ TEST_F(socket, connect_with_restrictions)
>>   	ASSERT_EQ(1, WIFEXITED(status));
>>   	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>>   }
>> +
>> +TEST_F(socket, connect_afunspec_no_restictions)
>> +{
>> +	int sockfd;
>> +	pid_t child;
>> +	int status;
>> +
>> +	/* Creates a server socket 1. */
>> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
>> +	ASSERT_LE(0, sockfd);
>> +
>> +	/* Binds the socket 1 to address with port[0]. */
>> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
>> +
>> +	/* Makes connection to the socket with port[0]. */
>> +	ASSERT_EQ(0, connect_variant(variant, sockfd, self, 0));
>> +
>> +	child = fork();
>> +	ASSERT_LE(0, child);
>> +	if (child == 0) {
>> +		struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };
> 
> You can constify several variable like this one (in all tests).

   Got it. thanks.
> 
> .
