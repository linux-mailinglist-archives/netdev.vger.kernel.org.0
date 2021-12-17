Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300254781E4
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhLQBIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:08:42 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58048 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231566AbhLQBIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:08:41 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGLE2p8031682;
        Fri, 17 Dec 2021 01:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cr6qc2aB6HFqpdpYp6v+0aRhh2Hg+Bg4KN2ituLWZEc=;
 b=XomEdt259oynkkHxmC3in/erqStSiBbE2Y95MmcT3annRycrVGIN8C+pMTMXkqge3hAF
 S05ywyC4YPVSYzmJh58Vz/i9WfnLxdztKgZU+/LHFG6hCvXlCOG5MpACg4s9pCtka1kH
 ifMr1xh4JcC7D4Kdfj7Zyqdr0hEGwBSaw6USjA6YA/O/R5hjGyWNLuNooNmJaMP+qUkG
 psYoYCxv64vsBoOCHjru5RzOp3vzj3NbEXY6DSkT5SeGL1SuC8j4AZY7h2bZxfXG7nO5
 NOFctyqWXAMEto32dKKpb5pEtU1UYyhQVuOu/6K5nupihIrcKGzm34wxvfVnt5awK3uG Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykmbmgqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 01:08:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH15tuQ114925;
        Fri, 17 Dec 2021 01:08:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3cvneupx5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 01:08:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhBwq3S466pc1oqfdJuBUnfFyEu+HBd/oBUnOXTO68r6Y0PERX0n55lUnlkElc1OEoyU6Qn/VaU4QrDM5oxXQlwzDpcBkGWmYuQcbl4EqTmAIVZPBZr0OeXXAVodKFhgpyyMEjjHwI3V51FrESJVW38HNRoILWTgpi/LrfE0KfdVKB6UZpU79HtHEuHzMOroFjbOnRmo0nHqQWU6rd8Dd5HbtMLoFLCeCaAH7RMFAtERRtA35mJgp9AKD6birZfGYq+n/E0aDVHjhJcdhvJMGSE+aStrptej5+ylgEyEKjAAlSMbUJ6HwI/+27K7wdLfiQLZWhNdKe9b50DSRDougA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cr6qc2aB6HFqpdpYp6v+0aRhh2Hg+Bg4KN2ituLWZEc=;
 b=nDm5yt3T3t6DY2aKhtjjUEMmtLG+IS+OrWrff7mVWe9TNs0fVNN9m94xVY/1YA81bIEnSuZSILNs6hdX047JhAdkghbJiW/s99AbOeAg921R8EbWBxQR/NhKK9bKR3nc5qI7OHI4uwph/jvbYLNpuFbrvb31fkyej/JNQbFUz4dMBn+2mdbQwAsuSc23JW+WD1LHQhIBrZICQ11ZRn5qaeiUaM3AArDQ8B5liFfmu/R8RfRZ1ZqsrOa9BGHWaeyFKVThr9BaZ/03wMh43VKKJiSSPFavlneDRf/oHeJjIseONQnnicwGO9QaOyfSdeZSJ7jyiDi20K8xPeQ7Qb13pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cr6qc2aB6HFqpdpYp6v+0aRhh2Hg+Bg4KN2ituLWZEc=;
 b=ecsVxtbILDUnqKIoNQKvfnyO2bfGyV/lg6K/XzeqpwG6Bx3Lk29Fth2uPGtwqFsJ0NM7SPaKaWYN5hhmvHTO5bACJdR+vm/nCGtT8+N3tDMLx5QDlWYnp5SRqAe6dcMrohq4T2wOC8wcv5lWtqxNYJ7JTJYn8CkESw7zSFE4kO8=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4734.namprd10.prod.outlook.com (2603:10b6:a03:2d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 01:08:33 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4778.018; Fri, 17 Dec 2021
 01:08:33 +0000
Message-ID: <b0f7fe98-3d60-f6da-51c6-cfa5e7562c44@oracle.com>
Date:   Thu, 16 Dec 2021 17:08:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
 <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
 <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
 <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com>
 <CACGkMEskmqv5bLyqEgXEN76Eo=NaPXd8ycMR_rs5_-PWhRkTFQ@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEskmqv5bLyqEgXEN76Eo=NaPXd8ycMR_rs5_-PWhRkTFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN2PR01CA0069.prod.exchangelabs.com (2603:10b6:800::37) To
 BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c60938e5-8246-4c06-9c0e-08d9c0f9bf15
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4734:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4734B7570008AA58AB188AF7B1789@SJ0PR10MB4734.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmRCKmxk/qJT6z1qOJHZloaO2KxKTNO2Z+3TRgFsZg/y8V7zk8WigpjOvomAwW+RLlJbY9xpitQ69DK9UKwLgqMBLzSh1i0LNTctc+SuuREiss5Gi7+uiKMAzQUXoRAaZ0/+MIb7xPhbQLwE0ScnK4QAtoNpH1iWi52X/JyS5NmQ61BN/5Pl8o4P7QTn5AkKnZKZDi4FbS4rcelhk7j4FwUV0h7SmvzRMtNSMzTyQp3lKGrcKD9NSbXfEGUbmfd2Q0S9PND1/ezkC7KxNka2egS05QBVHTDbF6sry+ZF4hTqvEnOFoGhU6mzRy2FO9ky6K7Yi7kJhNbvttySNVkgTx+dNKDBRuISb5EEmOJN35v2gvotpiHEaC24JoXFpYSVwL+7HQHweK4MC1wyfSU6zmOk7omGss0VUCB57fG2zmbHiBA0tB6rSaAOiqFfQhkGhpfgbTnURzLgPJ7mP+DRZlmGdl8B/2ZY3Zr/zN898vdE2fiPPWVQYyR4eB0qAq91KHtKHmO9OwuqXS2LtCUUuS0S+CyDPdsfq+kV1wlEkC+u92WWyUEkTisiW20xA+5QZqSbsj9A9F4nte5UqQ4BBmCwhxy3/PdLWiwmHwKWslO1wYTLMVdzVh3ouQtb/iB9F2LlJ5VgDsuD2TTNdCouSpX9e2ojm/6H0sqyJW/tXvAlYmJ1z21X8Piwbm/xi1AyRhb+QBvK0/trX2BidtPPxEVmcOkjjhsdMA+LPf33ErUlIE5Rg5R611RUh21wq1pDaJP3rJD2CaGvGhPdL6FuVSoH1fiqC5sJNe4pOeI6uJvDAbekF+siorIIo31MXbO1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(31686004)(8936002)(6916009)(66946007)(6506007)(8676002)(31696002)(66556008)(66476007)(36756003)(38100700002)(186003)(508600001)(36916002)(4326008)(6666004)(53546011)(26005)(966005)(2616005)(2906002)(54906003)(6512007)(86362001)(6486002)(5660300002)(316002)(30864003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cCtaT1Fzelg0ZktCdk1pRGtqZ2owY0lUUGhyeUpoMjNTczR6QW9GQ0RMMVNk?=
 =?utf-8?B?T3B4SzlHS05DMHduNkE5ZDdkTU54cElrR3pqYW43K24yZTVURk1zMzRtaFFz?=
 =?utf-8?B?WXltTHVqRVRiY1dVdUx5RmJ1M2ZXN0Z5Rmt0MDY4bVhqaTVvclhGVGdZcDlM?=
 =?utf-8?B?RDdpNUszbEhuSjJPQUQ3VG1aM3J3ZEdUK3F2MjFhS3dlMFhkakhyK2pkbGVF?=
 =?utf-8?B?ekdIc1J3MXRLRlRFUlRYMmMzU2RMS2ZkZk5ObTRMRjE1QVRjNmUrVVp5OHBz?=
 =?utf-8?B?cmkvRkZSbWoxdDZsSi9kMkNFL2RRRW5FUnhUbjhoR3FRZzQ0NGlMaHI2dGIv?=
 =?utf-8?B?eFhTMURxbHhDVlowRDFZYmVTcFQrOTlQb0d0blAwMWhQUldsSFQwUG1qUHdH?=
 =?utf-8?B?RGNXYTJneGJBZHQ5NlVTaDJrL0toNmhCVE5DUi9MejJPMUUyWFNBSDFsdFc0?=
 =?utf-8?B?Z2ErWEtHQlNUNUtwQ0UxQW5MVkpDTFpoazJNcitaRnhmaFcvRTNPSEpNZ2NK?=
 =?utf-8?B?cVYzYldKazlmRDJKaTNla2tNdmlEK0oxUzBUNHB3bmJDRjduR0NqZlI2V01u?=
 =?utf-8?B?TmVDbWV2czJGaVc3Lyt0UW9NNGwyRDgySG5aNGVQVW9ISWVvWWsxRHVNeWpF?=
 =?utf-8?B?b0FVWDhoNUd4S2hSb0NLYlJCNzU1b2VaaXhFOWlDV0V3RkJtSnpidElMazNE?=
 =?utf-8?B?YlhJSUQ4bXlzSkh2U1MyeTFEUXRmb1lBcitYMkcrMTFhbnpMR3FWb04rU0Rx?=
 =?utf-8?B?M2ljVEpvWk5SRG5IVEFMWnBjM1hZTmpGQW5aRXV4UXhPZWJVek1TYlZHcnNa?=
 =?utf-8?B?b3dQNm1pT3JwWFRrazV6OTA1bnl2aDFVR3lweHVJY3doeHhRbEpkbGphY0Jl?=
 =?utf-8?B?c0VRZXQvVWNFaHp5ZjNyRE5DYmp5ci9GbDRWM0FhbGZaNUdHc0N2SVhOeEox?=
 =?utf-8?B?Y2xWOVlZUG5XdWh2OVZPa0RQMXNtQkw3RVFMdXhNaFUvblM1QktqZTc3eUVH?=
 =?utf-8?B?RndvdUNIZ3JjekMyVUZEVFhzeEN5ejM5NnZodGpydVVZLzRqTG54ZjZ4UXJm?=
 =?utf-8?B?Y2xwZnVWSzRPcEZ5TUVKckxGOGZHdEVuMzFqb2RXMW1LQUZkRHdJN3hzV05K?=
 =?utf-8?B?aWNOUFlMbGdLVUNSaU9pUEt3aCtQNnNQUWdLcVJaSkhVT1o0TmEvbmlCUzly?=
 =?utf-8?B?MGRRT0EyU2l2cW9BaVJaQkZxSGp0VzQyMnJpRE1qRk1NU1dPUSt2MnJQb3JM?=
 =?utf-8?B?RWJiaWw3OWFJU3hITVYzdWNCWlJDTDRadis4cjcyRnoyd1RLSWl5NTZXTlpP?=
 =?utf-8?B?ZHFWWStUVWkzZ0JXTkhxYnBINXM4L1czWGNGTmtWZ1JxUnB3SWF0SjJhZXRC?=
 =?utf-8?B?MlpnS0NzUGtrMm9BUytLQURCUTR1Y1ZpUnc2L3hYeVYxVXpLTzMwU0Q2TXJG?=
 =?utf-8?B?Q04xcS9MeHhyMXNwZHlIMWEwb25ZMVZNUVJlTUVyQmJRczVFekZ1ekZyaVBK?=
 =?utf-8?B?UmIyZkNsajVIWHV5NUcvK1R5U0ZlMEx0MGdvb3VYaTJKSzJabnlvWHJMTnBy?=
 =?utf-8?B?dW40aFFmSC8yY01UQWQrRVNVVGlTaVg1U1RKU0xqV2xOWnFpQ2pvSm9kMmVu?=
 =?utf-8?B?VytmczNKSHE5YkFMQW9hUkdVb1Jvb2d3cldFL2FaeFVieDM0aWpRSWw2RDg5?=
 =?utf-8?B?R2hkVWR2Q1BKek5rbHZXODB1TDc1cWQxY2tUQ3kxZlhFNldMS0V5LzhZRUJO?=
 =?utf-8?B?byszVTlKME1JQVUwb1ZzVDM5U1BjVENUM1ExU0cwK3hHOUtSSnJXZjVjSTdk?=
 =?utf-8?B?V0lEU0ZoZFIydlRRWTd1aDR1RlNkSGdBcldteTBQUU9TeG1XTThuekYyRUFO?=
 =?utf-8?B?MjZVb2F0OXVpdmtTb3kxS1dzeUpKQ0J4Q2lMNjZDYmpCNlVFRDI1SStuTWtx?=
 =?utf-8?B?M2JtbDBYZWorL3pkUDJxZUNkOXBPcFUxTlQ3M0U5Wm5SWkJoYlRmUm9ubmpW?=
 =?utf-8?B?NFN6RU9jRDMxcWJYUnB4WWtoTjQrUHd4dWFBam5ucEY1L1pQak1zWnZFeHd1?=
 =?utf-8?B?YkNQTDJYNGhlZUFGZXpnZ3BYQU84ZlIxSzd4MHdrSzQ0ZUZWOFM3MjFOa2Zk?=
 =?utf-8?B?eGI1MmRxeVdVcll2cXZ2RnFaSnRXZEU0dDVxRm1WTnZlY2s5SG5IVkVBR0ti?=
 =?utf-8?Q?ML4mSK8nDUwG6/CyShPnwPk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60938e5-8246-4c06-9c0e-08d9c0f9bf15
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 01:08:33.6921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NGo6y/VZmVq9ZycmhPjFguRBFF6ALFTl0B3Pa+9dZmxWGZuqI6aeaj7Du4l7VBZQjuEaM6Vd1RrvTc69q9jyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4734
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170005
X-Proofpoint-ORIG-GUID: MiqO2UHQpLkUG4vUAhcUTzqkMAWsis5C
X-Proofpoint-GUID: MiqO2UHQpLkUG4vUAhcUTzqkMAWsis5C
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2021 7:43 PM, Jason Wang wrote:
> On Thu, Dec 16, 2021 at 4:52 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 12/14/2021 6:06 PM, Jason Wang wrote:
>>> On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>
>>>> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
>>>>> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
>>>>>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
>>>>>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
>>>>>>>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
>>>>>>>> it ended up with. I have the following questions,
>>>>>>>>
>>>>>>>> 1. legacy guest support: from the past conversations it doesn't seem the
>>>>>>>> support will be completely dropped from the table, is my understanding
>>>>>>>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
>>>>>>>> which is backed by the spec at
>>>>>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
>>>>>>>> if there's request/need to support wilder legacy virtio versions earlier
>>>>>>>> beyond.
>>>>>>> I personally feel it's less work to add in kernel than try to
>>>>>>> work around it in userspace. Jason feels differently.
>>>>>>> Maybe post the patches and this will prove to Jason it's not
>>>>>>> too terrible?
>>>>>> I suppose if the vdpa vendor does support 0.95 in the datapath and ring
>>>>>> layout level and is limited to x86 only, there should be easy way out.
>>>>> Note a subtle difference: what matters is that guest, not host is x86.
>>>>> Matters for emulators which might reorder memory accesses.
>>>>> I guess this enforcement belongs in QEMU then?
>>>> Right, I mean to get started, the initial guest driver support and the
>>>> corresponding QEMU support for transitional vdpa backend can be limited
>>>> to x86 guest/host only. Since the config space is emulated in QEMU, I
>>>> suppose it's not hard to enforce in QEMU.
>>> It's more than just config space, most devices have headers before the buffer.
>> The ordering in datapath (data VQs) would have to rely on vendor's
>> support. Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w
>> vendor nowadays can/should well support the case when ORDER_PLATFORM is
>> not acked by the driver (actually this feature is filtered out by the
>> QEMU vhost-vdpa driver today), even with v1.0 spec conforming and modern
>> only vDPA device.
> That's a bug that needs to be fixed.
>
>> The control VQ is implemented in software in the
>> kernel, which can be easily accommodated/fixed when needed.
>>
>>>> QEMU can drive GET_LEGACY,
>>>> GET_ENDIAN et al ioctls in advance to get the capability from the
>>>> individual vendor driver. For that, we need another negotiation protocol
>>>> similar to vhost_user's protocol_features between the vdpa kernel and
>>>> QEMU, way before the guest driver is ever probed and its feature
>>>> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
>>>> from the device, but we can assume weak ordering for legacy at this
>>>> point (x86 only)?
>>> I'm lost here, we have get_features() so:
>> I assume here you refer to get_device_features() that Eli just changed
>> the name.
>>> 1) VERSION_1 means the device uses LE if provided, otherwise natvie
>>> 2) ORDER_PLATFORM means device requires platform ordering
>>>
>>> Any reason for having a new API for this?
>> Are you going to enforce all vDPA hardware vendors to support the
>> transitional model for legacy guest? meaning guest not acknowledging
>> VERSION_1 would use the legacy interfaces captured in the spec section
>> 7.4 (regarding ring layout, native endianness, message framing, vq
>> alignment of 4096, 32bit feature, no features_ok bit in status, IO port
>> interface i.e. all the things) instead? Noted we don't yet have a
>> set_device_features() that allows the vdpa device to tell whether it is
>> operating in transitional or modern-only mode. For software virtio, all
>> support for the legacy part in a transitional model has been built up
>> there already, however, it's not easy for vDPA vendors to implement all
>> the requirements for an all-or-nothing legacy guest support (big endian
>> guest for example). To these vendors, the legacy support within a
>> transitional model is more of feature to them and it's best to leave
>> some flexibility for them to implement partial support for legacy. That
>> in turn calls out the need for a vhost-user protocol feature like
>> negotiation API that can prohibit those unsupported guest setups to as
>> early as backend_init before launching the VM.
>>
>>
>>>>>> I
>>>>>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware level
>>>>>> 0.95 support, it seems all the ingredient had been there already dated back
>>>>>> to the DPDK days. The only major thing limiting is in the vDPA software that
>>>>>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFORM for
>>>>>> a few DMA setup ops, which is virtio 1.0 only.
>>>>>>
>>>>>>>> 2. suppose some form of legacy guest support needs to be there, how do we
>>>>>>>> deal with the bogus assumption below in vdpa_get_config() in the short term?
>>>>>>>> It looks one of the intuitive fix is to move the vdpa_set_features call out
>>>>>>>> of vdpa_get_config() to vdpa_set_config().
>>>>>>>>
>>>>>>>>             /*
>>>>>>>>              * Config accesses aren't supposed to trigger before features are
>>>>>>>> set.
>>>>>>>>              * If it does happen we assume a legacy guest.
>>>>>>>>              */
>>>>>>>>             if (!vdev->features_valid)
>>>>>>>>                     vdpa_set_features(vdev, 0);
>>>>>>>>             ops->get_config(vdev, offset, buf, len);
>>>>>>>>
>>>>>>>> I can post a patch to fix 2) if there's consensus already reached.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> -Siwei
>>>>>>> I'm not sure how important it is to change that.
>>>>>>> In any case it only affects transitional devices, right?
>>>>>>> Legacy only should not care ...
>>>>>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against the
>>>>>> modern one in a transitional device model rather than being legacy only.
>>>>>> That way a v0.95 and v1.0 supporting vdpa parent can support both types of
>>>>>> guests without having to reconfigure. Or are you suggesting limit to legacy
>>>>>> only at the time of vdpa creation would simplify the implementation a lot?
>>>>>>
>>>>>> Thanks,
>>>>>> -Siwei
>>>>> I don't know for sure. Take a look at the work Halil was doing
>>>>> to try and support transitional devices with BE guests.
>>>> Hmmm, we can have those endianness ioctls defined but the initial QEMU
>>>> implementation can be started to support x86 guest/host with little
>>>> endian and weak memory ordering first. The real trick is to detect
>>>> legacy guest - I am not sure if it's feasible to shift all the legacy
>>>> detection work to QEMU, or the kernel has to be part of the detection
>>>> (e.g. the kick before DRIVER_OK thing we have to duplicate the tracking
>>>> effort in QEMU) as well. Let me take a further look and get back.
>>> Michael may think differently but I think doing this in Qemu is much easier.
>> I think the key is whether we position emulating legacy interfaces in
>> QEMU doing translation on top of a v1.0 modern-only device in the
>> kernel, or we allow vdpa core (or you can say vhost-vdpa) and vendor
>> driver to support a transitional model in the kernel that is able to
>> work for both v0.95 and v1.0 drivers, with some slight aid from QEMU for
>> detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess for
>> the former we still rely on vendor for a performant data vqs
>> implementation, leaving the question to what it may end up eventually in
>> the kernel is effectively the latter).
> I think we can do the legacy interface emulation on top of the shadow
> VQ. And we know it works for sure. But I agree, it would be much
> easier if we depend on the vendor to implement a transitional device.
First I am not sure if there's a convincing case for users to deploy 
vDPA with shadow (data) VQ against the pure software based backend. 
Please enlighten me if there is.

For us, the point to deploy vDPA for legacy guest is the acceleration 
(what "A" stands for in "vDPA") part of it so that we can leverage the 
hardware potential if at all possible. Not sure how the shadow VQ 
implementation can easily deal with datapath acceleration without losing 
too much performance?

> So assuming we depend on the vendor, I don't see anything that is
> strictly needed in the kernel, the kick or config access before
> DRIVER_OK can all be handled easily in Qemu unless I miss something.
Right, that's what I think too it's not quite a lot of work in the 
kernel if vendor device offers the aid/support for transitional. The 
kernel only provides the abstraction of device model (transitional or 
modern-only), while vendor driver may implement early platform feature 
discovery and apply legacy specific quirks (unsupported endianness, 
mismatched page size, unsupported host memory ordering model) that the 
device can't adapt to. I don't say we have to depend on the vendor, but 
the point is that we must assume fully spec compliant transitional 
support (the datapath in particular) from the vendor to get started, as 
I guess it's probably the main motivation for users to deploy it - 
acceleration of legacy guest workload without exhausting host computing 
resource. Even if we get started with shadow VQ to mediate and translate 
the datapath, eventually it may evolve towards leveraging datapath 
offload to hardware if acceleration is the only convincing use case for 
legacy support.

Thanks,
-Siwei
> The only value to do that in the kernel is that it can work for
> virtio-vdpa, but modern only virito-vpda is sufficient; we don't need
> any legacy stuff for that.
>
> Thanks
>
>> Thanks,
>> -Siwei
>>
>>> Thanks
>>>
>>>
>>>
>>>> Meanwhile, I'll check internally to see if a legacy only model would
>>>> work. Thanks.
>>>>
>>>> Thanks,
>>>> -Siwei
>>>>
>>>>
>>>>>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
>>>>>>>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>>>>>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>>>>>>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>>>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>>>>>>>>>> Well, although I think adding an ioctl is doable, may I
>>>>>>>>>>>>> know what the use
>>>>>>>>>>>>> case there will be for kernel to leverage such info
>>>>>>>>>>>>> directly? Is there a
>>>>>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>>>>>>>>>> differentiation (legacy v.s. modern) needed?
>>>>>>>>>>>> BTW a good API could be
>>>>>>>>>>>>
>>>>>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>>>>
>>>>>>>>>>>> we did it per vring but maybe that was a mistake ...
>>>>>>>>>>> Actually, I wonder whether it's good time to just not support
>>>>>>>>>>> legacy driver
>>>>>>>>>>> for vDPA. Consider:
>>>>>>>>>>>
>>>>>>>>>>> 1) It's definition is no-normative
>>>>>>>>>>> 2) A lot of budren of codes
>>>>>>>>>>>
>>>>>>>>>>> So qemu can still present the legacy device since the config
>>>>>>>>>>> space or other
>>>>>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
>>>>>>>>>>> accessed by
>>>>>>>>>>> guest directly. Qemu can do the endian conversion when necessary
>>>>>>>>>>> in this
>>>>>>>>>>> case?
>>>>>>>>>>>
>>>>>>>>>>> Thanks
>>>>>>>>>>>
>>>>>>>>>> Overall I would be fine with this approach but we need to avoid breaking
>>>>>>>>>> working userspace, qemu releases with vdpa support are out there and
>>>>>>>>>> seem to work for people. Any changes need to take that into account
>>>>>>>>>> and document compatibility concerns.
>>>>>>>>> Agree, let me check.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>       I note that any hardware
>>>>>>>>>> implementation is already broken for legacy except on platforms with
>>>>>>>>>> strong ordering which might be helpful in reducing the scope.
>>>>>>>>> Yes.
>>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>>>

