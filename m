Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1139A5E9723
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiIZAVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiIZAVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:21:42 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2121.outbound.protection.outlook.com [40.107.113.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679DDB11;
        Sun, 25 Sep 2022 17:21:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7cDSUHqV2DzlcppsS437WKxaH1Zm1GLdRHcHXORKoR9LDzpJFlpnVfPsiRjJyQa7wxQLPEF2gMNLJGS9G7Gr+1E20DXWBQke2xX76bZ3TWsoBRSRvKCDzXqvqa4lGwxDuMwpIN2ti3wGsnZk6mO6IEHXNKmlA18GCMDQFCYMnwFW81jK68Y8FPi9vcATQnErMGZuZWkiQeSgBqq8H5Y/2+jv5KKGCUPIPrunBgseSTfo5fDgRef24Srcbw6LI+ZICxh5QINTodDJDYj2oSLm8FkKmJeXKNpJOMfBuSTgSHXZG1YmwpB+rKG8DxogKQRJBaSfGz3alM7+A0iZAO/3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhprd83sP208JDKd1n09tXEXpbJsG+AhRvk73WVQcZU=;
 b=lNuY8MKpq3itowPi6E9VQj83yeXVM8xcKe03lMEbdTqGi+JByN1SZzal04NbC4zz52mdqXgmoF/hnzpRjtx4zYta0MUUSA4+aWg9V+laY8BAKyl4yBhqTmTEQq40B6IMX03PkZt62xrkJOLrrorTS2hbBQx7Nxk6CRsvXoIOTcn2VxYlcC9LjQMfnGpGc/ku9J2lvXwdaDPl95o8x8eM2Jh9+1v6wxEFD/oT4nGaJ/2gC53uYCvDY4yjuG5iJpnwvVVhMBcqYd2O5XwZiOqm0ls6+zgKVLb8N9qSA5yYlDtmLYn6bOIGI3sYSm9/zsG05zPox9zuwXNpYMog2fujig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhprd83sP208JDKd1n09tXEXpbJsG+AhRvk73WVQcZU=;
 b=ps0SGnrz7IAENq+THDN/V7dzdlkBGqWQMf3az2u9kbMt+McXvC/RMujotAccYDdyMuiOC4p5+fgApqYuDwof2v4/InmeSLn1m17rvXWcFc8yynYWxa1ACQaLJiL2FsNS4bnUMM9ihNv61BWv0AK17ALBHntWtnO9tkP3ofGatFQ=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB8280.jpnprd01.prod.outlook.com
 (2603:1096:400:15c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:21:37 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:21:37 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Vinod Koul <vkoul@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, "kishon@ti.com" <kishon@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Topic: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Index: AQHYzZbyqTwrMjeNqkC6dNbQ2PLk4a3p9OQAgACfZDCAA5ZCgIACtaTg
Date:   Mon, 26 Sep 2022 00:21:37 +0000
Message-ID: <TYBPR01MB5341791936EB2C724C753FFDD8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921074004.43a933fe@kernel.org>
 <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <Yy6qQ/CKfshid/B7@matsya>
In-Reply-To: <Yy6qQ/CKfshid/B7@matsya>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB8280:EE_
x-ms-office365-filtering-correlation-id: d03363a2-422e-4d3c-1d74-08da9f55134d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d32W+fDWGbhrMNmx7P/ZeqWDAvR8AOCVkwSQKIThBVd+UaP3/SnaYBfVwq/ysjiK3TPL5eMLxS+I1Ir/rKmdAnagmUp2FR7qZ89s3DL78Hd41Us8uStzmLX0KEdEHqLxVrqBmStNw3aiaQA0hhWYDotNEjYbwo1J57D1JlejUJyIA67hML0wUTkjABPawf3upQ5cKS6GcIWddXbgAvkAsK9/MGigyv539ZYB67lIqXVvjVRGMNqbiQAiBANQWXpXxZ2j5Ne10M6rDJGksWJ3j5jxvx+ADnpNEKgNh2JnC1XOyCROFES9QiBKsc6XMEvpMPJb7ODLsUwQQ08DJgqfaEAW6/DmLc+j2knYcgk5Z+N0R9N2xHOA1WmlSqhRDXu8vKQIPzUYqDHc7UBUFBu+djMyHoF1ZrX4KOXRczbzu7VkColYINU+A7v56h8obrbCs6GyTuRElg+iJHBFy7TkTULoswpWPhb3GlAqtkZ0mPMD4LWQKYq6VcNtK3wtA9xQp2B0pN6/tfJs35hfPsYBGBeyejgH+bJT0YjTTW4FiJgIoSaLSgN+AlhZdmFiP8rkqr53/gwVUEhAcoLZpqtd4696bLUJeeAG1tGPn4IqFDnvEsF8Chbt4obaMOYNTKQnnIdiEXe6qxObvhUqzHT5JFXp8/2AghhfkEsuI2bUJxd1yMQBZTo2B2kxloO/RTDUEQHwxA2xFBWdTuf3ez4KU3UrhvEApwtOkwDCCg4op0PkQenSRPsGN2cJP5xYH/zA3vubenRen/ZwTveS7rClpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199015)(122000001)(38100700002)(38070700005)(9686003)(186003)(41300700001)(6506007)(53546011)(7696005)(478600001)(8676002)(66556008)(64756008)(66946007)(66446008)(66476007)(76116006)(4326008)(71200400001)(6916009)(54906003)(316002)(2906002)(33656002)(55016003)(8936002)(52536014)(86362001)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6sdyIdJqxp/tK3j5U1fvFiNQ71zvK03/u+Or75TjqDCkDg9fVc9Ano4P63tE?=
 =?us-ascii?Q?JWCPzLCP6rzNXPWpybsaEH1BloS8N7m/hlPfAYqIxdiRI8/eixBmatEhZAdk?=
 =?us-ascii?Q?s4Ef3OvZ2cjMUvfOXyCB5RpY/jfVrSeiKSKGBrT+b7r68WP1r22U0nJSuKR+?=
 =?us-ascii?Q?s27YiObEnTndsRrxFNi8XsNENXXNsom4VtutofgqwhPR44/ZdL7PwtHH+coe?=
 =?us-ascii?Q?C6jT/f8Zxwbd9n/YRzW56jp6VeOKaMSclfuLVWJPw7N9u0bihdZIMAigjkpt?=
 =?us-ascii?Q?uBH5lH08nGNzJYwIL42PTyKgIvXnF4Ldy/J3lQvZZG7nqCzkBTUmmKBLfOeY?=
 =?us-ascii?Q?VHJLVUXnPLOcaLqrMLIgXZ5kjZCJ+YG5epMAm9QXh+YnY3snV/keVsXWxue2?=
 =?us-ascii?Q?7a4rkaRxs6XEoLRkJjdPeAbgLPod1SOQSm76sgendLVbC0Pjiho0IT0bglne?=
 =?us-ascii?Q?CONxgYmASBUUKyjR3bcvqAbH+5a9C825AEhqiM7Nez+HoxEa10AdPnW+SKJ0?=
 =?us-ascii?Q?LU7A02lOWbFhd9ZubOP951ge99fqRv57AE3UExannSfMLO1jaSwMSIhXFe/8?=
 =?us-ascii?Q?lLCTktTr7FyhPeUJlwfuH2xfZzsV+Ef7Gz9jDU73K9WWqvYFysH6lrlLz3t6?=
 =?us-ascii?Q?LF3alZMJYf5E1TY+fXgjza1VLqJ+0GLCJURfbQfOur4j+k0uXVtL1vvgJxFU?=
 =?us-ascii?Q?h9NBBBLSL/jxAr+1PJY++abzXHgN5NoluIvAAmHg1Vmc0ZTyu0wK+QJBiwWJ?=
 =?us-ascii?Q?w3/oYNrmCfY0eeFKws1w7XTcbqKh+f5BCkgu6JTkX0UrNF180Mt3tMBiX2rf?=
 =?us-ascii?Q?u00T41OzcUH7PZ/NlOKqUzJ2yineapKq2R/E8dukkkYW7PlPYrFhPrSFrkmz?=
 =?us-ascii?Q?X3M5+Ej9pWNZKtjzg5cQ4Z0bAhwsMMKZqZplmeoDsKlVWiscqrs8sYWJ2ZAN?=
 =?us-ascii?Q?efbP5Ew+rsI/p+V1aVYVuCZlwTHwV5nW3cyjAaXcxvIiaY0SJ+lcmwhCiyhL?=
 =?us-ascii?Q?Ueu8mR2pthNiu3RX1qOzsFXda+F9CAtHa6Pw2gNMFjBegnKJ6/TTTOcl3IsO?=
 =?us-ascii?Q?rXJV4whfFG7ZJLPRwqHknrTEJ2VjhMY23W3rlmpCXzdQYf/3II+w1XUhVdaJ?=
 =?us-ascii?Q?i/ouhhk1VP5AebHpuQzKx15GZY5TqP9m2YdLMyjn0uqpAlJMllOD/7dCu0X/?=
 =?us-ascii?Q?bKggZzG8BMPmz+HKDjMW6wAAp2qXrzw0sxJ59ycrYiJPxAi4YvIw682bCyzW?=
 =?us-ascii?Q?2xCGf1vYWuRp6KoaUdbzsPczQKUoNevu/p6y2ItV+qCKGCpm4eTFYsgkc812?=
 =?us-ascii?Q?EfhTddIeJVOu2+ky84AvF4r4nNwOkS6i/o9p8pvQCj07ie5rKcrJ5fViMFo3?=
 =?us-ascii?Q?Ye1iIiGEKO6couSH7QFHhg+PEuJnhgh/ZXZG2iN/Wf8cahroylzWP+IyiOak?=
 =?us-ascii?Q?IACfj4xUXswDiX5rvpE/LTtwHHApfm8U3ll3xSYoF/NSo7IWxthoFHNj9Yql?=
 =?us-ascii?Q?D5oLTzreUHCnxP6+gYnaI+Kb1DbRVjV1gJST1bn5+xFKyaw/ih0puNwC5A/p?=
 =?us-ascii?Q?W5yuN44PMKJtRQkYVmjh/O0FveHdKMAGOZTmK6y8zA0N5IYW2WmaQSUTWfxS?=
 =?us-ascii?Q?cuEjCUg4SDR3jOwvSpIqVOv1Mlu/O7x5hratOozEtLHHqqWqVdtMk4bpKLer?=
 =?us-ascii?Q?J86cdA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d03363a2-422e-4d3c-1d74-08da9f55134d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 00:21:37.0735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: id4ARHhtRsIAH4jLOQCDMsME5PLWTFRtG6akvvPu0LGprJNx2LlXXLc9rzvtZKFJHETmdQSQh+BclbBJwVKTOWw3N/4j+isi8OyUP9Ss/D7nZSbyi5uKlLSjnOTjVz8W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinod,

> From: Vinod Koul, Sent: Saturday, September 24, 2022 3:57 PM
>=20
> On 22-09-22, 00:46, Yoshihiro Shimoda wrote:
> > Hi Jakub,
> >
> > Thank you for your comment!
> >
> > > From: Jakub Kicinski, Sent: Wednesday, September 21, 2022 11:40 PM
> > >
> > > On Wed, 21 Sep 2022 17:47:37 +0900 Yoshihiro Shimoda wrote:
> > > > Subject: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch su=
pport
> > >
> > > I think you may be slightly confused about the use of the treewide
> > > prefix. Perhaps Geert or one of the upstream-savvy contractors could
> > > help you navigate targeting the correct trees?
> >
> > I thought we have 2 types about the use of the treewide:
> > 1) Completely depends on multiple subsystems and/or
> >    change multiple subsystems in a patch.
> > 2) Convenient for review.
> >
> > This patch series type is the 2) above. However, should I use
> > treewide for the 1) only?
>=20
> No, How is it convenient for review.. I would like to see a series just
> for phy... I dont need to see the whole other things...
>=20
> Maybe Convenient for you to toss the pile to upstream reviewers, surely
> not for us!

Thank you very much for your comments. I understood it.
I will not submit this type of treewide from now on.

Best regards,
Yoshihiro Shimoda

