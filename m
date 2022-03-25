Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DEA4E6E87
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 08:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353766AbiCYHMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 03:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238896AbiCYHMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 03:12:15 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50086.outbound.protection.outlook.com [40.107.5.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8531BD7FA
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 00:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZrCtBTO9K7x+L5yHh+MPTFV0njULkp/S3oH5/AIydEMOtUonqTCCidQied5dnSJu4zKkA/I9W2ZYzfnQJbuvMsp0vnE0u7UQMNY0bEhjBrAuIGXlIDvuHAByexjr2ksXK3/nOPFU8BzKRpT0C5HfiyAkQ6Mv3IQ6GO83gIdJ7sfJGIFAiEhmQKpz7tbeQH6l/jF3DprGQ+QMzhNbgoBkid2qg6SBCToV3RJ/y34zcE57xp5/gtKjK4A3PztK+MNljBBINEC3cX8RQFycbOhP8/M+LtUTkJ29gQ7uQ5n+u6/N5JCNe25i1SBjJmWbP+y4bl7L+y44TYhxN3aoHlzog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5FoNHnR3O59SUKIMZ34WxU2rBNenB+H2eYTWh+uYbA=;
 b=coUIrOhKlzkmNN76tcYLTud/F11Y/rO6W4w+540rWntOE3UYPt1rpYjKo48KwkZsLqVDqPTrgX+Ho6ZrMRTQfWgyt4neuXKgQWbvWiPIixVgoIycUB2EI6x3SzCWixoWpFjEV1WdFqsCWCLP7Zn9r0cEogRFQ2nR5WMBm0wGbZ14pvoN/gn9gHI42UvRmoIXsV0V+007ujEpjRCyVOcnVTAkDvqJpk5YoB2yj9HLPccEshBvQLwT5WX7OMTELy8lSm4HgPVeM7LJZdgZ7YI1qro6iyG2QNpXYEeMtKY6aMWToqOsUASaCeqLtnW4J4jNpEpZ+jf3z+Y9v8IQpBEbkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5FoNHnR3O59SUKIMZ34WxU2rBNenB+H2eYTWh+uYbA=;
 b=vJnlVd/D/skEGttth48Ma/luuoliRZ5UzW6yHqWJSopa5T+H8fZaD/cLdt3h4yPGGNoVhNK9Kf03FT1uuZsSDykVraoNnISRrY4P+1JB9frDBRXbA8OTxipcqtlPDBeIVwJbikpL+DV7snkabm4TAz06Te3zg7D5Mop7nyPasO7hce/SG4odLNjH3kkASGuWNahYrfsUZcwZ46txPuWIGzWMq18BxZp4NutSS67LcF4a8XMFFEvqKxR07qPmkpN8oa1HPExsGBPlSBRbeKgnNDxYazsoFS9CYce0mUDdH7RFOgxmwnC2ywFMy8Z8d72Olv44wRT19x7FdS1thEUmMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AM0PR06MB3937.eurprd06.prod.outlook.com (2603:10a6:208:b2::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Fri, 25 Mar
 2022 07:10:38 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8%7]) with mapi id 15.20.5081.025; Fri, 25 Mar 2022
 07:10:38 +0000
Message-ID: <2f6bbbfc-0776-edb4-2eeb-ed73a8312d63@vaisala.com>
Date:   Fri, 25 Mar 2022 09:10:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v3] net: macb: restart tx after tx used bit read
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com>
 <20220323080820.137579-1-tomas.melin@vaisala.com>
 <20220323084324.37001694@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0085.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:a::8)
 To HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc7cf1cc-330d-4180-fd65-08da0e2e903b
X-MS-TrafficTypeDiagnostic: AM0PR06MB3937:EE_
X-Microsoft-Antispam-PRVS: <AM0PR06MB39378D1FF468FA370C675BECFD1A9@AM0PR06MB3937.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1QAw2W1uHNnk1qLaiEvrCpk1eMAvJLouCsYZ5cpinkjQzxqq25QHdvixbDvnlgPCMcRmg1p2wfahyhjQ5/RZ3BYs4kxgmwhB7b9Ur9+mhZFCOwZoR90NYNPaTipKtZEoWCnE3IHqTJM56Kun0So3T2ZiN2x3bv+tRVGdun6Q9Ye7A+FWx95UCjkCmssuriO97M2UlmuR4uYMnkpCDrobCnviA9oiZ4Um22nbBk3KTJ25UA8IrB3KkvZZ5GUnqBFdu8+SZWgX3ay3cPPvHezjgSZ7gsZkIBJl2WWuCkzZf11atzNOXehiufti0w6893rYIdDVN+0qLh0Bjl0p+oWAFPCPUejdvVEO+sqoH9GTeRFS7Y+eNwRpUBp49VCk2Tn4tL7KVppxYpl6aTvaJ8VURWk0E8qdANm1QE4uM2QSt/sQKJu9X3HQMJBy0Kqm+BhsSHnm4KqCUEMajz+LflwWZuHeDy+5FBYsvMJB4rECBvtnT9PhcYFSiQZq+UVJ0mpFhqpUBc2c7yn3KAZQejbUKmBmkDZo1hptw2HCrKE4jVEfcrvQeBXP9lIsgZG6VTQKBlJUy1eSQXUZMf3yCRMNopfqk6zxOAlbK/Pif5J8YqyHaHdAv/hmfuae7PrqEa6XRl3YjCFtKCNcglKjQTCgK6QyPX1VTeNnMI/gNzBDck2+kgG3BP/u2hpUUtV+euJewv0NAcHo6DSD9bvtmCI2aZbM12hvRCVo4BeiVCSicQz16dU5eyFkiVYnF9NlDFSWcHbh45L9Rg7nGSMIhVNGRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(110136005)(54906003)(316002)(2906002)(31696002)(8936002)(66946007)(38350700002)(38100700002)(8676002)(66556008)(44832011)(5660300002)(4326008)(53546011)(186003)(66476007)(52116002)(2616005)(6506007)(83380400001)(26005)(6486002)(6666004)(6512007)(508600001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjQ4eGUwWFdSbFVGLzduZVFzdklOaWsxLzZrTm8ybVBJMjVOTStvN2xUSjlT?=
 =?utf-8?B?dVdOdzJLdmpaK2NTUGxhUzFDN2J2bkEwdGdqMlluOG44V05BeGFhekNYenVs?=
 =?utf-8?B?OVdtTGRoME1hYTRuWUs2aHhPMWRMRmNJMC9sZTZkd2diVXA3ekYyNDBpRkxI?=
 =?utf-8?B?djR1R2JhT3o3bEwrelREZEx3YyszZm1ZWWhFdDI1UVkzejh0Q0JjRk1ZMWJC?=
 =?utf-8?B?K3NaNXhwcForYnF6UzlBTTR4RmdaMFVtc1JTVzNYM2RJVnN6VTBFcWt3RTVv?=
 =?utf-8?B?dXBkRGhuWjhJdzU0TFBid2xiK3htYWE4a3QvenhsdTBGYTdDTjJMRzJpK2J3?=
 =?utf-8?B?S2MzbXV4ZXh2Q0lCbS9Tdk1VUWFZQ3dRaUlDYng3NlJvMTdaYmVzQ2tENEJx?=
 =?utf-8?B?VEtocm1GNnFwWXMvQmMveVo0ME1zVnNnMGZSTW9MZUR0U0tZVHZWeUhmKzl6?=
 =?utf-8?B?SmpWTnMrU3VKQjBEYkVIenFMeGN5YUx2eUo3OVBHYmJjRjJORFJlYzU0dEZ3?=
 =?utf-8?B?eHNOcWU3US9Ed0dCYlFzT3RhVDJsenphUUY3ZXBXN1EvZ2JkY2ptakM5RmFV?=
 =?utf-8?B?VnpJbVBPeWp3UGR5ODV2K3RjUG44UW8zblpKd1I5SUY1cGtvRVQvV0pzL2pO?=
 =?utf-8?B?cU1kN0U2cXNaLzdxejRCSlNqbmFldVg0NEtVQm1MdmdjcTk0T2FQUXF1ejlB?=
 =?utf-8?B?TldYd0VrcHVmQklDUUdFNFNjaWRXOW5pTm1QN2ZFL1RRMSt0WHoxR253dlVp?=
 =?utf-8?B?a1UySjRXTmgyWWFma3NidlF0R0ZWbmFyNVBVNUk1dkZzaDJkdm5SeE5BWWdk?=
 =?utf-8?B?dy9kMWpQQkE1SnNJVGZXbjNkQmVrMVFxeHphZXRkMW1sTmtSRG9HMENGOENG?=
 =?utf-8?B?VGtESU4relY1L0ZiSHplNG0zcDJ1TkZDbVNaa1QzQThDY25kemNWZENaSkx6?=
 =?utf-8?B?dUNqS01oUm1JQ0ZLYXpVTXFFbEFqRTBPNmFCMmJWaUJMMENsay9oTXViakJN?=
 =?utf-8?B?OHZJbktSeGhwZ3RmSlp3Zlh1dHFVTkhySE1RTElQTkw2MzloZGNZVXk2YkRu?=
 =?utf-8?B?TVdQU0E5MkdZOTlodnVZV0Zkak1kOUU3VmpOSG56L0NrbHNDK0syOHNkT2dL?=
 =?utf-8?B?YnR4dTI4dnQzOWxBMGt6STFSM1J4WTB3QTlJaENkTmdGZUg5S3lPSHJYcGlj?=
 =?utf-8?B?cVZPZThWcXJOSmdBOXp1a3ZqakZUY0VGR0ErSExLeXZBS1Nsblc2akN2bGEy?=
 =?utf-8?B?YkQzK2syU0ViQ2x1ZWxvTUhxSWhQcHJldnZBSHFHeFNUOTdxL1M5RUZQMzg5?=
 =?utf-8?B?Q2psZUprNWt3cnNXMU5DRFFrdVpwVUVBOEd3VjZsbEs0eEY4dWxDbnFUYkVl?=
 =?utf-8?B?UU9mNmloQUNEejFXSy91dk5iUTR4dHFkZG13bkFSWkRva2pEbXNwT3VKck95?=
 =?utf-8?B?ZWhxM3NiWFlPbWZSUXdzcDJjQXE3ZUFZN0VCbkthYUszWWJWNkhRcThaOCtJ?=
 =?utf-8?B?TnRRS0pKNGtxT0h0ZzFkYys4WlNaV0QzMGl2R0o0L2xERytMSUhZZFRaNWZs?=
 =?utf-8?B?bHhVLzJSSUhyankyT3BBQnQ5M29pajVpODVCeFJvSmNTMm9HS0xiUE1sVGk1?=
 =?utf-8?B?dWFYWG5zbUhRMEY5UEZoVmoyR3RhdXRoeUs3alZWdDZJTG9vZ0dpN1BxRk1w?=
 =?utf-8?B?RDVaaTk5Q1BjaXpiaTlZZTJhU09laCtPYndXTGUvTDIrU0xCdVZDN3A5K1BQ?=
 =?utf-8?B?ZG4rYnBGOWlxSng3cHJ3R1YwSVRCTWZUeHhZbjE1M3p1SmRoaDFmVHZHc1Yx?=
 =?utf-8?B?YUFLamdFVXdPZEc0WlpnemFlVndZM2pLWStJeTQrUjlIK1JUUEQyeUlLVlR6?=
 =?utf-8?B?Y0F1U0pma0hIanpsMjBrcmlJcEJNTVU3NTg5VVc5dXdqUTZTeXJreS9DMUMx?=
 =?utf-8?B?R3FDNVdMQmpFVmM3bEJOSWgwK3FjNFRoLytYY0lmMWJYeEF4SUhVU1RJeldF?=
 =?utf-8?B?NWg3T0k3eWFVSEVUSUJyaTBCUUZlMEhPd0JSc25XNEJtVlREYW9mWENNZEM5?=
 =?utf-8?B?cjFBYmIzR2hGaGpHTjB3c0J2S0tMcXVnWmpaYk5nY2gzTWx3SVNWQjlPYkxt?=
 =?utf-8?B?SFF4N1pldyt4WVN6cXI2V1hRUU9iSHArZ0draURjWG5QQ1pIbWlaTkZCUmR5?=
 =?utf-8?B?bnlOdk5ZL08wUTRNaG9YWE5wS3I4eVVjU2tYOTRXQ1RzQVh0cWt1aGVhNTdw?=
 =?utf-8?B?a3FhY2xFZVpFM0MyblNSbGVuR04xNm5sWTlOSEZYMVZQTFloRDBrNkw3eEVa?=
 =?utf-8?B?T2Z2VkNxOGVVVVRsNXlDbzF1bnRvc0NzVzh5S3hydVI4R0c4U0J2d1VoM0lD?=
 =?utf-8?Q?rk/XMj8UO3ZL/vno=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7cf1cc-330d-4180-fd65-08da0e2e903b
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 07:10:38.0293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QW3Moep7lj8gFArZfL1sqzMqyLb39lrKGNbSGhVjRVPJ91qvJaak71N0/zLgewmAvQtf3xCmPWX3CJddk5BsQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB3937
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 23/03/2022 18:42, Robert Hancock wrote:
> On Wed, 2022-03-23 at 08:43 -0700, Jakub Kicinski wrote:
>> On Wed, 23 Mar 2022 10:08:20 +0200 Tomas Melin wrote:
>>>> From: <Claudiu.Beznea@microchip.com>
>>>> To: <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>
>>>> Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
>>>> 	<Claudiu.Beznea@microchip.com>
>>>> Subject: [PATCH v3] net: macb: restart tx after tx used bit read
>>>> Date: Mon, 17 Dec 2018 10:02:42 +0000	[thread overview]
>>>> Message-ID: <
>>>> 1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com> (raw)
>>>>
>>>> From: Claudiu Beznea <claudiu.beznea@microchip.com>
>>>>
>>>> On some platforms (currently detected only on SAMA5D4) TX might stuck
>>>> even the pachets are still present in DMA memories and TX start was
>>>> issued for them. This happens due to race condition between MACB driver
>>>> updating next TX buffer descriptor to be used and IP reading the same
>>>> descriptor. In such a case, the "TX USED BIT READ" interrupt is asserted.
>>>> GEM/MACB user guide specifies that if a "TX USED BIT READ" interrupt
>>>> is asserted TX must be restarted. Restart TX if used bit is read and
>>>> packets are present in software TX queue. Packets are removed from
>>>> software
>>>> TX queue if TX was successful for them (see macb_tx_interrupt()).
>>>>
>>>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>>>
>>> On Xilinx Zynq the above change can cause infinite interrupt loop leading
>>> to CPU stall. Seems timing/load needs to be appropriate for this to happen,
>>> and currently
>>> with 1G ethernet this can be triggered normally within minutes when running
>>> stress tests
>>> on the network interface.
>>>
>>> The events leading up to the interrupt looping are similar as the issue
>>> described in the
>>> commit message. However in our case, restarting TX does not help at all.
>>> Instead
>>> the controller is stuck on the queue end descriptor generating endless
>>> TX_USED
>>> interrupts, never breaking out of interrupt routine.
>>>
>>> Any chance you remember more details about in which situation restarting TX
>>> helped for
>>> your use case? was tx_qbar at the end of frame or stopped in middle of
>>> frame?
>>
>> Which kernel version are you using? Robert has been working on macb +
>> Zynq recently, adding him to CC.

This was originally seen on 4.19.x series kernel, but the same issue is 
also present with 5.10.x series kernels. I have tried looking, but did 
not see any changes which would seem related to this particular issues 
neither in newer mainline kernels or xilinx tree.

These stall issues have surfaced as CPU load and timing has changed, 
even with the same kernel version. So it seems rather likely that it 
needs the correct timing to get triggered.

> 
> We have been working with ZynqMP and haven't seen such isses in the past, but
> I'm not sure we've tried the same type of stress test on those interfaces. If
> by Zynq, Tomas means the Zynq-7000 series, that might be a different
> version/revision of the IP core than we have as well.
Indeed, this is the Zynq-7000 series.

> 
> I haven't looked at the TX ring descriptor and register setup on this core in
> that much detail, but the fact the controller gets into this "TX used bit read"
> state in the first place seems unusual. I'm wondering if something is being
> done in the wrong order or if we are missing a memory barrier etc?
> 
I agree that it could be something like that, or then the controller 
gets into some unknown state that makes the transmission halt until more 
data gets pushed into the buffer.

I have a proposal for improving on the original tx restart approach, and 
recently posted it to the list. With that patch applied, have not been 
able to cause any stall sitations during stress testing anymore.

Thanks,
Tomas

