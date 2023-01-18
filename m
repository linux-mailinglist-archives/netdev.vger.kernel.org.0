Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37542670FB8
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjARBOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjARBNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:13:37 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8608318E;
        Tue, 17 Jan 2023 17:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674004063; x=1705540063;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sTjPNh2GJJxi2aYbJS+SlpPeL7uxog4wXidX1X090qY=;
  b=cGvXbNyDKXSdKn0DjzIuWiSts8zo9WxH9lg/T1Gc+ltOTj5iRR0vGzeh
   hhUJ+Wy9hJ7ptJY1zV9RwZR0H7F8D1LGHnW0NQkO71sHbu1DRPnO9Pv4C
   33NeDfqFvSSqozZHBOIqT+Yv72GoHcJXd8xhZxuRgZtXPWX+vICsgKzmv
   jaWQ62eGD6PR2NRm+Dsn4R/Mm0GE8fX+Ge3XAWR85NtyxbPkVfAa7oiqb
   SnnAbU1V33ms+/plCf5mqRM8sd+uRdnSOS4mBHozHrnmilAkNvYKo788g
   IaAR+YFXYFNgOrGVeGLzNQZZvBE494mR2Tx6NXEx/l3bwMhOfO+FdV6r1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326139654"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326139654"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 17:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="801975996"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="801975996"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jan 2023 17:07:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 17:07:40 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5kB6DDkt4kV1kVjXuTXEjmwTITnDqo5a0oug8mysc7qRkDbGUI5yvcGOXNdvARAJaQ/xUNU9mgBj3SyziK5biBdQMZRLOdX2mKfauj34k7wf2eL7OQX1sXFfQVfCWCMygufX4ABb/Yfgav5ZmUXIBANOTfEEyc9Rlc4iSZI6BxP2kJmAX2nuVl4JT/KooalxzbLgyCFc24PL6o0L73PNdM/z2B1SepFkMQ3n5gL0tohp6sJIEme56kh0lxnK7V2E3SP1arqRUe2/hyYZGnlQwMB7s8eAtVHwMezqQtGiFoVTI3Fw0uE8sRkPzm36HXhEza0v7T3rig7Shzfl7oE6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIN9sy/E7X7rrmKOQ91ma0I6BaPDpf+prJxa/eZ1zfk=;
 b=NaqaJqYaA6Btg+2s33Es9fVuuB3yX2lG3tynSY9h0cRn3DK/BOPgJvn8/f9oOFCaTHisXePUN4IUdCyQr5A37gdW1PMsjBOtbnaP4yW87aQNvMRAHycFg3HbqkSGQF/m3pTPSYthTjtGnoUsvO+bXoH3PS3+05kK9xM6aQURyp7Oxw2Zj1XFCFdlpEPTzm6xKRKlJyHKP+TmXSoUGgm4ewtt+MloSn+3igthLPepQ/1WDsK4lW8kFmLWm1ki9vfv6YRGzzmYSy1OHwfdqW9qv9+QBaUD3yQKWKZKynSiFCblJGLS0q29S+jGr8LxAgJYJxJMbtU0ox3+gIg4IYRH4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 01:07:39 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%6]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 01:07:39 +0000
Message-ID: <feb36396-74ec-06c1-9d91-9c980d0775e7@intel.com>
Date:   Tue, 17 Jan 2023 17:07:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 3/6] net: mdio: Add workaround for Micrel PHYs
 which are not C45 compatible
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Joel Stanley" <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-aspeed@lists.ozlabs.org>, Andrew Lunn <andrew@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
 <20230116-net-next-remove-probe-capabilities-v1-3-5aa29738a023@walle.cc>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-3-5aa29738a023@walle.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::30) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BY1PR11MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0c9d71-ea57-488d-f2c9-08daf8f064b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLeGsR1abocxHxLxMwFldXEQhSD/gKOr7ZJXLvhlGxs/VVMEV/IFRXxmwGjkZF+0urkn9GBId81zdBSTThrJv4zj3DPzF2+EzVdylcfDscBJlV+YF91v0gbwWokEJzkk3bmCkcY1XuTabJndoB+e7VzaYjXJ9KEAC79huB1jxuTLXvpTdFTPZeVi33uxLoTkXhfIeejSgQEMYSJOueDb8BqMsGtYhLm8hpe2J50/Fu+5FRyd8DZC3BXCoytkjTXW/MzuLJesP442yaTUNetHwpQH2OjHsI797uCkCKaHD0jT5qNq0tZXKL/I/gwZfV4AmAJC1Mmd1X+DN4YsHCx3rtTQKVsrmwt61Y/GxPrC0TfJfyG4YAJjGQvn+mdAmoR193dXvefuu465Ayo5OZvlBUoo5NxZozFU09EAb7AkX/Q1qYc8EtTcI1KrSIIG0WqvG7vR8zuvsml58DNKWPrvnQKgT6AleSgIIAHyW2P5XehNdpv4PRJONdTYHdM7x1vG0tiwRYnGOrDP/ke9h5Bx9FjE4gGn9JbSipOycIJVmdVZ4yX+06dCTMW/ihPDBJE5kT+xHrTZHCAGDUWhXsm+8dA77fZdee9CxtrVGgLsZ1/g938zLfDFdT4O1YQN2J6t5Jt8S483XM7ppsVoVvY5izYklv3wS4eeBhl4JAKLnp3hjSAY5FM1k/uTd8wQZ/566FVrqo2RmIiWUF7pTSWt5mNj66vgQmcgUBzGEZmeLVF9AwIq1G/m7r5b4VPvOg1m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(83380400001)(38100700002)(66476007)(921005)(4326008)(82960400001)(7416002)(66556008)(86362001)(31696002)(2906002)(44832011)(8676002)(8936002)(5660300002)(66946007)(6506007)(53546011)(186003)(6512007)(2616005)(26005)(6666004)(6486002)(478600001)(316002)(41300700001)(110136005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVZKRmNMOS9VZUJWSHJzT09ua09QdXBHYk9KdDRkam1JOGFJWXBhQW9IZnZB?=
 =?utf-8?B?U3hXZkxVdkhwWW4wcnE0SG05Q1hXd01PSVN4ZHdES1F3L3lxMWlaYUxtWG9H?=
 =?utf-8?B?OXBKeE1haDFDeGFwUGJtU3NNY1pMNnROeHgwVEFIUnB2cER5Ymh4TFlrUm14?=
 =?utf-8?B?QXBlWTZCYmV4bWhoS2hDM3c2dzBmSjUxMGVKcE1udW5BM2hMTE55SWJ5VU1V?=
 =?utf-8?B?dnNiMitvN2FIekRXT3FmbndObmVydWRqMGhXWWdoN1Ayb3V0bmptQ1JEbUl4?=
 =?utf-8?B?dzg0bDZCUERqTW1mSXZkczNEeDd3WkVMS0JNaEs4VmF0N056WnBBdHZVMTVj?=
 =?utf-8?B?Y3RpUGRNQVlyalBmaldabFd2aVY2enNYekdjY0h6UDYrWC92WnlwOVlKRWQ4?=
 =?utf-8?B?T21jZjZ4cU9idmdWYS91emQwaVIrUDVVNmc2V29QTm5MYzBlNTRsYU9MQXBp?=
 =?utf-8?B?Tkpka1A3T0hkQU1LNmt1TE53U2IvdXQ1eURCS0RQdE9uYUdKZVJYN0hzODlH?=
 =?utf-8?B?TStkcjdFVXNwa2o5YmhEaDBLUHpEN2RuZUhuOUM3WnJwVTFBQ2xmOWNoYU5w?=
 =?utf-8?B?b1cybFBwNCsrclZTaFdSY01oWVp3Q3dzbitTUVpSSUhQb295Sjhia1FQTjM3?=
 =?utf-8?B?M2FjSzZyRWxBUWlwY3QyUFY3U08xTWxCZnNRZkRlSW9NeXVpYmVSSFcyRXZk?=
 =?utf-8?B?Q1V5VG0yakZXbnkxODBaUUFoZklNUHppaW82dmR0d0Fpa0NjVllnY0lrZzZs?=
 =?utf-8?B?UmVYa1MrNU1pemJxOW8zcDBIMGVvT3ZQV0Qxb1ZRL3hNOTNRS2pEQVBZT3l5?=
 =?utf-8?B?ZDZpd3NtaG1oWkF2dHl5by9adFJiK2J3bit6OTlQMUhFK0lNc04wVTY2UFRE?=
 =?utf-8?B?Y3RodXlXSWUwTllubG10c1MvOFlVajZFMkZYNjVpYjZ2TVhnL1NUS2JNcnF0?=
 =?utf-8?B?UFROaVdCelBpQVZxbkNaaE1pQS9HN2xUcTNXY2pXbG5SMnZXbUpLRHRLbVZa?=
 =?utf-8?B?MWYxRVo5dkYzWDcybUZ3UExTM3Y2aWI1cG9zbjNYaVFpZ21NZTZIdTVTL3k0?=
 =?utf-8?B?RmlQM2NuR2xVU0syREFFS1R3VE1tL1FwWUQxbzhSZWdsdlJTQWdNVExzMGdC?=
 =?utf-8?B?RHl2OStub2p0U3M1OG10ZHBlUE0zcUNVbXl4NVpRL2htdW5kVUpxR2V1aFJx?=
 =?utf-8?B?TWVIdmJrVEZuc2xrRElMamhSVWk1bmswTTNqUHRrZ0I1eEwwNy8xcS9IOEtX?=
 =?utf-8?B?OWovOHBjQTErL0xGV284SzRnb2lDZFBxMHhOWTBEelQ1WW1GYUJmbXE4bzFI?=
 =?utf-8?B?WGdlQjZIR1NZQjg2L1Z2Qm1GeU55c3JxalpQNFB1N1RiOGVQK1g1cE5lRHpH?=
 =?utf-8?B?WFNFV05yUEVoZncxcEE4SkVBTUJXTC9HTzFCYTVHUWdiK0kwKy9lTWNQcVE5?=
 =?utf-8?B?NWxHQzJzcmdxY3hhOW4yNjVUTjJkR1RqaGFMMzlFeVRqSFJZYmJnSWx1ckdH?=
 =?utf-8?B?eDVYbXIxZ1pJQjdyZnVQZDdDWUJ4bFBmUDBkWVVYS0k0V3l2U3luMkJnWWNw?=
 =?utf-8?B?SXp0VEFKSy9kMUh4ZWVZQWczb3QyN0Y0RUtIc2RuV0hYcDY2eE43Q1pIY3Jj?=
 =?utf-8?B?aXNDdTNSeWVsN0RMNG8xVCtCdjZNY2I5cXhpT2UyTW9LTHkvMlFWUHJ2UVdJ?=
 =?utf-8?B?SXdNYXRxQUhHczhPNXdSbmJDVFVjd1BVY1BtMGNYcDNmQUxYWS9uNEJEVUR3?=
 =?utf-8?B?eXJxT2loNGE4Wk0yLytKWkdxSXh5bU5MNXNQNnBYeU81RG51d0hZUGF1aTc3?=
 =?utf-8?B?amthVFdKWXVFNWhLaW1TOWg4WFFMSmliSk5mSy9WMTgzN21wQVhLUmsybTZ3?=
 =?utf-8?B?TFB0bUJWWmY5MldyMnpQM1c1bzBIb1NDUTVkaUV4bzllMklnbTQrb0dUVjJM?=
 =?utf-8?B?WHlQcEZBNXBhZ0VOR3B3VnF1WGJhdzdSZWFqdktlMHhWbUFFck0wNjgxRGpP?=
 =?utf-8?B?dDNKYzRrWm1Yb005THFDVnpNUVdLSGt2S3N2Y0FFU2daNks0WGlSNnlCVjc4?=
 =?utf-8?B?L3RTVnpzQ09OVnJ6Qmx6ZlM0YS9zc0cvNG41WUJMMitHYk11eTI2cnByQ0lV?=
 =?utf-8?B?Z3hFNUM0QmtXYXpxdnJuc3JJM0F0VW91VnNHRzg2a0NYT0o0RDZoUkNQZVhn?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0c9d71-ea57-488d-f2c9-08daf8f064b2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 01:07:39.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEuvTI48PtnabMvjILBe9RmGf7SX7uAJPYEBLvSUSGSWLHTldyuKku7Jpnhbh+CvKqFa4hkjKKjFJmDH9HUy+zY7/W8mOjA0PfDCgJduLBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/2023 4:55 AM, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> After scanning the bus for C22 devices, check if any Micrel PHYs have
> been found.  They are known to do bad things if there are C45
> transactions on the bus. Prevent the scanning of the bus using C45 if
> such a PHY has been detected.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

...

> @@ -600,6 +601,31 @@ static int mdiobus_scan_bus_c45(struct mii_bus *bus)
>   	return 0;
>   }
>   
> +/* There are some C22 PHYs which do bad things when where is a C45
> + * transaction on the bus, like accepting a read themselves, and
> + * stomping over the true devices reply, to performing a write to
> + * themselves which was intended for another device. Now that C22
> + * devices have been found, see if any of them are bad for C45, and if we
> + * should skip the C45 scan.
> + */
> +static bool mdiobus_prevent_c45_scan(struct mii_bus *bus)
> +{
> +	struct phy_device *phydev;
> +	u32 oui;

nit: phydev and oui declarations can move inside the loop

> +	int i;
> +
> +	for (i = 0; i < PHY_MAX_ADDR; i++) {
> +		phydev = mdiobus_get_phy(bus, i);
> +		if (!phydev)
> +			continue;
> +		oui = phydev->phy_id >> 10;
> +
> +		if (oui == MICREL_OUI)
> +			return true;
> +	}
> +	return false;
> +}
> +
>   /**
>    * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
>    * @bus: target mii_bus

