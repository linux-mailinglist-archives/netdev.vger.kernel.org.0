Return-Path: <netdev+bounces-9255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6014C728498
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 583841C209A6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB396171A1;
	Thu,  8 Jun 2023 16:08:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8841168A9
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:08:07 +0000 (UTC)
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6861BFF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:08:05 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6b2afc1ec49so525145a34.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686240485; x=1688832485;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BP3bxQmEgC4VjfYwLuwk34dGsdabvj85+UKn5ikI5zY=;
        b=agC8qaMC7GHoefOrroKBSCu79N0jfckKO5roE8tw0ATj6jOj568AkyR2/a6Xq9Hjs/
         0MamOrsCJmKz/tRgVO78L6XY4s90oLa+zqoTNgU5ptednTRmQ/2S6rNq6QTQMImcEwxr
         ALvX2pHTNLxg32P5XvKXkr64sljL/TLaTNqFslE+sLzz+VcGWAkyuq+vInEUEL0R58Hf
         Mn425+T9Tf/4SlzQ25yUhndKYnZVxJMqhp24aSKen2n2UnRpWyrBLKKT//927GnsVB5z
         +HbZV0qNfhQnBL/w92iasPFf1ML21TzBxWcW402PakFll6yJikaWgUjiDoPnl2TKngAX
         SkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686240485; x=1688832485;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BP3bxQmEgC4VjfYwLuwk34dGsdabvj85+UKn5ikI5zY=;
        b=MZMs91gadwB+PB9p61Uwa2apSipyLA+0298CjT0BgTDbEQsCtFI7wuhIRqOIZcQBe7
         3TzizJhfS4zwPRz2dh+YAZ04AVe8Zv0tNCuozK9hsGW8SiEUeJGPnclcyrqAclirFRgH
         RPAOpqNtLxbd8HgXKG9Dp2co4FytwcSDVXLspRN6VOYSZIBq74QY4NPJBU59awSHXFnt
         t9YjRP6AIApPfXlIig9Gi4X+Lkdghh8XlQH2Ssl4Ogh5Hy+AD4nBZRsztbj9Ew6fcNWL
         PUcxBBRISdNfFUAZie9lcrd7pPwUiyw0uqdkWPFSunuzZEfQDcoQu6CueMvhDbScP+CY
         W84Q==
X-Gm-Message-State: AC+VfDzKhlfOZA5rQ5lQ96mZZiK2TKU1NJoiYbT81ZLbXENkKo3543PD
	JLn+64/zQzsOhV6LY21ha0gK7A==
X-Google-Smtp-Source: ACHHUZ7EYpn3580ns8FBjBpnBAw3+T8XBNtHJOV/34vqvskzwQqphQftBULkzc1SXXjS/eRfRXbumw==
X-Received: by 2002:a9d:7d8d:0:b0:6b1:5e60:a2c9 with SMTP id j13-20020a9d7d8d000000b006b15e60a2c9mr1350294otn.9.1686240485068;
        Thu, 08 Jun 2023 09:08:05 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:bbfb:717f:472:7a01? ([2804:14d:5c5e:44fb:bbfb:717f:472:7a01])
        by smtp.gmail.com with ESMTPSA id m4-20020a9d7e84000000b006a44338c8efsm617985otp.44.2023.06.08.09.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 09:08:04 -0700 (PDT)
Message-ID: <91e6a8cd-2775-d759-4462-b1be7dc79bbe@mojatatu.com>
Date: Thu, 8 Jun 2023 13:08:00 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] net/sched: Set the flushing flags to false to prevent
 an infinite loop and add one test to tdc
Content-Language: en-US
To: renmingshuai <renmingshuai@huawei.com>
Cc: caowangbao@huawei.com, davem@davemloft.net, edumazet@google.com,
 jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, liaichun@huawei.com,
 linux-kernel@vger.kernel.org, liubo335@huawei.com, netdev@vger.kernel.org,
 pabeni@redhat.com, xiyou.wangcong@gmail.com, yanan@huawei.com
References: <3679ed57-a0b9-4af2-cf83-e8aaa4bbd29e@mojatatu.com>
 <20230608123224.3191731-1-renmingshuai@huawei.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230608123224.3191731-1-renmingshuai@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 08/06/2023 09:32, renmingshuai wrote:
>> On 07/06/2023 01:19, renmingshuai wrote:
>>>> On 06/06/2023 11:45, renmingshuai wrote:
>>>>> When a new chain is added by using tc, one soft lockup alarm will
>>>>> be
>>>>>     generated after delete the prio 0 filter of the chain. To
>>>>>     reproduce
>>>>>     the problem, perform the following steps:
>>>>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
>>>>> (2) tc chain add dev eth0
>>>>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
>>>>> (4) tc filter add dev eth0 chain 0 parent 1:
>>>>
>>>> This seems like it could be added to tdc or 3 and 4 must be run in
>>>> parallel?
>>> 3 and 4 do not need to be run inparallel. When a new chain is added
>>> by the
>>>    way as step 1 and the step 3 is completed, this problem always
>>>    occurs
>>>    whenever step 4 is run.
>>
>> Got it,
>> The test still hangs with the provided patch.
>>
>> + tc qdisc add dev lo root handle 1: htb default 1
>> + tc chain add dev lo
>> + tc filter del dev lo chain 0 parent 1: prio 0
>> [   68.790030][ T6704] [+]
>> [   68.790060][ T6704] chain refcnt 2
>> [   68.790951][ T6704] [-]
>> + tc filter add dev lo chain 0 parent 1:
>> <hangs>
>>
>> Also please add this test to tdc, it should be straightforward.
>>
> Sorry for not testing before. I forgot that the chain->refcnt was
> increased by 1 when tcf_chain_get() is called in tc_del_tfilter().
>   The value of chain->refcnt is 2 after chain flush. The test
>   result is as follows:
> [root@localhost ~]# tc qdisc add dev eth2 root handle 1: htb default 1
> [root@localhost ~]# tc chain add dev eth2
> [root@localhost ~]# tc filter del dev eth2 chain 0 parent 1: prio 0
> [root@localhost ~]# tc filter add dev eth2 chain 0 parent 1:
> Error: Filter kind and protocol must be specified.
> We have an error talking to the kernel
> 
> And I have add this test to tdc:
> [root@localhost tc-testing]# ./tdc.py -f tc-tests/filters/tests.json
> ok 7 c2b4 - Adding a new fiter after deleting a filter in a chain does
> not cause  an infinite loop
> 
> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
> Signed-off-by: renmingshuai <renmingshuai@huawei.com>

Please respin with the following applied:

diff --git 
a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json 
b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index c759c3db9a37..361235ad574b 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -125,25 +125,5 @@
          "teardown": [
              "$TC qdisc del dev $DEV2 ingress"
          ]
-    },
-    {
-        "id": "c2b4",
-        "name": "Adding a new fiter after deleting a filter in a chain 
does not cause an infinite loop",
-        "category": [
-            "filter",
-            "prio"
-        ],
-        "setup": [
-            "$TC qdisc add dev $DEV1 root handle 1: htb default 1",
-            "$TC chain add dev $DEV1"
-        ],
-        "cmdUnderTest": "$TC filter del dev $DEV1 chain 0 parent 1: 
prio 0",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter add dev $DEV1 chain 0 parent 1:",
-        "matchPattern": "Error: Filter kind and protocol must be 
specified.",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 root handle 1: htb default 1"
-        ]
      }
  ]
diff --git 
a/tools/testing/selftests/tc-testing/tc-tests/infra/filters.json 
b/tools/testing/selftests/tc-testing/tc-tests/infra/filters.
json
new file mode 100644
index 000000000000..55d6f209c388
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filters.json
@@ -0,0 +1,24 @@
+[
+    {
+        "id": "c2b4",
+        "name": "Adding a new filter after flushing empty chain doesnt 
cause an infinite loop",
+        "category": [
+            "filter",
+            "chain"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
+            "$TC chain add dev $DUMMY",
+            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
+        "expExitCode": "2",
+        "verifyCmd": "$TC chain ls dev $DUMMY",
+        "matchPattern": "chain parent 1: chain 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY root handle 1: htb default 1"
+        ]
+    }
+]



