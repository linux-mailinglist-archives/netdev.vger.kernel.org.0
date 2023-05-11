Return-Path: <netdev+bounces-1718-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 570806FEFB5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC64A2815C9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C445B1C767;
	Thu, 11 May 2023 10:12:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5161C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:12:52 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2104.outbound.protection.outlook.com [40.107.237.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD0BA1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:12:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4hpK+GztfQ2Nr9qDvBZvD5ZEnjTMVDcHjexeI3BOsJ6lBz119nk0ayfbOKeIx1tp2A54eyLXdPC9Rp3H+2zku6nqgXqA3bgls9m2utK9/lVU3dhz9004bnRRDt4ClaVB+/JIHeAEWd7sdLRtMFmlqQ2A8/JXgUapL/mpN1LhFWUzyGBgPdz02dIjLixmzI2P1ws4WrLoJjdm7Al0xg6vzcUmt8guy0pD0g9iRheaBFFAywyQUqY9EMcUaeZvS/FpLRcva8obh+p71neYvHhL6D+xffkhGYS+2f9XVUkFG5V/H7OXmr+1/Glq3M01/tQTM57/8MTnwc3xIDgxSqzdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79fLo1ynR0cbjoRsulYpkg6+QyW26YV11qD4W5OVFlw=;
 b=RHmbln3iHt1BE57z50z+zCGNGxUMVPe2TUM2GMV5kXpeg4LOtzSbC4DpUL6bKpJHb46afIfhznxktkQosjYABXahDJheaF/yDfOfJt3V8/72VBRrsmnM0Ylg8UFZCEZEDUMo8PanYcLqnWtmx6Ysf0Sfslyy25ixj5LiPeo7mpzNemRtfB0B22k1pQJlhZwpUhi1gFiBY190wI88JBvG2g9wqqbGV+r46PwBrmO1PqOcRdkLc8BO7XZfvV9qqswnhNuhVrNMeNgzku3q4+LIdyXZD58l+tTwFJdIjpmw8cj7RKT9k/rHeBTqmDupjLs9zfWsKGrhGo5j6l7a5GJUsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79fLo1ynR0cbjoRsulYpkg6+QyW26YV11qD4W5OVFlw=;
 b=u+MVhPYhQ3MSrEwFN9Ggatg02UZJCpC1io65nGyGKLDJ0AJ+JgQnltMTiY/1lI3i23THOXL3sHDS5J0bcXEGHqp003L4fxBTOd6+bUTMR2tTsMdeDvdrX4qZtgqEQX4avpCimqOjEpmxmCqW7eLWvoXKBz+Sv1J9OSTIEH3OdF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:12:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:12:43 +0000
Date: Thu, 11 May 2023 12:12:37 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/7] net: sfp: add helper to modify signal
 states
Message-ID: <ZFy/lQC7rKT7Dde/@corigine.com>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
 <E1pwhue-001Xo4-K9@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhue-001Xo4-K9@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR04CA0017.eurprd04.prod.outlook.com
 (2603:10a6:208:122::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: 0210482c-cffe-490c-a29c-08db52084292
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v4nxOAlDfjs/LFf141+Q5/BcL7ppDB6PHceGdYmOftox7UJ9k8M+3PmApmt1PHEbd/6WyBwCmI3uCuecGIcnzmunpo+VTZ8aYG6Ios/89x3xNc9eBrSZsN0mn3LkhyR3NTeGA0dm5S3A0kNiWgJb77/SjOey/Lc4ykchmHOZHfFpSMSej3FHlYj1lxeYEjvrlfqOvG+XY/vqvTAi+Aa9DpWg2+UFwPbxZuHbaq3TpYJR66EIrb3qq5fJyQo7w4jjsvkGvrNuc7NqNaKV9hmpUGy6fCUw2m0w2qCmXxBk40N+VvCGbVqZeXw5ZJxhdU5cnIq8ZsjIzCBHiasLhEPpkGdJXBGDU3AOijdm391kLCzaFJCuTpSruvwD5+NimnURlvcO6jhUaCV986jME1cxzScWDkDDOywxZWQ17/OOStKP77zvcGI32R+YaJUClGaTnhdngvxX4skbcEZitFuRqlryygI+HuJ0LyZSznFMKhTKWWUSvsUXq5SDqvmtG7eDG9VHINfW5wy4J5IO5P4eXQpY9CEgzpphGQzR/fWU5oK3FhBZkDCRq5tJe1IQA5iS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(346002)(366004)(451199021)(83380400001)(8676002)(8936002)(54906003)(316002)(6666004)(66946007)(4744005)(4326008)(2616005)(6486002)(44832011)(5660300002)(66556008)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AGp/oPDXh0JEbQyj0KbyblH1P6hrleddlKgdUA7n8gi6y5qHiBpwWeHlRuKW?=
 =?us-ascii?Q?8LYLBmjdcnQzlbVGawG41WXbqCl91TowRHrqkp7HUKVmcIHgJF0gieKEk33+?=
 =?us-ascii?Q?OH0UbKkQHRZfMWNxJjhY/o2Qx9/TPnfQnYltcLDk0SpZRLRMaodE96PjXMvI?=
 =?us-ascii?Q?bUZAzmbm8g3ybol2SZq+dNjpFmN2d5bY/mevGMxTCOijzq+6ljQi0FPWyO3Z?=
 =?us-ascii?Q?SAs0RHJbgYXN466yivKInZ1r00XxVYZf5vpv2f4Nt/tYEK90SXYne5E7YMnm?=
 =?us-ascii?Q?8TPZcDSMgINVD/JtZVoRZcyx6yakWlJF1IgjikpovS4V0RQq28s3O3vnjgTW?=
 =?us-ascii?Q?XPrPkMweINjmcYgizblsxy/hM+jK8amIRKOizHwqEgZxlOaVUaUE+tZvas1S?=
 =?us-ascii?Q?QSDck0U1it2BhvCbVQ3JpHvc2lVMn70H0yc94CjeNcQ2C382QSImql+NtBWx?=
 =?us-ascii?Q?c008txgIC8fIl7KbFJql74U88gcukagQ9ydh+EcPSR01hraSd9idIcNwGy8s?=
 =?us-ascii?Q?l77nvKNGsEa0rVmJt1hptF3+pI24K4FjiHxW0tVVf1lr1rbh7gnIY8xw4o9N?=
 =?us-ascii?Q?qwSATbyoKGZQWmHnLqVZeXU68e4SsSFmz5cNCFtvwFtX3OP54Nq03hOv2n5S?=
 =?us-ascii?Q?Uvdin1KawUZ4AnqjZry6ADjF27T0MZ2Pnfu77J51bqVn/eyqCpPNbpEf1/O8?=
 =?us-ascii?Q?P46xS898rECkkF3wOQLtWy0prjGBwrNSAsjb97CyvswI1IcKZwbhwCf5FbbD?=
 =?us-ascii?Q?juBuvg9T3ZMwcyi2tNsEvgy43JWSfHWDoVVIeKGy7tdb1yAwGNr8EGbIBjSC?=
 =?us-ascii?Q?kO9Nd/BNYM2XZ6gSNiccqhHMEJpgWXEZyBUyP4biIoJUKls+qHFjrv53Ihho?=
 =?us-ascii?Q?QsWI0C8B3QGGVbeXzZXIbksV2sJWOQ6zaCqKvdOv7fEqFUpMQuZ9dTilybTl?=
 =?us-ascii?Q?xMF3kSRHaWxzbJJVw89M/+exjKjU0rdLv4E4iYNO/go7fM/GoV8KZNNJqMIH?=
 =?us-ascii?Q?1iibaEcN0BKSpgXN8wVYmuL+ibyMWOQqPLqrkYMl8cy9Tnuox90PGU3wBDaW?=
 =?us-ascii?Q?vyrk0RAn6ENhgz+RP0k1iSHz87m+UHxgwiotWDwdymAlnJwnof6vOiXQ4LYh?=
 =?us-ascii?Q?j/f2KR9H2JzEMXD1jrZRK3F+jCQgO5w5O2Q+C3BKjtIwZKxbNbJOi/bEaAqo?=
 =?us-ascii?Q?OKehqs0IwQkREllUQb3+PAUSutUD3Ny/9t1S4z/Qyk+Y6dP3R3Oitn3Hj2M5?=
 =?us-ascii?Q?C9o3WMqoNpK8ry6BqW4ooB24sFbObmIQki8sVCYqrHujFxo0Lf7+/ifIoI6F?=
 =?us-ascii?Q?OFihIyfKccAbC6HxQQTVgq/8VCWG5YaSTV3XrXjg+GxFxjou+Dx29yAroTWk?=
 =?us-ascii?Q?KV5rIjlMgvhmXXXMDiG8Yivmkpha2WHha8On7uQY7QcZM9gVRJdkrxBh2M/Y?=
 =?us-ascii?Q?uyohpb7VwflP9b/0btXuX3w5izfYfv+ItflKz0ZAA2e6fUjxB2b059ZqvUMQ?=
 =?us-ascii?Q?uBEf+z9cXC+4V4JXtfFQ6pMLC8t+RaziI3Izy5ljb10994JrqYmc+nKIJKPy?=
 =?us-ascii?Q?LK5w5RjaE4GygdfZL2Hc6Y+5R4fpGLUAw1M8Pk/4Lb4rI3PDp/dAgs1Oysv0?=
 =?us-ascii?Q?G2DKnw+YBLBuiagfimefOxoWyNGoF1tvRlx41BtoVH9Wx5UGM/DQ0usx1D6K?=
 =?us-ascii?Q?s5c8pA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0210482c-cffe-490c-a29c-08db52084292
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:12:43.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1K7T86NqTlJmh9sMj7gp39Rdxg/WK4dGYEnYABWOwG5XX5ZOJmRyWjuR9Ld3tXVeRmIIWiduBG2N7jPrwwDtm4WlZQl5+rT4alNX3Wukw5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:23:16PM +0100, Russell King (Oracle) wrote:
> There are a couple of locations in the code where we modify
> sfp->state, and then call sfp_set_state(, sfp->state) to update
> the outputs/soft state to control the module. Provide a helper
> which takes a mask and new state so that this is encapsulated in
> one location.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


