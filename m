Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8C257C638
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiGUI0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiGUI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:26:24 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6EC7B1FE
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:26:21 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L599rW028541;
        Thu, 21 Jul 2022 10:25:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 mime-version; s=12052020; bh=+zObvC8XWN2kvNVsR+J1+4+vFQ5NwlosJ+v34VrVWCQ=;
 b=IEfHnfVgeuz2jXpBujXP5huWaEjTTccWLDGOaA9ClyqddD3jutfKngLDVHOt/zLKUsuC
 4zqDhqVWXY8VI5abZ4PngSDvv4K7qEllWedqepGTzgroDfd6VMpZBlYpq4yAayp2McXn
 tO0LoIISL2JtGa7y6CLBdQdSoHoX48gxn0zvPGmiTDVb1hFz1hdQhYEG0UI4bhSN722+
 E744IFHj5dEVc6VbSCb3FdmztmxyRoEb+zaiIr6YH6OZcqyfuPUXwVUCxSnKnHbhN0rY
 Bwvm0m3DW9UcqmLWr3c9/ga4ZBFiMYXKmV70OgfxQSgsxVs/1vRQvjl9KnK4lYzJwde9 uQ== 
Received: from mail.beijerelectronics.com ([195.67.87.132])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hbhpc4quu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 10:25:39 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX02GLOBAL.beijerelectronics.com (10.101.10.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Thu, 21 Jul 2022 10:25:38 +0200
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (104.47.18.104)
 by EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Thu, 21 Jul 2022 10:25:38 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJo1YvjI+P/cGVSJsba1HdE7G9+8m97J7XozHit7Hak6DM/5DP3y5bWKjgJht23wT71HgijZmW8Idd6hO+Isr6EnMxvZV2ksVn6aTiD+aZgQ2bzfg/rcdPxowbzUN4VIXGEL8xB9yChN/Y99dFydcy+t0InHNtCHKofamiIct7h2jc35e+IJeN6ZEFppuV6LS9+VARSpCwAoP95sQZFZFCFkVS0LZLE9vIFf27UCrP+JbXFNBVRSp6n+jes1s1Q55CUq296AQbOIv4xOEaccomGdn1kJ94BfQdUCt6bVAS2vN7YZlC3XPjlfCeNaBCVqm+58Kv5tbjMVJNDY1qnE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zObvC8XWN2kvNVsR+J1+4+vFQ5NwlosJ+v34VrVWCQ=;
 b=Z+yxgHmAmvO+L/BSEJ+df4J8sUkFCtUDRHUIwJnzdgoRuPHQ/wLktPDHI8Fa8HmSCTPpjsSJvklXFEl5jzqSRRS+dB9tgvL/Nq5udUF7nxyO/mgw1ygQXGazqgsaaZTnv+BtSWqAOlGS9aszC5OGj8+SlXvO5+j7BOh0jYXLaoUqXUUuw1QdJxn9gy3Ia3/tiL0MhNY8PLZVgENZdT0W00P6ItsYFFW2w7dm+aNmSoa3N1JgxJWf9QH1AJTuI0TCD2raMrdx0o+5yllbe8N7tvxrWp4a3WCN4I0DYfgCAeZqmZ8FT9vvsuSdgkwi5OVru5tZsJeuYNMbAcHDBBpIzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zObvC8XWN2kvNVsR+J1+4+vFQ5NwlosJ+v34VrVWCQ=;
 b=tA8eWS+o0rSYHAFUd1e1TG8CSlxUfhTgZZBpNyidTsmVOFZOWOORplkxD4/jo+dZeNmUAZQ/RQKjVZksTnP/gONmtZyCceNo6db9XbmxK7faJkc1sDDLRW7aXe+iVd2azg9yChIzTP0OjeELE0nXPAW2Y45C+Mo5NF1sH1c1km4=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by AS8P192MB1255.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:3cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 21 Jul
 2022 08:25:38 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::582f:a473:b276:fa7f]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::582f:a473:b276:fa7f%4]) with mapi id 15.20.5438.023; Thu, 21 Jul 2022
 08:25:37 +0000
Message-ID: <a16ea02c-bbe5-82c2-6b38-f5b7d77d0eeb@westermo.com>
Date:   Thu, 21 Jul 2022 10:25:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <nicolas.dichtel@6wind.com>, Eyal Birger <eyal.birger@gmail.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
 <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
 <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
 <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
 <f8eb52c3-40a7-6de2-9496-7a118c4af077@6wind.com>
 <ba54b498-5388-44c2-9554-953a3cf1b8eb@westermo.com>
 <20220720095002.094986df@kernel.org>
From:   Matthias May <matthias.may@westermo.com>
Autocrypt: addr=matthias.may@westermo.com; keydata=
 xjMEX4AtKhYJKwYBBAHaRw8BAQdA2IyjGBS2NbuL0F3NsiMsHp16B5GiXHP9BfSgRcI4rgLN
 KE1hdHRoaWFzIE1heSA8bWF0dGhpYXMubWF5QHdlc3Rlcm1vLmNvbT7ClgQTFggAPhYhBHfj
 Ao2HgnGv7h0n/d92tgRTPA2+BQJfgC0qAhsDBQkJZgGABQsJCAcCBhUKCQgLAgQWAgMBAh4B
 AheAAAoJEN92tgRTPA2+J/YBANR7Q1w436MVMDaIOmnxP9FimzEpsHorYNQfe8fp4cjPAP9v
 Ccg5Qd3odmd0orodCB6qXqLwOHexh+N60F8I0TuTBc44BF+ALSoSCisGAQQBl1UBBQEBB0CU
 u0gESJr6GFA6GopcHFxtL/WH7nalrP2NoCGTFWdXWgMBCAfCfgQYFggAJhYhBHfjAo2HgnGv
 7h0n/d92tgRTPA2+BQJfgC0qAhsMBQkJZgGAAAoJEN92tgRTPA2+IQoA/2Vg2VE+hB5i4MOI
 PWGsf80E9zA0Cv/489ps7HaHFuSzAQCm8MVuy6EsMIBXQ84nTb0anpfLHCQMsRNMuW/GkELh CA==
In-Reply-To: <20220720095002.094986df@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GbCzAk1YmE8Y8AwmBYuKH0JA"
X-ClientProxiedBy: GV3P280CA0087.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::14) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df17f5c7-bd2f-4c13-5c56-08da6af29721
X-MS-TrafficTypeDiagnostic: AS8P192MB1255:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxnSgQ2laUV6mlC7q0yFDNrjklPpU6jS5BGDjulysKBb2G1gjDmFdGM+UINexNc34/Ff/VPF53jO5t34zhrqmPElQKEXqyReb5siMGqjZLpgn1bXVh9xVnOVGIPZauIRN18E9A0hIPTuqn7KXiKuKlhmySsvTU43UwsFajk/YbvPJdIB9MQgHDUh0gvR+5zLKOZkoHKgxaeR5ZSmaC1qBr2Fbtz0RkzBDx1JKI4wVh2qCrA6RIwNjiVZ3lo4U3QEASc5vA1Vz+VlxUFcPWRPxpaNjZ8lj911y6lumqXAJMX8mfWljpA/K6lKar5aVnYMfRWJuKKsvSC5OhdxLBkO+nmIq4ztjdDMM3M6RkhLjevy7cH1GbQSHTXYngPG8TaA8N3ME9nD9NNUJeeh8a1uUH+0nnZAuw91rYEkxiigrHrsZdclrgGJpfpxF0a8yJdJtUWOsiFSa3urZZV6wkpqKNvjJHRfUJok1jhhUphUbPeDyyvJFWmBGlIY04v8EWCn11bI+hBPF4qX87jdyS8xWQ9D+WcTBm0AWogd/fcp7mXOLofmGAvnp4D89Q9okc8XiTPj+AQ2c3i6NjNtLUYf/v8eTj+VjGkdRx7XFjeItraDHwFtOsI037YeAwq9WGfSt1kiaduHV5BRrhNnAe+AaezRjamxN4UgBn8dLS1LoMFYg2I/I0rDTLbsK7WtsdyOw43hUu21kGQ5yofmcqZCgyOeEqOwM6ObsJfp3G5/a/wqxW+rB7QOq6mVMrAgyEpBpYx9uzPRUOnwUyYFy8FsAFCkKD5T9yF57e+Wgn5nf2MSTnPJ90lNKV7xrdTHAo0HEAhGpw8tGXJhhJWBW7Cl64oCohxuRKU4DeHwS+MWDsY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39850400004)(376002)(396003)(366004)(186003)(2616005)(83380400001)(21480400003)(8676002)(31686004)(6666004)(41300700001)(2906002)(53546011)(6486002)(52116002)(33964004)(6512007)(6506007)(478600001)(26005)(36756003)(38350700002)(38100700002)(4326008)(31696002)(86362001)(235185007)(6916009)(316002)(5660300002)(44832011)(8936002)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzFqUlFaZVdTZnAvaVpQWDQxQkRvNXBxUmVxendTbHBWeTcvN1ozdkNOaHVC?=
 =?utf-8?B?TkdSYTlLanBnaHhMbGpxclhWeE9XK3JZVnZKb25NMDMyZWJrU2lmcG9YbGF4?=
 =?utf-8?B?UU5WVk9wVUpUOHNXN3pVT1k0VlIyUmloQjhyLzY4SllDSDlwL2dSV3FUaWh1?=
 =?utf-8?B?UWR2RisyY2NIcTJPdVZaUVpqOXliaXhUTnhqZ1ZieERqalJaeHhkSXF3SmFX?=
 =?utf-8?B?M3h2R3RlR2RkZllkRi95aW56bmwxUU9kOWdSbmtjbHE5cndCb3laSVVKc1dB?=
 =?utf-8?B?WTUwMzlMblMvV1dZNGg1eXZTaE1DcDZMbHk3MFpZbHp1eTNmZzdpVE5XZS84?=
 =?utf-8?B?RTRzRFJEKzdkY1lFS2ZuSDVTSFlTVkptbmtJbW9qQTRpSDBkMlZOR1R0a2dL?=
 =?utf-8?B?Y2RSaEs3VXhTVXpjT1NCb0ZBWWhQeWtyczJGeFMySEU0eFRMdDBnRCtEUlRz?=
 =?utf-8?B?MW1vNWNhWlpsdkR1V0Jncjk2V2hRVUdLdW81SHg5Q3BRb3dWZHIzSG9WOXM1?=
 =?utf-8?B?M05QUTdhVklGbFVDN1VwVVZ6a3E5akFxK2trRlFEWE5uM3IxOFY5RlhTK1lR?=
 =?utf-8?B?VkZidHE1YXNFT3AxWVR1NjRxWElrY0xPNG1aY2w1SFlEbEJVNlloWGJEMGIv?=
 =?utf-8?B?WkpTZWRsQmtTMUR4Z0ZIMGpiNnRMR2R5WVlML3RxNlpBczdqVUxDQitRVm5y?=
 =?utf-8?B?ZzMzcUVvMFVHOHhuN3FTeTh2VDhRV3VjdXlYVkxaYWY0SGpuei93L2RGQjVX?=
 =?utf-8?B?WElFY29wR2l4YTB1ODJkNHBRcWhUallLRDBPT3FLYW5HQVVmOXl0WFlEd0I1?=
 =?utf-8?B?d0U2Y2p5N1p3WEY0UzFXNVR1WGErc1JYUklpMDNQL2hOTzd1Z0NXVG1TSW40?=
 =?utf-8?B?ZHFFQnBGUzRrclNCWGUzK0NxWnZRQVNQZi9EMXVheTdRa0hQN0Zxb2VuaTZZ?=
 =?utf-8?B?S3VVUEhTbDY2UU9kWllGRHAyeUd2djVGd1FKTklhZWlVYVdSelZ6UmszeDFl?=
 =?utf-8?B?VGJIdHdVTVJYSy9wWUFVM2hsK3g5Njc0R2VzNWg3c1A2TzFtMkNFNk1IZ3Bp?=
 =?utf-8?B?VlBjVHByN0NHVE13ZjhEbitRVVUvTjdEa3JlUFUyTDR0dGhQVkxkbkdUNWNr?=
 =?utf-8?B?b1pORkNWZGgrYVpGNGVMM2w3QkhyRE05R2hKQTdJTnR1R0dNQTBRQWg3b1JG?=
 =?utf-8?B?blFpNERSVWw3dlgxK0FvdXNQZFhsUkE2VWtoUmNCZEt2Q0hIV2R6eUpaWHlz?=
 =?utf-8?B?Uk9LQmw4bXVjUnFCYnd5RmlzcGUwM1NiMnlRSXFGT3I3bENYVU9DYXZDTmVw?=
 =?utf-8?B?eTluUkhtbUljaUJIaCsxSnoyZHhPRjV3VGJKeHppa1F2WHpEOGE4bndIbUR1?=
 =?utf-8?B?dS9UOFFXbERYR3BTQy91NkhMbGt5dWdOcElDRkFlVTJPUStDM0h4SzdFNUlx?=
 =?utf-8?B?Wk5HSnhrU29INVhRK0RENlF4cnpaT2hmZ1JMVmo1bTBQOFBqR1RUenFFQktp?=
 =?utf-8?B?YTlEWGpWdGlqYmVFZnlzcXRPc0JOWmNtMXFkZi9LQ3QvbFZpTDU5K3Z0U3Br?=
 =?utf-8?B?UjdaZzFjTVlsczZ0V3lvRkJTVmFsa1RBWWpzUHZHM081eVh2SG80M3lNWlpE?=
 =?utf-8?B?cEZZTDNEQzdzbW4vWElBWGVpMTlWR2pVaSsySFlseExrRU1KZ2dCZisvMlE1?=
 =?utf-8?B?ZkZhdXFtcEt2dTl4a1hOb3dsWHdOd29xdkpEdzE3M09mRUNOUlZ1T3ZwdFph?=
 =?utf-8?B?REVDQ21PdWVHZmtZY2E5WEJQbUNNeWF5Z29MaUxSQ016N0syQTJ5aUZQTEJN?=
 =?utf-8?B?NjVLUitQM1Bqb2hYRllMTWtYVHRZRFloRDdRbThEMU1aVGRKaEQ4SStZL0JL?=
 =?utf-8?B?NStZZ2JhUTEydlFVOXY2cWtlV0xjSFpIdXA2TnhnTW5FRkRuVXdQMGNvWWVa?=
 =?utf-8?B?Vm5WVkU1UEZvY0Vvbytwei90OGlTVSt0aDhQOFNpck1nYzYxRXBrby9Db0Jq?=
 =?utf-8?B?K25pZ2xxbnBNYmM2SFhPanRtUEcvVzIyak14ZHlXNnRqR0VueW1SZXpiMC9U?=
 =?utf-8?B?YlBVS2NyQzZMOGllYXN1ZDNDbnFvUnpsWlhWa3hQajc5emt0dWtVZzlLc3Uw?=
 =?utf-8?Q?rNFiG7+mLEkJjAbwz8lLQDrar?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df17f5c7-bd2f-4c13-5c56-08da6af29721
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:25:37.8240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0El/rA3nJjr33834YhA6SFN7IryRjZ26kow7KhapMg99AtB9TLBxoVXbQIuIGG87b3XIgVg9zmjAj7LfE0bAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P192MB1255
X-OrganizationHeadersPreserved: AS8P192MB1255.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-GUID: zzJC-RD-KcrItlw7fc73U73nijiWayhg
X-Proofpoint-ORIG-GUID: zzJC-RD-KcrItlw7fc73U73nijiWayhg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------GbCzAk1YmE8Y8AwmBYuKH0JA
Content-Type: multipart/mixed; boundary="------------Ll8MJ5stVld7gO0fHEad3jBE";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com,
 nicolas.dichtel@6wind.com, Eyal Birger <eyal.birger@gmail.com>
Message-ID: <a16ea02c-bbe5-82c2-6b38-f5b7d77d0eeb@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
 <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
 <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
 <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
 <f8eb52c3-40a7-6de2-9496-7a118c4af077@6wind.com>
 <ba54b498-5388-44c2-9554-953a3cf1b8eb@westermo.com>
 <20220720095002.094986df@kernel.org>
In-Reply-To: <20220720095002.094986df@kernel.org>

--------------Ll8MJ5stVld7gO0fHEad3jBE
Content-Type: multipart/mixed; boundary="------------wi9UKqh3tGAKduOe6sIRShuQ"

--------------wi9UKqh3tGAKduOe6sIRShuQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8yMC8yMiAxODo1MCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgMjAg
SnVsIDIwMjIgMTc6MjQ6MTcgKzAyMDAgTWF0dGhpYXMgTWF5IHdyb3RlOg0KPj4gSSBmaW5h
bGx5IGdvdCBhcm91bmQgdG8gZG8gdGhlIHByZXZpb3VzbHkgbWVudGlvbmVkIHNlbGZ0ZXN0
IGZvciBncmV0YXAsIHZ4bGFuIGFuZCBnZW5ldmUuDQo+PiBTZWUgdGhlIGJhc2gtc2NyaXB0
IGJlbG93Lg0KPj4NCj4+IE1hbnkgb2YgdGhlIHZ4bGFuL2dlbmV2ZSB0ZXN0cyBhcmUgY3Vy
cmVudGx5IGZhaWxpbmcsIHdpdGggZ3JldGFwIHdvcmtpbmcgb24gbmV0LW5leHQNCj4+IGJl
Y2F1c2Ugb2YgdGhlIGZpeGVzIGkgc2VudC4NCj4+IFdoYXQgaXMgdGhlIHBvbGljeSBvbiBz
ZW5kaW5nIHNlbGZ0ZXN0cyB0aGF0IGFyZSBmYWlsaW5nPw0KPj4gQXJlIGZpeGVzIGZvciB0
aGUgZmFpbHVyZXMgcmVxdWlyZWQgaW4gYWR2YW5jZT8NCj4+DQo+PiBJJ20gbm90IHN1cmUg
aSBjYW4gZml4IHRoZW0uDQo+PiBHZW5ldmUgc2VlbXMgdG8gaWdub3JlIHRoZSAzIHVwcGVy
IGJpdHMgb2YgdGhlIERTQ1AgY29tcGxldGVseS4NCj4+DQo+PiBNeSBvdGhlciBjb25jZXJu
IGlzOg0KPj4gVGhlIHdob2xlIHRlc3QgaXMuLi4gc2xvdy4NCj4+IEkgdHJpZWQgdG8gZmln
dXJlIG91dCB3aGF0IHRha2VzIHNvIGxvbmcsIGFuZCB0aGUgY3VscHJpdCBzZWVtIHRvIGJl
IHRjcGR1bXAuDQo+PiBJdCBqdXN0IHRha2VzIGFnZXMgdG8gc3RhcnQgY2FwdHVyaW5nLCBt
b3JlIHNvIHdoZW4gaXQgaXMgY2FwdHVyaW5nIElQdjYuDQo+PiBEb2VzIGFueW9uZSBrbm93
IG9mIGEgYmV0dGVyIHdheSB0byBjYXB0dXJlIHRyYWZmaWMgYW5kIGFuYWx5emUgaXQgYWZ0
ZXJ3YXJkcz8NCj4+IEkgdXNlZCB0Y3BkdW1wIGJlY2F1c2Ugb3RoZXIgdGVzdHMgc2VlbSB0
byB1c2UgaXQsIGFuZCBpIGd1ZXNzIHRoaXMgaXMgYSB0b29sDQo+PiB0aGF0IG1vc3QgZXZl
cnlvbmUgaGFzIGluc3RhbGxlZCAodGhhdCB3b3JrcyB3aXRoIG5ldHdvcmtzKS4NCj4gDQo+
IFllYWgsIHRjcGR1bXAgaXMgbm90IGdyZWF0LCB0aGVyZSdzIGEgYnVuY2ggb2YgZmxhZ3Mg
dGhhdCBtYWtlIGl0IGENCj4gbGl0dGxlIGxlc3MgYmFkICgtLWltbWVkaWF0ZS1tb2RlPykN
Cj4gDQo+IExvb2tpbmcgYXQgdGhlIGxhc3QgdGVzdCBJIHdyb3RlIEkgZW5kZWQgdXAgd2l0
aDoNCj4gDQo+IHRjcGR1bXAgLS1pbW1lZGlhdGUtbW9kZSAtcCAtbmkgZHVtbXkwIC13ICRU
TVBGIC1jIDQNCj4gc2xlZXAgMC4wNSAjIHdhaXQgZm9yIHRjcGR1bXAgdG8gc3RhcnQNCg0K
VGhhbmsgeW91IGZvciB0aGUgaGludCB3aXRoIHRoZSBpbW1lZGlhdGUtbW9kZSwgdGhhdCBh
bHJlYWR5IHNoYXZlZCBvdmVyIGEgbWludXRlIG9mZi4NCg0KQmVmb3JlOg0KcmVhbAkzbTQw
LjA1NnMNCnVzZXIJMG00LjEwM3MNCnN5cwkwbTIuNDM0cw0KDQpBZnRlcjoNCnJlYWwJMm0z
NC40MzhzDQp1c2VyCTBtMy45NTVzDQpzeXMJMG0yLjM1MHMNCg0KQlINCk1hdHRoaWFzDQo=

--------------wi9UKqh3tGAKduOe6sIRShuQ
Content-Type: application/pgp-keys; name="OpenPGP_0xDF76B604533C0DBE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xDF76B604533C0DBE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEX4AtKhYJKwYBBAHaRw8BAQdA2IyjGBS2NbuL0F3NsiMsHp16B5GiXHP9BfSg
RcI4rgLNKE1hdHRoaWFzIE1heSA8bWF0dGhpYXMubWF5QHdlc3Rlcm1vLmNvbT7C
lgQTFggAPhYhBHfjAo2HgnGv7h0n/d92tgRTPA2+BQJfgC0qAhsDBQkJZgGABQsJ
CAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEN92tgRTPA2+J/YBANR7Q1w436MVMDaI
OmnxP9FimzEpsHorYNQfe8fp4cjPAP9vCcg5Qd3odmd0orodCB6qXqLwOHexh+N6
0F8I0TuTBc44BF+ALSoSCisGAQQBl1UBBQEBB0CUu0gESJr6GFA6GopcHFxtL/WH
7nalrP2NoCGTFWdXWgMBCAfCfgQYFggAJhYhBHfjAo2HgnGv7h0n/d92tgRTPA2+
BQJfgC0qAhsMBQkJZgGAAAoJEN92tgRTPA2+IQoA/2Vg2VE+hB5i4MOIPWGsf80E
9zA0Cv/489ps7HaHFuSzAQCm8MVuy6EsMIBXQ84nTb0anpfLHCQMsRNMuW/GkELh
CA=3D=3D
=3DtbX5
-----END PGP PUBLIC KEY BLOCK-----

--------------wi9UKqh3tGAKduOe6sIRShuQ--

--------------Ll8MJ5stVld7gO0fHEad3jBE--

--------------GbCzAk1YmE8Y8AwmBYuKH0JA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYtkNfgUDAAAAAAAKCRDfdrYEUzwNvkWi
AP9R5WBIyjUAmpT6yH218WjXnmDbsViVBi7Vms0W9x+oWQEAqlR5KlDIZPW+sivO6nHHEvFgjbS5
8G9gCHhSpFtHpAA=
=qVZg
-----END PGP SIGNATURE-----

--------------GbCzAk1YmE8Y8AwmBYuKH0JA--
