Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4F86964B3
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjBNN3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjBNN27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:28:59 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E38244A6;
        Tue, 14 Feb 2023 05:28:57 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGMSg2c5dz6801v;
        Tue, 14 Feb 2023 21:27:15 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 13:28:54 +0000
Message-ID: <1fb0ee51-ca6b-052c-da52-52a5a8ca409f@huawei.com>
Date:   Tue, 14 Feb 2023 16:28:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 10/12] selftests/landlock: Add 10 new test suites
 dedicated to network
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-11-konstantin.meskhidze@huawei.com>
 <ff460f1e-fc0c-d362-a97d-573df193fedb@digikod.net>
 <78583ab7-031f-cc21-f3a8-dd900dc3c47a@huawei.com>
 <7abfa7f7-73c2-1aae-5acf-bf8ba1699074@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <7abfa7f7-73c2-1aae-5acf-bf8ba1699074@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/14/2023 3:13 PM, Mickaël Salaün пишет:
> 
> On 14/02/2023 11:36, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 2/10/2023 8:40 PM, Mickaël Salaün пишет:
>>>
>>> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>>>> These test suites try to check edge cases for TCP sockets
>>>> bind() and connect() actions.
>>>>
>>>> socket:
>>>> * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>>> * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>>> * bind_afunspec: Tests with non-landlocked/landlocked restrictions
>>>> for bind action with AF_UNSPEC socket family.
>>>> * connect_afunspec: Tests with non-landlocked/landlocked restrictions
>>>> for connect action with AF_UNSPEC socket family.
>>>> * ruleset_overlap: Tests with overlapping rules for one port.
>>>> * ruleset_expanding: Tests with expanding rulesets in which rules are
>>>> gradually added one by one, restricting sockets' connections.
>>>> * inval: Tests with invalid user space supplied data:
>>>>       - out of range ruleset attribute;
>>>>       - unhandled allowed access;
>>>>       - zero port value;
>>>>       - zero access value;
>>>>       - legitimate access values;
>>>> * bind_connect_inval_addrlen: Tests with invalid address length
>>>> for ipv4/ipv6 sockets.
>>>> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets.
>>>>
>>>> layout1:
>>>> * with_net: Tests with network bind() socket action within
>>>> filesystem directory access test.
>>>>
>>>> Test coverage for security/landlock is 94.1% of 946 lines according
>>>> to gcc/gcov-11.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v8:
>>>> * Adds is_sandboxed const for FIXTURE_VARIANT(socket).
>>>> * Refactors AF_UNSPEC tests.
>>>> * Adds address length checking tests.
>>>> * Convert ports in all tests to __be16.
>>>> * Adds invalid port values tests.
>>>> * Minor fixes.
>>>>
>>>> Changes since v7:
>>>> * Squashes all selftest commits.
>>>> * Adds fs test with network bind() socket action.
>>>> * Minor fixes.
>>>>
>>>> ---
>>>>    tools/testing/selftests/landlock/config     |    4 +
>>>>    tools/testing/selftests/landlock/fs_test.c  |   65 ++
>>>>    tools/testing/selftests/landlock/net_test.c | 1157 +++++++++++++++++++
>>>>    3 files changed, 1226 insertions(+)
>>>>    create mode 100644 tools/testing/selftests/landlock/net_test.c
>>>>
>>>> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
>>>> index 0f0a65287bac..71f7e9a8a64c 100644
>>>> --- a/tools/testing/selftests/landlock/config
>>>> +++ b/tools/testing/selftests/landlock/config
>>>> @@ -1,3 +1,7 @@
>>>> +CONFIG_INET=y
>>>> +CONFIG_IPV6=y
>>>> +CONFIG_NET=y
>>>> +CONFIG_NET_NS=y
>>>>    CONFIG_OVERLAY_FS=y
>>>>    CONFIG_SECURITY_LANDLOCK=y
>>>>    CONFIG_SECURITY_PATH=y
>>>> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
>>>> index b762b5419a89..5de4559c7fbb 100644
>>>> --- a/tools/testing/selftests/landlock/fs_test.c
>>>> +++ b/tools/testing/selftests/landlock/fs_test.c
>>>> @@ -8,8 +8,10 @@
>>>>     */
>>>>    
>>>>    #define _GNU_SOURCE
>>>> +#include <arpa/inet.h>
>>>>    #include <fcntl.h>
>>>>    #include <linux/landlock.h>
>>>> +#include <netinet/in.h>
>>>>    #include <sched.h>
>>>>    #include <stdio.h>
>>>>    #include <string.h>
>>>> @@ -17,6 +19,7 @@
>>>>    #include <sys/mount.h>
>>>>    #include <sys/prctl.h>
>>>>    #include <sys/sendfile.h>
>>>> +#include <sys/socket.h>
>>>>    #include <sys/stat.h>
>>>>    #include <sys/sysmacros.h>
>>>>    #include <unistd.h>
>>>> @@ -4413,4 +4416,66 @@ TEST_F_FORK(layout2_overlay, same_content_different_file)
>>>>    	}
>>>>    }
>>>>    
>>>> +#define IP_ADDRESS "127.0.0.1"
>>>> +
>>>> +TEST_F_FORK(layout1, with_net)
>>>> +{
>>>> +	int sockfd;
>>>> +	int sock_port = 15000;
>>>> +	struct sockaddr_in addr4;
>>>> +
>>>> +	addr4.sin_family = AF_INET;
>>>> +	addr4.sin_port = htons(sock_port);
>>>> +	addr4.sin_addr.s_addr = inet_addr(IP_ADDRESS);
>>>> +	memset(&addr4.sin_zero, '\0', 8);
>>>
>>> Please don't mix declaration and code. Follow the
>>> ./scripts/checkpatch.pl recommendations, except the "braces {} are not
>>> necessary" for tests (not kernel) code because of ASSERT_* macros.
>>>
>>     Ok. Will be moved down the code.
>>     Thank you.
>>>
>>>> +
>>>> +	const struct rule rules[] = {
>>>> +		{
>>>> +			.path = dir_s1d2,
>>>> +			.access = ACCESS_RO,
>>>> +		},
>>>> +		{},
>>>> +	};
>>>> +
>>>> +	struct landlock_ruleset_attr ruleset_attr_net = {
>>>> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>> +	};
>>>> +	struct landlock_net_service_attr net_service = {
>>>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>>> +
>>>> +		.port = htons(sock_port),
>>>> +	};
>>>> +
>>>> +	/* Creates ruleset for network access. */
>>>> +	const int ruleset_fd_net = landlock_create_ruleset(
>>>> +		&ruleset_attr_net, sizeof(ruleset_attr_net), 0);
>>>> +	ASSERT_LE(0, ruleset_fd_net);
>>>> +
>>>> +	/* Adds a network rule. */
>>>> +	ASSERT_EQ(0,
>>>> +		  landlock_add_rule(ruleset_fd_net, LANDLOCK_RULE_NET_SERVICE,
>>>> +				    &net_service, 0));
>>>> +
>>>> +	enforce_ruleset(_metadata, ruleset_fd_net);
>>>> +	ASSERT_EQ(0, close(ruleset_fd_net));
>>>> +
>>>> +	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
>>>> +	ASSERT_LE(0, ruleset_fd);
>>>> +	enforce_ruleset(_metadata, ruleset_fd);
>>>> +	ASSERT_EQ(0, close(ruleset_fd));
>>>> +
>>>> +	/* Tests on a directory with the network rule loaded. */
>>>> +	ASSERT_EQ(0, test_open(dir_s1d2, O_RDONLY));
>>>> +	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
>>>> +
>>>> +	sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>>>> +	ASSERT_LE(0, sockfd);
>>>> +	/* Binds a socket to port 15000. */
>>>> +	ASSERT_EQ(0, bind(sockfd, &addr4, sizeof(addr4)));
>>>> +
>>>> +	/* Closes bounded socket. */
>>>> +	ASSERT_EQ(0, close(sockfd));
>>>> +}
>>>> +
>>>>    TEST_HARNESS_MAIN
>>>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>>>> new file mode 100644
>>>> index 000000000000..b9543089a4d3
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>>
>>> [...]
>>>
>>>> +FIXTURE_TEARDOWN(socket){};
>>>
>>> Remove such trailing ";" and format with clang-format for both
>>> FIXTURE_TEARDOWN().
>> 
>> Like this :
>> 
>> FIXTURE_TEARDOWN(socket)
>> {
>> }
>> 
>> ???
> 
> Yes, it may not looks nice but it pleases both checkpatch.pl and
> clang-format. :)

   Got it. Thanks.
> .
