Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBD7192B9F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCYO6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:58:30 -0400
Received: from mail-eopbgr50040.outbound.protection.outlook.com ([40.107.5.40]:51790
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbgCYO6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 10:58:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKcW3EGKrB+MRNVIgdngQLXQAVLW0gNLeWH4qaua8orCZIHnp3nqeDzBTy6OQC9Fqcw0l7aBiqJHy5dZrNd4wwhftdgsrYpTQyP2I0IZ+Ku48SJ25QBJMx+nE4Rmm6peBdKkJgGH8zCozxjE0H6TESWYgDqtWirfRT09X5kpdC0ekUHlR1qpRIBrK4ToiTg/xl2SE4bX/cdoFkcscnpAtexhEoM3IAaoJJITl+ya27mkf2qttoJSVX87B+z0tCD2A1SEwCjA/wKuM/FUgE/EDHjOLAIzUhzDso7KykPGsGbT3tDqMcmdaCm8Re+Uj364NI5LTN6J16vTd89Ps7MROQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jg1bQzumul1N3q0i5HAuvYJ4bTQt47+ld4xBHx9txA=;
 b=Fv8WgsB09oDDfIE+jfFgtlXxLyOyxBFR1H6yx52W5t31tNXk58s9Xs/UXxpaVmBIpG+UptZc9Y0vt4RDT/nbzO6ektfIYVl0qHD61824CQoZqcWI3soYP6H5qDbTYd5A3kPtrTz1uL8LiiacywhaF2LS0WGfEFy3dgIUrtH5uVWh9o57g0qJlZWo/iWZxdab1lv+cb0eJa+4jGIBhn24t8XeT/V0hMmhfXxfkqU4rlxmcKxmrVgrI9vp+5vafB6HmBljBmHzthRsuRmMVjDIWngXde4IF52VAi4T3f/bIl3YWLDA2H18OYZof6PQ21zTuXJ1MYk6pfwnqq0UTFpOKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jg1bQzumul1N3q0i5HAuvYJ4bTQt47+ld4xBHx9txA=;
 b=Vj9cnsnwzAXNpzIcJMCKhe+Nv0ua+gaXOJ5vzduXNwCuWV8MB1FXuDrYGLoY9Tyku7pkB/WssEv4s+B7g836oxIMPahPsftGG5Bw5IlYFoXt+tP53/ykfXoEnyttZIRx1lECml+KRWvPBmrzbD+aWLRoWx6hpeAFpn41lXRBfnY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB6096.eurprd05.prod.outlook.com (20.178.126.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 25 Mar 2020 14:58:27 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 14:58:27 +0000
References: <1585138739-8443-1-git-send-email-wenxu@ucloud.cn> <1585138739-8443-3-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
In-reply-to: <1585138739-8443-3-git-send-email-wenxu@ucloud.cn>
Date:   Wed, 25 Mar 2020 16:58:24 +0200
Message-ID: <vbf8sjo32i7.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::17) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR2P264CA0029.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Wed, 25 Mar 2020 14:58:26 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1001dd7-b1b7-461e-62e4-08d7d0ccf95b
X-MS-TrafficTypeDiagnostic: VI1PR05MB6096:|VI1PR05MB6096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB60965BEB0541A4A31EF69706ADCE0@VI1PR05MB6096.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(478600001)(2906002)(26005)(4744005)(66476007)(2616005)(66556008)(4326008)(16526019)(956004)(186003)(66946007)(5660300002)(52116002)(7696005)(86362001)(6916009)(316002)(8676002)(81166006)(81156014)(6486002)(8936002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6096;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuNgjUpujvap4RcSMpu7H0WQbF4vwMYYZ2ywVuYu+QE17bTF8Aivf+95iY3L45lg+e8anL7V2IN4cpVVNGRXShp/2UorwgHI29dLDM4XBKcuvkYfrh8kAN043KZaUYcx/5+mYZimnNRbcjupNVSvK5QoOnhfzEzvC/ZEHm9HlZiVWvz9bV7gijTzwdu3+/mgcyapJXlmzlCxRcez0elRYTB4MtPReiu1AnjQErnRI2iRPewH2G/t1dOH2wZ3tsT4hGw/3tbON7j3TlYcXmeRWZJvpiRZmYOSAukDo17MRd0tm63Y1q4/PqZsic1cESXs/fjYhB47pq8Z6F/nL/1462fUs1A2UsZ5DH1j6b/w1xVZPeynKDSAEgv/jbumT9N88XYjyV0rnzk1EIEaaSucEViy099AMQz0VXNs2w7R04FBuMwoIlsKrfsO7+781NWr
X-MS-Exchange-AntiSpam-MessageData: yAzx/QILcyStlqJjCz2drb6j9zQxclDWe9Bgx1gCGMVSlUsgM/HevfAKnwKDgvBrlyjVf5vQ0LuMBWCHtdqw3rCSR8DB6DVYMejWvNsU+MrRITnWzOWWXX43lRC36V5xVytzbP+aRQgnEZ2pSMiDXA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1001dd7-b1b7-461e-62e4-08d7d0ccf95b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 14:58:27.2625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4F+4Kf4pnbhTqFWqp5EMAXAK4zKkUImVjrlA0ExHB6JMouSImNdXpvOVouZ7EI8wzBr/rEGQorN9BBkE00VFYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 25 Mar 2020 at 14:18, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
> in FT mode.
> Both tc rules and flow table rules are of the same format,
> It can re-use tc parsing for that, and move the flow table rules
> to their steering domain(the specific chain_index), the indr
> block offload in FT also follow this scenario.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

Reviewed-by: Vlad Buslov <vladbu@mellanox.com>


[...]

