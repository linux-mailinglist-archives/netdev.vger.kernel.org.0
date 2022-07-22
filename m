Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D9957E26C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbiGVNlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 09:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbiGVNlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 09:41:09 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CED1EEF4
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 06:41:05 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-10d9137bd2eso6347977fac.3
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 06:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pn07Pd1IcgyJT99K4/In19Np4gq0Ksq2PMr4YrPpG8g=;
        b=LOxav/+MNcZIV6eU6iassj8Vuto4qGTrFJ/n+wgWJdawMYlcd6ZZx0GA3RkW3P6jXT
         PRy5EtikCaOdXf8OinbSLGUDgffuLJcAOG3DMWwNNWzJ69Q0Qb45gmRSF60EcpDNB/Mx
         fY5CPxZq/X+h+sGpb3srptNJT172CIFjPLKew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pn07Pd1IcgyJT99K4/In19Np4gq0Ksq2PMr4YrPpG8g=;
        b=1xq9sjkL4tzS22eo0CWkZkw51EX/5yrT9QdX1uamic/IhVYAPi4zAxjSBYg4sy4veP
         zCIPQU4jEJLwWbFvPVdmiohKEP1P09qX8f6JF3k60VETrQbXUjkRbf6R7nh8doXblM8+
         OZ1fLNC5uKwHjxdwAUAnetsF9t+1ZpswE3HoLpRk6zpGHPK9CsawYanEluujoqYEvNpA
         +ncQZU5Xomcl4e1sEE3pXBEVVos0o7t//rCufGGLvQ2uHcFUmMvEFiZBUuOItQg+NJ5d
         HljKalk/axHZ7Fxo3Bw8lQuCS/K5+haCcI/4HASTcdRah9dQ3EmN2vgLq4gDL+MiftEF
         aALA==
X-Gm-Message-State: AJIora84ArG4kFBP3McUROJuIEaOXU88+oXRflUNEbCG6ND9D/vp1pwd
        0M04wZwFWF3rts7h6waJ02bjwA==
X-Google-Smtp-Source: AGRyM1tuw/2HfKvILDi3ZV+Tr1PJfXzEE8zHaGhVzyTwsLHrzVCKSEoPyK1Y81LL9nNGBBCzaHgw2g==
X-Received: by 2002:a05:6870:f286:b0:10b:8bcc:880a with SMTP id u6-20020a056870f28600b0010b8bcc880amr7683825oap.299.1658497264671;
        Fri, 22 Jul 2022 06:41:04 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id r83-20020acaf356000000b0032f0fd7e1f8sm1788033oih.39.2022.07.22.06.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 06:41:04 -0700 (PDT)
Message-ID: <3d090a7a-a57f-72b8-a375-c1b1a5c105ec@cloudflare.com>
Date:   Fri, 22 Jul 2022 08:41:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 3/4] selftests/bpf: Add tests verifying bpf lsm
 userns_create hook
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220721172808.585539-4-fred@cloudflare.com>
 <20220722060706.y6keqvyvzdvkmc6i@kafai-mbp.dhcp.thefacebook.com>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <20220722060706.y6keqvyvzdvkmc6i@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/22 1:07 AM, Martin KaFai Lau wrote:
> On Thu, Jul 21, 2022 at 12:28:07PM -0500, Frederick Lawler wrote:
>> The LSM hook userns_create was introduced to provide LSM's an
>> opportunity to block or allow unprivileged user namespace creation. This
>> test serves two purposes: it provides a test eBPF implementation, and
>> tests the hook successfully blocks or allows user namespace creation.
>>
>> This tests 4 cases:
>>
>>          1. Unattached bpf program does not block unpriv user namespace
>>             creation.
>>          2. Attached bpf program allows user namespace creation given
>>             CAP_SYS_ADMIN privileges.
>>          3. Attached bpf program denies user namespace creation for a
>>             user without CAP_SYS_ADMIN.
>>          4. The sleepable implementation loads
>>
>> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
>>
>> ---
>> The generic deny_namespace file name is used for future namespace
>> expansion. I didn't want to limit these files to just the create_user_ns
>> hook.
>> Changes since v2:
>> - Rename create_user_ns hook to userns_create
>> Changes since v1:
>> - Introduce this patch
>> ---
>>   .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
>>   .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
>>   2 files changed, 127 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/deny_namespace.c b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>> new file mode 100644
>> index 000000000000..9e4714295008
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>> @@ -0,0 +1,88 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#define _GNU_SOURCE
>> +#include <test_progs.h>
>> +#include "test_deny_namespace.skel.h"
>> +#include <sched.h>
>> +#include "cap_helpers.h"
>> +
>> +#define STACK_SIZE (1024 * 1024)
> Does the child need 1M stack space ?

No, I can reduce that.

> 
>> +static char child_stack[STACK_SIZE];
>> +
>> +int clone_callback(void *arg)
> static
> 
>> +{
>> +	return 0;
>> +}
>> +
>> +static int create_new_user_ns(void)
>> +{
>> +	int status;
>> +	pid_t cpid;
>> +
>> +	cpid = clone(clone_callback, child_stack + STACK_SIZE,
>> +		     CLONE_NEWUSER | SIGCHLD, NULL);
>> +
>> +	if (cpid == -1)
>> +		return errno;
>> +
>> +	if (cpid == 0)
> Not an expert in clone() call and it is not clear what 0
> return value mean from the man page.  Could you explain ?
> 

Good catch. This is using the libc clone().

>> +		return 0;
>> +
>> +	waitpid(cpid, &status, 0);
>> +	if (WIFEXITED(status))
>> +		return WEXITSTATUS(status);
>> +
>> +	return -1;
>> +}
>> +
>> +static void test_userns_create_bpf(void)
>> +{
>> +	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
>> +	__u64 old_caps = 0;
>> +
>> +	ASSERT_OK(create_new_user_ns(), "priv new user ns");
> Does it need to enable CAP_SYS_ADMIN first ?
> 

You're right, this should be more explicitly set. I ran tests with the 
vmtest.sh script supplied with sefltests/bpf which run under root. I 
should always set CAP_SYS_ADMIN here to be consistent.

>> +
>> +	cap_disable_effective(cap_mask, &old_caps);
>> +
>> +	ASSERT_EQ(create_new_user_ns(), EPERM, "unpriv new user ns");
>> +
>> +	if (cap_mask & old_caps)
>> +		cap_enable_effective(cap_mask, NULL);
>> +}
>> +
>> +static void test_unpriv_userns_create_no_bpf(void)
>> +{
>> +	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
>> +	__u64 old_caps = 0;
>> +
>> +	cap_disable_effective(cap_mask, &old_caps);
>> +
>> +	ASSERT_OK(create_new_user_ns(), "no-bpf unpriv new user ns");
>> +
>> +	if (cap_mask & old_caps)
>> +		cap_enable_effective(cap_mask, NULL);
>> +}
>> +
>> +void test_deny_namespace(void)
>> +{
>> +	struct test_deny_namespace *skel = NULL;
>> +	int err;
>> +
>> +	if (test__start_subtest("unpriv_userns_create_no_bpf"))
>> +		test_unpriv_userns_create_no_bpf();
>> +
>> +	skel = test_deny_namespace__open_and_load();
>> +	if (!ASSERT_OK_PTR(skel, "skel load"))
>> +		goto close_prog;
>> +
>> +	err = test_deny_namespace__attach(skel);
>> +	if (!ASSERT_OK(err, "attach"))
>> +		goto close_prog;
>> +
>> +	if (test__start_subtest("userns_create_bpf"))
>> +		test_userns_create_bpf();
>> +
>> +	test_deny_namespace__detach(skel);
>> +
>> +close_prog:
>> +	test_deny_namespace__destroy(skel);
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/test_deny_namespace.c b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
>> new file mode 100644
>> index 000000000000..9ec9dabc8372
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
>> @@ -0,0 +1,39 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <linux/bpf.h>
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> +#include <errno.h>
>> +#include <linux/capability.h>
>> +
>> +struct kernel_cap_struct {
>> +	__u32 cap[_LINUX_CAPABILITY_U32S_3];
>> +} __attribute__((preserve_access_index));
>> +
>> +struct cred {
>> +	struct kernel_cap_struct cap_effective;
>> +} __attribute__((preserve_access_index));
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +SEC("lsm/userns_create")
>> +int BPF_PROG(test_userns_create, const struct cred *cred, int ret)
>> +{
>> +	struct kernel_cap_struct caps = cred->cap_effective;
>> +	int cap_index = CAP_TO_INDEX(CAP_SYS_ADMIN);
>> +	__u32 cap_mask = CAP_TO_MASK(CAP_SYS_ADMIN);
>> +
>> +	if (ret)
>> +		return 0;
>> +
>> +	ret = -EPERM;
>> +	if (caps.cap[cap_index] & cap_mask)
>> +		return 0;
>> +
>> +	return -EPERM;
>> +}
>> +
>> +SEC("lsm.s/userns_create")
>> +int BPF_PROG(test_sleepable_userns_create, const struct cred *cred, int ret)
>> +{
> An empty program is weird.  If the intention is
> to ensure a sleepable program can attach to userns_create,
> move the test logic here and remove the non-sleepable
> program above.
> 

Sure, I can do that.

>> +	return 0;
>> +}
>> -- 
>> 2.30.2
>>

