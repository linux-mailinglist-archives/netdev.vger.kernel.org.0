Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3463441B1CC
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhI1OP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:15:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13376 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240172AbhI1OP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:15:28 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HJhFc36jsz8yss;
        Tue, 28 Sep 2021 22:09:08 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 22:13:46 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 22:13:45 +0800
From:   Hou Tao <houtao1@huawei.com>
Subject: Question about the release of BPF_MAP_TYPE_STRUCT_OPS fd
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Message-ID: <a6ba3289-accd-051a-b27c-d90df0eb7cd2@huawei.com>
Date:   Tue, 28 Sep 2021 22:13:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

During the testing of bpf_tcp_ca, I found that if the test program
aborts before calling bpf_link__detach_struct_ops(), the registered
bpf_dctcp will not be unregistered, and running bpf_tcp_ca test again
will fail with -EEXIST error as shown below:

test_dctcp:PASS:bpf_dctcp__open_and_load 0 nsec
test_dctcp:FAIL:bpf_map__attach_struct_ops unexpected error: -17

The root cause is that the release of BPF_MAP_TYPE_STRUCT_OPS fd
neither put struct_ops programs in maps nor unregister the struct_ops
from kernel. Was the implementation intentional, or was it an oversight ?
If it is an oversight, I will post a patch to fix it.

Regards,
Tao
