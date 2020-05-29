Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128FF1E8158
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgE2PLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:11:37 -0400
Received: from mail-am6eur05on2059.outbound.protection.outlook.com ([40.107.22.59]:14615
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgE2PLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 11:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md4aWPqHk39ExWe08Xb6XkL9EhU+Vny00hrACFdYc/s=;
 b=jw6rsYxbSErd9p1u2b8GhB8UXtfnfxxB8BG1zX16JytUgZxPoDup48srWzEyVqOx2k3aONlSREHPRB4Opwem/d/d+s1nvto9EVw1cv+yenDmDHghmVHksff97YKkcSGz79WJ/E0VOtRijFbJCEImzUY1OqyRqNpPnCga5PqW3sg=
Received: from DB8PR03CA0002.eurprd03.prod.outlook.com (2603:10a6:10:be::15)
 by AM0PR08MB5314.eurprd08.prod.outlook.com (2603:10a6:208:184::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 15:11:31 +0000
Received: from DB5EUR03FT014.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:be:cafe::1a) by DB8PR03CA0002.outlook.office365.com
 (2603:10a6:10:be::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend
 Transport; Fri, 29 May 2020 15:11:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT014.mail.protection.outlook.com (10.152.20.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Fri, 29 May 2020 15:11:31 +0000
Received: ("Tessian outbound cff7dd4de28a:v57"); Fri, 29 May 2020 15:11:31 +0000
X-CR-MTA-TID: 64aa7808
Received: from b8e7cc468349.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id CE55B22E-6CCF-4970-B6E7-19B24865799B.1;
        Fri, 29 May 2020 15:11:26 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b8e7cc468349.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 29 May 2020 15:11:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnN9D8r7UmZSmNrPscqPdV0wZBme3dcLA5Yr5QE5TdDthHKlIENJJ0gZ+CCU/UwPx4te2OSfAugTGCICNnqF1VGtio2Z3WwMLli98cM8FxHRQBMoe6VXAap4KOQ4xernXTs6NOV47fmbef8v8ZpExZIt9ejqHVIMQKlLP9KKzF9SE35g4HgepPwPHcZBkNrxQhhlCqzlRsS2EecxqFATbOR0FlflXkbJkFSNOyOsfgNGxtOvyfRvDqo19MM7+RNknQBpt86ROQuyvshIIeKgXRXAG18mqI88Se4gwrdPuDqRjLqJNvuLsrb7a3nt5WEqAcYDO8uxKUw0CGmiVY03Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md4aWPqHk39ExWe08Xb6XkL9EhU+Vny00hrACFdYc/s=;
 b=i2lPH0+zFwmvR847RmzMyAgMaX+pdPSuMrWy7yOPp3uqgNzhjhMFkRoFT1OCkTUas/EJSQXtBX8b2Y0Z7fbqEcqn+WFkQWtHo5BBM75eC4FAGvGvWLZQRgLyV2MBA13HCFpVzbgHNOMFYCWucGTs/+iNhD9wAHl2jG2sWaMRN0fw8ap1jZIhY4BS3aSyyyZtWPnJQKkel8E8P16gu2o2S9hBYpsw5KTviyPl2NzpIO2/m7jZGGMTljw63qehLw5TFd3FYTZm7Pqi+xZKTPAM6s3ybCo6HAT9FdLhiDhhi2t0471bw2z6Q/OhfREyJfLWtJurCZyvs0HIet+l+KCI2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md4aWPqHk39ExWe08Xb6XkL9EhU+Vny00hrACFdYc/s=;
 b=jw6rsYxbSErd9p1u2b8GhB8UXtfnfxxB8BG1zX16JytUgZxPoDup48srWzEyVqOx2k3aONlSREHPRB4Opwem/d/d+s1nvto9EVw1cv+yenDmDHghmVHksff97YKkcSGz79WJ/E0VOtRijFbJCEImzUY1OqyRqNpPnCga5PqW3sg=
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com (2603:10a6:20b:af::32)
 by AM6PR08MB3207.eurprd08.prod.outlook.com (2603:10a6:209:42::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 15:11:25 +0000
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0]) by AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0%5]) with mapi id 15.20.3021.031; Fri, 29 May 2020
 15:11:25 +0000
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
Subject: RE: [PATCH] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Thread-Topic: [PATCH] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Thread-Index: AQHWNb3NFZ7FWfLNOU+TupO//UXkNai/GlmAgAAQR7A=
Date:   Fri, 29 May 2020 15:11:25 +0000
Message-ID: <AM6PR08MB4069FC4405535635177ACC6DF78F0@AM6PR08MB4069.eurprd08.prod.outlook.com>
References: <20200529133123.195610-1-justin.he@arm.com>
 <20200529141033.iqtmu3giph6dekuj@steredhat>
In-Reply-To: <20200529141033.iqtmu3giph6dekuj@steredhat>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: c30add3c-07d6-4291-9f2b-5f482f241b86.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb07e706-1e15-4440-a906-08d803e291ce
x-ms-traffictypediagnostic: AM6PR08MB3207:|AM0PR08MB5314:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB5314B969CDAC5BCA260B437EF78F0@AM0PR08MB5314.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: O9fCRXdIqdKGSgn61uIgMJv7qi48iZdMzkCUkgKCy/EZ68ecPS+hDmOSQ21U4dC6S0CJUFMrKkmzuB70r49GmJjzzHnweQsEGejeOBOARwSPpP1o3VnLLK76uNxpVZVzIdSs0m/CKmYcMmQ2+uS3ZanOEyxjt/3CRenlb8LDTSJZRa5ST2bxagLmnOGM8ofgCQeTM7gYq4NHs1ighR1VG2encXZMXzHRMzcg/yezFIKB2J+nuQiALsPFV+zjGfayOs1ne3e7DSOoFu+JjmnSkQaqQ9iGY14GUQQh2SZDDmAcHRYa6XPg35rsqrMGNN401tlHPBrEP5GkPPwqsWyOqQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4069.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(86362001)(76116006)(5660300002)(66946007)(186003)(6916009)(55016002)(9686003)(8676002)(8936002)(26005)(52536014)(71200400001)(66556008)(66446008)(66476007)(64756008)(4326008)(478600001)(316002)(6506007)(83380400001)(54906003)(2906002)(53546011)(33656002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: O7DpK9Y04G3mVN8Fi6O2wChYD2OPEQSewzqtau282LD20+1SU+rsW63zVXcYa3d++7GkltuC9qIOGTk3omRM1phkN9juBk4o63/dxULQxpQXczyVvL7am3NAsj+yQyby/kgLH7FFJgtIKaxBJE28Nxuve3fOXtsXwC3yyDUVNw6v/krNWqm14ccif9c+U05a1mwFNFvzmDdfJZWPyHojWCqgemZms5+aE2DrjwONE+HMOUotTWpZldYZeb2MbRlYvSOhnqnV6+68AzvucLy8cLXc5dzuy1MjeqP7x/95P+5YWbkJcYeZiaGT2nvgnk6gYLzk9UCMSke5oE8f7M+l6Odn4h+itdb9sOglQftkgFZ5ll+g2zHnvP8uT4ZjkEpLiCS+ucwKPsHIKshWNxHvGWyC4Bpxmh94W5g0rSqRaQoypZy5xUTpFCzrVJ1U26GLnt7oRuQFoA9fLzMsl27e5wf+l2FP/0xEekFBCJ/iYyQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3207
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT014.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966005)(336012)(33656002)(82740400003)(5660300002)(47076004)(450100002)(4326008)(356005)(26005)(6506007)(186003)(53546011)(54906003)(83380400001)(82310400002)(8676002)(7696005)(8936002)(9686003)(55016002)(70586007)(70206006)(478600001)(52536014)(86362001)(2906002)(6862004)(316002)(81166007);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 93bd0942-5888-4333-7582-08d803e28e03
X-Forefront-PRVS: 04180B6720
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y6ptzwRo+Q88Nn19v8155GBE8+3S4dHfOGD0a9uXmR7PB/Xei8XiahuigD1X99gxE9HWA6epse2AEeOUjvQKQMzfROREBDjmxYGsRfpm1VIa8rQIIc21gToLT5eYT7x6up5K7KTOsVeoXTRB5GEECS5K2aHu9d5/hy4cDkLRgA/RVCwebo9KlzxxjsQxoEKangeZ1Lh+VvxEVFKu1NVB1IIPswGAwJb/hXaf23sbxZzUZp0QH358ez/oAXB45WEw1FHLI+2qHKzkPK/eGVIlREjScVuBGuI8LNuag5QQoFZqQsUY9FGVeGi8KKP9Ow8hQuQ/meKe5G9SekG2BvK6KpqTi5TOJ71xN6DgELjhoUQOTystGZFVx6c4ifA/r8JfHD3z51u3nNAoRrQ5+ubZLg==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 15:11:31.6527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb07e706-1e15-4440-a906-08d803e291ce
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefano

> -----Original Message-----
> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Friday, May 29, 2020 10:11 PM
> To: Justin He <Justin.He@arm.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Kaly Xin
> <Kaly.Xin@arm.com>; stable@vger.kernel.org
> Subject: Re: [PATCH] virtio_vsock: Fix race condition in
> virtio_transport_recv_pkt
>
> Hi Jia,
> thanks for the patch! I have some comments.
>
> On Fri, May 29, 2020 at 09:31:23PM +0800, Jia He wrote:
> > When client tries to connect(SOCK_STREAM) the server in the guest with
> NONBLOCK
> > mode, there will be a panic on a ThunderX2 (armv8a server):
> > [  463.718844][ T5040] Unable to handle kernel NULL pointer dereference=
 at
> virtual address 0000000000000000
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
> >     ...
> >     release_sock
> >                                 lock_sock
> >                                    virtio_transport_recv_connecting
> >                                      sk->sk_socket->state (panic)
> >
> > This fixes it by checking vsk again whether it is in bound/connected ta=
ble.
> >
> > Signed-off-by: Jia He <justin.he@arm.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  net/vmw_vsock/virtio_transport_common.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> > index 69efc891885f..0dbd6a45f0ed 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -1132,6 +1132,17 @@ void virtio_transport_recv_pkt(struct
> virtio_transport *t,
> >
> >  lock_sock(sk);
> >
> > +/* Check it again if vsk is removed by vsock_remove_sock */
> > +spin_lock_bh(&vsock_table_lock);
> > +if (!__vsock_in_bound_table(vsk)
> && !__vsock_in_connected_table(vsk)) {
> > +spin_unlock_bh(&vsock_table_lock);
> > +(void)virtio_transport_reset_no_sock(t, pkt);
> > +release_sock(sk);
> > +sock_put(sk);
> > +goto free_pkt;
> > +}
> > +spin_unlock_bh(&vsock_table_lock);
> > +
>
> As an a simpler alternative, can we check the sk_shutdown or the socket
> state without check again both bound and connected tables?
>
> This is a data path, so we should take it faster.
>
> I mean something like this:
>
> if (sk->sk_shutdown =3D=3D SHUTDOWN_MASK) {
> ...
> }
>
Thanks for the suggestion, I verified it worked fine. And it
is a more lightweight checking than mine.

I will send v2 with above change

--
Cheers,
Justin (Jia He)


> or
>
> if (sock_flag(sk, SOCK_DEAD)) {
> ...
> }
>
> I prefer the first option, but I think also the second option should
> work.
>
> Thanks,
> Stefano
>
> >  /* Update CID in case it has changed after a transport reset event */
> >  vsk->local_addr.svm_cid =3D dst.svm_cid;
> >
> > --
> > 2.17.1
> >

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
