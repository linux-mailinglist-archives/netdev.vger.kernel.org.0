Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4339192B9C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgCYO5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:57:50 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:18273
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727486AbgCYO5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 10:57:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKolch4nmgI165ZhWfhtTPlZfeNVB5VERXX7dITXPF5dLrUTmtDcuO5ZobSW9fFA5KX2Qc2nENxgxDxh5vFQSCabSRkHPK7bMShjNUoIHmyL6NgRd/yvQxX10f2LrT9qVYY5FOhQzybvf5yl+3kp0cIzPwD82p30iAbO2kQyUNxVS0Ev0V/RJOiIPGnkc/XuQM2muWLhc9ZE7WtyYaS6Rdj7HDaLkSv2O3fZ8c/qH22PYHAVcYP5u7yQcTjcRLQlmLkhoeVFs94vqLk7IicgN+EYbXFU6Th89Z2Gy6Cg1u7pb5SpjYV+kQ3+hvKreBSyBptLD5GAPCrcRc7SsmOWJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jFt+HxLnsspP9ZEc7Rl+cgPq8Ri2kmtq4QcjgnOyU8=;
 b=kKeNnvA7rbnp7Y5NCF5e5W4nE2w84rmWjRO339mtGP3IPGacSW7+CB8gaXafn17tvaWrMkStnv+18S/FVJcOYwesBjDmEXvAAUg+qIuLrmMRFoiiFZtyzdt0VdIF8Q2qFYjLY+U/DhbZh6AAnMFUH1xxCIJtD2ykistX5L+zxsAK3PwIr8gEhugc01cU4Bat9z88d9YsYtANMArLqR9l4b5A8/O2gCQyQ3zxGRJnTcRHt85QzuQ3IPbeJyKLA0SGpHii0uxWtrOC7HrX8r/WO0wbHXa4/P1Cnm8Vq1e9fECKBsTs7TOWpGMka+VcOE9O3M8HOQajnaAH+UBPlw7+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jFt+HxLnsspP9ZEc7Rl+cgPq8Ri2kmtq4QcjgnOyU8=;
 b=HDfoEBNNub2Qv1Zsf7QCgYo7Ou1Wd8IwC5dkY0oyw3G4yVX3rAslpQdOMvFkm411Cf86AuGhPNSeOu38ixOBWgLLL/0tEunjVuYq036obS8xFQdjX8tPzZVbngMZRXKAgdBIlr+n/ZK2KTCYRdf8ELWF8i1ehXBELU1iRT3ZidY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB6096.eurprd05.prod.outlook.com (20.178.126.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 25 Mar 2020 14:57:46 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 14:57:46 +0000
References: <1585138739-8443-1-git-send-email-wenxu@ucloud.cn> <1585138739-8443-2-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 1/2] net/mlx5e: refactor indr setup block
In-reply-to: <1585138739-8443-2-git-send-email-wenxu@ucloud.cn>
Date:   Wed, 25 Mar 2020 16:57:43 +0200
Message-ID: <vbfa74432jc.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0032.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::7) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR3P193CA0032.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Wed, 25 Mar 2020 14:57:45 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9318d53-bed6-484f-ca29-08d7d0cce0dc
X-MS-TrafficTypeDiagnostic: VI1PR05MB6096:|VI1PR05MB6096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6096AF1731E359B049AB198BADCE0@VI1PR05MB6096.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(478600001)(2906002)(26005)(4744005)(66476007)(2616005)(66556008)(4326008)(16526019)(956004)(186003)(66946007)(5660300002)(52116002)(7696005)(86362001)(6916009)(316002)(8676002)(81166006)(81156014)(6486002)(8936002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6096;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xLhkw98q9Eh+RcskWA7JicBsbeuORyWFjBr+Gb8oSbGJWtGZ5HY71Dlu+B6VNb9zAotJTbEC501grjgD5JH4EiYtEFmRjXRxG2N51+gRAagxpH5DWw9RAI4IGhLQbp33ymvBn1hI/vbzsbUi26UvZlZNCmaqsbD9dr6lt4Dib5zwrL69e4LNkMmE0A0HCUzyKay67VV4JE5tmeZquYYERWKHBgW0y6ZGv6+NTlQdZuGIqWP1ue7GqoR/noITVfK257Yrdgk8msg2a7bs3MpBtOkdNxDxDCoywS+RmtcKqao9oi/WULxMmY+k5kx7IBPu6EEMpL5ldcl9PPFNzWK1CAf/y5TIhmx3uh8X2cbaIeZnNRjrLxqHss8eNlJ6FxPxsO34ZhxAaFZfWwTe3eLnwqcBHQwH8XLJ1lLN7r034npiuqNSzdmhzc1dYdSTe3ux
X-MS-Exchange-AntiSpam-MessageData: YnYOu/fJhH1BOy4pCMksD/ws+V2Je1VZ0qIZstsyyQy6mvrcta18cszsGFSERmKRstfW3jwZpapY461i1TS8Ytd7Rj5jOSqemcflVY5Z2AmvHLHBMMS0Xf9tHW34dX6ez0rVl8Kh/QmxUysHhUh52g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9318d53-bed6-484f-ca29-08d7d0cce0dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 14:57:46.2125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TiV2QfHY+2685RZpeO/V1Uy3t5iGBO/slFlJ4FEN/50+j7zgxx4I8klfKW03snLL6nhVz+pNCOAQFaUlLYfQsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 25 Mar 2020 at 14:18, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Refactor indr setup block for support ft indr setup in the
> next patch. The function mlx5e_rep_indr_offload exposes
> 'flags' in order set additional flag for FT in next patch.
> Rename mlx5e_rep_indr_setup_tc_block to mlx5e_rep_indr_setup_block
> and add flow_setup_cb_t callback parameters in order set the
> specific callback for FT in next patch.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

Reviewed-by: Vlad Buslov <vladbu@mellanox.com>


[...]

