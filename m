Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D471CE8E9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgEKXOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:14:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:38630 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgEKXOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 19:14:20 -0400
IronPort-SDR: abUck11/6pQj+xk+7MnJ84tlFlTkJPO47UGAPeSQOXuc5dx+jPZhKkvO+uivaHcAoJGZAa1Yux
 3QynEL/+Jglg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 16:14:17 -0700
IronPort-SDR: 81qYP/AFmgS8cIV66ueeWVvmsHEvjnp+rR13xva3miR2n3QccCmQFeFrXQwuJ3JZMhOf+fj1dr
 SO18gRnaUUbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="463337688"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga005.fm.intel.com with ESMTP; 11 May 2020 16:14:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 11 May 2020 16:14:16 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 May 2020 16:14:16 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 11 May 2020 16:14:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 11 May 2020 16:14:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UO2iMQcLntBlNxHR6sf/tMh8X9EczEX8ewnbowZbyjWisHegN2OpT6Q4bHFDLzB1ATH6BlSIbMdZvh8XssKIzwC5AslLRxbiGLJhF+81p2/2yIug5J9ZuYnLN0JLh0+x1aE+zJRsZUUx9tzZTEHGFnu5vgIEnsx1wghcQfKa4p1GMi1W40UPKMIpPcf5x0HV6GtQT+/PHoss1Pe07YEoF1e7v6QtVlrdeGrQ2n9Isf3JG37u9/QhfM0KyEdM1nTSrSBTo0cGq1wDBaZ6WKUTlLYtIFjbhDu5je/eWvfedhp4iItC9nGiehSwxYuIX3D3xrMUrN899Y9FfkbUn4m8XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCX2yH63bA/8/oIS2hjtWmve5l15/9/or5XyqyqqKvw=;
 b=j0aWTrWrbNMoOQTEpnsBjrC1UFEGCUlNycSFTVBoVJTVZd0bSAmOS9l1Joo3DIwLfeovONyHRrWUOfTmUXLbU5juxaMIozFR5pTkC2A7yjwNYSDnLMigtfmI77ubtr7dX2AK03VokWIrcaA0B/JSNN0E/IScZiP17XNkCA2s2HoyXQiIXFxufNyR/aJZuoGdo7gfyInFRG8iM44AViIr9e72zlb4uMoz3UhYw208aJ5IdnLQ+DqK9XKVPZMNvECZoerLpGnVjyFlbGKZw0Rc+HjDS2TcZGJBtcKrOCzY+BIA83HUeCEQz2TA8ja5u8TFQ/nXJeVTho38IhwXE/cFmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCX2yH63bA/8/oIS2hjtWmve5l15/9/or5XyqyqqKvw=;
 b=erhbKAv7Uq304GKjKXgDwni7VQtfjBcfvteeYkXTetbH4GfK6vI6X3H4X4HF/Y82DpFF597UmJ7P6Vj21E+4URV2yM91CncSN0dcBBddUdSdJ43t6xQ/l5C+ySbRVRJkBB6yVsuAV5tEB06bxum8YTHb8733QUclLrXKyA2RkVA=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB3228.namprd11.prod.outlook.com (2603:10b6:5:5a::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.28; Mon, 11 May 2020 23:14:11 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 23:14:11 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] igb: Report speed and duplex as unknown when device is
 runtime suspended
Thread-Topic: [PATCH v2] igb: Report speed and duplex as unknown when device
 is runtime suspended
Thread-Index: AQHWIpIDJj+i8q8yvE2ZGA3JsYZy76ijjmYA
Date:   Mon, 11 May 2020 23:14:11 +0000
Message-ID: <DM6PR11MB2890802168856F147839914FBCA10@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200505040154.24080-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200505040154.24080-1-kai.heng.feng@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54fe4544-8ef2-4291-e0ab-08d7f60103dc
x-ms-traffictypediagnostic: DM6PR11MB3228:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3228AA7D36CA0BE898425ED0BCA10@DM6PR11MB3228.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 04004D94E2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HK/s2hZVn0f3O8IUP6WN8bspwGGhs0IQwTyJVeFTbCBscOh9jGsxIRnP9iu5We7/92e4KLXyAFz0LtjJB0Kar9gD2d4gDxHan2wgJOXg1Eq4Q/jOqUhm8l5qBrnnQPk1kpQBe6hRMV6b95oSMATehMA9aXaJzYnWdkJ1+Z43bJtpFbICwMY3tAWeQMT4Ga/Y1EsZMKewiNnxjyU+pO6UGBYHbGBoi9gV/PkiwtjN++S6M/Cs2Nfsj3wYNSi4n1JZyRy0xLBK4FugBQU9fwgFKbKkUhytMLi+MjQTMNwUIjl+UajpKPOlH92xMsbJ/jJEt5VzjHCut5iVOGYCg/sz6Y4QYgNIWhlY9cS0AomZl0kQAzy30kF2MUQph+Ysyv7Jg/bphyku1qbi1edKH0tejchu3Y/k6ywWvPtDA65QSluw1MW6Rpz+Q7oh/cPVwdC2FrQGz64E8gcAwbqt/IpSdMPPf+DDCMIdX8XM5DzMWr3wfhrsEfQHPVqaAZqkvk7GzgxdlyoB6Mjhs05d5jC5Fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(33430700001)(86362001)(5660300002)(15650500001)(186003)(7696005)(9686003)(6636002)(76116006)(54906003)(316002)(110136005)(55016002)(33656002)(52536014)(33440700001)(64756008)(26005)(66446008)(6506007)(8676002)(2906002)(53546011)(4326008)(66946007)(478600001)(8936002)(71200400001)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OB2lFbnxpXj31moft4Vz2hlS6iCxdEvyT3YoCL2GszJow1zEZ/vqa76XR192zmi1aBVOpLmBNP4PjT6LiG39UMJRcXPUFqYGCf/LllsKB80OJJoDSIaaWDbcGReRV/SYmV6gO+sjb4nJhSiQGTyRzxznawZCM69GQf8fjzJsEmT/eDIr8l9ZmR+9yIEBypeL3K04lt/SIFEjGvSTxCThj+xIpofIsWxPpdv7YlrWmGRNCqRJoibcpQ+MzfxxforkeXoaAdOIcj5K7BMJRXVEmK1UfmuT8M0hyodyZ6wgUrfgm9uDcRpskt7Oai4bLwjoPA92fQI8Dcso4BM71610Hr1Lb93ZhYXfJXFbKht0cfGYjsP50IVZVy0kV97qX+pWnjlb0IdAOW2o6MM5RmXjdMJYkBX6BHlEs7h2YDxonS5LMrv9DT8v1KpQfSphBo1shjI0BQEW7Rj1aM46d1HgEGmK1uCP0DM2EuvpVWMaj34=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fe4544-8ef2-4291-e0ab-08d7f60103dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2020 23:14:11.5392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 78RHrRS3PaG6xXO8xRJVLEmcPDWJQ0LRV+KyT3CNbVuK2uq28Ii8fhGEIV/0AzRQ2H9I/W4wwtYinUL3eoZ4qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3228
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Sent: Monday, May 4, 2020 9:02 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>; Brown, Aaron F
> <aaron.f.brown@intel.com>; David S. Miller <davem@davemloft.net>;
> moderated list:INTEL ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.org>;
> open list:NETWORKING DRIVERS <netdev@vger.kernel.org>; open list <linux-
> kernel@vger.kernel.org>
> Subject: [PATCH v2] igb: Report speed and duplex as unknown when device i=
s
> runtime suspended
>=20
> igb device gets runtime suspended when there's no link partner. We can't
> get correct speed under that state:
> $ cat /sys/class/net/enp3s0/speed
> 1000
>=20
> In addition to that, an error can also be spotted in dmesg:
> [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
>=20
> Since device can only be runtime suspended when there's no link partner,
> we can skip reading register and let the following logic set speed and
> duplex with correct status.
>=20
> The more generic approach will be wrap get_link_ksettings() with begin()
> and complete() callbacks. However, for this particular issue, begin()
> calls igb_runtime_resume() , which tries to rtnl_lock() while the lock
> is already hold by upper ethtool layer.
>=20
> So let's take this approach until the igb_runtime_resume() no longer
> needs to hold rtnl_lock.
>=20
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Aaron Brown <aaron.f.brown@intel.com>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>  - Don't early return the routine so other info can be set.
>=20
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

