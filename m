Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4091E8CC8
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 03:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgE3BOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 21:14:30 -0400
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:12423
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728293AbgE3BO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 21:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dcqb1DSJMMZZH44ArLQKv8JqmUEnupkIdIs4TZLhCk=;
 b=jSrovo9EmEXx3EmPRkkCg/8mLhJZwIcPUWVykUspibqA0mvXNw1aXvLiSzPyRJie9rJaME3xNjIZMP8t3RezHY/Ptq+fb5T04DEeVrY/1HgKOCpHg/S5VTRJQL0684dX88Lmr4B1ZWpGdODthprgtk245dsY2215+/lSy9KYLzg=
Received: from MR2P264CA0074.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:32::14)
 by DB7PR08MB3004.eurprd08.prod.outlook.com (2603:10a6:5:1c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Sat, 30 May
 2020 01:14:23 +0000
Received: from VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:32:cafe::87) by MR2P264CA0074.outlook.office365.com
 (2603:10a6:500:32::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend
 Transport; Sat, 30 May 2020 01:14:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT046.mail.protection.outlook.com (10.152.19.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Sat, 30 May 2020 01:14:22 +0000
Received: ("Tessian outbound b157666c5529:v57"); Sat, 30 May 2020 01:14:22 +0000
X-CR-MTA-TID: 64aa7808
Received: from a9416762e1b5.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 82C59234-AA46-402C-9233-53E482E74DF0.1;
        Sat, 30 May 2020 01:14:17 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a9416762e1b5.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sat, 30 May 2020 01:14:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ol4BBsjhhSRiYC4DR8LBkGlk3aOmAxXTlKGP1k61U4bM2hOeg3YHfn4j1ZMEFrr7G0IqNjfIP9dxPAKGIwsjsIAu2mtD62aiGVCCAdonEUI3dlcRD2INEw5VWwB6y7KtXdz2jgnwW3VCZvGIwGXqCSsXz7FGaORV2mMC2u1/YNPa47vuEiyG+dxFmSvRccc7TjSdvZxKD96TdDD8BgyPw0cVYWzWmQy3lfML1gJ1/8LLnwtRznspV2gvxtAINjTF50GBRSxrQiqIe5DsNBwmrmkBdFGeKQfnBkbahvTR0h/RfJA6+PnjaKYxUD78TT4QysNDnfiPDr42B/mJwpD4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dcqb1DSJMMZZH44ArLQKv8JqmUEnupkIdIs4TZLhCk=;
 b=Gd3SQJLkMJJWdsE+95gb6zR+jP1CLrVYlrynO/aVgLI+Mwnc4jM8FOHGTTsIwU/HGs10Rk/plx1M7RUVm15QCenrNrb7+1X7Yj56aeRXapMDX0xRbd8gVQTJVVWellodGvYpU9rj5IQTfRxlHuJjxTQOAKodnqPqXalpcT5DbuKG65yaH+aluPJPEzk/0iqRmirN/ejXE5DM1o0wgDXfy87jEQQNZfQiWmcQAGW6I5sA29MmjrleOOX8COlWhCURbJaWmvlgLlg3srqaWOFmLFEh7l2l5IzHxSIkhy/rNUxLvgeI/NVWX3yWvTS+MiuxYN2pmuFeuqd5PNpqm5Rcdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dcqb1DSJMMZZH44ArLQKv8JqmUEnupkIdIs4TZLhCk=;
 b=jSrovo9EmEXx3EmPRkkCg/8mLhJZwIcPUWVykUspibqA0mvXNw1aXvLiSzPyRJie9rJaME3xNjIZMP8t3RezHY/Ptq+fb5T04DEeVrY/1HgKOCpHg/S5VTRJQL0684dX88Lmr4B1ZWpGdODthprgtk245dsY2215+/lSy9KYLzg=
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com (2603:10a6:20b:af::32)
 by AM6PR08MB4343.eurprd08.prod.outlook.com (2603:10a6:20b:ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Sat, 30 May
 2020 01:14:15 +0000
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0]) by AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0%5]) with mapi id 15.20.3021.031; Sat, 30 May 2020
 01:14:15 +0000
From:   Justin He <Justin.He@arm.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaly Xin <Kaly.Xin@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Thread-Topic: [PATCH v2] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Thread-Index: AQHWNcziU+BZVxkkR0u4Tcyr1QL4sKi/Ql4AgACQY1A=
Date:   Sat, 30 May 2020 01:14:15 +0000
Message-ID: <AM6PR08MB40691DD26C69D5BA3F2D3468F78C0@AM6PR08MB4069.eurprd08.prod.outlook.com>
References: <20200529152102.58397-1-justin.he@arm.com>
 <20200529163412.fqswshs65f53qgez@steredhat>
In-Reply-To: <20200529163412.fqswshs65f53qgez@steredhat>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: a30fce08-ca14-40b1-a291-dc601566b059.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [223.166.32.90]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0cd4f977-5146-4a3a-704c-08d80436c982
x-ms-traffictypediagnostic: AM6PR08MB4343:|DB7PR08MB3004:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB3004CA7BC2DACF00687FA33AF78C0@DB7PR08MB3004.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1417;OLM:10000;
x-forefront-prvs: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: GcY4bwNS/767LP5d5D7z9ECSQXSS8XiUNnHGWKjtLbbH3/Pji3XXbuOdEweEf9IviiYaZnoxzxzoIaKtNcbP6MSYH430bpQUf5DR9M06h+mjPo4GtmvAu13ETdHdjzxgZa8UEkCp97IY7xfr1udNpLP5S+6RtlRGjiHfGbNwMdpHu0j27RZBbmk2d2zfKeE3Tjl7HXzoVeKJGocxFwVtYBsso7udD+b+bavidPuow6l0QN6gARAWKoX4BHccnajdIDJn7i/xYyoqi8Y7lLtSTF0RWXz/fUWNrOQ4014B3ns6XnBrcI/L7w8uMHiAEdoKXp/MqydcKWmdxZZ9L9qhNg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4069.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(26005)(6506007)(53546011)(2906002)(86362001)(83380400001)(8936002)(478600001)(7696005)(6916009)(8676002)(76116006)(66946007)(71200400001)(66446008)(52536014)(66476007)(64756008)(66556008)(54906003)(5660300002)(33656002)(55016002)(4326008)(186003)(9686003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SEuL1fWmbOm4VJZuSfqK8EfLSWrkYgpddP7nBoctgjeSGL+iBWd5BCK1F7sAPTXz34pQZuqp77VvDfoJumPhZCLBr4ha1eHV4cqt9NCPC/iFBTY12feS3vp8xo6Jpn+pCMncVD1PyOutsOEB1VoMrTIuddmqbyCjPhVybqkT84d21XiQOC8eWeGpTikoJD+I95V6AOqZdguE3GODhRXEor25N1gHecTDL1EtUr9cWUG7yvvWEqKQpvdQs89T6JfsZU8Ecg8rvFZHfCPdPhwd3BUdR0nXL8yy2OEpP1Sjum/eUJliF4Rkaqt9xEKb3nldaeN0VuWZzM8JqRP2ja8vuqtwvL6hKF1B7YSrPY2TX8l2WXg7IMAj08XAWLqXimbFPZ2CPqgSEFjFHNYIyu9wqDGXhe7CLychlZxlJErAdUh0Na2U6gN5sqZtz6d7GIMrNU7jTJgW7WsMzv60mImq5tVd6LAjEnEOh93e5AFIpng=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4343
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966005)(70586007)(2906002)(70206006)(4326008)(478600001)(7696005)(6862004)(186003)(52536014)(450100002)(336012)(86362001)(9686003)(316002)(26005)(8676002)(55016002)(8936002)(36906005)(47076004)(33656002)(53546011)(54906003)(5660300002)(83380400001)(6506007)(356005)(81166007)(82310400002)(82740400003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: f299b6f6-d358-4953-ff88-08d80436c519
X-Forefront-PRVS: 041963B986
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbZYhBKweWXDfbkin+i6zjA1SmObSAaBbbZWCJLwSHic/Q+aQ7X6AqFc9eUB1j3CrhaapEbJZgvELWZXcGksxaCAqDSzodJH5EH8Vz85N2RuX+QsTYgwe0VwYXrf/3rVL0DEdHzhLA4kyxc3OiZ6bpxwPwt558M0uQUyzlu6h8+I5g7bxD61Y/kEeu75IbMIgMFASV8XN42pCul0gI6QGUnRLdFyqbgQTnZhUHVK1v3uOp8C3i3OdnsDzWBeIKGWTNNYa6juxMRW0nV0xnf3t0btVPVQLdjs+6Nqv5Cwq1EM6WLvc0er9dQLjdGPOf4udRrm1GIQdY3gOWhs/Nk9uyyeTJrD1Mv2cIjiFRPyHaXaHHTRMppgMEokIto8JVq3EvblDTKJh5Br5S3xDTVypw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 01:14:22.5920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd4f977-5146-4a3a-704c-08d80436c982
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3004
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano

> -----Original Message-----
> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Saturday, May 30, 2020 12:34 AM
> To: Justin He <Justin.He@arm.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Kaly Xin
> <Kaly.Xin@arm.com>; stable@vger.kernel.org
> Subject: Re: [PATCH v2] virtio_vsock: Fix race condition in
> virtio_transport_recv_pkt
>
> On Fri, May 29, 2020 at 11:21:02PM +0800, Jia He wrote:
> > When client tries to connect(SOCK_STREAM) the server in the guest with
> > NONBLOCK mode, there will be a panic on a ThunderX2 (armv8a server):
> > [  463.718844][ T5040] Unable to handle kernel NULL pointer dereference
> at virtual address 0000000000000000
> > [  463.718848][ T5040] Mem abort info:
> > [  463.718849][ T5040]   ESR =3D 0x96000044
> > [  463.718852][ T5040]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > [  463.718853][ T5040]   SET =3D 0, FnV =3D 0
> > [  463.718854][ T5040]   EA =3D 0, S1PTW =3D 0
> > [  463.718855][ T5040] Data abort info:
> > [  463.718856][ T5040]   ISV =3D 0, ISS =3D 0x00000044
> > [  463.718857][ T5040]   CM =3D 0, WnR =3D 1
> > [  463.718859][ T5040] user pgtable: 4k pages, 48-bit VAs,
> pgdp=3D0000008f6f6e9000
> > [  463.718861][ T5040] [0000000000000000] pgd=3D0000000000000000
> > [  463.718866][ T5040] Internal error: Oops: 96000044 [#1] SMP
> > [...]
> > [  463.718977][ T5040] CPU: 213 PID: 5040 Comm: vhost-5032 Tainted: G
> O      5.7.0-rc7+ #139
> > [  463.718980][ T5040] Hardware name: GIGABYTE R281-T91-00/MT91-FS1-00,
> BIOS F06 09/25/2018
> > [  463.718982][ T5040] pstate: 60400009 (nZCv daif +PAN -UAO)
> > [  463.718995][ T5040] pc : virtio_transport_recv_pkt+0x4c8/0xd40
> [vmw_vsock_virtio_transport_common]
> > [  463.718999][ T5040] lr : virtio_transport_recv_pkt+0x1fc/0xd40
> [vmw_vsock_virtio_transport_common]
> > [  463.719000][ T5040] sp : ffff80002dbe3c40
> > [...]
> > [  463.719025][ T5040] Call trace:
> > [  463.719030][ T5040]  virtio_transport_recv_pkt+0x4c8/0xd40
> [vmw_vsock_virtio_transport_common]
> > [  463.719034][ T5040]  vhost_vsock_handle_tx_kick+0x360/0x408
> [vhost_vsock]
> > [  463.719041][ T5040]  vhost_worker+0x100/0x1a0 [vhost]
> > [  463.719048][ T5040]  kthread+0x128/0x130
> > [  463.719052][ T5040]  ret_from_fork+0x10/0x18
>          ^         ^
> Maybe we can remove these two columns from the commit message.
>
> >
> > The race condition as follows:
> > Task1                            Task2
> > =3D=3D=3D=3D=3D                            =3D=3D=3D=3D=3D
> > __sock_release                   virtio_transport_recv_pkt
> >   __vsock_release                  vsock_find_bound_socket (found)
> >     lock_sock_nested
> >     vsock_remove_sock
> >     sock_orphan
> >       sk_set_socket(sk, NULL)
>
> Here we can add:
>       sk->sk_shutdown =3D SHUTDOWN_MASK;

Indeed. This makes it more clearly

--
Cheers,
Justin (Jia He)


>
> >     ...
> >     release_sock
> >                                 lock_sock
> >                                    virtio_transport_recv_connecting
> >                                      sk->sk_socket->state (panic)
> >
> > The root cause is that vsock_find_bound_socket can't hold the lock_sock=
,
> > so there is a small race window between vsock_find_bound_socket() and
> > lock_sock(). If there is __vsock_release() in another task, sk->sk_sock=
et
> > will be set to NULL inadvertently.
> >
> > This fixes it by checking sk->sk_shutdown.
> >
> > Signed-off-by: Jia He <justin.he@arm.com>
> > Cc: stable@vger.kernel.org
> > Cc: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> > v2: use lightweight checking suggested by Stefano Garzarella
> >
> >  net/vmw_vsock/virtio_transport_common.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> > index 69efc891885f..0edda1edf988 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -1132,6 +1132,14 @@ void virtio_transport_recv_pkt(struct
> virtio_transport *t,
> >
> >  lock_sock(sk);
> >
> > +/* Check if sk has been released before lock_sock */
> > +if (sk->sk_shutdown =3D=3D SHUTDOWN_MASK) {
> > +(void)virtio_transport_reset_no_sock(t, pkt);
> > +release_sock(sk);
> > +sock_put(sk);
> > +goto free_pkt;
> > +}
> > +
> >  /* Update CID in case it has changed after a transport reset event */
> >  vsk->local_addr.svm_cid =3D dst.svm_cid;
> >
> > --
> > 2.17.1
> >
>
> Anyway, the patch LGTM, let see what David and other say.
>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>
> Thanks,
> Stefano

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
