Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5984E2116F
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 02:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfEQArm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 20:47:42 -0400
Received: from mail-eopbgr1310094.outbound.protection.outlook.com ([40.107.131.94]:57216
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727709AbfEQArl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 20:47:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=kJPl7b+IGGMt+DCN9+JAOG+iraKdyNBnLYedq+4eKRXNYKO/bKG1u1Lbeo6k/F6uJVn4iUySbNy+UYQ81T5sLdwE/KvKCZKS2hgaFBI5ogZ0aOhDmN/Fqd3j5604rSgCRxtymWYKmSuBk+6MK01BRuT9s8ELOlva73BM8a68g+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFGZkSISXDkX/8g6Qz6QbcxO/Igk3YEgRWTs8QYGavA=;
 b=Mmyp5mgvjTrYELaMJV3ndWq5GgYKZpuKjgGN9DefiY2DugydqsW4pvdWWwq1V66kcM0DpSwcL1aAX18L+FMoeRhm+o6Pp9rXV82yxpWmGepKS9bCkggT3mJhMwgqKygkvmBPhCIZ9T6OKPUiDiokvBNe6SoWcuXNSEM9b0IGDLM=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFGZkSISXDkX/8g6Qz6QbcxO/Igk3YEgRWTs8QYGavA=;
 b=cL3lXi5N5QnNF2k0pnN264+AyfmvhtGLh6r+6mcn20mYnQZgQnUwgjIgKnhQygyCCiUZT79kJhwHPmecSI7KnRwt4+Cxb1gEaUSgEfGALmNxR6M68X6vHHHcrLv9Vs/Q3KUnSIoAqglSwlzhAEheVTZ7accYoKI5U3lpN+0al6U=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0204.APCP153.PROD.OUTLOOK.COM (52.133.194.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.4; Fri, 17 May 2019 00:47:31 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Fri, 17 May 2019
 00:47:31 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv_sock: perf: Allow the socket buffer size options to
 influence the actual socket buffers
Thread-Topic: [PATCH] hv_sock: perf: Allow the socket buffer size options to
 influence the actual socket buffers
Thread-Index: AdULT8Ri+kxJVj56RXiGnzXz8jUENAA+hb4g
Date:   Fri, 17 May 2019 00:47:31 +0000
Message-ID: <PU1P153MB01695A75877953399C4E94A6BF0B0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB046528E2099CDE2C6C2200A7C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
In-Reply-To: <BN6PR21MB046528E2099CDE2C6C2200A7C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-17T00:47:28.7028353Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9d1c7d48-1283-4379-a578-6f8b90e813bb;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:e49c:a88d:95f1:67ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8367752-20a8-4c71-5725-08d6da613e87
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0204;
x-ms-traffictypediagnostic: PU1P153MB0204:
x-microsoft-antispam-prvs: <PU1P153MB0204715DB77BB38412A66D6FBF0B0@PU1P153MB0204.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(396003)(346002)(39860400002)(136003)(376002)(199004)(189003)(1511001)(446003)(22452003)(316002)(99286004)(486006)(46003)(476003)(11346002)(102836004)(14454004)(8936002)(81166006)(8676002)(81156014)(6116002)(9686003)(2906002)(10090500001)(68736007)(8990500004)(33656002)(110136005)(54906003)(7696005)(6506007)(5660300002)(186003)(76176011)(229853002)(7736002)(10290500003)(305945005)(6636002)(66556008)(6436002)(25786009)(55016002)(64756008)(4326008)(478600001)(66476007)(76116006)(66446008)(73956011)(66946007)(86612001)(52536014)(71190400001)(71200400001)(86362001)(74316002)(53936002)(6246003)(256004)(4744005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0204;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JZmv+FERqA8X8Cha2vgtxjRCTR4d/UTpT3l7HZhKPnQGe2gVDOptkK+JUjGXOfKIcZOLC/KB3Cg3LwEdMrfWpAkXndzj2J8S0fR13yfZdabrBv2muAS6MkccPGmlfxXhDDN8XcKwT5zzgxTKxPW+K5XcJ4GkAcNDi8/xnOVA75SF+NIKcykctKZut1Rk19qf94UQQsHaWdj4W0qxS8el4cnlHD+PkSUr3tMN3sup9HofITkuO4wabhfJgyh1oULLzkmgtaLjgWbouzKUZh9nOnpG9s0UxWMJybyz78FVEy4w5oI/TM9Yap8E4P/tpcFs/mAt7wFq0yVFuhYTC8cXSI0sTzm/BellAtE6JvPB0UY7BbynrgE9pja6/rOMzfPivn2Jas5gljmq6rehZgWSuVbiDYE4jQZUwC7SP40VJ+o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8367752-20a8-4c71-5725-08d6da613e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 00:47:31.1715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0204
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Thursday, May 16, 2019 5:17 PM
>=20
> Currently, the hv_sock buffer size is static and can't scale to the
> bandwidth requirements of the application. This change allows the
> applications to influence the socket buffer sizes using the SO_SNDBUF and
> the SO_RCVBUF socket options.
>=20
> Few interesting points to note:
> 1. Since the VMBUS does not allow a resize operation of the ring size, th=
e
> socket buffer size option should be set prior to establishing the
> connection for it to take effect.
> 2. Setting the socket option comes with the cost of that much memory bein=
g
> reserved/allocated by the kernel, for the lifetime of the connection.

Reviewed-by: Dexuan Cui <decui@microsoft.com>

The patch looks good to me. Thanks, Sunil!

Thanks,
-- Dexuan
