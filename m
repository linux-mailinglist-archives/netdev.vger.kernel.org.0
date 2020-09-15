Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7626626ACBE
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgIOS6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:58:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29936 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727871AbgIOS6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:58:43 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FIiDuD012795;
        Tue, 15 Sep 2020 11:58:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0Zg8MVAh2GieNzarK06zw5O1ABPoaIqknKSMAZ0A2no=;
 b=ClziXJQtCTBCCde2H5cKfBKkictOEmq+jl/0oeEs6h+9svf5lQXgy8AAwEMDyAsITJFu
 5ZNs9Bjt6BcEcfnXMBtKuuf0QuRB152/hhHVaI9kg8RLBgJQJvS2wTOttB8ib032vrAY
 3PXVbJmIkeU6ll0mFBpt8pWl3FWju7f/5/g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33gv2phakc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 11:58:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 11:58:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmJ8H5WFeT4pT0PQ0A90hfnLGb0OYisRELLHn8nvHCht0YRwdZqvgPvSnr/udU4eYVfKCpmXq1mcZefJzUWQKsKwvyuyGkFnvQ1TBr19EDObreeJa+uot2GlGiG5f0ICQaGtuGY7pP2/CfZ9UzwWKdgrepPOXuCt7ygEaT+ZHOo2Acs7njXPhDe+ieN0/VyUCDBPac8U6+ATIWakEJJfYxgJDxu9HVsFUuM7Fg93DSvdUBG/O6zI6NhJa2hHGG6GjOHfT0OlbMdDzFsuewUlwiaxnXc3j00Tcq0WXf1Qw2uWWtp5YQ/xEyvOCLrzNzR7HEWrUARxqflDIUAMBS+GVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Zg8MVAh2GieNzarK06zw5O1ABPoaIqknKSMAZ0A2no=;
 b=cpi1qpbboxY6MZAGuhCdJGBegLyNP1wBUPONK0/gvHng4Z8BvEIx3U5IH4DtF4Q3g1qSYneasKOeDq0vmxGoPNpzyAh6XSfRbJFFDid/BmKMgnxCxijcBqmvaoxHofxTd/V+ipnX6OU6a6UyfkpwQf+Hv7Zd/64KFREK/cbD7drs66WWLzHjfTuM2tD1BPylw0VG4eqWaKt8J2+FG/m7qyFH93p45zIYDWEpiyEbPb7r10KbYIx7ZBdMMQ4+AsPD7JqEIZ3+ZT8yDbOaA3+QpkzO+wVkNFR2PQadF46RK0nOZbz5wlshY4uF0Ry/3mFXiGFO8tbtOYgapaZZGxjfMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Zg8MVAh2GieNzarK06zw5O1ABPoaIqknKSMAZ0A2no=;
 b=MJ6BYIafNbG5+S7LMYe49KlB086Y0f6lVOLvBr5UJ3YT5cXrtqlJ625LD2/OQo/4JnYSs8p0+s3KUPRLPLo30Dv/yDdSPo0zQjo91LjQD/LKPehfSUMp4k8MYxbZBDaxePmUiXwcE/nT0y8LOqRVDBz54nienc+q+buvZHOTKnM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 18:58:03 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 18:58:03 +0000
Subject: Re: [PATCH bpf] bpf: bpf_skc_to_* casting helpers require a NULL
 check on sk
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
References: <20200915182959.241101-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5c3d74e4-a743-38c5-64ed-1cb8a6ed2a6c@fb.com>
Date:   Tue, 15 Sep 2020 11:58:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200915182959.241101-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0049.namprd12.prod.outlook.com
 (2603:10b6:300:103::11) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1005] (2620:10d:c090:400::5:15d8) by MWHPR12CA0049.namprd12.prod.outlook.com (2603:10b6:300:103::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 18:58:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:15d8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d9dee15-ed9e-454a-9fc2-08d859a9461c
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB40877831D447784E49A0624FD3200@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kSe4+a0BEj92mx3nQneHn6pMLNHwCMb64gnAlcQ9g+ZS5HQjQSEUBeevA97Eok3qk9JmRzJdNiat1FqYUBwfvqU6ElcoxQDTE6ziqieEXmquZYCkssCwyFOm1KEersbfYZLZckCn0LWXNLKGpxXOVhlSptfvXa5dSdbeSnIQAPZuTKUo/1anSVDJziV1Gg/Cqrto8CVLFGbfMiaGm2end+KmJE2xqdGvZDaYuv+QjU0AZepRuJ0/cm5VdHULy1j7HENyzNb2zNURH5Rj3FsSTj2SLwQsqVbPWhs370p4xm31BHdBQA8RIeAOC/O7thHdXFjb8htrzORLJV4bDb2wm31cNFX4iGrdYdMVdk2WWVy22ncw5nJU+0ZI8Wl892k+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(2906002)(54906003)(16526019)(83380400001)(8936002)(186003)(36756003)(31686004)(4744005)(2616005)(52116002)(8676002)(5660300002)(478600001)(6486002)(316002)(4326008)(66556008)(66476007)(66946007)(31696002)(86362001)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IcWvPSeD2h1wZDO/4oI/IfFdX1BKDrJl1wVzFKukboS9vwD43wCK4VF4zuu876Zm9D0SnQjpsyDrM6oUE2QK268T53SxBUL0I2gZxnEGDSXZt8U7qMuwwtYQTzF9TeBVCpEy6sH+DstcDbiVYC9p0TXswRS1oGFm7Cl2QYteZKd5LOsfZTSolQGXITUAdlnCNlWm9DBvOK643z/sn0HJSlHKtKA+WQ1X6hkKwhD/H0mch381vogBKeiaAJAkbCUzllU+doPEf7LdzeP56o+byFS6Pj3XiRbKGjuWCUbDd1HhXBu3mOhWL2dNNE3FtWj9m1VadRXZH0lKV7NMa9q3Z+PeaMZZ8enCaHB4iQCMtKP369kdRAmBuj5opCRr5H+sz7SCqbNXjZiFrbB+PG1JlXmpTAeIBBOP09U75oVhYIb18Hqv9fqWtBa8oVQM04FtGQNrO4boQRr+r/z+zx/W95r509Te6N7XcNm0/m02hHCCDM0IbvMuLWALGLydAHHCfJOFL0jelRIMJL3RnQ0XrTPWyzO6taqxgFWi6wD5sATS7f7YR2Igx7kVOLMBuhsyofSHQeESS5cKHjBHVfjgUUN74El0/V0CwTczm2k0FL4OrIb8FAoBO/tzULPPw2i4yYKv8ELid3OVK5KeEQLYmLb2uNfIk5t2h+y59TK/FMcqJbmrsOOMV5R20T1a9HZ/
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9dee15-ed9e-454a-9fc2-08d859a9461c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 18:58:03.4460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yiVegynFiJVQTczxXKkY0XCI2bOf4/mXkNE2AVxLhAy/xmoKrj92c/mLzTmoRAbg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_13:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 mlxlogscore=920 lowpriorityscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/20 11:29 AM, Martin KaFai Lau wrote:
> The bpf_skc_to_* type casting helpers are available to
> BPF_PROG_TYPE_TRACING.  The traced PTR_TO_BTF_ID may be NULL.
> For example, the skb->sk may be NULL.  Thus, these casting helpers
> need to check "!sk" also and this patch fixes them.
> 
> Fixes: 0d4fad3e57df ("bpf: Add bpf_skc_to_udp6_sock() helper")
> Fixes: 478cfbdf5f13 ("bpf: Add bpf_skc_to_{tcp, tcp_timewait, tcp_request}_sock() helpers")
> Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Thanks for the fix!

Acked-by: Yonghong Song <yhs@fb.com>
