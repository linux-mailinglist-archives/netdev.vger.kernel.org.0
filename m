Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75FF4BBBAF
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbiBRPCY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Feb 2022 10:02:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiBRPCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:02:19 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEBD18D232;
        Fri, 18 Feb 2022 07:02:00 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K0ZdT5fdXz67sHf;
        Fri, 18 Feb 2022 23:01:01 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 16:01:57 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Fri, 18 Feb 2022 16:01:57 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Thread-Topic: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Thread-Index: AQHYImlgJM6Z1962JUm5hvc+dgM0dqyZawKA
Date:   Fri, 18 Feb 2022 15:01:57 +0000
Message-ID: <4513acbef98840199ff62124601cf455@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
In-Reply-To: <20220215124042.186506-1-roberto.sassu@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Roberto Sassu
> Sent: Tuesday, February 15, 2022 1:41 PM
> Extend the interoperability with IMA, to give wider flexibility for the
> implementation of integrity-focused LSMs based on eBPF.
> 
> Patch 1 fixes some style issues.
> 
> Patches 2-4 gives the ability to eBPF-based LSMs to take advantage of the
> measurement capability of IMA without needing to setup a policy in IMA
> (those LSMs might implement the policy capability themselves).
> 
> Patches 5-6 allows eBPF-based LSMs to evaluate files read by the kernel.

Hi everyone

I published the new DIGLIM eBPF, that takes advantage of
the new features introduced with this patch set:

https://github.com/robertosassu/diglim-ebpf

the eBPF program is in ebpf/diglim_kern.c

If you could have a look and give me some comments
or suggestions, it would be very appreciated!

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

> Changelog
> 
> v1:
> - Modify ima_file_hash() only and allow the usage of the function with the
>   modified behavior by eBPF-based LSMs through the new function
>   bpf_ima_file_hash() (suggested by Mimi)
> - Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
>   and bpf_ima_file_hash() can be called inside the implementation of
>   eBPF-based LSMs for this hook
> 
> Roberto Sassu (6):
>   ima: Fix documentation-related warnings in ima_main.c
>   ima: Always return a file measurement in ima_file_hash()
>   bpf-lsm: Introduce new helper bpf_ima_file_hash()
>   selftests/bpf: Add test for bpf_ima_file_hash()
>   bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
>   selftests/bpf: Add test for bpf_lsm_kernel_read_file()
> 
>  include/uapi/linux/bpf.h                      | 11 +++++
>  kernel/bpf/bpf_lsm.c                          | 21 +++++++++
>  security/integrity/ima/ima_main.c             | 47 ++++++++++++-------
>  tools/include/uapi/linux/bpf.h                | 11 +++++
>  tools/testing/selftests/bpf/ima_setup.sh      |  2 +
>  .../selftests/bpf/prog_tests/test_ima.c       | 30 ++++++++++--
>  tools/testing/selftests/bpf/progs/ima.c       | 34 ++++++++++++--
>  7 files changed, 132 insertions(+), 24 deletions(-)
> 
> --
> 2.32.0

