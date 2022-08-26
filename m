Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06935A2049
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 07:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242448AbiHZFXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 01:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiHZFXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 01:23:47 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD96CE4A0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 22:23:46 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27Q1oMNI020745;
        Thu, 25 Aug 2022 22:23:35 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j6fbn2h59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 22:23:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpQFlFOQqZ24C91QVmPQff7TD//1ahYLFedNmx5OMFbTtaBOPbqqDwi7j+EJkqrmCMGeySbY1F7/5rDg4RZWgEP0a6qI4JyRkEtGMPjegw47CZwEU9QgciH7PFASkpevoYTq93Wgh/8OlU/4HAXTCKLuproSxpKkMMT7e+5uVh0xumxyshQBbxj9XiJT4ng/4hWoOT1Nbug6bxlu9Owx3Hl4kTRZSAEt9CmzkaRZ5qImoJWAi1SluNUEN/hfAtYja3yfMQ3+MCTrWlwijPuttJl2LxkbZLo3n0Vf7VCpGgZDTan2lMD3mSKFD37GBsj4vZxHinOL6ztbIt8w6d61BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEQJEzoqDqFIdFxZBMjt/qK4HippuxNdM68IZaOLvSE=;
 b=Lw8ujUH483LAPIBv2vKdzVFeTig30KA4Enqq6N2ifXnccMwquGZ8SiIctXsA4o0rD9Ly3QB3wM0/VtZzWGEA5LEQ1r8jvazAyKvN0bvtN2v6GLcVPZLBlhAy5AoRkIfmxmQoJaG+mq0Grdn32U5dIAEupFCX+Smy5Sb8Ow52wNGukEa1Ibhi8k60tZkQj9e9pPTmp7R932rcJ+hi3SI7+y/8pjaYwT+yOis4YvF01ft6w+4UzfjkYtbZkJBxOOCpNjidPM5H31hdtJ0NO+qN4pYBD5pJJOAtMgJrCQ8hiEjVOXYg0T9C9m5hywo/0soGKI9OE3XvizrA1bI5GakcdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEQJEzoqDqFIdFxZBMjt/qK4HippuxNdM68IZaOLvSE=;
 b=YcWj8JJSkyjEfgd/jNvb8/0uZ0XXw8cmIKQ7R7+Vi1yXrE63/M1zO6Zn7ujbDbkLe8BznAv+rMgMHeJycZA6OV9Uww39KmOfT+x2oMBVzQDk0wbgvceuvsFw+IaoQIHKz1JBv/jgz7Za7Ruh42rPKSVNvw+7NQWrzStDza2t21k=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:430::6)
 by BN8PR18MB2962.namprd18.prod.outlook.com (2603:10b6:408:a3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 05:23:33 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24%5]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 05:23:33 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [net-next PATCH V3] octeontx2-pf: Add egress PFC
 support
Thread-Topic: [EXT] Re: [net-next PATCH V3] octeontx2-pf: Add egress PFC
 support
Thread-Index: AQHYuPdbb4kNaib4mUmbddoyIe8apK3ApUqg
Date:   Fri, 26 Aug 2022 05:23:33 +0000
Message-ID: <SJ0PR18MB52162AE97BF2AAAF06ECECD6DB759@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220825044242.1737126-1-sumang@marvell.com>
 <20220825195544.391577b2@kernel.org>
In-Reply-To: <20220825195544.391577b2@kernel.org>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cf6f4e5-827e-4a99-a837-08da87231e99
x-ms-traffictypediagnostic: BN8PR18MB2962:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e+fzMt3qppGJwjf3NH/kPHtidjCpGB1i1zdOyOHSwYvvkJJ0zKRL546tV5cvvV3jwpi6gWtpQ7WnYVZ6aw7HAi2bbm1WsSH9w5l17VfwOCEfI/G5DdPO3ETBngiCIj/ybe/Mjfc7lnkQuPofUCgbnnikQKDOzG9C4a8OQqGn6FFCb5JV5FgVqXxQzTV2Jl/BKw2wfqoSzqohA3kpGUUqJh1SOE816vyikkF+d78SbtFmPXBKPzBgtRELFHeqOlKmGKFHUk6lRv6UHXzQXDSe2fxba7CZZ0qJBlrjRCMEHOYl9uGEZ5j3bRmmcNJTBaIIz6S8YHbnQImjnadXUivH7UN/Q9DjRWTmuBeog4jsi4n0gEmOscKZitxo5hYu9PeyasE+PxNc+dYJB5u2EjqtilWJHSjeaaAONOD+cAW79FYGlVVXoez1FOcDjZr6CXENQ+6vbBBoSOn+TkLhdnUGAPA9FYDOycFi003TeenvVH7ZbLi7zRpBwePLp+R8oMASPZV4HJukuSmKMpD1adzbyxIcEJqEJ076/ws+vXtGQFwRxX54dFP8QcZeNUF26bF3HWw04z791mgj3pQH5rLONGpbP60PvF4QUWxbGE8wi55RSDz+7ChtobqF/1b/60McsUMPDk2cm35i+naR31IYeGlITHKvfhQ9FbFQkP3qOYY46VHk6SWKO4VC4+T7YQPxtb7Yyl4OWQ3e5r90z8YRy5rfWVb9MFHJqblX1uI/SqdIJm4oR97YDTpWTEnoOzZdaHmp9cGnQ86no5hgEYJl+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(122000001)(6506007)(41300700001)(7696005)(478600001)(71200400001)(83380400001)(186003)(26005)(5660300002)(66556008)(66446008)(8676002)(66946007)(2906002)(4326008)(52536014)(8936002)(316002)(55016003)(6916009)(66476007)(9686003)(76116006)(54906003)(86362001)(38070700005)(33656002)(38100700002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?un+S0y7tGxNvBv/bkSr8sFVRlDd5AQu+nlopSx/A4FdD2roXSiTMy6JVjMtn?=
 =?us-ascii?Q?XWsN1VaS415p8+LpXZqwmdaVGwAUhVoOBmbxEDNQJWvcxMFDhx+0x1aztTFj?=
 =?us-ascii?Q?g07NkyuJVX6khYocIM49dZasI4Xep5coVVXXNpCyArd2sk6SNKh0HxEaO7Sz?=
 =?us-ascii?Q?IJlRNBtbLSZhWwYvfU4RtRkqDRyuUSD++/NT3m+MZOkUok4bKTsrwu4S0W3+?=
 =?us-ascii?Q?+oSGzmqdNtZAnpB6kilFl33RKA1sGmNW/V/SrHkzDyJfNXs6VZ7Cdb1tREuM?=
 =?us-ascii?Q?dniwcPCpCFam9DYNQWTv0rq6HB9pnMY6o/C3O4shkRHztT2pR7fYbvihyb7Q?=
 =?us-ascii?Q?Z6ZfBa4Ym7fiHW4AY+dboehh+6BlyALMoVSKbPlVbQ5STZxkeJ6e/IriSnAK?=
 =?us-ascii?Q?nGQVRtrytZNFhtFV04wo/VuAPcudLrXt5vCRrBSzRm+liewTrTD4ooVrvm35?=
 =?us-ascii?Q?QtHu8/k1/wKjHSE2vKwEFwJ3com4S6/czfQuwYtWPMBstb4UwNp6zUXa33Vj?=
 =?us-ascii?Q?zL9clPSbAxjebh2xZx0M8JYXEkjBIDN7sFL22Yt69a3ZrNr561PmGzpLWH9P?=
 =?us-ascii?Q?k+oO7saYtBH/SH6Vh71d6Qg2rcbCDu7XLtfUN8SNvid7Byit1nry+TAEIv4a?=
 =?us-ascii?Q?nfU6sCjx4rapjtryJB/PvvpMMC8e+pfNjv70nO33DnNNE8S7tmrCtw3Qka4Q?=
 =?us-ascii?Q?Nqz2+sOZlbGykKNPsS/u85hQzwkMddvAMnJI2nEHSlx+MIL+E66MVYlWWSYr?=
 =?us-ascii?Q?dNi++/dp0em0mZR+MfdQl3Y8a9c0QrDHbi4u3BowKw36uUrtvlM2pW6nSEBD?=
 =?us-ascii?Q?s4kA5gb9fDOtv3NBkLDanRoJ8Pasrq19gGxo+mNRY3q5x1GRVQVcOERCEDYa?=
 =?us-ascii?Q?JB8970K/jp9FxCape02Vah1NxUGxqE6+s2ejfuCufRZ88D9ZD6a4mbUQXyn9?=
 =?us-ascii?Q?ypIIj1rAuZKCCtQkzpIrvpHNcw4dDMkJm2ukNBxjeS35+ElW2EfJsSI4iJz9?=
 =?us-ascii?Q?pySHm9t3felfXlGPXp4qU6ize7Lu1s1DmzymOjTEFFh2ApHC2zO7yFiDjTst?=
 =?us-ascii?Q?OlIEcxJkrZnC7A4ReUeUqQyDO02d7Kou2ryi22NvC45r1EfuZKypYkwSxA4b?=
 =?us-ascii?Q?RRfUHbg5+OGGaAntfagT/AZVDAYOO4A5jFFZeJO5uEvusVLNiN3EKaLb+uF4?=
 =?us-ascii?Q?jHX+Rw0BivBuLU07kWHPjL2CDWkcghV1UyuuG5ze1ac84YtbTk2OsYBaOvyn?=
 =?us-ascii?Q?ckFCzsekBNo+8l9AxyosuXmhgwsXSrtFu1DC1iOsjVDA3oXqtl/ouliIp4lB?=
 =?us-ascii?Q?mQevHs6O3p6vgYr5+aX2V1GEWgAXnWoul8c2rFYY3vz+nb6LenFtzBIx3cUW?=
 =?us-ascii?Q?SVEmXsR7/OGnNwFcPPwHuSePiCBaDLBqeSYYmAVR0bbTu7ErFP9zI4aN8I+q?=
 =?us-ascii?Q?OhLAnb7S73SlLy/t2vbRbUfRhYVdlqATzpOMnC/L7a2PS0WT8mPqayg6u0HX?=
 =?us-ascii?Q?Tibk7S08N6A5SHNCUy55e3e4LQU7GBxI7oaMkqIumTIwfDpngtu42Afl3oGZ?=
 =?us-ascii?Q?XXY+5DytRzvkyjF0QJYcTgc9OV7S08qfJr9xBtJM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cf6f4e5-827e-4a99-a837-08da87231e99
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 05:23:33.3181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s0GPScYip+VTMNjO4QRuX9n0gPRIN9bHMg0xR93+GETSFRuctKI1a929js+sgEMYamSr4hRJ/X6Bohhd0rLoZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2962
X-Proofpoint-GUID: LnB8uTybDFVwhil4aC01jmCg38iXl3-7
X-Proofpoint-ORIG-GUID: LnB8uTybDFVwhil4aC01jmCg38iXl3-7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_02,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>External Email
>
>----------------------------------------------------------------------
>On Thu, 25 Aug 2022 10:12:42 +0530 Suman Ghosh wrote:
>> As of now all transmit queues transmit packets out of same scheduler
>> queue hierarchy. Due to this PFC frames sent by peer are not handled
>> properly, either all transmit queues are backpressured or none.
>> To fix this when user enables PFC for a given priority map relavant
>> transmit queue to a different scheduler queue hierarcy, so that
>> backpressure is applied only to the traffic egressing out of that TXQ.
>
>Does not build at all now:
>
>ERROR: modpost: drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf:
>'otx2_pfc_txschq_update' exported twice. Previous export was in
>drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicpf.ko
>ERROR: modpost: "otx2_txschq_config"
>[drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf.ko] undefined!
>ERROR: modpost: "otx2_smq_flush"
>[drivers/net/ethernet/marvell/octeontx2/nic/rvu_nicvf.ko] undefined!
[Suman] Sorry my bad. Updated the patch with the fix.
