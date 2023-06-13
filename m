Return-Path: <netdev+bounces-10303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD09772DAFF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 652D1280AB2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC8D3D90;
	Tue, 13 Jun 2023 07:32:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A573D87
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:32:23 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF281FDC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:32:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaL8Az7mHjpADltfxLWhsbouGkE7iqq3XlnZAMc6hnSiR7IXmyxZIRGDfo8eAAuNrZv8bVY+Xt1lAO6wTNhaEMxy++ER3roIropUjsKRJdI4OtRDQIv5bw2YxlwwMaI6qJxjjMAvRsTQhQD8l9ezJY2WUkUo1n3NW7yDGevsFjKOEpDMffXjl5MXzrH2wpG03vqDHV7bRxxwxr5HeW0SgVZdZBZ9VBdCNWtYj9r86ZoRN/w9Fer9fEdVrY5ztoLWzGSGIxUhJgKN/cSdu/kp+DA5IDxApHF+2U4nVDFCWcdROVzFiOb0tbvR4Lyq6kTmj1AUYA9Ya286cOFO/nqSdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nzaV5+c5bEvGa3Gcnux4YrBqNql70Mc29FSSKczK88=;
 b=hI9YRCC4zewvW4BR19yAHlarQImMeSz5LyLHwkxuqH4OghUHL3TEu9p42elCkuk/JGe0Ck537K3gUk2aiosuFHTgi9JFfm2K7sHCs30rpba//JBdSSzOkgwB1TsFVJ9ac3xO7WrWa7FtOmK/8QdG+O2LyKaK46IegfkZSDtl3ckke2AovCXNtxh6ialocbupRnCri1stplntJkSL11gxWScH2XeQnUtUEi5TweZD9Mz+OxQlYL4qHo3+EbQZ6abn2V0mPuzUAGf1FzXzpxfXr1gScIulsvbac5bUDyhOCzHUC2XFTjiBDv6dcXiVJKFtgwlSIVLO1UWwYsgXcVkWiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nzaV5+c5bEvGa3Gcnux4YrBqNql70Mc29FSSKczK88=;
 b=UsTAJZryNPq6Q+oSksKP7oxqju3Qn1Z7EyIy+0xN3+umB9Alat8Scp67fHlEuhQFLppLLngbJU+OabFZ6y7TXPmP2BvsivWvJ3VE+fegQfkaiEGt2CgoYSDfojsM5in01JHnxnLB0FikJlEorzJcBV0ZHHSiVFYPdOAN6fM805Fs6xt1EN73akceebCq6lnaK3/Iv6K0PvYPu90qud/W5SdeR50vaFfGmZD40eX6oOTa7ToJRj8OaFdMnhV0YJKvB7I7Y/Oul6oqcqt2+g0bLFTv4eGFEd0XBZL99cJ5KuRnCcOASfrsexbFYyY3I661s2IQQ8lncYNxfXu40BqNkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6432.namprd12.prod.outlook.com (2603:10b6:930:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 07:32:12 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 07:32:12 +0000
Date: Tue, 13 Jun 2023 10:32:05 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: mkubecek@suse.cz, danieller@nvidia.com, netdev@vger.kernel.org,
	linux@armlinux.org.uk, andrew@lunn.ch
Subject: Re: [PATCH ethtool-next v2 2/2] cmis: report LOL / LOS / Tx Fault
Message-ID: <ZIgbdYe289TsKhHi@shredder>
References: <20230613050507.1899596-1-kuba@kernel.org>
 <20230613050507.1899596-2-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613050507.1899596-2-kuba@kernel.org>
X-ClientProxiedBy: VI1PR0101CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b1ac7cd-94fe-49c9-6232-08db6be04da4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QjwlUM3guu5/ScrAvKJpsYQWl669hDGvuuGP4ScmsZMkb4X4/1hLJASHHfl7p799c9lOEvlKjYfgd+pZRzA+uMjjl1gccRXBlP8BJj30gF8o9vPvvi0pSR+AWOMvYcI00YBw6Ve7ouaQWHaTeTxs0aPsYdnIqYEyFcpIw+YGVyCLIZ61tWS0sKZEjFhPppX/yea2l8EefBwWwHAAQ3zY0JmQrMemsG8xPjgW9M2mph8xRFO47ZOL+M0IIiLgNQUfC1w3KXwnJWIUf8VSVLYHp/s2wHcBS9z0ngM7XouL8SZWMYewG/QP6ygFHl6zXVOY/Ii9aC6LPx5DU/7MUoQjfv6WLGxfk2PvXWqlX6XgLi7C+40OKOR0+4RTpWrGKhgTvEyFQCMdHDps5H0HZtuESw5QW5tgVy6OK2pL47U7RDy/Yj4IRvXxRODA/vubBBpp3TO4tZFmZwFG50PTDHKckBF064nl8Mq4t0V071XtiLBjVnmudXke0fZqmkJkG/QEjxx7n54rdH4mOZanONMselMlgos7m8iN4VJZEezpqIuAq7/oD/JvuOhxrw658khN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199021)(66556008)(66946007)(6666004)(66476007)(316002)(478600001)(6916009)(4326008)(86362001)(26005)(6512007)(6506007)(83380400001)(186003)(9686003)(5660300002)(8936002)(8676002)(41300700001)(33716001)(2906002)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nrsG1z6CN8lIwlLh58MHsr4cqCii/KPQRNVob8T7dKfGegdhvNAVMW+2r6eV?=
 =?us-ascii?Q?FGBGF3tzB8VibX5pbKJ8gSmGpB3XIp08xo5Bb2mmSsduiOpJMhPOQEMJow5H?=
 =?us-ascii?Q?Djswvj7vSWjo0Gm/uA6aXH1cp9Hez7FPA7sQ57bp+W1qtnlGjPnk5sz7P0vJ?=
 =?us-ascii?Q?0JHvyTPieOpF44Rw76oQZx2wGl3gnxYgY/bOSubrsx0OOlAVWO/QpQgAAcGL?=
 =?us-ascii?Q?TRdWEg6EaySi2x3kBaX8+csWO5bbs94Pqtzqw5YLVWJyc9hkeyEzrVg249Fb?=
 =?us-ascii?Q?QBLVLRuZkhGMjPTYr1RbOhZvKlS4m4Qskik3GVHE2cLWLXQbMP48C7pkG0dm?=
 =?us-ascii?Q?HZ1S7C1PjTbJ31TX4hFs8GoS/UxMpxYj+EUw+tBIIiYHf+03vJQ7Jw9jYi24?=
 =?us-ascii?Q?c2viyitdFUjcm1hoxJxj/T7LUtKChoo8NIwhq7kT8TcYFzSo9GpT+cMIGrwV?=
 =?us-ascii?Q?bpS6STN6RvxVVfksTnsBjuBQWjVSKHyG3K2mVydVCkwz/VRhsV75Wf3yfLxh?=
 =?us-ascii?Q?IjM9Y9wqbrTKNlDgNK26ADSJrDTKy52qlTfoijv2kZC79mAWnPRnnYDtbdba?=
 =?us-ascii?Q?bIVq0JzSEmjSXmo+1GcCva9R+obU5xmtLGrbBuNNnz5mU+vRAIOWiMYzEzKt?=
 =?us-ascii?Q?IHZtrAc129pdSx22nMyYW9ZGgUOrUI9pbKjo4OOWqnIKb0Fx6IoT2l4kirZr?=
 =?us-ascii?Q?RAwgVW9sQGWvJQkB3gArxhgqsw7X9fXekj3zo14O2FPg8gGI3mJtgxJJGscz?=
 =?us-ascii?Q?inClC9sOtkhH9hq1VfjQSDOCHMK+1uKYFctzo45P3T1pAtqxlpN7U6/jwkzt?=
 =?us-ascii?Q?m+dHRy0SjIsqYfzriUpprvNkYSHCY6aOX9A4Fu80zTMEG2eHM8L5WCwZBlxB?=
 =?us-ascii?Q?zRQOnHFdyRYP/SHdFa2or9X+Aw99fk4sCpGS/gnbbiJMJQBvc494HFwOmsZM?=
 =?us-ascii?Q?vzgZJYAMVNfbrSjbTjqhHUsBTT05/abY8A8Y2ChPXUwDC63U8GPIO0uaScZ6?=
 =?us-ascii?Q?cbX+sO2EgZFlTZVle6TzcAcJ0A34PdrrbCvP7g0/cBwA/ESkj5LYX4ij4VAM?=
 =?us-ascii?Q?H/2UJgFuEcXyOvhhNZQDA/yIGlspnkLfSSOU+1W09EF9SUaGuB50q4jjXKP6?=
 =?us-ascii?Q?o8atk6CKwQOfk5R7fUnHOhj5BNQOuCsaCzis0PS4TnEfAVAXgxKRweAKbhd8?=
 =?us-ascii?Q?xOiUulpKaxmB93x2O71oHtOiXGcuCci0oJlzfKFyRplGkycYfDhNXriAHqwl?=
 =?us-ascii?Q?kEKzhR3tJSDw/ByCEsOobtiJlzTmy77RJmF47kXguNIGwRSHlbNJ7HKoO8fF?=
 =?us-ascii?Q?PN2cRNfQjPMv7UGgYOLhD2n6wraZsggG8LQZzteJml3QRCK9GjwfZcJaPPfm?=
 =?us-ascii?Q?2gNlUcZ6IvgLt53h8jGd0yz4vSha5LPx1uT65F3YmrnSmk7YX+gk/FNlNX7e?=
 =?us-ascii?Q?JMUYrPCE+CdJ0RJ30k3ClBg5bHkaa8vQu5Ghk1Pgx/Rq5yJ7GYaK4YGBkgr1?=
 =?us-ascii?Q?RMFT9SXsGq5MIzKVrewtAEdj0TIhWwJvxFGrIQoZPu6RT810q5SQit4VLjO4?=
 =?us-ascii?Q?h56hOt4KoP4jNOuf85Kh/OrU5Rn/lYpLR74Wr2pN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1ac7cd-94fe-49c9-6232-08db6be04da4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 07:32:12.4897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bn9mCaVG2unkGnShl3Dayg8eC4Vn589ClwoWXLFxyHlqinb1bUqudcrbx5mgIPPQ0bXm4ZC5s6yj9QKDS9+wbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6432
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:05:07PM -0700, Jakub Kicinski wrote:
> Report whether Loss of Lock, of Signal and Tx Faults were detected.
> Print "None" in case no lane has the problem, and per-lane "Yes" /
> "No" if at least one of the lanes reports true.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

> ---
> Turns out I don't have access to any host with CMIS optics at this
> point so untested. I can only confirm it correctly shows nothing
> with a DAC...

I'm not sure why, but the module I have reports two banks and therefore
16 lanes. "Tx fault" and "Tx adaptive eq fault" are not supported.

When both are up:

# ethtool -m swp11 | grep "Rx loss of signal" -A 4
        Rx loss of signal                         : None
        Tx loss of signal                         : None
        Rx loss of lock                           : None
        Tx loss of lock                           : None
        Module State                              : 0x03 (ModuleReady)

When I bring the other side down:

# ip link set dev swp12 down
# ethtool -m swp11 | grep "Rx loss of signal" -A 4
        Rx loss of signal                         : [ Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes ]
        Tx loss of signal                         : None
        Rx loss of lock                           : [ Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes ]
        Tx loss of lock                           : None
        Module State                              : 0x03 (ModuleReady)

When I bring the interface itself down:

# ip link set dev swp11 down
# ethtool -m swp11 | grep "Rx loss of signal" -A 4
        Rx loss of signal                         : [ Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes ]
        Tx loss of signal                         : [ Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, No, No, No, No, No, No, No, No ]
        Rx loss of lock                           : [ Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, No, No, No, No, No, No, No, No ]
        Tx loss of lock                           : [ Yes, Yes, Yes, Yes, Yes, Yes, Yes, Yes, No, No, No, No, No, No, No, No ]
        Module State                              : 0x03 (ModuleReady)

And I don't see these fields on PC:

# ethtool -m swp1 | grep "Rx loss of signal" -A 4

