Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2953E5BEFBD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiITWHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiITWHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:07:09 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9D8786C8;
        Tue, 20 Sep 2022 15:07:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZ5pwuP8NttnhJ+n80QYy1BclgiGpwqGptUer56hHt/WbXef00IoZ9wleWZwHmjnd9c+4jY7PKmgVoRQoih0zrA9F+e8MrO5DC7zSTlBDAGEFS/IEX4Yh+L/UKaz+zTgFjsOjXYWBPOmuFS13J92fXanGtNNnQH4fSSukssaJ9kDmWeuVYX1uJdq3ArA791ACNb/qexb2vAoki3YyeaBJWwDchiNPRGrhG3g6qagiJnwOsDcGSkpdXaTeLmSSl9xHu7u/Rjfn5+qHdxI3y5eturU74FOGOA/+wcani3Z4WJ9O6MMBPmioRve7cdq1YuTi+PDe5caMs7MTkJlJnKrNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58fwbh+ncxWwlM140hKXJjpi+9EOlIH6TN+gQPFgf6I=;
 b=krPRSD/qaUA7jCVjkzNOivP1nQi01lTLxfupl0qiZYqK8AziCJBA4eSgueUaGnLrVFYdWpAR51kYhUaMwJRWen+wu/PVFqlsAxfAM4nXCMOzyokGZnT/76asTMTdIDbIcHUOH22lkEPoiBokwd7W1wSQLFPHcNJtEnuXgaPdcgWluz0czJtLUotqfWYjtBOZqAag5fbZw/fEp2OlY5q4G8HxpQvnHRB8n+6j5o+gVQKzBqJvnYRZ4Aj8lbsNs/j/yy4GK6YB+jSknN0uDdAlCd9XSdrEgNcpd7laQWNh69jHs202ifpYE6x3IU9AKIfD16UMsqvt0HU9iOM7Fr2mHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58fwbh+ncxWwlM140hKXJjpi+9EOlIH6TN+gQPFgf6I=;
 b=S5nW4KmW/L2z3K1+0RYNKk0xwAUFsShb53uThy0R3J/zhybDl7BCaHBIFBRpwuX0vGnXBGtcAvRd+o+IDt1c1Ezvtbvf8/Rhx7Md57Asx8G1fU233Dt8zG6x+yQGKop3yscvQKoAFJh1DeouoHdt0IX8cVkK717uBmp5oV3RPkQ=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3683.namprd21.prod.outlook.com (2603:10b6:8:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 22:07:06 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:07:06 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
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
Subject: RE: [Patch v5 08/12] net: mana: Move header files to a common
 location
Thread-Topic: [Patch v5 08/12] net: mana: Move header files to a common
 location
Thread-Index: AQHYvNF5q1KLYleqUUW5U5ePz1XrZK3pAOzg
Date:   Tue, 20 Sep 2022 22:07:05 +0000
Message-ID: <PH7PR21MB31164B87023A5DE22DEC760DCA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-9-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-9-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=86b2f2c9-465b-4a68-a855-7fbdd10c1495;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:06:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3683:EE_
x-ms-office365-filtering-correlation-id: 877b679c-6b83-49a0-b0c0-08da9b547480
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CyxkFqbRmsgSUOEW05dUPKHSJ+fSsXf1mTLMPp0erhr8aNb5qJI6KKF7buJj5dz44yv60lz3281Ectrw+ervMscaV2z/wCOIdkbh9LDhlucJghb28vzVPzajifa5OeKxcF4sKvwDSZDNvSDb4YDFOehSmOmPjkOplGQ5g5khzY8g0Ehwc/XvbVbOT23kcXtiPwKxUOwnYDLHXiljDz2m8YlET9TMQsrWBHq4H1g/UrauWjAfZpe9unO23ykhhcEyEQPZXk3EZeila2GcIfXip64mvyj7TEH391+gIFT0CWuuuGoFtQh3h/QbgWyCGtDw4xKXJffgwHsaY8k7bkpkKxRuNIwhrFlkBmZ4IRB+TgnhT5Fvsw+SZWLRRF0xM30uUM/tdC0m3tNlMJsCviQSuYmoY++33LUrk9NT4eM+oCUkkBYXA0ZwSA1TVayB7GNEJ3VsobbB9yof6QDWhidhzpdWzHzqYzmta0GKyo5XmdSfcWxTyr5tL2q0Gip9AdulFlhHoDfSSGhAc7pdIEga6vG+S/qNLOPBDqL1GoPQbvMwgQR2uA4cYPXXBcMiRSlTbdYkCou3g8Cqme+i0KqtNDlANsOLQl7OJIf/1sepvF9OkGuS/Ees3I9e16BAWGpVMDI9Z5t/ZbOa680BhmyePx+/6ZMpFqmLCqruw+fLFYn1ZVmRF0575EfuxQJHQon9k/X1P8RSjFSEkA2mo07vRPCmElxmFddPKOImdK6XXtJ0A3XRpNFLWHdSmt8FTg3kp+Uidldv02rP1xX7Z+TCNd64EPNg+TotOqz1DoLiyx/XVbnFqjknG2QZucGPlNGJJ7jVoEVshH+zgZpdrMoWUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(8990500004)(921005)(38070700005)(86362001)(122000001)(186003)(83380400001)(38100700002)(76116006)(82950400001)(82960400001)(6506007)(2906002)(7696005)(53546011)(9686003)(26005)(71200400001)(478600001)(54906003)(10290500003)(66946007)(6636002)(316002)(110136005)(66556008)(41300700001)(4326008)(66476007)(66446008)(64756008)(8676002)(5660300002)(52536014)(7416002)(4744005)(8936002)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XVvnd/JYXHXJe/5CBcD7D0C/3yjBriL8U0oaDglztMmbC1OHPJUV02a4ReQ9?=
 =?us-ascii?Q?DX2g6Ok7QmFUhzeNR9fbYyil5JWHpIBtmizubPZXiXr8Fl2d3MR/btKsCoP9?=
 =?us-ascii?Q?l8Yh0ByJpEnw7IBeuaVB7YVsJC8zzhRVMtTxVyIKmYOaOUOttcn/rriHA98Q?=
 =?us-ascii?Q?ZggpWwVfW3c6aKOpXMS44haMhW1X4bMVZHL8bjmAcKorUD419cKsFElmO3cf?=
 =?us-ascii?Q?kOlO3LYT3qxwRLisYUo5Bxx7tNRwTtiMzvi+rrdoJniCj2RpePnSfDxqa36w?=
 =?us-ascii?Q?49A8sd3JkJjHrszKIf+PwQ/rQTFvQL8oggcOKJIycSj6KHBY7FKsZt3exdhZ?=
 =?us-ascii?Q?NZXhmhfIDfgs/Vnn/Zy0epzneHds1fVKU6R9HFPRznRG72+UEIBsU+tK6C5l?=
 =?us-ascii?Q?efNEtMjcNqQHQOAiLk0XXqHVXCwHGYRWi6i/lBy98ckB61OTFWBbqhfkEd+h?=
 =?us-ascii?Q?vFXPKrmip2/FjdwiYdy8bWuUsJMiRcVEnmV+LEK16swiXfuKnv7Kveh9GdLe?=
 =?us-ascii?Q?MouCyQUIHmTCXu28nsUOtvuiuWOiuOPoeRmjfmxHjGEdCx/bEDGBR9+y6Vqj?=
 =?us-ascii?Q?T9Ry+feq+0zEn+SjgoeaX/M+8bpoDf1Bp14hTjGpv+w+xaPiMedBYj+CbJxY?=
 =?us-ascii?Q?u9FyRPjLWChJ3A/SYPzzeGpRcx5SFsJCURR3l51ymAgLYY+vvGoLjLm/Gwdb?=
 =?us-ascii?Q?elzuS+4rx1w2JtrbxjRYkfrYEp6FrowKbFeQp8OYlJU074VHMULyzzDrDsLL?=
 =?us-ascii?Q?QsFdLLnVGNCRVcMEa8iqY6MfA5yMasRzElYfFvQ05BJrBvZMhJtGsQVYy6oo?=
 =?us-ascii?Q?+VVquL39pMbazTdKw8VJNcJ4wL+EJguzunpgnvKvku+OtG6Wqt74JZ8FIBNV?=
 =?us-ascii?Q?FNLKtLq9IdV5T6YFXXR+RKaPcXSbN2W4dNQrwynuwJRQuvA9VlUuJD/ahBTY?=
 =?us-ascii?Q?KEBYAiXwu/5PTKgojZYbl0ebmKJdqEjyMnsY4fMuVVv1duubt7f55DSS1SmY?=
 =?us-ascii?Q?Y8G0sMrHrKLTY5FSSeyXW6u+t8g7vhl+4yhF91ZctC0Q+tPaVITHYRiNlEgs?=
 =?us-ascii?Q?QIRWqCkLx9NKHJhAgXNrV01liDpR3i2vthQdFlVFXsigsEVFWOlGISoVU5Ur?=
 =?us-ascii?Q?S/yk0xblTAV2wOoe4HVtDnzypLKg48YUvyrMhrtGVaeiPHJc/vaTZMbXTmj2?=
 =?us-ascii?Q?wBAwhu7DbkbR5b47v7A6GmBDnDuu1nr9i8/ZxUxO1UxG3ghotwvy8AdVI9hw?=
 =?us-ascii?Q?VbN1iRLaNjKmPj5V6dvrJtwQreuSqQlURdT5yo0yzm4oh3ayh0c20yl5p4qs?=
 =?us-ascii?Q?fR16SFVKBDOZe9rCB5ouY4wiUM2TuzdHWLI/UR4znuD9KvUpFRjSKaeVD8zA?=
 =?us-ascii?Q?nTsCcUfXc3bcMvu1OqrblaDlIkB1jpRjfowU772Dz47MHZm94/bRQiqBTQ2q?=
 =?us-ascii?Q?JJF7H+UAZjBKBrPmHIZOw3QXWP2tbSSrJZtUmuZKR1UsvcL/AYJk3uaIz+Uw?=
 =?us-ascii?Q?DwHWTnJbvz5u3FmFfMMoQFu+QrssttsLTUMlntMUJFNe4jfYpYuqGC/9Dvo5?=
 =?us-ascii?Q?BwQ5hsxjBr4ijHUEXENJ3SC+AIaOerydkIIwvCTs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 877b679c-6b83-49a0-b0c0-08da9b547480
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:07:06.0026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 67klc1BdL3cuPX0HuBqAFbifUrjIM+hA+SkHHXHWhcKZEKAqLHBXVVpd1uzOpHvPOEuTUr5JfrY5mZdMGjx39g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:34 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 08/12] net: mana: Move header files to a common locati=
on
>=20
> From: Long Li <longli@microsoft.com>
>=20
> In preparation to add MANA RDMA driver, move all the required header file=
s
> to a common location for use by both Ethernet and RDMA drivers.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
