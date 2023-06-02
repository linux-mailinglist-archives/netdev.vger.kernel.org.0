Return-Path: <netdev+bounces-7477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2468172069D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99B0F281957
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8DF01C741;
	Fri,  2 Jun 2023 15:54:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E7E1B8FE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:54:52 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2104.outbound.protection.outlook.com [40.107.220.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293CB197;
	Fri,  2 Jun 2023 08:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVk2qzI4jV9b+M3kXy3sK1ECPIlqm7PT7+Fk4Iae9Y/iyhyKlKIMlYLZG2wvGFiuoW7Hm+Hcdj0jQEfuPlqhehyQyRzm/jex5oYdhl35tq/UGMI/JEDRL4H4d3cijNRLtbIu83TyJAR6J/FvJgPkWyXbu7W3gHkHTNP4PAa+q0UAi57DCvvzaQeIMYjJp9PyLhahztan86OncERRrkdmGPqgTt9j1PuhpU54J2D2Ftq3T3KueR3EchzXnyC6pCiGe1Jahd3RDHWSjj90Yvsc24BoWvkCSkDH4vv/QyMtqfc+dwL9H5zlJnKhCSlEJIdWM3mry5GG1AvGcAanSQ2a+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQWT5j6agbxv/nLRvMNWHb+NADvCANDxTx3NySUGsf4=;
 b=mkpCYTKNKe7a5urmaN9m6aDA/OAgPZ1d5fMsO57S+OBZMKyAL4s1FGvCEniQhJedJ2zPypfFxxJo7FQVafAovgwCenlD56KS8qnyUW+Py8nhuLbn/QGNMFgsrRDoQ/hO/IdxhESjsdVXKVfaICdY0i7DRlfm+2CygqULYN3GXVz+6vXEOXpnJA9Umk0RldJBx0kXAbWziKZ1AMec4c+hYcQscO4oqLnjtBRn3ormCBPVdfaRzFjm1E8q3L57+/0p8JDnL60Ewulwnbf2/P3jyVgA3U3VhsD0a0TBpOwqq4SqKwHKhCT2X4Rxa4sfXMUuPTOW8etCaIetMSp9HOjztA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQWT5j6agbxv/nLRvMNWHb+NADvCANDxTx3NySUGsf4=;
 b=Codth0+ZUKYDYhG53y1Fy+yYPgjeiqQgA1GXaYntHg0JNnIs1FtreN6Vu5zUKCDlBSnBvE/HWo6PKA+Gw55IYKWRD3lAPElTB+gD90bNvc/h3eoLmmO+/t2KJ4MRWyHErwG1qAzCWhanvhfpYWNWt4Uzv0FbiWAPnSG/atalcVY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5291.namprd13.prod.outlook.com (2603:10b6:303:146::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 15:54:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 15:54:47 +0000
Date: Fri, 2 Jun 2023 17:54:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	linux-wpan@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	David Girault <david.girault@qorvo.com>,
	Romuald Despres <romuald.despres@qorvo.com>,
	Frederic Blain <frederic.blain@qorvo.com>,
	Nicolas Schodet <nico@ni.fr.eu.org>,
	Guilhem Imberton <guilhem.imberton@qorvo.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 04/11] mac802154: Handle associating
Message-ID: <ZHoQwKiiAhfu74/U@corigine.com>
References: <20230601154817.754519-1-miquel.raynal@bootlin.com>
 <20230601154817.754519-5-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601154817.754519-5-miquel.raynal@bootlin.com>
X-ClientProxiedBy: AM9P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5291:EE_
X-MS-Office365-Filtering-Correlation-Id: 147ea2b8-232b-4ca0-af7f-08db6381b131
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nDyOSmtbJ9rN+bp7zdtteg0FctxrDkYKWpXFsAa7HK4wo9vC5ntwYRn8/UmdTyto9uXfvl2XDg3fabYEzHOIIpjMD0uxl3TP1GMuLwGx1rMIRBio4zVlowJnFwFhB/C0dQ9yMHEJBswRJb20zX8RdblZJKLEmGRNfqw1KNVmUJlDnCIC+7SJhkuoFxk/ysVDXcbpU8Pm+WqLWq588N9+znrMve5bZhDwx+opPLr3tMmpHgQux0vw6qid4OVVV6cA5Z78+llLovE2dM4jC5afSQfJ5cLZKndef5lBNywoLwsYGdR4nGe7FQoTPPCqE5V7M4hsIgHjZQz+j5ZcRmlUPseDLFS8bSyasqcQZvAmGOLafXZItijE53WDIhi45jKZM0H23h5P8afd9UIIVNlfoAOAKEjgVPaTpyP7b7z5H3WKETvEi2nuFkdSFP5SjO9Wwnj+dtH8nd/ZHsEfP+mJbb98JmWrq31Cu7mVAagilN7xj1+gGGTrMK/og9Kq5yhoAvE96k8bRuHZJ9MNWCE7Q5vI2Oe1IZNRyVIXv6n0ph70ymymPRP4T2CCaIN9Z9Dh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(346002)(396003)(39830400003)(451199021)(36756003)(2616005)(83380400001)(2906002)(86362001)(38100700002)(6486002)(41300700001)(316002)(6666004)(5660300002)(8676002)(8936002)(478600001)(54906003)(66556008)(4326008)(66946007)(6506007)(6512007)(66476007)(26005)(6916009)(186003)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dd8ir9jVnW0CbSaX3VOPsGpEmS3stoPqA5UnVzCLITu1ahM2p2evbchrmsQu?=
 =?us-ascii?Q?nuUOQ+s59e+xEfD0m3HpD8mzp9qz9Cr2HINoPLWP4C3gPU1v3cw/5NEBMiJz?=
 =?us-ascii?Q?6wQ1SDBe9tU4nqKtcv100OYg0gIk/JqSFKnCzuIBOCsxBH0xV82t8f2EHwDO?=
 =?us-ascii?Q?uSUtOijBxv7M2qNYoppjJrqiX34IkfWsuhbHSx3wX1YZ8lz7yVkdEbXP8uZ3?=
 =?us-ascii?Q?YnMCqjRcqvYj9YpwZCWzqqUpSrqIhA8F3cxObBMGqKfv/2BW+1uae79Fuk3c?=
 =?us-ascii?Q?uG3Dyx9jSVxx1mqtxyGfvCzCgJb/iml+fjtC/2d11WDyMpvVhzAXuq93Lzzz?=
 =?us-ascii?Q?X+XisuuwVlF357WqTxz6sHjlqUcw78MkCHZmkOo+7cnRpygAgCSw7QWtuGGH?=
 =?us-ascii?Q?CGNStpJKsVQS17T66ba5qPr9KO1JmrTi4GRMeQ5eiILylhEjiyppAnaQyQGs?=
 =?us-ascii?Q?aIjtOljhHHKZBp5blvBIN2WeyXymCeCmkJU8tmoVSm3sB++R0Uucrk6xIEqa?=
 =?us-ascii?Q?mbeUGGg1YVE0oOYpomGfAdMTUki9Nka3MZzCj7+nGEAqFuVtkjkUPKrN+nOF?=
 =?us-ascii?Q?gSIalVkdXtNNxAGJS7/xD25poGeSmI3+EDhbLbjpshWhDltZPsrr0AGvppbG?=
 =?us-ascii?Q?u3u4sOCJK+h8+bQG5KgOdYvyrS3KNUPlxCLd8NMZhmNnXm899NIY7ZU+1W1R?=
 =?us-ascii?Q?UM86LY75zqnnK13QOc+l95i/s/c0FXbMhjWddmZ7kFXWji1/4a+zJ9YVu754?=
 =?us-ascii?Q?O5u7POKFGpEj57EKCRRHIYRM1WTkeCU2f6Dbx7dlwAvPl+d/XzR5cH7PohuT?=
 =?us-ascii?Q?fE/nzh8yfG23K5/MZdmsxjn9Ry8uu1Fer4BdyghCqa4J7pXf+ZelCBX3vdWc?=
 =?us-ascii?Q?qbQXZbYWbc+LEGnec2GrlZng3H7kJy3w/uYuWfNNulsSGhVlMa1x6l8/KMNx?=
 =?us-ascii?Q?NK9lk6tHcmY/hofbzZwgekN1wMrFXY3ZU6fmL6P0rCwb2dnWOcxl90bzi3sf?=
 =?us-ascii?Q?HREnLkTm4pwwsaa09K9p0hmL5rMR41MZqlUR7viukkaWp3kO4PZnkYa+2QYQ?=
 =?us-ascii?Q?4/tfg4TjeAHkmTgGTrnBZGddZC1ALjJIyK4++DtccgWRmTb1Lo1up5Hr10Z4?=
 =?us-ascii?Q?zMHOs7QpOqFCGi6VKZcdqpa5JKouSjJ6Z89J/1nU0sAS532u28Ai9wdx0Rz8?=
 =?us-ascii?Q?gNE3eEQ9HUbg+QoR6jfdzlvKB1+7FwWyMwOI4iaUS3dsDyLohvsoMqEK3yZI?=
 =?us-ascii?Q?zEZOsnG+oNCArZT4Tz5DFX+jbre4wZ4kYSP0BB0pHto9X469c8Sw0bFs2g4f?=
 =?us-ascii?Q?vxfU6kLWxMLMK0YHiGof+5s+MPKa+AGndJpnA4pAkJEjwoe/EBZKKQd07Jjf?=
 =?us-ascii?Q?vRje15raUAsR+oUC1GoOhS5wVh4UY5DK2TbsjpRY4N0DJyY21YP7SD0iv38K?=
 =?us-ascii?Q?tAzr/NRTQgSiVbUdBqGFx+qQsmmHT2qon+6mK17PjlezNvPaWIRVoX8eBglK?=
 =?us-ascii?Q?PfuEi//h/fOxzZzTNrlQnvsmSzRaSy1zPLtQEovIAj9G1ZGFarOOIhZkJizQ?=
 =?us-ascii?Q?Ao0CMYyP74Op+8woeDbb0r7wFvzFDv2uJj9/Pa1jq21uhY5gA/6gxw20CbEu?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147ea2b8-232b-4ca0-af7f-08db6381b131
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 15:54:47.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoGQgMn4iOFsT+QHmkX0YCaCpvyq7bVhmSn4kebXpMmPNchVcb0JoE9qOKPnNxH5DefPh5Rn72MnMR4+vrx74aeWV67JOzOu834ggdtAp1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5291
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 05:48:10PM +0200, Miquel Raynal wrote:
> Joining a PAN officially goes by associating with a coordinator. This
> coordinator may have been discovered thanks to the beacons it sent in
> the past. Add support to the MAC layer for these associations, which
> require:
> - Sending an association request
> - Receiving an association response
> 
> The association response contains the association status, eventually a
> reason if the association was unsuccessful, and finally a short address
> that we should use for intra-PAN communication from now on, if we
> required one (which is the default, and not yet configurable).
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

...

> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index cd69bdbfd59f..8bf01bb7e858 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -198,6 +198,18 @@ void wpan_phy_free(struct wpan_phy *phy)
>  }
>  EXPORT_SYMBOL(wpan_phy_free);
>  
> +static void cfg802154_free_peer_structures(struct wpan_dev *wpan_dev)
> +{
> +	mutex_lock(&wpan_dev->association_lock);
> +
> +	if (wpan_dev->parent)
> +		kfree(wpan_dev->parent);

Hi Miquel,

a minor nit from my side: There no need to check for NULL before calling
kfree, because kfree will do nothing with a NULL argument.

> +
> +	wpan_dev->association_generation++;
> +
> +	mutex_unlock(&wpan_dev->association_lock);
> +}
> +
>  int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
>  			   struct net *net)
>  {

...

