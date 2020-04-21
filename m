Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B801B309D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgDUTpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:45:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:22211 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDUTpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 15:45:04 -0400
IronPort-SDR: kgokR1c4ZXpVfyAEawhBXjS3GEIAgttDH8dDV5uwkSIA4jtGwn+QtigJ7L5LcJxpLhIv5gXG1W
 nL5MUMEAq+Yw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 12:45:03 -0700
IronPort-SDR: TdyOj/Ji7jFRHDeikT+uA/qPDW4FYUbhCGCPnTFWfzKGpfwkwjLVhLYF420fbAwkM6Cj26olUt
 U0yNs+WBw43g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="290584809"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2020 12:45:03 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 12:45:02 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 12:45:02 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 Apr 2020 12:45:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 21 Apr 2020 12:45:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjM7Vp9wnERPR/dKfO46Px5KjEW26KCMPejrnBlYjqX5+agwjdmEgkdahMAXJnt+flK0jNLf0kW4U/CxY3e+LqYG+iyyh0QOtsJFBkh+8k7OO3/k/CMJPWMk9ETXW+otcxySag0qzDo81Wm50eXJrnGdj8F7qXwpq6CqEo3wSjiKAxK+/jfjHqEd58ukrHT4/mWbO9T05Gdb+4Xb6ue5Vfo08AmBD1geF/HlKge3r5Kc1lCix4kSBLh+vNbplmQLxEgpJtQKS4y2x1F9QW6Q2n27t4Z5eaMgfaTKYt7T/3ICsWYdKKjGhm/qP9h2UM7NKJWo9hV0r3bIDKLb76ysVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3h90TmqyjfibcO2WIbq5JtMmbawzt/Ue939CG532LU=;
 b=ei/GwwtRQbxbHjkLTf8FF7JcWdVxbHJf71UVueLusCqJFayp0iupFTVMI1iCBxcaoAA9oaL7xlSmVavs7idmXoyTkHc40UDmhU3B5SxCc6z0hf5W0BqPzT4soYPq5Pkvz4KNFWilioQCZpGwobKYFEeXp5H1fOH9fqpgCBxmW6z6411tjxL/GTXI1DFdDFenkQIzdtTXJPSzDgGJDw6MKsgg/5d9xg13s7XGr2lSj/D2pJ9I83cIJLaDl4DnM0EBJg8pkvuGMSRr88xyRP+0RUa+zQb9+Vo/ssNu7UMzni2dBWk28qi2pTVfOP3cfKUat41N91cH3LV6wUjtksWoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3h90TmqyjfibcO2WIbq5JtMmbawzt/Ue939CG532LU=;
 b=dQyXwSh1GglkNDmUCjlIS11tVcLTnBFcAFtTzIVHypamieWNsFhagUkuhKSQeSqYK7lQDCXoVyXtgQD6vKV6ppHOEF/fvPb/cp97a8mn9C0hr3X7PiwL8VQeyvJLRDaroio/sMJ0R5NY98S5z94RdFIWXP/FIlADeU4Rb4BS6a8=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by BYAPR11MB2821.namprd11.prod.outlook.com (2603:10b6:a02:c9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Tue, 21 Apr
 2020 19:44:56 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::2026:169:d15e:8536]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::2026:169:d15e:8536%4]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 19:44:56 +0000
From:   "Fujinaka, Todd" <todd.fujinaka@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 4/4] i40e: Add a check to see if MFS is set
Thread-Topic: [net-next 4/4] i40e: Add a check to see if MFS is set
Thread-Index: AQHWF384tHXgU+McHk+GnQDbvMz7MqiD3j2AgAAcXlA=
Date:   Tue, 21 Apr 2020 19:44:56 +0000
Message-ID: <BYAPR11MB36067FA39EEFFB3D3CF0C001EFD50@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
        <20200421014932.2743607-5-jeffrey.t.kirsher@intel.com>
 <20200421105935.4a92485f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421105935.4a92485f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=todd.fujinaka@intel.com; 
x-originating-ip: [97.115.147.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ddf1d54-a4f9-4979-d2c8-08d7e62c7811
x-ms-traffictypediagnostic: BYAPR11MB2821:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2821436B3CD71D9EAA7D2181EFD50@BYAPR11MB2821.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(376002)(396003)(136003)(366004)(346002)(26005)(6506007)(6636002)(107886003)(81156014)(52536014)(8676002)(9686003)(53546011)(2906002)(316002)(45080400002)(5660300002)(110136005)(54906003)(66446008)(4326008)(478600001)(8936002)(7696005)(66946007)(186003)(66556008)(66476007)(86362001)(64756008)(55016002)(33656002)(71200400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3bixkC4a7QW9/pQ+sBUpGp5xitMmQwAGsTAC6FrCawdbsWzW7j+84JV8PJOvYXuR0JixmGCj0GAnn8uDPXiQI1bERR9amYJfWmi9WNG/+gIFYCw6fg1L7Jsw+D7CHqyak3HiYBdRhhRmMS2ItSNzHdZlxiSLHyxa3pn0PbcYkk/RD+iMhHDb9r3y0GCxPvGcgqEBn6knxg3m8rGiLyGE8VnjzSnX2BspMUl5umpQh9XGm1EseAyQceylI/gPAmFUiJ/jEo1IYruYg+5CsnYk8RxzFMlj6jkvjchFRbtFPHQjR/tfIcKksKOK/iFYD8mDavPrspwZSQy1s+MmWDx6a2ZC2lECXylIJVkBJsZiMBMAgg8dnHGGFeEfocDNxr+dXmF+ONh1mMrkf53MikfdBdSNd/9DTiladNp3R9cH2jmmPfw7BskutcbAqqKGBr4x
x-ms-exchange-antispam-messagedata: WK9uTtDIl9Bv5yDx8jUxUXRlNw6iEbs0txg3x8oMl7AFC1BZVRL6RTpVGOir2COm60Pj2EK2/RZWclzZQBQkm8TchFU3Vi6ujjUOvXPSJCMnwlCEnu3cqotNKyHlLfNaXhWDAIDc6bh1YhRUr1uIjA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddf1d54-a4f9-4979-d2c8-08d7e62c7811
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 19:44:56.2178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZXUSK1P0Afgg1axrBamCAdZs+dePayWFjdwpsLAy8lB66z0fhmGbPZyRMDZ0gl9HCc2NDfAXRZxaptYJwu3WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2821
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the top-posting. Outlook. I can't seem to find this email on my n=
on-Windows machine.

I don't know why we don't reset the NIC, but I was told there is a reason. =
And the reason there's an index is because
the datasheet shows four registers. Somehow while I was formatting that lon=
g line I lost the math bits that read four
different registers. Let me see if I can fix this patch.

Todd Fujinaka
Software Application Engineer
Data Center Group
Intel Corporation
todd.fujinaka@intel.com

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Tuesday, April 21, 2020 11:00 AM
To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
Cc: davem@davemloft.net; Fujinaka, Todd <todd.fujinaka@intel.com>; netdev@v=
ger.kernel.org; nhorman@redhat.com; sassmann@redhat.com; Brandeburg, Jesse =
<jesse.brandeburg@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>
Subject: Re: [net-next 4/4] i40e: Add a check to see if MFS is set

On Mon, 20 Apr 2020 18:49:32 -0700 Jeff Kirsher wrote:
> From: Todd Fujinaka <todd.fujinaka@intel.com>
>=20
> A customer was chain-booting to provision his systems and one of the=20
> steps was setting MFS. MFS isn't cleared by normal warm reboots=20
> (clearing requires a GLOBR) and there was no indication of why Jumbo=20
> Frame receives were failing.
>=20
> Add a warning if MFS is set to anything lower than the default.
>=20
> Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c=20
> b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 4c414208a22a..3fdbfede0b87 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -15347,6 +15347,15 @@ static int i40e_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *ent)
>  			i40e_stat_str(&pf->hw, err),
>  			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
> =20
> +	/* make sure the MFS hasn't been set lower than the default */=20
> +#define MAX_FRAME_SIZE_DEFAULT 0x2600
> +	for (i =3D 0; i < 4; i++) {

Why is this a loop? AFAICS @i is only used in the warning message

> +		val =3D ((rd32(&pf->hw, I40E_PRTGL_SAH) & I40E_PRTGL_SAH_MFS_MASK)
> +			>> I40E_PRTGL_SAH_MFS_SHIFT);

outer parens unnecessary

> +		if (val < MAX_FRAME_SIZE_DEFAULT)
> +			dev_warn(&pdev->dev, "MFS for port %x has been set below the=20
> +default: %x\n", i, val);

Shouldn't you just reset it to default at this point? If the value is not r=
eset on warm boot this is not really a surprise.

> +	}
> +
>  	/* Add a filter to drop all Flow control frames from any VSI from being
>  	 * transmitted. By doing so we stop a malicious VF from sending out
>  	 * PAUSE or PFC frames and potentially controlling traffic for other

