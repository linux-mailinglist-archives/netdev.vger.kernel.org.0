Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719C639BBE5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhFDPcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:32:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhFDPcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 11:32:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 154FBOTx018228;
        Fri, 4 Jun 2021 08:30:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OeYFmX67/HzRX9fQJKlkRQh4zSfEYNMBr08z6DJZw8Q=;
 b=owl2P3sUM2NLDAzm3MN3/s+0nH5bTbEP5SZ9YlyknY74GgvKDoXzBgYwB3Pj1cA0N43i
 M2w1s6qum7Bkp6pCYClHC/azQ8roWYJz1wldHG51WGOG+fjjNAqAmOwmmWdPKFtbSDgw
 beROZSlg8h6DUzyvUiBZHPi65CQgUZQbTDA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38ynmw8fvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Jun 2021 08:30:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 08:30:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1XNzlkBu1pDjaK3xxtbHIE60mkp5kXMHfVlcxvhkGIHKh+9TEH87EDI0noLHoCtpAaa381i3q2Exp/5lSezoQ/tqDsUTnyDYeXrub9tIS+mOeRozyYf/kY4NilOJFKez4sz94lSJwUjIdxaFL5zIKJ1ky5B4dD7FDWpELOeL7SBsUbQlqGpO1sQAW9jNANopIiUSl8mZK6JnHsXvKL4iq+buHmVlMb7nf2EiQvexmb4+hDSgAliI88n/a9xJEMF+m4oa8a0ZSEo+Sa8GOsUvEINlTNHhJZ0iGJow25gKREYX0Sx6A1QMD0hzpF6nybr7icW2ijQYgW2b9d0YbYbhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeYFmX67/HzRX9fQJKlkRQh4zSfEYNMBr08z6DJZw8Q=;
 b=B/VGy2stJj2ZlsBguoN2IFQZeE1qpxMvt2WKdO25AJiDWTrO4SICiDawGEO75pnMI3yXUQYlG+9BL9PrPpk5ws1zwMdimg6QKmKC8DxolgI2Qe0g2Q/TO1WEprq+FUCz1U977bxAf8SRizoA3cul98lOeX/6mBj2BFAMoxZuMNwfkWTAnTEswDjjTkBNUpLnN6AxToljs3J3hN6dLzix1S7mgLP5dEX+Zhq5SvUzanvipRPwIxj64Ix+WTvxpLRZo8/d4kt3LkYH57SFyQ8ME5ljqKI7LY6IATetwDJE6zEwzNQDMBEMiyX2BMHDQ/omh8FwiScjeUp7UZK1r8RyGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4420.namprd15.prod.outlook.com (2603:10b6:806:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 15:30:00 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 15:30:00 +0000
Subject: Re: [PATCH bpf-next] libbpf: fix pr_warn type warnings on 32bit
To:     Michal Suchanek <msuchanek@suse.de>, <bpf@vger.kernel.org>
CC:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <CAEf4BzbgJPgVmdS32nnzd8mBj3L=mib7D8JyP09Gq4bGdYpTyg@mail.gmail.com>
 <20210604112448.32297-1-msuchanek@suse.de>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <64eeab78-f2c9-ed23-8cc6-a603edb71e2c@fb.com>
Date:   Fri, 4 Jun 2021 08:29:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210604112448.32297-1-msuchanek@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a57b]
X-ClientProxiedBy: BY5PR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::36) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a75] (2620:10d:c090:400::5:a57b) by BY5PR20CA0023.namprd20.prod.outlook.com (2603:10b6:a03:1f4::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Fri, 4 Jun 2021 15:29:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb42abd2-f4d1-4208-b6d2-08d9276d9d86
X-MS-TrafficTypeDiagnostic: SA1PR15MB4420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4420AE050828C6A9B87976B1D33B9@SA1PR15MB4420.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:800;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8dR5VrI0z2DmiMtFnBTyZ0I2LaaFbogb6gsC/gDdSdUU8PwhiNjMviWCsVkvZMWTVN5pksJ8qe6jn9GW570xeZLnm+CmuAfreS2QqDalH2qYKjim3AV3dHGriwppNGc49rOvPR2lyXu3OsZzatqby7e2oycecg3HJtojeGEFO2sSoNfrJWhfk3TFKDbnDbEjXDUIP5rDvt/c+FfrW4B6mgssK3EdGYO1pk49aZvFpeEDHTqd00xil+4375Dq5ssRTgADNa0xwB5EXnY5KIZ3yxqRltwcH3qUrd0N1dDJkITocVy6gj8xkgywYKFkN9IC85+kBIjHaije2MnN5Xgv4NG5bG5L5Tk7QOBWd61Co5uuToliRIMZUspB98PNjC/0yX+5H2RRrt1MM8fZpqjRPkGrimq0kZcjv+3/Vtz8AGMPDp29WLdlb2X4ck+j9tIDehY0TfEzITdqk3f1QLbGf/0JuCjID/DG6a9ZWN00V+UiN5GleKsssoUDIMM8nTcqR5rQlulYfOQv1R45hPNNqnrjvwjL1gt79ACckh6xaptpZ/OC0ik287e+ivAtsTz+wjPk1G2gJ5wQT6kVpJN2yAweTAfcj91PqwYGor4GHgh0xPPz92AvCuP+p4euK72wjjhd7F9e2okMkqgxM8hiF5fusQsFlk1pZ3PxgORjN7JPLz1GF5/PZmNhIK3mrmj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(7416002)(16526019)(52116002)(478600001)(83380400001)(4744005)(2906002)(5660300002)(36756003)(6486002)(31686004)(66476007)(66556008)(66946007)(4326008)(186003)(2616005)(53546011)(31696002)(8936002)(8676002)(316002)(86362001)(54906003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SFJxaEpOUTJwWGVyQXFoWHVkRmhTWW1YQzRHWWlJRysvYXVQeXV5Tjhld3pp?=
 =?utf-8?B?cXYyYmlYanEvL1Q0a1BEdTJoYnFmTktXTU9TYTFpTGV4RkFtb2lHSlBqT3dS?=
 =?utf-8?B?L04vbHYvR25jMUM5RnFjMHZqc0dMMG5Yb0xPOHpUdmVMeHh0U05BU2czcEtk?=
 =?utf-8?B?OVIzTFRuNVRBK3A4QUJPNk5CWDFyVGxreFdiL3pLeUE0Uk5hekwzUTB5RUN2?=
 =?utf-8?B?R1lMZGxMeXd5bFBqL2NDQytxSzhFY2xHWUNrT216Z2xQRHU2SDNTbXBaZXZp?=
 =?utf-8?B?WlorR3RjYUpzK3ZqRFBvdHJrd0RKVERyWnZ4V0FTUU5wWk9qNUdxdU5MdHZN?=
 =?utf-8?B?bWZuUmh6ZW1yMVhXNWFXSG1jTEpLZWdvWGtSaFljR3FpOXk5N0k4RUZhK0Ru?=
 =?utf-8?B?RXNmKzVVNGNROU81WTRTY3MrT1VYZHovUUNPZnk2d3ZPMlJ6bWJ6bnBVQklM?=
 =?utf-8?B?TGVLaEQ2NU13dTgzZldzTUt6Nmo2UTN0N0JMMVh2TnY3RG5tQ3FZaFcrdklV?=
 =?utf-8?B?bFpVQ1BWbGU0VEQ5MEFQcHhYekxpRVFjQ1l5NmRiNkEySDZmUDRNcnlxMnNr?=
 =?utf-8?B?emJGdzAwd2FkVTY3TlFxU0hmb2s5c01yeVdRVXJSRnNSMXMxM0w4MFE3SzB4?=
 =?utf-8?B?aUlNbkwxSzdQRGZlOUJpTjNTMzBpcHdmZG9VNThyNWdrckZLWHBab3dTcnNU?=
 =?utf-8?B?aG05RHEwbzdjSkV2WFNic1Flb05rWkk5T2grTzFDc3dXQjhzR0NzR2c3RTll?=
 =?utf-8?B?aVJtYlRjcEJsOGgzT24xcFBXZUZmUVRtM2VSVkhvK2JDenF1b3FPNGw1bXZu?=
 =?utf-8?B?dTFpV3FxWkRjUDRVVmo2N2M4MmQ2a2hjUDVUK3ZFUUlQdkE1YVVTcGVuQVFL?=
 =?utf-8?B?L2tCOXdOSTVGSnFDY2ZwZjIzQllYY3Q3RWVVVmlaWFZuSUhaZ1pkMEQ3S2NJ?=
 =?utf-8?B?d081MGFNblpOelNaOE55NzJ5V0pHV0M3enZjRGV0ZGVGaHpFZ24yRlpEcDVs?=
 =?utf-8?B?djBHUiswZXB6dUFEU1VMVk9wSmlIdlFGMENsUnJTektCTlFkRzZYNlBBb3Fh?=
 =?utf-8?B?c0RRWUdCOTFpKzFXcmlucjIwNzNiUUxoM01SR0hQTlpWOXhydktNSVpBVHZX?=
 =?utf-8?B?V0ZoNzd4TzdCUVRNRGlQQ2tHSzVyakx6NFF2UEFaSU1TMzJ1VWJYSGt1MjVw?=
 =?utf-8?B?QmhDbVFTWEVDbTdvTXNtZ0RoaXVTc1JXYVRxdjdZY3dvbWNUekVvNmJXM05h?=
 =?utf-8?B?RXJhYWlzbDVSSGRlTUc0OWxyTFR1c25hUkhnczczSU84ZEEwS1lMREJLR0My?=
 =?utf-8?B?YkJIakVGSU9aeG8xUVNqUDdMc1EzQVY5ZDRKdCtpUGFsM0RKSXlkaC91MUVM?=
 =?utf-8?B?SzEwL0JEZmpadGdkdDFCdjhYcERsZExHbXZWZCtBenQwUjBxNXcwN0g5bTNG?=
 =?utf-8?B?eFlRcWdtUm5oLzFtNTIwY0dseEF3Zk10QkxvOUpqK3ZkQjd1eWVOS014ZlMy?=
 =?utf-8?B?U0tkUlNwSU5yQmx2eE1ycHpHL1g2cTJHVktDZ0xNWUowR2dBRi9KaUN2T0FS?=
 =?utf-8?B?T2NhVlVCMjMvbDdjaDU0Z1dZTEozVFo5SThwalNwMFptcHVjZlQra3ZzaEhx?=
 =?utf-8?B?OFNZQmM2SElWa2NON2FTblBOSXZ4RWVoY2Njbkh0UU1vcUp3a3VGR2pmZVRW?=
 =?utf-8?B?TDJkNGcvYWhua0JnSjFhUG5LZjM5d1lhMGtMcWsrbG1hVkx2aXhiTFRaRWM5?=
 =?utf-8?B?MTBUcmtYZ3NFYzlmdUQ0cTl1YUh2THpnbWZLQnhiSEt4ZmpFNWE1blBPa3Ay?=
 =?utf-8?B?TmphL3docU1NR25Tb0p3QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb42abd2-f4d1-4208-b6d2-08d9276d9d86
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 15:29:59.9624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NJnMmTZbWkdv32jDaPBUQz0vC3ME/IG8b+WcQv+O/l5ZykEC7kOKE55U73Z3f+M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4420
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: CeOs4DJjGTGzxquKYP6irKfmy0di20bS
X-Proofpoint-ORIG-GUID: CeOs4DJjGTGzxquKYP6irKfmy0di20bS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-04_08:2021-06-04,2021-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 clxscore=1011 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/21 4:24 AM, Michal Suchanek wrote:
> The printed value is ptrdiff_t and is formatted wiht %ld. This works on
> 64bit but produces a warning on 32bit. Fix the format specifier to %td.
> 
> Fixes: 67234743736a ("libbpf: Generate loader program out of BPF ELF file.")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Acked-by: Yonghong Song <yhs@fb.com>
