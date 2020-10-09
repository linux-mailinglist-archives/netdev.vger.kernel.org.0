Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC50288C35
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbgJIPHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:07:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388736AbgJIPHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:07:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099F3W4m024541;
        Fri, 9 Oct 2020 08:07:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=n7HKaTzXDq1oyx1MMX+wkCgJh0AjOmtIAFHdpA5T/dQ=;
 b=JqXRJku3EUiKtsDXYhnLvXwZLkZ7PcgC4zSKZ41bzGnyYI7i8PL4y1EkS6Iw7q+2aDIO
 ENfoJCwRrLYhBGCwe+6Gkwfi6dZbJjUyx4cRwbHafkzcOoE5r9sVx/CVsO0Kc/uyZexV
 t/TZei+6145yYMczPshjH2edbyaIBqoQyCQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3429jrc6p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 09 Oct 2020 08:07:10 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 08:07:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG1W6K9jLEaDscGI0owWBak4j6FKQyg2WfbM3Shk3itbwcer/ixAqwNm7eDJ2Ed+wYHOauV0xacTAbSu3AmSdGeXpP7WRY0pRTy5psKxQNm9pTusAFIuBSyGQGXxvIm8lcK3RCIcreiQUSiQ5gXTz93pqaPLWE4QY9J3eoK48zLpaJpY5/Zr3cbtZepC7FXptzVFiAjwqFoabxxyX8wVK/sGe285e4KaKmRPinJ7JU6wUW6srqGtGm0TpM6Rp7eKOmMGBgbJ0HETuKHiL5QksoCf7cTXZgNZxf6V3/vxMWembBOGOVFKLUdjKLv/KtpZ5s1OY8ooQIjQJe5+t1pAMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKe8bj2pZvZcEsG2j5MttcGmDuBZEBQhnzvsnNRegfc=;
 b=XdJOE5l2e5ct8/9Gmfuh1bMYnF48mTU2p6xOYeDuSBJLEMNxXRH7aN+rH7Io6qxVQAmhlukMHtyA93nb5lJCeyXH7smboWuLRjkT09tucHA6g218KwFgjjhFMtsa+fg4gC3osiUDV50XsEDFOVOrVjMmwrRo3uliel396RngE2a4K/oI9MuMbzxi9u3fkjgd2rhoyfqt5LJ4/HF/yG/c37cqmIW5i93QrTg4JUd8M2MhbT09hSAlBZeKU1LYrKGaFborDATER21R+qIl+QEfQgcfa3UW70R/LYCNfGPxcAtP8Renp80quXgcU10KszrKb+oYmP+u/eKL/5sZ3Tncjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKe8bj2pZvZcEsG2j5MttcGmDuBZEBQhnzvsnNRegfc=;
 b=FAEXWoEPUVaU3eB/qiEudRsweXs5G9U+dIG+vi7c4yLpk8qqdhfUtWj5ivPWKcMqBDVhV0U0iEs1RLzsMgNnJCoC3CX8So5Xw8lw20x/WNLESVYjBeycY1O0Ya9GG5IzIpH4MR+Zza0gImfjr/1ieaW8yXgZp7aiN0BeEwLA2kA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3619.namprd15.prod.outlook.com (2603:10b6:a03:1f9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.27; Fri, 9 Oct
 2020 15:06:54 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 15:06:54 +0000
Subject: Re: [PATCH bpf-next v2] bpf: add tcp_notsent_lowat bpf setsockopt
To:     "Nikita V. Shirokov" <tehnerd@tehnerd.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
References: <20201009070325.226855-1-tehnerd@tehnerd.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a75100e2-ceec-f7d8-0f3d-decbfee95d83@fb.com>
Date:   Fri, 9 Oct 2020 08:06:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201009070325.226855-1-tehnerd@tehnerd.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:544b]
X-ClientProxiedBy: MWHPR2001CA0011.namprd20.prod.outlook.com
 (2603:10b6:301:15::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1844] (2620:10d:c090:400::5:544b) by MWHPR2001CA0011.namprd20.prod.outlook.com (2603:10b6:301:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Fri, 9 Oct 2020 15:06:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 625a6193-a915-47d9-8f93-08d86c64f541
X-MS-TrafficTypeDiagnostic: BY5PR15MB3619:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36198327DC6097778E3F81FFD3080@BY5PR15MB3619.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPDFsg8tObVTi91o0KIn8oKsfqGMXAVaA+KSM9LtdVy9LwcYec03Ah/yrioMHWIOEN3rbayTK74N1Pisgr7yHYiP58umYMQFhk/GU7DSyYjNTX6yoYMGDRdnzzBS2yp8yFENvWI2aDe25C5E9OobfD5sUYt9tlZr4GfxRAUP4UODtAtHc1mg7bKg4CgrC5fWg9jtysog3K4k6/ULHDRTF5rrVDLFIjd9vrVBFb9DjPW1rYM9eIhEkM78GI7auORc/EKQ2OG0iLL1JjO6nkgQiErCQ92ASLplbqdDTmpJZ6y996AmOZC97Q1MEzOshMxcBtv3TlrcqvF3u85ZB4WcUeFaN0UAf29tuBJeczxHqGguXHsq44wGKSRTAMtH2X9H58UpHMlyQzXIYHWypYlvZusOFx8Xd3XZkZ2XuEkaAfHea4KSyniJLI6bXJSrAm/CK7F4wLTPsmFsOjnk6205Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(53546011)(36756003)(31696002)(5660300002)(52116002)(4744005)(83080400001)(8676002)(83380400001)(8936002)(31686004)(2906002)(66946007)(66556008)(478600001)(2616005)(4326008)(54906003)(86362001)(16526019)(316002)(186003)(66476007)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7pzGujh6JN90ApO1gRy1HjZAC7HzXs2c6vGL+tfDW8/0Y0ZztldzglBXK2ijGgSFX8JIyfmvsOZsAEnofX8ZBxI2QPsJvH0dnW7wR+7YDhMni0ItYa6xtKC+tkFPr8a+VGSoSUqwv50aNl+h3zU8ttPjrJL7CTkCgTSNRiVxVvKHtmaIGBD2+pcQNUgudgSVtKpYHLz3QqN6PAk5lZSJOYZlDw24DcI1VAl/VXEYd1TyXp5wcMdp63+Wh+buTPlWLkD9kAWvuDmM8Zwb54qq0FjLw7+OR1YiyBH8Ki+Zr6LAAHM3b9VzwEO+59nj+y1rz6lUXB5p/MKArIoOvuVQV1034p/gMvB8W7VRP9GpsQwlC2yM9cL2WINj66TPRuBLTJhOHhuiAVGbdDgYpw7Dpr62BvnY3p3wGjlYbdwzr/V6tXL4U0bUmHxDns1h8N7W42PYsPUF6ebOci/uY91jBXOHSdtpiR6oYRkJgr3caxvNKIKqHROiwxXLonVRpHnAVoTnso356rHEhsmh0+23g5yZNIkfMa+BaYrYU1s9gUsRVZMnJdaQXbjPB9zmyR2JsfY1pd87vOXUJ03n6KvmKPQTAVXEUxYfUJbySLXwXioPgxkKavGXktehikOuy5uXqRC6DGCfKK0ZqUvaIgNaXdyczf7UVjixK+vkRPjMa5o=
X-MS-Exchange-CrossTenant-Network-Message-Id: 625a6193-a915-47d9-8f93-08d86c64f541
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 15:06:54.1828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSvNfXteHxRQwthh/pJ7Lg0Pl0S5EIL+NBg8kanaasDfCGLFCaxXyBFFQIbMRAY5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3619
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=825 impostorscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010090112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/9/20 12:03 AM, Nikita V. Shirokov wrote:
> Adding support for TCP_NOTSENT_LOWAT sockoption
> (https://lwn.net/Articles/560082/ ) in tcpbpf
> 
> v1->v2:
> - addressing yhs@ comments. explicitly defining TCP_NOTSENT_LOWAT in
>    selftests if it is not defined in the system
> 
> Signed-off-by: Nikita V. Shirokov <tehnerd@tehnerd.com>

Acked-by: Yonghong Song <yhs@fb.com>
