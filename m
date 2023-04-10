Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A706E6DC58A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjDJKKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjDJKKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:10:06 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2044.outbound.protection.outlook.com [40.107.7.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3C191
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 03:10:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5ffeJ28xJxQkvOEk56HHqBR16GMUb120pT/46vDjD4vvZ1/pvhf7xATLyicwt3EmMtpxfN9ct24djTSp1rxD5P23buhV1lD20+wHy1uyFKPdnUpFVqxZCYMGagvKQRedQbUbyLKGOsm8GEsfcM59tygS79OrfEXCMmj8UTPUEh8Y4HYU0u9oj+fxTB0JiuGVN51msz8wSO3ZK92SKd+Ky6yiwAS3reDC6bB/+970yNNXnMQeqcofUyd4X+KUisU0WAwNZ1gZjiO+voa4T/OsbnP4yEbJGeJVsJFIJwaqfOTpnZWNbK8zm8IYel60nOmpjlfV+cIZAw2KlMNxkz3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yuXUSD0rTrrFYJNjgdUTqwPPutyXQlFhuWcrE8Zn+qI=;
 b=Z6MDNVlS13pc3vAMLV/jUnMw3ncjopBx0bbX2pMG+vh4w/nFB7uZNXV+HxhomYfHouxyWTyj2YAzxb0L8yghkhML3fV74HzsG45uKJ25bFSItfs/+H5qBhrSCNANTn+zZOZbZ8YGKU1V7eK2p9lK6utNNcFX/ZuRDSELUZX/QBNrXJ0I6mDRMOiY60TIHC9ojmo/ZeRlch1ZPUBpHnHxX1xzd/SBLvw/6Fou2b2KEcM58XyRX9UnidZSjdl+Sm9JacjIs40XDUyZAq8iBBFjZvYIdi1Qnjurz51gdmaBN4kgS6QWlKy1y0RYEjAbBE19RhvCYtvue0gFDHwwUfw5VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuXUSD0rTrrFYJNjgdUTqwPPutyXQlFhuWcrE8Zn+qI=;
 b=FGsi5+VHQPE4xZQUJbLWmsP5GHIz6cXkFfyF01wOqJflgTTznL3MKzaZ09ORSSwnbScF/rvBcq7h80U9e29yQGDgBrLs6556gvCd3fQkytxqwVv1TYhsxBrvxk5+BkbGVKKNJsqqbHgkyQhbo8I35ywpk+eT90dgNL8bfFw7iuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6997.eurprd04.prod.outlook.com (2603:10a6:20b:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 10:10:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 10:10:01 +0000
Date:   Mon, 10 Apr 2023 13:09:58 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC PATCH net] net: ipv4/ipv6 addrconf: call
 igmp{,6}_group_dropped() while dev is still up
Message-ID: <20230410100958.4o3ub7yy7gxnzzpy@skbuf>
References: <20230406233058.780721-1-vladimir.oltean@nxp.com>
 <febbbc75-2cf5-1cf9-8ed9-6a42ff295ab9@kernel.org>
 <ZDPA1pv7tqOvKHqe@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDPA1pv7tqOvKHqe@shredder>
X-ClientProxiedBy: VI1PR0101CA0061.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6997:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c973f7b-1e13-4c1b-9f7f-08db39abbf43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adga1ogDTYoCCSGAoT9F4K7rwwnfA/Hu9LLRYBlpfRVjX9OUpMyE04tN22dAEFTMQEQtXkrJZ80BHYaLR26/5WLAEqwwzQDyuf83ivgW+3KEXcyBXl6ffLS+tR0OurEhjexn0pwreaBXJ5PGq2DGbyjgYOGN+0Bp9nnR1p/7JtLkGrV7IT+CQU+3NHUcHM2gxfbbvxbGGdAbJrpDzkk/qR6snKtYjSmEFB96N/2f7xlidpmPmz9js5AmvfdejZFAB8eSW2O7NjpSxdiOMJhPA07j3w7VX9BRrMCGZD0ObyXAosKkF3UZFMB+MdDw83KL4LKX72t829/p9/MYCwAer8QYXrf6nJ8QcE2QomuRwW+C2o+JvSw27npWUPSaiP9A425hkYIFOlGwuLg78hZjA4PI/FrVd8CzUyhEuNG6Pkerjt0inLT9XWAjj+XD/rUWlmgL/cbhwf0e3D/HIKt2AbYatfxjMLpkTyp2tCM1R3QRxiu1470HW1eJoAzH/4k/pi43MSFrxxt0pyWcTHZD+KGwOs984UH7/63CkgacH2YYFr9l03wYQkTI2wasw4Fv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199021)(478600001)(316002)(54906003)(9686003)(6512007)(1076003)(6506007)(26005)(44832011)(186003)(6666004)(6486002)(2906002)(5660300002)(33716001)(4326008)(66946007)(41300700001)(8936002)(8676002)(6916009)(66476007)(66556008)(38100700002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MHsF1yDjZsV/pxJFp29XprGZxIAe7mhez8LLIBeDSiCsDnwK0NfN1epvzDUU?=
 =?us-ascii?Q?w9H+g4khi30dSg9P1U5qU2XXINYO/f5qyZXvJrRPnw56KpoDt0gN9SKgVzK7?=
 =?us-ascii?Q?vuxI14KO8k7LZyNhAo3n0p/UWkWsBfuf+qo3O/teCA/8U+jYONFBpXzEZGPz?=
 =?us-ascii?Q?z9hIQ4jB9nnVIzIdA0R6yZuawiy0nDCOoe8FTz6AwgfMQSnveqOaEzgr2q+5?=
 =?us-ascii?Q?+PbUOjJdxX9xtVLWXI3c2HhuTkj38yq8gldhOzBBX8TlDYLz0KiCjWqlIsq3?=
 =?us-ascii?Q?H7ke9+Bz1/Qu18Tar3y0HnbkcOrn/UKJFqWI+HjCR54uTNJo3xEVvEMvKx6v?=
 =?us-ascii?Q?uISI58WcZRrk3mHMAu+Q2o9H+AfvVDpEebolwf3PSSJTXgHHJGEm+VO1jo0t?=
 =?us-ascii?Q?mL+Ge0hb/NdK+fLnDyRSF3+H2AgywcLLF3GE+j1d+EZBpajgL680FQ1ADHr2?=
 =?us-ascii?Q?uhQ5cIGEqpAy2+WFWPosjnXyuwu1zc2z8U1KFsdmUHfHuzXU/R8gXgt2qTRk?=
 =?us-ascii?Q?snzVom0hCSK0HO1LZ8l7RJYhRnt3/juxq2SGDfg/pzUGRYl2eNWBJu3g9I1p?=
 =?us-ascii?Q?U42vswKtjrICMf/TgFI0vEb7B/9H7VaTV6km3ZtmXE6uIKbmN8hQ2jeY5n0Q?=
 =?us-ascii?Q?cE9L2TNLYKsz7xSIChVy7zEJpvTdwOaG80McGGKk4l3VwP3uuAjF4r1OZgRm?=
 =?us-ascii?Q?qGSMyVgChqnDCsXt63j21yUSRgS0O2TU+6/UfkO8FemMnh9YX/MH6Lr5uEJn?=
 =?us-ascii?Q?pdGr/S+rEur3R6KkrQptHXvWnoYXmrqmaIrUABIDZGeN5d7NQeT+UnWSAVd3?=
 =?us-ascii?Q?NBs9NeDBLYtXM302y1WVp+68OuweFk2i9y9x10tj5qgFE1qr60ZyezigNal0?=
 =?us-ascii?Q?2uktUTkcpPxbgfROYCBzZKEQ0JyUzS4/vYbHV7eqyJRumBUQklQfNfwLlJNF?=
 =?us-ascii?Q?NunOk+sp32qdaPUKzzFVb9fYYfsKFbnS/6tsj1byDCTcR6IDtN+AmCO4hebQ?=
 =?us-ascii?Q?Tvjn660zVBRnOUt00jckljPl/0oNLc7CmWCi6fJvTozNTx5JDL0hClt05XMt?=
 =?us-ascii?Q?sv8x8dLoYMFNmnkIrXT8hGIWljyO+Mzrj7fzG5fCNZwfojkQOkpF33+OpJMt?=
 =?us-ascii?Q?HcKUQViPzQQ1NWWatlAXcJhpLYcQky+lR0WrVDS/7Jpe1XPyhu/qjIux3ODT?=
 =?us-ascii?Q?EDpR+fRHcX5C+Wi1gW4dvG7i3R+TF6ygudlGlbUdy2Vp3L592MjMMxxAJByj?=
 =?us-ascii?Q?J/Kr6lyXc9S3i+9z1uVcm50dmHAmljAfcRVjSRWgF/bUXHygUS8PTWyNmsea?=
 =?us-ascii?Q?QbxFIKF5DhsIMueYm1wvgKUBNFAyE6kVi+ivEAWZ3xeSy5S+5INdLebtFOOD?=
 =?us-ascii?Q?GWUjxKDJqyEGzZSnG3j0tcm8ZWcA1mtTGuxuyZeQzlRYE6FOY4qn1bhv0A2I?=
 =?us-ascii?Q?pxVwSTSBcBB+L1fCGElldwoyNpgpudESWrFgD4n/2u2yKCxqNw2F2Q2xT6yH?=
 =?us-ascii?Q?AdV98fjGRD3qEXOi+vH5k60ap1IWUok6bVMMBfaU5bmUxD5h5u9oG6Rn+CeX?=
 =?us-ascii?Q?3MgzK0Zk/NS7frOL3J1yAD3MLfeoMHdWY/XZnfZU8OqfMWLuq3/N+vCsdLvr?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c973f7b-1e13-4c1b-9f7f-08db39abbf43
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 10:10:01.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1nUlY299qx/cGZd4fUhcr+W5p1jbDSyoozyLZSlmYCGKrDWNjX9jTl7ynbCBoxfnx1fwClcdltVNez5PUwALKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6997
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Mon, Apr 10, 2023 at 10:55:02AM +0300, Ido Schimmel wrote:
> > > The proposal is to respond to that slightly earlier notifier with the
> > > IGMP address deletion, so that the ndo_set_rx_mode() of the device does
> > > actually get called. I am not familiar with the details of these layers,
> > > but it appeared to me that NETDEV_DOWN needed to be replaced everywhere
> > > with NETDEV_GOING_DOWN, so I blindly did that and it worked.
> 
> I think there is a confusion here between the netdev notifier and
> inetaddr notifiers. They all use "NETDEV_DOWN", but in the inetaddr
> notifiers it means that an address is being deleted. Changing the event
> to "NETDEV_GOING_DOWN" is going to break a lot of users since none of
> the inetaddr listeners respond to "NETDEV_GOING_DOWN".
> 
> IOW, I believe you only need this change for IPv4 (and similarly for
> IPv6):
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 5deac0517ef7..679c9819f25b 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1588,7 +1588,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
>  		/* Send gratuitous ARP to notify of link change */
>  		inetdev_send_gratuitous_arp(dev, in_dev);
>  		break;
> -	case NETDEV_DOWN:
> +	case NETDEV_GOING_DOWN:
>  		ip_mc_down(in_dev);
>  		break;
>  	case NETDEV_PRE_TYPE_CHANGE:

You are correct, only that portion is needed for IPv4. When I open my
eyes, I see it too :)

Although it would have been a lot less confusing for someone looking at
the code for the first time if the inetaddr and inet6addr notifiers did
not use events from the same NETDEV_ namespace as the netdev notifiers...

So, how do you think I should proceed with this? One patch or two
(for IPv4 and IPv6)? Is the Fixes: tag ok?
