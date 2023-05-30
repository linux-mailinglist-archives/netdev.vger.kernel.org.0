Return-Path: <netdev+bounces-6502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FAA716B74
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B52C21C20CC0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F20124EBD;
	Tue, 30 May 2023 17:46:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1861EA76;
	Tue, 30 May 2023 17:46:31 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA99E8;
	Tue, 30 May 2023 10:46:23 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UGYMM3031897;
	Tue, 30 May 2023 10:46:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=aKWCdYH+x8QB4cji3O1daNQy3KRdRkoLd9qqsOdoiHw=;
 b=Ik53mFPVKk2LAcF1WW7aWb1M5VVO/V82pZaVkqJLs8jJhkTDEronfRwZhbc6LFrfX2PR
 VJDN2aLVcMcWM144DGOYbnnwaEmyBmVIa15e/7+iMBy+KgYcaCjX09hKYjHUNCkt7zEs
 QgKERpyB9V8wUV9cvRH53qP93kJ3F4ZN6p1tP7poQGd3hzRE461hkjhiH2Qcb7+PzIcp
 0knnq3xAVutAYXhofbuzXpywTaG8pb3URg/0hHGLePnBeEu5NdFv1W7Iow18qqqQGe7y
 U2hImHWMngNiBT1sTDLR4dLEsjB7MBdfvvxZRzYnix4s/RmkEahtoaJT9/5Sb4ZVihKP NQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qwb4x4etn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 10:46:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hK5eLFw5trORef5ktN72oi/7s0NzJ3qi+3ezVJsiiTouoqkohtaPEqxXDIzkBNysJ38JWJpNcKg+u1XE/29TRbcMZXwzGg2MNZqzoZIMwRVGlKOVa9Ik+sEDxSPg3PidFiU4r5JDtPVQF6xbDo+UFIhxrqBnY2LGclS9Q/4d9GJ+6uPsriJsAXVEj7l1K+1VMumGBwJ19M15Eg4p0DYDcHtmMHRo7cJNxBlHdSifbhvxtUbrapuKZV+24pTfAYxTlFfvwRUvMxTivZ85Bw8Z53uNs314nM6UbJatNhy3wTGmYKyV64Mv3f4IoosRhkEWDAVmHEg/RnOxUbTup//4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKWCdYH+x8QB4cji3O1daNQy3KRdRkoLd9qqsOdoiHw=;
 b=OrTB0Xryye2uqajWMU/jV7nv/0cchvbeYBFXTH5GW0wb7dUL66SFbMzQ/JhKijbyxxjqt6/qh6OOMlSu6LN2G53Ddcthpr/F0m3i+OIm5s1f5fNQavfLcen8fvZnVAa2mD4ZisMUfxLNscly5mGRKdDFWVdRs3ohmZp0rHH5gFgowPqTtBQmdnmAfdmUwhOR8Bt7qBxGz5qlprB/Pxz22iuJ9E+r/tagihPfaxkpVSEOq+M5+YVzhLbfrpBbIiZkAfMCMpmS2Rel4Oe2wfdSDVaAM5s9WD23kH/eLaMj1lcUdEAqy3lwhfG1gz/huVNs7F2ChmmgJcefXIv2GDzp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BLAPR15MB4065.namprd15.prod.outlook.com (2603:10b6:208:273::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 17:45:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 17:45:57 +0000
Message-ID: <4f37f760-048b-9d54-14ae-d1f979898625@meta.com>
Date: Tue, 30 May 2023 10:45:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH v2] kernel: bpf: syscall: fix a possible sleep-in-atomic
 bug in __bpf_prog_put()
To: starmiku1207184332@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230530070610.600063-1-starmiku1207184332@gmail.com>
Content-Language: en-US
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230530070610.600063-1-starmiku1207184332@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0065.namprd08.prod.outlook.com
 (2603:10b6:a03:117::42) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BLAPR15MB4065:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b40162-54ba-45e1-96ca-08db6135b92e
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Lg7ViECEoMZLD4RyS27R8WmAKfs4cVphcwVXbTCMeaw37K8dt7eZIGfcS1MA3dMsC2sxokF2GvrySTD3Wmn6xqEuByM+e1Uyj6qRdUNzgGzmOJJuqz+CnDg+plj5fbFr2VzK356IXDiZ1mQkkFT3Am8DdwhiDMAvKo+wm8PYBc4q52UH6j4pthwYZ+yX4vbOfr86gZ/Nk2rQt68xzVOl8q2j8Dk00mQ9iDA+aW4Yto7ZCE99tWokgs0xraA2kk04z/E8Kgh7Ue33WniNySQ4xk81oR8R/0LN7qshXS5fB9dMIQmS8wudMvI5pq+if9oEWwl8fA69WsU53nwK3HQI58AbzUXSa12sutRLqudTEZhGHOopepd+a3BOdwnSe+xkWuwf/CxooCj4ad7uufRrOhG9rHuB4CZNwzk5YHq0fs0R/bX/DKn8+2/icnCvA/vYDSCIWwqWgROtm8L7aX3bxC4PF3f5ftcDEWFi/cvBlAdp1wa3dA8Np0W7BJame6c5X2W0B8eMaCaaonwSdeieaXasVPHTpOADEwbxfnqY8qN3LaGcRF/fyIElxO/67e2JBoOyP3yBcoerdbMYziVTMogKjgxiOlcA7S27N5rtsLuI9y+1+GrBbx0J2oFZ1Xwy0SuIrPT1TOLfxygAQ+0oGnNDs8bU/hds444dcaaSHFo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(478600001)(38100700002)(921005)(31686004)(66556008)(66476007)(66946007)(41300700001)(6486002)(7416002)(8676002)(5660300002)(86362001)(8936002)(31696002)(2906002)(53546011)(6506007)(186003)(6512007)(83380400001)(4326008)(6666004)(316002)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?djNVcThnWU5XaGxRUEVxeDF0Y1YrbkVjSmhPT3lKN3didmlqS0llRVB0ZmhZ?=
 =?utf-8?B?aEtERm80R0w3UTJreHh4ODh4UmkrNStNR1lUbGtLaEllWGxxN1FSZ3MvWGFM?=
 =?utf-8?B?VnR3NDZZUjFka3lWUEl3aldoWXI4bUhCN3kwTzA2U3NtbW5DVmZ0dmZKY2cr?=
 =?utf-8?B?VFpoNS93VWNaVHZTdjJsZEZzRHZyRXpucG84eEkxRldBQ3k3K1lJYUdkejQx?=
 =?utf-8?B?YUM1dHMvYzFpdWt5K0czS3BPQW5oMVBiRitSWmI5MGdzSnloMDFvbDI5bVZu?=
 =?utf-8?B?WTRoMUpZbjBnck5HVk8xRHpvUEQ0dG1xQjRDL3NpeWtuWGw5YUpYRzZncHJK?=
 =?utf-8?B?OHlnWlRMa041RkcvM2R6d2M2OWZXeHZkbERZeG5pc2pUN094aDRscGpqR05j?=
 =?utf-8?B?b1VnZFQ3VDlWNURWR0MzR1hXQUFxR2RKT2VuempWT016MTBaemRmbkZ3bWo3?=
 =?utf-8?B?YnFZTXVtTEt4SnNrVWpzdUl6MVI5MUNoS2JNQzZWeCtRUlNLNVh6N3ZpckJa?=
 =?utf-8?B?Y3FteTJPZkU0VFdGdi9qa01tSlZFVlRzY3I2dU1xOUdGVTMyN2JwWiszQSsx?=
 =?utf-8?B?cEkyRCtJRlllcHMwQ3VpN2NsaFJvWUJoMlZYL3JaTHl0WGJlOVNSbXlJZ1h2?=
 =?utf-8?B?dGQyMUF2czBtUE40UEdNUHFYcnMrRGYwWG9SZ1NycWYxaGVZa3RVQ0xMaGw3?=
 =?utf-8?B?K1JsZHFiRlZyQUxHVkZ3ZXlDK0ExOVh0V0JZM2xlUW9RWHB3UFFrVWtMNnFQ?=
 =?utf-8?B?b1ZBalMxMWUycGwwZVNKaENKRjAycXJTemJOTElIaStiMENDWEtGZ0ZNUVlG?=
 =?utf-8?B?SkR4aTFvZ2NzYllhenNHK0xmZVlsMTBZUkpINHJpY2FsbGtmcCtiQnZ0VTVF?=
 =?utf-8?B?UlkvSVh5YmQybHVzTW5GMzNGRjcrZHlLQWNVS0J5a3liMTVhR0h6cXRLak5S?=
 =?utf-8?B?MUM5aDRBby92bzF5WDd3QTQzY2tIRUJ2WjUwemJMZE9nWEFCQUlKVkRVK0hP?=
 =?utf-8?B?KzVvU2RFdTBmNGFMNzdYMEY5eDJNVHcxdHJqT0U5L1h1K0tDNG1FcU8yQ2lv?=
 =?utf-8?B?aVVRMDA3dzFvdnVtUXc1b3VISEdIdXZ5V0NIRU9Dc0tpUGlqcFU4aUpNSDB6?=
 =?utf-8?B?STUrbzI4NFhXZEJBQzhObUUzZndYOGNtaHZWVHZRUTBBSjZlSWo4c2g3S2lR?=
 =?utf-8?B?TEZMVlMrM3FDemhKbGdtcnR5NUdJN2dQajBPYVptMThuejFRbVU4RW5ESkt3?=
 =?utf-8?B?M3JiMXZ6ZzhDbm0zdUduN3NRanFQTlRnNE9zNVFEck50Zm5adE5JMzgvY0hs?=
 =?utf-8?B?azR3Q2d6N0dvZi84SW1tQlpUS2VtUlBLNkduM0FqOE9VcGFMN2F3eklidng2?=
 =?utf-8?B?TE94OHlMa0tmVXNxcmtpWitVa2xnalRkdXBxZWkvMTNCdUhqcHZ6MkRWNGZz?=
 =?utf-8?B?cFNhY3FnRkg0NWQ1L2dlT2RaSVZZYWVBZzRqejdrbmN5SzVuMlZUNW51bDN2?=
 =?utf-8?B?KzQzektNbHNTZFZieklMUzFtWGFuWVYxek1SNTR5SDhVWmdnVEFWaE1ENmlr?=
 =?utf-8?B?eUVodFk0amJEWW1ENXVoWE5ra3B3Qm80YnE4VjFNb1FySjNYUndBK1M3Yi9L?=
 =?utf-8?B?YnZaVXFTaEg3NEtOQmcvb1B4eFRtcFVwYmFGaGVZN3BaUEFaTFkzMkZPeDF2?=
 =?utf-8?B?Q1duWlc0blJmSmxSN0xPZi9UM2RBaUVnYnBpUmFoelpFNHR6MlRaRFpzSHBH?=
 =?utf-8?B?c1RURmpiRE5RZWtsVzhXWVlVRVNxODR5RVRuL0xTdytHZGdNUGM2NlNmaVdS?=
 =?utf-8?B?UC9NblNRSThYditsMmNoOHRjaFZXd0J3NCt6RlVINHVQL2dTZFBKaG5qN2xa?=
 =?utf-8?B?ci82bmRpU0EwUW53SEJSajljTHZoY09YbWJ2Zk9oVEUrRHZTbTlEclR5VUpE?=
 =?utf-8?B?akdSZWxyNlUxRVVSQmlDVUx2UmdWNk8yMGErTk5EZG1BUzVoSEpmc0lZUjhF?=
 =?utf-8?B?amp2Y1BRK0Rvd05od2kyOFc4Y2VrOUdYVk5kQWxITmR6YTRrR1JMYmFnQWJv?=
 =?utf-8?B?Z2p1cVVkNTJIZm02MEdRdmxwUDRZd1J3U1FxY2gyK2ZVVDNqK2xnUlVMV0V2?=
 =?utf-8?B?R283Mnk4dVhsTTBIODRUTzVHeWFNR3lneGk5OEZwWjZIY0FiV1grd3prVWE2?=
 =?utf-8?B?R3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b40162-54ba-45e1-96ca-08db6135b92e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 17:45:57.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: inMPMtSZp5WKYysSfsjyFD0ThS1wko3O3HWS8Epm+wTN5r/kMmxEppiODHoCJdI+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB4065
X-Proofpoint-GUID: nWHApsJYHpm0WboHpINydN4ze3g0MR4t
X-Proofpoint-ORIG-GUID: nWHApsJYHpm0WboHpINydN4ze3g0MR4t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_13,2023-05-30_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/30/23 12:06 AM, starmiku1207184332@gmail.com wrote:
> From: Teng Qi <starmiku1207184332@gmail.com>
> 
> __bpf_prog_put() indirectly calls kvfree() through bpf_prog_put_deferred()
> which is unsafe under atomic context. The current
> condition ‘in_irq() || irqs_disabled()’ in __bpf_prog_put() to ensure safety
> does not cover cases involving the spin lock region and rcu read lock region.
> Since __bpf_prog_put() is called by various callers in kernel/, net/ and
> drivers/, and potentially more in future, it is necessary to handle those
> cases as well.
> 
> Although we haven`t found a proper way to identify the rcu read lock region,
> we have noticed that vfree() calls vfree_atomic() with the
> condition 'in_interrupt()' to ensure safety.

I would really like you to create a test case
to demonstrate with a rcu or spin-lock warnings based on existing code
base. With a test case, it would hard to see whether we need this
patch or not.

> 
> To make __bpf_prog_put() safe in practice, we propose calling
> bpf_prog_put_deferred() with the condition 'in_interrupt()' and
> using the work queue for any other context.
> 
> We also added a comment to indicate that the safety of  __bpf_prog_put()
> relies implicitly on the implementation of vfree().
> 
> Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
> ---
> v2:
> remove comments because of self explanatory of code.
> 
> Fixes: d809e134be7a ("bpf: Prepare bpf_prog_put() to be called from irq context.")

Please put 'Fixes' right before 'Signed-off-by' in the above.

> ---
>   kernel/bpf/syscall.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 14f39c1e573e..96658e5874be 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2099,7 +2099,7 @@ static void __bpf_prog_put(struct bpf_prog *prog)
>   	struct bpf_prog_aux *aux = prog->aux;
>   
>   	if (atomic64_dec_and_test(&aux->refcnt)) {
> -		if (in_irq() || irqs_disabled()) {
> +		if (!in_interrupt()) {

Could we have cases where in software context we have irqs_disabled()?

>   			INIT_WORK(&aux->work, bpf_prog_put_deferred);
>   			schedule_work(&aux->work);
>   		} else {

