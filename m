Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B6D254FE1
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 22:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgH0UPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 16:15:06 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7020 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgH0UPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 16:15:05 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f48141c0000>; Thu, 27 Aug 2020 13:14:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 13:15:03 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 27 Aug 2020 13:15:03 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 20:15:02 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 27 Aug 2020 20:15:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZAI4UxET2hofqll3x+3FKLGxCMMQHlYWbkNMj6iUOUZcjUdCGFnDSAi9ly24yPDlsXsxGv9nw/HSs6ipi2xyv+Bw13z3jwa7/uRF59syFw0Hl7XTz51/4Anuux5DKb+ihNrn/i8SFAsZDHCebm5mwwMZcYoVZiah9wD/034KehD1sRxvYqJ4I0varZ7Id9r6VkJ4HAMKhsQUaFeHNq7FWyFYMrQix96EnQFlHvpaI/+nGLHc8q4KbIbOCwGuCWLlh8PJEmGtLQ+Gkb6YumAP/eNlSmUZ+072Tx7qS5cKVWAaSLhvf4ZdU6uJYzZ5FR1IhH8dfPOsSe3QNS2tKjGsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqozqGbdL4DmDxC1HnNXphlhNWh7o39PXOemrfnPZeE=;
 b=MkSK+f9AzMeVKGmoXCg8Tc5YCiVFzbW9DjgnKUfQrVtKIh3IZHb6W1w9E89CQ0YmMfyFqhmBayP+xmaylF6pRA8C1AWb07PEikNMv68ibYZzSWeL4cNxJqRBFjaVW714hFhIdlhcp6DRDxPO+g2w2ZBMecKZRWOLVqj7zLp9k/l4pw1Egx1kFzrfnRKX0gC9UmDws4XIHmalE3tCNLSgJsa4UlEf/tu3A1puu/5ymNTipgELOkAKkxp2+3F+ZRvRbthmroHlDnxJFuk/fgFmz1bJ4pAxn6hdukuR/N/zR8jeGAPvS25YqpkivC0YoVcmd5wBfy0U52Y+gIjIcQWCCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3841.namprd12.prod.outlook.com (2603:10b6:a03:194::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 20:15:01 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 20:15:01 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykA==
Date:   Thu, 27 Aug 2020 20:15:01 +0000
Message-ID: <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec0d8008-9913-4932-c52b-08d84ac5e113
x-ms-traffictypediagnostic: BY5PR12MB3841:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3841A6E6E8F33B67B6045631DC550@BY5PR12MB3841.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e5geeLzPPUig0BFkyS8iIGmTIKk+dC3l3NWEMQLN26Cc5mWwFHaSJRhPYorfQPiFd/zoRvQ+jMhMn9UhY7qtn4KQAJA5VANNIFi2aMN/gyZMp2oEc8XgeuGuiSGT49JU9Lm/p8Fw8J6lRX+tEpDc2YDOR46sRc75IXdtIXSD4Mj7Ywy7C8hHat8WoULHurkqC6NhXvY4y1R2tGMLK0D0f04WHHCO+eMwwhV/okyTJ1FGN8OhmwJItfGlM7OfB+b2q2/f5zsWg/oFuq5hjpz7nJytVq/g4G20ywMLHVKw0JBGT6EzslkqwXbLXOuFqYaJWMOYi/vMw9JaJfVDs6naow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(66946007)(86362001)(66476007)(6506007)(8676002)(64756008)(66556008)(76116006)(55236004)(4326008)(83380400001)(7696005)(2906002)(9686003)(26005)(186003)(55016002)(8936002)(52536014)(6916009)(107886003)(71200400001)(316002)(66446008)(5660300002)(478600001)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hsqrIiMsKVlWNfONAt5aSN0mm0pxBhZ4ygE1bq/1qur6M+r6UD1CXJcD+dxXteoyM+k8EGnlAgVooLLF6I/MBum3bgeO4scKiI5nTlsL6tByJMu/XQ4bTghLWxLoLBj+nR27mIucu4YPr36PrhOIEEJDA0oYOIPB45zFwgDnNLE0aleXk1kaKl94RILvhTkx3M7P5wmoKmmk8Q5ZZs/W4pqydwKQI+9AMrLf38bpkzu0ImUCYMcW2tnQAI+0Hpy/cpiuAMCOE65ETXH/yZU98iuom0yXfcJpbwlzxkX4riN1iOiwYcsfXWOA++EbSFVfe7elNVbZNv3aLxHWDEiWWrgL6gNfleb9mgvv4AjxfsOeVgUXS2dn8NXswMVD1Jn/W+L4PRP5FD6iEeti9nwFHRMF7qBkZaWcbLK/v5U9pcadfpBkPiqotVZ0YgsUPpEt7qdYQizXZ7VdI0+M6nQ26z/MXbJMqvbqtwrlE36oTk2Yj4bOK8MAwlZB/cp5ZAAP79+UiX958sGoUTl8HtP8QPZ2wmJ/JTCg5FLkC4z4/pUC44+pT2wR8oBk+iZXcU8ALZrMVlAOo1JlSJXiX349QQaQtEqAlkM2MsZPyVUyWeOiLzxfrhyUcNZJYw9zqd+pQcfeIRg/JaFVF9tYyaXClg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0d8008-9913-4932-c52b-08d84ac5e113
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 20:15:01.6275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J75HJLofjVbAdgJKdejc+3FCHJpT5/XtF7AqhbII0ZI29cJ5kgV7OAG3APm3javAJlK209ceQFCB6TrqZJnSZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3841
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598559260; bh=MqozqGbdL4DmDxC1HnNXphlhNWh7o39PXOemrfnPZeE=;
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
        b=To3wAtuw2LqMixp+wyxtaaD10v9qgADxOjcCSGt3N1eJQluq2OmxKGcQpFxXpSSPL
         3grAV+wcz8m9ZUEAEgBQauTkMXZQqiJw2PmHO3ar15DafDtIZcyqIaTMMpj12zbvtq
         GtbbbOe9/SJWLN0gaPu/LEOgCjRZT/ouMXC5fHwf61dYlGr+MHQkD4vPcRO/EnzZte
         50bYJsCiJ0r2H7iFvBXaU3GitQnpkg+rZrCoPCf0MbcJXU92k1xu9nCv8NFI1mWNbh
         HGbgDTcbZRdGt0iuFtTzgP5vxYNz+egS0C//JIUTq+xHaenxJ9soyd2edACXulRSyt
         yOo5R2QSYY/8g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 28, 2020 12:02 AM
>=20
> On Thu, 27 Aug 2020 04:31:43 +0000 Parav Pandit wrote:
> > > > $ devlink port show looks like below without a controller annotatio=
n.
> > > > pci/0000:00:08.0/0: type eth netdev eth5 flavour physical
> > > > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> > > > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
> > >
> > > How can you have two PF 0? Aaah - by controller you mean hardware
> > > IP, not whoever is controlling the switching! So the chip has
> > > multiple HW controllers, each of which can have multiple PFs?
> > >
> > Hardware IP is one. This IP is plugged into two PCI root complexes.
> > One is eswitch PF, this PF has its own VFs/SFs.
> > Other PF(s) plugged into an second PCI Root complex serving the server
> system.
> > So you are right there are multiple PFs.
>=20
> I find it strange that you have pfnum 0 everywhere but then different
> controllers.
There are multiple PFs, connected to different PCI RC. So device has same p=
fnum for both the PFs.

> For MultiHost at Netronome we've used pfnum to distinguish
> between the hosts. ASIC must have some unique identifiers for each PF.
>=20
Yes. there is. It is identified by a unique controller number; internally i=
t is called host_number.
But internal host_number is misleading term as multiple cables of same phys=
ical card can be plugged into single host.
So identifying based on a unique (controller) number and matching that up o=
n external cable is desired.

> I'm not aware of any practical reason for creating PFs on one RC without
> reinitializing all the others.
I may be misunderstanding, but how is initialization is related multiple PF=
s?

>=20
> I can see how having multiple controllers may make things clearer, but ad=
ding
> another layer of IDs while the one under it is unused (pfnum=3D0) feels v=
ery
> unnecessary.
pfnum=3D0 is used today. not sure I understand your comment about being unu=
sed.
Can you please explain?

Hierarchical naming kind of make sense, but if you have other ideas to anno=
tate the controller, without changing the hardware pfnum, lets discuss.

>=20
> > Both the PFs have same PCI BDF.
>=20
> BDFs are irrelevant.
