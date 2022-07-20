Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE457BE23
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiGTSza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiGTSzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:55:01 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020015.outbound.protection.outlook.com [52.101.61.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC3754CB2;
        Wed, 20 Jul 2022 11:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQuOYyZxKbn+JMG2d61C4MWIKE52Atzx04VwLRQQeE/cUkq3mCoCuQadIGTcZN5x1AAo8TS8ReELRcJlGopAwGugZJKU4iu85fsFbWNu0pSoWZ5KJzIbyWhbVtTXprOgLEanUxlkGfYG8ycSOi4rGxjYavl6OMkiimZ5VGZY6yYjbcMryEGLx4x81J46r+14FfgufryNgPjDX1bb2Up4cHYB4IUrXl3ybd30ngoJZFEsZo02/WbCkhX0quPdr006OXx6DxiuthPAZDunEBBe14OEeRerfYRfz8r5u4k5y9CUIAingSJepVJZ208KxuSywrMhbIVaB19ulAy+SlzExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnlyVMRCgy51CqEhiKonZImE9K5T4Ol9w2OK1izCC9I=;
 b=HezlnNV//XssnYQhXtwB/QBVga62DbZtKJpO3+Whzj3JYLXnvciU/knhHf4OVK7g0KvR5N7DJXcYlT/jW0vY4BEmZuzbmUJ8JqAaJcScbn1cXY7vBICuxpMMnrPg+MZQQhJJlJ+LB3cFGP6ADiHWiAmolVEmGBLaxhdGkEEKYDX/uVs1b80hvFe+vPKDndTYod7Jpc4MIATMO4YuQeiw5Ww9/Wwwwdmz5jHODaHGprzJwpiZOmQ5xbPYjAs2lktpzkRBF+PsfBpSwqGObLQORd91WLyAxMLzUy+I1kCigo8gQwyUo1oqpUH3/2H+W9Vi+7aXOvGK8XC5LSgCcNqyKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnlyVMRCgy51CqEhiKonZImE9K5T4Ol9w2OK1izCC9I=;
 b=Rr6PUuNmO244StdBqthvhYKU/oMBjgEkbqMYGxyAWYthHLKXuexg0OkW4HO0fFjNMoVQ7cRMj7R018D0WGbBdaUJerMqB8mh1WQs1qKt6syw6vThm+PuunpKR7toP25aCNWgYcMRnDnYkDBEPqL+mC0YsKuYcncrzdSfC1IYDlU=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SJ0PR21MB1935.namprd21.prod.outlook.com
 (2603:10b6:a03:295::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1; Wed, 20 Jul
 2022 18:54:58 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5482.001; Wed, 20 Jul 2022
 18:54:58 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: RE: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Topic: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Index: AQHYnBH4pVNR0eqcD0CILiDoHCrOv62Hk0AQ
Date:   Wed, 20 Jul 2022 18:54:58 +0000
Message-ID: <SN6PR2101MB132703A0F4D08DC28D37A17EBF8E9@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <358f8d52-fd88-ad2e-87e2-c64bfa516a58@sberdevices.ru>
 <20220719124857.akv25sgp6np3pdaw@sgarzare-redhat>
 <15f38fcf-f1ff-3aad-4c30-4436bb8c4c44@sberdevices.ru>
 <20220720082307.djbf7qgnlsjmrxcf@sgarzare-redhat>
In-Reply-To: <20220720082307.djbf7qgnlsjmrxcf@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f2ea54de-b924-45d0-a337-e99ed0f78dbb;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-20T18:22:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b259af13-25d9-4f57-4282-08da6a8157e6
x-ms-traffictypediagnostic: SJ0PR21MB1935:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EhGJpSOGChZZ4FVFW71l2Pf5weOl+MR14l3O4wIZxrfdmgJj1Cz3mRIz3SUkrJ2Ghtx6wdiJ/FGdA3MRxjGpmI7BdXQyaJd4yij82Tnm5NZl++Qji0B/5N/Ze/mZ8AakLznRD8druQeNQd/hH1fLo/nGiNnBlJwcxzNM1uyDzZ/U4/tuc1HKfl/lYzY6dKBIiMSD5A53Z4PrLubHNczpykofFnmhTOwRNxbZJnVMHJB1AfVp3o0PCqLwyBuxJ5vmQmCcqUlTMrGYkcuuwEqNr9hx5NXc0eTydRZ01MXGhr4e5GaJlKrJwgTa6LrQEAG8wfvY2Q0hpu2Rh2TJNRT5jVa9OAChLwFfAga5xSOHnw1dGgIDid3QMzcAXXcY9af23ma2HvBRzc+rjMP4EW+p0ESsmwLhvVZdrT9CjVXXdZsvQvD5xobkvtaZh9HFvcULFik+gJ9E+JjflGJC7z6iwAJ2jp6RkE8YGkGvE3cLjr841NPW+6qRaAplv4W3F7WJI3pr7Bi97i66QR7OKQqQAJCrhgPuQNb/TfjN4VdWf4yG8yH9DblziJmPWebVDkWcUIUaptASFfMoRAADEl/BE5sAOlcQ7SS9RtoeRuNorR/Q5CMqUmk44rEj20Wb7IVHFTWETqiy7GiOVjC4hJLevksB55oO8LPD/adrm6l6bGLBmf4/GBWF/yL1sls+84wsRJXpqkgxntNm7Frl5q6jLKaVcIq27hQNHNZG7bi49N3a8cKXERNLV/gNS63QNBnrpkYW+6rz8XLJYckk+kmcUeu7YvSjDm3nfWEYikBeBID33twmAMSAJFMEear6wpS6txUBmdsxh+1xQTCTnUrqU0/U9hmRorwVnXwla6tq5NM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199009)(54906003)(110136005)(9686003)(10290500003)(8676002)(4326008)(41300700001)(71200400001)(26005)(7696005)(6506007)(316002)(186003)(66556008)(66476007)(66446008)(86362001)(64756008)(33656002)(5660300002)(52536014)(7416002)(8936002)(76116006)(66946007)(8990500004)(55016003)(83380400001)(2906002)(122000001)(38100700002)(478600001)(38070700005)(82950400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?1AMY9U8yv+6gUlZL0vwiauNojPBDH5U7xIGTxl8M5RDtIpq5ezQH1j+D48?=
 =?iso-8859-1?Q?MqSYyiB2YnTe24o4W1/wippv0WvByDd4Z9/fjbsBQoUQhSwowLxl+pve9J?=
 =?iso-8859-1?Q?7azeV2735jEyBrj3KIsAr2RcnLiIWG76WOa3aKy6AggzWdR5QTV55B6RST?=
 =?iso-8859-1?Q?/QODqgbSqbGBSYGve6pvSRuzKYFqBdnC7gFxOuxPPlkFLJ3u21EwzxPzjq?=
 =?iso-8859-1?Q?pzCMN/NjxRzCk7/1IT4VcRhT00ltshJZnirZCKPMyykdX8NYhzj1cWuo1f?=
 =?iso-8859-1?Q?8Tdy1TZMg+YK8Qz+Se2CIAD0RDxK+Mm/nrPnmEkSPLjBfP32Ljl3yfTg+t?=
 =?iso-8859-1?Q?HM6nCK3dBeGMLPAI6XMmIW41AdSw6AM+H3vQ+TG5ghcsKMzze4IL2zy4Yx?=
 =?iso-8859-1?Q?4is35IpJgfZDM9O/yC0gYYWWHBr6FUxWbOHKePQ1Z83GVoDi5OTOhaPIM2?=
 =?iso-8859-1?Q?YpldrMHWIuy0DlS2ncHa82M4fVOnu18VKv03jrBzHZFDxajmNihlIZTu2x?=
 =?iso-8859-1?Q?/ICMfTeY05QI2yHTEUaJ8UHJwy5CeS6I9HMaPU9TBpp7JEroDC4rICIyTD?=
 =?iso-8859-1?Q?bEbJPBvUQk/vdA9Rtcm8y69A0QkolalrFxFfjvNAXsxkneisc4JoeobT0r?=
 =?iso-8859-1?Q?pkEvzsImQfKfX5S2z70KX9B/nRurB+2/6hr4f6ooXUEPeQbk4sGcx0UmsO?=
 =?iso-8859-1?Q?jrJwwTfPRLuLfNOhtXSr+Cl5mdYJpwj3iKqSjNkhdtC50roZFYUEXY9WjI?=
 =?iso-8859-1?Q?+vrxe5hr09frQO1lOv6xbllU28jrEbevQDnSIuugHyeq9YRZs6WEjXweLc?=
 =?iso-8859-1?Q?KGjet9OG4b4wJh2e/6dsMvhXEQklYzG9C0wfowhJBb29ngDGqzdvK1WcBI?=
 =?iso-8859-1?Q?/DVQsdE8ZTj/oQ3qwmSsdBbiRlH44eDhjhno6PrDVQk8PMgfA7z4PyYQbq?=
 =?iso-8859-1?Q?JOS29wrH/Dmj3kBiOYDEbH6bASlopMuSgfbetxS7eo+chaUTqJ6bOWxKDY?=
 =?iso-8859-1?Q?sM8GdoKGYEBOLP4jWgYSJZJVTm48Rn1msbwNVCcodIGE3kRkyQYgpIaGYt?=
 =?iso-8859-1?Q?PJMvFPHZUgmITRBQLv8njsSnZrzyMPf0jkZVu8YD8PbR7Jik9J4GHdNO4J?=
 =?iso-8859-1?Q?JQkzeJ2+kc2HwkbZGbPjrI9q0EJjlAYXPXkvcZ8JME+kKz0qrZ2ExFryfW?=
 =?iso-8859-1?Q?hlb3YC0oqjGA7mPiWC4XSMZP1E5ltRp64NB8zyx8gz8qAIVV3fm4p9uqMv?=
 =?iso-8859-1?Q?tdvIcs4IoRu8yWPs+n9P5+Nun/dJlcjdw4y66wUrJU59bB4GHDNYRFDmFH?=
 =?iso-8859-1?Q?XVWGVccsDY19SvAS1nG6C47yCADjGiHWlgiVjp2D+qUw2ZY6xMMkwZKbMS?=
 =?iso-8859-1?Q?p3+4xO4IeaRvAVG+vJZLL+5hR24sejWjh7rCE298dEInN04ZIktf/TJHhK?=
 =?iso-8859-1?Q?l+bBkuhDfR6X6VtpOuAON0P3Gqmz2ZzyYL/jR3H0DvqQy7IjAAjriKD/iD?=
 =?iso-8859-1?Q?HklkrZ8/hbYrGWw7bDbA2YvfaEqCK0nsRwY0Y79xekLI7LjgNuf94yHHyG?=
 =?iso-8859-1?Q?7sNzrHaAqhS9EBd20RlanBmYO2JOxzY5e81J5YUH288hCZUFqiayKxruPH?=
 =?iso-8859-1?Q?/kGMvlDrkh5HnNQ8vGCxhwsHTapl1ofcDw?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b259af13-25d9-4f57-4282-08da6a8157e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 18:54:58.4223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/5GTsaDcZj2HuMShsi1ClvtHdcZzLNPhq+qY771qlD06zrVC25nqKJONGRMj+h9lWHrXjIPqrl4H+jyNb05pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1935
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Wednesday, July 20, 2022 1:23 AM
> ...
> On Wed, Jul 20, 2022 at 05:38:03AM +0000, Arseniy Krasnov wrote:
> >On 19.07.2022 15:48, Stefano Garzarella wrote:
> >> On Mon, Jul 18, 2022 at 08:17:31AM +0000, Arseniy Krasnov wrote:
> >>> This callback controls setting of POLLIN,POLLRDNORM output bits
> >>> of poll() syscall,but in some cases,it is incorrectly to set it,
> >>> when socket has at least 1 bytes of available data. Use 'target'
> >>> which is already exists and equal to sk_rcvlowat in this case.
> >>>
> >>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> >>> ---
> >>> net/vmw_vsock/virtio_transport_common.c | 2 +-
> >>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> >>> index ec2c2afbf0d0..591908740992 100644
> >>> --- a/net/vmw_vsock/virtio_transport_common.c
> >>> +++ b/net/vmw_vsock/virtio_transport_common.c
> >>> @@ -634,7 +634,7 @@ virtio_transport_notify_poll_in(struct vsock_sock
> *vsk,
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 size_t target,
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *data_ready_now)
> >>> {
> >>> -=A0=A0=A0 if (vsock_stream_has_data(vsk))
> >>> +=A0=A0=A0 if (vsock_stream_has_data(vsk) >=3D target)
> >>> =A0=A0=A0=A0=A0=A0=A0 *data_ready_now =3D true;
> >>> =A0=A0=A0=A0else
> >>> =A0=A0=A0=A0=A0=A0=A0 *data_ready_now =3D false;
> >>
> >> Perhaps we can take the opportunity to clean up the code in this way:
> >>
> >> =A0=A0=A0=A0*data_ready_now =3D vsock_stream_has_data(vsk) >=3D target=
;
> >Ack
> >>
> >> Anyway, I think we also need to fix the other transports (vmci and hyp=
erv),
> >> what do you think?
> >For vmci it is look clear to fix it. For hyperv i need to check it more,=
 because it
> > already uses some internal target value.
>=20
> Yep, I see. Maybe you can pass `target` to hvs_channel_readable() and
> use it as parameter of HVS_PKT_LEN().
>=20
> @Dexuan what do you think?
>=20
> Thanks,
> Stefano

Can we return "not supported" to set_rcvlowat for Hyper-V vsock? :-)

For Hyper-V vsock, it's easy to tell if there is at least 1 byte to read:=20
please refer to hvs_channel_readable(), but it's difficult to figure out
exactly how many bytes can be read.=20

In hvs_channel_readable(), hv_get_bytes_to_read() returns the total=20
bytes of 0, 1 or multiple Hyper-V vsock packets: each packet has a
24-byte header (see HVS_HEADER_LEN), the payload, some padding
bytes (if the payload length is not a multiple of 8), and 8 trailing
useless bytes.

It's hard to get the total payload length because there is no API in
include/linux/hyperv.h, drivers/hv/channel.c and=20
drivers/hv/ring_buffer.c that allows us to peek at the data in the
VMBus channel's ringbuffer.=20

We could add such a "peek" API in drivers/hv/channel.c (see the
non-peek version of the APIs in hvs_stream_dequeue():=20
hv_pkt_iter_first() and hv_pkt_iter_next()), and examine the whole
ringbuffe to figure out the exact total payload length, but I feel it may=20
not be worth the non-trivial complexity just to be POSIX-compliant --
nobody ever complained about this for the past 5 years :-) So I'm
wondering if we should allow Hyper-V vsock to not support the=20
set_rcvlowat op?

Thanks,
-- Dexuan

