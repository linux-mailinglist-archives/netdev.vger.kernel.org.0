Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A46B254481
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 13:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgH0LrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 07:47:07 -0400
Received: from mail-am6eur05on2109.outbound.protection.outlook.com ([40.107.22.109]:24192
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728803AbgH0Lqh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:46:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPyW/Hemv8HOK+WOPdGfkAFO3+ji1se1dG06ifN8ft9NYlSre9bh078ViSCBPa+AvAa4D29gWuqyoWGJ1faMz4m/K9qGdAeY0GNuIgh0rPwB/n+u216WAacRMaONO7WmRbXkr5OKHVnXTi3LBblsvdceqM2ZXIiAzpBgOLN9ycbe22BnFy8rE2nYEGRJgl89kj1PGWGxkZHIaoYViofqMgyWQjB+D/rN6x7Uy4h50Y/X1EFsnNqJZK25Z0QeUHwWMvEjKomLAMX9JpcMdcQBdqzRcR/SLFbaeNldK3int3coZc9nwm0oYKo078UIDrdWKaRTY79poogG2WmQcE/hpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QaYW4MxBDq9WdesC7EPnbMk1teyDfMBmWVCY4qVZrI=;
 b=loR+2pm8W/n03AQPOlJmr139ylFBcBGVJARRbT8Zcr7+h4qJQMUBRU1BeSiPUX3bhGWX49i+HY+K2OvTmsN9jtYEKHMfP2bAmbF5jjPfzPAcl7ibTdmHppyhNaQGLE2MSPJJOHouQKwU6cWJrfPQkGAncokXbC2GjXApWv72+LHt8TxXUWE07OvGJN2HL1JP6vzwc9IQHqBVEDgYCTBRSLC0M0EwIvHURUHAhRbfn5v+R8EWMEpdoDV86YsxyqSlcRZroeEbVuCmblpZr27e/bMMw8yZgdmCSjDAMdYvOMFaN4h0UCae1D9jV/oBqN/8xlyAYXaDz0HcV9Y8ZL2YPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QaYW4MxBDq9WdesC7EPnbMk1teyDfMBmWVCY4qVZrI=;
 b=l+YLtLJ7Qqgnq3CiJoSsayMXhDFbSUxO8PA/PwVSC4l/7/hv1/2loLGsZYpfuhsYfuXoFDqPIOdKOKNkflVNnyVwpsO+MgUkhloHMiLjlffwv46D5X4JCz7e93w/fUkikd9EAcdH9nVFacKNnaNQRQOeurJSxT1dZ0zf2talYIY=
Authentication-Results: prevas.se; dkim=none (message not signed)
 header.d=none;prevas.se; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3731.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 11:46:33 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec%3]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 11:46:33 +0000
Subject: Re: powering off phys on 'ip link set down'
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Cc:     Lasse Klok Mikkelsen <Lasse.Klok@prevas.se>
References: <9e3c2b6e-b1f8-7e43-2561-30aa84d356c7@prevas.dk>
 <7a17486d-2fee-47cb-eddc-b000e8b6d332@gmail.com>
 <4adfeeab-937a-b722-6dd8-84c8a3efb8ac@prevas.dk>
 <adcbe6fc-6adc-4138-a5d1-77e811f4c0eb@gmail.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <b340593a-c28f-5bcf-4559-bbc23a462972@prevas.dk>
Date:   Thu, 27 Aug 2020 13:46:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <adcbe6fc-6adc-4138-a5d1-77e811f4c0eb@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.11.132] (81.216.59.226) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 11:46:32 +0000
X-Originating-IP: [81.216.59.226]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2226ca47-2217-466d-765f-08d84a7ed836
X-MS-TrafficTypeDiagnostic: AM0PR10MB3731:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3731543EA70499C887EF8FFE93550@AM0PR10MB3731.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05BmpzkwTaY7muPXW8d5OfkGkKxLkTnY37LcPYpzR6P3xK/RGaupDiEE0VPlR6MBdcF833aVqsF7fMaAMu3t6mUrOcbWiyY5mzo91oLooexI4ADG+p3138IpasATu+CDChhh6LpXN0ot6cA4rAINxtqS45WcNxKffJls5qqu/fw1UsDCIrZ2fRcUF9Y/1DIOtwkjVw5WoCnZpxHQiJCLQvKmqv9KnfTn37D4RmFj78EM475YGs5X73bDdz2SawVGDkbuhqc+idmfPzQO2COL1bJ4Crc42kyoHfBMXMAtcXuE/JhcstJ8AwOqziqCMcbAZjXfehxuF1abzX24Q+zMaQSqAErAF4deRtZVJ681Q1c9nmU35UThf+iRf5WH5yM6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39850400004)(396003)(366004)(346002)(136003)(8936002)(86362001)(186003)(52116002)(107886003)(16526019)(31696002)(2906002)(956004)(31686004)(4326008)(8976002)(2616005)(44832011)(53546011)(478600001)(36756003)(26005)(110136005)(316002)(6486002)(66476007)(66556008)(66946007)(8676002)(16576012)(5660300002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gzOB7p1TfONjRcPIvPL9RP1BXvx5Qu4cfNO02m8WsRhRPOlX7hAetYETDUkDISZ49sb3LPBHpEHSp8K00FJ8mpv28EB196lPlowp7BDLZ8WkjHwRmblG2EgkxPJoS67MPTtRfiTgQiMirhsCaOeCb8FHNqr77l+ecFymEOQ/PDPv/tdPENS2R5hTn+sA8Aq1PEhnx2DadNQhGfd4D/eNS7fxVJUbmsUNtjKiF0Gk6iiRgcZKolF66lAEfet/73bT3XYxIC05Ldbp8Df7egSxLriL6MR/DD0WZRNm88CyBUhOx3bOMxsF18siacSbqE2BnYjYaZmy78XB1zQcP8IkLCarwQAcfBLb2p3rKjUf92n7A/QXJJJhezBTJAbHNP+5u8iyJ8uWMKyys+hG4yVki6o8BzmJ5R/W0YZmzHFzFOdJincYoiHTZ22AuaKFG5E5q/pb0T1jZaEzCpZVlrB4bE0eV1hsuwD84fSNDTUnPLc0SI2FDtuc/KFbswwLglAdDBpLxfgrMYhsrQkAAww9h3Bu2CZrKmfuP0XjEA3e30Bs/FRlT9McDc92PoCYXFCbiGhJwyoz31+QA6VZ6aD+jYkGYTvm4dvslm0QhrWHTrbZWAF0pXhY7qlidyBYxItRpYI0KGi905tBhwgFc8hz6w==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 2226ca47-2217-466d-765f-08d84a7ed836
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 11:46:32.8956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7je4ybf8dkrneEk2DrBdyZ6C+YG3lnQSM8Jv4TduB79pBoEbI69q7Ct1XMiSuOh/sww6epk6IWGm5Sh/RhY57nlVOVETcHOK3vDsgd8b2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/08/2020 13.14, Heiner Kallweit wrote:
> On 27.08.2020 13:00, Rasmus Villemoes wrote:
>> On 27/08/2020 12.29, Heiner Kallweit wrote:
>>> On 27.08.2020 12:08, Rasmus Villemoes wrote:
>>>> Hi,
>>>>
>>>> We have a requirement that when an interface is taken down
>>>> administratively, the phy should be powered off. That also works when
>>>> the interface has link when the 'ip link set down ...' is run. But if
>>>> there's no cable plugged in, the phy stays powered on (as can be seen
>>>> both using phytool, and from the fact that a peer gets carrier once a
>>>> cable is later plugged in).
>>>>
>>>> Is this expected behaviour? Driver/device dependent? Can we do anything
>>>> to force the phy off?

> 
> Maybe your question refers to something that was changed in 5.4 with
> the following commit:
> 95fb8bb3181b ("net: phy: force phy suspend when calling phy_stop")
> 

This is a 4.19-rt kernel, and yes, cherry-picking that commit does make
things work as expected (and required). Thanks a lot, Heiner!

Rasmus
