Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B83306ADB
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhA1CAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:00:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230527AbhA1CAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 21:00:49 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10S1xmgF020185;
        Wed, 27 Jan 2021 17:59:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nPuyN+q31kP+7UFbw8xLeD59k4mOKgQNkOmg36SHu40=;
 b=qKBpY4lV20Gl72E5+Lpd9XuHwuXBf0OrmHdtSgw1OWa/NTVket+DIHVQC3nnMLRB9Tps
 S7bmQJ5p/sqvRwMMIM8KFxcfUXERlgzG8IJzPZA6c3e7or5Oj70XGYWgkYox/7yrtP0t
 mFD2s4332nlvMXI/SNv7et3Vt3I4mEi8BLM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36b7vwm3gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Jan 2021 17:59:51 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 17:59:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mam8umr5oOlTj4ehWJ6XtSSG2MlISO2+4f13ff2w5BnTT/hg7XlzbJV6axW1VI/o9HzQvRd4Fzm6ZlQO6pjCFs7FwKiB4gMUTy1sOQjFNOXULS2yH4XjV82xRyG6aQK2ESUQYkVUPca4jmTlgOpzcIAjuI2EIwXpylKMaYEpHAS9Zp20PMz+9Fd4oCx+csVX7WSdKg6ZLtryO+JKRLolbXoeckEWigXBVokvJCqgXb2AONErk/CC6kEDgqV9Z6Z5Cw66sFAyI4ntSs+B5EaxkaDmACqE+NxxfDKCgCgmGV6p7DQJuLL9GaMAWIceDPKNTfpLUBeCbXeWZr4xliNfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPuyN+q31kP+7UFbw8xLeD59k4mOKgQNkOmg36SHu40=;
 b=T6n251mSU8O2QiybWPSoREljXJaac5VLqa/4TzMBYCjiOU9TZxrhG+Yp+NcyhV5S1iB0OykVUN2k/JhRyz6IaBmHTL9v9OT4tQJxBJQAFf092awol8byZL+Of42vuPwQu+be9eRLBQkREMxMUzXTrB0G4CflaUr//IiY9IIrqLS3GUEyfXZZ4I5j2ObFlbNXfhJ9FLZMcBB3jP2WBvQW7Q6BM5Yxzer2PUY8Tb0xtXqPiKgU24Rqg5kfcP2OAfuOH9VaxlMjDKFcculRilgp8uru7j3YyC6881F50Y5IQZRcngKVw4ljYB4zz6Gmv+cAUfBlWOIw5OZZbDRP4diouA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPuyN+q31kP+7UFbw8xLeD59k4mOKgQNkOmg36SHu40=;
 b=hZKx/ZLjUI8/yZbir2+tpPFVRDNwOdGXiY3Xpv9fhOkB724/SaJPN/sW6oLv8fRwh9JYsNP1O9J0CK7zCLs6rySSRge5W02sCL8Yt/8S6sX80yhdUmJJJbgaEjpY/JdN/xAiWYKZygc3VNA1g1E16pDN9FTlmoHAQPP6zIiXWuM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 28 Jan
 2021 01:59:47 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26%6]) with mapi id 15.20.3784.019; Thu, 28 Jan 2021
 01:59:47 +0000
Date:   Wed, 27 Jan 2021 17:59:45 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v5 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <YBIakXaGQoI/1bvA@rdna-mbp.dhcp.thefacebook.com>
References: <20210127193140.3170382-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210127193140.3170382-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:485e]
X-ClientProxiedBy: MW4PR04CA0362.namprd04.prod.outlook.com
 (2603:10b6:303:81::7) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:485e) by MW4PR04CA0362.namprd04.prod.outlook.com (2603:10b6:303:81::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Thu, 28 Jan 2021 01:59:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d2b1d38-e692-4561-c1fa-08d8c33063da
X-MS-TrafficTypeDiagnostic: BYAPR15MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29510CD041D1BC3613502363A8BA9@BYAPR15MB2951.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Jt/2+YkWeicRxfkt37hGEAtTXlHon8kUp/RVto0FZuR2CawJEDmAO9b/vx7gpQORlSGUTySVbKTZu+/ia4CP/DCQNMEWE9LOEUxnplc/l8tYqMZHlMk5MfsklucurObSZh2PFwxYy/4YBIcqKoGV5qFlkqOemLLHhL86izYCxMMGIgi1VEqJyFREm5W0A9Hr4OovVIt8Pm3tdqHBviESWR8FV6eR0lvtT21r0xbZuHBGqMLni71n4HyA6fd7+MZ7oEiQ7yufEEBV8aVN49eTh0IQmqeoMTossTFGExc7QL40n7ejqKSqxyOA14ujOhzxlL4GPndNVPVtFUaAVutwhPQgD9jIaqOZwPm64CA7n24ZJxRwtHB3ntgIbYtfwPzYgS7Mplsb+Xx4o3hewNr3xMHhp6UFsnEk2xrkOZESdhKgXuubpP8QB1AZtOygmSgCQdLND3ZRNXRKEv7YYngNIxDNZ7yRtnL9som5CLS1k2ezNdb4I3XXExOso+9jls0fph1T6ZFo7tLLelSCz6Dzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(66476007)(4326008)(83380400001)(316002)(8936002)(16526019)(6486002)(86362001)(478600001)(186003)(66946007)(6916009)(66556008)(2906002)(5660300002)(6496006)(52116002)(9686003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L3NPZ1ltZjhZWFBLUXN4VGwvd3NYTE41R1o3OU03MUI1a0wyZ1RIdHMyamJn?=
 =?utf-8?B?eHUweG1xVWhZR2dZdHp3TWUrcm05T0RpVkF2dUtRYXVwVU0ySllXZU96NHFD?=
 =?utf-8?B?R0daN3ZXNnl1enNNaUR5R00xRm1qVkFLOTc4OVJFeDJ5aU1mTzM0am1QenNs?=
 =?utf-8?B?NUtkQWhXLzhIU1F5TGVvSkZnMlRDOWx5RWVrYzdZUncyQkNlQXU3alRnSVdK?=
 =?utf-8?B?Vml5VmRJa1BSYUpPU1JjRVJ1Y2U4Tm5YaFhtM3hIWGo1ZXhmakZWYkFaclVF?=
 =?utf-8?B?blVoOXFZdlcwelRBUXVOSTVJSVRvRXZFQzA1MG84YWV2enh4NEZNUHpoUjhS?=
 =?utf-8?B?SmtyQ3hDMW9wRWpRRXpxWmV0Ty9BQTd6VXl3bGhvMWxxekV1OUx0VDkzc0ow?=
 =?utf-8?B?bTVmanJJZVY0V0RnemphWnpUOXphT05HZnRuOWpTRTVaamQzVXdUSjRYSDF2?=
 =?utf-8?B?aGpkYkpNazBCWm4yYk40NXJMbFBsUWlPVlUxNHo4WDlWRTdxcWU3QWRicHNP?=
 =?utf-8?B?dVBpRGx2Zk13Mm1NanhRODZjVGM1bEdSaXJ4ZFVPZHdVa0Jqekl4WUR0UjlE?=
 =?utf-8?B?NUFQK0licEFUY1Fhd1FrRUlUK2M0bytIczAyM296SDRxT0NhRHV5c3NGcHVj?=
 =?utf-8?B?OWt2MUp2SFB0cnN1Rm5ONkhGOHJiemk0bWhFSCsyRGdGZEZRL0o4UlhGcGtp?=
 =?utf-8?B?SENKTUlUVmdzV0NNK3BsQ3lGOVRMZ0J4c096OWc0ajBWSjJkdWRFakZCUVNI?=
 =?utf-8?B?K004a0czZTdSdjc1VDdrTFA0WmUyU0JvdjlCRW9RYTJzaVJsa3J4YTExQXpX?=
 =?utf-8?B?eFBXVFpQY3pUUlYzK3dQOGs1dUJ6TVZvbm91Zncxc01JSkJJdXp1VlBXYUxk?=
 =?utf-8?B?UFR1bjBlMklrYnRNV3N1QVBKcm1qWStOZ2VzM1hnRU5WenVhYnV6a01rYXVJ?=
 =?utf-8?B?WEd2TGpvN2hDWFpxQTZsL2VMQ1dCM05FazlvMFF0eGhhT1FmamJGckpzajU1?=
 =?utf-8?B?aTd0eEpUak1iZ3BDTlZpQzhtMFkvOWVhZzZBeDBUNFA4NTRRcis1TzdMK3RY?=
 =?utf-8?B?ck4zQldZcTJiMnNwa1drTWRCYU5vMGZ0NXVCdHVGU0o1R2hqRTJDM2hJQkVq?=
 =?utf-8?B?T2tNQzFUT3JoNEhtUTlOSDB1RVZEcXdpeHY1VUFXSWREQVFyM0dOQXp3NG9E?=
 =?utf-8?B?TnZpYlQ0cGVVclJZM292NVlXSzRVRVduRWxFWjBjUDVDZzh0NGNFR1ZIVW1K?=
 =?utf-8?B?ejFKQ3NWTEdtUm8wT2UvYXd2bjhsRnliTmdUQlFyVVhxWmliUHg4UXMxTUZj?=
 =?utf-8?B?MThJVXVpd1FCSmxxckVYalVkbFQvYlV1QlBnekwrc1pnQzhGV3p5K2drMDBi?=
 =?utf-8?B?ZmdnV0lZWGNFeDUzWG9ySHFpMUNEclJ4NDJiYlhZaG5uUU5rZzJLM3p6WkNV?=
 =?utf-8?B?b2ZYWVhqeHRzMmNIQVZReUhkYWh2ay84aXh2czFyd2FlMG1LZGdmQXhlcU1F?=
 =?utf-8?Q?fZQfIQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2b1d38-e692-4561-c1fa-08d8c33063da
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 01:59:47.5661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3ETKgjE1jEDqhS2ke1H8KNlpTtIW/jY0+7kYF5QTVxaXzXpkpElGNudMHWD9O9r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_10:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Wed, 2021-01-27 11:32 -0800]:
> At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> to the privileged ones (< ip_unprivileged_port_start), but it will
> be rejected later on in the __inet_bind or __inet6_bind.
> 
> Let's add another return value to indicate that CAP_NET_BIND_SERVICE
> check should be ignored. Use the same idea as we currently use
> in cgroup/egress where bit #1 indicates CN. Instead, for
> cgroup/bind{4,6}, bit #1 indicates that CAP_NET_BIND_SERVICE should
> be bypassed.
> 
> v5:
> - rename flags to be less confusing (Andrey Ignatov)
> - rework BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY to work on flags
>   and accept BPF_RET_SET_CN (no behavioral changes)
> 
> v4:
> - Add missing IPv6 support (Martin KaFai Lau)
> 
> v3:
> - Update description (Martin KaFai Lau)
> - Fix capability restore in selftest (Martin KaFai Lau)
> 
> v2:
> - Switch to explicit return code (Martin KaFai Lau)
> 
> Acked-by: Andrey Ignatov <rdna@fb.com>
> Reviewed-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Thanks for cleaning up the flags workflow, incl. BPF_RET_SET_CN. This is
more readable indeed.

-- 
Andrey Ignatov
