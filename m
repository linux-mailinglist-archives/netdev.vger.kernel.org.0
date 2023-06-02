Return-Path: <netdev+bounces-7474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7458872067E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30544281A03
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E211B916;
	Fri,  2 Jun 2023 15:47:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E2D1B8FE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:47:28 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A3E18C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1nCyGip9u0vs2Ce9tFWjJVbcL3sty3XQjA0CGaesAG9p6s9qCrzEMPNnlisA3XLGCn8s5NqlzzAixObe1tmUcZKk0kYSjKuL0PIFOhi+oxDPZGIRh1StRgDQOx4Lj11FUWozp9ACuZrXU+uj8yEA6UHsTtGRN+a13zSLUJCuNiLV6oTAy5n1cpQjJIl3BRuSvy/fnnmsDFuPVlVpRSBXTiLSv3eBQjP8umjNWu+BxE7aXNFsXRVDK6n1ftGNICnsJ3pqW7E+DLShR0Qt8f8JQwaYRIM+eDmp8P8udfUC2SdB1LVSNXN4TbfF0b/OI9+jL76LCeGzmVCQvryQmOfWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmazHBK5cbqzH9MUmUNhk/cXyhfQFrQM5XMVdOyQv6A=;
 b=exguEWQraCSMQpyyUpOiP98bn0vJz5fS3Ziv4re273zxT1J79viQkWZn6eTvP+CSJb1i0YNClJWgVb7IizE7L7ngga1Vz43aJrmSvzKTzv+2Jghd8cmyFF/WDnUDT/n3xDT3Elsh/LCqI0uyZX+e/i8x1iCCRpXdcxm7WQj3vl7JiC9nLM+ASRk5pqszl7vU3TxL53A+qh6dbyMTthnm2scm5ncmvcXLJCgcWC0kav7U1KHsWssQtZ82jJ9+lq49juF+YqVyN0ozn7nlw9EUvvw2MHlFopsqctruVa2VV7SBMQ9/dgerCWkrhdpd1eJh5F9KykSuQ6UGJpJ1YVa2jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmazHBK5cbqzH9MUmUNhk/cXyhfQFrQM5XMVdOyQv6A=;
 b=pU2HIx1bAd3XaxHVeqKpFy50aIFQ2QJ9STQUHn1rQf/WpPPg57Sekh3XCIeh0y8Hg0CdkAQlakxx6qab9jMsjRSRiyAeUYde6HDhQEQngVvzx7ETjiTcUJ1i4psVTjwPS+RE5PQLfZdtq8ke5Op7aQOqp2Jwz9MYx+WhiJZR+OQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5581.namprd13.prod.outlook.com (2603:10b6:303:195::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Fri, 2 Jun
 2023 15:47:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 15:47:23 +0000
Date: Fri, 2 Jun 2023 17:47:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	sridhar.samudrala@intel.com
Subject: Re: [net-next/RFC PATCH v1 4/4] netdev-genl: Add support for
 exposing napi info from netdev
Message-ID: <ZHoPBYx2lZJ+i1LC@corigine.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
 <168564136118.7284.18138054610456895287.stgit@anambiarhost.jf.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168564136118.7284.18138054610456895287.stgit@anambiarhost.jf.intel.com>
X-ClientProxiedBy: AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5581:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b598082-053e-4e27-a779-08db6380a839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m9Hr17omEnhHVvzUMAFR6cqwqdEshBFjmnWh134PriU1Z1wEtA5FvK4GIPpclJAEf0Z5vLvar8Im7ul/tIYNsEyEHLSRTf5wt59E8f30/AVdv3vQJfEo1q1H/yhjaen3Nkhkrnjp0mhhfcSB7nkqij05bBXVJFT+UNSfyZmAs7H+h8JOHiLoxlT1oEKa55NbmsrzpG1cdAkBp7macViADi3BoyXyXIrOYYZ8ohn97D4wA05MpYTeJcZRunyNQ3j4RY7d/veu1YvUjMt1h2vtZYcIIva2gM0MPN8Zh8CDjmqWUy999QEF+iNewlu3hUHm3Mp/QJ6RA4G70wRSkMYQ6qxy8xJwYddIdRSCRsIULgHq5lWnIP+LjCophwPQC8QRrtAPCgbohOdC7LHvgAN5B14ohGEYVyJtpswxB/TqJWAZzx3ca0y7yLZ+2J6CZk1fnRUtT1eYOWGHfr/tAI4CDheVW/a8DSYCs7e8+c52+I2/cpHsQkctQWZUZ+jGJG93lIVf2PSiK45PP6iAJ2kOHdibr8idOXdnVsOb2n0lqmM7o/r+Gc0/9XNpPlq1Mwuv7Ysx4eb+pi32YNiYssiBOk04sX6XLoS50oA/VidvzDE/Pe00TNyb7HecMVVo1FMfnpPmHC+2hj0Z/qvn0ksrBPwQmGuH8+8cFqLrOJ4g6DU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(346002)(136003)(396003)(366004)(451199021)(6506007)(6512007)(26005)(6666004)(4326008)(6916009)(66556008)(66476007)(6486002)(66946007)(316002)(38100700002)(41300700001)(36756003)(86362001)(8936002)(8676002)(2906002)(4744005)(5660300002)(44832011)(186003)(478600001)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?drmB96ev1htDPGWxvGYWCGSeVGyInG8sxQzA0ay0au97hWRIFBln+41XbKCv?=
 =?us-ascii?Q?5joHZQTDBmqsIb8LLRFRIB1i0QYYWtw7jbvOb6syYgGdWv8AZ1KfbPail5BT?=
 =?us-ascii?Q?N8jE14HGYUKxbFYC/B67SBW7WDTJCfgcwyprG5JtwKZdvBqdkSmy4qvvZvkA?=
 =?us-ascii?Q?eWlcUrx8osJA46T/iotcXj7vcm9awA+IPV+6qY32odt3ZPCqNXUBnqWlhGdq?=
 =?us-ascii?Q?IJ/Jmi0s6CAmu0IAMvE6eD69ZWWgSrvIEZx+j8wL1+SBoR+ofyhuj1vj8SG3?=
 =?us-ascii?Q?a0PDA1Pu+uZWEeIQ89QHDCwChP9iFfhHcBJ7jEu/lGdeubMUl6xBS8dUleLG?=
 =?us-ascii?Q?89hjFg9gSgTEu3nG9Eoghm2ipaxVgPMZN6E05wkyth5eD9K3aiktwlzZXbZJ?=
 =?us-ascii?Q?NuTysmHbKgQiSL8Q9fqD4EofnfenAH1DlO3S/WpuM3WMmFz4i6SRpFV5p+a0?=
 =?us-ascii?Q?NTd7NufY2QtRF5Oa62GJhtmPptNPfho7C8RNzFTxKdKmBbDFkMzJd+LjqzmA?=
 =?us-ascii?Q?CJSff9Q4Uyrge7R/NzSUIShXdVvhJJhtDQ3Ux6T1pVNuBOADY+l14K7loJk6?=
 =?us-ascii?Q?ct2tSd+IwJ1WLUvVuvDNTd7cWC7C+wbskRZjsHm6mH0mljAjA7aa43upWlR+?=
 =?us-ascii?Q?rbA6gYS5YrtkRLDn1al6HpPQt09ZkJdqBRfGa8hUHvJAu37pRJJ1gHPoIbAY?=
 =?us-ascii?Q?IDZT9NgE4eS6rtpHsvCuUUIKP6qp9vu8FTvvo/nTQFUB4wFlziIdShOEWi1F?=
 =?us-ascii?Q?BFqcKHITSvzJ55Lnlyb5d0plW9qtIld6YJYr7MdOL6VUs305/GQgvrQ39BcM?=
 =?us-ascii?Q?WfGNsZK+Ru2FBZEztSa6UzcfJCIpiahYzG3exh16qUCwRo/ZLdSoigqqV4yE?=
 =?us-ascii?Q?ItFf5RqL7U47YkFhPduRZaVD6nEVCm4TIW+Q1luR8O1VgoXH6Rz8QQgq78Hb?=
 =?us-ascii?Q?qS+guZLEgtVkMHefdhrotAMfVyCq9hN7+XALUOx0+3K5ay5OXC4ZzNxdk6rX?=
 =?us-ascii?Q?+7IrEGcNSPWYFbZ3zopsOYyof3iPaawl6Ppx0Y8KQIb0THdaAFeWeJyL5qNr?=
 =?us-ascii?Q?bE3jyNPRedQrjgk2QwrXvkprSA2dUpNFijFReCuKlMsappEXvT/VQN+pgC6L?=
 =?us-ascii?Q?0LWGw73F9M+uFfiz34vSZkprTqeX4Eg9NiI8TBJ7HvzpgLpUZW+/m7SHioRM?=
 =?us-ascii?Q?o6lLCFnzPiDfQMWlsBWHivyXHA4hVGyq1kIkcehSWGuvuyK86ah74ELybCP5?=
 =?us-ascii?Q?g532lIQURLjgluC+qEs5sZK8evEu0Mna6WKyxnHh76wyyIGNIoPv4tp6WcpS?=
 =?us-ascii?Q?TOWdKoKP2Eud0a8uCDh/BcGUs+giEZ00MDs8eHuTPyH84EITqnCNUhbIyFGn?=
 =?us-ascii?Q?tsAXX+ZX/n0IyJ97RsaPYadxfPeY34EzfeJ6QL/ZnFbMvEcQf5S3gVVnqLkZ?=
 =?us-ascii?Q?N6qj0TsYpyF/3r0gB2J3PgNHZFjcnLswNWx/fLcFwKjnUUzEKLRAAvbpegRD?=
 =?us-ascii?Q?fPpLw4azjS7cAbdhuzHTRkBaFcBBQFfoH/Dik3PrZQUGRPPtVk9DHPinH0dN?=
 =?us-ascii?Q?p6iSrJEC+wDyy8SMzHCXUg9rWtdei5OZMLYAn3S9JBzUKiyK0ochru05rogs?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b598082-053e-4e27-a779-08db6380a839
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 15:47:23.3674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHLlVBcvYxVunzcGR87xzuylZqpvfG9mgaGoX62oSTb52ykMx3WWas154NnDdteFXSWjOXZiUrdhsXc5eJJ/bCAydYFOGRhrNXNa3OnJyNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5581
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 10:42:41AM -0700, Amritha Nambiar wrote:
> Add support in ynl/netdev.yaml for napi related information. The
> netdev structure tracks all the napi instances and napi fields.
> The napi instances and associated queue[s] can be retrieved this way.
> 
> Refactored netdev-genl to support exposing napi<->queue[s] mapping
> that is retained in a netdev.

Hi Amritha,

This feels like it should be two patches to me.
Though it is not something I feel strongly about.

> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>

...

> +static int
> +netdev_nl_dev_napi_prepare_fill(struct net_device *netdev,
> +				struct sk_buff **pskb, u32 portid, u32 seq,
> +				int flags, u32 cmd, enum netdev_nl_type type)
> +{
> +	struct nlmsghdr *nlh;
> +	struct sk_buff *skb = *pskb;
> +	bool last = false;
> +	int index = 0;
> +	void *hdr;
> +	int err;
> +

nit: please use reverse xmas tree - longest line to shortest - for
     local variable declarations in (new) Networking code.

...

