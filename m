Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF60D6CCC14
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjC1VYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjC1VYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:24:07 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A0C128
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:24:07 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id y184so10083828oiy.8
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680038646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ei1+ZkIr7P6lb7pJQKjMkdmS4P4aKEm4kBIVhIGSGbc=;
        b=npAOiwWt7IVoJjs5P8y8cVU/tjKfHxu6O6RaR77z278lp9AN3JPSA2rkZX6UuLQ73C
         uvr+08cVB2SnqIfe1pP8yI2bIo5l7AAUb4GQMigq/U6BUFu9H+Tr93yRj+05gE6Q4l6W
         8hB4x3tmfyXDhg5EvPUc0vPdy6eszYlgS92nHwaOeZkpEF8x3CPYJYUyTNPb90x+b15F
         9IJUQQmp7gIUUWKIGPUHwpuMG1AvJ+fDHE+GdkMjvIO7k0Q/PVb7lzBGtGZ0cp6G5K1S
         vC+U+Xp85MMby6jl5F1AXK9xszSgbD703QK2b8FKPpZBfqfKKLiXTZIa+/9m7anxYHY5
         N27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680038646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ei1+ZkIr7P6lb7pJQKjMkdmS4P4aKEm4kBIVhIGSGbc=;
        b=u50HWa4poU2hnIZMYVCCmUV60IGvMP/mezn1PQQzwcfX7I3YUWKHtEHpCP0FTQ2DGJ
         XOExD5lrY7GMYCLMMhtKg48CsQ+1nQg57ttFrMlXfVoLBaILfcmfas1zZSoz9gUsQo6G
         j2xtsIVIe+BARvVJ76I2xfOBevJ1V3vKcVGelKNXFnQ+ak3rp4gm+A4KXyvSlfKk7gh4
         aEHbFxmGQaZKmQTARn7wN25nxx3s96mQIPC4qVIY7eAad06ZMITPFeh00exBAh4TOqYf
         RFc3TBhsG+5QjUMgrIIniuyW9Gq1NBBIh7T4VGWfStiVWqJfsaPQK/xzyJ/T+OD6QKMc
         s7Wg==
X-Gm-Message-State: AO0yUKVLK70CjVHpPWNvj4M/LEcy6XHQov4vfDTZ2XfCVIgx738Ut0nk
        A/MlPjiFuRxFQXBvlQiYzz9YLNIla6zjRJPbLqs=
X-Google-Smtp-Source: AK7set99h7QGAjVwEib7HP65M0035yS9MBd5T+v4iqHBasxM5wyU0Qbb+u3ywFFLcUA6qXIw0iQ9Aw==
X-Received: by 2002:a05:6808:a91:b0:387:3694:d5d6 with SMTP id q17-20020a0568080a9100b003873694d5d6mr7714169oij.25.1680038646295;
        Tue, 28 Mar 2023 14:24:06 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:7010:5bd:70ea:a1f8? ([2804:14d:5c5e:4698:7010:5bd:70ea:a1f8])
        by smtp.gmail.com with ESMTPSA id l20-20020a544114000000b0038413a012dasm8239435oic.4.2023.03.28.14.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 14:24:05 -0700 (PDT)
Message-ID: <71fcc44f-b283-4868-dc97-14441a040147@mojatatu.com>
Date:   Tue, 28 Mar 2023 18:24:02 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 2/4] selftests: tc-testing: add "depends_on"
 property to skip tests
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1680021219.git.dcaratti@redhat.com>
 <1113c9203f6bb491819dec865d3e107a69a13ec6.1680021219.git.dcaratti@redhat.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <1113c9203f6bb491819dec865d3e107a69a13ec6.1680021219.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2023 13:45, Davide Caratti wrote:
> currently, users can skip individual test cases by means of writing
> 
>    "skip": "yes"
> 
> in the scenario file. Extend this functionality, introducing 'dependsOn':
> it's optional property like "skip", but the value contains a command (for
> example, a probe on iproute2 to check if it supports a specific feature).
> If such property is present, tdc executes that command and skips the test
> when the return value is non-zero.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>   .../creating-testcases/AddingTestCases.txt          |  2 ++
>   tools/testing/selftests/tc-testing/tdc.py           | 13 +++++++++++++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
> index a28571aff0e1..ff956d8c99c5 100644
> --- a/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
> +++ b/tools/testing/selftests/tc-testing/creating-testcases/AddingTestCases.txt
> @@ -38,6 +38,8 @@ skip:         A completely optional key, if the corresponding value is "yes"
>                 this test case will still appear in the results output but
>                 marked as skipped. This key can be placed anywhere inside the
>                 test case at the top level.
> +dependsOn:    Same as 'skip', but the value is executed as a command. The test
> +              is skipped when the command returns non-zero.
>   category:     A list of single-word descriptions covering what the command
>                 under test is testing. Example: filter, actions, u32, gact, etc.
>   setup:        The list of commands required to ensure the command under test
> diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
> index 7bd94f8e490a..5fa3fe644bfe 100755
> --- a/tools/testing/selftests/tc-testing/tdc.py
> +++ b/tools/testing/selftests/tc-testing/tdc.py
> @@ -369,6 +369,19 @@ def run_one_test(pm, args, index, tidx):
>               pm.call_post_execute()
>               return res
>   
> +    if 'dependsOn' in tidx:
> +        if (args.verbose > 0):
> +            print('probe command for test skip')
> +        (p, procout) = exec_cmd(args, pm, 'execute', tidx['dependsOn'])
> +        if p:
> +            if (p.returncode != 0):
> +                res = TestResult(tidx['id'], tidx['name'])
> +                res.set_result(ResultState.skip)
> +                res.set_errormsg('probe command failed: test skipped.')

'probe command: test skipped'

> +                pm.call_pre_case(tidx, test_skip=True)
> +                pm.call_post_execute()
> +                return res
> +
>       # populate NAMES with TESTID for this test
>       NAMES['TESTID'] = tidx['id']
>   

Other than the above, LGTM.

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
