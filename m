Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281944F541F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiDFE0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444293AbiDEWVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 18:21:02 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E02DA6D5;
        Tue,  5 Apr 2022 13:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1649191622; x=1680727622;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5oM6Tbg3YS4sB6Uf6R0fiZCcMu82OqpwkpFDAxE4yH4=;
  b=FW+KnMELhHxYWkklzmhF84FYlIxwlOv6PDYgwjGPlzaUUhLubZU2Nkoy
   S3/pSpi9Bx2vPGzXWP/CSCjDDSJKOsoU/YjpVNUBSFvPVKwFNoEdK+L/5
   u0iQhniJlvSQcYMFOF4GzQCW1HrnocwD6RnIMYv7WavI3WQTex8gvyhBQ
   8=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 05 Apr 2022 13:47:02 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 13:47:02 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 5 Apr 2022 13:47:01 -0700
Received: from [10.110.72.142] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 5 Apr 2022
 13:46:59 -0700
Message-ID: <82b87aee-09c2-fbad-7613-4e298bcb3431@quicinc.com>
Date:   Tue, 5 Apr 2022 13:46:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next v3 07/27] bpf: selftests: Set libbpf 1.0 API mode
 explicitly in get_cgroup_id_user
Content-Language: en-US
To:     Yafang Shao <laoar.shao@gmail.com>, <andrii@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <shuah@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
 <20220405130858.12165-8-laoar.shao@gmail.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220405130858.12165-8-laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/2022 6:08 AM, Yafang Shao wrote:
> Let's set libbpf 1.0 API mode explicitly, then we can get rid of the
> included bpf_rlimit.h.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>   tools/testing/selftests/bpf/test_dev_cgroup.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_dev_cgroup.c b/tools/testing/selftests/bpf/test_dev_cgroup.c

patch subject should refer to test_dev_cgroup
(currently has same subject as 05/27)

> index c299d3452695..7886265846a0 100644
> --- a/tools/testing/selftests/bpf/test_dev_cgroup.c
> +++ b/tools/testing/selftests/bpf/test_dev_cgroup.c
> @@ -15,7 +15,6 @@
>   
>   #include "cgroup_helpers.h"
>   #include "testing_helpers.h"
> -#include "bpf_rlimit.h"
>   
>   #define DEV_CGROUP_PROG "./dev_cgroup.o"
>   
> @@ -28,6 +27,9 @@ int main(int argc, char **argv)
>   	int prog_fd, cgroup_fd;
>   	__u32 prog_cnt;
>   
> +	/* Use libbpf 1.0 API mode */
> +	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> +
>   	if (bpf_prog_test_load(DEV_CGROUP_PROG, BPF_PROG_TYPE_CGROUP_DEVICE,
>   			  &obj, &prog_fd)) {
>   		printf("Failed to load DEV_CGROUP program\n");

