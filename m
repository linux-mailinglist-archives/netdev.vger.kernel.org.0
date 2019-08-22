Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D318A98A38
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 06:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfHVENF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 00:13:05 -0400
Received: from mail-eopbgr680123.outbound.protection.outlook.com ([40.107.68.123]:52547
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbfHVENF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 00:13:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kb0GIPNW9TvkaRtN0qN3tTU33miPbwtVKl3IJqouSOKHmeAXugVXCwj+xxGcbxd5C/k0tZ6Nt+NRyqikGNxxMUH0OAohIl5OyfHBIhbC/unopceTU9+tYmSa3azHlCZlO+SW1Cu1n+tplfHtDvwkU/euguXDR0fEBOm0d/ZXoAgANns5p54WkeX4maEREJ2ppPIsR27K6ddLH67G1B89TBkxWvNCLEFhfMxu5/8hUrOEHo9RcjbPybFEMlr+ZNpole1/T3OHL/APHQxtR/rq1oxsYdPy96BTweUij0ZJzqt198I05dqiD6Le8r4Yc/fA9c543f7jJ5QdCG6b73nUoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frq1ZZEntgGeJQx+nbSM4B4jLXSLJDeUBbPjzXe9mPE=;
 b=KPzgHO+2uFQ5VNHP1pInS5ShH6EId1LixHVE7RtjIxfCmCVoYC6ZSAUkrOdJA8zZwiHkjobAQzPg6NfsuImCM5dEI94Y58U0E72DbG6Wk3Z7cboI+os1IjdTIv9K3/EURCUTje65wpaLwKTKGWgsFDLbp2Xjl0jKslrrJ2aMaKwNBgln6gwxNfT3wRvPAwrLOLKZ9hGGdzwY0cmHhvAjM5FgLOsmRAWNQhgVASj0HQ6IsGOLXTCtpZetjqTQiewJ0nsk1oRCGOkTAWOpprpW6hn6VqLNpj3C3Wq13qvJVRGnKrjLbkP97yZU3iTi6uYs94k+sunxf+ub7eXjX95z/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frq1ZZEntgGeJQx+nbSM4B4jLXSLJDeUBbPjzXe9mPE=;
 b=LBez7/zBNxqCe69+oZ/NC6tO4QrayuM4Ai7nYxnFcXnJg6eQhFzoucW/kjZoCqn9ixj1dZhNRIGfMDpqgbYEJnbu59h+9kgPw0QP+W3LgQJtUXy5ps2pDnhCKZdyXJE3pfFv7+Nl4J4xLJH2b8bGEszQvJAthMB63ANoKqTa8cI=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1259.namprd21.prod.outlook.com (20.179.50.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Thu, 22 Aug 2019 04:13:01 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Thu, 22 Aug 2019
 04:13:01 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next,v3, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Topic: [PATCH net-next,v3, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVV7aiDgd7yolKIEul0PfWUyB6vqcGj0GAgAAA5lA=
Date:   Thu, 22 Aug 2019 04:13:00 +0000
Message-ID: <DM6PR21MB1337D99E85AA40A1B59A62EACAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
 <20190821.210907.884869474698105971.davem@davemloft.net>
In-Reply-To: <20190821.210907.884869474698105971.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-22T04:12:59.1268659Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9d7ee34c-701d-46ce-a7c8-31e1e6c851db;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [12.235.16.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72e86e13-7425-4375-b923-08d726b705b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600158)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1259;
x-ms-traffictypediagnostic: DM6PR21MB1259:|DM6PR21MB1259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB1259227190C913A67E974A65CAA50@DM6PR21MB1259.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(13464003)(199004)(189003)(476003)(7416002)(316002)(4326008)(229853002)(9686003)(22452003)(8936002)(2906002)(25786009)(86362001)(6246003)(478600001)(14454004)(81156014)(71200400001)(71190400001)(8676002)(53936002)(81166006)(76116006)(6916009)(66946007)(10090500001)(76176011)(8990500004)(52536014)(186003)(11346002)(66556008)(26005)(10290500003)(446003)(74316002)(54906003)(64756008)(66476007)(305945005)(7696005)(6436002)(6116002)(33656002)(53546011)(99286004)(66066001)(256004)(14444005)(55016002)(102836004)(3846002)(66446008)(5660300002)(486006)(6506007)(7736002)(42413003)(142933001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1259;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WbQOnlrHn4PR0CKctB3NjPqZ4akvly89ZCPx62RvCEdY6Ym0JVEgFzrWZGDq3NWOA/YqcGI+etIgTSRL5Coo5gzSjVk4ABOHbiTbmW1fuZq1s9k8lZ40sHN7sbwn+M+IDqYGH3qvlCb47+dMEgcb9pDMwklrA4MRVkgloBrPMn1/I4IZcUT/Y5ZuWJDeCC11BbejjstGpWDhAOP8JCQvuYQMV6AtcOxpz2ArfS4QDKgorbaAQiFrHbJt2WtwZPdrvx5Cw9Un783aGcUK0JkqXwlSUuH5b6xiVEdFid/wOepIUiL7M2PuXutfzDk5Oin3ZD71bv8/ut34erEiIZd92kk45oJgZTW8mYS1Vz0OxAnVmb5erZ4gmTgwF8jrSM8SZm83DKJXGaEj4qwfSqWky9eiDRJ0fYwGuWe4genzYDo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e86e13-7425-4375-b923-08d726b705b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 04:13:01.0641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGdVyyGHtHPIcEGbZeZ0IzxJQs1P0KIYlkJ0m5spZSQfzAZxvTJdUCj4qez09N0Q80RUBcGjd4t01oRpcste6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> owner@vger.kernel.org> On Behalf Of David Miller
> Sent: Wednesday, August 21, 2019 9:09 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; saeedm@mellanox.com; leon@kernel.org;
> eranbe@mellanox.com; lorenzo.pieralisi@arm.com; bhelgaas@google.com;
> linux-pci@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next,v3, 0/6] Add software backchannel and mlx5e
> HV VHCA stats
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Wed, 21 Aug 2019 00:23:19 +0000
>=20
> > This patch set adds paravirtual backchannel in software in pci_hyperv,
> > which is required by the mlx5e driver HV VHCA stats agent.
> >
> > The stats agent is responsible on running a periodic rx/tx
> > packets/bytes stats update.
>=20
> These patches don't apply cleanly to net-next, probably due to some recen=
t
> mlx5 driver changes.
>=20
> Please respin.

I will do.
Thanks,

- Haiyang
