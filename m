Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3B463A04A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 05:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiK1ECZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 23:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiK1ECY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 23:02:24 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06FD12D3D;
        Sun, 27 Nov 2022 20:02:22 -0800 (PST)
Received: from frapeml100001.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NLBYl5kYTz67Nln;
        Mon, 28 Nov 2022 11:59:39 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100001.china.huawei.com (7.182.85.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 05:02:21 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 28 Nov 2022 04:02:20 +0000
Message-ID: <8c93e5fc-b7d0-cf96-f03f-97065fecddca@huawei.com>
Date:   Mon, 28 Nov 2022 07:02:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 09/12] selftests/landlock: Share enforce_ruleset()
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-10-konstantin.meskhidze@huawei.com>
 <62210161-c645-7999-0a2b-95c539d990ba@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <62210161-c645-7999-0a2b-95c539d990ba@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/17/2022 9:43 PM, Mickaël Salaün пишет:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>> This commit moves enforce_ruleset() helper function to common.h so that
>> to be used both by filesystem tests and network ones.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v7:
>> * Refactors commit message.
>> 
>> Changes since v6:
>> * None.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Moves enforce_ruleset helper into common.h
>> * Formats code with clang-format-14.
>> 
>> ---
>>   tools/testing/selftests/landlock/common.h  | 10 ++++++++++
>>   tools/testing/selftests/landlock/fs_test.c | 10 ----------
>>   2 files changed, 10 insertions(+), 10 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
>> index d7987ae8d7fc..bafed1c0c2a6 100644
>> --- a/tools/testing/selftests/landlock/common.h
>> +++ b/tools/testing/selftests/landlock/common.h
>> @@ -256,3 +256,13 @@ static int __maybe_unused send_fd(int usock, int fd_tx)
>>   		return -errno;
>>   	return 0;
>>   }
>> +
>> +__attribute__((__unused__)) static void
> 
> We can now use __maybe_unused instead. This enables to avoid
> checkpatch.pl warning.

  Ok. Will be refactored. Thanks.
> 
> 
>> +enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
>> +{
>> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
>> +	{
>> +		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> +	}
>> +}
>> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
>> index d5dab986f612..20c1ac8485f1 100644
>> --- a/tools/testing/selftests/landlock/fs_test.c
>> +++ b/tools/testing/selftests/landlock/fs_test.c
>> @@ -563,16 +563,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
>>   	return ruleset_fd;
>>   }
>> 
>> -static void enforce_ruleset(struct __test_metadata *const _metadata,
>> -			    const int ruleset_fd)
>> -{
>> -	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> -	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
>> -	{
>> -		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> -	}
>> -}
>> -
>>   TEST_F_FORK(layout1, proc_nsfs)
>>   {
>>   	const struct rule rules[] = {
>> --
>> 2.25.1
>> 
> .
