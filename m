Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A25665A937
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 08:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjAAH1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 02:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAAH1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 02:27:47 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8407B55A5;
        Sat, 31 Dec 2022 23:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672558065; x=1704094065;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G1OppLVaFbnK/9EjTL+SVEdn32syeo1k0UeC/RtW9Hk=;
  b=dt0omy5G1qGmIG5wS7K0vaXMbxStnIkWXd4lHHyKsGCrHoUIhnG6fULW
   WqKcvD9nCn0kbietD6wGPS2r5UF9PGsEmviOwzMxXXkU570XJeKIiupYG
   o/PkrudF0gkRBj+u4FMSdF1bkIpXI2f9tW1Bferf0WjE+nrePs5+xzoFR
   kY7GAu18ENgSOVr8sy+VAaAbF3zzqLHSkaMrLpHWxwOG3GXlUPCs55phx
   3PeOPP0WOynbx65Ubudc/AFtP9jxV6CAmwKW5hYF+vio32eL0dMstTOxK
   2gSavSDIFKEUwYm1ZabppmGhvbDJagzl+SRKh+XDpG2HP2rbm/wfZ2Cgq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="301045631"
X-IronPort-AV: E=Sophos;i="5.96,291,1665471600"; 
   d="scan'208";a="301045631"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2022 23:27:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="684822995"
X-IronPort-AV: E=Sophos;i="5.96,291,1665471600"; 
   d="scan'208";a="684822995"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 31 Dec 2022 23:27:44 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 31 Dec 2022 23:27:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 31 Dec 2022 23:27:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 31 Dec 2022 23:27:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVXwG/HXw91iJeZ6iFbGlUdiU2ISkzUIpUYZXJzHHwtVj4aXI89d1Ps/cmKwkhOm+zpA2AXD9//7p1+XFtuMAawXX6XrRves8Mk+FXGBKnGWfU9otZeGyLz7wASzSdN5TDCvmq8R/mxgRWx3EfBuEiwA4CZBdA7Qg/6CSzg4e/pj0yFt2KhW8iVlDMuQPg4UpuT891Mt00hmrYRhN+kuB/dqDrkgFja5J56aAvBrlYsFWf3yVh66L3FRFiGaANlyFsks3rCie2KkbVapO0AsAHfOHbnFJPkLFeDHVXnlDXaXBlpRuNPJFlvSiBkmvKm8lY8aOfi9HrIND4RI44ayWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=196qRogZ+GRPc3bqV29gzcvhMAQ9xgkHF0cmV/6tHBk=;
 b=oKfIFzj2oG1nh/DCewTc4EFoLwXyyu6leA8xUNsuhczlvPZivi1uuR6rK35zVBsDtfRav9Owg+E3HuuggVnlX1SjXoutXuIJPj4GoLk8+YpmVYbx7T3e7y/nWpT6qQfu4Tw7dSdZzndfIo7uFKwvJNWfqk67XiyRon0O+KcYeSGuC3bZYRZHOergdCs/xKdwzW35xrY9zpv3BgNt5ZJq4hFPpbVfRF4KJHnIKSbUV2NzlNgCp0eBza9ddCOVX6Z7YV3krV+zJQtBEq9NwHYfq8dSGPHt3g8MHoD1OxhjhcD2GN32fSXrCWgkqjAaDP12+FsUXRVhUMt+qxznSuoRXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
 by SN7PR11MB6850.namprd11.prod.outlook.com (2603:10b6:806:2a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 1 Jan
 2023 07:27:35 +0000
Received: from MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb]) by MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb%5]) with mapi id 15.20.5944.019; Sun, 1 Jan 2023
 07:27:34 +0000
Message-ID: <249b621a-a527-6ee9-7802-acb34e91e433@intel.com>
Date:   Sun, 1 Jan 2023 09:27:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
To:     Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <rajat.khandelwal@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
Content-Language: en-US
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0192.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::16) To MW4PR11MB6738.namprd11.prod.outlook.com
 (2603:10b6:303:20c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6738:EE_|SN7PR11MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: adf8c267-f9b7-4b5c-51e0-08daebc9a6b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivrgrqlR6+X8XDAJ7sy4PdO2o8vMW8qSTFP4FD1q5wz4ZM1Rcml6sbuXLX22fk66rPKgrsPKw/SzlcdJVZYkNOPMf48tfKAbz4TBjVj8aaCVL6hQFPIv5m9a2xKVEnfexsaaE79zcTDkO/YTueoPCs6cVzHkFRvmE+CeflgcMDzt8qy974x5tccPWsD6zcH1wIK7uYLHk4fbkLza16OOMZp0VvKV+5NAfyDeqiCp0K811j+vwCMSKZbWE/byNiMYRB2F+e7m/eO1sIegxzFdHQCmyQQMmHOtM4kNxtwjbEZzkKuTBW47AD8vavx9IBwLnUSSbKXHiblFtLh8aM1HKzMs0H7EjbJLgztUk0OGXQw0t+2DJYYVHBlWn5aqNx2e3wska29R8EBtG/vvYLRmPpDYZrf3bojcB0qQWhnWftkwasd0YC9SP8l2MSJWvASIfosUswmMNQA7gdHy2bs527NOpiNsWV8qDIx/rvFwsmXrUPC59asmvQR4PO+QivQeU+ETK5JUtcUqyPy4irmgxJpNP3QDifFkgRJmLY9BDwuPj0iwliRUx5vbysxPBr2TA5nG6cwUN3kWTg63Fl5BopXahtTeLVB5mBsgJMIyG1H/+PdDJXz1LAf/3n5z4AVccoS2oHxVy6U6uQ7/+0DoIFQTXOhYFQqcMYhnuk2zyarlo6xqiESorILR2RpMWKX2KoUIdI+vr8HD/sS2tZWmqUUHJw93zQ8zcAB1PKm6M0Ctyc7PYmzTJD+xbEyGSmn9ZrLdV4+aJu8D0RYum8T6tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6738.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199015)(921005)(82960400001)(2906002)(31686004)(86362001)(6486002)(66946007)(38100700002)(31696002)(26005)(6512007)(36756003)(6506007)(53546011)(8676002)(8936002)(6636002)(110136005)(66476007)(5660300002)(316002)(4326008)(478600001)(41300700001)(66556008)(6666004)(83380400001)(2616005)(186003)(22166003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVN4OExJQXRRY001MkQzOU94UmlUWVNFb1FyRVNlckN0VEY2UE5YSFJQdmtM?=
 =?utf-8?B?TnlsRzl4MzJnS2ovdE85Sis0RzZMVGNiOGhhZVBRaUFqdGtXNUMzVmVLZllI?=
 =?utf-8?B?ZTZuTjZpaHo4NU1mRGNRNVpqTTY4K05vUnJ1SWhTME1BbUFjc3BIQ1d6NXZL?=
 =?utf-8?B?b3VvVFFscmU2L0MzRlk3ZFQrMFFGNTlrM3RPaFdyMHBTZ0VkL29vZUwxS1Fl?=
 =?utf-8?B?cG1Zem1ydkdPRUg3SE9yOWJJSGU1Y3plMWNDK2VpVmd3K0tvdm9ONWxrU3d2?=
 =?utf-8?B?UE5XUkF4QzhZTjNUbm5ROTcxNExobTN6UWEyWmZHMFBBWG5EYno5eGpvaHZL?=
 =?utf-8?B?di9WU2l2d01nZExKUDZBakE4cEpWaldoMDBRN0RncVQzb3dDTG9HL214QnZZ?=
 =?utf-8?B?SUlUYzFneHNlc3Q2SUk0UG83OGs2c0FOak1scmw4ZjZIMXNTQXMvUHVwMU93?=
 =?utf-8?B?NUxwOWJxK1VzSXRKVC9kNjAxeCsvUnQvcVhQN05oaU5kaFU5T1VVM1gza1I1?=
 =?utf-8?B?T01jOGExVkdXdFdKS3ZtUFBoZ2UyNHpSOGFjQWhDSk5uOUlncmJYeWJHVkh4?=
 =?utf-8?B?WUdHNFlHdDJ5UVdmKzlaWU4zS3J1UEZzV1RZUnFGUDFUOU9mbE9KNXpIbENk?=
 =?utf-8?B?Tk1ZbHE0anFpZjQ4cEdwWE1UYUZYTittYldENmpjcURDNk53dzYrNlgvZWJ0?=
 =?utf-8?B?WldIUjBiWW5mZVlKUmQ5aUxoMEFCTXVRTThxU0dudld5U2MwNWg4WUszUVp2?=
 =?utf-8?B?enZNR202V0dDZXp6T0Vzb3BwV1poMlpsSncvdDZLNEQxRWpWYTRRa0Y5dWdw?=
 =?utf-8?B?TTd5NSs0UWNmNUgwdWdHU3dYd0xkTktYd1BlNm51SUd0OGFUMytzcHZVZ3Mx?=
 =?utf-8?B?TDBzNnhJVHFFWWtSUVl1cFc5RGVvck5sZDhlWnJjc1NYMDZZY0x2RG51bVNI?=
 =?utf-8?B?aVlOMyticG5KckwxZGU4NnVEblp1MEwwbUhuRzgrN0NQZEk2emQxKzNYUk16?=
 =?utf-8?B?S2pFWjZyVThTUGQxWTYzb0JKd2Y2MTRCblhlUjlnT0VZUXZzN0F1N0ZKRHIv?=
 =?utf-8?B?dkh2QVgwYzdZb0gwVnhrR20yaTBzdFZJSXlIODN1bE5YY2YzN0xCSTVJOUtn?=
 =?utf-8?B?cXNad29vUmVJZnJVam8ycWppaFNQVlAxenFGVVNVV0dvVGJMek9teXlBSC9s?=
 =?utf-8?B?Sk5WM0huZ0FTaXVBMTBIbFJXLzFKRnJHdDgyRHd6cTNZa3l1N3dTWWxVbGpy?=
 =?utf-8?B?eXJiNTBlNnkzOTRYR1RoTWs4czUrK0N5N0R3eFBJMTkvUE5PblY1a2dzQlZz?=
 =?utf-8?B?amFsYWl6SDRoOHQ3bVowaWlXRDJLQXZzZ2QxcUcwSk5qcHpwL20xbW9mUzhJ?=
 =?utf-8?B?KzNvNzdkU1RjcnozbDYvQVBxUUtDTDNwbVdJK3hJcG10dWE2YVJMaEhGZEVr?=
 =?utf-8?B?MW52N1FHOFlpNUtNUXVjYUNvazAwWXlmSU5mQU5hb0N3Z2ZsNFpidzFvWFA0?=
 =?utf-8?B?bEZXYzlqOXpaU2RoVFlQdEhIc3BRd1dvTS94NnNFWUQ5R2tSSVJjRjZZYU5l?=
 =?utf-8?B?MG1TUVZoSzk0SlZWVURkcDJzNWs5dkhhbmxUc2c2UVN4KzRZU3UweTFkL292?=
 =?utf-8?B?KzFXbVZweENaVm16ZmprSDdvVnQrbWpyMXIvWG5YZWk3TFVtZnJxS1VKZjVE?=
 =?utf-8?B?QzA4SVhMNU1ZSDJhTnZ6VjlYRnJiMXZKeTBraWE2dDZuRDVsMWFLV0QvanFy?=
 =?utf-8?B?bGY2R3JhbTFhSUxOamltV2oxNXRnT3FjRTZCSG9yUytpb0pObEhXbThOSjla?=
 =?utf-8?B?SmlqR3o4S2QrdTgvMUd5YVpHcE9odlZlYm56dkVYT1l6MHFyTTBLWVFZbHJ0?=
 =?utf-8?B?c2RrU0NNVENiOGtaVjBSMUh2RUE5VjJyWU54VVNXMzJlclBSM1pkZlF2YklJ?=
 =?utf-8?B?QWZzZ0FjSStsbWZsMjNQN0dTWFNvamZJekc0NjI1UWFCUmVuTDhuM0lqdGMx?=
 =?utf-8?B?bGx5Zk5UcTUvSjZtdDVuTWR3TjFDSHc1ZitKeW8yVUtiTUtuQWtsdkdoTStp?=
 =?utf-8?B?K3kvNGRuVk5WWk5pZ0VMOHF3ZzNoNTl6d3kzVVh4SFFxdVpVc0FYM3liMWIr?=
 =?utf-8?Q?cRckTyn4e3s1G+pNeHTzcMG0J?=
X-MS-Exchange-CrossTenant-Network-Message-Id: adf8c267-f9b7-4b5c-51e0-08daebc9a6b1
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6738.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2023 07:27:34.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f85JSHVho1LJYov7l8+dYsMQQzaSZuGmh+Fzp7MPqdDPgYBnMzw7hpfAieYBLFp+z2v5AMWcWFFes/KU9htCYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6850
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/29/2022 14:26, Rajat Khandelwal wrote:
> The CPU logs get flooded with replay rollover/timeout AER errors in
> the system with i225_lmvp connected, usually inside thunderbolt devices.
> 
> One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
> an Intel Foxville chipset, which uses the igc driver.
> On connecting ethernet, CPU logs get inundated with these errors. The point
> is we shouldn't be spamming the logs with such correctible errors as it
> confuses other kernel developers less familiar with PCI errors, support
> staff, and users who happen to look at the logs.
> 
> Signed-off-by: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 28 +++++++++++++++++++++--
>   1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index ebff0e04045d..a3a6e8086c8d 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6201,6 +6201,26 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>   	return value;
>   }
>   
> +#ifdef CONFIG_PCIEAER
> +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	u32 aer_pos, corr_mask;
> +
> +	if (pdev->device != IGC_DEV_ID_I225_LMVP)
> +		return;
> +
> +	aer_pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
> +	if (!aer_pos)
> +		return;
> +
> +	pci_read_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, &corr_mask);
> +
> +	corr_mask |= PCI_ERR_COR_REP_ROLL | PCI_ERR_COR_REP_TIMER;
> +	pci_write_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, corr_mask);
> +}
> +#endif
> +
Hello Rajat,
May we use the privilege flag approach, give user control: and mask some 
advanced errors?
Although...  Why did it happen? Didn't you prefer not to investigate it 
or else mask it? (I have concerns about the PCIe link over the 
thunderbolt tunnel)
>   /**
>    * igc_probe - Device Initialization Routine
>    * @pdev: PCI device information struct
> @@ -6236,8 +6256,6 @@ static int igc_probe(struct pci_dev *pdev,
>   	if (err)
>   		goto err_pci_reg;
>   
> -	pci_enable_pcie_error_reporting(pdev);
> -
>   	err = pci_enable_ptm(pdev, NULL);
>   	if (err < 0)
>   		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
> @@ -6272,6 +6290,12 @@ static int igc_probe(struct pci_dev *pdev,
>   	if (!adapter->io_addr)
>   		goto err_ioremap;
>   
> +#ifdef CONFIG_PCIEAER
> +	igc_mask_aer_replay_correctible(adapter);
> +#endif
> +
> +	pci_enable_pcie_error_reporting(pdev);
> +
>   	/* hw->hw_addr can be zeroed, so use adapter->io_addr for unmap */
>   	hw->hw_addr = adapter->io_addr;
>  
