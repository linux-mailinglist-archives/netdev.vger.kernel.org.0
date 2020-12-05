Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE42CFF49
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgLEVhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:37:31 -0500
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:26546
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgLEVha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:37:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVcYnxkzIhlYo/3GXHIVgbwfEttpZU0e2M674QR365+Eqvxg0alyxHDjPEg6NPCikpabe81ZJLXHsCSeeMyvJOxciAdtr0V1CH2EUADa1XhWyVRtG0ENWYwc1c+D4xqiqXERE4HcgunkI/NGfv+JxDOSAyfXpXHsXogJvGqjM0/V5p1j6XHsWjPU20QG+L+XPEYg+9uhwIkmihf7amWYWORKrpkmlG5qS/HRNaakLWZXTfIZC4rt+jJLOIdXmMWMnGILTEOrs2vO5oIr4gEHw6Kxj2boqoX730viYPFwiyauuA+UN9rvf9/T4tgqe9GGIIasV5MJFVmK5LVVhykhLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIzYXo8rD6kbjCp0uu/WiT6LS/Z6SWNkaa5IB07AfQU=;
 b=etNE7kL9krWYXkIeL5e29pAOG+80wFnp4CSqh/hGAIvuhZXWUXyvZR25NOCoYU1iWqXa/Gf9n6ENs2Z56oIovn5devhsBk7ozFH3nwp5GMNG1dZ6qiMH9/oKiJxgL61xeWO1pj8IYjbMju8qGXFkZWrAchfYaPSWNOPvhrilddABnJLsSVQxuSEMrDCEjXpXf/brVFUtiBT5MJfg7k+UWdP9fBQPpaqFWUJi3amFGiy1AUj2DJADBZOzgYvy/652AFjl4J/PRJ1zfzFSpw5+OsXufbLOMjyHUGoQvhThSZYOokOOt2rVDFrecTN5U3xNLP5NqGkFn1nz70qiwvFbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIzYXo8rD6kbjCp0uu/WiT6LS/Z6SWNkaa5IB07AfQU=;
 b=Yh2rvcDiesPxnwActKwmQCegrp5DrENbVJJ1zIyT0/PoT2qzF2pqQMgkx77SR68UHGVhs5JVQwoj2YQMRq9dSrHIcDbXCipxSznw+Q+ZUeWZvPPnIzL8u43rZ8GjX5ews/0weFRuHGQ2mGPqdmV9RtwuE8iomJJRiMbXdmbex1I=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3171.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sat, 5 Dec
 2020 21:36:42 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 21:36:42 +0000
Subject: Re: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and
 simplifications
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiang Zhao <qiang.zhao@nxp.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
 <20201205132716.4c68e35d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <d9ec515c-7eae-992b-aaf9-e3bf8a4d309a@prevas.dk>
Date:   Sat, 5 Dec 2020 22:36:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201205132716.4c68e35d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AS8PR04CA0071.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::16) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AS8PR04CA0071.eurprd04.prod.outlook.com (2603:10a6:20b:313::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 21:36:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54a1dade-7903-4a89-a81a-08d89965db2b
X-MS-TrafficTypeDiagnostic: AM0PR10MB3171:
X-Microsoft-Antispam-PRVS: <AM0PR10MB31718CD455ED490564C0831993F00@AM0PR10MB3171.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ks3lUiu6LzOf+/r2Nsb279Ns6VBYXWmHQFWbxwCN3m9BT104cioExqnPRm/adQefdSGFNxWvbC1IxOFaHh5nWWkteur67UVoUs44LPQobCWMEmZr0UK2dONpPiY6cmcUyroLA1GE67n7818PNnNSoVa/CobzrWobG1nIn4F3N3eZLxKTtgp7XFC79R7qV6D2Nfp1gGLaLRjUDE5gtl2N5a9xOxf+rsePlLsczcQscEJRSKgXodq/kWBYP5EL5KbCLuFdRKjwvsUG5NjFQ3n3dzgZqZiQ4/iW7XPneozR2t33U4zK53/GB6nw5cT+qd66rxyf/Y/Q8oL9bTThOVIervLmh4C+QyASbO+PugHKzepxCOubxEh6Fat0MZPMdG2zSYBYrLrLuQ+S6M68YnK4fVruNKFE4yhpJYtxh+UYqBW9rr4tf9371hHcaH28XwNcN9UvWDiE/0Hr+HjdUIUQn3V4RijTA2B9Fz7UQ5smBMB+7SE8/ueP9aK3mgiKGjEi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(366004)(346002)(39840400004)(6486002)(2906002)(16526019)(26005)(186003)(36756003)(966005)(66946007)(4326008)(8936002)(8676002)(8976002)(478600001)(66556008)(956004)(44832011)(52116002)(31696002)(6916009)(86362001)(31686004)(66476007)(54906003)(5660300002)(316002)(16576012)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?wqO4N7YEyzpfSzyL03ajBq3O1H0MfQXE3ZGDcmlwBusykqNdKKRPkbg3?=
 =?Windows-1252?Q?rOUYXFOBfT298VfzNJIwQjKff2UL0tMwFr09wrIkNs2Odo76zO8RihME?=
 =?Windows-1252?Q?VhyOcgou+78vcVlP/ywbp2EBDNOrwiQaPcIBcLqH40pSEgVHe6Kc9vUn?=
 =?Windows-1252?Q?JymjU2GQHgk7BlqY+RR6gKPugxNCvYx7UdVPjPDOUDkxUTPMf9apOOPF?=
 =?Windows-1252?Q?e1qcXWYGI2xlkvhPdwQCQPVRtGPF7bTitZLVqRBoH3tQjVeTRgwrMqeK?=
 =?Windows-1252?Q?XDy1i8SP8DqeEEZXD8zRcrBLoLiC16Q5uE3LDYMroyiL9wlit4oX8iHv?=
 =?Windows-1252?Q?iFx6aHVrYSkUmk7sYBsfWpLcVS3e2uPdwdzgiFiiq0UaQeAqkzVIJYU6?=
 =?Windows-1252?Q?Wc9Skrgd55POivNJ1E6Zv8N6XTyDY93NPcblVjkGlaQuZJELNfOM2V+a?=
 =?Windows-1252?Q?mg5ZQ7KH6BY/nYUJ0i5Yjug4cPbW2czecrjnYjM+PtqLmnmybUKNrSt3?=
 =?Windows-1252?Q?EJgphYz4Fx3Rr0t/oI9JWr5lxrh2DvIEyRzZjB5PucoTWys95L2cb8CH?=
 =?Windows-1252?Q?Q8Eo0zAQpc+hrdmB08JP5qxRZZI1qsU0tMh1vg43r8qwapEmaIdekxmT?=
 =?Windows-1252?Q?+D9L3Nm/GPbsnbTandScy25O1l8Z/oAucrvSBkzRSuq/zf1+s6c3X5E6?=
 =?Windows-1252?Q?HTUH7JLot7bCc4iqL+2j9xB9U2H5JP+u1m4f2xiOy7eIdH5fRFNkZnjr?=
 =?Windows-1252?Q?czWoXleasTJ/Z2cNodLXG4DiDgKD1iDt6x4thelFh3PbYAiF4SdRCRWG?=
 =?Windows-1252?Q?MViOKwd1ybLz2ItkQeBb21kt+u88XTOI6TY/vzPNsov+IQ2CBfXJhv6a?=
 =?Windows-1252?Q?qU07RFcb99Ci+nHlyqPCK7P7WCidowqAd9UlpCnkBpa5hEvQjZG9zjgS?=
 =?Windows-1252?Q?PKk3RBTuOcnOKjhYQlpj0LcogYttKsy7SYIYc/fIUgEO5eTga3yEgf8Y?=
 =?Windows-1252?Q?ix9iqICPJuPBgfhgADt2Ufp5v1L5BMqxL9dEusuGHmn9rU0k3CGwCrdf?=
 =?Windows-1252?Q?HdL5W+gw5u9e29FY?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a1dade-7903-4a89-a81a-08d89965db2b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 21:36:42.1762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /gmt0mDOOGjMdZDUaHOU4J4epkiPX9GXJCbKBEWeQ11l37KUqE9QoR9eGy23/doonQEPtN8vWdaLALB0iq7XRLv5CeOjNW+HhRwJDUeSnYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3171
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 22.27, Jakub Kicinski wrote:
> On Sat, 5 Dec 2020 22:11:39 +0100 Rasmus Villemoes wrote:
>>> rebase (retest) and post them against the net tree:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/  
>>
>> So I thought this would go through Li Yang's tree. That's where my
>> previous QE related patches have gone through, and at least some need
>> some input from NXP folks - and what MAINTAINERS suggests. So not
>> marking the patches with net or net-next was deliberate. But I'm happy
>> to rearrange and send to net/net-next as appropriate if that's what you
>> and Li Yang can agree to.
> 
> Ah, now I noticed you didn't CC all of the patches to netdev.
> Please don't do that, build bots won't be able to validate partially
> posted patches.

Hm, I mostly rely on scripts/get_maintainer.pl, invoked via a script I
give to --to-cmd/--cc-cmd. They are all sent to LKML, so buildbots
should be OK. But regardless of whether Li Yang will be handling it or
not, I'll try to remember to cc the whole series to netdev when resending.

Rasmus
