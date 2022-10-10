Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D523B5F9E1F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiJJL5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiJJL5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:57:08 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D69ABAA;
        Mon, 10 Oct 2022 04:57:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc3pEV40mnKnSxMkYse3azGhAJXKd6sRMtdz7SAiDhKcniDKc9BcN8z7z8Xb90Xjl3BEjG1HUyK51LQOskkLgP4Ur8CLLkVTiIHzsrrBG5fQdEolMfIwu4go/OeNynv6D4L2xlYxHhqebUnvElbVL9ypylCa2onRHT+sfX64FNtwgZ0H5s+GamYqPhqJgt8dIrKDxVnt3CIq5FJfD+AH2B2itIz5zmKpb5XFgLgmP4rNu6IPsDZVt19arW7D1r+O52jKcANPKm2UgELzfVdfsj+OJG+4lv9VQRukmKQbqtf5uzqaiUPNppC2F9hrxE+lhDQ0rDhkcdeaDAwX+OdjKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOLDwMpJO73GbPXJ1Ya3Q5arzATP462wSAwVnP7Hgqg=;
 b=GZDHTn8CPhYUTk1pfQ47JLTSZLphp/R6GGIYOLKo5lACse+Fw2Dnj0JQtQgPygybXTgWWT21Lv8U0rDaCfQrhSqVWkOKexhLtOOln56P+YUNPjmwCHcF0yKRMzn0J0Pd+TpgrpCKvB/2uTDhqTbA/RSm0jM7KJIZrIaEDr4XRa6D/bAQeHP7Y5Z2HzQsQlw3oAV6Ha6CzbKSOS1nU0rtGbE/Jhew2infylTXsCUk+Vg4suv+t7/pXU6HN4ejjH6MgKEbzOu/cXz6gZioohzMi2qj9MdquFpXDICQs8t1Hx0v0ZddQvYdhbK7c2ACokmZoMyrYeKtLzdjGjt1nyNyRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOLDwMpJO73GbPXJ1Ya3Q5arzATP462wSAwVnP7Hgqg=;
 b=eNUrH2ld9T6V+Q1pCRkqf4pn10nANMrcgHrcRya1x6yaXJUKSx3NXOXdJnXkBfXfZlZMrI+yRXr2AhfUTCVbYeAEMNLSko3GYNscOjXNaE+vLbGjlw60WEBhwofJmXxjSlY7+NfK2j7M6OKYrGfscmQSKnTYsw6KzjI/WxKbT4w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8282.eurprd04.prod.outlook.com (2603:10a6:10:24a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 11:57:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 11:57:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.0 55/77] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Topic: [PATCH AUTOSEL 6.0 55/77] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Index: AQHY3CwzfXD0jI3L4kKPlFvwpsxtlK4HhnmA
Date:   Mon, 10 Oct 2022 11:57:04 +0000
Message-ID: <20221010115703.wpy6uy22oee356r5@skbuf>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-55-sashal@kernel.org>
In-Reply-To: <20221009220754.1214186-55-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8282:EE_
x-ms-office365-filtering-correlation-id: f594af23-c17b-4687-cab1-08daaab68c6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jGqX8N06IPF9kI1l/VSSlybRSE+V08Bxfswpoylm9kyrycL9yTAK/zjykmz/tOE4qp5tAf6GfJplCZbBlZGCt2BrdizZdcdNrSsb/l4nrgSP3e9BulwPiXv+oYoVKhHF5iG7J77OdisJaBX5OIYGN/k2FiPhst6sdOSu2SgVHtAeSLWbnLGDJLxtuHGLmZGMt0LOi/0cFvEZywxMcYkny1UqOb2MMbd/+NodqHQtET7+BeztoHp6DELiIu+MUU9UxCf+LLahFm+1e+gy7X4n9O+wB7JOuO8/0XByFURPJQPkTc+2IjP4a0765uITew/4bibxxObAZ+jqcpoP+OcjFZHtlhCc9f8HEyWDKjcmHue5ga0aDDG95Usg0muFkFh1zcuRwjsX2IQgIg7Pjl+a61GWclW2I9ijdYv2+wDrrPb996GEY2ODtH2YleNZLpwzGU5EggAtuKo8l0/Qhw0Of/L0RE4q1dRNzIEQ7QInRlizrnQBRbglP+CLhtqyzp2wLLo9qn3Vx10Pw6H0QAF1I0INCZGraFZ7Jg4fMdiu6V2J4gcepZ176UqpsHPtgK9g5eSxBZnnyj3ib2l+ulyukFKNybVCT4jiZTzi35SEwGiuZm1m9ypz0j4D2rOToEFviA6zRz9Sq+3VyhkJhmvYm8pH8+FKZERJTawJETSO1cwwbDpKqXxS3zRw2SZLBhx/qpDGxhNcaXDa3pt0iIM4a6gPEXUMoaNvbUdIKQO29+1HOTAOgiJo/kSk4fbCrlGQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(4744005)(76116006)(66476007)(316002)(66946007)(64756008)(86362001)(66556008)(66446008)(44832011)(33716001)(6916009)(54906003)(7416002)(2906002)(8936002)(4326008)(5660300002)(41300700001)(1076003)(186003)(38100700002)(6506007)(83380400001)(478600001)(122000001)(6512007)(71200400001)(8676002)(6486002)(9686003)(38070700005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ArZuQct0XVP8l42Hsx1f6E/QpidvC2pJ/F3WZszYuAvyKgbrdCED+9nyadmY?=
 =?us-ascii?Q?ejXbj3rpNIbyEatTACbUaQeqbxaZVp1x0ffeDdDFH8Nf2Y7T5zwsPNEeYD/R?=
 =?us-ascii?Q?aH+75/Qf5UDA6ymhg66sGIqlFJbdOu7uv/HaILKhadnIxtiQkMMplVhNMs9q?=
 =?us-ascii?Q?v/k0mEImkshoMbezgakv8sS1OW+6dNo/dWW1Pr9cDBmMSpH7cc8+k9VaJsOu?=
 =?us-ascii?Q?JOi8O3i/ezh2uTu2F/uvA5vxsjadxwd3luUY8F2J/ML40FoGOakRKXUBK1sH?=
 =?us-ascii?Q?TGTe0mP5cfkEk5+wNiPH1KURQtO0spKzStb1/pGMDOl8kle0Ta+KqSbe45im?=
 =?us-ascii?Q?oDkNwtWXJGChAC/AHSEGGrfWOyu1YgfeeHPxJHKMn1R28pfNsahfplq5CIQW?=
 =?us-ascii?Q?Dzvce1oW3QNcorpI2lXLsoXWdHtuzOsLVCbnZ09ihBVJa1Vhlh3xXlfsoLdd?=
 =?us-ascii?Q?3ipAOyDtj0qduUVrS29xQreKU4gVewe+F6cKcH2QP77ejG3+camtO47sG3i0?=
 =?us-ascii?Q?QVQvmK6ivuQbDNmOiw3sCWvnzrDYrr9+ZTwNukDVRAYVhKqGkVzK8Q6I6Ksy?=
 =?us-ascii?Q?ASxIpfzO04cQV9rOzKXW6890qTTXFpmUUWCxzawxPgsuqFVt9n2cndRS0v4a?=
 =?us-ascii?Q?7caDYZJvmKkSrCqGF9ZNIzjbhoctZ6+fpPE3wB2xwaerDjM+LUzDMnCTH5k5?=
 =?us-ascii?Q?yjyoDLH7BSQ74Nbuzh12g9CHW1PCs9k01V8E/cMtsI4ecU/0a7P6GK3IvSg2?=
 =?us-ascii?Q?4glsGz/ljy40+lRHhzFZUQeg9AeGQPTV9lljStMuQO6Onox7byghuQ3icezC?=
 =?us-ascii?Q?ukGwk+DzreEcKqycOg+ZzY07xVnaHqColYgG1U2Fowd/i3BDE4rWyFKo7Rl5?=
 =?us-ascii?Q?boscA2DJz/hxoRYHmNsAy1m9e46K7il3rn4oJowM4qjnXDnLm9GhRTZ7m1vk?=
 =?us-ascii?Q?10MfDBKhJTUpxKx22DME97XTBt0njquM+zFOXONV5BeK7Rih2e7voFKvysAg?=
 =?us-ascii?Q?8q+gtnJLQiFMXtZ4uS/MyIvx3D8kwiXEXr67qS54WSCElcVCnzPLsgsz1FwR?=
 =?us-ascii?Q?XYcXfKs6XK3fa3JUr6g0bYdM49mJFn1h1ByhJrJEEfDkgWXiJrU9kCNNORHQ?=
 =?us-ascii?Q?HokOCADPQXPPqz/TTOdDtvR1mtIpl8lM5qfmiT7mvy2eM54wKAY7hsIFnTlM?=
 =?us-ascii?Q?3ptqDGzzZmWfyeE4zhYcCjg9clLNwKM37sjZYqQzhRCRs8qJnlSKJdGMptw+?=
 =?us-ascii?Q?9HYvPeHexTHK2MDQIGH+YrLv7kmyLGEj5TjtID87CQhjhwhpbCLAydDRKysb?=
 =?us-ascii?Q?3pc4Nsv5FclYYexqG9R1qcnYptem8hVbelouhVwPMOUJfUKmj52bXXi8FZiV?=
 =?us-ascii?Q?AzoGY8WIrdY2xcZ54XoHGOcoZeEesRChcL+4SNloehcr9HZsjIWvVCfnZOEU?=
 =?us-ascii?Q?l9lxb+ZPCrVizalLqYRQJkMK92lGe73JzZ8HBMOweZYxPPfQJ7J1SgWpWAR6?=
 =?us-ascii?Q?o7kHeOppQzdswa3CZEcbYPwO8yBfFCGlXqRug38sI5zx5am3ucjZMKeGcs91?=
 =?us-ascii?Q?+NhYlfsaSSCNahHNPiRyo+2l3FDQgU0Q4cSgBWJ3p45tHrBRSzyEPNvlSfRG?=
 =?us-ascii?Q?HQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54BA5CE1B94DF649995B7AAB11B3E2FD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f594af23-c17b-4687-cab1-08daaab68c6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 11:57:04.2718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZZPLk1crXUEh67JBjxzGmzWEU62dUHKM+nv1ICSiaGRm7CxuVpmrGMUo6VHzNihJone/ESZJKlet+/v8HxM8kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:07:32PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
>=20
> Since the writer-side lock is taken here, we do not need to open an RCU
> read-side critical section, instead we can use rtnl_dereference() to
> tell lockdep we are serialized with concurrent writes.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
