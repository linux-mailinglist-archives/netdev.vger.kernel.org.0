Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F318E4BBEC6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiBRRyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:54:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbiBRRyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:54:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B6D434B5;
        Fri, 18 Feb 2022 09:53:50 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IFx4vB009851;
        Fri, 18 Feb 2022 17:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/s4S2v0Hwmu15qc4HFVGhsN0MYs2UHafIMY/416VEOY=;
 b=0zRYrD3u9ueS//GVQOojQMvfMCPfQfHdgWV8sFChWB+XnIfAfCNqmeKxciye4x4KPcUW
 4G1lLcMnZpaSfITRKU84HJlEJo+g0ZiXmWirFWm9TiTIegJp4mgOrj8IDuMPCFPzwAqD
 q7OC5wGR09EjwlvTKkY/ZgQQc1g8nMBUhD66xOCWTXmRMIiQiwzUkjQMpTGcC1Q0kFDU
 bcYUuh7NYb/Uu6eegSuBbbZcrXvVkoOSSm4vhcgqRmj/KJJwoW1//7Cr5Ly2RG05h0St
 ZqDZCbELcjdRyEokK/QoYPSnO6brdFjQbaNfs8g/C73CIHrRywafspCGmIFMuprklsxW PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nkdtdc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 17:53:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21IHVoTk146966;
        Fri, 18 Feb 2022 17:53:45 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by userp3020.oracle.com with ESMTP id 3e8n4xvr18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 17:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejo5iaF9NtRPjrJ/XmnUUdV9MyxbgnYnG7wkP0EqptAxcxf0VkdojRmiZG68NHGVvj7k5RFDYxPR1saNLVRDpnjQ++yFdWh2sEBckgI5GvfZDfb48uzbQ6HXe8lzvpjm0a3Uxg+XDdYpfzksvZsIOsjBVjJefxuiDi9JxiYx6XhJnVV46fslp3w0y73eSxYzVMLn2/BQ6U+RURjm16u1YCVGZQLgYo/3i3TT8nTj/iVAw13QX7+Owm0P8juVLlp1+ugf9czOEwJMvdjI/LRnHQLL2EnZRgSrUb9byaZ6INil1sFybBLiGQV7Mhdy52C4p3ccxVJ6vQXCMbSYJLPruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s4S2v0Hwmu15qc4HFVGhsN0MYs2UHafIMY/416VEOY=;
 b=X581JnZpAtzIm4kx+OQ9DjiyKg1DkbojWAf9APxd9tpsA6e3IOIesVxe+DsLXq67R6b/pux65kN6D4s53zMavP/kbfffmooV7by49Opnhmqt1gYbSPq+sAKD2wfT7+D+sDr1eE+CT0HKaboCpF8OjbYOIPTcjeCymmme2SjLB1BEm9qQtYG84rGZj5sgZVJeo7c/YntfOYz1VG+9Frml/X6j2aaqKe+zfSvX7v503JiCkBfApysLsR+dL2FibmVorgIVHRFodaxQMcYZn8VmBd1R8UIuyHJa+DXv4s5xh2M0caMUUkJ7jV5GtTwZ9i5CQxucayUtqDSDLcgMv1uerw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s4S2v0Hwmu15qc4HFVGhsN0MYs2UHafIMY/416VEOY=;
 b=LK5VSDmAyZCUQp2EcOlbV8BOYPIPGDfNBgitHrxvj0aVlEDzcYo5VzXyBY1Ly655CkN68m2Miv+wxuiids+Dw8HOnCuqlmBwQnJMtxDKJH/ktUFp6jc53XDFdiz3BjS2SzACC+Q7ZNyPjYlczIHSN4HaGonwFnmilw0U5FtBxbE=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3752.namprd10.prod.outlook.com (2603:10b6:610:d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Fri, 18 Feb
 2022 17:53:42 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::6d8a:c366:d696:1f86]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::6d8a:c366:d696:1f86%10]) with mapi id 15.20.4995.016; Fri, 18 Feb
 2022 17:53:42 +0000
Message-ID: <0b2a5c63-024b-b7a5-e4d1-aa12390bdd38@oracle.com>
Date:   Fri, 18 Feb 2022 11:53:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] WARNING in vhost_dev_cleanup (2)
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>,
        kvm <kvm@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <0000000000006f656005d82d24e2@google.com>
 <CACGkMEsyWBBmx3g613tr97nidHd3-avMyO=WRxS8RpcEk7j2=A@mail.gmail.com>
 <20220217023550-mutt-send-email-mst@kernel.org>
 <CACGkMEtuL_4eRYYWd4aQj6rG=cJDQjjr86DWpid3o_N-6xvTWQ@mail.gmail.com>
 <20220217024359-mutt-send-email-mst@kernel.org>
 <CAGxU2F7CjNu5Wxg3k1hQF8A8uRt-wKLjMW6TMjb+UVCF+MHZbw@mail.gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAGxU2F7CjNu5Wxg3k1hQF8A8uRt-wKLjMW6TMjb+UVCF+MHZbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::19) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a719976-31c1-4e88-45d0-08d9f3079a15
X-MS-TrafficTypeDiagnostic: CH2PR10MB3752:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB37524A704D36225987A7F8C7F1379@CH2PR10MB3752.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C0+h/fcdxhefU5dGkHoEMdnKHm8s1jaUCFpUcpuGcxzQX+ee7SMDhnI/hTsdd0GcnlMbBqHFw+708uCbtVT/K0OfFY6C+VzcuoSD5TVW4/QveML5tCugHraE2reUKONXm26aRiufStiokWF6XEeLaeLUN0xo7YGPyDN8N8ZfXgmwpQZ7J/z8qbus8WQzhig1OAphPA5/l6iO8mH6h9nbZhWoKwqCIwJL+33Ovp3bP3CC3wQrP3821LEyb3zczUr8S/mKllh5jgCULX98ganf/MG/ZgnktBrpImW1rdw8R8A+ZTPoaoqkudpmRUy9U9pfhzQfYsG9SqxXM1GH5KhFMnwYlgy7DWC0MyXdfFc3M3eMspX+8kXHSjNDV89mlwlzwoyFDobzwYEt5skxCEal2JfEQSZYUMSQh5YvOauR8vG3o36cccxxr+vTQtzDWb5FJT6xJqabrvz2+e8RlLo0XCk9zEvbdgkSfxPBlXC18U0H2BRTggCIPhTRKG04bpFYsJPgiwZmaLFlJ9SXFktdnitPXtS4AGU1XCwBiPbgbCPN/Dsk+EI2zP4Q/SO9WWlPxj4NKsBXojFWWQbwkWN2myc6evoPPDBh42PDyDmkJzGOBqPMvy63gDjE8K9wWGH/hbfAEFJn3gonmHNF7VHDyLXff/D/QLb3P8idVE2QhGA0d0CMctfCBx6cgFZ5Z93RJWYqrDfTKsztctFRc0I956wc/B24Q70HSU1wBPv/I9tLqEu//SqZLGI7khkopP86/z0yVBB/6DmKEIgQEQckHTX2CMrfn9aGH5/q7k9DOMjbzZKgtN46SRsNkqRpelziPC3v7Y1PgKMpUBZ/wpKWH8nEkJf2rVAbCyu1Ct8yKFV7tj6h2OEX4m3J2oH790Yd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66556008)(66476007)(54906003)(110136005)(2616005)(4326008)(186003)(26005)(6506007)(53546011)(316002)(31686004)(66946007)(36756003)(83380400001)(6512007)(508600001)(5660300002)(6486002)(8936002)(966005)(45080400002)(2906002)(38100700002)(31696002)(86362001)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGplMGdpTTlvem1RcjRaZXRmbDZIVFZacUFlZVVuVkpPM1hBOENUanVCWjVZ?=
 =?utf-8?B?VTB0RnBMRytxcnNzKzUwZlZtUWloWWJoMnVPdHpEcllEc0RnWWpHOCt4WGlZ?=
 =?utf-8?B?UHQ3Q2RVTzNXLzJrN21laGdDRVRPWDVQVzdHRlpvZ0JNSGJ4eVlneHVqeFVv?=
 =?utf-8?B?eFlPaE5Nc2lXRVFoL0p1Sy81MGRkSjM4SXZRQlY5RkxnTHJoY3N6dlVYUlNK?=
 =?utf-8?B?SFdpVVhxQkR0SGNqd2JqaDRRdFhRRzVqNUNpVmFKaG1MT21KUXAzMWpxR1dL?=
 =?utf-8?B?d2pMY24wWmR1R2xuNllubXF2N2cwbS9QMUJkSnhkNjkxUFlkRHlYTVlES1Vi?=
 =?utf-8?B?UUc4L3Z4czFacnZlSE9CK0V0ZWNDNEEyK1pLb1U0VXZxZVhXMHpSc2F6VThO?=
 =?utf-8?B?dXJTMzJsZUZTNVZkS0JHMGFUQ1U2Z2hDZGROTnVRMXJJbU92RFdSQm5mL3ZB?=
 =?utf-8?B?RkhCY3llZG1YbzNudDVFUjFMQ0tKMjRIeThHTElHVm9NTW9HYndoaXh5Vitj?=
 =?utf-8?B?eC9RWktZR1E1SGQwNDU4bDY1U1IzZU9zcDFFZnVxS3k3QmpRNnF1QnJaNlIr?=
 =?utf-8?B?dTR5STNQeVI1clF4NU82NEwwMUFSZkk1VXRGRXh1YmFjRCtXamxFZzQxL2Nu?=
 =?utf-8?B?QXJRTDhhc3lZRXFpenpISHdDUUZmUm1LUEUxZjVla0szQ083QmVhcTM1MDZi?=
 =?utf-8?B?OXhJaHd0b0xMUy9sNkhIc2NLSXZZSlhodnowSGNMWXpwUnJURldxazUrVWpH?=
 =?utf-8?B?UkVJQkQ3dUtDR1RtUTU3OG52RjJzU1hGRFpBK2JGZGRXUDNXRDh0eFpibEQz?=
 =?utf-8?B?czlLNHByWENzeit1dUZBRDRrT0dudUZ1QkdyU2NCSDk4VkhWdG9JN2ZzQ0tr?=
 =?utf-8?B?NHQwNVdoZFR0WTdUUDVyMU1PMEpIdGlVTXdEVDNGaGRSMmswR3BOMm5nVTgx?=
 =?utf-8?B?U3cxbjlnSUZ6NCs4S2w1MExPZTNMSGRiMVJ3MC9LOEI3eVBYRm1iRzM2a0tD?=
 =?utf-8?B?V2F5YWNKOG9mV050b2NvMzNrQkN6QmVnU29sVEpoRVpxVTFQNXJ6bVR6RXYz?=
 =?utf-8?B?cXIwUG5mb2hDZVBlVWZXU2JzUDBxYW5xbUdRbElhcXFOenFCM3FiOUtLbGx5?=
 =?utf-8?B?SU5jQmVwbm44TkNCQUNOb3kyNFN0alZPMFNyL1BVS1FaZ29VakhRbGc3WkZm?=
 =?utf-8?B?aUFkbk0reVBhdDJoOGNLK1MyTFlwVVFrWVN1QW9seUlaSFJhQWUxbU5JZDJw?=
 =?utf-8?B?SW5FOTV6cUZLa3RWL2xjQnJHU1YyNTc5MzgrMmR5TVU2K0E2Qk8zZmtCUUM5?=
 =?utf-8?B?eFYzakNkQnRQa1BrRVRjRGtmTXZQR0h5MXhVRkFQa3pMUTgrcEV0STVhZ0J5?=
 =?utf-8?B?QVl1ZG10S2JsWHlSOUoya1dHYmFYa3BBRFRhSXR0SjhnaGRoNzVZWGJzMTJX?=
 =?utf-8?B?TGRyVk9ZMytsN0l5ZFN3a3JQaDcyRzZSYmp2TGYybXN4cmVaN1dQWVpuRjNQ?=
 =?utf-8?B?NEkxVTdZcy8raFBualpid3NoQjU4Z0gvY211SDduUTlBL0RUR3ZLOUFrNHJq?=
 =?utf-8?B?UVJkTEVPc2FzUzJTYkpMd1N2S2s1NVBPeXozYW9sNW1NQkRXWnhUdFRtZjRa?=
 =?utf-8?B?bVA1Mm5JTktLRG0zUkxGRGhPZ0VQNTU1WXBFb0RVS3MyKzVsRDhOQU02cXpi?=
 =?utf-8?B?YzVoSzdwZ09MaHlYYW9XeVpnVVk5cHNjVTRCTCtsbHB0QmtzMG9qdTFmbVN0?=
 =?utf-8?B?WWp5dVV2ZVNDdnBockRsb2NwYlkyVzdsQ2FaNlNmYWZHZlRCdmt4UVZ0QnR1?=
 =?utf-8?B?c1VHV3N2K1VCc0lYRUprbmoxZm1jYitwUEZCb3JnQmp3OXFPOGVpUHhWNXla?=
 =?utf-8?B?cmtUM2RzZzhWS2tLSFlrOE4yV2Z2RWsvT0loV3Zna2tZZmd0SW1PLy9GRTBq?=
 =?utf-8?B?T05PblYrNTQ4TXBhbUZ1TUppSmxyZEJaNU1jWitYOXVRWjVHaXRQcGQ1NHI3?=
 =?utf-8?B?SmxkcVZCSEVTOWQ3c2JkbEpTZ3R4azB5VHNxRS9pSnZ5TjQrOHVJWDRZWTFO?=
 =?utf-8?B?bnVQcWtkaU9mTzArR3ljWEZUQVJpcmRPV3VFYUROL3NLMGFrYVYxdDF5UzZL?=
 =?utf-8?B?SEhHYjZhMVl3OGYzRFpVeUVwNS9sZ0xoSGtFek4zbnduTzNJYWJsN3A2QlJ0?=
 =?utf-8?B?QWtodGF0NytsVGxrbE1hWFZpZFI0ZjU1NkZZSTJtNkFYejFFanFUbTlQTHND?=
 =?utf-8?B?SG81STlmYlZtQ3llNmdsYzQ5c2x3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a719976-31c1-4e88-45d0-08d9f3079a15
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 17:53:42.7541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ii3TdP6ZGeDOAUN4yUs0SbYaaZTmvjIOQ70NQFVuOMnBehhFCSyfmqQetiNn+bt+h/PGDkjCR0R+ZwcQU0ZVAkrHpyPDWGQ929Ag4YnDV94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3752
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10262 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202180111
X-Proofpoint-ORIG-GUID: yAvtOixVKS0fgyVEPhqaZP5EXLAO_9jP
X-Proofpoint-GUID: yAvtOixVKS0fgyVEPhqaZP5EXLAO_9jP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/22 3:48 AM, Stefano Garzarella wrote:
> 
> On Thu, Feb 17, 2022 at 8:50 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>
>> On Thu, Feb 17, 2022 at 03:39:48PM +0800, Jason Wang wrote:
>>> On Thu, Feb 17, 2022 at 3:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>
>>>> On Thu, Feb 17, 2022 at 03:34:13PM +0800, Jason Wang wrote:
>>>>> On Thu, Feb 17, 2022 at 10:01 AM syzbot
>>>>> <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com> wrote:
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> syzbot found the following issue on:
>>>>>>
>>>>>> HEAD commit:    c5d9ae265b10 Merge tag 'for-linus' of git://git.kernel.org..
>>>>>> git tree:       upstream
>>>>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=132e687c700000__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9YisMihn$ 
>>>>>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9RjOhplp$ 
>>>>>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=1e3ea63db39f2b4440e0__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9bBf5tv0$ 
>>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>>>>
>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>
>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>>>>>>
>>>>>> WARNING: CPU: 1 PID: 10828 at drivers/vhost/vhost.c:715 vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
>>>>>> Modules linked in:
>>>>>> CPU: 0 PID: 10828 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00051-gc5d9ae265b10 #0
>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>>> RIP: 0010:vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
>>>>>
>>>>> Probably a hint that we are missing a flush.
>>>>>
>>>>> Looking at vhost_vsock_stop() that is called by vhost_vsock_dev_release():
>>>>>
>>>>> static int vhost_vsock_stop(struct vhost_vsock *vsock)
>>>>> {
>>>>> size_t i;
>>>>>         int ret;
>>>>>
>>>>>         mutex_lock(&vsock->dev.mutex);
>>>>>
>>>>>         ret = vhost_dev_check_owner(&vsock->dev);
>>>>>         if (ret)
>>>>>                 goto err;
>>>>>
>>>>> Where it could fail so the device is not actually stopped.
>>>>>
>>>>> I wonder if this is something related.
>>>>>
>>>>> Thanks
>>>>
>>>>
>>>> But then if that is not the owner then no work should be running, right?
>>>
>>> Could it be a buggy user space that passes the fd to another process
>>> and changes the owner just before the mutex_lock() above?
>>>
>>> Thanks
>>
>> Maybe, but can you be a bit more explicit? what is the set of
>> conditions you see that can lead to this?
> 
> I think the issue could be in the vhost_vsock_stop() as Jason mentioned, 
> but not related to fd passing, but related to the do_exit() function.
> 
> Looking the stack trace, we are in exit_task_work(), that is called 
> after exit_mm(), so the vhost_dev_check_owner() can fail because 
> current->mm should be NULL at that point.
> 
> It seems the fput work is queued by fput_many() in a worker queue, and 
> in some cases (maybe a lot of files opened?) the work is still queued 
> when we enter in do_exit().
It normally happens if userspace doesn't do a close() when the VM
is shutdown and instead let's the kernel's reaper code cleanup. The qemu
vhost-scsi code doesn't do a close() during shutdown and so this is our
normal code path. It also happens when something like qemu is not
gracefully shutdown like during a crash.

So fire up qemu, start IO, then crash it or kill 9 it while IO is still
running and you can hit it.

> 
> That said, I don't know if we can simply remove that check in 
> vhost_vsock_stop(), or check if current->mm is NULL, to understand if 
> the process is exiting.
> 

Should the caller do the vhost_dev_check_owner or tell vhost_vsock_stop
when to check?

- vhost_vsock_dev_ioctl always wants to check for ownership right?

- For vhost_vsock_dev_release ownership doesn't matter because we
always want to clean up or it doesn't hurt too much.

For the case where we just do open then close and no ioctls then
running vhost_vq_set_backend in vhost_vsock_stop is just a minor
hit of extra work. If we've done ioctls, but are now in
vhost_vsock_dev_release then we know for the graceful and ungraceful
case that nothing is going to be accessing this device in the future
and it's getting completely freed so we must completely clean it up.





