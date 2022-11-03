Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF661852E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbiKCQrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiKCQrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:47:13 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F0E1AD8D;
        Thu,  3 Nov 2022 09:46:40 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3CAX6c010312;
        Thu, 3 Nov 2022 09:46:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=1yS1L3/liCEdLLENYhdELoAWCVOw2X1dSDjoWPUcDmU=;
 b=QNlzsiAk1e4pQRz8Fd6ZjrXBA2Vquy5276hWFgBbuPmt0wzJZZbXn1829ERJFQwGklVL
 m7BCcarU4gzlR+Au+VaSJE8gIMBmO3UQppoIHHLPrW47yYIX8W4uzVRWW+eganyk3BbQ
 0hVsa3B07VT+fLc8WsU0qRIzjsA6HYkLJxciKBc71T5XMGDezCr/kYm6/8TvhhlRDtd3
 qCwH3W5wcsUVkU9BNNzmvfZQLvGzqudkXsSVYUdR9QSQPBLUY3CS3CVPHr9KIFiy2CAU
 MQfUQVOK5hfdcQvmoEUhibIVWFdAyQbC+8xksa0q32joX/f0Wy+EQCwFeI0LGo2mKlMX tQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kmddh2d9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 09:46:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnz8WQPQHck7/PtE+H+FQwbRaKbzhrCgP0oyMkgS9ZnIUuiTqBGIOCBuoMm7jUoZrp+8MWEUv7YEa6Vk1KW0jviNcSbkkj0N4zdmOqGelC9BzGQAFMPamCXLqixd7K/eUmk9YQC0TARO1B4bmw6bytMu8HOm+KW1/50bmYXEqwQtilZGSoQ75u0vW++7hwzx4Nkm0RR2DWwWj4Vn+WKimq33plkhXFxifqTQCF8lx+A2gxS0heYwmHfeeZd3vH2RiDo0q93HbcxHdpxyXI0v55dII/cKrBkbuuGnFJgPfdc3xq3T2QQGydMC5UFfYbI2dlNwAAlt/OIyi2gdYRmoKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yS1L3/liCEdLLENYhdELoAWCVOw2X1dSDjoWPUcDmU=;
 b=RpwyXYCpacc1MBmo7Dq1otk28k0imEUhXR1xGJTgEqkKIDHg0kTCr3cFWOlI+MewmbDPP113HSB7xRA0cqcfWasoU36F4AOuZt6X6xhY6ewnDKtwezsBt6HGdUcqapF8bD6aPeiGdJO02q7XgJymrN3Pp929+DeP0lYFhKh7/iqW9DPlwM0lbNOOhtfu0/mdrletmFJMnRJZRV/Z+dtFpruUCetDX2r2z7ulli7yhG1Ig9DdTOTow2muJ0mGqr/d8GEhC6hnIbpCgRE2djPxefC4VIccICHsfu+DWmUqWlO/+geVV6TIH+OolHoCCH7XFKsopwADxn4ldItRr1+4Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from MW4PR15MB4490.namprd15.prod.outlook.com (2603:10b6:303:103::23)
 by DM5PR15MB1484.namprd15.prod.outlook.com (2603:10b6:3:cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 16:46:23 +0000
Received: from MW4PR15MB4490.namprd15.prod.outlook.com
 ([fe80::c42b:4da0:5bf4:177]) by MW4PR15MB4490.namprd15.prod.outlook.com
 ([fe80::c42b:4da0:5bf4:177%5]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 16:46:23 +0000
Message-ID: <8e7802a4-9854-aabc-bc4b-3aba21440f7f@meta.com>
Date:   Thu, 3 Nov 2022 09:46:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH bpf-next 10/10] selftests/bpf: support stat filtering in
 comparison mode in veristat
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kuba@kernel.org
Cc:     kernel-team@fb.com
References: <20221103055304.2904589-1-andrii@kernel.org>
 <20221103055304.2904589-11-andrii@kernel.org>
Content-Language: en-US
From:   Alexei Starovoitov <ast@meta.com>
In-Reply-To: <20221103055304.2904589-11-andrii@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0124.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::9) To MW4PR15MB4490.namprd15.prod.outlook.com
 (2603:10b6:303:103::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR15MB4490:EE_|DM5PR15MB1484:EE_
X-MS-Office365-Filtering-Correlation-Id: aa78e191-9934-467f-a6e2-08dabdbaf133
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s44HLjjas0WAATUEUZvDyG2k1yIoEeGBY+S2I3qW+XGF/2Lm3Dqog24mWno+jJC6kBZGKorVEzy3qM1bZtYZPmq1xLLMPrXXgJA4T0Cbz1lSkO5Uy7fG1l1TUxGDcLy7VrBdI2JnG3eydq4jtFpNOwfTDThFWEW2ofAT9FbEHywDZVcJMCvIVE/jjYbb3Fyh5qtxLVJNNCsncj9SRs4arSHmA/el60AqSmYExbPacfmgH8JgvHRH4r2AqomZIt7DKPMKm72b5etdPsKPv4jEn7FZA7GsTjrb0Mg8Lov3rr2q07RdGgplLT8VEthlbX7wzs9D2IUviEEvfMSpiqUhovPTVGi+szgRYoM8r9UgRk5h7IfjphVeilt6OhRRc0A9lfAR5NqirzuCCbYofwJTUJZ2OP2OohUWQUxd8ZD3o0fgnIYV5lMEyyJfsOuxcpFAdwhho9ebUh6Zt2pkHetccpzGjkLZr445HxyLThE0sNppy9RmzPtPvbzIpfYTz5f4PXTgVJcU2kpWXWC5Dh6WZ4KYTyfRs10aRdq3VOswuQllvYnifDIXqiZt4nxsLFO+wZaf51Ft5MW6E5W0rE3mp+fZSkupbkMts8J9WpGZV65TPZBSLRDrIXczgeo+BQO8exQcwvTkRl273NNKDCxi3460bcpZoI3QyBWwFtsRu93YxBJcnD2OjfE8TC4Jtk4DBLitqGKjJy2kfu4TPW4k2Bj27tG1YFNFU1ie73pU01J+VD5eqhH2LTus3LVW7RBkEXBxiO1CuGQIW1CurYrq3JpGuFEDJ0Ip/YhqJnbvNJk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4490.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(36756003)(478600001)(6666004)(6486002)(4326008)(2906002)(4744005)(66556008)(66476007)(66946007)(5660300002)(86362001)(8936002)(31696002)(41300700001)(38100700002)(316002)(8676002)(83380400001)(186003)(31686004)(2616005)(6506007)(6512007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmZIQ3hEV0pxYzBEWGEvUTNtQXdlYk9tZmRQaTQ4Ly9Wc3VIbjZwQ0ptUVV4?=
 =?utf-8?B?MjgrUWFlMVBkMUxTUkpxWGRzMVQ5R0tIV1pxYkdoODc4MjBXVGI1OWhITkZu?=
 =?utf-8?B?eHZiN1FPQXp3bVFSa0lwZlBxR08zNXVXaW02VXJqcG51NVZEY1RyY0p1cmQz?=
 =?utf-8?B?Z3pPQ0FLUVY0Z3pWYS9Nclp2TEQ4K1VSMUFabEZkSEg5WDlERjdvNUlnekJh?=
 =?utf-8?B?NThkOWJmTFU4ZUpYU2drRnF3b0VpSkhwS1FpYTJHaXp0NkJCY2VmNEpWTkFt?=
 =?utf-8?B?VU1aYmo1TmpWdzFhREdEVTdmUnRIRkoxU1p5dXlrSzh0dnJRazZRY05RZVAw?=
 =?utf-8?B?WUhwaERXczlwaGJCQ0p3ZUZ0VG1wOXA2aVUybDNzM3RyaVNzMXQxZVVDSHFL?=
 =?utf-8?B?RHZuNC80V2VSUENuYS9PcnhSOTkwRmZlV2Qyc3V4RnljY1Nka3pFVmJwYkNu?=
 =?utf-8?B?VnROdGZycjFwRXJVK21yckh0NlFFcVgzZW5kZkJVRmxDOTgzRkJzVExyKzVr?=
 =?utf-8?B?RDk1Z1EwajZIajlVNjlSczF5Q3dSb3RkYTdXSmZvVmtsRS8yR3RQMnVMSEJY?=
 =?utf-8?B?RWhPOG1jZmFiSWZCNWpINEUzaERGckI2bXlYYTV3b0IwRmNXSVFDdmRRWmlO?=
 =?utf-8?B?ZVAwNVdHM0VsUmh6U0tla2ZHbXFjRHRJY3RTOFBkc0xrTk9UdUc5YmhzRlNZ?=
 =?utf-8?B?Q0Y2R0FCNmVPcm8zclBxYWR6Qm1VREN1ZDhJY2Z0Ukxkdjk5SFZjcVlVM0dj?=
 =?utf-8?B?M0NTbDJOUExBRXJWZGxzaHNLYStqTjNoWEFQM2RRY2FDZGpCZENiZkF4WWVN?=
 =?utf-8?B?TUFBbUYzcHNHWkg3TEJtVXU0V3ZaUUJndE0zSnFvUXpqMVpsTEdPVGs1TWJW?=
 =?utf-8?B?L0Q1MkJTTlUwWWswQTgvZk5Ja1JzQktENjliZmNLZkE5ZHpQcXc5VHdHT0hN?=
 =?utf-8?B?K2V4dGdKM05LU2pUSTlrV3k2UkRWVVJrWm5ZNWNWSVVzY2ZNbWZ2QXhrYlNr?=
 =?utf-8?B?QlZaeEhaY2pVMktON0RxcWppV0ViU2NocENsV2QyMXJXV3BoUFRKclplQnFm?=
 =?utf-8?B?V1N3aml6NDZ2ckdYVW9EV1psb0JzdWNoSDlGNU1INkVlNWhydE5KWXNTUFZM?=
 =?utf-8?B?ckR1UUxQait1MGEzcEF6SGl2QVBiVmYrdmhoY2tyVlBiUFE1MVlUMUlDZG12?=
 =?utf-8?B?M3VvWDFhcDZ1NGtRQ2t0cTc4MU1oblFwcVcvMTBFeG4zUWdTWWZWekZvZDdJ?=
 =?utf-8?B?ZlBvclkwVzQ5V0lIcC9NY0REQi9pM2pKdW9mUDVUL3dGYmpMZ1lZcERZSUVF?=
 =?utf-8?B?bE0xU3JXOTlCMUsvaHRaOXg0bHRHWUJ0Z0Z3ajhLNHVOa0hxUUR0Mlk5U0Nr?=
 =?utf-8?B?Nmc0eGVOMVluR3l4c3lmQ3B3bE5BY2MyY2lXelFCcnVraWlESGxHbnFhZ0h3?=
 =?utf-8?B?ZVJIc0w2bHltanlyN1BLY255SzF4bkgzSWsrUlpObWhpY25lMzJYNUxBLzJN?=
 =?utf-8?B?aTh4c0NEV1ZVS0ZQalJWZGNBcnphS3orWUcwQWJjaGxvblcwRUQvSzFza3NN?=
 =?utf-8?B?OVhXYWZ6UVVBeVlvN2EvTjR5Z000cm9xbTVoVUZRNjlmSUJxYTBWZTUrRjgw?=
 =?utf-8?B?MGxlNEFvS1Fra1Z0ZjRTNVNpcUpNUFFQV3FLQnArZ3J0eFNtV3p6VGxjdGsv?=
 =?utf-8?B?a2x5U3RzYUhJWXpRU0ZGaFp0cWFZQ3lFV2pMRDNzVVlwYWoxeXpZTmM1NFJJ?=
 =?utf-8?B?aWpOZDVlRlgvY0RIbXl0dkpXUzltKzBET3JUSTFLb0YreDN6VVVKczh4M1JZ?=
 =?utf-8?B?c3Mvc05hV29Eb3hDVnJMMkJ3bDVFUFlWT0x2S1EvZ2QvUDdMV1FGNk9Ybnly?=
 =?utf-8?B?Q3IydjRIUWxhNUxvWVUyWUlteHZnQmovT083eUR2ckJuVk1FV0liZ2FQOXJK?=
 =?utf-8?B?RUJWZ1o5R0F2WEpOQXdKZHNQT0JGRmxtSmtNVTZYYkMvYVhqaG8yeEFoempl?=
 =?utf-8?B?aG1uNm0rR1lnRjVvbWoyeG4zc0Y1VHErZGxmSTBodWVrZ1o1a0ZBQXluS1NX?=
 =?utf-8?B?Q0IydnVMWFFOejJsaThBOW5hRUZxT3RIekd0enJac2Rka1MzT29sa0JLTDVm?=
 =?utf-8?B?NE5DdTFNSWNFU3BXY3JQQThPbGZpcVlrU3liQ2toVmxrL1N6WmdoaVNJTXJ4?=
 =?utf-8?B?N2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa78e191-9934-467f-a6e2-08dabdbaf133
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4490.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 16:46:23.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMU6quXwGQL7g+9XK4kixsQV8dZtfRPCPNT/IEi4N4g+REGyx4r7quqXX5z61Kc0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1484
X-Proofpoint-ORIG-GUID: 6rNBkznU14ZKj8GQB5p2gbDo5xnKdogo
X-Proofpoint-GUID: 6rNBkznU14ZKj8GQB5p2gbDo5xnKdogo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 10:53 PM, Andrii Nakryiko wrote:
> Finally add support for filtering stats values, similar to
> non-comparison mode filtering. For comparison mode 4 variants of stats
> are important for filtering, as they allow to filter either A or B side,
> but even more importantly they allow to filter based on value
> difference, and for verdict stat value difference is MATCH/MISMATCH
> classification. So with these changes it's finally possible to easily
> check if there were any mismatches between failure/success outcomes on
> two separate data sets. Like in an example below:
> 
>    $ ./veristat -e file,prog,verdict,insns -C ~/baseline-results.csv ~/shortest-results.csv -f verdict_diff=mismatch

All these improvements to veristat look great.
What is the way to do negative filter ?
In other words what is the way to avoid using " | grep -v '+0' " ?

