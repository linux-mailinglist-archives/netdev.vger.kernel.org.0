Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F5A5770E3
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiGPSyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGPSyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:02 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E35CE024
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRZZFKglcxLMiRKj5KUb511FQPPCtkdNlt1Nj6fIPIa2w6VkibD7dJJ9ajoIXjKhrZAJwWnkg3WqjZ/Bcu3tZs92XNH4o3mQHg4CQ05DxiSyvm7KYn26XxDAzYjXyzQ9jkmzL9Km3eOAiY8an/9V77a1fKzxrKk0wMgPKKuaqAft+0ACsTpZo61Qp2JbSATICwxHH6IJPvAucIJE5vwG13VidaOng8bqDja2NVfZ2bERMG+2OBX97eH+W7KJu+WD0U3hIkBPBIGoOmOnmuohDPuuoAQR5AipyvJoDaHYA04tMXLhQjzyKUlt9V2LXWx7bcRq74Hwz/GwVrvLuJASSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hu6qqIK40xjUjNbw/ffyeHHcBLqiMwxH2vnngzmgD0Q=;
 b=GR1dxq8ouL0P6BVN2axfNVkiG6HQBIWOcBTcY9oPCMR6nrCh2QAToc7z0QhPPCgCKV41i/x0jH6RFs8nxwvPCColWjRmx/L1nJ01dTkz1Ne4wjl5/xpDDwfn13dPInL3YLVWX0sCIyysiDAq4+oGhHpS/SuPJFhxlslQJBjI42jc53I9emci1p2R+IZ8O18/by+C2t2chceXIw0p3WA0OsfyLo14mfX+zOtOGpAM3dApmkM+d9KNyVMpkiU5xClOsvPhj3fmtgR0C39xTP89RPIwT9TIgSx9KFdppth3BJvBx48nXLEYEOb5+Lw4ygIzSQgNEKmj4gdSR+mOvFCy7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu6qqIK40xjUjNbw/ffyeHHcBLqiMwxH2vnngzmgD0Q=;
 b=qGPZm2zRY41XWkpozORvX6jAQ7SEAxAvmXXnFhnzDiI67yTT6hw31lG9qBRz9w8hlSpqiZrWJfHy2KQLPbAfvf7Ev4gtRMx+DUjGH0dwE47EdJxpvG8Hly38onLKoNASeI7w9/jW/Zob6eJGTI6w6zpPiGBYRkcgZc/7UNdmfBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5261.eurprd04.prod.outlook.com (2603:10a6:803:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:53:56 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:53:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 00/15] Update DSA documentation
Date:   Sat, 16 Jul 2022 21:53:29 +0300
Message-Id: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a3937cb-d1c2-40fb-1d04-08da675c88a2
X-MS-TrafficTypeDiagnostic: VI1PR04MB5261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjgfRuCZNNGCoLKZ2WJXf+hD3ZPBaYIbcR17BBAK1IOc0aXkO8x2f/qKjEKyM0Q3oIVFTCOdCB2mpTj4vnl2288NxtFWmCgisdNLUT6zJLhs/r2eVrFMu4a1zaeeprVv01A61pvxsp5q/Wqyvq+Qsb+PG4/Wyti6q9PC5eKJ6qvu3MMsPQfgmJ33zb9jH53a6a8Qh0BNK6EjOCjX3y/K6+u9MkRhUeF3RL60+wd2wHgv0kTCg0iig4gmyJJrrmgpR4S0cjV7veNr6EMX5xKWDGr7yIktyX4wYfjZq6LLpTXYc1SWylFVBmg/yNpHW61W0pTquzdXH/33J8om0Ytejtdd37QM6fTJvjnGdDsoDyFKy1eT0JUl5UPD1LX7VwzJrZmqt4GxcmZ2fbLjShicm7BQ6bYe/hLinMNRUIZWVjq6K55A3gLGo8GdSxSiMfZh3Fm48vo2/NZ93jEKu2YRepbBvvs8HKXmlXREuQW0IxFrNZ29M6dBAJf4dMkJHapDtm23F2iU0pOfHRHplJnAz3tCKIFFxQ7hpTux9b+ImTOxPxFfShMdx7T/2F9SITIFsKiDgk23od4688oUvcFsgfynxsvwSm9SKynJWVxVhwSZLNEiGZK2o72iYe5I+XJu0Sxjg6hMXwdL6XzJwlDijmhOVvwMmBj4Z17au2DNi9sk4NZRsrKzkq3ghSwRbz9ZwsDGExnJCmnbK7bnQAUdXIHTCS4zp2s4UQYLQayrJvkEL1LJfTccw3eLWglJX49lphtzCWWytuzBxwXyAPuhJCCq6kabrrh2J3xkOzOur2Dn85AE8jdD4kO5sIK8j2Dr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(83380400001)(2616005)(6506007)(52116002)(6512007)(26005)(86362001)(1076003)(38350700002)(38100700002)(186003)(15650500001)(44832011)(2906002)(8936002)(36756003)(5660300002)(6666004)(6916009)(54906003)(4326008)(8676002)(41300700001)(6486002)(478600001)(66476007)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sP2ve8acAJOsT1zjqJXg2RujlneQjb12LtYs/FeIL5LRO2K/YqKef1DPw5Bt?=
 =?us-ascii?Q?ke9bhp1e1ETjGCUE26MXpQZbjgNuCIK9hcwIvbiFQxxQcSlF1e7f19AlV8TR?=
 =?us-ascii?Q?h9sX3AUqjDnM9k5VZFX4yEnneAWgRSezomiSMECmL8evG+/nfjWg4nKUmJLc?=
 =?us-ascii?Q?WDQ344g56O1pJ4gVrdoUwLZVrv8ebQefH+sMp89mtY990Ece3jOi2zjBqziP?=
 =?us-ascii?Q?X7y0e4ZIlDrv9bG78G8jXECVgC1tmAvzAcmkDZN8gLv2g3yfl37DTzg7mDBh?=
 =?us-ascii?Q?1ug+VGr1BodNlM3OcLvSy/v6dVs47zuw77AvxdAj1D0Kr2viOBfwWjL9uyGu?=
 =?us-ascii?Q?y8d1dA+mV8iOlkt72HZnVbXEir1LOVPobO1dwCgC+nujAxyaTpMu7CxwWXM3?=
 =?us-ascii?Q?vbJvvB6gW1qB0+Tv+Rr+7rNyLKlDDHIWyHj4VXGWQZR4twHyiL9hOoLFCX/G?=
 =?us-ascii?Q?1F5ke7I1CCbT257VAkzq1Jo7Crq6wAp8px2ICDK5WkAtcnLjdkfGr7/EVaDA?=
 =?us-ascii?Q?gLwRwrkiG+aWiRMrZlijZizxggXrwKlF0CQPyJJZuEVBVZZ6WKiqdlOmzLan?=
 =?us-ascii?Q?PL6pegKGP1xDGSAee5zsuApGgTmHWtXWDAAp0pMRBvmx8UJMqFCwHpfk1yQa?=
 =?us-ascii?Q?jPtoWCaoziOIpoStRzyQ8M2pOgQYPA8ldlZMGlwN4HfQvXVFQUNXirXlZMNR?=
 =?us-ascii?Q?3fjeNyrVq2uUFa39HA+1HQwb9FB5NZYsrRU3VfXTWcH+mB8ybegsEeiDioWq?=
 =?us-ascii?Q?O3B9b1lirwwrSOMqJybDiNpKzbCS7eN2Snc/ELY4AK0SYA+iP2WcQECKuEXj?=
 =?us-ascii?Q?t/J0H3D3xDDrwsOv/SYdu0IDwp25d3tTOdU6xru1T2US/lhunbd93Uv2YiON?=
 =?us-ascii?Q?9ivCC4c6IDmfXxghHlMlR6OPipkh9ZS9eZfdreaQhuZIwphV3gheoMfymsgw?=
 =?us-ascii?Q?G707bav+3zjNUdWitGNRXtYvtdmX8HeYMTZy05zyi3NHzo8mx7CQHBkyJOOz?=
 =?us-ascii?Q?Ur/z9qEHmyb6MVCv9at49HMl2vpjO+cxwF2lhjaAikM7GzE/j9qUWQ1vSrRj?=
 =?us-ascii?Q?EjfHtJQFfwjDcQX1qCTQn9KSDWlIaS8BEHZAVfPyGJmIRP9thnJ3w73XYVlK?=
 =?us-ascii?Q?kWr4sbkNA2Eyv51OwBVqs2jtUzWP9pzmDVGWgyn/CWvbbVp8cc3cRzlYS+Gm?=
 =?us-ascii?Q?DeReTsTed3Qy3F8HGQoSeEbpiQPPbLy9x+rI6gOmLABnPckObuZfIQ33Rqgo?=
 =?us-ascii?Q?Zxi0+lx5ryG18gshtiq0VFATKJGYumrYzUEbYpq5QrSkO8J6JQEc1nz4gxlX?=
 =?us-ascii?Q?0Wnsst1n1oTaxsXWKn+OHpsKILG+8cZIUZ2v5+NogT9mGMgX4V1KFuxTL/Iu?=
 =?us-ascii?Q?/D1QJJnP4c3LQuOp8t0ncrPFMyJyUBjFpxKCy5KC7mqkH7sZ1EAvQ+YGdh/7?=
 =?us-ascii?Q?A9au7cPDP8BoNHYOKO7CMvU8urm+yk2xaSNNtEpHDa0LFnuxoVG2K28QCagf?=
 =?us-ascii?Q?UKB3DChVCLuITWd3e/g/dC7IalKFx/O6qV9xZJpwihsAaE6uhf94eId284Wz?=
 =?us-ascii?Q?dEgN3tTNQsS/jA77bUkwHJV1WoIZijyLh9jAUJwqEAhOYZf6ktTGasVLxaNY?=
 =?us-ascii?Q?5g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3937cb-d1c2-40fb-1d04-08da675c88a2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:53:55.8011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Je9PleAQSY8CfCQTectp1VttjTI5q4YrKW3bBPJU7irLnhsjnNL4rPJzuMkS/0cMSTmUlRv4/hQ8Lk89TjyGSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are some updates of dsa.rst, since it hasn't kept up with
development (in some cases, even since 2017). I've added Fixes: tags as
I thought was appropriate.

Vladimir Oltean (15):
  docs: net: dsa: update probing documentation
  docs: net: dsa: document the shutdown behavior
  docs: net: dsa: rename tag_protocol to get_tag_protocol
  docs: net: dsa: add more info about the other arguments to
    get_tag_protocol
  docs: net: dsa: document change_tag_protocol
  docs: net: dsa: document the teardown method
  docs: net: dsa: document port_setup and port_teardown
  docs: net: dsa: document port_fast_age
  docs: net: dsa: remove port_bridge_tx_fwd_offload
  docs: net: dsa: remove port_vlan_dump
  docs: net: dsa: delete port_mdb_dump
  docs: net: dsa: add a section for address databases
  docs: net: dsa: re-explain what port_fdb_dump actually does
  docs: net: dsa: delete misinformation about -EOPNOTSUPP for
    FDB/MDB/VLAN
  docs: net: dsa: mention that VLANs are now refcounted on shared ports

 Documentation/networking/dsa/dsa.rst | 363 ++++++++++++++++++++++-----
 1 file changed, 303 insertions(+), 60 deletions(-)

-- 
2.34.1

