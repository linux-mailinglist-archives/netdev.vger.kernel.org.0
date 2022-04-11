Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5106F4FBEEB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347168AbiDKOWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244163AbiDKOVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:21:20 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFEF40E42
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:17:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WilKPbi8HC/oeiyYlkq0ky1yqWZHz5zqNUUOQ2+w1CgYSmef6jaqYOtyq9SuWEiHq/br5RJENy/I3Do0Cc9ysO928KR8I4lQ3uAcuBJf46VrV/XBBViK1W58j34zRsnglrw+Hh/IPi3OgRXXRz6dDB9ZUoJj5IiMKC/xYY+/eDpQEtRqAcsSUNFLwHfXJSE1IuPxugSiXqwBtZH+ontcBbODHChfEIiSSR4NWzz77ESm54FpKfV2hoPsk3qFcLjfwqJ5GwYWkalYsQ2HVbBEXxumWEY8ad676MIASN8VV92HMWsQqvw0oaPRIt88TXYHMfgfvOvXaRZnc9jlrSaSdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRJtyli994khM0it0raaQ/YAWsnX2UHoOxgb4JMdfj0=;
 b=NYIqHtozKI6lhXRp0h7tALsZOC1pztV5DVADxt5U8O4q+97vnPu42FV9bEzhYaLkpo2sQUd3vOIR9Gt5CzExLr9QHx0vcfJBt0kGN3YdJgv6cOFejnCD06cOxV7d4s8phfS4PYBDkmTFDgC8YMXrKVk6OLTMDXNxF0NahDSa2bFRUWq9smZ8gkwsFvJF9jTGNazUjNjcB4aBUeBWanV0bA7hjcrL+yIETTn91aT0AeyWsgt1v8WHissjqL9cD27QreilH4ySjRJR56GExfmqU3nwlWqs1NjumDmByvSv0c7Q1uJRc3tKqln/C6j3k7DJwpU6FrTlBS6TWCamf9PEVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRJtyli994khM0it0raaQ/YAWsnX2UHoOxgb4JMdfj0=;
 b=O4E8vvxshhCVoPPz1gpaExma+ip+ibtSc2hKSl/nv5390F1xW6xGAmfEbXA2Br0nnbu34lf4pNZ2so5rS1s7Oj8x/Ua80KB2w5I3WzLbNvVb0KuctrSFPrl+7J0yG/llDkXsmYVTj+B3RbXp6vOfYjVeD6qeSuYyVZK2MwBlvbWoJZo5w52imCIfrk9i2uT1eNHIUaB1TAxrS0iB1/dXQ5MH9tHnRLTGKCEXo8rbwhSQVT/bbwHlD0IESe4OTExUhKi8HCkA0Gzy2nAdOvkotQo3qqg02pECGeahP6Cb/vP0pqfDqLNN22iMlWeRjeBSEgfAZT8HzJPcy5lk+t+q1Q==
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by AM0PR10MB3380.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:164::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:17:44 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:17:44 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Schild, Henning" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>
Subject: RE: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Topic: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Index: AQHYTaW3YftshBPJT0uGZWTNekz6x6zqtO4AgAANVEA=
Date:   Mon, 11 Apr 2022 14:17:44 +0000
Message-ID: <VI1PR10MB24463A87DC9BED025D377CD8ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
 <YlQtII8G2NE7ftsY@lunn.ch>
In-Reply-To: <YlQtII8G2NE7ftsY@lunn.ch>
Accept-Language: de-DE, en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2022-04-11T14:17:40Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=e86faf57-96f2-4921-bc4b-864f0dd520e6;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b7e5e7b-fe7d-4f0a-3fc0-08da1bc60bea
x-ms-traffictypediagnostic: AM0PR10MB3380:EE_
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-microsoft-antispam-prvs: <AM0PR10MB3380F5E150D084FFB679554FABEA9@AM0PR10MB3380.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7ZrA7Nn8ZYCEaENpjD4HBZPbKu5kaqkSIEjnt7Jkyf9SUXI8iJrJqn9JS+Dd/hv7cvaKfqxaqWjzn8y44mJRmZcqIVGv3FSBZOzhfkp54Gao8wu44v/gULhlTAdM1fEgQHZWa09omvqJwjUKZgKXlj4rj6bih2b2Xm2bPzNiAWlzey58SgUJiud8KR7YEBOfqm4RUh/M7e0DnwtBF425FSOuQJtG8gw4vjR046SCRfeBQ9RtXkWXgc4HMS/g/WBR4154n016r3h+r1UMEyBh271gjaGu/Yp1l9ZqiOpplJGK1F7DyIgzYZdT1LcZehXtyuRk0Nz6rqitPvAlNMU1MhUq0gOBJF/CQafGv08tVBpww01OL3Iuhe0AQNHebJr/bzeg+fsdQCDuQEGHQElG0KVTHk9sCYRcmc3ChmB3I9NGQJbwHdq96vquyjyVcpaijKmRfrRdAOad9dZUWm23SfvPtLJlVf+jAxc9VRaSRl6/emfKgV+81ee+utFDUcZ1tNLd8efG06jpFXC2m/JRmW/F3SvCjuqaXNO6PFLw5Nbx7GjbxK6rcNNZquo1Upxxn5At9EJCowcHG0Jhap/Kw1elOn5rOKrp8vohrkAJGqV4fAv9hI7/GjcbthnqZ9aKhTdrmvyoZXkfYy9XsZOYE/lDvGG7ie5rxIOOuDnfPqZK15FTlkuwt4Qv9MtJahH222soU21Sv5ng79Xn6WAjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(53546011)(26005)(33656002)(508600001)(55016003)(6916009)(54906003)(71200400001)(107886003)(66446008)(86362001)(186003)(38100700002)(64756008)(66556008)(8936002)(4744005)(8676002)(66946007)(66476007)(83380400001)(7696005)(6506007)(9686003)(38070700005)(2906002)(52536014)(5660300002)(122000001)(82960400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NgJ4fKnfXesxAIiOhioBNfUZNrMLQr4zyOsWyvT9wxQls3jU0co0Gv4iS9nt?=
 =?us-ascii?Q?8JxTRoIV2LEMayQBNpy+svrmBl9+37tnnpnr6k3im5+eCuhvmrkpZCOtzkxj?=
 =?us-ascii?Q?rISdYR6B3+eKW8kfTHJ3iVLrcQ7elSCrUex+I3Lfgq6wTpXZSSMUh5qvFpG4?=
 =?us-ascii?Q?NmofNWYr+zdOOfBXyUTI6WKrF3RA6elDZueUJW9lggVmCCnjBY6Oik5IW3sg?=
 =?us-ascii?Q?6pmSL01pMG3FZCoKBd8fvQ45LwmKM/PXguOsrxc3uCMOjRlcTHdnWp5C9AO8?=
 =?us-ascii?Q?5FD6OdOGw+ZNG3nK5n2UGmWatom9yPfbqrUb4FSrp1Wl9U5d0sYQt4arYR9/?=
 =?us-ascii?Q?MTT/c/brh5Lb+VNUqKgNAuKq7Y30rJt998gLvzjvAfhaiCXpPs9uFhT7yGi0?=
 =?us-ascii?Q?xx3OyUC2PkC70X2KwIO/O7ikvJpb/FonL9r47FctUD7M9nxqo7QXnrwCkNj3?=
 =?us-ascii?Q?pVQYLNbhzQ+CCRhtD7HGrLtVE6qDUaln2YtNeaLjEWoPLPiE/iMR9M7Ak65k?=
 =?us-ascii?Q?wQwcFJ3cfgeSQZT+Fch1K8owvF96aN4BnhXIQBlYbeXZNEVKy4eABoEXgmMj?=
 =?us-ascii?Q?xt4rOZULNfuHsP2KV2ZX5ctZmcBtsgkgP1v+qnntXax4FxQqEz5NP4XNo49D?=
 =?us-ascii?Q?imCxp5aXNU+s36QC58l8r50Rh4B6DRN1qpHuK5VQ2N8aY8lUeT0YwAYVGR6S?=
 =?us-ascii?Q?tEvibnviB3ttd2kNKUknmiklV+7R2RP1sGiKFoH1tZb8zZTMrqs/frAlmD4v?=
 =?us-ascii?Q?YuIfirUGj2D2vSAxwGbFYsqN+Rw1QbtQUSRHWpqhaQosfwhilZb/t+VK/AY3?=
 =?us-ascii?Q?zxG6/2Ua3GBIHI0F7EWGO/ug6hrtV9DEem5KcDXizRbXQMYoPhWIarxW4JGQ?=
 =?us-ascii?Q?8lwQV6jHWG9SRIFc+glMQFf2H75KfTzYQ6IqsyNkrKjnnLjwKrJ4e+OEpT8J?=
 =?us-ascii?Q?ckQVEA1WeifTFAlYY8HoPQFkud1X/NXowZ+7pe8ovHJGZYmhkCRL7eHg6PnV?=
 =?us-ascii?Q?w8kwoNkZoooT2qUWo/p6YYKHeN3zBWr/JFt23bDbokQnQ88+sX1pOzhhU2Q0?=
 =?us-ascii?Q?zdXhg/Iqh2W5jJFehpbwO9b1YYCHibcSla5Zhmys1f50sLhLRQmEDc1ljiNm?=
 =?us-ascii?Q?gIqWQLJHaC5FruA13zF7ggL5e7F/FNgi6d8IGUrOPKXnN6cC9pklherjDBEf?=
 =?us-ascii?Q?hYIIwLdzdtAste7ZaK21q5ukzXpDxJvBT+RSD2flOOZPzuI1cyVo7H58aA9T?=
 =?us-ascii?Q?tyTOuy4G5WkMZuagnCBP9ONBSQ11vreCfXQTroapiMUgzPs6FYPxyFhUEkKE?=
 =?us-ascii?Q?b1ez66ssl/NaQFgQvLiL0SUw3DkKDnhfscKj3cTgz759K8fY1LGORySl1+5B?=
 =?us-ascii?Q?0fL1MiuO4hgqPhZn+M5G5Oa1Br5s8wftgAeP3sXoRzo4OT5hteRN+0eZG+xT?=
 =?us-ascii?Q?kTVVRIe80nU0XH3BOGnVGsABLwGpQCbDObp0wxMdpqbWhemRWmiqUpFKIfVq?=
 =?us-ascii?Q?zz6Tyy0NHEQXNiZWTmCKyz1RqlAYPZMstmA96RYTP28F8FEAcbKn3vISnHSb?=
 =?us-ascii?Q?grgeuHTvfM0Ef/aSxZg5V4+57EvVu9EhN+bNKzLUjM3k5ggYT2GDKn009+NQ?=
 =?us-ascii?Q?OQIlOpqJiZuLn94Z8of+Ky+OIwMBQIgULtlDLCErV9yxcugOUdNlhVgBkRZC?=
 =?us-ascii?Q?sXiJniPM9K+4IEQ+bLPhsf+XALZGT4sYtyZcBX+HrjbuBZirJKvMqviQS52/?=
 =?us-ascii?Q?tHYkf3GxAIxDyzlJ/tV3Mc+GiPTH/xw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7e5e7b-fe7d-4f0a-3fc0-08da1bc60bea
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 14:17:44.1378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D4tnijeBj9x47qK3fQRSjX+okzLp76t4de9Dy/4yG8g739ZaGPFJ3asVsGV1aDupMegLdnmkMICaaS71Al2Du38/E92TOPSg/RJakVjXpac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3380
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Tag driver code in not by me.
So I can not publish it, only the owner may.

Erez

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Monday, 11 April 2022 15:29
To: Geva, Erez (ext) (DI PA DCP R&D 3) <erez.geva.ext@siemens.com>
Cc: netdev@vger.kernel.org; Vivien Didelot <vivien.didelot@gmail.com>; Flor=
ian Fainelli <f.fainelli@gmail.com>; Vladimir Oltean <olteanv@gmail.com>; S=
udler, Simon (DI PA DCP TI) <simon.sudler@siemens.com>; Meisinger, Andreas =
(DI PA DCP TI) <andreas.meisinger@siemens.com>; Schild, Henning (T CED SES-=
DE) <henning.schild@siemens.com>; Kiszka, Jan (T CED) <jan.kiszka@siemens.c=
om>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information

On Mon, Apr 11, 2022 at 03:11:48PM +0200, Erez Geva wrote:
> Provide a callback for the DSA tag driver  to fetch information=20
> regarding a traffic control.

Hi Erez

When you add a new API you also need to add a user of it. Please include yo=
ur tag driver change in the patchset.

	Andrew
