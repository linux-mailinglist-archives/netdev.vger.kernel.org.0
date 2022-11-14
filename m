Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57147627629
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 07:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbiKNG4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 01:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbiKNG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 01:56:24 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B78F13E8B;
        Sun, 13 Nov 2022 22:56:23 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AE6hJeF008852;
        Sun, 13 Nov 2022 22:56:06 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kugnb00xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Nov 2022 22:56:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRJ+F3wxiC0zjCboawyjjvzw6sP/OYLZ/xPlAi+tOej6Yrxyxb+6Lf4fXotHVkdvtR3Zkt6eNOqHdRBOJoL+gT0/2TStrJtl8iIla6I6R/6Vj1zEJBexNLDInnXAFSxv3oa11GCj21u4CYlvwev9DSng2eOgqNl0ZQ3eZfvtWuTUC/Tit2Gx2dnKGwGNS45745Ywv1KJxS8+ksO+GC8RL0gycRPq7RocDnkWlSGK3wWmXADwjMy5+6NdF1/RqR3p2HajmGVv+LNMDgUWyVy4KRpNwewF2HNaxrLoGGzDWaV7g/zoXViWjylX1hkwOTGP/8tSu602KPXMUnnDlBGarA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUZ113Y+mQpXizCoiVpES7zKVoTUx++oBOFvj6GSI8I=;
 b=VysbV0i/gmNtOI5jtJp2NcgNv/DHOZl9tzSuS2AhZiKEwcDn5wVuBfOfhbBNwHkzzgjWtDrCaTawKGd4Xb5w41Wq882BzvD13E149XKvgHgwQiRnqqbq/dENZR2mXnbwo8m40Y85Fqsd65SA7KVdFcn904KkRc1rEvW5Rpmtwyn4iTV7yvyYKjm6uemD7R7rDyHVugKyfmoFoyfvnq1olW17Nd/JvivEmgCa4Es0NY+F9FaOK7sojbIsnGoNLHkF3oTCmwygBj40KyQDl67JdQvep5bIAy31yqu99/AkPuxAOS8M07ogDvXPgVoQ1pE65r219/POdy6WFo6Q2jzNAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUZ113Y+mQpXizCoiVpES7zKVoTUx++oBOFvj6GSI8I=;
 b=bE48LjbFcGbJo6khJBAuyKudWvGAglsbQ8WiQi4kXPXXwX5pxi57YPBqA2XauF4Fu+bl6vNiw8tIZWN+Nz4NyO8XgPSsKCnbfL6Fu3Y/J2JcascH0TEpK/MAojJkuXruRS15a8qeHZ9ooaCD9S07jcow6qiwK0mmI2yfHIbx834=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by PH0PR18MB5209.namprd18.prod.outlook.com (2603:10b6:510:166::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 06:56:04 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::c182:14c1:71c3:a28f]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::c182:14c1:71c3:a28f%9]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 06:56:04 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: ] Re: [net-next PATCH 0/9] CN10KB MAC block support
Thread-Topic: ] Re: [net-next PATCH 0/9] CN10KB MAC block support
Thread-Index: AQHY9/YpLTAFfymhb0qokby5wVJzsw==
Date:   Mon, 14 Nov 2022 06:56:04 +0000
Message-ID: <PH0PR18MB4474F2B45174D75C27DC4DF8DE059@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
 <20221111211235.2e8f03c0@kernel.org> <Y2/nhhi2jGUSk7L/@lunn.ch>
 <PH0PR18MB4474E9CFE1E1FBF8EAF71817DE029@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y3E/o10wIZPMxPWa@lunn.ch>
In-Reply-To: <Y3E/o10wIZPMxPWa@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctNjRiYTMyMTMtNjNlOS0xMWVkLWI2YmUtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XDY0YmEzMjE1LTYzZTktMTFlZC1iNmJlLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iNzU4IiB0PSIxMzMxMjg4MjU1OTcxMDcz?=
 =?us-ascii?Q?MDkiIGg9Iis5bnNuTHVsT21kZnJLeDdZWlBic0Q4ZkIwdz0iIGlkPSIiIGJs?=
 =?us-ascii?Q?PSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQVA0RkFBQnRu?=
 =?us-ascii?Q?QlFuOXZmWUFmSlpZT2IyVlFiMDhsbGc1dlpWQnZRSkFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFIQUFBQUNPQlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFRQUJBQUFBK1JHOGVnQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFaQUJ5?=
 =?us-ascii?Q?QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNBQmxB?=
 =?us-ascii?Q?SElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdCMUFH?=
 =?us-ascii?Q?MEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhVQWN3?=
 =?us-ascii?Q?QjBBRzhBYlFCZkFITUFjd0J1QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHUUFi?=
 =?us-ascii?Q?QUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFCekFI?=
 =?us-ascii?Q?TUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3QVlR?=
 =?us-ascii?Q?QmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFB?=
 =?us-ascii?Q?SUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdC?=
 =?us-ascii?Q?bEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdV?=
 =?us-ascii?Q?QWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dB?=
 =?us-ascii?Q?YkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|PH0PR18MB5209:EE_
x-ms-office365-filtering-correlation-id: 886b9f4b-c1b0-4b5e-bd96-08dac60d4c69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p3tm0+usV6BywgY4Lla9bafb7QX9wMg2pR7LtE9EurOGeZD37pWlLTeLzZPsSYNF81E/b/LVvmK26zmDM0yd+ddY/TmSDct+5qpuyrW4NT7KIfXNIsBVpSm/JfMy/9no8f9OtGQvbLQn+LwG1nRH7X+lr17pJaC9OOrKNQb3FtJMJfhVO7IRKUB0mjWs5stLNM4maRq1UHBOkGCmZjm75b2jb+/5ZmARirB1xtCshQdVidEu356UGbHlxZeIhNc5YLkuoc1jwDZiog91wviNiTlGNJ8plLt+h9xxvhXVlXAagKiNS53ExYMCqUoNBtvMSCs0kC/svTztT3CQMGEjFmEV2qwCk/OsUAVHVw4NVVuTMjEZ+SWJGvTHqiZvUKaJynqKPzWf3lCRm1lZVxDbj6LErnOc/yNbkEgILnGNY7lGoZhPCADLY+Ry7/JDlyC7/WeJHh/dAySI7dEV6+qOTVbJUUFGZW0oqZzm1lySinUqF4HyTcuaFWXvaWQRzzP/R77qw28RfCr1tSBBSGsK7tyTK07g+IabLF5PJhMnvwTblCboGRAQxXTMdslP1Gtz1NVpvdKS0uIeOVCnsLFHVfu/qu0RupjLNKT05/sHlwQH2AivQSXWfw7uKUkYdGtpC3Kn+eAP31yKtNatXTVo7xKNG6clpAaYr+QnH9FYrNNpDNumGRo5ZiYBxKlFlDGNpVQlWX8z+3l8e+be/UpPQIFmp4yyLinGLHOIYoh5hbpSQ9zf5FoM9jNOQi0csezDN5SYIpg9moIauIilrxJYjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(346002)(376002)(136003)(366004)(396003)(451199015)(66446008)(26005)(8676002)(4326008)(76116006)(64756008)(9686003)(186003)(5660300002)(66476007)(41300700001)(4744005)(66946007)(52536014)(8936002)(316002)(66556008)(55016003)(86362001)(38100700002)(122000001)(2906002)(33656002)(38070700005)(478600001)(107886003)(71200400001)(6916009)(54906003)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oKsKY3D59xBpdlHwOQgjNMRlFZiPfCTBBhGSzCkBo2U//NphEnGQXmu5nzE1?=
 =?us-ascii?Q?1sswfeZuPVrOmuFSgTTJrOeOhTIl2nkeHeCOfyzrE2iDBu8jwD0ISFH9Ypit?=
 =?us-ascii?Q?kI2278PDGKIhNkSf3V4qSA6fkrHZvLpkgLP5b6g+aI7Eq5sRGOITaS9k/YXL?=
 =?us-ascii?Q?PSnQKm0y23tYPZVIIjTHNIaU5iOPjfbUobtMXHLFMU0rZLnw+NCwpStSv/0z?=
 =?us-ascii?Q?XoDGd3xFg2iDtboaPwQjn2RCUqiu1ut7mH84a1Tp2nfz0s4bXhmdj3X6zRiW?=
 =?us-ascii?Q?OhWiH38jZmwI7qqrlzYwiIRx0ThepH2qRCNT9u3PFxcFc0N+UQPDCx0k244Q?=
 =?us-ascii?Q?G7aAunq1BI4CjdLwA+UH159TWrGrMhYCp7OrwF8cgcY45jqj1IJT4ySeeRjl?=
 =?us-ascii?Q?ChWxkzfwX8czLEN3gWsj1qU0itt82h+SF+9uQlYgT38yb/EjYVZeTzL7CW9V?=
 =?us-ascii?Q?eZEV3J/pIwCUFT8wyvqEcEFPXL8iOm+eLMo9ear25raOT27jT3/YaTKhJeFC?=
 =?us-ascii?Q?RhYyfymbidLLX02tLTvZzObrldjSDzmTs6Lm3mR5B99Pg1QFWLPouJGGHRD2?=
 =?us-ascii?Q?eLw7XazZjeDI3Oi1huExXNOHbwUgAQ5BRqY3TX3A2QwS+QGv+cMqpQyA2epb?=
 =?us-ascii?Q?/UFfU5vaK1AoTxXWKmlohfqKYuKwfqGJxTDUirqFMqFzm4XIt9Ky3RvibnMW?=
 =?us-ascii?Q?Ogaqe5IVphj9LP8V1CjF0wJGfs5y4bUNvPqaDdNceYP051pLLlL5ySCApR4z?=
 =?us-ascii?Q?jN67by/QzfTuTu3jZrSxDHJubrowspxF05dk1Wyo40kfeu6AuSXBxuqxUylD?=
 =?us-ascii?Q?BdqPfGatjd2GucLdwl/9AZKDErEOBNi2o4Mun4GR2xfkdMDLXWkB5sMjmcAO?=
 =?us-ascii?Q?2CKgVkPTlNOUyAX5C2JLhZoJiNR5IIIatqpK93FgCY1oeGdCPvnHyxtI6Xo6?=
 =?us-ascii?Q?Q/f1CAFj3Vz6CDQPVojhQpEB8qdlgwTEeO6Tw61x0MJdgYURQrZxG+fYiPql?=
 =?us-ascii?Q?bPSCMB7Ta8HU8zp+qCGx9qtC5c9qfqjI1oNKhm81GKIW6XjxwOL08c9iQamm?=
 =?us-ascii?Q?fGHnuG1KpTvb7/z7a3QFPPwQy6gxGtm0ZN6+AJ1b8D84anoY2g0fQQaJ821C?=
 =?us-ascii?Q?x9bd2IV0unolQf7sKb6ooUDveCmMyzPQqyGcVrMscjnwSHOJMMBpB3SJwFhj?=
 =?us-ascii?Q?3iVQkTy8RTZyl0Xr7tmGWtYAaLLTkYdFQBWZG/8VkFdzxgG7P0pOc0ltlTNC?=
 =?us-ascii?Q?zpjYYxqDHB2+MEp0wyESIkS7FUHR2X3tIOr9F5gEY8RKwIfu65jDVxTvn05B?=
 =?us-ascii?Q?MeK/TEICujHsimRqKaOYk2BcIYHgGYfLeITqP0m/JM8Vw/8jLhlF/AV34d6R?=
 =?us-ascii?Q?y05F1bckEEU8/EZMecVyYyb6Re3uO6E5JGsUaVyYMXT/8KNbpQptvBYlaW/F?=
 =?us-ascii?Q?jxX6t+3QT803toXXY1MnKoqDGX7i7oorjGRsJ8m7TMjz1g1ZGJt1XRhgLHzz?=
 =?us-ascii?Q?kJV4JtsmiokZWtWkOI7mzQPhDeRzM7jocm+KuOFyYA6pNLHct2Pnye/wsH45?=
 =?us-ascii?Q?KsLmfBFZAkeLjzKyF7PcqsXBbQorAdSXqg6nXztF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886b9f4b-c1b0-4b5e-bd96-08dac60d4c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 06:56:04.4594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UEkPZOBb0YElzOs0JwHCvW820/0xApQpUzPtN/fZl3vMxV5GQb6gmYRcNYJ6jasi6I6UIyqKfPF204J009qmtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB5209
X-Proofpoint-ORIG-GUID: J2DNQjHnc74lKsBiiTdh6GRmwVHypbnv
X-Proofpoint-GUID: J2DNQjHnc74lKsBiiTdh6GRmwVHypbnv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_06,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> For  "Dropped packets by DMAC filters" did not find any equivalent APIs, =
so will keep it as is.

>> Nope. Propose a generic netlink API, probably as an extension to ethtool=
, which other vendors can use as well.

ACK,  will remove DMAC filters debugfs from this patch set and will submit =
this change with netlink API in separate set.


This is exactly Jakub and my point. Is your hardware so special it does thi=
ngs which no other vendor does? Is the concept of DMAC filters dropping pac=
kets unique to your hardware? Is this feature so obscure that no other vend=
or will ever implement it? And if it is that obscure, is any user actually =
going to use it?

	Andrew
