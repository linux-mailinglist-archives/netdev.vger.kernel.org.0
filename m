Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82380378F85
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbhEJNl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:41:59 -0400
Received: from mail-vi1eur05on2103.outbound.protection.outlook.com ([40.107.21.103]:56704
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241543AbhEJMxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:53:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQN8YHEYUb1wTM9vhXu9+qhs93kAgZz3Y9lyPIWkpxpbvMKBKz+n2oGejfmxH9zExa25O0RksZSKKmJRsX3aWpkrJ+dSFqrgMZQJykNH5R+RIEFEvr+yIB+J84nXtrhbO6h8flr2p02hRc61QcEYBCvE1AmsPv1BSmClyXXeCtXSVhLeZ20v9CQ9r+OJEMTMULAF9AWl1cEZpdOhRCYNJNoYPAfkO6urA9n7M9cuOo5jr9TKbmU2HUeAk5tANlwh4EdGp0iCq0Fv4P9og/C0QQFxDgPjfBh3cNkw9bxSen6IhypiY+bb4dMZ0D5xOL33wJmkk6mzaQgLhU4rYZv06w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgAAHkqeOUXgcCLf7As4UktHmy8HWK34IoFwuAjAgqM=;
 b=csCDwveCQbzjb0ni6ycdohya0DJFSNXTTikNis9HLbN7A6XZzZsPLBcz7l4VAt4pz7wb0UgYMBO5Pi2wDq6OMqcYLyLIlctVTx9IiGtSANeVDDQhlEuHqpGJQ61OVJmR+MyQ6mMSXQB/R7uktXzynGDOet7sWhSwuH+Ain4xUsblQmvEOeFbtSMK1xnG/blRkG8xCDffKZmekVVUCGq9ZYP4lt0XM6lZkSQAdrAltnYy16Arc+QKK9hni6WwNZfUMe9QTTtpq2PDeP0mBzVas+gKPUn6c15CYxC5Mtccd0PlIv2QCdgColcdoYdk7x0C9sm3lOR5sARcl7SrqrEc+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgAAHkqeOUXgcCLf7As4UktHmy8HWK34IoFwuAjAgqM=;
 b=f4I96Fq5msI9+FirN76AJz2CBxACeVQICh97P26vIws0dcmkOg0fHHyuGUk8QYwanjPGqp/iRDNEdWB8jscNR5l4NzZAaMxKJbloyoyGnkA7uH4C0+d7iG3v7nhF8gUT8rKpgd8mG2LzDO+febimAts1oZz+VEgE8oGlwA5FbCs=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3426.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Mon, 10 May
 2021 12:52:06 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 12:52:06 +0000
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Adam Ford <aford173@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <CAHCN7xJCUtmi1eOftFq0mg28SFyt2a34q3Vy8c0fvOs5wHC-yg@mail.gmail.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <a20d5593-f59a-4161-5df0-ef57f9c6d82b@kontron.de>
Date:   Mon, 10 May 2021 14:52:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CAHCN7xJCUtmi1eOftFq0mg28SFyt2a34q3Vy8c0fvOs5wHC-yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.142.79.33]
X-ClientProxiedBy: AM6PR02CA0019.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::32) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (46.142.79.33) by AM6PR02CA0019.eurprd02.prod.outlook.com (2603:10a6:20b:6e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 12:52:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07ce0de1-053b-49a4-82dd-08d913b26acc
X-MS-TrafficTypeDiagnostic: AM0PR10MB3426:
X-Microsoft-Antispam-PRVS: <AM0PR10MB34267BCCF89B975D0720B0C2E9549@AM0PR10MB3426.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEfo8N7CeZZe7HpB2uTugRH0JLslzkfGMFLlDc3i9hQ6K28B064RL4z8pJ8XjLKeef8uxMy3H4uROxbMhiPgSzTiMoTiG+kDlOp50YqjpZ9/sd03ijd/dcMblxYuANIhQJQ6KIjOeD4ukSvhrqOnqaiPFcFC6P5uw1shymbMuKbfHFL30AoABgP6ZoBUXk8GZxjCJ8XOvo8WSN971KQOwx8skbiRJ1B7lm9uqS2vGnHywRHEgEAIvNW+3yUCxotu61zB2cHLhwDMvnONxg1YWas+bTQCdzFNzqoMtOM0RcOSjisiWR35sYg2LP7B4MRH7prhYZOFQxks8SUexL/j/mxKfbYdJSoML+zLftCb+SjulsdkJugqOR9wFu+GOWgdyw+GgcTlTaFaWuHwzqgOCjqirLxfUKfKBLAIcO1iyxJc7kUMtRzhqIuxsCpFy0WEza2QkhQw5sHYoVDU4BU+Q/Jpj5Bsev90hxEmSracJ1CKnvf2OHNW9ViueA7diMaiQ/8ZcOpH1CtPffFJnHs2CoD1NR9OEiucImTIDW+hVOWL9I2Ki3vRNUi/PCWgjrfkmiM0/CKPDR9xGH0mtZYoo7niAQc820RsM5OsIAlL3BVr8DDDbLBq+JqV56oba3aN+IzZDL9xz/2LvyX97wGXmEm+dpIn+NDoPzm57BilJmKZ0NRtEfTYPdwqIaOLERW8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(38100700002)(2906002)(956004)(54906003)(6486002)(6916009)(66476007)(4326008)(316002)(66556008)(66946007)(8676002)(16576012)(2616005)(44832011)(86362001)(478600001)(31696002)(5660300002)(16526019)(31686004)(8936002)(53546011)(36756003)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dnQyRUpmeVI2bHd3dHRBakNZaitwMEFLdWtPNGhkZEticHYySFU0OGl5SVdK?=
 =?utf-8?B?T3pXbVpQS1lVVkdXSEFPVlVzZURkaFMrazhRaVZIYUw1dXgzbWNmdjJrS1Jn?=
 =?utf-8?B?YXkvQk5WRTFQZGQzVWNUaGpIMWhqUHovWWhmOHVCTTN4dDdWMjhoaVJvdjVq?=
 =?utf-8?B?am5MWHdLZ2hoN09RNzJDM0ZlcDlBdHAybjVoOGlFa0JWMmpSWnhiMWwxeThG?=
 =?utf-8?B?aGVjbnZpQTRUWTBmWVpLbWlMbXRCdEhVYkdFWVFvZ3VOeCsxTC9sMFdudThZ?=
 =?utf-8?B?YkxtVWJUZnF3ODNtOFZXbktSM280V25tTHUrdUFmQWdYRkpKc3k3bWtNN2dF?=
 =?utf-8?B?cTdhOUhnSU9RWG11Y1FhS2tKZXJ5M1N6NWNOelhJN3FKZ0FJT2FYQ2dIeEJ3?=
 =?utf-8?B?MHliUXowRUZqUUZwVHlSb29udkdmVmQxNUNGYXdmbnZkMC9kOStLTjMrNitS?=
 =?utf-8?B?K3Zqd1JRaDVNWDBlbnhTS0dZZXB0MzVDb0lPOU9VTlAySTJscnRxT0xNeUU0?=
 =?utf-8?B?czFpM0wrYk4zcG8rYTJmdkFvMnVWOUFKaHNWZm5hR1UrR21xT1ZaRm9HSUxa?=
 =?utf-8?B?T1o0VnhyVkY2c0syazNwS1pVeHNBamh1YW4wb2w5WXR2RE5kNzkrb1puaDhG?=
 =?utf-8?B?WEhZU2tiVDZFYnQxZmFnL0ROWHdxdks4blR0QklZR29pU1ExbjdMeVp5alNr?=
 =?utf-8?B?TzJkeWliT0R1WnpRemt4dUE3UUNZRndVWlBpMEx5K0hXMVVkeDZvVjNJZGhq?=
 =?utf-8?B?Y3k4anBZQm1RR3JSZmJWV04yNVB4dy9hRUZCcUx5eFVHTjh3SzRnZ3luMDl0?=
 =?utf-8?B?dU9mRGVmTjFDQzJLZVB1N2lvMEZjNEpLOTNzbXMyNWRnODA5R1RWOUQvOTNl?=
 =?utf-8?B?RWE3TzBGbkp5dU9DNkVYNVdKOTIyZm5MdGhOejBwbTR4RzR2Z0NhcWN0VEJR?=
 =?utf-8?B?S1RaMHZLcjFYL0dhREF1cFI4UGVsWWl2Q2lReGcxVHozTGhzWEFoWUtsU0M4?=
 =?utf-8?B?UEZ3TUpoVk1ybHFIUkZkcFBFZlBDWVJLM3JmWlJxckh6ZGxlTTJVckEwRUta?=
 =?utf-8?B?ejdiZm1pTnE1V0V0V29UKzQ4SFhtTVRGK0RUa3l6WndUT0NqdUNrMy8zbnlp?=
 =?utf-8?B?cUp3Um14cmNteC92Tkk0SjdxVHRKcG1WdCtPL1VaWEZDblZpWXFIcmJXZGlp?=
 =?utf-8?B?eEZxaHZ4eEFvK0dTeVpaenhFbHAyRitLNFZZTnRYYUxoajhyN1Y5eVJucVkw?=
 =?utf-8?B?N3pqUkx3dzA1M1hkT3pCQmMrSzdaUjdhODdWT0ZjOEpuZjhFVDhQV2RHYXlC?=
 =?utf-8?B?WnZ4K3BYTkVLaXg3clBtTE9WYktWRElvaFhxZk0ralQ1anV0NnFyNWU4RVRF?=
 =?utf-8?B?ZExldjVSZTVrMHdvUmFSWFJLeTQvWXJNNkdjN3hYWmZ5QlE3clQrZjlsbmxx?=
 =?utf-8?B?bCtWcnhzV0FMK3p1Ynhnb1hid0p1SW9UR2pXeURvWk1maG5Rb2ZnMi9DWkNI?=
 =?utf-8?B?bmRwL2VtR0hEOXd1UkFzUWg3V3FaeVdBUTQ1bU53MllyajNBRnhCUUlieUlp?=
 =?utf-8?B?RWRIY0Y3N1ZiOCtvRlV0ak11ZldDb1BYaWg3eHVHRmpuNnJZakJOWjdwYXBQ?=
 =?utf-8?B?Q2xvNW96YVRqWHN1dWhBNUxVTGJ0WHNsTjFJQnVRcEw4NnpCQzE0ckUvZGg2?=
 =?utf-8?B?aU0wUGJWc0NGdFhxeHJ6cTVURzlFTEppYkM3MGpubFRlc2hwRDlmZ3grOERw?=
 =?utf-8?Q?oosOqKVRp9Y3n/zjSlBSSNwaNQARdzWlkWKXKpS?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ce0de1-053b-49a4-82dd-08d913b26acc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 12:52:06.7629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iPT+dnu+CVXVCS9eBz10lWLL3DJeKor/5OE1Y9YACG8yhgfwOS6K3nWqYy+YCycP1vydxI55waPAm+fBLVPc9rvZuHQ8YjHlWraje6W1l4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3426
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On 06.05.21 21:20, Adam Ford wrote:
> On Thu, May 6, 2021 at 9:51 AM Frieder Schrempf
> <frieder.schrempf@kontron.de> wrote:
>>
>> Hi,
>>
>> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini boards. It happens quite often that the measured bandwidth in TX direction drops from its expected/nominal value to something like 50% (for 100M) or ~67% (for 1G) connections.
>>
>> So far we reproduced this with two different hardware designs using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
>>
>> To measure the throughput we simply run iperf3 on the target (with a short p2p connection to the host PC) like this:
>>
>>         iperf3 -c 192.168.1.10 --bidir
>>
>> But even something more simple like this can be used to get the info (with 'nc -l -p 1122 > /dev/null' running on the host):
>>
>>         dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
>>
>> The results fluctuate between each test run and are sometimes 'good' (e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M link).
>> There is nothing else running on the system in parallel. Some more info is also available in this post: [1].
>>
>> If there's anyone around who has an idea on what might be the reason for this, please let me know!
>> Or maybe someone would be willing to do a quick test on his own hardware. That would also be highly appreciated!
> 
> I have seen a similar regression on linux-next on both Mini and Nano.
> I thought I broke something, but it returned to normal after a reboot.
>   However, with a 1Gb connection, I was running at ~450 Mbs which is
> consistent with what you were seeing with a 100Mb link.

Thanks for your response. If you say "regression" does this mean that you had some previous version where this issue didn't occur? As for me, I can see it on 5.4 and 5.10, but I didn't try it with anything else so far.

Best regards
Frieder
