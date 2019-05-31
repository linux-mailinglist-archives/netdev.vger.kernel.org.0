Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C420030B69
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfEaJYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:24:54 -0400
Received: from mail-eopbgr780042.outbound.protection.outlook.com ([40.107.78.42]:31360
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfEaJYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVeefBjvLW68WMPeWOfgJ+1+zMlkNMnQirijFsttVfk=;
 b=udIVXAi17CEqwjJJChXNeVCChapygWgjuQJXfsXkYbv9e3eA2mI8lUCje0zUE6PXMySv999avgnCdoe1iBoL0FUz43oMZO8hDpzyOKRJd6JHnje2hdVOXdFrNgin+Tlzo44Dv8onD2jwFTvikl/jHJnzLpk4KgnUbc3Pwm3UWxo=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3069.namprd05.prod.outlook.com (10.173.229.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.10; Fri, 31 May 2019 09:24:49 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::e0b4:74fd:b16:b280]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::e0b4:74fd:b16:b280%6]) with mapi id 15.20.1943.018; Fri, 31 May 2019
 09:24:49 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu DASA <vdasa@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] vsock: proposal to support multiple transports at runtime
Thread-Topic: [RFC] vsock: proposal to support multiple transports at runtime
Thread-Index: AQHVCi09e2vAF3DRiEK8RdGpXTGFs6Z45mKAgAX3q4CAAcHDxYAC/vSAgAFyPgA=
Date:   Fri, 31 May 2019 09:24:49 +0000
Message-ID: <3B468856-C98D-4AFD-9369-24D39D77277F@vmware.com>
References: <20190514081543.f6nphcilgjuemlet@steredhat>
 <20190523153703.GC19296@stefanha-x1.localdomain>
 <20190527104447.gd23h2dsnmit75ry@steredhat>
 <MWHPR05MB3376D035CA84FB6189CC1BFFDA1E0@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20190530111935.ldcgif6kmyxelaag@steredhat.homenet.telecomitalia.it>
In-Reply-To: <20190530111935.ldcgif6kmyxelaag@steredhat.homenet.telecomitalia.it>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.9.1)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [83.92.5.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c546cff7-b257-44f0-5377-08d6e5a9d490
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR05MB3069;
x-ms-traffictypediagnostic: MWHPR05MB3069:
x-microsoft-antispam-prvs: <MWHPR05MB30691F7A9583507F009AC82CDA190@MWHPR05MB3069.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(136003)(366004)(39860400002)(189003)(199004)(86362001)(66446008)(476003)(446003)(91956017)(33656002)(99286004)(64756008)(81166006)(256004)(53546011)(82746002)(66476007)(14444005)(316002)(2616005)(186003)(478600001)(81156014)(5660300002)(11346002)(66946007)(66556008)(486006)(26005)(14454004)(73956011)(54906003)(102836004)(6916009)(76116006)(8676002)(6116002)(25786009)(68736007)(66066001)(561944003)(8936002)(7736002)(36756003)(229853002)(6246003)(83716004)(6512007)(6436002)(2906002)(6506007)(50226002)(57306001)(76176011)(71190400001)(71200400001)(3846002)(6486002)(53936002)(4326008)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3069;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 809mvHM9eHzdY/39o+kAOmMW42L18rAN7RyJZ520oE1kfFtn2aR+qBzur9zICUVYUbeZhd3OCygbBdmXxGTi9alfIq1Wre8JK/94Bla/MKjcpaiv2cGjOljVAvqE6XNxXNwQ32GsQB+WyplYZk6S+MV/3sidYtBHt/SeoYZGByOZrTXScOYr5edssO8f3a4bYVQWRcPDVy8/UD+sR8sNHUIm03lQ8I+XJSxIWrKnt1bSYLtgRnOJ79fzEa1X0lKRcUtnePoUBl+Y6d/WrYrD7uOVbNqqwGW9axVFkpakzaQT8xpZ+D9NW21WFpbSLvuouiq+qirzTkqlQKvujP666uvYnfhAvUTIq+x6gM2cuQ4ZIbHhNAdZoyjj/gUywIBy2wI6w8Nhy+NYe3pFgd5zSUijG2AqJ59drcpcUX5kMSM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <397F5DBC63F8A54B8D266AB74F251B35@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c546cff7-b257-44f0-5377-08d6e5a9d490
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 09:24:49.6816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jhansen@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30 May 2019, at 13:19, Stefano Garzarella <sgarzare@redhat.com> wrote:
>=20
> On Tue, May 28, 2019 at 04:01:00PM +0000, Jorgen Hansen wrote:
>>> On Thu, May 23, 2019 at 04:37:03PM +0100, Stefan Hajnoczi wrote:
>>>> On Tue, May 14, 2019 at 10:15:43AM +0200, Stefano Garzarella wrote:
>=20
>>>>>=20
>>>>>=20
>>>>> 2. listen() / recvfrom()
>>>>>=20
>>>>>    a. use the 'host side transport', if the socket is bound to
>>>>>       VMADDR_CID_HOST, or it is bound to VMADDR_CID_ANY and there is =
no
>>>>>       guest transport.
>>>>>       We could also define a new VMADDR_CID_LISTEN_FROM_GUEST in orde=
r to
>>>>>       address this case.
>>>>>       If we want to support multiple 'host side transport' running at=
 the
>>>>>       same time, we should find a way to allow an application to boun=
d a
>>>>>       specific host transport (e.g. adding new VMADDR_CID_LISTEN_FROM=
_KVM,
>>>>>       VMADDR_CID_LISTEN_FROM_VMWARE, VMADDR_CID_LISTEN_FROM_HYPERV)
>>>>=20
>>>> Hmm...VMADDR_CID_LISTEN_FROM_KVM, VMADDR_CID_LISTEN_FROM_VMWARE,
>>>> VMADDR_CID_LISTEN_FROM_HYPERV isn't very flexible.  What if my service
>>>> should only be available to a subset of VMware VMs?
>>>=20
>>> You're right, it is not very flexible.
>>=20
>> When I was last looking at this, I was considering a proposal where
>> the incoming traffic would determine which transport to use for
>> CID_ANY in the case of multiple transports. For stream sockets, we
>> already have a shared port space, so if we receive a connection
>> request for < port N, CID_ANY>, that connection would use the
>> transport of the incoming request. The transport could either be a
>> host->guest transport or the guest->host transport. This is a bit
>> harder to do for datagrams since the VSOCK port is decided by the
>> transport itself today. For VMCI, a VMCI datagram handler is allocated
>> for each datagram socket, and the ID of that handler is used as the
>> port. So we would potentially have to register the same datagram port
>> with all transports.
>=20
> So, do you think we should implement a shared port space also for
> datagram sockets?

Yes, having the two socket types work the same way seems cleaner to me. We =
should at least cover it in the design.

> For now only the VMWare implementation supports the datagram sockets,
> but in the future we could support it also on KVM and HyperV, so I think
> we should consider it in this proposal.

So for now, it sounds like we could make the VMCI transport the default tra=
nsport for any host side datagram socket, then.

>>=20
>> The use of network namespaces would be complimentary to this, and
>> could be used to partition VMs between hypervisors or at a finer
>> granularity. This could also be used to isolate host applications from
>> guest applications using the same ports with CID_ANY if necessary.
>>=20
>=20
> Another point to the netns support, I'll put it in the proposal (or it
> could go in parallel with the multi-transport support).
>=20

It should be fine to put in the proposal that we rely on namespaces to prov=
ide this support, but pursue namespaces as a separate project.

Thanks,
Jorgen=
