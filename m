Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E231D6B7912
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCMNgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCMNgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:36:17 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2118.outbound.protection.outlook.com [40.107.243.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D016043B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:36:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nW5y8X7tvUW/+7AYbHcwjsT2UJRoT8VYdTrGXBAjmyO+vuxzACFlxwbnAeH53dyt0P9kBiQW+fx/8zx/6qu5JFDsQ58xOoJMwlmQyrseUW9qXzI1ZHdC10F7HdXHNFz9neyfDY0RgZcI82/NhXdFz73JhpNoVjIjuwWEzbLW+3VWGpdNvsh2YAXYrVZ5OIE+zu95zG2EOHFvGTXwOOrW8DUfsr15ilB+mRGOeLTGl/DL/8FwhSdxMPvLBs0scbSe110lXbjwb5ym9agZ13zjQI+FrUYKu+tFJ/O5jRwIDQU1uuEtWakdWbqNUqzDOlb3eLHoXYx9dc27pGEFW32/JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSGOjJlXs/8qiN9vYqzaLyiJl+DUQgn8zQaaSAvAxnc=;
 b=O5PiZ+VRPYBzXyCZgJ16ZuWZzaOABSmNqP1c6SCBYgVY3EFkKJW2lsp+RztI1Lr5syzgllUhLy7bTTLVlejB41jDZVR/TmIddRyMjVHKtTGL6dc3F53ppxwjoJ6DEFpEKQsP8l9MZrnYkBd92yzLbd1HTSBCV4v/lnQXHg1eIbMpWWOzMY+oYi49yWbzKLjG8Xjo55eNHVZsczXKGvsCCbQzulUllnkdz5/IruP43NdNsSXKsnWHV2h3t7TnyAEhbiPWROUScrYXqp9XFTD7/cf2d5fd8LdGcauRW96FCx/11mZ1R6SIcERUdH9g1/og3eVhtcKVHraxf9tJ7DsYuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSGOjJlXs/8qiN9vYqzaLyiJl+DUQgn8zQaaSAvAxnc=;
 b=BPYIFR0iD9N/3aJUKgmhlFE6mzIDiRMvz38RiPjtmEFOhZ3xhHbm5XDIKjaOhKyinKToy2pc/BiGQ9rILiH/Hm3QA1xHq9uOzyWlEx6o/+rmbqBqrm+ugRvlGiMsbHKppKIRSH1xIJmOURqx2sykMaTrr1dl6T/nGCdsR7wX+Xk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6042.namprd13.prod.outlook.com (2603:10b6:510:fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 13:36:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 13:36:13 +0000
Date:   Mon, 13 Mar 2023 14:36:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Patrick Trantham <patrick.trantham@fuel7.com>
Subject: Re: [PATCH net] net: phy: smsc: bail out in lan87xx_read_status if
 genphy_read_status fails
Message-ID: <ZA8mxgA5Q+CSuDqK@corigine.com>
References: <026aa4f2-36f5-1c10-ab9f-cdb17dda6ac4@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <026aa4f2-36f5-1c10-ab9f-cdb17dda6ac4@gmail.com>
X-ClientProxiedBy: AM8P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: 313032fa-3035-4a77-b982-08db23c7e984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gv0buYt/iDuhZNMPMsuEIPHF2CzcXvPaWKxTJXsMmigqXiFlkLYob6ydYRouSjoOVTN9WhBKqEIfd9I0wZai18rw4FCUwiYN5cgL2NJ/v3FVsws94c95vRy2Xxueb3rKF2VI8XjjzfYGUKsYuU3neSUA7G0IQ0HFNh9NWvUwGKUtZBVedGoWuFa7TszWew2n1oRyFfCL8NYJqBqNzxJs/DonW0rdG0tz/dHX2frfcU9x0mvQf1dXGGjFjJq7AvBKq1Hj4GPvWxr00Kl+8KiNN0fN1LR3jlJb0A/IwvbBRZBlU7vGqAdQN2In5Sa+08emtk5zg4QQrjE2lGJF4rSfRgc2P/hHmJYzJEdEjlK7aogaxMaQh1P9QlKbbfXQm4PxzmyF3dkSx22x3fbRkloY0XtCv+2afl7bcoerl1w03mgq7FjLwOYv6q8DnCPn4aA72R1JQVaiyj+pGqxfG9js8wTGWeTqL/Av0DEmWLdf1vVypKk10WYSk0gdK45yS2WsYTROJgJzAgzwvO2g9Wy2KHrqS27j6fnqWiYC+T+7D1OJpEnyvhSpIqOX9G1JYxblE3eYUlyydetCfEEEb9gdTi36OsskAYka3Ty64Q9NfedUB+FgumyN7ncdddVOVJNBkuGzrZUmOVjfpieeA6PND34ybOCLu5mjuDnqptWC+PeUU5x0Lqg+i57BnoXCRw1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(396003)(136003)(39840400004)(451199018)(6486002)(2906002)(83380400001)(6666004)(36756003)(44832011)(6506007)(6512007)(5660300002)(8936002)(186003)(86362001)(41300700001)(2616005)(8676002)(6916009)(4326008)(66556008)(66946007)(66476007)(478600001)(38100700002)(316002)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hp26jFXER27GFGVG4uE+fH8JefoEBEh95vv+6BiSPrbChih1Qek9/wdZlLsW?=
 =?us-ascii?Q?6uPEHoPgjA93SBLWBcbtlUI/UpAeYybcwNbS5Q9k2fJ0iOt3nlYxZ3UOpb6W?=
 =?us-ascii?Q?/ZCSfeqxcb/pmqKzlfYg0EMSiedAgCAlKWxTUaJ3XMP0h2sjiOMQjmy//6ZO?=
 =?us-ascii?Q?106xWX1fNzPIahU+Vy8bID8y9i9rM1W2gCQnNT/X9cyTpZ3tH8sR/ZV2A5Xx?=
 =?us-ascii?Q?8hZtHXhODxItcG6COE3su09bP6SXZW9qrRkgp9F+8FaqbLrO94CsMEZUXYZX?=
 =?us-ascii?Q?grvUetAIICLJ4GAhcI/hP64Ftm/mICGaSvwqpXDLuClioEm45LomKpzZ/Fq5?=
 =?us-ascii?Q?0o70b70wL83CysGrD/8QzfddR0chCgmJHkVygnbI192iECWC/Myol2UmI2hn?=
 =?us-ascii?Q?xG/qdND1qX3AxTpsJVQyjzZcq+405TLCyM2o4QcMOzquUl4xWrCSlTJLoytK?=
 =?us-ascii?Q?39IV0dtCAgfHBjWxbuA4ByKDYFCdXeJItZu61emVb7nJdXWhPKLyTHtR2qVN?=
 =?us-ascii?Q?n/6TDvCrOU2Co/sm9DCus1gOyNI2DcZzR34nkzEoepRxxCn+9UcwM9Ndue/H?=
 =?us-ascii?Q?oja3S3y0qazpaMhfWeluhUKL0EEU+gwaQf5gUsXjfqiso+N880+7LMdH3dFu?=
 =?us-ascii?Q?p9BjBoURAIfxwzR2IJOEmXsMffFuCWeUVpRaNICcfEPgSb1x0Adyul1Aqfml?=
 =?us-ascii?Q?LAPaq0EE6J63G9Ob7ui2dwq5XWtKI2jBHl9P9yEoxlxqKerJcq1ltAbCWxDT?=
 =?us-ascii?Q?8IlHINfnVKL83gpmrKn7xXLyIxVRdYi5CyIdKaZ3UgFecJgsv+bKSt5iB2J7?=
 =?us-ascii?Q?E9IFjDzRXueIRpcv/TJI3S+dG4S2ORj8MuADVRau26PSG+PpgrG3s0TmVf2F?=
 =?us-ascii?Q?9n4JhuxeZTvI9KVtmrCapW6rA2GjD7FbeFK0r875CW6aBj8kHQtYrHvM7UkB?=
 =?us-ascii?Q?6uvoiHMnt/zOg5axw3njAQ2Q6gBM12hObr0w6f9+l7iZ6RLRGh7WIi1Jn6nL?=
 =?us-ascii?Q?vlF8nSCyHIjgSdwZ9HoKvkyyX7b29ZpAc5TXgxayWUTVCd2PmnvlEE2SbuzD?=
 =?us-ascii?Q?NFqlVRVr4EyBnRkGQbNsfx1x0BSmTyiWYLj3pl/PNcPpPANPWkvCoJjXh4Vq?=
 =?us-ascii?Q?2JPACX0VZNY10JfK0L/z645IzluBEb/gJ84zB2eZTEh8KZvKcw1egAdqlWwk?=
 =?us-ascii?Q?4GTYCeQlJtQIyXPdA3WU4gwvT8C8pmzpYVQoHHlNu5jMAxc7BrCRCI5sZK5H?=
 =?us-ascii?Q?2UPvqXR6uEhvELfC38z1LFA+HqTT0iRRi0SFP3cxavd4ckIFXR4lHfypVZh+?=
 =?us-ascii?Q?IlKy1VXaMIxRDhaQTk4K7iDd8kc3dd+5jmnJX19fy+MzVymuP8MvwfsZKQxG?=
 =?us-ascii?Q?sTOG2HxSgXoNEn2M7fJqalk/NePljRW/+8gPwaRqv1XmBjHcgdtp3ljLHFxZ?=
 =?us-ascii?Q?XKbFCTAu9CbPYVMOEFCaiDb25X0Wbdr1N+WNtH2wRUDdN3DXQLphCVUXxrm4?=
 =?us-ascii?Q?eq77N1mJGTb1Diw3r8RaincXsZf0RFeygtz00KU61B0a84hLJEM/ksBt/2sP?=
 =?us-ascii?Q?Zvh9cGwCoujYtOlRG54P29ZVREe1hRjnjHTH3KJ6OUnlBWeIu8oIMbds/xEf?=
 =?us-ascii?Q?NmCOd6bNEs7tp6/smSxgpl9p3fAU0yw/Qcf9+d4UaSkvjQacvIu3Rvcp0QKx?=
 =?us-ascii?Q?SbTIGA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313032fa-3035-4a77-b982-08db23c7e984
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 13:36:12.9122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpMlw6+BWrBXBsR7WAZFHn9cjZOSaMIOkFp26WhHpkXj5WHlv8mxFIFB56FsPcXHwO9B3CIvrNIb92IVbhHrhF2sTeYqPOnr3tJWW+TBSEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6042
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 07:34:45PM +0100, Heiner Kallweit wrote:
> If genphy_read_status fails then further access to the PHY may result
> in unpredictable behavior. To prevent this bail out immediately if
> genphy_read_status fails.
> 
> Fixes: 4223dbffed9f ("net: phy: smsc: Re-enable EDPD mode for LAN87xx")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/phy/smsc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 9cfaccce1..721871184 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -189,8 +189,11 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
>  static int lan87xx_read_status(struct phy_device *phydev)
>  {
>  	struct smsc_phy_priv *priv = phydev->priv;
> +	int err;
>  
> -	int err = genphy_read_status(phydev);
> +	err = genphy_read_status(phydev);
> +	if (err)
> +		return err;
>  
>  	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
>  		/* Disable EDPD to wake up PHY */
> -- 
> 2.39.2
