Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B681B7F5D
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgDXTx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:53:26 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:29594
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbgDXTxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:53:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwNukLujAIho6ewtYhaNJQ6W/qiHHaIzQtOuIaN4jyRE/LA2RjwZ6fFdGtV1jrQQY3dzzlCao8pnw9bVfPq/ful+l+BKUfTJUqbRjRrhevjGH7zcxM7gZrlbXeZtT+EBFW7mkSVqQpPsxng2UPLTzKDuyQX3njbhexOoX/ZfSQqEndksXQmCyjVEZlIeWT9hPmmokax+YKyVmJHLnsKRz455xDH/xuDE4XFaOV4d8WRmM4eBItvg3L9MZb/KWa3ebkKfswz9/KZhl3ymCOPzcEQ93SL6MSM8zFnmgCAotZ6TNv3WgeQb64bXNu/ZSENH1YrOkARUq8sYU/Iz6pwifQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tB9SdX4+nXyRffRhdfvTokn8YkxP8B45OQF0I4nnWV8=;
 b=ijPrQU0z0S2A92YFc6jwJTij8QTtrE7c7QLKtuDropgBJvqzVWp7TQVq4ThtERYP4h1h1F4BB1ZizaH6EmxlIVMJTPGwnau4wdLW8hPzE//8agxB9re0jdGQA25SulhsjtIBSdfdtGwvXNRGjziFqm+M6KXy8TgdHkA90WiViyC6Exe2llvmM7kmdLsyxLGI9hlVs7yDBBZ98+ctMhNyUwTSVlwwIf20pkxkqbYYMmdZQAAwR/AXIKdHJeI1ZjmT3CKEzHSBHr1ct2EK1kbsas1i8j4w11yl5eEzzmBy01CWfBFID1JnTIxe/n8PNKBHvScpiLYJh3md5nLk+xTeGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tB9SdX4+nXyRffRhdfvTokn8YkxP8B45OQF0I4nnWV8=;
 b=U6EU5bdEFLOzovPDL5+sCmRuY3ISBhgkFk6Ws/q5SsB5Y+hrGOlcSAMCjis5sYoKJ1YAimZZQ6cTb43tbJvmU1uEYCS/WTgcY3+gaiqWqHGnB0Pmtz6Cr4KbS2STw0fmOw3WE2H28iYvpQ3FJaNgnxvkOTNZ+NviP2gSUJNc7Cc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB6007.eurprd05.prod.outlook.com (2603:10a6:20b:b0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 19:53:22 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:53:22 +0000
Date:   Fri, 24 Apr 2020 22:53:20 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Erez Shitrit <erezsh@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH mlx5-next 3/9] net/mlx5: Use aligned variable while
 allocating ICM memory
Message-ID: <20200424195320.GB15990@unreal>
References: <20200424194510.11221-1-saeedm@mellanox.com>
 <20200424194510.11221-4-saeedm@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424194510.11221-4-saeedm@mellanox.com>
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:53:22 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 70beacfa-dc84-4b8a-9577-08d7e88924df
X-MS-TrafficTypeDiagnostic: AM6PR05MB6007:|AM6PR05MB6007:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6007842F36098AC9669209BFB0D00@AM6PR05MB6007.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(6486002)(4744005)(2906002)(6862004)(6636002)(8936002)(5660300002)(52116002)(6496006)(107886003)(9686003)(86362001)(54906003)(33716001)(1076003)(316002)(186003)(66946007)(16526019)(33656002)(478600001)(66476007)(8676002)(66556008)(4326008)(81156014)(450100002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LW1axazG7v2eMNzsG/Mgqy2nZA6Z9J4XQTe9LJh5xy+KvRU3p7jpWlCmPMad0eOU28ptilMWB0n1SdNJGkMMev6UBhpdScfzFAY3XGgDJgFiJe9QF3i/YeYEX1xxYWYpqZBHSoLqGFFk7MHXDZsmehI0mKgFkeuylseJ2jzV8CjIsTkH/WDoX1InzjN9PuNSVpwTR1rOLUXvhTw0rX0KWIhUindlTbO2cgFG4YZNbKXlJq3IkYL7t6MGm1tMY6I5mQHnSsmnAW8V0DwyigdvJ2B2N9xLJj+YXVy3GnWTrRM2Kn0GAJsTGgUm64ISYv1sqn/CfleeRruuw4ZNoajBhBIKTgPI2MF6qt07o4imbbHrCRR22VyKZpVuPmrCTTHPYCwG+Uv/ToN6J7E0glsnFcM5ggUOap1wLmpI+VlSKjmHt44sLC3C4vk+U4e8LDKK
X-MS-Exchange-AntiSpam-MessageData: mRBkKPr87A4iH2JDQQXuqBs3k3E2n0MCAeeb+mla+fbD9nKeUw5Nig2bRQLWUoW+89WcLp3FRM+6hWc1oSNwxCHngcaAVWht9jBpkTOjdqeLbdPbQmWzX9FCD5RcpnDu79q7/GtsEKZ3HDh+MbdnQ2F/PQNdZmmkkHi2R9FDXS8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70beacfa-dc84-4b8a-9577-08d7e88924df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:53:22.6608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9vA1mLbSbgKMysQdguEdTM3+kETDgE5r23wDhgHwLL6tm6hBqn+17Hk9dZ6e/Jxvrypvyc9bqum7Qh2lmx+kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6007
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 12:45:04PM -0700, Saeed Mahameed wrote:
> From: Erez Shitrit <erezsh@mellanox.com>
>
> The alignment value is part of the input structure, so use it and spare
> extra memory allocation when is not needed.
> Now, using the new ability when allocating icm for Direct-Rule
> insertion.
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---

Extra blank line between SOBs and no line between text and SOBs.

Thanks
