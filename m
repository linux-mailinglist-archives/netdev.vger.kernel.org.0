Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC4867F2CA
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 01:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjA1AJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 19:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjA1AJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 19:09:22 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BCD8CC65
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674864532; x=1706400532;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=20Ez9qwURl19jtOGGDR3YPC2MAGfjVWPlHCLQKBtBXQ=;
  b=gBCdMxmXQ4JeqvobfNYeqAXDCq5mptmlo4Xrb1bbHc9qKz+Yxp4tmekb
   WNJ8QzoMyL+t/Nl0i7y/ccAMLOyQBIuZYm2q9y3dsVhm7iElx9RgVSin4
   OvH7LAgfd47ondj+cR98PIFTcyLyysGp+55hB8Xew+a0qlC0uNiLiG9Lg
   g41Ry94ERnB9cwNlGrLp3qx2Rr6eZAhi8g244LpT18RWBUAO94H5XLMWE
   H3oyKvILkYykI+yojbLuSsaZRus4Q1oYNSY0QoQ3gpGee/gCCapsLuPoV
   zygDpmOgVi7nisvIOw62uuMFL8yYPJ7Woxjli+K5iQwESatIiqP6zUzWO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="389607977"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="389607977"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 16:08:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="656792848"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="656792848"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 27 Jan 2023 16:08:38 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 16:08:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 16:08:37 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 27 Jan 2023 16:08:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+/iKIBz5IyfF+IKY3GMooJodZW8PYy9y72f3NXAc6QXRHpuGvudWeGSQDPVbo6FnZe8Y7n7wmUQeCGMFXNXM1kly9nj3PT/YaB+vUd9UXIvZKGl2GW+00rMaNRRKblhSjnAXX0u53XO7WUwYLFB8ZuiMkaINvWoTYHFtQ9f53oOb1NMwuETrK6QVtRs6DmwNSm/1ExzeCTQsGwnrH6SiCF90UTLT98IX2jfe+vTtbCnehfLQAdceIUFDg0rzrcwRgFMk6IXkPlfIiLOd5R6JzUzP3eHJ08zjUb60C4V/Lhz9mcbV4tFn1dfNVpDcUkb+BIei5aVux8jLr15LnTr/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAHEANoCthPGzLJa/zqCPA2mObBm9jAJwbxivk1bhyk=;
 b=NbbC1IT7bEUrcYjnCH6Za0Hdf90EaRApD+NsvvypyeEXt+4belrae0MPcYVRtU+n9L/Axws/5NJw2+5ydJX0SfV7eRd/BEPOFBNP0figMPPo++3J4D5BP5fFMNeV2Zai3bbdYafQtWU/PEsWDPBS3Lo6BaKW+LSEWNv9CRd2nQaYCDWFlLQgfPntdEhSCWKsQOxaBxEhiBL05bOuTgpdwZz3mYfFNfNmXgtFOUHxh4zATz2HpcawdIN0MisH8yxjLjsj0vZeF/Tve+jNDBvOJdIpy81DQBQINkKYRv0CCKcWHW193buKBYngKSjo+eazyMcytXOf0MpQ2LfXxVzXzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB4872.namprd11.prod.outlook.com (2603:10b6:510:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 00:08:36 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 00:08:36 +0000
Message-ID: <cc1ccc5c-a8fd-35f6-7a11-59603f2db7d5@intel.com>
Date:   Fri, 27 Jan 2023 16:08:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next 2/3] devlink: send objects notifications during
 devlink reload
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>, <gal@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>
References: <20230127155042.1846608-1-jiri@resnulli.us>
 <20230127155042.1846608-3-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230127155042.1846608-3-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB4872:EE_
X-MS-Office365-Filtering-Correlation-Id: 5969cae2-9a1c-40d6-c10d-08db00c3ccf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWEhKs3oZqZozPsmyXS+NDJployTimmwn+CvtLFhZyhHbSRjpR+bTWCHhW0BROHLZpg+dFSWZabGkrXRmQUn+cDk/zr0npp/PU78AtNHd+Pgyds04w+7Sxk4WUElQ/uxmqqyvCqgEo4lqO+3n1xowLQyTCNKbl40bk2o/13gZ+mIDB2anQqG5ouUfU48n0pWSUYeBcblfPWGfrzhgVwJosOVwD/DsqhX02ORtFJhEGCGN4dDWAFVYedTyI/cQYr/NQDNioQvkMIQvqPi9lOQuqB4QJGP4JwG1l9qJyBhzQIZUdhO06cI3jjT2TQLN8ncHstHaVKlHivPQk3zXCNNYAoopkycWAdC1bih/JajwxbMSikkIR1c9y6vIvBn0hWb5HVM+MVzZYW+5sV1Lyw8z2rNOGKPMTTe66kVa6tMWm0E2tOaztN2wLUaMoSLurUud+who961ArurcIvdgSVIE6bRQmQCw/oACJ2L424m3CWKBf+J4hpVI7vrHRjrxk38HTuGRh/aGd5FnG5PXQhkkOElcOWz7O6EK6ea1unczSax+cI2Aacz0/xo6psiN/9MaZCvb3AdsRjbAYXx/PNNQ6hBLnbUp1wqrhMovw0seD9BLC4OgykY//b3qauScC7IxPgyWPISHzLQnUF/wiPJlnJIw8HnUxJsImn4VjwigseGSRKkDWW5iUlGF5cd5QGexrpOWnw3QuElwhogaDbSFOh3RYxBUHRP+WSXQDiYnlQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199018)(7416002)(478600001)(6486002)(2906002)(6512007)(15650500001)(26005)(6506007)(53546011)(83380400001)(86362001)(186003)(2616005)(5660300002)(31696002)(82960400001)(31686004)(66556008)(41300700001)(8676002)(66946007)(4326008)(66476007)(316002)(8936002)(36756003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkZNTVFXMDVsK0J3Z2FKZlU3djNWdnI1K0ZPMnZlcWo5eklYbkF0ZWVFR1ZO?=
 =?utf-8?B?MEl6Y2hSOE9aOC9pekVacjFyZDRKTloya01LOWxzajJ4bnAvZmhBWXpVQkxa?=
 =?utf-8?B?eXJOUFFrOXZkNFBqQmtLcitUTTVEYTBiYjF6RGczN2NZdmZUV2MxSUNKeFlz?=
 =?utf-8?B?VUV2dkltUERvcW94cGhIWHQwaDFWOGE2NFdRZUhqV2g2TnpWNWcwMUhPWlZZ?=
 =?utf-8?B?azJJRE5PQ0lCdmFkaGV0amQ2TEQ5Rm8rZmtUVFpMSlpZSmlLR1JROUlLMXdQ?=
 =?utf-8?B?SGtCRWk5Vm9xcnloUUVFRjd3QnZyeHJ4YmE1TmN2dG1sOFdWc3dmdnFkVFYx?=
 =?utf-8?B?Q1RRUVl0UGJuM3lNZ3QyVjJwRTcyTFh5YXhod0ZtUk1QUlUwQU5jOWNmYlpl?=
 =?utf-8?B?SEJaeWYyMFAycWRxV2tXSlIvTXU0azM3aGczd29UVHVRUmk2cjA1RzdGZnRv?=
 =?utf-8?B?YmdZZjU3RUpMS2Y2V2NSVHFJdDFpR3JvNUFqRHNTaHlzb0RydnFtV0Y2cy9K?=
 =?utf-8?B?MG9tNm8yVjNLTzF4VWh2YjhENE5rVGc1VWdXQWp5YSs4WjNTcHJJdURrRUts?=
 =?utf-8?B?RjZ4QmxUUUMwRHZ2cld5WnBwL2RjKzN6OG5mdTdCZW4xbTNaR25DWEpyeWs1?=
 =?utf-8?B?RXg3NEE3dGw2N29hQTVFVTRNcTFNK3U5ZldZYno3OC9keERoRXZtcXVrKy91?=
 =?utf-8?B?T0FHWHBqenVPanB5dmNLNFk2SS9wcFEvSTVyVWp6dU5CaU91Z0hFbTRJeDly?=
 =?utf-8?B?WHAzeXVUVDNrQlBiZ1grNHFhb09Td1JsQWlhTFJCRjJoRWVSTmpkTGk3VnA0?=
 =?utf-8?B?SXQ4SUlSNzk0ME9NQnNmaWRKVXFnQ3c5NmZKVm9uSG15ZzhOcW9BYVlzSXBS?=
 =?utf-8?B?SVBGNVFRa2JUWlhRTEs3cE5PdGFYOEhhMW1aU0xIZEFmcFoyRGhhOEtNbUN0?=
 =?utf-8?B?Wk9TUUEya21WeGJBWTk3MTYrVVNNSkhpTlNqK3hJbmJ3QjFidjgyM3NySHVm?=
 =?utf-8?B?YXp4eWxtck1ha1N5M2dyT2RDekYvcStNWDc4MVNWR3VxU3E3bDNxM3BIajVj?=
 =?utf-8?B?Z2k0elhHZzdseVJJakloN3FJdHVHRU4vSlZXb2JGYWVldzQxS3JPMXorSmlG?=
 =?utf-8?B?UGdtTWFEOHJiVUp0RGhLdS9sUmJaZnFMUG5LTE1TbEhROHgwV0VOUlAwTi9y?=
 =?utf-8?B?eEJ5cjZRQXRXS3M5NE5aUGR3SHYvcWgwQ2NXR3dzNGdOQkkySG02UEl3SUNL?=
 =?utf-8?B?WktOK2Z2dHVoSGp6di9PaWlZMXRQamszU3NMZVVtNDRpajV4TVB4L1RwT0xm?=
 =?utf-8?B?bGJ2OWR5U0JkVXkvdXhOY2sxV0xvMlp6NDNpcVMyWWNSQWhRb2hOQTZDZW5L?=
 =?utf-8?B?NEtYcnZ0elZGV0tNdVN3eDlKakF3QXY5SUhLVlhUVFp2Q2pZR1F4cmdNYlor?=
 =?utf-8?B?ZjlvaGRSd2ErSW9nNWEzRVdzRS8vT0RBcHZ6TnpiN21ITUJMKzBvK0l3ZFAw?=
 =?utf-8?B?cjhwUHRqUEVVeUNnRlE1eDQ5Tkl5ZGp4b09hRE5uYVF6aEZFRFgrNGRIZ1FT?=
 =?utf-8?B?VDlWQzBZck83VjUrazlkMWRmdXF6bk8yQlBIS0p5dnd6ZDluZStJUG40QXRv?=
 =?utf-8?B?Q2lUcCtJY3lSUTdkV0V0NXpKU1RZcGJNNStWYUZBejVSU3dFaEd6S2N2WURC?=
 =?utf-8?B?Y3FGRUhPSC9qem9mWmlabVBIWEJ5ZW5RQVQzeFd4c28xWThqMWVqNHNCS1E1?=
 =?utf-8?B?MzBWY3dzaDZEd05NTkdtcUROaUV3czd2eDF5OEpudjBqNk91eExLbjJIQ3pt?=
 =?utf-8?B?RjZWWlcvWEVSY004RlhlN0IxSTArSkFqZDlDSzgxUjM5eGN6ejY1UTREREVu?=
 =?utf-8?B?SjE5VTZ0VVk3dlAxR2RjcHlmVzZ6aXlKZFVIdlU5c3ZMQzJSZjA3aHkrMnZt?=
 =?utf-8?B?RUF1NllHb3g1SW5TRXdNb0QvK09GeEtRcGtMZUVTckt5ZXZHdks3Vkl0OVov?=
 =?utf-8?B?b3graXFjUU1wb2Y5NnI2Q3VPL0NzZHQ4ZjdnMjVtMFRxUmRLMXZEZDJLSUF6?=
 =?utf-8?B?OUszd1VhaHY1T2plTEQvT3h6eGdyZFdoZ1ZxR3hsNlZNZnNqQldVeDFwMHBM?=
 =?utf-8?B?WHIyZk9CaTlkNlFaT1JlM2J5MTkzL0NMTXA4bElwSkdOVHFkakZKUFZTM0RT?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5969cae2-9a1c-40d6-c10d-08db00c3ccf1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 00:08:36.1481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fe41hmD2y9KbGOiGuJP2HjhqvCceLSwrt2PAbQQGgd5BneOU8YnPOwdTlkh1nznQ5TR6S4SrKLrnaeHgf/VZJj9IZJgZ9OCZjWebx6aANAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 7:50 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently, the notifications are only sent for params. People who
> introduced other objects forgot to add the reload notifications here.
> 
> To make sure all notifications happen according to existing comment,
> benefit from existence of devlink_notify_register/unregister() helpers
> and use them in reload code.
> 

Nice cleanup. Should be harder to forget notifications in the future!


Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  net/devlink/leftover.c | 20 ++------------------
>  1 file changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 24e20861a28b..4f78ef5a46af 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -4230,36 +4230,20 @@ static struct net *devlink_netns_get(struct sk_buff *skb,
>  	return net;
>  }
>  
> -static void devlink_param_notify(struct devlink *devlink,
> -				 unsigned int port_index,
> -				 struct devlink_param_item *param_item,
> -				 enum devlink_command cmd);
> -
>  static void devlink_reload_netns_change(struct devlink *devlink,
>  					struct net *curr_net,
>  					struct net *dest_net)
>  {
> -	struct devlink_param_item *param_item;
> -
>  	/* Userspace needs to be notified about devlink objects
>  	 * removed from original and entering new network namespace.
>  	 * The rest of the devlink objects are re-created during
>  	 * reload process so the notifications are generated separatelly.
>  	 */
> -
> -	list_for_each_entry(param_item, &devlink->param_list, list)
> -		devlink_param_notify(devlink, 0, param_item,
> -				     DEVLINK_CMD_PARAM_DEL);
> -	devlink_notify(devlink, DEVLINK_CMD_DEL);
> -
> +	devlink_notify_unregister(devlink);
>  	move_netdevice_notifier_net(curr_net, dest_net,
>  				    &devlink->netdevice_nb);
>  	write_pnet(&devlink->_net, dest_net);
> -
> -	devlink_notify(devlink, DEVLINK_CMD_NEW);
> -	list_for_each_entry(param_item, &devlink->param_list, list)
> -		devlink_param_notify(devlink, 0, param_item,
> -				     DEVLINK_CMD_PARAM_NEW);
> +	devlink_notify_register(devlink);
>  }
>  
>  static void devlink_reload_failed_set(struct devlink *devlink,
