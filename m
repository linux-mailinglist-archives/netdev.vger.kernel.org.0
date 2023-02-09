Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6A6907A9
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBILnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjBILmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:42:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1674A6E885;
        Thu,  9 Feb 2023 03:31:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZR2Q2RnFbagGyX5YCVSuYN30uU2QVj2mWzqzF5iSq8uUW4IjVxQiHyAyTq7G1UzVoXSYPPxzav5rPK+A4Mh/ITs44ZbIND1iglV/Cg9CtdWk+nP/UsjDrgoohEvcUIMmfCvtrsW9ucUohJUA0pWFevFgGhwwWVOdCbCnS4peIwdf7yWFMTblKG7opUofqjD3ItN4LtFEupsbhcuUAUZ1AMVI/tFG5udQR1aveVu0sPTMcu03/+N9HJ34lha2T9ov4b9RWIDVjyfLtL/76S0EoeMztbaZ0FSEAssaqhjE9mO1JtKZe0aTEEciu4sp+FjobNEClMHCepK60e0W5WEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wv/h9yMF1V7f8yQyo1ITCHbCwWDrmyWqYtd76E8ToHE=;
 b=AIikFwk0FSPqlx9eirUO/VY0izD2abhKoCtO6eTgvLeZsmuUWXiz/oBCDhsQ8OKvxZO3q4+HWcM1jYnSUKpge1nvJY06EjhtqK2FVRH9FTe4o7VvSzNqEKGScXyRbT/5u/vcbjZMLhyQ/mNAkI7d2lVf0apkCwLfeBpoucv7z+/C+D9n26w+kFsvkBxmszX2mQaaecnF79j89QyRf4G3gd9yrVOlFThTAUCsFoXT5DNW+fOBJ/xQ7uOnm6/v6pXmzKu/FMjXGdFMGiOGXq0ZxEPZjFRWSZ3HKsHc7ITWKn6Rw+nNrP5boOPCpNb4oeQGu487Zq6v0jc/e3FMMeyPiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wv/h9yMF1V7f8yQyo1ITCHbCwWDrmyWqYtd76E8ToHE=;
 b=eQ0M/s3sSwbTRQo7lwAn1wirtgYUKwYHdG9hv5MqPxAKIOM3ghMiRZFlyENi13CRosgmdxel+Y/abR18bLp8vVLJ4GTQhrVRKsq3d1pXszWtE5MJHqDS4AUPTMjslA6cATz6aqoENg178ZRXt1GWouS1eHT11vTdPK/uRwAHRQDBWEgvgPS1fRJTJ8R3+ZhILSMwY9qZaV3J8k2rVaQ3NiJlloZoeYOVPYGnaDBDICcAs9mtOXi11VJyBuAtzfl5WrC6QpUvQTgXczW/tWZE3YiKYXeYbAUV2CmymMNLkWCig9KYP/dH2O60W5NjrYY9K3w0bbq704WtoDJXbDbRvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6604.namprd12.prod.outlook.com (2603:10b6:208:3a0::7)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 11:30:03 +0000
Received: from IA1PR12MB6604.namprd12.prod.outlook.com
 ([fe80::735c:fa9:2043:279a]) by IA1PR12MB6604.namprd12.prod.outlook.com
 ([fe80::735c:fa9:2043:279a%4]) with mapi id 15.20.6086.019; Thu, 9 Feb 2023
 11:30:03 +0000
Message-ID: <e9772188-2b52-d7f4-0540-9e9402155285@nvidia.com>
Date:   Thu, 9 Feb 2023 16:59:24 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v4 03/18] hte: tegra-194: Use proper includes
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Devarsh Thakkar <devarsht@ti.com>,
        Michael Walle <michael@walle.cc>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Lee Jones <lee@kernel.org>, linux-gpio@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
References: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com>
 <20230208173343.37582-4-andriy.shevchenko@linux.intel.com>
Content-Language: en-US
X-Nvconfidentiality: public
From:   Dipen Patel <dipenp@nvidia.com>
In-Reply-To: <20230208173343.37582-4-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::13) To IA1PR12MB6604.namprd12.prod.outlook.com
 (2603:10b6:208:3a0::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6604:EE_|DM4PR12MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: d27b7497-fb1c-4a3f-af5e-08db0a90fc2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kJ0ZjfD7taWEJFCo/vx/mTiyAEC2X1B5VCXMLNd1n7I7puu1EUNOPjfMWSzzQb+upc5gf4sayt5uSBAaOua0+lRtCJof0QqjE+OdLxV9ZI2LwKQwOwjKWqh0rw1+BjFmHUWwltOzUMtJ7TvcZ0TJlJfbgG1dNbaQ/FjVpDJ1UFupHN/bpzXp3aWy5iFQF+8yge3ZFseeiJbtQSfImgB61mkjCUK7haZZuKEkXwiQvWSwuWxn/GkoFt7bNUWWMZNEFBCZuDBa5qjEhlk6ndB6o7BKmVuCyzeodyWFqqODQ7DB51pCWN4LJ1Zi6lKqv5gVy2d73VuGe1JMNbk0GUPlWk58Xf3JApo+tBPGCCod9nwzDquDWDUgwIEl80JT6sfMb890EY1Fr35FIQH2pSZYQ5zrFpjEbVUmO/9UrT/y39U1tsQYneP3XpJIHWx+gIuG1u0q+5RTJoffEJ0R3DvYAbbJpFx2EF8sYcitlHUtqk+/CO3MezgmhuOSENdz2PiSj7P9brVdLqMgbD3YHflxi2cWrODBwMhUDWepfTczH3adY0SG5EZLOk6E8Exdx7cURwziwuOQ2r/RXljuyEP0Y5uM8mzQ+TrjhK/H2EWU9wBuTo+hVNXayNt4F92ZTJe+6TrPN8Zgy/0kNK+jYwOMgHTU65PPQmOxNstZ1h3RW3tjFZFUa50ct8m53fVmmnb8up4ySdK4vTmZ9admV0/REWKly8QwbGJteMS6VZYnkAIDfeZGM4oMclXRYlyeM5gU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199018)(31686004)(7366002)(36756003)(31696002)(86362001)(2906002)(921005)(7416002)(5660300002)(8936002)(41300700001)(38100700002)(83380400001)(7406005)(66476007)(6486002)(478600001)(6512007)(316002)(4326008)(53546011)(186003)(26005)(66556008)(6666004)(66946007)(54906003)(6506007)(2616005)(110136005)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkxVbHQ4NE9zeUc3VSs2Qmd5M1VuZXRLYlltcGtEbDc4NlVIb3l4MEhMZmR2?=
 =?utf-8?B?Q3hRQXpCZTVXMis1RjlPRFBNUnB4emI2LzZBOHpQNE45YmxRQUJ3MThnRzRk?=
 =?utf-8?B?UEVDa0xFdnJWdzBVSTFOY0NGN0VFM3Fic3ZoYkpaMExMVkpWU0FCaUVUT2Jp?=
 =?utf-8?B?VlFDaVM4MkhhNjZtYnhGcDN3K1E3ZEhPdWF2b0VkWkdxYlh1VnVMVTR4RUtZ?=
 =?utf-8?B?QWxpYmRMWXJieGpaRG5nWkFYTnkzMXJRWVVYTzk2RGxqcUdPeFlrSkJsQ3ZJ?=
 =?utf-8?B?Y3ZqVUwwa0ViZEd4ZHRJbXVlVHJBblZ0RUJHeWk1Y2VuV1l6R0ZkMjNDQ285?=
 =?utf-8?B?RXJ2ZDJFOGJiQVNrVGphVG14YmVOWC82YTgrT3FKWGdVZURGbjNmdDRYK3pW?=
 =?utf-8?B?RUZ6Q3ZwLzdVRUVLcHBMU29OM0kvRXhvYjMwZDlNRUJveFZGK2VDRmZEbU50?=
 =?utf-8?B?TVZ3b1doREt1bkNIQ0J6eHBVVlFGSisvU2lYVmpucmVzSllTSmFiUUdzeFZm?=
 =?utf-8?B?OGZwc2U3S3lRL3ZSS0xvMFNwRVlLT2xRUjU4eFVGSXRiN1g0TU5LY1BVNEt5?=
 =?utf-8?B?L3I1dUtkM1BNRFJnY0Qyc2lUMm1oUG1EUlprZ1BBaGYzZWtLTngwUGZUMzFT?=
 =?utf-8?B?MW0wUFh3Uit4aFM2M3cxTnJkZER4aTRENFFXejBwdm5mdGpOU2pBVWpvTUZr?=
 =?utf-8?B?RFFBdWMvZjdkSWo1QnZSSWlRUlBwaENqb09zQ0QxdGtZcFBDcVhhZWxwY1A3?=
 =?utf-8?B?REdORWtmOTdJcjFNcVdQOG1EdW1zM1hiL01ybFJqSG1vRjUyYmU3UEljSkJC?=
 =?utf-8?B?UEtreXkrUXBubnltVnpObjQ4enZNMG5nZWVNWGF2NFNOVzRTVnMxS0NvU0h6?=
 =?utf-8?B?MlJqZkZudENxMm9CbFJwU0FCWjRXTTU5Q21iQ3lzR1ZuWHpUMTFOLzJXeVdZ?=
 =?utf-8?B?T2RCeHBYaHU2amhVcDF6YlNkd1pQRHF5SHVkNnhVZUxPWEdUV2c2djdHMFJM?=
 =?utf-8?B?RW1lWjRiTDRNUno4MjVzbXB1Nk1nYjhKVXZCNmhGUGpQR0NkZmFrS2NOWmJ4?=
 =?utf-8?B?UWIzdTF1dzZqMVFkSXliN3hKNFlZOEdpMXNHa21qbGsvZ1dWU1QvZ1JTV0tz?=
 =?utf-8?B?WHhscVY0SUZ1cE41NU5abnM2SVJMSGE2YnVYWjRUQnQ5QkJoYjNxS3dnUHVL?=
 =?utf-8?B?MXBFSVF4aDdpRDhsbTYzcjZ0SWFlYjhZTTNaYlRldHZSSmhJVm91eXNqb0Ry?=
 =?utf-8?B?SGMzN0s1UmMxS3RsOWpIQjJDcmtJdW5FTVBNNU1KUnQ5czBDRXBvOXZ2Qk4v?=
 =?utf-8?B?N1NpVy95Rjd1SS8yamZnVy9paDNqU0puV3hQdHVZNlFONXdrS0s3TlhpTW50?=
 =?utf-8?B?dm4rNnpZS2pBbGIxc2swMnNvMFZkd3RYRE1ZdDJMNDNVZUIrZ00zRkoxUU92?=
 =?utf-8?B?bVJGWXk1ZUEyVk1wd1B1TktNeEtLUUhmWGtMT05qd0ZlUFZMcHc2aDBFbVJz?=
 =?utf-8?B?YkVESHg0NlNCZTlpWXVzaUxOeW9LeE9JTytqN1pBck5NOE5oa3NZUHU4UUM0?=
 =?utf-8?B?Nmg4eSsrVUVraGdlbXJEbWJIZkkwanJQYS9WRmwva2ZYMWFzUWFINmx2TzZG?=
 =?utf-8?B?eit1YkMrWmtpblNaLzJiZDgvTU5OcXorcThFVDVkcGcrcUdKUVpMdFJvTU51?=
 =?utf-8?B?VzRJTGk5L0V6YXhydFRjbElCM0JyTC9OaDNvUXUzN3h2bTlvaENKQWFnUEdm?=
 =?utf-8?B?YXZSZzZlWHROZ1gzVHlHSENmOG5RSkJXSXRTdHNuRWpUUE5iVy91Q2VTUjlR?=
 =?utf-8?B?NlhMZzY4cVZWdWpXUGE2bEROWjRaTzE1ZXhkQ0pvSVM0Yk5EU2xWWlhNanlU?=
 =?utf-8?B?VDFMeE5ZMEtuOW5oM0UrOWdjS1JxTnp1SDJJSElyN3VIL0pvcDRMV0pNSktO?=
 =?utf-8?B?R3ZFQ2s5TVo2RzV2WkR5cGVTVCt6bU14ZHhqb2U3bjk4aHhOaGVNMjlXTmFh?=
 =?utf-8?B?ZS81K3F5dEc1VnlMNWZWZS9BT0xEaHhVN01WZFNiMWJzODJ1NVFDUWQ0ZDJq?=
 =?utf-8?B?cTMyTzJZWGxKY3ltM1p2VzdBbllPWWxvbE1ZRFBIM2E2TCtCRXhRZzJXelR3?=
 =?utf-8?Q?yx6R0t4siwkpyC+r0gwCmnBXz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27b7497-fb1c-4a3f-af5e-08db0a90fc2c
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 11:30:03.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RgnVePRshhtNyI7EK3hV10yfvYWwoy6r/JMJaW3kBxatpvWgvTplrf0ZPqjDP0Il5grE/15H1h9RyChK1nEEDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 11:03 PM, Andy Shevchenko wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The test driver uses the gpiod consumer API so include the right
> <linux/gpio/consumer.h> header. This may cause a problem with
> struct of_device_id being implcitly pulled in by the legacy
> header <linux/gpio.h> so include <linux/mod_devicetable.h>
> explicitly as well.
> 
> While at it, drop explicit moduleparam.h (it's included with module.h)
> and sort the headers.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/hte/hte-tegra194-test.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
> index 5d776a185bd6..358d4a10c6a1 100644
> --- a/drivers/hte/hte-tegra194-test.c
> +++ b/drivers/hte/hte-tegra194-test.c
> @@ -6,14 +6,14 @@
>   */
>  
>  #include <linux/err.h>
> -#include <linux/module.h>
> -#include <linux/moduleparam.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/hte.h>
>  #include <linux/interrupt.h>
> -#include <linux/gpio.h>
> -#include <linux/timer.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
> +#include <linux/timer.h>
>  #include <linux/workqueue.h>
> -#include <linux/hte.h>
>  
>  /*
>   * This sample HTE GPIO test driver demonstrates HTE API usage by enabling
Acked-by: Dipen Patel <dipenp@nvidia.com>
