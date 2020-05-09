Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3541CC401
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 21:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgEITRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 15:17:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbgEITRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 15:17:03 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049JDtKO003631;
        Sat, 9 May 2020 12:16:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0Wt9r2vb3Pid6PaIxRXF6CLOmKX7Qs8NEXMFh55Qsnw=;
 b=o26Hg63mul31h0iUh03Lf9ch91acy2XFHKSWspqLRXj0mvGmQqIiH4MxwaB1ZpBw6C2e
 +pdBS5BE/emyRri9ccWv+/lmW2USPXwU6xWMSPWhf7x/t4PipREUlE6SiCNBwB+59D66
 hHh2Xbr+CYgZG6rHLPUsEuJgPQGDkysL2k4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30wtbfsjq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 12:16:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 12:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPGJ5zgTUtkcG3wKVuZbK5POoEb0X0jkzVBc8cwjr7XGV/kITv8pHaBI30dXNFRm0AYNy18RMY/8YbF7ChkCgnTIcsPjR0AeHPrhEJB49UgtbfxZ0uu+sLzk5FCiuGoBSph/iTsyMhaumQ3SQlskFRwwyKPcEGuEICCxVHjYId1X8TmaiS+XwVFR7xuaQ7MVQ4n6JnsWWtvqRomUyk+9R36fdVKDwL80n/18m4tAFTwEiBXC1GTsdkp+Aa0A8I/ydGqSZg15l+BbTXy7IM2DBWpM9ZmEiFR4LE4kHAUsZuzaE6h4VIziyOAHHfNJShZvp93fa6jG1nQ0764NlcJxpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wt9r2vb3Pid6PaIxRXF6CLOmKX7Qs8NEXMFh55Qsnw=;
 b=JfhkFHMs9RM0Mcs2xDN7f7u1Jc9VX1fKeY+hn6Yx/r+sRbVzZtjNxfNeO6dL9PZ8XRqL8nrFZipWBhFYd3VVGl32q6CH40Dsk0muamkNwCHZ82Ie2rfzEYztcbtjZXHn4rNIPq+sCpCf8+C9XPsyGl0RFOMH5c4pkCTSf2mmRqGJfwDqb85472ziPw7nGFT7U5kYmP9pGVwTGEztCwfQ7Rnn4yI5gSLpiCI1161PG1y9Y5H9f0+FwL3/vhFa95lbuh8hpwrrJqkcpkV6VMyswffDUs+NO4QWezjCdKCCApLb1GHibtYEzDCS5pDUR4JS6YDkyuJedz67lAxoXFGIdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wt9r2vb3Pid6PaIxRXF6CLOmKX7Qs8NEXMFh55Qsnw=;
 b=dVEsRVIdhcHLUWCBL2TStoGFWzhA19jXMvOEA3HOU4v0nVwO+q1WUNPSpxKQhtjlkxug94U/0tegWbXXNfA3r+Rz9de94KgpMQZRVqRHybPTCo+kVePNH6Dal5wLizs4+RLNfb+kOB2gtXJ58hIcPiQjUINY+pgHKpRmJMX2WwE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Sat, 9 May
 2020 19:16:44 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 19:16:44 +0000
Subject: Re: [PATCH] libbpf: Replace zero-length array with flexible-array
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200507185057.GA13981@embeddedor>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0ba4c222-b1e6-c003-56f1-6f43405066f0@fb.com>
Date:   Sat, 9 May 2020 12:16:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200507185057.GA13981@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0012.namprd21.prod.outlook.com
 (2603:10b6:a03:114::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:3134) by BYAPR21CA0012.namprd21.prod.outlook.com (2603:10b6:a03:114::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Sat, 9 May 2020 19:16:43 +0000
X-Originating-IP: [2620:10d:c090:400::5:3134]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb30b58-b4dc-4f6c-9707-08d7f44d82c8
X-MS-TrafficTypeDiagnostic: BYAPR15MB4088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB408894A7ABCFF650D44E9831D3A30@BYAPR15MB4088.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uT9k4J2Qa/YTzyMSzwhhq4BZl2a89qEUJpUuQo6RVP99qcqew47PmRwH7dHgso+rr7Rvq8huiWvV2OwWDvNNQ6uALW1URydh/XW5vmRQ4OyWaRTh7DM6xBEs7n+p7BpH4WLWtrUVRcZgGH3fxQCdc7P7gfwu3mJjg05fO2DCEM2eYg1/RvKqlTvQum1sSvu4WXG++wDi0m6WsXl2fqeQSMNlhYNngkKXovRplI5DmoYGOTVERMkcNakimQfKU/cYj+PwCGmR6mbtq8OjMZ5K8BCNPEW4rWrYwQmTx4tSGSSM93FnX88k7Kg0X8sgYalKE+XOpvawwPyvuunQucDa7Sq2A2Hg0B9K9Rl3IDBMHr/5jfwhvJZc2hoKSNxLheHyjy4ErUrqEJu9go1aEUkUSsR1oiDoJL3sgkr0qI04Al2I9tWxg1Cx9MR+DCaNAcrmr0B3Ak7JKX+aIjd2UB5HU+LcqbvtRH3XRowOoDogoPKj1IADQVz0slbA7oHEcxOk3F254e2qusVSfiaHQ44egtjEiY5Bc26pvgxQXevjJNkfbvaBCLypHaoVm8jxtjLAtIXT5JmuCK1geI6w5sTUUZzgFFjQbMxvYXHm38MOBpBeBKRmEM1XX5jYyem6Sfl2JX4oQE9V2J001A3cdFxBbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(136003)(366004)(376002)(39860400002)(33430700001)(478600001)(2906002)(6486002)(31686004)(966005)(6512007)(31696002)(66946007)(54906003)(6506007)(52116002)(66556008)(66476007)(36756003)(86362001)(2616005)(8936002)(316002)(5660300002)(33440700001)(53546011)(186003)(16526019)(8676002)(110136005)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a99622aa6kSXPo6zfTzqdNbgguZJx1iV/HQIiGTIFEwqIVNpLOPhpjMZEGXexp4lRGAWpoVtdiVtEzXPr0vd8dpn87ycaCALArImAwDL4ZK/eC+A3XhHvNcU1rE8s7RTnUxH5lPfXY6RAj7wEB2XFzFxwyjr0N97Wb8d5dNkbl7Q1obvORDxOePBueE0Nu8XSvqvYWBujtITQoRkCPFGIKJdRSJ5FXHcc2sq1RAFJ0mOp3KX01mhQkfwaerX26FcmLji4RNDoKxZQJsdk2yb2iA2jrdltuZzrQq37/1Hi+bSEzuiVOSqsISeMIYtlW4w93eTS+bbUFKrG3cuyOdPiqTgPo5yXctktBOiwpJ7XydufWJYpWUMO9zBFpI2a6R7ry6NW4Hn/N0UXmjnAoGnPaJvTX/6Tci70ND0aqHqSodVZgnDWel07zPCH8UGtfM9LlpW/xQj5NuDqcaRPvF9olOjT9JFjUAMvtTt08d/gvU3WTimv1RN/Mte4BIXD9wxPezNYOS1Fd246KRlC2jJeg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb30b58-b4dc-4f6c-9707-08d7f44d82c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 19:16:44.3335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2zx9pj6ewi6QIkKKkMyPEXtNCL0ULJ+57lx0wLdt9HmSwSJ2exomTXGIRSWhqiz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4088
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_07:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 adultscore=0
 mlxlogscore=997 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/20 11:50 AM, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>          int stuff;
>          struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> sizeof(flexible-array-member) triggers a warning because flexible array
> members have incomplete type[1]. There are some instances of code in
> which the sizeof operator is being incorrectly/erroneously applied to
> zero-length arrays and the result is zero. Such instances may be hiding
> some bugs. So, this work (flexible-array member conversions) will also
> help to get completely rid of those sorts of issues.
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

I think this is probably for bpf-next.

Acked-by: Yonghong Song <yhs@fb.com>
