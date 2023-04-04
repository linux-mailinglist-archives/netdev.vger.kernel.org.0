Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D686D5C06
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjDDJeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbjDDJeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:34:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2094.outbound.protection.outlook.com [40.107.96.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46263E6E
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:34:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXDkeT7YDPO/S9YYRzVNy8Fs6dd8TSsKP8Y0oZws2R59HyFE+vH89/BC3+29TSvSJDgt3O9gqifcChNDy8zRxegX1czj16X0Y5Pgw8dmsbekdSvLDRiJsusZagAGMc0+PadCx/oBld6ryZ7GHEsG2k9iAjfJ/oDo9JlEyr5nSzWDsHsOV+zKdBhIi0kU7mM8s3UgzguSgkgKCEt5WdqFZWbGksQazrEcF9DSFST7DcbwMnr39qwGXs7zQXzynoY5V/JV2SIZZ86sxQS++4mVZxuyYkewdeSdkPgIK75NJ7AY8Wiac3OqpjJfMKNUnd6CdJa+JdHnPO1IYSbdy/WBsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjunRI/nlkVoWtcy4I9FqJdeVjXXGuYzvRx9PD3YRjI=;
 b=QE10KXWQtFekU+WjFefSAhmY4CoTqZ+FAfefvMP6xN8KFauuU2S1JHnk6VkVtyO+CIzgYzG2TDmcbjjEDWwFkKmxtWWI1KNwfUJj61pJqsJ9J7hWM2gIbXeC1hhAQKd6qNUnF0qfUqGXFuuPSgPi0Q7fgFOvkrtk2vFPTnmiFW20UeshiSk8Wkp78JmZEN5eZBoZ+dYKi/MRrL6kagpy3dekqmeOpAAoRgsmRJb0TUGRmxUUnEnR1T+UYzrar0CoY8YXw6j6zrDwzMGPp1+7hS7LEsoNWxn+OTBKJRoSN2kAXNy5wJ0h5JtRpqFe8QsH5vJy9lqUyVUfCw2YifUfMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjunRI/nlkVoWtcy4I9FqJdeVjXXGuYzvRx9PD3YRjI=;
 b=LPq72/8DdAR7176RZHd2MUVfyOSSIbAertw7Tr8cXog/4Kmzdy6hMkRiDVyw0jwU5Uia9Q2Miw4nzL97AuwW+G5PNCCCU1pu1WPhJEMpaZVj+BYgbKbmPzWN2xQNibjWTSA8bUQi1D/yo7kLSARNEO7mbj46GCUEhbExqmBnByg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5360.namprd13.prod.outlook.com (2603:10b6:806:20d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 09:34:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 09:34:20 +0000
Date:   Tue, 4 Apr 2023 11:34:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v5 1/2] net: stmmac: add support for platform
 specific reset
Message-ID: <ZCvvE8l4dnMOEGQ2@corigine.com>
References: <20230403152408.238530-1-shenwei.wang@nxp.com>
 <ZCst4PvQ+dlZEbgl@corigine.com>
 <AS8PR04MB91769E3A7396555DCAB43CC089929@AS8PR04MB9176.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8PR04MB91769E3A7396555DCAB43CC089929@AS8PR04MB9176.eurprd04.prod.outlook.com>
X-ClientProxiedBy: AM0PR03CA0084.eurprd03.prod.outlook.com
 (2603:10a6:208:69::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5360:EE_
X-MS-Office365-Filtering-Correlation-Id: 021781af-97b3-40c4-8d69-08db34efc491
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ntesk0xvKdGsDNPq92EEw5UPKKRQfvUje4nEaOCsmqgQkV/c3e1o0eIfmZS4TfvzC/z+mINVMLDP/XTBpkCGEKl/ksv5EAUff7TnG9jnJ/qsPNMZVzDuhho9Q5XLAnDD61obJpJ2cs0VQKRX0EMeW59A1OqfHn4aVdZQhB2b9BiwDUXdQo+W7Wlev7f8T3dQzqF6OHiTlVsslg0RBctEVQZbgRmd8Hyq18KltQz9Hxsp1Cjg9Lxh1uE99flhRmDbF273hhtV74kjKpR9NYsCTjP3xInJek9Vd+4bCPRPqoIQZ834KaauwZFSj947fbv8isKEFfovm0x23CP2o2NTuUFmPHZ3aOiztt22g8UwxSwnkN0/i36itpQIzI4IAgBNdK0xV8XzppzxftTtbPvzhQrqk3vyDXyVtel1EgbiydWy95y6tCYrClo1NWejK+ajSNauuMPOd5KVxfKjY3sn5WRZJqC8sfvcu1FGhsjOFOq/XOGxSwSfg2tQurP3JJVkiOMluakDnmiibNf1Z0R7Es54HfAfs6jAR1QDLrY1jQCtRKsNqsha5cvXn54kSwmxxQnGLb2J707PBGTzDyBlUbYaGGzZR1Lonms2uBVqGnw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(346002)(136003)(396003)(376002)(451199021)(86362001)(2906002)(36756003)(6486002)(2616005)(83380400001)(186003)(53546011)(6506007)(6512007)(6666004)(6916009)(66556008)(8676002)(66476007)(66946007)(4326008)(316002)(5660300002)(7416002)(44832011)(41300700001)(38100700002)(478600001)(54906003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B4NGYII+duEmV4J7i1njzRACqtaSgIVFWwRKQxQXJ152wj91av8Pabh+Cozw?=
 =?us-ascii?Q?ELhtjSet3IO/vtFV0WxmzbezN08SYZrajd5r96oRKajviFuReEP2K09+OTd+?=
 =?us-ascii?Q?6m4JKJ7I0WL/bSJfQ2OAXUGLDtfG55npkAImobfBsZo7xQMJ4NYiBuS2nVOF?=
 =?us-ascii?Q?GfZknBqfByiKBXWhrR8e6SUBO3zgCxeBqpjYBLRz8Hg49/MbGD5Q8xL0/o4I?=
 =?us-ascii?Q?Fe0XiiA7NTn2H9H4tJXP7GpYHfKlZx0mZMYbMryY+kbVVAHx89AbGCaeQRS2?=
 =?us-ascii?Q?/nMdpmAVc9Phr03xpEiUfey2uTlz2kpyctJ/RVEvbpFeRVgxVS8F0Ch2hZjc?=
 =?us-ascii?Q?/G6yQ5lWHocuQops2JG22Kdcf9ONnpGqhK+AvSam5nH2gcDA0rxmEuNdeH9n?=
 =?us-ascii?Q?zlqACqdcJPV09e80bzz9yel1Ve4rYeZ+B3QuUihVS/mSUpjDsFPANKBdZPNG?=
 =?us-ascii?Q?4Q8Z8zW6wBJNSptJoL1hGC+sEOopdN1K/SRGi/x2QolAcFuX6tE+lguXJjSk?=
 =?us-ascii?Q?0/NLSsCajZ/7WbZ2Y0Dh0lOWv/fyikEkG3hJxMyLprcFJiDWBZscJMD0A5iX?=
 =?us-ascii?Q?05P4r4HKVzKvBzMhtkjkX/Nsx+gfyo5HCD2M9n/0vp8Vbik+pUK70SX+Ngtq?=
 =?us-ascii?Q?WdWobnClEnQXLgj+CUNIsHt/qluSdVT/7i4lrfh6dwkx2NZUGqoKq/MLRHL7?=
 =?us-ascii?Q?MLpNzWR4kXgkK9sy4aDWXMxXSWD9RQ+wSfdzKNdbaC0Ms2gngZTDlclzjDq8?=
 =?us-ascii?Q?ZyPDPbTTwMBE5O2cPmHdDJZnhhPQ47u7r8oUuX7rQU3yljYluTkeK87dQz0x?=
 =?us-ascii?Q?UsAJNHTHTsaZrzm3F7UnxIkSjPgh59g41WsfUeyP95FO62mjMK5TILYFhdoS?=
 =?us-ascii?Q?T/yRKRyYHj6NaqHxQ/WeAouFaXaCb8o0F8VTzwa18pQz05lBHDbTfhh06WQp?=
 =?us-ascii?Q?g33x6ICsE+YLWnbtLdmHjVYh9JTY+YNErQkdQ1JBqIxTSp//NxZQx8kRo9dL?=
 =?us-ascii?Q?2PHjXtWcAdCDaV+g36RfEjY87jCudizKmIMPu3YtytK9m+g7T3MGA88Zg6n2?=
 =?us-ascii?Q?CXUzH/UZtgwvsgVRNwETXXkHtm8LqvzUzyR/nLTPUZTrXe/o8Sr9W94qb4aq?=
 =?us-ascii?Q?OGghT4r+wViGa5L9JR2Zq59vc8sA8P7WcZSAvR4qIV97Vi04wLbUHlciZg1v?=
 =?us-ascii?Q?zipyro3YYd3CB63VhsFtBkcdJPRzZPR4P0/0ObamupBqv66K0fZ46tWEOqQe?=
 =?us-ascii?Q?EDflXvvR62rbA9kxSA0dQC4Cw1eyOlmEL9Q2yaxWcInBNt4y2aKZR5jd83mE?=
 =?us-ascii?Q?xD/43qY54chy9QyYQvE365NAQN5qO2QfBg4lLVp8vwO029TjkYUVcNmMMWG0?=
 =?us-ascii?Q?Tynst03OXFCJgNg+lUq16EwwqSRIf1etBED7UTv4uqjDnsTZzW3wrPckvEGV?=
 =?us-ascii?Q?sSrCuYyJb/AJaWfH9ewQ0qAYFszKCnC69btR8Mr1kSNanNKxD6npxBMjtjFp?=
 =?us-ascii?Q?gj6BkJBi188huJ5TP8X4B1qqsDnW7zWJfY6oMda7NhjfnNd6vN1r6eKNHFkj?=
 =?us-ascii?Q?nC3Pv2b1eSgwsT00ifBgkksdIS7/6fW+7o64RP427z2+c2vKSEQ9nX1h+AXv?=
 =?us-ascii?Q?0GaLfLhVXiwa1IdpslRG3ilh5a8VHzgLnNfWsl1f7gALqNv1bNbcgxJ5EqWr?=
 =?us-ascii?Q?gyk0Lg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 021781af-97b3-40c4-8d69-08db34efc491
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 09:34:20.4755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKote1SAfWPdAKHO+wznxyaMazMvSZ+jGWKU2C3+70W/+y177bCFXIM5AodCpo8t0TckFu7iV89GXJpMkgwwGjAaR4Y3Q3idtFD9lVeUpS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5360
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 10:16:46PM +0000, Shenwei Wang wrote:
> 
> 
> > -----Original Message-----
> > From: Simon Horman <simon.horman@corigine.com>
> > Sent: Monday, April 3, 2023 2:50 PM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; Shawn Guo <shawnguo@kernel.org>; Sascha Hauer
> > <s.hauer@pengutronix.de>; Pengutronix Kernel Team <kernel@pengutronix.de>;
> > Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> > <alexandre.torgue@foss.st.com>; Jose Abreu <joabreu@synopsys.com>; Fabio
> > Estevam <festevam@gmail.com>; dl-linux-imx <linux-imx@nxp.com>; Maxime
> > Coquelin <mcoquelin.stm32@gmail.com>; Wong Vee Khee
> > <veekhee@apple.com>; Kurt Kanzenbach <kurt@linutronix.de>; Mohammad
> > Athari Bin Ismail <mohammad.athari.ismail@intel.com>; Andrey Konovalov
> > <andrey.konovalov@linaro.org>; Jochen Henneberg <jh@henneberg-
> > systemdesign.com>; Tan Tee Min <tee.min.tan@linux.intel.com>;
> > netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-stm32@st-
> > md-mailman.stormreply.com; imx@lists.linux.dev
> > Subject: [EXT] Re: [PATCH v5 1/2] net: stmmac: add support for platform specific
> > reset
> > 
> > Caution: EXT Email
> > 
> > On Mon, Apr 03, 2023 at 10:24:07AM -0500, Shenwei Wang wrote:
> > > This patch adds support for platform-specific reset logic in the
> > > stmmac driver. Some SoCs require a different reset mechanism than the
> > > standard dwmac IP reset. To support these platforms, a new function
> > > pointer 'fix_soc_reset' is added to the plat_stmmacenet_data structure.
> > > The stmmac_reset in hwif.h is modified to call the 'fix_soc_reset'
> > > function if it exists. This enables the driver to use the
> > > platform-specific reset logic when necessary.
> > >
> > > Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> > > ---
> > >  v5:
> > >   - add the missing __iomem tag in the stmmac_reset definition.
> > >
> > >  drivers/net/ethernet/stmicro/stmmac/hwif.c | 10 ++++++++++
> > > drivers/net/ethernet/stmicro/stmmac/hwif.h |  3 +--
> > >  include/linux/stmmac.h                     |  1 +
> > >  3 files changed, 12 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > > b/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > > index bb7114f970f8..0eefa697ffe8 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
> > > @@ -87,6 +87,16 @@ static int stmmac_dwxlgmac_quirks(struct stmmac_priv
> > *priv)
> > >       return 0;
> > >  }
> > >
> > > +int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr) {
> > > +     struct plat_stmmacenet_data *plat = priv ? priv->plat : NULL;
> > 
> > Here the case where priv is NULL is handled.
> > 
> > > +
> > > +     if (plat && plat->fix_soc_reset)
> > > +             return plat->fix_soc_reset(plat, ioaddr);
> > > +
> > > +     return stmmac_do_callback(priv, dma, reset, ioaddr);
> > 
> > But this will dereference priv unconditionally.
> > 
> 
> The original macro implementation assumes that the priv pointer will not be NULL. However, adding 
> an extra condition check for priv in the stmmac_reset() function can ensure that the code is more 
> robust and secure.

But it seems to me that it is not safe because stmmac_do_callback
will dereference priv even if it is NULL.

So I think either the NULL case should be handled in a safe way.
Or there is no point in checking for it at all.
