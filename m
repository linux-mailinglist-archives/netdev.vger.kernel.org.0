Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0813F4ADDC6
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352035AbiBHP6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381766AbiBHP6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:58:05 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE64C061576;
        Tue,  8 Feb 2022 07:58:04 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 218E75Sm013818;
        Tue, 8 Feb 2022 07:57:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Tyx4oW8fOvIHCIhS0bQuy6hnH3L+XQZltU/DVfuGU5g=;
 b=eBiaGf/zZfa4CMKjMOqwa/cXpzT2r7RPtRh5i/SlP4KCn2/VQBMLcAWZruLyRswecdaJ
 Byhnz7onAwqJN3W0km4EZGCKjgYXD/Jfm3d6svYxhDzTxf48eF5S3h24/Mezk9wKI3Pa
 5lAF9VDQNNQRZxqDeNCzPFhY29cZzvkRZp4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e3puw1ux3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Feb 2022 07:57:38 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 07:57:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOlDqkmjEre2kTgWaXt/G5tzUzI2HZL8ucAonJZuUGBeFnUiHFwXD0YM5+b1sd93tjk7sx0fA+FfLl98GPaQmtPBdYNIbArqV8rPzkNGZZWsYmUI42kynEox4FjoTBC324Ksg2rGPOHKapSkzi60KTgCZsVea8z3gRFJJ9hsjl8XD+pYu0Vj3CDa670q3MpdHLRj0f2YoNOZu5zGN1/b7dVdZplWBPNvGAO29f74zrWRjAxFIb9GXe+GtgRo0MY+nXOQRmjKbD2Hmmzz40S3RwzhdrtJSNDI8HDEdVy5ODUnngL9M3nbklSx0kRTQzKbViZL8mCPOw+oZstVoGrZqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tyx4oW8fOvIHCIhS0bQuy6hnH3L+XQZltU/DVfuGU5g=;
 b=caoY43hee8BZJqVEFRSuR6bFDOEYE+TlYryQ3KlRGYBJ88A+ZjwKjvRcXk3bskjaWRLfgu88Uo3bb3Iv1W721oDcCRBLB3kYNOFbXcgZWxe/Wu37Qq1a2xdL5mPwWgXhExMNKJ0G7y9HAgNnXYwZeFISkm4ZPLvZZdfYBrMJCs6F37ypsaKwsigVPDphYGcyCl3mxdp36wldlLz2wsHzlm/ig83qbOxUJcXYOoczqkMIHfg2VTu22Ib5UZ0hSweW1uERpg2BM2QOhVVHz2M81RbRFgfjOZjGTjTukeAFMynxgYBJ2534wf4HmzBqlFWBJ9VuhCCN3/DFfJI4i+yJ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by SA0PR15MB3869.namprd15.prod.outlook.com (2603:10b6:806:8c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 8 Feb
 2022 15:57:35 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c5d8:3f44:f36d:1d4b]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c5d8:3f44:f36d:1d4b%6]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 15:57:35 +0000
Message-ID: <5f455130-f73e-bf2a-ed54-e81b75585a21@fb.com>
Date:   Tue, 8 Feb 2022 07:57:32 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v5] selftests/bpf: do not export subtest as
 standalone test
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220208065444.648778-1-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220208065444.648778-1-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR10CA0013.namprd10.prod.outlook.com (2603:10b6:301::23)
 To DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7538f566-5a07-4ffd-bc86-08d9eb1bb916
X-MS-TrafficTypeDiagnostic: SA0PR15MB3869:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB3869A3054EC544CBE09AAA34D32D9@SA0PR15MB3869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pXMSy4mjAdx9+0nz897DBFp6DkcRsj5shYeOapxeDHtoHrk5P0xmqkZxKKYRtv9g4odZ/S5+FG3TOIywtHfclVJb0bVzoGumu5KfTpOC1AgD+qrJKEFyiZgRd9JJU8oPmpPrnlFf/pAB4YqXgaBFR/S6tvGFG4Oz+aOUIbbDM9gXmrCOx5zqROQJiG/lQUNt/kkCq4CfVp46xNGtsxDAjZbOv/XIh8qV5Ui0NztBcZXEdu/LpXX8F6Fvnjte2lZ/4J8F8FBo79xjQdvZLqieFNEwij2JkJIaQJqrs89aotOx9BjWgU/jnux5P37bKkMax+WCY+gQmVDDJ+ZRxvkzYQvRMovwSLF9vvFuEwuf3cQA/FwiIJE7lSoSSPVXV9hgBV/AMB6fKANtjvdl5gjeGSr+6gG0v221dGXC2f0gJ2jUSEcBNnhLMVJfmTpegwVx6NTmO/+sfwVi+JYUQ0SydMmamHXIiiskxBemDRISt+ksBV45iVfOUGeXsCTHkZ55a497YnlFidAxp73hHxpupb7dmKxnYQABFJtNTZCSnlrR6kkHZulJr4sEztDJthRmic9rA6A8wctlwkPBMpvogKFdAhVW+XiMwI9+erBgo/9kOSwZ1tF++vYzDceXFF3YVHWec5Ztq9eOXPL9Ar3Q8VZP32fi9ItaPV52BS9NppwEzeEWjGFPxdQEKJI77OZgKTo/cNhlcnykLyfR7FlTjuOa4Lc5ksBlkybzWJqIx4k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(4744005)(4326008)(8676002)(66946007)(8936002)(31696002)(2616005)(186003)(66476007)(66556008)(53546011)(52116002)(38100700002)(36756003)(2906002)(5660300002)(508600001)(6486002)(110136005)(54906003)(316002)(6666004)(6512007)(6506007)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDBOVzFhb1ZWeVBmcGlpVGxmK1pnN01qclFSMEhGemFPRTNQM25rTlBFSFA1?=
 =?utf-8?B?QTZMQzF6azV6MkFVTlR4dWxUMng4MXhvWC9wbEs4d0w1VmtFWXg5d3QvMDU1?=
 =?utf-8?B?V2c5dTJNZzBaNjI3YmkreWFSbjhLNys4R3AxS1Z1QmFHVjZ1WktOa2J6Rlkr?=
 =?utf-8?B?aGg1NG0zWHlyelJqK2NmOTFUcGlQRnd2b2YvTVZRazNxK29QU2pNK1M2QnZZ?=
 =?utf-8?B?RGdvRzJtaUlQTTAydTFsZVFTS1dtcEk5dURqY2VEdlFMd3dDV0dDbUZqNlJC?=
 =?utf-8?B?TTZaSkozeCtLTG4rd0JHQW5RemRSRjVxN2lPT091T2JBaTF5QzVRWmNaRlFT?=
 =?utf-8?B?S2NWQjFPRklFUm42d1dNb1lONlZUbHUzRzRnUkZESDNoMGdKSUpxR1RBa2F6?=
 =?utf-8?B?WXlYZmc5dHphd3E1YmIyYTk3eUtVVFBpdEVGT1F3KzlVeVRBNktHRmFFZzhW?=
 =?utf-8?B?V2Q5eFo3ZkxTQTMyMDhRWS9mam5OelZKNENIaUVud0hoS0hTUThjczNLNUZO?=
 =?utf-8?B?S3pPM1Y1RUFZc0lRend5VzV6SW5UL1RaZlZkU2FrcVlvektpTVdaa3ZoODJ1?=
 =?utf-8?B?bVY0bmh4b3BUZzk1c3VCRkF1YWRUa29WcDFmMGNYYXdESUJEdUxWUDl6VUhN?=
 =?utf-8?B?enRmcUNYVjM5WGRpTVVZSHJreGl6UmMwN0NYaGVKa0gyVlIxb2ZQWktkaTVu?=
 =?utf-8?B?UVZCdFRBWjFjdHNSV0ovcU1ScjVwZHp4SXNnN3N4V3IyVUxSWlFuUTQxNHFk?=
 =?utf-8?B?UlhrdEorUVYvR2FRZUU3MVpyKzVEeXBJUG5remp4bEZzeEdiM0pYRXRCb0w5?=
 =?utf-8?B?THI5d0QyK0h2T2c2WC9QdW5qYzVkN3pYZmcwZTY1eUl5R25RTmllVThUUjhQ?=
 =?utf-8?B?OHpOblFINEtxYUhTQUhEMWpJRHljVlcxbzN1bFI2aFVNdmNFaXFXdGJLd045?=
 =?utf-8?B?VVBKV2J5UlJZZFBhVkN4cHZ1bFhTYzcrNytCL3ZPVXNRMXQybHRXcVVNR3N6?=
 =?utf-8?B?ZFpLTW5JZHJHZHVMYUtkeWYxZ0ZrT0ZTUEwrZC9qU0lleThxaE9CYWV2dEh6?=
 =?utf-8?B?OVRPVTl4ZFJnbzBRTitpUWtEZWUwZ0dNUXhwUThwU3NpOWxMckRmbytvQ3FW?=
 =?utf-8?B?b0hCWDYzeDN4NWRFaTJhK2RGZmFCK1VaUGw4eVJpWi91MG8vWGg3dDVYYThq?=
 =?utf-8?B?RVRiSFkyaEtpUVhoRWQ0aEVVdXZDWmJreDY1UEF4UFBqSVgzcnRPZVJBS2Nh?=
 =?utf-8?B?MmE3ckV0aGY1eTdCelQ2akNiUGc3V28wZUZWb2dDSGZ5U2hiZ2xFR3d4Syt6?=
 =?utf-8?B?ZW94N2diWkVPNm1BbEFDTGpaRnM3dk1qb2N5OG5vTUQrR1BXSUhvSGFHSk5Q?=
 =?utf-8?B?bnBiUTMrSEV2V0QwTC9vcXB5L2g5N0pGbUZxdUdWYW01NHJ2eXdwSC9sc0hG?=
 =?utf-8?B?SmpMaHNiNEl6ZzdGdWVaeWFXTXpnRUw4QW12NXdvQzZyTy9taVVHOUlVWVA1?=
 =?utf-8?B?ZExpOW5DM0NCbnF0WStvYUpWWEtOVGVLTm8wWmRKK2lHRi83U0hRK2k2Zmlw?=
 =?utf-8?B?b3E2alVHd0ptVFJ5bFJMREp4cm04WGxPTnJtOGdnM3lmTlhTNEh4NXZHWHBT?=
 =?utf-8?B?cVhuWTkyNGlYa1FyaEpTWFZ1Q01xc2xRcFp4QUNQK1N4UGhiSFBWeFBYMGNw?=
 =?utf-8?B?SzV0YS9xUEFib1FBMGhES09tSFJKc094WkQ0cEplSjF5MEcvdGFzbGFya1gw?=
 =?utf-8?B?d2tmYlBRc3QzQ1cvLzdYZk5ORFVFS21VR1NOTmF0dlNWeFk2WDdMWnMvWis2?=
 =?utf-8?B?Z2t3d1NoTFIycGU4anEweDFLMHZlZkdveU9GRzQwMVhCWGlpVGI1RUhvbDlJ?=
 =?utf-8?B?c3hYQWJXY1M4bm5tRXIwMjBwc09jSVVFelk5cW1TVXJpSkJOeFo5Y2hQaUlr?=
 =?utf-8?B?YkgxcXlwekd0ZnBleURGLyt2KzhzVmRzNmxvWXRYaW9FeGpicXY0eTJ3eFBz?=
 =?utf-8?B?cUQxREp2VTVIR3dseTR6UHJsLzZpWVp0UEVKOHZxNjluOFh4dkpvVGJxRTJX?=
 =?utf-8?B?eDNUMWt0VUtGL201WlFkNXM5T2xidTdsbm5VaWZNWWlkcmhSd3ZidFVwZ2g4?=
 =?utf-8?Q?lB2/h8L6OAf6Wgv8YNJaQaJN+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7538f566-5a07-4ffd-bc86-08d9eb1bb916
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 15:57:35.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8hvagikJ6wCPzjGJVeSxo5dPkaX0g3+ZXUBfCgTcdhzuhhbFn+Bdnse9YSXmQbC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3869
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: CAkLqhfuflb8hQFmJi29pgcpj2NLcngY
X-Proofpoint-ORIG-GUID: CAkLqhfuflb8hQFmJi29pgcpj2NLcngY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080098
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/22 10:54 PM, Hou Tao wrote:
> Two subtests in ksyms_module.c are not qualified as static, so these
> subtests are exported as standalone tests in tests.h and lead to
> confusion for the output of "./test_progs -t ksyms_module".
> 
> By using the following command:
> 
>    grep "^void \(serial_\)\?test_[a-zA-Z0-9_]\+(\(void\)\?)" \
>        tools/testing/selftests/bpf/prog_tests/*.c | \
> 	awk -F : '{print $1}' | sort | uniq -c | awk '$1 != 1'
> 
> find out that other tests also have the similar problem, so fix
> these tests by marking subtests in these tests as static.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
