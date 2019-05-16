Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041FF21041
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfEPVsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:48:18 -0400
Received: from mail-eopbgr1320095.outbound.protection.outlook.com ([40.107.132.95]:30624
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbfEPVsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 17:48:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=IvhzQBIiaPJRyIPJo9CnMBX+O7bfqgsFJmZRKRS5IhMBK7A7AIZojBJKgz6sSn2OxTvPx6cYpaOuqmwepH6TEg6qeMmlEpTZXbqxdesxw6uJjpXSMWF3eVu6IJJ8Nm9lffUg+QGAja1IIkdI+3iTtQkNBP4n+jgS+bDBp71ecSc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pyPs1jmTq4+0rs1P7NTg2NLZT92ZFYyZF3cwId5Gj0=;
 b=d+WGkobl/clKAJAaCrrduNbyawU8kUGnH22R9GSBlprw5q+EkFrdazEdz/j1Cg334Z1SSGaGvSfgSOjYs3NnJYJRE18ZoQWuoWwJGLQW3+IaWn+R2rdhvu7tKtIYTWu89pYsJZmlCgreetKBch82foGyss7wOzC6HTqiVzR8MBc=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pyPs1jmTq4+0rs1P7NTg2NLZT92ZFYyZF3cwId5Gj0=;
 b=cjDkJzjJB36rTmsVnb2BeLTRYtOXvkMPElXPV9PBqBW+G/UoQL8h94DQL7eKt5lcxeYW4d/3tribrgjvtOaJtTvUhJwJN7st18SSPD5HPgjpEAleBrG2VKgMQ4uSbtVTQ7+Vem3MqONE+r1wGFkGROu4VdX3Eqpr79px9xuFMjw=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0153.APCP153.PROD.OUTLOOK.COM (10.170.188.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.6; Thu, 16 May 2019 21:48:11 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Thu, 16 May 2019
 21:48:11 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Vishnu Dasa <vdasa@vmware.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [RFC] vsock: proposal to support multiple transports at runtime
Thread-Topic: [RFC] vsock: proposal to support multiple transports at runtime
Thread-Index: AQHVCi1BTYIhBg2OhU2adYZy3cWNRqZuNneA
Date:   Thu, 16 May 2019 21:48:11 +0000
Message-ID: <PU1P153MB01697642B92D138D5FA52193BF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <20190514081543.f6nphcilgjuemlet@steredhat>
In-Reply-To: <20190514081543.f6nphcilgjuemlet@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-16T21:48:09.6369173Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=406e061b-5a12-49ad-88ef-c3f377b22500;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:e49c:a88d:95f1:67ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdbb8ce6-1342-4861-4cd2-08d6da483127
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0153;
x-ms-traffictypediagnostic: PU1P153MB0153:
x-microsoft-antispam-prvs: <PU1P153MB0153FF07B0D2D04E4385C569BF0A0@PU1P153MB0153.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(366004)(39860400002)(396003)(199004)(189003)(86362001)(86612001)(76116006)(66946007)(73956011)(33656002)(10290500003)(52536014)(53936002)(9686003)(478600001)(66446008)(81156014)(81166006)(6246003)(6436002)(110136005)(54906003)(14454004)(74316002)(25786009)(4326008)(66556008)(64756008)(55016002)(66476007)(229853002)(8676002)(8936002)(8990500004)(102836004)(446003)(316002)(186003)(68736007)(11346002)(99286004)(486006)(22452003)(76176011)(7696005)(53546011)(6506007)(71190400001)(46003)(2501003)(5660300002)(476003)(305945005)(14444005)(71200400001)(256004)(6116002)(2906002)(10090500001)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0153;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nxEK0Lf2TNxAEVypd8mLfGPnMzvaGAMmJqBWaxwSxCP2W+p0AtBbJXg1ZkpE5TOB19PxaPbBenrJtnyQVf1XBKK0Lk7io0DeV9tScMlNTzvZUIVq8BYTIwOiUQjkOIkXnW56FTCKrzOOo87cskxa1CV23AF8W3+AWsUeUO2QOO8vWKgVWljZPTJNxqR38upW0NwUsKxPAEdXrl5qsCZVSMxgP57wBiRvX0Tmu2/vKG2LYFNs0S35oUlU0jE3Y0geXd1NeovOgGEUi/v+9BF5BjXjhK1SJ/ojVTwPTMWKjz35VUN8xarPORqfNOxqkpNocoQgHY/Tx5XAofVvALl+uQPdAboqhjsz7jH+J/A/dBHfpssukDUQZacooAy7oVZVTYLlE1OyDv0ALhgR1GUHD45lUazHGCTjmRmwMDyvf8w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbb8ce6-1342-4861-4cd2-08d6da483127
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 21:48:11.2785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Tuesday, May 14, 2019 1:16 AM
> To: netdev@vger.kernel.org; Stefan Hajnoczi <stefanha@redhat.com>; Dexuan
>=20
> Hi guys,
> I'm currently interested on implement a multi-transport support for VSOCK=
 in
> order to handle nested VMs.

Hi Stefano,
Thanks for reviving the discussion! :-)

I don't know a lot about the details of kvm/vmware sockets, but please let =
me
share my understanding about them, and let me also share some details about
hyper-v sockets, which I think should be the simplest:

1) For hyper-v sockets, the "host" can only be Windows. We can do nothing o=
n the
Windows host, and I guess we need to do nothing there.

2) For hyper-v sockets, I think we only care about Linux guest, and the gue=
st can
only talk to the host; a guest can not talk to another guest running on the=
 same host.

3) On a hyper-v host, if the guest is running kvm/vmware (i.e. nested virtu=
alization),
I think in the "KVM guest" the Linux hyper-v transport driver needs to load=
 so that
the guest can talk to the host (I'm not sure about "vmware guest" in this c=
ase);=20
the "KVM guest" also needs to load the kvm transport drivers so that it can=
 talk
to its child VMs (I'm not sure abut "vmware guest" in this case).

4) On kvm/vmware, if the guest is a Windows guest, I think we can do nothin=
g in
the guest; if the guest is Linux guest, I think the kvm/vmware transport dr=
ivers
should load; if the Linux guest is running kvm/vmware (nested virtualizatio=
n), I
think the proper "to child VMs" versions of the kvm/vmware transport driver=
s
need to load.=20

Thanks,
-- Dexuan
