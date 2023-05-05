Return-Path: <netdev+bounces-577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1EC6F83E8
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C94E28102A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677E9BE62;
	Fri,  5 May 2023 13:25:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D156FAE
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:25:31 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2097.outbound.protection.outlook.com [40.107.94.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5501F4AF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:25:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5GUXzHhtKsSsdUOubGWyKayAVprRRRW8Rn+HxuXCWBnZpT2uNwyqaZHmgxoB93xX94AiG0Fu9BHxvE6EjdIQWozpMCHKwv/WtStJKOZPb4vM8Fx0lwQ19FEARnDY13j82cnHTXURxIUHeLmnTC3fc8eJzRdEfEjubVM4yusAb7HcWI18dbaNO2+KWDpIolqv4fLrY92IqoV5Cy35oDV0dTIM3gldYZ1e8TGOkosViL9zfnxrY5aMHQE1EMK91bRG1X9otXVebXzN+hYWy/w2/QJyULXdk1N/R5LRWImeQImd1PwHk5E0Pfr83nVAB9utJXTSvvb/NVFPo2NUbSVGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIsZ0Tq3EVFeTEbxNi+wXq9OJXNOZKZVGabxxLnGs9k=;
 b=oSSO7vHyMwNMyqhwpXwFCmnZdFpKnbJMlCFybiSzsaY9s38P4yLdVfrEWQvVLyOaqB02EO1R2RedQADrttX+YViCO8SMNmYjFyr0hfECg1ORzfxpYEOL6HL1VCOWkTuRvHwYnlxPwoMA2PRMj3ElnJ1G3hvTbMaLiarX5iVjxqKJaXXzGWSWDc5qJmPH7hUvZshRiDq9qRT11W4l/nHw8bnYqekWcJqUoGeazzZ/NbYTs7DgQ+INZq8p6BCijGtXzvwVNKtPxf50xduyQyJV4fWdizM9wlHWEC+fNIonaym8GFknVqwEoCnkoug4uooyHSiG+CZmnptVfgSeq2MAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIsZ0Tq3EVFeTEbxNi+wXq9OJXNOZKZVGabxxLnGs9k=;
 b=CA2sWyRiHifZp48dZVdW3ciIl3+dYKze7j8c/dUwnvRBaynhy0v6nIZb0nv+qRESlLYmEXW3v53MFlm0zUmt28Pw3Uph0x9Jn1V14irzwi/qzz5r5eUSstDsFFq/EyI2kANNANdLg+5BnRbYdkiZvoagprlCMtBJUV4CFG9DOZk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6431.namprd13.prod.outlook.com (2603:10b6:408:19b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.12; Fri, 5 May
 2023 13:25:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 13:25:26 +0000
Date: Fri, 5 May 2023 15:25:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Ivan Vecera <ivecera@redhat.com>,
	Pedro Tammela <pctammela@mojatatu.com>, davem@davemloft.net,
	netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, marcelo.leitner@gmail.com, paulb@nvidia.com
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Message-ID: <ZFUDwJF1uRH3q0cT@corigine.com>
References: <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com>
 <1bf81145-0996-e473-4053-09f410195984@redhat.com>
 <ZEtxvPaa/L3jHa2d@corigine.com>
 <bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
 <87354ks1ob.fsf@nvidia.com>
 <20230502194452.23e99a2c@kernel.org>
 <87mt2kqkke.fsf@nvidia.com>
 <5c325bab5f4b4503c7740fd73e9ab603285d0315.camel@redhat.com>
 <87ild8q72m.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ild8q72m.fsf@nvidia.com>
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1e0389-473a-48ec-f751-08db4d6c3069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YYu34th10Nc1oaQbiC09kqwHoLZ0ukd4sEInoYQLlvhYlUAkthLyUFb0KWTE5S0WKNQ6hbe2GvKWr9onqBw/sFkg9EePRqlTmrHNOsytXEolDSRd0tcIycy+N9PTZdZl997WPTnzRcA38PaSZvkHxDXMrm3pP/l5qrovhlSICI9MWEP6fLTNEJ+eMxu1QdHAMcpmYElfNkBtCW1ghsI9dgFUhi3PTFBZOkmwp8DVoDI7fBCaKvGXlCkMxPdu2T78R2Pb5SL7v29xFnM6cPlYJEJZFLauVJButkjjsux5yLqgJI8+q4Mrt4OsXedk1WSoQjgH4X835AyraRDZWTgEpaZ45uDZHYOYOnCTGDtfTSvOs1KbBUXITqnsu4Vo7SiVK+yUf0KGuERP+uVWg22wZko5fr+5ROkLUW48xuBG6Xgv7mVzWD3UnK1Y2yQZ7nKwFkuMwTmOHIB7JbDmuGKw+AqMEw8GYnij6P88XcfXBKg2GRHX9DqVHfRsPS0zzsjQD3ZLzI0+5P+AFGDDhrReq8MaH5q9pVYnkQVRuWmT+hmt3lS2g4x2iWBbegbuJyVd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39840400004)(366004)(396003)(346002)(451199021)(66476007)(6916009)(4326008)(66946007)(66556008)(6666004)(478600001)(6486002)(316002)(54906003)(86362001)(36756003)(83380400001)(2616005)(6512007)(6506007)(5660300002)(8936002)(8676002)(44832011)(2906002)(7416002)(41300700001)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mruYimgeFi/spAwWZhASlHIL8zxuK0o4vhIbmR7FJQAcrSlNh3T8a/FKwQ9k?=
 =?us-ascii?Q?D/ZbtDp1h2aWPn8JTY3bwEZTwcmzJ42R7f712oBLwybRLTjYidxXuTn8mtWH?=
 =?us-ascii?Q?+Z5JsVjThARpSc1KFhXguEj0oKnO+ZA02ils5Ay6isMVCmIwI9NwGMBn04AX?=
 =?us-ascii?Q?5d/x4RE6IoJMp2zYS8OJp+/pGrLjt6T4sqMZPekWkpx1oXAsnAt9nU7nmXFc?=
 =?us-ascii?Q?SuncjkqeEHIQMg0PTVywrzv0lJUQLYbAPGqTleZpz6/FhQchOplnb/uGrjB3?=
 =?us-ascii?Q?SdqKU/JxoSrjcBXr/STC2WSnorEeVSVNEMFMR5xYLaEQ1bF1DTIbMlr2MdD0?=
 =?us-ascii?Q?D4aRqEtU+g+ZNJdjMXTcubrAnUZ3fAer/zjBsfWezTUyVLdaCihCGiz+l2nN?=
 =?us-ascii?Q?nYQspBM0J/VijZyi4AznkmCmbwUsljeAKp+x17OfhI5VbqehyfUJ+XU1YdFL?=
 =?us-ascii?Q?yJHrImPePX4IYkRr4A0DtBm/dyRZIcLenKUBaujhJ0yKVoKD/jM+LnbTyhzl?=
 =?us-ascii?Q?RhvHXWS/741EBxoa9LSkzK6x0bDr6qH5SnM9B/Ccghk3aPUsmwrU5Wb66hzN?=
 =?us-ascii?Q?KKOOtCEkAvkYGrSw9ugVZPtJTJBIMHgcSdZATEEmTm1Ye24WV6BbpBSBrzSV?=
 =?us-ascii?Q?PytDcTiv5Z5k+KVUeRFCCiXFrurtUATVeYn3kFhwfcdUYWL2ibyLLVw2SFpZ?=
 =?us-ascii?Q?7Yn+ydjyUMh0ff9MqhQt6KXoIFM+fPK/1TDLfNit0RngRqXonmKMqhzumoJD?=
 =?us-ascii?Q?XR/VnBTtOKsUCnpWIiV3W3EzaObgOcE7YUNzZy7DcALAccie4BfwdROW4+yk?=
 =?us-ascii?Q?WjfbnwBKnfzjXy1ym/whsaRvhmTI7BrxwJ1b7Lk54s2Br2dg/tZ3MTmaHGsb?=
 =?us-ascii?Q?XQuIn4ApM3ISmyEe0mJaXoD6MdbZ5xwqWkepZsRqS9LXOq6HRgJSu8zppzl7?=
 =?us-ascii?Q?gs2asGMmoZsUASeZ9JrtmoeW4P+m7MNj6yiJ4riKgo6TiNXLIV5msyEsiqfZ?=
 =?us-ascii?Q?qkkMo06ebYh+HWAtYZ+m0PQ2q+hogJgnWYQ/v6MudlCVuFXzgACvU15yb2JS?=
 =?us-ascii?Q?huCkZLCcNCqmk4ePJ9vpBp+cr0ixLaaV/80Z0dvPSv+SlZOOaxs7hW7P6cJs?=
 =?us-ascii?Q?+XFE0eWnJyhMnBgTSVR0XFDog0j8PwzqS+9H+c6FLOsXgFAlrCPNy7z+F7rY?=
 =?us-ascii?Q?f+rBVGVNuTHpNFZeHeOfYCUHfgr6faq/KpHUp5ozdJOOSKqWeM31eTYdefIG?=
 =?us-ascii?Q?FK/muM8kLFvT+BNo5wKbrpR0oXo/Jjd432uJ4B5y1G3oENifBvYpZGQrqj2X?=
 =?us-ascii?Q?n0kV8+uZ+mJPqyNwHBibvz3j+oVXOWo2L74dw7rlXmEXalGE4WW12IAerAnZ?=
 =?us-ascii?Q?TR5Zjvg59pQOROwW8JhCTtB2d5Eu3UVTV/bSd3oOsHrJbmjLyc8iMiTHgUeD?=
 =?us-ascii?Q?8418g/UDEb5P3GD07qHb5d3mCeVovihaYaT6EVrilaDjcWVC2NMmuWgdYLeZ?=
 =?us-ascii?Q?uB76UYsSC0NnEH3hufcSnXhqdBYcOg1l3E8ACcbd44rO39m8T1ND4qQbN4oV?=
 =?us-ascii?Q?q8FYYHwhwvt7chehKOV4/By5YtDOsLan1iJ/d51vxSoX64HGntB8SmYBqxEj?=
 =?us-ascii?Q?mwfxrD88WiC9wZXsr1qU+pCGWfeJSf7niD8eYo58YxqW5tqC1dBXMkH2T8La?=
 =?us-ascii?Q?Agj2jw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1e0389-473a-48ec-f751-08db4d6c3069
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 13:25:26.8781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKhFD2KMlUScohvjZp/N0dnoZrzFi080HLlzQcpfmvCKhP8FvyV+wkp1xKs3JhiTn49zslPaLPElsS01a+xNhonFtYyov+vBgZP3S50v4Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6431
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 09:32:40PM +0300, Vlad Buslov wrote:
> 
> On Thu 04 May 2023 at 16:24, Paolo Abeni <pabeni@redhat.com> wrote:
> > On Thu, 2023-05-04 at 16:40 +0300, Vlad Buslov wrote:
> >> On Tue 02 May 2023 at 19:44, Jakub Kicinski <kuba@kernel.org> wrote:
> >> > On Fri, 28 Apr 2023 14:03:19 +0300 Vlad Buslov wrote:
> >> > > Note that with these changes (both accepted patch and preceding diff)
> >> > > you are exposing filter to dapapath access (datapath looks up filter via
> >> > > hash table, not idr) with its handle set to 0 initially and then resent
> >> > > while already accessible. After taking a quick look at Paul's
> >> > > miss-to-action code it seems that handle value used by datapath is taken
> >> > > from struct tcf_exts_miss_cookie_node not from filter directly, so such
> >> > > approach likely doesn't break anything existing, but I might have missed
> >> > > something.
> >> > 
> >> > Did we deadlock in this discussion, or the issue was otherwise fixed?
> >> 
> >> From my side I explained why in my opinion Ivan's fix doesn't cover all
> >> cases and my approach is better overall. Don't know what else to discuss
> >> since it seems that everyone agreed.
> >
> > Do I read correctly that we need a revert of Ivan's patch to safely
> > apply this series? If so, could you please repost including such
> > revert?
> 
> I don't believe our fixes conflict, it is just that Ivan's should become
> redundant with mine applied. Anyway, I've just sent V2 with added
> revert.

Thanks. FWIIW, this matches my understanding of the situation.

