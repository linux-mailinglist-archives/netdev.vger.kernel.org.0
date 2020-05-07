Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D451C9C8A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgEGUjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:39:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:41222 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgEGUjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 16:39:41 -0400
IronPort-SDR: FBdgYHiDR5PBckoJ37qcu5aA+Keyj44dIWaJ9xAxHDWsyXg1FXJUSDZ6Veo8PeHCHcpP8mcrFL
 SKxBk4/g/btg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 13:39:39 -0700
IronPort-SDR: F47B8PGoN4/DU8rwYvTi1lXLd1/H2jOcWoV+5FCnwDoRN2Hmf8ZIts+xWRx6EUqx8BaTFhzDka
 yElIjpmjC9pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,365,1583222400"; 
   d="scan'208";a="296649024"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2020 13:39:39 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 13:39:39 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 May 2020 13:39:36 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 May 2020 13:39:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 7 May 2020 13:39:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmk84Tf3UBVWJxqf4JCg6qMH9LqTqqdv0LBs/vq1jtp+tl/D/B6hk0ZKISNInfsgBf79lN8HWK6TUChueRl1gwq29SW3l6V/McLm4GTFrdEWfKLwWwuOh7D+fKOqbIqkxMm4YFQk58b10tlZ8I8UCfJNeSl6/eqi9DcXRccd4CsdnC+AcsGHMjnz7RdBpNGT7fax5MQHe19tld0YFZin6E7DhYzwFMh4OvM0FV2I3aEl/0AlrGaEB9bS1dqqQh5wsgMy6A70TOEu6rqPihymgaJ1kS8/21vMHmvlyBmS8S3t3haLXhkZChcODBKLqdHzI6KjPknASZEluCQbYooulQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvCoGxLIrkzTRNRpCRUsvA3H9AOOxbkQsaMHuavp+3E=;
 b=ESv9D5vfG3BEH1FAzRcKTOLW8KHdKoLn2zGfcXeKalHn6ACNgL/VuRuxTtuc8SFcmAkP8SFruBeZUR8lM1rcGn9EBekTvFK8geZbGzuUEKQPlNG5on7RJP2H1vWpKZTANKsVQ9yeKuWkRVFpZxZfQO6hX65K4AQsyhxIcgxb64LOyk21L0kDcL1psKZj+51+mpvrDmidGJzfslkRI0Do+7/NNpCNsPfLAx3ITq61Ar3o4YlbvJykloWkyGdm0TaK94AoR3qIE0R773tvubxghccFJhBkDH6R/nPzXeLFNFRt3YAectfGTwdzTgRqN6kdts5lk3a5Pk2GQZCRIWlkSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvCoGxLIrkzTRNRpCRUsvA3H9AOOxbkQsaMHuavp+3E=;
 b=MahP03MjvlhORi4XFSgbBdktci1aB5pBL220wXCD+9Bfp+Qht/Vz394MrbwMH9UdZLySk/tWlbm3PKz3KRmEYci6KuOYTtT3RBZE8zzAUmR1JdtifUWFfDVGaYQnpEhmvJmFcHcx1t2v9p3chUm/MnDnc/PIgWRqUl7NhSmwxXw=
Received: from DM5PR11MB1659.namprd11.prod.outlook.com (2603:10b6:4:6::20) by
 DM5PR11MB1916.namprd11.prod.outlook.com (2603:10b6:3:10a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.26; Thu, 7 May 2020 20:39:19 +0000
Received: from DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783]) by DM5PR11MB1659.namprd11.prod.outlook.com
 ([fe80::34e5:3ad6:73cd:4783%12]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 20:39:19 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] ixgbe: Remove conversion to
 bool in ixgbe_device_supports_autoneg_fc()
Thread-Topic: [Intel-wired-lan] [PATCH net-next] ixgbe: Remove conversion to
 bool in ixgbe_device_supports_autoneg_fc()
Thread-Index: AQHWIrDcl6alaI9TTkSIYAEivEhB8KidGalQ
Date:   Thu, 7 May 2020 20:39:19 +0000
Message-ID: <DM5PR11MB16593FCAC4EB2174D93F8ADC8CA50@DM5PR11MB1659.namprd11.prod.outlook.com>
References: <20200505074157.40938-1-yanaijie@huawei.com>
In-Reply-To: <20200505074157.40938-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 513b6e9d-a57b-45f5-3479-08d7f2c6b774
x-ms-traffictypediagnostic: DM5PR11MB1916:
x-microsoft-antispam-prvs: <DM5PR11MB19168C63B0F5D666257F94BC8CA50@DM5PR11MB1916.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HHY4UjTUuvl7U88Hpf6qY2vo1xPl9XQUcMj91La3WqHfgS0ugFYVo8i6UU0gUZcZHH0Xm9tz7bnZFvJY7XEgz1MByzXDLbbAvPXbvkz2BnqVec8UvetlcKm2ImdtEiGwdkGyraSE+XvxUVBmrTEBU1LD6GOw63LvfBeLa0gAfk9RCPFq4wxs87/nQpGm2s3PZqVQLeu1G+5l9fHWZcxCV8QOrPxjdhQJAzJA0d2toUJ0beKePMi8mByR7Owb+jE5UfYvyHplYw+hlMt3pzQBeMWgstaXlRw8fQE4V9viYenVCnr7NOMeU2tTrnn6CeKtABV/GVi+CbIapdpwSbVsuPOtZrxuAicFVIRZjsI1lBsi7HaiYQh2jz5Z7ZzkFB+kgYV/ZlW+XeYrafgH/TzYPQGhpy+/HHoZP51jd8snccliqCyLpoY8vi3tlRTtJGEtBbdvCUq7XCXavTMty+wIR6b0HCphZ1NsLPTtuWSLhRONJcrzh9REKtdKpZSSx9A1l/aCZRWWmSQ9sXoBEi9p+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1659.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(39860400002)(346002)(396003)(33430700001)(76116006)(7696005)(66446008)(8936002)(186003)(9686003)(71200400001)(66556008)(66476007)(52536014)(55016002)(66946007)(110136005)(83300400001)(8676002)(26005)(86362001)(83280400001)(33656002)(83320400001)(83290400001)(83310400001)(4744005)(53546011)(5660300002)(6506007)(2906002)(478600001)(64756008)(33440700001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ekPOq1A3V4Tc8cM+iu81qG21UPsDRE25r88kghPGR/5lj+4xwhrdgkyDB63AxxdGK5tfdbKWRBjODTSCRaGLSjJyHmb5YhAI7ieDOjQbT07GRk4LaYDo/qN+3hjxO9TRSRepBYAirtVL/jep5BEbIOnyQ9P/R+9PPcpIhrUXbX1W72Z5kNkK3uACnzqwYL5D2h8zXhk1TRvwqBcvIPVQsExknHX929em385pLPXUVaZeIO80K7Y9AOhGGdtk4R+uEUgMLoW4WQsubWguoU0aq0jLxWKSy/oaF6rQrTSEBfbQhlGnVOMOpo76SdWF7JXiO4gtaeAJ9SiIwXYkxAWnzB3ogqdway7+buYcRpCNiRjhZ1+9jaI6Hw001awW5z9X+j6laVuMMDL8So1erg2DOWMHPEVktG9AfiavKYdV1oPTSlflnxsQBGZVA8Ou1l7W8OPXjderSOPdFiuw8PKAGNd9WksGqfy7Esd1IsR7qBpNjbbLKpaULgQpl3c0B6hV+pxlfB+OJuH1rYVMv3OPX2w29aRid+s6fpnQ2Jb+ztOrrirxovJGIYfR4Qh8Me4gzFPPJJS+yu1DGLuEeU38P6fsqhtGnSbBelwRMZgWZNL7zs7BBVOU3O+T/OKw0Cu+PDuqvXqEyq7EjMdAaiMo1FKffSggPCH9EaLaiZ8DrvBICjQIl0ktupxwfuvbB0xg3iCoy34JnS4sDsFmfXtpjiUHJnj4mN3pdLST3mFOT8DVo8gLLRB/QWvJihEJYCh8jEG51hbDL7HsruHSLdn8xKectBmPs/N0YpzYEJVC4cE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 513b6e9d-a57b-45f5-3479-08d7f2c6b774
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 20:39:19.0387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFwVwMPMumT5g8tTW3SzLA+8HBy7NMYo+sYlR3hn43SH+8Qt8gb1r3Saf/JtotTQwo9HaOz3KDGNBabrJxhQa+dkmqy+R+Iauc3mXjfpFuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1916
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Jas=
on Yan
Sent: Tuesday, May 5, 2020 12:42 AM
To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net; =
intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-kernel@vger=
.kernel.org
Cc: Jason Yan <yanaijie@huawei.com>
Subject: [Intel-wired-lan] [PATCH net-next] ixgbe: Remove conversion to boo=
l in ixgbe_device_supports_autoneg_fc()

No need to convert '=3D=3D' expression to bool. This fixes the following co=
ccicheck warning:

drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:68:11-16: WARNING:
conversion to bool not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


