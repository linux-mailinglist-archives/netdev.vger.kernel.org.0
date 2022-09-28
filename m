Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7BF5EE44D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiI1S0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiI1S0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:26:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E10FEFF68
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664389609; x=1695925609;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1VTm6FK0hNwhUv04urkVIWKyT0LiMW95tgfZSgGR524=;
  b=BWN2SuIxjRhRe0rnlv+3wo+AKoYxPxJNUN+cut2VfMkkk1Je4v4uEpW3
   60af6N5vKJ0gopAN9Qmu/RgKzQFn+NZrPSwI3m+U80VmUBU62rltaJrGx
   wz71rBIT3xlz+VHQKkKxhg+HS6FxiF5eopanx+Uid58cIZqkBwxSLDpMt
   qSYAiuKMSVYhSoUvr7e0V0G3DDAZQqPKqjnMZgrMGQgC09sZ2UZRyfvpX
   qMZIKYZqfGCJuSq5uwO6OpgMGAuhs099GaoHNugFC0vDg2HdID9BFjdOJ
   AnGDWZzSNt1cdqwzmv5JQ8FmWBYhfQc1KbGxhJa8Ef1jqFRjn1rdcbNkh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="288842146"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="288842146"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 11:26:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="684516362"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="684516362"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 28 Sep 2022 11:26:38 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 11:26:37 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 11:26:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 11:26:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 11:26:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8Ip5em7rXRbrwPDNf6rs6MISs/hoKO1WaHrI7HYuVyvkMgYALihdQu0XY/e1O5evKRI1eo9TJHej/YCkUPpapl/f5+GmbVLGLWHpeTSlng5Uio66dM4dOas9RGfopKlOx2DWzUVNnRC3OS1woD6mX4DZq5pW0+JEBF9iRRcuePzfKm5wgh5UzxODZa2L8Oh2lQqXyZ39QmGHeCuf0p3FWcX0PEYptGm+ovSEQcnLB67IJCxxitH96wChMOs4jvnm6F2waq8wKrbegeKf9DaiVIVHvQtZwn2QcUN/RgbNeWgqWU2+cNNcfnBhNbVrE1r8PGIayRl1SM3WKT9/ioX6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CbFjkAjlx30zo8R3B1pAouZYoy7PhzoybcTTb5HHZU=;
 b=bRigrdASjLwryioTvbBcpLEWSv32ncmxsU/L1K/6RQkz0SrWliGlBfeyg1v4+RhhbZ2j+oJz1dxnxhvganrSfkD37XopaPqKF5NuWy00G4D2f9Ivx77aE8rk6dXl490MNo1AIGVib1fpY1SgjUeOJuj2oT32DElM2od5XNS00AMU5Y4tfJXblK4gN9GLhXzWsSyv4i0GWPuydjdtORoNXuHFTUP/sYchkoTFkxmS5RqVDpCR2Px55qKy4561EgGXOdag6bp8A77Gwg8oAJRSwrq+7VrLFSgEzSG+af7pz8jLmIaXY/MMo7tCOtafosucEdplQOIIHB/OuGysfW3soA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH8PR11MB7048.namprd11.prod.outlook.com (2603:10b6:510:214::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Wed, 28 Sep
 2022 18:26:35 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::e1bf:5cad:6e0e:cd0c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::e1bf:5cad:6e0e:cd0c%7]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 18:26:35 +0000
Message-ID: <084792cf-07b9-8342-31cf-1fea93ce1940@intel.com>
Date:   Wed, 28 Sep 2022 11:26:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        "Michal Jaron" <michalx.jaron@intel.com>, <netdev@vger.kernel.org>,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
 <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
 <20220927182933.30d691d2@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220927182933.30d691d2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:a03:331::16) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH8PR11MB7048:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d725a51-7c43-4bfe-49e9-08daa17ef9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrkPdZic/8h8MxDaJWSfKFh49Z7f+Qr+kHeyjKutJlnU3j6ZcivNvH7E4X8DnzBH2N0P+jH6B1aiXH7w4g78ewB6OmMMbv40gSmk5dowLnjYd5FbwEHkiq8iw1SeUMLt+TJsOR02EZxfAllO8xu9Cbe3AIE7MjAin2+Z0Mc0CBGNporJn5dhTcaT36Os646bW0MWY2d3mgu6bffPPUsn+125Dvx0axycczdFs3cwd0+lPbZfUGA5aUJMR2kNvjmx4JJ3rmRxOEii/klCqllCk5vVqf9PgEoJSXgh0jCZ1GhQbN6jt/Q83E7OQbCcbPOVuYefnQLHSzs18hK0+X2fBrXyO+h6ldP/IZTT96H78rGBUcY7J63iKDp+j7tCvbicz+mLVhVRwZ1LbA4olHsxK07CN4W6lOyt1WrHbXUD2K7ZVhOsnD1Q0OVRjP16k/OUZ0cVh4o/i/hV+ef0MaLlk2e4Qmdc7E2A11AkOBGoxRJeNgQuiZcyOoKKUdXhUi8+Pb2UVhrWy/N2IKmBTGRAHQnilTkmDHb+zcp7t4pthYFvtSjwv1J26ZNPEVw/05etc5tAzDp7QEDBy+w64XKTT6nKZI2cEpt2Bb59/n1AjD4oCHsHa1c8hffeFYCOVfXd1UzauK2csFNtwo0sLQttYLhA4yZ5mgp0mmeSrPCy6+UdSZytFkcEvEnWOyn6OeDU1tbgypuFQMTB7Vz1CaM3lpcGegO8agTkAyStJAeIaCDqHJ4+Rbpt6N+5GofwbEnXNlhyyw99f5/14RN48eK4GwCBjCkIG136JvR4yaeBOr0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(376002)(366004)(39860400002)(451199015)(66946007)(86362001)(31686004)(38100700002)(82960400001)(2906002)(107886003)(6512007)(6486002)(478600001)(6916009)(8936002)(26005)(54906003)(5660300002)(41300700001)(2616005)(31696002)(66476007)(83380400001)(53546011)(6506007)(4326008)(186003)(66556008)(36756003)(8676002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b21HZElxdWFxc3VzTi9yWVNIeE5lV1JheFU2bmw4bXBQNjVib210dHFOMW1I?=
 =?utf-8?B?M29GVDczZS9LTFpzSDJ5SWJTZG5CWk9lU1NndXhPV1BPNkZkUHMvUEdJdU9Y?=
 =?utf-8?B?WGw0aG1XTnZzTXhuNzZkMFZoaTRKN1VkUnZUTmF0cVlNcEJRTCtsalpja041?=
 =?utf-8?B?RVRFT1p5UFZjMWpIb3VoYjNhKzc5ajIvOFhIOE9CMm5DVDB4NnVqV2RqamhR?=
 =?utf-8?B?c1d4WTZXWm9XaHRlR3F4TkpxTjVpU2Q3cURHQ1pXRy9MZmJEOGxnL3BBNElX?=
 =?utf-8?B?d2EwTkg5QmxBZkVzRmk5b2FBdFdsSC8vdkp5eG9xdm9LMlRZdCtZVlNWOGRL?=
 =?utf-8?B?eHNpTjJMeGpnNEZ2blAzQldEcGhXVy8xQmlrN0duMTg0SHJYNE5KSTlwTDVu?=
 =?utf-8?B?UGdlRHl3andZMFRhQ2lOMUNWK1EwRDZsTzdvUTB2NnFFSVNTalM1Q2RlbXMx?=
 =?utf-8?B?SzFremIyOU5zNEI5ZmE3dDZoekpCVFZ0aFJiM1J5MitTU0lZSDlwWFVibTRn?=
 =?utf-8?B?YUFjNHJQSWNQaGNDTG5DYzc5dEJWSFVjMkNsblNUdTZmRWpSMWQ3NSt6RVJO?=
 =?utf-8?B?RkFyTGlZQytNSldtdkFKSUZFQnB5OGYyejdKbnNnNmtFSk5rQzdtY3VLUkhW?=
 =?utf-8?B?Qnd3UkpOODhjQzJVNzZJOEp6cW10cWRORS9aWVZPQ0p5ZXlabVkwYkZXR0Zi?=
 =?utf-8?B?K2NmMWE0T1FDWmpKWTdqUTFCdXBweW5vck1TUzFMTGZxTUw3NzFFaWlOYVhJ?=
 =?utf-8?B?cERGb0tWdWV1bVBTNjRmazk3L0pvcWJVQTk5REt2YytLY0VtZnJWams2UHYx?=
 =?utf-8?B?SUo0Y1VtZEtLK2dSYjZKbEtKMFJrTlhRNVlGcXRjWnBtMUVsYTQ5Mmx5OVRm?=
 =?utf-8?B?eXJoSXpDdWdSQUJlelhWV1dWMmptY24zRjdJc0QzRHo5TlF4RDZqOTNtakUz?=
 =?utf-8?B?bStic0NFb2lRdVpkMXpRb3VxS0RWMzMrdXlmNnBiVUVSZ0VCWFIrT1lxMWJI?=
 =?utf-8?B?UEI0YkNnaEtuUXl6MDZpR29GWk9PUzlITTVBY3FSTVNOLzVTblNzYlhPNGRZ?=
 =?utf-8?B?MTlyZFdCcmE2enNjUzNvNlFjcURQMklWUFFrQm1jT1NQSEtTZnVUUFhFa0xj?=
 =?utf-8?B?dTF0NjFiSzJGb2haQmsvT2pUNmtZN0s4bkwraFhLbHpVWk1QYnp6QktuR2VM?=
 =?utf-8?B?dUhZSFc2UEk1UVVDY21HMy9Ja2FXbzBNdnRmb3gvem15eTY0WFJCZEM2bHpp?=
 =?utf-8?B?TlNoemNscVMvcXBKRGxJNnNaSk93c2FzT2ZWR2JTYUsvYktHYm5PeGFPSm92?=
 =?utf-8?B?Wjc0NG9RM0c4eC9ML0JYWitxWFgvakoxbDY4ZnRJOHFRRC81WUlpRUFaTFp1?=
 =?utf-8?B?UEtzbnA4ZytoanJiUWE4bE9iOSs0QlEzdFIwS2xuYitVRFIxTmdSaWU5YUo2?=
 =?utf-8?B?elBCS0ltU0ZBbGhtb0RNZnlpbDQzWnpnbTRwUDdnTTdCOGgrY28rRWYyckZK?=
 =?utf-8?B?TkQ4ejRSWmVRSHF5SDEvMHBXeFcySGlzeVNDK3VDWE8zcm5HRkNvTFNldFBp?=
 =?utf-8?B?TGFaeCtsS0pSemYvUHcxanJ5LzBXVWpjU3RtQlBVdnZHaWhXcXlEOVQ3Z1Nl?=
 =?utf-8?B?U0tUR3Q5WjFMVWIvd256aUl6clBjUHFiTWFPSjNRaTZoaUg3MTdWR3BwMXE4?=
 =?utf-8?B?SzVMUFZCNEFqazFJNTloVkYvek5uVEI5cHNWYXgwb2NFZTdiY2pNTk9PTENG?=
 =?utf-8?B?YlNpa3F2QlFLRGRWalcrM2huQUM5NUY0L0xyRXRQVElWSmRnQ0JDMXJDa29j?=
 =?utf-8?B?dCtza2RvSTdKNTZUbm1Kd3JMU010dzF5TlF3ckNpNVBIK0hSY2NMd2V1Qzcw?=
 =?utf-8?B?eGY2a1Qxa3VWck5CR3k5eCtOQ1J0N1Z6RWY4dllDK05JT0ZjaHR6OC8zVzNF?=
 =?utf-8?B?VkUrNHByeGJ0MFV4Mk1FY2VnbUNYMmlRaXBybFRlbnI3M0Rrd1E1aDN4MFZw?=
 =?utf-8?B?N3FBVUdjZ3RBbVVaQ2dyMVZickl2VjVWZVRibHdpV3o1VHhNZHNHNERES3FS?=
 =?utf-8?B?OHVuTVBWTXVYRUJjdFp2SmlENlA0UHNHNnBwdW5RNHlMS1J4R2xqbmZkclMy?=
 =?utf-8?B?L25TejB1U2dEYkdwOGNNME5yWStlU0FtQ2dDalcwWDlVdTlZcHlLSFJ5bjd0?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d725a51-7c43-4bfe-49e9-08daa17ef9c5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 18:26:35.6628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o274OwSNg4XiQIEk9tTnlCryQvywIt/cKfelH0Drv7kF7v1gvAeiA2qtzCKiu6DPItKbmXSzQB540Blf3eLUZPBxA5oy/YhvNcfE9D/jUa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7048
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/2022 6:29 PM, Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 13:32:13 -0700 Tony Nguyen wrote:
>> During tx rings configuration default XPS queue config is set and
>> __I40E_TX_XPS_INIT_DONE is locked. XPS CPUs maps are cleared in
>> every reset by netdev_set_num_tc() call regardless it was set by
>> user or driver. If reset with reinit occurs __I40E_TX_XPS_INIT_DONE
>> flag is removed and XPS mapping is set to default again but after
>> reset without reinit this flag is still set and XPS CPUs to queues
>> mapping stays cleared.
>>
>> Add code to preserve xps_cpus mapping as cpumask for every queue
>> and restore those mapping at the end of reset.
> 
> Not sure this is a fix, are there other drivers in the tree which do
> this? In the drivers I work with IRQ mapping and XPS are just seemingly
> randomly reset on reconfiguration changes. User space needs to rerun its
> affinitization script after all changes it makes.

In the interest of the other patches, hopefully, making this kernel, I'm 
going to drop this from the pull request while it's being discussed.

Thanks,
Tony
