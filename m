Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29633587B09
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbiHBKwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbiHBKwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:52:11 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140072.outbound.protection.outlook.com [40.107.14.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B4518B1A
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 03:52:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXggADznNiA4bDgeePT6KG7e/EMZ3nyRe5glSXimgxqVPNxW3WikDg+kWvsbcWDVfpV++VX9XbjzKs6cGWoaUg2EKmzWRc4l+Ugdk4tMt0DZFsN+RIy1D5u5lqr6xD6TQIiVfM6BTOEiOXhhfsOlePYeb1hGocEqkKadngXDZpzn4GH+dEDFDmG6KNUgHyRp8JL/dYZX/DJ0287SfHdG4Hph37JdQRR68EZvCp+9CWQmwRgLeyFJDElDgaDdXXkeyfuHa4kowdf5vnEJST2FUWJaNuMfZV14t0iUXv+aY9Uprkjl0K+6mX7kDYySW5ANH5DuZGPVxn8f7ABvnRe87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vy31jhPrnAk8WVuhJCLQ+PqO3GJwzgnxII4b/ipQu+0=;
 b=YvFW3veWWxfulAS2kSaCaVMbPy9BY58wfWYiDy2rKU/7qYlHYZe3JIx6wsHqhDITksriGJhehEO+Y/VGg7tvREDUYsETd/ZVmVqtP3lX4c8UixHQNoW9CD5L/Trk/x2Tse95CX2fg2u+Bs3O3EOECef3UDefZsY9PckhShmiXAALZy0sE0LiZie6wfeWkDBAfQS8gATLrnrZI4eDv4yLh2yOineyFqfCamLreRzGBz5QXEBnuVenVlLOUqCKAeH9c0oFUghTdLVFroNk9L8mlfyRFxsYvP0rfgPJZGrCOSvAQdzJvhNbGjA+HBXH8xNHKkELVyZqPkA7N7rnDWnPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy31jhPrnAk8WVuhJCLQ+PqO3GJwzgnxII4b/ipQu+0=;
 b=se41pPn/xV9zh3NngJiZU0Xx/RkZMJTgQJef50uynl94txUY+Qpt6Hj6Q+Z5tRWucsBMTvPkmWYoXMiiCyVDIu6WDsEUcFQdrumCySOPRBlbnrdOg2iC0ewdUfS5MLDY1ezUPwqDyzQ5v6IhenQny/6zTc4c/vFCSo6cHbGBwe7NHDSKsXjD5J2Oo1v5eu4Ih76UouLcjdOrc0CXubqIreD/uWvvJVo2wtFTZsQSVFe41WhyffYLOTpcr6aGlkVDTUb6BHZUd9hnPaPueiNY7sthhcMXob5x22TWTfxSh2h7Ob4Ar7w/AwSagIM/O+rX0krB/8lT8m4ZHudMMlYSFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM0PR04MB4353.eurprd04.prod.outlook.com
 (2603:10a6:208:65::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Tue, 2 Aug
 2022 10:52:07 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6%8]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 10:52:07 +0000
Message-ID: <34f7cb15-91e8-e92c-7dcd-f5b28724df92@suse.com>
Date:   Tue, 2 Aug 2022 12:52:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] r8152: pass through needs to be singular
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
References: <20220728191851.30402-1-oneukum@suse.com>
 <YuMJhAuZVVZtl9VZ@lunn.ch>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YuMJhAuZVVZtl9VZ@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0108.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::49) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc63b26b-5e9b-470b-e980-08da74750ae9
X-MS-TrafficTypeDiagnostic: AM0PR04MB4353:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzqJav5RXFfckfo0rR+CEVtv7BdrGjQ9mc2xldKhKHQvI6FY8J0X9U36U9EPVAPe5HwG71oN9bLmV/+x/DJYYCtT0DGANW0kBGAhLeZihKnyMjdhU9t6wZs2gxWekh7gkJPUPtZDn8yHCVAxO9fW3ujgBkg6dpR4KCRaM7Im43EDE7AaLTXEfAvbPJJA7U7SxXxSUGU7DwX3mHgqj71z6+5cH9VVc9K6/+3XZpRS+qOUBoZzUKT3LgEk9xpU4fBo69zBakkfjtHQyF2yuCYGKtcBzyjz4HvRonz++nvE0Nk5YIPYRgSj1XCc3lLcKgYeE01XVtALzkBUOnueJU7GmEpErsiiNDtQutaIE4xb5iA3Zo5rWuXuD1OeYAdOknjFxQjfOx4R4SmacOtzy2MSAXA0z6RP2A3K3JpqzsGW5ehrBScQ0KMP375vGdi3SgagZzDzyJIRZ10TSadmBEPCHe6QUnNhwRn/Lq3GOBdXkVEROsXgOeuiTgy/Id04UtDtJuebLxI+90vGcbQXclz/rrfzIPTcGOUV4nUPE9L8uahHq2fuv/FPdpaldVLVp8XdB/CePC34e1hALmN3OyRY97gPwzJPJQHTGjRCL7juS6kl86R5bSEMeyooXmrSbaRcACxK58pUyG3YX90c4DBYO7/MeltEv0EFLHwacfx1EStR7NvMH9BlFtZk58evlmXPM/FJX7gT5uB1lpmW/W8ksso9lRhlaRSgDgwwz5Q0q+hKR7whbJhJbhN4pd86Qp0A6B6Cc2lmn4jNuIGWuBs98RM/eqhS1VTfXe3QudCYf1tx1Yd4fRhdSFa3FwMrJ2Ge
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(39860400002)(136003)(396003)(186003)(38100700002)(83380400001)(2616005)(4326008)(66476007)(66556008)(66946007)(36756003)(8676002)(110136005)(316002)(31686004)(8936002)(6512007)(478600001)(6486002)(6506007)(86362001)(53546011)(2906002)(31696002)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTFYaHc2VXVzM0hpYWpMTGlOa1BKUDNSUmRoVHdWdFRCdEFDNVFkcEF1ZDJE?=
 =?utf-8?B?dEpSc2d3OVJ3UkhvOWp0NFRROFNJTDhwTG80Q0FIKzJDVE9EUjd3MEVCZk4r?=
 =?utf-8?B?U0xtV3BoL212M0NqdHJRQ2ErZ2o0SCtCcU8yTGpDZ09CaStibXUxRkk0eW43?=
 =?utf-8?B?cmlxSmkzR0ZaVkNlbEswOFN1cjNsdGhyeHFyQ3d6UVp6Ti9ITEU3K1BJM2JO?=
 =?utf-8?B?bWlOZkVVKzBoZ2V3RVhZN042UTFGckFXa01MbE1jSlhiYlBOUUJkeVNrWks0?=
 =?utf-8?B?OVhTMlp1ZCtYa0VsTzNsamd4K3p5T2VGMEVDWU9aS0VKcnpGK0ljTTdYUmJS?=
 =?utf-8?B?TlpBWmJ4eHhYNitQenBLUWVaNWg0Nm1HaXR5bkUxQTJkRnM2MGZLaEw1Yi83?=
 =?utf-8?B?Q0FOcU9DK0JYRHNWbW1PU0srQ1ZXL3Jici9hNzNSZ25ONWFSWVI5OXh2RlJE?=
 =?utf-8?B?d3FmMGNaTTh0TlA4TmNQcnhPMjluVGdNSHhhRUp2NUdicXhleTgvSkN5VWx0?=
 =?utf-8?B?WEhNaENOb1BCRTVPTldQOXl6SHJ3aXBta01ySmJrT2tmOXRmd3dXUG15T0cy?=
 =?utf-8?B?RTdTMTZlbTNSV3FxVVdvUEkwVmpYdGlRcy9FdXQ0SzBZd3NoMGYwNE9CRmdj?=
 =?utf-8?B?bmtMNldUL240R09PcG55VVR5QWVDSEtQREpWbWNYZUFyQXU2VG9hN3ZjWHVT?=
 =?utf-8?B?TkthdmhTTDRscTJrWU5HV0U1SW52ZTA5WFZDVDl0eHNrOXNrTDEwdDYxbGti?=
 =?utf-8?B?WmdHWjlIN0w5R0pUdVkyYWNXT3RHZnRVVllQblNzaDdOMnBUTzAwemFQcGNP?=
 =?utf-8?B?Ulo4eVovKzFYZVhUckRMblBmVHZCYnhMTVpVNGNlUXg0NE9CVHlCMXM3Zys4?=
 =?utf-8?B?ZFd2bDQrQ2pVZ25NZUlBbHBZU3Q5dTNWV1hWZ3QvM2RBY0d1OHIvOFB5S0V5?=
 =?utf-8?B?amhNNTdIa0NBN0V4Sk1iNVllb2NYRmFnS1hraXIvMWFCR2VCQmpjUldYWFZG?=
 =?utf-8?B?RmVaaThTNWRiRGM5eHhPaytJRjRtSVNidzNaQUxaTXZ3NWU4d0VZZU10MXBT?=
 =?utf-8?B?ellTazhESnluc0NKc3VKeG1oZjBvNjFMWUQ4bmYxTW9nbVJpak8xSVRnb2FY?=
 =?utf-8?B?aWxwL2xPalF2aGUzM29RRHh4RXZEYXExRHpFQnBJcnVKNFg2UzMvWnpac0tx?=
 =?utf-8?B?bnEzK25YQXFlUk5JNVlCSkVWRGhINzROUENrUVhPc2x2dUhEdFh0aTdoSG1x?=
 =?utf-8?B?WFRSdmwrUk9idnMweXozMzFMTzdyV29QaVYvYkl1N3huNGc2Wkl0VWZyaXhX?=
 =?utf-8?B?UlVpYVdGTzVhSVNEQjkwZkppNUhuZEVpNWJFeXh6R20zWXI4d1hjRFRVa09a?=
 =?utf-8?B?UDVuZ0F5bENtQ0E5NE82VURNL2xvMFdRZmtxR0JmdldnZzNPZVFtekEyQ2ZI?=
 =?utf-8?B?Q3lkSFF2UXl4cnR3SzhEZVd4eUdFaDBIUlp2WFRxejZnV0lCMnJJcGtTMmhR?=
 =?utf-8?B?NXd0d3kzYkNQekNjQ3JQY09DbVVjT1NPV29lK29RUmRxZ0xOTlJVSXcySmxp?=
 =?utf-8?B?dWZGVTdHaVdUdjF3Zko1bUZqQURJL1hORWU5QnlKZnhzNlRjZUY5bUd0VDBB?=
 =?utf-8?B?cVp3bnRmbGh6N3JHN0NmV3dSU0tMVVNkMFV2eXhzUkdEMk1xd0FQbWxSZENw?=
 =?utf-8?B?U2R6VEhSSVVRL0MwalNsWWxNMGlkelFSUDdQTlBoWmxpR2ZMcHc4bURMVy9J?=
 =?utf-8?B?Wi9CNzUwdm5zQ3d4aVAyb2UvMm1UL1ZMNTZLajhHVHVhOEM5dEJkOVdiKzF5?=
 =?utf-8?B?NHhxV2hWYml0ZTFxeUhOWXh2WnJLZlVMNU8vMDZhckxyL3duVE1EVWRmUWJE?=
 =?utf-8?B?RG5vK25UaXR3N2t2Z1JYNi9LMUlQQVN1YW41cHg3MHE3YS9JMWxKVVlaRy9z?=
 =?utf-8?B?YW5OTnVQZmJ2MWRoOFVJMVhEaGpBREFpUFpzRSsvcG1IOUdHenBaQTBqdVhj?=
 =?utf-8?B?MUlDWDZmWUhUQklZWjdOUlJnYVc2T3U5dWFzdGtJTzdoZmJuSHgyT0QrVDR1?=
 =?utf-8?B?c3JaekVWSHpXUmxUaHplRCtSVmJDaUhYNlkzZ2R6bVJia1hxZVp3MUI3ZnVs?=
 =?utf-8?B?V0IwY1ArM1FDZTNPRG03cTNjOXQvZ0t1TGhPV0haZ1ZtK2hGNVpwdHdLVTZW?=
 =?utf-8?Q?3vbftK10hUAJUB5MKOKJUwNEjjafP/eE24UbTJGJQbqb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc63b26b-5e9b-470b-e980-08da74750ae9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 10:52:07.1318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iptlpc9jFxcmwvNq3MtkcynUYfhFXbRQZBnywpNtk6cbdc1Su4h22RQzXYlaaY3SyE0TsKJHfu/E/k+vpib4yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4353
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29.07.22 00:11, Andrew Lunn wrote:
> On Thu, Jul 28, 2022 at 09:18:51PM +0200, Oliver Neukum wrote:
>> If multiple devices are connected only one of them
>> is allowed to get the pass through MAC
> 
> Is that true? Ethernet switches often use the same MAC address on
> multiple ports. It is not inherently broken to have the same MAC
> address on multiple interfaces.

Well, yes, but for a host to assigning the same MAC by default
is a bug. The whole point of MACs is kind of that they be unique.
For the same reason I fixed usbnet to not hand out the same
random address. In theory I have broken setups which relied on
people reconnecting a device getting the same MAC.

> We know this implementation of pass through it very broken, but
> unfortunately, it is there, and we have to follow the normal
> regression rules, even if we really would like to throw it all out.

True. Nevertheless, do we really want to say that we dislike a design
so much that we are not fixing bugs?

> What exactly is your problem which you are trying to fix? 
Adressing the comment Hayes made when reset_resume() was fixed
from a deadlock, that it still assigns wrong MACs. I feel that
before I fix keeping the correct address I better make sure the
MAC is sane in the first place.

	Regards
		Oliver

