Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487B72D3330
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbgLHUQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:10 -0500
Received: from mail-eopbgr150100.outbound.protection.outlook.com ([40.107.15.100]:50499
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731118AbgLHUNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:13:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5SvpvZTVbM93v87HEFh7GpR+AG2KdwE9Fshtd3DgRCR82ExSPENjsTHxtrmDHtUJkwBH0bFokJ4KnBlM1jE/LS3ezeQRg1DU4i/AEiywbwts8fgAa0jem6zz5zhw1UHAPHq35/Cle31EL/A5s6QqvD2jy0YLUkFVjojJrSBDS3oz+PPWcYM+va8YnxfdYuuVPY3FhBEc7l2FTD0a2VIOFpeHQGd5qq++ZRi4fHaBPxOjhyJYpJhmnPVkNaROFVFy8cb+3snsrATHNTnYiqMShkZW6kf1dOYQjcKEjf2s0JSiPWP2RhLBWOs1+hl+ZAHD93kp+l9gpvucpYNSD9vQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJHmbv58TPvR+vptGIBaRrbMiZHMzZt5e0r20CgooM4=;
 b=gSAuMmUSPi42VW9reoVIoZtfInuT2Mbg2azsxvAOgBLzYIVsNldDwfLUMo/LIsBoWr5cLTmgORbxgAq0sujV7JpYJvJgTQ6nd6MjVsJqVkyh6/KmigO1FxAXGQXqzlqjblm7zxnA6UjxMdo14kd04Gxx+dVnQ7+rhtyMj0fYmUxL1sAnPzn+DH9W4tqezu3b6PO3uOlaDSi+bxE9PBLXzuSHzSc6+UDjm2UECept5HzDff94z9/IIYDmPuCAlasDxIDWKNgYKOT++B9Z+kmBVuFbzDLdDPAxy1bFjapuDU7fvrBhjQkOMk/sRIaZ8y1H1jjhcwQdW79grMoifxFhxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJHmbv58TPvR+vptGIBaRrbMiZHMzZt5e0r20CgooM4=;
 b=a1AWdvR1ahX0GbLB0Muwc7+c+SipoI8CBA18mz0cWa6w8xvno4w77XhOiLDPNVmgHlm+qzn1KfH/5jrGVdfjwaQiRR/oCW+NnBQTrzyUt6A5O1rFvbVzy4kiLOHMaqEnpmN5ss6PmjnoYqHDgktwdLAzNIs0XnIoQGxtnU3vil4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM8PR10MB3988.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 20:12:58 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 20:12:58 +0000
Subject: Re: [PATCH 02/20] ethernet: ucc_geth: fix definition and size of
 ucc_geth_tx_global_pram
To:     Li Yang <leoyang.li@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Netdev <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205191744.7847-3-rasmus.villemoes@prevas.dk>
 <CADRPPNTgqwd37VSqiUcv2otGVr4mnQbuv6r887w_yCp=ha1dvA@mail.gmail.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <22fb47eb-9f51-90ca-907d-bf8252424fce@prevas.dk>
Date:   Tue, 8 Dec 2020 21:12:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CADRPPNTgqwd37VSqiUcv2otGVr4mnQbuv6r887w_yCp=ha1dvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::22) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:14::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Tue, 8 Dec 2020 20:12:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33def56d-0ed2-4114-ba8f-08d89bb5a805
X-MS-TrafficTypeDiagnostic: AM8PR10MB3988:
X-Microsoft-Antispam-PRVS: <AM8PR10MB3988CD25F2D859C616CD7BF093CD0@AM8PR10MB3988.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 70JXnLYoVpBkfC9ODUmVpHZ9QIF9v5ckhQODwBQ9l6fu0OTb/zhnB30myUYKyrH2iYZS5wgsHMArGrkpey9YZx8ZDXB9qbMxOaOX/qk7CkGKaLs0xtGCchMy3HWX6Ggl+58sOK4TlZ+NJ7EgvYQfWOlIA3BCmdEaWLYYaGIXHI0L1KQs0TnZo2BxkzTw0MPLskYmkbTA7xxBuiR+rIHoEH5l5Dsk8NINVpcDoXEauYZQtY5XM2v+k3SdyBsn8FNb2td7dkle03Q7hK/lyPlbPlyYM37spoi9llbdeZ3WRmd9SNOVu1VXNwnW8S93euRYSd6SE84m7bLX41YFtYVTRCRNlVecOyn3klRo/EUHry/sycAObKqvUcTHb/2WT2Q0UKoyyDR39DVjhzBR6hVtinFGozKCyp0zPY0v0T2fNWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(31696002)(36756003)(8676002)(66946007)(956004)(2616005)(508600001)(26005)(4326008)(8936002)(8976002)(83380400001)(5660300002)(66476007)(6916009)(54906003)(86362001)(16576012)(52116002)(53546011)(66556008)(16526019)(6486002)(44832011)(186003)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aFFPZzY4cmZSb0tRY1JvN2E2dGJ2bFptZU9ZZ2o0d2cvS2V2OEZyMkRFbmNB?=
 =?utf-8?B?UXVVZGpZOTE5M2FOQ1YvYUlZdnNHWS9JWWVzTTZpSlhVUFg1cEl0OXAwelVs?=
 =?utf-8?B?Yks3UWlMSm5raUErbTk3SXczcTVJQUl1YWYwbFMvWkJ2MHc4Y2JpMkh4c1Nx?=
 =?utf-8?B?OTRGRkZUOUhZUzkxK05XK2c3b3JqY25iWjdKK1RuY2RwYjJsWkd3Snc5T0VI?=
 =?utf-8?B?bGVDQjQwU29CRzhMNEJyMzhXVzZ6OVhpTUUyMmZFK25uTG5qOGVlSHFjZ0NC?=
 =?utf-8?B?WWYvSWJkc3ViSWx4Sk8rbVdJTWZFR1ZneDRDQlZJUU5KNERWRGxxSVd4NnJ0?=
 =?utf-8?B?NHozdlF3c0w0dDFWcmdqTGZROVZXUU9IVHZqTHlqeWxoWGNPb3ZJVGsvY0pR?=
 =?utf-8?B?ak9KU0cyMC84UzFxUWVQalFxZzFsYjBiamNQamJGdHBwOWhVWHo4akJtZFd4?=
 =?utf-8?B?SExzbGg2a3cvenI0SStybVp4UEh5UzkxK1BKRW1lY3doSm05UCtyVXlTVEZn?=
 =?utf-8?B?ZkxLcVVBOE5keWttRW0zSU9kRGxoOWNDTTN3Qkc1VHVpblgvSldaVDhiR2hr?=
 =?utf-8?B?MEhPdU9sVTh3NDBTOGlicWVSZ013dWZ6blFJOU1HaHZDYmc3djZuc2RvRnRv?=
 =?utf-8?B?VDNiV243b3dVckQzVFJLZ09zYTRaM0c4YjZXMlhwSEVWY1ZPblBpZlgyVXlD?=
 =?utf-8?B?YXowSG9RWWFDaUlucytueno0VW5LNUFPNFZBejU2d1d2R0FXYmUxWmdNRUI1?=
 =?utf-8?B?VjkzblpnelVyWThQTkpMeFJuNTg5MFloUjlIelBNcDR6RlRHYnZEWkdjTk4z?=
 =?utf-8?B?bklMZGdlWHF0MTJOOU5ld1NJdk1NR2poSklQVU1aenhVVXhkZkU4Y3Zrc25l?=
 =?utf-8?B?NVMwKzVnc3VsanhEQlFJSG1zdHpCUUlXS2lxZWlST0Z5b3VidVlXU1VzS1ZI?=
 =?utf-8?B?NU10b2FxbFc1NnFKUE4yZ2d6MDdCcmY2Z1lrQlpaNXppSnNHSHBQNy9LMEpx?=
 =?utf-8?B?WVVSbEtvandCWGR5blVvUGEvVnE2UWw1VE4vZ09qNzZ6QnJ3d2laMStENVZ5?=
 =?utf-8?B?dU9pbmdpV09JWE03WllpMUNvUUlLcXJnTWJRdHRZb0NvOWFpNHJjaU9kK0xw?=
 =?utf-8?B?cHlKV1hCTGxiYitXbFV1bVIwMFFMZWVZdmNUWmRkWXo5S2trOUE5RXJEUWNp?=
 =?utf-8?B?azU3TDM4a1E5NXZkaGVMTjQ2U1o3U1RkRHJ3ZnpjZityWktPMjJyQkpKZlVo?=
 =?utf-8?B?c3hNWTQxb1JEanA4MnhsTlNnYUFPVGlsV2ozVG8rQXpiQW0ybEU3dG81aVpN?=
 =?utf-8?Q?mAZHCNGxMlIz9R5V6SKwltMSJyVm6ROUAy?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 20:12:58.1879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 33def56d-0ed2-4114-ba8f-08d89bb5a805
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GmaBXO9Kgf+ce7pPNdl8PGrZpAdN3yPLMelJBkVHepcKGKgwJGDSj4dS4QP7qA3tmyuoJ+xG9tefKOrFCayIHVwZIroYhsG9fBaHutaPw4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB3988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 20.14, Li Yang wrote:
> On Sat, Dec 5, 2020 at 1:21 PM Rasmus Villemoes
> <rasmus.villemoes@prevas.dk> wrote:
>>
>> Table 8-53 in the QUICC Engine Reference manual shows definitions of
>> fields up to a size of 192 bytes, not just 128. But in table 8-111,
>> one does find the text
>>
>>   Base Address of the Global Transmitter Parameter RAM Page. [...]
>>   The user needs to allocate 128 bytes for this page. The address must
>>   be aligned to the page size.
>>
>> I've checked both rev. 7 (11/2015) and rev. 9 (05/2018) of the manual;
>> they both have this inconsistency (and the table numbers are the
>> same).
> 
> This does seem to be an inconsistency.  I will try to see if I can
> find someone who is familiar with this as this is really an old IP.
> 
> Figure 8-61 does mention that size = 128 byte + 64 byte if ....    But
> this part is not clear also.

Hm, indeed, that sentence is simply cut short, it literally says
"Additional 64 bytes are needed if". The next line contains
"Hierarchical Scheduler, or IP" in a smaller font, but that seems to be
a label for the arrow.

> 
> The overlapping does seem to be a problem.  Maybe these global
> parameters are not sampled at runtime or the parameter RAM is really
> only using 128byte depending on the operation mode.

Yes, I'm thinking something like that is likely to be the case, since
this hasn't seemed to ever cause any problems. But who knows, maybe a
few frames just get fragmented very occasionally becauces the MTU0 field
spuriously has some random small value.

> 
> Are you getting useful information by reading from the additional 64
> bytes, 

AFAICT, after the additional allocation, the extra 64 bytes stay at 0,
but that's to be expected; they are supposed to be written by the CPU
and read by the engine AFAIU.

or getting changed behavior for setting these bytes after your
> changes?

No, as I said:

>> I haven't observed any failure that could be attributed to this,

I haven't played around with explicitly writing to those 64 bytes after
initialization. This whole series started because I searched for the
string "MTU" in the manual, but at the end, it didn't seem that I
actually needed to modify those MTU fields.

Rasmus
