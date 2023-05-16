Return-Path: <netdev+bounces-2906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B2A7047C4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1410281581
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0854120982;
	Tue, 16 May 2023 08:28:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95001F94F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:28:02 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2119.outbound.protection.outlook.com [40.107.93.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A401FE9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:28:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QT39n8Q6Sx7M1Rs3+d7UB0Om+3NU2YaQLs8Tg7aSqOeYQiY0NgVVyMILoTtXbKUIqEyKEmvovPKDCU3XGV4rK6LnVzZ/KhGEezTpCODniGsHR8KVjdeVuUVi+Qm7+hJzt8gcxYKRmfRuFeUCN55R0b2tQsZ/y3ZIuK2KXyvcfhMDj/onfx8baJWlhuNx9mmQ5R1PNepytLViL5EsNJMo+VrgZDv2nTK0R9RKztsL9EsjS3i6SC2JUXBnATOByQxuwIIyu4l9UAgJY3vozfdYlF6B8lfuEpr0EUaPKLxtBG/+YwL7ivPjPiKQbf2hdC8t0TBdj6GihZ45nQv/TDHj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j48BxXnn9qm0DZww2GSvE1onoRJ6N5isOjjfLqbuqWY=;
 b=dcXP604Gd//tNCxiW+5hTKtO/EuwFkkviUJnHvA34qzWwwn4fL85+J4VZbQHmhN92W2qq1MUU8oMnRw3t2heC9sajtysc6aVfV5Ca3RBnq1Y1KPXFfxFSAJsXIINcoea7zjUA4qr3qvIJPZ2llJ2jXgDAQOA+ZgLBBkDyaHgQ9lUDSq4nBZeTM58joIUbQoOptLi6ORnCoRJMmkZrh3fc18IIGMzy/4zg61T0FlVuA3RDhtrBW3t1nJKFGaMbCXIw4ZGeivceTgHjL6DxXLgteNmIC7pl2HvSCmc1hU4pHierPfYfels7irY6C6JZcsfLnmV9trWvL0a1Ex27kM79w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j48BxXnn9qm0DZww2GSvE1onoRJ6N5isOjjfLqbuqWY=;
 b=CxL7uKTQNDBYz1D0U78FHc45Pj68fGN2dDXei0oTEI4m0vMQFnJBGaowIn1twJ7Tq7tb8DoTNMfW+v7W8gU3no9FOtu2bitwHXHM0TSFoJI/vBC4y4w4cziyQQOyDcWfj5QPxjDgtnRMihFzhPeeTgcvpsJTODcgekyVASdzwc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5774.namprd13.prod.outlook.com (2603:10b6:806:216::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 08:28:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:28:00 +0000
Date: Tue, 16 May 2023 10:27:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, jiri@resnulli.us,
	m.szyprowski@samsung.com
Subject: Re: [PATCH net] devlink: Fix crash with CONFIG_NET_NS=n
Message-ID: <ZGM+iu2xLGsZCOE9@corigine.com>
References: <20230515162925.1144416-1-idosch@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515162925.1144416-1-idosch@nvidia.com>
X-ClientProxiedBy: AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: e2113a1e-283f-4d3f-898c-08db55e77574
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K0q1u8SmXZcxdZeRifLIxvuwEquncLvzdZRFsH/9PG9MzGOdCKSInGblBzHzzsN6BcZDU0vAa8JtUpHKKYjpI2kZ0U/SltNgetpbUyEsP8713xppYa1NtFBRqS/nGlrQRuOAMIU1aMWsqiv6FtJ+q6kv8Ifioo4KhpCYqrJ4PgIgPj0yEmWU9iN4CM2k+dTxGpsTkYhsc2LJvv9sqtvQJj/tKf73j9JS4kte88Qu31mjOLwUrWsE2l4qBsqGBGW+nBc1iiLviG4qo3A6Db9bJ51AlX63+dKou7FQR5yKx2W6mTNaED6EMbA9xse30H3VpWKfmt9ARPmFMUjh5mQEiLfsyRxW4PUhIT73tZoIXBjiUZ3imf7V3hZsF2XO0iea4C/4xyhy6S5Yk1kJDroU/fV1j2dd1jo0GOgQIMpz8VJO90i2cTeg/BCL+wDcYWYpfWVlbO4A+oG6E6x1X9CUx2rqfNndyFhET9JvdNpno41/3xjCHVmDT6nCZ8bYph9MNAFpxojBkQYa/j3t5EOkrOpmAY8pqMFKY27RW0YmJBZdwg4Pt5GaZPwBWojUVwt5RQ8al/IfbNvv1u7PQIQ/lveikDUs24htlVQh24nFG6fFDGqDE5YUsSwSQNaPmwk+dFVGD98TPURERBqZt4P92Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(346002)(136003)(39840400004)(451199021)(6506007)(6512007)(186003)(2616005)(8676002)(8936002)(2906002)(83380400001)(38100700002)(66556008)(66476007)(66946007)(6666004)(966005)(4326008)(316002)(6486002)(478600001)(41300700001)(5660300002)(6916009)(36756003)(44832011)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q5SXbJCti69uLSKGRkIDidcX+1L8zuchjTOnQriEQK+xKNk2fjV0k1XrP0AS?=
 =?us-ascii?Q?Mz7BjjlI3NaQZB0jFhGkBjHBMOYYV4Uole9cHXdv9OBBHjLJpGWU/HBjCZv9?=
 =?us-ascii?Q?H/6pkiMBpnJaGzAx8i+BtmQjyuqVGSz50+pKElfAdW+IxnPquWa8/h0+5/45?=
 =?us-ascii?Q?uQYQtAeDjZP/6N4ugAcPMvL8KzB7odPzP1mnV3dnZbF2aUoyToe9O5aPP9N4?=
 =?us-ascii?Q?NcmEpvZ5Ese7UZrRD9sVN8oLqSdPbTt3Zv8NRSsWGMjoxyJmGlYgdoV1k7HN?=
 =?us-ascii?Q?B8usFqcHf85ewWYEaLMOPkUJpXDbyqV0bwbXTpv25fDKZoMMnzKUTtnA2yqV?=
 =?us-ascii?Q?+lgygUPB1U0wjrlmzWTTRJMEH6tvBExPCP6mztTbbI/gyJRsXN8LrmeGyPph?=
 =?us-ascii?Q?7EAvorRUyyS/MJk4RdjaA/27XjfJQd3OA8b9q5z/WF5GCaVacVmXrrX/67Xw?=
 =?us-ascii?Q?xnvAMCdzplLCp1jhU+DcSJF+GOltw7kIz1fhO+g6LrvcWlFM5bxmzVUBPOIy?=
 =?us-ascii?Q?d+9gI0aQoVvtlrGzy+/SoQQwCxUOuKF1oZirSgdL+7pYblcyi4TPlenweuvY?=
 =?us-ascii?Q?5yXjj410SVgJvi4rw2TusR1ctkPsK0MQRtyd5ny4I7LVXSf76AlOcOKXQoue?=
 =?us-ascii?Q?DE4iuQwg2EAYRIP4TSKd87yB0yQ4FGXIP06dhWUxXJJXJYcdXFXnzyf8ElW7?=
 =?us-ascii?Q?OF67is3iJO02eDyTKCHIRJjvJ65ohdkHc76ajZS81/bkMUlavqf10jE18OeA?=
 =?us-ascii?Q?d++L64doXLKSVB/vobZDabZyoK/8vJhdS8Fsdkm+ESVxmC4h/R40+nTPS4ne?=
 =?us-ascii?Q?dJp83OjEsbPD/S93pPuhhfY/3lap3QvJsyFKM4yyxxQ1pRx+LJYmO+S3V2SF?=
 =?us-ascii?Q?ObMJg2DI7Eaagrxl9Xe/Xmw0BUH1l0j5wxPa0NnPVUhpKQZUY8kcKodFeuLz?=
 =?us-ascii?Q?lvBJd5VMsNMySZaWn03+nMMBBrbh+2ixhh6VwCC2cLEoMCa8wvJ3HKCsEv9J?=
 =?us-ascii?Q?vhuIwVD865KWuK5QG5ccs2ok4cxz7DiYnY9LLnnFeWWZWPNCkM4aTn6Xs/mO?=
 =?us-ascii?Q?v/VOEvkG5Ik14IH345p6V0sTLhEIm3Z/PiCzS2MwdNH9I4p4IFJukNtNoR4T?=
 =?us-ascii?Q?VPpd2TzeJIMXCBPryo2Cg1+TnIIn4M9XIfGux+s4K05pWybP8d8NA7P9S1t9?=
 =?us-ascii?Q?15FOliysYF40lYxF1IBHIsgIta7u2frH7HuoRDsN0KqL0UwHLGxZ/84DsgYQ?=
 =?us-ascii?Q?RxG64S0tSp5vzbATb3eSB/ZgR4JNO0+e1h10lkupDsNNICJC86VoROZKnVNI?=
 =?us-ascii?Q?zh4Hm2ygGEPbnymgHRlZMzBFHewQmRvTienL9tB1w805zkPtS1XvDvYREB6Y?=
 =?us-ascii?Q?uJb4Lr7oKaVGlyMFUxMHVqHQqL7jMXMS/RUgwglOaf7NoGS4nn9W99sxGIkV?=
 =?us-ascii?Q?Pg8kyAjB720Opfsu5O1SZHIcGpEM+mpB/smujdk64i5bxmPJo7lnRW2l1oR+?=
 =?us-ascii?Q?vwEKqd6OqLTTFlP8MQgdcXofEGZV2lyPeDu+esbu2v32KgTy3AWclSF8f33Z?=
 =?us-ascii?Q?xBtubTvNZFLGidiauUOcvflQQClkQCoXe4UzGAT63qapcMnKPNpp4LAVv4mP?=
 =?us-ascii?Q?giWlTl3XnX6AqIdi1e1n1Gfiw/1/o+GOaNMU7XXnBfPn9MD0u+R/QzzdciFz?=
 =?us-ascii?Q?gBW/Rw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2113a1e-283f-4d3f-898c-08db55e77574
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:28:00.0496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TaK0SLsK2muyywoEQEA+sAWSf6HAnF6G10LY/F5zgHWTZv51Gyr8KTKLlMALcC+DCsg/rpeJd2wuVovm9NZiLmSRp9uLqy83NpD8g4orW3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5774
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 07:29:25PM +0300, Ido Schimmel wrote:
> '__net_initdata' becomes a no-op with CONFIG_NET_NS=y, but when this
> option is disabled it becomes '__initdata', which means the data can be
> freed after the initialization phase. This annotation is obviously
> incorrect for the devlink net device notifier block which is still
> registered after the initialization phase [1].
> 
> Fix this crash by removing the '__net_initdata' annotation.
> 
> [1]
> general protection fault, probably for non-canonical address 0xcccccccccccccccc: 0000 [#1] PREEMPT SMP
> CPU: 3 PID: 117 Comm: (udev-worker) Not tainted 6.4.0-rc1-custom-gdf0acdc59b09 #64
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
> RIP: 0010:notifier_call_chain+0x58/0xc0
> [...]
> Call Trace:
>  <TASK>
>  dev_set_mac_address+0x85/0x120
>  dev_set_mac_address_user+0x30/0x50
>  do_setlink+0x219/0x1270
>  rtnl_setlink+0xf7/0x1a0
>  rtnetlink_rcv_msg+0x142/0x390
>  netlink_rcv_skb+0x58/0x100
>  netlink_unicast+0x188/0x270
>  netlink_sendmsg+0x214/0x470
>  __sys_sendto+0x12f/0x1a0
>  __x64_sys_sendto+0x24/0x30
>  do_syscall_64+0x38/0x80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: e93c9378e33f ("devlink: change per-devlink netdev notifier to static one")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Closes: https://lore.kernel.org/netdev/600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com/
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


