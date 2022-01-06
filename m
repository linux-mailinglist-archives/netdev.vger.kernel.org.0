Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C815486AAE
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiAFTvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:51:31 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.32]:47056 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233979AbiAFTva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:51:30 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 154507C0070;
        Thu,  6 Jan 2022 19:51:28 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mamiUxXE1VdxdmorThEEtN3/ftRJmF2h4H/ongS7q0OFBzna/YdnOudiGgMGbjpSvHFn1UqdqPKJikbfp1ir5m64YHECYOWU8GSJ0MMQ8B7PHBlC/2f61H16crA2QemFpDb9FofdvQRflESDeOUQtui6t0jaGNzgj489HLYkSVQcoAvPXpUJpCKEqYbB5UPEUK74ZNFCBJdCEw1AEHXixgnFWolOs02AXfJGZR6qBRBoj3j9Crwe7COYTlA0+DlOItpXR0XXt6X0gJ+8nBDlG6WUjKev2mA017MnDeIPFdSWQM/D0a9dyDG7o4SiXvPvO/Uck9lBYBE5J8IAlpnbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9M8vUtycHXAnrkpCXjzHYTZC+m/o2TnDZtnVHeWyzY8=;
 b=TzTfPA6ykfgQ+b2Xa0wqdpLy/jPdJJ069dNMJgav63IAsdgqr9FXRw9Llr4MhY0Bb/aJkCM4wsOP6jDKGLQqSlk3LXSKPPI30iVQvqn8PM69FAE2heMSq1S+gLzL9FJ991LJPKeFtv+DvqOpqvUphkh4dZABKH9Z9D05gvMLS0zArnuBKpA3n2JnlAeGysG0B7AVomx3eX/g2BLFXkor10m81lQBS3Z29GtnCkRUOeMdofQFXadD8bWIYe9fxJgcKmbFgEwM0LVafi25BR18pVfIzSULF4nUcAtFivlie3ShbNC/AU/ua6ZmzdlvbyFcgtFXe8MWD3kQzvUx3qa/7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9M8vUtycHXAnrkpCXjzHYTZC+m/o2TnDZtnVHeWyzY8=;
 b=GQ/V2krcwmmH8/RlMBuYTg4qVg+NhhumhiSCaunelAFoslQhgd7AVl0+UYIy+YefBq0CxYwMGrl1szb0tijVECugUjUjXkmBC0Emp1zZvsDNVtMfJkzbrTUvwMFdJGwK8IYzGaz24oYJNNFPbSGog9/0WhOjKPeNK0aWShOQ73w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (20.177.58.151) by
 VI1PR08MB3248.eurprd08.prod.outlook.com (10.171.183.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 19:51:25 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 19:51:25 +0000
Date:   Thu, 6 Jan 2022 21:51:19 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        idosch@idosch.org, nicolas.dichtel@6wind.com, nikolay@nvidia.com
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20220106195118.hw2kx5t6l6sem6q3@kgollan-pc>
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
 <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
 <20220104204033.rq4467r3kaaowczj@kgollan-pc>
 <20220104131210.0a2afea8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <fa09b12c-24f0-86ea-b9d0-ac470961eb64@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa09b12c-24f0-86ea-b9d0-ac470961eb64@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: LO2P265CA0298.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::22) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54949c8a-a06e-44ad-1919-08d9d14debe9
X-MS-TrafficTypeDiagnostic: VI1PR08MB3248:EE_
X-Microsoft-Antispam-PRVS: <VI1PR08MB324889374E27842C16D3FECDCC4C9@VI1PR08MB3248.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmac/1KztDU5y8G4EBPomwGXjmgVSwMTh8/065eKxjJ07fNuxp2r0QzMRxbjii7tZ9BSrLW8q9/G260xTlKG1JnlGqfMKVtAVjfLIIoRGGKZOsSn1BJo2F/JsaqHeZoDHR+LTqYh9JpL9uYEp1vR+oZhvz9I4ORYQTglmH8SuU1ABthopDwQUiHOTrt0AL58ojXufkFGmNR38BSN8gs2VyuO3FRTu/n+FSygOgRi1sq8XuMQsifiSBy+cX4uVe2jin9IwPBD1gYTu+x8P9SlPHocFphWwLpBP7oNS1Irl1pbMoNYQfvrVYctway11JvL6zbkS7gmSJ0cRC8KGGwrN18J76/R+m4Ku2G6Sw8rCCXqR07tLz/g2L7ythlzeoFN451BP3FF8u/KmQ4GdSdCxcC0tC2GxIcKRz634nNgl/cvU3GAXkEj3H+P3tC23vr1Myjc44bfSsYP0caLEUCJCGbxTQeNb/GK/oeqVG2HpG9UcjeLvulC1tVpYeVBaJ+WQTx4fMJjQIHLErqD5czHl0sxzrm1uvePM55TJVdHPZeY1Cu3RTM3i9A3tkuGOv40h7DiO/Zz7vflOvZQyeD8Yuxf3sTlpvipuXrj5/domYqWPKIQM9tOGTdxnR2x1Wi+iuRCR8ewfBock5NU2MjkeqCbpYsVSkroZUlCjKksJWRA9hMZuJKgKic+X1/JFAQAIYuWuaZd1tSVnLI3isnQCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66476007)(4326008)(66556008)(66946007)(1076003)(2906002)(38100700002)(5660300002)(6666004)(38350700002)(8676002)(6486002)(86362001)(26005)(186003)(33716001)(53546011)(6916009)(52116002)(6506007)(54906003)(9686003)(8936002)(83380400001)(6512007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bxgbFYi9happQG75b5sGpV2PLcaUFG+ELzNo0UquBucjFda2HN9TI+wRY36F?=
 =?us-ascii?Q?XCNv7JqCSL1EWGO502VVGiGDf1IxscSEnRYLwDUFPUElmNXzU7n2/0KnOdrN?=
 =?us-ascii?Q?RHlCVZzmCTGgs7KFax4pnFAxGgVQ7/gsA2VPDm2oEmMgCKkxka441wbtqLqi?=
 =?us-ascii?Q?KDZaOvo/gSuEb3Hc+3IzJKxGw7ZtOzvTBxC0Hi+G/RmzNEOsnkpqexfQEbKo?=
 =?us-ascii?Q?K0B/hCp/E6FFTfEhgFoFLyl4WU/mD4m4TBCmxL029jOhKhW+DKo2Bob2bet0?=
 =?us-ascii?Q?q0Gwdne8Vt7IlnGAXJxYefBGBGPksyc4X5n+Xx4MQ7nGtC0GtbMORq/SUhOp?=
 =?us-ascii?Q?Yo4NximDEtpi2UQ+ZuHiVut2c4k4M09kI5pbc9HQz++81GzE22OkqB+eovGG?=
 =?us-ascii?Q?Uyvgx3uolCKfV6iPHU9tXkQt4mxkxkX6iWhW/8Mx5QgTrklGllYR5pekCaYZ?=
 =?us-ascii?Q?ORISbLILf3CklHMcaOj1mQykjNkJ9svkvCVUCPZChYXMXQSlWsmDqGz/G5xQ?=
 =?us-ascii?Q?uHsF5Gbl46WgaYiIIrNEonMZI4cjvBo1RUqhGBpTKTnm0eBxsKRUD0YylhRn?=
 =?us-ascii?Q?c9LhIffd2dDA+qHe2JQhvT1QIuOkJ6KH4AN1bBTwLBgGde57Gla1kccG5dYT?=
 =?us-ascii?Q?9YsRUnEjvWEnU4oOyaKykZmCw/Go7rA93Xx7kWtLYMUYjU6AY16k8qflGuzj?=
 =?us-ascii?Q?hCzes4TeUmpy7G1goFdcX88Jw0+cXGcoTGFH3Zy5N9hdHQC8DypYTvm9AA+C?=
 =?us-ascii?Q?mdldhDUm463PBaIU/bKq56tCpLqeWxYg+i1uQ/O59c6P1Hasi3EHaRNt5J/L?=
 =?us-ascii?Q?QQqDKeOCWVKiDVyBG71018M9RNPlIrCeJ5Z2mHefcyNkGaO/uHsmvqC62OZJ?=
 =?us-ascii?Q?QfR8maTznZ959mSmxZjCGR7jYzVYo6sKR7ijzGzr7BVe5PZR5lWQQ+8d5Uxr?=
 =?us-ascii?Q?DaN4a3kYiYh4gqHpSr55Ts+GXR9IpktP/pVfaZYubW3Mws/xpxMmaH/Bfsmm?=
 =?us-ascii?Q?QA4a35YViqwVJIQhwsLGihiPFCKw02laE1exLcZ81Re/SgUhj2XJRgR/ohQ+?=
 =?us-ascii?Q?cgaXTqEbNBLTipdbrXOgnj63PmXd6a8vm+S5XU105TKTabDI2WkM6XlZ4xrA?=
 =?us-ascii?Q?ynEyXij2Krh79OmScJQkZd9Kr2SG5F1dbA8XW/Hd3CzAYl7Iv4S/662M1c/E?=
 =?us-ascii?Q?nDjPwaUAMx6b/6wfD9O8riEB7C8cZWALn84x09Sh7Vt0foL9I/axRnloxUvN?=
 =?us-ascii?Q?pP9lEOsILQdGL7D99WA8NBjWj1W2qPWrR4BI2WR03uC9yvQO8RFdm1cL1Z68?=
 =?us-ascii?Q?myIi997bvGxsQgsQ/gQNj+a3gS51GrH4CfZYbG5tTH/uxobqOgqz+bbeo39p?=
 =?us-ascii?Q?peeD8AGwL9qYWs5p98FuuAU4eYwPOByZM8a4FMuTNggQqZiIr+E2rhCMIcrV?=
 =?us-ascii?Q?58B17qQUj9VAL9CxDeSCNxLlNUaZ2CihhFDCFV2J82qqDfgKj10eC8jsci0A?=
 =?us-ascii?Q?K0BWMFAutILMuRo9Yq+LVlUz/PNri9V+4m6qpf+L3hwYRPvc54Krm4YjIPwo?=
 =?us-ascii?Q?wH7ULosrAEgNKY5syOqEfWeAZUvIm6oG1y/nqrZKRlHDEha0GcwkKNLJCpd3?=
 =?us-ascii?Q?Gw8HqUbIMwcqpVk6Tz+acy4rP5wGRWaHHxXJ14C6yq2VdKNZLpuxBHfTrsOS?=
 =?us-ascii?Q?FOc8hlf0mYw/nf1R9cESFlWBOW8=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54949c8a-a06e-44ad-1919-08d9d14debe9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 19:51:25.3003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmczDknaLwUOWiGl+05Ow2eUe9oCFYLQM20ZGGRnHE1POmuQ7HO2NOzcR9C5hqoeTesFLphJAaa/uUwlsBaTHFsdpv+UzZ1hCOQ69zb1mvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3248
X-MDID: 1641498689-qe6yGZYmguSo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 05:19:30PM -0700, David Ahern wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On 1/4/22 2:12 PM, Jakub Kicinski wrote:
> > With the dev->bulk_delete flag and raw array instead of attributes you
> > can go back to the version of the code which stores dev pointers in a
> > temp kmalloc'd array, right?
>
> missed this response ... that should work as well once duplicates are
> caught.

I liked the idea that we can avoid increasing sizeof(struct net_device)
for this feature. In this case I see the final implementation as looking
something like this:

dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);

for (i = 0; i < num_devices; i++) {
        dev = __dev_get_by_index(net, ifindices[i]);

        ...

        if (dev->bulk_delete)
                goto cleanup;

        dev->bulk_delete = 1;
        dev_list[i] = dev;
}

for (i = 0; i < num_devices; i++) {
        dev = dev_list[i];
        dev->rtnl_link_ops->dellink(dev, &list_kill);
        dev->bulk_delete = 0;
}

kfree(dev_list);

unregister_netdevice_many(&list_kill);

return 0;

cleanup:
        for (j = 0; j < i; j++) {
                dev_list[j]->bulk_delete = 0;
        }
        kfree(dev_list);


Including the explicit checks in rtnl_setlink() __rtnl_newlink() and
rtnl_getlink() for returning an error if IFLA_IFINDEX_LIST is passed.

If it looks okay I'll send a v7.
