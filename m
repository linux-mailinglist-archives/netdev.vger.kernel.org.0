Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD113D7AEF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhG0Qa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:30:28 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:23809
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229489AbhG0Qa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 12:30:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9V+uHL4D4EKnSEpSrgEHzPtAVdd3tY0iT52/3+fZZxEjYKSrarB8JGuvTNGEEWFtqZTu94v200TIwsPQEaiyljo5MBtoIJh/Y5AmL1626MAzjv5+j2oknzeuqkAxFmUkewD3B3BgD1fb+HR5xxSKa72f4khd/RSvyX5Q8pFmGLLGnVLsfU6D/TFeMD5wsPDDIRI8I53jZotX5CI2cuqaS9jg6ZEwkCCgbf7jX4hZO37inkamv4nnUhcyzw1rUxGD955gnmaiaRx5eJnTPnKAlt5FyWCHGRrZzpqFroGPT3Ku2WqjC+Qwty97K9HxZWsJds56c11os6S7zJb58PHsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJ6jJ1I9XjoE4aBS+4nUO5uzcQ+/h6NKn/+VTZKF3kM=;
 b=PwR+W74/s0AW7+6aYn0quFUWroVOh8mgiwJ+J3IqIH8mPdIQD40gbevWL/X9bLODxRqoUU7ZQ/nOoJ6qJ6K3SqON1P/drtXsUsYzsDZPVo4BOKSMsnDTYD0cUJouOtNzdjuUZ5HWeJSbGPgxpAkMyY7fh3Dft1mJDE4yCSyOiXSJThAmka0z5SM1sMpjiljrm9Ch4e76p1cJN/8ZEChf/5IeVRc1HHVXbUBJFPoM1TzYRACVwilMnkCFDUzGGDRieneuBGmiBl3uDX4wZBvRcJf8WT+znFfzwsYSjpwmcauVFRzu4mimf5r0bwRYMa6FsZMTz5ziZJuD6Ifa+EUWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJ6jJ1I9XjoE4aBS+4nUO5uzcQ+/h6NKn/+VTZKF3kM=;
 b=jLK5ngpyCkWdiiC3LUf9g1zR9kZaDnpj+e3+ss+C2u78lh8GJWn8ZLc0nZyiF/qiXK4DyC+0nUF4FvoaAOgCi0d2iloU4IpKB0jps6MlxAtatoP7Qh09NPCg1ZIy4+7i+Pan8T6hz/wyWBXESuRNG2vwOZKiv/RoHot6k02Ltm75aXF+5JFm0CduW6x5KPMrNftAGn37DhxRCs0e6S6Axh1F/gk/3PgRqlpr4qPwbrjAXuERQHNV7OZM5giXG93UMot72uaZBLVR7BrwF4r0EdkNJuDm3UYgZcyM2QI/dyLyX4TZ5FFMqKk2l6GzSTVqIrAxhQ2Kod3rDs11NLWcwg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5351.namprd12.prod.outlook.com (2603:10b6:208:317::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 16:30:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 16:30:26 +0000
Date:   Tue, 27 Jul 2021 13:30:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Doug Ledford <dledford@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v3 27/31] dev_ioctl: split out ndo_eth_ioctl
Message-ID: <20210727163024.GA2164561@nvidia.com>
References: <20210727134517.1384504-1-arnd@kernel.org>
 <20210727134517.1384504-28-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727134517.1384504-28-arnd@kernel.org>
X-ClientProxiedBy: MN2PR12CA0027.namprd12.prod.outlook.com
 (2603:10b6:208:a8::40) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR12CA0027.namprd12.prod.outlook.com (2603:10b6:208:a8::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 16:30:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8PyK-009577-Iv; Tue, 27 Jul 2021 13:30:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 011b09d0-705c-48cc-cf71-08d9511bd6c9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5351:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5351DC9C4CDD1F09FB455A3BC2E99@BL1PR12MB5351.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4wo2HprDq00vIXuPj3Gj5mI2nvitjB07ehHvVjQtG1+hxrcDsYthqRYbKlHV56LLtcfROAv4Fl0v42gabeKPEuHhnmXDTjwWBSav+ja3QVHZHchSBe6gkjuMdPWvaLsA0Lpa/1Ok50MG4jyx+7LNctXDOMb/hBPmkccINZwBZJPUzco765YxfR7F7XnkKfxK6wmNjoVWILomuAxLhm3kUGNNx9fpDXXCNDtqOY0slT9c3aZZGr1OMLnoffoJAx2mkcoa8gCLNiF4fSSm2F1n5ZcU5Lr6Q/YsfJ8HrY8km3VhwauE9Lr5/fNCGnP2LB+YXKilLT4XfiMltEvA26olwsDs5RHNsSf13Q9wXQjW/v212Dcx2Qsp0KvdpE9GxRFt10wC8eW+VL2Oj/8mxQCRr34IsagudKLEp+zI73EldOGPZqYgZ1rWaQx4AeLU5COEVWeygOd/fcBeC7JiWonAJidSk2oxICbuVGI7JpJi+FnZYajl/c3EheJP74TnpH1Iy+gqusff/UtQ1tTUJqV5VnPuy/TTB3yRT0TydG4pZKhgEIXY2d6sK8Gr9paMg1G7V2yIwXJk127+xMNs7jIDwh4WdD8LM1rPitp0GBihQSONPPRz+UMGePyBvHtr4yaYRuONmhbpkScJ31fNUt/TuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(54906003)(36756003)(5660300002)(4326008)(6916009)(9746002)(38100700002)(426003)(86362001)(66476007)(33656002)(66556008)(9786002)(2616005)(186003)(7416002)(66946007)(1076003)(8936002)(2906002)(26005)(316002)(478600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lelGCpRm1EX+O58aagZcbSMp5MlhYAEwe57D8xaO5Jglj6awUTayhIoR/OjD?=
 =?us-ascii?Q?DbN/7PoVVoMsjQklcaLyTgatz+FPUiq/ctbrS+d9lP7hKhwOZpL45FkeDOKq?=
 =?us-ascii?Q?FGJomBuPUZRdvIQHS1cTugfnRC1Cgq0Ybj8mAJdxF5UdCLtm2z6iLTTWhVmV?=
 =?us-ascii?Q?FnWlDnEaOO7761wxyJPJ3+Sie2wIMWDWrz21OO/DUU8nn+JATMu8NCakNOQ1?=
 =?us-ascii?Q?kv6Y+X7HPmYG3FbVKD2LI2hl5PnoB9jrlJPWwJbPIHMhJA0hwii5/iVTbOjW?=
 =?us-ascii?Q?0Lz+xuDco+H/dRLfiJMA+cKCINHJto3faL2W4h+9QNQUuX4mvH6pd7ApPyh/?=
 =?us-ascii?Q?IOjKnovmaeixYehkMkTyKmL2URtYw8rpScjLmLvd0+Y/Btt2JJeCLhzEsZ9F?=
 =?us-ascii?Q?w/B8M24rNmiKI5BThWqXFsdlsgfS/NYfILgFlQi3V32w5py0oh/KXxQT580H?=
 =?us-ascii?Q?fg+Oc9YczquXM4s2e0I8ZhnsPN3KkrFYA+kmZothBUg6GaM7mLPZwwyKZfQg?=
 =?us-ascii?Q?ZKGGZXlBifVjLaH0htdpt+ZkTQq91xPak4GNWWd0z4XkUkDuxQgGnmftACTX?=
 =?us-ascii?Q?HAzi2ajl2JOlW1iIUjMT2capOR9OKh3hX1u34kziR4JpLwBqBszifmWB2n1G?=
 =?us-ascii?Q?Bc55b06jG/RL12uuauqOAfI9e3tIsDneCYWdjCvNwFHFmYxX7W3NpHNGbn1s?=
 =?us-ascii?Q?BhPaRU8JeeuJHj7b5wN7fH6O8x9B4BxAVM2nP9YZryRtudmk3oe0kuIE6B/H?=
 =?us-ascii?Q?XhpSZ/PX21LuE+fWGyb2LDOq/5omERMwhxZHTgHBl+tPxlQTVzliYmXCER88?=
 =?us-ascii?Q?mFnBg6Rmq/Zq6pObfs4J+Py4d2gI5dXs5s8BonH2KwoZq0xxAL5uD0/NaS2d?=
 =?us-ascii?Q?qK9HlHObzPD9d8n1PlaK6Y2urk7PO5FxWDLvgCcvcrvifTGLKn0rk2DkqeqO?=
 =?us-ascii?Q?W4f6x49wilHIgyEEwl+mM+EWIoLPsmzF+JSkSLUeCI01rlONdeT5CA2ZSraT?=
 =?us-ascii?Q?Dc1Lyrk+KVxbMWg1Cq6ST1h6voOm/P7kd9BwLmSeNCshHo3Zm9a7Wndp5bek?=
 =?us-ascii?Q?reoY61UiLpWYu95Ez1bbxu9fIYDzZEXNETep873HqBrtEII9KbBJ7C70nMGL?=
 =?us-ascii?Q?Bq0uy0t2tMVkfDwP3+SVZrYhrRoS9OQfZ9DQMhVx6K7dTj10hhsmByj5XGLU?=
 =?us-ascii?Q?EBYys1pnDw2tt67UBv9b1luDvTkmf4NoxjgCRawJxdqUqVeNMuL3H1u1zJnC?=
 =?us-ascii?Q?HKa6ZwWaYu81kcxrIL1k08sf/CtO5sskFoyKtdTcPtd/Cp8qvKGOCvaJHBKp?=
 =?us-ascii?Q?P7QZx9fMTua6PIg5wJeoW530?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011b09d0-705c-48cc-cf71-08d9511bd6c9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 16:30:26.3264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhIWna88ej/lhkWZPNN+JRxV5X1HeFYM+Wph64rwhBjj5k/MVJ4kuRAklzfyNxPB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5351
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 03:45:13PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Most users of ndo_do_ioctl are ethernet drivers that implement
> the MII commands SIOCGMIIPHY/SIOCGMIIREG/SIOCSMIIREG, or hardware
> timestamping with SIOCSHWTSTAMP/SIOCGHWTSTAMP.
> 
> Separate these from the few drivers that use ndo_do_ioctl to
> implement SIOCBOND, SIOCBR and SIOCWANDEV commands.
> 
> This is a purely cosmetic change intended to help readers find
> their way through the implementation.
> 
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>  Documentation/networking/netdevices.rst       |  4 ++
>  Documentation/networking/timestamping.rst     |  6 +--
>  drivers/infiniband/ulp/ipoib/ipoib_main.c     |  8 ++--

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

ipoib is a convoluted, but this transform looks OK

Jason
