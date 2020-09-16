Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40EE26CF39
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 01:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIPXEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 19:04:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:56082 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 19:04:48 -0400
IronPort-SDR: frIN4sRBsM9iIvFgxFd7uZ3pYqX+Hv2sp79IveS7toJHl1DQaBtupoX7UPLny3wkwUaimYveEJ
 /L1va+96+k1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="159634324"
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="159634324"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 16:04:46 -0700
IronPort-SDR: DFlm3pIk9zM6fE1ICDyZMrMiQZ5dtKNQ1Ahv55yhBH4QOB49nqIkaPsjFsJeIMBIKK5x0FCkbh
 IoVZopD5lF3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="483493388"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 16 Sep 2020 16:04:46 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Sep 2020 16:04:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Sep 2020 16:04:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 16 Sep 2020 16:04:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFgyqd8oMrBPpzADVXFoIbetLNjWvXY8pHz7OIyxwo95Yn9Mtfrjwd95G19QKHwdqD7xIVPqhfgupZuEHlGmQD5rjeS3VVNlJ8sUDlOjGFdbtavijtIGEoX+7YRUuxU5uA5jKkcvyhP6Jwq+qFr4UcAfLpV9YGbK/C3hav2+pjDTPf8mZjD9QLIr/hoZB2sWlHzAflZe2MiUfvHWY6DEmsauy0c48IUc0sa4hXsafmZmwz32a5u8OLAM+3mh1qcvd6zXOwBvGHuFxwHAVpvfZTbIPRnrJwlRW2WGKfW9GggPArdxDEoC0cchpAs6doEfTppLB4n3zKNmLA/gN1uDiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O11Cy/NfDgrzoUqLuV+LIfFh3CpYUPUMe8xQ4alnpX4=;
 b=Anl0L594MRAdCCs8xIeiB5XTh1V30poTpIvslABgA/+5V5kHzIc7iXdfed4GEA1wngT7KIFT9vBRuwBGCyQuOVFzRp8fqs6J4Fiax82DXubCHmXXhNYUK/YlV37QqkxiGZg1OaWwedrZkGa1BguSRNdkLLJhnwGbXasFhTKAK0P3k0jEYEzethH1fODNNakGxVKDwkIp3dLmnvaBxW5uMvWCqsNYHRvPvxuJfolqXHK3l/bV79RIzW/Mdq+LZ+axSoZYyPXnZLu8CIZuQuIm3xj6sQMPwY+DQGEbc5uAfDollOG1jwPDf0/lbCvZ6gWRqzfxM+bBmY4uGZXjWjTNxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O11Cy/NfDgrzoUqLuV+LIfFh3CpYUPUMe8xQ4alnpX4=;
 b=hfQHqLG4lRC6Mlpv/VTW+Yv1jfSBMccohbXV0LefzsftFAvIEj/pSUSEQVhCPRTZDJqnjM0hMl0nVQvTqCUOonfgl+S3M0tu5gZfptm2mXPO01waw6ZMVpgFBXk6t/ZSnGO5doykGeiXEHAyANiMYaKUT7KX8rApMSVMpeVkJ78=
Received: from BN6PR11MB4132.namprd11.prod.outlook.com (2603:10b6:405:81::10)
 by BN8PR11MB3538.namprd11.prod.outlook.com (2603:10b6:408:83::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 16 Sep
 2020 23:04:43 +0000
Received: from BN6PR11MB4132.namprd11.prod.outlook.com
 ([fe80::8189:cff:4996:ef83]) by BN6PR11MB4132.namprd11.prod.outlook.com
 ([fe80::8189:cff:4996:ef83%6]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 23:04:43 +0000
From:   "Williams, Dan J" <dan.j.williams@intel.com>
To:     "oded.gabbay@gmail.com" <oded.gabbay@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "SW_Drivers@habana.ai" <SW_Drivers@habana.ai>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Thread-Topic: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Thread-Index: AQHWjHyb7wmLLFd6Ok2KvQEJXbW9Ralr4oaA
Date:   Wed, 16 Sep 2020 23:04:43 +0000
Message-ID: <00a7f70a97a1acab74eac5c23e20fd73a04cb3f2.camel@intel.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
         <20200915.134252.1280841239760138359.davem@davemloft.net>
         <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
         <20200916062614.GF142621@kroah.com>
         <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
         <20200916074217.GB189144@kroah.com>
         <CAFCwf10zLR9v65sgGGdkcf+JzZaw_WORAbQvEw-hbbfj=dy2Xg@mail.gmail.com>
         <20200916082226.GA509119@kroah.com>
In-Reply-To: <20200916082226.GA509119@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d38baf18-c3dc-497c-fcfd-08d85a94e65c
x-ms-traffictypediagnostic: BN8PR11MB3538:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB35387AD5CE02AF33603A2D21C6210@BN8PR11MB3538.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FCkwleabq4Oo4JZ+tjaspgqONhgCmw5P67dawndrjoDtKTGjQjahz2/fdlsx1PaM1SGqceb6+TK+R5ASD9VIBZhwzLPQya6G21P3cmxf6/i0RlNKacLJseEcDQoen8CPWxvl9kYpyDfDcNWkMmioAEi8e8yw1MgLB/P/Z2praOK3mkSkaIvu7rAdK90nlFmpZe8xBApKdhz/2vWsNMgGIjKtPFYMPhtclp1RH7ZSEY3O6Sov8uqWoOaUD0cDUjIQGJdBPR0DnNf9JKPshy7KmKVSRdDvDpMVCwzVXE6U3mqDQxixu093m4vcHsu5EXpfQThROow4UpThcJWRE0q93r03OgJXCnR8ZXWAWY/8eK+0EsdVbk9x5GAsuEObA4ms5ZcWQO3tstDq+iVwMAbW8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4132.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(7416002)(86362001)(2906002)(6512007)(966005)(6486002)(8676002)(91956017)(76116006)(64756008)(66446008)(66946007)(66556008)(66476007)(2616005)(71200400001)(186003)(26005)(316002)(8936002)(5660300002)(83380400001)(54906003)(36756003)(478600001)(6506007)(4326008)(110136005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: WIdDrs5XJlkUKHa7IdDjHzHbxCK9tUMwCB36kwY6ITmoCwFU82FbjpvZ1OQSZuN82ER+8b7YY3rVAvXVMT5tcbw3rHRsZmhJZc4A+N6avnWlNSgEMDvcwNTOQGjimJTm7moxeR9lsw50Uln4Dc2OojgnbzyYq3uEOOuScKIHbxzK+Rd1lHwDMndnCCq7GkM0+rzwibfJM6yauWbhsIDejjWtBlqJvsNhsS42ThUteocFWLjwYFe0KonzfhgR0FntNjNPJDRljVLDNgbYBDCHmf+j4mSblJjTKZ4d52NyA5lZdz18hH6uOMgaz9FnAuOVRJIMIoxdWGXc+GU2Uh3Oi2smjLV2rNLw6KR2FG6tNIFLaQildNRwE9Uv++uijPV3nyzd6zIZWar9K1z5nPIHvxvh4hS3+TwoyFeFjdG83WnvVQSmPkslUmQW4HKPN+Dz0CPcs6Vt3RyjPTd5oagA4tnk3od6L6dEQidq29cnJ/x7dXuryZhpxXzNBBjs+vcQ8H/8cNyrnmww6klWA8DeGHG8ngDYewwbF9BXVlNAwjADZLMoueYKcDvk+njbWZDHb0LWYEHIXg4WOIBrbZYaV1FLIYGflekuI5Irmtqtc6bTwJP02lBIoe6Z7CsnQVHiA4IIQhzHGa+6tbh18N6AyA==
Content-Type: text/plain; charset="utf-7"
Content-ID: <9D0B55A74BD07C4AA9E8E9FEF359187E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4132.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d38baf18-c3dc-497c-fcfd-08d85a94e65c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 23:04:43.9128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQIJr/R28M6VxQ1n5kQahDDA5qzXJwHlubuTVmvyn0Dwi1DTjtCaGiEyWobkyxUiCqamosOW7o4m8P9xSZpGaiz9fXEdV6BqpdkhhHjWh4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3538
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-16 at 10:22 +-0200, Greg Kroah-Hartman wrote:
+AD4- On Wed, Sep 16, 2020 at 11:02:39AM +-0300, Oded Gabbay wrote:
+AD4- +AD4- On Wed, Sep 16, 2020 at 10:41 AM Greg Kroah-Hartman
+AD4- +AD4- +ADw-gregkh+AEA-linuxfoundation.org+AD4- wrote:
+AD4- +AD4- +AD4- On Wed, Sep 16, 2020 at 09:36:23AM +-0300, Oded Gabbay wr=
ote:
+AD4- +AD4- +AD4- +AD4- On Wed, Sep 16, 2020 at 9:25 AM Greg Kroah-Hartman
+AD4- +AD4- +AD4- +AD4- +ADw-gregkh+AEA-linuxfoundation.org+AD4- wrote:
+AD4- +AD4- +AD4- +AD4- +AD4- On Tue, Sep 15, 2020 at 11:49:12PM +-0300, Od=
ed Gabbay wrote:
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- On Tue, Sep 15, 2020 at 11:42 PM David =
Miller +ADw-
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- davem+AEA-davemloft.net+AD4- wrote:
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- From: Oded Gabbay +ADw-oded.gabba=
y+AEA-gmail.com+AD4-
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- Date: Tue, 15 Sep 2020 20:10:08 +=
-0300
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- This is the second version =
of the patch-set to upstream
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- the GAUDI NIC code
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- into the habanalabs driver.
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- The only modification from =
v2 is in the ethtool patch
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- (patch 12). Details
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- are in that patch's commit =
message.
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- Link to v2 cover letter:
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- https://lkml.org/lkml/2020/=
9/12/201
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- I agree with Jakub, this driver d=
efinitely can't go-in as
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- it is currently
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- structured and designed.
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- Why is that ?
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- Can you please point to the things that=
 bother you or not
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- working correctly?
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- I can't really fix the driver if I don'=
t know what's wrong.
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- In addition, please read my reply to Ja=
kub with the
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- explanation of why
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- we designed this driver as is.
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- And because of the RDMA'ness of it, the=
 RDMA
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- +AD4- folks have to be CC:'d and have a=
 chance to review this.
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- As I said to Jakub, the driver doesn't =
use the RDMA
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- infrastructure in
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- the kernel and we can't connect to it d=
ue to the lack of
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- H/W support
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- we have
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- Therefore, I don't see why we need to C=
C linux-rdma.
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- I understood why Greg asked me to CC yo=
u because we do
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- connect to the
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- netdev and standard eth infrastructure,=
 but regarding the
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- RDMA, it's
+AD4- +AD4- +AD4- +AD4- +AD4- +AD4- not really the same.
+AD4- +AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- +AD4- Ok, to do this +ACI-right+ACI- it needs to be=
 split up into separate
+AD4- +AD4- +AD4- +AD4- +AD4- drivers,
+AD4- +AD4- +AD4- +AD4- +AD4- hopefully using the +ACI-virtual bus+ACI- cod=
e that some day Intel
+AD4- +AD4- +AD4- +AD4- +AD4- will resubmit
+AD4- +AD4- +AD4- +AD4- +AD4- again that will solve this issue.
+AD4- +AD4- +AD4- +AD4- Hi Greg,
+AD4- +AD4- +AD4- +AD4- Can I suggest an alternative for the short/medium t=
erm ?
+AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- In an earlier email, Jakub said:
+AD4- +AD4- +AD4- +AD4- +ACI-Is it not possible to move the files and still=
 build them into
+AD4- +AD4- +AD4- +AD4- a single
+AD4- +AD4- +AD4- +AD4- module?+ACI-
+AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- I thought maybe that's a good way to progress here =
?
+AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- Cross-directory builds of a single module are crazy.  Yes=
, they
+AD4- +AD4- +AD4- work,
+AD4- +AD4- +AD4- but really, that's a mess, and would never suggest doing =
that.
+AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- First, split the content to Ethernet and RDMA.
+AD4- +AD4- +AD4- +AD4- Then move the Ethernet part to drivers/net but buil=
d it as part
+AD4- +AD4- +AD4- +AD4- of
+AD4- +AD4- +AD4- +AD4- habanalabs.ko.
+AD4- +AD4- +AD4- +AD4- Regarding the RDMA code, upstream/review it in a di=
fferent
+AD4- +AD4- +AD4- +AD4- patch-set
+AD4- +AD4- +AD4- +AD4- (maybe they will want me to put the files elsewhere=
).
+AD4- +AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- +AD4- What do you think ?
+AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- I think you are asking for more work there than just spli=
tting
+AD4- +AD4- +AD4- out into
+AD4- +AD4- +AD4- separate modules :)
+AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- thanks,
+AD4- +AD4- +AD4-=20
+AD4- +AD4- +AD4- greg k-h
+AD4- +AD4- Hi Greg,
+AD4- +AD4-=20
+AD4- +AD4- If cross-directory building is out of the question, what about
+AD4- +AD4- splitting into separate modules ? And use cross-module
+AD4- +AD4- notifiers/calls
+AD4- +AD4- ? I did that with amdkfd and amdgpu/radeon a couple of years ba=
ck.
+AD4- +AD4- It
+AD4- +AD4- worked (that's the best thing I can say about it).
+AD4-=20
+AD4- That's fine with me.
+AD4-=20
+AD4- +AD4- The main problem with this +ACI-virtual bus+ACI- thing is that =
I'm not
+AD4- +AD4- familiar with it at all and from my experience I imagine it wou=
ld
+AD4- +AD4- take
+AD4- +AD4- a considerable time and effort to upstream this infrastructure
+AD4- +AD4- work.
+AD4-=20
+AD4- It shouldn't be taking that long, but for some unknown reason, the
+AD4- original author of that code is sitting on it and not resending
+AD4- it.  Go
+AD4- poke them through internal Intel channels to find out what the
+AD4- problem
+AD4- is, as I have no clue why a 200-300 line bus module is taking so long
+AD4- to
+AD4- get +ACI-right+ACI- :(

It turns out that they were caught between being deeply respectful of
your request to get another senior kernel developer to look at it
before sending it out, and deeply respectful of not disclosing that I
was out on bonding leave.

It just happened that I left before they could
get the latest version over to review.

+AD4- I'm +AF8-ALMOST+AF8- at the point where I would just do that work mys=
elf, but
+AD4- due to my current status with Intel, I'll let them do it as I have
+AD4- enough other things on my plate...

I'm back now, let's get this thing moving. /me goes to review.

