Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B60352DD64
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbiESTCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244370AbiESTCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:02:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2126.outbound.protection.outlook.com [40.107.237.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B33255215
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 12:02:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9KHqqUn2tSU//etN/pUuLyDHHVyGwztMKj0GkxgIcb4mvodkU+oobZTZlFg23Z2Fo1Hllca573cbYSQ9TGs2pCeJ+ulhPB61MzVZnfmegx5RaZKpB3KEAfUHMCg8tLHDj491hdPvZKJOYrFnb3wfcd47r/yNCSuuZSHpyTHuKSVpG7ajKKNnosxLVUR3+qKUIU1mpBfV9eRSYAuEGKvdomi0/QbX9WB+OTS1ozZBjPyV5rk4sX63H5Rg7laAwPwF6mzYRh/lE+1XhjI+ghBnyq4c3trrqExHYxWxsTUThS/4WZdX4ps2eZfNPyUtA/BN5i/X3nXI2cfCa/I6Z9Dag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RufFTqCGa5dpFpmV0kGYe9xBp665aM8YDrEbIf/LAsA=;
 b=X0N5bcWVtge/JOTdK7t9rfKLeH6CcxaW/6S73wydJK25ikRViYtwGuSVCi6/y/aXyC4AYbrc2nH33niwftTdXX9sCti7uDQ524klEqgBNQsXmqz0IIl7+kJNZXPv/pWrOEFBmPHeS1Tk5SggqiCFxCfbgp+5ojxf4YYydtMfQtRKTjBwS8REM+OccUaKdmbthoq3AuOCTV5JVzLrkXdlpJ7cWXb/ghoWP1fTZ6bXHYwGVk8HJO2rf10ymLpNbgresmH2inH3GWjo57CGa0IxxxPgR9tqlJji24kFUtVvXxrqx8TR5oOqg1ePo2GtiGKo9oZQrv+M71b/I2P6JNLCIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RufFTqCGa5dpFpmV0kGYe9xBp665aM8YDrEbIf/LAsA=;
 b=WLLswX2soeVd8HvYQ0RtcP50NgyS85mcoVyTgWwaaXExB5wJOBfF9QIpRtGtQAXmwRMcDCdTW0ph9AjmDIJktdyqz5004JQvjxfU6y837TgZnTUC6xfqhZExgxWVf5HYcu0QlHHmnZYLp+Gox725hYUBizoLP3xOwltdFTr/KF8=
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by PH0PR08MB7177.namprd08.prod.outlook.com (2603:10b6:510:91::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 19:02:18 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::a405:a624:766d:ac03%9]) with mapi id 15.20.5273.017; Thu, 19 May 2022
 19:02:18 +0000
From:   "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>
To:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Shyam-sundar.S-k@amd.com" <Shyam-sundar.S-k@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>
Subject: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE KX
 mode
Thread-Topic: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE
 KX mode
Thread-Index: AdhrsYRlI7dNMKCQSQqkS/yalTkp3Q==
Date:   Thu, 19 May 2022 19:02:18 +0000
Message-ID: <BN0PR08MB6951A0758F4983512A99018383D09@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 642b6c42-14f3-4466-9f9a-08da39ca187c
x-ms-traffictypediagnostic: PH0PR08MB7177:EE_
x-microsoft-antispam-prvs: <PH0PR08MB717732648F9D056D340F12E183D09@PH0PR08MB7177.namprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QggFuogt2gbqR2+dXPzuSGHkUJnAOv9VjE6/1RH9WoWaSIeTq0u0ZYpPto/E6VIDCr983ajve9qmil+11TJC+ZmqKrK9EShttNVch8aakyTufTRnIuF7bkqubSoiKrmsBJCkeOpkohczFgALxu55VNYiRQtgL/U9NboEGxc9C1iOKMRhR2+O9c/bliOEWh5kLlS0QuT0PouIJHQRC12KhRY9OMMWw5Bq3T9cqGs2uIUhO1id6+tHZ8nXv8yEjr+YGatD5ITDkRKZ77r1MaEgjpFnVwnyUE/pyByja+8GgXXa0XIhKZvO+MeJ9SjDvcpOgM7BEeyOlaz78a3ea2ybnY9r4EdDBbaLU0qkYcWSNj51UUhTiaCAvZhl/SpEb+avD9NHJWKvJuyzSVynGhPGIjvCJrSsH9SnozMGPN0emKEEsRuBHA+1AisraO6psbAXdUJkKxCvGR+rcLReqtDb8Y+GQFlx5dqHcu7RxowF9qd4fywHwXh83j9ZOBmmMtH4tyGsrOtWx3q9qFTZFp6AoAtNqm0FQQIK/FREybWUjJko4NZEHBvoVLJKEnQVHix10Tr0f6qOHikUCSCIwQqd6/WAo82s/naPgimWT30mJbLzZQSxEhMKCDvMVwAMtU0tM+LVY23o/+aE59mVblo/J1GHxq3BS1JS2UQssmFfgxE5KVyCkvTrVqPV7tpUxsTo2Z6jJhQSwfa0DYXTKa+z3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(122000001)(7696005)(2906002)(38070700005)(82960400001)(54906003)(316002)(110136005)(38100700002)(6506007)(508600001)(8936002)(76116006)(66946007)(33656002)(86362001)(71200400001)(52536014)(5660300002)(66556008)(186003)(4326008)(66476007)(64756008)(8676002)(66446008)(26005)(9686003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ULvXrM73lCqSRuAPYedNBgN6+/sYsBwBipJ+mIIdvygm3vjAH49IdyLpSUz4?=
 =?us-ascii?Q?Z6stLYa+D2DwIp72selrjuzAG6JI7J1r8M9heTA9iuaPi43MAiJj9rJn7Jlr?=
 =?us-ascii?Q?rtY6RXlW4KZYT5CLlGTKfmI3edDtMh/9SI+Q6Et3YoxXbeuEZFY8DdJ/RZwn?=
 =?us-ascii?Q?E6odO/JRoStd+e0rW/rYs8IBL5eFDekBv+ujF/T1lai1nncqAQ6W7QGZYucU?=
 =?us-ascii?Q?GPoxL7OwASEY/00Qs8JTLQXKvow3Fkq+t+oWOc9AU3Cs5vNXNUFUNSkY0jxw?=
 =?us-ascii?Q?0h/8ftwvHz+NKRJ3k6FmvnXBXqyIhpJ0Mok6seSlOctmt3kTR2qv7HQfh1Xf?=
 =?us-ascii?Q?ysRjeS9+Aish94LKY7asm9ZOvKfR0kYZbJoZDYO6YZ873UWIArtSs02W1xd9?=
 =?us-ascii?Q?Fg7Na/gOptm+JpgSLftvn6yfAGVh1DG28peHDBxX9RBnMgpimdQ9U7s39+BT?=
 =?us-ascii?Q?fsre5jqTNzwkAIxFaFsXijQlz/L0vLRy3MLbNZypnScIYhrBlrB/LSi1dffO?=
 =?us-ascii?Q?3EfR1Uzp1vwe/+Fs4DOERfvGFlcp+7ivB+axBKYI232BoOfw2QfogtySXKQM?=
 =?us-ascii?Q?F6Qfc+qOQjhSCM4iqRV1Jc67fCPHtfgWYzpnhP+yAP60l4ZiP2JVnWw26Aox?=
 =?us-ascii?Q?BJnhvX2gjF7+ocstZLaSodm7jku495BBbHdYhax+QZ9rmWl/5akNodfodzkn?=
 =?us-ascii?Q?s7deVoNcqYnbpIVhXXduD2Y4RIruroYUW/o+smuUXGUmWBMdkoKxeqAlB69l?=
 =?us-ascii?Q?1a1d2KgpPPQ7wchRStK9bYmEADCy+1zqJ+7DzxiR73VwonrYepglEgsoAt/G?=
 =?us-ascii?Q?U2UImWXg8K+9t03WDb7WDkBm6vJcdn7T7VsrNk7w0nkbOQAcgEwhYgiuZ7zL?=
 =?us-ascii?Q?AXamTY/r0xv/bUDbhtEWurVhhbTSEIYP5sl/+d+iP3qcQ1ctYYk0HUOwmLJj?=
 =?us-ascii?Q?MlRrtWjUtPEL8wkA1OY5WKGFAkt81iHE/8FNKFz1RZInSqWvbBaBUagSbAeF?=
 =?us-ascii?Q?xVD0pLFizfXLpj/TxSCmAJi0lBneCkfRrxNrPd88pG+0HzGJ7tvuD/ovYHnk?=
 =?us-ascii?Q?i1dvUVWn8NDAv/vaZI8+8pT4aCUgHqwkHXJgxFTq7BHRkfhVWZ63aXzmqbyI?=
 =?us-ascii?Q?6wSu/2q6qMkBt3oe9TIg8FIS8RQQ2dDQLa3mAgOduzCQIE9Gs/E0EtX06nD6?=
 =?us-ascii?Q?zRHw9bdakuzvdyHZmrB0LMpJDKfq/Jf95OuDck0bcyQq6YVkLtNDFazidgAU?=
 =?us-ascii?Q?yg+wnFdtQj88pipG3Bh4nlawp5MWIxhdMDX3D5HFAorBfUEUvj8WkB0iLLn8?=
 =?us-ascii?Q?zGDj1/401xJ8EeKBFCrHM0cjB0eiNKMI1R1oFS+vkkgj0w/mUHrOnrBhKQKd?=
 =?us-ascii?Q?WgWyvTyWhRBKfdQ6idnceFqIR2bzm9KpYjH9XiWLxyYM4QEx+H0GWrcB/15T?=
 =?us-ascii?Q?M8Lqyv0PXcFeScXH3wNv94VriTKdWsP0OGowMfFGkMxgGCQrBZS018+utggn?=
 =?us-ascii?Q?roB9OHz0b7ppxBXqAeEMTWI0ctQJHEhquD/p8RJ/pJ6e3JRVQhXffl2kiNIN?=
 =?us-ascii?Q?XoQtNU4+GzzNtuDa+uR8Qfm891z+FXW5M5qTRy276XTUkMVjmqn06jMxK0x1?=
 =?us-ascii?Q?ohXk/LbXWQDZD95mmawIDBk2o80eG8UAIUUpVKZN+n27/yX/dckBQm4QvQ3V?=
 =?us-ascii?Q?tGXgC7v3Y46gABN3CwZdDqaJlKQa1WZpYKSg9hjEamYX39xo0fM6qrFcYT3T?=
 =?us-ascii?Q?K1rQRK4xWGT8Py0RDqXWd9Kt2vbKZAE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 642b6c42-14f3-4466-9f9a-08da39ca187c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 19:02:18.2875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6t7fowLxV70obmuCOIcgoc40XgX36PtH7tfWGJFrp/G7TVFddS7ja0q0IilpiJfJkusT6OkiaMoyaeuMQ57k0PsgVRhvDl/8D81Se+Bb30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR08MB7177
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Consolidating the two threads; adding even more asymmetric results)

Additional information:

I performed an asymmetric test. One side has 'ethtool -s bp3 advertise 0x20=
000' and the other side of the link has 'ethtool -s bp3 advertise 0xa0000' =
(ie. one side is advertising 1G only, the other is advertising 1G+10G). If =
I bring up the 1G-only side first, followed by the 1G+10G side, then the li=
nk properly comes up at 1G. However, if I do the reverse, and bring up the =
1G+10G side first, followed by the 1G-only side, there is no link up. I nee=
d to bounce the 1G+10G side again (ip set link bp3 down/up) to get the link=
 to come up.

I then performed a second asymmetric test. One side had 'ethtool -s bp3 0x1=
20000' and the other side of the link has 'ethtool -s bp3 advertise 0xa0000=
' (ie. both sides have 1G+10G, but the 10G differ between FEC and non-FEC).=
 This means the common denominator is the 1G speed. In this case, no matter=
 what side of the link I brought up first, they linked up at 1G.

So it appears that either two speeds need to be advertised, or that at leas=
t one 10G speed needs to be advertised, even if it doesn't match in the end=
.

The setup is two identical systems using the XGBE in backplane mode for int=
er-system communications (redundancy). The processor itself is a Zen (Famil=
y 23, Model 1, Stepping 2).

