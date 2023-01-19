Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16871674731
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 00:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjASXZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 18:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjASXZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 18:25:44 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2045.outbound.protection.outlook.com [40.107.21.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C62DC2;
        Thu, 19 Jan 2023 15:25:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2DjBneqAZ4O7Aeg4CSAfTgqFRJAsWPN0UurbYmXchC6jSXEMwDh42EiscHvX8BrlqDs8FvgcSqS0L5n6MQaMEfQqMOumWuZlwR76Ykxyh59zk3+zpuqN8XmiIGvRvtzKXINreI8YLVA/rYXVZ3KcRQcsczQh3snxDSxltZcFO1Z4GY4Tsqi6nKrkljK4wjkORoJSXvPBU08IlX/rBYsInUWnKdrJzU9YF/OrB+QIBLO9U02Id0xYI1oQmToiVqPNc27gF2RojIW0iaUECttVj+Ieq5bK2+de6dm4oSKDMVk44JkdLYLYT3TqMxKijXZOxOuSzAj3fzFmEglqvH/2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VFn3octmcUlSRkn8C/g19M6SeT/1pL37lZmRzY6pdk=;
 b=VMIlSly2Ox/i+89S5aHFfHRtcOPmsX3cHoJowYGZ03kTqPlm+eFbSe8xa/MKNd3uY4v7OEFKlTdyBRoEgVOA1NBXmF7+WtwLoANL/X7Dz3oQLAkp4Wkf2i8B3cZrgHydz0/PYzpV9gIMWMokg2dRZZWDne74Zl37oOxKYizC6/amofbdbXiQjDUV6QuMGDnVzYfIrInOzQapFFs9t2G34pqayJXZWqRJVIRKkfc6cQrudloUy3nMjT6dcmxVsJy9pq/TLurlU/5zHouxM/eKggA8MgpqK3gi7vglAV+orqnhers/WOZf0I+KSlTEnrnNKJxFYrZv7p1GHG0ZLpnFbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VFn3octmcUlSRkn8C/g19M6SeT/1pL37lZmRzY6pdk=;
 b=qg+A+ipvnuqMinFtDOVHz+X3KNXeQyG6JXSsPRWpU9RRcZJzh0G4vo0Qoo3Tr8FbEivPdKOdrB9hPxeW/vpup0R7U/Wd1jh+dib4/NXbFcCwg9NT6+Gx7EQFeJo6mOZP128rQamgJzKEzl6r+RW9ittkm+vCdfwKrF9/adBAqRTdXUFsOEEfkfv4U7/A1GoC1qlhYL/UuE33A5+7efYVnMWL+mCCpKSFFlKdM68Hr82I+WZyzm1jnq05Sm1a4ikrKzVPsixvlcbV4woLZ+8xi9yKrXQLj+oc+PSvlw8QSDvNkrdzGF1DrUH2C3lQwa03u5RecTOh+n/8RUXoT4Td1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com (2603:10a6:20b:56e::11)
 by AM7PR03MB6545.eurprd03.prod.outlook.com (2603:10a6:20b:1bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 23:25:38 +0000
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::264c:4825:bcb5:e4ac]) by AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::264c:4825:bcb5:e4ac%8]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 23:25:38 +0000
Message-ID: <347b59b4-3a42-6b1e-369b-641e50bd00d0@seco.com>
Date:   Thu, 19 Jan 2023 18:25:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 2/7] net: fman: memac: Convert to
 devm_of_phy_optional_get()
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <cover.1674036164.git.geert+renesas@glider.be>
 <0c2302aceb4739ec846edebbc57e71819a8b8ad3.1674036164.git.geert+renesas@glider.be>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <0c2302aceb4739ec846edebbc57e71819a8b8ad3.1674036164.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0374.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::19) To AS8PR03MB8832.eurprd03.prod.outlook.com
 (2603:10a6:20b:56e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR03MB8832:EE_|AM7PR03MB6545:EE_
X-MS-Office365-Filtering-Correlation-Id: 7921267c-e32d-45aa-1c36-08dafa7478ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMlhzKh/mEBjpqX3Whq1BA7VlKBQFrZOm0k7dlyvGk0uYpq1sHri33EwZHbLmCiwSfTBeOwer/5k0TdrvwATiFo7NQo7zueh06xccVmB8Ly2XtbKAn7lby8ePIc6nw1RmkPkvuYcBM+4+KDUDSEiBRqWRh7qCkZeoLomNhjZkCmhNdl2OHM/Se7YhHPpHv8LNPkMQgj3Cp+W0f0PTOrQiJdTniQatrDo1/pyAN+P1T21cYTYI7eYYp2gbeRBOinhgDOMLwj9mYLE5lAy/UcoGn6ZtT7zvZxtJeDJY1XkRmCuq2ljViuPKBwS3TH5bptLX/Fk9bSRB4mvHgyVLIC6Top0XEEjsG+LcUBq2c4KkUhwMP7d8fEPlwxt44YHBjVUwn5IyxvwlbD3Pp8yS5MoMXxPsYL9+jd08nJ5nZiGYuPJWczLi1rwykNokcg7QBHYaFiPg3o2eLwexKaN5ymadqmTfEm1RFZMQfUW/gXdJpdGjPYqXhsdWBBjiW+YMZgjkHBGuWiadISe/KPrKcbasIJMlfvCBUgpdm96zlPG3AhwaO/LpS30E7a5Ai2G93c98W2i0TuoZ3ldq6iOvmlH9YIKzpkmhGvz8n/z9bt/hS3ZZsj6N5kiZd/cDTgzS8HdRHugotQuYtLpqo0srEl/RJzjCXz7VLnLZfv3cndz4yxy/H0mUEkWmWBOruu9sAmHgoaugLHKmNQK+11vjKwED8K3WiH/OnEo1KES9+diNveORcGZuU2mNo6pR8ngpPtIHip2vUgPlnoJP6TVmWCDjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB8832.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(136003)(376002)(39840400004)(451199015)(31686004)(44832011)(86362001)(921005)(31696002)(41300700001)(5660300002)(7416002)(8936002)(38350700002)(38100700002)(36756003)(478600001)(110136005)(52116002)(83380400001)(6666004)(6512007)(26005)(53546011)(6506007)(186003)(4326008)(316002)(8676002)(66946007)(66556008)(66476007)(2616005)(2906002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHVkMDVKdGlFY3JYTU1Dbm5hZ1pLdEo2WVJUWEt2dGl1TC9ScXBvOGx1Q1Rl?=
 =?utf-8?B?Nk02bFNRTXI4SEFUME1Gc05lL2tkcHh5QWtjT2hBMitvOHZySHM1WTlrUUNJ?=
 =?utf-8?B?MjRNb3ZYWHBMY2hXeXFSL2hMY28yaWVkMUh5UHFUVU55dnFlYUdMemlQcHRS?=
 =?utf-8?B?Z2tOd1ZqQlIvZDgySmJ0bHY0aXFUYWJTYW1ZOVowYUhrT2xld0VLc1VtVEFs?=
 =?utf-8?B?NFp3dnpxK0hnMWVGT0M1UENMM1k1aGtlZEJrWUFOc2ZmR254U1JMemtLNHFX?=
 =?utf-8?B?d3dSSWJqQzhyWWg0a0VJdmV6U1c0UjhDN3ZiNWpWT3JKVjlXRC9iaXg4Vzd1?=
 =?utf-8?B?bDRYVnp5UUU4MDFOVEY4anFGTE1nbWhxMXM5YnY5b2pudFc0QjBWMU1rRXI3?=
 =?utf-8?B?bXhaU1lsaHlxbkpsY3FVcUp3L0NFTTcyUXkrdTJLYWRZNFB2VW1tK2Q2d0FD?=
 =?utf-8?B?Qlc0dG9BUnlWRVY5ZDVNTnlzb3A1WHhUejJYaWc2eXVlSTB5eXdKSXJyWnk1?=
 =?utf-8?B?WmlxSFNHempicXBsekZEZ3l4Yk5yTDBNK2lrTUNoc29oWlJvblQvOXJJZUNo?=
 =?utf-8?B?bXI2b1pCQllZYzl3cjQ3d0c2cDdZOEp2VUw1MzVuTzhZcnAwZnViVTJDM1dZ?=
 =?utf-8?B?VnFSdWhKb0h3L0QrYXZlTWIrT0FxeHZWTTNiUVFsYUt6NWpsZUpYdFJwSHh3?=
 =?utf-8?B?V3hWV1JxdkJoU0JzS0pJQysrNFVyVjc0OXh1VVNOMVZMTi9TUE91QncvK3Yr?=
 =?utf-8?B?UlRaVkpxZkxuOG1TcHFLYWVIOGoydGx0UWM5eGI4eDZDamRKaittcEEvRkFG?=
 =?utf-8?B?WmxIV3VTdXJkMTNhckZkWHh2cWxHRGlQa0NNdGkzL0xqVTB5b3RIcFNnZGlX?=
 =?utf-8?B?VU94bHF1dXluVnl6RndQa0dpREpVdHp0M01IcHZRS2Vhak92dDhHYUsrQ29Q?=
 =?utf-8?B?aHZDbXdCTDBiYUVjT3FuaHNCbVhobUMzTVJwMG9KTytwdS9qaVB3Z2Nqd2FC?=
 =?utf-8?B?Zk5kZ0dXR0VnUTBqQVN1QlozTVpBekdnMUxmTVJvbHJyRGJ1SFNDNEcrNFJU?=
 =?utf-8?B?bDVLZ3RsR2RtOThuaGdrMWU2ZEpHWkJJc2VHckdRUXBmZ0huVzVpYmF1VjUv?=
 =?utf-8?B?eWJYUHpMS0h1NHZaengwRVA0VTZnRSs0K1lEZmN0Q0ZWZGFyWGhwVHlLaTRS?=
 =?utf-8?B?WjUrblJYMkpldHA5b3MwbU1XYlJyb2dpTk9VS0l2UmxLSVJ5eDV4THZKRHZa?=
 =?utf-8?B?SzBlSi9MRk5oeWU3TDRrNENlRyszN1hZLytndlNsZWIvWVcrVGVYSm5qK0FD?=
 =?utf-8?B?aTNQMU5qOVRiRkp1UHYvK3czcHdENWIvZzEvY1BoUjJKNDVETTg0bFRsbm8z?=
 =?utf-8?B?VmZmYXRqcGxWOU02TGNTeVJJMFhYOFA3SmJuVlJZdmdtK0diQ2RwZHRDbnZS?=
 =?utf-8?B?UmI2TnQ0b0cxWUdxc0VWNzNKdzJsUVdMOXN0YjdTL21iTUI3YmxqeSt1Q0hw?=
 =?utf-8?B?amJ4aXdFM3BBRUh0ZlNaM05CaFRja0NnZTc3a0JWVSswVWpiQlkrRGc2RGdx?=
 =?utf-8?B?dXA5ZG9NZkhxV29Ia1EycHhGTC9Ham1aL0RhZ3VxeHVGSHFGeEVEaHFjMW1D?=
 =?utf-8?B?c3JiMFFwKzdNWXBVMzRPZ3ZKUFBRQTZpZjQzZTdWNzJvVzFndkxnRlQwcDlI?=
 =?utf-8?B?YUpndzVpODlOc0lCeDZmMTJWcVRWMEdXYUdFWmc1KzVwSzlxU1JCc3RrZFZm?=
 =?utf-8?B?SjlvT1lOcHNRazFsU3ptaGJncmlUbGZlNVR2VHFVdGEyalFzYVYybUdkdEZp?=
 =?utf-8?B?dXhMeG5xN29RSWlVNHhYcEx1WHhTQ2JkT1RUZDJmb21RRlQyNVZ2NnZUUmxG?=
 =?utf-8?B?Y3VZVUJoTm1zTFRQUnFERkhlMFRRNit3Ry81RFV5QjhjSC9hTlp3RC8wclZ2?=
 =?utf-8?B?aC9lVk5nSFQ0blQxQTRhUExnSmNMblgrei9iUU1QQUhkaFZIWHAzZ3BlK1FR?=
 =?utf-8?B?L2IyUW1zR3d6MVhidnNuSStqY0hLaGZwWHVzcnowamtYOGhHNXQ1VXNsV1Fs?=
 =?utf-8?B?anFGS0hiYXJBYjFjalNLSUIzdk1NcUhNNG1CZUlrZ200Nkg4Skc2NlVVKzhr?=
 =?utf-8?B?VndyMlpIV2ZoVHFqcGNiV29mSXh2SWtMRE00R3F4NGh5TTlxbVU3eW04MEFw?=
 =?utf-8?B?WVE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7921267c-e32d-45aa-1c36-08dafa7478ab
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB8832.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:25:38.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PinIk39hbEHMcyiy07oeR/ViXXfeJVH0LHB33/r9d/V5Ura9FhrS0bG58lVuCPpj8hYUeFHuB0bUl8rA0mDVwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6545
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/23 05:15, Geert Uytterhoeven wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index 9349f841bd0645a0..892277f13048660d 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -1152,12 +1152,12 @@ int memac_initialization(struct mac_device *mac_dev,
>  	else
>  		memac->sgmii_pcs = pcs;
>  
> -	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
> -	err = PTR_ERR(memac->serdes);
> -	if (err == -ENODEV || err == -ENOSYS) {
> +	memac->serdes = devm_of_phy_optional_get(mac_dev->dev, mac_node,
> +						 "serdes");
> +	if (!memac->serdes) {
>  		dev_dbg(mac_dev->dev, "could not get (optional) serdes\n");
> -		memac->serdes = NULL;
>  	} else if (IS_ERR(memac->serdes)) {
> +		err = PTR_ERR(memac->serdes);
>  		dev_err_probe(mac_dev->dev, err, "could not get serdes\n");
>  		goto _return_fm_mac_free;
>  	}

Reviewed-by: Sean Anderson <sean.anderson@seco.com>
