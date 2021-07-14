Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229963C7DFD
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 07:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbhGNFmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 01:42:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:5413 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237903AbhGNFmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 01:42:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="295935362"
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="295935362"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 22:39:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="427712322"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2021 22:39:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 22:39:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 22:39:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 22:39:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 22:39:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHgk7vCWyY4pW0D9rlW+lIc+NlUwXkyFICtYEqXlfrabTwEfXqvvyxxG9nfeb8rKzpA5o7rxq/HCAVeNH9zOwTLv7QDbWpXGHAecX77U+Cy2696HF7u/+OvjaXBJwJo0flVsmuB8FAoKiS+SEmlonL3AAmZMngxrKVJEPZgOeQx+TPlzZQfMTYT0CrBOX6wblZNs2u+Vf+QTL6isIclv2obQsWgGBKpnQyDXik/Ztnm5QaDi20ZJpLwqR9k/hEzY9nuSKXTIzy1gk4HaCwXp5RBeOt3Q9xZx5w51ZgFxTZu1MAWBBV1VHXB1+10OxzHnYft/yZJ93VQyFxNRn6Nl/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8S1qOl6ONwmNwKdZ2sn6wAb0IuKHi0uaLJHAOburP0=;
 b=oYuf6TzjDKSSBnEjXX/OIJLGxUMuFn6TsJIbc8BiXTd308Zse2oB23b21hhyd4JiPSQ/A/2TZtMWrCa5K60KuPfFGpoaDZKOSRKqlAVsJKNq8wA1mbVWtab6cUqvauGjfX9Szvo6WpE5rBAsZpIchkYENQE6gu6MX7xl/C7Dx1jwSnaJO9ATVOMefB9yyp34Nuys3z35qLN6Co61LoSxAKaKGZOPQ181Vmzge3xz5k4sAZz2uvn7zxDtIcJGRo6BvxKQzznGp4QktbIqp/djV+jyIIyHC+A0vj97RhuZxnVJ/1p4VzzaqlXgTbaeCrxPrqhMRwz5Z2ZaX5ZtRnMWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8S1qOl6ONwmNwKdZ2sn6wAb0IuKHi0uaLJHAOburP0=;
 b=WlFunQRIETY32WN+s25cBGEb4JfKyeqRtkSJVJ9v7miZ2AB8gobpS2hVvgsXDk/5AsK8F3CXqQUChU6h3eCuFM2rNjfoI+Iy15PYPsBX1NoO2MbEZyZIVTDLmAdpWITBh5YXnGGCdGK0kZ3uKzgJBhuxyP9EBpVN89pg7ncU+/0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR1101MB2141.namprd11.prod.outlook.com (2603:10b6:301:50::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.25; Wed, 14 Jul
 2021 05:39:19 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74%4]) with mapi id 15.20.4331.021; Wed, 14 Jul 2021
 05:39:19 +0000
Subject: Re: [Intel-wired-lan] [PATCH 2/3] e1000e: Make mei_me active when
 e1000e is in use
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <acelan.kao@canonical.com>, Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        <devora.fuxbrumer@intel.com>, <alexander.usyskin@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
 <20210712133500.1126371-2-kai.heng.feng@canonical.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <3947d70a-58d0-df93-24f1-1899fd567534@intel.com>
Date:   Wed, 14 Jul 2021 08:39:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
In-Reply-To: <20210712133500.1126371-2-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P191CA0032.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::7) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.168] (84.108.64.141) by PR3P191CA0032.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23 via Frontend Transport; Wed, 14 Jul 2021 05:39:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51de0d96-385d-4bb6-7b19-08d94689b97d
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2141B072045D638F52259FAD97139@MWHPR1101MB2141.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zY+XxmdtUcpHzeISF6l+PWOUlmcxv3maz3pToTyCupccEwMy7xqeYCr6Act9PkfWuKtjhGSnUIOpu2R3rSqixmIXrq/G923FLmeqzxj5aE2m7P8i3a15kr77M+NJGAlkm6osy8vGGXwT1uTP+D2DlKIaccsx4QVxSzgd6K1rIWktewmau93mLnn6m7VizvjjDGYHWVXjZd3H6n1U05YBA+d8Y/P6t2s3LVC9D+gVlUjkZmA9c3T5p/Ifj+w/DXfM9nL4ywapjiYwXFecc29ihtqMYbXD4ywMN7kQ/5qIPGQK42hFnik3lNXkjdS5HHyHD3Yx0p3/l1uCxJuiAnO/UdcyiKUbDvDB0W2qWNOM8BGwyyYFuPsmVXgobjFrb49AfsWAGHDqoZ3EivpkoqNszuyhTOfHLCw/1OX2fTckWaujy78wZJI3nAWRs200T/YWPiDVCZLGQ3PBWqr6hPO5dYX9SqcKDggwpZpoynHmwVi5zaCaHmv+wvwRtraBa0Pkfo+U4GQpzQ4HOMUdCitiiynwhHWrfpWyQ2Iv+eXyU7cJLFJWCJQJYZZmxE4QkmJnOkL6j5GYqPF/EqFp6AzgU10hwX12d8/uR18o7tcFnxa1aCtpwv89iUlDIZNO12NdFqNsQF4Zz+am3+dJtL9QjHZj4FWK3pxoYDBT3iBPY09Gf7hAHceegzcUrS2o7TrVbov12WhWYSt1wDg2ujTz3vmlbkRtlHMgnoZOAv/MDhJU4fBG1gfcmNjri5W8kZDCKxS1uMsEWxLhEIdVDoHmf5SMoNoGFAxHMfzWrCL+O62pkSicBycYSrJEC4ApXL4C7+EQNfX79bGnWqEiDHNVf22Y255Nzq6LV5KtJJK66E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(4326008)(6666004)(186003)(2616005)(316002)(16576012)(86362001)(478600001)(966005)(956004)(66556008)(26005)(53546011)(2906002)(38100700002)(5660300002)(8936002)(83380400001)(66946007)(36756003)(107886003)(31686004)(44832011)(31696002)(54906003)(6636002)(66476007)(6486002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHphcVpjU1Jnci9vczhuTUpUMkc0djJJUEYzYWMzY0l6UUlwYXd1bGZ5NENC?=
 =?utf-8?B?amthYXNPc29LMkdLWndJa0orcVVBSi9ueFRVV2t3UFQxVndGblFPcmlNeWp4?=
 =?utf-8?B?T1Z5dDdrUHExakFsV3dsSzRzWkdkZjFLaC9BQWxJMWNXVTdSMkJqY3ZBREgz?=
 =?utf-8?B?aGdsNFlhZ3U1Ykp5WU0rbUpSSzZrbWhIallmczlGTTBBQnRyeFRrVmxmMkRr?=
 =?utf-8?B?dlA0V3BsN1dPbEg3MmFmRW5UU1NCOCtSaXRHSnc3WURnU2VZWEdHUTZra3RE?=
 =?utf-8?B?WWRXb2xMNmVQUWNqYUl0a29jalNwSTJGV1NIR0JicTRXYWYyVDJrTGdNUzVt?=
 =?utf-8?B?TGxDc3poMkEzM3BaZm1za3crZGZZd1hYRVZPT0JNSEdhcTVGUkZQaHpveDZ5?=
 =?utf-8?B?WWpTYW5UVUpma2Zub1RsSU1yeGhILzdvdGF0aTNZaXBqSFJQNlNGcnpOZUxU?=
 =?utf-8?B?Q2h5SGRXWnozS1dyNFI0UGR2TWFmTVhKVnd1V1RGQlQ2aXQ4S0xrcFlhc2tD?=
 =?utf-8?B?eFMxTUZzWU9aaUFKVjdZYXF2Q2hIMng1dUhzZGlBQ1I5UTBFS0F2RDc4Nnc0?=
 =?utf-8?B?ZFJXeTNMb2RhYzFIblVRUEFJdWtyWk5zTVJtekpFV1ljdFNNWHJCRUw3b01J?=
 =?utf-8?B?OGR0K1dhNFRMbG1RRDZPbXBaRjNXZStnakRmbU9OQkJQdld0U2xnSzdTMW0r?=
 =?utf-8?B?OVlrQ1RnZDh5aVFmOGFmNXYzUHlRT2trRDR2dXlhMis2Vmd4SkJ6dk9NYmww?=
 =?utf-8?B?VWZ4MU9memtUVnVFSU5FRXN1TGVVejdtWjNpZDhqR1RhU2ZCTGtqUTB2ZmFv?=
 =?utf-8?B?b2xLMWdHOFN1VmJBaDlaeWoxYWl0OXB5STJKcURQZTQ5NjRzMUJSR1h0VmpK?=
 =?utf-8?B?RVZhcE5JZ0NXQUN3cGxneEFQVGl2NlVlZWtWMFRSNnppa0hndEl0KzRVUThH?=
 =?utf-8?B?bnZsUXRXUXNkM2N0S2E3dUhEZldzeHEvam1NZTdiTXNjWDk2T25EeDNuT01Y?=
 =?utf-8?B?VDh0RW1uaERraTdZRWlKNVhXdkphemNJRU5ydXVHYW1Oa3V6KzdEZVBkRFpq?=
 =?utf-8?B?RjVKTWU3L3lVc285ZFZVSzJqd1FXUWNUT2FmRWtGYmZ6ODdYNHBnM094ckxF?=
 =?utf-8?B?V3dRWHRUOXYzRHpxb0VxU0dINmkxL2hBTXcybXhqeU5jcWt1OUJOMHc0OEQr?=
 =?utf-8?B?U0tZV256MDBCL3c3ZkxJSHJrQllBYmkzL1VXeGlHYkYxNUFaR1JRMVQ4Q2t3?=
 =?utf-8?B?WG5uOHhabExyeWY3aWhhRFc4R1dES2o0aGhzMm5GN09aOGd3a3dSSDN1Y3E4?=
 =?utf-8?B?UmxSZ2NzNENUd0hTeXRVTVl5NEY3aVlDU2w4ME5mRjcybFRZQWZlQzBYUm9k?=
 =?utf-8?B?amtlc08xVlU3SlJyMVE2OTVqMGZ4OVVmeVp2alRDVjcvdGJmOHRhN0djd0Vh?=
 =?utf-8?B?K3VIQnBraEdrNUNZYzFuMnUrR25kYnlOUnc3NG5md2ZDU0x0N2F4K0xTWmpu?=
 =?utf-8?B?TE9yL1IyWGlNTTdhWVE1MlBIY1cyVkpFc1huVXg3NDI0U0dmWjlqNmgyV0k4?=
 =?utf-8?B?YXJyMHV0eUtwc0tHOC9nUTBMNEFFeEFQZ2JUQU54L25XNDhzeXJLdGIxa2R6?=
 =?utf-8?B?cFJsV3VUNTNtSTJGOUVJWjZJSFkwVHdFcXMyWG91ekpKdWt6NmI1TGIvSFhm?=
 =?utf-8?B?b0FPOTBGM2pQZ1QrSmI4M0xTNlpibklmUGt1ZURyZXZoOGc3WlpmbmJkWC8v?=
 =?utf-8?Q?FjFn96DZNj9aXcJUsMAArkLbLFNfVJftTk4UVu0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51de0d96-385d-4bb6-7b19-08d94689b97d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 05:39:18.9702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2wZ3jqfsGSTCMil+PagAVdOQobwjQeu7y6laVMmpM26f9nIB2XlU1Uu21phICunyP7e5CALIxa9qelv7SgmYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2141
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/2021 16:34, Kai-Heng Feng wrote:
> Many users report rather sluggish RX speed on TGP I219. Since
> "intel_idle.max_cstate=1" doesn't help, so it's not caused by deeper
> package C-state.
> 
> A workaround that always works is to make sure mei_me is runtime active
> when e1000e is in use.
> 
> The root cause is still unknown, but since many users are affected by
> the issue, implment the quirk in the driver as a temporary workaround.
Hello Kai-Heng,
First - thanks for the investigation of this problem. As I know CSME/AMT 
not POR on Linux and not supported. Recently we started add support for 
CSME/AMT none provisioned version (handshake with CSME in s0ix flow - 
only CSME with s0ix will support). It is not related to rx bandwidth 
problem.
I do not know how MEI driver affect 1Gbe driver - so, I would suggest to 
involve our CSME engineer (alexander.usyskin@intel.com) and try to 
investigate this problem.
Does this problem observed on Dell systems? As I heard no reproduction 
on Intel's RVP platform.
Another question: does disable mei_me runpm solve your problem?
> 
> Also adds mei_me as soft dependency to ensure the device link can be
> created if e1000e is in initramfs.
> 
> BugLink: https://bugs.launchpad.net/bugs/1927925
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213377
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213651
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 26 ++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 5835d6cf2f51..e63445a8ce12 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7317,6 +7317,27 @@ static const struct net_device_ops e1000e_netdev_ops = {
>   	.ndo_features_check	= passthru_features_check,
>   };
>   
> +static void e1000e_create_device_links(struct pci_dev *pdev)
> +{
> +	struct pci_dev *tgp_mei_me;
> +
> +	/* Find TGP mei_me devices and make e1000e power depend on mei_me */
> +	tgp_mei_me = pci_get_device(PCI_VENDOR_ID_INTEL, 0xa0e0, NULL);
> +	if (!tgp_mei_me) {
> +		tgp_mei_me = pci_get_device(PCI_VENDOR_ID_INTEL, 0x43e0, NULL);
> +		if (!tgp_mei_me)
> +			return;
> +	}
> +
> +	if (device_link_add(&pdev->dev, &tgp_mei_me->dev,
> +			    DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE |
> +			    DL_FLAG_AUTOREMOVE_CONSUMER))
> +		pci_info(pdev, "System and runtime PM depends on %s\n",
> +			 pci_name(tgp_mei_me));
> +
> +	pci_dev_put(tgp_mei_me);
> +}
> +
>   /**
>    * e1000_probe - Device Initialization Routine
>    * @pdev: PCI device information struct
> @@ -7645,6 +7666,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	if (pci_dev_run_wake(pdev) && hw->mac.type != e1000_pch_cnp)
>   		pm_runtime_put_noidle(&pdev->dev);
>   
> +	if (hw->mac.type == e1000_pch_tgp)
> +		e1000e_create_device_links(pdev);
> +
>   	return 0;
>   
>   err_register:
> @@ -7917,6 +7941,8 @@ static void __exit e1000_exit_module(void)
>   }
>   module_exit(e1000_exit_module);
>   
> +/* Ensure device link can be created if e1000e is in the initramfs. */
> +MODULE_SOFTDEP("pre: mei_me");
>   MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
>   MODULE_DESCRIPTION("Intel(R) PRO/1000 Network Driver");
>   MODULE_LICENSE("GPL v2");
> 
Thanks,Sasha
