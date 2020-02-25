Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1F516B93C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgBYFoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:44:08 -0500
Received: from mail-eopbgr1300098.outbound.protection.outlook.com ([40.107.130.98]:49755
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbgBYFoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 00:44:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xcb8Oa/oFANdDUXq5AzJSZK/J/PwXJLCrif76rxvJGrXy8IA6JBUgHsdb0Arc0uj4qEC2iA4ntv8cOxGOB7vgdmn1kL1xGstjCxKIhAdQM/dF6FJ/YMbt5NuM3V2IP+GwUVQ0+SHH73yVgrBtqSnjgMicl5cCfaetYaLxTb6vQo7okLIQ0TZdGHFw9p5SB0gEQNxizmFU3xUNp7Z2CSuYY9AY8Q8suoEpUsJPjoGH4jn6TZoBibYw/qJm1DO8Wt2zUuuJzxsPvBJfYqecvIBD2YovrFZaF2dnei/047/gRhaRGNA16SwXqP6ieDKEKr1b4RuX6pcRPANP/+VnCnuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJ544hrnEvPO4y3apa1/ZMmRMPQl/dOGTkbKlXDPPxc=;
 b=Lzqh2Ug+y96+iRAPdD90sYF8aJAoVgs/St3lLIe7xGqdjbobKe7dA1xrGQhLw01SY8Nm76PQ9iY2i7oHOwtI7dxXdPgje+hoFyvyUB3pEBPTovOuLAs1hsck+aOWjTof0av4o5pxa3M/9NyvEYcyZnQgr2YqKLnjPLe/fWJ11W2lL9Tr36HchsSfw/1dxH4vYh0I/tQvrfWxFrG+X+CAbHWgJa3L/CpE3nUSFe4Uq3rbhXZYAIK+Pwu6Ej+DtJBHy2QUQ7ZZTvPX0i7Se36javZ53Qwu8zfreuMuEfYvJDszdMWl5CZONnYY0hekQ3cuCnSJx9YX87R0H7uxHEwnPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJ544hrnEvPO4y3apa1/ZMmRMPQl/dOGTkbKlXDPPxc=;
 b=aXgNOssTUHDQ7wfRHYvzF31ANtA7D/Bd+/5Jch1/I48D33bl5QeY5LxRinJcg1H501ik1/rIMq3skLVww+zjrKrmD2bQbbKMSva/wK8h/tnmOwwJyG13TqrN7VVFrbKlfn0u4nrEex02i7Wiraf2ubQQYUuZEVqDrGEMH8Tr6mg=
Received: from HK0P153MB0148.APCP153.PROD.OUTLOOK.COM (52.133.156.139) by
 HK0P153MB0323.APCP153.PROD.OUTLOOK.COM (52.132.237.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.1; Tue, 25 Feb 2020 05:44:03 +0000
Received: from HK0P153MB0148.APCP153.PROD.OUTLOOK.COM
 ([fe80::a02a:44fa:5f1:dd74]) by HK0P153MB0148.APCP153.PROD.OUTLOOK.COM
 ([fe80::a02a:44fa:5f1:dd74%2]) with mapi id 15.20.2793.003; Tue, 25 Feb 2020
 05:44:03 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Hillf Danton <hdanton@sina.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
CC:     syzbot <syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: INFO: task hung in lock_sock_nested (2)
Thread-Topic: INFO: task hung in lock_sock_nested (2)
Thread-Index: AQHV6vp3dmjBMCIIPkOhqBCQTbJmP6gq7WJg
Date:   Tue, 25 Feb 2020 05:44:03 +0000
Message-ID: <HK0P153MB0148B4C74BA6A60E295A03D8BFED0@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
References: <0000000000004241ff059f2eb8a4@google.com>
 <20200223075025.9068-1-hdanton@sina.com>
 <20200224100853.wd67e7rqmtidfg7y@steredhat>
In-Reply-To: <20200224100853.wd67e7rqmtidfg7y@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-02-25T05:44:01.4499098Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d56ff2b7-befc-4546-a08f-b67215e9b71c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:b028:3e64:8d77:da03]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0e07591d-bb34-408e-52cb-08d7b9b5b8ec
x-ms-traffictypediagnostic: HK0P153MB0323:
x-microsoft-antispam-prvs: <HK0P153MB03239F97DA1BD1B151625EE9BFED0@HK0P153MB0323.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(189003)(199004)(86362001)(81166006)(7696005)(8936002)(8990500004)(8676002)(5660300002)(71200400001)(6506007)(9686003)(55016002)(186003)(478600001)(10290500003)(316002)(52536014)(76116006)(66946007)(54906003)(66556008)(4326008)(66446008)(81156014)(64756008)(110136005)(66476007)(33656002)(2906002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:HK0P153MB0323;H:HK0P153MB0148.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v9cCIv7Mcf7+9RH0cjq0gRZ6SYEuGMIbcwvZXJqYLGGMSAjwM/PzkJxTqePvoXKgZGq9ZOG/PVdNYQ7Pl5qrkELTVQ66qu4/spqQgGMMPO0jIAZCft+TEO349xly3PxiyI5C8U9ISsjTqnzGE5QZ45KY4HCnXsA145B9MyjryvxAr2A2mTcH4YYDYqCPbWtGTbr89H+CCX6eTVKGAnDbwU+1hz836urq1mpewz8TeK3GJEPzPfblRoGRGlvl7T/QI6J9T4nCQtWN2dRTySmV6szJPgXcF5LOTU9cImnkuGaqi5GGwFJ2U/yQRxtnXRnTG/FCjkQFxOEgSAJwA+La9eB7HEqI7rIygb4uneiYHNX4Jb7TbBb2rZwmw3Nmi/LNvqZRqh2+53gDEbOSItmf9V5WTfFIUqhuPfKIRH8s9QpJsAeslB8xVA9ix08aCKKt
x-ms-exchange-antispam-messagedata: QftfeL3GIGVBZ6K7+3W/Sn88F41hnZRawL4vx2prJuJwYcpwdwvSvz+w4gZDARfWjh3Lt71uBBxm/AP2pEfNn9ri/nXod/r2TvyoRmDo54YdfE9xZKCJJzd0jZmisTTOJBJv8pjhfAAhX0S6V+g5PGBlErqaoS7zfYU0HItAgSTxYcBRjCWPip/TBb0MnwJnaJzevLM41XHsf+h2Wl9OXQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e07591d-bb34-408e-52cb-08d7b9b5b8ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 05:44:03.4761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ZSCqWt4vyQlVnXpWJS77SEPzyx2Me4wK9M9dn9y1RWwgNIlC6anJT2PTL0CMuDR/kiAp4rFnBuH0ZgXd6Iz3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0323
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Monday, February 24, 2020 2:09 AM
> ...
> > > syz-executor280 D27912  9768   9766 0x00000000
> > > Call Trace:
> > >  context_switch kernel/sched/core.c:3386 [inline]
> > >  __schedule+0x934/0x1f90 kernel/sched/core.c:4082
> > >  schedule+0xdc/0x2b0 kernel/sched/core.c:4156
> > >  __lock_sock+0x165/0x290 net/core/sock.c:2413
> > >  lock_sock_nested+0xfe/0x120 net/core/sock.c:2938
> > >  virtio_transport_release+0xc4/0xd60
> net/vmw_vsock/virtio_transport_common.c:832
> > >  vsock_assign_transport+0xf3/0x3b0 net/vmw_vsock/af_vsock.c:454
> > >  vsock_stream_connect+0x2b3/0xc70 net/vmw_vsock/af_vsock.c:1288
> > >  __sys_connect_file+0x161/0x1c0 net/socket.c:1857
> > >  __sys_connect+0x174/0x1b0 net/socket.c:1874
> > >  __do_sys_connect net/socket.c:1885 [inline]
> > >  __se_sys_connect net/socket.c:1882 [inline]
> > >  __x64_sys_connect+0x73/0xb0 net/socket.c:1882
> > >  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294

My understanding about the call trace is: in vsock_stream_connect()=20
after we call lock_sock(sk), we call vsock_assign_transport(), which may
call vsk->transport->release(vsk), i.e. virtio_transport_release(), and in
virtio_transport_release() we try to get the same lock and hang.

> > Seems like vsock needs a word to track lock owner in an attempt to
> > avoid trying to lock sock while the current is the lock owner.

I'm unfamilar with the g2h/h2g :-)=20
Here I'm wondering if it's acceptable to add an 'already_locked'
parameter like this:
  bool already_locked =3D true;
  vsk->transport->release(vsk, already_locked) ?
=20
> Thanks for this possible solution.
> What about using sock_owned_by_user()?
=20
> We should fix also hyperv_transport, because it could suffer from the sam=
e
> problem.

IIUC hyperv_transport doesn't supprot the h2g/g2h feature, so it should not
suffers from the deadlock issue here?

> At this point, it might be better to call vsk->transport->release(vsk)
> always with the lock taken and remove it in the transports as in the
> following patch.
>=20
> What do you think?
>=20
>=20
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 9c5b2a91baad..a073d8efca33 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -753,20 +753,18 @@ static void __vsock_release(struct sock *sk, int
> level)
>  		vsk =3D vsock_sk(sk);
>  		pending =3D NULL;	/* Compiler warning. */
>=20
> -		/* The release call is supposed to use lock_sock_nested()
> -		 * rather than lock_sock(), if a sock lock should be acquired.
> -		 */
> -		if (vsk->transport)
> -			vsk->transport->release(vsk);
> -		else if (sk->sk_type =3D=3D SOCK_STREAM)
> -			vsock_remove_sock(vsk);
> -
>  		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
>  		 * version to avoid the warning "possible recursive locking
>  		 * detected". When "level" is 0, lock_sock_nested(sk, level)
>  		 * is the same as lock_sock(sk).
>  		 */
>  		lock_sock_nested(sk, level);
> +
> +		if (vsk->transport)
> +			vsk->transport->release(vsk);
> +		else if (sk->sk_type =3D=3D SOCK_STREAM)
> +			vsock_remove_sock(vsk);
> +
>  		sock_orphan(sk);
>  		sk->sk_shutdown =3D SHUTDOWN_MASK;
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c
> b/net/vmw_vsock/hyperv_transport.c
> index 3492c021925f..510f25f4a856 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -529,9 +529,7 @@ static void hvs_release(struct vsock_sock *vsk)
>  	struct sock *sk =3D sk_vsock(vsk);
>  	bool remove_sock;
>=20
> -	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
>  	remove_sock =3D hvs_close_lock_held(vsk);
> -	release_sock(sk);
>  	if (remove_sock)
>  		vsock_remove_sock(vsk);
>  }

This looks good to me, but do we know why vsk->transport->release(vsk)
is called without holding the lock for 'sk' in the first place?

Thanks,
Dexuan

