Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD924B774C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbiBORDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:03:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbiBORDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:03:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D89411ACC1;
        Tue, 15 Feb 2022 09:03:22 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21FGM7Nf011842;
        Tue, 15 Feb 2022 09:02:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=67B4JiuguTRGGoRmXZ1vvYGPUlhqpWYpTFOPmUPBooY=;
 b=OFEWdQKhNdgs3IRp0CGNTqlM9zVzXCwF7Kvjl2hVIxBBeOeQXlJPUrAjDK5GSXF5DQT+
 h3iDKjMCaIvuDDHFkM5x1OPBMnCe5sH6CwK1NGC1m7l1MzuD9jgBEEUHo5+Mcc4/RyyV
 RRVsg1Z1F4Vt5bUbc+JZIlX7zXFhQfikKgA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8fmu0bxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Feb 2022 09:02:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 09:02:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0CU7QIHy6Eaw7vhXugcijGoJJMV85lEtQXihuEuwN9FNYixk5jEEkGmHOmVVSebzNcdlJk2T3Yvrj101PIt4YoR9joWpi/GO5Zcer9VLe5yf72LF8QQ2j7M7EaG71BPOF1kPRckYKLry4JxIAlDAc+JVfAJhut4V3P0gFtjYEksjOL1hOVdcZRu/IXhY6OIOpPUn2tL1QURe+NSUtHF7Z/9UthjMgaeK8ifnacJI+9P4FqWE55n8Zyh/PRB0GwhzyFfmpdP1hTA2MAapKc5+x0NYMxoXC8toc06behuj3ehiA0ybQ5jD0MLZYs0ZhhSQBsDFunoPUDvHNjkyn18mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67B4JiuguTRGGoRmXZ1vvYGPUlhqpWYpTFOPmUPBooY=;
 b=E5uJRxYuKLtUOCN13MVoO9AB04NmDEhHbUWVGJ+/wiI9itR3+lfcsq1SnvFZXLpL1S15xmiZhzq05W6/FF9mbAvG/RNDVBLcIMRRLYK4Uw4ltimTkxLHqGZoiJ94npU5jEuKnak4UCRvNPgQYrGQVYfAFuE8loX3td4+Le1wlos9LAUPlSqFepbv827DvZ/iC2azPZsPFHkaGdTcNqZ/DN25Vt7cLInB2RZ78hbAJ0IXhs5sXfXbNLZcMD31nGTkAYYOnvW1rINxzS9AHj0ryNzKvcv8/5SUM5LyuugoAC7bPpADU00yP8KRewc4FismBKyKBy1dkrFvZV1GFgiXdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB3581.namprd15.prod.outlook.com (2603:10b6:208:1b6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Tue, 15 Feb
 2022 17:02:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.4975.015; Tue, 15 Feb 2022
 17:02:50 +0000
Message-ID: <f939bd53-96d0-d1dc-306f-6215ade6a7f1@fb.com>
Date:   Tue, 15 Feb 2022 09:02:46 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 3/6] bpf-lsm: Introduce new helper bpf_ima_file_hash()
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>, <zohar@linux.ibm.com>,
        <shuah@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kpsingh@kernel.org>, <revest@chromium.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
 <20220215124042.186506-4-roberto.sassu@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220215124042.186506-4-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1601CA0021.namprd16.prod.outlook.com
 (2603:10b6:300:da::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eedeaa4-f83e-4560-bd05-08d9f0a4ff74
X-MS-TrafficTypeDiagnostic: MN2PR15MB3581:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB35810E2610732B6251D3AA0AD3349@MN2PR15MB3581.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lix39mFGcqm94oshGHVC7AtBpf+qPGsf6VG3L3OARyWTzhf3FD57eH7B9k0WujEXXaLmUQwQXZtWeTfHCUIVkaWKGLpzJGglze6l14oMV7/KgeO+e2KYaHQJE+JDBYMk0so59l2LQBB3NS1oSKw25PC7Cs5+8ESVqVjckeJEMeasNHrInQ8KUDswZwNy26M56CPMixR8ncLkDKCOnYoBrwqZrz1js/adbpf2VtSkT/PG+Q8cFlXt8QLREh4WEaQeARMniECIRs87vtTbQm0LjRS+u3N531cqrR8Nz6lzy3FulnOFjmBlfD8lIPxknV0CpC9XsPvl0erSQ7fxoy4iHH1cUJPnS4NULkpZSRuBFrdq4odrSMIpmcKxcAYBv5SnalOaj60tRDrV8l6beytZuPpbHO7HJqJjXezDRutAxmsU5M2WCIlslyPeBzbHMfNgfqUgoPeS6HLXdasQoiNCB/w851PuvKqO+RbdFzi4CTXwGxZa8liMGafk5TC4zcNi+52g0e25WqSuXFvLetFsL7lXDT/h99DQ9ljBrAGibZxCD0ojjpieDSZCQ8b/BQMfVL+JGqNC+V/ui5ZWk/DhHg9BxK3h+BwN9duH3ORyhJqy44bKw8CfGpEnWSCLuveqH9NVlNPLQ8+F2Sp3SjGfMBKKyDyr20TuRwHdBS5kLfF66UEweqvsMUXkmWU9/3lkaGw1nRbUtTLtwXcIv0ZoZZY9GBVZJM7AXVzpvlVipe8b7AhvHJsCjGZAxqXWpvgE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(4326008)(83380400001)(8936002)(7416002)(2906002)(31686004)(5660300002)(36756003)(6506007)(8676002)(53546011)(186003)(66946007)(66476007)(6512007)(66556008)(2616005)(316002)(52116002)(508600001)(86362001)(6666004)(31696002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWZ3OWgwMG9DcjJ3VHcwSW5manpiL2hKbVM0aEtFaW1pTDZzQmlaa0F0VUxU?=
 =?utf-8?B?bnkyakZVUEtydGdqOUN5ZDFiREJ4SDdoRmlzOXZPdS9QdVlKTkV4b1VjRWxB?=
 =?utf-8?B?VTQvUkx0S2l3M28ydzQ2NDZCR0k4bXFqaDdMei95U2ZIdmZqQ1B0dFdyMWhB?=
 =?utf-8?B?Umd3cXpwVDFPVm1xekdCanF3czIzbmI1dXNlYzNUUkVDa3ROZGpBL2dTcTAy?=
 =?utf-8?B?Q2FqbkJzN1FMTWg5RVQ2UjBQd1hub0lOZ0d0ZW9ZNENha3A0YThjc2ZKbWFk?=
 =?utf-8?B?YU4vcThjdlhDYXVLRTBLTzRuejhMM0dRVlBaWGtoOWhaSHk3L2xzVk8wamk5?=
 =?utf-8?B?T2FRZXY0ZEpBTGxwZkpBZm1TUUJNWXQvUjhURmR2Y1hsRlpHYXVSTXhEV3NI?=
 =?utf-8?B?NnQyL0tNQXVDd0o1VFdiMDVNVUVMekFZMnFqOGNKekFyQ2c5alJUaXlGV0I2?=
 =?utf-8?B?V29vYXFFczRpVGp3TzdyWDE2VXVPS0kyT1dGSE5TWW9ReEdoU1JQbkltcXZp?=
 =?utf-8?B?dVJmbDJFTXhMZHE5R0pEOE0zbDBhT2ZQM1lGY0Q2V2h6cCsxWkJGeFVvMEk0?=
 =?utf-8?B?VWVFdmlyMEZmb3RSS2dFMzV3bVVhZDg5Nk44QWw5aVVqNWp4elcwbmU5Y2sx?=
 =?utf-8?B?Y2hjcGxEZXhBRE1oUUNITzY0WWdwaFF0bEZNMlVEVmxvK0JDNlpoTzI2Y2hT?=
 =?utf-8?B?b0VNK0F2UmtRTWlDM3JvdkRQaFlLQnFwSnVRbkdsQWNqcEluTTRuY0NORElN?=
 =?utf-8?B?RjVmeEg5U09IbTc0SFhDeVZsanJ3bit4REk0dXFxYVpWWE8wcXNsYnZwM21a?=
 =?utf-8?B?d2xWQUVZcHg3aE9BYU1mNE04STlHUnZaT2ZYa0RSRDJ4NGswaVpvbnJxbGlN?=
 =?utf-8?B?R3NoVndYOFV0Rlh2L2VSNzNQMitvS3pOWWZ0SlJSRVJOeFZ3SDFVbk4vczdS?=
 =?utf-8?B?SjNiSjR0M3hrOHBlUFR3RXN1MllnMGhTT3Nzc3kyK2FiYlBkR3dyV2dxa2k1?=
 =?utf-8?B?ZGMrQ3lkQ0cyMFZVZFNxS21UenFyQTZGYUVLUWFJUE1rUmhOK250Y0pnSExK?=
 =?utf-8?B?RERrRk1BMzVvYmVWREhPdnFHbG5DdnJoeHZ5Sng5TmZHcHBxQzNleG5kQ29h?=
 =?utf-8?B?b0J3VnlLZ01ScG1rcDBsMFZBTmRqckpwa1ZLQ1dROEN4cHBCZkdvWEtDVy9P?=
 =?utf-8?B?aWs3NmhXcE9icjd3YnRTMjlJaVVUV214VkZsK1JOaS81bFptUGZxWlA1VWlh?=
 =?utf-8?B?RkxLclZ3SGswTUNmYmRQOGVsTFVKRXoyY1IzNERrL3JnVEplVU05MFNySWtO?=
 =?utf-8?B?UlFzL05VQjd5MUlYUDhDUDM0NTIxOHZVQUZCcC9oYlI1Z3g3ZjRGbUc1aHdp?=
 =?utf-8?B?QWUvNHo3N1QyL0ZrcHFPQUJtUzl4ZjdxblFpc29wV0pXSzNMTml2YVhIcmdL?=
 =?utf-8?B?akxteGQrK2VJWFN5cjJ0c0w5b0NJZGh6dGUzMWhrRzF0eHRJSmRMNDZVZzdx?=
 =?utf-8?B?UFowcDJ2V3dhYlNtSm9tMUZzYVJyUlpXc295Z1JrTEZPaTZiL3hXa3p3MmFj?=
 =?utf-8?B?QnBINm1IOEptUTR1eHhPVEY2c2FFUFh6YldVM3JWOWNlMW5EVnN1MWFjZ3gx?=
 =?utf-8?B?OHlzKzd2anFYQllSa2F3TEl2MFVnVGNiUmk4V3pPcFY3bnN1M3NlRGM2SVN6?=
 =?utf-8?B?ZkNnaVBSY05PVHhFVmpxeDV3TW14SGE1T09IcC9YUWRidThnYTdWWm8rQ25E?=
 =?utf-8?B?RURnQlZJNDdDNUZlcXRucjE4cCtXbzhjSDBPN2E2TkY5YTc0R2pBdmcxcDhr?=
 =?utf-8?B?MDJyTFRZNjF6TjZhcGtuUWxCU2U1cVNKZUFyQWExc2dWc012ODlzbi9YTnRM?=
 =?utf-8?B?TnUwYTVTeHk5VlFmMXBxc0IvaUZHUmJzdmcvSW4zVXlwM1g1M2tKQ2JKTW5F?=
 =?utf-8?B?WlpEeC96R0VoNEVtRHN6WTdRUmx4QXZnbnJJWG1QakFYd2czWVFvcTlEOFVj?=
 =?utf-8?B?aldMQW80elllVzVvaW5pT2J2WmZPZ0NMcTU0Q3paeG9yU1NodVkyTk5oT3pC?=
 =?utf-8?B?RTIvUkZTUFhkQXF1V21GakxaRGNUZjI3am1NM0J2WHJQSzFWNDM0N2tVdTVj?=
 =?utf-8?B?WEpPMmgwalFzZElyN0pXTjJPRWRranZ2OVZUNHhDdmFNU2dLWXN4RitvN1NM?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eedeaa4-f83e-4560-bd05-08d9f0a4ff74
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:50.2497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +i1FXeF/iJK5a8OfyVAryOmarC195FV4atoxIfX2j70xBb4q3tWMvr2luhe/Yt9c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3581
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Fb8mDZWM3vdff2PqdyUxRa1hbBWl6cdG
X-Proofpoint-ORIG-GUID: Fb8mDZWM3vdff2PqdyUxRa1hbBWl6cdG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202150100
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/22 4:40 AM, Roberto Sassu wrote:
> ima_file_hash() has been modified to calculate the measurement of a file on
> demand, if it has not been already performed by IMA. For compatibility
> reasons, ima_inode_hash() remains unchanged.
> 
> Keep the same approach in eBPF and introduce the new helper
> bpf_ima_file_hash() to take advantage of the modified behavior of
> ima_file_hash().
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>   include/uapi/linux/bpf.h       | 11 +++++++++++
>   kernel/bpf/bpf_lsm.c           | 20 ++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h | 11 +++++++++++
>   3 files changed, 42 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b0383d371b9a..ba33d5718d6b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4648,6 +4648,16 @@ union bpf_attr {
>    *		**-EOPNOTSUP** if IMA is disabled or **-EINVAL** if
>    *		invalid arguments are passed.
>    *
> + * long bpf_ima_file_hash(struct file *file, void *dst, u32 size)
> + *	Description
> + *		Returns a calculated IMA hash of the *file*.
> + *		If the hash is larger than *size*, then only *size*
> + *		bytes will be copied to *dst*
> + *	Return
> + *		The **hash_algo** is returned on success,
> + *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
> + *		invalid arguments are passed.
> + *
>    * struct socket *bpf_sock_from_file(struct file *file)
>    *	Description
>    *		If the given file represents a socket, returns the associated
> @@ -5182,6 +5192,7 @@ union bpf_attr {
>   	FN(bprm_opts_set),		\
>   	FN(ktime_get_coarse_ns),	\
>   	FN(ima_inode_hash),		\
> +	FN(ima_file_hash),		\

Please put the above FN(ima_file_hash) to the end of the list.
Otherwise, we have a backward compatability issue.

>   	FN(sock_from_file),		\
>   	FN(check_mtu),			\
>   	FN(for_each_map_elem),		\
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 9e4ecc990647..e8d27af5bbcc 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
[...]
