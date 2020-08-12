Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92010242A66
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 15:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgHLNdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 09:33:12 -0400
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:42145
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgHLNdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 09:33:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luOcxFiSVZErzX+RFVOcyioQAp0L5MhamL9DA8OoiEBHTUlNY461d3stlP2oK6LoKF8WGJfdUuAryVrP5q8xlax/d/pK4RWGZY7gx2joMktCexZarsxANuuA/hUeS/GUmvW3FsvNSHldLSknim45/dKzLbl4EDu3bFFpK/75hRtCh52UbqmIn9ZRJu3zfanMhLcn/HclN2H+DMjTn83VHZ03wehXpwyvBYaWeg6bhNLvBumrE3wjQ9fRCxIebaxt/qJnFVC14Ng/8e/9LRRebmQqc8+nF16TG6qmiyxsuDjHlaOI+BEi5MXOpQf+kjUv9KqgiOB42x3trLKfAToTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLEXfUha1UEydpaujSaekxg0qrc2/7ccXlcWAgFVBM4=;
 b=RphZlC9nO78HQeq+brJI5B0F0oS7pAGS/6CoMn8TC10zLZ5o66GcJIAHixh3p26w0bEjnV0GdPzvAp/dCxjSkFLzghYI/nGV8xmPqz5WIS2eT3dH/71BbP49ioiq2VYTDA1UV52PAvIPK4/xERqbST6iG7L+bGmUJIse92TUzjubZyIskEh9+PCBANn1qcRZ/F9vHqHIeHQJGidnUKuyBQONJtWK9mnQ6EoYi3++++tKOeJaIgRmq/TzMIth399YXTbXIH0jbYUjEGlhm8KdZx6WWXuJKgigKuRewXMZqtZ7Y2z+lKEt3myMYmfSejoDFjDSB9MFhc46cR5wmGA5aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLEXfUha1UEydpaujSaekxg0qrc2/7ccXlcWAgFVBM4=;
 b=Ch1Ffk29l/5uc4f50pgml/XIBDT8eW+rzX9LayysyPnzydtAEWtRZThp36ZevG686DjSrTTHiehwrxSezw9eHcO5gKlzbbR9ICZwIQzV0vN9mBxLoYBhAjwZz+cBV0rLeq+Fv9Va23a0dr6GgEWFHODoDQSuqu2h01ms2vugR0g=
Received: from DM5PR05MB3452.namprd05.prod.outlook.com (2603:10b6:4:41::11) by
 DS7PR05MB7270.namprd05.prod.outlook.com (2603:10b6:5:2c3::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.10; Wed, 12 Aug 2020 13:33:08 +0000
Received: from DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::8139:6253:e8fe:8106]) by DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::8139:6253:e8fe:8106%5]) with mapi id 15.20.3283.014; Wed, 12 Aug 2020
 13:33:08 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH net v2] vsock: fix potential null pointer dereference in
 vsock_poll()
Thread-Topic: [PATCH net v2] vsock: fix potential null pointer dereference in
 vsock_poll()
Thread-Index: AQHWcKf8GJrT2g2/N0mOruUUuG8ezak0eJKA
Date:   Wed, 12 Aug 2020 13:33:08 +0000
Message-ID: <DM5PR05MB3452B24F729BD183C4297614DA420@DM5PR05MB3452.namprd05.prod.outlook.com>
References: <20200812125602.96598-1-sgarzare@redhat.com>
In-Reply-To: <20200812125602.96598-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [208.91.2.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20bd1e93-f412-4076-9a35-08d83ec4400b
x-ms-traffictypediagnostic: DS7PR05MB7270:
x-microsoft-antispam-prvs: <DS7PR05MB727039A1D3D72CBDA0874E85DA420@DS7PR05MB7270.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5YWToBpWcQ8yzXDp+Pt7WHbrEyCZ34v4BChIwN0WcQH/HaVcEGS0juQCumR+Eoq3QaRHJiCrgTE2GA4Co+o1fJx84odIL175Z3zmnlKt/EmqxHAmq5teGb7Nma8MxYsSSiYLLJ2mU7nrrSYi40NxiXxuVCjm4XNbjIcFmJrTm41/gmibFEF6uDTvID4S2ErB3i3BytqOnmaSVdGNZl1MsWF3dnunbDoUrAXT+YT54pFUGBVDdE9pjysdVAS8Vx7xaL1M0ngvbYjtWfUacL6wQc+FQ34mLWDUq0SUMHXyOuu6pvUvVfB2wUKdXmGek6h0ql8WHy4qnN2fhDZc4kj8QDFzmd1d/auzRbPPRmh0HLQKZY3Pd+YToDLujfst4PQLiLWbRBE5qUM7eMyFhgic5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR05MB3452.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(54906003)(110136005)(316002)(66946007)(66556008)(71200400001)(8676002)(66446008)(76116006)(66476007)(55016002)(2906002)(64756008)(5660300002)(9686003)(52536014)(8936002)(4326008)(186003)(478600001)(966005)(7696005)(45080400002)(83080400001)(83380400001)(26005)(6506007)(53546011)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IwpSdOarXnE09pnTmWSJo90f7WiCvI5gTx6LeYhuV9Wnod5af4M15ySdyn81lbd5yk8Gwn8I5Bj2Ht0ER8YbawvntnBgcksU9c8qckiX4WfBSvEVC2mOPJ5AOZSezdkwfymF+K5Xc08wrXYqX7nWc54RVMrPr8lCZkRO9aEbwfbjVs37YRKeMs45eBF3sF0Z1aESx8CPuH1Yexhs/So0bn3PCE8DzjFGsTY/UufHCrQejUJAvhgZEOJ6NWTBgSLyAOncN6ym9Eb1wX/VzOHTCvK5W/I16gyvyyOqFyl5wEdGXDXHv4zFlgPXWjNh7fuV+fbVBXuHvoivCeoKV76JfnFtyLFmoCy5Xon5tK/Rc49Nmtcg3BK6b9/6juky14O0eBz/mJfvjVT/syDFS+FrU3OpZ6TOb5/pvIY4iIka4lNig5ArEG3sWd4tknUTKQxH5wVb3wKTOu2sWS0kazvVmj5osbWWHG8GJ0gzMitxrInFqLMOjcOGHHAF8thM9PtNIVfkU/v9QkmmqZ/I+PCyEUEwglBg5LcueRZ3ltYwfAN7WYqVIeueRpmekoXBCIag0pSkDGntvqW4fjqKzHAoKmJVbG5TxkT64m9NJsBrvl6tgzbEkbOMDMQnprrMi2cO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR05MB3452.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20bd1e93-f412-4076-9a35-08d83ec4400b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 13:33:08.1439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tRAYOP9guyYzB9Vnw8Ast/2Z4YOWJsv3UdmcT+wmw4LLXFgrgwq88RI1UClV6jMlBxEjJemDnGY1o1XK96NLQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR05MB7270
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Wednesday, August 12, 2020 2:56 PM
> To: davem@davemloft.net
> Cc: linux-kernel@vger.kernel.org; Dexuan Cui <decui@microsoft.com>;
> netdev@vger.kernel.org; Stefan Hajnoczi <stefanha@redhat.com>; Jakub
> Kicinski <kuba@kernel.org>; Jorgen Hansen <jhansen@vmware.com>;
> Stefano Garzarella <sgarzare@redhat.com>
> Subject: [PATCH net v2] vsock: fix potential null pointer dereference in
> vsock_poll()
>=20
> syzbot reported this issue where in the vsock_poll() we find the
> socket state at TCP_ESTABLISHED, but 'transport' is null:
>   general protection fault, probably for non-canonical address
> 0xdffffc0000000012: 0000 [#1] PREEMPT SMP KASAN
>   KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
>   CPU: 0 PID: 8227 Comm: syz-executor.2 Not tainted 5.8.0-rc7-syzkaller #=
0
>   Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
>   RIP: 0010:vsock_poll+0x75a/0x8e0 net/vmw_vsock/af_vsock.c:1038
>   Call Trace:
>    sock_poll+0x159/0x460 net/socket.c:1266
>    vfs_poll include/linux/poll.h:90 [inline]
>    do_pollfd fs/select.c:869 [inline]
>    do_poll fs/select.c:917 [inline]
>    do_sys_poll+0x607/0xd40 fs/select.c:1011
>    __do_sys_poll fs/select.c:1069 [inline]
>    __se_sys_poll fs/select.c:1057 [inline]
>    __x64_sys_poll+0x18c/0x440 fs/select.c:1057
>    do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> This issue can happen if the TCP_ESTABLISHED state is set after we read
> the vsk->transport in the vsock_poll().
>=20
> We could put barriers to synchronize, but this can only happen during
> connection setup, so we can simply check that 'transport' is valid.
>=20
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Reported-and-tested-by:
> syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
>  - removed cleanups patch from the series [David]
>=20
> v1:
> https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatc
> hwork.ozlabs.org%2Fproject%2Fnetdev%2Fcover%2F20200811095504.25051-
> 1-
> sgarzare%40redhat.com%2F&amp;data=3D02%7C01%7Cjhansen%40vmware.co
> m%7C32b3919883a448f56a8708d83ebf1dce%7Cb39138ca3cee4b4aa4d6cd83d
> 9dd62f0%7C0%7C0%7C637328337851992525&amp;sdata=3DCSo8PEJJwyDE75Qz
> n3lmasJFSNaNChiRXjoy%2FfoJ8Vs%3D&amp;reserved=3D0
> ---
>  net/vmw_vsock/af_vsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 27bbcfad9c17..9e93bc201cc0 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1032,7 +1032,7 @@ static __poll_t vsock_poll(struct file *file, struc=
t
> socket *sock,
>  		}
>=20
>  		/* Connected sockets that can produce data can be written.
> */
> -		if (sk->sk_state =3D=3D TCP_ESTABLISHED) {
> +		if (transport && sk->sk_state =3D=3D TCP_ESTABLISHED) {
>  			if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
>  				bool space_avail_now =3D false;
>  				int ret =3D transport->notify_poll_out(
> --
> 2.26.2

Thanks for fixing this!

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
