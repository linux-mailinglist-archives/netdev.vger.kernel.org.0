Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56419270AF2
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 07:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgISFlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 01:41:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:22552 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgISFlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 01:41:08 -0400
IronPort-SDR: WjUweaoo93+T//lFQQz9GU1h/7ffB0aM9/Mr+fMDoFs2T2WCve35BRMB6IxhBfdm57ZYsbxzdA
 tDijUql33GNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="147760237"
X-IronPort-AV: E=Sophos;i="5.77,277,1596524400"; 
   d="scan'208";a="147760237"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 22:41:01 -0700
IronPort-SDR: rCnslv5DORACA9kn8JFoYtrQ/n2O1I8cLwGmwix61HZQ+Ry1DfxNR7BrURt4fzqJ+RDyx5GaAb
 9mW4r3I5acNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,277,1596524400"; 
   d="scan'208";a="508521738"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 18 Sep 2020 22:41:01 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Sep 2020 22:41:01 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Sep 2020 22:41:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Sep 2020 22:41:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 18 Sep 2020 22:41:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcPD4+1iwsnijXnKhmGf2Y/QyS6frfYXurAZEERJ56OusAdNqVA5bAOSgMx708H63tgXT8LpenSwDP8JYouPehRsLG4tfcsdwU867h7JPvWR8iTHAnZg40nDZMuMvpccdx5/0Tqx/xjEl/eRKb6SYGuMoYFuBctaS6ESz0SzVLDz2wpzaGSEnzTpwExqROa/I1/pjhKW9CKM2XfOLd4UCWT47q62ldYuDl546K3YZ+itref2wqiAFzapuejHamwGBggVBTUsY8lIJH+1O2eY4O01yjKQ9vJ6FBs7zMP50Mru4RssMK4SsLFTpF2AdW+i6fQiQFYltsSE98k74yE0ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvGkFG2PcWb4D2xDQuQH6oy3ws05OZpCCB5zYDpSo7k=;
 b=PDMCIzmz9d8V9bMmBGTbFQtOmPV1zs+JdveLH0IiLT9DLK8R0FiE/YjnJeVoE5SFRobdiWtqfFbSWHNYzr1p76U28xeUqO9Ccon5PHD8RcUH948aJ+ApRyJ3GRGaRD4NhI0UbdsJpuPA+OPHvArNI6TLdRs8SUxZr3wvNsRwS9YuJRE7/ahX8lgPXfjWmE94c9A1dIdO7ppv+uBGBm/5rjZSMZQCVls7NSeKgL7SLH4DJRMXZAs+RbPWJI2FSTi0aiAO8sOJktmtqWGzpg/rAiRNrp4H+m6+x9XDGjC9xP1YbEk3b1uK4VC8nZUiAmFN3PA00HApUjs8jcie3XEz1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvGkFG2PcWb4D2xDQuQH6oy3ws05OZpCCB5zYDpSo7k=;
 b=QV9gyrDtm8FHn+ji+k/CoUPC3JQ1M5q8z2hjCzllGQke9jiFL4bsUNh7UBWe/o98DEu/vVgvie51oTZkwV1OqpM0vH5ySL57H9dbubhI+OelThCxN/03mZlRdsKX6zTrZakh35oiT+f8wdqTRIL0UTpmZ7lWRWIUhHy2APPiqYg=
Received: from SN6PR11MB2896.namprd11.prod.outlook.com (2603:10b6:805:d9::20)
 by SN6PR11MB2557.namprd11.prod.outlook.com (2603:10b6:805:56::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Sat, 19 Sep
 2020 05:40:28 +0000
Received: from SN6PR11MB2896.namprd11.prod.outlook.com
 ([fe80::c9a8:3bb2:d3cd:a5fc]) by SN6PR11MB2896.namprd11.prod.outlook.com
 ([fe80::c9a8:3bb2:d3cd:a5fc%7]) with mapi id 15.20.3348.019; Sat, 19 Sep 2020
 05:40:28 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH net-next v1 6/7] ice: remove unused args from
 ice_get_open_tunnel_port()
Thread-Topic: [PATCH net-next v1 6/7] ice: remove unused args from
 ice_get_open_tunnel_port()
Thread-Index: AQHWX8dMF0NR+poA+UiR1NcJAC60rKlvzwkw
Date:   Sat, 19 Sep 2020 05:40:28 +0000
Message-ID: <SN6PR11MB2896C431060BD976DDC92DE2BC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
 <20200722012716.2814777-7-kuba@kernel.org>
In-Reply-To: <20200722012716.2814777-7-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.208.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d79446dd-ea99-4f4a-1fc4-08d85c5e8434
x-ms-traffictypediagnostic: SN6PR11MB2557:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2557F20D90BC7752F47C9DE4BC3C0@SN6PR11MB2557.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: znk4DEQdXgvH596jumSWMGlxXE/P4R6BDvE2VLLoX+kfqPzWc9OubRrfGJF8X0GdkKA6fRHtkMbDT0jWwVbx3gjn3K81xyj2ZVP362A93cFkXGppgRa+MP4YpQmdc9o0iZ0x5CxhzWe/Ly84KifvxSl1LmaIRpKNtJYyLJhiiKxzf9ysCCAxEhF8OVk7xyns9HimbKoAmWd6jO0og1vGcvI6Ot5wL1iaG80Q+7qUrQy7mQnh1isEM5UMtkAbB1sFZ2UaDyqZjYAAAVq8gbmpjnd/UcmcOuEpN8uB5AzCP3XM9aGbA9z9z/KUUboWe0Be
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(8936002)(71200400001)(8676002)(83380400001)(316002)(186003)(86362001)(26005)(478600001)(55016002)(9686003)(33656002)(4326008)(52536014)(110136005)(54906003)(66476007)(64756008)(5660300002)(76116006)(66446008)(66946007)(66556008)(2906002)(7696005)(53546011)(6506007)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZEeW4gkVU2K9HMaCCMOhMiS7z/CSHtgQChwH8h/quPHUpAxsnAEew3I0n93TmA+sF0fG5XEjeXB39JwvICzYjAM8Mb4XTCL4He9I2DH4+QHVfI4idcRtA5YXL2+rSFO8040gmwp+axe73YzFhMsXBQk/K6bcqE4wRUsw2ufiq5LLa/HYEfr48ku/7Wj58uWYQ4lhHCxdPCAR688B19zlZLVd2p0uHvfCGPuPrHsr2o28QEtIOPDfjBBJ0pLq7elUm1UXRpx4eKPy+tImPSol+T1XGSl1JwamMuHJ9i/p149kclIUe/HsFgRyU/v65OTT4w7RwnyDKarOngtK0p1PqygoiYQyyObOVW1e50/2oF+uf4zCh9afARzIE0MF/c4alirbpeb4A/ygkZtbqvc99iCSxDwbayz5N80YnEpDE6TBNChjc4Bmh7Glxw/wbPpfuudxWm3gKXW30H4IONEQMh19daRCByipQyImCdSKZz0k7x0JfORJUd1LUGtELRHqNE+x+MeS1BupjAeQA61EWK3dVqlz55dXZv2xr7Ous+QoYqRzbi9xDuH/3T6X45kd5VWg1Yd47+lMXV/0f5dqZmaFeGuCvVzoz2GGWYYC041CZwO/2qdLLC3NxuC5j4WzFxITGzcOMKtr3RknlAVVQg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79446dd-ea99-4f4a-1fc4-08d85c5e8434
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 05:40:28.4606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WVp0qkS/40TOpKR8OQ6ZsgMeSD2kxp8lwaPZsxnZwgmLkYDac4JT86k0zntngMFfr0StkPGkWMbBg+lnjECA0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2557
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
> Sent: Tuesday, July 21, 2020 6:27 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel=
.com>;
> intel-wired-lan@lists.osuosl.org; Jakub Kicinski <kuba@kernel.org>
> Subject: [PATCH net-next v1 6/7] ice: remove unused args from
> ice_get_open_tunnel_port()
>=20
> ice_get_open_tunnel_port() is always passed TNL_ALL
> as the second parameter.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 6 ++----
>  drivers/net/ethernet/intel/ice/ice_fdir.c         | 2 +-
>  drivers/net/ethernet/intel/ice/ice_flex_pipe.c    | 7 ++-----
>  drivers/net/ethernet/intel/ice/ice_flex_pipe.h    | 3 +--
>  4 files changed, 6 insertions(+), 12 deletions(-)
>=20
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

