Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0297A1E5BBF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 11:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgE1JWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 05:22:55 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:13434
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728161AbgE1JWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 05:22:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcxrkGEnbcFqIBQAAEMcv3solf9nsZ0eeELmnuFFEu8leIPwXs+pjPF7l2mwjTmrpJBMJiZri9vv7basD3Ac+a6ebZnxFpTlJkaRNhyDDrlncLEMrHhQIax4kz20PEhAInVjLnW5QM+9BgeD63+h37Ge5BatxoEFy6Y8fXC3yXUL5iiW0G263+Qlb5E9da4e3NQjJUbF+TqPP+diHVEpnhGXcWwMSYYkfb5u75jnaI8zx3MqHM5T7alJzt+oCjiXzeqzIOLAC6yElWer0COp/KfNEq6pGbV042ruVPryy+/xoo89948SbpF407gzq8u4u06DJx90MNclzLDZD4R2NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8hi750IbBEYUwKp1d/bC+LLqwxq2WOcCx5xFqfg+QY=;
 b=jIIdm8NHTdDqORLG704cUj5ZCkHM3C/e07kt0M+y3AaOlwPFe4xhoYbUy6gYRNbGKtqAikuH/HKmNSuRlY1qFtDk2iVUuToYmUxORze0Vm8qO0or/NigrmpeQ1c54UcECV2jSyK6bWLWXojhCjkH14KBhZcOB6VI2vyXiufdmYfb620yfVCSi9OJcXc9JBQAWsPtKVV6RNFuDLc6ffktaeJ0lSwyd+pwYVKXR9HTmkmrefbQPechim+z0iWxav5KFffOYek680rEbV4cuDln0gKgYA/UQEvLOZcZyn79lCct54L6DByuJBfePb8HKGQM9vbJ2vSbWO1LErik1egcFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8hi750IbBEYUwKp1d/bC+LLqwxq2WOcCx5xFqfg+QY=;
 b=m1Ampq4KFD3DQ3nRUYIbtqnPEoy+glLA2VHQltd4YggpLv+o85nLEGa3m2CthKGTdt4PKbusZE8yQrx102Xh36B0s1Sfizkp7Vh+7JDl6B5gYZ/3QiflDUupjtjLGTSnAbrWptHr+hyX+zZcv+HOjDL1sAGRb7cwP9/B/qlpeuk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4793.eurprd05.prod.outlook.com (2603:10a6:7:a2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Thu, 28 May 2020 09:22:49 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 09:22:49 +0000
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com> <20200528084052.n7yeo2nu2vq4eibv@pengutronix.de>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Amit Cohen <amitc@mellanox.com>,
        "andrew\@lunn.ch" <andrew@lunn.ch>, mlxsw <mlxsw@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Link down reasons
In-reply-to: <20200528084052.n7yeo2nu2vq4eibv@pengutronix.de>
Date:   Thu, 28 May 2020 11:22:47 +0200
Message-ID: <87y2pctnvc.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0140.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::45) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR01CA0140.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 09:22:48 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 381a1a49-8e56-45c8-d301-08d802e8b06f
X-MS-TrafficTypeDiagnostic: HE1PR05MB4793:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4793F1C6BDEE883E9F2A6360DB8E0@HE1PR05MB4793.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /KoQzHF7E5Q59+4FXCM1fY/a7OyS1SzOXuCHWZrI03usu6Y4gTLUkDdjH+TtqgxCQ4Y3qf9+l6XJuqT/LrZ6Q59P0nWH0Wb7uFclBc0imVmn0JHtqc3YGt9b0pRrVBfW/oyY33VLHQsQ+uzBNU1CrXl3cXw803NJi74NdCHSbc1vOtoahssQ62pwlywCe9PQQtONLInHPUsQYgitRKKEgHtVFmTx89Zz8fGaFgYcLY4cjfFwiYoas375HlursDq9gxrAD7YpmieyTSXy8VQA7LzBJx2uUPrKrNiCS0dL3TTBnil2Jee5Tm1CCEJAqfCrjhhXYlqyDJDj7fJo7c7jog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(52116002)(186003)(6916009)(83380400001)(6496006)(16526019)(3480700007)(5660300002)(66556008)(4326008)(66476007)(26005)(86362001)(54906003)(36756003)(956004)(2616005)(66946007)(8936002)(316002)(6486002)(7116003)(478600001)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rKu/GiWTERRKAY5oDhYMerRtFFeH+wAYxsj3niRvuck5hRbqW0XtQfSq3+2208NY/dkX6tmGbe8ptyBRfUNUirEydEY3Ir4hW8yddDKn9ZMrCbIGhb18+dO1OwO/5ZYa+uxfxx8USCEzS11YlMcaBzxUVgbfHfNUtCi/SxlATsyi4ZmC5AVvwHZQ/WgYYDxGK+zFlEyHVeTZ+38vbBsedswGVFsf0zn8bFZxdxBP5wWnp7W3dtp5n0n3YDaxoPy7WnVagWIIeFc+jJy2NpEBnqV6eAE8Yhl0Nq/MKHUhIAN3QN5OAXxaw9D8TCxJM0MGkcm38xX+2yT7i7jxVP8n4XTIRxsEhJNU3VAglOJdpSzSwxe7V6hH09mGnMlkSyNp5IQnA07dc7M6Qjwa7kV/iapCNQsLuKyetJkc73MR07ymd1fqb7UT0vpvb7NJhZRNHOQYOyhVkF3cxiCz/v1WQL+t8/HO5qHvit4ialg5d/rmSL+Qd4yZahHhezIDpM8c
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 381a1a49-8e56-45c8-d301-08d802e8b06f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 09:22:48.9731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gV9CqLmtI10eExsT7LvOtAyC7PbJmY1vOBLAC6OLV8lqqEPXim48FRceExytGqdMj4P/OSigs+A/kr9DcGnT2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4793
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Oleksij Rempel <o.rempel@pengutronix.de> writes:

> I would add some more reasons:
> - master slave resolution issues: both link partners are master or
>   slave.

I guess we should send the RFC, so that we can talk particulars. We
currently don't have anything like master/slave mismatch in the API, but
that's just because our FW does not report this. The idea is that if MAC
and/or PHY driver can't express some fail using the existing codes, it
creates a new one.

> - signal quality drop. In this case driver should be extended to notify
>   the system if SQI is under some configurable limit.

As SQI goes down, will the PHY driver eventually shut down the port?

Because if yes, that's exactly the situation when it would later report,
yeah, the link is down because SQI was rubbish. In the proposed API, we
would model this as "signal integrity issue", with a possible subreason
of "low SQI", or something along those lines.

E.g., mlxsw can report module temperatures. But whether the port goes
down is a separate mechanism. So when a port is down, the driver can
tell you, yeah, it is down, because it was overheated. And separate from
that you can check the module temperatures. SQI might be a similar
issue.
