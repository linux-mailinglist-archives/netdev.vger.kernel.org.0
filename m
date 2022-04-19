Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EB9506F6E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352889AbiDSNzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344219AbiDSNzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:55:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0201094
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:52:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrzItdAFANcHye1L/4QUj+tkb+cFwrZOIcnBmtYWR8FqkI6WBRmtkvI89CZbVC2HeygAvSMKl2bNERCESu1aqwIy3OE1X5HjsNNkSqCkngMNAKjPnekXExq07U0q98ieE85siqx8bfub7RazB448ggTk+u9ujA1Gc/GgX2C+rhCjbYhccpBybkMBFjBaxBnagguZqOL5yOliThNyEAJbUEV1XIj96D/or1Iz3fbPQjQWR2X4NZ23UtMI3GSu+kldNjWgyv/+i4yCBgJj1OAXepK0XrL3OrVQKzpQVxTEU0SqyxLZQr88FucvX8+KQH/cTM+qte2SKwNOPvA+hx75yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJSSoDhwUe6gFHNdmpTxPJori4blbGJ+SCmRW2hbKu4=;
 b=SPTFleFB7/aQjPmr2e/FnIOu5NBmTjyZNl5R5NBx+LwKA3oXEd0PKpt7QFPziw5Ez6iVcqONZVIQOz4mwRNimN4BGPERm/MPl91/NDORwRjnrCqkyPTjVIwNSTRRPrnjH1FicdYjg+7Y5Ph3xqG6FZjT3LfKYcK1oaxLpxNOkvu/Y4Wi2XGapzUoJ7XQEivC3rh0FH7Vd5P88kLQVNl6e20GKtrZvyBtxWCM9b6o7GLr0mwepayOAnyCNxADUoSsXWuNAIK7EnAt8hNkj75+akuD8Zk/iy2w3iQIYv4mtqxZNTyHOVsv5cHp/AFjslc1lcHHh949DLirCqHxTMGsgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJSSoDhwUe6gFHNdmpTxPJori4blbGJ+SCmRW2hbKu4=;
 b=VknUZGzTFZBUCqo0EPrSm51WUCab3sdqlgFgZtfHGB6SiJHHGPF2iQhpof6TkboJuY0agPYgm/+L1biM0bPBvYZ7vfGggKw2gAfr5hfL1LhFKUBGez0lengWhz/KZywUizUTgPui/34VrSJZ/vVnt7tIn713vLuz7TNzYdVRD0F1mEws2EC3VLoRUpshj8khYOu3H2A/lDWCykPwgKYk3O5CeVLDcC6Nu9mZb3d7YH8W4dqR82eDCUP29w1ci4TYrT51fGYOl5pnvpipScx7ZGXdSNKkpqkr46CIr4LeFQxNL06WtCnc6FlBgQ1ANiBvy3LSBQEZXjEPQFqUZTW7rA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by DM5PR12MB1850.namprd12.prod.outlook.com (2603:10b6:3:108::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 13:52:33 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 13:52:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] selftests: mlxsw: Make VXLAN flooding tests more robust
Date:   Tue, 19 Apr 2022 16:51:53 +0300
Message-Id: <20220419135155.2987141-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0100.eurprd09.prod.outlook.com
 (2603:10a6:803:78::23) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37bf2a5c-1268-4677-a11d-08da220bd8f8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1850:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB18505CCAA73FA558D5F02937B2F29@DM5PR12MB1850.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1kF+fZo/WxXc4ZZf6E6BpaQwpokiUirK7Q5nHVvVRShH2EKtloiZulOhZo02jetyrpwnBriksD3oGi8qBTGUWXh8uAX0kINYOk7dPqeA3+05KZkTJLZ8ModQY92DQ6LIk5Qpo/1E71MFdP12hsqxqnN1Esu0+afjrxS71PNkHE3dq/lVHvCEOlwdtR9U+Ntdt6yqsTCydrixCFgNP5h73OBgXJpuVvIZ7jnpoCt7zZWitl3NngJKoq4BW7IVWDC5lBqUGs/nagJzF6f/Z2eIYvXK9Ptuv6xMbJt7O6MBNZzteW1vXRxoo9UIlhnsrAU7dtG3OKxB34S6g7587iS7nbXyAQ0jvZpqQmgND8LtZBPJDwh5zRih3bx4BUaBOFbeh2LsALFbb82RV232rv5fte9gMbdGF5bBpBFByl9DpyKaICfsH7IFXw+QhknAeoxr4jL3sPKnxOEfyJERJykI/hAlFSvWRG5eZq78XW0atBclIwKn2EBfiQU/7qKQyvzJHphLorHUqZbdcFckMWOqoxQS84eWTDfd88H0xMJl442845gy94z1goYwB/Z4N9DE0L3DGT6cZFUUZX3hvn0riHzTSkG15LHAz+IjuW0MIDoSPwc9mtigbvB+bg5Lly7n4zzlIFnLozc36jPGmJv+Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6506007)(2906002)(508600001)(86362001)(6666004)(5660300002)(316002)(4744005)(36756003)(6512007)(1076003)(6916009)(66946007)(8936002)(107886003)(66476007)(66556008)(6486002)(38100700002)(186003)(26005)(4326008)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/EA8OvpUj9QWGPay/IEJJ3Nudlo6cOmKar1bHbWoeaEkHyaig3pRGSykvJuB?=
 =?us-ascii?Q?j06xVTo2fummIpI7kOPx7l2nAn3RITG1qaIU/XhQWiUWpYoxqHyQqmbb9lB+?=
 =?us-ascii?Q?5xHE/KY//kVCj/CjCdDQfkw48aqCoqXGASD8Ims5iVqSioKKg8bn1wSV5gU6?=
 =?us-ascii?Q?5yKdeT3th9aACzJfy9H/UxR4crRcWr6BZkcoZJavfv0BN9Or3JHw0esRCBGp?=
 =?us-ascii?Q?FZQarX3QAyYd4auW/JtZp0Dl2lljx0dRxGzEU9XwQ3RTWAXT7wNuNzhjC+VI?=
 =?us-ascii?Q?0HE9LhyT9rpQO5m+cQShPI26enhddKaWDyQyNyzsgOln/1Xp2ccTrGIeR/va?=
 =?us-ascii?Q?ajFBkV1yl6ZNYWZ0RvnAIbAabwQ76XEfb7Vt1sgbVUJvxtrEKe/RzubSps9C?=
 =?us-ascii?Q?MjHZ0rXmPcJ/vA9+Il/qiZlBqCxjFj8yWooZlfVODoO6+UTqLyvHGnc+MxuP?=
 =?us-ascii?Q?+6G5az0sZKI63y3EGBO8TB5DM7YY4ooGExX2F6Juihy0YqPPEsSwzwLe6Xls?=
 =?us-ascii?Q?5u46PX5SGPPHX/G47LNhEG5i/Hbeb1c9UaOBZrpWcmg3Txoid5OCr3mo8rOP?=
 =?us-ascii?Q?X8WBkrl0GpdYQVB4LvRa+PrtUUIVENhJGM2ZJPME5rK+RwWkpapOiAUruQUW?=
 =?us-ascii?Q?+E915F1IwyIxEhPAxjkQAnxyqn87Py0onD/BfcwBJd1zeTMXXDqSYW2+ptB0?=
 =?us-ascii?Q?m9qxX0/2Ge0iWviO9IhcNWq3OQuxNK5YoNs/YFRwkjLxtqC7egz7WBjk9Eao?=
 =?us-ascii?Q?bwhbtuqWwPCm6yxJYgxRjwDTLRha5defmP52Fq6lmqObOJxYyjoD74KgE1Zh?=
 =?us-ascii?Q?b0kl8+jyGoPQQoamimWHU+Jhf7y0gfZpNZ+sUUTvo9/gOPWyGms5duwzZhRH?=
 =?us-ascii?Q?6dViwPybDqLYVAj5bzElpnWXWiSXg9esJ/88X/Q7zbLRNSikO44U5Aq93OBF?=
 =?us-ascii?Q?HR7QVKoHGaB5UtYcbe+5ZEKBEzujc0uTqzNZ0egbIm8yRpkuz4oxCyCyFMBk?=
 =?us-ascii?Q?GLi9czAHGgq/5mNop70e5abXFJx2h6p9wPie0UgSJY83sJZu3qOMsiqBuK3e?=
 =?us-ascii?Q?x/ZoitMkQOtXcIqBrUbDG3zyYAPBWEHz1xcIi6YS8BxKqicpowwkFfKbYAjm?=
 =?us-ascii?Q?teGYTl537ATQ0Qkr5XUZSI//CRSw3WNvIEttQdxxXA1W1gjWulBLxoYq/a64?=
 =?us-ascii?Q?EH7S2zDbNi3xBQV1H8CQ/72OgL59ilrobtoGwqDBx9eaesewsbjyyotXwZxC?=
 =?us-ascii?Q?9+ftRM3KgsVA6I8bhMBL0xqS60/uoE2SjfYabZfrytCPjzWXU9VUpdc879RX?=
 =?us-ascii?Q?wV8urI2KAT+v4UBcKWsC3MpINU0FJnA3t+d6o4HzpZKZO29mHNNMuGu6yICx?=
 =?us-ascii?Q?mPXwNY5n72EfdMpZg3wJNyV5IENL9yULeBPFG2wFimCoqi6thI2ve33ntLer?=
 =?us-ascii?Q?LGV7q7tKCjKfYvghmOT+ohspCX+0fSAYC0lpLpO+dETbfbZrrk5Hbifwk869?=
 =?us-ascii?Q?7Kit7rgTxte9n9Ua2uR+2qh4nfaMhk1P246usAR0a2MlBWG4qITLVknzF0ak?=
 =?us-ascii?Q?mdhisvNENjoV4cCDPY3gRDBVbun1VNlFxGERe2UnP2P5AmPS48hbjB8b05op?=
 =?us-ascii?Q?AIQ568Cbtm3Nl/CbUZWhxGuBrP/S3ah1EBrkNWFt8kjY5HAJTBpgiIfzW6De?=
 =?us-ascii?Q?zG4xjI29elG98rRgamjuhfCeqD09/qSkQ8eL0DcOsKayrmf+g2RAgblCov2b?=
 =?us-ascii?Q?0cv/3qrmnA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bf2a5c-1268-4677-a11d-08da220bd8f8
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 13:52:30.7753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wlog7+zW/hr8i2T4W2iGklEnakqbxkSncUwvQAeFXeYUH6nemBwrDOO0O+V53XF7Fml1W4ifoaeQywzYOw/cXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1850
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the VXLAN flooding tests (with IPv4 and IPv6 underlay) more robust
by preventing flooding of unwanted packets. See detailed description of
the problem and solution in the commit messages.

Ido Schimmel (2):
  selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets
  selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted
    packets

 .../net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh | 17 +++++++++++++++++
 .../drivers/net/mlxsw/vxlan_flooding.sh         | 17 +++++++++++++++++
 2 files changed, 34 insertions(+)

-- 
2.33.1

