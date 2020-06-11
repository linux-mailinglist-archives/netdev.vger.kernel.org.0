Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646551F6B3A
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 17:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgFKPl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 11:41:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:61111 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbgFKPl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 11:41:26 -0400
IronPort-SDR: IuFDu1E4r5VHd0r/kHj3NMQjPTCERNCEOnIxkffVdAiPzxsbZ4yh91plQUzzd40kVKrEMifHQm
 cn/cPr0msLjQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 08:41:26 -0700
IronPort-SDR: fueJ0QLG3RqFywjH4ExWaslAga+/8NrUelGnTHZNcON3zheYo9sESIzoz+tap8KLz5LQP6+uN6
 NLjmy4oq1QOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="473739682"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jun 2020 08:41:26 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jun 2020 08:41:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 11 Jun 2020 08:41:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiIZTwBICbU3CWh+96FlBZeMDErKFdAujxivR2W/MHdtAKqe0BxmUcIFbx9qmG1gsLmoqHdN/eSFmq3QXnmcLegUYWUbsyqu/sSs5O4Zv+JBrS+f3rgtqiDs6lE61leLh4bY6U7fzCEb31REKe1UobSz8ZSP3gHtkJQjV234jQEjMJBLedftbjzTlBYuIkz/ZB1XoyjPuEBC1LL3uh1390Sxxllok6z5vSuv4qMd4h4BXXcnkxVrYqiNC0Z9y9hrMjGb52D7XDknyiCnL7WxzMti368JssfiqcRaNPi/pEjRrebZamSVV9xRgFY1PNSm3MTMndXyPsXG+RLXOUUqgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2ZCakJjUE8tzN1eSbco+zNVDptr6m9rGEFV6/HZHWM=;
 b=LMD94TtySXjfBc50PzPHnxoa5aO1yYUmGZZmjNF6/hTrFYgwL3eIpVftPybOFWs9HtDhmiNnj7PLICvbGFQEzkl5Y1NroBWhlvEX6rT46LHaDG/dGrUL4Jv46B7EDXYCI3NlOMTrCJ1vq3hsIBLmPNO+oJsKoWpQJPM9hQPpxy/K0kuH2E4jJRh5FZtXrywnN1pwJk+LMSRjgbozhm0DcetB8iSJ/Z3bltr5WiZaht2ITa27xWUaPUn2pcBDWspP75Ssmpa1+s/7zG6+M4J1VLN8pQRu+7mJ5zcZ+mnxmO3PSjq++WLUCQCTTid/eq2CizL162C76Rl7fGRxI1YPXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2ZCakJjUE8tzN1eSbco+zNVDptr6m9rGEFV6/HZHWM=;
 b=hh6nt0IIizH/j/9URc872VzT5FHRGZdaFS/E5E3ImsyI2C619X7EBosn0PDp2jyI1SfMYqqs8brOL5gWHIIdtZt3i4hp77cpZORJFUzh2TjNEgT6pWltxug7i+34S0D0LTIuoD13rZ9hpdIDCcsi761twz/URPs0buHFnqIYNlo=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN6PR11MB4067.namprd11.prod.outlook.com
 (2603:10b6:405:7e::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Thu, 11 Jun
 2020 15:41:23 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 15:41:23 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: silence an UBSAN false positive
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: silence an UBSAN false positive
Thread-Index: AQHWPdtY9EVDXYNXok6jepffJZYYnKjTkZxA
Date:   Thu, 11 Jun 2020 15:41:23 +0000
Message-ID: <BN6PR1101MB21456AF399BB25055FC8A83F8C800@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200606200116.1398-1-cai@lca.pw>
In-Reply-To: <20200606200116.1398-1-cai@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.59.183.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd49c9b9-bfe6-41fc-beef-08d80e1de529
x-ms-traffictypediagnostic: BN6PR11MB4067:
x-microsoft-antispam-prvs: <BN6PR11MB406716AB33DA31ABDFDE93958C800@BN6PR11MB4067.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bdw7pdTmrH131Fad+VDuPiWB59Iqw1PNhMMoLc2pjRS0bUZ/MRT4BwkzWSE22DX5KF7iCJoZWGIEWMgvz1vOPHqmj2sDgDT+EOPBhkuOfegy/3GJST5nt5P3/SKIWCWi7KixGxC7eIyxW6Ly+yPUivqsD/Hd7G0nNDUd6t7aFrHe0DEK56MaY0Pfw9AC8Z+oyJ8ksC1aWsCVmpJrv/4DWZWiFZ6FwTpcj1xbLGYeuyAFbdPl4ZoVVdp7HXcMIcSMfkmEw1DPSW7PP1mnWcz4nIfB8vWyLxgNwamaQrXlfdsxevrB7iAxh8YrVx+d69M9uVXCsJ0qBx/DGdWdNNMIcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(39860400002)(376002)(346002)(136003)(8936002)(316002)(71200400001)(8676002)(4326008)(2906002)(5660300002)(55016002)(109986005)(54906003)(9686003)(478600001)(26005)(83380400001)(86362001)(52536014)(186003)(7696005)(6506007)(53546011)(33656002)(66476007)(66556008)(66946007)(76116006)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: I00bZPMFdgUyUI/k3CsKFqmDIyW1WnS02+SEoWFlU9Kjt6c480ckVBmSwg+99caHprMsEgRrHNZRMBbGmU3UGogG0CR8fvktDxQaTsbb2z7aZW++b2GY2OI1gNnh0vplQsBhcSu/Y0pGO7/EMm1Ag+5cU/2NX3muhYX+N7WB7xSUI1lOnP9CDY1efJ1KrV14Au04nox9CtEeM5YyUpztPDZtJ12HK+U4+9Cowd1vn4cj7MnIs5AIhMZOa/Hoa4mHciJIIfqX7Llz9QJLyUgLA4v31NZpBAd7o8CUzIMiCysniij4UBJpMphGVxVmAPqjcPQj8NUjCg4CaKzpGbEfS84xeFgfAAXu+AidG+5F64ws25vQdD3NWrMIZ6Rsk1khdJ/rfYsXYXtuaWpAtwZmzut+9eHN1DeoCaZi5Lr1WtP0zE5kdZL2NmEbp4n6uoJxS+22jYuEGoYCsWOKOng8ttV1losMWs/5A5HA6G9tQFA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cd49c9b9-bfe6-41fc-beef-08d80e1de529
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 15:41:23.2564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C7WINfWrESVPEx7QCSHD8qhjQABNp1MU17NM5smSaBjUHt6e6sOuihkGUD9VYETv6N5dCAkLh+kqAEXiepz0qvdG+aBdCcm9uICoXzZDDlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4067
X-OriginatorOrg: intel.com
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Qian Cai
> Sent: Saturday, June 6, 2020 1:01 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Qian Cai
> <cai@lca.pw>; intel-wired-lan@lists.osuosl.org; davem@davemloft.net
> Subject: [Intel-wired-lan] [PATCH] i40e: silence an UBSAN false positive
>=20
> virtchnl_rss_lut.lut is used for the RSS lookup table, but in
> i40e_vc_config_rss_lut(), it is indexed by subscript results in a false p=
ositive.
>=20
>  UBSAN: array-index-out-of-bounds in
> drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:2983:15
>  index 1 is out of range for type 'u8 [1]'
>  CPU: 34 PID: 871 Comm: kworker/34:2 Not tainted 5.7.0-next-20200605+ #5
> Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40
> 03/09/2018
>  Workqueue: i40e i40e_service_task [i40e]  Call Trace:
>   dump_stack+0xa7/0xea
>   ubsan_epilogue+0x9/0x45
>   __ubsan_handle_out_of_bounds+0x6f/0x80
>   i40e_vc_process_vf_msg+0x457c/0x4660 [i40e]
>   i40e_service_task+0x96c/0x1ab0 [i40e]
>   process_one_work+0x57d/0xbd0
>   worker_thread+0x63/0x5b0
>   kthread+0x20c/0x230
>   ret_from_fork+0x22/0x30
>=20
> Fixes: d510497b8397 ("i40e: add input validation for virtchnl handlers")
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


