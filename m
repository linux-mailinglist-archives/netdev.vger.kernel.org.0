Return-Path: <netdev+bounces-8568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6376724952
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35D751C20B50
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3F91ED23;
	Tue,  6 Jun 2023 16:39:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33D7174D4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:39:51 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2092.outbound.protection.outlook.com [40.107.93.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AAE10C2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:39:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaktf+FUGk0+48wPDAsIvcA/nF+x0jC7PYsiCyIYMKGFVxTZLWvvn36B9Sg4sXFdawqPRCaWZg1zrTKnLy6x1ffaxqfAgJeYCU62Wz917rX9I/z0R8YA9DyQ9ssD93ga3kB1ItepI1yBpK0L0Hr7udGVheeUoMby7eqFNTJYWWwkaMeFMcBFf6FIWSaEAsr32ZL3E9EDSTfwVCVIShJVlIociHhndXdOlk08ARTgvrjg5j5lJHX/6IGdDyX1qzV0hODg51l2hIii9pkC82DgWj+ZyInU4lvrZmfzAtv1njrPyh2VqezPSQ+h8WMHf+pbpQFgM2X/v7ed7SrYcMOxlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUb5KeuvKPRuqWGV9D6kMWJppPvkMXm1NEclJ9ZTjVA=;
 b=QYmB9DaUxGKE8O+QGiFREV/qwkgq0tVeNIBZjBChPH0X7QjxHR99xjy/NCOVrEKqS1r0W/uYMi6xI9U1Gj4Ki3VLIMt9Hewt2KeW5YmMeCv5CiKUY6ok4KU7078RozPJKwJno8HygN7zIrgt/rSIord3Lf2Ql8Rs7rjIk1Da+dM3c+QqVBm1cPwgUOs9g8VNAzdXaC07WnoUcC1ECzPVi+iVpXDIn2+isHzKBPG1cBhzNjoMACka2IKR3l7Fkqf+fNmsLrxdkeOuPmA4cYn4PpJ9wL+bPlDastT+zqLCr9pVO4Sc3NAX0cpNEtZ0jSO+bNGRF9lsLaOijHJDOhHwUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUb5KeuvKPRuqWGV9D6kMWJppPvkMXm1NEclJ9ZTjVA=;
 b=K/K4d3yVQcUl8mtnzPgdl2lHomPb76RDw0tk7lt7lo+Gow3MBY1Mi8qozz5IX/FgBVXz3LhfEddlW9d8LMArsDZZK9I2yHvIrtivJijyku+UbR14Bfr4KH+THXVkDIw9q9DBEbvKVBvWjHyhv21Rm5cBYxCyUPophlQRies7Ckw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by DM6PR13MB3804.namprd13.prod.outlook.com (2603:10b6:5:245::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 16:39:46 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 16:39:46 +0000
Date: Tue, 6 Jun 2023 18:39:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH iwl-next] ice: clean up __ice_aq_get_set_rss_lut()
Message-ID: <ZH9hS9BBDhy9lIG1@corigine.com>
References: <20230606111149.33890-1-przemyslaw.kitszel@intel.com>
 <ZH9S6wPIg9os8HYa@corigine.com>
 <1e11a484-af99-4595-dc1f-80beb23aae9f@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e11a484-af99-4595-dc1f-80beb23aae9f@intel.com>
X-ClientProxiedBy: AM0PR10CA0050.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::30) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|DM6PR13MB3804:EE_
X-MS-Office365-Filtering-Correlation-Id: b7189bba-71ed-4f65-7264-08db66aca332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4DtkVAUjOOMIIqs+Avf5SV5pPvcNqYpxBFqfLcvFFI6/vR06M3oyKrZ2BIDn236zk1OBpuFtodyhsXEIzhK7RgNkRcJR8F6xmwVM82SQdCerc7Z905Kp/AHYwxv4wN0qcyAACFbV+P08GSADvY4h2U37UWsrx0euDdJ39G3OB7lYzmIusSS2AFH0xlOPUTMl3tacNZKXTJGzMRiLE6E4x6duu1rprZVY29OZQGXH1p9/WUGPbiAsStAQGXC4aWUDsQ+JfmfRyR1fLUSVgiJgjRS9bBOXMIQkH1xdMsFBs859XndyqdzTlhEKjZRvWGNdUGLe7/2U3TP3kbBq7kkEIjgN96Q5HqeqyB7eFPYxO61ExAN2m7vBmNkiuap8nbFIdZ/Iaxv69BjZ34rlGDTomdnK37B8fxbtVgD4DFGhZq5cs/Uev5FvikFzxRRy+z5eSpmyHi7su99VNdKvj4ekHXbQNxAAeHMSvwo/aqwsp4GzjlkEVggvZrQ6cmJZH3usOcftNU2Qw/9+E/dNUpIMRPfKEanUMsIn7bf68p3/70fuVkZoHyKGwsWAaF03xOs5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(39840400004)(396003)(346002)(451199021)(316002)(41300700001)(478600001)(2906002)(36756003)(44832011)(66556008)(66476007)(66946007)(8936002)(8676002)(86362001)(5660300002)(38100700002)(6916009)(4326008)(54906003)(6486002)(6666004)(2616005)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iVilvQp70tIRVQ66gzD11R/xE3uzaVPSASt8PiXN/mtI0meqnIRK9PiiX7Ao?=
 =?us-ascii?Q?QoDQmYcQ/dn0jvywGwMeYbAITHFgWW3yzBqGKjHYFDy4JbOHIxpjBifqRuxP?=
 =?us-ascii?Q?At+80hbUoZ9kiZQdR98EdTBfWxOmSYZ6x3k44Pk2v2+YCk0EI58uFOvA4Rmk?=
 =?us-ascii?Q?XWO08SVuTYQmIDGG6/NIdc6sOgfbRWOvgik3dhx5x0Ji8baSS0IgYXi3aYt3?=
 =?us-ascii?Q?zxZOV7CMKtjV4WXF86RAc4n55fnH+e7P5aLijzV/AdaeqNB4wyiDUG/PqiCB?=
 =?us-ascii?Q?7aNMoIUIanyqvalYkw+r9vkxagwN8IM/ipZO0h36ZrqiqEHZNgZKe6ru+wJX?=
 =?us-ascii?Q?vzMsM9L5FLfi/2OSYwYifC06Dqx2JZiUszY9M0ovRB4Ai3mxZm1rjsHThpXi?=
 =?us-ascii?Q?FOrUV1d7Q//4uPY30ei1JaxCz0zwOx2X26FSbj0o0UfBXj1tNJUsIqOeXkze?=
 =?us-ascii?Q?i6nxarelxufWy0dsXQ9rGKSpWnr0Gxe1gi5j9hNhd/ce3AhfQloVdesp8ECF?=
 =?us-ascii?Q?N6Ma86sq8T213WqVrf4UgucfwobbxQJGWl8OvetiPs1dAZxiIrzuIkGjMWwU?=
 =?us-ascii?Q?vP13X+BVHE8s87x2T6poO+FGa0QIFCLLL7by6/eX3axm+3CQQHvddyCsU4AF?=
 =?us-ascii?Q?Dm4s7IpMWJSfopgghDawlLHHxOMFLPGjNir2yOHbe5DWxX+0EdFwcGYDUwdr?=
 =?us-ascii?Q?CfIF8dDM7Z1biDis1lc67kpaTk6VxbszHJdWBG5K0jZbTpxvcpnpYd+/Q7wR?=
 =?us-ascii?Q?J+yXXcXyKumJQFcxZx2Wp7ftOyMGmJgNaTVMxElEhC1Mv2pJLiCpC9rgk5fT?=
 =?us-ascii?Q?AUDf9FEmqSh7lG1HPylrJ/Ml6qzFnrbLzYx5LvqPHmPTOJVGNZO1cdASGdbY?=
 =?us-ascii?Q?xJQqOZXkTbjg1t1qqaNwwCm6/ptzBxmvZEDO/fTDAf9O4e7vusBNS8+PM6+d?=
 =?us-ascii?Q?/EZ0IhA+Zc8PnUzt0hHtD5QE8V7yXW8Pn+OXwaMxu7aFIoa5xvROiNqRO2P1?=
 =?us-ascii?Q?UFR5CJypNIABwAGzHiGgGVSSbouSYxjoGukTZI9f7LxnxjnFexbd+TMm61uT?=
 =?us-ascii?Q?9cL6Z0KgvF9asI5bRaa2KESC1Pb315iqZCewM4VanNjTg/8EA3/rsglDvmm+?=
 =?us-ascii?Q?DSiWyPog6a6JFI2XIind5d2YT+1EDCKAGYQpS8V967xPUC33Pzh26xiVi1JY?=
 =?us-ascii?Q?JEyka40NimVv8VUvVYNWREiGFtoM5mdk2MqqBATF2YAgXZtYMrnQAiuEgkJn?=
 =?us-ascii?Q?viCorV+O6+Bs6f9DFbHaYlHXIQqVMfY1FgCmkDGYc3V9phvtcZfj1iULcChs?=
 =?us-ascii?Q?dkglmdS3LqcxQAHjgMeFrmFxs0LPX/0qdMe8eywMgAUc7I2+1PRxC/Fdn77K?=
 =?us-ascii?Q?Pq6OFBdz0OOF7DbXH+mde92bVfWSYq3MVI9b11reZQxx90+x5BLFdUobccy+?=
 =?us-ascii?Q?sBUYhMHJKbS2Fo5S/i3IAxHq1aVGhPVgso3+/BE11sP//trLbocJu91oXLPi?=
 =?us-ascii?Q?BMgRUmBK4eUXxhNtdfvNCqBKDlaZ/3aVrgGRvoRiZRsDej/GX7WmynG5IE7L?=
 =?us-ascii?Q?cXUAo/gS9G2wBvUXgnApzLN0oVpjdnXPczmRCG5eWrqSwF4eOdg+PWaDNTnD?=
 =?us-ascii?Q?WDwrDrxMTcNZf3Q6ChuLwSHwppqpHolCKDBT2ttjapcVavtnEYIl+KSwsqp9?=
 =?us-ascii?Q?R0XgNQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7189bba-71ed-4f65-7264-08db66aca332
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 16:39:46.3751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/tkno9z/my4hifvClbWS7plYarw0XNP61ZzqU3jTmfI2AQmDjPaPxK4/lS9FMIVo4+0qscsxfKsw4tGzZihFgmEjUI2W6nAMB75uC55kVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3804
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 05:42:53PM +0200, Alexander Lobakin wrote:
> From: Simon Horman <simon.horman@corigine.com>
> Date: Tue, 6 Jun 2023 17:38:19 +0200
> 
> > On Tue, Jun 06, 2023 at 01:11:49PM +0200, Przemek Kitszel wrote:
> > 
> > ...
> > 
> >> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> >> index 6acb40f3c202..af4c8ddcafb0 100644
> >> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> >> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> >> @@ -3869,6 +3869,30 @@ ice_aq_sff_eeprom(struct ice_hw *hw, u16 lport, u8 bus_addr,
> >>  	return status;
> >>  }
> >>  
> >> +static enum ice_lut_size ice_lut_type_to_size(enum ice_lut_type type)
> >> +{
> >> +	switch (type) {
> >> +	case ICE_LUT_VSI:
> >> +		return ICE_LUT_VSI_SIZE;
> >> +	case ICE_LUT_GLOBAL:
> >> +		return ICE_LUT_GLOBAL_SIZE;
> >> +	case ICE_LUT_PF:
> >> +		return ICE_LUT_PF_SIZE;
> >> +	}
> > 
> > Hi Przemek,
> > 
> > I see where you are going here, but gcc-12 W=1 wants a return here.
> 
> So that it can't see that every enumeration entry is handled here? O_o

Yes, that seems to be the case :(

