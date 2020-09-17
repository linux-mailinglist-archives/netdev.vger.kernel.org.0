Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29B426DDC6
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgIQOPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:15:51 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5747 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbgIQN5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 09:57:54 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f636b030000>; Thu, 17 Sep 2020 06:56:19 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 06:57:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 06:57:48 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 13:57:47 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 13:57:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bd1ndm4FR1jhV0LcWwAtv4PfSsNru1u2uc6uKAOpZu0RKIjr7S92dsckSnuSLffxXWsVg6Aph8rnlyEk4UbYA57dpp/S5SsVk0qAT2xHVnAFlrEeaWMt5YkljwDGDFd7+pm/9GFjFsay4rXx05Pxfh2wCoAoUx8hkU9111jXSCo3syVxMCXA8/cFOUw2vEQYfupxb/ZTyCiuZQ9Q9VuX3dLQc5VjH6jklF7iJX3OEkUJxRyw3H5GxdBLYgStbVbYBnGnDa3U6q1o+DFz0SQ4SvcDs+Uo6H2IZDm3g+ePismQBN7d2x72zXQ4XPMbuv8Sb+lnCOAVoCLM7iY7Yrnt4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0L6sni8+BLz5nCb/03iL3ZLENYcCw9RjLoHbTg1V5Vw=;
 b=knzLf8IyPdISSjge68/uK3zyjcgjqQDvCquFOypHiaqTuFJkQriaFFenJKNSU2FmhKe53plbVGrC4gsQfoN924AHtgxbLhd6TVAwgVPbswC0fFu/ku0JZDneZ83Zwrmy5yf3XS7S1iefEk9WcCGyhyXjvJlTI5yRaVRL20rLbgiNLhFyX5ehxa3mm63RxfNef260szEspwsVc6CZ0V6zRKFGDv2+u+O7cdFeRNGM5eiw/PoHQLbjcg8KusTpupqeSKARTq0/kKlKfPwE7bJ2HjUm6Jjl/1NDHRfDZinjEJJgFtIKHaUuZCdvvEZziDZkpp3sxmrjPTL2L8xqIntD6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3112.namprd12.prod.outlook.com (2603:10b6:a03:ae::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Thu, 17 Sep
 2020 13:57:45 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Thu, 17 Sep 2020
 13:57:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     kernel test robot <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 5/8] netdevsim: Add support for add and delete of
 a PCI PF port
Thread-Topic: [PATCH net-next 5/8] netdevsim: Add support for add and delete
 of a PCI PF port
Thread-Index: AQHWjMsL8gKWg0I4YUi42AevKwUwg6lsrmMAgAAs5SA=
Date:   Thu, 17 Sep 2020 13:57:45 +0000
Message-ID: <BY5PR12MB4322321C2ADF35CB8A2B7E71DC3E0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-6-parav@nvidia.com>
 <202009171937.JRIyGgCc%lkp@intel.com>
In-Reply-To: <202009171937.JRIyGgCc%lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 122c51af-0860-439a-6516-08d85b11a76d
x-ms-traffictypediagnostic: BYAPR12MB3112:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3112815033D4C5DD460FF6BCDC3E0@BYAPR12MB3112.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2yFl2sqycvzoYWtEFRxZkQBVN2l4zgeIPT4OI381wrn5rwnxbzdqXqiXCeXdvodW4TrV2bvv6at6YXOxk/7evGutMXWsw8ORP6gvM/qFtGO5W85XiejfT0V8JPSC3ILgR/Is08YPt4n4mEeVeFtB1m9eUOwj1PToc4zJBllWnyiTKR6R4ixp0xjC5TE0Td4XwYdr/J4HU4YnyYYdK/qde6rK/msbmor1fsI0zjVIzuHVL1oCwZuXS5WufMyfPrusZHjqNvCSieAlmr1JCUHmYCA+UJBXjRIzl7ggqeqsA5dgdY/ZgVlpwmQ2URmo6WxmV8DbOv4W2hsP4YfGRwc3IkrJMxtsuxeYdAdvQboXUX+0kJ2avZsGn8RUpJ7SFWSG3pzLLa3nZIAdfiLaN1bfIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(71200400001)(54906003)(86362001)(55236004)(110136005)(26005)(6506007)(186003)(2906002)(8936002)(33656002)(66946007)(83380400001)(5660300002)(4744005)(76116006)(4326008)(66556008)(52536014)(66476007)(7696005)(966005)(64756008)(66446008)(316002)(8676002)(9686003)(55016002)(478600001)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DkXO+Y8O31T1rZ+ghoc2Ah7IvTOWO6a3GvmjUZnFGvxu6M+RWF41SaQV8P4Lp55qSAJN6vwdSnU610S16OSelxjajidQl2I2YcGaEA9rv/Nw4ZyeJapTrbKg1U/hImL3PDaQ8AIzkGiVPTFSGU+fYCDgVtIIhWZLf0GOTMYWmPWbp42E2agf8HyqrNwicQ7TRAtjsEY1zf9Ju5SfbmuFPuoQuoeAWfCL4MTdWHBC/Ps5F2TQmHYTn7zbJoI2NdVX4xi5kAxq2aUYeTt8/HLeq1AMbN3Sr2JoLZNL/VVm7EILGUlqzUa0XAOfjCeR7miEJYBNOB86/VuRbNxqwjTOJfsNNHMA4HkZ/xgoQ+TpyQYa5hr3/uuKENHRZxtCoKeYbMSIWrSAp8IZLgL58lPkYGuJ8QlpmUQZvxW+G2VNigkByqq8C5Nmk4QQMy7F5u/wwr0m12xQMV6rEiI5kCHyB8jijBsR5VFI5rGDHE3bPddK0wnEihd7/Kt2J2p7Q64U8tKNEIek6FBMHYj3p6P1ZFj7F9l7f7ZrKWt9WfwPSDpRnuwfrSicZOjJEOzUugtrzeuIELHxTP19zFkzyapp9k28mGyzSlPEig+AOkR+jt0JyqFgl6haP4fgmK2acVO5raGrqptRUo7nGDOuqZuCTA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 122c51af-0860-439a-6516-08d85b11a76d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 13:57:45.2708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iWf7GDBPScP//34smqL3K0UHRe2Gg4HnFAiKfXrSMIUDlssrlISP8Y9BsK0YTFeWNMAQtAaxpIeLb9pPxn7idQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3112
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600350979; bh=0L6sni8+BLz5nCb/03iL3ZLENYcCw9RjLoHbTg1V5Vw=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=PXPEGBUsliriYgv/BzsI8wWWiH0b953Yi1BbylvfXnpYqiq1aF6QT0iELI2V6X15N
         /kSpVXnQSrmE6k9ZQM6woUnIk9julIe/xukemUYJ3Xil7nfP60Ucr99yxJXe5stZHI
         1GqcBkLCXOS/NLgrVo1J/bDtEk37rTlPsIg2OrwNTCd6O8STDblc4f64PVa34nNDPr
         rO9thet2wNjnEes2NPr04ZumOkTHlHP5CVJftFvSz+xPlxPhsmm4QQ7fhc99yjDNAy
         xr9H/8is8Nh+rKfFq1gPtDP+AnmAxf1faWQCgMjND0XU0Kak/eDn1g1qLFfP1whRId
         pRutzopSn6nyg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: kernel test robot <lkp@intel.com>
> Sent: Thursday, September 17, 2020 4:46 PM
>=20
> Hi Parav,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on net-next/master]
>=20
> url:    https://github.com/0day-ci/linux/commits/Parav-Pandit/devlink-Add=
-
> SF-add-delete-devlink-ops/20200917-162417
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.gi=
t
> b948577b984a01d24d401d2264efbccc7f0146c1
> config: i386-randconfig-c003-20200917 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
>=20
> coccinelle warnings: (new ones prefixed by >>)
>=20
> >> drivers/net/netdevsim/port_function.c:122:2-3: Unneeded semicolon
>    drivers/net/netdevsim/port_function.c:140:2-3: Unneeded semicolon
>=20
> Please review and possibly fold the followup patch.
>=20

Sending v2 containing the fix.
Thanks.
