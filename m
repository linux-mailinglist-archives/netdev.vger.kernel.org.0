Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162C254DF57
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359864AbiFPKnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376541AbiFPKn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:43:26 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269B7220FA
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:43:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNc2YbVKlQDlRYrO02xldxfX41RIWmvA9BnXBJJjRvFetWtJ0itdKPyc7f5Ik8jnJIkp+2m4+bLj2G++EVvzukyfSIBKH+hsMH5KYzGNnx9KUSoK+hpwk5Ytyad68IfC8C/A8+nHWxxdOqRXS8TJ+30eim7jr85yIq9SdN/oKomjqzC7HwVkZdGmxHLBxwx8jz8zp8myle0h+r1AkVl9YcyADImeD6SfwlwuHNP37fYZ1Z6uo5yYLV6XVdGJa3EGQlKuzeBI/xfFmGw9ZHiW/EsOC1rmUrKybn2P5JqMZFHT0fTZvkZvtobhbiw6g+2rv6oje5M4wNmhD3HFUhO6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJQSwHsQ88ffer3u25+w1cZfo3J6ilfE1KHMiaNjqNk=;
 b=mgYDPiSOUxOeRaOlSPGlZkAXLXbjhdr7H8+TxOWIDd8V2p68eQAkANrotReCEgIaJdY7RebS7FYZC4A/g0opp0hvBfiSyrqa9vjpRA1bWKLuTcS+7bpZs8Gm/oSxMqI5GdtJyF+xG4j6TyTFr2xGj5LgKZTejg92upDsz913dUYmRGlPcsai2SNLH0tbBBzxn/l/+BNAy7cYbOKVkScnEm4vY4W4R9/W6HueYdovKy1Kgi6PUqKmQ0+AYAduqb8IcTiAiEJsBcVGCyCfv5cPcQ1SODICeCCbXfWTUgYNFVqV9vFAw9nnpHzaMFVzGug3hSzz+40ommPxa7LGxxAyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJQSwHsQ88ffer3u25+w1cZfo3J6ilfE1KHMiaNjqNk=;
 b=l2jOheZP32FUOZB70XrcsJuSerEXtFhJsVLJ4WjqXhTY/+pOqHzhYsklWSGse2YDPo9HGxBfpfT0C00ahqq1+y0lbOAETK0pBoUQKLQfFv+0/drGCKDED3TweXhybJPlWh4EsZiVPasBag4SbMpMAkmJ0Y6YlBOyJRx2dK0R0no6g50GhEJ7NG0unphgSkqE4ih3ES6t1kkxhqWE6Y9UZJtCSUrfyVJxjiJxLGCkxGoZ0PqpH7YuOLnWpWiKhIkg0LXj0STGOYzH3al4IxcPabicmpLPL9s4MUAlGM8aCW4fbONiQp68p/U10ZiyiO78esANLbZdHE5xdci4wH3gxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN6PR12MB2670.namprd12.prod.outlook.com (2603:10b6:805:6b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 10:43:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:43:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/11] mlxsw: L3 HW stats improvements
Date:   Thu, 16 Jun 2022 13:42:34 +0300
Message-Id: <20220616104245.2254936-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0089.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d88a71c6-d466-4c17-c499-08da4f85091c
X-MS-TrafficTypeDiagnostic: SN6PR12MB2670:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB26703C4926136827F8B7B898B2AC9@SN6PR12MB2670.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k0xdYMUfYXtJb2ep3/Xl5/ZLe2wuv3FIlYJ++Rm7Qn9lUd4SO38Bi2MJ1aaqjZp8n832lEKMLvomdQbJgTukOXCYfXXbEWzh+vT4GZRlDnI2iGkpXUQ6UZvGoO9TqSEbXzQj85mh//6K8/pjifnt0BbfCnmpjc9I1eULzoRJ+SNTD1o70Bg/9E4viZE/XdSHGfbUweeOcV1loQvbba9j7ycPBRGZJEM44hODgYeIXoSyuQxEiLft8bknlNKk2eES70aXq75yNy/41aDbwW7uc9sCssWuTw2eRlfJ9I8dGsG+GeCARGhuEjf7J4fUXvPCQjjOMmnDacql+iq34Ukg98crtwVMwASx/cSXDFb/kp8UKOLmcPO195nVnRi/zcoBLlAS94yrRW7ODRi3htj23gexmxsT7Ts0+Sn73l0UHbKBI0L6xQz6UrX1E547aKTFQYIBIj4mDWY7MckIrLijxsKJ3oisypVNMIl9tApSoeq7fdB1Vlu6lSWaWkyMenBXm7ivpJAIFmMrZ8oBwS/UmECyefL99/qgEuOvZQwr6Iv5txBFqvBY69rPzZgP1KztSq19vtNG+Y1xCuMbGuDAVEIxwXAsgG0URiemWLFFYiS7w/cG27j/uv6Vd6PkwXfh7UGsbq6VpR6q7DwDiFkqIzm+qENFzAm6VmYskebmOnheF/e3D0cAtwvNuYsnmL8DBiYgQBA8knUJ3gq9wjOlrS3E8dUSxaoz2gpel35Qt2k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(966005)(4326008)(508600001)(8676002)(66556008)(86362001)(66476007)(66946007)(316002)(6916009)(83380400001)(6486002)(186003)(6506007)(1076003)(6666004)(38100700002)(66574015)(26005)(6512007)(2906002)(36756003)(8936002)(5660300002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XtSfNWpDoxecqAC3FspzHN6igrcIsxjLSF0ZgoJcwaGP9mifjLsC23zAnlSD?=
 =?us-ascii?Q?UWuaC8qnViyI3Q8IBIq38t1m0+2fxSsCIR3g0ft+hWIaHp/5yBSds0BgOrE8?=
 =?us-ascii?Q?GdxQPTnK8YtkMG3lxfKGXPckBuR9AQww3aq6tRNav9VzEVsXlolCYBRBa0KU?=
 =?us-ascii?Q?hE9D5Oesi0FlrTylx4zaM4ZAoG2Uyous9YBt/jyxv+79eQtn6F7TTiM5MZbX?=
 =?us-ascii?Q?jLzMkuOe01tVG4JJUEkGJ5KX4MlSpggvtCl2yHMSmzDIm7YI9sJsD1YR3DGx?=
 =?us-ascii?Q?5gkWYvgOzdI+YykHWKx4Sp62GgV53bY0E4fD0KopljU3f1xTwz/hsRopQahK?=
 =?us-ascii?Q?HHiPRbWKahH2sEpiao+dUacsCQXY5Az1Xd1F4fTz1pExz9b+HJJ15rYvpVgP?=
 =?us-ascii?Q?rJ/PKggtFnjJ0hZVXSjekSscOgyoOsr2EvwmltTTkFAY3EFFtfPlXF3JIqwS?=
 =?us-ascii?Q?1zfpr9Ol8L5OzKpuP3n1tAHiXH3shRORCNYa3zo9WaiuKPUgy58n6LM8N2hi?=
 =?us-ascii?Q?F63Kb4jve6co5dftIhpmL3pyYHWNZ2+ezpi2cCEZo3vRqC+adb1wJYXgMTtI?=
 =?us-ascii?Q?R0lhE1XO5QdZSsEbMdMDZkb8oH5u5yGLgN92utiuTl0BCvXv0uwCGruU7hM9?=
 =?us-ascii?Q?IfTIpU8eu9sqtrDvtybnOvWjq+YU1GTnrSfI5k7u4YtBCAKyHkoH0a7dVv5H?=
 =?us-ascii?Q?6X9WoRUC5lT+Li/iQZUiUp/nj5hcvakW+R5nG91Iwl4AOnYySGnocQNJNKHy?=
 =?us-ascii?Q?+pCtD2bCQYgmQkynnt6QXR/BnMveq3jljLfHCxYETFIs+MuOh3cbQ54KBOLD?=
 =?us-ascii?Q?sil+CLeVhGfCbYwMJa/d37s6yXc7kZw9/S0FrHC1+C7jsBJFXZVkvfW0SW04?=
 =?us-ascii?Q?5atBNalfa0ISapoXoNwAQMweT3DIC0hZ4Vb/Cz29D8iN7yzQdZl45tbACpmE?=
 =?us-ascii?Q?cKmAdGtJjTIH6JRHW8AT0LY30nzsvmBm1zKeEd2JydXbyOx55JU+daBZgPmB?=
 =?us-ascii?Q?HPREfy0I8aXL+VRsfb4KWnS6nbOX92TAzr6iA+zgZyxB+QI97x69yBfc8nBn?=
 =?us-ascii?Q?zHjgiZIS7pacKLhJcWK+X0oxawk2PLhxZ8BdhLMyI1DsA6sns1Z+YhsZK+dR?=
 =?us-ascii?Q?MToZLceSeV4exC8qhfXvONVJ/lJh9MgDUEdfAfO6oDhlXhptJCDQ86rs1BdO?=
 =?us-ascii?Q?860GY8sxhhgKKvGZo1RyuG2Hk4XK/79qOsAnB9wV3uQvfxdf+ZSf4N49/nmG?=
 =?us-ascii?Q?m8Xurn3a9YtxBkFeGiYaWqTJSV1JSiH1BDrTayMnyUxiuAoDoVDNn+DDh5Wg?=
 =?us-ascii?Q?KKPHvZj75ISShlkuD+Vj4aYLu/8c/4p5MKdfIzZiTwgcj4ZdKl5mNJ+XJvsv?=
 =?us-ascii?Q?iOv6SEfJ05XTlsed2uPLaAz3jA9kGHn9gk0oSKurgGH3ksX9cdM9IFz++dvl?=
 =?us-ascii?Q?1Vdgx4LUUPZX1K+Nv0jvdEo3mOuIzMk48Wgm18iU2N5u++DamGI3LP5rFXKK?=
 =?us-ascii?Q?V4fYIgCIx8Y/AbLDFRPZfd0IMRqShUCucOkc44UkzrrDgosX7/r7VojwZUpq?=
 =?us-ascii?Q?oTLAcpISiHc1HTVrZNCH5sCiNj3sddXSlkngHOgasgEU4XTL4U2Us+9tgktp?=
 =?us-ascii?Q?KvMFXyJhe/eAMt3S7Ll+Tcl5ddhZSQdey03PgU1FsLect+ojOAXV2MKWTaJd?=
 =?us-ascii?Q?YLlGqEPlikkcJUPEA28Jmtf7isKuVrdNov4n5ENkZglxQO0yDzVUn/V6QYHN?=
 =?us-ascii?Q?spNOy883CQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d88a71c6-d466-4c17-c499-08da4f85091c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:43:23.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6y9D2lzYKBefIEVE3v0Pj/koGcf8aabvVEjKAa8DSikUbsdPltQWpcfuAnCICOuY7L6c7ju0+eOKL17b/MzDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2670
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing L3 HW stats [1] on top of mlxsw, two issues were found:

1. Stats cannot be enabled for more than 205 netdevs. This was fixed in
commit 4b7a632ac4e7 ("mlxsw: spectrum_cnt: Reorder counter pools").

2. ARP packets are counted as errors. Patch #1 takes care of that. See
the commit message for details.

The goal of the majority of the rest of the patches is to add selftests
that would have discovered that only about 205 netdevs can have L3 HW
stats supported, despite the HW supporting much more. The obvious place
to plug this in is the scale test framework.

The scale tests are currently testing two things: that some number of
instances of a given resource can actually be created; and that when an
attempt is made to create more than the supported amount, the failures
are noted and handled gracefully.

However the ability to allocate the resource does not mean that the
resource actually works when passing traffic. For that, make it possible
for a given scale to also test traffic.

To that end, this patchset adds traffic tests. The goal of these is to
run traffic and observe whether a sample of the allocated resource
instances actually perform their task. Traffic tests are only run on the
positive leg of the scale test (no point trying to pass traffic when the
expected outcome is that the resource will not be allocated). They are
opt-in, if a given test does not expose it, it is not run.

The patchset proceeds as follows:

- Patches #2 and #3 add to "devlink resource" support for number of
  allocated RIFs, and the capacity. This is necessary, because when
  evaluating how many L3 HW stats instances it should be possible to
  allocate, the limiting resource on Spectrum-2 and above currently is
  not the counters themselves, but actually the RIFs.

- Patch #6 adds support for invocation of a traffic test, if a given scale
  tests exposes it.

- Patch #7 adds support for skipping a given scale test. Because on
  Spectrum-2 and above, the limiting factor to L3 HW stats instances is
  actually the number of RIFs, there is no point in running the failing leg
  of a scale tests, because it would test exhaustion of RIFs, not of RIF
  counters.

- With patch #8, the scale tests drivers pass the target number to the
  cleanup function of a scale test.

- In patch #9, add a traffic test to the tc_flower selftests. This makes
  sure that the flow counters installed with the ACLs actually do count as
  they are supposed to.

- In patch #10, add a new scale selftest for RIF counter scale, including a
  traffic test.

- In patch #11, the scale target for the tc_flower selftest is
  dynamically set instead of being hard coded.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca0a53dcec9495d1dc5bbc369c810c520d728373

Amit Cohen (2):
  mlxsw: Trap ARP packets at layer 3 instead of layer 2
  selftests: mirror_gre_bridge_1q_lag: Enslave port to bridge before
    other configurations

Ido Schimmel (2):
  selftests: mlxsw: resource_scale: Update scale target after test setup
  selftests: spectrum-2: tc_flower_scale: Dynamically set scale target

Petr Machata (7):
  mlxsw: Keep track of number of allocated RIFs
  mlxsw: Add a resource describing number of RIFs
  selftests: mlxsw: resource_scale: Introduce traffic tests
  selftests: mlxsw: resource_scale: Allow skipping a test
  selftests: mlxsw: resource_scale: Pass target count to cleanup
  selftests: mlxsw: tc_flower_scale: Add a traffic test
  selftests: mlxsw: Add a RIF counter scale test

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  29 +++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  18 +++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   4 +-
 .../drivers/net/mlxsw/rif_counter_scale.sh    | 107 ++++++++++++++++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  31 ++++-
 .../net/mlxsw/spectrum-2/rif_counter_scale.sh |   1 +
 .../net/mlxsw/spectrum-2/tc_flower_scale.sh   |  15 ++-
 .../net/mlxsw/spectrum/resource_scale.sh      |  29 ++++-
 .../net/mlxsw/spectrum/rif_counter_scale.sh   |  34 ++++++
 .../drivers/net/mlxsw/tc_flower_scale.sh      |  17 +++
 .../forwarding/mirror_gre_bridge_1q_lag.sh    |   7 +-
 14 files changed, 283 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/rif_counter_scale.sh
 create mode 120000 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_counter_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_counter_scale.sh

-- 
2.36.1

