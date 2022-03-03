Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F064CBB09
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiCCKIt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Mar 2022 05:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiCCKIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:08:47 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A9516EAB3;
        Thu,  3 Mar 2022 02:08:01 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K8RTz6Vc5z67Wgc;
        Thu,  3 Mar 2022 18:06:47 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 11:07:59 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Thu, 3 Mar 2022 11:07:59 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
Thread-Topic: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
Thread-Index: AQHYLiawVJiGIoJTAUWtCyWVLc4li6ysmoEAgADV/tA=
Date:   Thu, 3 Mar 2022 10:07:59 +0000
Message-ID: <c9ef19a0203e4e9eb9416fa84d034db0@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
 <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
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

> From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> Sent: Wednesday, March 2, 2022 11:21 PM
> On Wed, Mar 02, 2022 at 12:13:55PM +0100, Roberto Sassu wrote:
> > Extend the interoperability with IMA, to give wider flexibility for the
> > implementation of integrity-focused LSMs based on eBPF.
> >
> > Patch 1 fixes some style issues.
> >
> > Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> > measurement capability of IMA without needing to setup a policy in IMA
> > (those LSMs might implement the policy capability themselves).
> >
> > Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.
> >
> > Changelog
> >
> > v2:
> > - Add better description to patch 1 (suggested by Shuah)
> > - Recalculate digest if it is not fresh (when IMA_COLLECTED flag not set)
> > - Move declaration of bpf_ima_file_hash() at the end (suggested by
> >   Yonghong)
> > - Add tests to check if the digest has been recalculated
> > - Add deny test for bpf_kernel_read_file()
> > - Add description to tests
> >
> > v1:
> > - Modify ima_file_hash() only and allow the usage of the function with the
> >   modified behavior by eBPF-based LSMs through the new function
> >   bpf_ima_file_hash() (suggested by Mimi)
> > - Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
> >   and bpf_ima_file_hash() can be called inside the implementation of
> >   eBPF-based LSMs for this hook
> >
> > Roberto Sassu (9):
> >   ima: Fix documentation-related warnings in ima_main.c
> >   ima: Always return a file measurement in ima_file_hash()
> >   bpf-lsm: Introduce new helper bpf_ima_file_hash()
> >   selftests/bpf: Move sample generation code to ima_test_common()
> >   selftests/bpf: Add test for bpf_ima_file_hash()
> >   selftests/bpf: Check if the digest is refreshed after a file write
> >   bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
> >   selftests/bpf: Add test for bpf_lsm_kernel_read_file()
> >   selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA
> >     policy
> 
> We have to land this set through bpf-next.
> Please get the Acks for patches 1 and 2, so we can proceed.

Ok. Mimi, do you have time to have a look at those patches?

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua
