Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878C0F78E4
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfKKQg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:36:28 -0500
Received: from mail-eopbgr730070.outbound.protection.outlook.com ([40.107.73.70]:45793
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726877AbfKKQg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 11:36:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk2d27cw/WeaRrf4IJ9DvPSdhvqbcffjwfFJQjAln88uRKiBNEEWEz/6r3SFYDJTgXBlE/HiFNdnZ03bTqa3rRkPm4rt4tkydPQXTZHDI2b9PvXTButYzKu5RMXv1vhfG8Dloe0nVv5B11+QndBdrzBctEXs3MB7Ny4FyJ2AfS4OCXXiOVM1lZ5Mo1u/9rtqiJGodlwKCJ6RJibcH9JGUjx2QiFil6UGHssrLZitpGSH37sZlTepK00d/4bMXOTuPP5/KHRYH36LCnLWL9Al+iktPlMIQSLsVFiZxXPgq6qQMiEqn280NTOcj7aCpphsLTvc6c6+bvYAbTivoLlKvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhECcW+STZ6+97zS4fFba30Zd0+2lh5Tvswncz34eyQ=;
 b=bkzUTsvKuVHDhIN6vHk0LgdXuuUV9sW+2adhkygTDuExJSmKlb96TXo3K9BvrqsauYEenNGUHYLIxT1Qpl7YgXkvE3hXJrgrFIl1UrAz2wi9o03BgXsWZEipbzmdPtulz0smKopsZ21gvg/uSitpxpRuki9/VeO1sHwvjx/xicwJKPMZxaglBDY147JtXWhkbaHWyd5MdpbrRexzgEjEMRmC9tS7I4ajM+KBSzPqd0hIFhdLAtMsHTfD+9p0QvM4RXuHNnLfvMQ2rSpGU6JLpa6B2kEsP9LlRk2YOg2e+BkgjvS/AS7M15801R4P9Csw3hJeVf5qS22uxpqxmAevSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhECcW+STZ6+97zS4fFba30Zd0+2lh5Tvswncz34eyQ=;
 b=qUqQrkGzBPKN5HxEWi0NfR9usFiw1T3HrsaKhkd2Rbcq3yPlfPOoaT6Oj6RCPdXF1kvAgf1xf6TbFTez6GpiYQTExsUZwJpTOapJ6C5u4+a7Yvc1XfD+n75vbp5hcb2Nh/nh0OayL5fh//wu/kA0FaBaRijJhPbG0/JZrSav2Cg=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB2925.namprd05.prod.outlook.com (10.168.246.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.17; Mon, 11 Nov 2019 16:36:23 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2451.018; Mon, 11 Nov 2019
 16:36:23 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
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
Subject: RE: [PATCH net-next 13/14] vsock: prevent transport modules unloading
Thread-Topic: [PATCH net-next 13/14] vsock: prevent transport modules
 unloading
Thread-Index: AQHViYhrCrVR34m96EWV4ga8NEWQKaeGSMwQ
Date:   Mon, 11 Nov 2019 16:36:23 +0000
Message-ID: <MWHPR05MB337664DF4523C75B44982048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-14-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-14-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ee2f900-6355-42ab-931e-08d766c54a39
x-ms-traffictypediagnostic: MWHPR05MB2925:
x-microsoft-antispam-prvs: <MWHPR05MB2925AB366AEE3F58191B0668DA740@MWHPR05MB2925.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(54906003)(186003)(8936002)(110136005)(81166006)(81156014)(8676002)(4744005)(6116002)(3846002)(2906002)(7736002)(33656002)(478600001)(2501003)(52536014)(316002)(71200400001)(71190400001)(86362001)(305945005)(6436002)(14454004)(74316002)(25786009)(486006)(7416002)(66946007)(5660300002)(7696005)(76116006)(26005)(76176011)(4326008)(476003)(229853002)(66066001)(102836004)(6506007)(66556008)(446003)(9686003)(64756008)(14444005)(99286004)(256004)(6246003)(66446008)(11346002)(66476007)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2925;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xJtJkxVDW9mRhJtj1by2ha0VJ5jOpV4ypwBZvMJUMRM3gIC2tbMLM3JTGzShdzZE+MnT1sQmTmS51Wt7pc+w69lvN8V+JfD0ZwkBydt57zuD5qu0UgqwxcZlxCEu2vh64pnHPdCSuzKuqQD0EF1Is0pPpYO5nQgiLTblldc/zgzVjDEuhYUnAMOGXnU4AzIogCyydX/jkr41z5J2QoHEvRVf/eCgaDeRzVk5o2nrk1LXNKlsDuabtKEn9INGCJo5fH0e1E/bRjF9l6BF4f/2oyvD3zl+FMuyxAxt7idsuA5v3orxb2cx3mRSX1BgO+r8nOQKDbZ3eCJKYH9psN0ClgQVLLKXlWhyVWHu0SpoDGgZdV+E2LdnXUw4wO9gKxoqIArCJzG0h4w2feYaCRPnXq588QColvwhiuy/5h9F8txZeBa40m6/pQoantYrL+FY
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee2f900-6355-42ab-931e-08d766c54a39
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 16:36:23.4653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Whm2uLdV7QJh+Mo6uyPUVP314BE4Mkm4Ygh4g7fTnPUJ0xkZQpgqKsQT0a87nPsuIpjWq8clN/qSoTZbvaMjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2925
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM

> This patch adds 'module' member in the 'struct vsock_transport'
> in order to get/put the transport module. This prevents the
> module unloading while sockets are assigned to it.
>=20
> We increase the module refcnt when a socket is assigned to a
> transport, and we decrease the module refcnt when the socket
> is destructed.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> RFC -> v1:
> - fixed typo 's/tranport/transport/' in a comment (Stefan)
> ---
>  drivers/vhost/vsock.c            |  2 ++
>  include/net/af_vsock.h           |  2 ++
>  net/vmw_vsock/af_vsock.c         | 20 ++++++++++++++++----
>  net/vmw_vsock/hyperv_transport.c |  2 ++
>  net/vmw_vsock/virtio_transport.c |  2 ++
>  net/vmw_vsock/vmci_transport.c   |  1 +
>  6 files changed, 25 insertions(+), 4 deletions(-)

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>

