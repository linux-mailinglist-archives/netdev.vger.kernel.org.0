Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24A74FF0FB
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiDMHzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiDMHzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:55:48 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C3B2E6AE;
        Wed, 13 Apr 2022 00:53:28 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CNGdBH018367;
        Wed, 13 Apr 2022 00:53:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=4+oCveBiNfxlLaRAa/yRgV0dY8t5XeKZT379ZpPG0Dk=;
 b=A9o1N3eezueUVTpbgt+zO8XE++5/9dkbar0oPkMpiHsNPoaVdGJkpQmEIZuxhje2slr0
 w3GKOvDek7SEMNqAPxzdZb8EuIf9pXHM0ccHbHutGMnIeeUsJwTZIvAGpdSkX2583lLk
 iiJv/3hzzbhoP3tO3Fv2dOvFr3Lzkoe/emjaKSY04i6nhDVymFMvMSMJ3CwsnYnPftyL
 qRg4U0tlsJj7gFnsYD2y3lQSWkL7pAVVps69tinQ5kc9aEpM75pRL82JIgGxCBJ4KCxL
 9APQ3QG3ymPJTpbVBDangDxYVobOssHDzMCCekG0iKyHVDQLcq17z6kPJRB71XZNMVPh Ww== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fdjxysnxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 00:53:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Apr
 2022 00:53:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 13 Apr 2022 00:53:07 -0700
Received: from [10.193.34.141] (unknown [10.193.34.141])
        by maili.marvell.com (Postfix) with ESMTP id CBE983F7045;
        Wed, 13 Apr 2022 00:52:59 -0700 (PDT)
Message-ID: <dac72406-2743-ce1a-a0d7-4078e5d222be@marvell.com>
Date:   Wed, 13 Apr 2022 09:52:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101
 Thunderbird/99.0
Subject: Re: [EXT] [PATCH net-next v4 0/3] net: atlantic: Add XDP support
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>
References: <20220408181714.15354-1-ap420073@gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20220408181714.15354-1-ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: qa77qsuw5CWfhrDI60ppcal88QmImgsI
X-Proofpoint-ORIG-GUID: qa77qsuw5CWfhrDI60ppcal88QmImgsI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_08,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> v4:
>  - Fix compile warning
> 
> v3:
>  - Change wrong PPS performance result 40% -> 80% in single
>    core(Intel i3-12100)
>  - Separate aq_nic_map_xdp() from aq_nic_map_skb()
>  - Drop multi buffer packets if single buffer XDP is attached
>  - Disable LRO when single buffer XDP is attached
>  - Use xdp_get_{frame/buff}_len()

Hi Taehee, thanks for taking care of that!

Reviewed-by: Igor Russkikh <irusskikh@marvell.com>

A small notice about the selection of 3K packet size for XDP.
Its a kind of compromise I think, because with common 1.4K MTU we'll get wasted
2K bytes minimum per packet.

I was thinking it would be possible to reuse the existing page flipping technique
together with higher page_order, to keep default 2K fragment size.
E.g.
( 256(xdp_head)+2K(pkt frag) ) x 3 (flips) = ~7K

Meaning we can allocate 8K (page_order=1) pages, and fit three xdp packets into each, wasting only 1K per three packets.

But its just kind of an idea for future optimization.

Regards,
  Igor
