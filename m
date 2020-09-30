Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2CA27DFC4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 06:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgI3E6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 00:58:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41962 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725385AbgI3E6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 00:58:06 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08U4uanF000882;
        Tue, 29 Sep 2020 21:58:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4hiIl+t8iPEGle4KIr2PubrksLxP3hfkTyPzZ/3F/BU=;
 b=XzK5HC/4eQ2b2iAXskM3xDS6Xq/TUSz6ppJnltRwNw2ut8wRaowrlNoEiv2DheuwjGkT
 q7SQsaNQBsZHEcH17JuyDRPUr63Bqq+qij1heKg3F1w4nQd2mFIfw6CtL+a2s2JFZm8F
 yFrs7QL9JJzTmbRnnmHFj95NodcTKmh9uyc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vtvnmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 21:58:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 21:58:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCOotSiniAASYgbJq5EqeinwzE7WoocyCmY7xDdQ1LwaMXUH1MSV/fQ8oi/OrKKVzOfKXfc+mV4GvK4hCXvB0LcKQBkeNDVN6eG4zshUzWvOvxAhH0C9giciaI+bOmBpSvUBpswX4iol2kUYgfscfI6Kvtk/dLUmVUGF7ZXs2GzZe1i12eMWYwMKFsbOLyFC1iJg1x4H9/Vmx/fP2gUFEoo8qrmC6M1ZQD9Bew9mbiHWpXQnzswwufAEZiWwFN4GmCx0T7T3G8d7tcEK8bGPhyZYFHYuDcCm6YEB5SEEpnaxJyE0X+Om4SWHD+t/zFfnnI3/ONBGnYVY7YB4lnksZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hiIl+t8iPEGle4KIr2PubrksLxP3hfkTyPzZ/3F/BU=;
 b=n0qR9RaG2eeVJos4oIz4w1vKvLpQ11xdjHTMhtIwyEqrcujb5VTk4ZQu7OTpNZh62ZEreiY0gw/EXmWNpQvu87b+WK/Rgn3ypErUUXTIIDbdV0sTW3BdyRtb0WAAg/SMiYSNKIdbfeytjiRaOHo1eM4rLi68iGr+3seq9xhAf6lgcL7t2F27LI1enf/4mjzTQRI2x9Qq+s3Ywpw/knfMfslKT2BXCVYgKweCQcRr+jNs0d3k3BBjkMFyJ4WI9o/hvGZXXVx4j7bb6C8Vc0n/3NqX9eyB5b6lKAnU1DE11FsVCPh1JCOrdB36VMZm5KLOFnCxsZG8ntZAB11ZdYcotg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hiIl+t8iPEGle4KIr2PubrksLxP3hfkTyPzZ/3F/BU=;
 b=bQ8sH+R+wlI0T6DVK40VMJsn9O+PBKOFIK9gnvutqIAKzJO1nB5/LHa49WuM+3ZglQfgRavGhlGyhLSHm+P4Kk7ikPFVZbhLKgk038tNV7oGlqA7uuAjUr17ywKDCfBQZHmToQuwcPxpS0Ed2gJkVVRPKbpGYoxibzXwiR6ENKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.26; Wed, 30 Sep
 2020 04:58:00 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 04:58:00 +0000
Subject: Re: build failure (BTFIDS) with CONFIG_NET && !CONFIG_INET
To:     Michal Kubecek <mkubecek@suse.cz>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200929101737.3ufw36bngkmzppqk@lion.mk-sys.cz>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <28cee29b-9704-87d7-e8b9-04ab76b240b0@fb.com>
Date:   Tue, 29 Sep 2020 21:57:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200929101737.3ufw36bngkmzppqk@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a553]
X-ClientProxiedBy: MWHPR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:300:ad::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11c9] (2620:10d:c090:400::5:a553) by MWHPR15CA0036.namprd15.prod.outlook.com (2603:10b6:300:ad::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 30 Sep 2020 04:57:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19a0cdc8-fd9e-434b-7813-08d864fd67c1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-Microsoft-Antispam-PRVS: <BYAPR15MB23285AA02B3DFFD0417E5551D3330@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Vh0+7KmzR9JmJFW6YQActtx2E38dMyUttib62+pTY4XjlVq5zRW8D8Lrc+sa9TnzWif7+bejtfbntD+Y8t1oVFw6JIqz2i6tP30LJzQ9loCF4EEHXqebcOZ5CRn/we5hNGOLyJQFHRYgugaqZUrJKOpyxS+zJh4G77XPNG9OvmWoPSfyzEBgEH7O+OwzqNodVhAyYpua9o5YAD6L4SY7vBLnRF8Z+sOEHEf+KFitSM6YHwPlGZijibAwxSQc0od7Dj+AJfIK1ATeg5E9D44FogJk7vdyEHIiDJCjX2vj+3d8ckMm91GpWMJDxoRC4qpE1OTGg/HlgIaRU4a2Vo6WFFe2P3XIY0qOJUUl9Z+U38dItGFxKIn76VhfLOORC+c70wKd+llwqNNcG5iuPP4mfc6nEbeObRtpLEPC6HwIiigVkMaTM5wv4hvQFFcFcXz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(39860400002)(136003)(8936002)(6486002)(316002)(8676002)(36756003)(53546011)(4326008)(52116002)(31696002)(186003)(16526019)(86362001)(478600001)(2616005)(2906002)(5660300002)(66476007)(66556008)(83380400001)(31686004)(4744005)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: UKrk8ygHpNyqjhUCcnXOF6Uryg7NSDeEyniYiTeOETdhHNL8G7jQzFjaX3yAimwVBrHM+uTE92z0r1wdGghAnW60YXwEZageNP4qNtsz6TW7cLYn4mkc8dIvfZMz2rc12txwbqDwybhjQx61xxaMMPSk3LojNVQknQrmZoWSbW6JYFxGVDmu37ECSaAXBUCWQFUrehtd9J6QQXa2lMN4tkFoyqj++IQvWr3uv/fC4up8ETyfvgafveif7zKHLI/OXOgZfpKsyK9x8RI7fSA/YNIEC0MoVskKmcESmGLIb09NEoixufWfRbYiL2KMOZKgjWLTlVpzyF4mCgLLWLRgs0m2IP7BsoT6UtsOOPhRLJj/ylWYZ3z5P3xpOxaJxdHClN/ObMaz9MUax704xK/STbrZxW4t/+Prwn3DfSNOyKAy8GO47runrQ1zudKmzppUpf9XLqBBXh5F6papJR/5EK6L1y3zBhPh1hl4eyfydDrkTXOEosMiSYt1TFtXohYPNfyvSb9yO79Of1AcPCbgikbyc7DB8wTK5PrYIoHrEzzgrKGfRhv68sCIqWi7nXgny/bJoMpRWYSMPgOPQbcvCYM/m/GBJNuJvajm89ntOKQ0ipA2yiaYIH5BH7NR6Q2xdmv4o7+gsbdwmAwL2pCL+W5VJOchpjHtToEe8ddpoFOfjWx8tNEpndbwcoZ2a3MX
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a0cdc8-fd9e-434b-7813-08d864fd67c1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 04:58:00.5589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6YVT0hl4pAsIbNcanZ2p1yima7OHt15xfnTENWwR75UgmafP6PFj/dtVW7Iw1WL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_01:2020-09-29,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300038
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/20 3:17 AM, Michal Kubecek wrote:
> Hello,
> 
> our builds of s390x for zfcpdump fail since 5.9-rc1 with
> 
>      BTFIDS  vmlinux
>    FAILED unresolved symbol tcp_timewait_sock
>    make[1]: *** [/home/abuild/rpmbuild/BUILD/kernel-zfcpdump-5.9.rc7/linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
> 
> I believe this is caused by commit fce557bcef11 ("bpf: Make btf_sock_ids
> global") and the problem is caused by a specific configuration which has
> CONFIG_NET enabled but CONFIG_INET disabled. IIUC there will be no user
> of struct tcp_timewait_sock but btf_ids will try to generate BTF info
> for it.

Thanks for reporting! Will send a patch to fix the issue soon.

> 
> Michal
> 
