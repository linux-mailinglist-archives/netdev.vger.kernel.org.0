Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054DB12BFD4
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 02:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfL2BHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 20:07:18 -0500
Received: from mail-mw2nam12on2093.outbound.protection.outlook.com ([40.107.244.93]:52831
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726248AbfL2BHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Dec 2019 20:07:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEnsigEW7AkHP+BIaVLHTSbpXO9lK0nVcwm+DtQdRGlc1JSzDDmbyiR2kCXEarDJajbM/MD4kqXQscOYuy2QAwq6UWufN9Vn0LCc8rEmZwP9uu3yYCb9tQrqDU7sy5EDzMS/aNhXCSbcE2SbJ4owf0GYs39fRQ0HxcFEl/Yt2DVuL+OP/P2iBQzamIEjdhgtojymO8FMnzyvG5lXhcT6eVsjjksBElm2VgA5l8RQup3r9pUI4UlADMgBVysL0SJ9A3ZcfcQaB3GZiB9wZzJrNtQO6CgfAGj+QCFkj2zIF72gdGf1kOM6JgV3tbFepl/BDYTmIxT7fqCwCxZZ8seBZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4H3NJmF6i5VrGBGM4B/muwj06rH5n1nohU3LZ5oSDW4=;
 b=W1lcFrx4lkZLYwzVUeydGzeIilF0DgWsw7JEl5TjXcTDwb+gZTgIv8oTO7PtFMGUigbB8bn0BnojdBUOFy3autb5i+oIkqek5oAYvTy+l0zYwBA93SKl76jThxrSjPIglHj4PGS41NtnJdNuFtHViBazvlBHFwFFRoLFw968/I9qw2BAYRaYDxDm5cgmtmbSFZ73TTM+a1TASSzHA2wS8Tco70Yko2YeHkGBMM95wfo+n2vDqZjGRT8Wx/s/xL+8T4tR+v1Y15i39BLlUxeeDpDAMjW1+LY2rO7SEM0AYQVgXOkrXCFGqML1kdq0qCoshB9uHAtznUcRByC8iwoJNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4H3NJmF6i5VrGBGM4B/muwj06rH5n1nohU3LZ5oSDW4=;
 b=NBT0hgYPqBE66u7PKf8lMex56d0FLq5kSRr5iCJNlXSo9AI5RU4cv/tEjoaezPwh2hlAc0DYtXNnSqPNbGzp0k1KSaLJah3ppE25z5kW/fVUHd1hyDBH56NVe45ln/ouaEO7zFt82xt79K6tck32WMPHHhFc/L1BV8JveAlTdBw=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1216.namprd21.prod.outlook.com (20.179.20.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.3; Sun, 29 Dec 2019 01:06:35 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215%8]) with mapi id 15.20.2602.009; Sun, 29 Dec 2019
 01:06:35 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 1/3] Drivers: hv: vmbus: Add a dev_num variable
 based on channel offer sequence
Thread-Topic: [PATCH net-next, 1/3] Drivers: hv: vmbus: Add a dev_num variable
 based on channel offer sequence
Thread-Index: AQHVvdkhLyg9j1bIO0OUHtBIsB4tRqfQP7oAgAAKl2A=
Date:   Sun, 29 Dec 2019 01:06:35 +0000
Message-ID: <MN2PR21MB13755046D790AA59DFA9EB5BCA240@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
        <1577576793-113222-2-git-send-email-haiyangz@microsoft.com>
 <20191228162002.3a603c8b@hermes.lan>
In-Reply-To: <20191228162002.3a603c8b@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-29T01:06:33.7814625Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=409072ba-85ba-4fce-887b-cbc5478647ed;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 08acaa89-fcbd-438c-1535-08d78bfb59ae
x-ms-traffictypediagnostic: MN2PR21MB1216:|MN2PR21MB1216:|MN2PR21MB1216:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB121609EB0EB12CCD8F06933BCA240@MN2PR21MB1216.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0266491E90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(366004)(39860400002)(199004)(189003)(13464003)(52536014)(8990500004)(8676002)(66946007)(6916009)(71200400001)(186003)(86362001)(81166006)(26005)(54906003)(2906002)(81156014)(8936002)(66556008)(76116006)(64756008)(66476007)(316002)(66446008)(4326008)(478600001)(5660300002)(55016002)(33656002)(53546011)(9686003)(7696005)(10290500003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1216;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yrGvYzgmzkCVmF5E9b43v0gxvx8G/IEdVWwxD/vIwHi6RPzbY0N135QtayqjAcx7s8j7Ip5KSsbPD8byvnQ4yY1ntWgezrOGA+x8RiFPOJ8AS73pVyz9h1hFheTo9yFxXX3yDHKsfwPjpk/Gw6I9xefWNK6nndElZjElcS5oXUhgN80hKQOS7kND0n1X2RRzTZe9gMiRksFZqZEoaU/QT7aQ/GTS34TiXeKeaPipxYlGHgDwkBb+G0WnJM/zHt0qStTBghwNwNbSlSEdbf7Pscf5G2CtA3oDvC1QLIUyT1w6G7v+8/rHkiAUtlXEeZRulSjv5PUDLMovxzfJ8NYspJPk2uy3uFGx3IXcDt2fGJ6K4Mtv1fzagoy9vBMXZsTyh4IvpgS3r9+dzeQCjzXkLrTZ4gpA8zJnl/N+r4oVbKMsBRO0uo8P+RrLm/6NF8kBhkKjmCxbXp97q3UvP94DoKlweySFR1JypGo+F9Kud//L5A1V+1FZZN4RCgE4d1Ri
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08acaa89-fcbd-438c-1535-08d78bfb59ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2019 01:06:35.2734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uHJbbcKw3kszi6Rh735E+a8flpU5oU0HnXUR2fHHpi1toEnw2k+HXcE/FQHPNkVXTtZs5NaHet4YqBNhVd4dQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Saturday, December 28, 2019 7:20 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 1/3] Drivers: hv: vmbus: Add a dev_num vari=
able
> based on channel offer sequence
>=20
> On Sat, 28 Dec 2019 15:46:31 -0800
> Haiyang Zhang <haiyangz@microsoft.com> wrote:
>=20
> > +
> > +next:
> > +	found =3D false;
> > +
> > +	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
> > +		if (i =3D=3D channel->dev_num &&
> > +		    guid_equal(&channel->offermsg.offer.if_type,
> > +			       &newchannel->offermsg.offer.if_type)) {
> > +			found =3D true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (found) {
> > +		i++;
> > +		goto next;
> > +	}
> > +
>=20
> Overall, keeping track of dev_num is a good solution.
>=20
> I prefer not having a loop coded with goto's. Why not
> a nested loop.
Sure, I can use a nested loop.

> Also, there already is a search of the channel
> list in vmbus_process_offer() so why is another lookup needed?
vmbus_process_offer() looks for the if_instance and if_type matches
to determine if this is a subchannel vs primary channel. The loop=20
terminates at different condition from hv_set_devnum().
So I didn't re-use the existing loop.

And this kind of search happens only during channel offering, and
doesn't impact performance much.

Thanks,
- Haiyang


