Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE702CADA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfE1QBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:01:05 -0400
Received: from mail-eopbgr810042.outbound.protection.outlook.com ([40.107.81.42]:30816
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbfE1QBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 12:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmOiSjI9oMrpM01+XsoeE3Vgvg19icreVSQ9mjxmVXc=;
 b=lAs5CPdcAxM2EbXKGdeZ5dF/V0HToTLXRuMxCoDE9RJwO1BUPSSt7SgwCWRTmKv7EIP6XRJvzkUvjuAavumFcwGIqs1Q/ibaLNd7OjVOqDgD2ji28PVjLCejWEi5LJ/w3wiVUTj8vj/7grNMpteZD3wyBvDbEZe1wqXQlk0nDEU=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB2943.namprd05.prod.outlook.com (10.168.244.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.9; Tue, 28 May 2019 16:01:00 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::e0b4:74fd:b16:b280]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::e0b4:74fd:b16:b280%6]) with mapi id 15.20.1943.015; Tue, 28 May 2019
 16:01:00 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu DASA <vdasa@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] vsock: proposal to support multiple transports at runtime
Thread-Topic: [RFC] vsock: proposal to support multiple transports at runtime
Thread-Index: AQHVCi09e2vAF3DRiEK8RdGpXTGFs6Z45mKAgAX3q4CAAcHDxQ==
Date:   Tue, 28 May 2019 16:01:00 +0000
Message-ID: <MWHPR05MB3376D035CA84FB6189CC1BFFDA1E0@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20190514081543.f6nphcilgjuemlet@steredhat>
 <20190523153703.GC19296@stefanha-x1.localdomain>,<20190527104447.gd23h2dsnmit75ry@steredhat>
In-Reply-To: <20190527104447.gd23h2dsnmit75ry@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [83.92.5.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37246ce4-4764-4f50-9155-08d6e385adc3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR05MB2943;
x-ms-traffictypediagnostic: MWHPR05MB2943:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR05MB294357A9F02164E54B9313F3DA1E0@MWHPR05MB2943.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(136003)(39860400002)(346002)(199004)(189003)(43544003)(8676002)(3846002)(6116002)(7696005)(76176011)(186003)(9686003)(54906003)(8936002)(561944003)(14454004)(45080400002)(26005)(110136005)(33656002)(478600001)(99286004)(81166006)(81156014)(71190400001)(316002)(229853002)(71200400001)(53936002)(6436002)(966005)(6246003)(486006)(55016002)(11346002)(76116006)(256004)(66066001)(14444005)(305945005)(5660300002)(25786009)(7736002)(74316002)(52536014)(6306002)(446003)(66946007)(476003)(6506007)(66476007)(102836004)(68736007)(4326008)(66556008)(66446008)(64756008)(86362001)(2906002)(73956011)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2943;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B0kfn3wGF87o7aFJ45Z3yJVK28aPftW2MbBRH/IIlBFu5YJFcwUA7SJGHKZgrNm33TJcr6fCQaYMTap+lcmh/OSNPYc2j/ZOht6hX2sFHPFSIK6EfMaqV2ImOplAtpFHMxBWZD34eV3cKwsIVC8vqjJODAy9JjJdn4HFemOlGiQVl9E2ZwohjKdu4pbVZJblhhW2G0QfWTNsoKf+v0WE2v1UjQzzVXlFfYJr4lMjC2eVlekS8UnjHGk80PgZo5wQhT9mXBnb1gFeKiwh47eLJ/eXgMCscp9ovqHjBf2gPPwjiRGnguKX+DAnblPJMt6sjZ6hQm4TojHtLZGK0ygIeKnkX/inm1ui9hEcYlRnIfWyg1UCQVY/IxjhmD+xi327t/OPrbEWq3gxQ0E3kAw5Yx7Jt+q2jUBAyD97xDac2uM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37246ce4-4764-4f50-9155-08d6e385adc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 16:01:00.4044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jhansen@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2943
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, May 23, 2019 at 04:37:03PM +0100, Stefan Hajnoczi wrote:=0A=
> > On Tue, May 14, 2019 at 10:15:43AM +0200, Stefano Garzarella wrote:=0A=
> > > Hi guys,=0A=
> > > I'm currently interested on implement a multi-transport support for V=
SOCK in=0A=
> > > order to handle nested VMs.=0A=
=0A=
Thanks for picking this up!=0A=
=0A=
> > >=0A=
> > > As Stefan suggested me, I started to look at this discussion:=0A=
> > > https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fl=
kml.org%2Flkml%2F2017%2F8%2F17%2F551&amp;data=3D02%7C01%7Cjhansen%40vmware.=
com%7Cc2a340a868bb4525c6d408d6e2905909%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7=
C0%7C0%7C636945506938670252&amp;sdata=3Dkl820ZF1AAOXEyCZYoNPpYmLVyvK3ISr1GT=
0oDODEn4%3D&amp;reserved=3D0=0A=
> > > Below I tried to summarize a proposal for a discussion, following the=
 ideas=0A=
> > > from Dexuan, Jorgen, and Stefan.=0A=
> > >=0A=
> > >=0A=
> > > We can define two types of transport that we have to handle at the sa=
me time=0A=
> > > (e.g. in a nested VM we would have both types of transport running to=
gether):=0A=
> > >=0A=
> > > - 'host side transport', it runs in the host and it is used to commun=
icate with=0A=
> > >   the guests of a specific hypervisor (KVM, VMWare or HyperV)=0A=
> > >=0A=
> > >   Should we support multiple 'host side transport' running at the sam=
e time?=0A=
> > >=0A=
> > > - 'guest side transport'. it runs in the guest and it is used to comm=
unicate=0A=
> > >   with the host transport=0A=
> >=0A=
> > I find this terminology confusing.  Perhaps "host->guest" (your 'host=
=0A=
> > side transport') and "guest->host" (your 'guest side transport') is=0A=
> > clearer?=0A=
>=0A=
> I agree, "host->guest" and "guest->host" are better, I'll use them.=0A=
>=0A=
> >=0A=
> > Or maybe the nested virtualization terminology of L2 transport (your=0A=
> > 'host side transport') and L0 transport (your 'guest side transport')?=
=0A=
> > Here we are the L1 guest and L0 is the host and L2 is our nested guest.=
=0A=
> >=0A=
>=0A=
> I'm confused, if L2 is the nested guest, it should be the=0A=
> 'guest side transport'. Did I miss anything?=0A=
>=0A=
> Maybe it is another point to your first proposal :)=0A=
>=0A=
> > >=0A=
> > >=0A=
> > > The main goal is to find a way to decide what transport use in these =
cases:=0A=
> > > 1. connect() / sendto()=0A=
> > >=0A=
> > >     a. use the 'host side transport', if the destination is the guest=
=0A=
> > >        (dest_cid > VMADDR_CID_HOST).=0A=
> > >        If we want to support multiple 'host side transport' running a=
t the=0A=
> > >        same time, we should assign CIDs uniquely across all transport=
s.=0A=
> > >        In this way, a packet generated by the host side will get dire=
cted=0A=
> > >        to the appropriate transport based on the CID=0A=
> >=0A=
> > The multiple host side transport case is unlikely to be necessary on x8=
6=0A=
> > where only one hypervisor uses VMX at any given time.  But eventually i=
t=0A=
> > may happen so it's wise to at least allow it in the design.=0A=
> >=0A=
>=0A=
> Okay, I was in doubt, but I'll keep it in the design.=0A=
>=0A=
> > >=0A=
> > >     b. use the 'guest side transport', if the destination is the host=
=0A=
> > >        (dest_cid =3D=3D VMADDR_CID_HOST)=0A=
> >=0A=
> > Makes sense to me.=0A=
> >=0A=
=0A=
Agreed. With the addition that VMADDR_CID_HYPERVISOR is also routed as "gue=
st->host/guest side transport".=0A=
=0A=
>> >=0A=
>> >=0A=
>> > 2. listen() / recvfrom()=0A=
> > >=0A=
>> >     a. use the 'host side transport', if the socket is bound to=0A=
> > >        VMADDR_CID_HOST, or it is bound to VMADDR_CID_ANY and there is=
 no=0A=
> > >        guest transport.=0A=
> > >        We could also define a new VMADDR_CID_LISTEN_FROM_GUEST in ord=
er to=0A=
> > >        address this case.=0A=
> > >        If we want to support multiple 'host side transport' running a=
t the=0A=
> > >        same time, we should find a way to allow an application to bou=
nd a=0A=
> > >        specific host transport (e.g. adding new VMADDR_CID_LISTEN_FRO=
M_KVM,=0A=
> > >        VMADDR_CID_LISTEN_FROM_VMWARE, VMADDR_CID_LISTEN_FROM_HYPERV)=
=0A=
> >=0A=
> > Hmm...VMADDR_CID_LISTEN_FROM_KVM, VMADDR_CID_LISTEN_FROM_VMWARE,=0A=
> > VMADDR_CID_LISTEN_FROM_HYPERV isn't very flexible.  What if my service=
=0A=
> > should only be available to a subset of VMware VMs?=0A=
>=0A=
> You're right, it is not very flexible.=0A=
=0A=
When I was last looking at this, I was considering a proposal where the inc=
oming traffic would determine which transport to use for CID_ANY in the cas=
e of multiple transports. For stream sockets, we already have a shared port=
 space, so if we receive a connection request for < port N, CID_ANY>, that =
connection would use the transport of the incoming request. The transport c=
ould either be a host->guest transport or the guest->host transport. This i=
s a bit harder to do for datagrams since the VSOCK port is decided by the t=
ransport itself today. For VMCI, a VMCI datagram handler is allocated for e=
ach datagram socket, and the ID of that handler is used as the port. So we =
would potentially have to register the same datagram port with all transpor=
ts.=0A=
=0A=
The use of network namespaces would be complimentary to this, and could be =
used to partition VMs between hypervisors or at a finer granularity. This c=
ould also be used to isolate host applications from guest applications usin=
g the same ports with CID_ANY if necessary.=0A=
=0A=
>=0A=
> >=0A=
> > Instead it might be more appropriate to use network namespaces to creat=
e=0A=
> > independent AF_VSOCK addressing domains.  Then you could have two=0A=
> > separate groups of VMware VMs and selectively listen to just one group.=
=0A=
> >=0A=
>=0A=
> Does AF_VSOCK support network namespace or it could be another=0A=
> improvement to take care? (IIUC is not currently supported)=0A=
>=0A=
> A possible issue that I'm seeing with netns is if they are used for=0A=
> other purpose (e.g. to isolate the network of a VM), we should have=0A=
> multiple instances of the application, one per netns.=0A=
>=0A=
> > >=0A=
> > >     b. use the 'guest side transport', if the socket is bound to loca=
l CID=0A=
> > >        different from the VMADDR_CID_HOST (guest CID get with=0A=
> > >        IOCTL_VM_SOCKETS_GET_LOCAL_CID), or it is bound to VMADDR_CID_=
ANY=0A=
> > >        (to be backward compatible).=0A=
> > >        Also in this case, we could define a new VMADDR_CID_LISTEN_FRO=
M_HOST.=0A=
> >=0A=
> > Two additional topics:=0A=
> >=0A=
> > 1. How will loading af_vsock.ko change?=0A=
>=0A=
> I'd allow the loading of af_vsock.ko without any transport.=0A=
> Maybe we should move the MODULE_ALIAS_NETPROTO(PF_VSOCK) from the=0A=
> vmci_transport.ko to the af_vsock.ko, but this can impact the VMware=0A=
> driver.=0A=
=0A=
As I remember it, this will impact the existing VMware products. I'll have =
to double check that.=0A=
=0A=
>=0A=
> >    In particular, can an=0A=
> >    application create a socket in af_vsock.ko without any loaded=0A=
> >    transport?  Can it enter listen state without any loaded transport=
=0A=
> >    (this seems useful with VMADDR_CID_ANY)?=0A=
>=0A=
> I'll check if we can allow listen sockets without any loaded transport,=
=0A=
> but I think could be a nice behaviour to have.=0A=
>=0A=
> >=0A=
> > 2. Does your proposed behavior match VMware's existing nested vsock=0A=
> >    semantics?=0A=
>=0A=
> I'm not sure, but I tried to follow the Jorgen's answers to the original=
=0A=
> thread. I hope that this proposal matches the VMware semantic.=0A=
=0A=
Yes, the semantics should be preserved.=0A=
=0A=
Thanks,=0A=
Jorgen=
