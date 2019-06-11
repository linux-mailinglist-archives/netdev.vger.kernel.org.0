Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9043C3C0AB
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 02:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfFKAnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 20:43:11 -0400
Received: from alln-iport-2.cisco.com ([173.37.142.89]:42489 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfFKAnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 20:43:11 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 20:43:09 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6818; q=dns/txt; s=iport;
  t=1560213789; x=1561423389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7NQLhDO8eHZXT4Y6QwnsC4qmVdoofjr9CF4MNqUSn+I=;
  b=iOi7MhVqazryzaXFpmcLZkxN6NILnT8UZv3tgQDIweMbBuAz/V0oWWAg
   JhoWviXeqKCCmscRzpsI6XDIvCb1AWMwa7sw403c5+8HHlln8EfZTlgJ1
   Zs5R10ftiSw0ZcPv8Q7Rzs4hn4kX6+SU+v6K+YnlfcE157H6uStdKN4yP
   E=;
IronPort-PHdr: =?us-ascii?q?9a23=3AptZH6xBEH8sKNxf26jrVUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qg93kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuJvPscSESF8VZX1gj9Ha+YgBY?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AGAACb9v5c/4oNJK1mGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQcBAQEBAQGBUQQBAQEBAQsBgT0pJwOBPyAECyiHXAOEUooNgleJQ41?=
 =?us-ascii?q?vgS6BJANUCQEBAQwBAS0CAQGEQAKCdCM0CQ4BAwEBBAEBAgEEbRwMhUoBAQE?=
 =?us-ascii?q?EEhUTBgEBNwELBAIBCA4DAwEBAQEeECERHQgCBAENBQgahGsDHQECnVECgTi?=
 =?us-ascii?q?IX4FvM4J5AQEFhQ0NC4IPCYE0AYtcF4F/gVeCFzU+ghqCLIM6giaLWgGdEj4?=
 =?us-ascii?q?JAoIPj1eEBpcbjROIdo1EAgQCBAUCDgEBBYFPOIFYcBWDJ4IPDBeBAgEHgkO?=
 =?us-ascii?q?KU3KBKY5YAQE?=
X-IronPort-AV: E=Sophos;i="5.63,577,1557187200"; 
   d="scan'208";a="285671698"
Received: from alln-core-5.cisco.com ([173.36.13.138])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 11 Jun 2019 00:36:02 +0000
Received: from XCH-RCD-005.cisco.com (xch-rcd-005.cisco.com [173.37.102.15])
        by alln-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id x5B0a2e7031830
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 11 Jun 2019 00:36:02 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-005.cisco.com
 (173.37.102.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 10 Jun
 2019 19:36:01 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 10 Jun
 2019 20:36:00 -0400
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 10 Jun 2019 20:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReZORISEIWrxg98aY2UFCrYC8cP7VOyBEdAs2X8Jo8A=;
 b=ABwb8KWwK1tZIzyRNNrf531HMBjwQeNsFwCkZz+qZIsbrG2breyApzxU+85Ye8cHwLC+YuIQ9Xk2rbvvO9PJnpzkwLWASfiqhrnnkrz87jPdAAHrIhxFrgnHrfYu6YDs1u13m938cPYGnDBHzritdBbQ67U/qhK/xOcfdJREUoU=
Received: from BYAPR11MB3512.namprd11.prod.outlook.com (20.177.226.97) by
 BYAPR11MB3576.namprd11.prod.outlook.com (20.178.206.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 11 Jun 2019 00:35:59 +0000
Received: from BYAPR11MB3512.namprd11.prod.outlook.com
 ([fe80::81dc:1465:c3b9:23b1]) by BYAPR11MB3512.namprd11.prod.outlook.com
 ([fe80::81dc:1465:c3b9:23b1%3]) with mapi id 15.20.1965.017; Tue, 11 Jun 2019
 00:35:59 +0000
From:   "Christian Benvenuti (benve)" <benve@cisco.com>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "govind.varadar@gmail.com" <govind.varadar@gmail.com>
Subject: RE: [PATCH net] net: handle 802.1P vlan 0 packets properly
Thread-Topic: [PATCH net] net: handle 802.1P vlan 0 packets properly
Thread-Index: AQHVH9KGeIlyZG4nJUSB/Xa7PyfB96aVZygAgAAcEACAABRg8A==
Date:   Tue, 11 Jun 2019 00:35:59 +0000
Message-ID: <BYAPR11MB351224279A7FDF2B9C5A73A5BAED0@BYAPR11MB3512.namprd11.prod.outlook.com>
References: <20190610142702.2698-1-gvaradar@cisco.com>
 <20190610.142810.138225058759413106.davem@davemloft.net>
 <20190610230836.GA3390@ubuntu>
In-Reply-To: <20190610230836.GA3390@ubuntu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=benve@cisco.com; 
x-originating-ip: [2001:420:c0c8:1001::1a4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efb5fb4c-2c0e-41e6-c49d-08d6ee04c655
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR11MB3576;
x-ms-traffictypediagnostic: BYAPR11MB3576:
x-microsoft-antispam-prvs: <BYAPR11MB3576CC212D0C6BC2F53361B6BAED0@BYAPR11MB3576.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(13464003)(7736002)(6246003)(11346002)(486006)(305945005)(8676002)(81166006)(53936002)(476003)(5660300002)(6436002)(7696005)(54906003)(446003)(68736007)(14454004)(8936002)(478600001)(46003)(81156014)(33656002)(316002)(186003)(52536014)(25786009)(256004)(71190400001)(71200400001)(86362001)(76176011)(9686003)(55016002)(99286004)(6116002)(53546011)(6506007)(102836004)(4326008)(74316002)(64756008)(2906002)(76116006)(229853002)(73956011)(110136005)(66446008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3576;H:BYAPR11MB3512.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BLh36V/hMa5SaQq3dFc0PQj9YNrxxsvwt0A8AUofr+Nv6/FMrPXGE9v66zfFqSzGvor+LVr9xFG5X25s05LTeQ1PjJyu9tAZPjgx00jybVLPL2h2OVkHuB6H9GM7l/QcuO31eBnK47BJIECCWpWpk0fritU2z4F7cMPNKd2Mzv89/LnZajPBEgZLaSKh+8rSMAUB84KjLPnQEXoqsQL1PHgkYFDiGWA7TsSna+KFiDljUXjXj5zI/IWgQkPRYOiIwPc+R7jBZ0hJ8GV2FAd09835SSXpcF1QDYDRejGzMaYtuh2wvdqJAGpAAf/bcbk6aj9WQT4nwJ3snb7DQyLQ7bitzpONG5+BgBZEIMkN+03LyuarM9N//ARKMVsVtPCIJltEiuvbgN6LFFNf2lfxqcwYZSsZ/yHoXwk5opQ0/2s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: efb5fb4c-2c0e-41e6-c49d-08d6ee04c655
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 00:35:59.3253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: benve@cisco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3576
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.15, xch-rcd-005.cisco.com
X-Outbound-Node: alln-core-5.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Stephen Suryaputra <ssuryaextr@gmail.com>
> Sent: Monday, June 10, 2019 4:09 PM
> To: David Miller <davem@davemloft.net>
> Cc: Govindarajulu Varadarajan (gvaradar) <gvaradar@cisco.com>; Christian
> Benvenuti (benve) <benve@cisco.com>; netdev@vger.kernel.org;
> govind.varadar@gmail.com
> Subject: Re: [PATCH net] net: handle 802.1P vlan 0 packets properly
>=20
> On Mon, Jun 10, 2019 at 02:28:10PM -0700, David Miller wrote:
> > From: Govindarajulu Varadarajan <gvaradar@cisco.com>
> > Date: Mon, 10 Jun 2019 07:27:02 -0700
> >
> > > When stack receives pkt: [802.1P vlan 0][802.1AD vlan 100][IPv4],
> > > vlan_do_receive() returns false if it does not find vlan_dev. Later
> > > __netif_receive_skb_core() fails to find packet type handler for
> > > skb->protocol 801.1AD and drops the packet.
> > >
> > > 801.1P header with vlan id 0 should be handled as untagged packets.
> > > This patch fixes it by checking if vlan_id is 0 and processes next
> > > vlan header.
> > >
> > > Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> >
> > Under Linux we absolutely do not decapsulate the VLAN protocol unless
> > a VLAN device is configured on that interface.
>=20
> VLAN ID 0 is treated as if the VLAN protocol isn't there. It is used so t=
hat the
> 802.1 priority bits can be encoded and acted upon.

David,
  if we assume that the kernel is supposed to deal properly with .1p tagged=
 frames, regardless
of what the next header is (802.{1Q,1AD} or something else), I think the ca=
se this patch was
trying to address (that is 1Q+1AD) is not handled properly in the case of p=
riority tagged frames
when the (1Q) vlan is untagged and therefore 1Q is only used to carry 1p.
=20
    [1P vid=3D0][1AD].

Here is a simplified summary of how the kernel is dealing with priority fra=
mes right now, based on
- what the next protocol is
and
- whether a vlan device exists or not for the outer (1Q) header.
=20
PS:
'vid' below refers to the vlan id in the 1Q header (not the 1AD header)

Case 1: vid !=3D 0 , no nested 1Q/1AD  - OK
Case 2: vid !=3D 0 , nested      1Q/1AD  - OK
Case 3: vid =3D  0 , no nested 1Q/1AD  - OK
Case 4: vid =3D  0 , nested       1Q/1AD <--- The patch addresses this case

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
Case 1: vid !=3D 0 , no nested 1Q/1AD
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
	Packet looks like this:

	[802.1Q  vid =3D V ! =3D 0] [Next header: Anything but 802.{1Q,1AD}]

Case 1a: Vlan device present (*)

	__netif_receive_skb_core()
	+-> skb->protocol !=3D ETH_P_802{1Q,1AD}   <--- therefore no call to skb_v=
lan_untag()
	+-> vlan_do_receive()
	       +-> vlan_dev =3D vlan_find_dev(...) <--- vlan device found (*)
	       +-> skb->dev =3D vlan_dev
	+-> Deliver skb to vlan device
=09
Case 1b: Vlan device NOT present (**)

	__netif_receive_skb_core()
	+-> skb->protocol !=3D ETH_P_802{1Q,1AD}  <--- therefore no call to skb_vl=
an_untag()
	+-> vlan_do_receive()
	      +-> vlan_dev =3D vlan_find_dev(...)     <--- vlan device NOT found (=
**)
	+-> if (skb_vlan_tag_present(skb))         <--- TRUE
	                if (skb_vlan_tag_get_id(skb))  <--- TRUE (***)
		          PACKET_OTHERHOST
		  __vlan_hwaccel_clear_tag(skb)
	+-> Deliver pkt to next layer protocol
		If we take the example of IPv4, ip_rcv_core() will drop the pkt because o=
f
	 	PACKET_OTHERHOST.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
Case 2: vid !=3D 0 , nested 1Q/1AD
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
	Packet looks like this:

	[802.1Q  vid =3D V ! =3D 0] [Next header: 802.{1Q,1AD}]

Case 2a: Vlan device present

	+-> if (skb->protocol =3D=3D ETH_P_8021AD) <--- TRUE
	        +-> skb_vlan_untag(skb)
		+-> if unlikely(skb_vlan_tag_present(skb)) <--- TRUE
		               return skb
	        +-> if (skb_vlan_tag_present(skb)) <--- TRUE (again)
			if (vlan_do_receive(&skb)) <--- TRUE
			     +-> vlan_dev =3D vlan_find_dev(...) <--- vlan device found
			     +-> skb->dev =3D vlan_dev

				goto another_round <-- At the following round the packet will be delive=
red to the next layer proto

Case 2b: Vlan device NOT present

	__netif_receive_skb_core()
	+-> if (skb->protocol =3D=3D ETH_P_8021AD)  <--- TRUE
	       +-> skb_vlan_untag(skb)
		+-> If (unlikely(skb_vlan_tag_present(skb)) <--- TRUE (packet is .1p tagg=
ed, vid=3D0)
		               return skb <--- packet is returned as is, 1AD header still=
 inline
	        +-> if (skb_vlan_tag_present(skb)) <--- TRUE (again)
			if (vlan_do_receive(&skb)) <--- FALSE
			     +-> vlan_dev =3D vlan_find_dev(...) <--- vlan device NOT found

	        The 2nd part is the same as 1b:

	+-> if (skb_vlan_tag_present(skb))         <--- TRUE
	                if (skb_vlan_tag_get_id(skb))  <--- TRUE (***)
		          PACKET_OTHERHOST
		  __vlan_hwaccel_clear_tag(skb)
	+-> Deliver pkt to next layer protocol
		If we take the example of IPv4, ip_rcv_core() will drop the pkt because o=
f
		PACKET_OTHERHOST.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
Case 3: vid =3D 0 , no nested 1Q/1AD
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
	Packet looks like this:

	[802.1Q  vid =3D 0][Next header: Anything but 802.{1Q,1AD}]

Case 3a: vlan (0) device present

	Same as case 1a: packet delivered to vlan device.

Case 3b: vlan (0) device not present

	This is similar to case 1b above, with the difference that condition (***)=
 is false
	and therefore pkt type is NOT set to PACKET_OTHERHOST, which translates to
	".1p / vid=3D=3D0 header ignored and packet NOT accepted".

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
Case 4: vid =3D 0 , nested 1Q/1AD
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
	Packet looks like this:

	[802.1Q  vid =3D=3D 0][Next header: 802.{1Q,1AD}]

Case 4a: vlan (0) device present

	This is equivalent to the cases 1a/2a/3a above: the packet is going to be =
delivered to the vlan (0) device.

Case 4b: vlan (0) device not present.
	THIS IS THE CASE THE PATCH TRIED TO ADDRESS.

	__netif_receive_skb_core()
	+-> if (skb->protocol =3D=3D ETH_P_8021AD)  <--- TRUE
	       +-> skb_vlan_untag(skb)
		+-> If (unlikely(skb_vlan_tag_present(skb)) <--- TRUE (packet is .1p tagg=
ed, vid=3D0)
		               return skb <--- packet is returned as is, 1AD header still=
 inline

 	+-> Since there is no 1AD proto handler, packet will be dropped (but it s=
hould not)

Thanks
/Chris
