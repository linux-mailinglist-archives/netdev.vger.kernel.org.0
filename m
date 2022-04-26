Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20500510331
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352939AbiDZQYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352941AbiDZQX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:23:56 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6481D3DA6;
        Tue, 26 Apr 2022 09:20:46 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23QDDBSN029493;
        Tue, 26 Apr 2022 09:20:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=ubNDydfKF8ox4o7eLY4+glSSy0wWOtCY2o+4EHI1MYE=;
 b=ZEdn9nWk99jYF2jrEeDKvbX8VXT28JVb1QcIRVW8fEy42gmTzvYrFffrcPtxEX2jRE0x
 r2lOsEiLZY158Tua7XpdOimKZJDXq7LRmXE675I3Xz+DuwRmPqOIWJ4FiuFZaLgh2vqX
 iSsi+nycPFHT3E3+nG2ABGtt9pkfIcYRnwAWi9gcglTH0PjT8K5q053snlfGbMFytxtt
 7t4eK1vKUZCrWcA0+PaV/+N0FLLVd0DofEV8Ga1vfOasu2l+v6J1VqjHXvb0i82KWoZ7
 YbTVJW4tzyTZYwXkrY6l7aPkWDqGYf4xajttfSowLnTCr7Gi7uqINmb6JUXDpEB1XPwP 3g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fp868av2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:20:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Apr
 2022 09:20:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Apr 2022 09:20:18 -0700
Received: from [10.193.34.141] (unknown [10.193.34.141])
        by maili.marvell.com (Postfix) with ESMTP id 66A473F708A;
        Tue, 26 Apr 2022 09:19:50 -0700 (PDT)
Message-ID: <69541987-fe2e-c7ab-814e-06e5575cf4c0@marvell.com>
Date:   Tue, 26 Apr 2022 18:19:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101
 Thunderbird/100.0
Subject: Re: [EXT] [PATCH net-next v5 0/3] net: atlantic: Add XDP support
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>
References: <20220417101247.13544-1-ap420073@gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20220417101247.13544-1-ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: om_pomMjob5vOlAqzgoQO0ND_8GTfTj5
X-Proofpoint-GUID: om_pomMjob5vOlAqzgoQO0ND_8GTfTj5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Taehee,

v5 looks great with these pageorder changes.

> v5:
>  - Use MEM_TYPE_PAGE_SHARED instead of MEM_TYPE_PAGE_ORDER0
>  - Use 2K frame size instead of 3K
>  - Use order-2 page allocation instead of order-0
>  - Rename aq_get_rxpage() to aq_alloc_rxpages()
>  - Add missing PageFree stats for ethtool
>  - Remove aq_unset_rxpage_xdp(), introduced by v2 patch due to
>    change of memory model
>  - Fix wrong last parameter value of xdp_prepare_buff()
>  - Add aq_get_rxpages_xdp() to increase page reference count


  Igor
