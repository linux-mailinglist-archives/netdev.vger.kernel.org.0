Return-Path: <netdev+bounces-10438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8246572E7AE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31EE0281143
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EC13C08B;
	Tue, 13 Jun 2023 15:55:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517923DB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:55:26 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2134.outbound.protection.outlook.com [40.107.92.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D910A1AC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:55:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAEugSzMaeeJ2TDI+dmUSjtE5krZDyAI+4d+3Q1rDzFTiGuMg6qSs9Kv73biYnRYtiW3wDI++2VWgu96XNK9gF/aRu+mup44SROBos219EA/6FJOQTXf+k/ID0zWYR6MXFTjmtrBLcdUOSV9v5H24f+RcKWU/a1Itd1EccRbaIS1dATd7Cgo5BJvLCXzSce8lZ2eL7D5nFzwoePKLUO2HsJHwp1kJUeEaZgVf1cR2JQyAG5uJij8Z96bbKJ+kTqH9oWVnbNIrbQj9NhG7ep4s8rCMlQgqrGwRio8g16OrVIpfhaag1+n9cheQ9/wH9I76vFM/VwNm7dGpFq8Ibvt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UheDH3LLOZ6gGxwqjSlD6eLFwS0fYAJEx/LE/SBMln0=;
 b=fEQYfisiVVWjQdB6uSMLOc+vX+YSXh1qsIIABFLf94GtUeEPPaO3qhRHKJeGNqwQIFvLKBegKEfzG0VwbnAs+BNs1mq4ukK72oYAVveEI88sOj5oMbeudomNlF8kwk0B1QwQxAY2skRNfGLh7Pf0armv2SKFAA6dc9Ud1IHSjXA3GuYga6ghIDiUFVAQ2djw5AwjFUfNBUm1RLlc6uCZtAQBcOT0nAZ9S3d7Bzse0dXgj1A3euvZSTKKj7tbh0PvOTlHsHCwVv8g85sWG4Qtr2LA7yZPtUMGKFcBJIpTP8uqH4cORFa7OxN0oBXf9hYPmzeXyMaVYAqCQZViqBlACg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UheDH3LLOZ6gGxwqjSlD6eLFwS0fYAJEx/LE/SBMln0=;
 b=IZ6JNhCMP63OqVFiqpNCjQmgfAFWPlgQ804jLgNra/vABPKBMy/trg+BxYj5gIMQUDsrvTB6zrUN/V3Dl9NlmXE6DcUfyUkDSeQlM03xv9o1oDem2fGbUZ59MmgyRC4nPxHVIMt8N8jI3Rmdi4pv0ZfiOwWBYUyCQWe3LRbURtk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB3981.namprd13.prod.outlook.com (2603:10b6:806:95::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 15:55:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 15:55:21 +0000
Date: Tue, 13 Jun 2023 17:55:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org: 
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 01/15] net: phylink: add PCS negotiation mode
Message-ID: <ZIiRX5+sdYUkBVxu@corigine.com>
References: <ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk>
 <E1q959I-00EBvY-Oq@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q959I-00EBvY-Oq@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM4PR0202CA0018.eurprd02.prod.outlook.com
 (2603:10a6:200:89::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB3981:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b3f97d3-097e-45b1-1124-08db6c2697e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SS9GkaifeLPhG7OgzenRxDTU08vLhZHP6pi1r1ypiPuJsFe5f8B4sQQSVpIkz76KOlc+DGTFiEm1hiSbnDO4/NiTSSYpXjNXJsZtUm3+w8wqayL7Ppm2McHnJD9aTXOV5UZkblElcUQLostAVDR8n3GwafVbm3la1HWK/kdiEcX4T6dXP4mj7yjvmLckf/fLfHs5VmM7Qn8TV0YMwfn27nQWO+WabYtDHFf6pRShDQvIkjlYd4UMJWSZt20tzqLtviwjV4+qv0NauBV2Z2Eh+PuhTF421ISkXm3tQJ+3Ovf/T43Gu2Wp94sKDW9c40VMwXCNRTEcYCh9+k/eHpLhpx1FHGvKMDoRJ8qRcb5nHX9AjknyzagUSXgG1YvasSQbAPeBWVeXGEkNzNmGgae/2qtV93QXMZUcjRRx2bksUU7oPqKytPYZv5b7hx3z68gpNqPMc2XL9dyL0cHPr3K/tStxAeGjBolObwjrnRkqQ+dk/Sph/43+Fgq2GcXZDXFFlrmCJSXEUTrQrMOvCfGRK0M/QiIuyxpQXNSIk2aagMXOpTp6qymCo4+jmjFTPV8ALh89BsyZZsbkdgh18+MNgpnXVIwfjq2XTGXXTa3ZyGFN2r/MYOKAjyiatQcDb/tCm2YxAz38rY7bhvkmYUoxHQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(396003)(346002)(39840400004)(451199021)(6486002)(6666004)(36756003)(2616005)(83380400001)(38100700002)(86362001)(6506007)(6512007)(186003)(2906002)(54906003)(316002)(7406005)(7416002)(44832011)(4326008)(41300700001)(66476007)(5660300002)(478600001)(66556008)(8936002)(8676002)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BzsL5/HI8cSbD5KLwKU5IgAi6e5Mg+uyngvpwd6U5bks5LgXMDlp9CvX/imd?=
 =?us-ascii?Q?NXrXl2Hy0TwhuS+YtvtzOSIP9TCNp3zJqEoGUYmeq1PbhUfy1GbC4dmUrSkd?=
 =?us-ascii?Q?t4Nsn2OBHLGTTMsw1bGMRBARtvD5sFqSi3jiohrilfKzWCqy+q2qE+sxTy4Y?=
 =?us-ascii?Q?+Jy7dCrbgLyaj/W2S7w5vtgzc7jXE1TkFcLNrFKt2rmyBr9aqNLXGQQ2EHlR?=
 =?us-ascii?Q?JseZ+loazUVU1DwE3UQczWxjiStss1LbKfLHao2KCRBwm9q+0/MxLCRsWMNU?=
 =?us-ascii?Q?Ptsiy+o2C0QW1wEQXB1wjfWTQ5rVmckYkRHJmOyzD8W5FrMP07KRL7RRb8dK?=
 =?us-ascii?Q?BOQNHuF4yiKJOhIgGZdIYfVsRymjkV8yl3E4NsbimZTMh9ldkJSrR6CBK4Z+?=
 =?us-ascii?Q?GeTvKGJsuGyOakb2LApemZ3A5k6McvKW1GA0mPUb1EbZTAZ4huXWCVlNo6tx?=
 =?us-ascii?Q?oYKO5Y8ZCvvt0oXQWJFogLDW7q5xf4g3LNTZg4nKGzoauim16+wKXlifYFk2?=
 =?us-ascii?Q?pz6dnSgF1SaVUyoEu0htYD/p/bEbPpxQGLg/7lPBEv1A9FZ7n/5HBSHWSHaE?=
 =?us-ascii?Q?1bIoaMyQdHD9cFVNvbeqt6NHAUqjT+XgJcCQRAOVDrB2o/M8NyJygevUW4zI?=
 =?us-ascii?Q?j0q4ADSHcEMqRWU0KC0Aohldb00POmGJYOvXs/Emd6m92423BkJ38SUiC07D?=
 =?us-ascii?Q?weJIUzu4fNAyAp6Y/nPwjsDVv6MsOaJTD/IyCpai2NLxxDTPDSHSzl6zM5Ac?=
 =?us-ascii?Q?QTkyX+Xoi+muWXBow6dv0dsFMIa/p5e208XBwROIGmEHTMPFLZIDnKUemDZu?=
 =?us-ascii?Q?9NSxwDPhsVVGyAKUXypV5/cgO4BJu8SR6CL9+syOuC4vGwIpcYYVaP088k19?=
 =?us-ascii?Q?923bbimlPD6fXe7RwTpqvP/LAo94CzWKrwYx/xB+NsvTOK6gNDttDv/eQCkh?=
 =?us-ascii?Q?nSFTu5RCVnTN/Q4SrwoUqgA0qTw4BWuK3xv2YQXqJt3gbvNcCQxssDhP/eHO?=
 =?us-ascii?Q?UbEdPHFTA+Xbk+HKZD4Ik+k1LdT/WcARfJCnV3iB2kj2ToP6laxs7exBMD7H?=
 =?us-ascii?Q?CNfJyd1jLHnkOettuaQLhvgJqCF5exurHSILMYhRj/0SfIDKcwiXYcaNXWm6?=
 =?us-ascii?Q?+28QXRL0jUXQePaNO3d7XQDgFu+UQBIblWcbmhXMjahMaumGpns7S0XGHu8q?=
 =?us-ascii?Q?pf3+Klw7lLQ7Hua4aDFjRogebiiuw0L7gly41wVmL0qecAmiP4aHUdIZyHxo?=
 =?us-ascii?Q?+keifdrXm2BMH78rkM4g80Ug7qztfpdrg/50ZMFj1lTlhiA0/48Dzrxq2f4w?=
 =?us-ascii?Q?qvtWn85U/P6IWuriOZoddOMD2YLhi5pDR4mEmOReGbnRPwyAD+yANTdOo1Tg?=
 =?us-ascii?Q?IhbmSzd6lja33vD7/oXTTwP7brwMB5bMeMTp6iMtEkoyQY3yKzyiddLjvPhk?=
 =?us-ascii?Q?d2aPNlZtJLQmVEE4lk7BbyndArFs5ShtVgorI6koDaGdMpILVa70Iv8UqdEI?=
 =?us-ascii?Q?aRCqj+j6B8vI7YTnYGIZZXsQyyGFg9u1SD+1z1lM9fap/NsEQAmWmL6Ynjtc?=
 =?us-ascii?Q?XvaSdpUJE6qNVnKw1a2XGyJNWO97nBsivtiS21hSfoNeWWYuDH02NDXbP7Oh?=
 =?us-ascii?Q?DL8yCinHkQWQdFxei0MymV+t1pmlfgnaTjgTjE3MfCmlN6z7bBTIXVeAlReN?=
 =?us-ascii?Q?dCMqoQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3f97d3-097e-45b1-1124-08db6c2697e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:55:21.8230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pziuJtuAhq3d7mhHKLF2pdz3j9egzFL7e11jl3QuCR5pl97fNb4JW4Zci9xEPZo92N9WpIn641CuckhAocv/KAhjDwN4s8oUt00VA8cNsPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB3981
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 03:37:32PM +0100, Russell King (Oracle) wrote:

...

> @@ -1149,12 +1159,20 @@ static int phylink_change_inband_advert(struct phylink *pl)

Hi Russell,

A bit further above in this function is the following condition:

        if (!pl->pcs && pl->config->legacy_pre_march2020) {
		...
		return 0;
	}

So it is anticipated that pl->pcs may be NULL,
but the function will continue unless
pl->config->legacy_pre_march2020 is true.


>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, pl->link_config.advertising,
>  		    pl->link_config.pause);
>  
> +	/* Recompute the PCS neg mode */
> +	pl->pcs_neg_mode = phylink_pcs_neg_mode(pl->cur_link_an_mode,
> +					pl->link_config.interface,
> +					pl->link_config.advertising);

	nit: this indentation is incorrect.

> +
> +	neg_mode = pl->cur_link_an_mode;
> +	if (pl->pcs->neg_mode)

But Smatch flags that here pl->pcs is dereferenced unconditionally.

> +		neg_mode = pl->pcs_neg_mode;
> +
>  	/* Modern PCS-based method; update the advert at the PCS, and
>  	 * restart negotiation if the pcs_config() helper indicates that
>  	 * the programmed advertisement has changed.
>  	 */
> -	ret = phylink_pcs_config(pl->pcs, pl->cur_link_an_mode,
> -				 &pl->link_config,
> +	ret = phylink_pcs_config(pl->pcs, neg_mode, &pl->link_config,
>  				 !!(pl->link_config.pause & MLO_PAUSE_AN));
>  	if (ret < 0)
>  		return ret;

