Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C5852D268
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbiESMZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiESMZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:25:01 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB39BA55F;
        Thu, 19 May 2022 05:25:00 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L3pvf0yFPz6FCs6;
        Thu, 19 May 2022 20:24:46 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 19 May 2022 14:24:57 +0200
Message-ID: <09ab37e1-eba5-80be-8fb3-df2bde698fc6@huawei.com>
Date:   Thu, 19 May 2022 15:24:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 12/15] seltests/landlock: rules overlapping test
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-13-konstantin.meskhidze@huawei.com>
 <4806f5ed-41c0-f9f2-d7a1-2173c8494399@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <4806f5ed-41c0-f9f2-d7a1-2173c8494399@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/16/2022 8:41 PM, Mickaël Salaün пишет:
> Please fix these kind of subjects (selftests). I'd also like the subject 
> description to (quickly) describe what is done (with a verb), to start 
> with a capital (like a title), and to contain "network", something like 
> this:
> selftests/landlock: Add test for overlapping network rules
> 
> This is a good test though.
> 
> 
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>> This patch adds overlapping rules for one port.
>> First rule adds just bind() access right for a port.
>> The second one adds both bind() and connect()
>> access rights for the same port.
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>
>> Changes since v3:
>> * Add ruleset_overlap test.
>>
>> Changes since v4:
>> * Refactoring code with self->port, self->addr4 variables.
>>
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 51 +++++++++++++++++++++
>>   1 file changed, 51 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c 
>> b/tools/testing/selftests/landlock/net_test.c
>> index bf8e49466d1d..1d8c9dfdbd48 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -677,4 +677,55 @@ TEST_F_FORK(socket_test, 
>> connect_afunspec_with_restictions) {
>>       ASSERT_EQ(1, WIFEXITED(status));
>>       ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>>   }
>> +
>> +TEST_F_FORK(socket_test, ruleset_overlap) {
> 
> Please run clang-format-14 on all files (and all commits).
> 
   Yep. I already have updated clang-format executable on my Ubuntu and
setup Vscode to use .clang-format file.
>> +
>> +    int sockfd;
>> +
>> +    struct landlock_ruleset_attr ruleset_attr = {
>> +        .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +    };
>> +    struct landlock_net_service_attr net_service_1 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +
>> +        .port = self->port[0],
>> +    };
>> +
>> +        struct landlock_net_service_attr net_service_2 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +
>> +        .port = self->port[0],
>> +    };
>> +
>> +    const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +                    sizeof(ruleset_attr), 0);
>> +    ASSERT_LE(0, ruleset_fd);
>> +
>> +    /* Allows bind operations to the port[0] socket */
> 
> Please ends this kind of comments with a final dot (all files/commits).
> 
   Ok. I will.
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                       &net_service_1, 0));
>> +    /* Allows connect and bind operations to the port[0] socket */
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                       &net_service_2, 0));
>> +
>> +    /* Enforces the ruleset. */
>> +    enforce_ruleset(_metadata, ruleset_fd);
>> +
>> +    /* Creates a server socket */
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +
>> +    /* Binds the socket to address with port[0] */
>> +    ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr4[0], 
>> sizeof(self->addr4[0])));
>> +
>> +    /* Makes connection to socket with port[0] */
>> +    ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&self->addr4[0],
> 
> Can you please get rid of this (struct sockaddr *) type casting please 
> (without compiler warning)?
> 
   Do you have a warning here? Cause I don't.
>> +                           sizeof(self->addr4[0])));
> 
> Here, you can enforce a new ruleset with net_service_1 and check that 
> bind() is still allowed but not connect().
> 
  Ok. Thank you for advice.
>> +
>> +    /* Closes socket */
>> +    ASSERT_EQ(0, close(sockfd));
>> +}
>> +
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.25.1
>>
> .
