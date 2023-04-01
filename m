Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7906D33C6
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 22:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDAUS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 16:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDAUS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 16:18:26 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2089.outbound.protection.outlook.com [40.107.241.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E679AD20
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 13:18:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eakCR5ZmILeNO0yJ6lv0MR4wYq/eRkz0tV/6KQ7chA+8Oy1jlrB8FuoLPoXby/26mF6AnqQdf2rqt/39tDWOTSXlk9EoqnJhlEKC44w2M+TqcCE3x/xlYkPxYedxWktHqJlsaqz6G53UoRBK4Vauy9NOkyIrACdEdW0KWD+/OBv4HSQRUj/TafF+oU374rpVKgw6kr1sc45oS5r7HzotNf1a4KomBO84mii849loyH9u7AnqP6I8KU6FGPuqHnL728h94ZBX4RhgxlyEW8CISbj9kh0ob+Yl7A7Wy2p0iaFLnczcihSPlvLOEORLfFPfG4vdIlnQ1SMPnOtxbKmrsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4aLNxTM2bg4PW5Z4UlpqxyWE356XeoJboarnFlPfWU8=;
 b=UUewwFrW98F8l4VJ98GOY7H3pEh4I1EItyLcbTGcazG+1ldABF7vl4DVC0gXeLSis7rYnB543nmNsnINMbyJ0B5gK9Ymc/GOxhLB0mYFJ329UxTe/uMRfANwnuvP2rTWVJcEQNw+OWz2pRdxLER1mz9kvhVWlj+n34/pTYj4PIgML2fI6oaSxp6btvutdOE++WYcKMmpGxpWOErRcirDj41KcuaJ8GJa0bbj1eIuCcQzhS+h2EPGHN2hCmR2Iz8VPKYUfI3XSKUiGZyiMrQkDE61WbzhoSkNvuhiUXr/ySQ0Gf0WnqVPzcowoieaRdT+5sSvcl5+uxMXf7CFlOcU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aLNxTM2bg4PW5Z4UlpqxyWE356XeoJboarnFlPfWU8=;
 b=LBixKdoSJ3OADuSZPR8piFyXEZ56sISPFrqk61NPhYOSEjR9DdEY6fyrKKw0dUP+jtzeG3d2JRvWyRpNr/e6CsADoM8OA4hcxARY5/0C/hO1QCcPTKZEXjPZM+r+3EPH0w67CraNvTI2PlNzRTEMkM54e+ktiL0DZS4f/Jo3lVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBAPR04MB7287.eurprd04.prod.outlook.com (2603:10a6:10:1a4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sat, 1 Apr
 2023 20:18:22 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 20:18:22 +0000
Date:   Sat, 1 Apr 2023 23:18:18 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Max Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401201818.bxitvurfirsl6rpg@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
 <20230331111041.0dc5327c@kernel.org>
 <20230401191215.tvveoi3lkawgg6g4@skbuf>
 <20230401122450.0fd88313@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401122450.0fd88313@kernel.org>
X-ClientProxiedBy: VI1PR08CA0257.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::30) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBAPR04MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb6afee-1c43-416d-ec1e-08db32ee3d87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUoDwZ59bmSwGHvfse2n3QA3rXLgcavwjAdWxGOt13r7Hj4Yawz0krKKrEZ8cNcuKimfAHwthlWOlpzXfTEWkRoKMZU74vdbmzXoAeWyKtn71wM3E6qtyTSxSrdjR5VaBmdkwmWmYoL4zjxto07NZsqFCJuu6cCt7CdM39y0exqqohFtEQGCXIVxGQMnlyo6+RCZM0IJwAXmr/rhhxsBTAOvabRM3Q79zP8Avovt5bBIKbBhE8Em/REJL+DJOF0UrT+tFqX0VqdZvMCfs1pVX9gKFh4UOl7xplVd+R0s6ACzqLeXsyYOKEvB26GW3i1MqzR5SbTBrYia1ZraFeDjnLx+cx0UVC+j4j/0geLsiAEXOFWwN4Wv65qc3ScT+6+m70gJEzDeUrqVWla1ngtuJlqQFo9/LLoD4TCI5DQsRQWahCHzN725lJRROvb6d5fQuonh1PpY19MaMSlW2UHd4ayLn1d+rFb/i6Q600ZHJ/p/lIA9spaja4APFkYy73ofB/5mFc6Pwk/Sj0ABWOyETku+DZ3Nd+fBzkPZY2/EWUebwXiy+l6VIVk/9gVp6IEY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(376002)(366004)(136003)(39850400004)(346002)(451199021)(4326008)(8676002)(6916009)(66556008)(66476007)(66946007)(478600001)(316002)(8936002)(4744005)(5660300002)(41300700001)(38100700002)(186003)(6486002)(44832011)(6666004)(9686003)(6512007)(6506007)(26005)(1076003)(86362001)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z19EbzzcHTCYD9rQsAkadz0pPw/LTB2rCrF5S+3vKGGLEGCwN6kDihgMsX4M?=
 =?us-ascii?Q?L/M6kDO18KC2SPS8s8rRYulf7p+71tA5F6kPZUsmB9eQcCh6KC3FvV7JM7uI?=
 =?us-ascii?Q?alvoEHKLykYr9buBueVWcOSqjjAgjNu0hg2EFayxPWRBxCu+K32JikFuTi/t?=
 =?us-ascii?Q?m0Rq5LH4nZLA6uxTPbyCz2Ra/rvIta/kJsm2ep31SbzkUbnJjPzzxNEWRcqy?=
 =?us-ascii?Q?pQ2928KXCVZn4IUzLRF/l8IZ3Onn3GFMF7L34YdMWmYKQ1L5aHQKPGC6cQWi?=
 =?us-ascii?Q?XAEq2iZA13PWqZzN7Q55K3OzbJDxa9K9as/eARsrTpZASte3bOnQZniPR3Jt?=
 =?us-ascii?Q?7MrGZdKz1ab0Gb4Umwo8TKtXIAbnRoR57Gd0klVWMXAEqT0upIqPO0+00RPg?=
 =?us-ascii?Q?k42g6LrTyRMQ9B30iyYMyw6mrP/5ok7UJU/fYEezXdEAoBQlHfCBarHOwuzj?=
 =?us-ascii?Q?4ERlH4GN1DMMJsTgzPPYtle5AOZKbkDEzV97P1uJcYtnJVlnDXcxm/2Q5cAM?=
 =?us-ascii?Q?JqtBFAd5x9hbk25jvxj9QXTJhyHyUqtA2mQzgluSmReIKdFN8pqg95CoTz10?=
 =?us-ascii?Q?Bko/aG8PLvCquwBC/jvtomRiIeXldCPd/Egrr9ouc/b94xWMvKSRVZ/eMP61?=
 =?us-ascii?Q?zF09GvX1T2QnAJRrKCLBtjBR+pOUX5W7viCOmGPZBxyox31TpY8ZnxHWbCNn?=
 =?us-ascii?Q?76EQwY9mR9rfy9LdPG6pA8HF82zrGiEQrODQLT/UcMsyl5oLRW2UuOEnS02p?=
 =?us-ascii?Q?r+YaCUBHz1iJPUEW121INgzRl6sc/u/gID2EgSjUVmztnGvbvTZy0gbJUEy6?=
 =?us-ascii?Q?zGDLPV1c5Dy53pzFuW8E+o9OVGsE4C0Tb4b0cdgctovFNgDjU/MMgETYFuzR?=
 =?us-ascii?Q?fk3a7/cCztpqO6L8QHqqQN5cbB1vj36uPVnmwnabwvRakaPtxJYFFlFdsgr1?=
 =?us-ascii?Q?GZmxpg/yI1v5iI1Rm4Mbr+CYiO8uOZ0RIKG0sPhVDdaotoxnlMiJXWsl5O3P?=
 =?us-ascii?Q?Xj6Yq/11jeJx/VGCwyAbD/haJDi2TdMBgH1RlHX1Ld0pPmcNaa1SvzplwUO0?=
 =?us-ascii?Q?b2zJI9zqvSLKIcgqa4V4Y7kYWmAwvvU+dlk9jkhQXy1O/4tvZ/xhpqGU44Hl?=
 =?us-ascii?Q?S3+CbBQ98Wiu6G5Kxrje/cmU3j+8tuVP8hWZPCa9SqRTn25aGamgGImZxtZ2?=
 =?us-ascii?Q?ph84rlucX2+NzaG85CH8WWMp95nBp3KAAVUdmvoQeemBZp2xkg/j4DjNsGmG?=
 =?us-ascii?Q?HWvOboBcwFqTMmUpO1ujfHyvgF1i+jvUgWA+fDO47Jkoqfpazoan/C2vlCDm?=
 =?us-ascii?Q?mGRwvGAv1hFcrcvHQm8zxiyqqnYEgWevCljBSqyK40XoFyL/0P7lYWSFsoL9?=
 =?us-ascii?Q?qqJCkmanF8/os0x6+dxNrDhEAWRRK6R6YBYc1RVRZZ0zGRjIQmCd3/hB93ML?=
 =?us-ascii?Q?ZTCANLcnU9wlEhidoN8SgTgsaR0trzzvy+WI1/PKBXpCfQ5cK7Kggel0v8Ml?=
 =?us-ascii?Q?31zTu8JkcnpRfgzi5pMkKmXAMWRnZMeVNwkOwVldryi/1C/u1fIz96scRXN7?=
 =?us-ascii?Q?0WpoXmPI7VdpozgPwJTMWzYZ6WQoxOgRHYTp7zSezHkenOZaUlHgVKku7JGJ?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb6afee-1c43-416d-ec1e-08db32ee3d87
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 20:18:22.1691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lVByUk4WfO1csA3xHmYZHKrzfgPwKzce6ZwLyKxddwP8sr4iJJ8OCDZOWz3byLanng7fyjltcDT7yBznl9WXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7287
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 12:24:50PM -0700, Jakub Kicinski wrote:
> It should be relatively easy to plumb both the ifr and the in-kernel
> config thru all the DSA APIs and have it call the right helper, too,
> tho? SMOC?

Sorry, this does not compute.

"Plumbing the in-kernel config thru all the DSA APIs" would be the
netdev notifier that I proposed one year ago. I just need you to say
"yes, sounds ok, let's see how that looks with last year's feedback
addressed".
