Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F53C5E6E66
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiIVV2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiIVV2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:28:16 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20057.outbound.protection.outlook.com [40.107.2.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCBC111DF6
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:28:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeqaidprOnuRPuQiQnU1i8zwDnivKd/VlhTgRS1kp/HqCfxEJ+Ettdz71hR50uQ5aSWfEO8+791cKvIs/04zKkyKlCR1ZgKbYfwcpMszh1sxqcWXC4vZ+psMQUlDtbdwvGm6I7un11jYnZ1UitNplTdzRwPzJdteFlM/W+6DE7I45zC2GISkvVMn/oe3AesgGM7XCRe4Osv6/cCiBYf6SOKrIbjafspHx1i1rkOGnRUmciYmXKAuK6KfO4ywOydCDc+sg7UT0p+iiWVxLioRWrg1nbIMQXxbyDQ2/WsQ4Cn4zceESbD45K2vTYEg0XxTDkbbca2PJDjK514XQCFB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nguSxZbat+A58AeYmyBEAOpD8hOTZRHOZ+jZdl2Xos=;
 b=OQQ1zafE/tdNqKk6IuWQ/cluBtUFYzEal1C/lX83Vv0PDaMcI+X15k1rJf4yNLadxX0YYlie+Lv+6dEKvG5Zu6TEIczvihljYX94n8DwogbHwsCHGu+T0zuVfgXSCsruqDQPii+Fr4DwZfuy4ku2QSxK+ooiD3tkalTlVOxY3TY3i7m+itQtpC3/RqTzuiLbfbcRc3o6+HcqErb49vWD6ddJxtgPxbEycpgLfkRg3IAWHhzS/Rqr9CV+NHGQPrzmkUXfCfvq/Rk7dI9ucI5ANLc1AzHtVLBXO/jeYKa18vjdr1Am3CUu+L/FIte0J38yVoS3+0yt6ln4zbeNLOr60g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nguSxZbat+A58AeYmyBEAOpD8hOTZRHOZ+jZdl2Xos=;
 b=Slky9YeBaZJfgUM511IQSg7uu0OyLhuzaoMS874+Fa0jsPaVhkcy1UiuikiPeZEoSvDi/EQtOK3UjrGlp4HJLe1kb6Iqc2DhiWV/bQORNaIOBL994L0TE1COyx1NsRDBmpoOkz0adI1Tp6SH5iyg4gdNKvIfVm06Lhd1XD5EQD0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7922.eurprd04.prod.outlook.com (2603:10a6:20b:249::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 21:28:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 21:28:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEHDgIABDlWAgAARNICAADKKAIAABd2AgAAI7wCAABAEgIAADnaAgAAAo4A=
Date:   Thu, 22 Sep 2022 21:28:10 +0000
Message-ID: <20220922212809.jameu6d4jtputjft@skbuf>
References: <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf> <YyyCgQMTaXf9PXf9@lunn.ch>
 <20220922184350.4whk4hpbtm4vikb4@skbuf>
 <20220922120449.4c9bb268@hermes.local>
 <20220922193648.5pt4w7vt4ucw3ubb@skbuf> <YyzGvyWHq+aV+RBP@lunn.ch>
 <862fa246-287f-519e-f537-fff85642fb15@gmail.com>
In-Reply-To: <862fa246-287f-519e-f537-fff85642fb15@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM8PR04MB7922:EE_
x-ms-office365-filtering-correlation-id: 6ce33ae5-66b7-4bee-7e6a-08da9ce15925
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lFZbLeFhPoT42CcGgQC9UY56ZDaW8tXvnELJ06Q2h00zn/YeLwLvru8LkcInGbBdyDYsOOqLU8bMhV51r6kQ3eMhICEInqS9YyLcOfKoAHVq7rRyM53O3JajsjWYnwgB6tH4HTcyRZobCSUfy2AIuu4rjfMbeKHSX2TtDbFViQiYWjEVtOHqiwCoVcPiPjWpOuevsTLDfv+495HzzrSJwiJD3EYap9UX1DnZEX9BJxIWURtNiDO31lnRPvUHR7zINRBaXu/owaXI1gKaT/LkHXt/J+OXYbFBP9CsVz4s+ejgVLBuhcff3H/L6LDqm5nFBYppRt0YyHCA5e+b9c8+vIQJEQ79rChGJp1x5La8jKinzS1wdo/SjMzIsHLqY9jnpeljcQizB0C6FQ1hS4ctgLTxswRiEtitwfMF8ofeD8zXaE1Wlm4mwRe9NTGol76w1/57EOodNrA0GnQePdYRVkbdr4sW3rEXhDk0Q4b10xsmKoaqTPBy/B5152jTbA1lQbygQF9VEGfDRpq3AiKUO2vQC9pd2I2Qok8eho5gKRRBja55kMG3PKNmvJ8V1r4n1v+dDwjkvtEemsl5KoxDIZktrKTiWseErcpT+d93VMXoBPLKqvYKMu5W9K0jviyVQ/8dY3EkzkATR1z+I4UNyKFi+9pSypQvMhjA154eOVuyPwo15joktIstf72pfiVzW3i9LJdH6WZvWU+pZOjjuwIfedxARo+WiocipzK0gQA9v2Nu/SzEOnnPKMZVICDatzoHskpJmdQ8Xv98wkWPog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199015)(66476007)(76116006)(66446008)(64756008)(66946007)(66556008)(6916009)(71200400001)(2906002)(316002)(186003)(8676002)(54906003)(4744005)(5660300002)(478600001)(41300700001)(1076003)(4326008)(86362001)(8936002)(44832011)(6506007)(38100700002)(122000001)(6486002)(38070700005)(9686003)(26005)(6512007)(53546011)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TVvs2hR4KpaCTDgJZ5H8Hm9zqnFiZxHcoCo3NhY07H2ESEscbxtsF+1CbUV2?=
 =?us-ascii?Q?g9k2Oeg4KIMkdx1nrZdrtob9VdAKmZ8oK/5K+BsMGw90kQtFaDH0Narg3CgQ?=
 =?us-ascii?Q?fyQPO5jBOkJGIbNBrbw+6TTTwkjKcBm2XtQ07jv8FZc9gIPYQSFbWStqzN/G?=
 =?us-ascii?Q?QV+mtE+HTaX5MPLjhYUJpEAByo/0AZnq76CV2CEn8/g+G1P5gZ6A5Kll9qo/?=
 =?us-ascii?Q?XT9gR0it14RAKkvHeZ7zVtEAU5MKHlMPieBaVAY9L4a/Q6fg6CP0kco6ySla?=
 =?us-ascii?Q?8F1KNBnAGZXVFgejMbOtDxHepkx8MyBokJXE0umyOZELXh3Ta6IuHFZlux5i?=
 =?us-ascii?Q?gsETPCOfhUVCyguuVe06FXC/FCwTRbZZTh2H36Jf71ZDI3UVkNCoHzQypQIh?=
 =?us-ascii?Q?6WIRwGuitIymuX8prtdsPOc2xQF/SzZKUNRHJUrfMwLH9t/FGnWBWgfAIeUI?=
 =?us-ascii?Q?dpzCr6cFi87puiA7oA4Ar5UnAqbcvuCKyYAtNo++M/2p5EKa6nAtxwO/40yN?=
 =?us-ascii?Q?IVQUJVzXTzOJWF3RFBdyJJ5V6fS9raVxw/7J60WmC/zDGoai5P9PUleTxPsS?=
 =?us-ascii?Q?5O5XJUkDxbLwRhwHg8Vwl/xEjW/6XuqeJYRHL5sNOcGrz/WosMmQeZzpxjWe?=
 =?us-ascii?Q?SQ5RPb8mS2dylDDmYHm32lzR1JKDK3qSearv5YC0FrBn+GhfAJ73FW4sDT+6?=
 =?us-ascii?Q?i7DZV1Hcsrpfmk5PEgjhtXtO1LaktOzUTgCYSzYHViLlPefSoB/aCBqb0Xo7?=
 =?us-ascii?Q?79xrAJtrUaZf9g8zd4ds/JAmR8JCFN6Ijxc+BVKYkJXMTr7fayk5YPzkj+bn?=
 =?us-ascii?Q?jp39+vKVajWbnAwTKjFkdxC3hwK1ZS7zORzg2aUsy6Y2pkSHs3FkrvjoCtXL?=
 =?us-ascii?Q?odZ8SAMl911gqJkNGB6BqFVm7B3DS5enrkTh28l0smsyCnUBBZiKAU1GEiXY?=
 =?us-ascii?Q?R8G/jjU/YtkZUznaIcusaYdoUqDyLgiRr/oyU58ChTbTqNB+NL3Fe2jJdWCq?=
 =?us-ascii?Q?Gw7ILU9h+0JXtZ/QwFtf5dc/68Pum+jrJlOGG/u5duWaJH9d8dAwHCCOhQYu?=
 =?us-ascii?Q?K4zSu04WTorwdwE+i9KZQUGtsqZX1bjQMFBHu6XOAhduykvWGf10R/u9Lt9W?=
 =?us-ascii?Q?vVL3QWkJmVOntnm5UjMRnXcoZ0gmxhVqu1SP2lnyTNgvFMPsJMg1VCWCLY+s?=
 =?us-ascii?Q?xb9ezEWUmw91nWWEcQWBdLBRL1UvHGsaxKdibo3m8XE7mDDQgijYDhJABaBq?=
 =?us-ascii?Q?Cs1pN1xonRl7oljmr9t5+IN5oCeX8t+zzXbTBHRaVelWnaz5kdzjrEUXTvWP?=
 =?us-ascii?Q?Ik520SEz45keW9+AAkEDBQMlkRvY3p6QBzAtS9Z8xuTC9J6aCDvmAaJzdfbK?=
 =?us-ascii?Q?IVpZyW5RpLOoZpsynIvbWq9lAzVQH03Zd4CDKMvduP0PkGCl+4QuyM8egCKM?=
 =?us-ascii?Q?YOvRlMlzNZdS1OqMlPjevlABCQYwQ6ogbtO3x8j/1G69GyxKp5Ie+a42Tpm7?=
 =?us-ascii?Q?p8biTeY8MaIjGJNx+rxrF+J9iWkvoaKAnLzi+tXwoiqQkaEHe8k7I3BIvx3T?=
 =?us-ascii?Q?O1vsGkoZH5LWzpXTIxEJ2BbV85jz6oPo9P5x72H+REVLLfPTB3LWWMETKmEJ?=
 =?us-ascii?Q?FA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7283F9CDDE54E48A938032B466B3B8C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce33ae5-66b7-4bee-7e6a-08da9ce15925
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 21:28:10.3238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KPeJKgt5OPLbdoADVy3rnLjck9v/wfTZeU2/ikoz2xBSgythp+rwkmHGCJOSorEmbN7RIKnnuximoHgEM0IqZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7922
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 02:25:53PM -0700, Florian Fainelli wrote:
> On 9/22/22 13:34, Andrew Lunn wrote:
> > > Ok, if there aren't any objections, I will propose a v3 in 30 minutes=
 or
> > > so, with 'conduit' being the primary iproute2 keyword and 'master'
> > > defined in the man page as a synonym for it, and the ip-link program
> > > printing just 'conduit' in the help text but parsing both, and printi=
ng
> > > just 'conduit' in the json output.
> >=20
> > Sounds good to me.
>=20
> Works for me as well! Thanks Vladimir.
> --=20
> Florian

Hmm, did you see the parallel sub-thread with Jakub's proposed 'via'?
I was kind of reworking to use that, and testing it right now. What do
you prefer between the 2?=
