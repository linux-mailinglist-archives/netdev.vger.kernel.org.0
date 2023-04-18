Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED856E6905
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjDRQKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDRQKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:10:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A55359D;
        Tue, 18 Apr 2023 09:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681834240; x=1713370240;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=86ZeUwTPFvUfpFbfyYQDwUE+OZPr3QMsJNFhJDdgcCU=;
  b=NMLHizvDTLBHSILC6SzZ9mc2fL14xL35Gjy88zcZGzHV1GAR03Ea3Vro
   SVqUOn+BOamhwJKJQnNgH2cIZZXzdrsUu1DUekdzzljj2Ob7J+t1gFz5i
   fN7V4fmnlUc60PLOBOEh+wA+nEw71W7hwPngL13iHDs2O37hAL1zcK+UD
   LGbiWjjx2xL7PlwzuOgvldG+CE47IqvY2DOa91ty5xZPbrBCv+qxXURSP
   lzL9MGb4P8Byfk9TIDdMEc9oq9Wxt9XdOOQGM+RRhJmZFIX+2lgCfj+g5
   Qa1hQtEMPMZVC7YVTLASzUsTrwHemEBCUCnvJxnI/gZp/nEvOoObya4oS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="431500230"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="431500230"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 09:08:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="802586911"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="802586911"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 18 Apr 2023 09:08:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 09:08:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 09:08:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 09:08:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsUjFqEgct7C1Vq30zsD4ELAcysE9wtudq3d+/i2EXraKhZYMND4VoJV3o9xPZrgTSc83GbbyZIaOWOBLIK5ofOhMIn2gn50BJCU2+6emCgD1p8BPFjnmSafJjnPp5ZThX6h9cgCK7KauG+4AFXmg7b1G5C8khmr7U70PCwPVZXT3C4+yuiiDPVzWHdYl7yDn9vp3TsVZK6C0EIqWrDmRrEDN7hcjimthegj1afsafoyCR+CHeH7oXFEyogPN/CY07gJOs/uHYtTKxFjyWWLhjJVn21SooE50Fx2KCFSLoa+5h+YIBPdOeHk41lJJEmwDdKcZlL56lST6kUvuqSCeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86ZeUwTPFvUfpFbfyYQDwUE+OZPr3QMsJNFhJDdgcCU=;
 b=aL9AM/wEGb509d9+FhjKPHFOUUn/t2fnti/8kt0O3voJyYxzeCv+2hRws7OPuPsbGzn1qU7EMHOUdDpbAqkTjGdgXDiVUFkH/z0XEgTBxlyBw7uCpmaE/PdYsUwf/ImHR0+dxOF7XdLx+NakuixdtLbaC6ogsDVMbqqtbaCbePgbTYjlDdN4PlRxkUChF7x3Lph3G2ppyJbX1OwEePFAPjc8qX3/BCyS2oN9VUfw7ODSOHGjNFgF07BQJF6SYpcg7r4XrYrt2a69x4RRRqHX1Jo1KCDrRGcrxSMH8H0yuQknXor1ZlyJ0DD0OL01EoiOS81qh1yiWKeQ1VsT7hCMBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 PH0PR11MB4840.namprd11.prod.outlook.com (2603:10b6:510:43::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.45; Tue, 18 Apr 2023 16:08:15 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::f56d:630e:393f:1d28]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::f56d:630e:393f:1d28%3]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 16:08:15 +0000
Date:   Tue, 18 Apr 2023 18:08:06 +0200
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <keescook@chromium.org>, <grzegorzx.szczurek@intel.com>,
        <mateusz.palczewski@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>,
        "Donglin Peng" <pengdonglin@sangfor.com.cn>,
        Huang Cun <huangcun@sangfor.com.cn>
Subject: Re: [PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Message-ID: <ZD7AZpQJF7YWTUgt@localhost.localdomain>
References: <20230408140030.5769-1-dinghui@sangfor.com.cn>
 <20230408140030.5769-2-dinghui@sangfor.com.cn>
 <ZD6/H9DotpfOxr1+@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZD6/H9DotpfOxr1+@localhost.localdomain>
X-ClientProxiedBy: DB8PR03CA0006.eurprd03.prod.outlook.com
 (2603:10a6:10:be::19) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|PH0PR11MB4840:EE_
X-MS-Office365-Filtering-Correlation-Id: 01d9f006-ef8b-4152-acd7-08db40271de8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GdMnGtaXfMQYSkOYMWYCEZeycIIMWLBOleMZ+4h30qtYWbvUdAWeHdqSfIHyCMwZRkt1qK+EIy3TkkT6xCi3ZGelxto1ZmhNGl8a7xnJk6ZOdAupYgisd7jnGYdcAxAhddoiHo9cxuQGvEUvoJP5JMrfx1mmHoFa3KSC48F18dGr8TAlh0+jW2FHdbv9JcisMPMcGDZXmeKLmtzKDY3pwOiPKWxMtOpw1LweNCfSIwEVWiWvMyJ0lVfgvbZwIznapu5QwHu0Q/kl2L+pC8SvPoziOUYu6XKQs5yrutKWAd4cxjHT02WIgTCOWquQHDxqMJ9EdDaUtUhFKwQA7vLdXO/p21Gl8xY82BRykG3vVXCzY/k5QQQJMp9qqPv3VIVIxjME8s8Pn9sg9r9JJFNkTY6sf7xZwLobulW//FAOqUZ959sc9x86H28+0p5R8eHBP+fN5wWa0nIfTtL3+rJcY3EVDeOKou6XnpzimTaiedRMS4+wDKoSmHpK2jXfoUxUXqSvpJJ9lFUYUj+hpEx4QMiUPervvc8G9dwrkfMxt5qOddMyjHDMPzVySMb+tRQ+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199021)(2906002)(4744005)(82960400001)(478600001)(6666004)(6486002)(38100700002)(83380400001)(26005)(6506007)(6512007)(9686003)(86362001)(186003)(7416002)(41300700001)(44832011)(316002)(8676002)(8936002)(5660300002)(54906003)(6916009)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5iOEiN2KXl3cGP9/xtXzzfOeG0vuKWMAqp9JMXy3VIqGgl6u6YSJi0NlJdob?=
 =?us-ascii?Q?82uNRoeYeVACLIrT6+FENXP9Ro0fRYqPeQGEOQ7713Sdv9aAkQB4njIZBHW+?=
 =?us-ascii?Q?g2uL+tJR3tyvAdC8/ANeiUsYjtu8hgUzYodt5Bjabwi5m34gAu0IejvXDWGg?=
 =?us-ascii?Q?1QBRnU5RVF6IZNG9xehkcGv5ceM8pTu4gbWE5ct2hXxvHnMfWZDetZr/1M6H?=
 =?us-ascii?Q?WKjnt2qiSUl+8cH0V/tpWJzuUTC5QMp48GvEr7Yl11LLI1TkWeyHvcGEViMG?=
 =?us-ascii?Q?5GCfLfoivxyzl3HF7HPUt9LPea1I5GxZeqz8UyRzpGMhWt6Xo0/Mu3MGnf/6?=
 =?us-ascii?Q?aYuBIijLr0Us7MB5xiB9X63wWYG/Al28sDoVmzWNBSUJvxv3jo8tm/C+HCc9?=
 =?us-ascii?Q?TiFqxRT24IGTVB2bgOZbUyWlcRk3u8gHraactrGN6hI1fWCZcYLLED1ddtMy?=
 =?us-ascii?Q?uoPuB6UvC/0Xr5FVFhMRktfMtwH1RNiB88AD/zrJzPN0eAbYbGsgXf5ompyy?=
 =?us-ascii?Q?ds7yV7VYz7QQj9dktZ7YAJXKKpSIaSfDQqfKhsoWei+At9ylV7FEgyr+9O8e?=
 =?us-ascii?Q?ES//E5rNom/4ajWEqHukDH+ceD32OhEINJ02oJLRXi6bqYExtcHq28TBxPZn?=
 =?us-ascii?Q?hHSRJ8LX4V9062FBNqT2kZWS0q1AOQS5JbTG9gs1wnDCQAVnk8gz7rHKz5x9?=
 =?us-ascii?Q?TuwK9G/TJ0hGJidbxuIsirFQH2U2lGB/lapErs3Uwz5f3z0z8hpCK0Wcrz2a?=
 =?us-ascii?Q?b7Gh4nC+sfpOmTAk5hwcCpkafi47JjHkN7KFrDMktvdKPLne2hG8p2G/qySo?=
 =?us-ascii?Q?BR8MkZ/0MwW3Xsr/OQqVH7lVfNi/w6wmU57yQYxg+iPJ0yA0dX/iTIlbQhFp?=
 =?us-ascii?Q?caSmL6TdfRMv+eSL4TCT6cM1A6htGBTMV6kZkicW1ZeHfeRKhCT/ecHX/k1T?=
 =?us-ascii?Q?O2XDkB7wkKMWjKHk42iF6Y8H71oh1vMlTINn4jMYTzgzJh/BFiU4rV9Ee0pJ?=
 =?us-ascii?Q?pMnhtfsQzLVlxT8H9A4rJ09k8oaSMiO0Li3mhlnEEuFNRZg2vF6RbQyofkx9?=
 =?us-ascii?Q?89qOfSJGt2OQT3r3CtC6jYmu+Lbxuk+rpXvwDKua2VH+EdoqQVtrtEjg5HcU?=
 =?us-ascii?Q?6JBzYJtOuLfTelTBpKGyK53Ho3vrWVYy4yoJvESPa0NZDlvYL3LHHEPHMy59?=
 =?us-ascii?Q?EcFV9TAA1w2gluBG3P2kkOzkNcIIV1hj9pNsp41pwgzYf8/oMY+6TrhdQN1w?=
 =?us-ascii?Q?wTliDUp2py2D58qlPnWsTpT1UXV+eW+REZDbTY9YaDWhJ8O+vYRzcuWFwirJ?=
 =?us-ascii?Q?+AzaXQtdttQ9hdsIyQai3ospccZqCjncLeWJeU3478/x8OW+GrK/XjjdauMK?=
 =?us-ascii?Q?MtsNDOr3xgUU64CN0W+kH2bIVJ5DoDn9xonmSPU93fW7d8ownK8ySWW14nv0?=
 =?us-ascii?Q?WpvYQieNi2bd1dLEkmFvn8XoivKXKggcXGkez2+FALTi7ohrLUSOOPGQJO3E?=
 =?us-ascii?Q?Aw5cxE/4mWwV6MIC/gf51+CuTENYJvyAsE5z1YjKkVvrLBcdB63vrCpLs4yT?=
 =?us-ascii?Q?zgZTvyiEK7ULNpY9i3zVlQuX3OcVE/QL1Ix/yl7hR0Pgjc8jBDwp4UQlfs4u?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d9f006-ef8b-4152-acd7-08db40271de8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:08:15.4442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0uarohtBNx1PLo2hOkFY+WHK4K7g9RJva1BVVKEr2ivUSL0eU/JM/wOPJgZbOBpEWZiY+oXiJrIuFHO7oFofTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4840
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 06:02:39PM +0200, Michal Kubiak wrote:
> Also, I would recommend to add a description of reproduction steps (most
> preferably a script or a command sequence) which triggers such an error
> reported by KASAN.

Oh, sorry. I have overlooked the scripts from the cover letter.
But still - maybe it will be a good idea to have them in the commit
message (to track them more easily using "git log")?

Michal
