Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B32356D290
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGKBcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiGKBcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:32:00 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020023.outbound.protection.outlook.com [52.101.61.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D701217042;
        Sun, 10 Jul 2022 18:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igBAO4AfOGcLiflxT1EIGsoRlOtq5oBswfI451Cl6bX4JVZSmrjDmoirbFkG8Zcvmv7n5ncm5p0f/9w6DrGuCTq6uyeCxWq/IWX4PHtP0iKkRlb3e265bCgB9/s36POhA82zlPboZ9lOqPq78/PLtAIHZqnL9TldMQpsRxWCMnGqyZ9qcf1i0KPvH5Dj95fVcpyuZBecd8yDScIg3WvHDqM5qPdUCCedMoPYKWDsAPNBdM8flsb6ISDdv1cwkvMQJ6c0x7Dpyx0p6ljidTA/OAbPNBbXxXge/jX3dZV/luy56tyTc2dXO/SwiJdfTjJLIs3yswLNgo8J6KabVLRN1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEyHmBfTCb1sTZhgNdmBxPopA2Asgle0ajr/uGlo/R4=;
 b=QyhbmZePrscMGHKxzM87IuTAvJzX/jMwx7d6zkq/yxIWjXkTWlqOPXvb99kHDid7VQnq22arzFS0MPKGpPJ7EtvdPZIwK+/mg4w8vBTwdapjUfZqOs9bNMn+SjDt7N/p8kvR+M6mYc3Y9AsFTfvGFakA3MjvyySv0thBfjOLymdgcFKulauyMz3Iir8MVuoQ8Fpf08e62Jo9bzk9pAquWiQmPoqigGklTYf/bvQy2KuzGVBsnfrvcTSkF8f3/tEv6NvzLLdsC8CZB4HMLhzTVRanfMcKCl/6IaBNzE7oBmVuLrhcB6zKj9mcyZ9SOsqfN76BCjqvfJgQgkEi4r4bjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEyHmBfTCb1sTZhgNdmBxPopA2Asgle0ajr/uGlo/R4=;
 b=cUZCxDr8SqduQ27MdD0hmXeqceEDMGqSpUCNSmqROg7XmqXP2FJdipSduu0BFL2JUj4JZvZUGzx2iUXNvUAYBs5LYkOmV7lr7auwe2JLBkxKJ29Pg+7RI0HPRbDsoJHMbnOfrtjVQ/XidkvZHquXfBXKy6RJ+ub2137sjdy573Q=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by MN0PR21MB3508.namprd21.prod.outlook.com
 (2603:10b6:208:3d3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.2; Mon, 11 Jul
 2022 01:31:57 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:31:57 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 08/12] net: mana: Record port number in netdev
Thread-Topic: [Patch v4 08/12] net: mana: Record port number in netdev
Thread-Index: AQHYgSXZgFZeGzZvSUSVSDNCEYcOwa12/BuQ
Date:   Mon, 11 Jul 2022 01:31:56 +0000
Message-ID: <SN6PR2101MB1327C18BB9EE8FCC090F15E6BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-9-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-9-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bd39efa9-e617-410e-8cd3-c56dc4a4d996;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-10T01:48:49Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd574e9e-0b77-4cd2-136c-08da62dd24b1
x-ms-traffictypediagnostic: MN0PR21MB3508:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h9aK6y2DzjTmcnx6XNiPjpCm58DpVjg3EyAZ0yjvMQ+8WP8SaCRI3t0NV7hgq0eO7/ZDajzXYo4E00RPIEiI+w0GXSuwpJ0jDBhTpjzREQLLHQxoC5xPymZSFUHxaz+FpRsjDtv0W8IR8p3qZ8jLWUdE9EsCjRQSvFvAa69IfdtusnC1Dhpr9qwkU8POmcFKnpaNJyQDJJEBdg39fb/F6o/A9FSvh3TnbEP8n9QdfGcCAqw8QOBb97JdKviNgZ56iXdSqyZQQySzknbl6+Sc67fJPup04WzXpSWrTh1tT46ANlBVNiOu9+4ROoZjkAm/SYd+o8NBhbPsGu1lL1PhgtJalgrjJvk1SnW3e+9NsYpNwc3m6vk68SjEtj5BnhHJ9bKmuiulRi0t2f3LT3lC/DjC5p4+QSFp85BMtoMZilWZMF+T+j8Tn8OsXswHBiY63V059Bieprysk22MCnCB0cUDh9YDzb9RxsymFAXDW9K9y4UkXtac507ON7lr3m35U1eNkFua4x/n4gCfvVW19Y4di5dj734u9CR4NWhHeK+rsxG8mHHxpVYHlPR0aFLew/wol7AEaOxKen4lLdZoxbl+NUFWHiIFMAm0lAGQoBzVoeXTXgmriUicqrgEPclRqXc4iYwQoP5v0QiVHmJODjijibJOw+WsgPcrrXB8kD5xF1nxKfUldtkfwr8mRsRqQ7W3pV5kCQ9oPWk18yn9p5SRemfM/fKJ1dKZELJyR4xax0mTyzaI0AYPC1LYcd4q3glOk4GEhwUZhaF1TUDUSmlq9cINGJNvjtAaUTwu2TSDH8fyLBH94XIbGHQUEorUy9xfLhablfygE2Gi9Wql7kP7WpsvPPZYZqM0auhjIvw/eGiidsgmiG69HQvdarPx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199009)(2906002)(6506007)(558084003)(55016003)(7696005)(41300700001)(33656002)(186003)(26005)(8990500004)(9686003)(71200400001)(66446008)(66476007)(66556008)(66946007)(64756008)(54906003)(316002)(110136005)(8676002)(38070700005)(10290500003)(86362001)(8936002)(6636002)(52536014)(4326008)(5660300002)(7416002)(478600001)(122000001)(38100700002)(921005)(82950400001)(76116006)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IDARfNMO208d3Z4dtSNeWtXHDQ1KvMTf/m5aqcf7nIGzWXkuG8oWrfmHfhk9?=
 =?us-ascii?Q?a0uKTZAa276EYd+dx/KVW03Fs51f0ER1xHPoY7hg6iOc/WfO2k/VZeh+L3lS?=
 =?us-ascii?Q?DSs3eIuOQ50+kk2Ii0qUM69Ib6HoYgBWSmOSQ6lCy/XPQgYrfS08XnCWdGkJ?=
 =?us-ascii?Q?MirU1Se7KvCv8ynVzSId+zNEgRedBCtdCX58vzN2MKDDelJpiwhGAMzC9FQD?=
 =?us-ascii?Q?4eCQd+TzNZziplzxjVW8DK2/VOvC+tp+go+QKKzCkw8gGX8fKZMbmJNec9T5?=
 =?us-ascii?Q?F63Biplv3R/SGqvmoCPhW/LfH+Vz6J15RNGb4WJ/DwuTLHmIe88WB0yB4RN6?=
 =?us-ascii?Q?9p9knU5Ika+DszEpJKgld5jvOT+QNW3ZBPp5QIq4isCj9PE95rz+JhoysO4D?=
 =?us-ascii?Q?+aB2S0AcEiTKBhNhsZVrcyKF2RcM11SPmmXmtCjyUcwuCNE02JwBhDdjhebN?=
 =?us-ascii?Q?wXERAI1al8tn8RKDGokgnmpjN9sEvte0j3GaLdseFU6grwC0uYbVl6cEYU/4?=
 =?us-ascii?Q?NMPpPpOCiQ4I/ErT+hWK4Js2zP66VDKJOChNmF58kppzNeJMsjZMIPAYCxSU?=
 =?us-ascii?Q?ifFX1GhIuNct53qTQV7VknfG5klr2J6q/ITGkqSEoFYAWe58nkS+iCMs5DGM?=
 =?us-ascii?Q?g+9UUT0YUQaGulkp9NAXDQo6cugsFx0LX6618c1Hs+uhflkLx7ax2C3+wpxr?=
 =?us-ascii?Q?V8SSEQNOJp9NBfSSL99TqsIFsOiu4iSXkqBhIITr0NAP7AgrXDliPMmFR0ud?=
 =?us-ascii?Q?2oW+zTlagauGRGzNVlL5urBud+CiEd0wIA2WbubawTYs6J92PVCAGSW6c2ng?=
 =?us-ascii?Q?7st82ngljQMByPJDldhR4uerpi63v9gXjZz+O8Eo11B/g4NiDUdomucZDfN9?=
 =?us-ascii?Q?eS2bvwNNab0Tsl0pQ0+Dh54AfxNmmbNtRHV22Q897XG/KK1qbPa8OVNmEOSc?=
 =?us-ascii?Q?/bQStXzXW+BfFHNqWszzSddcCRNmtb5A2zk42UvwoVfCfnoVvPjIfs9RkBkO?=
 =?us-ascii?Q?C3OWs168ffCWC33WZ2/O4ENQCWHPw0sJybkvw2zLgxOKAC6ipE/XXYPBdbQj?=
 =?us-ascii?Q?dnAyGwpjj49AtRIgobd2zsR3/RVvrKJCgvBux5WCFL7C0D2rZD5UtBwCmP3F?=
 =?us-ascii?Q?+bq0IER6yM9t/gMvuM6KpOY0NRr+OkB6bLrkDzlePpj+GbIsjJoI+uHImBSo?=
 =?us-ascii?Q?mIDwnxnX2WvGqC1Bi2mRRX7/jzIgG7BBYwqzm0irIh9tAoS/6h79BANSJ2ac?=
 =?us-ascii?Q?MkFxP2UdFlLPkdlFQNathpEMpxYpV0Q1P9bl4vGY2MZUELSb+6FtatuORoDk?=
 =?us-ascii?Q?R2TVzrlbnPOAsFxaxRD9Px9XHnOyFvvoHVEVVXY8VK+3KwJ1ddGmXe8vhJcG?=
 =?us-ascii?Q?A+5O5OlKyxwMLxw0mTrAhVA1y/cJsIniSTPGrVgBn9OTJfRbcVGYoa9KrFth?=
 =?us-ascii?Q?PFk4zkM0DM5xCKNUt9wnuTvvm7XG6kN8noUTpZ3SbHNfMSCem8xurv1Liixd?=
 =?us-ascii?Q?TMw67Y5mFcG1cID4oraT2I3qjnrzgs2PHnbT9mZo10/LDuFolXFT9chOnZBD?=
 =?us-ascii?Q?/5nWTxDY0D1gl0KYgdN+RiGKMs3rjX4/PHSzGSy/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd574e9e-0b77-4cd2-136c-08da62dd24b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:31:56.8912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hkQhAjpAf29uspazY8iR9AdmYTpkSv+m0aibOpiXDfeGwWEtwshUkDetEMnOfO+Vovns0Ndk7ZIK9I1CptHM/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3508
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
> ...
> The port number is useful for user-mode application to identify this
> net device based on port index. Set to the correct value in ndev.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>
