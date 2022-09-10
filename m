Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7165B48D9
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 22:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIJUrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 16:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIJUrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 16:47:24 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5454055C;
        Sat, 10 Sep 2022 13:47:22 -0700 (PDT)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ4Z30VNQz67PMg;
        Sun, 11 Sep 2022 04:43:07 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 22:47:20 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 21:47:20 +0100
Message-ID: <3060ddc9-88db-b7cc-cc58-e5100edd113a@huawei.com>
Date:   Sat, 10 Sep 2022 23:47:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 11/18] seltests/landlock: add tests for bind() hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>,
        "Joe Perches" <joe@perches.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-12-konstantin.meskhidze@huawei.com>
 <0c950c6b-00eb-fdc1-1b2c-fcf50089b980@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <0c950c6b-00eb-fdc1-1b2c-fcf50089b980@digikod.net>
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
>> Adds selftests for bind() socket action.
>> The first is with no landlock restrictions:
>>      - bind without restrictions for ip4;
>>      - bind without restrictions for ip6;
> 
> There is no "ip4" nor "ip6" but "IPv4" and "IPv6" (everywhere).
> 
   Ok. I will fix it.
> 
>> The second ones is with mixed landlock rules:
>>      - bind with restrictions for ip4;
>>      - bind with restrictions for ip6;
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * None.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Adds local address 127.0.0.1.
>> * Adds FIXTURE_VARIANT and FIXTURE_VARIANT_ADD
>> helpers to support both ip4 and ip6 family tests and
>> shorten the code.
>> * Adds create_socket_variant() and bind_variant() helpers.
>> * Gets rid of reuse_addr variable in create_socket_variant.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Adds port[MAX_SOCKET_NUM], struct sockaddr_in addr4
>> and struct sockaddr_in addr6 in FIXTURE.
>> * Refactors FIXTURE_SETUP:
>>      - initializing self->port, self->addr4 and self->addr6.
>>      - adding network namespace.
>> * Refactors code with self->port, self->addr4 and
>> self->addr6 variables.
>> * Adds selftests for IP6 family:
>>      - bind_no_restrictions_ip6.
>>      - bind_with_restrictions_ip6.
>> * Refactors selftests/landlock/config
>> * Moves enforce_ruleset() into common.h
>> 
>> Changes since v3:
>> * Split commit.
>> * Add helper create_socket.
>> * Add FIXTURE_SETUP.
>> 
>> ---
>>   tools/testing/selftests/landlock/config     |   4 +
>>   tools/testing/selftests/landlock/net_test.c | 180 ++++++++++++++++++++
>>   2 files changed, 184 insertions(+)
>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
>> 
>> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
>> index 0f0a65287bac..71f7e9a8a64c 100644
>> --- a/tools/testing/selftests/landlock/config
>> +++ b/tools/testing/selftests/landlock/config
>> @@ -1,3 +1,7 @@
>> +CONFIG_INET=y
>> +CONFIG_IPV6=y
>> +CONFIG_NET=y
>> +CONFIG_NET_NS=y
>>   CONFIG_OVERLAY_FS=y
>>   CONFIG_SECURITY_LANDLOCK=y
>>   CONFIG_SECURITY_PATH=y
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> new file mode 100644
>> index 000000000000..79c71fa37ddb
>> --- /dev/null
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -0,0 +1,180 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Landlock tests - Network
>> + *
>> + * Copyright (C) 2022 Huawei Tech. Co., Ltd.
>> + */
>> +
>> +#define _GNU_SOURCE
>> +#include <arpa/inet.h>
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <linux/landlock.h>
>> +#include <netinet/in.h>
>> +#include <sched.h>
>> +#include <string.h>
>> +#include <sys/prctl.h>
>> +#include <sys/socket.h>
>> +#include <sys/types.h>
>> +
>> +#include "common.h"
>> +
>> +#define MAX_SOCKET_NUM 10
>> +
>> +#define SOCK_PORT_START 3470
>> +#define SOCK_PORT_ADD 10
>> +
>> +#define IP_ADDRESS "127.0.0.1"
>> +
>> +FIXTURE(socket)
>> +{
>> +	uint port[MAX_SOCKET_NUM];
>> +	struct sockaddr_in addr4[MAX_SOCKET_NUM];
>> +	struct sockaddr_in6 addr6[MAX_SOCKET_NUM];
>> +};
>> +
> 
> /* struct _fixture_variant_socket */
> 
>> +FIXTURE_VARIANT(socket)
>> +{
>> +	const bool is_ipv4;
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(socket, ipv4) {
>> +	/* clang-format on */
>> +	.is_ipv4 = true,
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(socket, ipv6) {
>> +	/* clang-format on */
>> +	.is_ipv4 = false,
>> +};
>> +
>> +static int create_socket_variant(const FIXTURE_VARIANT(socket) *const variant,
> 
> To avoid scripts/checkpatch.pl errors [1] (and to follow a consistent
> formatting thanks to clang-format), please use the generated struct type
> for FIXTURE_VARIANT and FIXTURE_DATA instead (everywhere), and add a
> comment before the declaration (as for FIXTURE_VARIANT(socket) just above):
> 
> FIXTURE_VARIANT(socket) => struct _fixture_variant_socket
> FIXTURE_DATA(socket) => struct _test_data_socket
> 
> 
> [1]
> https://lore.kernel.org/all/b1cfb8d4-ad54-9cc1-3d9d-e690c81da016@digikod.net/
> 
   Thanks for the tip here. I will fix it.
> 
>> +				 const int type)
>> +{
>> +	if (variant->is_ipv4)
>> +		return socket(AF_INET, type | SOCK_CLOEXEC, 0);
>> +	else
>> +		return socket(AF_INET6, type | SOCK_CLOEXEC, 0);
>> +}
>> +
>> +static int bind_variant(const FIXTURE_VARIANT(socket) *const variant,
>> +			const int sockfd,
>> +			const FIXTURE_DATA(socket) *const self,
>> +			const size_t index)
>> +{
>> +	if (variant->is_ipv4)
>> +		return bind(sockfd, &self->addr4[index],
>> +			    sizeof(self->addr4[index]));
>> +	else
>> +		return bind(sockfd, &self->addr6[index],
>> +			    sizeof(self->addr6[index]));
>> +}
>> +
>> +FIXTURE_SETUP(socket)
>> +{
>> +	int i;
> 
> line break

   Got it.
> 
> 
>> +	/* Creates IP4 socket addresses. */
>> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {
>> +		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
>> +		self->addr4[i].sin_family = AF_INET;
>> +		self->addr4[i].sin_port = htons(self->port[i]);
>> +		self->addr4[i].sin_addr.s_addr = inet_addr(IP_ADDRESS);
>> +		memset(&(self->addr4[i].sin_zero), '\0', 8);
>> +	}
>> +
>> +	/* Creates IP6 socket addresses. */
>> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {
>> +		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
>> +		self->addr6[i].sin6_family = AF_INET6;
>> +		self->addr6[i].sin6_port = htons(self->port[i]);
>> +		inet_pton(AF_INET6, IP_ADDRESS, &(self->addr6[i].sin6_addr));
>> +	}
>> +
>> +	set_cap(_metadata, CAP_SYS_ADMIN);
>> +	ASSERT_EQ(0, unshare(CLONE_NEWNET));
>> +	ASSERT_EQ(0, system("ip link set dev lo up"));
>> +	clear_cap(_metadata, CAP_SYS_ADMIN);
>> +}
>> +
>> +FIXTURE_TEARDOWN(socket)
>> +{
>> +}
>> +
>> +TEST_F(socket, bind_no_restrictions)
> 
> Please use TEST_F_FORK() everywhere.
> 
   Got it.
> 
>> +{
>> +	int sockfd;
>> +
>> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
>> +	ASSERT_LE(0, sockfd);
>> +
>> +	/* Binds a socket to port[0]. */
>> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
>> +
>> +	ASSERT_EQ(0, close(sockfd));
>> +}
>> +
>> +TEST_F(socket, bind_with_restrictions)
>> +{
>> +	int sockfd;
>> +
>> +	struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +	};
>> +	struct landlock_net_service_attr net_service_1 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		.port = self->port[0],
>> +	};
>> +	struct landlock_net_service_attr net_service_2 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		.port = self->port[1],
>> +	};
>> +	struct landlock_net_service_attr net_service_3 = {
>> +		.allowed_access = 0,
>> +		.port = self->port[2],
>> +	};
>> +
>> +	const int ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	/* Allows connect and bind operations to the port[0] socket. */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				       &net_service_1, 0));
>> +	/* Allows connect and deny bind operations to the port[1] socket. */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				       &net_service_2, 0));
>> +	/* Empty allowed_access (i.e. deny rules) are ignored in network actions
> 
> Only comment lines ending with "*/" should start with "/*", otherwise
> you need to add a line break after "/*" (everywhere).
> 
   Ok. Thanks.
> 
>> +	 * for port[2] socket.
>> +	 */
>> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +					&net_service_3, 0));
>> +	ASSERT_EQ(ENOMSG, errno);
>> +
>> +	/* Enforces the ruleset. */
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +
>> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
>> +	ASSERT_LE(0, sockfd);
>> +	/* Binds a socket to port[0]. */
>> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
>> +
>> +	/* Close bounded socket. */
> 
> Closes

   Yep. Thanks.
> 
>> +	ASSERT_EQ(0, close(sockfd));
>> +
>> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
>> +	ASSERT_LE(0, sockfd);
>> +	/* Binds a socket to port[1]. */
>> +	ASSERT_EQ(-1, bind_variant(variant, sockfd, self, 1));
>> +	ASSERT_EQ(EACCES, errno);
>> +
>> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
>> +	ASSERT_LE(0, sockfd);
>> +	/* Binds a socket to port[2]. */
>> +	ASSERT_EQ(-1, bind_variant(variant, sockfd, self, 2));
>> +	ASSERT_EQ(EACCES, errno);
>> +}
>> +TEST_HARNESS_MAIN
>> --
>> 2.25.1
>> 
> .
