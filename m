Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209C85F4121
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 12:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJDKzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 06:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJDKzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 06:55:46 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1032553D06;
        Tue,  4 Oct 2022 03:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSNyfZ+vrH699XGEtYOIcJYr3JlWxhMz2uUhfkCuWwfY8RmoUq3ucQDbc3Y4uaRuo75kHgWqp5wMnh7R21yBOA9hJkFuVAWpfkw5WXcFfB9A+RF2X58at+y28kTvhk7hb2cL0LmBKl76WAha4ulvK7rDtCEg97PptfVf5ttP3/+R4yDWLdthIns4k83iF1asjL+KM7YX9HuC2nn4tYHMOj69ExopFJqzpFH+FECgA1r3k7oFY6uxsnV78SCNw2Ituxfvr+68LXn7f9Ab+gCgxTwLtl8BDc9iwkKj/2Xulr1n0JKDIEshP3QDPvQ0XdiOFVpkU/e77du8/uhg7L3X6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfFSsCq3/SjZFlP4kd0gEYKoOo95BWMIEA8ZFXDO+Pk=;
 b=UzcovutY51l5jVPthJ+KzMvfQEI6td5ivK19iwkGkqzj+HZRHYvONObfrUtrmMzSWbHWoo+A2toA3iMtFTTXErRF7eELMtlY8xhqy9YOmJExa+uxoDP8Yo0JVZgwHfWwGGgAfBge05cMMVLF2E0C3M6IMSv7OYZWii7ORHEu5QMyMZ/SSABaUmRZGPcX2gMa69lYh7qvYJE+D7kep3Ssi1srNsEyntEZSlchbmzD0f1AYteKNOT00rdzD8i9GHhZ47VsJCZ8QOJr3zXCNxnc7Ymf++BE3DRoZP8vSoMGz7uvHXWGLjAXVlpok4GpRuBI+6EjGPUbVwvPMuJ3RLFSig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfFSsCq3/SjZFlP4kd0gEYKoOo95BWMIEA8ZFXDO+Pk=;
 b=sWz1sWY7++HU5jA27cahN06IXJWcFsqvbkFCkBmxP2BbHWH4O51OhuOs4ddRCl0L27KANDwDt82Wp9Ji1TTzsUDSxERWeDKl1IqcAa0rXyydFLn9GHHjLHxN9MciySpGbfMlYp6cHHCrGQ4KMXXLcZ4w2XndY6ylA4WaN7Un4FSqFASYM8ZkgaUNzaklCwWNiM25r/pkdw3SvRLIwSL3uerk+mZymjseOK1NEVesjJIc72Cf6L8hICTpGTfl53R2D2+kZrGCRzSBd4G2WzIrhgDnZxWodHb/W/BEwhc9/ey7XOcx5PHb5fl6+O8XmHv6CBV8CgVAf1Gdak2SxET6mg==
Received: from MW4PR03CA0205.namprd03.prod.outlook.com (2603:10b6:303:b8::30)
 by DM4PR12MB5724.namprd12.prod.outlook.com (2603:10b6:8:5f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Tue, 4 Oct 2022 10:55:44 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::d3) by MW4PR03CA0205.outlook.office365.com
 (2603:10b6:303:b8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Tue, 4 Oct 2022 10:55:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Tue, 4 Oct 2022 10:55:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 4 Oct 2022
 03:55:34 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 4 Oct 2022
 03:55:30 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <20220930175452.1937dadd@kernel.org>
 <87pmf9xrrd.fsf@nvidia.com> <20221003092522.6aaa6d55@kernel.org>
 <87zgebx3zb.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Date:   Tue, 4 Oct 2022 12:52:35 +0200
In-Reply-To: <87zgebx3zb.fsf@nvidia.com>
Message-ID: <87v8ozx3hb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT073:EE_|DM4PR12MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: d0b03083-9139-4851-0515-08daa5f6fc51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lieMt6pIwyp2rIQQCe+NM7fMPdzgt8nmJT6TsPWN9150kTykYXROpkWPkAqIibTbq3UGNah1XtAu46LJWRuZr2msq6RnilTUQsekp7aCQ6FYNjYeyu7aRk+HC3BlfJTiZiAoDhkT6ZXTw8YMQsFIlGZWIrpaZ2NvYtnfH8T4o1ai4AY3XdKm49JVyJsutCMD3tDGXz0EwLwNh3SPeTdwLqfNlmh2oH/vUzq4V+Nb+xxbgx1el+moyt3zk754TOnB1ynGVC3N/2VXAFEfDr2pA9SjuTZ26v1DP8x1YPNMK0ojE0WjWzfisI5JmYscYacxghGt/aYFhBUp//DMk3ZDhi6243jE3984uzb6b00gL+0woZt7Sn2cvIFdmdFhC/BjVZZrxVvA4D6Uwx3gs8xQX5dljp+Z7ZQuNvUAxLjgcFvnPTBeGMbp5q8Jd1N0ZMaNlcyvSIOe4DsgbPdNiTLXpy+/LgCRNd3PByrxnASXIm4bzpmzGICoggk2dR0bK9Tgy6Sh0YlJPiG9/zM2F36ACITnRadbVi5UruuzQOD2B7IpOEha8qjOlqtZ+YfhIKElnRqk5n8+KmiISA8BrR5l5Gin0dQsNSxW+OLRf9gZ3Oj2ozug8d15J9PCvzUozdL4dGoXTKjkFUnCRYNnMeSlwa86dVgEmCAw/6QWV7LvDMZ4TrVrMQmWbt7WWjIbeUW8ZZHxAavdIGRZg6Fosi/3/HpxdLR1h8VWsS4Y1ErTOnSo6F4buj8DC2mnRoAlqHB737dWgoaFED6zZerFgzVilw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(36860700001)(83380400001)(8936002)(6862004)(40480700001)(2906002)(86362001)(82310400005)(41300700001)(54906003)(7636003)(336012)(316002)(37006003)(426003)(40460700003)(26005)(16526019)(186003)(2616005)(47076005)(8676002)(6200100001)(5660300002)(36756003)(356005)(4326008)(7416002)(70586007)(478600001)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:55:43.8177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b03083-9139-4851-0515-08daa5f6fc51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Jakub Kicinski <kuba@kernel.org> writes:
>
>> On Mon, 3 Oct 2022 09:52:59 +0200 Petr Machata wrote:
>>> I assumed the policy is much more strict with changes like this. If you
>>> think it's OK, I'm fine with it as well.
>>> 
>>> The userspace (lldpad in particular) is doing the opposite thing BTW:
>>> assuming everything in the nest is a DCB_ATTR_IEEE_APP. When we start
>>> emitting the new attribute, it will get confused.
>>
>> Can you add an attribute or a flag to the request which would turn
>> emitting the new attrs on?
>
> The question is whether it's better to do it anyway. My opinion is that
> if a userspace decides to make assumptions about the contents of a TLV,
> and neglects to validate the actual TLV type, it's on them, and I'm not
> obligated to keep them working. We know about this case, but really any
> attribute addition at all could potentially trip some userspace if they
> expected something else at this offset.

And re the flag: I think struct dcbmsg.dcb_pad was meant to be the place
to keep flags when the need arises, but it is not validated anywhere, so
we cannot use it. It could be a new command, but I'm not a fan. So if we
need to discriminate userspaces, I think it should be a new attribute.
