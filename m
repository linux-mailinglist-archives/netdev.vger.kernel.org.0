Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E03946F4E3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhLIUag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:30:36 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4562 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229850AbhLIUag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:30:36 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9K3pwm012288;
        Thu, 9 Dec 2021 20:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=v2GzSn6Wyzv3JCFmkt7FKvU7tkKafGvzwyYUYXfytn0=;
 b=fSL6XxNSUFFoPEHPivdWqCBcNobBzywnNxHqIVIR9KB/DX/Xy5XtP6nSqN+sYCXBCwIl
 86lRd7w71rbyVcSV9n1uy1MNe6gteOSAeOMbHFb+sSioFIJWV2s+sAA50bxjXZAqTarM
 Ogjak25mdoVN67sRMIY3p5H/e11e3fM9q7UrCy72R1jBaoBOwByW8p4B9qEwJY+Xc5XC
 l81MGq7kEkZepr+P1/zQqOZNsUua1pTtl+Cp/FKtXpg114lNS0NC75jTVS1uYUVT1B5c
 8AK9R6WVMzz6iwQpN1oZfzuFbcs3TOzdOt26O+558BmXz+G0FbGmRGWv0Szu5uawCXfg Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctrj2vpc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 20:26:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9KAnnK016747;
        Thu, 9 Dec 2021 20:26:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3020.oracle.com with ESMTP id 3cr1st3hkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 20:26:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oro9tDE8dPO5I/MpxZ2cacKO04+XuZAjZJ3pyowFQaTO9j4BASxSgPlw/m5Y150SQagxrvqRbzN7Hm1Td7mgXKr8QIYCpw9HlJzvdBleIfHRDXMHh/KJjEYcMm8kS5TztCWVxm5tZJ71VkdqCD45HXJGPHrUXlGTeN2i7ycBMQQVRmeEGi0p3KTrA3XGtGckTmDr+1PrKfYFABXIAW7jZFyICCqQkb3m9zwqcyhyJGSMUraPyZwISUMFJ2735MfAlN6zdGgGl7jUD98SiGA+G2jFaGUy/jE1v+6szHFy38SD2+ESZEfpbOTfAIriII+/ahO90UB64x0Rnf9JDJPbig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2GzSn6Wyzv3JCFmkt7FKvU7tkKafGvzwyYUYXfytn0=;
 b=oNqjgbzOfXi9TUkI8Z+GQkbPQe3mvHlptIJVS4kEGIfRZFhHh9OnhqsyXtYZs7G3yMXuG4ldug0Ibo7u7Me3za17vlyb534s67rfzI1qaua6ca8ny3EPkKoZf46ANGARHPX1+8b5RukLuS6utZl9XCvP8+2eHke+53ApwbAsf/S5RFEHnPWVn4yGz8R5qkJxwpCJv8Qh9m5jV8VwNsI6yfx2zwlgsbdsFnnv5hbVevj/YFy+xyzVtaABBJacKGBao3yLLeVW/nukQhXNlSEEcy7bc96nrMKFmdR5J1bKSGTCenIW9kaFiIlDpBJIdXAlO5OIwEAOpyXmDvYC9XL2ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2GzSn6Wyzv3JCFmkt7FKvU7tkKafGvzwyYUYXfytn0=;
 b=Lzvhh16h7NQ2kSrct767MCbDVl2j7oXmraJcTupyKgqdcoHXFQ0v0ItxJS0dZmRJGiZPVXWP7XOx6WcUvNzadtxonzfZD4RZQklreB+H+UIx92WEgMlhd8ACWkE52vFGGGufIazd8Bj4WCvXg3jKFqSKTD95XKqKFuBRBWMRC+0=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB1635.namprd10.prod.outlook.com (2603:10b6:405:3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Thu, 9 Dec
 2021 20:26:48 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 20:26:48 +0000
Message-ID: <4ed8cace-3b2a-8cb8-43d9-bba1c342a3a5@oracle.com>
Date:   Thu, 9 Dec 2021 15:26:45 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] tun: avoid double free in tun_free_netdev
Content-Language: en-CA
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
 <YbDR/JStiIco3HQS@kroah.com>
 <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
 <20211208083614.61f386ad@hermes.local>
 <b141489b-780c-1753-2a83-ccb60c4554d0@oracle.com>
 <20211208155838.24556030@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20211208155838.24556030@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::12) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from [10.39.248.41] (138.3.201.41) by SA9P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 20:26:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8713cb34-dc64-4c33-c046-08d9bb5239d6
X-MS-TrafficTypeDiagnostic: BN6PR10MB1635:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB16357F22C3C7610068AC3670E6709@BN6PR10MB1635.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4ZUPQmVF6EYWSQZgx0nms5Tt3eVRpHht/OebZEzli1m1PxNjBVHX+UYFpDPxL0brZS1/+b5sKs5tigxwX6lqDabrzF+K79cOxSmyHE56CIcljyRGt+fklLpPkT0BM2nxRPt92PVSg0YDkeQ2UFsgjh3C4K2duk9eP6yw5TccY7/VLeU8GPLj4QPsmr4Y3+g/NC+JrbXKp0d9Ok2JbclOl8xHGetzUyIf4TaC5L479IM4hDpOKj0ViyfGG7FN1ZLZCYx0CSCZd663PlPFemhzIjaz3o5QsuKFw0pzrkdyIlKjfG+dByuLC6lsoW5ML5x9HHQ7FgjilaPmUdXYk3kO+jyqLr71lcLKhgPZFcyb7I9ovA/WVyg2MrFtLU9D2v8/CnCsSbNI+1LwT56pxKVGCZmYhV+iCFQ/QcF8yXqSTInkvEpO2r7EwGfV70M1Or0zokI1h0WLJGIuCyF/TZGD8qUpv9iArpfyEbb0Z86QgDam+IydoWnBd7JQRA5kHp381TnP8QqKKUpleWCdphj6322zSrRYiJAOtdEYxCQ2qX70UD5XhxfNTdDTXXo6oQlxlWpd1LycK/Nf8HltbB+terqCeJ+h9Z49s/2pEE+M10uQm6o/+vOhfSyY3MdWlYhRo8npBNKHVH94JvJq0bZ5NPKOKDckay9uriXT7Hwrf8bg+MpYyYP3zZN3gZC5x2mIdxISVdqiWDXz+WJ2BILzVefM35N/3X4QqTaiIQZnyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(53546011)(66476007)(66556008)(186003)(26005)(8936002)(16576012)(6916009)(66946007)(508600001)(2906002)(6486002)(36916002)(316002)(83380400001)(31686004)(86362001)(36756003)(2616005)(44832011)(38100700002)(31696002)(8676002)(4326008)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTB2Q2t5WUQ5czcwVk5RZlRKUGFTVzlwSks2UjFGZnE4a2cvMkZVSFVXbnRT?=
 =?utf-8?B?YXY5eldiUy9KSjVqNVZXbEZtdHUvYXlNTXpSZEZBREJSVVdYRTJlbzEwVWNx?=
 =?utf-8?B?cldUOGR1MHZUVnQ5TlVzOG5SYUxpMnlBSFY3b2sraTZ5M2VrT0tJWjRGS0Fo?=
 =?utf-8?B?UnIyYW92WGJvek9nc1A0WW9hMXkzcVVwUlVuNHFvLysrSFFpMlpkd29zdXZL?=
 =?utf-8?B?MjJpRm5mV3IrM3V0cmZMbytFSTRucTBsOVVUYXgwZ2lsRWtFa1Z5dWtDbzZI?=
 =?utf-8?B?R0dtOUk3dmFieVl5TjJrWkJxZG96bGs1RzM3ZjZEUEFmVUhXMjZsRGxHM1Na?=
 =?utf-8?B?bDVNb1dVTXVBenhGb3RZNkVwdXBBVkplSVNabTk2NjBtK0FueXorM0NsYkhG?=
 =?utf-8?B?MmFOWWlUcGVJZEVXVVBaeDFmclRNdFVXaWFLeTdrOC9KdE12Njg1UWdyM2th?=
 =?utf-8?B?TmhWZGk3RDdtUlZ0cFQwVWovN1FKVEN4SGRZUnlaaFRrSFZpa0JEanhNbWNo?=
 =?utf-8?B?ZzJGb0FBNG43Y1VSb3ZxQUJmZ0xCMHU5b2xPRlVidUh3dzVNWEdDcThCbWlo?=
 =?utf-8?B?RzRaMXV5NHRrUjRwV2w4enl3WFJ5V2duanE1T3ZUbjdCYnNUS0lGcTY0SVE2?=
 =?utf-8?B?ZVc1Vlk1S1ZLNkk1RlB5NzdWdnFQaEhEUW5xY0dxUit6NU9RNlIrbmo0VG1a?=
 =?utf-8?B?Zkc3UFNlc0xkWVY2NVdDSEtuNDVjbEdzODhmekFEMzNhc09yOXNUQXdZcVRL?=
 =?utf-8?B?c2VFTXFMUUhlSmpjVmJyaDhBTmVOemdnalZzQU5Pd3laWWJOTEdteTllZk9s?=
 =?utf-8?B?QnZuSU4wVTFEQnpUM2VSUmhNL2tMbnNPYS9qR1Z6VUhvbFNUci9IWXgxbFRr?=
 =?utf-8?B?bW9VTVhoMWVaZU5HSERoR0xDNHpiZmdaYkJaTTdOcVAraXE3RTBQSkwyUU81?=
 =?utf-8?B?Q1poYVhlY0hrRkJCWThrRDFwNjF4bzFaeUVVUHFwYVg2OWx2ZnlaUE1CNjNt?=
 =?utf-8?B?VVY0T08yWFhBRHlFZlBsRGtyMlQ4OEcra0tncDJHcHc4c2NLTjlRWW5YdzQx?=
 =?utf-8?B?OU1ERDF2WDZnSmhrek5yT0wvRThQQTg3RXkyTWtQQkdTbUF6cnZHeVdJU0Zk?=
 =?utf-8?B?SmFqbXg2U3RRSjZyOWZtVjlOSWJSOHFDek15WWRKdG5Ma21ZT01IczdaSGo3?=
 =?utf-8?B?b1hBYlFWSWRpbHRiRGtYNmpQc2t1L0FyU1FkK3lOVG42UmFHWUNKWUdnUHg4?=
 =?utf-8?B?TVRHN2crdzNGMFZxMXZxS3k5R3ZKSGNTdXhEbFN6RVdWOFBEeklOcFFIWC9B?=
 =?utf-8?B?Ry9RTGwyQUpCcS9hYUR1Tm5xZXJMZjJoWkxHZS90dlBLTHV3ckZTdmdzWU4z?=
 =?utf-8?B?VldISlk2cEVpczhwMHFWWXJPZndNMzY0N09Oa0hVQi9wM290Ynlwbnc5QVBx?=
 =?utf-8?B?WXZ3eFRlR0lKRVYybHdxVjd3K3lOR1poK2k2d1U0S3hWZy9PZURWcVNJbi9C?=
 =?utf-8?B?UHgvUGdqaXNWeXNBWmR2UHB6NU1TZzVVZ1dwei9oOXFPQUhNTU9SOGFyTXF6?=
 =?utf-8?B?N3VWbHFMQjNNQURYeTR4RWFVa2N3SWNEWk01UjJpYis2ckRWUTdmYnI1b3Ew?=
 =?utf-8?B?TkM2bGhwbmNqbitKaFFYRjRKRWFlcFp4RlZBRkcyYzdOOWlJY3VQRk9ZSng5?=
 =?utf-8?B?WkF5OUlOYm5BK2tLbVBUQngzVEVRYjhuenlISkkyRHRBYTlzbVRpMi94dVBB?=
 =?utf-8?B?QnhIVWNrTGpxTzFiem9FQkFjTHVXZVBaN2dsR3YwUHZKNTlSMGYxWDFQcE5x?=
 =?utf-8?B?dGh2SmNzUlBjS0x1QVJyY0pvUDRvUGh3cjVISmdlRjd6bmFrYUZpZnI5Q1NL?=
 =?utf-8?B?NjczTmJYRC9mNktkZmMxcjVGWjRwdVFHbXBsdUZ5MDVmOVMxMW94VDJ6SzBH?=
 =?utf-8?B?YVdhMnc2SDVZclRCazAvMlF4UXE4VFVUNEtEekZjOTVEa3VlclczbGREaUJi?=
 =?utf-8?B?MkRUU2xPWFpMSWVEdWVpUkI0Mm1rZlNqd2VWMEJmZHJYRWJxTWE3MnZkSGU2?=
 =?utf-8?B?WlhWKy9IUVcwQ3hPRkRkNzQwbzltVjRRTmZ3L0dMZWl3RHZ0dFg1RDhmb2F6?=
 =?utf-8?B?ekZBcHRLbFZEaFF0OWdEK1BCQ0l4bEovMzZ6VXpleWY1WkxlNzVqb0xSeHhh?=
 =?utf-8?B?d1NmTTAvQkNSaXJmVzFENDlZd0diYWhacUc2dEFld0pvMWxuWFh4aEdSTTdE?=
 =?utf-8?B?NHlaOElmV0V5d2wwckFqK25tbzl3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8713cb34-dc64-4c33-c046-08d9bb5239d6
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 20:26:48.6566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRNcXBmtniykLyN5oIAUzyQZ6kjEsWc/nBOp5pP5+MCxnzKvAub3+LHHFsN/rMvtTGFkn3ZK+BT61lPcw6Hkbwuf2piHhIhO3hRtwpRdhks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1635
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090105
X-Proofpoint-ORIG-GUID: qNAm6tpE4du0Odoz-up-WTLWDcHiADKl
X-Proofpoint-GUID: qNAm6tpE4du0Odoz-up-WTLWDcHiADKl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2021 6:58 PM, Jakub Kicinski wrote:
> On Wed, 8 Dec 2021 11:44:02 -0500 George Kennedy wrote:
>>> It looks like a lot of the problem is duplicate unwind.
>>> Why does err_free_flow, err_free_stat etc unwinds need to exist if
>>> the free_netdev is going to do same thing.
>> Maybe instead do not call security_tun_dev_free_security(tun->security)
>> in err_free_flow if it's going to be done anyway in tun_free_netdev().
> That won't be good either. register_netdevice() has multiple failure
> modes, it may or may not call the destructor depending on where it
> fails. Either the stuff that destructor undoes needs to be moved to
> ndo_init (which is what destructor always pairs with), or you can check
> dev->reg_state. If dev->reg_state is NETREG_UNREGISTERING that means
> the destructor will be caller later.
>
> The ndo_init way is preferable, just cut and past the appropriate lines
> preceding registration into a ndo_init callback.
Thank you Jakub,

Looking at other ndo_init's to try and figure out how much before 
register_netdevice() should go in it.

George
