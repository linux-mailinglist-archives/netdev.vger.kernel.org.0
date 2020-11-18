Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9CA2B8218
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgKRQmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:42:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:2401 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgKRQmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:42:52 -0500
IronPort-SDR: q06xIyOus30q8nkAaXf8dfa+FjvS0Cd7K7LkMASNAoxrsuEy7ilyY79ZMZSLFP5kRcZsgtj4r9
 yIP++7VrrENw==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="232758048"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="232758048"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 08:42:50 -0800
IronPort-SDR: le//3P3UwJScKmJrckCbQ5lBNBAiRDt9/uySHHbgDJPj8s6LxGqeEfpASwYvZfPO5Rz/cU2Ipa
 pm5WmY2pMooA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="311294584"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 18 Nov 2020 08:42:49 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Nov 2020 08:42:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Nov 2020 08:42:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 18 Nov 2020 08:42:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQm3Wjv4gr5/FdCtzenLMmcd0kz6D1GTjD3KwWLdXT0K79rrYTHGnM3odQEbMbCvlmTYNFy14nIMVuSp+ncBGltjebVvAIWuHHRcxZIqQAr0GYrXmxYQqUAwT7O0URLfKt0sX5oiOSTROGzu9WCvYb1IXrSpmfD65hVOm7ZfrmkSpAMjrGDzg16pM2zl8Pm7FOn1XQDVkO6Ri0XcvRGKehueNDdxVhWIpsYJTqEfnWgpm4nm/wtvJwy6+hXPscql9STujsp80wx6F2LbTaq6igOPBzqg5EQhHiP2jtADC8hsM63uC1xI5a9w5qs3+M9IS9vb9EW2uWV0FSBftl3shw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtTyEOMbwnQhJ16sGWtJbxkiLz3EER8MwV6kh/3jNyg=;
 b=d1a500vRUjYlt+5yl9di/hQOykrFEzLoQlxnaEjR+kJzCx/T0ZipEXmQD5U9jPD9SiKIpeU0CknNpYFJxb/aU5qTK8sXYgCmGQrLxiW1du7dMpCXKEAX9o3bNUvn8r3br8TXLyoqUhRPrhX5SnpEV2ja4fNYu4QgSgAeJX0Tfrb36fXFK8U37j+XSGP6rrFD4NAhAhWa9paI6M7alGRRfp6xDcA101hnxqHrVKmo+U2Ax62FgpZxDf5MTCQIN/1+lyzrxvOlf7rtw5NvZjWAbuAyY/tnTUCH3leyRhR6BEqTSX/4igE2jbz1XXpYtIYMBWZe00WlFeNyG/2fOXMHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtTyEOMbwnQhJ16sGWtJbxkiLz3EER8MwV6kh/3jNyg=;
 b=O8/SmZCUvIkrXcPTDfBjrPSRGrq3+IvJVk6WQfo/H+jgpjef27omVdZ1t/+QdVb5QpY3+iRZ3sfxZ0fNrUXXZow5VGunHd9DRAaUFl//r2rb2FHa/3r3KUqyqoghFgiOP+SLlKm75bllWNZXY4A7ETtYsf8G351KLIABk8DKKcw=
Received: from MN2PR11MB3565.namprd11.prod.outlook.com (2603:10b6:208:ea::31)
 by MN2PR11MB3902.namprd11.prod.outlook.com (2603:10b6:208:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Wed, 18 Nov
 2020 16:42:46 +0000
Received: from MN2PR11MB3565.namprd11.prod.outlook.com
 ([fe80::1a1:48b0:c5b3:28bb]) by MN2PR11MB3565.namprd11.prod.outlook.com
 ([fe80::1a1:48b0:c5b3:28bb%6]) with mapi id 15.20.3589.020; Wed, 18 Nov 2020
 16:42:46 +0000
From:   "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: RE: [net-next 1/4] i40e: add support for PTP external synchronization
 clock
Thread-Topic: [net-next 1/4] i40e: add support for PTP external
 synchronization clock
Thread-Index: AQHWuhq1bQqAG8eeLUmr1UdRqZnptanLh96AgAKWk5A=
Date:   Wed, 18 Nov 2020 16:42:46 +0000
Message-ID: <MN2PR11MB3565041DE307A4FA48DCC5D0F3E10@MN2PR11MB3565.namprd11.prod.outlook.com>
References: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
        <20201114001057.2133426-2-anthony.l.nguyen@intel.com>
 <20201116170737.1688ebeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116170737.1688ebeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [89.64.99.236]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da4702c9-5426-48f8-389f-08d88be0faa3
x-ms-traffictypediagnostic: MN2PR11MB3902:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39023684079CC822B59ACC33F3E10@MN2PR11MB3902.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sCZMnS/1tYwfotGCAxTdyPDW9Z/afxLCEUF0S/YBmUqv2fG2pcdcjMt8CpT443gLgERY8koFUFGWTlZS5lD87vYDzQotOqudFJtU6bXkSjP2CEDCozT3AXbP2OrrKpBJE03Spiv77jTdA58p/b4RPmd5Ey4UII4BQH+ykNzD1I06dqHJAZbObXTrANK0Loosc9XMg0gIlWfPFNySxDOQbeR3TUxkpmmpdvAqZ0itXViyKb7jWhlSRdKfrK/HuLPCO0KpLhdZ2Ro5CWdXYY2mDyu9pn8qnCsrc/9bumu2uQCtT7K+hRq9CxjxvfDNO9B/gBzSTHFmwYXjWSpR5TArlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3565.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(76116006)(9686003)(55016002)(71200400001)(52536014)(8676002)(6636002)(5660300002)(8936002)(186003)(4326008)(26005)(83380400001)(2906002)(54906003)(86362001)(33656002)(110136005)(6506007)(478600001)(66556008)(316002)(66946007)(66446008)(7696005)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qT3EZNvOgf/GkHAoktn/rvxItgHy+vWSeBfKIBdTiiRNGYvPFVgordi7JrZ+0ChtcsXgMYX0RVocv+9Orzg43WR4+7G46aTdY6K+gq2nDMOYK2S6XfgazQrhKOdpfdsEgdgsx1PwfEJtNM+vX5URCqDyF3JYP0FoOkA2YRg91RwLUHwNCHxCHQJM2YZiczheErwvVKx9M2PLpmfvV/3vTWuhNg+SinpHIDBNmAQNXPl9ileXMuYghSz4SG/sE2bfR4Ucq3LHMoxDvcDRWTbOIdzC1dKlKI0sy2scDDdamC9u9NP0UGqx8ezRUaWuB43SwD7TwBRjdWLRilJqyHNK6pQULdWTDhBMPjybvGxsVOcxsdJ/86rnz3odixKl8jvWWwJKTKlzaRmVa4SF3oET7fQykd4tjlCGI8KtfI5i/WjtcivGHFSQ5JZI1LfNN2099jQjlUR9jG7XCFhVTU3Gu7FYt+TnzBZOMg7wef9gorabtMaoqr9LerzevmhtyKVH3gZcIHSikUYZQ9nRE4kZmQKXfOlMYZsDJB8P0g4CzNIYU7MsHAm9XL+p7xQEnVVTag5vJPHIysEc2Nt9Ck93sHSwiOZ1PsUt2J4Vb/aSXGHv1+y/dSIJRTNqw6NeW0dEbh3pdoSoDZdlLSgL/JRmOyi5hjH4Vz/cM1Ld2Yp9iNLmQXz92SkCEA5TvbhkJqZgApGQescf3oieKQj+i3F68FJE9e+eZBt9nVIWxnP5rge0gjxrbJTCDY2NCoJlZIqTChiMbjzrPv4q+douEPcC+RBmPoMFlQZP4VnkLDkRW+Du5kX7Af9vC64Qp080/tjB7bhIVnyt3qYVIlGhlx/7AOtl/ny1zoxVforPDoY4RL8OCZW4/Ev3Ch7Hqz61mv1Xq7lSNx/DzLaP4U1jo5fmUw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3565.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4702c9-5426-48f8-389f-08d88be0faa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 16:42:46.5332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n5b1mrJguX+w5VOh5w73KMTDfczCUmAquXFt/DlypgwCoyvhrxSiub7+CqEkdSdY+X2ZIhqbtgf4/JyhsMHUL0hpm2x4RYfHEEYOp48rA3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3902
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Tuesday, November 17, 2020 2:08 AM
>To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
>Cc: davem@davemloft.net; Kwapulinski, Piotr <piotr.kwapulinski@intel.com>;=
 netdev@vger.kernel.org; sassmann@redhat.com; Loktionov, Aleksandr <aleksan=
dr.loktionov@intel.com>; Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.=
com>; Andrew Bowers <andrewx.bowers@intel.com>; Richard Cochran <richardcoc=
hran@gmail.com>; Vladimir Oltean <olteanv@gmail.com>
>Subject: Re: [net-next 1/4] i40e: add support for PTP external synchroniza=
tion clock
>
>On Fri, 13 Nov 2020 16:10:54 -0800 Tony Nguyen wrote:
>> From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
>>
>> Add support for external synchronization clock via GPIOs.
>> 1PPS signals are handled via the dedicated 3 GPIOs: SDP3_2,
>> SDP3_3 and GPIO_4.
>> Previously it was not possible to use the external PTP synchronization
>> clock.
>
>Please _always_ CC Richard on PTP changes.

Sure

>
>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e.h
>> b/drivers/net/ethernet/intel/i40e/i40e.h
>> index 537300e762f0..8f5eecbff3d6 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e.h
>> +++ b/drivers/net/ethernet/intel/i40e/i40e.h
>> @@ -196,6 +196,11 @@ enum i40e_fd_stat_idx {  #define
>> I40E_FD_ATR_TUNNEL_STAT_IDX(pf_id) \
>>                      (I40E_FD_STAT_PF_IDX(pf_id) + I40E_FD_STAT_ATR_TUNN=
EL)
>>
>> +/* get PTP pins for ioctl */
>> +#define SIOCGPINS   (SIOCDEVPRIVATE + 0)
>> +/* set PTP pins for ioctl */
>> +#define SIOCSPINS   (SIOCDEVPRIVATE + 1)
>
>This is unexpected.. is it really normal to declare private device IOCTLs =
to configure PPS pins? Or are you just exposing this so you're able to play=
 with GPIOs from user space?

Right, this should not go upstream.

>
>>  /* The following structure contains the data parsed from the user-defin=
ed
>>   * field of the ethtool_rx_flow_spec structure.
>>   */
>> @@ -344,7 +349,6 @@ struct i40e_ddp_old_profile_list {
>>                                           I40E_FLEX_SET_FSIZE(fsize) | \
>>                                           I40E_FLEX_SET_SRC_WORD(src))
>>
>> -
>
>Please move all the empty line removal to a separate patch.
>
>>  #define I40E_MAX_FLEX_SRC_OFFSET 0x1F
>>
>>  /* macros related to GLQF_ORT */
>
>> @@ -2692,7 +2692,15 @@ int i40e_ioctl(struct net_device *netdev, struct =
ifreq *ifr, int cmd)
>>      case SIOCGHWTSTAMP:
>>              return i40e_ptp_get_ts_config(pf, ifr);
>>      case SIOCSHWTSTAMP:
>> +            if (!capable(CAP_SYS_ADMIN))
>> +                    return -EACCES;
>
>If you needed this, this should be a fix for net. But you don't, core chec=
ks it.
>
>>              return i40e_ptp_set_ts_config(pf, ifr);
>> +    case SIOCSPINS:
>> +            if (!capable(CAP_SYS_ADMIN))
>> +                    return -EACCES;
>> +            return i40e_ptp_set_pins_ioctl(pf, ifr);
>> +    case SIOCGPINS:
>> +            return i40e_ptp_get_pins(pf, ifr);
>>      default:
>>              return -EOPNOTSUPP;
>>      }
>

I'll provide and updated patch.
Thank you for review.
