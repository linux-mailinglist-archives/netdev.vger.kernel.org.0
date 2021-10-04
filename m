Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19651421A77
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 01:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbhJDXLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 19:11:16 -0400
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:3650
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234534AbhJDXLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 19:11:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRo7QPSfJgRXbz/lxJrIh7O+LDQhFxc/zxjLHIyboDB4Fd135Xmw993JYpOFJ7hPptBaAKWUv0V5hYXSnuyuOWjFV0+X57E6LqRxAj1ZEL55akzGuog6sQO/+NCH2XnxKGOjfacDHDn5sR7ajezbi8UWBn6iRIajxE+a1MrvS4hpPO3r7cPc/a0vMi0ORKlB/ylpgQP8ODsnM6rsyhuM5qJrnr3zZDV5E7+XIMOikgkfBygqif5ixATwgH8eFN/DwCHLS6pWigBKiIHs2xP3jO842ODKkXhCmwYrCt4tRH8PmzXKl7yXCGJ7EUXs0dHI9Aws3Qngkps/Kg9A+e3lnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJ9KuIkrEe04a6zqa4Vh6F1Q2Es0D/t33QoXfJQweDY=;
 b=LPRY98Igs7oK6f5aE+YwwwuNqkvqdN64Lj5savOGoBZtVgBEKX7RzAs0A2cCfkP0TqJgtAHUWZVE413TEft6p6woxBnXj5c1P0BxE6Qn1FoNG6JDKDzM/n4UzD+rYWF9XY6T3WYSmlwadlOeWX+Ijcq4XmhA/07VGCKLJ4hKWfkKIcQ9bCszFzrn8E4h6Sb73XIOKZ7Ancyz11OPegVnqLA6kif71J/X1jcxMDbJvSHSCZhYhy3MeZrXqWqchXoz/9QN2n6QWeRuftVwKMyDos7BX6GtLXyWIDzwoMz7KaDh/svT7fUGccXOVW8VGHy51dda9XTgi++PJphfwb+Q/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJ9KuIkrEe04a6zqa4Vh6F1Q2Es0D/t33QoXfJQweDY=;
 b=Mrb91zhkm0q5eycQzCh8izYvlA3Qt9yJQwP5HHpYjuh6XWH9rqnxFdlg+06fd6nT7wsTC1dXCQGVqmfyX0AE4C8l/MIYZFHOuTLquA1lJsud6aPF8rF4CaYIJu4wjYT2dKGZQSCbOK0V6qWj3E2kfUyzmY68dur6vxUm/zDixdw=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3961.eurprd03.prod.outlook.com (2603:10a6:5:32::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 4 Oct
 2021 23:09:21 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 23:09:21 +0000
Subject: Re: [RFC net-next PATCH 08/16] net: macb: Clean up macb_validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-9-sean.anderson@seco.com>
 <YVuIcqKjDgawNPG4@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <b88da591-5cf9-dcb8-bc7c-e6198868e6ee@seco.com>
Date:   Mon, 4 Oct 2021 19:09:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVuIcqKjDgawNPG4@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:23a::12) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:208:23a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Mon, 4 Oct 2021 23:09:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c36a49e-b0ba-4919-c747-08d9878bff95
X-MS-TrafficTypeDiagnostic: DB7PR03MB3961:
X-Microsoft-Antispam-PRVS: <DB7PR03MB3961D3EE9F0BC594C015528496AE9@DB7PR03MB3961.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iqMa3Y+s8FSKqwWGDgG28LSERouFily8W1C07avQNZOLcxCp5Q+Qkd4KuA+Bxi4EH9VBlNNzvHi+LMjzv8zSBU+y57+DRYM6MUXkHuMZoapid3TEDTVQXovMUiU4JdaSS/YHVBLEDfEGiEZi5P3gTvGa5IhERybRZWd5IBRRDXk8YJ2r1gIfgfm7aZiUBX0pre+/KD4kq1YlvtDGCYH1+jvsyMvAl8m4/DIdQLXr067KO0VEdVDSZfl0qso86X/YKYyMwoo4vw4Zm4hy0e7ck6ZAjqEjzTiQbphFmNaG43OIIjeiYKdvy9mZvx1aO68NcsXui3ibZiqa2iltP8NOlkDlEKIB9TnAtcnbqBygeYafn77mwJmOIgx2NOkAisiJi0LvSySg4P+MJh//TR9eUzNkkphuAqwH6LlN+iqrQ9JpZdk05FCkRJCuHaREXskjVOjLU8sOSV36pU+YgzPdTBdInhesyBKjWi3LOtiUdveiZWSlCFdbPwETrAVrZ2rXImozEBv4Z2gdZtS3xhHrWsdkolKmvHj/EXan9Ip3L7MmnMoKDiQ2g9ckHrv2CdKlsVGzUATvlXiU1P74HB7vDV/BbUi08fUGDskHorqNlyRaLQPPYtvLdl+23eyFSGckx6lNzOjlBelKlzPukzaQVKTczUHfeg6eJ3AEIu5ETLxWjVqcDT+72zZRpxZSRxN/ucLhqa6PC077X15BQDIIIxSL3I6nIal367IQm9RhkmUJSh1MWSFRt7VUt5ARCVDm4/V9FA3UUyFxSCu44ndb1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(66556008)(2906002)(52116002)(6916009)(2616005)(31696002)(16576012)(316002)(66946007)(36756003)(6486002)(5660300002)(66476007)(956004)(26005)(54906003)(508600001)(44832011)(53546011)(4326008)(186003)(31686004)(4744005)(8936002)(38350700002)(6666004)(38100700002)(8676002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWV1MTNPUG0yVWQ3NDYra0RjYnVvNDFIcTR2b1FHdkFvR0NYRXMzSEF0RXFn?=
 =?utf-8?B?SENGcU90VzVrb21CM2t4VUxiQXhFSzAwY3RVcnEvUEgxTDFCdTVtSDBLYlFh?=
 =?utf-8?B?OVJGWmY4Ym9kNFRYVVoxNENzRzc1QUpQY3JWUEhFeCtWQ1pra2F0RnZDN0Rr?=
 =?utf-8?B?OU5oaHBPNS9XMElUbERsS2JONkhXblc0RWVIOGNpQW1tZzlrRWVtajd2VDYy?=
 =?utf-8?B?aE1kb0YrWGh3WC95ZllVSVVFSHoyMzVseXRiRlp4ZGY4Uy9BOEgvRHRyZldG?=
 =?utf-8?B?M0R6QWIvWEVvL3FqU2VxOURpVmxGakhVbXNUS3VqeXAvRHlhSXVNRHZpL1dn?=
 =?utf-8?B?MDFpMENXK3pVQkdxNlBsZzUyaHIyRS8xYXU3dFJDWlQvT2hxdm53YmY3Y0Iw?=
 =?utf-8?B?bmc2QWwwYzlwbUpPSFZiUXpwRGYyYVYweEx1SEgyNnVNVS9qUTMvRUpvZlZP?=
 =?utf-8?B?dC9ISGR5V05NczRvc3pMYnNiZlhxeXZxZGV1VU1BMWhDMGhIQmVzUXc1L0h3?=
 =?utf-8?B?b01ZS0VNVUJKclZHa1kvN0VnMEVjSXVBbVlaN01kSzhtdE5GV2FHZU5vTWdt?=
 =?utf-8?B?RXdKeFJSWnRFWXQrTkQ3enJML0RLVFNZZ1YzMnBNTDZTT0xrcWUrN0JwOHRQ?=
 =?utf-8?B?TVBYMEVEUzdsb2hud1BCM2lFVVBlYm5hZHdpdUoxZDk4VVB1eE5uYm5CdmNF?=
 =?utf-8?B?M2ZUYWgrTForVjFIanNySVRNQjVaYTFEcXA1aU5ILzNWaEZCTTBwV2ZxQVhS?=
 =?utf-8?B?amFJdEN3U0JyQjBUOW9SMENQT29YbmxMVmdtc0VFZDBUenhhd1UrSkw2Z08z?=
 =?utf-8?B?cEJKcU9tTkN4Z1IyaDF0WDh5OGlQNitQVUU0N1N1T3MzbGtWM2pwdGpSTDcz?=
 =?utf-8?B?UDRLdzlxMXlIamNEdGVpOVZFbUVSTVE0Y3hXcWRFbkdhODl2cGhWRnNXWnlX?=
 =?utf-8?B?QkI0b1Z5WFJGUm02MWdFWVpFK1hERjFVMVdqVWdIUUhEMnFXNHhMQkdvQkNl?=
 =?utf-8?B?aERKcEJsYVA0ZFVQMDJDVUx3NWF1Y3dURE1RWTdNdlZnTnFydnRnT29NeXFy?=
 =?utf-8?B?c2w5QmJsK25mWGpDcDhXL21uREhMa0xlanZGUjhwNFFlcFVCTWpxR2RkKzhO?=
 =?utf-8?B?cFNybDJzSlZrNlVxQWE4ak5Yb0xWMlg5alVJUy95VTM2ck1RZWM2UmZoVlMr?=
 =?utf-8?B?T0RPM3ArSUh6OG9xbEo2MkRmZkpJWGJSaXZDRWN4Y1VXdDB0YmlyQmtwejBJ?=
 =?utf-8?B?dUhwYkIvTWo2R2V4UWt6NmR4cEtuWDNxUVJTV0FrdmpPT0tvSTZGWS9NRk12?=
 =?utf-8?B?ZFova1lmVmJJSm5lZCs3NnE4ZjVKQWdhQnluU1BicUc3M2xndnQzaVRkSXFr?=
 =?utf-8?B?U1o5elpyYTRxczNKQzdxWk10NnZOUUpBaEI1ZVArSmlBdkJqYTRnNTdCU2hy?=
 =?utf-8?B?ckdQOWVFTGVqM0lpYkdYaDd5akFKSnFNNGpuczJ2K0EvK2xGWkFCKzZ3a3BR?=
 =?utf-8?B?U2tSTEdNUXV4N2Q0QUpmbGcyUU9UUVlDQWxIQTI0ZEg2ZWt6dDRNZTdBbnRI?=
 =?utf-8?B?ZWl5dk5LeUtMakU5aHpGQU1RWlM5RVEwSStMSDBYTDlDbFoyQy9CVzNqOUdx?=
 =?utf-8?B?ZnVFcjR3YVJBcDhWVDViTVcyaUJrNFhNRDhHdDd4MncxQVIwK1kzdjBEMVZa?=
 =?utf-8?B?V24xbTQvSUNrMDRzMWUwblUvNENXUEh3SUR2Szk4dWNqdkRHZ0RNRTZ2MVcw?=
 =?utf-8?Q?SkVqT2wj1P1EUNMxKVpKigTLsq+lUCL7AZVEsCa?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c36a49e-b0ba-4919-c747-08d9878bff95
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 23:09:21.0825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqy0TMb7cuISE0gW+Dvb7OH1d09z/p4gR8pTThMJRdeqnKjnWtyYMHmLijxIfzfutJKWVwxhTCIdIvyzz9Ctkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3961
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/21 7:04 PM, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:19PM -0400, Sean Anderson wrote:
>> As the number of interfaces grows, the number of if statements grows
>> ever more unweildy. Clean everything up a bit by using a switch
>> statement. No functional change intended.
> 
> This doesn't look right to me.
> 
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index e2730b3e1a57..18afa544b623 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -510,32 +510,55 @@ static void macb_validate(struct phylink_config *config,
>>  			  unsigned long *supported,
>>  			  struct phylink_link_state *state)
>>  {
>> +	bool one = state->interface == PHY_INTERFACE_MODE_NA;
> 
> Shouldn't this be != ?
> 
> Since PHY_INTERFACE_MODE_NA is supposed to return all capabilities.
> 

Ah, yes it should.

--Sean
