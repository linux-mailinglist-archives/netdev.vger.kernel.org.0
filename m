Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C447368861
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbhDVVBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:01:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:12655 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237018AbhDVVBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:01:34 -0400
IronPort-SDR: qKyJTkzDarXrhMin9LW3iWClMM4OPSjAfBPMBP8ivbWJCfBgsiR8ZBbZRWwBE0aMsiN7qjmqMV
 eNY6k0Fb/Alg==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="196030214"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="196030214"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 14:00:56 -0700
IronPort-SDR: E54E9S6vi3L9os89wfG/r4UNxY6qMiCvWp15xaIuP9dgORqhkb1z9KAFTyqS5LYBoqe/EZFLeK
 D/rHlnYDjLPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="386199416"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2021 14:00:55 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 14:00:55 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 14:00:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 22 Apr 2021 14:00:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 22 Apr 2021 14:00:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2MNRwjSU/jauBb20RG5SLS3iX70n1ESkkNhXfqNue0DV1A4yYLnT2RztYC2AesLC/JIh3lcPB36Hzrdjj8yWzTmBmY6tL2jBM2H8CMbmJcEu8qTVDm/1dI8VtTnfCn21+dIPBUCicV50TEBRKDeJ8VNqJd6a1Ka5JlsSvImhGarlX1Ss1UyEm30UpnFSL9bdHYaEbMc9NDz8CHHbqv5gGkUnRejIKsQj7BTfcRSslT79xxnGV/r8AKB/0m2foJIznBcDibmjtq1g9oA8Gq2pixmCkEYkxYskfP33XsvOmmNE6qFUzXB8ZbUQhUeP+Qz6gDbiY47GsgpFEol5QSUsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwo+jcbNLdRTZECq7jqoVkGf7R12srlhKKLcNc27OkU=;
 b=YeEBtcJcig0B2YO+IFklbgXI937UiNjO1c7Hg1R1bLFyNKLvW2WDODSNiqGqyYqZ5z4r4sXOsEnbAhgayX/aKUTlreCb0J6kWP5KWIoqSJkIeRFpiuPCR3X5gvP8ENmy4KvyILI/tuxRhYHTWoRj1yqEGgBkNW0mmMnTXyjpducWn4WqEXVh0bK+jayqb6BPn4QFGK3muBIn9/F+N/+sydv4BEuO5GxO9VxKoYMm8SJBEoIVgN73ep4GqSwjMpFSU/BMwo4DPj3/p/NlpeUn0CB2HOBpoRFcoulTxxR/X4VpvOf3IxCsWfW8oluqzgg0mLxKSqssJRZXGXFIXsOdGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwo+jcbNLdRTZECq7jqoVkGf7R12srlhKKLcNc27OkU=;
 b=GNBVNFmufTKhk+pVreRIkL0fIaeUFptDbBcYl4YQXkucrtY3XBG/n7yIkEKbJ1LhIJgoezvQPglgNHijA83hgPOP8ec8jBhLAo43fLy28TCIhIw/bar2eVHzP83rOcvdAaOekKo7RKXC/NvzXxOJ8s9qcwZus9AQ1NZUOhl3PxI=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by CO1PR11MB4836.namprd11.prod.outlook.com (2603:10b6:303:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 21:00:53 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212%5]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 21:00:53 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     Coiby Xu <coxu@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/3] i40e: use minimal tx and rx pairs for kdump
Thread-Topic: [PATCH v1 1/3] i40e: use minimal tx and rx pairs for kdump
Thread-Index: AQHXEKH4t3DMRjDXP0aMNwDR0JJM5KrBU9fw
Date:   Thu, 22 Apr 2021 21:00:53 +0000
Message-ID: <MW3PR11MB4748DAD8745E21A92A7CD38FEB469@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <20210304025543.334912-1-coxu@redhat.com>
 <20210304025543.334912-2-coxu@redhat.com>
In-Reply-To: <20210304025543.334912-2-coxu@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.40.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4a06c47-1510-4c37-4af6-08d905d1b775
x-ms-traffictypediagnostic: CO1PR11MB4836:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB48369BAA57901E34DD8299F9EB469@CO1PR11MB4836.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aioiP4Kz4gAvt5+t6iSYpUDWkx9bQi2Kw07n2x52cbjbjeX7b+I9ngJlqoltyx6Lp87kt8PJrENFcRSx16CR/qryJNT1yluCQ/AfDh4eUu2fNQiKXebETT7PA13CzyGxLEul0dvvGMHQcCQeABTqfAVD1FWeORg7lenif/dYHXClQVzJBV7x8O7t6sus/MiU7hzv19mRcHAG4PdecQTyuv/p89dKTu3zlpZ4GtBD864TdaSYHRS7PTZ+vEjNQlUa8LuBprf/N3054/8am9vqh0YqRSK6+AR4Rqh2riiXsfF1srV4W4F5+n5OHXbipBBY+H/yWWEBNDEmox7bJsWa4LjTKOJLCMB1fhZAbsf36kNOILbn0wjIxCigEKXn2vwJVZCB3VLqFEYf8WVACy4D/hOskz3YUeffL04XrNRTaNMi1IxKJHY9CLhz32ByGVWIP7Z+SxR0VGSn0oz6MWPsHUh3i+S7ESFbuZV9c/4wfR11tvifhn7qo3o/L0bu5miCoDj3QU0BD6HCAGfkg2CjruWsD1NRxd1R3TvgUNEK9GquJEOrdqLIlVMyXj46JIGNFy9qnlNsek2kGu2EAybGmxLNhyEtsGtg5s2RTZWyeUg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(346002)(366004)(8676002)(71200400001)(186003)(66946007)(4326008)(8936002)(66556008)(110136005)(54906003)(6506007)(2906002)(38100700002)(26005)(122000001)(478600001)(52536014)(7696005)(64756008)(76116006)(4744005)(5660300002)(33656002)(316002)(55016002)(66446008)(66476007)(9686003)(83380400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OwvgY2IaGDTFa5MV2tWVEHtCyLcba2e30FEudyfQLh1nFIaDFwDPgjCdj7je?=
 =?us-ascii?Q?hYK2g+wb4/tLK4wNGi6ppqTL865EZ6NJRyJOCFyMmDGxspRR2c+OAd6nayzG?=
 =?us-ascii?Q?h562nmk9QsOgDcVzy5EaKATIOcW9XQc2VaLf6ioZbcJRqFq4t/UojxZ6d0ks?=
 =?us-ascii?Q?WVLyaShS6qK2EJk+vz6EfrgqC4ySggcTazY/5yTKgusQq37X/4Krp+5ZanTS?=
 =?us-ascii?Q?pCsJmnycidmdPJooD4GIROGY7WqcRUoATm+kicjvVKMt5wleBV13eslgSH33?=
 =?us-ascii?Q?qHUIo19dWb2kOR/4C65UOKM760/nUVNnh3VUnksoSCwbDPHNa/4yMrwuJpDs?=
 =?us-ascii?Q?IEgG7rG+EsYUXZu3ugmUsBKoRat6W7wBObZXGChv5NdWBNnw17zUantE+iKu?=
 =?us-ascii?Q?bVXLN8Vykbvzz3lvKeCxamukZx6+9/iaaik2JtuVg8wm4mTbKiTjJpmvxhlZ?=
 =?us-ascii?Q?n+7T06rrEWFjEwzIngUehKmpIMlhG0S01R7G8/h3d04QX1EDqKycfkS9Qyge?=
 =?us-ascii?Q?LK4k5QXb32m5JSWGnC5BQ8aYzKBXvFpI55lSoeMgQk70nTXXNgOLMkmnjSbE?=
 =?us-ascii?Q?cqitMNPkSzsK9HS+7YltJzhA34HP4Q9+dPNebBn1xvXVYDgcKugzviVwyWjl?=
 =?us-ascii?Q?Gdu8zSuctrdwjh1CxsxSw3MuCcGWI0WB0inPsIBvKoofQ4T1MBby9uvK/1Pz?=
 =?us-ascii?Q?G5+fMNmTJC7VDAa7gPaRHyArsa1h4IWMIj7n0sRoUYuMg7fzy4cS6+hDHAq1?=
 =?us-ascii?Q?3R8yEJjYEvrSwtQqpzvRR2TcrEj1NppAUmWwkJufHbTovnPCDvj30l5g+/2J?=
 =?us-ascii?Q?3RStkWQKgccX9PcChPl2eno7m+Wf+0SUmyS5k/qlVkxzOvregLUGBGRMoivV?=
 =?us-ascii?Q?qkr3uN8uSS/Cq/TJ2YepZQtQVP0EAHc7P2E7VqN5MIwyI/BeYSF3LhiwYCVM?=
 =?us-ascii?Q?4hsV8BpnN8d9hhhX8JpDwtP5nRacXhdEA1EdMfvW7wR5wn3iqWA2z89VZkGl?=
 =?us-ascii?Q?Tjnf2XV7Bj9L0df9sjHx8Y9POsKuNT944dAsb4J1zqVtI1AQIYhCn8B5nSBG?=
 =?us-ascii?Q?jwup9se2a0lHyXXERO5vr+ivNBUIYrkFE3k8Y3Nhzt+0S+484Hi2uLHPFvwa?=
 =?us-ascii?Q?iD0gUOXDxUPTXcd3o+GyllsxMGQ/5khXAdyBs4PvxyuVX52b54FmwdOCt5t1?=
 =?us-ascii?Q?FoDpY/MYvvND95hm095hoQQuOypdGKc9rajffROrom1HscPBpXpf/YtJ22F+?=
 =?us-ascii?Q?pAeeKl5MY+XrhMlZNvNZZ5fcoQxqpz2F7SvA47EZ1NC/jD2sOOufmMmq2a7V?=
 =?us-ascii?Q?teI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a06c47-1510-4c37-4af6-08d905d1b775
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 21:00:53.2990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sKkdM24ps/FWbg3E9r+N482tpY+UZxc8Bz2XEteEteJN6OLpyCm1B5p+fmMBMFutVrODyw5YzvCH8cVGGlaTxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4836
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>-----Original Message-----
>From: Coiby Xu <coxu@redhat.com>
>Sent: Wednesday, March 3, 2021 6:56 PM
>To: netdev@vger.kernel.org
>Cc: kexec@lists.infradead.org; intel-wired-lan@lists.osuosl.org; Jakub Kic=
inski
><kuba@kernel.org>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen,
>Anthony L <anthony.l.nguyen@intel.com>; David S. Miller
><davem@davemloft.net>; open list <linux-kernel@vger.kernel.org>
>Subject: [PATCH v1 1/3] i40e: use minimal tx and rx pairs for kdump
>
>Set the number of the MSI-X vectors to 1. When MSI-X is enabled, it's not =
allowed
>to use more TC queue pairs than MSI-X vectors
>(pf->num_lan_msix) exist. Thus the number of tx and rx pairs
>(vsi->num_queue_pairs) will be equal to the number of MSI-X vectors, i.e.,=
 1.
>
>Signed-off-by: Coiby Xu <coxu@redhat.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
Tested-by: Dave Switzer <david.switzer@intel.com
