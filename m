Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6520FAFF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388739AbgF3RuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:50:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40354 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbgF3RuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 13:50:01 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UHmxUY006082;
        Tue, 30 Jun 2020 10:49:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=R+TKyG0PD8v+MBRwTVyBMIxa+fw7pq1xQM/xn0mtEws=;
 b=lcgNQ23I7zIoOZh1mNblhPqqUgHZSGdYoxiFU4jdi/oclQUo+gEtAWNDt0xx9EZXbuPb
 5htK58LwJt/MEcpWvARS5rHoFMEm9FZfJd8q1ZTcxLDIl79okAWbDdUwEk4UUsLIzsl5
 RAxlocKz2sBJV5nc1F/i5U7uUJRga1tKeN0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp39b8k7-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 10:49:37 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 10:49:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nwbn8BayK2ZfwL5Bte6QeIzpIGdyCyziJLeSvb47lVxoXFJMirnlrCnPJzvR565t3H3wRV5ullrcHLMaYn9oL8E63K/mFmHo7xkgUU7YHvIAEEsjf7JQb2sLC4yFME5Oq/rUkiI9EbhtX80LKK/0NuC1IKJtG3om++xN+eo9kLfDzvAjtCcDkHryXrw+F3vg73mlM9ByC5M15KsEsu3cnN02dh3Gsyfl9bWwtYhpRfG/OWnjwPPTKJdvQtwq60VAMu6qbDE6UqUDZ14QYCD1m/+0YyhjCMVdPvABbAmNKGSvjiDl7oTCUHbsyYm/q+Xd3AfSn2cmazK7h/N/GUZ5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+TKyG0PD8v+MBRwTVyBMIxa+fw7pq1xQM/xn0mtEws=;
 b=mEnIUjyjkHs80QlrCHIGJYDQrXK2g6C7XhIENvuDNssC8xH8CCnofNB5xYydxiUNvLVVCtK0TZ/2R/Ik34ErlnhXiO+LMN+cudry+xxekYOlyn353CboqIOk4+BUtEzDl89/gsnZxThJaWIYyccqvzanI19PCpYFpHNtFaM1lPgpPHilI3b6gVV279ft/EpNfZ+4f+2uFpofl37Y26lVAnFw6K6CXn8/roTN2ZZ1NVXTp7xZGyKEomZ+5jC15Se3D1oMEKXkFFT6X1+qeLPDbbRMmwUfZJI55uQeaTWIaT7jnaKaB5XUkWNDswvWlKmmKQPrlwFQ+Utf1y9WdYGwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+TKyG0PD8v+MBRwTVyBMIxa+fw7pq1xQM/xn0mtEws=;
 b=HJTyzgzyUuJBjbdftY6O2Hmkg5IG9lh0DJTgH3oEkGjCW16BRSo7v7vYNa25xZzkl519tQh8ZNZkO1eG7z8BPIbfgWHHxoO+hGKgJUoHjDARMN+0IXNCFkI+Yc/AHtrK9w2imLbRfWvkY7/5Ill6XtFEzSkxRJTvVxvzMSIYezY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Tue, 30 Jun
 2020 17:49:17 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 17:49:17 +0000
Subject: Re: [PATCH -next] bpf: fix net/core/filter build errors when INET is
 not enabled
To:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        David Miller <davem@davemloft.net>
References: <b1a858ec-7e04-56bc-248a-62cb9bbee726@infradead.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a4c90264-c77b-8cfe-d3ff-3526d6229da7@fb.com>
Date:   Tue, 30 Jun 2020 10:49:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <b1a858ec-7e04-56bc-248a-62cb9bbee726@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:217::8) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:c3b5) by BY3PR04CA0003.namprd04.prod.outlook.com (2603:10b6:a03:217::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Tue, 30 Jun 2020 17:49:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:c3b5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c9f35f3-d0d5-4625-4d73-08d81d1de90d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2695AA1E31A8C66857A584F4D36F0@BYAPR15MB2695.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AdEMb5MnZzOU9HpGbPCp6HreYTKSahOpKFgXZ//XsvELHKW0o2wojoYU+t84eD+hDyrqoHJNBXB77jew7bS1yTh+REZ1LYRqP2Fuv9kLZ+Z14+89AwXlVTT0Xw9Ig+hUXpHceZ9N3j+Q6xNIQpH9IzO34eabLNfjLTSatukUEFVPKHztDKNEAvkNfUxDoWycxtoDQgk/t7DhSECjAjBjf2iLLS9YxGmQl6QBbu7jPP8KLpS2AmrvaVHfepz0GW21r/M7lg8bvfdef0eyh9XStrvccOGpw8+aLc+VyXK3J88wvpDH54JPV0AlYFpFzAZaWTQG2nAw72eextXM10VQZQG4fH6CS/IX9lewcZOewheYZE0seNXQH1UVmz4iShgo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(478600001)(316002)(8936002)(4744005)(4326008)(110136005)(8676002)(54906003)(5660300002)(66946007)(66556008)(66476007)(2906002)(6486002)(52116002)(16526019)(186003)(53546011)(31686004)(2616005)(31696002)(6666004)(86362001)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: e6fYxAqkjgLq6QI4exSAV2u99ZjTAC4s6tHwA91Yv1NFReQZbKFgahgycNKzi2/WA58Ne6pU92t7TdAeTg8O/qpPr/3V8kV4fVambdkb2aKrv2MJgqQNTGncKQPt+hhC85pi9Xdzm+vinubytlOgbF/zodXRJRkRuEvh2c4z8wfrPlnQois51rKvg88Q+kjUlKRAMlFS4ybaPSUF6VRV/UIpOIbCjRjCYXXaOxdoiHIKjR0xLlBLw6qRQ3Nb/qLkedQmm6lwy5v9WgDhU6X2JjoDd82QYJIdrfC3nCGBtCelXgk1/1JaiT6gt6G8u3Rh4M4rcJdZAnvU4g1HBk8YBbFLlyWLzssq/ZX5neqhj1UEwV5qDdB2Cj3+k+d0rWWdZau8nHk0VNlb+E+I4ZbeNvEXjfEzhxffIXamor5M51IojeKJtaaBnnZjrhCmKglf7k8oZ1YgaflATSI+drESMbTLduXwXLBVppzSFL2BDD5RObss+KLsBQJ48jDeryL9f3xRsTTfJ/kB/DD3Dl6KSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9f35f3-d0d5-4625-4d73-08d81d1de90d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 17:49:17.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDNF/RHPb1+1J5Ji8+3wukpGbPr0DcSjcBgTVyMh/UReZEXKXfXpEgK4okZIfNmQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 phishscore=0 cotscore=-2147483648 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/20 10:29 AM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors when CONFIG_INET is not set/enabled.
> 
> (.text+0x2b1b): undefined reference to `tcp_prot'
> (.text+0x2b3b): undefined reference to `tcp_prot'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@chromium.org>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org

Thanks for the fix!

Acked-by: Yonghong Song <yhs@fb.com>
