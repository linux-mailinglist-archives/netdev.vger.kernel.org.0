Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629625E6603
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiIVOl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiIVOlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:41:35 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937B166A52
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:41:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fd7JMbxUWDbQcvbhVxdiStHrS9l5LpaKA7tKNbIMKCkrMMMWEl30VMqWNbX3OzDdycz1g1GUzu6o2Ie4Um/JGAyXukyt+wHL+qS3JDGNTZOhjnFoB+1InluRy5scdx+ft04b1jfWpSMv/O+Fgg9adi2rH1OXxsMxiojI5dP2cYGOCjn6bHOkRVbCx1l69253mbvH2tK9vS3DkJtBTI3376HBFFqwfDVTDrBif9QZ6OheabIfgvPl6nsf2OpBzfC10fw9Y3kAIzZDUrgAOhO/2bmhZlyYDIwAo11ZiSZsw/3VVJ+zIuQUQhNa0+VhSqWvTmeTso78B/KmgiFYrRSsKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hc8vZQrYjvLoWRBlf0ZngwVTIQ5Xf1mYipWiCbZ8S+I=;
 b=g51FvInHRgTruYpywflkzF6+eIVZvmD+gGXt+FEaG/ZhPam8rSr7vSXNcO45802a1hqwcfiwavXVZAOYmbIeixhRaqJTrbMiaxJoPUmqrvAWlveIY/OwaaLBd+bkemts+fYdRnh4wZ0LhVjjzfEwH0gRJWLF+EDlOyOxhbvVueGPtrg48lgu7saXBgVxB92Jgj4nvBRrgWusjkFCsgv+FKOSWMMxt3GCMt+WQcwBtTh3MH2UWPiaD6b1PcI0pcfYlDffVh0Z4FvQMw2J6HbOfsW64ViqjGN2u3L2cdu88uPlyATDJF9ksUvUiFVemOJi2LG31c9kNiEAFMdE/+JHRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc8vZQrYjvLoWRBlf0ZngwVTIQ5Xf1mYipWiCbZ8S+I=;
 b=nAVDgYxXggR0yhSxF/f5Ys5I1hu4EvA4ud22TltkWj+39czZdyRc3XgHhkgWgnn5sW+rn9RvX28wdnBbAy5g3QLZiLQIzb8Gay+ZYcZFFvlMQ7kofhCQ0ZGPaXTev/grH7gNAqrOFh6vwaDWMGVD5tJQ3JON7lT1amh6MqUrbm4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9625.eurprd04.prod.outlook.com (2603:10a6:10:308::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 14:41:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 14:41:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEHDgIABDlWA
Date:   Thu, 22 Sep 2022 14:41:24 +0000
Message-ID: <20220922144123.5z3wib5apai462q7@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921153349.0519c35d@hermes.local>
In-Reply-To: <20220921153349.0519c35d@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB9625:EE_
x-ms-office365-filtering-correlation-id: 6b140f8c-3437-4930-10a8-08da9ca88675
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V35nfUJ2sTgsbreXuPNqK6ZW+NonZTXhMJSWxbVuGSDuYEhrq7QSTq+eebK6y4cv2MwdCFt8RkLX6q5hGxPbf8+f1vRkUE6Ue2kTO2bXmGMvW2NXbETbHHU9zN57P2OyuxmNeuCnd4+tIl1zN0VRcBti17JIdhRucDqsmzIiQw2UoNTiSWqAOUJ2jv71utwUco/+cRRIIy6JHMfb1ELoykFBDxPwdfX6LI2N7W9U4H/9iYaDE1MLqu72v9sypAXfdU/1QhPPFpQrFzbMb0yeQ44VXrywIfyfVBiubi6Z7F8dNKsB7TRjLwK745PjUucjSLClZThhPhM5vLlTOCi6AH8JD3iSFeEsDt9f5+zxFaYul+3qsYCYTYBOuvWYNmMF1Era8sv3rjRBNR+sRfEYfqDfpyPfWWepbfusmKW4DxTepS0gtevuJEGsdgWpEd2WnXDwhfpcIXUISq8QsRxpCl9If7sysNxZXw5LsdNzJXqp2Tj/s4r0Pe1SoAIHLt/fc/Db3ni/ITyiy4Y1IvjzXoU4g12DECjlBOLpfqgnPwH/AjnB3KbD1W5RFI/fnRvyEtOrc+HW7+0A1iWDSZsBxJRFOhPfGK3r6FYVXBMNH4LbcOA7DxgRam1b4x8OvhTmqu8ZO+ljpgqOHsS8lzPNOY8XVRxV7mDK0ubLLIhGzgtu/u/rIgZ5imx7h+EXDRh6EF8dgGOuzf7I5Nj0OIAse0nLEeAtP3Tnd7d58VrCsOfvUQB/1mY/b1Yzj845+J2k+44ALsRBJ03VbRNFADEayuN7NzpgDGcsd9/7ChUYFN8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(71200400001)(54906003)(6486002)(966005)(478600001)(76116006)(4326008)(6512007)(6506007)(26005)(9686003)(8936002)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(41300700001)(2906002)(5660300002)(44832011)(186003)(316002)(91956017)(6916009)(1076003)(38100700002)(86362001)(38070700005)(122000001)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BLzFUGs3eAwOGlOgbz/zGT0ULuLphE4z1pJxk/bQtjJ49sAR4DTd/AI1NNGV?=
 =?us-ascii?Q?LC9yxjGyrtzKtp3O72o2nV5mkvsde85KjEe28rUrMiyRJUdQOcpU98244hRx?=
 =?us-ascii?Q?ryX8Gasu7SgOV0Inet6cDr5Yvms0YD7/a3mgWF+aghiUtp9IAN/jo8bMemsD?=
 =?us-ascii?Q?GrdVB7wZRdoWIbMBz5isbyDrROetAoyK+FNYsRgpzfJzPdS3vhEQwNz8ZaPM?=
 =?us-ascii?Q?ZaiCEIOvSeJVFUrGzIS2t2E2nWvtRmQ4kcE8OU7MneAhgVXiywmivNhYfupS?=
 =?us-ascii?Q?L4gyF7G8I5qQxFLJROp1gFuAOGDY/8FfuMDgNIGUkuykangbf0vv81opgWoS?=
 =?us-ascii?Q?iifScHmy3RWS/slq/+T313/V5WlcC5FDo9ftdfBq5ldHqHtvsZPwaTtykS8J?=
 =?us-ascii?Q?M/X3UjTKdpo6TlXJT0yj5uN1iitShV4fAlKo1VqxYxCVQWK/q/JFof/MGCRI?=
 =?us-ascii?Q?KHxgJOqWUHeY0Oe445wzf/sbGL5/sIdJiDtIc5ZNedfOCHEnPlk99DoBuZfG?=
 =?us-ascii?Q?vQhKGKNA4VGdPpY/cMM/vsaLTM0GDQDTozFBtVLKRokkkgb3KIwQwlfK9Ued?=
 =?us-ascii?Q?urHJarAPct7KIx/5oVjEKzxjFRCZkwa6BW2WUCK1Z8ZUw1Tc8vBIFMhfhjip?=
 =?us-ascii?Q?8j11eu4/6tdSHS4vRfof4R8uUNJKa5g/sNtHVYEw83BSLW6rRA5zujqBMaLt?=
 =?us-ascii?Q?0ChJdd8wVstZwQw2mfBYmjR9awfaOFMjOKlflDMfdnpm6JzNroq9Xd/hMR9g?=
 =?us-ascii?Q?B86FA4D21PLCfnHfTKXbQO+01Fe/aQ22rFYYb6an1DvSG5xdSOrqRrgdyKta?=
 =?us-ascii?Q?KBOM73DFiQByeu1u7ECxKh+PfNvrpAQSVSkPZiQVWhHlytybiHWdkpLTXkfs?=
 =?us-ascii?Q?MwqdXrYvmBk6I2dFbG+WIL/oNlA6pGcT65nR00j8Z2OAG1RiMNPKz0tlqLko?=
 =?us-ascii?Q?2x5DFCsE/uaV3f/kWHaAyGEJBei9LoZ5wS14DwGKBG20IMIwUAwP6p9p01GZ?=
 =?us-ascii?Q?Sxk3sc6RhsPON/v704bDm0u0MLCJcQKBNfAGWG2LdJWE5JXd3qFZShJA07nO?=
 =?us-ascii?Q?/tDyrnnEY56Z1KGXfiJIhXZ2tikeHc+RF+Wie5IJknitvmKbg1DogdirfU2O?=
 =?us-ascii?Q?0dX7Cz1ocVN4hJ6SEynAKaYh4lFSWQsfiEEktuQuJM/UHoHKBpaiRGzGPD1V?=
 =?us-ascii?Q?l1nT/zJqn09TVf+b7K8hfITyYmTAiGgxy/hHwxPzetUbSe0MFi6Y+kxtO2ur?=
 =?us-ascii?Q?8meSKLPf6peZ9FzamQUJGAEqox/GTqmBEPr/DuoE3c+WLyap2+z/0zd2xoW4?=
 =?us-ascii?Q?VcJFbQiH2yg0bRCgKj+Hwu5zDS47AYGNVL1te11+Y2DFwB8AWaVSHxhEcugc?=
 =?us-ascii?Q?PuDGfwlYoFpBNlHlU+DLm+cLN9pkySEviNlqIRnM6/QijQsJDF65O9ndjeO6?=
 =?us-ascii?Q?WIT3f9FEIykCl9szHJkWDt0jxcFzbSRPg++elA8uZwVE37ceRMXNZjRpMdwF?=
 =?us-ascii?Q?Ygy+YkqNdncnakt7pf5IpiZty/06JuAt/4yWtdZmT3KXTgoYo8F4hlHf5P0X?=
 =?us-ascii?Q?+YYtmhlU+A6wGE6M7hBAYzbDOeA9Num2w5z7nQT/c4j4xOTnUl/r8FFY+Ry7?=
 =?us-ascii?Q?gA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <798FCB2D8A7A6443B0A4489412824DCA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b140f8c-3437-4930-10a8-08da9ca88675
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 14:41:25.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VZ3RWMBvfex0yZUTLJHihVC7fwUM97fzHPcwCXXNeejSWNzRzdnD9+xiThoJQrLeO9LhOR7KgKs1A913+cLBmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9625
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 03:33:49PM -0700, Stephen Hemminger wrote:
> There is no reason that words with long emotional history need to be used
> in network command.
>
> https://inclusivenaming.org/word-lists/
>
> https://inclusivenaming.org/word-lists/tier-1/
>
> I understand that you and others that live in different geographies may
> have different feelings about this. But the goal as a community to
> not use names and terms that may hinder new diverse people from
> being involved.

The Linux kernel community is centered around a technical goal rather
than political or emotional ones, and for this reason I don't think it's
appropriate to go here in many more details than this.

All I will say is that I have more things to do than time to do them,
and I'm not willing to voluntarily go even one step back about this and
change the UAPI names while the in-kernel data structures and the
documentation remain with the old names, because it's not going to stop
there, and I will never have time for this.

So until this becomes mandatory in some sort of official way, I'd like
to make use of the exception paragraph, which in my reading applies
perfectly to this situation, thank you.=
