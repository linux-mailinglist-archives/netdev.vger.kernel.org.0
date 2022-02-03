Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CC14A8BB8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352994AbiBCSf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:35:58 -0500
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:30630
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231788AbiBCSf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 13:35:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hkzwol04BccB06LbT+Rvf4exnbf7obuL1mCy3vIpDACiJlP5Ng3J5vXLL4ABg3PwBgPpQeyVpgytORglchZTxKLvpN3qPCp6PIcnq/OkWRa9I1NhraPLcrDL4wxEz9afnc0HCUkorgwsbmjPBc2J2g2oAVaWq3UZKoS/v0ScKzgH7w+8hvzrONeTANpc19TMYbJlNRC5SJwKG+akNjqD3SL6oFlvLFLMel9auPNmLflH0h5A9jiUegM9nNnCoiy33iJUqCEu95V5GQI0I5DuFAwkmKsdp02wqpygQZJHTgVPhZHUaG1MHzgweurod45Pr/rTZGsjZnBz1aDbuM+sxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYupSOi5tLvm2YRCGLNw+zq+NaktIRUOdvu8up1lSRw=;
 b=IMtp0aYqAlBOp+0Aan/uwH9EocPymFGIG6piTCOQ/5tSUEKbJXxG6KQLf/Q2UqVmu7d2Iij0EgcgzpB+izugio23XLFD2UX6AXHv70uGmUh65xx/D6XigyVSZDApmrDYaKOA8ZBoKGFRoJHnJfLvHDZ3wQpx1ofJ8uZCeehQ6rQ/fd70Bn+iL7oclQTZTCXcCLLaLLD4vMgY4OHvZIWgbhiQHTGYIM/4J2zgcpou9j8ETv7KjKcicoh1KGA5JWxgPYoFUNg84XK01ugH7z+YaIZEllA/CeeFV3IJ9sLjjHHbX85h/fbjnAnb5RTt4Tdfdmhs8a2dQndV5t/O8nmd3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYupSOi5tLvm2YRCGLNw+zq+NaktIRUOdvu8up1lSRw=;
 b=qIJOvgpUZjkYTCAyT86KrYm3ESCIb5mkHuWRWJvEzzsvOwY8clNx0JFjRNeAaCesaiCn8FnDfyrlcama9LSeo6RdHQM7iniDmUU5isbhWskxGmA3Jwli0znp6egJ8o+rBriOl/n2YxBxO5EzngwI/jPtyieBvk7gcXPSMm5ix+SQqnGocgLb2FWwI+ImXoYkIh0VCaq4+2BFJJLCZ7ZLBcalsOXQIYzzGOkMNxAm0ly3FEqeMvpkRk4qPvfTAXbBeB7TpWjMvG3mooH/5qpqztdsGH4VSJcZWd0MrM/V7lAG60Yczdg7/PnA2c04T+0riEG8p8j4YeUvHajyjy+SHQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BYAPR12MB2920.namprd12.prod.outlook.com (2603:10b6:a03:139::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Thu, 3 Feb
 2022 18:35:54 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d441:b84b:1d5:4074]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::d441:b84b:1d5:4074%5]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 18:35:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHCAAaWsgIAAAHcggAFuTYCAAD3DAIAFfHeAgABLrwCAABzJgIAAWrPAgAE+YoCAFykAAA==
Date:   Thu, 3 Feb 2022 18:35:54 +0000
Message-ID: <PH0PR12MB5481901FE559D9911BCE9548DC289@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120004039.qriwo4vrvizz7qry@sx1>
In-Reply-To: <20220120004039.qriwo4vrvizz7qry@sx1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0aa473a-db00-4e5e-1e9d-08d9e744034b
x-ms-traffictypediagnostic: BYAPR12MB2920:EE_
x-microsoft-antispam-prvs: <BYAPR12MB2920208E60089AAD6D6E9861DC289@BYAPR12MB2920.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ByuEbBeTGG8h9NHG3V04IYDQgiTkE3NLY3mkZgANNPPt+opMui0XnIwVObAbNgPTXuytCTLRncELoNXzRdoj5FCOlwNJ4H0dvumPQExkZ1KfOkA4UusY6v9FgIqzqjT97EdYC8reCIFqd3vFIw9+bV8/jbhVq5VukhjDe8n6KBmSoiOhvEsMGlxk8LPKb0jKFZupI7rsA+vEuZxkTNJFM/vxnKRe0rjRhKCxSqeTvo7jw6343zzZs4E0Blgx2QKEuYK7P2E7nreyTbkhDU0Z/L8F9ds62jinIfE30/l7YjrnkBSiEx13VBqVK6ltD+idl1nfoVe9EacqxOrdlkHjP3cAx+lTjcB6GFJCsX1NT+h62VbZqFwk0ObY8ExrTRcBogPxkE3SsQkGSFypQouTNemZ0uTyRUgrwhg1Zd0JkAiZ805FoPeEZ2MTu35EzVADl2lPl/+duFNGD6anZ1XlUKt3YOFyzirNC05w4W9HO62DFcTyqUJcpKL20YE6/JGy1g+/FeSQ6MkB4hvGLTwiZjBlhmxIwhGsduObu7KPpaAzd4jWX4aq1IoYoSShfyWhMeSU/wdtukkDF/2Ltzlb8hcp1XCHGf0G7LanyYdIkdSfMECrOSUzUJkGPKSEoWaO5Xp1efwnJ47elmiXdKdDG87CShBv9pS8NHL3Oi8qxolcqVk07vbcjmyIB4y0/DvDJY+udX935V3nxeWoolg03g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(316002)(66556008)(66946007)(66446008)(38100700002)(110136005)(33656002)(52536014)(508600001)(66476007)(86362001)(55016003)(122000001)(8936002)(186003)(64756008)(5660300002)(26005)(55236004)(71200400001)(9686003)(4326008)(76116006)(8676002)(7696005)(38070700005)(107886003)(83380400001)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kG9civZReMsoW9Tj2uwOJtcWRokAzcv43wvPcqKeOgJVKvsgeqQg5IIyQV/L?=
 =?us-ascii?Q?KK4DjfYmJAnVztrFoQFFGHCmM74EwkDn6qCrbGMAdMhl/Cby2rhzQ4LVfs1T?=
 =?us-ascii?Q?7zlmz1DGCi91kz8cDmMR21Zu2dVGX+aRIo2o/NFY78OYiNIDqMfXioiXoKqF?=
 =?us-ascii?Q?NGapZPrWZyJgUGnXXTm03E63hG4Ppvgxvl3wnr7abQMAaihUjUYu01pJ31YR?=
 =?us-ascii?Q?vJ/RUtIHbfbdYN28DYTJIwInLtmMv4g9RJZiC3gIIGU12klX+vnST9nm81Tb?=
 =?us-ascii?Q?XFDAi98j+NW9GQvFmdSmE+Ow2cuwCPpjU3T09RTJmXpu45ulsKsHdEmcguvg?=
 =?us-ascii?Q?JUzxuo1LiKzqQrZS64d6G4bgZW+jPcZBWz6URiQKoYTykJLisZOqxcz4P2yQ?=
 =?us-ascii?Q?rBylIZmGTakPdJndeEa8tJ7oyqh+569I+vnNFUcMZCQE61T/qCWLObwS2FNL?=
 =?us-ascii?Q?f37jQwKN3ppTcORrqgSLdkxFPSvlf9bd+ac6qVMRhcVi85dx68pH4xh8Fs3D?=
 =?us-ascii?Q?52T3YDMARaZngzCz2WPCPuoKec45PyG5ywojWQt4wRwDDsXBYJd76p/hRVFp?=
 =?us-ascii?Q?YB/0WRCwryAc4Yz5WLYAQxVDlzJM4xRsw/at+RbIn6N9I7kYgRh7CY4TfCg5?=
 =?us-ascii?Q?/F5TFCvySMhDY8QoV/xs+jtDFjtz9jMuCU8Oh+CNx/i5NY4jbgr8SvziPipn?=
 =?us-ascii?Q?xwepfYdWLDWsYmjESuUHVW27OF3jl6KkWIHpYZsTnkw3x/IHegoFwUNNC88h?=
 =?us-ascii?Q?UCcH6pa52vowV9MxRQcBlcVWlOyFokf7GZ1FFWBZDApfRmAy9dUwgoo/LQ65?=
 =?us-ascii?Q?7emF3PV6eCgeJfXG2J7wkpE+WZkzjN3upbJWACwbk4Kz7HQtRc9ZDAO0BZ9o?=
 =?us-ascii?Q?NFxz3YHdqb8C9Mv+ePpRku2thmtIg4ad4nFMSZdViyIU0iiaXdqJYHBKz8QQ?=
 =?us-ascii?Q?mlp7SRP0cTXrymsHhi/q8T+7saBqu6owxTYC0t/FGkOeQOJlwrsyALtEqI81?=
 =?us-ascii?Q?c95OfDuevI2aMx7oOaVB9N9gJAY3Mv+iXJBCBm5ys4N3oyBMQ3R4bvrBzndf?=
 =?us-ascii?Q?9D2CLenjQ24X4N5RNhiYdqUSZCKxIZG6oaDQratYDLfFO14Ae9JQq9fxtOzJ?=
 =?us-ascii?Q?gmqpnW5ggRWtEFcJvmdqJB4ahqciCXoCq7n3HuESm0WRXzCF5LrW1QFZqKfr?=
 =?us-ascii?Q?Kvk4/ltza4zBSn1wBpDMJnbDOpt8M09zNgxMR37HZiuuFzMkGZWVYs3n5Y08?=
 =?us-ascii?Q?MGnKRZfNKrf05j4Rnhci5W7BOGDCEf16B4MWWxJWEqxdb7Vf6g0tEUykxzVG?=
 =?us-ascii?Q?vgziTI8RXbuv853/egyLphGlSbePXvVIqkJZqtvx40eZv3beG0dxRt/A7C10?=
 =?us-ascii?Q?MgO5bEspfsUlE1WeOZRDqRI0srzNJ5HrwgApru+E+W2DakrZMvzFzhTmSoK/?=
 =?us-ascii?Q?oIEQqVtsydsu6PtBz26rVSdx38mtk0QZEUPq7OKTuPDrRzUvjiawLemsEM6Y?=
 =?us-ascii?Q?KCYWw63QL8Sg/zeeGHUaJTDlYriD+tdrphp1r/TANDH+fcw2nCYCtb3g0Ont?=
 =?us-ascii?Q?xZInuIU+lsUYcwroKxKHZx5oAjV6yvK6LCOIKvHbLutncz6aSe/48mE1ygHM?=
 =?us-ascii?Q?30f7HkJ5eyOiDl4oruYzqro=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0aa473a-db00-4e5e-1e9d-08d9e744034b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 18:35:54.6964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hrHmHvYPC1cf4svS7D1Qfah0pDjBqcHLBjgWW8OZf+5HQQpK82Wd0S8ATuUCCd2AFdzh9Hz3CRg2/3GgufWG+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2920
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Saeed,

> From: Saeed Mahameed <saeedm@nvidia.com>
> Sent: Thursday, January 20, 2022 6:11 AM

> >And _right_ amount of X bytes specific for sw_steering was not very clea=
r.
> >Hence the on/off resource knob looked more doable and abtract.
> >
> >I do agree you and Saeed that instead of port function param, port funct=
ion
> resource is more suitable here even though its bool.
> >
>=20
> I believe flexibility can be achieved with some FW message? Parav can you
> investigate ? To be clear here the knob must be specific to sw_steering
> exposed as memory resource.
>
I investigated this further with hw and fw teams.
The memory resource allocator doesn't understand the resource type for page=
 allocation.
And even if somehow it is extended, when the pages are freed, they are retu=
rned to the common pool cache instead of returning immediately to the drive=
r. We will miss the efficiency gained with the caching and reusing these pa=
ges for other functions and for other resource types too.
This cache efficiency is far more important for speed of resource allocatio=
n.

And additionally, it is after all boolean feature to enable/disable a funct=
ionality.
So I suggest, how about we do something like below?
It is similar to ethtool -k option, but applicable at the HV PF side to ena=
ble/disable a feature for the functions.

$ devlink port function feature set ptp/ipsec/tlsoffload on/off
$ devlink port function feature set device_specific_feature1 on/off

$ devlink port show
pci/0000:06:00.0/1: type eth netdev eth0 flavour pcivf pfnum 0 vfnum 0
  function:
    hw_addr 00:00:00:00:00:00
    feature:
      tlsoffload <on/off>
      ipsec <on/off>
      ptp <on/off>
      device_specific_feature1 <on/off>

This enables having well defined features per function and odd device speci=
fic feature.
It also doesn't overload the device on doing accounting pages for boolean f=
unctionality.
Does it look reasonable?
