Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD9D4AC26E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345370AbiBGPFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383583AbiBGOpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:45:11 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FADC0401C6
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:45:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kit2+7w+y52dOeyOgpL4JzRA4Nx3rS80VCLzXsSn92P21NDKzo045iWESbnw6y0EFWdjVpuBu+uXgpw2taHb0nvrI1KkBwHRRjE2b7nuG/XDJSi3Fce6tWBoEhaROdhhsfAAg5zPB7qdzxSVyV9ON9036JxFY7yK4C28YgFBDQR5hLvtjWx7vyxK+7MXeNP/pJ+0t5WNo86xgTn8HliEz0do4vZvCnPS2Imw2eg4iEym9GZjoCMcblwRZX8AJCTIm7BdIlW4VcyJPHuvrJLHDV6jQ6LxE8tiUa/meGgyQBHJAfkM+uPSnWPzfOpaADCY1ZqdewOUdWTm0/A6tS8sHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8iDATVyzTZ+6C44LlqWBzZNcbCJ9d205Z8TZxLOhr0=;
 b=n6PgvxU0kj6q5O02b9yo1JdYT6UDLW+CcnNjcuy5xSf/HL94ZKEszmYaRG46KY4iCsZWUG/5HLHYCIvJrjNLXK0Vm6asMzn1yy+mz73aYdlo2/TaNpwyoS27AK+TvzSli9CyHB9UsuAXSK4vlkXnTCQaerLAoG0UxR/1qO6CqusCbPhYt9keHXvsBhI+QCgDitveJq4//BXVc0GUg/Z0zOEOUpuJh6/djV0o/yGTt720KLrPhxAIV8PLeyt5Jq3z83pOHQfoyvFyYT+5kmXSym3uE/LVji/w6zp45wa2gvWh9lq+hvByhGfEW+vs6a8O3gBBn8oAe1otrWB8P7JTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8iDATVyzTZ+6C44LlqWBzZNcbCJ9d205Z8TZxLOhr0=;
 b=PGek5iPuccNLC5hsfSxx5qPzSttOqWxgBmIUIy+D5yxpejbQ4htooKweNkBEOelPoA66VxfeeAxzoBoKy/tMKs7UWSowS5JE1+2jIuWdxaBPnxvIjEmTcWXRMZYpxi5wIjXQ92kp+ynQvVundKlOq2ZV5tkqhNEJ6G3ji7UmGUJ63/smVByarB5u81m8z1wfXRjM343bpyUFtSz19wwtluDZ4bIWi4i0rhtwqSTCsaOdb4phyj64mA1EJIzzXYZThiTicocvRm3P4ezFk+k4tgVluyy066KiSUaW0a64qILrieh/8c9Hlb2t/3qUxblUb5uAUNT9ijzox6dFe08khw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 14:45:09 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d441:b84b:1d5:4074]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d441:b84b:1d5:4074%5]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 14:45:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHCAAaWsgIAAAHcggAFuTYCAAD3DAIAFfHeAgABLrwCAABzJgIAAWrPAgAE+YoCAFykAAIAAD3gAgAX9ApA=
Date:   Mon, 7 Feb 2022 14:45:08 +0000
Message-ID: <PH0PR12MB5481385A3F7D9A3BFC91B1BCDC2C9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120004039.qriwo4vrvizz7qry@sx1>
 <PH0PR12MB5481901FE559D9911BCE9548DC289@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220203191644.focn4z5nmcjba4ri@sx1>
In-Reply-To: <20220203191644.focn4z5nmcjba4ri@sx1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cc896f2-eba8-4b9c-7ba4-08d9ea487038
x-ms-traffictypediagnostic: SA0PR12MB4430:EE_
x-microsoft-antispam-prvs: <SA0PR12MB44303A181D3DDD3290D40ECCDC2C9@SA0PR12MB4430.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JP3152ufcvZDe90Xm0EIcbkWJtmxu/Ve2JSDg2hrO3Pmw2B0joEhosdRhnJ9wWulykLDtb+tbOs9Nuru6nmFmLWu2YNvHWSXZKnRD5mCRGNvR6JsbIXKVs7oNqaUShAhK6QKTB/d92robaOvxa4k/Tr9Rv1cTvMW9ifnxCJupjXeDvJSlJuzPHbJfAmhhOPXnhiMPNmohecjRgX+WtKeACTiej6GTi9JF0r/qHdFRTlpKpl1VjAVQ1ntlTnAWY/ppW3KlNIYxNFY4jKcxJRnZFF0e8o9GpS4a6KJpMXBOE6XQ6nN9gGeazwNV3FfqLkulf0wXv+U1vqN3Ly6SP95SusX5zgO6iFMpDP6JpWIaMzXzzS3rf+GKRjATBbXIdBZBfDl2zX72m9VyH2i8k5ExrYKQNrILsLnhs26ehCtKEz7UG/RD6jlBLZnK70DV/2crm5icuFcUsvMkFQ8RARxpQyUkFGDi49xoLLoasa3XzrnSxyXXVBtUcgGD280tPDm8+QH8wKMhoqMZOAo8tHk74pJ7jl840iDVXg5tXlucljZ7jWblJpRoYBDczB35pms3xQ6RA6MoXuV6KQSJSusG3IlZw70Us1FV5BlG1YcZRimaGMXpRllkHBlB0fPVeHB5/3HddOLOiKMkBmJC0iocH3aDheCdFpbz4D3CcXYujH2k6uEyXGLNQ9nqpAfrJw7jTQFQXWtj2kumoyloZYFUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6862004)(316002)(6636002)(33656002)(54906003)(76116006)(186003)(66946007)(8936002)(64756008)(4326008)(55016003)(66446008)(66476007)(66556008)(8676002)(508600001)(86362001)(6506007)(7696005)(55236004)(71200400001)(9686003)(107886003)(2906002)(5660300002)(52536014)(122000001)(83380400001)(38070700005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SxIOuwVcbgLthLwl2y31a1Nur1JLrHPayxXG6dwSldU0GIoQHU3Rpu7pYj9C?=
 =?us-ascii?Q?/aF9XQuoJQJJPTCQjW3F11aS26Nc+e/RkMJ7sxMHyyH+AzjwnmCAsZVEJ4sT?=
 =?us-ascii?Q?78ai33nN2QozYIcALa00ig2h7rEr3lrloDNOsK69xqsXA/xEdj5K8qAg4qWW?=
 =?us-ascii?Q?jrs0eYrP0EoTF1D2MIve7qVdrph0K7EnoHxtJTYAoa8AsidgNl44kK80LGe9?=
 =?us-ascii?Q?VUxGVkra7SPLakSE4HOcP8Ub03b9jPS/6MGi3Nay6DXs/mePhp4R4sjit/3l?=
 =?us-ascii?Q?LjFJC7yzVXwCMzj+B4OyKyx488xt0HSEfnKfa2g4unzIjpwlPD9cRvuIwV3E?=
 =?us-ascii?Q?LUIG6tYBO+gOlUkTR8F6AwB/S18HWWcBupw8maIeF7WvikipCia/w19fs2Ml?=
 =?us-ascii?Q?ifubuWHLLaC4+8JTd58t6+RWynchatV2M7g4fRkGigENf9Kvlig3QyIMGHHW?=
 =?us-ascii?Q?NZ/UBFPDA5pRYj6h0dv2Hb3WjX2KZNKcUZmN/pX+B6b5Tc3e8hEJAvGGHBUf?=
 =?us-ascii?Q?AH5n3J+9GDgihA5YvjA+Dchp3CGz9EnxSqrUTscNuMGRb7DeXerFZB4q5Yfm?=
 =?us-ascii?Q?BeSBaR5varfHskDUdFaocsWWDt/QgRdJ7IBVK1J1d6PE5LGx+Pk8sK54rC60?=
 =?us-ascii?Q?Vva1v57Tqlupbe+g/0bRLdV93ZLQPJLgZujvBByAru6YTKdgi4xsVjlXuntC?=
 =?us-ascii?Q?XZVVHqX8hm6N5iblgMtOTbPqgOyhZNIqWLDgjB1U6jOhB9OsQQMJWERNLIlf?=
 =?us-ascii?Q?sxstP4l/8JK8gitE0aM2++hIH3VYQxn6qGc9lB2Keefez6Rpvt4Hg77uCc35?=
 =?us-ascii?Q?FgkCSlLpfhR6FJTbwHRq1TlYUXsH5iVMK96JDqce8OYvZpnhjaJ6fShekXCq?=
 =?us-ascii?Q?JoaNINVuHfsPnmbZaX717rgA8BIirJrnPFQ/VEKTC9DHMpULDNYIexlx1ers?=
 =?us-ascii?Q?aQl+urLbd8q2rnQv4nwb7zsBiyDwF1d7oe3iejL4YiTPZfOcS3RO24AkA6Ua?=
 =?us-ascii?Q?h6pzXjVMwZd9WH9NYwgOJ2vcQ+q4otaJwN+kCf0amnlUa2tK7z7/E+p98+xW?=
 =?us-ascii?Q?B8AqFlo5qPtNP6aqgg2oVRPZvrrI3oc3hm2Rwjt65MiLMkEAtAJ29GtuHr9C?=
 =?us-ascii?Q?BobXUo39VmZ9+Zl3xIsL5jRXN3CH4UripqYbXv9AAj+2Vue3HGStwfb0/s1m?=
 =?us-ascii?Q?p2vHcv50d7KTEjnm+n/p7rGBA9Yb2YaeAXatTx+cMaJUr7QIxcJTzHBfOhKY?=
 =?us-ascii?Q?TD3r2yYk5nTLQs+TGVbiYC4Ogz1U4SlNwqOrn9WhWaQv8sQIcE4BglIavMSI?=
 =?us-ascii?Q?/Glp4bsI6VPwrzCn+C12USdJpFaBSF1QwOn40dDD5HU54rd8+tBtrp22IG7U?=
 =?us-ascii?Q?IuVAXlEoMcCEQDy4lKzyklbxcYbK7vKEFI3+qBmaB7UPhzvxeBTpHkF2zns1?=
 =?us-ascii?Q?/FMj/HmVSIxve5VzAiBP7TqhZrb/e8Vjic+62578Jrsbm6IOiJo983vDmGJy?=
 =?us-ascii?Q?clT9UY2Ey37YV6KMN2cdKXzbdzkcqPj7i5k+7okHPJDcHPeLPoEzuKHlQrOY?=
 =?us-ascii?Q?9EyhZ8KFgWmukXWPY/Pc1X+/FAYU8SRk8zBZElXqtApJtNZu9cRzfeCcNlKp?=
 =?us-ascii?Q?LDK3c8zHGauZhqZ4PtjaysE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc896f2-eba8-4b9c-7ba4-08d9ea487038
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2022 14:45:08.9212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WPCl0FttQSgkpI1hBUqPnteQ7zeDrd9pS3vBzHw8ixVl8YTI+CvAR3i+el/Cs8sMvrmFXDS35IBhakKBjHfCgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Saeed Mahameed <saeedm@nvidia.com>
> Sent: Friday, February 4, 2022 12:47 AM
>=20
> On 03 Feb 18:35, Parav Pandit wrote:
> >Hi Jakub, Saeed,
> >
> >> From: Saeed Mahameed <saeedm@nvidia.com>
> >> Sent: Thursday, January 20, 2022 6:11 AM
> >
> >> >And _right_ amount of X bytes specific for sw_steering was not very c=
lear.
> >> >Hence the on/off resource knob looked more doable and abtract.
> >> >
> >> >I do agree you and Saeed that instead of port function param, port
> >> >function
> >> resource is more suitable here even though its bool.
> >> >
> >>
> >> I believe flexibility can be achieved with some FW message? Parav can
> >> you investigate ? To be clear here the knob must be specific to
> >> sw_steering exposed as memory resource.
> >>
> >I investigated this further with hw and fw teams.
> >The memory resource allocator doesn't understand the resource type for p=
age
> allocation.
> >And even if somehow it is extended, when the pages are freed, they are
> returned to the common pool cache instead of returning immediately to the
> driver. We will miss the efficiency gained with the caching and reusing t=
hese
> pages for other functions and for other resource types too.
> >This cache efficiency is far more important for speed of resource alloca=
tion.
> >
> >And additionally, it is after all boolean feature to enable/disable a
> functionality.
> >So I suggest, how about we do something like below?
> >It is similar to ethtool -k option, but applicable at the HV PF side to
> enable/disable a feature for the functions.
> >
> >$ devlink port function feature set ptp/ipsec/tlsoffload on/off $
> >devlink port function feature set device_specific_feature1 on/off
> >
> >$ devlink port show
> >pci/0000:06:00.0/1: type eth netdev eth0 flavour pcivf pfnum 0 vfnum 0
> >  function:
> >    hw_addr 00:00:00:00:00:00
> >    feature:
> >      tlsoffload <on/off>
> >      ipsec <on/off>
> >      ptp <on/off>
> >      device_specific_feature1 <on/off>
> >
>=20
> Given the HW limitation of differentiating between memory allocated for
> different resources, and after a second though about the fact that most o=
f
> ConnectX resources are mapped to ICM memory which is managed by FW,
> although it would've been very useful to manager resources this way, such
> architecture is very specific to ConnectX and might not suite other vendo=
rs, so
> explicit API as the above sounds like a better compromise, but I would pu=
t
> device_specific_feature(s) into a separate category/list
>=20
> basically you are looking for:
>=20
> 1) ethtool -k equivalent for devlink
> 2) ethtool --show-priv-flags equivalent for devlink
>=20
> I think that's reasonable.
>=20

Right. I was thinking to put under single "feature" bucket like above.
Shall we proceed with this UAPI?

> >This enables having well defined features per function and odd device sp=
ecific
> feature.
> >It also doesn't overload the device on doing accounting pages for boolea=
n
> functionality.
> >Does it look reasonable?
