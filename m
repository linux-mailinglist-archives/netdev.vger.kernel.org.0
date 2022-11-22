Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B98A634352
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiKVSJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiKVSJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:09:21 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760DD7AF7A
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:09:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KomGUXet4hBD872BzQIGEcUFB1+78nKbuHR2rf7GXKYPETBt5QCkzSGbuporANQLHD1meRkabv4Txh92SsQeENpacvQNeqjur/tQCTUCpuFnzjuix6FEGCXW++tPovDLzcdWojQdmeffro4i+6JsJ+dSFiYK6Py1zUtMZlpLGLcOda9gose7RQwYWTNPO3Q42lw0KLbc0kucxK2i2WIAYeh4yB+cSuAIn7B54LgEksEq0iQcruD3uvduTiEURie69KzoS76CpjwAsTrOKCMM9gl1Ac7/J9Nxm5T2O5cnFa37uWWX+v5IzU2wKzR5OOUOOBcg/UNlM90nb05rtVYBpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cIX/xbRH82lTufsd7MpljpJa49MxH0G8JG5ODsdU2s=;
 b=b87xOpxTEM8IuUcriZFeKhiW6Eo4la2fMcbC/wnV1Bx7ijUBbAEVcg5rnJZSXMb4vBIilJch65sb4GwljNOquhmrq/ONGMBkmc4jLOhpt/9TNywIwTx/UH5ZwQmlpFNdNtTq3fBO0w7v7CT1nu902ayE+3VSodrrogPtiPaX/fzCemgFKzDSdo0xdtUuvebazw926GIsvplAbMrt33dxN/xOiR0FtgCID95KQHQ3Q1ZPMQ2ckMT1/nvw1Xl4EhPQPazFGWKfIM3sDzzV7gX408LHsZbqY1IRy4G0q+99p3LQ5l4LdtXVUSfKQo5CUk9wDcSplnoHhGmdzw9SB1Yy4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cIX/xbRH82lTufsd7MpljpJa49MxH0G8JG5ODsdU2s=;
 b=2xtStIy1WvOvhyysX8iFjXSHJ+ig9vT3ewygrlkS4nTVQDqV6M85N8GpuHyNMSjyWkIzOLLJ8/0se4SeXobE6hF7R5gpX5iHoR5rs6hLepmlZIlAFhGZfWKPMv8qzaRFsKgpfxIkljXAuEVproJb2Ftu+EH5Q/E4v0EfEjQZ0EnkgzdnYGIx5nZQ+OidAnutqP3NXJyMBc+Kyp5qlXyCPmOL1V5TI+2xSPm9OVQ9W4fPufdLtc9JUs6P4cSQdaTwpenEir/o8AWJFNMq0l2c0nv6vFd1ssCMrBNtGRAD4QIdrYqLWETjURo1ge0NgpzU0Ow2ppFuGyDYcwaNWS9A3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB6901.eurprd03.prod.outlook.com (2603:10a6:20b:29e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 18:09:15 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 18:09:15 +0000
Message-ID: <3acb1f69-8a9f-5793-6fcd-f7061992dd7a@seco.com>
Date:   Tue, 22 Nov 2022 13:09:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
 <20221121194444.ran2bec6fhfk72lt@skbuf>
 <4bf812ec-f59b-6f64-b1e0-0feb54138bad@seco.com>
 <20221122001700.hilrumuzc5ulkafi@skbuf>
 <522f823f-70d2-d595-1f2b-1ca447c6f288@seco.com>
 <Y30OFnm0kFV0isE8@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y30OFnm0kFV0isE8@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0024.prod.exchangelabs.com (2603:10b6:208:10c::37)
 To DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6d8f99-df6b-4065-bd93-08daccb4aa75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H7vNcu04PC6O2Rr50Exyy5K3vp7/2sNMFey1pouXXUQIpH013xCVyxrgxjYMJPchG+IEmdKndUKD1yhUypZtdF5mSl72E3+8XgvlsZFS/9Jpd/1v3Nen9GU/HGTCg9ND/6JJVetpSvIJWgNHX5tnHpzIccaJBdoWIpCFcfXkZD8G9Pzc00lZF+dBYA+nortyW5RXNVaLvlXBa9Y9NDXy9kXNXlzuaJXQX0hCKpVOTEwiCnpfAnCxe4Kdp57fBbcKnz6iLXEHzZrwNq/clvsa30kLUc3QHG0gtJr1235MSiKti2wMOiyfvcsoM0ZKgnoNHmVSdocxmpwEC6jT76TS4HSL4i9O6XneX1+6sPW7NclHKcvko7Z1Cs7f/jt14EZPAJgp7ob4AVpsKdGMC5UESMxZqjvrzAr5GZw9T76TPMXywrgaSpefHg5n36u/7PR22605fOyF6e8u8+6JwGC99WBXVa3tO2methlx+LS1rh5xN8xlwAbBu6xkdv9+GTYuepFzM3MttXck2hsaTF3iD3/zWQq7L/xky/yeMLvPajaSN/SnLP3L1VuTT4IzyU1Z4+1QyMkAf2ATL2wP9uwmsoj3pkRyJRu9uhLfzmM+wBGtm0OfBzwiwrL4QBna2UGrW3bFoexy1d2kHI/ZUXHGFM7MlInkqhCSM6F9NZDElXp7Lc0EmvBBZSJlTo4iWt6awSJm/mVn3OR4NuOt9+WOWzmr/BquZja6Yr5vEZTYSphWNYt7pm+rGBN6xdDFbvZyx48bQJ/4sn1o/BHWyKw/+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(396003)(136003)(39850400004)(451199015)(41300700001)(31686004)(316002)(44832011)(7416002)(8936002)(6916009)(5660300002)(4326008)(8676002)(54906003)(66946007)(66556008)(66476007)(36756003)(31696002)(6486002)(83380400001)(86362001)(6666004)(478600001)(26005)(6506007)(2906002)(6512007)(186003)(2616005)(4744005)(52116002)(38350700002)(38100700002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFpYenIvR2d1cEZYOHlQOUNqeXYzcXBFYmx2a2FzUkpZNHNzSlRWRWpZeHVw?=
 =?utf-8?B?MTFoWk9qTkY3ckJ3dzVLZzh4ZUpYYjNWNTJncTZDYTI5TFNESHNxTzBHRW54?=
 =?utf-8?B?eWFpbXNNT2c3dWcvdGI5Q25rc0M5Szl2QnBmQzJTQ2lHcmN4bEx1alREUXBh?=
 =?utf-8?B?dzBwRGhWOW1SeG5MZExJTG90RWJQMXc0ZjFOWEpUVzJ4VGszSzdpeXFvTVhp?=
 =?utf-8?B?Z1BlUm5QNC9vR1I1NVc3ZHdydzVwSnd0Ni8yL0c5WDVic0NvSnZmaGlMall3?=
 =?utf-8?B?L0lrZ2QySFRIbDBwRVI0NzhQWjg5RzRXaE5yeHNtUWlVYUEwbkI0aTlTOEdh?=
 =?utf-8?B?M1JWYnZPSEZiU0g3QnpvYm5TdU9oNjZZT1pOZUhwWjVDY3pybG52NDczTjBN?=
 =?utf-8?B?RG9VQ0dLVE5zdERjMmtETzBydGx3KzZxcUU1Uzk3d2MvczBpRmpmTFNDaVVR?=
 =?utf-8?B?UDFwTkRzQUR0cDFSYm1zZThlajFiUE1CbEpHSlBzbXVSRzdKVVpUaXdZeXlD?=
 =?utf-8?B?d0JBSHVyV3dzTEpFdjE1d1o2Q21uckVqQjE0RCs0YnhRbkR2dDdwSTRKbnda?=
 =?utf-8?B?d0YwMkk0ZEpnY29wQVRHVmlWQlYyR0NKU0ZMV2dJZm93Z2xaMTRma0xYaFZS?=
 =?utf-8?B?UEZMZEROeFdwOC9oOHA5Q2Znc1JsUlNaZk1ad2F1anJZNFhZRnRhcGlOa2JH?=
 =?utf-8?B?clRLSzNtbEc4bzk2L29VWEVUaS9FNDNhVzdCT1ZSbWJ0N1dNdmVlUi9QRmE1?=
 =?utf-8?B?emkydU1Lc3d1STRnaWc4YWFWNjcvMDhSZzMxbGxiMTlieXlGb21OaTVuSU9r?=
 =?utf-8?B?bzlCdVB2bzRmRlZrYkp6SmttcE1yYTZrcEFpaExySUhvalc3azFwcVovdlpG?=
 =?utf-8?B?WG1zZUtPRFZnZFpxNlJZK280UHQxWWlkZVZyWDRLL1JuQUh1dE5iKzFXVVd3?=
 =?utf-8?B?Ui91OEdGZHpwcW1lOFVDdXhRUEtaazYyZ1ExQzFkdWlDdlY0ZlZISG44ZEI0?=
 =?utf-8?B?K2lQNzNub2k0MjU4RGxCOTNRaXhCUGh3R1l0T0dUc2xuVUlCeGhaNVBabVNz?=
 =?utf-8?B?QnArNytIb0dXTlR0OFBuYkxTM1VZSmZxbzZCMnRkUGtmbGo1eDc1R2N3SkNr?=
 =?utf-8?B?WXZPSFBUOUM3T2xoamI0Q0pVQ1lXODhtTy9yTU02bUpORlVIVnVFNDdRZkUx?=
 =?utf-8?B?YTFyTE40Y2syK3Z4amQzSjUzWCtKZ2dQUjR5TC9HZmxaN28vVzZlMzVPYkFE?=
 =?utf-8?B?QnhxSHJSSEJyZlZzbHRnMmNCRkJQdUYwMnZSc0VuQ2xsUHRETUJYR3pCeWxF?=
 =?utf-8?B?TWlreTJkSTJBSE5WWGJTTzR2UHFSdnRCMi9kWU43bUhabHVhbDUxYmlwZXNr?=
 =?utf-8?B?K2VYN01wVmVlcmMwVkNnNEE1clNieHVnZ3FsZWVyWlRocTVMb3g4STl3bEVk?=
 =?utf-8?B?MkNsUlpJaE9sSHBOVjUrUDNHTC8wdDhhK3pJaUl0ZkQvbDAwMWNRZ2loR25E?=
 =?utf-8?B?WTNjRW4xVk95aExCSzlaVkROWUNmSXVUS29YMjJkaG04bzNGSkNMM3B3OWxT?=
 =?utf-8?B?cnBQSEtYYW1rZjgyM2tWM3M1WUgvL09hWWpSeWZybkE0V0JmMXBjQU5qK3hF?=
 =?utf-8?B?dTh4WlV6SEJ5c2xFMys4ZWF2bldta0ppbW9wYnpoYVZkN0ZpSERoWDk3cnp3?=
 =?utf-8?B?V2FvK1RDNE5NSHQyN0UxdURGdzhhTExVb21LNXgzSkF3SW10WnVaZklFT3JK?=
 =?utf-8?B?OTgrUWZaVDYwTFNxVDZSQi9YOTBoUmszaHdHdzYycUFvNmFiTi9LUmtyVW5X?=
 =?utf-8?B?eFlEM1Uxa0djZmRkUkVpK2hpT1JnT096ZkpOQ3RMcU1oUlRER0h2c0lkbWNp?=
 =?utf-8?B?UTFYNkhiZ2QwSnZGTlZSQWNIMEV6dVNQNFp5UDZVYys4NnJXbWZOSXloL0xM?=
 =?utf-8?B?K1Z0QzYwNlFBM0xIUk1Tdlc1L0Fsd2RPVklTcE1wUkx4OVJ4a1dYUHhLVyth?=
 =?utf-8?B?YksyT25vOHVyWTl1LzV2Z0VpVVhlZk9rYXlHWWlNdWU2MTYwZ1BTWEFwR1NR?=
 =?utf-8?B?aVozN0tUUGxPOVN4cWtjQzhxVis4Q1gvWWdxRmtBaU9VUWx0cDk5clo3U200?=
 =?utf-8?B?dUU3UG4rbk56a0wvNDdSWFZsdUZxVmZBM3hueGtZa0Rkd1AvT3dwU3Y3aHJN?=
 =?utf-8?B?OGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6d8f99-df6b-4065-bd93-08daccb4aa75
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 18:09:15.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6fe7TnPqmcFntsa3SS2SToVzlQhrZjG3eZuPt4GqNalkt1BBd95wj4X+wjwWn5LQaDg1a3klsrwbbxCJEhhIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6901
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/22 12:59, Russell King (Oracle) wrote:
> On Tue, Nov 22, 2022 at 11:10:03AM -0500, Sean Anderson wrote:
>> So maybe we should do (PHY_AN_INBAND_ON | PHY_AN_INBAND_OFF) in that
>> case. That said, RGMII in-band is not supported by phylink (yet).
> 
> I think people use it - why do you think it isn't supportable?

Sorry, I forgot that support had been added recently.

--Sean

> Why would it need to be any different from something like SGMII? One
> can implement a "phylink_pcs" that responds appropriately when in RGMII
> mode (which I believe is what others have done.)
> 
> Note that Marvell net drivers always register a PCS no matter what
> interface mode is being used - I believe the hardware has the ability
> to read the RGMII in-band and in that case it's just the same
> registers that one has to read to get the status as SGMII.
> 
