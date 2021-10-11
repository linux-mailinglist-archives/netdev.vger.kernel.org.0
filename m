Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3794428E6A
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhJKNpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:45:21 -0400
Received: from mail-bn1nam07on2058.outbound.protection.outlook.com ([40.107.212.58]:44807
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236926AbhJKNpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 09:45:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4IbFoRPJsKHet6OPeZ3Uyc0pOJsuGZ//5dx4en15YhXQwUVEQdeBi3QHK+jSZErdLZsKdcrWNU1yACpHRWtXimovgJbnADsunInVI218BZhTbjzqGaK7w+Hyd4d9HO/Ke4eZ8PEOmHDHd2VAzf8ze3bxkoUZqDmHis1eiZuGpFdHIdtONZRfkBD5hv9DAfpTSEp/WQLhgEVi9bat8I5m891Uq0Qntl3bv1nL8lLLVnGYp0WDAnHQwbjQ3j8VtU/9PiFxezJHRD5Y3VGWqmLW+m4nYISmnpoxsNfuCS7gPuQzZvXyj0JaBrHshrjoCchpJy5Oh1Xht5xFRz7uD4/bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slf97c2ubtue+57bS4WuQliAi2vWuql0ZkvkPGyvM50=;
 b=C0OmTiIqkT5nD5isIGjH+LDoj7Nq4J4DYYG+iIK2tkVYtTF5Z/bqLUdf0gZiC6effQVeB08RCQBacHZosTHqa7QdsrWPLlTWMV88qNkb7J+QSCd+i+4BIupyfqdj5SmnNVTvhXUDYN7JJMqGEkFwFfxsYaao4gUlQg+Pyp5ISZltyh3EfhzWpS5vm0ZKxIFNmpTNdOnWpbNLciTEjVz0tKtKizO5gkV08anZz5lGJC/Zn2TQ4PGxcDQji25WJwAw+ptVlJdhgyA8dATGdSa8RWlTVgMYa2TuO2E+aQZ+SNPZaELI2bO/LH38dPmHxAUp0uYQKIZvC3B8c0Lt2jvoMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=plvision.eu smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slf97c2ubtue+57bS4WuQliAi2vWuql0ZkvkPGyvM50=;
 b=Uzub05RgbyFVpCfFlc1bV3j0MPSWCRONzRC96CFh9Tz2r7n5HMCUM1HrpYf13lXJK5xOw7p9slYZCY5ITfJ+aZLhB0w74dTSbwtVLFkbIjrJ6kS1Q22f/gVaNam5F1hgogjO223ykMesaNOJi/tQy/jFw68D2MsW6cpCN2daiY2LAYWsT5wc1MIB+ykD5mvw7dNwrLMCg5pTT6cy1aW8+7kuGlkAaO54dtHtVPQYsVIyCpo6+DHdGs5jGxOoGazkTqorqQNIgenqop/LagqosqKG8Mwm+GAv+fuVy8JL9F5XkN92O3/cUNjX9/iIhftNKOloVTMPArUI65McF41j5A==
Received: from DM5PR1101CA0007.namprd11.prod.outlook.com (2603:10b6:4:4c::17)
 by CY4PR12MB1384.namprd12.prod.outlook.com (2603:10b6:903:3d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 13:43:05 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::da) by DM5PR1101CA0007.outlook.office365.com
 (2603:10b6:4:4c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Mon, 11 Oct 2021 13:43:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 13:43:05 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 11 Oct 2021 13:43:02 +0000
References: <1633848948-11315-1-git-send-email-volodymyr.mytnyk@plvision.eu>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
CC:     <netdev@vger.kernel.org>, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        "Serhiy Boiko" <serhiy.boiko@plvision.eu>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] sched: fix infinite loop when creating tc filter
In-Reply-To: <1633848948-11315-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Date:   Mon, 11 Oct 2021 16:42:59 +0300
Message-ID: <ygnhbl3vbrto.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebf925dc-d9ac-4320-9512-08d98cbd0d6d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1384:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1384912209F7C646865E35D7A0B59@CY4PR12MB1384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RBtMNN+fuOHcrbfHEYVPpetXtfJ68ULkyFJW8Z2pWZMPxlhT5Bdi5/titP7AWupziOTWSzs3uYoQ6cvGHvVBCqqAJCg/RLGLbCj6YLFfjIJssml+aOtq9/dF2ydYgjRee8Z0PgjK7gCwL01ss7zIp1SFXAsOhz5NcjO/AQhBrVoRsSZjZEoWZRrNwRoZ0Z+tYyNEr0JZI1+B8+qPfojcgsNVDGYeg0vbslT1mIL6UVEchR3ekURHjQey16bU2JX77w6v4TnTp8ufU1kroyLCk34SjvqxwegZFQr5Qzsum94PcnNhRLTXQl73CDqwOpd0iP+bxO19wA9zYDZYhEI2IHp1HRUijIRjq5WrAngoNndmgaHeZLf5EtVckaHf35rc2VuYOqtyxM6LEAVF5V7ewf87SZAIoc0+/Pw4htY8DoTmye1gB8cljnED/CV6ynxSQ2ClHBs9IxGPl/ICLOi5cp93Oc6jL+QKKiIl8zJndi+BLiqukZzEk7UIhSf2eRb8eK6xRmUA3mY1EkjAJ9Akvz/uyeXg8y6fxiJ5EUUDTK1nLMpMGyUnxS9KDwGhEpU4MMY2TvAByK2d7wBRDHJpF4WT6NmhXI/qqGUfexyYo6yrk4AkamHThGZXhJQ9vxl5iGLB4jj4OposYn6WLMUhmoHRZMFJJkKjvp+LwxWE1AhaDNmcFVDE8NvjZirrRzeC+UjrjUNEeVvilm5VrDTnQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(26005)(7636003)(82310400003)(426003)(2616005)(186003)(336012)(16526019)(6916009)(5660300002)(508600001)(2906002)(356005)(70586007)(70206006)(36756003)(83380400001)(36860700001)(54906003)(316002)(6666004)(86362001)(7416002)(47076005)(7696005)(4326008)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 13:43:05.0469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf925dc-d9ac-4320-9512-08d98cbd0d6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1384
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Volodymyr,

On Sun 10 Oct 2021 at 09:55, Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu> wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
>
> After running a specific set of commands tc will become unresponsive:
>
>   $ ip link add dev DEV type veth
>   $ tc qdisc add dev DEV clsact
>   $ tc chain add dev DEV chain 0 ingress
>   $ tc filter del dev DEV ingress
>   $ tc filter add dev DEV ingress flower action pass
>
> When executing chain flush, the "chain->flushing" field is set
> to true, which prevents insertion of new classifier instances.
> It is unset in one place under two conditions:
>
> `refcnt - chain->action_refcnt == 0` and `!by_act`.
>
> Ignoring the by_act and action_refcnt arguments the `flushing procedure`
> will be over when refcnt is 0.
>
> But if the chain is explicitly created (e.g. `tc chain add .. chain 0 ..`)
> refcnt is set to 1 without any classifier instances. Thus the condition
> is never met and the chain->flushing field is never cleared.
> And because the default chain is `flushing` new classifiers cannot
> be added. tc_new_tfilter is stuck in a loop trying to find a chain
> where chain->flushing is false.
>
> By moving `chain->flushing = false` from __tcf_chain_put to the end
> of tcf_chain_flush will avoid the condition and the field will always
> be reset after the flush procedure.
>
> Fixes: 91052fa1c657 ("net: sched: protect chain->explicitly_created with block->lock")

Thanks for working on this!

>
> Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> ---
>  net/sched/cls_api.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d73b5c5514a9..327594cce554 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -563,8 +563,6 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
>  	if (refcnt - chain->action_refcnt == 0 && !by_act) {
>  		tc_chain_notify_delete(tmplt_ops, tmplt_priv, chain->index,
>  				       block, NULL, 0, 0, false);
> -		/* Last reference to chain, no need to lock. */
> -		chain->flushing = false;
>  	}
>  
>  	if (refcnt == 0)
> @@ -615,6 +613,9 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
>  		tcf_proto_put(tp, rtnl_held, NULL);
>  		tp = tp_next;
>  	}
> +
> +	/* Last reference to chain, no need to lock. */

But after moving the code block here you can no longer guarantee that
this is the last reference, right?

> +	chain->flushing = false;

Resetting the flag here is probably correct for actual flush use-case
(e.g. RTM_DELTFILTER message with prio==0), but can cause undesired
side-effects for other users of tcf_chain_flush(). Consider following
interaction between new filter creation and explicit chain deletion that
also uses tcf_chanin_flush():

          RTM_DELCHAIN                         RTM_NEWTFILTER
                +                                     +
                |                                     |
                |                          +----------v-----------+
                |                          |                      |
                |                          |  __tcf_block_find    |
                |                          |                      |
                |                          +----------+-----------+
                |                                     |
                |                                     |
                |                          +----------v------------+
                |                          |                       |
                |                          |    tcf_chain_get      |
                |                          |                       |
                |                          +----------+------------+
                |                                     |
       +--------v--------+                            |
       |                 |                            |
       | tcf_chain_flush |                            |
       |                 |                            |
       +--------+--------+                            |
                |                                     |
                |                          +----------v------------+
                |                          |                       |
                |                          |  tcf_chain_tp_find    |
                |                          |                       |
                |                          +----------+------------+
                |                                     |
                |                                     |tp==NULL
                |                                     |chain->flushing==false
                |                                     |
                |                     +---------------v----------------+
                |                     |                                |
                |                     |  tp_created = 1                |
                |                     |  tcf_chain_tp_insert_unique    |
                |                     |                                |
                |                     +---------------+----------------+
                |                                     |
                |                                     |
+---------------v-----------------+                   |
|                                 |                   |
|tcf_chain_put_explicitly_created |                   |
|                                 |                   |
+---------------+-----------------+                   |
                |                                     |
                v                                     v

In this example tc_new_tfilter() holds chain reference during flush. If
flush finishes concurrently before the check for chain->flushing, the
chain reference counter will not reach 0 (because new filter creation
code will not back off and release the reference). In the described
example tc_chain_notify_delete() will not be called which will confuse
any userland code that expects to receive delete chain notification
after sending RTM_DELCHAIN message.

With these considerations I can propose following approach to fix the
issue:

1. Extend tcf_chain_flush() with additional boolean argument and only
call it with 'true' value from tc_del_tfilter(). (or create helper
function that calls tcf_chain_flush() and then resets chain->flushing
flag)

2. Reset the 'flushing' flag when new argument is true.

3. Wrap the 'flushing' flag reset code in filter_chain_lock critical
section.

>  }
>  
>  static int tcf_block_setup(struct tcf_block *block,

