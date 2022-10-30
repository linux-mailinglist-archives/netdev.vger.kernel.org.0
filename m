Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C262D612965
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 10:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJ3JZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 05:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJ3JZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 05:25:15 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070.outbound.protection.outlook.com [40.107.95.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EE32C0
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 02:25:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsbvQhyZJIkqQbFo3V85Dd79cme3tDK7UvB+xOsPb4VHfB0uW9lPzakgK5lv1z4kG/rXVDcB8nDJ/PvCMTzeAXeT7/Pi5a1bJ+QcrRPvqvX+lGj6qj6NXEo4fOO45RduEtW1ajymPaU+4DIVg0e/LNXQ8O9ZFJw1mfBczen5t8Po04CWc4u8AVAAb7MJ0SBvkalJ2fK13OrW6QR62gyitjHeBF6oOcEkT8qYvnTxR+VFKZbzmKLhF9TsuZ8CmHujA1kcmpD9tDO4tIJSIjy0fK4mnxF4fBG8kspa4rx5PEf6hiwMaKwkxqwgyz2t5FQ6rp0nETkm8bqUXj1Zy3FqhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLLxvZksRetjwjdMPvziNPMzngEJk9Xp2s7sxduq0Wg=;
 b=GspWMtH3puCttkRG1dIUD3D9N3hIb7PA0QrcmSzGtxDOEecknV5KXw9v/lya8LTwoPZ7QHj6aCPf/k6g4fq0J5cSj3QVs9B6kiNnIBIS7hDpfkOUwgo4080ZtktX1kS2jGXoLALpTUaGPXXTQP2Efe8EBAwlV0hL8pX80qxhokNaRG97f3dBagFzuTJFRCmFz90qaAQJBf87s8gxWZ6+3VA3JAfCLv0pCjixbgnzIw1JcManQZYNZ32LtF0NhQN31gDktxDyosrhD3g13P2Mmwg6aKKZSCMMF+sHhkU7iACxKSZSSxhWzfE63jzcavvc0ZWLjEgmp6dabiSCi4obPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLLxvZksRetjwjdMPvziNPMzngEJk9Xp2s7sxduq0Wg=;
 b=uM/4E7fPp7cGxVPjrF+c55MHzEZxvbJPzPj/RfPYuGNuBbeW6M46S9VcOiN6jFZMwUt+xF110oa8BV7q33LroJolBPQWMTOzcfmFTkmy5xWOEWK6KcoGdzN0F4WoY8jWvZJPVxhVwEWHkUYXVOR+4u9mzaGpHVy11J3Gb8hts2bhrz+4jPPv+l8wzr/79F/0GutibbVbegCBC+HdHW9FfnIBtBA271cMskXbTPqHCuSAHDGb8lsyWYK0wHxB+VsVNUZRZMh59giddqevC/ukYJiEjyxozUIgdxkiCelDfi9fX6gZMVDkToAVbdfPFVR+Ec5F16hLYkB4OW3mjscHJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4176.namprd12.prod.outlook.com (2603:10b6:208:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Sun, 30 Oct
 2022 09:25:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 09:25:08 +0000
Date:   Sun, 30 Oct 2022 11:25:01 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 03/16] bridge: switchdev: Let device drivers
 determine FDB offload indication
Message-ID: <Y15C7Uq0OoMTTv1G@shredder>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-4-idosch@nvidia.com>
 <20221027231039.2rqn7yeomk5nsx76@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027231039.2rqn7yeomk5nsx76@skbuf>
X-ClientProxiedBy: AM6P194CA0011.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4176:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a3402cc-f96a-4452-21f3-08daba58a2ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sTLpEvLNG2txNN0+I5wqYR/ztiEeVljumrxDG0/+ow+Lq9CTOYgdBL1GF4zNlIA3LKW52sYLid/yvLRdKxjuALcGkA8c4w8p+OQ8LdzkuM7DEuE4dhd1DyJC0R70+Z7vrBlyd++oPQtf1dCSh6vL1+nVDxg1oRSIpUsbU+wLXQwC+g3efz6v0vfHo9WHF3IieiiJV1h2PCJboUqaHnqdTGnmwYVDMzAhhhJOXzarHXL+N8qCCm/6wQQPQA9j+p8hmkq+Tp8b2d3pvWbeTQJBvmGcdAhMRSGYAoy6Bp71+ZifoozOd1rK/LAzuvdOajt9zPattP0SyvymH7XLAG7NbmjUUzbeIG2nYhaGkOB+ZKox+UoHAcmJkmHPzndAgYcYrH0OyTEnpDZDM60RS5w/mD2XBxYSUz9VLW8Z7ars/+VDyc0ptr8OKpSHPiuMEdsm1ROKq9bET85UNYFOlRruSPCy6oOEuoU6ghQQupohKrdZUyzR+iUV3PCCdgSuhVjqYBPHsVNHeYwGRZOVUAFXfC4dRbI91KOYve8nD36YDdG7PR79U5m/IjJsxUvtvczu+Msc52a3dTrOI92fpHmLEO0Egk8Quw7qVc3HM2/SZcdBezrl6XWov/7gMHHRf7Bd0yuZVL3iry+oLeyBiJiBjyYASLcuX5NtJR33ZpFB+/9Ag4Nh5SJ/6xfYUvYHKEyKtq9ip5qyER4u2MtZmwPtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(6512007)(2906002)(83380400001)(26005)(5660300002)(186003)(9686003)(7416002)(8936002)(33716001)(86362001)(38100700002)(6666004)(107886003)(478600001)(316002)(6486002)(54906003)(6916009)(6506007)(8676002)(4326008)(66946007)(66476007)(66556008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7XzGhJgR8oSAVQS1aitG1x1UyjnUBf8F5qKuAjqpVjl6jPVJ3iPJZlkCdhGS?=
 =?us-ascii?Q?43Ipb82/xOWEEJ6q2wOmHpCHMvi2D7gqlTipVA7dikV0iOP6DiEKeHtrVW4f?=
 =?us-ascii?Q?+GIHBKWPDG0tvUjvCtVKFYnL20DAM3bc9pIceU/YFwtpOUrOOavMZAKsFCab?=
 =?us-ascii?Q?zCCE+xOHpLTZpAaWuZnBHA9n1LyHhQzTtrks5SFIYICviBX6doTLhlL7oOUj?=
 =?us-ascii?Q?RPLiuNVwnROyfLBYGnnlFTcUvN5FD533sfHLwkYvnJezi+bW83SJC+d27I+V?=
 =?us-ascii?Q?YwlKT/JYWzqaNRC+TwNKLUU2/KnxC9SWmlmQ19RBSil6wjU3bYmBOKtba1AA?=
 =?us-ascii?Q?H3Ei4uXpmDeg30q/ErsrPS5nTt2fBOKnfVu1wyWmBDyKFskw0WSpragySBu9?=
 =?us-ascii?Q?nMwIRtni7SIU6dgojVzfh371RVPUaYZFP/ln1h0d0CBDrpl/xQmHW4rfi+Ys?=
 =?us-ascii?Q?ksKJ+QiwEaJPnKk/0jkz6ehys1lvawGb+xF+LbdwHlE3nRVI5u5fXOrxraRj?=
 =?us-ascii?Q?m05xdol+JnZcIjlXu3PjewG5GHrN0hV7bnN9JIZekokekFW65bqxzISFBczh?=
 =?us-ascii?Q?gZWJ65Loz6y4yl9n6M/rPmWs0WkrGJpaUPlj0lJlXz3ZgJB800mJUbYvf6pP?=
 =?us-ascii?Q?uMvZBRKfGEZcQ22CtXBXm2kLYVRc+yKa6bh2yyi6YJ8Cp3c+eh+g8gE1IQuk?=
 =?us-ascii?Q?S3TjM24EF/CEs4sPmBlc3Zchr8h/OfX3UmzlN5E8l13xZrKwDeAKIUQoUxax?=
 =?us-ascii?Q?6876Dqkc6wUSdXJBPVDZIqp68n/had10rjns0neT9hNNCRFbyrWpQqre7Am6?=
 =?us-ascii?Q?EqZN1KnDfjTLwXXRfxZNvDHmWbcZbDxVmJajSVRluzN700ec+ZSnOqQ8KJ6h?=
 =?us-ascii?Q?oAF/7u8LTx4Yz1lC88QrdoXYnP7L8h46SJGj/RQwAxYcde4Ndk3LtticrfHY?=
 =?us-ascii?Q?kx+/KhMNZaZ2fc7XZYpN0Y0fkbu2sHN/rANS8JXyKY/mlGXi4vyxrIZz9chp?=
 =?us-ascii?Q?n/hBqXeO5JDfP8RtPKoAv/2u7nU46s5MpWQgwPIuFfyK4lXUeMRCBxvHClX8?=
 =?us-ascii?Q?BqHBtS3uASWJMJH2T/ysT0pzUSiydP6C0wT/8TvWy96xiO0E+1bL13sHSvPB?=
 =?us-ascii?Q?s+3iKfgFEBtbZy1Ku3QAHk6LY1saeDd32SwZQ6J1wLpxZILHcFoLEUy24Onc?=
 =?us-ascii?Q?yzcwKqvtkyQR2y1cZNcr33u2VXSXOWykbtT86gRmBTFZ+bUnzSrmWWfSZSSq?=
 =?us-ascii?Q?T7dIMfeTZmMs49kej1mY2cI6x3/0Qvc6EjEgg3Q9zcURUOaqTuDDfzSitI03?=
 =?us-ascii?Q?ed1PVqKesBir70MdBYnW0KshWP4V2jiTh+9reZPSwi+SfoHuH23AKkSO80ou?=
 =?us-ascii?Q?yj/cQL/E6GZlRQDDVrrT1E2a5hUqkX4w9MbhgEsCSV3palzaruv9Bq3ztWgy?=
 =?us-ascii?Q?F7+DjtnDnS/0zEAOXp7ZV2X2z0LGz+XPOGM88tp9dOIz3yyWA9hDDqAoYEvj?=
 =?us-ascii?Q?kh9jRdEvhUNfJkKGVDFOIiiIczxq/i4kbNh3zYZPomsk4s6M+bFCPJ9R1RmA?=
 =?us-ascii?Q?bUs8U0mKXI8O7RAisvCbi8XA23z6KF+LNQJiuxrb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3402cc-f96a-4452-21f3-08daba58a2ff
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 09:25:08.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MdVMgQ5YNZdnn3FeUKc5yhYT71BzTbZVSJxZ6lYHLMTQy5E701TBYmQXKmmF5/F/jyZQKXBEWREsKnZ0UI7rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4176
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 11:10:41PM +0000, Vladimir Oltean wrote:
> On Tue, Oct 25, 2022 at 01:00:11PM +0300, Ido Schimmel wrote:
> > Currently, FDB entries that are notified to the bridge via
> > 'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded. With MAB
> > enabled, this will no longer be universally true. Device drivers will
> > report locked FDB entries to the bridge to let it know that the
> > corresponding hosts required authorization, but it does not mean that
> > these entries are necessarily programmed in the underlying hardware.
> > 
> > Solve this by determining the offload indication based of the
> > 'offloaded' bit in the FDB notification.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> > 
> > Notes:
> >     Needs auditing to see which device drivers are not setting this bit.
> > 
> >  net/bridge/br.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/bridge/br.c b/net/bridge/br.c
> > index 96e91d69a9a8..145999b8c355 100644
> > --- a/net/bridge/br.c
> > +++ b/net/bridge/br.c
> > @@ -172,7 +172,7 @@ static int br_switchdev_event(struct notifier_block *unused,
> >  			break;
> >  		}
> >  		br_fdb_offloaded_set(br, p, fdb_info->addr,
> > -				     fdb_info->vid, true);
> > +				     fdb_info->vid, fdb_info->offloaded);
> 
> ofdpa_port_fdb_learn_work() doesn't set info->offloaded on
> SWITCHDEV_FDB_ADD_TO_BRIDGE, the rest do.

Double-checked and this is the only one missing. Will send a patch.
Thanks

> 
> >  		break;
> >  	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
> >  		fdb_info = ptr;
> > -- 
> > 2.37.3
> >
