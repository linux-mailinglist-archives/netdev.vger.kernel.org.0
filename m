Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67285473A17
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbhLNBOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:14:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39986 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240325AbhLNBOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:14:12 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDLKoE9005506;
        Tue, 14 Dec 2021 01:14:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2cL/jo5XIVZwXWnG6Wmy4DscN0cHslVVZRKpROk7nHs=;
 b=ucbgQTcJLCRl0apMNRpuWCXcI1oly8LDFiknmt4gMNKAnsrQj7VcYJOntSMbKEMY/H4d
 2mjoB9X+A+Lk89PPZFNHAsBzle5Rd14mMdLWoyRqXnCIUsDECODoXTaRGLCZT7nSHUvh
 huO4lY450mjTCvlpUInsrm9nQFqT35jMBdyPWJSXyEUT7mGI//Yu72nvWA1kS+2E3baX
 ZarSH7ndI23wr6j3Oq2Jl4Z2LO1bV9YmJdN3oy/jsoyGF6v/Il2uObCQXLVaOHRG9J3i
 5MW+AhtASVTK1SwnXwQrw9Eq19u9HT9jlrtfkuaY0SqOYGeFapxdoeQH6UtB/t2RX8+L Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u22tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 01:14:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE1B30X041862;
        Tue, 14 Dec 2021 01:14:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 3cvnep2f4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 01:14:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGgPOh3RmItKwJvSuHIZYlgY1/4rfPTZMh2hBQRo5FHaX5rH8EeZgOz719nvG4Z9xZYe69oY6kNlL/UvYX7tj6rlVew9daP05EagXd9Bsa9Yo4JBclVDaFLcamfE39VBwRiPTk6ljlZLsdGAlKoU3/f94di5EK7h15hDYsnDWo80N1sEgjlbzidUUrO4huDol06/K/c7PfNnfscG/Ek0UIzbfWmvnBdSQV1qQ18EugHvVqbrequvJ5VcjkZngyg0EntFvXy7R3Cwh4HftMUj9HNRn0rmeePGxgSfCTOwg022QosUNX+yUh1ahvnMYK9q0IHw0p39mzPEw3dg+4ja6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cL/jo5XIVZwXWnG6Wmy4DscN0cHslVVZRKpROk7nHs=;
 b=LwQXDTHY2v74DxCkRWf2JbTXaY2oqzzym+oLmxwjCoaP2zhfKdDWGAvD87DtvaYwri/k0xCvCUP10lSHJDWAliq50FiUIYIwd3s2I3ZFrnMqTqw6i6OIJyHSU+i/xSkBaCF0gHw/aG1DURl0poW09pB71TBahkpiDhVmzeEYKzdjPWzWbTtFQe/4Pq6WiBvbRCuHC87KvqjieTGJXqEkhhR7JcRXfSOehLdsOu9khvW1alWNuthlyhjRUODWmw2UDzjawObVqBC5NbBXzH5lYS8k7nix3mvYFGd3mzn1nWiMuE+EGgXL6t8nND1HStl0AQDGgzr2ocZvjOWJCnlnLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cL/jo5XIVZwXWnG6Wmy4DscN0cHslVVZRKpROk7nHs=;
 b=OzvclFjqjBa0Uy+qydtKGiwxu/rQMtbIXyS7gs4OjVAFP0ja0WjzXyd6U4d/cFONs4bXS69KiqExhEw3PrkJyylzz3F4bSokfh+TxzdN6xkY0EkDKq1ElwdTo1A89C6VKDLVrTtvBN44/CXay5TdHCqU6JDItMNfgupRfEqvJQg=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 01:14:02 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4778.017; Tue, 14 Dec 2021
 01:14:02 +0000
Message-ID: <d9dbb500-a7e2-2f30-2f5a-b700f25eda7b@oracle.com>
Date:   Mon, 13 Dec 2021 17:13:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <CACGkMEtwWcBNj62Yn_ZSq33N42ZG5yhCcZf=eQZ_AdVgJhEjEA@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEtwWcBNj62Yn_ZSq33N42ZG5yhCcZf=eQZ_AdVgJhEjEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0347.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::22) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec904fd0-a963-4700-c42a-08d9be9f03cf
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47676102DCC09885D827E636B1759@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLE+1JEJpGHZ2YQhWaLUA/kgpyqN163v13t4NiW7L4e6kXbvuCNvDRRYUg95sY+aeLxICilRw0vWbWO89/Od1t291P0YLSZjByAp+Fmi7uQISeXOsOqU3hHY6QnP2xh4iYFLNIuGcXerJWVGsTlB2AQ/X4GZPxjiP3NUi+Q3+so+cy9rZKrw0sOmgTb1t64Mm8J1fis8/3JyYdMuXem4t6If0XiBFi7gC3ePKVHOP6R5LC01dFo0OkiR98XNRxeosBISPJ/ZV5f65xlweq2rbCVNXNph6oFP5w4T2DSOlkpsDmSRrGoulLkPxvw4+UBgyLrGlq7rO90bWu9bUBBeZSUYp4aQgploaoi+asDaWW4ep4KwFA+heBfpNNSvpX0SMHpmf2bPVM/Qvv4wzr57rYO+VYc+blEVt+87zXSUTB/KMQFgqjEU8bHar3JFpME54z4b7C8qBJ7o5ZyrMgmpBO8AbHSHn8xaCqkwwcEQtttGPN3zwiVYl39Rd0XED6ltKFprsht+6XUYv/ihgFxnCAHBQC1Gk2+8iKpa13F3IqoQ1sw4Phmey+PPqBcxD/p1Q+mWJA+Or3iAKt0Z5SGHN6sgAasmTqcSBO81O8oO8+QaNdD7noADmkCcMnuJPKDGHxvSzlT352cdkQGVXkM8vUgxi+Xat3h3WQVGkxWA7uZVSCJuFZnkjnInVQGbjAMTS3qv3iLKlDxQw8frx2c/AIEe+GP+NqZQGt/7taxuWmPo20sgn88+qXRGz1RuISkWDc2YcbtAUsLV1sNZ7dx8yZonUIvjxF0d1d2NI8qqFKIhhQXLPZ7xxftfE/N6KnTb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(8936002)(38100700002)(2616005)(5660300002)(31686004)(86362001)(31696002)(110136005)(83380400001)(54906003)(36916002)(316002)(186003)(2906002)(36756003)(6666004)(6486002)(6512007)(66556008)(66476007)(4326008)(66946007)(6506007)(26005)(53546011)(508600001)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkpDNGdNaDZ0UklsSHJOakoxc3lLanJsai9MMHZJM1FqRVFCUHdZSE1JdzIy?=
 =?utf-8?B?dVgvM1hvcnh4RzA2NURINFdGYk9saDlQbHZiTTMrb3BHb1dtNHVhN0R1ZnJY?=
 =?utf-8?B?OW4rd3E1VXdtWHJZMW85b09Rcm9uVFN3dGUrRzRjRlhaVFJSV0txam5adXY4?=
 =?utf-8?B?endha1BSVFc5OWQwOEcxU0hRM3N4eFd3QU9CaUVhd1JRVGdjUXZ4Q2xicEg0?=
 =?utf-8?B?NS9HT2NFMHYvZlBXSGE3NUozR2VQbkVWYTVvVUREbHo3YVRSTUw5U3l1U1pw?=
 =?utf-8?B?Vlg5Q2pUT1lWSlErZHFUSTN5NmxKaHplN2hyaGJobVhQcU9PTko1WlBpTzhj?=
 =?utf-8?B?MW16OTJmQjBjWjJHVFlUNUF0QUgvRGlPcy9Oa0JYV1V5QUdyM05aZUp0NHFB?=
 =?utf-8?B?VmdoSmZ3Y0JvL0ZVdDFPU0xZL2t2dWg3UDhJeWVlbkhISFJ6Y2lmTjZNY1Qw?=
 =?utf-8?B?eUdYSHhSQ2lOQU5mdTNnWG9FNkxtOUw3MFczV3hOa2pBaGE3WjhLVkRVRmhh?=
 =?utf-8?B?YXRYc3ltTmh0RnJSWU5NVFVZWS9VY284ZnB6eWd6MkttdWUvaVFIZU5hbGNI?=
 =?utf-8?B?d1g2dzJmTHJRQWtyTVBGcURqZmhlZ0xleElDT1pZbnNtMTIyOFdLUHJCaE9Z?=
 =?utf-8?B?ejZVcGk3K1d1eEcyZy91aWVzY09abnJQK3ZVcmY3dG5xZlo3NW10QXJuQmxE?=
 =?utf-8?B?eC81YU93T0FWOHFSdlZvLzBzZDNXeUErUkdQSGVhTTBoVlY5aXJ6R1JkUW1Z?=
 =?utf-8?B?c0l6TGE1RlVTRnhXNlk5Q2ZlQzEzbVgyZWRHRmxlQmlFTFFCejd3R0lSYVZI?=
 =?utf-8?B?M2E2VDMzZkhzcXB6aVhWQTdna0thTE1IeFo0K083aVpjSjBoYk4xMGs2ZFJw?=
 =?utf-8?B?R2Z6Zk9XMWxoWnRMQjdZTGpGQ1UxNzdXYlo0QzRCU252ZDJIRTFURWFzT3N3?=
 =?utf-8?B?elZ3c2V6OXBqMWhJZzFkWTVFY3cwWExOV2F2YzZSdDVMMkowSXF1NnlVdWpS?=
 =?utf-8?B?Y2Y4ZTQ0WWovUjFKQng0MVAzRXhjKzhBNDlEbW1UZ2M2UDB0SXV2MThZdGY2?=
 =?utf-8?B?YWJVYk5xb1hYb0VjZjhoMUllNC9abEVocERqODJXb0VtNnRRYjNabnNoeDM1?=
 =?utf-8?B?STZreHpYeTRHdTNiVXpQem85aHVOVU93VEFwNTNrTm9KTWlUdC96d1c1bUJC?=
 =?utf-8?B?OVoyVUdnWktVRTF0OCt1Um55L0hzNUFsKzV0M0QxU25Kck5qSUM4Vjg2cUxJ?=
 =?utf-8?B?QnE1RUJWZFBPR2tpcGpOclpQS0hPb0NtWFFXS1pqMytJNGdOWlB3MWVzOFAv?=
 =?utf-8?B?azNHbnVxVFlLUzdtTGtHakZhZU1FQkt5dFh4NU9yaHRsM2h1VHlRb2lpN1Bq?=
 =?utf-8?B?MHoyM05MK1poM0QydzVwWXFBZEE3R1VaU2xpK1NoL1phODF5TUtBLzdEenVn?=
 =?utf-8?B?UWNTVmFkKzZISGtSVnpQdllhOWFIL1EvVkZYd1VrUUZnaEFBaGM2bEMxUkNV?=
 =?utf-8?B?ZWgzdkkrOGZRT0Z2NzNFUTgvaG5nUCtVU3J3VGhEa0hLb0Y5bE1TMlcraHRP?=
 =?utf-8?B?ZmVORXFNTVlPVVdtTHBoUlBzS1N5aUl0WUhxemQzdFhVRkd3eWUyeG92Vm4y?=
 =?utf-8?B?WG9tcUJQclFUanhIM2tkNU9GaGR5Z1M4OGVzVmlCdURFcUxWMUVEZTlJeEFD?=
 =?utf-8?B?OHdDOGRNZXk1UklXM2JVY09XYi84QnNCdHYzcEEwcEMya3JyV0RFQ1NvV2dK?=
 =?utf-8?B?WDYzcmxTb3F0MjhFRHN3MjhxSW9qTHVacTVGcXpDUHZ5OHYzRnJnb1d3T0FQ?=
 =?utf-8?B?SzZLWmM1LzMvYkdhellvR0QvVGd2TDB6dk52WE1hTzB5cWNxQksvWjBBN3E1?=
 =?utf-8?B?OVB4aVNYeDJqY3BCRTZ6ZDlmYVc5ckM2YXdkMFh1YTcyWXcrNGhwZVAzby9h?=
 =?utf-8?B?M0hNZUgrSXRZR3kwT1lpRHBLckFrNThwZzlUbkhyTE13UlZtc1Q0eU1hSVdE?=
 =?utf-8?B?amE2aU5NcVdCdFZFOXFJV2ZtVnFRQ0h2R3RTOVdMcVBpbm9tT1dqUlpnd2Jm?=
 =?utf-8?B?WXAxNEhRdVlxalhiS1ZNUTRLcmUvUnIrcWRVYXNIL2k0OWlYeW82RlUxZWV2?=
 =?utf-8?B?YlNaZ0JLZExMRlZVTGxxOFZtNWxhQmNHeGpFOHVaeElHR3FaeElXcG9sZG5l?=
 =?utf-8?Q?f3VXDOZC4qaxP5pvVxKf7tk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec904fd0-a963-4700-c42a-08d9be9f03cf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 01:14:02.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GR4Wds7CWFFTkZgOeXic7OqaRhq1qmyIhOJ4dfw4luunucbQlFSfP06TF8ZGDViAvveAZZBhbrKh7I8WZNGZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140003
X-Proofpoint-ORIG-GUID: QR03XNv6uBmnnQJkCXbA9GhKTe6KeLQT
X-Proofpoint-GUID: QR03XNv6uBmnnQJkCXbA9GhKTe6KeLQT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2021 7:02 PM, Jason Wang wrote:
> On Sun, Dec 12, 2021 at 5:26 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
>>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
>>> it ended up with. I have the following questions,
>>>
>>> 1. legacy guest support: from the past conversations it doesn't seem the
>>> support will be completely dropped from the table, is my understanding
>>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
>>> which is backed by the spec at
>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!f64RqPFbYWWTGBgfWLzjlpJR_89WgX9KQTTz2vd-9UvMufMzqEbsajs8dxSfg0G8$ . Though I'm not sure
>>> if there's request/need to support wilder legacy virtio versions earlier
>>> beyond.
>> I personally feel it's less work to add in kernel than try to
>> work around it in userspace. Jason feels differently.
>> Maybe post the patches and this will prove to Jason it's not
>> too terrible?
> That's one way, other than the config access before setting features,
> we need to deal with other stuffs:
>
> 1) VIRTIO_F_ORDER_PLATFORM
> 2) there could be a parent device that only support 1.0 device
We do want to involve vendor's support for a legacy (or transitional) 
device datapath. Otherwise it'd be too difficult to emulate/translate in 
software/QEMU. The above two might not be an issue if the vendor claims 
0.95 support in virtqueue and ring layout, plus limiting to x86 support 
(LE with weak ordering) seems to simplify a lot of these requirements. I 
don't think emulating a legacy device model on top of a 1.0 vdpa parent 
for the dataplane would be a good idea, either.

>
> And a lot of other stuff summarized in spec 7.4 which seems not an
> easy task. Various vDPA parent drivers were written under the
> assumption that only modern devices are supported.
If some of these vDPA vendors do provide the 0.95 support, especially on 
the datapath and ring layout that well satisfies a transitional device 
model defined in section 7.4, I guess we can scope the initial support 
to these vendor drivers and x86 only. Let me know if I miss something else.

Thanks,
-Siwei


>
> Thanks
>
>>> 2. suppose some form of legacy guest support needs to be there, how do we
>>> deal with the bogus assumption below in vdpa_get_config() in the short term?
>>> It looks one of the intuitive fix is to move the vdpa_set_features call out
>>> of vdpa_get_config() to vdpa_set_config().
>>>
>>>          /*
>>>           * Config accesses aren't supposed to trigger before features are
>>> set.
>>>           * If it does happen we assume a legacy guest.
>>>           */
>>>          if (!vdev->features_valid)
>>>                  vdpa_set_features(vdev, 0);
>>>          ops->get_config(vdev, offset, buf, len);
>>>
>>> I can post a patch to fix 2) if there's consensus already reached.
>>>
>>> Thanks,
>>> -Siwei
>> I'm not sure how important it is to change that.
>> In any case it only affects transitional devices, right?
>> Legacy only should not care ...
>>
>>
>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
>>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>>>>> Well, although I think adding an ioctl is doable, may I
>>>>>>>> know what the use
>>>>>>>> case there will be for kernel to leverage such info
>>>>>>>> directly? Is there a
>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>>>>> differentiation (legacy v.s. modern) needed?
>>>>>>> BTW a good API could be
>>>>>>>
>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>
>>>>>>> we did it per vring but maybe that was a mistake ...
>>>>>> Actually, I wonder whether it's good time to just not support
>>>>>> legacy driver
>>>>>> for vDPA. Consider:
>>>>>>
>>>>>> 1) It's definition is no-normative
>>>>>> 2) A lot of budren of codes
>>>>>>
>>>>>> So qemu can still present the legacy device since the config
>>>>>> space or other
>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
>>>>>> accessed by
>>>>>> guest directly. Qemu can do the endian conversion when necessary
>>>>>> in this
>>>>>> case?
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>> Overall I would be fine with this approach but we need to avoid breaking
>>>>> working userspace, qemu releases with vdpa support are out there and
>>>>> seem to work for people. Any changes need to take that into account
>>>>> and document compatibility concerns.
>>>>
>>>> Agree, let me check.
>>>>
>>>>
>>>>>    I note that any hardware
>>>>> implementation is already broken for legacy except on platforms with
>>>>> strong ordering which might be helpful in reducing the scope.
>>>>
>>>> Yes.
>>>>
>>>> Thanks
>>>>
>>>>
>>>>>

