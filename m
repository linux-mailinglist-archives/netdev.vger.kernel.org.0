Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB102FD0B7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbhATMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:50:17 -0500
Received: from mail-eopbgr150133.outbound.protection.outlook.com ([40.107.15.133]:19521
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728864AbhATLeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 06:34:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYxCSOMpgSkVWaLMsK7xVh4WlQgBvY51kSdV3A3SIUNdYRjpEMh/0kw5gsPFeFhMgzl/DB5DEBfVewPJBYhC/oldwoVF0a0Ni12a4yb0lk/2qRt5jtQOjfe6MCbgeKCX19eTFgChCe/xf0TO70EAnQ7x5X8p8GO7LWA412wFiHvHC1RV/GZkds0YqcLVQfJgK2yLKBPEA0ANl71BDAOZudvxSyQFDxZIpr85E69aF9+KvzYje88SJZmtze+SkcOnCLme5QNfSJsLBtIY4fYuDeJFjvABwePcy1UQZaw8Qe5Xos37i+8t9h/kEiml8FVNjXTPJlE6RL1agdjTerPBPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ew4duM2f5oNHXi5ncXyGbFFqbpEHWVStla0dT2hSoNc=;
 b=UfTK4v4xCUtxOc1zLVRrkPwfKTA8hPybQG5epSt/+U9g8CCNLYaeO/Ew/DLLEaVxDdDLHEoKDIUo6prk9ILE12RayUlNqSlsJ6JV8+ub1XorqbrTO47utN+tkWBhKsa/1J2BX68SiTelv252a9yyGplc4R1cTRzDGFrUCvZpK9dd31Z4cuZdOrLRuTCC3UyEsndKNPVslEKSsxakCh29j3LfM2gtbYgZ7ylBGx4rmPaj3uZpaXh35V7MrAMeRW7GlB639ja1A3hWhFjY6XRZUDs90TDpZxPg3K+NFhAj9Ue1mgCE57ECQalA2TZYfRMd1FMcxkMgzzK1RHe1bGBM9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ew4duM2f5oNHXi5ncXyGbFFqbpEHWVStla0dT2hSoNc=;
 b=EcHYw15KoVzSC9kcroBtwUAbVwEiM+yZa0xykZw1+Dwlem2m881nTCZ80DaTVEJD9YdAkBAcidote6DZc5qmP13oFgKXQEsikFebtNZ/FUCHuiGMgGIzNbycXXcnSoOt1JmQ+nw2rge2U36JvN0LcJNdIIGAOm4295WQiklG8uo=
Authentication-Results: infinera.com; dkim=none (message not signed)
 header.d=none;infinera.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2113.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:4b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 20 Jan
 2021 11:33:34 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 11:33:34 +0000
Subject: Re: [PATCH net-next v2 13/17] ethernet: ucc_geth: remove bd_mem_part
 and all associated code
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
 <20210119150802.19997-14-rasmus.villemoes@prevas.dk>
 <58e13bb0-11fa-95e7-e9d9-acc649af4df7@csgroup.eu>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <8c31cc00-b1bc-cefa-8ea8-5907b8fbe6ef@prevas.dk>
Date:   Wed, 20 Jan 2021 12:33:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <58e13bb0-11fa-95e7-e9d9-acc649af4df7@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P193CA0085.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::26) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P193CA0085.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 20 Jan 2021 11:33:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f554ec0-53ec-4e3a-9515-08d8bd3738bd
X-MS-TrafficTypeDiagnostic: AM0PR10MB2113:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2113B3CD9088E63842BB396D93A20@AM0PR10MB2113.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PhPAigk73VaT2BBwmDERxI23WMoN2I9KrrF+4vtmPgIW3VEjkomg7fAIibSbiuJ/qQXYt7kzSwcIHFa3AnfQ2rTmjnv9HCA9+2xdmeHIPCK233iKoPCqnk6xSCuOW3d1ijty0lw1MjnQBORckSgD+8rctkwIWztHRx871x3H/wJO3m/94htfLrh/KXf0rTUgzc49nHA7dXM6zG47fH1J90C3R2tpydyoj4q5JxceWI2d0Mgk8uMAsYzflkm6nGi8SYoZi9/8iiqeX99Jul7ZPtAR57SJ80uFM83h5Wx2HQImDY21onAgiwf7nbUc+l5oG7kcnwCCMxt8m/wKjOs9ExrVWRWkl1i4d1V4Osgz/0WSU0BbJXUBsGOsq3LNVYfaYB9h662Q5DNV1lNTKk+Rva/DxV2N1En+L/s6wX6vIQ1tQ4gC5trnPRT/mYcIIL/Rg4NZdTyqFxAeMycxDLtpNkRHXifqRFu4M5LaPatj6kY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39840400004)(396003)(346002)(52116002)(8676002)(4326008)(956004)(54906003)(2616005)(44832011)(83380400001)(66574015)(31696002)(5660300002)(6486002)(186003)(16526019)(8976002)(31686004)(8936002)(26005)(16576012)(316002)(478600001)(66556008)(66476007)(2906002)(36756003)(66946007)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VStoSUo3YllaRG83bWQ1LzlxYmZBVXRJTTBYc01jajN0OWpNOGo4K1BZK2lT?=
 =?utf-8?B?YXpwb3p2akpKNXdoM3RKbDNIQ0NGa2ZUb3JKZmo2NytyQktBWC9qWHdCdGoz?=
 =?utf-8?B?eWk3VEtiN3A0YzZSRUl5NjlKdGdacjJjTlBGWDZBR2ltcjZzbUdFbXdEc3BB?=
 =?utf-8?B?YXNScDdDeHVnT2p2Vm4zR3h4Y05pNTBpWUcrN3NOamNtRTQzNlFSazZWWHBL?=
 =?utf-8?B?Y0E1dDJ2K3ljdzdlRUN2R0FWY1pSemErVFdGRjJSWlpSdGN3M1ZXQnM5dzUx?=
 =?utf-8?B?RGozOU9WbTlCYmdTa0Z5WWNkMnAvMDJOckwrMmFFd2JSTEd6MGcxSTNlSWY2?=
 =?utf-8?B?WGQyZ2ozZ2x5RHF6Zkdnc2xCNWxzdG55UmFkOXVIRG1YZitya1B5QWNTTkdw?=
 =?utf-8?B?WXBib05VSmRkWE83Yzh4RUFmbjNKWnplYnFUNTdPTnZmYjJ3cHBBNGE3Wjls?=
 =?utf-8?B?YnRNd2o2amFRWG9ZbXp0OWhVREZ6R1RRWjFKekZkVk5xNjF4aThOdmY1THdn?=
 =?utf-8?B?RWt1QUdNeUdGN0NublIrNHpaRC94OGcySUxBRmgrdnJVUWNzY1RadFY1YS9H?=
 =?utf-8?B?QmowSUttTUZNdm9IYjN0QzZ3VmVKRngwdGN5UmY3R2dNWS80OWtsd0NLaUZR?=
 =?utf-8?B?Y3dpSDVyYncrTmExTEUrQ0crbHd3WVVha2J4dDFaU0tPVVlyOG1yNmVwMTZL?=
 =?utf-8?B?WnkxSTRvTDk1UGV6Ykg4SFYxajBYWDVFRjdZR3BhaitBUHRpU0NkYVEzNXVr?=
 =?utf-8?B?SURibHJaekdlRFV2RkxCdGpQYXlHYnAxNGNxWnpPa2F5by82cjA1UUMwQUNJ?=
 =?utf-8?B?d2xwa2tOQmgrMTkzdnRQbEd0dDQvKzU4aXRZQkJCVFUycUlYdFpsVFphUFll?=
 =?utf-8?B?VGVYd21qVnUrUHlNekhpUU9wYnVZU21lS2xRUzJNdWM4MGRDQ1p0ZFJHZi85?=
 =?utf-8?B?Z1dzc2gzZ0RyL2xWZnQ3K3BpSnBGQzRlRmM5bUV0dkJoc0xsdGJsd3VlaGtP?=
 =?utf-8?B?QjI5dHZ2UTFQTVdYaFd0L3RiSGVFVmt6SnJnUFMxNS9mZGlCMnI0dzZ6dFA4?=
 =?utf-8?B?ajZpeXdRdW1zd0tLT1BJT0sxbXJLTzE5R0U3RlczTWVibWw0S2JSQ1BDMGNt?=
 =?utf-8?B?eXJmSkxRRldCSW1NQzNlQjZVdVBVTEJ4Y1VuQnFhcFI3c0NBOFRyaWVmakpF?=
 =?utf-8?B?KzBIMTZQcDkwL2puSW8wbE01SzViUWUxMjRIZkVydkExRG05Y2lXNHN1dm1T?=
 =?utf-8?B?M1ZjeGwvZFN5ZGhFWUs1SXFKSUgrUG5nVElCZUhoWWsxTG94cFh2S21kcUx2?=
 =?utf-8?Q?YpcplEZoSwbL21nQbkcYeImKh0Thy7R7j9?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f554ec0-53ec-4e3a-9515-08d8bd3738bd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2021 11:33:34.8842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WjdKaFPBFYOP4HMO1rLH1wFZYXHHNk4NsnvN0oR/B4PvCjj2+gfzXQnmdqXfD/JbAVX7aul4wNIP3HBcDezpogGV/TBOsFnqBqqeF1V/4Rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2021 08.17, Christophe Leroy wrote:
> 
> Le 19/01/2021 à 16:07, Rasmus Villemoes a écrit :
>> The bd_mem_part member of ucc_geth_info always has the value
>> MEM_PART_SYSTEM, and AFAICT, there has never been any code setting it
>> to any other value. Moreover, muram is a somewhat precious resource,
>> so there's no point using that when normal memory serves just as well.
>>
>> Apart from removing a lot of dead code, this is also motivated by
>> wanting to clean up the "store result from kmalloc() in a u32" mess.
>>
>> @@ -2195,25 +2179,15 @@ static int ucc_geth_alloc_tx(struct
>> ucc_geth_private *ugeth)
>>           if ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)) %
>>               UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
>>               length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
>> -        }
>> +
>> +        ugeth->tx_bd_ring_offset[j] =
>> +            (u32) kmalloc((u32) (length + align), GFP_KERNEL);
> 
> Can't this fit on a single ? Nowadays, max allowed line length is 100
> chars.
> 
>> +
>> +        if (ugeth->tx_bd_ring_offset[j] != 0)
>> +            ugeth->p_tx_bd_ring[j] =
>> +                (u8 __iomem *)((ugeth->tx_bd_ring_offset[j] +
>> +                        align) & ~(align - 1));
> 
> Can we get the above fit on only 2 lines ?
> 
>> +
>> -        }
>> +        ugeth->rx_bd_ring_offset[j] =
>> +            (u32) kmalloc((u32) (length + align), GFP_KERNEL);
> 
> Same.

This is all deliberate: Verifying that this patch merely removes the
dead branch (and thus outdenting the always-taken branch) is easily done
by using "git show -w". That shows hunks like

@@ -2554,20 +2519,11 @@ static int ucc_geth_startup(struct
ucc_geth_private *ugeth)
                endOfRing =
                    ugeth->p_tx_bd_ring[i] + (ug_info->bdRingLenTx[i] -
                                              1) * sizeof(struct qe_bd);
-               if (ugeth->ug_info->uf_info.bd_mem_part ==
MEM_PART_SYSTEM) {
                out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
                         (u32) virt_to_phys(ugeth->p_tx_bd_ring[i]));
                out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
                         last_bd_completed_address,
                         (u32) virt_to_phys(endOfRing));
-               } else if (ugeth->ug_info->uf_info.bd_mem_part ==
-                          MEM_PART_MURAM) {
-
out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
-                                (u32)qe_muram_dma(ugeth->p_tx_bd_ring[i]));
-                       out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
-                                last_bd_completed_address,
-                                (u32)qe_muram_dma(endOfRing));
-               }
        }

So I didn't want to rewrap any of the lines.

Rasmus
