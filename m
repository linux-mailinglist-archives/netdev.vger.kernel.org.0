Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758914C9E39
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiCBHJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiCBHJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:09:46 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24BE45512;
        Tue,  1 Mar 2022 23:09:00 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2224cw7l010815;
        Tue, 1 Mar 2022 23:08:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JvhH2llqp30IE9zgWaPmmFbzsZSPhBe3uVrdzefMreo=;
 b=Knpc7+Ut5ammNDWpk2/sftmBhPt3sDbFtxqKbvIbcYRidn4R+/SBIn8t4XTYBq9lCGsE
 pAgLO1iVU5+MfPsLg+38ZZFNKraEC991Wry4ACRUu5r55ClL9N7Y5SqNpzmRF4k1v8ov
 27Ar1+8WQLZivrmxJtfZVp4PiHSkqyGzrWg= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ej1r0ggh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 23:08:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCrGEyFXqbzNjxk2/fqqT0xdeh3vrLi4DoFyYzdeGs6oXXwgJlUzTMN/QFrRi33G8Zr1uYszrQfbAfWatPJYMaFTZiAbl9wUuX263r107bRj8xhClbFoTFEBOn1cGA12uye5RNde2/NZy+bisjZIuG6uFDamGV0rZH8d1JHaulTaKeW1xZ7QRMa5kjpJX7W+HjluRngGUB/cbkjh2nelLPoexmCw5CgeDisngRK6+hHqBng2nVvwDZ4CWbtof5NDD8EofxdFUa8tdRZjejjjvw1Iq7mSP/6hk/s95wgg86glsEX28iyAOhUziSxiVJtrz2D/GcLSIQSs7gGzcU+o+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JvhH2llqp30IE9zgWaPmmFbzsZSPhBe3uVrdzefMreo=;
 b=oNQeoe/02iG/tSmSg4XMPSVrRKobrtYRNmfwXhs1UtbmABpg67UyxMMW+R1IPSfksBWpCHTnZ02pc08CPoSGdQt1wYKAJ0lz4qJj66E6g31EMo0ghtSC9TJAq/FD1kO6RwuE0wkF00jCQldDot/ZDSvQXlyj4ZLQSlqzPqUw8EgFVHOYNKfeUJXDySJ1Z3W677oc0yBaYozp39XZ9o6yKeZ9rz7HeQcdAOhkThSLs/PYEPbQEBCZinIZEfhWoKq2b4jRVY7s1Pe0irgoKpgSvwPmTWQnnlsXX4sdh6XJf3f47SfJ0RBZgfpgFdHNVfxKkS8AsEc27jeGY65Ti6yR0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3451.namprd15.prod.outlook.com (2603:10b6:5:162::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 07:08:41 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 07:08:41 +0000
Message-ID: <a9a4e58c-44a1-8ca8-80a6-eec3c3980539@fb.com>
Date:   Tue, 1 Mar 2022 23:08:36 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next 1/2] x86: disable HAVE_ARCH_HUGE_VMALLOC on
 32-bit x86
Content-Language: en-US
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, kernel test robot <oliver.sang@intel.com>
References: <20220302004339.3932356-1-song@kernel.org>
 <20220302004339.3932356-2-song@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220302004339.3932356-2-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:303:b7::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2288e3df-7212-44c8-a565-08d9fc1b7b11
X-MS-TrafficTypeDiagnostic: DM6PR15MB3451:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB3451EB1C537D86906E413662D3039@DM6PR15MB3451.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQY8PjWg5fo+dUepNYpcA2Z7D4EkV4ET7aQXTKtMnjmOV4J2rCBHq0vmqoqBS0vXHihF8onE3o6pnEuHY1zuX54+cq+Rmb2QNjuhhJfXcUqSegYvYwiz4JkynN8TBOasuP/MG//zKnXXtRUqdzAyULp6v+k7RPdccEoeUkhPW4wi4OzLM++sVTiSkEGYV+xVxg7/2QaXJtWUeTLjODDnP8HYxZ7BTQ3U6PYsRPg0Ku76UYPfgB7CyMP2hl7JcMFLRLh4wuQ0sZ51XRaCjdiZjjTyUMR2sqagiq0sbcDWd9A0sBoEdTPAW8V7ReEqxNUU7dJAbCTDKIBgxsZIr0FAxVCA2mVGP1MCJ+dWzXh9JNdxn03BTVD5qOpGBviPF2oKtFya3TtG5kPa8XqfHKu2Nw5HuwWCIGQo2NG6s4BMEyaL+DNz5MvYTOhDYlOU//29VqNRP12k+2ZTOO+lJxruLyESF3dGXkOOOP91cfv3G89wF0cHA+KEcBhcB5xpwtDa4QNtVuRdWkckV4HVFajY9rqJsT/sbt5tqdplIu972IhPE/EdNOBDF1NKY43QcqiiwW4ubY2TrXeV67k9tzMZP0J+qb0xrEl+6ZTWVmo5+65SOtZfywakI2d158W/LIUrWtqtJQ9l55BruHHrWNUToAQvw6o+ccdRhsZgPZ8vtbson2EUyDn99KK/RBgvWjNayPNZlI90XYvethQNvHxdgIhNL8X5bUTl9/ICN5YWKBLRB1LuXTVoERV8Ic+Cyszc8evmcVZd71V98uOAHlP9Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(6506007)(6512007)(6666004)(52116002)(53546011)(4744005)(8936002)(5660300002)(2906002)(6486002)(4326008)(66556008)(508600001)(66476007)(66946007)(8676002)(316002)(31696002)(86362001)(38100700002)(31686004)(36756003)(14583001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzY2QU8wc1M3NUhETlV4MWpqMTRWVkNDUlMwb2VwWExKNHZ5K2o5azFaTmRY?=
 =?utf-8?B?cWRxZkErY3BGWlFEVFV6K2ZrUytsaURNQVVjVkRDOVVrYjJXU1QxQmh5QXBh?=
 =?utf-8?B?d1RVcWthd2U2MWdsSTJSeGRUOFFaOWhqWXBFTlJIM1cxL2NTcG1iVnJEc050?=
 =?utf-8?B?TkZqd3JVMzNLSDlCc0pEY2hnMnFKQ1BxMStWbDJWeUxNbVZaRmlkRHVHKzhV?=
 =?utf-8?B?SmNRWVVacnUwY1duRTB3dlhsWi9jR293dWFxcVFqZktKWWdwSURnN20yQTRQ?=
 =?utf-8?B?WE11Uy9oZTA4VGRndEtIZ2xoQVBwN0kreUFSRlJWL09IMk5iaHF3b3NlRlV1?=
 =?utf-8?B?SFVXOW1UVGNCVUdkbCsreGUzUjJweEx5Qml6b1MxS0JZcFN1WTQwMVBadDZK?=
 =?utf-8?B?STl2K2dSODlEM1NYWk5hZmRVOVRWaWFQelZPN0tKU2FGVzlvVGErckNKcURu?=
 =?utf-8?B?WkVGdmx1Q0dkaUNpdTIwYU1WandFQWRGdW0vS3JjUTlKdUk0ck1lUUYzZEpP?=
 =?utf-8?B?WGY3NEJkMStndXpobkdkc3hBNGNzbG5rdHE2c1dHOWxjblkwd1JaSHRpOFYx?=
 =?utf-8?B?U0VIdWczb0JSL0x5Y2lxejFqbnJ4dVFaLzlMRG9hL2NxcytKYXJYN05nNGE5?=
 =?utf-8?B?UUhWL2MxcUhWWXdKbW4rOHJsaGdPT1VQaVU2VUgvekFpQXY3TDlZTk5nM0RR?=
 =?utf-8?B?S1hkVlM0T2EyWjJHY2oyRHArOUJMSEtqM2tic0U3Mm1wQU5jcjduSlk3cUlK?=
 =?utf-8?B?dWRiZnhYQUVJR0xka3hieG1VRVZ6RysrUlhXQzRPN1dUWVJQcVpsam9JZE95?=
 =?utf-8?B?VTlKVHhyVDBQTHFSUng3V1F3K0NjNWg0MWQwMzBPZk9NUDZiOEhWWWkyNVhp?=
 =?utf-8?B?MTVHa3k5ZVhqNEh6ZlY0d1Z1Uk9Db2JpWjdnaDhZQjFRNVdEWUNqMVVKSys3?=
 =?utf-8?B?TEpZZXovYThCUkY4OGphS2kzVHN0WjQ1T0l6cmhNMzg5YVZvemlnelozK09x?=
 =?utf-8?B?U242NWRqTGhNT2M1QW9SaGxCVFpTQm9JK0xwd01ObHA5ZE5RTWJ6MlFNc21w?=
 =?utf-8?B?WEVVdVY0SzJUakVTZXZ1SXBBR3M3ajdPRzZmTjNvMm9POTVuazBXOG15NHFn?=
 =?utf-8?B?SkNsTitnN09lVDZNQnErU0ZBcy9iMzF0RXIwdFFEbTEyS0YzMjVIKzZJRDFX?=
 =?utf-8?B?YlVGQUQzS0dmQ25LcUdzYzRSKzZYM1gzdjNpekdGdkc2dEdkS1grWFJZbnpP?=
 =?utf-8?B?ZUhJMDhla3NFMHIxOVZsdStsU1k2THI5NnpzbjdzcExTM01GVGM2bDd5Umtn?=
 =?utf-8?B?bzhodFp0eEVaMVByelFiRU03d3V4ZC9GYXQxZndqUU02ckdSK0h2R3NVNksw?=
 =?utf-8?B?dW04ajJTTXlNZTFad0EzMFBJTGpNU0xrVE56dVBNcGVBM3dGSzBYNjh0eUpv?=
 =?utf-8?B?c2NxQUtqRXJXSVhsaDRLbjdtdWVXdFJJSDZIdS8yVG5SN09XWFY3N25icTAw?=
 =?utf-8?B?dDRVSDlRYjFPd05Xa0FYZ3FkaGcvaWF3SjdBS3Q4OWxQL3BSZ1pNbTJ2bHN0?=
 =?utf-8?B?OTZQcXZ6bXhRVUZ1bFhNYVpzSkVBbFJKSjFpK0F0RzhqTTBxY1NVL05adExq?=
 =?utf-8?B?RnVCVk9BamJuNWpaRm5ndE9tcWo2d1hiZGdqOFRWaGE4dWh5UUJQS1p6dmRE?=
 =?utf-8?B?QXpNS3ZVSUFaVk9GSWdUM0xXRUpyOXFlZGhldnlyMHE5RXRqa253ZFAxcGIr?=
 =?utf-8?B?NXhYYlNGWXI3eWFQL2RabFNkOHZIZ2UwZ0dsazltdjN0QkZkYTkyczRTZXNT?=
 =?utf-8?B?b3RLejYyUG4xUTZOZHVqUFZrVGVZbGFkNFlaeDFacWV6aCthRFNoRi9tR2do?=
 =?utf-8?B?UkRBWnZ2ckJUMnlEYkVkUEJQZTVCSkhYMzNSem1YNXM2NTFHTXh3alVQRlRt?=
 =?utf-8?B?QXh4K1BXbTBlV2ozdDRZT3M4NUNUQTd2ZTJnYldVZmxtZmYwYWJmdWNRV1du?=
 =?utf-8?B?aytEZVpnSUg0aWdhUFJ4RXltVTh0ZHUwVExxMWlaL1lRYUZSMVRTcFhqVXpr?=
 =?utf-8?B?V1I2T0tNUCtLSXBKbWcrRy9sL1RXUm9Ia2tBRkZkTTJPTlRjQ1kwU3lXS3Bn?=
 =?utf-8?B?bmF4UW5MQVpWTkFJdjIxU08rRFoxZUYxRHZnY29naTZpUUoxd2VSRThWUEdO?=
 =?utf-8?B?VWc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2288e3df-7212-44c8-a565-08d9fc1b7b11
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 07:08:41.0581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbPdn/wfR9ZizZ8LjjU+VTSOaDKv6ON1cNXcUgdyNmKyNFHPc3ySnPZDL7Pa2B3G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3451
X-Proofpoint-ORIG-GUID: BLmI471lJns-mrbx-ODOrDpR-e53UBKq
X-Proofpoint-GUID: BLmI471lJns-mrbx-ODOrDpR-e53UBKq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=548
 clxscore=1011 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020029
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/22 4:43 PM, Song Liu wrote:
> kernel test robot reported kernel BUG like:
> 
> [ 44.587744][ T1] kernel BUG at arch/x86/mm/physaddr.c:76!
> [ 44.590151][ T1] __vmalloc_area_node (mm/vmalloc.c:622 mm/vmalloc.c:2995)
> [ 44.590151][ T1] __vmalloc_node_range (mm/vmalloc.c:3108)
> [ 44.590151][ T1] __vmalloc_node (mm/vmalloc.c:3157)
> 
> which is triggered with HAVE_ARCH_HUGE_VMALLOC on 32-bit x86. Since BPF
> only uses HAVE_ARCH_HUGE_VMALLOC for x86_64, turn it off for 32-bit x86.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: fac54e2bfb5b ("x86/Kconfig: Select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP")
> Signed-off-by: Song Liu <song@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
