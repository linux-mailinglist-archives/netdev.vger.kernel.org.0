Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686B464FB64
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 18:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiLQRtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 12:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiLQRtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 12:49:20 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BFE10FC0;
        Sat, 17 Dec 2022 09:49:19 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BHGKXLS015234;
        Sat, 17 Dec 2022 09:49:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=I/vsOCXqYq/Lpe+3q1TJPiaoR4VoeHU4It1r7PRJgN8=;
 b=IQBdUPABvvdlGLFCoPIrTExRcaOSBKdKYVnuC0PUU48dCmzTEBhTTDGhbuwlAmi7+PBQ
 5BjQ6biHzaFa/8w3Bs2iomq1irKSEJk9tcKSEgYXEtMUzFbyUKDtA1ilVxuN8NYG5iF1
 OeWYnAgOBntYRtX9W43buLtsKdT5azNLXYIhu4PaDEfXvBwnCixmgbYIOBLdVKW4VVv1
 /mgULzlJQW8cJzvUzgyv5z1adgNsq4ZtXsgyHnM8X9/Ma/nYEtnK7GEP2SQSZBqT19VE
 pf6TUUCO2tOULV+tdzKmsyUTmoXj/ft/0ufkYU5IfG1h+8jlSpUk37jxNwerS61Wb534 NA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mhcfyrx6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Dec 2022 09:49:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3+qVK9oahVrdWtmkkha6Ux6CecqaI+q+FaeS5eHiVTF3odenDWTuHruseHj+M57/tAxBzxpdftJCPKvtyiH/0tRZCdmByp3jGbE5e4s3kZdDCQa00hljEyFGLnl2e8zGBzeyWgyUSoEZ+fzPRCS7X5vRyifYBcRLF6mdpczUEGeFN/lKg1P1eK0fxsoGougZzRJ74e5m8ELXJZjI+EG8y5wQGFezf+3GtFV5LN+2Mpmu1dvcfHYjFjjfSMuCyr5xFAZKkzSbEdIB0Ko8UYXDgsK0SSvLDpvZe1dTJ5SUgo2L7hYxX2hty1Q1CqjMuHCYnRHnh5OAZXUIZEHWjzd3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/vsOCXqYq/Lpe+3q1TJPiaoR4VoeHU4It1r7PRJgN8=;
 b=bkXWiChN8WVArPvIwW9BdVaoptZ9kB2Re8AiNvBEg8C6sjc6DwU+WChRxp5OFbeYWzE0UL5b5mTYAvIra8QLx/JYfr0UZiu3BsmYKxCRGlxjzDNUCC1TyKlMSJdUDkih0uFoZXalQwTZdsq2CsFo8WLWo50Q9bUxtII0DWD4dVA0JgQGkrDWkgE0aBEnBn4APO4677sM4miZ2Q2UyjlcHE/xfhV+w5TDMLWdWurzzqf8kT+E/3nXMkp7ncdEHMdx+myXETLfi2gqz+jqx2lIj9rf5umG0re9lABwYKg6lYrzHghXRoMd/CiRSH8Pn6Lx3elzsd1nbnwck+TEYC1wtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4823.namprd15.prod.outlook.com (2603:10b6:806:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sat, 17 Dec
 2022 17:49:04 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5924.015; Sat, 17 Dec 2022
 17:49:04 +0000
Message-ID: <bb4655d2-e047-4018-0119-bc199de69b97@meta.com>
Date:   Sat, 17 Dec 2022 09:49:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [bpf-next 2/3] samples/bpf: replace meaningless counter with
 tracex4
Content-Language: en-US
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20221217153821.2285-1-danieltimlee@gmail.com>
 <20221217153821.2285-3-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221217153821.2285-3-danieltimlee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0208.namprd05.prod.outlook.com
 (2603:10b6:a03:330::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6ec1dd-1eeb-4dc9-e7e0-08dae056fd2c
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kBjAYcI1eAEf5pCHtMwon9+gGuapbCyAM1YquJ6cT+C9WrLv1k3S9r6xMMzP0Un6dubUO2brOQrmCS9XPtbEFD0tY6sMRt74Lz84YnYx6O53KFBJTLRbDeQzvfwMnFntGt0DJvDaXjSb92yN+WwZEnf+7KKhQ57f/ILqEv2zdiiWLWxsw2qocImRILQExWmBJdnSXBxAnmbAQBRYK5FidlT0rSyBsbo+M0gtyD0VYisnWAytbGCeWdlk5OySkboumTItRA/dZSxRXOZVzC0jv9HucxYLI58dIokJT3v0sLgf1GcXllpAMxkrs96ICimx1DLTMf+je22LEOFZK++CRxmYXv7cYqkkCxNK5/TKx8o7O5hSyhomQTUux9Nuy0tYa13z3Y2A0LJCLFCRPartGXOjijU2NvT0jRcqrEvgFfW0Mlse24C/s2ezQZxP60CJgtt9jwwBimRlBhraeABLHFY2USBPU5tYOdpu9stu1MBW6zK2K4bgPsry/dlWEcYsNyOwVHNZTZ3UclxplPgCfZRgOgyPcS9rUMSQ76STFEL9skf1luW1uNZZlG9sPWwzekE8KLYtpj6av8kzmky0qDd2x8mNZBjHokhLpzfqgTAe8yz47+9fa7YLP+hc6ydo1lmdI9J9TpWrWj3iRCZOhN7PpIkrAS2Tg6pYYS7joq+3CQVVI04+vOmRGJ+kQEZJmPIXw+POo6RKzVNee9s5sgWll9/bcn4E5Os81nBvAt0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(41300700001)(4326008)(8676002)(36756003)(38100700002)(5660300002)(8936002)(2906002)(4744005)(83380400001)(31686004)(53546011)(6506007)(478600001)(6486002)(316002)(110136005)(66476007)(66556008)(66946007)(2616005)(86362001)(31696002)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXJ0cE1kUCtmbmJWVVlmN0ovREZBRDVMc0FmRC9uQWhOSVZNQmpCMkNpNG5W?=
 =?utf-8?B?M1E3Q3dZZ000NmU3VDV5MTA1VUh4SnlxWkw4SDRQRjFpc0ZkRTBRVHFGNzNG?=
 =?utf-8?B?ZGlnN1J6V1orNzJ6bktWcURSNUpHTm40OUM0TlUrVUloWlFpN0xpVnAzNFh0?=
 =?utf-8?B?SUlIYmlKZmtzUW5ieFRHRHZJM3pOZUw0TUQ5YlRoeGRmeEJzRWNJdFBzL0dN?=
 =?utf-8?B?MHk0THI4QjNDUE0rTHh5Sk1wQnpESXJ0WkVtZmRFWmQ1dXA3MGo0UjhYcXNk?=
 =?utf-8?B?cUtHSWE3Y1RTZHErbjlMT3prU3BrSW9wZEdxODFsQ3cyQS9HRGFnb3R2UHQy?=
 =?utf-8?B?VVpUaGxvR3IrMU9HOEF4M3djbldXWnNzZ2pKSnFQR0VlT3Badng2Qi9KQVI2?=
 =?utf-8?B?aGtSZmZ2a2hmVjc0MnFma09xQTNnS0t6NHpsRGRKZm93UmVrdGc3K2hFbUVU?=
 =?utf-8?B?WkdCN09va1grMTBwU09GZWZ4MmJYOEVBVFc4UCtTdjZDYURodW1pU3NCamdk?=
 =?utf-8?B?U2JFYktFZ0thMElTeDJuNGh2UWNyNU0ySHZDVFh2MFFQQ1gzRUNyU2ZIL0xk?=
 =?utf-8?B?T09ibkcxc0RaeUpMOTFBd3RmWWJNdjV5TGg3ZVBJSVNGSkNybHhOaWpxWHIy?=
 =?utf-8?B?WkxtL2NhNXV4akJTNXhyMHc5UHhDdmlGMjN4ZGdvczhCUkNLaS90M1pRNjRN?=
 =?utf-8?B?SUFFYlpWSDQxcUtxcnBYeDNlU1lqN2RjeHNzMkhMTmFvYkF1UGhoVnhCdTc1?=
 =?utf-8?B?Wlh4eGhQMGNjR3Zpcy90QTJ2c0RwdlhFT3ZlTVV3VG1Wc0ZFSk9tbzJLb3FM?=
 =?utf-8?B?Si9aTWE4QkxsVlZpS3BIZXd3MzQwNkZtaGhKSE9YeTd5UHJSYXorOTlPSGpm?=
 =?utf-8?B?c3NXVHJtMldSOVdtTnFEQm9NR1VrMHVod2kyaVk0UEtZT3Z3bnBpU0x4R1RM?=
 =?utf-8?B?czdJYWRldjJpQ041QTBvWFJ6U2RZSWJWRlpoMXRYRUYwd1ZVVURUMnBuc3FS?=
 =?utf-8?B?YWdaTms3NTZBYzd2VUxESFNVWHdLWSt3dFlRRTZzNnVRaTAwWUlMaXFPcG5q?=
 =?utf-8?B?SjM0bG9vYW02cFJTaEExZDNMWnRGMXlIMTlzSkRSU3dTN1VMbDJPRTFoN1R1?=
 =?utf-8?B?dXR3Wm0raFczZ1EzclFrcGhsZmE1Y1JKNEVsdllNZUR1TFNyK205Q1BFQzF0?=
 =?utf-8?B?bEJrUDZnR1dtMHljODg2TkdraUF3cm9MVUVxNEZWbFRsN1ZXSU0xa1RhUE15?=
 =?utf-8?B?NnJWM1ZLYk9jQ3QzaWp0NXRscThHSFZkMURSenVtOGhWWXlSdVNmckVrRTIr?=
 =?utf-8?B?a0dqYmtEN2pnOFA4bzEyY2FxMzY0YnZnMFpyUzNoZlo1V0Q3YTZEcUx5TmZB?=
 =?utf-8?B?eHBDOThZNEw5WVgzM2lCZXN4cmlhVFFHREFxb3cwd2tnMEdJVlRndjJ1TGFt?=
 =?utf-8?B?b1lmV0hJL3Rmei9qS2d1dHlETE8vcmFCZE5pQmlSWG1TcWZCZmZYRjVaSG1w?=
 =?utf-8?B?ZXVmNVZkV3prdW5ZZ3kyMnVFbWlqcUxlK2tUWDNjek1SL2twYmJHNVFQd1pv?=
 =?utf-8?B?N1JmMVBjd1I1S2FjRExuWFdHLzdSUzgzaC9qTWZFc1NualRaZUh4dys4VkF0?=
 =?utf-8?B?NHI1U2hDWUIwOUFpMktFTVY1WGVrazI3RW9jZkxmeW1Zbk13cGV6bmNYd0pq?=
 =?utf-8?B?QmNnZDViZXlUY0RWc1I3dysvVGVIb1JoeS9uMm5Md2ZPdWo3aGhqTzExQ3F1?=
 =?utf-8?B?a3YvMUN3VzJXT2dYckxINS9yTlYvSjBicWI4NSt3a292emtUbHJsMk5xUTVv?=
 =?utf-8?B?K0x2U3dkSkduaFlDRFI4VGJxYjNtTE41VUVHbU9ENUh2VUNOeWJMNlcycUFy?=
 =?utf-8?B?MXVzVWNuakZVcTYyYS82L3Q5Wm1KRktPS0Q5MmkvMlhUL3QxNWd6eldHRjlK?=
 =?utf-8?B?Smx6NDVqejhITUpOSjB3UTROMU0rVmpTRXlEMVQyQzVlZExpcSt6RzdNN0Za?=
 =?utf-8?B?cXVBakNmZWdkZU1aYk9oZkZwLzJFVHI0YnNyUStsSmRXRHAybUhPVnQyVWZB?=
 =?utf-8?B?NGRlbVd3TFV5WGdEVThXb3VrWWVVQmVDNXRYM2cvS1VUVW8xcEg3aVExbVlp?=
 =?utf-8?B?ajlIVVVlNXZjcjM5cmlWc2lGblRFUU1MVU51VTVyRmZqWWdkYkxUOHFKL09p?=
 =?utf-8?B?WWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6ec1dd-1eeb-4dc9-e7e0-08dae056fd2c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 17:49:04.6671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AUXOtyfSOSTRgjwVh3sjaHhGA+mLhpCTk9ei6inGONksosEtZ7gbgdihXNp4WGC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4823
X-Proofpoint-GUID: jpVgjgMb7SvSwRa7quDeXJMJDM6mG9U0
X-Proofpoint-ORIG-GUID: jpVgjgMb7SvSwRa7quDeXJMJDM6mG9U0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-17_09,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/22 7:38 AM, Daniel T. Lee wrote:
> Currently, compiling samples/bpf with LLVM warns about the unused but
> set variable with tracex4_user.
> 
>      ./samples/bpf/tracex4_user.c:54:14:
>      warning: variable 'i' set but not used [-Wunused-but-set-variable]
>          int map_fd, i, j = 0;
>                      ^
>                      1 warning generated.
> 
> This commit resolve this compiler warning by replacing the meaningless
> counter.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
