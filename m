Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026CF4DB81A
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345276AbiCPSs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiCPSs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:48:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48476E345
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647456432; x=1678992432;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hLTeQDNeH4MBO1LYtcj+d81fnv3lOqeyPBBZc7EKQBM=;
  b=XSQxniZnbNSVxbnEbuwbIskwABaV2U7aJIQjXS9I5rhn3pClKZC+EfSD
   EhPLLGY/GpoOc4o+sufNCJHDuINSS6PSF9R0E+1xQtsupcG7VETbKN1l9
   MDB6Mvj5IZ8UqfSfiMk7CIjb60BVfz+xRxrmKZ+6VEmV+BZtWqeUg0ruT
   IZwyClq65bkiDiheV744NhUBB7Qqz9yk5iy0ldSR08r5z5U43VsuOgtJ8
   Vlics9dtDTBbAHmeRvjwmigtOBB6dVYWt02SYwB4mu/UdWd9zi0i26K1S
   IKreqdY64KHN8Fut0M8o7M5LTyntIDZu/L+YvTnL5CXegBcBgscE+IzqV
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="256413607"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="256413607"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 11:47:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="598827830"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2022 11:47:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 11:47:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 16 Mar 2022 11:47:11 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 16 Mar 2022 11:47:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UT+DMbjQuAxWqDOKzIgDcMeYAUjRYQ0L3SGGsO3AnD4pq4euPZDKq2VlnTrTkRNN0G4DZbVZtOum3lhffvAMJWmrU7vYuJuM7y8iCek5CD4+G1wiGAXjY7O/Fpep0DILrQAGfANY1kM6dtr1fDVzPLc3vWW0X/RJE9ZoehDEQUR23QfB4UXkmDRcC57nYLmgOhEynevHbexZfDpF9uLzxQnlL7ae7THRDbHm83rE9Sys7E4EGmDWNkT1X4K/Sm2V2u6pqQOptT8xrzvO55m9SZu3q+8wUmfMau9uyM7RvfIOH4WKNb0X0py4RVKWVle3yDHa4k5Pxx980Ecsd0GH7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLTeQDNeH4MBO1LYtcj+d81fnv3lOqeyPBBZc7EKQBM=;
 b=Dg7m3phY/XgwRBG1/7HDc0KK04lJbMLuZ5pzt70D649ZYYdfekS+vPycdDE6swOWkFV+A49nOdHTjzNSUYHYq7PQMJPdBgRK2jAyoWFuxOWbFeTv5kHMJZ0he74cRyGhEt7NfB0YaV4r86fzwKnVpd0UkKmsrH6AVxO1jPr01We1jSUh5siFRD7VjsZvIf4Zu2ieFX2iUO76V1PQ4U9TSmMinNmnXduPH+gYYeDOZRY2SKDmkVq5Bw30w+rPeqK/5BLrRGJTAn+JMWN9JD1zhPJN4Mc95gAtNrQ2ckA8y3GUTK+xu5PreN4vahl78DDQ4kj4fcRDx9Q35pb5rzQapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BL1PR11MB5269.namprd11.prod.outlook.com (2603:10b6:208:310::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 18:47:09 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5061.028; Wed, 16 Mar 2022
 18:47:09 +0000
Message-ID: <8499d14a-ea8d-a8a0-be46-c2ca5e050ddc@intel.com>
Date:   Wed, 16 Mar 2022 11:46:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net 3/3] iavf: Fix double free in iavf_reset_task
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        <netdev@vger.kernel.org>, <sassmann@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Mateusz Palczewski" <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
 <20220315211225.2923496-4-anthony.l.nguyen@intel.com>
 <20220315203031.444de6d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220315203031.444de6d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1701CA0006.namprd17.prod.outlook.com
 (2603:10b6:301:14::16) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99042708-685c-4151-02fc-08da077d603b
X-MS-TrafficTypeDiagnostic: BL1PR11MB5269:EE_
X-Microsoft-Antispam-PRVS: <BL1PR11MB5269A5F4472D8C7F2C8094B8C6119@BL1PR11MB5269.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UL4XXUL/DifllKsb3kL2Bf8py2oR+NQmeMMoY1P4lF/K7vEOKBF9c9KSk0+V8BAUbBxthD+bKP4w0QXly45IFpMEVXFvZLSRw6zWAnVqx+y93DMbsRTQu0bNGE9jvL/Ss2DsoefbcYZWReQW+VB99VbwM/+6RkZzsrUYdh8tt63QNx2cbTg8k9B2XTgJBWGTuur86vPI7iz1FKUOSVN+UWnDGeZam13OOw80mQFbmAiarCxPiQby9qzI1+W36ixG8cmhu1MFGznRh3x5p0URggybQqxqW6bitSTJkDPdG8kXPkX+EURmBJtQ11oa5s8VWcnBk0iJQ2gd11tPbP+C5C+Yjtt3e4HfYWXZ+8XlecmEso21MqW4XdgQ5eDoVli5WXdFp9jmucuGTYZSfWkmJzs68ZXsIHd8upGYeqE8PnNGbDiE4OKDB4DQGTiBFJ7taL3NqMIAQ5ab18NWGRHSNngwgYHkH4xUMMbNmIHTNH+q/uEscp9ddAmkhMUeLFwRfrsyBuaiG+ghSiG7i64UwgrfpEsvIZhu5JE/M5Jl6GEorv/nvSY/hATxd/zABY2bkmBNNMqELmwO8v/IeZjNRHhtrIpr2CAzT5+qAoyY+1V1d6lhgXAvuMsRnxmmgHnUgQ9a4YmFarHGX9vMie7TUaSs1jF3aiBfnPXmmC3XQbImjRHbl4B2cDXujWhrl7sCT7s6e+8dSHPN537/HnKMTUtpXbhfWIZWgeqgR+sVBaw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(4744005)(6486002)(26005)(186003)(5660300002)(8936002)(31686004)(107886003)(6666004)(36756003)(508600001)(2616005)(31696002)(4326008)(86362001)(53546011)(6506007)(82960400001)(54906003)(6512007)(316002)(66946007)(66476007)(66556008)(8676002)(6916009)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWp4R2d3K1c1aGVaeFJITG02OGYwTFZncFZPL3FSRFd2UXRUTXE0dGdyak5q?=
 =?utf-8?B?a1BDZEVnRVNZdUQxcE52TTlIK3c2VXMvR1d5Q0ZLK2tGR3E5Y1FqUjMwZG10?=
 =?utf-8?B?YkU2TEJFNFpYTTZJMUkrTUIxZ0wrUVN0WkR5RkFZdDBzZkJyQ2duUVdwSXJj?=
 =?utf-8?B?MllVdHZYRjhtTWJrRFdZYW1LaSs4NVFDektxcWhkUDZ2QjJaSjlqZDVzQzB2?=
 =?utf-8?B?Z0lHaGlsU1B3eHZBNDJXRDA2VWt2Q2lXSkpHM3d4bXc3dDhpTktxUHZReEpi?=
 =?utf-8?B?MTJ6Vk1LZEpuVlR2TzdSY2lweGhISVY5U1g4YWc5TTgxYnEwcG9IZUtTUUFG?=
 =?utf-8?B?STQ1MkpFOVRHV3VyOTBFWFpETUpHWWh1N2RLMEJHUHpqR1V6bk5mTXpubTVp?=
 =?utf-8?B?aGpVQmZqaGIrQnNLb1h5MWxCSUJxTG00c3hFeGQ4ZEVyNHQ2dUVQWmdRYnFy?=
 =?utf-8?B?QVkyeTUyclNySmdpdjZvUC9MUGgwaUdKSlZWU04wL0pYMVFXaHVaQllmNmF4?=
 =?utf-8?B?WGhTZVJ1WjI3V2dLMm1sWVFYRTBwalBRUUpGUzBTNUtkeWN2ZGhSL1V1a3pM?=
 =?utf-8?B?ZGJtVEZPaUM2Ny9wK2VtSjRySWV3eGtXTDBkSUJRQ2JwT2JoV3pKclVMT2hR?=
 =?utf-8?B?elFTWE54ZlQzWjBCeG56NCsxRlczbkROeEJSWVFEZWJFZFZIZ2N2aTJsaklv?=
 =?utf-8?B?TXhMS3RTODdjZGxJaTNCMzJScS9xalpjRUhyWVRFZC9nYTB6SUVoUGpLL3Rh?=
 =?utf-8?B?V2FFOEVLQnBCbFVYalJNSVgvOC94aVRvcjQ5Y3M3bENmZ1I2V0FPNXVjUG04?=
 =?utf-8?B?QUJzZUEyTDNMV1pIVmx4eDdiNkZSR3BicEZJaDVUWkdySHFldm1tR0RicWFG?=
 =?utf-8?B?R081NThMYnY1K1NoTVhCdmxsZHNWQkQyUE5xR3BXZWQ0YVU1SnpKajF3Qy9M?=
 =?utf-8?B?enU1eWhUSHZWL1A5Y2diSlZUYzVoOGdOTGFBOVlMQ1NkNWVXQmxMN1dJRHNQ?=
 =?utf-8?B?TzNwcGVOOXkyTVV4RkZiVkhZblViSXFZL3k1RnVzVEM3VjFrWDJoZFJ4dktt?=
 =?utf-8?B?TTFxWldxb3EwckhaVXF2NUhIQkRlb3VCQjNKRFJ0THUwaGI4TEgxS0Z1VEpr?=
 =?utf-8?B?REYyaXlQbkpnT0tySTNUSGFKYlhadmZHTlM1UEYvWlFqcGlwejJySVBRV1hv?=
 =?utf-8?B?UXNYaU01Y2d4akEyVzg2NVI3QzBoLzJlYUNJL0d2Rm85Mkc2ZHI1M09KN1Iw?=
 =?utf-8?B?bkNtVmlIME5CTWJrM2hFTWkyWlA1SlY3cnFYQU95VWZjeUpicWxNd0d5RldY?=
 =?utf-8?B?cm1qbGFPbEtONFpvRFVERVNBTW5UQzNDMWhtSHgrR01WRTAzSXFxSlJVeCt5?=
 =?utf-8?B?Y0FDYUxBcy9rQ0NnTWNEcDFqcGN5NGJvSG1PblFBbkpJVHYxZnIrbW9hd0Mw?=
 =?utf-8?B?QThPakl2emV3OGZ2cTVDc0huWGZ6MXRrdU9DbWNCM1EzZEduZEY2aVR1cG40?=
 =?utf-8?B?TVM0NFdZbzNQbFl2WWdiRDNxYm9Yc0RtWGROcUFhcTdLTGdRdXZHckFNdUM3?=
 =?utf-8?B?RjdpL3VJVkV5Ynp4N0pqaHZwY2VsMTBWaHpmYVZaaVcrcElzQXhmREJyM0dU?=
 =?utf-8?B?Uy9TbnJQZVZsWjRRNnQ4Rk80YWtJYi83QVppcHZiTkdIVEdjcFU3aXRBdk5s?=
 =?utf-8?B?TndoY2doY3c1R3Y2WWIrb1FUVWVMZkQ2Z3pXL0lmODllRCtERVdPRDU3Q1pJ?=
 =?utf-8?B?aXVmaVZueWZWdmg0bXlUVC9UN2U3Y1ZQWkNTYUJxME9VVGNsUWRhb2RvM0oy?=
 =?utf-8?B?VE84emlCVTA3TEx2UFViNkRUdk9MWDZoclN5N3g2L2hWSDNXVDhjclFjU2Ri?=
 =?utf-8?B?UnJUeHV0dDdZSmF6RkFtUGRvOG1oMG5ObEJhaGlVU0hSMm1OVVJxSGtkb0xo?=
 =?utf-8?B?LzEzSGdmcDNpUkRjNml0bzN3dmhpZmFINUZIYkpEeEY3djFMT1l2dUlzcW85?=
 =?utf-8?B?bk0wRXcwZVJBPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99042708-685c-4151-02fc-08da077d603b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 18:47:09.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9CMV/BG2LHLK9ksjpd0JTOqhLQuwy0QLeAH32/4tkn0XGQjdthjcaiozEV0sqMJ3T7GYpT0VaarP7tuW/4ByEidUXkCP2HfXJiaxrI9nt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5269
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/2022 8:30 PM, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 14:12:25 -0700 Tony Nguyen wrote:
>> Fix double free possibility in iavf_disable_vf, as crit_lock is
>> freed in caller, iavf_reset_task. Add kernel-doc for iavf_disable_vf.
>> Remove mutex_unlock in iavf_disable_vf.
>> Without this patch there is double free scenario, when calling
>> iavf_reset_task.
> s/free/unlock/ or s/free/release/
Will fix.
