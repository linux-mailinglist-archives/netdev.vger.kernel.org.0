Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC957438112
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 02:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhJWAok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:44:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13390 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhJWAok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:44:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MNt43I001637;
        Sat, 23 Oct 2021 00:42:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fkoGNWMcvZhvzMdOYi0uRPVpDSbkAYMas7IG6USAMXk=;
 b=BVrHmEkwAIbpZl5UXJOQPBex/ToEgYBi3fz4Vl+CCGAYmY9gvcEA9C3Zbd5cHIOHtTTn
 +dMr1x5N0YLNFu4+VcX4EectN2sEbG64WehCPQjMiP0LVXuLR5HMHB6BJUGUrhEwFRiu
 xFaxeNY7NcyL7neINjMpoFtlrlsLPcHMsu+Mghz1SvPBFhJRAmmeIBLZNRbtMwcj6qDS
 nVp1WQr+SXLh0RCcGHB16P/fWKRE/84G+Ke6JMCz4nZgOHwv2RUQi0pRZS4ib+y7wBpo
 k44ms3C5JRvkeMbcsRzlHWnCR/stcj79z9JrNFPn6Po13BMHSPXcXMPDjoGI8GB/TxMg yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bunf9cw77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Oct 2021 00:42:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19N0f2Hl063424;
        Sat, 23 Oct 2021 00:42:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 3bqmsmqvsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Oct 2021 00:42:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSqf3ZYM1QginsUfazXwQlNoVyW6JzsVitdxcOn7x4zNb7+xC0SWLEaVBz/adjN6x8JPzYN+/v7Q7Oz4BQFSAWBOLx/FsG0c+ItrDlWVkPaWzA7ysYZilF2F2OHmse+TyRjRtnIcrLFaMzDW5rNoVUmp/nsCKVE2IS9wK8naxZAoa/XWtg9AJ5bGIDd9XhqyYirBkhp1/rGn3/0udTNc7bPtwDgXrT3PeQqpTS4nwpmedhinCtSXn4E77XQno4cD8qLCqSc0S6p3HkPGCgcPjEFSyw2Q+4GTSTjiRXOw8JXi78105/9HRoxKRZSudLOjOOI0pipj7D3FnGigYRIZ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkoGNWMcvZhvzMdOYi0uRPVpDSbkAYMas7IG6USAMXk=;
 b=OkmFzNT9Fi3iWVtEZ5S4Z0nKj1PTwY97PmfZrqi/y49dYzF4i+W3qxwcRy3jvCRvfePKZvmycoJikDcaYmEwJTgDZWQVV4R+Ig3o8sp1dPpWPkNoNUgn4/1m2Cs2heAzU5BhLkPlE4TZ5t/IAasKK+ucSLWXsDca8f0btFtrJWE4wLX+TugI4BDWYjE5y3oJUAbB1q0qB4XvLrIqWxGnLEeqa3MpHUMXl1zM+RyNwRilUhy3F4LxErWhpC+HnAYPEt4V3Jog7BVJ4BXzi6fhJDse8m/Dd2bS++BrXPwDiKTkRkzMlg0jMXosskZ9zu/z0wVm6wacD0vE95mB4+wyqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkoGNWMcvZhvzMdOYi0uRPVpDSbkAYMas7IG6USAMXk=;
 b=o4lxhzOWtvp3V4o/OLvgcGNEPYFAEa28w85zw3thiFKtxdIVHmZ65EqIzwvnabLOU1/ezzoF50/1wmfBOPBSPFtp3LZChH+0UJgE474H4jE2oBNjwtncaKSe7jM9ur47l1DRlMkJCmzXjLjsWbvAszBQf5bpzh4HOuKoUhUjrXg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BLAPR10MB5329.namprd10.prod.outlook.com (2603:10b6:208:307::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Sat, 23 Oct
 2021 00:42:07 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::3c49:46aa:83e1:a329%5]) with mapi id 15.20.4628.018; Sat, 23 Oct 2021
 00:42:07 +0000
Message-ID: <8fe8f4a9-2f5d-b687-279a-fe2b325d23fb@oracle.com>
Date:   Fri, 22 Oct 2021 20:41:55 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH net-next v2 01/12] net: xen: use eth_hw_addr_set()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        jgross@suse.com, sstabellini@kernel.org,
        xen-devel@lists.xenproject.org
References: <20211021131214.2032925-1-kuba@kernel.org>
 <20211021131214.2032925-2-kuba@kernel.org>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
In-Reply-To: <20211021131214.2032925-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0164.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::32) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.106.110] (138.3.200.46) by TYAPR01CA0164.jpnprd01.prod.outlook.com (2603:1096:404:7e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Sat, 23 Oct 2021 00:42:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de874bab-2360-4c81-8fd2-08d995bdf0d0
X-MS-TrafficTypeDiagnostic: BLAPR10MB5329:
X-Microsoft-Antispam-PRVS: <BLAPR10MB5329734B5FBED419A98525488A819@BLAPR10MB5329.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmA8hhMMlNpx7BSvPh5VupuhTr9fxofGdZDkFfNfHXD6gslJqaa+Y1kxQvettE3yxIH11nkXgytjxMFlHxWeL91CzelUNb9qSGNsVZTzm5JxZrPRMDQx7JL+/RyEJw5qcyC9Wcg85hKB73frqJ7R2FLAAnUG1IEZCzBHbQOlqLLxLx4V8c7ArQ+95l6ZNwnoJOtAZf/rBDx/i+cQTx3prr1m+o5FUCGGTraH7ib7l+RQC+5nDgihlaD/QT6iIMe9VPtOra2re91iXGO9BbXwLzByZjFPcqw8Okmxe95X9lzwaKT8ghIvXmPXepFA3DTg9DI/cr1aE/vgF2/CjP/6zlqgFPT7uUPtPWkA66ivVPp7DBIMZ3AlbJMekIZj7KxmKqXe31zI9+Js+pt7Pf7R4qFsQQkn8Q7PcAM9ZBvyPL5rNR5o6cx9C1PXB6maXNt57Th4qoZRnXMSAobMgN4TCtuLTJ/j8jmGZ/j8Emm/3omuoeg577wy9vH+1oEmh0bUCJF4B16LUD/AQFYZ1RgkoJjcYThOcDfKM9MQsgB/HrdoOW15T8+3ylumhrD0QzkaPIHbiqMbqYpDbrgE3M3ZHNGtbSfybSJmDGNA2fLwZf8bWdka/sOdjR5mzrZF73ZVmPBmUvPXLnC/79TiZbjITkSufMcZ/ZdV3v1WCtD7Yi2NE/CyG0O/COHccH6V2bc3Ep2i8vnqUf8salVz5eNBKMurkKYE0X2cTIw6OT2uD+gKMiHHduBp57m7OQmxvJs+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(4326008)(508600001)(186003)(4744005)(6486002)(66476007)(44832011)(31686004)(66556008)(38100700002)(8676002)(86362001)(2906002)(956004)(2616005)(16576012)(316002)(66946007)(8936002)(6666004)(26005)(5660300002)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVNVS0pERS9pWWwrcUdWcG1rZUY3S012cTU2TkRZbVpKMHROUjVYbkJCL0Uw?=
 =?utf-8?B?Q0daZ0JaQkNGOWdURXZqeWQxTU1CV1V2STEyZ0dIY1NVNUpkbW93R3FSb1Vp?=
 =?utf-8?B?aGxuazB2aDRUQlNxaU8rUjBSeHY0dExVVllWWk00eWhSL2lYUlFWYXM4aTMw?=
 =?utf-8?B?T1l3SDdienc2VUI4bTQ2SWV5VHVOSTU5cHdhdW9tcU5xdmdFTVVsUERiUHJK?=
 =?utf-8?B?bVhheFRmVFlRVUYxd3ZQcW1TMlhINkQyWDQwSjBvQW44dWdMbk5JQlZjblpV?=
 =?utf-8?B?TCtvVm1mMWdSSmlMcTNHcWFKakxCUFRQeU9ENmpvMEJ6M05uVHBRblNSV2x4?=
 =?utf-8?B?SlRNdWtYOS9FTDA2dGh5M0RLSVF3M0ZDemJYandhWUFaYU5aMEplUzczUU9o?=
 =?utf-8?B?VmMxbDF2MzNvWGE3VmJrYzNFRlhxSkxGZ2ZRaXdCWnpSSm1sVlVkeHVzOVlG?=
 =?utf-8?B?eEVnamtjckhwTXRqK1VYQkVGWTdqaDljSmNma3FXWmRyVWpLQ3ZBbnJQZ01C?=
 =?utf-8?B?Y0xsWHhmUzE4Vk9PRUpXdWpFajZpRW5BdU9RR2p6UFVLclF5N3g1SThFSGRE?=
 =?utf-8?B?TDR5Rk9RaitiMnFoZlFqY2ZSclR6ZzZJRm1IYVZLbjdZSDI4Z0tYT3duV1oz?=
 =?utf-8?B?VkFqVVB4RVJxMXpaVjZWTGR3N21HTG9PVXdtZmlyTytWdzdlT1Azb3hjcVhV?=
 =?utf-8?B?UHNCdk9sOXkxZm1CYzdUeEtDT3FNT1NWNDZwRkg2RUlmUStkNEpZQ296bnkr?=
 =?utf-8?B?Z2h2Wkt6dEN0YU9zdEs5Qy9LQzZqT1N0M00zNVlJTTFzdE8vdHNWWG1Ndis0?=
 =?utf-8?B?dWVVWkxSL2RUM251aUg1dHlHVUhDZURhMHlzVWdCS2hXc3p5THdEK2NScEwr?=
 =?utf-8?B?OWdNa1NpNXhsN3RjSmVWV3hXOFk1TnFFMW8zRUpyZ001MG1BUzR0alIxa2NT?=
 =?utf-8?B?dlJreWV2U3FFampJMVRYY2JUeC83TVJxdm9wTGVwcU02dmM4Qk9IYis2QVZY?=
 =?utf-8?B?cEp3QzVLRzlRdmM1cGkzbTBvdE5xbFhvbk1Ca3ZNUEQyMkRZMkJzZ3dzRHlF?=
 =?utf-8?B?dW1ZYTd0REY2VjdLTnN6dTBJWGwvNWZmdnZCSTdWVE1wMFR0VWpVenRpL2No?=
 =?utf-8?B?TFptM3hZc2xsL0s1N2tBR2dTcnllNDd0cW5QampKUHAyQU5vS3h2SGRCV214?=
 =?utf-8?B?bVNqMHM1dTlSeGo0NGNHUHphZ0lWNGNnL0dIVlMrNCs2cFhjazg0L3hXLzg3?=
 =?utf-8?B?U3RwWHM2a0pmYy8rOFBJWnVOMG91blRnSkpkVU1lVWZnTHdtaEtUVEVEMUhk?=
 =?utf-8?B?MWo0K1F5T2FkVjVXNEpqSEtVYkhLU2YrTkszK0RLYWdyTTBxUlRXbGp5ZlBw?=
 =?utf-8?B?a2xhbTFhaEtxSnhKWlV3amE0QTdXNUJFc1RtTEZ3aVVRNENsQTlZdjB2ejEy?=
 =?utf-8?B?RDRrS1J5c1k1eGthWDNkRWlUOWo0bkF5TlNuS3RPRERMTHU5Y3NHNHR5YXpl?=
 =?utf-8?B?cythcjB2clByaDBVN0lOYVlkZUMyZkd6Qk5JOE9TN3NGVlNzcVBHeENBUGw3?=
 =?utf-8?B?bkxVNlB0S3lDOUJ3Mm9mZEJlMFoySE9lUEE3RzhsM0ZmYjRWZXY0L2wzdXBL?=
 =?utf-8?B?QndIeXZLbHIyMEF5d0llRURWeDNkQ0NHTWx0YzV6N3NnSFRYWFZlQTk0bmpU?=
 =?utf-8?B?VS9uYlpiM3hXMVJLZFp2dVEwVU0rbWtDaE1hYkVUYmc4eEJpN1U3YlNLKzVq?=
 =?utf-8?B?TkdRcis1OVB1aUFyUVFDenFnWnpNRG5VYzlFS0thbHNZY2JIRG1wV21EVnh0?=
 =?utf-8?B?K2hhendMcms1RmZoUXlXQWVnMjg3eVlIS1RCNGRvVjhRV3hNZ0o0Y3IxaU5s?=
 =?utf-8?B?TVBLT2xiVmlhNUVTWnROT1RNM2IrMWlwQXJ1NStyNU1kM2EyMEc0WXBIZDIv?=
 =?utf-8?B?RVI0SUd2ZlJFVnRUUG1aVVoxeUFMcGFoTGZodHc5Umhzekt6ekhjK2tmRUVS?=
 =?utf-8?B?N1RSQ1ZENjg0OFlCZjlYbGJBa1l5Rm5GdDJTQnI2eStYK3VhNzl1TnFhRXhZ?=
 =?utf-8?B?QUt5U0lXeW9xeE9EanJhWldLaFcydGNQYmJhaS9EQUhaUXI4YWo2ZEVOMTZn?=
 =?utf-8?B?d296SldHUWowRVV6RDdFTzhDTVhQNHBjSndMNFlxWll0R1pKNjQveWVNWjl3?=
 =?utf-8?B?N21NakV2MDRSRlRkTnhiYXk0Y3FseWVSUWo4SW5NUGFmS0d4Zm5CejJVWng4?=
 =?utf-8?B?OGdYSFZDL1JPakZEeDZJNVlLZFRnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de874bab-2360-4c81-8fd2-08d995bdf0d0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2021 00:42:07.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1GVZuB/m/LmTmEYPqHafaIHyXx5WsHNHH4s8+CZT2GUhL3u9wQIRvKBVU3rBVNFivlZ+VE7ZQMJqM3LATgrXC+lDyeZiYmEZVpt1d9spiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5329
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110230002
X-Proofpoint-GUID: 7Lm-O9rqshsbQzcIS-vh4XS34YF3hfZW
X-Proofpoint-ORIG-GUID: 7Lm-O9rqshsbQzcIS-vh4XS34YF3hfZW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/21/21 9:12 AM, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>



Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

