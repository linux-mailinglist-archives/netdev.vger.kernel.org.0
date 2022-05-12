Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE00E5245E2
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346582AbiELGdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiELGd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:33:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453532B265
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 23:33:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9OtoN9CaZ/vxb/jkGRkO7c3cHsd9nKnMZg8c6VT+2b+7o0SDHYFwgRy5b+g73Y5W8hGEoUFqeMOiAJnPaccxCXgG3OHxFC/yrVpgWFIC5JXCOjcexNkt5pRdCfmTKx4PPl9/DJRysBGx9p6SGeh46iPSAnwcavEsx01lwgL2LUOLTV0w1ZrIfe7UUnKPNl3Ofov2gImqEKCDkDbDEU3sZ+RUV+bq7vX+qJc7Yj2hI5cDb881C4Xmdc41yNeOUEBKgoieRwEnQhSZ2dQvTQqQkQCiklopCjGnGuVUe7WHBX7d+JHnXvzn3RudFD+gHUtu4+zOBJqJjqNkzZh7k1lKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbRQ/0Qb0xrsJ8o+6Lfqsh990Me6i89lwR5zBEajhZQ=;
 b=GOqFvAMvefyyvNBdX0Oo9QQ6X06cI+rUPMCjtOsSJqxSDANgNiigj3UzykZxrVCn3v8KoQ3OZBH/eds/ZDB+rDhrDcrD+vny4rlmf+ZDIlgeg4xOi/xJuGeea+QhcQRBcPAY50sslrdsXlN0rDT133KeY7qS6yFozdtZGdC9xHyibcMtCo717Y4BvAyqcDepO32k6H5gWiKtOSLFJnP+g+r/mgmTXj5crawcu8xMAYA79rJTpoqAjKVMwWgbi7gzBHQkK5bTrjGzxLFQu1uZRizTEDMCSe+6zmV9L0AlGXBXCTIuWnrXElt3QKt3mXJO0iK9CRkQe8t6pjJ/Y9AAyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digitizethings.com; dmarc=pass action=none
 header.from=digitizethings.com; dkim=pass header.d=digitizethings.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digitizethings.onmicrosoft.com; s=selector2-digitizethings-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbRQ/0Qb0xrsJ8o+6Lfqsh990Me6i89lwR5zBEajhZQ=;
 b=a1/kguJbUuAD+dgIFI0KyS7sisCUCCYed5VHJN1CyxTQvQ38beJXdNjSwKc0Oov6bsWaxGn243NDUvLxS2pcvRuPJGYiNC4363lCZXuRVW/qYsJHOHCevuK3Xk6GOlgMPGtMXKHkdOCpIxz1rMbhb+5FsGjvMYDVLVVep8IEbs4=
Received: from DM5PR20MB2055.namprd20.prod.outlook.com (2603:10b6:4:ba::36) by
 BL0PR20MB2051.namprd20.prod.outlook.com (2603:10b6:207:44::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Thu, 12 May 2022 06:33:25 +0000
Received: from DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::5047:44a3:6942:3ff4]) by DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::5047:44a3:6942:3ff4%6]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 06:33:25 +0000
From:   "Magesh  M P" <magesh@digitizethings.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: gateway field missing in netlink message
Thread-Topic: gateway field missing in netlink message
Thread-Index: AQHYZcnw4cK/IZ5yOEmDLm6So/d3SQ==
Date:   Thu, 12 May 2022 06:33:25 +0000
Message-ID: <DM5PR20MB2055A7DB1D5CF2B66CB0384AAECB9@DM5PR20MB2055.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digitizethings.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efdef286-9f17-4774-52f3-08da33e1516f
x-ms-traffictypediagnostic: BL0PR20MB2051:EE_
x-microsoft-antispam-prvs: <BL0PR20MB205161780EFE348BD6A978E2AECB9@BL0PR20MB2051.namprd20.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jitrvtJWgUf7YbKPGIRcnksgN8qwsxqYy7F9ff74T3cKXJv7UOcAKdcKnBvCrwEglQiaQ/1DC3yTsQZSqjcOdubkCZINIdBsbGC8VClmbWt9eECxhdY//Fs39iyuODP9/Zm9TM3yguHtXgRYTjp1uMvyIAylSfSkfIr+HJ4klCvgXf9vV36DRaB9MsPp+JDUFBe02BsUMrpXPLHj0lMKxb1m6x4KFJp1kQBJ0w55wH/1O3DZdVIOStHYDnXVhDrEAcO8EOhZr4Qe2RSympP+psvom8DB+7Ynv1zp/mkVp79f3Q17BEX2EKRT7yGKxHEoHsAiEFhI3kb7+7MTTo1qXrPTtzRqUyku+dEJ+C+8fjr843v/XPFiR+mQz6LoLrEft1G6LedvsZE56M4JeRuUpiz7qpjDeRKoyGFkXHYf7ZSCSDTSlXl1sEmCzcK3jn8CL32f1860d1qChUXu5ydbXskvAPDwytF1AhzJ8ko/kCUbgUhiOWcACWLZSa0Vh9ItXvtdTOCHUEXdSjrvpAbXQkQMUwI8PmlR5v6EvxqQ82NVXusVdshUZoDorEpuxsbEFvYRictUYOmvFcEsGMUyKKWRFgFoguOBcyL+amEHFMV3f0IFdUxmfXESFAvxtPPJYDU+HcWIuSP4sFBcE4hlOryj9E39elktMiMHVWvg9AdPaeagzjmYGMdYzKJk3uAVQOIWk3GRz8NMQAAseQNvIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR20MB2055.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(366004)(136003)(39830400003)(376002)(8936002)(4744005)(52536014)(5660300002)(76116006)(91956017)(66946007)(66556008)(66446008)(66476007)(64756008)(38070700005)(38100700002)(122000001)(8676002)(186003)(110136005)(7696005)(6506007)(26005)(9686003)(71200400001)(508600001)(316002)(83380400001)(86362001)(2906002)(55016003)(15650500001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?q50PVuf1Y5sBnDtXVYcl3+//5HBkOiJPwgzZNbXj0dwHYU3wNz1dP2SH/p?=
 =?iso-8859-1?Q?p7fEczD1l3im2J0h9OXNsnJ5PtdAEBuv+ZgvaivoncMDwihMIpz1Aa0yTS?=
 =?iso-8859-1?Q?9FXDTE/85pIazWaS48sLLI8HQF3oGd4jnqrfi98ufbG0TUocIR83oLkywY?=
 =?iso-8859-1?Q?Et6BK13uJoVr6iDNcW59GhfKJhIo1uURjFm7D33skjm896MNOjUb4wF2/1?=
 =?iso-8859-1?Q?bPbPAPJ0AA6+kiA5wGqc6gWqzCxRRRALwgB5bxqpm9T/SWpUqKIsnjdh95?=
 =?iso-8859-1?Q?ro+MADj6kdCjlWqqV91YttjF70cf1M6j3L4afSI8QHID7Yr9SrW0jcznun?=
 =?iso-8859-1?Q?GM7MQ9Hj+GLVzbsCrLpEN3JjiyzXKqmJ3R/xTm2c5YzRVLH0wDd4lRo0u8?=
 =?iso-8859-1?Q?U/aWjLAHzuhvq5al+x5DHzSHm7ko8t/W8L9c3ZGVEKM1iRj5FixlwsF53l?=
 =?iso-8859-1?Q?PI9nMC5YGZSeYNBpHkCrP+x810bEY6g4nUTC/TiPOR2OawOiN/duf/P0Tn?=
 =?iso-8859-1?Q?cdYNyn4FStXskrlBRf+EZ2JdccLwFRWYmx12FxbCxVTTdYxUx0Me/lZuX4?=
 =?iso-8859-1?Q?+WMpMIH2ZUi6C+TDtUfTkavb2iGYJvl+QdYBiA5hhmJhfvAYs7cn1N/0we?=
 =?iso-8859-1?Q?6caRy6APSOxL7XOc2ToHocLoJ+EEZcZh/MP5xTwsTuxfxVnGJTv10lvPBM?=
 =?iso-8859-1?Q?fC4MlljBUx2FJ/jMlFshMQkpk63FSaISE7291lBXD++W8j7I1E1Kg5ZYwF?=
 =?iso-8859-1?Q?F63w9gypLM0I2QJADi5IoRxGw9Md7Mddvr5ZSybwW8Mt+B6pPhidR5VWB4?=
 =?iso-8859-1?Q?0H6aEtaJKMNLAtwBrbfQquULDAO2+LLGjdukHhxQF0TxZenCmg3RIBJvvO?=
 =?iso-8859-1?Q?U85asy0cOHBZ1HN93+/hoGg7td2q7QdahTfN159vdu7cFleY8QxqzCcQtR?=
 =?iso-8859-1?Q?uBowpHfXbPukFG8ELRcR8EapZAC+p25R7w9xLBTrQ0yEkpOHWE7AVE0lwy?=
 =?iso-8859-1?Q?Ug8VJu2Cytmaz5iN0gbzQawCvzOdxMtxRFO7rCsjO5rO75H3CzWQfaq5I0?=
 =?iso-8859-1?Q?Vn+GFvxaL1y5aDIAUenQQBTKInL89zsJt5WVF39KpD/uflv3bNHEl53Ibb?=
 =?iso-8859-1?Q?x+BcFhCI+pF/kP95zsaefzTndjtp8sPNVQx6WNP8NoEugU5bVCMsu28PQy?=
 =?iso-8859-1?Q?ID6i+gijBTIhZObmY1m3p3wH/WKFFZwi94/9mzkDRdXHJwbsIcZBfKjNOO?=
 =?iso-8859-1?Q?tkb/bT+SuAkIvJzy5SMOnZgq14EnbwAIfn62lSQfXXuDZJTqUqawN2ybei?=
 =?iso-8859-1?Q?2717PUlFV6PuMxVNV+DwLrMUO9HLQZsZfqKpK9ZSoJ46yBzTpdgfpGgT0b?=
 =?iso-8859-1?Q?j8hPZKH28c35/PwTJAyWOJ0n9i0zAHu2jOjDHdWN+zgEgQjW9WAXNAevis?=
 =?iso-8859-1?Q?pXzKoa72IadLoRdHE3ffD9m0ww4FxG+y1FJBA3ymRMOWGvksBc/oCdOPgU?=
 =?iso-8859-1?Q?AUAvZ56B4jYsA9+HSfRHLkedFw1W/tN+wIfwqeLi9xnJ6mEJC6a0E/NYzA?=
 =?iso-8859-1?Q?KDJrqR+YRmMQLP2TIhhNjh75AY+eNF9dleXY1JmczCCW/lNFljfiuOTfSj?=
 =?iso-8859-1?Q?xuqWTo+doqYRaE2i3db6SKK2eqh4D47NSjMod48YhEmYfrLJ5mLVZZwYZL?=
 =?iso-8859-1?Q?9Ka0yTDnFDFY66jQO9NCOHanB0V0loDOCkFKUmrKyVybF0i0XhOSsFu0kK?=
 =?iso-8859-1?Q?W6Gr7oGltaVkRK99riCbONjtJc7+CbnkAeAKl8rQYqKYiyMOyZIctYUuOU?=
 =?iso-8859-1?Q?vVAWnxrrCw+Y99ls9dQ6WsNljSucJI8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digitizethings.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR20MB2055.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdef286-9f17-4774-52f3-08da33e1516f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 06:33:25.3098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 49c25098-0dfa-426d-808f-510d26537f85
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u9XCHbxiKx8V9Y0Ce0xEnWIhz/ODrmZcH+gdAIE0RJn7aBITR0iozYYua0Rgnfv9gLBIsyuEtdOg0D+GVArPslG/VQwm8o3QXJrf1EhtxXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR20MB2051
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Steve=0A=
=0A=
There is nothing to do with VPP code here.=0A=
=0A=
There is a netlink related file librtnl/netns.c which calls function rtnl_p=
arse_rtattr() which is not handling RTA_MULTIPATH. This function is called =
when netlink message is received from the kernel.=0A=
=0A=
netns.c is netlink library file.=0A=
=0A=
Any idea to look for the latest code in netns.c to handle RTA_MULTIPATH ?=
=0A=
=0A=
I added code but I could see only one gateway RTA_GATEWAY inside RTA_MULTIP=
ATH. =0A=
=0A=
Regards=0A=
Magesh=
