Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E449E5BC5F6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 12:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiISKDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 06:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiISKDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 06:03:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A0422BF6
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 03:03:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/lachQzYn7BwCQGEKG5/k2GEa/5bJacwAq6bnrx33rABDErKDDh2nJR4JrM7T654pMtUwb7bXXqVdsKiska0yeOpXvbj9lMm272wNKJPLjK3iCUfPM1ZlsSgV5RYiOfjLB/cOBhQQtoJ8pbRo9q40EtvnYgNfmBN2w5GBS5gZj01NOyfyeNHOvlhYEKhDRkKwwiT0Py7ZT7953uzaa+Y07OpzlrN3l4cq6/puBQ6ZlVPse36U8ij6ffWPZ8U/e7borjl81UUPoEK7Fx9/xoDCBPvE6WbDjYJ1DmOiTqS/XCTUDowRVFVJrTSa6FMEVTKB1DKpY9rxmYXahndZNEWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUT2+gEaFPzQlw0Ee+tnstpsdUcEA4kD18eBvaqtCi0=;
 b=MA/y3j4M9zN9G0okl5jsDp04VlWA9kjnvDu7v1gsyLTkMXwN7vGh6dWXNtaynMc2kTUYaYUfcBDQR8hFhRHcKiJ9jVr+jyYab64+9R95pOc9TBGImiCd8SgQPH6WvPcBhCzVsu6BougXvBVGV6WtOIxYzffazkTBzygXe/I6OYPNL40xO6ZELXbwKxs+XTIzJSo0pa+6x09mUrITOIZr1KYsV3BRZ5OhVoxKnYEb9e+6kAvM0YKbVQO3rtUrg4AI2N9dGkVu0IlwkC060j8Lk1u1A10a+uyfmW09mEQyp8Y/hkHi/gzHILEEl/jGQdnHWmeLt9anxwwSUR4ex6OBTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bootlin.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUT2+gEaFPzQlw0Ee+tnstpsdUcEA4kD18eBvaqtCi0=;
 b=LGaEzz5zwGNzL8CZi3qlgVyF61omUVqWP6acDoyrQS1cXSuDN0yKWq/spIcyD4YUKYccY6Cax9RIt0440Iab7q70GzcbotbUIpsBazvHT8ipy/kTQv9f8UoT8HxIaRB00avbKU4u2UyQlOvfQ8gGkzGGKc7nM/zty3gAL3kLrsbQIndRXmhwX52K/EgWXnFN/ftTD+8SmlzSE+bxkcfZSzxJcyPOvGaYmb3dIe1JWA8MFC1u/pquVrBs2c+QdENU1c0vDutbhiTEL75ugjyM5dErGZeLvxvlqSqveEBUgsb7izqZteIKt4dMG7M33phspJU4Mwl9P0+a2wdu7jkjPw==
Received: from DM6PR06CA0050.namprd06.prod.outlook.com (2603:10b6:5:54::27) by
 MW3PR12MB4396.namprd12.prod.outlook.com (2603:10b6:303:59::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Mon, 19 Sep 2022 10:03:29 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::3d) by DM6PR06CA0050.outlook.office365.com
 (2603:10b6:5:54::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Mon, 19 Sep 2022 10:03:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 10:03:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 19 Sep
 2022 03:03:18 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 19 Sep
 2022 03:03:15 -0700
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
 <20220915095757.2861822-2-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <petrm@nvidia.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 1/2] net: dcb: add new pcp selector to
 app object
Date:   Mon, 19 Sep 2022 11:45:41 +0200
In-Reply-To: <20220915095757.2861822-2-daniel.machon@microchip.com>
Message-ID: <87edw7y93y.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT063:EE_|MW3PR12MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: 36751327-db5c-4dd3-5cb5-08da9a263396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: erDrzcQA81FuRt4Fj5n9QPFQqu5XF5riDIj2u2wmhhYmHy0V1nRUANiitqbQ/ihCfdzTtc4299lcTuUogCrFSgHENc2ivmRjpcOPeEtB15RvNpX9LO3Eoltc5K5QNyQwglYT6nfci0L5w2b4EzAVwfJ57wAHX9n/eyPH996PqdwPxTvnX6DRzNfaELlSA54C7Ka24HC0MWb5ChQ03W1ykeiTLovy4OlyG8nl6BUc5Jm6nuFpT0fOFM+2reY6MeB/l3HtwhciZkH6ZKjk1bbNLFDVgN5TjdA6RRkKsQoA4W+dP3NQ/aWt/DUnJuw1B9KZYzTIUgZmF8Vm5QYDjq6oS6pBHwTKZy6YkX37DQJmLcd5UBZkxVbYyAdQof0nROeKBvQXl1dJVRzSWthWEmG0cyUTPyXLxr9da7JsMpmdggqiM0qE1HFOgGs2Atcs1BtJH3msvR6czW8S3/2g1crl9hU3XxnGpTndtBN2qAuX0U3rrOb5BtGN6jV/M1UTg78w4ZDi4wh4u7kzYEaz9WFcGwAKQ5cJ3NkIddBqvVoAv1PdDZIp2SIL/LrPxYkWNp6OvsjcSKuqXC9dX5RkFYvfOSLSGFoK7+Twx16508W3zKt7h5pIBi6LjM3rKMkO9ao7+EYbqvooJa24ImKP/ST5u5uAx6s3XABUeoJkAu2LdEKjd3HwkfATc/wzX8NH0l+gz+v+sUWdJY7J3tIs5BVeD3FrBJ5xwvwEhN99F5WtsijxT9QUiFcae6aCws0GX1Y5RDGsO8/bPMHLc16QeZiKsA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(8676002)(26005)(82740400003)(478600001)(6666004)(40460700003)(7636003)(356005)(316002)(54906003)(6916009)(83380400001)(5660300002)(186003)(2906002)(16526019)(4744005)(336012)(47076005)(426003)(41300700001)(70586007)(70206006)(4326008)(36860700001)(2616005)(8936002)(36756003)(86362001)(82310400005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 10:03:28.9711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36751327-db5c-4dd3-5cb5-08da9a263396
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4396
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> index a791a94013a6..8eab16e5bc13 100644
> --- a/include/uapi/linux/dcbnl.h
> +++ b/include/uapi/linux/dcbnl.h
> @@ -217,6 +217,7 @@ struct cee_pfc {
>  #define IEEE_8021QAZ_APP_SEL_DGRAM	3
>  #define IEEE_8021QAZ_APP_SEL_ANY	4
>  #define IEEE_8021QAZ_APP_SEL_DSCP       5
> +#define IEEE_8021QAZ_APP_SEL_PCP	255
>  
>  /* This structure contains the IEEE 802.1Qaz APP managed object. This
>   * object is also used for the CEE std as well.

One more thought: please verify how this behaves with openlldpad.
It's a fairly major user of this API.

I guess it is OK if it refuses to run or bails out in face of the PCP
APP entries. On its own it will never introduce them, so this clear and
noisy diagnostic when a user messes with the system through a different
channels is OK IMHO.

But it shouldn't silently reinterpret the 255 to mean something else.
