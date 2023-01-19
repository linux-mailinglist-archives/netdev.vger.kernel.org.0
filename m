Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4595F6734E0
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjASJ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjASJ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:57:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874F353E41;
        Thu, 19 Jan 2023 01:57:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBCScU0eiMneAYc1pWNC3CqzadxmZEs7PtUYydCX3f7OxiESousi61zgGi+pWegTRnxPRprh6JLJbDCdj7uML7o2AD9HMHz11xQ7Bi9upERmhDdVvAHpqX/IBIJ+wGdwiDwRn+2DwK9MXBszs4GaTLFPvsN5YJFYeQFdbxBKO3+WJ+jjPlx0nukx3OPZDezjFcTxOQhdIRMH1jB6T8/IIbRxg0EjaCNAzrsral89WWNnb+J3CPvCM6onJ6gvoTN/yp/NItmUJi56iwsBGdjOndc8MIObFRb21Bs4HBI6Nob1LcWA3l+6ERblJfofPIStFUXeep0PbsNIVOls+MZ5tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dMSwUQhxfRpGyrIiU21/dIrpmE6levGqyd7jrli0J4=;
 b=TXKsqGpBfcSNg3pOyqk/G9T+45d8cn/3LtNWlNwHJ575WAnt8LeSiyeFBUMwhfHnHKphWUMdfNEycc7xU/JosUJMmhJkK4z7hpOfPtRL201mgfOf8GLvq7XI7A+LpTeXB8Pc8JZni4O5RGDqd8gL67EUc5pe9sGUPzejMM3HVhE8wT7+D/dprEJdieF5CIkWJNwwvbXxQA+DquGiX/e7gq2nHmMwMQVSl99Sc86FrCq1xABbbVtzNdSXgrBnh9ynBLbM6vy0m3r5OmnRL9kzK89F3Ciy2kdrL7wEH6JNSnTey2LHtZ9T3c3oILQdekSZEtLmqKmLcD4vOz+Q5qfVSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dMSwUQhxfRpGyrIiU21/dIrpmE6levGqyd7jrli0J4=;
 b=n+YB1fy+doDHyblGT3FhbMTw0+FSsY2dsmG3iypzu9lyKISlMRXusRkjFHNK78mmCFxsegs4Eqm2TgusXd3ds7Zked3FkzYYCbbFe7U7ysT27y8kTjIkPadD6FRmQmHgAexXGLcTnIQpKUztmYyAf/LNB7LYGjdZdBuDR3AVCqpsUQemKGSYV7PLzYILxmF9JvCkIwhyrLDwY93vAuDyV6hIbpBj/mANyuJIvPyIxKbP10uFJzTcg9W7GAc/NjCa6tW0SnTZhjhWNRAvB/uBL2yd7vsqlrqUhGvJllOerQz6exBMiQTiM+PX6hTnnMmxxiiARrU1anRcQ66TF/+6Xw==
Received: from DM6PR03CA0011.namprd03.prod.outlook.com (2603:10b6:5:40::24) by
 IA1PR12MB6043.namprd12.prod.outlook.com (2603:10b6:208:3d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 09:57:32 +0000
Received: from DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::5f) by DM6PR03CA0011.outlook.office365.com
 (2603:10b6:5:40::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 09:57:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT070.mail.protection.outlook.com (10.13.173.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 09:57:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:57:24 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:57:19 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-4-daniel.machon@microchip.com>
 <87lem0w1k3.fsf@nvidia.com> <Y8gLRF7/0sttKkPx@kadam>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Dan Carpenter <error27@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <horatiu.vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/6] net: dcb: add new rewrite table
Date:   Thu, 19 Jan 2023 10:38:03 +0100
In-Reply-To: <Y8gLRF7/0sttKkPx@kadam>
Message-ID: <87wn5i7soz.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT070:EE_|IA1PR12MB6043:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ba73dd-460c-47fa-d066-08dafa03957f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZExuoqVUHaxkUZoaoK3qooXrSQfT/x/adUgV++SLBLmMp5u1w++K8K2kXCVFBiCzxHh5mR0Dmb/pQb1vT48JW3iFiZX5Hm3YCziW8jjawEo8/WQ5FPIpkRAP6Z2zEA/BKlKnDQesFY/66gutRiBm7EC6vC8E7eWjmJHuRbKqEVj7P39GoCjX8XG/dJ4fWXYoeCqoKG40M6IUX8hDGJ9I8FY+6d6n2Oklnm+XlWY3JbwMvetkpS5fgshOoab/d3f9kCMWhC3/VX1znYAGGt8bkYZmdrUrArhYdgu7/8vuC8jYgE/GUv5q2JL9VhLBsyKI27G4wJwknmfTFrqmokUXUoSD+fqq8Jz0+x3fnMY/Wd0riWYIP6Ky/6GObUnc4dY37lipaHTCFrf3iraeUOSEt+IcsqieAhu5obNdX4YZDW71DSC0Ti1B26xZfHjITNfz6wnk6O4Rh+he+558fCmUxcnddfFadAoAd99zMh5oCAPzGXjn4Znt7xXmFP0TgZQxBKuzGGgGFTYLUyuTPLsy/Oj8C8FUIr7mqyclH8lBFBZ/kb6k+k/puf10Lng+/kvZ+n4apltjN96HWplZhB0SFp8jiEfrtDQr1SSiYN6U9sYWaO0Md2LppsU+Ciail7rZ/j9TQYavnfMLELjGMUgdE+Z39SM8dURRND9I2X7FAcl/kTuBGDxreO783xVFb7bRiexK3Sv2trHMBhF72E2Fg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199015)(40470700004)(36840700001)(46966006)(426003)(82740400003)(36756003)(47076005)(186003)(478600001)(16526019)(6916009)(26005)(316002)(8936002)(54906003)(356005)(40460700003)(40480700001)(83380400001)(41300700001)(2616005)(5660300002)(7636003)(7416002)(6666004)(82310400005)(336012)(86362001)(36860700001)(2906002)(8676002)(70586007)(4326008)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 09:57:32.4967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ba73dd-460c-47fa-d066-08dafa03957f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6043
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Dan Carpenter <error27@gmail.com> writes:

> On Wed, Jan 18, 2023 at 11:54:23AM +0100, Petr Machata wrote:
>> > +
>> > +	spin_lock_bh(&dcb_lock);
>> > +	list_for_each_entry(itr, &dcb_rewr_list, list) {
>> > +		if (itr->ifindex == netdev->ifindex) {
>> > +			enum ieee_attrs_app type =
>> > +				dcbnl_app_attr_type_get(itr->app.selector);
>> > +			err = nla_put(skb, type, sizeof(itr->app), &itr->app);
>> > +			if (err) {
>> > +				spin_unlock_bh(&dcb_lock);
>> 
>> This should cancel the nest started above.
>> 
>
> If you see a bug like this, you may as well ask Julia or me to add a
> static checker warning for it.  We're both already on the CC list but we
> might not be following the conversation closely...

I'll try to remember next time.

> In Smatch, I thought it would be easy but it turned out I need to add
> a hack around to change the second nla_nest_start_noflag() from unknown
> to valid pointer.
>
> diff --git a/check_unwind.c b/check_unwind.c
> index a397afd2346b..3128476cbeb6 100644
> --- a/check_unwind.c
> +++ b/check_unwind.c
> @@ -94,6 +94,11 @@ static struct ref_func_info func_table[] = {
>  
>  	{ "ieee80211_alloc_hw", ALLOC,  -1, "$", &valid_ptr_min_sval, &valid_ptr_max_sval },
>  	{ "ieee80211_free_hw",  RELEASE, 0, "$" },
> +
> +	{ "nla_nest_start_noflag", ALLOC, 0, "$", &valid_ptr_min_sval, &valid_ptr_max_sval },
> +	{ "nla_nest_start", ALLOC, 0, "$", &valid_ptr_min_sval, &valid_ptr_max_sval },
> +	{ "nla_nest_end", RELEASE, 0, "$" },
> +	{ "nla_nest_cancel", RELEASE, 0, "$" },
>  };
>  
>  static struct smatch_state *unmatched_state(struct sm_state *sm)
> diff --git a/smatch_data/db/kernel.return_fixes b/smatch_data/db/kernel.return_fixes
> index fa4ed4ba5f0f..4782c5e10cdb 100644
> --- a/smatch_data/db/kernel.return_fixes
> +++ b/smatch_data/db/kernel.return_fixes
> @@ -90,3 +90,4 @@ dma_resv_wait_timeout s64min-(-1),1-s64max 1-s64max[<=$3]
>  mmc_io_rw_direct_host s32min-(-1),1-s32max (-4095)-(-1)
>  ad3552r_transfer s32min-(-1),1-s32max (-4095)-(-1)
>  adin1110_read_reg s32min-(-1),1-s32max (-4095)-(-1)
> +nla_nest_start_noflag 0-u64max 4096-ptr_max
>
> Unfortunately, there is something weird going on and only my unreleased
> version of Smatch finds the bug:
>
> net/dcb/dcbnl.c:1306 dcbnl_ieee_fill() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1160,1171,1184,1197,1207,1217,1222,1232,1257.
> net/dcb/dcbnl.c:1502 dcbnl_cee_fill() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1502.

Looking at a couple of those, yeah, it looks legit. Those are missing
the cancel on error returns.

> I have been working on that check recently...  Both the released and
> unreleased versions of Smatch have the following complaints:
>
> net/dcb/dcbnl.c:400 dcbnl_getnumtcs() warn: 'skb' from nla_nest_start_noflag() not released on lines: 396.
> net/dcb/dcbnl.c:1061 dcbnl_build_peer_app() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1061.
> net/dcb/dcbnl.c:1359 dcbnl_cee_pg_fill() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1324,1342.

Likewise. Strange that each version reports a different subset. Or is
that just selective quoting?
