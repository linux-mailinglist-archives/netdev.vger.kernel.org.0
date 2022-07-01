Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04C5636DA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiGAPXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiGAPXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:23:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079AE37A31
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 08:23:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcIbOZvO+GKnH+axXk9+SPlgjx+sqZMkQ7kfzRuAIdw2t7I9yVN8k9Qn6KJQWLasGewKc25EGw6NnBNyY0r805qEVEGPimGzITFhZJ+nTzY7zrjjZhkzCVvpRI4o/lrSEJ3/ZvvClqEALxSSFMrcAMZa/t8RjUJYTQr75LzsR4IoRio+j0hZWuk2SKRm9YDIxC81aP0rEO8FGmyoqIVjeJi7zSfaOEHWZiQIKmQCIx4iF6Dggn9+vhzqYMbloJ+i3tQaQAnZCUI+Bg5fxNpPbzfGFawGb6Wy70gjCZ7iKmqPe/+I5E8odBHuRgQjIIZvvcelAGlrlab62NsYTwrLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFZMNwVhgvFicZc+cB8n2QlPFY+pm5ZF6nw//CZpTMs=;
 b=jHfLBh4t4/CJTv2puGbJ68ba7UxCa9Lr807pGxXwNcuspaMDtYE8ced2jxmeIAnHL2e3/apKqxGJtcHjjc1UbQsF8545SNasLDDomw5WDhFf+AOyWvNLI4gdt3lghtJirFnOSS6mCHTHlHs7VuCsNWjCymVoqdiekz8T8N3Uu5qRvtqKtC+4jgJHQ+DtJgoFKplXUHqgrjDJ9KhMKrytb54+tFxTODpRJE3oMIwxjBmzfIcgI3xTA1lPdp5EI2B7YSVHfzmL93PUzeSKog8kBCbI0fXO6l+dIMBsGraFAmMBtVzts1OunBnP+gSelIBTgeYWXCYX669Tue19agHSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFZMNwVhgvFicZc+cB8n2QlPFY+pm5ZF6nw//CZpTMs=;
 b=pNRihxfP15D79dhRIw++XojHbvMgDuGljaLSyi73JG+ExkEDW5WM78pJii5xjeNArSnmta90NQAvHvuJC1ZBoZ28km2G7rzj4qBE6bwA0GOMuCWuschTd/+fzFADBrfybp04uqvmKmyHMqz9X9DB7wCAjFbBYZzqWIX85rCm3sgtRIS2rCgtKrNbGP2ItQDUULV+YIGiQVuZGgYgwEgrxU7y1DCXAkXxaEu3dg0ztGGx6XThpF52e+DsTIb70jjzYGVXWT5Rtm1qrazkxae2C24sNbCRs44PCAn70UsaVZ7sahIcaFwAET25wDq2UE6XG1sQEP4zTwup84+A6X4Mvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Fri, 1 Jul
 2022 15:23:32 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 15:23:32 +0000
Date:   Fri, 1 Jul 2022 18:23:26 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 01/13] mlxsw: Configure egress VID for unicast
 FDB entries
Message-ID: <Yr8Rbo0R3GrxFSYH@shredder>
References: <20220630082257.903759-1-idosch@nvidia.com>
 <20220630082257.903759-2-idosch@nvidia.com>
 <20220630201709.6e66a1bb@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630201709.6e66a1bb@kernel.org>
X-ClientProxiedBy: VI1PR10CA0117.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::46) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51798201-b6f6-4248-4661-08da5b75a870
X-MS-TrafficTypeDiagnostic: DS7PR12MB5743:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7n+ho6H7/e2RBb4UPfJDnAxIk8pMR3iuqEI38+okxfsuilSJ4X0IJYG9wzblUtHxxN0GPq/ifsX2CeyOgkT5tFilTpnls4h430Bd5nXDY26zKynMxMBTAhZV3ekwGkIJOpiU22iHQYdFNFsYml5jjqQY1GW09sPQszkODL4Xm42Ro0MpsFY5DEeJgvuzoFW1HPmK2dddXpnniV3CxLLxDDMQLTjlkZzHz0Ei+5jckUhRjgsijcawFU81J4ExqNwSFv86O1d7WtLpOoraDMVmq0tEctxOsQkeWHIYAifHDVeKHhJd3USv9AApq7d64nvlFttOvGjkrTx59UVgATW4gIdwpHnQgCNYyQOBZ5IYo146cKbWG48nd62bvky5onzjSQrKWeqrsrnaqNTlkzxe0uMqnwHBzvd5//vKqmdyubIWnff9PC+noSn/GZ5bZcoCqQlmIwYawo890YHGDWe1YgKaE40UtQRG0w5c9kWz90QTN/aCjm4HYBz5Qh44hORakDDA0upbqj4OLj6eUZjZ1vbWr7VlV+bXNKdhvVjAnjIenGq/8+YD/jv1AQK9Uof0B//SaPbUs26Qp4Esg6i/h7SrHSWypmLrMu6/7NI/jxG6JxcyPJb2wgObA69p5lese7DTZzjQBC2m4nThlafOlq+foL8fCdt9sTiY3g5jmdh9uzjdnznkd+Sq36Hh7trKC2NzERlMKLe1rEFIgydLhb+yHjU3yFyAkwGZjX4c1Zg89jnrgE5p98iZ/zirohCYIk1CPbTW4jFquDpnpbzXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(376002)(396003)(366004)(136003)(39860400002)(83380400001)(6666004)(33716001)(2906002)(6916009)(66574015)(66476007)(86362001)(41300700001)(4326008)(66946007)(6486002)(478600001)(5660300002)(8936002)(38100700002)(9686003)(6506007)(26005)(66556008)(107886003)(6512007)(316002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aNWgyYJ/DlVGVSwO0AAEWGhG9LsRwbwrU0DWHQ7B6bd6CGQFuUaabb/G6gRv?=
 =?us-ascii?Q?3roH60vLbFKUYTWyeLCvsycYZls7lSYq1le4tE3951KXbLhfUEVk0V6oiXBH?=
 =?us-ascii?Q?Hz3RgiE9Phyw3lksaIP/IIlOlrygejCvEKibFcgTalvm/ANIQ58PMdivls/V?=
 =?us-ascii?Q?FXzHOnD8EZj4KGjj6QxSTuomdjyhs9fs0nzXTDuSVFGKnr6Ld44w2OqR1uob?=
 =?us-ascii?Q?elKCJt8q1azku/nCmaP58+YQajEn28ayUQEGYteoo2ro7pvM6QBgeK2609my?=
 =?us-ascii?Q?OgvVbCI5PUAOfXBo8SvM7vcsc5HQ9nASsfk4kUP61Vtrl0C0KMdNt4S7r7PN?=
 =?us-ascii?Q?TK3DcjdhKh59pnq+/tEsi75CMOnjWUIO3IxuIMkQbvGR8nzzE2L5e7nQGC7I?=
 =?us-ascii?Q?TjDmI1UkUgVHrBTGpLt92bU0BYq1omFx0iM2G12J2BiKyQXmjKPB409pEzhS?=
 =?us-ascii?Q?pWaa2FyBal/NSAzLNWoJTAEW+DqSAkl4zroSgrTukMVCNPT6fVsm0HI2C8Jl?=
 =?us-ascii?Q?TLPHiGr3RwUKTz5k8pdxeeQjj7QpwLn9Z4fIy2GBzWxA+pNKZbbosMEjLB2m?=
 =?us-ascii?Q?8EYXmxvDOH/xHTwxYa2X/beQvgBrvTHsyYhtSt7821Lj32usb3zCYZaV/1am?=
 =?us-ascii?Q?Jeo5gZUcVNX/UEVw1ZZoofZfSuF9VkLahSSUs3eum3dwXEQm2gamtUTa7lxr?=
 =?us-ascii?Q?DIbLuwQVpCosRqbJIM/n7zYo1/7IwnVcJLfAiBWF41AzU5uLNWAMyr5xM98w?=
 =?us-ascii?Q?q1qFxyfRh7zMk6qyoH2u1X+4NPK/WPXN2EkvBI85/2Vf+d2JwLYz5Bd48A+v?=
 =?us-ascii?Q?zuKUoUQk8Q3AI3jd2eJw8d3ITlPeN3fcA2fHhTvKrQEeygZ8JM8wVGn2VEJc?=
 =?us-ascii?Q?TrHqrU8reb921ERgmPupZ5b2K5J2Iye1O95NurJygaQ/50LETpltfwbYkRTH?=
 =?us-ascii?Q?UES8BrSR57cHY6ZV15zm6GQktYShy0PPeK16GVbks7UUYam3tvF1ER/2CwZi?=
 =?us-ascii?Q?Mpe69fqXPHIOwaKthWuy2SewQfrfz2/ZnkZZKxElX0iPSnw6mcmAoXf8fzud?=
 =?us-ascii?Q?TVjISog+bN/erEPN5wYkjVSQBzi2EBC5rBc5wIpGkFEpAKA0GiSSvnhbCIgR?=
 =?us-ascii?Q?plz2V7NKHtQoj8FdbjV9Wva42+/hnyiv/q0IsP28/VTaAjZl2eIspoqcUc9x?=
 =?us-ascii?Q?LRzUAcRoMZKFJFY0phbjXlSM9P627IiQE9SBWRG6oHHNOq9gzL9g0hyMUQNB?=
 =?us-ascii?Q?4eUX4I7a/WBQOy16sYztYpwPzGmCCEvky7eJzybM4wZ3PrjJBvNH/RKZFhd3?=
 =?us-ascii?Q?MJwVQHo2cPFYEoGHveL/3IMvwnAzdJOquUXcBTAhmEeK1mWHZTgEDK9FIU3L?=
 =?us-ascii?Q?rEmgAdGZSx2h9W9CrYjipP2NYkkpAT3Pe9ibYScq7QYeifAU7deomtr6Cgas?=
 =?us-ascii?Q?b/I9bQoV2a57m1Cz6hZzi0kUZmX8Ps6/9Gj/X11PmvYng1BIUqNwIXQsi6VJ?=
 =?us-ascii?Q?aMNf8KHZ4ME0rFqNWEnRFU7JczEGeZriguCi1vmKrq4FjAxDYQvvid/bwuUq?=
 =?us-ascii?Q?GOmy+yuQnYHe4yZdWrc+YQnxnBMtXC7gs4KAxeHm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51798201-b6f6-4248-4661-08da5b75a870
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 15:23:32.2671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXSSwBvxBCuM1nCprSk4ixyIJLlYiNOrY7Xy4RdFiBBzakOfrlPuA38manyubqK42VcUwNdSecz3FCIf0LT2Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 08:17:09PM -0700, Jakub Kicinski wrote:
> On Thu, 30 Jun 2022 11:22:45 +0300 Ido Schimmel wrote:
> > From: Amit Cohen <amcohen@nvidia.com>
> > 
> > Using unified bridge model, firmware no longer configures the egress VID
> > "under the hood" and moves this responsibility to software.
> > 
> > For layer 2, this means that software needs to determine the egress VID
> > for both unicast (i.e., FDB) and multicast (i.e., MDB and flooding) flows.
> > 
> > Unicast FDB records and unicast LAG FDB records have new fields - "set_vid"
> > and "vid", set them. For records which point to router port, do not set
> > these fields.
> 
> clang seems to have a legitimate complaint:

Yes, thanks. Need something like the below. Will add clang to my build
scripts and see if I can get nipa working with our internal patchwork.

```
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 6fb7fafdd2dc..352998d8e56d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2931,10 +2931,9 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
+	u16 local_port, vid, fid, evid = 0;
 	enum switchdev_notifier_type type;
 	char mac[ETH_ALEN];
-	u16 local_port;
-	u16 vid, fid;
 	bool do_notification = true;
 	int err;
 
@@ -2965,10 +2964,11 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 
 	bridge_device = bridge_port->bridge_device;
 	vid = bridge_device->vlan_enabled ? mlxsw_sp_port_vlan->vid : 0;
+	evid = mlxsw_sp_port_vlan->vid;
 
 do_fdb_op:
-	err = mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid,
-				      mlxsw_sp_port_vlan->vid, adding, true);
+	err = mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid, evid,
+				      adding, true);
 	if (err) {
 		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to set FDB entry\n");
 		return;
```
