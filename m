Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1775E6EB147
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjDUR6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDUR6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:58:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB62E7C;
        Fri, 21 Apr 2023 10:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682099927; x=1713635927;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AjKk9NGKXfyQqiQh+4jGp3nRrLduwFyRSDtYd+hN5QU=;
  b=X/jtg1gsqZIHg8DqJyvMkMNbPr2HbEYtBz6k9Q5Yff806RraLqoiquoa
   WM0WqhqQ+tLtNN64MLm9OLchePuqyaQ89y5oLYW+vX853ZkwHkRlxyJdc
   ujJoohCgiWnfv9syIlGgM7v+lAxxMIE5kErRs/p+XoN03t9qRt8yNDRHw
   BY+wS4TSxeUxhUUw1Jz0Xeuu9LyQCLgZKAxSgzxK+t3mxRJGQ3JOTW9Pt
   ix8Et3lz83uxsJJmsac5gDZcvN8ombtvMGrGxY+wYy8WS27hmyLbIzobl
   flxqTyWRischXkaSthuKM0gZcbZK9rUB0vrUNQUUnFYIVy4//8GvarMvz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="343532891"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343532891"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 10:58:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="724918624"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="724918624"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2023 10:58:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 10:58:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 10:58:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 10:58:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mso2WUI6mlCG08vl1GHzn37MWWFCw/Jdta0avlmja4IxnYExT7Rx0aHAtSj1B/TC90sFdtoy6vYbAbcSHB82DzIQIpCD6R6hc+S5WF004hQYWcrizSkzdHlYU3JHbgyVz71m0dLin3hSh+5ve4wokuM5uMtG2z8nQrwyB+fMx5/ujSEzD2qfzk+PMwtvjY/wUc66dcAu9O0J9N5mx4yaTl4Qnhxt93qmDBgNE71iDNr/5w2DJMfyv+9Y/nNm+yUCNWnyr/AGZs3RutnvEoVnmwmE0/QbdVod5DSP6A4uRDlhfvzjtt2rezJoj9WcjAT//nJzF4bcgzImbG99jlkvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WG/OigtxRR9aodivGy4F6x5d15c2GcXce2aAtDUAujQ=;
 b=iGo5CSW+pKAokHaJwqAS/2/QeFILZpkKwtmzo56euSkc7EoyRFHzVlxDmsna41+fsqeHGrrauFa1Bvj1dN7qD5rUx/6giYvlmV1pxQuQ3BCRsRjpnkniEUYHgeYTo5YJn3OcqVphiQbOvPihOX+MnM8YikooDV/En96kDTJuc8li1GkRWNIQVC5x7R1UdJ//DCRipN2Y6nTDsOuFoGIAK0gb9iJHJQ0sQES39MOiXzCtPan5AU2vb/s+yRJXyH1Ks55ATePAiZxcd/M3WWaMzqGqWge8v4NoKRr+1Ou7VTQdhd6MZpgv1OcN03omr1r79StnqWZi/Vzyh8ht+JhW5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5042.namprd11.prod.outlook.com (2603:10b6:303:99::14)
 by IA1PR11MB6124.namprd11.prod.outlook.com (2603:10b6:208:3ec::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 17:58:42 +0000
Received: from CO1PR11MB5042.namprd11.prod.outlook.com
 ([fe80::503:fbbc:de8b:476d]) by CO1PR11MB5042.namprd11.prod.outlook.com
 ([fe80::503:fbbc:de8b:476d%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 17:58:42 +0000
Message-ID: <7b1a31f2-3ab3-1c50-ae47-f004fe321fca@intel.com>
Date:   Fri, 21 Apr 2023 10:58:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH net v2 1/2] iavf: Fix use-after-free in
 free_netdev
Content-Language: en-US
To:     Ding Hui <dinghui@sangfor.com.cn>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>
CC:     <keescook@chromium.org>, <grzegorzx.szczurek@intel.com>,
        <mitch.a.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <huangcun@sangfor.com.cn>, <gregory.v.rose@intel.com>,
        <michal.kubiak@intel.com>, <jeffrey.t.kirsher@intel.com>,
        <simon.horman@corigine.com>, <pengdonglin@sangfor.com.cn>,
        <netdev@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <20230419150709.24810-1-dinghui@sangfor.com.cn>
 <20230419150709.24810-2-dinghui@sangfor.com.cn>
From:   "Chittim, Madhu" <madhu.chittim@intel.com>
In-Reply-To: <20230419150709.24810-2-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To CO1PR11MB5042.namprd11.prod.outlook.com
 (2603:10b6:303:99::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5042:EE_|IA1PR11MB6124:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ef8b303-ce20-46f9-89d5-08db42920ade
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IF0JOe9/UiXE2+KkqDytpY2VGBdHKTs9PpjxwCBdusr9qDaVVUn4RA1bCh1hQJQeydymYin+B4qALO0T6u7ioORHaak/9/GRqlVTQMXhBd1+7mNkhLqbTDvj30U6ZvjgfDdy0B3AUQHDWfQ3V68KGclK6BO5LqnMu5z8ZVq8kbGm/t3TjKmun0NcnnKBe1fRFCPRiBX5u1JQpvlN0FKxf12jmIja3tctqmo27HPoBDjOfYAJjSX7rHDuBWeNPeXPcWqrWYYL5G6ngxFHG7SNcvGxfqUa5eTEjkKDQmkeTtQ7NrLLm5FhJbjAgNTU2w0rjrIllqMz6dl4gNVKCcgW6F3uNcazGOHWz3zBdbEAlzu1cjLeBAhex/L+o99GUsd4ofASYw0rOXFZg7ftmlpZu5cZVNVyAyGYYQ0BI/ohjen6exu3Wx15AzoTlSVBjyW9Q6iz/Sh8XOAkmTjBO5+zpZ/OxtVGAJCHphWgh6HniL9U3znxx62GLrZcseA8PXLzCQAOyx2ZIL83gDXdzEnq4K4ZzQumOvvZbvw1VBaySv3dABi5ATXDd6O5HvJf1iYb1uQ5YqUUXKaQs7brjgtsg9EPF4Bq60l5C0571XrJR0+F/c124msjNXLEoILt1JwiHTXnM5V7m7lJFrSGM+xbSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199021)(84970400001)(31686004)(4326008)(316002)(6636002)(66946007)(66476007)(66556008)(36756003)(53546011)(6512007)(6506007)(26005)(82960400001)(38100700002)(2616005)(186003)(83380400001)(5660300002)(8676002)(41300700001)(6486002)(478600001)(2906002)(6666004)(8936002)(31696002)(7416002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z29USWIwVHhxQ1Jta2xxYTlpc24wNUFYUS9rb3l5S1phZ1hZTmJQTlJLQzYx?=
 =?utf-8?B?Y1gvZUxybUFza3J2amIyQmRUTGVtT2o2ZlhHNXhMUmw5ay92V0VnYmxDWDU3?=
 =?utf-8?B?aUVEazgyL2JRRVdIUGlUN0tGQ1c4RkQrWG1JV2k2UCtXa1NKTGg2RkVCZHBE?=
 =?utf-8?B?TFh5aGRHcFdyNE15bjdRVnRaN3FFc2VFSWdreE40bDRoUDQ2MWxNYkYraG1W?=
 =?utf-8?B?aTkyYTVOYTJISmJiMFdWUVVaWlRNdmpCUHJYWVFIZTFoSmZTTVQ1Y0ZGOHRQ?=
 =?utf-8?B?QVhCMURvT0ZWYVpkYy9TT3BVWVZTeE01Umt0ZmRrVHRLYXZjWjNCMy9McHpk?=
 =?utf-8?B?Ukk1b1E3RXpHRWxQZk9KU3pGYXlpaTMyU1l1VEUybS93YmJ0UjQ3VVlhd1cx?=
 =?utf-8?B?WU5iUGxBL3hnNHQ3eEhHYXdlTC9FYlV5aG5lcFFBazRucU1TOGFHWW9jREoz?=
 =?utf-8?B?eE5KcldseEdwc3plWE5FSmxGUTBpRUprdFBnSTFmVnBvRVdjZUt6YkFPSitR?=
 =?utf-8?B?UXE4U21ydjFUQlV4UTlqcno4R0YzaW9ack5jaEc0VGZFWFlha0pHUUVaamo4?=
 =?utf-8?B?Q291MlZpcm1mUzFMOU1qN1QxdWxTeFBLdkdsTzNkMWlra200OU9XblNybTNE?=
 =?utf-8?B?T0dvUXpjQ0FBZHluMGREeDYxME5LaWZCOWlCbWFSeEMrMytqV2tzZ2QxOXlm?=
 =?utf-8?B?c09NNmVzMEJ4Z1k2dTYvZUpBVitRVHNwWTVWQk5iOE5vT0dVR201NzVYNUpU?=
 =?utf-8?B?VFFJVXVUWm40UEdyV0J4VndGa05TK3E3eFQ4ODNidFBjMFhqaWE0ODNsWkFH?=
 =?utf-8?B?MkJSc1crL3BwNklTMFNyem0zbG85U2FnVE0waSszR2VEQ05XbzdvNEx5dGZE?=
 =?utf-8?B?eUZVblBwR2ttaGFBd0FxOXdVbTdSK0puNlY4Y2tTRkQ5eGI4REpaVlFvNDRj?=
 =?utf-8?B?b1k3WWRCcTF6Qks1bmxhdzJwckt6SndwcTJLa1pQbkcvcW9HaTd2RHBiZEtJ?=
 =?utf-8?B?TnpvOXNCMXdncUFDMFpvaGRlOTdueFgrbFlFd2dQcGZ4elhWV2FscThrRjdq?=
 =?utf-8?B?a1JnakN2NFp0Y00zTWNNTXhlU09ZQzZHdUFDT0cwNkJjSFZpdmFZM3dXM0Rn?=
 =?utf-8?B?dldkT0sxWmswMkM3VHI5TWZEOXc0NloyNFpQRHY4aWp1b3lzbXVzK2wxY1lH?=
 =?utf-8?B?Y3Eya096RmhvQjVRejhwbGJrT2V1TEtTVThzRW1hUHFMeUgyT3BnL1RSbTVu?=
 =?utf-8?B?amMvTnVDbjlldEp0MTcyTXdVcHd2S0dYSzF5TE5IcWh3eVlzWXRGaGlGR0dt?=
 =?utf-8?B?bVpERXY1RWhsbDFwYVpPcHFlSFE2VExhVXVyOXVlTUo1b21XVmhsUTgwY1l2?=
 =?utf-8?B?RDM0ZFpJZTduMUdabjd1MmlTRFpXams1SHJ1dk9pSjhqTkYvaTc4ZW5ySDlt?=
 =?utf-8?B?ZmVuQkJIdDlnNWRudXgrSUpEdjdNWUVpY2d4WU5PanVTcG1MTzNUNjJMRlNX?=
 =?utf-8?B?QWU2RVlmTGw5dzVJY0lqSWxaUGhvM0t4RGo3azA4S1Z4aUF1dkQ0c2UwMHlD?=
 =?utf-8?B?WlpsMzdUdkdQYU5YV1JML1h0dHlnMHpDYTBKR2FEK0NSMUVEM2p2SGpXRnRo?=
 =?utf-8?B?eml5bjNKdTBwMUM2clI2eEpFK1ZUbUhJS2V1VXpNbXp1TzJza2ppZFZhUkJ2?=
 =?utf-8?B?TDJ0STduWStKa0oxbjZ2REt1QnIrZmFuUjhic3huc3BsTU5ZOGRUUkI2b2Fw?=
 =?utf-8?B?c0FFRmZPU3FLQkd6SEphL1gwL21Ycmx1V3pzUksrMVhZSS81QWxLeFJKTHBK?=
 =?utf-8?B?YXp4NU45bitFZWEzSTRWOEFRVUdPT3hpTVdnd2FYWHJWUzR2K0RmYjU1enlw?=
 =?utf-8?B?QTkwSElCY3pxYktqMzZjVitYYUp6dkFLTFVWTjBmVGNvL29na3RtWGZtZi9P?=
 =?utf-8?B?TUVWSG8vVTNsY2d1OVNOY0M5a1lDdzZhVktXWUJhYzhGNDlMMXJFM2JxM01U?=
 =?utf-8?B?YXMyWmd3c3ZsNzZZUG4wTGw4SG1XWkNidC9iVy9hR29yTjdabnlTS1Q1cmdo?=
 =?utf-8?B?anQrSWRnUXFRemhMZ2hNVHErejQ0NThYTW13QlZkT0dlR0prSEhzWE1tU1pm?=
 =?utf-8?Q?nr7I0ib716tF9QJFDGVEZpfQX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ef8b303-ce20-46f9-89d5-08db42920ade
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:58:42.1524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLRafnIIwen+xB+a/WZMAEHNL2FQvcYWB2LITxmMQDcd9CwfcAZO2vZpiZO32tRZ5Bo2sg8Wh7EsKHK6wOw3zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6124
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/19/2023 8:07 AM, Ding Hui wrote:
> We do netif_napi_add() for all allocated q_vectors[], but potentially
> do netif_napi_del() for part of them, then kfree q_vectors and leave
> invalid pointers at dev->napi_list.
> 
> Reproducer:
> 
>    [root@host ~]# cat repro.sh
>    #!/bin/bash
> 
>    pf_dbsf="0000:41:00.0"
>    vf0_dbsf="0000:41:02.0"
>    g_pids=()
> 
>    function do_set_numvf()
>    {
>        echo 2 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>        sleep $((RANDOM%3+1))
>        echo 0 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>        sleep $((RANDOM%3+1))
>    }
> 
>    function do_set_channel()
>    {
>        local nic=$(ls -1 --indicator-style=none /sys/bus/pci/devices/${vf0_dbsf}/net/)
>        [ -z "$nic" ] && { sleep $((RANDOM%3)) ; return 1; }
>        ifconfig $nic 192.168.18.5 netmask 255.255.255.0
>        ifconfig $nic up
>        ethtool -L $nic combined 1
>        ethtool -L $nic combined 4
>        sleep $((RANDOM%3))
>    }
> 
>    function on_exit()
>    {
>        local pid
>        for pid in "${g_pids[@]}"; do
>            kill -0 "$pid" &>/dev/null && kill "$pid" &>/dev/null
>        done
>        g_pids=()
>    }
> 
>    trap "on_exit; exit" EXIT
> 
>    while :; do do_set_numvf ; done &
>    g_pids+=($!)
>    while :; do do_set_channel ; done &
>    g_pids+=($!)
> 
>    wait
> 
> Result:
> 
> [ 4093.900222] ==================================================================
> [ 4093.900230] BUG: KASAN: use-after-free in free_netdev+0x308/0x390
> [ 4093.900232] Read of size 8 at addr ffff88b4dc145640 by task repro.sh/6699
> [ 4093.900233]
> [ 4093.900236] CPU: 10 PID: 6699 Comm: repro.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> [ 4093.900238] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> [ 4093.900239] Call Trace:
> [ 4093.900244]  dump_stack+0x71/0xab
> [ 4093.900249]  print_address_description+0x6b/0x290
> [ 4093.900251]  ? free_netdev+0x308/0x390
> [ 4093.900252]  kasan_report+0x14a/0x2b0
> [ 4093.900254]  free_netdev+0x308/0x390
> [ 4093.900261]  iavf_remove+0x825/0xd20 [iavf]
> [ 4093.900265]  pci_device_remove+0xa8/0x1f0
> [ 4093.900268]  device_release_driver_internal+0x1c6/0x460
> [ 4093.900271]  pci_stop_bus_device+0x101/0x150
> [ 4093.900273]  pci_stop_and_remove_bus_device+0xe/0x20
> [ 4093.900275]  pci_iov_remove_virtfn+0x187/0x420
> [ 4093.900277]  ? pci_iov_add_virtfn+0xe10/0xe10
> [ 4093.900278]  ? pci_get_subsys+0x90/0x90
> [ 4093.900280]  sriov_disable+0xed/0x3e0
> [ 4093.900282]  ? bus_find_device+0x12d/0x1a0
> [ 4093.900290]  i40e_free_vfs+0x754/0x1210 [i40e]
> [ 4093.900298]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> [ 4093.900299]  ? pci_get_device+0x7c/0x90
> [ 4093.900300]  ? pci_get_subsys+0x90/0x90
> [ 4093.900306]  ? pci_vfs_assigned.part.7+0x144/0x210
> [ 4093.900309]  ? __mutex_lock_slowpath+0x10/0x10
> [ 4093.900315]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> [ 4093.900318]  sriov_numvfs_store+0x214/0x290
> [ 4093.900320]  ? sriov_totalvfs_show+0x30/0x30
> [ 4093.900321]  ? __mutex_lock_slowpath+0x10/0x10
> [ 4093.900323]  ? __check_object_size+0x15a/0x350
> [ 4093.900326]  kernfs_fop_write+0x280/0x3f0
> [ 4093.900329]  vfs_write+0x145/0x440
> [ 4093.900330]  ksys_write+0xab/0x160
> [ 4093.900332]  ? __ia32_sys_read+0xb0/0xb0
> [ 4093.900334]  ? fput_many+0x1a/0x120
> [ 4093.900335]  ? filp_close+0xf0/0x130
> [ 4093.900338]  do_syscall_64+0xa0/0x370
> [ 4093.900339]  ? page_fault+0x8/0x30
> [ 4093.900341]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 4093.900357] RIP: 0033:0x7f16ad4d22c0
> [ 4093.900359] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
> [ 4093.900360] RSP: 002b:00007ffd6491b7f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [ 4093.900362] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f16ad4d22c0
> [ 4093.900363] RDX: 0000000000000002 RSI: 0000000001a41408 RDI: 0000000000000001
> [ 4093.900364] RBP: 0000000001a41408 R08: 00007f16ad7a1780 R09: 00007f16ae1f2700
> [ 4093.900364] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> [ 4093.900365] R13: 0000000000000001 R14: 00007f16ad7a0620 R15: 0000000000000001
> [ 4093.900367]
> [ 4093.900368] Allocated by task 820:
> [ 4093.900371]  kasan_kmalloc+0xa6/0xd0
> [ 4093.900373]  __kmalloc+0xfb/0x200
> [ 4093.900376]  iavf_init_interrupt_scheme+0x63b/0x1320 [iavf]
> [ 4093.900380]  iavf_watchdog_task+0x3d51/0x52c0 [iavf]
> [ 4093.900382]  process_one_work+0x56a/0x11f0
> [ 4093.900383]  worker_thread+0x8f/0xf40
> [ 4093.900384]  kthread+0x2a0/0x390
> [ 4093.900385]  ret_from_fork+0x1f/0x40
> [ 4093.900387]  0xffffffffffffffff
> [ 4093.900387]
> [ 4093.900388] Freed by task 6699:
> [ 4093.900390]  __kasan_slab_free+0x137/0x190
> [ 4093.900391]  kfree+0x8b/0x1b0
> [ 4093.900394]  iavf_free_q_vectors+0x11d/0x1a0 [iavf]
> [ 4093.900397]  iavf_remove+0x35a/0xd20 [iavf]
> [ 4093.900399]  pci_device_remove+0xa8/0x1f0
> [ 4093.900400]  device_release_driver_internal+0x1c6/0x460
> [ 4093.900401]  pci_stop_bus_device+0x101/0x150
> [ 4093.900402]  pci_stop_and_remove_bus_device+0xe/0x20
> [ 4093.900403]  pci_iov_remove_virtfn+0x187/0x420
> [ 4093.900404]  sriov_disable+0xed/0x3e0
> [ 4093.900409]  i40e_free_vfs+0x754/0x1210 [i40e]
> [ 4093.900415]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> [ 4093.900416]  sriov_numvfs_store+0x214/0x290
> [ 4093.900417]  kernfs_fop_write+0x280/0x3f0
> [ 4093.900418]  vfs_write+0x145/0x440
> [ 4093.900419]  ksys_write+0xab/0x160
> [ 4093.900420]  do_syscall_64+0xa0/0x370
> [ 4093.900421]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 4093.900422]  0xffffffffffffffff
> [ 4093.900422]
> [ 4093.900424] The buggy address belongs to the object at ffff88b4dc144200
>                  which belongs to the cache kmalloc-8k of size 8192
> [ 4093.900425] The buggy address is located 5184 bytes inside of
>                  8192-byte region [ffff88b4dc144200, ffff88b4dc146200)
> [ 4093.900425] The buggy address belongs to the page:
> [ 4093.900427] page:ffffea00d3705000 refcount:1 mapcount:0 mapping:ffff88bf04415c80 index:0x0 compound_mapcount: 0
> [ 4093.900430] flags: 0x10000000008100(slab|head)
> [ 4093.900433] raw: 0010000000008100 dead000000000100 dead000000000200 ffff88bf04415c80
> [ 4093.900434] raw: 0000000000000000 0000000000030003 00000001ffffffff 0000000000000000
> [ 4093.900434] page dumped because: kasan: bad access detected
> [ 4093.900435]
> [ 4093.900435] Memory state around the buggy address:
> [ 4093.900436]  ffff88b4dc145500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 4093.900437]  ffff88b4dc145580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 4093.900438] >ffff88b4dc145600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 4093.900438]                                            ^
> [ 4093.900439]  ffff88b4dc145680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 4093.900440]  ffff88b4dc145700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 4093.900440] ==================================================================
> 
> Although the patch #2 (of 2) can avoid the issuse triggered by this
> repro.sh, there still are other potential risks that if num_active_queues
> is changed to less than allocated q_vectors[] by unexpected, the
> mismatched netif_napi_add/del() can also casue UAF.
> 
> Since we actually call netif_napi_add() for all allocated q_vectors
> unconditionally in iavf_alloc_q_vectors(), so we should fix it by
> letting netif_napi_del() match to netif_napi_add().
> 
> Fixes: 5eae00c57f5e ("i40evf: main driver core")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> Cc: Huang Cun <huangcun@sangfor.com.cn>
> Acked-by: Michal Kubiak <michal.kubiak@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
