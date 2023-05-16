Return-Path: <netdev+bounces-2940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F13704A5D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46B451C20DB4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E86C19E5A;
	Tue, 16 May 2023 10:22:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D4319BAF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:22:26 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2108.outbound.protection.outlook.com [40.107.92.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EA91989
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:22:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuRudZ61Y4W2rePmMzMpty75RB9bMCfpbxkVloYtjhH/Z96Tf/8wtBF1e5BKkvKchmHynTRhUkI6Dzuf7TplDnZeoIriDLQaglu31eXeqKXZ/E3O5DQsCqPE0WJxjKYbIvC/Vwd5rKfUvDjkgr1t3xwE4+768V4NxxkqfTic0Xt1/EigmCPBhGPTbPlE2n9v4vrbEd1f25qQ1KTNwSQ2KIdDYQGW85kmCIII2nAK38AkKRuBWC+zYZ3AhqU+H+cZmZP9z9xLkDWkPPKHDi3oqEZUEmSHXFSp2qVVgnD3mh8bLVyAHFSiVYvHREeMGr2TM78JRsQJn+sbfnFdmCvqtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=scx9RI8JHd70v/YWehUxg/WeFVCdraK4RNDgz/POOMg=;
 b=D15luR1howozd6x9V3FvxPgoo5x6KmDW+omvDRraw81tpI0Rsm0BQclLCdelopN7ClgHH3NXYZOBocvXL3AVNDlCROPVieNTHND68zRKXvVVRPE3LQWYMDzgaAIs4BOxTmerRsM3qYiuOb1jV2oMe63+m9CPJq60WFpZbotNGX8DPcyO7J5ulPBT/xtK45qi2zE9C5cQsnmUz618+yekk/QhQvXEiJSQNvkIUHYSqcunhtkKWlbeTc+nQnsg52j5pII9zb+Irks8HORVqhptUZbBJZnq0BJkBXPejSnODCkkpMFteal8OvVJ8HUKWc89w3NVNAoDcVu0wxTCDeYOjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scx9RI8JHd70v/YWehUxg/WeFVCdraK4RNDgz/POOMg=;
 b=PUjmvUck5Tv3QlXZeTsFNVLwEVv2heabm/sluAKOQqeVdPQOPDD4+I0a0rJQGm+3aHuxc6hXBhuIZ6kU8q29oTIIBPHAtDWt/M4SezgWgzdrAHJsfV4AnX/qlXCtZvfpEzxOKiSThgBVWueh0pkmHUwT0nymTZJwA+XH7lYiLhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4086.namprd13.prod.outlook.com (2603:10b6:208:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 10:22:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 10:22:22 +0000
Date: Tue, 16 May 2023 12:22:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yuya Tajima <yuya.tajimaa@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] seg6: Cleanup duplicates of skb_dst_drop calls
Message-ID: <ZGNZWEPQqJYVTzAh@corigine.com>
References: <20230515153427.3385392-1-yuya.tajimaa@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515153427.3385392-1-yuya.tajimaa@gmail.com>
X-ClientProxiedBy: AS4P191CA0011.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: afc03e94-ed67-4e06-ab5b-08db55f76f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hsYUngqPyUduA6KOiFIdCTDKRdKcgYyXFVz7iYWqLrgAU6Jj4oS1O2L08hpqqbj0RcVNR8dJ+PTzxn6KhMf9Zpab5qb8YfhOV1cppWfrZoT5nQQhjLnYL9mFcMoeSLWVYQOUWs2Glj5ZJez/2rkGcb28zAObOntl+uTgG3faSoRikn4N3psMKtSOPg/69XnAdeIQ7frIy/mcXkQq25FWAbDocYo2XR3cZSTJdeYM1De/IeFguyISKz+huhDY4uzk+Jl/2HfxkaxlrnYLykAj/DzhmFR4Rh8qLQya3IP9xoWIEzNw88TdXFGxw6ug4nXdGuUz4bKoRmWGSaeZlr+VGMAEXfQhFGOU927EWG4cRorrMhDeMHDpwYHpGAEMgUJ1BNl/drJvA5P/crtH1sn7cRho0F02YO11K/o12DebI8PTZ/XojS3L1GDT3KUHQEVOe9A5/VXoAj4TiK5yM9pQONq0W9YylhWrnCvAnDg/70J4JXMx9/oYt+/dt8tjp5pZDVJupeUt866JWNzsxFosPA1DMjaYMvc4LtsoWPBOmundLA/L2tbaElV3jf30bUpmITPajqcmyfwSEu6ypL7nNxvWlVzoXqb5brRZuwAavXo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(366004)(39840400004)(376002)(451199021)(36756003)(86362001)(6486002)(316002)(66556008)(66476007)(6916009)(66946007)(4326008)(478600001)(6666004)(5660300002)(8676002)(44832011)(8936002)(2906002)(4744005)(41300700001)(38100700002)(6506007)(186003)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eas85g09DOCcHduP64SEnCcPrpOcsScVdalgc14cOqiFYNVGk8C7Gtdvh9l2?=
 =?us-ascii?Q?bBtOdWO2ZvxX3ndYI14ZUg4qnaNdo5crEr8j7tgeQ1oxKRlXyTgubzCtAbZb?=
 =?us-ascii?Q?qIntZSISwZJAWPO4vfdg2Z/iOEhC+M2oJFzf/qpBvP73bJRorzwkc/Yj+r3Z?=
 =?us-ascii?Q?0F+sFi6/qo0WrzYWLMA7lxZFcbz0m2lM+yph7PXWxSTJPVBya/lA07jmVmhB?=
 =?us-ascii?Q?CZ4QlqFLKvcO5icJsO8XMjeIRoKahCnNCqFQg7+QES/2+uerY+07+zOdS55i?=
 =?us-ascii?Q?V67AoVv5Ya4wFdz5GPqx6a+1YYlsTQocgyJ1Xe0H3nSsVOjaEPFaMUTzuNvq?=
 =?us-ascii?Q?D0bacoR8wDaO8PnCOCBu5h8SN2OfJYs/ilqPZzq4HbmXoiVhxTf7wcTUrlLy?=
 =?us-ascii?Q?qAzwxqi+A8JDgAK8KFRWTIZXHtue/+fsyGtpWAym5pTqbBRZ+uID3nD83xeN?=
 =?us-ascii?Q?xgfgl3qDhCvXh25k/Bf71DNT8Pc3eGV+H2/2gsDgmyy5V6+IhAW2AOO8Z69k?=
 =?us-ascii?Q?kjtb0fVTvgZef/6vRJoTwL41ODaHFgq5V4TzPWBvHN3aE3jIu+rdEWbDIDTN?=
 =?us-ascii?Q?vsoxmIeUHTdlr17fMOhYHHN0wMp6+EIpafDXq4BQNZ0blP2s3vv2aBWsCIvJ?=
 =?us-ascii?Q?EtQWt6cFeKhyMARG7Qn5DABKEhxcE7QXnNlOXeRMasHJghZlJXC6BARvGCaS?=
 =?us-ascii?Q?dhWqWYeMmzTGm4eiNqPLkAiiH3BZ6+q52NFEwe5u8bjairgMBXHHA+yW0RQl?=
 =?us-ascii?Q?T03diPaFm3Z8yQa6zpEeBpo34V4VYZJmz7EFaJxSv0nNosFPnzSRp9ih6Zoy?=
 =?us-ascii?Q?+b+uhRpFTr6CDJwULPj0bVwtvFTUuFbDjmS/RFA6YYHXcf5vlmJNx4UiJrm8?=
 =?us-ascii?Q?xG5M6MORBvX2YLd7gPeSz0OX08IV70gFjr0an276TJUBj4ndgzkKTa9tfotN?=
 =?us-ascii?Q?VXmbBiC/nqE1WhSieQ7PZW17QUpDBsUjWAijoXwGCo424wIo+7r1h9alZH3X?=
 =?us-ascii?Q?dgI4HVVBd1PcUVtHXVkEdD/v4AKj5TRoAXuvklWqwNLV5/7eRlOR92ifeWeb?=
 =?us-ascii?Q?nDEcagroqiAdX3Mz4L6wxAT4GfdzfE/aJMQGBxiw/KdOEsOsBYUfYpQNDsyh?=
 =?us-ascii?Q?c8HXGzemVz7uLbf/7TTWIuEmlQDuDr4Yctx9bfpdBnvx3569RL9h4daUF3bE?=
 =?us-ascii?Q?z0viEABT0ADgVaqPNRQwIfAyeOn6fr07+iyRtw0bV+NZNNiuSFi7RCIPQSn9?=
 =?us-ascii?Q?O9RToMsLnpkNptY9R1II1s2gXTvcvi9fn5770OJ2xNAqnSTfLgQRBigrmHXh?=
 =?us-ascii?Q?u7HlUEpKjhtJKOxntBnM/cnR8IwoSzZ245OcgEDNewho+4+kSEW3RoaPRS0f?=
 =?us-ascii?Q?ePG7kpEx13Y8zHyzbXiYd+6bFj47/jPX+58KagXo7irVfy51m/wjUfB7x6Yp?=
 =?us-ascii?Q?azImJBaj1kowfXnyuLXaY4a6nROL2XTrC+EoJTEy6vMUWI5IDXGQPvZJLs+y?=
 =?us-ascii?Q?QhFDv+F5iXbuepLNYxjI0QXCNZUm49UHFlaseSqq9LJEw5Q/ZypSq5MbIydp?=
 =?us-ascii?Q?NMBNaXmGk5fEh+k1IDJ8oDvadlkK44v5PTVgrn5TktmR8RLzXDxSWy9z+aJg?=
 =?us-ascii?Q?zkwFkW4Mx0RNw2Gh2OplvfNHYaIMx1wZuc3NGH/EwNRG7w7r3xtdBkGeMYFA?=
 =?us-ascii?Q?fPAk+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc03e94-ed67-4e06-ab5b-08db55f76f8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 10:22:22.1317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: si1qoGZc9vlrBwkKxCI6gPGjCgguuk9OcxkouTEmcRQ3r1Vn2jCEW3aB5mcMuvTV5jepjLIZC9zoWyNAy+uPN7xS+HvnmfcAkRNTNIfVTPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4086
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 03:34:27PM +0000, Yuya Tajima wrote:
> In processing IPv6 segment routing header (SRH), several functions call
> skb_dst_drop before ip6_route_input. However, ip6_route_input calls
> skb_dst_drop within it, so there is no need to call skb_dst_drop in advance.
> 
> Signed-off-by: Yuya Tajima <yuya.tajimaa@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


