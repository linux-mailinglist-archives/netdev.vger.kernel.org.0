Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E17550176
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 02:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383745AbiFRApv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 20:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbiFRApt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 20:45:49 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60041.outbound.protection.outlook.com [40.107.6.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EAA6A065;
        Fri, 17 Jun 2022 17:45:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oh8ND/P/CLkgEMbfj4xljftkdTzDTaV7eApovdHjytdiL3+DgwKXDp3dlOewTLVjXYonTXkSvAmEjW54I3SGPhPF3FTjebTISbGqxbYpBkXETpxf1I/9yv33Zn9dmUDu7ArIGK+ZOusgy5TkzdR6KnXfjW6msMGNAB+c1FB1BP7lhU6+MW0psU2w9FIMR6PI5g0HT9xjxOgmnZUQDWofI4Q8Wne2Jgi2dAdq1+4huNNiUOy7GLEJEMsDlYuVwUDHeCaboZh7JQEJ4ro5gh+D74rUhOvf9loDuR/zGaaL5k1p7so1yf3p+gKgJA5RSiSP86OZib2dcvsFYIK1NdXW1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Aqe1YxCNeTJVh4q5W3y3JxePIBlNuF2765uUGh8Ww4=;
 b=BXEbFdmNOKKMBgiswjIwRefHSE5+HGADFSE4u+USvMoTLQLHy/jsaalfAbkRmAocqijnMP2obBy8p+8Qz2kTtuV8sXzVVSzYOfz6SfqEOWVOKBDH7grzyMa2Jda8vpRRPR5S+xkfNWoA26BmGdl7dUYGxG920sza0uqvLdPYn2AGH7tM5rwTT1RTfaozaRuehz4LcyWC3b5H8sSYO7FLk3Mx5HalsaM1gWTdOK+8TjoW2DL82txtmEOSqoL8CzfXfQleXGkmnosdat+1HAB07LxgeTNupBEX1cGjw+93DAPDPdLkIj3vDmPAQJJTUGu2ICH/ISIRLaBa0afIBKzguQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Aqe1YxCNeTJVh4q5W3y3JxePIBlNuF2765uUGh8Ww4=;
 b=qVlPwX7z+wGZlGXebaMfCHVb+AsTITPLZpRm5CpkfenQyetiE2eCXC5R798D/dpgNIr+t41CgjHbPRbsVPJDGyY0BM9ABIoiQMpZim4IQQF0XbqW1W+6ycYcRNJkorTbQUS9DFTnDFy4EEOV5oARDCm4ja81PdFIFZTzpI+SGtfKF2/13bixDpB1gSSeqbqDCUisl2UpMn4v88jmbC5uGViVLoXTFhmOPYAh5LLqoNmTotE183sKr+oXBLTc64ckaFHO9R3O2FtjEI95Dgpqv1vQAeSV2+32hVKq2UeUaoyqjEFtXh7VmgGQ7h+MamHZRg+UY2DFtmoU6mCSx4IE6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4182.eurprd03.prod.outlook.com (2603:10a6:20b:9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 00:45:42 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 00:45:42 +0000
Subject: Re: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-26-sean.anderson@seco.com>
 <Yqz5wHy9zAQL1ddg@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <dde1fcc4-4ee8-6426-4f1f-43277e88d406@seco.com>
Date:   Fri, 17 Jun 2022 20:45:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <Yqz5wHy9zAQL1ddg@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:208:178::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09f35af2-5ad1-4fa6-a7e9-08da50c3df3f
X-MS-TrafficTypeDiagnostic: AM6PR03MB4182:EE_
X-Microsoft-Antispam-PRVS: <AM6PR03MB4182A2B8BD1C35EA0E85770296AE9@AM6PR03MB4182.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfq7KPDdfLVqHBeYy7h1nihQ4ln9yuWzX5obBFL8/tgCOw0IwRrZ6wgUTdgjGHz+1D/reVLNztbYommvoziosD4ViwFuyVBSD/nU5ZRo8fKY/dSWOuMqdUyczkNrLp87Tv8dPGhx7eTdY90f5PncoNte8e2X5oyFjoLMrwt8zb/pb/DFJMFeN5ulOM+jJGCzan4wjEXFfWPfedJRL9gr0EwfhEwCFLun7y81Qs+At2Hn8aj5nN0hp00qBMs5D6wxQ/66dKVJn0hL+4OrKL2ZJHYVfxuL6xw6Yf9Wxd2c8ixc5aGflgXM98tehNJz7xUHKqGUIRtm5wmxGwPBcxyUlsbZJHELq92MV6opPSoYlaSeEZ9ZM48eZD1p6irEHaNG+CPbBXpvWZDKQI82zWUiChafXhU6HhdMcGOEYdcb+icXGAG2bUUmuUdaWG9EwmoWb684zdXbr0ttCX+LG4o+CtOM+7y9Qzz9zIjJFsnSjRJ8JXjXq+dSa4n0ichQv+gSer5dktdmpPi8/nqBv6LSRvupy5GE8b3CNWutSiQmr391rOujKDNISBZPZBkZ7tYa2AO+D/ddxF6h56Ssfkq0eWsrvKTqj2XLBwPYn3LEkHxMKU1D6noUNyd6eBeBQrN5pzuOrmTslJIA16GtKiWvBo5A35KPIBWHCdkBv+SG9kV241bDncBhZSXEhL46Q7fK4ZAk04PBh4/2oTWKqbmiWa8V9pfEHR27PRi2wiUY9UK76uR7Ak8dptgjiddq4rZSDoMrSnFVC3VgT0YpXMj/3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(498600001)(316002)(26005)(86362001)(6486002)(6512007)(83380400001)(54906003)(6916009)(38350700002)(2906002)(31696002)(38100700002)(36756003)(2616005)(8936002)(66476007)(66556008)(66946007)(8676002)(52116002)(6506007)(44832011)(53546011)(4326008)(6666004)(31686004)(5660300002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1MvWnRtZm9RSUdmRDJPemFRa0RNVkxVYmRlSHBzTExNb3NFalR1K2d5bGZW?=
 =?utf-8?B?cWhFUGwrbGFJalU4eW01dStjYlNNUjNSczhKeXA5YTUyNDd0MnBFZUJTOFBm?=
 =?utf-8?B?ME12WUZvbjZoTW12RWM2cHdKeThnai8vQVdmb3JWQ1NqMkgwa0F3eEpWQWI0?=
 =?utf-8?B?RXlrbFRqTEFHU3dRSXBkeHBYTzhLZTlzOW45WkN0NGxPcktHZStVRjFpRWUr?=
 =?utf-8?B?THZPUmlQT2hQUDdBUms0cjdjd1J2MDhnZ0p1WExBZFBPTGZmZm5kNmFrTE1t?=
 =?utf-8?B?U1l4WFcwNGViTG96amhZeDhqNGhGV2JMd3N2ZGp5ZzlzYXpPb0JXazh5d2ta?=
 =?utf-8?B?SkdzY1VEaUZURjREcE9EbkY2VjljZkFSRkxKL3I0bC9lZzFMbi9MdXVQNGdJ?=
 =?utf-8?B?K09vSFpLaHRTYnhJcDRmTjFkT1EyZlhUbUM3a09EK2lZU1dlNTF0cXJHN3Bo?=
 =?utf-8?B?NWtPRnpvM2ExYmlWOGZYSUxBVkdvcGY5SFBYQ3p5RGl2L1ZEUHVKL2lTdTA3?=
 =?utf-8?B?VGpvcmJSQkVBQURjb3BBOCtubi9zMmN4Z01XZGIrYzdxR1JUZExWS1YrQm5W?=
 =?utf-8?B?dVFiR1orQW14MHRPczRLN0RXak9zcCsrQStsV2xvWDQ0WTdvSERreFNuRUV2?=
 =?utf-8?B?V0Q1NFVodmFNaE5HSVd5NXgxK3RVa2Z5V1FGbVVFYkJuTU5PUGxlbHZSSkhD?=
 =?utf-8?B?Zm9vMW1PT1JTMkx0eHJJeGM3WXRtQWFDMWJ5alBSSXQ3N2tsdFh4UzBSRmNk?=
 =?utf-8?B?c0ZJQnRUN2FBdlZEeWlPTTRlSTRLK3o5NTdYbGFEaFdna0tVZHhzOW95ZUlD?=
 =?utf-8?B?Y2tCaWIyK01IYWQ3aFA0bzhkdkJxVHVvYUhSSkhJaEhHTitwSnZPQWxjUnQx?=
 =?utf-8?B?ZC9vNHJaY0RVWlFYbkRla2pXWnZVVVQ2WXp5MFFhb081MmNnT2lKSmJkZlZ0?=
 =?utf-8?B?YlJwK1lWTmZHMEI3ZnZqeWNQRi9PWmtGQWtjWHNOYVgyKzZYNG5RajBMdCtP?=
 =?utf-8?B?Sm5LSG9HeEE4L3RZSmh0WFo0RC8wUkVLVjNpKy8yNWJOY1BMSFYxaFh4elVi?=
 =?utf-8?B?T0FhVlNJV0VzdXVtdTNXbjZ4NHZRb0dyYllKU09RS2NUMmxTODJXaE5kNFlJ?=
 =?utf-8?B?Qk02TlFkWTBpUTRWVUVYa2dHMnRwa1dwbG8yRTMybnNhL09PWTBqbThkWHFX?=
 =?utf-8?B?WHBJWDRsMWZ3SmoyUWVhYWdpa01kU3NxdG9PalBOL1N4NitHWVNkNGJCcFNG?=
 =?utf-8?B?Z3ZiK0VyVkpqdHByN05hNVRaYWZ3MzFNbGJ6cm5ScVdqdlp4RVl2cWZsVDhW?=
 =?utf-8?B?SVBaWFp5bmEzMEFZUkJBRXo0enc4SXhIYURqQ1NWVGxVT0E3dThoR0YyWWpM?=
 =?utf-8?B?L2ZjYTNCOXREWEJzckVuWWFKZGg5NnFkbGw5RFpVUlRFR1p3cHQvanpHSkJO?=
 =?utf-8?B?WEsrai91YTBqWE5LbWRpQy90UUJVRzBrdnhCQjFGTkZtUHJ4S2tIQWVCa2M0?=
 =?utf-8?B?TFMwMG94V3l0b2w3RGNxU3k4NVRnSTAyTnZkUUs2MnhFWVZxL2FteEhYZ0RJ?=
 =?utf-8?B?M21Ba3Z5Y0tjbEh0WTROZjg4bG9ZVmorRjN4bENrVWZzYmQ0SUFCV1lzc3BM?=
 =?utf-8?B?SGpRSlo3L01PNkJMNW54OUIxUWEwcGtGbGNWQXBKYzF0UUJ3aG1DZ2xFMDNa?=
 =?utf-8?B?aEdIeTUrWDFydW1rcWYzbmlMcjFoSGE3aGdUc2wrTGlKN2ZwOVBrRnFpM1ls?=
 =?utf-8?B?SkNqRm5wWGlhU0EyLzFWZnZRSm81eTRuYloxallEdEZQdDdCb09yMCszQjFU?=
 =?utf-8?B?TE1Sd2M1bjhWRWwxMm4yVFFGNlZ2Y04rc3pXNGdLTFNTbXE1c0Nrd2x1K0I1?=
 =?utf-8?B?SHFmcnJPejE2L0hCV0JWSjFqWENtZDNKcE5yOGRGWHk5SVJXSVRGYXVvUVZu?=
 =?utf-8?B?YmJJUXg0QkdlMWJjbFFNVDNITElQRkxHQlRBbmFNNjB2MGpOWWoyeFp6Nld2?=
 =?utf-8?B?THRya0JlZzZEd09QY1VRRGFKcUhNKzNQLzVkMG1tclAydUZsV2pPcW84Yktm?=
 =?utf-8?B?Z21kNkVMSS91Q01ERXM0Q0I0Qnc3cE40Yk9qNDc3ZlJSYVhvcllmMytBODJM?=
 =?utf-8?B?Y2htTkpBa3JPU0tSVE0vQTd1WE9pWnhVYmRDWkR2Mzd6ZEM5UWtJMnNGU1Jk?=
 =?utf-8?B?MzdKbCtsYnpiUzFrU0tjejFXbUNuWE5zMEt2UXFza25memdlVEpCK2QwM2Fi?=
 =?utf-8?B?Uk1hcGhUOXZwWUNSb25pdGpXTk0zSmZnWTBIcS9qUVNEakt3MUZUSENTQW9H?=
 =?utf-8?B?VjFiQXdjRjJUUnRTQzIzaGlVVDM3Nk8yK1l0N3BJSDY0MUxodnRickVYcXdJ?=
 =?utf-8?Q?UWZq4w7Nb8Pi+NeU=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f35af2-5ad1-4fa6-a7e9-08da50c3df3f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 00:45:42.2088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1y/0Dh+CpdBFkiYBO6JQUJN6yvuBJIAdFO8HZ4HElAzFHrCKV+qGKV+X96LUUyefcmPTEAGTVFUgaRS31XS5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4182
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for the quick response.

On 6/17/22 6:01 PM, Russell King (Oracle) wrote:
> Hi,
> 
> On Fri, Jun 17, 2022 at 04:33:09PM -0400, Sean Anderson wrote:
>> This converts DPAA to phylink. For the moment, only MEMAC is converted.
>> This should work with no device tree modifications (including those made in
>> this series), except for QSGMII (as noted previously).
>>
>> One area where I wasn't sure how to do things was regarding when to call
>> phy_init and phy_power_on. Should that happen when selecting the PCS?
> 
> Is this a common serdes PHY that is shared amongst the various PCS? I
> think from what I understand having read the other patches, it is.

Each serdes has multiple lanes. There is a many-to-many relationship between
lanes and MACs. That is,

- One lane can service multiple MACs (QSGMII)
- One lane services a single MAC (SGMII, 10GBase-R, etc.)
- Multiple lanes may be used together (XAUI, HiGig, etc.) (these are not
   implemented (yet))

Each "group" of lanes corresponds to a struct phy. So in each of the above
scenarios, there would be one phy. Each PCS is a "protocol controller,"
which also corresponds to a "group" of lanes. Protocol controllers are usually
in a 1-to-many relationship with lanes (e.g. SGMIIA might be associated with
Lane A, and QSGMII A might also be associated with Lane A). The only exception
to this is the B4860 where there are some SGMII protocol controllers which can
be selected by two lanes (but not at the same time).

For Ethernet, protocol controller correspond to PCSs. Each MAC has a set of
PCSs, and an MDIO bus. Traditionally, the address for all PCSs is set to 0.
This would cause address collisions, so the serdes has to make sure to enable
only one PCS at once. It does this in pcs_set_mode.

> In which case, initialising the PHY prior to calling phylink_start() and
> powering down the PHY after phylink_stop() should be sufficient.

OK, that sounds reasonable.

>> Similarly, I wasn't sure where to reconfigure the thresholds in
>> dpaa_eth_cgr_init. Should happen in link_up? If so, I think we will need
>> some kind of callback.
> 
> Bear in mind that with 1000BASE-X, SGMII, etc, we need the link working
> in order for the link to come up, so if the serdes PHY hasn't been
> properly configured for the interface mode, then the link may not come
> up.
> 
> How granular are these threshold configurations? Do they depend on
> speed? (Note that SGMII operates at a constant speed irrespective of
> the data rate due to symbol replication, so there shouldn't be a speed
> component beyond that described by the interface mode, aka
> phy_interface_t.)

I believe these thresholds are for e.g. queue depths. So it shouldn't (TM)
matter what the depth is until the link comes up and we have to receive packets.
So I guess link up is the place? TBH I'm not terribly familiar with the QMan/BMan
half of the driver.

>> This has been tested on an LS1046ARDB. Without the serdes enabled,
>> everything works. With the serdes enabled, everything works but eth3 (aka
>> MAC6). On that interface, SGMII never completes AN for whatever reason. I
>> haven't tested the counterfactual (serdes enabled but no phylink). With
>> managed=phy (e.g. unspecified), I was unable to get the interfaces to come
>> up at all.
> 
> I'm not sure of the level of accurate detail in the above statement,
> so the following is just to cover all bases...

Just to clarify, I've tested

- Without phylink or serdes (e.g. stop at patch 21 or 24) (works)
- With phylink but no serdes (e.g. stop at patch 25) (works)
- With both phylink and serdes (e.g. everything applied) (eth3 broken)

But in this case I think it might be good to investigate e.g. patch 25 reverted.

> It's worth enabling debug in phylink so you can see what's going on -
> for example, whether the "MAC" (actually PCS today) is reporting that
> the link came up (via its pcs_get_state() callback.) Also whether
> phylib is reporting that the PHY is saying that the link is up. That
> should allow you to identify which part of the system is not

Yes, I've been using the debug prints in phylink extensively as part of
debugging :)

In this case, I added a debug statement to phylink_resolve printing out
cur_link_state, link_state.link, and pl->phy_state.link. I could see that
the phy link state was up and the mac (pcs) state was down. By inspecting
the PCS's registers, I determined that this was because AN had not completed
(in particular, the link was up in BMSR). I believe that forcing in-band-status
(by setting ovr_an_inband) shouldn't be necessary, but I was unable to get a link
up on any interface without it. In particular, the pre-phylink implementation
disabled PCS AN only for fixed links (which you can see in patch 23).

> Having looked through your phylink implementation, nothing obviously
> wrong stands out horribly in terms of how you're using it.
> 
> The only issue I've noticed is in dpaa_ioctl(), where you only forward
> one ioctl command to phylink, whereas there are actually three ioctls
> for PHY access - SIOCGMIIPHY, SIOCGMIIREG and SIOCSMIIREG. Note that
> phylink (and phylib) return -EOPNOTSUPP if the ioctl is not appropriate
> for them to handle. However, note that phylib will handle
> SIOCSHWTSTAMP.
> 

Ah, I'll make sure to fix that up.

--Sean
