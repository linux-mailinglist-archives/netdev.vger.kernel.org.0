Return-Path: <netdev+bounces-10357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5258072E026
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7149F281172
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830242910A;
	Tue, 13 Jun 2023 10:54:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D023C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:54:09 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E193E57;
	Tue, 13 Jun 2023 03:54:07 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QgQNB2sKDz6J7VD;
	Tue, 13 Jun 2023 18:51:38 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 11:54:04 +0100
Message-ID: <d9f07165-f589-13d4-6484-1272704f1de0@huawei.com>
Date: Tue, 13 Jun 2023 13:54:03 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 11/12] samples/landlock: Add network demo
Content-Language: ru
To: =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-12-konstantin.meskhidze@huawei.com>
 <ZH9OFyWZ1njI7VG9@google.com>
From: "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <ZH9OFyWZ1njI7VG9@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



6/6/2023 6:17 PM, Günther Noack пишет:
> Hi Konstantin!
> 
> Apologies if some of this was discussed before, in this case,
> Mickaël's review overrules my opinions from the sidelines ;)
> 
> On Tue, May 16, 2023 at 12:13:38AM +0800, Konstantin Meskhidze wrote:
>> This commit adds network demo. It's possible to allow a sandboxer to
>> bind/connect to a list of particular ports restricting network
>> actions to the rest of ports.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> 
> 
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>> index e2056c8b902c..b0250edb6ccb 100644
>> --- a/samples/landlock/sandboxer.c
>> +++ b/samples/landlock/sandboxer.c
> 
> ...
> 
>> +static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
>> +				const __u64 allowed_access)
>> +{
>> +	int num_ports, i, ret = 1;
> 
> I thought the convention was normally to set ret = 0 initially and to
> override it in case of error, rather than the other way around?
> 
   Well, I just followed Mickaёl's way of logic here.


>> +	char *env_port_name;
>> +	struct landlock_net_service_attr net_service = {
>> +		.allowed_access = allowed_access,
>> +		.port = 0,
>> +	};
>> +
>> +	env_port_name = getenv(env_var);
>> +	if (!env_port_name)
>> +		return 0;
>> +	env_port_name = strdup(env_port_name);
>> +	unsetenv(env_var);
>> +	num_ports = parse_port_num(env_port_name);
>> +
>> +	if (num_ports == 1 && (strtok(env_port_name, ENV_PATH_TOKEN) == NULL)) {
>> +		ret = 0;
>> +		goto out_free_name;
>> +	}
> 
> I don't understand why parse_port_num and strtok are necessary in this
> program. The man-page for strsep(3) describes it as a replacement to
> strtok(3) (in the HISTORY section), and it has a very short example
> for how it is used.
> 
> Wouldn't it work like this as well?
> 
> while ((strport = strsep(&env_port_name, ":"))) {
>    net_service.port = atoi(strport);
>    /* etc */
> }

   Thanks for a tip. I think it's a better solution here. Now this 
commit is in Mickaёl's -next branch. I could send a one-commit patch later.
Mickaёl, what do you think?

> 
>> +
>> +	for (i = 0; i < num_ports; i++) {
>> +		net_service.port = atoi(strsep(&env_port_name, ENV_PATH_TOKEN));
> 
> Naming of ENV_PATH_TOKEN:
> This usage is not related to paths, maybe rename the variable?
> It's also technically not the token, but the delimiter.
> 
  What do you think of ENV_PORT_TOKEN or ENV_PORT_DELIMITER???

>> +		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				      &net_service, 0)) {
>> +			fprintf(stderr,
>> +				"Failed to update the ruleset with port \"%lld\": %s\n",
>> +				net_service.port, strerror(errno));
>> +			goto out_free_name;
>> +		}
>> +	}
>> +	ret = 0;
>> +
>> +out_free_name:
>> +	free(env_port_name);
>> +	return ret;
>> +}
> 
> 
>>  		fprintf(stderr,
>>  			"Launch a command in a restricted environment.\n\n");
>> -		fprintf(stderr, "Environment variables containing paths, "
>> -				"each separated by a colon:\n");
>> +		fprintf(stderr,
>> +			"Environment variables containing paths and ports "
>> +			"each separated by a colon:\n");
>>  		fprintf(stderr,
>>  			"* %s: list of paths allowed to be used in a read-only way.\n",
>>  			ENV_FS_RO_NAME);
>>  		fprintf(stderr,
>> -			"* %s: list of paths allowed to be used in a read-write way.\n",
>> +			"* %s: list of paths allowed to be used in a read-write way.\n\n",
>>  			ENV_FS_RW_NAME);
>> +		fprintf(stderr,
>> +			"Environment variables containing ports are optional "
>> +			"and could be skipped.\n");
> 
> As it is, I believe the program does something different when I'm
> setting these to the empty string (ENV_TCP_BIND_NAME=""), compared to
> when I'm unsetting them?
> 
> I think the case where we want to forbid all handle-able networking is
> a legit and very common use case - it could be clearer in the
> documentation how this is done with the tool. (And maybe the interface
> could be something more explicit than setting the environment variable
> to empty?)
> 
> 
>> +	/* Removes bind access attribute if not supported by a user. */
>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>> +	if (!env_port_name) {
>> +		ruleset_attr.handled_access_net &=
>> +			~LANDLOCK_ACCESS_NET_BIND_TCP;
>> +	}
>> +	/* Removes connect access attribute if not supported by a user. */
>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>> +	if (!env_port_name) {
>> +		ruleset_attr.handled_access_net &=
>> +			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>> +	}
> 
> This is the code where the program does not restrict network usage,
> if the corresponding environment variable is not set.

   Yep. Right.
> 
> It's slightly inconsistent with what this tool does for filesystem
> paths. - If you don't specify any file paths, it will still restrict
> file operations there, independent of whether that env variable was
> set or not.  (Apologies if it was discussed before.)

  Mickaёl wanted to make network ports optional here.
  Please check:
 
https://lore.kernel.org/linux-security-module/179ac2ee-37ff-92da-c381-c2c716725045@digikod.net/

https://lore.kernel.org/linux-security-module/fe3bc928-14f8-5e2b-359e-9a87d6cf5b01@digikod.net/
> 
> —Günther
> 

