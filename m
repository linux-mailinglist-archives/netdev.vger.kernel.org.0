Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4851B880
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 09:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbiEEHPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 03:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiEEHPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 03:15:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C7C33E85;
        Thu,  5 May 2022 00:11:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.16.1.2) with ESMTP id 244LXu5f013451;
        Thu, 5 May 2022 00:11:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=h4K4sOayga0gZI8RfBh9lbccbKmt+58cwl9qH4N2V6A=;
 b=AS++L2ACiWLYnaHP1LGi8vPbztbpw7m7DuTrro3r5sxhvxND18YYb5M+voofmTdcOt81
 46oFOMItEQRTIiKIU6Bl8gaMtQpqHkqLkhjutZxM/qMtUxRpRWDifO392wxt4qN0WM+Q
 UUPdhl8BsjSXkl22P+rgXYdPr1brLFyaGSfPblO7p9GhAyYeD3pxwDdkbpfZCOKQgJ8u
 Omg16XikjSHHS7/LAjXR4sDVafRZJM9KSA3jPD15iRr0usrsv4faTuJ+DO7Vo2jbRsiE
 VWVYi07ddNO3JLJcCA88iMJ5A0ChRbDGUVyBqsWR6xzXhFrRao1OI8aIy8OnSU/8PPCx NA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fuscx3t0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 00:11:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 May
 2022 00:11:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 May 2022 00:11:20 -0700
Received: from [10.9.118.10] (EL-LT0043.marvell.com [10.9.118.10])
        by maili.marvell.com (Postfix) with ESMTP id 2F4A63F70A1;
        Thu,  5 May 2022 00:11:07 -0700 (PDT)
Message-ID: <735b9c21-6a8f-0f28-d11d-bd9bbd78986b@marvell.com>
Date:   Thu, 5 May 2022 09:11:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101
 Thunderbird/100.0
Subject: Re: [EXT] Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
Content-Language: en-US
To:     Grant Grundler <grundler@chromium.org>,
        Dmitrii Bezrukov <dbezrukov@marvell.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        "Yi Chou" <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>
References: <20220418231746.2464800-1-grundler@chromium.org>
 <CANEJEGtaFCRhVBaVtHrQiJvwsuBk3f_4RNTg87CWERHt+453KA@mail.gmail.com>
 <23cbe4be-7ced-62da-8fdb-366b726fe10f@marvell.com>
 <CANEJEGtVFE8awJz3j9j7T2BseJ5qMd_7er7WbdPQNgrdz9F5dg@mail.gmail.com>
 <BY3PR18MB4578949E822F4787E95A126CB4C09@BY3PR18MB4578.namprd18.prod.outlook.com>
 <CANEJEGvsfnry=tFOyx+cTRHJyTo2-TNOe1u4AWV+J=amrFyZpw@mail.gmail.com>
 <BY3PR18MB4578158E656F2508B43B21F6B4C39@BY3PR18MB4578.namprd18.prod.outlook.com>
 <CANEJEGuVwMa9ufwBM817dnbUxBghM0mcsPvrwx1vAWLoZ+CLaA@mail.gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <CANEJEGuVwMa9ufwBM817dnbUxBghM0mcsPvrwx1vAWLoZ+CLaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: mPpyEPWLBG1ygaxvhhBGlCOAr_F_gBsQ
X-Proofpoint-ORIG-GUID: mPpyEPWLBG1ygaxvhhBGlCOAr_F_gBsQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_02,2022-05-04_02,2022-02-23_01
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Grant and Dmitrii,

>> So to close session I guess need to set is_rsc_completed to true when 
>> number of frags is going to exceed value MAX_SKB_FRAGS, then packet will 
>> be built and submitted to stack.
>> But of course need to check that there will not be any other corner cases 
>> with this new change.
> 
> Ok. Sounds like I should post a v2 then and just drop 1/5 and 5/5
> patches.  Will post that tomorrow.

I think the part with check `hw_head_ >= ring->size` still can be used safely (patch 5).

For patch 1 - I agree it may make things worse, so either drop or think on how to interpret invalid `next` and stop LRO session.

Thanks,
   Igor
