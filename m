Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D491D15BE
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgEMNiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:38:01 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:6177
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387847AbgEMNiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 09:38:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ky///RyVfZzUjxDP1wQqYEwcy2L9szfSrp9BbqxxHI1PJ6jNlxnKlCpKRFDchxUmfPpej0YqP4/OFl8izQkNuh34EzyBZIoSIJaHATDhENORHyX8CxWxh85j0kExkYO+hA95KYjJpc6seyFGiJH9eA1JTXRlz0LkH7HoThnvB09gZLbk1vpjtyOI3MZXql9fSQI0wSYyb7k0KjRQZdrV2W+eKRiCEDItn9IuCxGRU54taDLrsz+o+Di33snASV8CdrzA7HgdwiB4S72Vdz9aGnMbLR4ifxIPtC5G3luco2QHBQJRiPOYSGDB0v3+JgZbZ0vtf3bEFGR+Ds9cLAqbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWem7qVSbNbOUaFg8y/qpgMvktXue77975/3pD/lJI8=;
 b=h4zRvYXspZXPmneUPe/ihQiU5RyDmLRgKH/ANdpEOqL7jkgnjQ2LA8kxUjcVz12pHqioabeFIG6wBACLYm6fPrnkwUmNJVHkGUcGJ9tTySID1VHPf9nAmkATc/ILTPv47Kco6MaoKSNP1sISWuZ+B6RuA9lJZjsQ9ec2HMag3m69Q5iqYr/VGEHHw5IHmit1RTMwGUc3sBVuNdha0zcqCj2ZhKdtXHnUkARZV/nUFIPPkatpRA8IqLaKbDMlTlhsFgZMhfZ/19Uk7666rtiAbvFgJv6wqm1XmrRh2NgP9ij3pvdhvo/XvxU8ou3EaMO4r+VFqgcBaKhDLd7nVEutIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWem7qVSbNbOUaFg8y/qpgMvktXue77975/3pD/lJI8=;
 b=SQpLMpr3xBEiHjuGwa6bUGT01OQvngx+BC6NrU5Azw0Ja0tuDIsI2ieMoXik8T8RYqHzThuYEbkOwJaOlFAgGJXXKxp8ojHj26bGYSREOAFb1zsHZo4zBWmW7eTevvfK4ds4obGEZuq5SoxRC71z3avd/d/VKJZ0Z37x63fwld4=
Received: from AM0PR0402MB3860.eurprd04.prod.outlook.com (2603:10a6:208:7::15)
 by AM0PR0402MB3811.eurprd04.prod.outlook.com (2603:10a6:208:d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Wed, 13 May
 2020 13:37:42 +0000
Received: from AM0PR0402MB3860.eurprd04.prod.outlook.com
 ([fe80::4888:107a:59f8:b671]) by AM0PR0402MB3860.eurprd04.prod.outlook.com
 ([fe80::4888:107a:59f8:b671%4]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 13:37:42 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Christoph Hellwig <hch@lst.de>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: RE: [PATCH] net: ignore sock_from_file errors in __scm_install_fd
Thread-Topic: [PATCH] net: ignore sock_from_file errors in __scm_install_fd
Thread-Index: AQHWKRbIe915HxPXSk6BLVy1DbwgxKimBNMQ
Date:   Wed, 13 May 2020 13:37:42 +0000
Message-ID: <AM0PR0402MB3860F7DCADF76C0F444C562AE0BF0@AM0PR0402MB3860.eurprd04.prod.outlook.com>
References: <20200513110759.2362955-1-hch@lst.de>
In-Reply-To: <20200513110759.2362955-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 96b111d7-5d59-4481-8506-08d7f742cfcc
x-ms-traffictypediagnostic: AM0PR0402MB3811:
x-microsoft-antispam-prvs: <AM0PR0402MB38118C70B9D1173D87948255E0BF0@AM0PR0402MB3811.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ASt2DFyYIRb+UDIJ3ifw/OR82gV5L1gPtUFHNaPR1eAIs16Z5vud5hINhYCxrOaECFM1Lmp7m61AbLnRHhuoeRKS6bbF90t6D2+JO6MQLRjU/wS5s9M2Fje1rZGZ71DKP0+Ri+B8ZbfBc/A5zvYJYEMFd7OIJsjESpVuN3aS9wLpnDjq7iAYiSykm4Nv78E1cT/HTCIocjFX6Hnpd9teykutg5ZS7hqkD2wJxBBpgHpfNABovjPOiYv07eKLFbZtzhFdAa0JY+GkvV8q0CC5bh8V7oayd46OCTu7B0VIzX2jiWYxwyh46KZIqnEA/b1leJl8uBRE+p/teiYDI96EPFKIGKI6KHmoHiYjHcmlq/i1AyLfSuMDHuLpFAFeB+rlJE2/Pmf24frg7v78tEGqOGU2thUPZN8d9u+oOKjaLOJwOve8u65ViumweVEcOguy+SQBMDTmjI3WsVHL4QP/bdI3iEkrPXHnq1GQ1ZgTjoP4gQnKny9WhnwerWIR8c42alDA33dA7jEtQZp4gWdeJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3860.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(33430700001)(66476007)(316002)(71200400001)(66946007)(8936002)(66446008)(44832011)(2906002)(54906003)(33656002)(186003)(4326008)(86362001)(110136005)(26005)(478600001)(8676002)(66556008)(9686003)(7696005)(55016002)(76116006)(6506007)(64756008)(33440700001)(52536014)(4744005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nZwfC+CKFu4bxjp8uQ16hpNljPP/xAd5wM6xwroFIr7Nxc3CFQwXOKkdk04Qp7UeRThXALQ7cXHl5jEYHiNPUQPHyZCqgAjGeimN6ZTgheC6tQC5Odmvu2aOcMS0D5LQVZdptuJFcW0d+jzvbdMLcBx8zjKSfGFNPbNRMY01Bmi5Pr0K8CqMWqJRgwWh6zzQNDAwzcgkM5Q0m4ZfE7C2lvLqVSvGhjmksSlLS4/H1ZYsRvTFvSQleAVXZhVHXcx+LZqqa4zD4t3Yl9IPPl5l2LaoXEESXro6ur6sWXskW0Z3gpJQeZzVcZYwerU011dvz6h+hvPwKdGH8xSKCb8psiPFf4g1au7iCzdgrt9+nSS09OnhSme7uu5Qgv/50OrAURjhuy11VdLtv75rOcfY3YZUqDfq9aQY7GCJJBs+xnwLbrAEqghtPqoCgzykeIw9q3ycorz/d1cuewY81Wl5Ors+g+Sa5YZDWxXjC6McpPM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b111d7-5d59-4481-8506-08d7f742cfcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 13:37:42.0984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SFWOe7+fywFDragRS3X6iYxFypqizc2UYIQ8n59KSIN5HaiVppljt2vZMYqg8yQZD7EaSTc+yMaCj1xZZDptbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3811
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] net: ignore sock_from_file errors in __scm_install_fd
>=20
> The code had historically been ignoring these errors, and my recent refac=
toring
> changed that, which broke ssh in some setups.
>=20
> Fixes: 2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks, I was wondering why my ssh was not working anymore.

