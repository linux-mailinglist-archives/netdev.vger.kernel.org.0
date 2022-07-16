Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9A577202
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 00:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiGPWmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 18:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiGPWmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 18:42:36 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD23192BB;
        Sat, 16 Jul 2022 15:42:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cs4bJJOQFV9gnW6zObBPL1Kz/rJkDHm0O4yCHKU5SlGC4LlUfzDKr9+vL1uybHVqxSiTP0n7qPBxl/1Ga0eN13LGEkgUaxYXNn33APk7dNkEwqYCw0mciym1URmsHqsKlpAU5kChVihYomS53eKmcwDe9uz78SFZfkem7Q0Qqc/pLNFaGyI9yO+/LZH7ncIOgcsk9tDbgLCsouq4QolvNomKdiFovp4wo7tV3nUk4sPQpaYBS3bbHd8eVqbunn5wBl0Rw8xLB9UYbjWeD2Amnxt6m+djR/mTH/yB+egFmLbtahrh3cFfurMXPQf8+9+zw/CgLwgWAX9tWN2bqO92ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtQxBWqCnza38npKtk/wMpUG6yvkrcGdcBQQ/q54IOU=;
 b=U2lyLUT0GdIZwUmdy5A93xA3ReTp3IuwAbDXFEt6D/joShCRC/myuAWlxYUmBto0z1d1GESf1ePKuKJoLu8YLq7E3fXuXNAlww5vA3muYF/YfxPyALj43L4R7GRzKykmDxb8Dd9+BTmvByoJC/0bpB6FTh3rA4HVwXpWfzjHAUD0LJeUqfL1IW2gO/6SeFmk9OT3IGTogdqlW0kd6khkYpu0DTUWZxRjnN8nc8RskgVp3zW3i3cH2v+5jEgHg41TxTGh48cEb9AZY1Up6UZV+7uu5shATQxY7Vs/YTcOI+7xr7J/V/Xg04EBVNl2VuQQMimV8CPQlzcMgKESkJuIJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtQxBWqCnza38npKtk/wMpUG6yvkrcGdcBQQ/q54IOU=;
 b=EWMXljLrqaQ7Q1ybjb+cm0PB8Z6JNoudb+wYcTGrZ7zBFspAsqpWbsvEp7J00zUU0cOfrUgfceeNXeggluKGSPhaaqVUv5AJrLTuOZdpBAoPLhKspYIr2XRDS4hz9l/ZgrfThkz5Ae0k/pXStzr7WNh8JkHeurG781jnLOX+eQ9FpEqaEbslwY8rZYBOtrH0oYX6EuQv6z2r/HTcAqts1NI+12VNPcqSmHkGOVLyJBscP3LsUCe8yMGQt9xFQJTqdB0K3z/x1+b4Jv8O5R2UDmZLDw+1UL7aZra85FkZRlR6FsDUuB0W7YG3EykCZi79eCqOk6Ov3Hz1m+j47E2hZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5541.eurprd03.prod.outlook.com (2603:10a6:20b:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Sat, 16 Jul
 2022 22:42:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.022; Sat, 16 Jul 2022
 22:42:30 +0000
Subject: Re: [PATCH net-next v3 12/47] net: phy: aquantia: Add support for
 AQR115
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-13-sean.anderson@seco.com> <YtMAvHXuI76cTLAj@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <afb79b32-5dfd-d1fa-130e-9d442c4b6100@seco.com>
Date:   Sat, 16 Jul 2022 18:42:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YtMAvHXuI76cTLAj@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:208:23b::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: badb141a-7fc2-4c62-f720-08da677c7771
X-MS-TrafficTypeDiagnostic: AM6PR03MB5541:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: No2g+gyjDRsoLmSpngMH+T74s3BW+ApjCVZILKpZtvpTa0owfhcE+PVZvFyxsADjH+cWZeAcMpqsHBXnpu8CYytrLpG4MxMRI2DxehLPdrCrK3otMHZsGLCVmcuoKW6OTX4xnuF8+nUaqYB2kp4NZkfGKEYF9MoSUgef6wKb/FspwEZjnp6gArJ0tRnJ1ZWI620+uoYr8fzo9NN5D97MVzkTJUQPEgQYVTI38VuLbXX2dll6G3yLd+hkEnX4VYvEE4SdllG+zNceSZHKUi+M5aaNz5bqoCqRciQl/pZjtlWSQa8HyuIpi6SafQSoKl/5mR6ZfpchbBn3NsfbIo+bqXm8a84XiUfMhnjxgu7gWfYT9YxL/vxKIBf7hCqePppHrqqQsTB8LowtQTF6Gw2iicc43fHfArUYnkK6qS3T+m74V0C7J8USqg1bJNtU52LGpxHRvhf6gqvONLxjJQQSYmdLCQ7p2/t7LPrfnOR7904N37FL52UOSuCw02XtCm9ijxsLcnwzIhHA6iX8sdB6R5A+GplTjBWZfN3VPMhq2AWBMYxkQn6WPCiI8DaUf17YL0UoI3y3cZ4rWnG+AHZhvrIqS8dJz6W+ufp6t7qUlRKH0o02p0EvyoIhKLKPeK2l9hqbwluRdYE7gn7BkVIITTeCMUlWLClS2Fp4vwOSVduPXtjkVi46oIJ1CQiCzsgfG1znv/dDZfLgfLc79Mw9gnt9vpDR1u7o7be/qpnxm0IORQO2ozj8wyW7ao3+8jskVlSERm7ynbuE/Ow9Mshn89sSKmxcIiTlqQcIkJRkdRxhHcNIBWjVeRsPtziUjrUEa32XqeO5GTPi0AuCpkMiYdfMc1iv2qdboAgEBQSo3Kaj6r+942iekjqopUQkfKAQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(136003)(376002)(39840400004)(2616005)(26005)(6512007)(41300700001)(6486002)(8676002)(2906002)(6666004)(31696002)(86362001)(66556008)(66476007)(478600001)(53546011)(52116002)(6506007)(38100700002)(54906003)(6916009)(36756003)(4326008)(31686004)(316002)(66946007)(83380400001)(8936002)(44832011)(186003)(5660300002)(38350700002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VldSSnVOc0dFZTM3aE5CNVlGNllhcUpsbkNVVXJxdmJMcndYRDFmZVgxN1g1?=
 =?utf-8?B?L3JZRFk1YWdTbmdUWDNDZkxNZ25NTGJWY3JTai9VaURJU1Q4dVNEMlgwREhT?=
 =?utf-8?B?UzlYOG1LRmpQaktUTFdaQi93RWlQVkhSVjNYQU1VZ0Y2VXFoeG51MGJsOXNT?=
 =?utf-8?B?Wm9aUzB5R1N2T3hobERpc2hNV2gwTnVNV1BvS0lKczNDQnFvZmxZUnVWSzVr?=
 =?utf-8?B?a2x1QWFiQWEvQkM4Sm9vUDlHSTRXcmYzOVp0OXE4UGQrbGFLSW54WnFCWk1P?=
 =?utf-8?B?TUc0NXQxNHlBRE9udmFLQklYY2RUbWE2Q202a3VrU3JCN3p3SFI0V0VpeWM1?=
 =?utf-8?B?YlpWS1B5R3Z3Y3JGZnc1MHo1WkR4bUdBai9wSlNvWWY2U1piUEYzV2hFajRQ?=
 =?utf-8?B?UHJxK3o1b05jRjU1ajdOZFVPbEd5YlJGZm9kWE4yR20xRGtqMk1lbE0yWW4r?=
 =?utf-8?B?K0MyYmlUYlg5NmIwTTBjRHY3dUg4WFJWSXhXb3BIYTlJWExhTVp2L0dBSHhE?=
 =?utf-8?B?VXNBRUtyazJpRURFVnphRnRVYUZGTitsWm4zc3RNR3F1aHR2aThoSUpyQU1v?=
 =?utf-8?B?RFhKWVN5Q2NRd1lZWVNnMUNmeEVSOXE1U1ZIdFNNT1Y4Wm5OdThSNXJCZUZy?=
 =?utf-8?B?ZTNHMTN5ZFdvRElMa2pOUWlTNWZ5MFU0SEg1QnVOaXN1d2todlhHUlRsRCtu?=
 =?utf-8?B?UE5SaEthM1d2M3VMQ2FJVEJyWWZpZUpIcUh1aE9nQVFGWGM2MHN1Z1ZuVGxS?=
 =?utf-8?B?WkNQU0V3SlBFMWtiOHpGWmxUYk5TbjhhK1FqZzNDNXRVTlMxbTVSdklQckJD?=
 =?utf-8?B?NUxZT3dBQ2hTRmk3TnVNOGJZM1FzTXI4QThHWng2K0tzdU1MTlRybldaS1BQ?=
 =?utf-8?B?NGpFNzVDUkJoSVlGdzh0WXNzYThBMlhFRHhubWFJSW1PSEpXVmtaeXZkK0dL?=
 =?utf-8?B?aHAzWHhPbFA5M3RpMkJBRnA1enh3Q1JZK1A3TzRCY0htVm9iWEFtSjVsZ280?=
 =?utf-8?B?UldJYjg0SFo0VCtLTW1rRTV0S0ZoY0luMVg3eDhWVXhVMXZ1WGgrNjQvUUM5?=
 =?utf-8?B?bWJDb3BWeCsxVjA2ZGtjMEZVZFFlb3lPUWlrZjY3ZWhIMkJFYWxjRXhPRVBi?=
 =?utf-8?B?NGpRUmRKcmR4UTVaSXc1U2UyNlNKNGtXNkRURzFPcWxKMnhpbTcwY0x3WDF3?=
 =?utf-8?B?eFhHdXYva0dVdHd6RDVKN3RLSXVGYjRZcjUzb2plSHRLZW0yWmRRaWFQcjNC?=
 =?utf-8?B?T1VXOTVtZ2VhQ2ttMjFnemFFWlZiczFEUno2NnMycC9HVkNhV2pJbXRrWU9z?=
 =?utf-8?B?LzkzSnBTYjQ2Nldrd2FUL3FNckJwK01wZVRIdndzZGs1cTVHaFluTHQ0QXc2?=
 =?utf-8?B?cmI4eDNlU2t3UCtIQUNoUTZQZzBDNHFWQXlxSWNiTEtIV0ltZXIwbytuWmx5?=
 =?utf-8?B?bXdSNE40WSswaFhxbzAzeTczS25BNjk0R0NCR2lrbjArQVloUm4xbEtHVDVK?=
 =?utf-8?B?dkttSEpjcE16eHl3Q3Y4WWo3eE9DZU5oVGNRc0dmRmRqenBxYzZiY1pBUk1I?=
 =?utf-8?B?RTFvdEozTjQ1dUFkNVBQamFpREZjV3lpVlR4dTBPNGU3anVpbWV5bmdLZW1H?=
 =?utf-8?B?MHJEaEJQYUtkT3RPdUFQQUR2QjdINVFpam5rL1ZEeG0zYW9IQXdSSEgreGlW?=
 =?utf-8?B?T2NxTmh0cUJwenoxQWVDN242ODhLMnBWVFJwMm1mdWtnK1ZoTy9nc2lmWkVM?=
 =?utf-8?B?OEdnN3FLNS9SNE9ERWZzMEZySnZnS0VtN3FxNStuaHlzTXFwcytFMVJMbHp2?=
 =?utf-8?B?dUNCaVJ1cFFRa1B0OTlVWmlkc1RXVTArKytNdWxjcVNmbnBpQittSFlFRk5s?=
 =?utf-8?B?UFQrb2E1VHBScWdabmYyVWw3ak5GdTA3QnJ0ZEg1Z0V3ZG5FOUcweTBEWnQ5?=
 =?utf-8?B?L01tbXNqcU5naHhpb2ppU29xTnNqa0dDVXR6cExEUCtlQStEU3l1TUVocHFU?=
 =?utf-8?B?Yi8rYk9jMTI5MXF2ZEs3bWtrdy9zR1lmajlUQWdGU2lWd0VzdEhabHZ3K0U3?=
 =?utf-8?B?LytJNEFXOHlDa3RZNGZrdnJ5Ynd3RU9NNmx6ZytJVGdFTU8yRExxOHYxU015?=
 =?utf-8?Q?R1BLKsM6Jvw8vtKvzFKsIvZnw?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: badb141a-7fc2-4c62-f720-08da677c7771
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 22:42:30.5315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ngHbHSgu76+pQr3++n4LLngj1NcNWBYJsCsd6Vgw+0SHrYxgp6P9MSIrVM5B2nJ5VH/ADs6g2A7QL5WYxbKP3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5541
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/22 2:17 PM, Andrew Lunn wrote:
> On Fri, Jul 15, 2022 at 05:59:19PM -0400, Sean Anderson wrote:
>> This adds support for the AQR115 (which I have on my LS1046A RDB). I had a
>> quick look over the registers, and it seems to be compatible with the
>> AQR107. I couldn't find this oui anywhere, but that's what I have on my
>> board. It's possible that NXP used a substitute here; I can't confirm
>> the part number since there is a heatsink on top of the phy.
> 
> If i remember correctly, the OUI can be part of the provisioning for
> Aquantia PHYs. And i think there is often per board provisioning,
> specially for the SERDEs configuration. So aQuantia/Marvell probably
> set this OUI, but maybe at NXP request.

Ah, interesting.

> Did you get the part number from the schematic? That should be enough
> to confirm it is a AQR115.

Yes, I got it off the schematic.

>> To avoid breaking <10G ethernet on the LS1046ARDB, we must add this
>> vendor id as an exception to dpaa_phy_init. This will be removed once
>> the DPAA driver is converted to phylink.
> 
> I suggest you split this into two. The PHY changes can be merged right
> away, and is independent of the DPAA. 

The DPAA changes must be merged before the phy changes. At the moment,
sub-10G ethernet still works on the LS1046ARDB. This is because even though
we program an advertisement of only 10G link modes, the phy by default
ignores the programmed advertisement. But by adding a driver for this phy,
the 10G-only advertisement will take effect and no link will be established.
So the DPAA change must come before the phy change.

Since there is no harm, I will split the DPAA change into its own patch and
place it before this one.

> Given the size of this patchset,
> the more you can split it up into parallel submissions the better. So
> please submit the PHY patches independent of the rest.

Yes, that is the strategy outlined in the cover letter.

>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> For the aquantia_main.c change only:
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>      Andrew
> 

--Sean
