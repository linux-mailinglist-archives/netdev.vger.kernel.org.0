Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E32A1857F2
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgCOBvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:51:45 -0400
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:35101 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCOBvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:51:44 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2020 21:51:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2726; q=dns/txt; s=iport;
  t=1584237103; x=1585446703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kgczx+gvSLMST4+4R4PQtvckEltAlA+35hIn4N7W1XY=;
  b=a5/0otTh8U60u1XcleCTy/qbB0rp7ry/ivoPnyWLBD9tiSnPZMbx7ZLL
   PkXmJy4+jx9iE86955yI0xYmDympWZ/gGYhyvDS4yz0jIwlJtiI9yiy+o
   9jMIgFmpiOI+8pzKF1vj0bsBZErTNh9EfpjVZKDOkp+0StBjlar8cVKGF
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3AizStbRG4ThHEWYWzGl2XY51GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4w3Q3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+efzwaDc3GuxJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CPBQA8xmxe/5tdJa1mHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgXuBVFAFbFggBAsqCodRA4pygl+YGIJSA1QJAQEBDAEBIwoCBAE?=
 =?us-ascii?q?BhEMCgh0kOBMCAwEBCwEBBQEBAQIBBQRthVYMhWMBAQEBAxIoBgEBNwEPAgE?=
 =?us-ascii?q?IFSEQMhsBBgMCBAENBQgagwWCSgMuAQ6hIQKBOYhigieCfwEBBYU2GIIMAwa?=
 =?us-ascii?q?BOIwuGoFBP4FYgk0+gmQDgUIBASIwgxGCLI1VEqJaCoI8kE2GQYJKmHktjle?=
 =?us-ascii?q?BTpoNAgQCBAUCDgEBBYFpIjeBIXAVgydQGA2OHYNzilV0AgEBgSWMEgGBDwE?=
 =?us-ascii?q?B?=
X-IronPort-AV: E=Sophos;i="5.70,552,1574121600"; 
   d="scan'208";a="651593719"
Received: from rcdn-core-4.cisco.com ([173.37.93.155])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 14 Mar 2020 11:56:50 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by rcdn-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 02EBuo7o002704
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Sat, 14 Mar 2020 11:56:50 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 14 Mar
 2020 06:56:50 -0500
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 14 Mar
 2020 07:56:49 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 14 Mar 2020 06:56:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vw8yxHhJmX7PdiXrV00PMaUOdLLBbOZY+z8bJIp+TCwnBpWx5WJyILSWX7bc2/cA1WG7mqPr+5U1Uws1VIpAnWuNr5/TYOexveIvoq+Q5/tw7Re4G/b+fZuG3BLpINWbQ4EjsFieT+qknmxoDKh3dc5iUn5j9x6RHZ3rwSEy2mnR5nUbQ77l6Fyp2RoQ1pVF1ekEm8i3s5+dJU41Eye+LnPZLLkteZ59Jhwi52gs74wgrKDI3pUenTHJnaVRJaBC8PJli6wMu8UzT7ZKqD86O49P5dpaIhGFWmLERnSb8Uhi6FwLBXQVSGnEoGGQZ8MDCHSQF8cJQQcNKxqml8A4LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgczx+gvSLMST4+4R4PQtvckEltAlA+35hIn4N7W1XY=;
 b=YAzh3Y+0JZKfablb81V/6+et+3gsmzMhnHOuT+RvaBJZljS53ELr4TptKU02CZDD903yBSYswFI70m9XZcQiuZ7oUyjF6U8qGUBQapP3OHI5kIoM8VRVKQObnfX5cdEDK5Xl/EVjqxn+a4h+h0F97buF1mDB17+/d2Kuy+AFFLoRmVROYhcZt+CcChuRgIw7sFEXuN7SURBi08z/KonYyUN8f1H0CX5PZgYibcKetjU6pIU11XFucGnAUHhO/hEefAGShJkcxtuAsOC+HLoPOTHySyYdclgtuMExWUnfTVoQ5PlshXj30bjrKynjyiN5ul6H6rxjrPqNKSrnqIOaCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgczx+gvSLMST4+4R4PQtvckEltAlA+35hIn4N7W1XY=;
 b=c4on8IiUC6+dED4RWAnF1lQuXf3Wa2VBr37cHj0tFS8ca2pkKHSfn6jSzHgXSqYs/VVEWtIzYcDl2kngkt1xssy5lMtmY6VAI/0zTVn2AIsdlc9ryqBi0YO6ViCGjjT0Er1kK+WPaZp+Ib6reAV27AoQEnrQAZMS61aA2evo0jc=
Received: from DM5PR11MB1756.namprd11.prod.outlook.com (2603:10b6:3:114::17)
 by DM5PR11MB1705.namprd11.prod.outlook.com (2603:10b6:3:e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Sat, 14 Mar 2020 11:56:47 +0000
Received: from DM5PR11MB1756.namprd11.prod.outlook.com
 ([fe80::20d3:f115:ffb0:6146]) by DM5PR11MB1756.namprd11.prod.outlook.com
 ([fe80::20d3:f115:ffb0:6146%9]) with mapi id 15.20.2814.019; Sat, 14 Mar 2020
 11:56:47 +0000
From:   "Jon Rosen (jrosen)" <jrosen@cisco.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Subject: FW: [PATCH net] net/packet: tpacket_rcv: avoid a producer race
 condition
Thread-Topic: [PATCH net] net/packet: tpacket_rcv: avoid a producer race
 condition
Thread-Index: AQHV+VMOPcbHVbWKSEuz6XmXlPikXKhH+szw
Date:   Sat, 14 Mar 2020 11:56:47 +0000
Message-ID: <DM5PR11MB1756E19258EABA5643011031CFFB0@DM5PR11MB1756.namprd11.prod.outlook.com>
References: <20200313161809.142676-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20200313161809.142676-1-willemdebruijn.kernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jrosen@cisco.com; 
x-originating-ip: [173.38.117.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c97124d7-99f6-4933-ae08-08d7c80ec638
x-ms-traffictypediagnostic: DM5PR11MB1705:
x-microsoft-antispam-prvs: <DM5PR11MB17059458CD45440333C75257CFFB0@DM5PR11MB1705.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(199004)(6506007)(478600001)(9686003)(55016002)(26005)(71200400001)(316002)(186003)(4326008)(54906003)(52536014)(110136005)(5660300002)(7696005)(8676002)(966005)(2906002)(33656002)(64756008)(81166006)(76116006)(8936002)(66946007)(81156014)(66476007)(66556008)(66446008)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1705;H:DM5PR11MB1756.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dkWKc+I0AU2AWWrGNI44m+QrommQTnojKwmfQ/tu8/PmYQbTOKO2JeMON4RGKNsmXAy9Yhjx2VnmZ8hX6Sw/OM3MH+p2k2L5XRJhFU6u2l32s+0WqreusxKIq//6eIVf9WALwmoIk+5hcP2bQFQF0I5c3kCLUlTT7pIq2shhiHb4rwIyR/xnu5dv5TXkk1HuoZyrJpSpEC3GuqHH3FRjGhLfjvCVmd8BdgR+ROppUuLLdBJXNItSn/ErK/szkzG6D1U4CnllPetpPQP688fiLm611rng7WeQTAPVljNlWQrvLn1fmfzwCCJWG/pvmGzqjvMNb4PjXTvJmL0hRyyJCbs7Ejq/rEO5y4Xg6I1PmrMFkJloQ55UpUtQ0QIVpsFYwoDWNWwGWNCTFY4eoYIfFUcDBHlaYhqGKTCWuv8sGIeGtplyKQRp5WyZcTXGWv0Ov1lDbIpmrjkPLO1NuLsPeUSBYK3odrViZZWFNrBLZxu8x2vc0Y+yxsWj4lCcd/nwtoR5wV0klECE2BGrjqXUCA==
x-ms-exchange-antispam-messagedata: Yspra+Es1MUutuspsRIMfFBy7D9GjdHp39wEky8o4TFIOlzjhj+40w4bHHU3+RoRnFozGGezW6I7hYbtEUu1LeAGj6DVm0OG/GY9PqZ0wCpu/ib+nES4a6u+4vVQk8JUKjFBCvp9pSk7dOMkvYJnlg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c97124d7-99f6-4933-ae08-08d7c80ec638
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2020 11:56:47.5675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7yafCmp06VYwl0FlMNgw+Op96p01I0iHhIw568Frysh5RTHF5GOWyOeX/f8C7z1h2wd2Oi1o0slMMwUhFn3zUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1705
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: rcdn-core-4.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

PACKET_RX_RING can cause multiple writers to access the same slot if a
fast writer wraps the ring while a slow writer is still copying. This
is particularly likely with few, large, slots (e.g., GSO packets).

Synchronize kernel thread ownership of rx ring slots with a bitmap.

Writers acquire a slot race-free by testing tp_status TP_STATUS_KERNEL
while holding the sk receive queue lock. They release this lock before
copying and set tp_status to TP_STATUS_USER to release to userspace
when done. During copying, another writer may take the lock, also see
TP_STATUS_KERNEL, and start writing to the same slot.

Introduce a new rx_owner_map bitmap with a bit per slot. To acquire a
slot, test and set with the lock held. To release race-free, update
tp_status and owner bit as a transaction, so take the lock again.

This is the one of a variety of discussed options (see Link below):

* instead of a shadow ring, embed the data in the slot itself, such as
in tp_padding. But any test for this field may match a value left by
userspace, causing deadlock.

* avoid the lock on release. This leaves a small race if releasing the
shadow slot before setting TP_STATUS_USER. The below reproducer showed
that this race is not academic. If releasing the slot after tp_status,
the race is more subtle. See the first link for details.

* add a new tp_status TP_KERNEL_OWNED to avoid the transactional store
of two fields. But, legacy applications may interpret all non-zero
tp_status as owned by the user. As libpcap does. So this is possible
only opt-in by newer processes. It can be added as an optional mode.

* embed the struct at the tail of pg_vec to avoid extra allocation.
The implementation proved no less complex than a separate field.

The additional locking cost on release adds contention, no different
than scaling on multicore or multiqueue h/w. In practice, below
reproducer nor small packet tcpdump showed a noticeable change in
perf report in cycles spent in spinlock. Where contention is
problematic, packet sockets support mitigation through PACKET_FANOUT.
And we can consider adding opt-in state TP_KERNEL_OWNED.

Easy to reproduce by running multiple netperf or similar TCP_STREAM
flows concurrently with `tcpdump -B 129 -n greater 60000`.

Based on an earlier patchset by Jon Rosen. See links below.

I believe this issue goes back to the introduction of tpacket_rcv,
which predates git history.

Link: https://www.mail-archive.com/netdev@vger.kernel.org/msg237222.html
Suggested-by: Jon Rosen <jrosen@cisco.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jon Rosen <jrosen@cisco.com>
