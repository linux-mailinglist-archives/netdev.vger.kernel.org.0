Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909DB300454
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 14:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbhAVNhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 08:37:11 -0500
Received: from mail-eopbgr50115.outbound.protection.outlook.com ([40.107.5.115]:16224
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727052AbhAVNhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 08:37:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdolDUR8AxV0MC6c96Ax4Zhy9pGUf6dXj2N0YE3hv50jhRx942Ut2wmuQJfUzp3eu9W5EnSozJ8eZKJJD+FvHIC+j4UcuRZgn9972PBEbBeKqwt5dN5FZXbjU1qwPTjbUPtKG/bGJgpBB3hx8gyNZBNOxaOu8nxon3/24g5UTlLEEsillHnk07OhcQQx89Dj1/O2ytgLOIoKaORSorTS5dzvT0wyxW335TwLbrqSI8tQQCBQulA2KcntNS7Fp4s6URptZaIC+BE+5vP7m/x/HAOiCH4Z9RW1SVHYo63dL9QOF/WACmN2izjaoXtej7CAySsz7JQiGNTgLXQJOSr3XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjKk8zDVPDvQEXlJNQhsSOqgeYHs2ysaoIbEaGxWFEg=;
 b=aGuLJMH0eqAAOxLVXiqYjT750/jT3rKT15F3HlfG7ucdE8A1W8+UdlKTSpUlgIgq9iuibBHt9jaq6EOLwAyKza/EdFLmeRODbMBaaoMQF70l+DQr/HM6FqwYoASW6Gbsq4BvXglbikmm+7Bs31B5+GqKhuMm5E8E6n00a3RYL6rsGhoIZG0qu0uuUzXSan4B6uC7tcpEjCAA03MTwaei0qTz7HqEJN0uLL5rm3AUGVMC/2uhs103cPVAwfrxbaAbCPH7mARZz2TrPlnoWe7hGjCg4zkCJ7zjpJ2nzntLPLt9F/nWoThMz6xjVGaMGnUs8c1vtqztRow16APCKa/R0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjKk8zDVPDvQEXlJNQhsSOqgeYHs2ysaoIbEaGxWFEg=;
 b=UYCsdZobK8afFnuXkDguBWZcJyCI1FJZZ8jAa3rLITKxhgWQv7gbqCRU/whYadX4g9cJ/TgHnpdMjixwaKyVtzmJ7ng5ZWm7aNzhNgRo0LQSNNd7o1m6JfMOYuAvCtP/4mIqKbz54xdn9LFznI7KuwMLGor8CoRhITF/KiB2BTE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1297.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 13:36:12 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 13:36:12 +0000
Subject: Re: [PATCH resend net] net: switchdev: don't set
 port_obj_info->handled true when -EOPNOTSUPP
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210121234317.65936-1-rasmus.villemoes@prevas.dk>
 <20210122090505.3tb4idcvrjd4zcwe@soft-dev3.localdomain>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <6f2ccc42-f6e3-201d-2bbd-05a78860fa63@prevas.dk>
Date:   Fri, 22 Jan 2021 14:36:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210122090505.3tb4idcvrjd4zcwe@soft-dev3.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0601CA0038.eurprd06.prod.outlook.com
 (2603:10a6:203:68::24) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5PR0601CA0038.eurprd06.prod.outlook.com (2603:10a6:203:68::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 13:36:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b51aeeda-2016-449a-cb7a-08d8bedaaf36
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1297:
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1297F62CC9CEC15554FE27ED93A00@AM4PR1001MB1297.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u6DXOYHOtN5O7kbUW4PE5y7ea95DIeCAZD3QogEAPolDgrlq/Mn4EBCzlNI/v0djGeB0wWKwbnwlT2l03ATen9GrAJANxFWuR6oXpyPBfpB+TWatwetejIvFXCNQ8eeYzrDE1W9O9AbXrh5NFLjbIJoOeq/ZiLnT5XLQqPTkaYbuZBbmcgDC7jHoNqLZBipN3K8OgCtXDY1awatJuDR0cyms93yZdriKYxo3M73Rjp79ZzZW2IsutETrE/oCYabRqii8BHIwETzay+SyurohBq0+Pgjv4XqVL7ZgkZN1RxgDpCOh2aQYWOmJ3UbKptTsv1x8ZC32YbWK+jSmnEfInSnyBBkQCdL3MXgsY3BfsXsTICiWMpDf+y1CiWyjz4H8Q8nUEdxD4tkHyzwHbi4EwOErlFRRi9ju1p46i4vAOo3OhqYprz00ihWXNIaN3fuwP3j3tOkwJu6InbO0KNEs71ZfmP1DUAWf83gn+hGlD7Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39830400003)(376002)(31696002)(6486002)(16576012)(31686004)(8976002)(16526019)(54906003)(8936002)(186003)(26005)(316002)(86362001)(66476007)(66556008)(2906002)(36756003)(66946007)(83380400001)(52116002)(8676002)(5660300002)(6666004)(478600001)(956004)(4326008)(44832011)(2616005)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bVczcElwS2JGb09YRzRONGhwWDlwcWY5ck56cW1DSngyNFpXR3pNL21lbWhp?=
 =?utf-8?B?YnU4Z095UDJxb1d6OS93ak9mZ0RCUHk3RTFvaE83L3RVOUpUZE44N1lvd29E?=
 =?utf-8?B?T0N1djVwb3NISERLd3E5bDZXNkR5MzVJM3V3TGlsMG5DRUtjVmVPSGxaL3dR?=
 =?utf-8?B?ZU9WQldiMFczdU92d2lKSEpWRFlHVmZpTVV5NEtWU2tZbGRvL2JvY3YxT1Ba?=
 =?utf-8?B?M3FNdjQ4aXVxVDdtTGE2NkFDZit5Q05ycU5uRVk5bHZCbGdsd2s0Y1pBb3BO?=
 =?utf-8?B?cktPbjRNOEp1dFExL2dBcG5UdlR4MjdZcjUwYWNDM05wU0Zmb0RDcVFNdFFk?=
 =?utf-8?B?Z0FBbnQ5M0lsbHNXamdrU0kxbnBXYVViNitGTllKOWJsVXlNcjA3TFRoSXoz?=
 =?utf-8?B?Q1czNHVXU2ZObmYyZG9UMldxRGpqRU8wTVpncDZING1GNGdWWXlLNnMyVHly?=
 =?utf-8?B?ZnBwMFppVm1GNENwMkM4T3ZTcFJ2NVR6TzlGVDJOUGJJNUFFY005MGNwNDFi?=
 =?utf-8?B?ckQ2RE9wZDFIdkZRU2FHOU1JSFNURHJDdzRBa2wvNVhLTVREZkt1aUtYYkY0?=
 =?utf-8?B?Vk43RDZQZ2hXaFRaSG5aZFMrSXVidk9qTFRHRHNYWWtvS1IvTnNhOElzaTA5?=
 =?utf-8?B?VlQwSzJaRjJBMndEblUzMnhSeENZUm1IQXlsV0QxR1YvSVA0NjlJNmttZWor?=
 =?utf-8?B?clIrb2lPeHBtc2VFWWxKdnpWVXVYVWNrREJuWGhQeXpRcEhXUCsyK3NUOElh?=
 =?utf-8?B?ekVDMXhKNThpWW02Rm5hWXUrZVN3MXphbHdOMkxVbTBZbG1sc2h0M0dzR3BS?=
 =?utf-8?B?aWdTMkVGamdld1RWMm1UcFhrcW5QZXYyZGIzNzZYTDNBNnNieWNFbTE0MVRs?=
 =?utf-8?B?SXlVMkdyaEttRi9LMmZGdm02Ni9tQW5DbVVBZm9FRm5IT3ZmTHBCTXlBTFox?=
 =?utf-8?B?aUZLVmhKdnU3L2ZmTk5LOFlqcTMwbTVjVE51cHVVb0ltM242TmpmbU9TNTh5?=
 =?utf-8?B?TEZyQnJYOExxenV6N2xpZ21JazRTcU9sSTNpWUV0ZUgzR1FwQ2dHVUxvQnJP?=
 =?utf-8?B?MGpQYlIzTGUwYkE3bmRBcmNLenh3RFZhNW1rOUtkWFV5Yi9oTTZQMlVUNXYz?=
 =?utf-8?B?c216dHJ6Ny9VN3lUekFISlA4cHZPaGhRcjRZNHYvbm9sbEZoempPM0l3bERQ?=
 =?utf-8?B?QkVINER3RVRzTVVPWXJXRjhRM2IvVzZpajd6bHFKZmYyRVBQMU1USi9LV29K?=
 =?utf-8?B?aW1TWUJiRzFJa0lmcDg3Q0hhNlJOU3doQ3lacHl6K2hVSXJqeGw5Q3NyTnhJ?=
 =?utf-8?Q?kFqGAELAeni3l12dfi9xoyKi751lEn05LA?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b51aeeda-2016-449a-cb7a-08d8bedaaf36
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 13:36:12.6735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Neuo+yBBOw3e06uPdptYrYHw9r+msdDWO8QWurJRi0X6iV2NrAyEKgZLIqKicesVbPB5n75D0hxJl2PGwYEjQSPcpFhNQ//kka4/eJeg4tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1297
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/01/2021 10.05, Horatiu Vultur wrote:
> The 01/22/2021 00:43, Rasmus Villemoes wrote:
>>
>> It's not true that switchdev_port_obj_notify() only inspects the
>> ->handled field of "struct switchdev_notifier_port_obj_info" if
>> call_switchdev_blocking_notifiers() returns 0 - there's a WARN_ON()
>> triggering for a non-zero return combined with ->handled not being
>> true. But the real problem here is that -EOPNOTSUPP is not being
>> properly handled.
>>
>> The wrapper functions switchdev_handle_port_obj_add() et al change a
>> return value of -EOPNOTSUPP to 0, and the treatment of ->handled in
>> switchdev_port_obj_notify() seems to be designed to change that back
>> to -EOPNOTSUPP in case nobody actually acted on the notifier (i.e.,
>> everybody returned -EOPNOTSUPP).
>>
>> Currently, as soon as some device down the stack passes the check_cb()
>> check, ->handled gets set to true, which means that
>> switchdev_port_obj_notify() cannot actually ever return -EOPNOTSUPP.
>>
>> This, for example, means that the detection of hardware offload
>> support in the MRP code is broken - br_mrp_set_ring_role() always ends
>> up setting mrp->ring_role_offloaded to 1, despite not a single
>> mainline driver implementing any of the SWITCHDEV_OBJ_ID*_MRP. So
>> since the MRP code thinks the generation of MRP test frames has been
>> offloaded, no such frames are actually put on the wire.
> 
> Just a small correction to what you have said regarding MRP. Is not the
> option mrp->ring_role_offload that determines if the MRP Test frames are
> generated by the HW but is the return value of the function
> 'br_mrp_switchdev_send_ring_test' called from function
> 'br_mrp_start_test'.

Hm, you're right, but the underlying problem is the same:
br_mrp_switchdev_set_ring_role() (whose return value is what is used to
determine ->ing_role_offloaded) and br_mrp_switchdev_send_ring_test()
both make use of switchdev_port_obj_add(SWITCHDEV_OBJ_ID_*MRP), and that
function is currently unable to return -EOPNOTSUPP, which it must in
order for the MRP logic to work.

Rasmus
