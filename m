Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0495FB299
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 15:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfKMOa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 09:30:28 -0500
Received: from mail-eopbgr730060.outbound.protection.outlook.com ([40.107.73.60]:12330
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727423AbfKMOa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 09:30:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUem60pPd0oxUSp/aZb2LoOKZCtMc9QJx+1SwJsY073BCIy510QV09ws6w4zhbgzdhs4dTybFzelWqLAzWorbgkT19aupKXhZHqB/DCNOalrRy/eUbUHi52/THUijnGgXrIs5Q2Cp4RslwKjf3ESiIz8lwx//xTSrqmpAlz+g6LeX5/vu5IyvsNLeQfTMjjPYOTqxYgSeZ3EawaUpe8SyVEYI4vbRv5OW1A0EXJjlAajFI67Fo7k0IjUnCwexMkB7zvtOU/kbaKnlvn3cwQmF3THW8OA835FRBrL9nYg7OFSH1xkNTQJZ5q84shirqi8zoUA8GEr7kJo+oNqin62nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nef3NascKxvatZ55N3nXuDDCeHfSedK01vo0Vu91jAI=;
 b=iZ/q/D7f8dPALCt9HhfwQrx3mJ4+rP1Wqmflps1nKULb64CM2o7JzlsPJC261j/xMHF63bEw2Vl0ZQvI4lGZnqDlpM8Vcxlc3Wz2heK5q3TCNXtjSPZ585wZDCI6/MYenS0aUvn2ss869cfUDGWXcjgnR+hR5ZXhXm9kvBSQM05PUA+hENAmuXGr1A0nWI2nXGn8HpfwY/ZLsuNEX7J0mbcEX9sgyU9PhRMluA2yaonvrW9MZMDKM19EnT3U7/LACXoxIYs+ExeLUdohUeNM6sJsTxZvBhkr9duUaOFjsv4VK4i0ndVKGVjZZ06CidchXd3uLY2UpaeN66kyedqgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nef3NascKxvatZ55N3nXuDDCeHfSedK01vo0Vu91jAI=;
 b=O7VrRZkEeuqJgm+cB3XcThFSNAG55M7xmEIHtVb0vpiD/Bs+OXLB+iBpQ1aAoF/TTw8002CUK4VxgRVNyk680dfEKJw+YqIn/nNyXOaBVYXAxXOiROFuBRcWT0eTG5YDAxkHv334xD7JNyJKGtLMp/cj5Yc2OB27zoMcW3VB3FE=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3184.namprd05.prod.outlook.com (10.173.228.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.16; Wed, 13 Nov 2019 14:30:25 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 14:30:24 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Topic: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Index: AQHViYhm3+s3qIN1EEmJgzgCfyvFAqeGCo7QgABKOACAAQ6AQIAAE78AgAHSO0A=
Date:   Wed, 13 Nov 2019 14:30:24 +0000
Message-ID: <MWHPR05MB3376560CFD2A710723843828DA760@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
 <MWHPR05MB33761FE4DA27130C72FC5048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191111171740.xwo7isdmtt7ywibo@steredhat>
 <MWHPR05MB33764F82AFA882B921A11E56DA770@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191112103630.vd3kbk7xnplv6rey@steredhat>
In-Reply-To: <20191112103630.vd3kbk7xnplv6rey@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5dd667cf-007c-412c-4b92-08d76846057d
x-ms-traffictypediagnostic: MWHPR05MB3184:
x-microsoft-antispam-prvs: <MWHPR05MB3184FF55F6C8EF0E97379E22DA760@MWHPR05MB3184.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(51444003)(189003)(199004)(3846002)(6116002)(14454004)(9686003)(71190400001)(8936002)(55016002)(54906003)(4326008)(8676002)(478600001)(81156014)(6246003)(81166006)(66446008)(71200400001)(66476007)(66556008)(64756008)(256004)(76116006)(66066001)(66946007)(99286004)(25786009)(6436002)(229853002)(74316002)(6916009)(86362001)(52536014)(186003)(476003)(5660300002)(446003)(11346002)(7736002)(7696005)(76176011)(316002)(102836004)(486006)(33656002)(26005)(6506007)(7416002)(2906002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3184;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eGLzsSOicfcokRNYipv42lv/BBex+c9/+yCuZjgbwdYQ4uAGMjJv2Ewp2U+z4+TzEG9FIU9XIYei9KATREeJyZAv4/BtrwZ8d0/UaYKPMH4DM9Y5fKuY6sa9OAjLel/2HrY+8YTIKv9yfopKqurP5OQGIazjX+AQSrAmPB2N+GEp/XLtpWZtLLErhktcqY2ihfi06ZlB7mzCWSWmLWAR7nKGW3LcylxrgaI4ROzGb3iglvHo4RCFcHl/ACzuK+IXa5al5y+VHCg1FoO1VNxqmYiEiExij66Ice3vakS4Vg5forCbr5q1atSIALVHNrh1bW6giyA+1c4ZpevtSUQ/8AUDhZnb+FJ/dNOt4zUT0FShmFOmDZYRYd6Zs5k0CmW0u5Hif+mEuqtmlY1MCwSq2bnYD0eawPKTn9888rjYWuL2UEMBtRbjUqxsYd/7lCMP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd667cf-007c-412c-4b92-08d76846057d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 14:30:24.3322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kh5WYTK2RH0nwUIGvoLLkwMId5VLRLuR4NBiT8dwFGq5lsA73gDRzCL7Wfg3jmYLgNgC5/U1ZGdkyfC+hBizoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3184
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Tuesday, November 12, 2019 11:37 AM

> > > > You already mentioned that you are working on a fix for loopback
> > > > here for the guest, but presumably a host could also do loopback.
> > >
> > > IIUC we don't support loopback in the host, because in this case the
> > > application will use the CID_HOST as address, but if we are in a nest=
ed
> > > VM environment we are in trouble.
> >
> > If both src and dst CID are CID_HOST, we should be fairly sure that thi=
s
> > Is host loopback, no? If src is anything else, we would do G2H.
> >
>=20
> The problem is that we don't know the src until we assign a transport
> looking at the dst. (or if the user bound the socket to CID_HOST before
> the connect(), but it is not very common)
>=20
> So if we are in a L1 and the user uses the local guest CID, it works, but=
 if
> it uses the HOST_CID, the packet will go to the L0.
>=20
> If we are in L0, it could be simple, because we can simply check if G2H
> is not loaded, so any packet to CID_HOST, is host loopback.
>=20
> I think that if the user uses the IOCTL_VM_SOCKETS_GET_LOCAL_CID, to set
> the dest CID for the loopback, it works in both cases because we return t=
he
> HOST_CID in L0, and always the guest CID in L1, also if a H2G is loaded t=
o
> handle the L2.
>=20
> Maybe we should document this in the man page.

Yeah, it seems like a good idea to flesh out the routing behavior for neste=
d
VMs in the man page.

>=20
> But I have a question: Does vmci support the host loopback?
> I've tried, and it seems not.

Only for datagrams - not for stream sockets.
=20
> Also vhost-vsock doesn't support it, but virtio-vsock does.
>=20
> > >
> > > Since several people asked about this feature at the KVM Forum, I wou=
ld
> like
> > > to add a new VMADDR_CID_LOCAL (i.e. using the reserved 1) and
> implement
> > > loopback in the core.
> > >
> > > What do you think?
> >
> > What kind of use cases are mentioned in the KVM forum for loopback?
> One concern
> > is that we have to maintain yet another interprocess communication
> mechanism,
> > even though other choices exist already  (and those are likely to be mo=
re
> efficient
> > given the development time and specific focus that went into those). To
> me, the
> > local connections are mainly useful as a way to sanity test the protoco=
l and
> transports.
> > However, if loopback is compelling, it would make sense have it in the =
core,
> since it
> > shouldn't need a specific transport.
>=20
> The common use cases is for developer point of view, and to test the
> protocol and transports as you said.
>=20
> People that are introducing VSOCK support in their projects, would like t=
o
> test them on their own PC without starting a VM.
>=20
> The idea is to move the code to handle loopback from the virtio-vsock,
> in the core, but in another series :-)

OK, that makes sense.

Thanks,
Jorgen
