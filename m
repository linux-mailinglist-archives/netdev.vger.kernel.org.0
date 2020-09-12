Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7ADB267BF9
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgILTdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:33:00 -0400
Received: from mail-dm6nam12on2111.outbound.protection.outlook.com ([40.107.243.111]:9473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILTcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:32:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDhUip37NkPdFEgA/hNjo7SDKb4tBd4G+UtE+Aqz+wLI1dl0WPkjdZ0tbrfCk+pnwFr8nYpnvMZMVX2hL9h0M7tT1/kbXMH2PGXj7QV6pCH/ZYAFbUGIL3nRaUrf6eq6l3+Tlo/scKqQf5uXFnW9bUwwYXno1O1gVZWcNxYlYoqDtuXLVFlFUxhTrDpWDAf1vOQNjSnxUKb2rGaaXlBAEKzNDpnH/+8dV8fGdYxpXW9p7nA90jcmhVFEaFGoC/DHqNjZ/YTeIS1yEuy21dj5I+/U4FU27ooUGVmGkaOC/ilWu2bJlFzxHIp1ou/rTHtweznUxIVRApO1y9yeTb4Xrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iI0w2fE/Mwc2ast+maigT5sJzULwpisS1Vb7LtjLQVg=;
 b=WXeP/VpTTvAGSBaKf0dc5tWnmKRxVHLbztSefmREheg2/SykwjcsyAMhozpsQBeANAXF47ACAJxdQVZ+XM6vv9I+8Ju1IED5g2tU9hlkwLnFV3Ic5an5lKJx9sXaesk2PDxIZm8D9yyMeiUcaAf0uZ6wV01FKa5amm0+hHesWvZiVfkxdwLSyfCMIHMHsTCZHQyBal4Q2limtkOiLHMNw4TGpWXWnFjNk31UX++9cS6+AqoXtcGKaZPUEzMEKm70Ofc/2gOyQvItGLaF+0OdL7MJ0Ev5m0HAJjfIKm11A+yaEgiAlci1ief4SmepTDbYncwnNrl+N1umv3lfSp4K8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iI0w2fE/Mwc2ast+maigT5sJzULwpisS1Vb7LtjLQVg=;
 b=bPLQbCIcqvoUZou0gSXApNQ/TWrIFJZFc1UmDB846yPVuFYpJHTQgjeMFhGjMyAwh9laM5PWc5qqje+MU0Rlt5Ir+xJKewuM/IYBpUO9FT/SSOvoyQdCNBTd8Ou2791OUBMdtV9pgq8NFPs7mO6W+3CHg4EnQn0e0NPXer7vf4Y=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0512.namprd21.prod.outlook.com (2603:10b6:300:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0; Sat, 12 Sep
 2020 19:32:51 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:32:51 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v3 05/11] Drivers: hv: vmbus: Move virt_to_hvpfn() to
 hyperv header
Thread-Topic: [PATCH v3 05/11] Drivers: hv: vmbus: Move virt_to_hvpfn() to
 hyperv header
Thread-Index: AQHWh3+bg6owdCWvBEyMIu6pbcs9KKllZ7Lw
Date:   Sat, 12 Sep 2020 19:32:51 +0000
Message-ID: <MW2PR2101MB105280A9EEE7109F984AEF8BD7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-6-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-6-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:32:49Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=47bda014-4e22-412b-a44b-0b465b3abae3;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6d1973f-0750-498d-b03f-08d85752a3b1
x-ms-traffictypediagnostic: MWHPR21MB0512:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB05125E52AA07E1C11CACE13FD7250@MWHPR21MB0512.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EMKEYv8tH1iDTa+NEiyHk9qdH23JzSIcUM3mOD02J+6ZI/qn7iXR5Mkd8NmN2MUsaTsm1RIYe8edu6LY/4RWwkRHn8WE/G5mlEE7VOjaNL89N34lgfyzhhno+5GcfsZ5P1eQdUy+SDrAwGGzVObZ+IyrJh96zWrMHpQr55unyAuXwCsVQSaegsznrda28j2e2iNXkg3a/6QkTIydQ2t/S0cTPCfAdYOmG7atFQ6szuya7yesukXHV2umrg+luijp7pD1M8EX2khUTBQ4t0E5sPSblmrShIJq9rOpiwFY3yMb4JjPpp3rz2nnd6JlWDgHevvkcs/Z5ZMz82ouIVhN95uwPPGmd0MMS3V4iNIRuCkHc+z0ylZB37TIKjGNACzc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(33656002)(83380400001)(316002)(4326008)(9686003)(10290500003)(2906002)(71200400001)(52536014)(8990500004)(86362001)(66556008)(64756008)(66446008)(66476007)(6506007)(55016002)(4744005)(82960400001)(82950400001)(186003)(5660300002)(8676002)(66946007)(26005)(110136005)(76116006)(478600001)(7696005)(54906003)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mEkA0o2Z/KAvj5Yv1cyQYqxcD7bwLdxZq2kc0KQwM1YSPGWNsk72azIFDt5CZuuDg/WCftIphfPqxN2eR9TnHte6/+Kd85PWL/CGRpYVFpN3Z0+QL/KuxJwIIW2pFJDYPgJgVt5z4s54kQOa79v1eN60O+UnAJvjrL3BzRDqPjfwcO0D2yfBktRWHg4UQ4X0ecbbTZ7sKd2g0OJk5nX+AO4Z1uMHDlkg7h/OxUcUbdltqHDSclkjFbRpeyDbdoM7fsCnSQwWiA1csSD8Zh13djtqMrtUsYyVT1wlwd26meV0Cj5AkDnPrK5fkT7cV8rYsc4GCAXIr29uHgaattYktkagercQUVQfA64UTmaNj8WNT5eIy/F3O5Wa1a32ytKzXQ1tBpq2+XqGsZJbALNjtiY4FdIOujpl+5mcR4iupJTPhkg8S+Bg4TTO+ksw0lY3igF5HgZF+u7sjY4WC8nX+IGcW2hSL5PfPctrW1ZXNjkuz9KfO590XoKWDYqkA/f4vApJW/vDxUFK15cZYj98fdMUqQ+7IOb11AvzviA8BtGRA9TofSy9BoCjdVbjHfzXx9yg80PM1Z3Jjhed5/P+CmZgB5kHccLQjQkuvSNmi4TzzUFCQSkvFD1VpmUT4ZO/NwxbwL1ifyQgGawj/bZUyA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d1973f-0750-498d-b03f-08d85752a3b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:32:51.5212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mX9rXrOgNxkA4kyTxeNW6xoDGDiQXq7vNBP9zjKdPZ1WD+NFpDPPN4E/10yeFNcaerxWmpbrbq+2ENXuCHgVU1AixyXruE39efsm+p7nMJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
>=20
> There will be more places other than vmbus where we need to calculate
> the Hyper-V page PFN from a virtual address, so move virt_to_hvpfn() to
> hyperv generic header.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/hv/channel.c   | 13 -------------
>  include/linux/hyperv.h | 15 +++++++++++++++
>  2 files changed, 15 insertions(+), 13 deletions(-)
>=20

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
