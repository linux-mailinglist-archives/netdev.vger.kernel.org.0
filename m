Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C032B9000
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgKSKSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 05:18:07 -0500
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:30455
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726274AbgKSKSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 05:18:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXXZrcE8Hmy+kQ+qC3jBw6e+BTrQR5wr+olUoVqtMzbcou2fEKPMe9HSGXOaRC+ipLyXlOvUgWFXLqlVIS/icdfrj4TCD6zm3atOkRRSyFE5Cwu8MuhiEmyGLV/AfWKqoHMJqDsHwLUDTMqxkywWJ9JpBBCUHE9nC+7ecbGC4/VkEJw/qhGoRX+vtE9x7C3zoci7OJhReZFaCOrpugzUopKseGp1X75w2dLe5VCp1jNCbq+HKdE6kjK2VpmaBaoqCNtMCv0tG/aUiBr45kcQGj/qdgrmV6rP1cL5a2p4eK1huq7IjocsGKk/l/tbfroRBmrUJRQQ/mDbZ/9+KOi1OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t42NQBiFHmZdyMtYZze/hsDCZH0pvPH8sh9nSwNaLtk=;
 b=D4vRXCx00DRMFlN/u8ltg0ylEPUaAveFf0ghOZ3XMMCMOCIsiRK/pNB1CYsT6i3sSVwC3jpZ6txqVTFQOdJq3GQl2u/bE8z9iYGgbeE6KYslwhdjUEhxfvRHisZZ/wGwbJErBNHDQHZrSij+d+FiLg8zhm2zkjDkvOuVMTrHNRz1W0gj4uz9SSxzw6+UyneVi0xT09EDFOPIdcANG+L2EzD6Wg9v4rEem+W5JxsuWsjzo2SKsMbINq2b8+WbFrAcumiailKTszvkuiMqE6K+buz9bY21IkqhJzKuhHHUThY0X+IGnuEgkcbRTlhTyHQoQJDMUGJBryREgKR7v5xz5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t42NQBiFHmZdyMtYZze/hsDCZH0pvPH8sh9nSwNaLtk=;
 b=rrIWJA9g6zA5fcKlgG1v9/tCNgeQn/AAYqDQkiz5e26dQvooueuHxCSQIHwTXP0MuvMARd2sJJF+FylNe9GoycgJQA5r4owk1NtgRDeExRVX8SV6vDd3O6dLNpFDHb1feRLwxXGriE3xuNRdfNAAqPVgN4uvs7hcqAWqaHYYDTw=
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB7PR04MB4540.eurprd04.prod.outlook.com (2603:10a6:5:3b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 10:18:00 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 10:18:00 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 0/2] enetc: Clean endianness warnings up
Thread-Topic: [PATCH net-next 0/2] enetc: Clean endianness warnings up
Thread-Index: AQHWvQ5OmTX8CJ9Zn0WweQRJtgreUKnOLTAAgAAAc4CAARJPEA==
Date:   Thu, 19 Nov 2020 10:18:00 +0000
Message-ID: <DB8PR04MB6764480610C5FC6311BB03BF96E00@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <20201117182004.27389-1-claudiu.manoil@nxp.com>
        <20201118095258.4f129839@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201118095435.633a6e2e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118095435.633a6e2e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 79f5719e-6d6b-49db-2652-08d88c7464a5
x-ms-traffictypediagnostic: DB7PR04MB4540:
x-microsoft-antispam-prvs: <DB7PR04MB4540E865283B70472FC0DB8096E00@DB7PR04MB4540.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q0GTGByUY2CR2ww7OkYug4iRGjWKhlmlo67DFXC/YHTB8to0nhHeUiOPiV6oFNq6S6CKa7uWmw4w3VOSW6jKUiI8Z9dPjkft93R0AwdI8okOaxZLc1ChyT3J5gxvLVKe9W4+zMdScePBOVaIbwuQpO+jjFjuyDZgDQ7i0UKGxorErGmtNzV2aRDc3TgETMGeTHRnnGAlVCSrD4pov77g7OjNRvH/SEL3mH4wEJmKTMdSVvsscwafq8g48dJa7x3FMlG5AW9Mol37MDsEHOn+yZNCMKm9OW5APUmre3jhIojTjmMtSAH0y2A10Hu8r8JXWwmg1gW+X96VJpAc1MIczg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(44832011)(5660300002)(55016002)(478600001)(7696005)(64756008)(66476007)(6506007)(52536014)(186003)(66946007)(316002)(4326008)(2906002)(8676002)(86362001)(26005)(33656002)(66446008)(54906003)(83380400001)(4744005)(9686003)(8936002)(66556008)(6916009)(71200400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: maMJfY8w6OflKJNQBe4qAl4C3l4Ly6klEo3kvBdhfu6Sh+7U6F+aET3kp7BrU2uqmgP+bI6Zk/H1D5mpmLWfiODGclxN71sJmagjJjk8KlxZh+eSlQL6a0vmY4RkAABW6GmMRPvaWuyl5+0drpSE8IK1qcbhqci2GAGTHDoSchXb3fDFhzX5CCOWm8LttEyyxlNGts5QgTXWaq5d3ze0BB6Cwja6pIC/sFGlsPAvZ5Vap5+ILkgmA/2BoF/Wepdx0FG2li51bfl2kOcKxhg5/lYDzyHZtBiRspxyFk3C4EByXEHY+Z42aCARD+MeyNI83UsonroBPTcLy45q52nGmnmYMn0hmjo4+qB+7it9JNNeRWlWCNrxo5q4+uxGZMBPmyLQXVvZ3GrA+cHWsHETplyt8/fuaRonoXlf4oR5R5nWaCqu01Zv2+UneOdY7a5J9rXRLwRsq9Wgj7MgAEwy25Ronaj5lSwafOz30oTgLlVm0uej32AdbeLwDOQBE9GbP7y/G6GrXbNkyOFcLCyzqPz/Zn8HjEe05cfM3oMT6xRQAlsEdqt93mm0MCBEVbhNehd5PTpc3L0omycDNfajt/AMijL3NBikGMOekTFrq8d+Vj8lO1xe+DL6yrwjsyK9YPs4anlZBciMEoXQ9XE7WA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f5719e-6d6b-49db-2652-08d88c7464a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 10:18:00.4785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3Iw3Sc8i2O/v0pL9DykI7l+j2/hcu/IoVcvfbLdxELSeFyXqep82dil8oF1QTBDO+IBXyhC9oXv8coHml+aZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4540
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
[...]
>Subject: Re: [PATCH net-next 0/2] enetc: Clean endianness warnings up
>
>On Wed, 18 Nov 2020 09:52:58 -0800 Jakub Kicinski wrote:
>> On Tue, 17 Nov 2020 20:20:02 +0200 Claudiu Manoil wrote:
>> > Cleanup patches to address the outstanding endianness issues
>> > in the driver reported by sparse.
>>
>> Build bot says this doesn't apply to net-next, could you double check?
>
>Hm, not sure what happened there, it does seem to apply now.
>
>Could you resend regardless? Would be good to get this build tested.

Reformatted and resent patches.
