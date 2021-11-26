Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FE745EB22
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbhKZKTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 05:19:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:30432 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232355AbhKZKRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 05:17:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="235582915"
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="235582915"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 02:13:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="510592635"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 26 Nov 2021 02:13:59 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 02:13:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 26 Nov 2021 02:13:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 26 Nov 2021 02:13:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8hs6QiNe0xw/vxHDKMV4vGYbqqt2jfxuxsvsrbb49pdpcR4CZ+wb8/zlUSBe0MT9D/4wU4ZMxIg3+JRN6Kr9n4YyjiG0KAupMwL+mmGdYotvr8h3Ti1lgKE1uAo3EH6mSFoJOZYs1UfCXEFMhMFx9h0hcALXmynVSrKj0ye+hBxn0mmzEA9l1F0jcr6LmCxFX4UM618/vlWBIkrK63eSe9YZphwHxZM3wsK0qUkN6KVHp37gYYoxseU4igo5IkfFDpU2gdB8LlbIo//dyKQZZN6AP6o8UymMn3SgyPRIbTnT1flzGi1CQkz+ULGF6TYbxvD+83fBlsdsNm4/94uMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6E4vp8kTHrzBqHuFYhTQGtJtCY2eWKlZdKdxnSBXSHg=;
 b=QC7712GNt80/EtTTYuNKNGXEoVc7zr3bPkppF4lTjH+SEutHfNK0oHhNZFAR/26QgHQ/1/CL/7On5S1+wAP4c+kIdddtJmRJeua/0ezVtFdwafE5HO4pAvDAF7Jh8qrz45dhxlHYMJZSFSQKpbEeRQeT0ta0LSIWraK1ncJw4n0DLY1r0CDHj78QRnV1ZbzcehXSIQbJF2g5s1gWd+1p7L2YyCinnjb29VgLcve3Ed0SB46EsTPhlgG3NZOzgacZdP7pTDU0xun7cy9gBWoxPZfIx6+X4+teSZKQwdiBD66ZmBUkUDn0qJ5ARYxOEY1TqgeE64iumZfF/bbCtDtoRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6E4vp8kTHrzBqHuFYhTQGtJtCY2eWKlZdKdxnSBXSHg=;
 b=PYGtEQxFPBEEBeUDd61uGfvjBHWRfsxrBZhAPzG9n3VW//hEWkeby+1vrjdQMUSSfGwTlBNVVEs3arpqd96KLoUtqWI96NWLzASSFAy6uGS7s7RxAPhqKTrRS/Vb3SSPHPmmDpuYnbCvDQ5ozPjxBa/wDuxBBAUq33BJlbqWR9A=
Received: from SN6PR11MB2733.namprd11.prod.outlook.com (2603:10b6:805:58::22)
 by SN6PR11MB3199.namprd11.prod.outlook.com (2603:10b6:805:be::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Fri, 26 Nov
 2021 10:13:56 +0000
Received: from SN6PR11MB2733.namprd11.prod.outlook.com
 ([fe80::8df9:13fe:fb00:71cd]) by SN6PR11MB2733.namprd11.prod.outlook.com
 ([fe80::8df9:13fe:fb00:71cd%7]) with mapi id 15.20.4690.027; Fri, 26 Nov 2021
 10:13:56 +0000
From:   "Jagielski, Jedrzej" <jedrzej.jagielski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: RE: [PATCH net-next 08/12] iavf: Refactor iavf_mac_filter struct
 memory usage
Thread-Topic: [PATCH net-next 08/12] iavf: Refactor iavf_mac_filter struct
 memory usage
Thread-Index: AQHX4VdKeMvXPXtsEUuTAi5bHvPVjqwTWSqAgAJApGA=
Date:   Fri, 26 Nov 2021 10:13:56 +0000
Message-ID: <SN6PR11MB2733AAB302567F2DA6AD818CF0639@SN6PR11MB2733.namprd11.prod.outlook.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-9-anthony.l.nguyen@intel.com>
 <20211124154931.5d33dc33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124154931.5d33dc33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40a6e901-0a84-43f7-472b-08d9b0c574c8
x-ms-traffictypediagnostic: SN6PR11MB3199:
x-microsoft-antispam-prvs: <SN6PR11MB3199326AA356E9347BB2E8F0F0639@SN6PR11MB3199.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ge0p7J5JrZAX2eqZbm9Aay8r4L0nYZwBqD61EDTKaOWicrVEU6mE7dPKZ86IFiK32d4QDxp6icE0MSqRM3rezSKTP6uooE1W9itb6LvqxT3W4XMoIV/8p7oeSPZpASMG0Pd0xv0JNaWs7880sof+8VlPO2U5VQ3UslzsXNWI/f0F22UUkjQ0i6ykooVLNjd3/kuI5lrD29yz7a3aWprIlb9doe9SVnKokImdhbsx9XBFuFeEx94RHBlrBz15r60lHxL9uJfw7NPu1mSIyQEoVMzPSnN/RVS9qgRY1vMpEj/VKnP8Q6NRHOLaCy80mF0RwLb8gwG8iwSqH7W/4Epyu6MVILrueWBm3bYVDs584aNsPFvVjFUtYMbXqc8a1r111myZ18uHH5htfupvl/u1v41SPVxnc3w2U7F5n0OqjBytWAXVcE0OmIScmsAzVaYKsgbRt84oXa80gee7WyRsmSx+oKcSOMBKQ5k9iNhljS1GBmDbDjcve3Bnjm/IJuOK6azA3gleTekPqObM6cNrNliNutcC1//GI8wD3Y8VBkT72iFycmOpAb1ysE0yvA4wi0/vow2pqIvQjaTBZ5xAQ2HF2Wn89cPJYoHPTV2GlDlRKIObWj7KNK7AT+Wcp4uW/2rrf0ySD6NzSW80zvFXzTDiuDdna+ppdLm1EUCkKefzntQrA18kKSmwDsH8aZg8NhLRm4t9Q2IhUqGVs6vJjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(107886003)(82960400001)(33656002)(64756008)(26005)(38070700005)(6506007)(66446008)(186003)(508600001)(316002)(66476007)(5660300002)(83380400001)(86362001)(66556008)(110136005)(54906003)(76116006)(52536014)(9686003)(4326008)(66946007)(4744005)(6636002)(71200400001)(8676002)(7696005)(122000001)(38100700002)(8936002)(53546011)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aHT6/V7WmlWCRlMu0tBAlwgXYC6se2ONWXE73pRnzqYrU1ZjIxuYwAM/QeaD?=
 =?us-ascii?Q?ymVuUssRbn2ZPvrTcuu6Nz9xPWPz/09aE+RO+ilnNiQ+5EImyvNO5jcQUwB7?=
 =?us-ascii?Q?LnVgZc9RKJ9jPg4R2j3P20dG26qf4V3iTtztsHThdHKkZVE1u7SfTK6vr4tD?=
 =?us-ascii?Q?aneAUNoV+C+64DT14mh5Sr9C1dNfDsA1j+5monRBfQzbP7wt20Vm7eey0/s9?=
 =?us-ascii?Q?DKAWGJpZ4e8EwYvF01KB6najAjuVW/1F0JCM7+7h5a8yfkuTO6JqbqQKnudz?=
 =?us-ascii?Q?by/ai1iduf6TpNc+e9K5Hbraszo81rcll5c4XxvZw40NCzwkHsKImvG/j9mn?=
 =?us-ascii?Q?dhJRaq71XDCenQcXr2awa1Apra61ehEDXd/gqEw3q9GJZgkVRnEWCr4JJ5Ye?=
 =?us-ascii?Q?LpEsHg1VDuMqttUNYLe6E9XO4rcGU7rDcSpg57cBa+8vOwKPgaVR2y/EK1df?=
 =?us-ascii?Q?J7UnGnEtvq5f8E+AC7erlMDpk9+EFE7jQWeRCFl++q09kdGCxgFEhEdGHkbU?=
 =?us-ascii?Q?ExIknav1KtjJezsgVQ1l2cKyBHzRf0JNu14SryCN0PzhaUb7giXRaLRPEAqh?=
 =?us-ascii?Q?HWD1NkMizzPK689CXEeoncVbcnsHCdyN7Tpl9jWyW7NwVHzMH7mxJHp3xS+o?=
 =?us-ascii?Q?k8QaECIxuJYVmXH+b7MG/sxOtOGtO6Znj+Bly7xX/lrHxD49umEkeTLbpv3+?=
 =?us-ascii?Q?Pa8AIaejHXqfgslSdQdMGRr164TPirtCyd6t13V+4qwJCbzbiUL36Fs4Fjcm?=
 =?us-ascii?Q?wJa5NHS6yBeEOUjiNPSF6I2EZ9rPPRJExi6p9RLA1zMJ/BpihQ6I8iiCgLGA?=
 =?us-ascii?Q?0oJ9gGalGX0IV0ShNAD/U1o/QRLZ/CB00uKbeJO82Lop2CFbetNz1tOAAeZg?=
 =?us-ascii?Q?88lUcXpXmU+s+yqWbpNAakEL6iHA/NgMrJZ2mTCuFfAETxfN39YgfHl5oz8s?=
 =?us-ascii?Q?5KKynYCogzFsyFf6HssU2FermVeP9oEkiSWxfMhiD7ki32n+NRddI31+eVYh?=
 =?us-ascii?Q?JafyiuNP+Y+syLSJ0ezga7aRw5BTdZnVSzoVjQRRtam3Jk58/ooAPnWzdMzr?=
 =?us-ascii?Q?P826kGVLQBRQAwkEPbP9qMGBVvNQrD/ULDRN+g6Ei/FxsQRdX3WJagBcVSEC?=
 =?us-ascii?Q?zmW9tH+AS6opel2J5B2FKsbGkPNykH9AzS5JwNYOoQXdwjhO2W5Q9w7fMDW9?=
 =?us-ascii?Q?7WYhqrWmJLuTxDNU4DTM8R+llptH1j3Ub/CYuonXn51XuqPNZQ4QMncR6eZ3?=
 =?us-ascii?Q?LhrDMzKe5aeYpeVZfHLILnzd2x9wRf1aqkXzn7OHpfudBWajOGvZ+EuTla3U?=
 =?us-ascii?Q?ii1GVIRpWFiurbNkfSU7MiPXLJ+kR4YiHnn6da+X5+oHp6k7Cw3VsEu675Y9?=
 =?us-ascii?Q?QORQ4kB4w/OhANEWTC2X2LPL8cnbA8/yZquRveUkzAPj6ifArvnwOhq947gc?=
 =?us-ascii?Q?jVJM6Vh4kzcq+zbHsOL4A9snaY5jRb8ZtcJB1hkwtqzHavyqSZx8BKK7a8lx?=
 =?us-ascii?Q?+lDa/VC8KJKxcg5DhUZp2qKNtolgutbBPejpk0ImIwkIsd0A/O/nMoS4N6AI?=
 =?us-ascii?Q?NNmkVcUugIPyaBFy6fqWFO86QcEBZpfhzrXyHyiX6kf9EWF5AtIk9IX5o+u7?=
 =?us-ascii?Q?w5N+X5SH1FMfVmFB8RcTYfMx5Ks6aysel0mgNsnyBYbq0+VqeniwMALl0HAz?=
 =?us-ascii?Q?GfmPKg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a6e901-0a84-43f7-472b-08d9b0c574c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 10:13:56.2734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p6D16st93X8dxp+7RM7GZ0ktwZEvoaf4wyjZOaqSSDFictxnrU84dy+a2NxPyhdiagvMtlZe1UmjaDA0TLvJh4lVtQvfKMw7PT/mOrokr54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3199
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Just to group them so they all occupy one memory chunk and for it to be cle=
ar how and where to add new ones in the future.


-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: czwartek, 25 listopada 2021 00:50
To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net; Jagielski, Jedrzej <jedrzej.jagielski@intel.com>; =
netdev@vger.kernel.org; sassmann@redhat.com; Dziedziuch, SylwesterX <sylwes=
terx.dziedziuch@intel.com>; Jankowski, Konrad0 <konrad0.jankowski@intel.com=
>
Subject: Re: [PATCH net-next 08/12] iavf: Refactor iavf_mac_filter struct m=
emory usage

On Wed, 24 Nov 2021 09:16:48 -0800 Tony Nguyen wrote:
> -	bool is_new_mac;	/* filter is new, wait for PF decision */
> -	bool remove;		/* filter needs to be removed */
> -	bool add;		/* filter needs to be added */
> +	struct {
> +		u8 is_new_mac:1;    /* filter is new, wait for PF decision */
> +		u8 remove:1;        /* filter needs to be removed */
> +		u8 add:1;           /* filter needs to be added */
> +		u8 is_primary:1;    /* filter is a default VF MAC */
> +		u8 padding:4;
> +	};

Why did you wrap it in a struct? Just curious.
