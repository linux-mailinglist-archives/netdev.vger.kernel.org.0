Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A06CC12E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjC1Nkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjC1Nkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:40:43 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3640C650;
        Tue, 28 Mar 2023 06:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1680010832;
  x=1711546832;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xq+hXiq3wsn4Aud9yHLvdm72Clljl8fb6hMrdil9KgU=;
  b=GLrPlVv5pQP8JxhaefokIFjmuO+jUi09bqFjztl+jEJhLH9JCb4SXZtC
   6uhra89ZYRNV3fJcospF/0Rqyc/FNTjYUG9bgJXpfFKPtPTBLYRW1oD3+
   0xtCJRvEkHVfknPF9bIxmMawuYGapGD6oNng+3Juulet+Ngkn+doOdTGY
   X2SIQZCBhoilPcXry1fdSi+L4HWQg2jRT2WSqv2WXVHIhlFSNDy+aABLF
   s4GtflLrgIS8xxDw9SVuLMvkx2CbShZtIyRQA+z+5BEOR+gQjLidcEWzi
   Tl7r1Y7xRQn70mzQ7eLCm6S5f61pt4ZDQMSVMa0PT18i27/6OvCPb+cWH
   g==;
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3XMZjJ6/UiKeJF5hA6yptl4hDk8TsRFe09WPYUWzZJkyTlRmZP35agF6HmVX3Gt4Cbdq/22cmHmGRbpqFyGp/ngSxpy3b4PA0WjIQCd7uCZyKZv9uFqkQZZZ0z8XRNzrZEi85Pt41R4KISPTuA5JYaSgRmBM0ZHw5uqJUNWwxmIFAOnm6Uk/3cecG/Rpyf2+G4C50Jrj9lf6MsHsMfxcF8MwJQ65wR5rz51jetDkNkeJzCVibom8SBOF1Dmh6YT4EmvppQVmGwU0WO5Ruxn6XbG5U5SYwMJCwkV3uSF3Vy+BdJp4CasZQWZNGsNCNSXSQmCWpG2Yv9nR8pDbMIjNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xq+hXiq3wsn4Aud9yHLvdm72Clljl8fb6hMrdil9KgU=;
 b=MLvkkBOlBMeQteenqK7zWydGYMar5PvEzxeEAW0knHVt2nGtBIJZZWzu+LpbhXld0I9ugB7/m+w8I5Z1tgj2SSf7YlO4VMYcS7O7enK6sw3yZtyx4JP4AvblocubB5L9NQjFjqWfY4S18lXQAIMnGzj1HZ/aiRYCwux1scw7+a+2jt4yyiYik2/2g6sgED3qkdYwznHQ/V1fXzmr2yhTiiVDzBl/ZOVxEHaA0ofmAYOUyjQRS5HYG3swCRKeKpD92I5UQQD5JK91rCLDKtKx4jW+ZXM9waqTin/gSusD2x3ezkXGkP/61lGDNWULHDmol6Z+GSHtjkK1LRq+3hlkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=axis365.onmicrosoft.com; s=selector2-axis365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xq+hXiq3wsn4Aud9yHLvdm72Clljl8fb6hMrdil9KgU=;
 b=lVVu3aQQ3aC/ydNi/I5g5WEMcgLC82USIO5d2e5B+sCnD5vqnOJZ/sCGxPb8kahEcB4F+Gf4TpXifLl2oXpH6UP8I+oMe/sXPki9hs40M/5y07tVFk1vuTDeiXt/wyRx1ncaRKkHDypaOrkUxKv6ZvJysbOCidKPBLqU/SbzrGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
Message-ID: <c92234f1-099b-29a0-f093-c54c046d304a@axis.com>
Date:   Tue, 28 Mar 2023 15:34:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog
 register
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Gustav Ekelund <gustav.ekelund@axis.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230328115511.400145-1-gustav.ekelund@axis.com>
 <20230328120604.zawfeskqs4yhlze6@kandell>
 <9ba1722a-8dd7-4d6d-bade-b4c702c8387f@lunn.ch>
 <20230328124754.oscahd3wtod6vkfy@kandell>
From:   Gustav Ekelund <gustaek@axis.com>
In-Reply-To: <20230328124754.oscahd3wtod6vkfy@kandell>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0029.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::17) To AM0PR02MB4065.eurprd02.prod.outlook.com
 (2603:10a6:208:d8::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR02MB4065:EE_|PR3PR02MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: 17d82c5b-366f-41b6-ace1-08db2f9119dd
X-LD-Processed: 78703d3c-b907-432f-b066-88f7af9ca3af,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEhrIxM5ocIQVwiOWqfjejOYyeziNPCXW7c2sTxg96JB/Sw9XAe07umRB2SmhA7axRckfK9uWwmXx/dCVA6QV42dMXe/iRRlhDBe7fg9wTpOcACcS04Cb93TduLRCPV5kBKKEybvL48YxKFqSDmlxB1dVtxQ2HvHDPhPiwpwiQZxqisX/TXS87aB4U9tljksPPDxa1YLxlA6y1HtpkAzojbonrjY73FUtxF22YEzZb3ek/bhZPxSTOrjOHJRJbhivKU7V51DZq5S4OEsh19z16JqmjIMT2vJ30wH59Yw5yZffyGWTDsOK62Rqyge3sCMj8KKYiVNVvIZWfsAxmY8cY5Ro6owJwCxc+L/KlT8kNTUi0EsBhx+6EPqf9HPdNENjIAPyOLP+fBMIOH1wwqF3e8F4G9WBofDSYFYatcH6514Va/kndx3Ep51VM4vCC9FMgs4jkqwWBcyz0ZCU0ub6FcThXg5iR+odPrq1Y7g4gCE2KSIbLmrE9F9s2hz84P/v4ILWzzM4GM+Xzldx439t3hT48C01rp+ykeuERyb58kQTN27diPAwimXqq3j+0bfgKb1UOZSFP9oKgepqOz1qI0SD21VbIj7ESutF2TMObJwZaoshw15S2H0/BtigoIwafdX2gMrRxaYZwRbldK+kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4065.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199021)(31686004)(36756003)(186003)(53546011)(6512007)(66574015)(41300700001)(6506007)(26005)(83380400001)(2616005)(8676002)(4326008)(5660300002)(66556008)(66946007)(66476007)(316002)(54906003)(110136005)(8936002)(7416002)(478600001)(38100700002)(2906002)(6486002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rmk3RnE5bjRlWDJYNXJibXJJb3VnL2JTdCtBdnhRVk5aYVlVMWRoM1ViOUo0?=
 =?utf-8?B?NUNJQVRVRUpaRWMyM2tyVG93aWpOMnlOdGZNNURaVzZuVkh1UGFRL3JMTS96?=
 =?utf-8?B?b3JuV3Y4R09PM0lOUzF2U0JsVDRNM29jazQveUJiYm54bWI3ZHRpejlwTGQ4?=
 =?utf-8?B?OWxMSyswRVVvMy8vdTFCVENRM3ZYbWJVUGYrV3BEYjk4RVpsRXJ4MWh1RGdr?=
 =?utf-8?B?WUVTVjUzUmNuRHhibCtKTmczT0l4bXRDd21qNWNncG5nN0tuMFROMjBRSytj?=
 =?utf-8?B?cEtJZFN0dWFncnRIc2R1RWtMc2VKR09hVWt1eU9EZDd2QUI0NWZBeHlHYUVX?=
 =?utf-8?B?MlBLVWM4cnBXMjB6Sit5UnpWQVhGbWRZYzBwbGRhNVY0WkJIRmtxc0RIbWZX?=
 =?utf-8?B?aVM4THQyWVcvRFc0MFp6QVRUa0RxQ1FsUmFGakVaalFEelRzMUdCRG5Nb1g0?=
 =?utf-8?B?ZXRNdXBTVDR2dHp4Kzk0dWQ3NFVyMjcyY29UcGZYcCsrVkVqcGtpVHo2L2Nh?=
 =?utf-8?B?OXBoZVB3MS9rSGlVNUl6Y2ZaK1dPZTV3K0k3V2JsaWVLdWxFL2lLRXpMMXNx?=
 =?utf-8?B?VVZHQTVMSlcwVitoMjBpUGZmK0lidEJqSitDK0dka2taMWVHc01BOFBiQjB1?=
 =?utf-8?B?bmgvYWN6a3dVM3pWUFNXc1JZWFpYTGRIVkhWSUIwanp1T001OWdMNms4djM5?=
 =?utf-8?B?OW5LcFRoT2xpRzd3VzZubTZJeVA3cjdoMHVOY2ZXQ0tQOUVlcHBxV2tKQVJ5?=
 =?utf-8?B?N0lOcndwQzBYS2lrTkNvalNpT3ljeWkzRXFLNllGWEFJMFRKaVlseWRGa0J4?=
 =?utf-8?B?V0R6ZXVCSW1lUDNIS0g5anNWTUthSGZXaTRiVzZRV0Vpbm5OZmdDY3FZTE4z?=
 =?utf-8?B?TVh3dEljNEhIYjhVdXJmNm1ZMCtuazNIL2VmbEZubmlOeitXMUVDemE0TzZ5?=
 =?utf-8?B?YU15RlhoazV0OTBtbFB2N1p4WmNSd2JCQVMwODl0Qk9adHVpR2Z3dmtYSEV4?=
 =?utf-8?B?cUVKdk5RRUptb1JybUlVOW80YUtJZldxc28xSytrRHl0R01Nby9xNDYwK0pS?=
 =?utf-8?B?bWxjVndUa2EwRE91WVIzei9HaGpLVEU1RC9qNDQ0NGVEMStVZ0VaZXhIRE45?=
 =?utf-8?B?aERxczUvdDF5THIvM3YzcXhuR1pSc2puMUUzU2JCS05TNkxpeGVRVzNvaHJ3?=
 =?utf-8?B?Uk9TMWdTNFBIZFhsVmE1TUJjZkM0TG01bFdVYVErT1JyaGZSWmppTVRBY1pq?=
 =?utf-8?B?cGRtejlMMytQM2l4ZklEOXZrbFBITm51RlVuOFZyVXgwbHJNR1hwMHJMUVhK?=
 =?utf-8?B?cHA0aTlCcGZLUnlJYUZ5UGFHWGluVzVXQ25oYjhaUUdVWnFnTEo5RUJUa294?=
 =?utf-8?B?eE9MQmQ1Z2xBV0RCUnZyTm5UVVZwUTJMVjEwaGVzL3lTUkdDMEZrSTBhZ05l?=
 =?utf-8?B?eDBmV0VuNHk4TFlSL2RxUWtqUFIwNnlhZ3RIZ1QxMHBUSHhnV1lYOVZjZ0tW?=
 =?utf-8?B?UHc4czRyMk0rUm9zeS81UDYzT2RsczMzdVNKTEdXS2VNT2YwYjZ3N3hxWndx?=
 =?utf-8?B?WjRXQm9sdStwZWx1elVoT2ZhYU9ydmtaYXdHTkUweVZkcHpPTFlHdEdrQUZi?=
 =?utf-8?B?MFZIblFqM2oxT1BYZDBvM2VpemhVMkwwUzVzVEpKbUlnRGVKeFljN2lPMFdr?=
 =?utf-8?B?bm1BbG53dTNOeERCckFUek1VS2dacitnSW1Td1dGQmFEZUNLY1o2QTYvaitG?=
 =?utf-8?B?RWNmTG4rY0gzbEg1N3ltUk9MUFVRenJZZ1p6K1hsNGhTUXJVUVBMNW1rRkFq?=
 =?utf-8?B?aTIrOEExdVNsL1EvTUs2K1hocWw1TGl1MUg4TVFNcHk5ZlppRXkvZk05MWdp?=
 =?utf-8?B?TE5QODFERFVEWmlMcTFQR0NMTDdjelBCdFVpb3NNWGdvWDVmMkkrZzVFb0hG?=
 =?utf-8?B?VU1wV20zNWg1RVYyNEFuQnZBV243ZmxEemZwYUNmTE9WaUdLMU1QT3FacG9P?=
 =?utf-8?B?MzhGTnVSclFINGc5M0FPYURGR09NYXBZN0RrME85S1VUSWl0OUZFZ1l6ZDA2?=
 =?utf-8?B?NjVaYUZlRUZBMVBUdHVFZ1BZRjFxQjhVcjJoaXBqYUNUSlQ0MnhOQmVlRnk5?=
 =?utf-8?Q?UjG0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d82c5b-366f-41b6-ace1-08db2f9119dd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4065.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 13:34:05.6122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXvUV8PLQlqa/qrenuVyQ9OjQKJC4+DUZtEMQljc9fXOOlzoXKKS7+ky4hkdD+FnXKEA5G3JYizTUU7gLdxCuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR02MB6217
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/23 14:47, Marek Behún wrote:
> On Tue, Mar 28, 2023 at 02:30:37PM +0200, Andrew Lunn wrote:
>>>> +static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
>>>> +{
>>>> +	mv88e6390_watchdog_action(chip, irq);
>>>> +
>>>> +	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
>>>> +			   MV88E6390_G2_WDOG_CTL_UPDATE |
>>>> +			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
>>>> +
>>>> +	return IRQ_HANDLED;
>>>> +}
>>>
>>> Shouldn't this update be in .irq_setup() method? In the commit message
>>> you're saying that the problem is that bits aren't cleared with SW
>>> reset. So I would guess that the change should be in the setup of
>>> watchdog IRQ, not in IRQ action?
>>
>> I think it is a bit more complex than that. At least for the 6352,
>> which i just looked at the data sheet, the interrupt bits are listed
>> as "ROC". Which is missing from the list of definitions, but seems to
>> mean Read Only, Clear on read. So even if it was not cleared on
>> software reset, it would only fire once, and then be cleared.
>>
>> The problem description here is that it does not clear on read, it
>> needs an explicit write. Which suggests Marvell changed it for the
>> 6393.
>>
>> So i have a couple of questions:
>>
>> 1) Is this new behaviour limited to the 6393, or does the 6390 also
>> need this write?
> 
> OK I am looking at the func specs of 6390 and 6393x, at the table
> descrinbing the Data Path Watch Dog Event register (index 0x12 of global
> 2, which is the one being written), and the tables are exactly the same.
> 
> For every non-reserved bit there is the following:
>    This bit is cleared by a SWReset (Global 1 offset 0x04). It will
>    automatically be cleared to zero if the SWReset on WD bit (index 0x13)
>    is set to a one and this event's Func bit is cleared to zero (index
>    0x11).
> 
> Moreover only bit 0 of this register (ForceWD Event) is RWR. Bits 1 to 3
> (EgressWD Event, QC WD Event and CT WD Event) are all RO. Bits 4-7 are
> reserved. (Once again, exactly as in func spec of 6390.)
> 
> So I am not exactly sure what is going on. The errata document I have
> does not mention watch dog at all.
> 
> Marek
> 
>> 2) What about other interrupts? Is this the only one which has changed
>> behaviour?
>>
>> 	Andrew
1) Marvell has confirmed that 6393x (Amethyst) differs from 6390 
(Peridot) with quote: “I tried this on my board and see G2 offset 0x1B 
index 12 bit 0 does not clear, I also tried doing a SWReset and the bit 
is still 1. I did try the same on a Peridot board and it clears as 
advertised.”

2) Marvell are not aware of any other stuck bits, but has confirmed that 
the WD event bits are not cleared on SW reset which is indeed 
contradictory to what the data sheet suggests.

Bug can be reproduced on 6393x with the Force WD event by writing 0x9201 
to G2 offset 0x1b.

Best regards
Gustav
