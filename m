Return-Path: <netdev+bounces-6042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E057271484E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:07:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87F771C209BF
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7426ABA;
	Mon, 29 May 2023 11:06:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50FE6AB9;
	Mon, 29 May 2023 11:06:59 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F83DCD;
	Mon, 29 May 2023 04:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xw4SXQ9HcdCPFKMr5zz5LOhh4OKWEnNI5nAQn1D5C/Ko3WZg/W5wl2Z4S7XtRTTzWoU6lomgzupJPkZn6dY2uwYBQL+ooaRfWkeWmQ2MsILl0XnrOG2OqjYQ6b+X1RmPGu6b1KOMs+00FvPtK8PnwXcDtKvNgZrcYwfTlZE62ibMvl4tgnWhmxOrLylMcqAcOXUV1BLDShS3YKxs6Lb91S4p9NpKZgpL9LZi1W/ggW046Gf7qe4W3Vi12LIoAxS8n9ZifQER/qgEIthq9UsfQP9WWNS2ycofLWTVCwf48aLdaoNLESyqdCIxpQMIsuZ95SzsvGBNMhAN8mShCkYnZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gi3h1reoM0gsY6r5M2Jk06Jp01CYi5Oma6M4dgU5KQ=;
 b=e/0h+nAo71m4heYK6Jv2jsX4Jc6sKIJ6wKoVFA4PFFpCaBc3Zq2pXqlDx1Pe/fxjRSOnf0eKzVgz1TXb9/nJs9Zxx8ysS9TNaFCjOFidKLTloFFpIMlrXMGZvOUIZmJxC3hkCKVg9yLSVbXec6tTKk4Ul+F+RLf0u6oPORPKhKwUEwrtnIe13D3xVnWnmftCgnAvBLt/HO8eht37ZId/vi+8BkDDz5aBrzlOOMjcr8I9a6wJ1i9WQFh/NmPENnt6vyUMfRPlm5VSYLXpdpxHkz8TFSdkFK+pkY+953lGq+EOkBS7j3aTXOIMAd0TD817Gt3DjaUPItuhAoBbAJrDQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gi3h1reoM0gsY6r5M2Jk06Jp01CYi5Oma6M4dgU5KQ=;
 b=R3d0zKY9rq+1hkqNuNlFZtQZ/FmLcklDQXjxPR0sDCRBegfqI1f3EEJTzIRl6DFcUIsWDldH+ThEyLsFkvawzSU/f5CQZlFrXM03F1JMRPtz/vIQdh7bSVfvLQQxmWRzsaVCUw/+OgDA8n3EB2LUaIOHOvuPrVHyjhvG/ycpQdJFoL8ueOyNhsHn+vLg7JTkUHw21d0WOXkWwQe027s/eNvwJy7ITu7QEk5JeENtAtvK7N9Ciw4GCyEEvnNvyyEDrq+tu20l4zolVNvVfywm+fTB6TA4NUwyas3tBdMUGNXc6Rv9724FrNwyMBPNWJFGcx3nXK99B+/TtfzdJdjzCw==
Received: from BYAPR21CA0018.namprd21.prod.outlook.com (2603:10b6:a03:114::28)
 by PH7PR12MB5709.namprd12.prod.outlook.com (2603:10b6:510:1e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 11:06:55 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:114:cafe::6c) by BYAPR21CA0018.outlook.office365.com
 (2603:10b6:a03:114::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.4 via Frontend
 Transport; Mon, 29 May 2023 11:06:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 11:06:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:06:38 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 29 May
 2023 04:06:38 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 29 May
 2023 04:06:35 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Alexei Starovoitov <ast@kernel.org>, John Fastabend
	<john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>
CC: Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer
	<hawk@kernel.org>, <bpf@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	<netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH bpf-next 0/2] multi-buffer support for XDP_REDIRECT samples
Date: Mon, 29 May 2023 14:06:06 +0300
Message-ID: <20230529110608.597534-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT039:EE_|PH7PR12MB5709:EE_
X-MS-Office365-Filtering-Correlation-Id: a1649c17-6650-4db8-6839-08db6034d016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yiJ3UlFmz1NauZp2N8fQ0zh/VadtXSUfQ8GtlRQHQJtqAUKXV1VTwimu6LouARKk/pz+q4q30a+IZZ8hpKvLMMQjd6M0NE9mckDny7Qq5OggrQ9Bc78U272stJZ7FQNXUoFEbUGrcuYO0W4yEjDq+D/YA+OZr/bd368SB3pvAnjUYpdJGUKcJ+BENw4qND9kd1i5N0yhVdnQs9ziVYr3r1aOMiBlLnVe8ob7KaCVujXmdoS5cy4nEt5ixFH3XwrdlOCqTK/+NWQFKK1eFM0Gu9vTqxq0F0oln4xZHfDwE9Pgn9hfMCrAaF3GxtVpQl8KfkqsyDszcku3gIXVQVBO9D4qbfx/G+C4r/uhHDhLo2NbutxturU+bIcuegdscoLNZcu4uvzL6TG12Ex9XZMG8DJI1gPQh1I6phK8sp2opkpD2V8KdaNFaUcjM8GO72rWHvqhCIymJ2lgi5MnxApK4OUUhIO/b3JNZXWhfBonqKBO2WNoEkYZKotChvvNt7hi3HJQlYHipBJyV8GuNbdD6es8QF5DAgdO7oJeo5nJPdLhb72HZU11iYs6zcKCStIf2wWK4Ue2VImA63KiiyKcgNmXB8JL1ZUR0L8rEDbt5FWfl1WMm11WCksUlNnxyXRwrBpzRPRdTOm8YyyTZsTe3PIZ/+OFNJqQVwHy/9e9Cz4VxYfdq7Mcr6NfnXIEWUjakDI52RVKyNeWY/iO1SIaIIehcVyi1sF9UasOK3MjfhOh5FtxbrD1SexRveZwDFoR
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(70206006)(47076005)(70586007)(4326008)(36756003)(83380400001)(40480700001)(5660300002)(40460700003)(36860700001)(107886003)(82310400005)(86362001)(41300700001)(186003)(356005)(82740400003)(2616005)(7696005)(8936002)(8676002)(7636003)(4744005)(2906002)(6666004)(316002)(26005)(1076003)(478600001)(426003)(336012)(110136005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:06:54.7346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1649c17-6650-4db8-6839-08db6034d016
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5709
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This series adds multi-buffer support for two XDP_REDIRECT sample programs.
It follows the pattern from xdp1 and xdp2.

Series generated against bpf-next commit:
4266f41feaee bpf: Fix bad unlock balance on freeze_mutex

Regards,
Tariq

Nimrod Oren (1):
  samples/bpf: fixup xdp_redirect_map tool to be able to support xdp
    multibuffer

Tariq Toukan (1):
  samples/bpf: fixup xdp_redirect tool to be able to support xdp
    multibuffer

 samples/bpf/xdp_redirect.bpf.c     | 16 +++++++++++----
 samples/bpf/xdp_redirect_map.bpf.c | 31 ++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 12 deletions(-)

-- 
2.34.1


