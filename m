Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDC8697FF9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBOPze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBOPzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:55:32 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4FBA8;
        Wed, 15 Feb 2023 07:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676476529; x=1708012529;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NcLl+tji2sP+nSCvIYnQWEecYs+CxCgeJe0YAYb8GPo=;
  b=IH9J0qdkTRdG2etTDjHTGGvf+NzK/swdge8nODXq6Mr40ikgCo9czHAh
   IoXGGhFrTEF43Unu8qf67lGKbs1uYu8gDlBD77iwe2BT88OqKp7TiUIa5
   iBMCWOKqi4F1ZwFST8tyftCGhIs6bnljYHZbqhKAemlfapPGqhZV4GyAd
   aAFcPR3l/guu5LMjotqr28pi5c09kVGhHv75H8T94oZALDy866Tm+HnID
   gmiFhm3XDO7dpTQuzS5kqRXIZkDNccGmo1kIwxdwFJhkQ4+A3IPQLTW8K
   feHu2dDkBrm6WEssK+B0YPodL6zQ8HT7F2slvaoIbr4M7R60xjpQWo3Du
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="332766231"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="332766231"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:55:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="733331549"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="733331549"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2023 07:55:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:55:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:55:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 07:55:26 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 07:55:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSUWrZP3ktveDKaqxaICCv2Z0Ic5eO/cYeVYgWyvIXW2coB+J3rtH3UziJ2HJWTHpbqJBFxPOb5W6re2FesckG4FoMmvnFziDrrVNphKFpxScgAYR4V1x3jploVFFMFx731ifuzndn/yxl8tZ4fEarnAsBzTwg26AW+Kl1SIGTgdfMH5x85ximoj8QkMDaa4GwXMmIZEGyJLj65cOEdYj5QReqpfF+5/KA4soXLdjdeQdzx7iBzZP8ozUpCSgAVxJ0SseudhiQKqV7uhtlo3nKkd8lWpLHDdJdOskZIpY43AhpzM+eUk0mLnyhE7L6tCDprpX/5JWqfEmIMre32UWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qo9bc6x0igTo+M8mG7vBpHIgMuODQXhMLS0PqgyQK84=;
 b=dVJnCzNt/CQb+f1j4onytqMdBANtgPebHBLwOm3k1pRQNP8DmqTMuwPw2j9K7twoprkcBbALOMbDSMFJLxtwM90EZWh//o1zAoVRmxV2FpVzjJinYdOj59V6/oCVBYmFsncOoBPsocPg+EL9Ak8GSm5AD6P1KJYW2bsxggoT+3RAmsYXp+5pLjpaIPndXGZbLmpj7eK1SfhvIObpZsmLhD1usZfBhaYAloVXvKqb81Tm8+CI4f3m9GtF8aSSwO2h5bKEkVmHN8MK0vNnu5BjRRCFyzqRdPJhMgGALqAALprRKxiRGzCMIPn2emy8mzU6kUvfCvzASbcH6fi4GR3lAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BY1PR11MB8077.namprd11.prod.outlook.com (2603:10b6:a03:527::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 15:55:24 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 15 Feb 2023
 15:55:23 +0000
Date:   Wed, 15 Feb 2023 16:55:07 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>,
        <sburla@marvell.com>, <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 4/7] octeon_ep: enhance control mailbox for
 VF support
Message-ID: <Y+0AW3b9No9pyWrr@boxer>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-5-vburru@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230214051422.13705-5-vburru@marvell.com>
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BY1PR11MB8077:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d8396f-fb68-47b6-f1c2-08db0f6d0bf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMxYpklWxUXNrHlGWE/KTx2g5/jyDrfQSA/PBqWHrWhqGEUshEOg4Dh1aUtt7OqH3gVR9dejnj4xLvfShZ7ys9iKjB10HpaTYEQBwsTvkOq5kGVffnwZXrYx6OMHf5z9sIXFyxkbCFQ/m0wpLvxoCowZwt/vnnRbpC1OwvHGoTuCiXebgez54TN3qH1EMmLlm5L9rZyNNhgr3nnXnWNLoUKTH7568mtYYzeUAF09uHEpHqps1ZDtp4gEdCoXSuEkPuTGYz/WG8v6ys/ICDuFfuM0U1TkYn5KYTIpSJHf7CAxtbWh7WvCZ3KeA3Hb2N9wJ9OjLDxSKASSVuEKsYK+rkBO6IgtRckR0WpEJ7XpThvJMZ3bFCVVKIlnascwkwF6R7GsxNNbkL1+aM0CspraOYyw7zg/CYGRUohYtfXlE3XU79Xsk3lHzgaAETx5e5a3qnwFiLuhKM65bgNtGURd0io2uX2J5QEu+R0ljQSJo29Iw0L/xM45YoBY9lNbtLLfIeNACLZAwXNeDmgUCXZmLQ7VKwWVawkT3lmikt0DmW+TdDLN7hqkq9ihyBpkXujn5EesafLw4TcR9KenHde+DIW5DSt62wnUCXiTegGEVrW+dp7/UV/7tZsgjKaTRZ0xEBtbIkOCKCyJ707rjPKiTtuNdHLcK4VaxqTII+55axZljUKC3n1HU+VUq/WeX3By
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199018)(82960400001)(66476007)(66556008)(6916009)(6486002)(41300700001)(7416002)(4326008)(30864003)(66946007)(44832011)(5660300002)(8936002)(86362001)(38100700002)(8676002)(83380400001)(26005)(186003)(6666004)(6512007)(9686003)(6506007)(478600001)(33716001)(54906003)(316002)(2906002)(15650500001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OAyCQFhGFB5lMTXCAT2VcjUm6DM6g3medt9ckqhAjhaqwzgVRH49bGNL42gB?=
 =?us-ascii?Q?a7pgEprubCp8y6OgkdXNj7VZShAkgNd1k8Jb3qFJlP+HRKgsTN8Ddt+wZKHU?=
 =?us-ascii?Q?4g7DkTyQe8+Ni/CriNnm+E5GAduGoPbCCwaFGVD0rYKyIr8yl4P6bM5jwlvL?=
 =?us-ascii?Q?+NEXY7Mq4o5ZxJUWbn+UYPrb1OiyIFORjq622nkrWvdOj6/CdIoz/pqMac31?=
 =?us-ascii?Q?vANUBseFauDbjBDsBYx3Em3OxquCYqSb/zYHwp0lC0mGmLF87nHP1SSjXSxX?=
 =?us-ascii?Q?Wqz3hhUuv0SVpezmtksQoUwGWG9YdBGU49JTY8D6Al/cO7j+0UnlNVSfzqsy?=
 =?us-ascii?Q?Ej+bCkf3Qx5OtxqADT5gFIRUbLgoTL2dcP2jsRllxCQ5cRPzPtc8QCLCyqo7?=
 =?us-ascii?Q?t0ta7VqdoHVTjM3qZg79mYf419qascQ6RmhyKWa6TmhuX6R6dHyPt8+EYIZ+?=
 =?us-ascii?Q?wkndUb6TCxRnUx4XvD80+uNg3KODI32qFdD59w8glGMFgpU91WBKhYt7mSnv?=
 =?us-ascii?Q?mTWXvZh+oTSy3CGLG5zPZ/rqI7lAgkTYDo0hryPYiu7UA70JrKZpt1znaXuP?=
 =?us-ascii?Q?4Q0vOq0jzepGcRtsUSL0k6fGobEL0VLtpZ1qAjIMLKnaVphkfCjiiOvUZqrr?=
 =?us-ascii?Q?mD62D6FuRkodjPY7OuKrK2Tz+WKjnoi2nToA4nC6KvncCez7VR+LDl4peUjL?=
 =?us-ascii?Q?ktmddQdBHbl0BlPXaw/YQGqmbBTrxUHHzlefdIM+nkUSBIMSktubLJ984287?=
 =?us-ascii?Q?v5fKqwTUJGcYNvnyYZuOMWwymNeS84f68yDMiLclDPmjEh+6/4WtcY+ZGKYT?=
 =?us-ascii?Q?e7k4mDlfyzrIWfBwUmScyTvoDn6xl8f8NBYw7fjWYLeYzqHugL1GCvbpnt5J?=
 =?us-ascii?Q?TmkfUZ1xKddQNDv5j0zuxh7zo6XzRC2ygp7T4pHg+DqAbm5zchstTJltqSeH?=
 =?us-ascii?Q?U3TRDAo4qCPsw3WPXAYfEvZ3JsvBkHZ9HrdDt27sHfpTCHYvBZ0K2R2e/Agf?=
 =?us-ascii?Q?cA/0K+n9KT9lNnNkP/ls8nlqHJ/zNxAmNuYw8SiopvHydb6bcvZJ32kwY/gn?=
 =?us-ascii?Q?TyHWih91L1BbZ4clc5bpAiohA2nSgsvzrs5XpDIpeKajE1qTTmaEtdLgMTQq?=
 =?us-ascii?Q?aqGxvwcCEr4EYdWiO4T+URDsj+wjXtPt4p6eezra7o9Niqt7Z9AzIcBe5ZWW?=
 =?us-ascii?Q?8zgejVfHLoAh2D0xdIJq3i8l8H3hDMW3G9wStwpxMa+1rdMbsQKKzKyWw20Y?=
 =?us-ascii?Q?FQ7PzNOEArVxPSqPgWVe3TdZJkAcBvK74zIeXe/C1+aTqMZi0pZi0q1sRrU5?=
 =?us-ascii?Q?GF/lej2GlN4f8Sh0ewG15aXO/66h1boONnZw17Sj5IQcp2+PCy4uSCWMc1h3?=
 =?us-ascii?Q?Krb86IDzvHSH275tkJadPtFWVAw5XpayQwn11lYWUlcrCzna3OV+b2fqnQOU?=
 =?us-ascii?Q?5vlLWvSuFN+cEx0Qn6RWyiLe6xKLnDnSKXngxuDg4GNaA49vGX6A9FKGCYMA?=
 =?us-ascii?Q?2/rYG5f6MfU4Y1b9q6Xt41ZFDC0Yxhl4fztPkn0atCZcpBma+YIw1NMFND+4?=
 =?us-ascii?Q?ltuXPPWMn3zGNvgItEcabRlMRfNoy3eYxHs450pIU/z/wiMQWUm+SQrw/QJa?=
 =?us-ascii?Q?rSAsnkbmhGlvebI5IWiDXBY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d8396f-fb68-47b6-f1c2-08db0f6d0bf8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 15:55:23.3522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwVAZjBBb5a07KkUJeW4xVub/0n3p5PJLn1TR1vWnUCIruZjqeUeKSkMY4DOO0vEl42JkUIuQZLPooayuZAfe18LNTTG06gZpL3K+RiC7b4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8077
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 09:14:19PM -0800, Veerasenareddy Burru wrote:
> Enhance control mailbox protocol to support following
>  - separate command and response queues
>     * command queue to send control commands to firmware.
>     * response queue to receive responses and notifications from
>       firmware.
>  - variable size messages using scatter/gather
>  - VF support
>     * extend control command structure to include vfid.
>     * update APIs to accept VF ID.
> 
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> ---
> v2 -> v3:
>  * no change
> 
> v1 -> v2:
>  * modified the patch to work with device status "oct->status" removed.
> 
>  .../marvell/octeon_ep/octep_ctrl_mbox.c       | 318 +++++++++-------
>  .../marvell/octeon_ep/octep_ctrl_mbox.h       | 102 ++---
>  .../marvell/octeon_ep/octep_ctrl_net.c        | 349 ++++++++++++------
>  .../marvell/octeon_ep/octep_ctrl_net.h        | 176 +++++----
>  .../marvell/octeon_ep/octep_ethtool.c         |   7 +-
>  .../ethernet/marvell/octeon_ep/octep_main.c   |  80 ++--
>  6 files changed, 619 insertions(+), 413 deletions(-)

patch is big, any ways to split it up? for example, why couldn't the "VF
support" be pulled out to a sequent commit?

> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
> index 39322e4dd100..cda252fc8f54 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
> @@ -24,41 +24,49 @@
>  /* Time in msecs to wait for message response */
>  #define OCTEP_CTRL_MBOX_MSG_WAIT_MS			10
>  
> -#define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(m)	(m)
> -#define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(m)	((m) + 8)
> -#define OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(m)	((m) + 24)
> -#define OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(m)	((m) + 144)
> -
> -#define OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)		((m) + OCTEP_CTRL_MBOX_INFO_SZ)
> -#define OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(m)		(OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m))
> -#define OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 4)
> -#define OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 8)
> -#define OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 12)
> -
> -#define OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)		((m) + \
> -							 OCTEP_CTRL_MBOX_INFO_SZ + \
> -							 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ)
> -#define OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(m)		(OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m))
> -#define OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 4)
> -#define OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 8)
> -#define OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 12)
> -
> -#define OCTEP_CTRL_MBOX_Q_OFFSET(m, i)			((m) + \
> -							 (sizeof(struct octep_ctrl_mbox_msg) * (i)))
> -
> -static u32 octep_ctrl_mbox_circq_inc(u32 index, u32 mask)
> +/* Size of mbox info in bytes */
> +#define OCTEP_CTRL_MBOX_INFO_SZ				256
> +/* Size of mbox host to fw queue info in bytes */
> +#define OCTEP_CTRL_MBOX_H2FQ_INFO_SZ			16
> +/* Size of mbox fw to host queue info in bytes */
> +#define OCTEP_CTRL_MBOX_F2HQ_INFO_SZ			16
> +
> +#define OCTEP_CTRL_MBOX_TOTAL_INFO_SZ	(OCTEP_CTRL_MBOX_INFO_SZ + \
> +					 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ + \
> +					 OCTEP_CTRL_MBOX_F2HQ_INFO_SZ)
> +
> +#define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM(m)	(m)

This doesn't serve any purpose, does it? I know there was
OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET but i don't see any value in this
macro.

> +#define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ(m)	((m) + 8)
> +#define OCTEP_CTRL_MBOX_INFO_HOST_STATUS(m)	((m) + 24)
> +#define OCTEP_CTRL_MBOX_INFO_FW_STATUS(m)	((m) + 144)
> +
> +#define OCTEP_CTRL_MBOX_H2FQ_INFO(m)	((m) + OCTEP_CTRL_MBOX_INFO_SZ)
> +#define OCTEP_CTRL_MBOX_H2FQ_PROD(m)	(OCTEP_CTRL_MBOX_H2FQ_INFO(m))
> +#define OCTEP_CTRL_MBOX_H2FQ_CONS(m)	((OCTEP_CTRL_MBOX_H2FQ_INFO(m)) + 4)
> +#define OCTEP_CTRL_MBOX_H2FQ_SZ(m)	((OCTEP_CTRL_MBOX_H2FQ_INFO(m)) + 8)
> +
> +#define OCTEP_CTRL_MBOX_F2HQ_INFO(m)	((m) + \
> +					 OCTEP_CTRL_MBOX_INFO_SZ + \
> +					 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ)
> +#define OCTEP_CTRL_MBOX_F2HQ_PROD(m)	(OCTEP_CTRL_MBOX_F2HQ_INFO(m))
> +#define OCTEP_CTRL_MBOX_F2HQ_CONS(m)	((OCTEP_CTRL_MBOX_F2HQ_INFO(m)) + 4)
> +#define OCTEP_CTRL_MBOX_F2HQ_SZ(m)	((OCTEP_CTRL_MBOX_F2HQ_INFO(m)) + 8)
> +
> +static const u32 mbox_hdr_sz = sizeof(union octep_ctrl_mbox_msg_hdr);
> +
> +static u32 octep_ctrl_mbox_circq_inc(u32 index, u32 inc, u32 sz)
>  {
> -	return (index + 1) & mask;
> +	return (index + inc) % sz;

previously mbox len was power-of-2 sized?

>  }
>  
> -static u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 mask)
> +static u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 sz)
>  {
> -	return mask - ((pi - ci) & mask);
> +	return sz - (abs(pi - ci) % sz);
>  }
>  
> -static u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 mask)
> +static u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 sz)
>  {
> -	return ((pi - ci) & mask);
> +	return (abs(pi - ci) % sz);
>  }
>  
>  int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
> @@ -73,172 +81,228 @@ int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
>  		return -EINVAL;
>  	}
>  
> -	magic_num = readq(OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(mbox->barmem));
> +	magic_num = readq(OCTEP_CTRL_MBOX_INFO_MAGIC_NUM(mbox->barmem));
>  	if (magic_num != OCTEP_CTRL_MBOX_MAGIC_NUMBER) {
> -		pr_info("octep_ctrl_mbox : Invalid magic number %llx\n", magic_num);
> +		pr_info("octep_ctrl_mbox : Invalid magic number %llx\n",
> +			magic_num);

unneeded change

>  		return -EINVAL;
>  	}
>  
> -	status = readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(mbox->barmem));
> +	status = readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem));
>  	if (status != OCTEP_CTRL_MBOX_STATUS_READY) {
>  		pr_info("octep_ctrl_mbox : Firmware is not ready.\n");
>  		return -EINVAL;
>  	}
>  
> -	mbox->barmem_sz = readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(mbox->barmem));
> +	mbox->barmem_sz = readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ(mbox->barmem));
>  
> -	writeq(OCTEP_CTRL_MBOX_STATUS_INIT, OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
> +	writeq(OCTEP_CTRL_MBOX_STATUS_INIT,
> +	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
>  
> -	mbox->h2fq.elem_cnt = readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(mbox->barmem));
> -	mbox->h2fq.elem_sz = readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(mbox->barmem));
> -	mbox->h2fq.mask = (mbox->h2fq.elem_cnt - 1);
> -	mutex_init(&mbox->h2fq_lock);
> +	mbox->h2fq.sz = readl(OCTEP_CTRL_MBOX_H2FQ_SZ(mbox->barmem));
> +	mbox->h2fq.hw_prod = OCTEP_CTRL_MBOX_H2FQ_PROD(mbox->barmem);
> +	mbox->h2fq.hw_cons = OCTEP_CTRL_MBOX_H2FQ_CONS(mbox->barmem);
> +	mbox->h2fq.hw_q = mbox->barmem + OCTEP_CTRL_MBOX_TOTAL_INFO_SZ;
>  
> -	mbox->f2hq.elem_cnt = readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(mbox->barmem));
> -	mbox->f2hq.elem_sz = readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(mbox->barmem));
> -	mbox->f2hq.mask = (mbox->f2hq.elem_cnt - 1);
> -	mutex_init(&mbox->f2hq_lock);
> -
> -	mbox->h2fq.hw_prod = OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(mbox->barmem);
> -	mbox->h2fq.hw_cons = OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(mbox->barmem);
> -	mbox->h2fq.hw_q = mbox->barmem +
> -			  OCTEP_CTRL_MBOX_INFO_SZ +
> -			  OCTEP_CTRL_MBOX_H2FQ_INFO_SZ +
> -			  OCTEP_CTRL_MBOX_F2HQ_INFO_SZ;
> -
> -	mbox->f2hq.hw_prod = OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(mbox->barmem);
> -	mbox->f2hq.hw_cons = OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(mbox->barmem);
> -	mbox->f2hq.hw_q = mbox->h2fq.hw_q +
> -			  ((mbox->h2fq.elem_sz + sizeof(union octep_ctrl_mbox_msg_hdr)) *
> -			   mbox->h2fq.elem_cnt);
> +	mbox->f2hq.sz = readl(OCTEP_CTRL_MBOX_F2HQ_SZ(mbox->barmem));
> +	mbox->f2hq.hw_prod = OCTEP_CTRL_MBOX_F2HQ_PROD(mbox->barmem);
> +	mbox->f2hq.hw_cons = OCTEP_CTRL_MBOX_F2HQ_CONS(mbox->barmem);
> +	mbox->f2hq.hw_q = mbox->barmem +
> +			  OCTEP_CTRL_MBOX_TOTAL_INFO_SZ +
> +			  mbox->h2fq.sz;
>  
>  	/* ensure ready state is seen after everything is initialized */
>  	wmb();
> -	writeq(OCTEP_CTRL_MBOX_STATUS_READY, OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
> +	writeq(OCTEP_CTRL_MBOX_STATUS_READY,
> +	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
>  
>  	pr_info("Octep ctrl mbox : Init successful.\n");
>  
>  	return 0;
>  }
>  
> -int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
> +static int write_mbox_data(struct octep_ctrl_mbox_q *q, u32 *pi,
> +			   u32 ci, void *buf, u32 w_sz)

octep_write_mbox_data ?

also, you only return 0 and don't check the retval, so
s/static int/static void

> +{
> +	u32 cp_sz;
> +	u8 __iomem *qbuf;
> +
> +	/* Assumption: Caller has ensured enough write space */
> +	qbuf = (q->hw_q + *pi);
> +	if (*pi < ci) {
> +		/* copy entire w_sz */
> +		memcpy_toio(qbuf, buf, w_sz);
> +		*pi = octep_ctrl_mbox_circq_inc(*pi, w_sz, q->sz);
> +	} else {
> +		/* copy up to end of queue */
> +		cp_sz = min((q->sz - *pi), w_sz);
> +		memcpy_toio(qbuf, buf, cp_sz);
> +		w_sz -= cp_sz;
> +		*pi = octep_ctrl_mbox_circq_inc(*pi, cp_sz, q->sz);
> +		if (w_sz) {
> +			/* roll over and copy remaining w_sz */
> +			buf += cp_sz;
> +			qbuf = (q->hw_q + *pi);
> +			memcpy_toio(qbuf, buf, w_sz);
> +			*pi = octep_ctrl_mbox_circq_inc(*pi, w_sz, q->sz);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox,
> +			 struct octep_ctrl_mbox_msg *msgs,
> +			 int num)

only callsite that currently is present sets num to 1, what's the point
currently of having this arg?

>  {
> -	unsigned long timeout = msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_TIMEOUT_MS);
> -	unsigned long period = msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_WAIT_MS);
> +	struct octep_ctrl_mbox_msg_buf *sg;
> +	struct octep_ctrl_mbox_msg *msg;
>  	struct octep_ctrl_mbox_q *q;
> -	unsigned long expire;
> -	u64 *mbuf, *word0;
> -	u8 __iomem *qidx;
> -	u16 pi, ci;
> -	int i;
> +	u32 pi, ci, prev_pi, buf_sz, w_sz;

RCT? you probably have this issue all over your patchset

> +	int m, s;
>  
> -	if (!mbox || !msg)
> +	if (!mbox || !msgs)
>  		return -EINVAL;
>  
> +	if (readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem)) !=
> +	    OCTEP_CTRL_MBOX_STATUS_READY)
> +		return -EIO;
> +
> +	mutex_lock(&mbox->h2fq_lock);
>  	q = &mbox->h2fq;
>  	pi = readl(q->hw_prod);
>  	ci = readl(q->hw_cons);
> +	for (m = 0; m < num; m++) {
> +		msg = &msgs[m];
> +		if (!msg)
> +			break;
>  
> -	if (!octep_ctrl_mbox_circq_space(pi, ci, q->mask))
> -		return -ENOMEM;
> -
> -	qidx = OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, pi);
> -	mbuf = (u64 *)msg->msg;
> -	word0 = &msg->hdr.word0;
> -
> -	mutex_lock(&mbox->h2fq_lock);
> -	for (i = 1; i <= msg->hdr.sizew; i++)
> -		writeq(*mbuf++, (qidx + (i * 8)));
> -
> -	writeq(*word0, qidx);
> +		/* not enough space for next message */
> +		if (octep_ctrl_mbox_circq_space(pi, ci, q->sz) <
> +		    (msg->hdr.s.sz + mbox_hdr_sz))
> +			break;
>  
> -	pi = octep_ctrl_mbox_circq_inc(pi, q->mask);
> +		prev_pi = pi;
> +		write_mbox_data(q, &pi, ci, (void *)&msg->hdr, mbox_hdr_sz);
> +		buf_sz = msg->hdr.s.sz;
> +		for (s = 0; ((s < msg->sg_num) && (buf_sz > 0)); s++) {
> +			sg = &msg->sg_list[s];
> +			w_sz = (sg->sz <= buf_sz) ? sg->sz : buf_sz;
> +			write_mbox_data(q, &pi, ci, sg->msg, w_sz);
> +			buf_sz -= w_sz;
> +		}
> +		if (buf_sz) {
> +			/* we did not write entire message */
> +			pi = prev_pi;
> +			break;
> +		}
> +	}
>  	writel(pi, q->hw_prod);
>  	mutex_unlock(&mbox->h2fq_lock);
>  
> -	/* don't check for notification response */
> -	if (msg->hdr.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
> -		return 0;
> +	return (m) ? m : -EAGAIN;

remove brackets

> +}
>  
> -	expire = jiffies + timeout;
> -	while (true) {
> -		*word0 = readq(qidx);
> -		if (msg->hdr.flags == OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
> -			break;
> -		schedule_timeout_interruptible(period);
> -		if (signal_pending(current) || time_after(jiffies, expire)) {
> -			pr_info("octep_ctrl_mbox: Timed out\n");
> -			return -EBUSY;
> +static int read_mbox_data(struct octep_ctrl_mbox_q *q, u32 pi,

same comment as for write func

> +			  u32 *ci, void *buf, u32 r_sz)
> +{
> +	u32 cp_sz;
> +	u8 __iomem *qbuf;
> +
> +	/* Assumption: Caller has ensured enough read space */
> +	qbuf = (q->hw_q + *ci);
> +	if (*ci < pi) {
> +		/* copy entire r_sz */
> +		memcpy_fromio(buf, qbuf, r_sz);
> +		*ci = octep_ctrl_mbox_circq_inc(*ci, r_sz, q->sz);
> +	} else {
> +		/* copy up to end of queue */
> +		cp_sz = min((q->sz - *ci), r_sz);
> +		memcpy_fromio(buf, qbuf, cp_sz);
> +		r_sz -= cp_sz;
> +		*ci = octep_ctrl_mbox_circq_inc(*ci, cp_sz, q->sz);
> +		if (r_sz) {
> +			/* roll over and copy remaining r_sz */
> +			buf += cp_sz;
> +			qbuf = (q->hw_q + *ci);
> +			memcpy_fromio(buf, qbuf, r_sz);
> +			*ci = octep_ctrl_mbox_circq_inc(*ci, r_sz, q->sz);
>  		}
>  	}
> -	mbuf = (u64 *)msg->msg;
> -	for (i = 1; i <= msg->hdr.sizew; i++)
> -		*mbuf++ = readq(qidx + (i * 8));
>  
>  	return 0;
>  }
>  
> -int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
> +int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox,
> +			 struct octep_ctrl_mbox_msg *msgs,
> +			 int num)
>  {
> +	struct octep_ctrl_mbox_msg_buf *sg;
> +	struct octep_ctrl_mbox_msg *msg;
>  	struct octep_ctrl_mbox_q *q;
> -	u32 count, pi, ci;
> -	u8 __iomem *qidx;
> -	u64 *mbuf;
> -	int i;
> +	u32 pi, ci, q_depth, r_sz, buf_sz, prev_ci;
> +	int s, m;
>  
> -	if (!mbox || !msg)
> +	if (!mbox || !msgs)
>  		return -EINVAL;
>  
> +	if (readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem)) !=
> +	    OCTEP_CTRL_MBOX_STATUS_READY)
> +		return -EIO;
> +
> +	mutex_lock(&mbox->f2hq_lock);
>  	q = &mbox->f2hq;
>  	pi = readl(q->hw_prod);
>  	ci = readl(q->hw_cons);
> -	count = octep_ctrl_mbox_circq_depth(pi, ci, q->mask);
> -	if (!count)
> -		return -EAGAIN;
> -
> -	qidx = OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, ci);
> -	mbuf = (u64 *)msg->msg;
> -
> -	mutex_lock(&mbox->f2hq_lock);
> +	for (m = 0; m < num; m++) {
> +		q_depth = octep_ctrl_mbox_circq_depth(pi, ci, q->sz);
> +		if (q_depth < mbox_hdr_sz)
> +			break;
>  
> -	msg->hdr.word0 = readq(qidx);
> -	for (i = 1; i <= msg->hdr.sizew; i++)
> -		*mbuf++ = readq(qidx + (i * 8));
> +		msg = &msgs[m];
> +		if (!msg)
> +			break;
>  
> -	ci = octep_ctrl_mbox_circq_inc(ci, q->mask);
> +		prev_ci = ci;
> +		read_mbox_data(q, pi, &ci, (void *)&msg->hdr, mbox_hdr_sz);
> +		buf_sz = msg->hdr.s.sz;
> +		if (q_depth < (mbox_hdr_sz + buf_sz)) {
> +			ci = prev_ci;
> +			break;
> +		}
> +		for (s = 0; ((s < msg->sg_num) && (buf_sz > 0)); s++) {
> +			sg = &msg->sg_list[s];
> +			r_sz = (sg->sz <= buf_sz) ? sg->sz : buf_sz;
> +			read_mbox_data(q, pi, &ci, sg->msg, r_sz);
> +			buf_sz -= r_sz;
> +		}
> +		if (buf_sz) {
> +			/* we did not read entire message */
> +			ci = prev_ci;
> +			break;
> +		}
> +	}
>  	writel(ci, q->hw_cons);
> -
>  	mutex_unlock(&mbox->f2hq_lock);
>  
> -	if (msg->hdr.flags != OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ || !mbox->process_req)
> -		return 0;
> -
> -	mbox->process_req(mbox->user_ctx, msg);
> -	mbuf = (u64 *)msg->msg;
> -	for (i = 1; i <= msg->hdr.sizew; i++)
> -		writeq(*mbuf++, (qidx + (i * 8)));
> -
> -	writeq(msg->hdr.word0, qidx);
> -
> -	return 0;
> +	return (m) ? m : -EAGAIN;

again remove brackets

>  }
>  
>  int octep_ctrl_mbox_uninit(struct octep_ctrl_mbox *mbox)
>  {
>  	if (!mbox)
>  		return -EINVAL;
> +	if (!mbox->barmem)
> +		return -EINVAL;
>  
> -	writeq(OCTEP_CTRL_MBOX_STATUS_UNINIT,
> -	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
> +	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
> +	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
>  	/* ensure uninit state is written before uninitialization */
>  	wmb();
>  
>  	mutex_destroy(&mbox->h2fq_lock);
>  	mutex_destroy(&mbox->f2hq_lock);
>  
> -	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
> -	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
> -
>  	pr_info("Octep ctrl mbox : Uninit successful.\n");
>  
>  	return 0;

(...)

>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_net_h2f_resp *resp;
> -	struct octep_ctrl_mbox_msg msg = {};
> -	int err;
> +	msg->hdr.s.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> +	msg->hdr.s.msg_id = atomic_inc_return(&ctrl_net_msg_id) &
> +			    GENMASK(sizeof(msg->hdr.s.msg_id) * BITS_PER_BYTE, 0);
> +	msg->hdr.s.sz = req_hdr_sz + sz;
> +	msg->sg_num = 1;
> +	msg->sg_list[0].msg = buf;
> +	msg->sg_list[0].sz = msg->hdr.s.sz;
> +	if (vfid != OCTEP_CTRL_NET_INVALID_VFID) {
> +		msg->hdr.s.is_vf = 1;
> +		msg->hdr.s.vf_idx = vfid;
> +	}
> +}
>  
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> -	req.link.cmd = OCTEP_CTRL_NET_CMD_GET;
> +static int send_mbox_req(struct octep_device *oct,

why it's not prefixed with octep_ ?

> +			 struct octep_ctrl_net_wait_data *d,
> +			 bool wait_for_response)
> +{
> +	int err, ret;
>  
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
> -	msg.msg = &req;
> -	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> -	if (err)
> +	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &d->msg, 1);
> +	if (err < 0)
>  		return err;
>  
> -	resp = (struct octep_ctrl_net_h2f_resp *)&req;
> -	return resp->link.state;
> +	if (!wait_for_response)
> +		return 0;
> +
> +	d->done = 0;
> +	INIT_LIST_HEAD(&d->list);
> +	list_add_tail(&d->list, &oct->ctrl_req_wait_list);
> +	ret = wait_event_interruptible_timeout(oct->ctrl_req_wait_q,
> +					       (d->done != 0),
> +					       jiffies + msecs_to_jiffies(500));
> +	list_del(&d->list);
> +	if (ret == 0 || ret == 1)
> +		return -EAGAIN;
> +
> +	/**
> +	 * (ret == 0)  cond = false && timeout, return 0
> +	 * (ret < 0) interrupted by signal, return 0
> +	 * (ret == 1) cond = true && timeout, return 1
> +	 * (ret >= 1) cond = true && !timeout, return 1
> +	 */
> +
> +	if (d->data.resp.hdr.s.reply != OCTEP_CTRL_NET_REPLY_OK)
> +		return -EAGAIN;
> +
> +	return 0;
>  }
>  
> -void octep_set_link_status(struct octep_device *oct, bool up)
> +int octep_ctrl_net_init(struct octep_device *oct)
>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_mbox_msg msg = {};
> +	struct pci_dev *pdev = oct->pdev;
> +	struct octep_ctrl_mbox *ctrl_mbox;
> +	int ret;
> +
> +	init_waitqueue_head(&oct->ctrl_req_wait_q);
> +	INIT_LIST_HEAD(&oct->ctrl_req_wait_list);
> +
> +	/* Initialize control mbox */
> +	ctrl_mbox = &oct->ctrl_mbox;
> +	ctrl_mbox->barmem = CFG_GET_CTRL_MBOX_MEM_ADDR(oct->conf);
> +	ret = octep_ctrl_mbox_init(ctrl_mbox);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
> +		return ret;
> +	}
> +	oct->ctrl_mbox_ifstats_offset = ctrl_mbox->barmem_sz;
> +
> +	return 0;
> +}
>  
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> -	req.link.cmd = OCTEP_CTRL_NET_CMD_SET;
> -	req.link.state = (up) ? OCTEP_CTRL_NET_STATE_UP : OCTEP_CTRL_NET_STATE_DOWN;
> +int octep_ctrl_net_get_link_status(struct octep_device *oct, int vfid)
> +{
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
> +	int err;
>  
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
> -	msg.msg = &req;
> -	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> +	init_send_req(&d.msg, (void *)req, state_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> +	req->link.cmd = OCTEP_CTRL_NET_CMD_GET;
> +	err = send_mbox_req(oct, &d, true);
> +	if (err < 0)
> +		return err;
> +
> +	return d.data.resp.link.state;
>  }
>  
> -void octep_set_rx_state(struct octep_device *oct, bool up)
> +int octep_ctrl_net_set_link_status(struct octep_device *oct, int vfid, bool up,
> +				   bool wait_for_response)
>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_mbox_msg msg = {};
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
>  
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
> -	req.link.cmd = OCTEP_CTRL_NET_CMD_SET;
> -	req.link.state = (up) ? OCTEP_CTRL_NET_STATE_UP : OCTEP_CTRL_NET_STATE_DOWN;
> +	init_send_req(&d.msg, req, state_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> +	req->link.cmd = OCTEP_CTRL_NET_CMD_SET;
> +	req->link.state = (up) ? OCTEP_CTRL_NET_STATE_UP :
> +				OCTEP_CTRL_NET_STATE_DOWN;
>  
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
> -	msg.msg = &req;
> -	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> +	return send_mbox_req(oct, &d, wait_for_response);
>  }
>  
> -int octep_get_mac_addr(struct octep_device *oct, u8 *addr)
> +int octep_ctrl_net_set_rx_state(struct octep_device *oct, int vfid, bool up,
> +				bool wait_for_response)
>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_net_h2f_resp *resp;
> -	struct octep_ctrl_mbox_msg msg = {};
> -	int err;
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
> +
> +	init_send_req(&d.msg, req, state_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
> +	req->link.cmd = OCTEP_CTRL_NET_CMD_SET;
> +	req->link.state = (up) ? OCTEP_CTRL_NET_STATE_UP :
> +				OCTEP_CTRL_NET_STATE_DOWN;
>  
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
> -	req.link.cmd = OCTEP_CTRL_NET_CMD_GET;
> +	return send_mbox_req(oct, &d, wait_for_response);
> +}
> +
> +int octep_ctrl_net_get_mac_addr(struct octep_device *oct, int vfid, u8 *addr)
> +{
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
> +	int err;
>  
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
> -	msg.msg = &req;
> -	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> -	if (err)
> +	init_send_req(&d.msg, req, mac_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
> +	req->link.cmd = OCTEP_CTRL_NET_CMD_GET;
> +	err = send_mbox_req(oct, &d, true);
> +	if (err < 0)
>  		return err;
>  
> -	resp = (struct octep_ctrl_net_h2f_resp *)&req;
> -	memcpy(addr, resp->mac.addr, ETH_ALEN);
> +	memcpy(addr, d.data.resp.mac.addr, ETH_ALEN);
>  
> -	return err;
> +	return 0;
>  }
>  
> -int octep_set_mac_addr(struct octep_device *oct, u8 *addr)
> +int octep_ctrl_net_set_mac_addr(struct octep_device *oct, int vfid, u8 *addr,
> +				bool wait_for_response)
>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_mbox_msg msg = {};
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
>  
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
> -	req.mac.cmd = OCTEP_CTRL_NET_CMD_SET;
> -	memcpy(&req.mac.addr, addr, ETH_ALEN);
> +	init_send_req(&d.msg, req, mac_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
> +	req->mac.cmd = OCTEP_CTRL_NET_CMD_SET;
> +	memcpy(&req->mac.addr, addr, ETH_ALEN);
>  
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
> -	msg.msg = &req;
> -
> -	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> +	return send_mbox_req(oct, &d, wait_for_response);
>  }
>  
> -int octep_set_mtu(struct octep_device *oct, int mtu)
> +int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu,
> +			   bool wait_for_response)
>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_mbox_msg msg = {};
> -
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MTU;
> -	req.mtu.cmd = OCTEP_CTRL_NET_CMD_SET;
> -	req.mtu.val = mtu;
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
>  
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MTU_REQ_SZW;
> -	msg.msg = &req;
> +	init_send_req(&d.msg, req, mtu_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MTU;
> +	req->mtu.cmd = OCTEP_CTRL_NET_CMD_SET;
> +	req->mtu.val = mtu;
>  
> -	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> +	return send_mbox_req(oct, &d, wait_for_response);
>  }
>  
> -int octep_get_if_stats(struct octep_device *oct)
> +int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid)
>  {
>  	void __iomem *iface_rx_stats;
>  	void __iomem *iface_tx_stats;
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_mbox_msg msg = {};
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
>  	int err;
>  
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
> -	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
> -	req.get_stats.offset = oct->ctrl_mbox_ifstats_offset;
> -
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_GET_STATS_REQ_SZW;
> -	msg.msg = &req;
> -	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> -	if (err)
> +	init_send_req(&d.msg, req, get_stats_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
> +	req->get_stats.offset = oct->ctrl_mbox_ifstats_offset;
> +	err = send_mbox_req(oct, &d, true);
> +	if (err < 0)
>  		return err;
>  
>  	iface_rx_stats = oct->ctrl_mbox.barmem + oct->ctrl_mbox_ifstats_offset;
> @@ -144,51 +209,115 @@ int octep_get_if_stats(struct octep_device *oct)
>  	memcpy_fromio(&oct->iface_rx_stats, iface_rx_stats, sizeof(struct octep_iface_rx_stats));
>  	memcpy_fromio(&oct->iface_tx_stats, iface_tx_stats, sizeof(struct octep_iface_tx_stats));
>  
> -	return err;
> +	return 0;
>  }
>  
> -int octep_get_link_info(struct octep_device *oct)
> +int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid)
>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
>  	struct octep_ctrl_net_h2f_resp *resp;
> -	struct octep_ctrl_mbox_msg msg = {};
>  	int err;
>  
> -	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
> -	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
> -
> -	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> -	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
> -	msg.msg = &req;
> -	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> -	if (err)
> +	init_send_req(&d.msg, req, link_info_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
> +	req->link_info.cmd = OCTEP_CTRL_NET_CMD_GET;
> +	err = send_mbox_req(oct, &d, true);
> +	if (err < 0)
>  		return err;
>  
> -	resp = (struct octep_ctrl_net_h2f_resp *)&req;
> +	resp = &d.data.resp;
>  	oct->link_info.supported_modes = resp->link_info.supported_modes;
>  	oct->link_info.advertised_modes = resp->link_info.advertised_modes;
>  	oct->link_info.autoneg = resp->link_info.autoneg;
>  	oct->link_info.pause = resp->link_info.pause;
>  	oct->link_info.speed = resp->link_info.speed;
>  
> -	return err;
> +	return 0;
>  }
>  
> -int octep_set_link_info(struct octep_device *oct, struct octep_iface_link_info *link_info)
> +int octep_ctrl_net_set_link_info(struct octep_device *oct, int vfid,
> +				 struct octep_iface_link_info *link_info,
> +				 bool wait_for_response)
>  {
> -	struct octep_ctrl_net_h2f_req req = {};
> -	struct octep_ctrl_mbox_msg msg = {};
> +	struct octep_ctrl_net_wait_data d = {0};
> +	struct octep_ctrl_net_h2f_req *req = &d.data.req;
> +
> +	init_send_req(&d.msg, req, link_info_sz, vfid);
> +	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
> +	req->link_info.cmd = OCTEP_CTRL_NET_CMD_SET;
> +	req->link_info.info.advertised_modes = link_info->advertised_modes;
> +	req->link_info.info.autoneg = link_info->autoneg;
> +	req->link_info.info.pause = link_info->pause;
> +	req->link_info.info.speed = link_info->speed;
> +
> +	return send_mbox_req(oct, &d, wait_for_response);
> +}
> +
> +static int process_mbox_req(struct octep_device *oct,
> +			    struct octep_ctrl_mbox_msg *msg)
> +{
> +	return 0;

? if it's going to be filled on later patch, add it there.

> +}
> +
> +static int process_mbox_resp(struct octep_device *oct,

s/int/void

> +			     struct octep_ctrl_mbox_msg *msg)
> +{
> +	struct octep_ctrl_net_wait_data *pos, *n;
> +
> +	list_for_each_entry_safe(pos, n, &oct->ctrl_req_wait_list, list) {
> +		if (pos->msg.hdr.s.msg_id == msg->hdr.s.msg_id) {
> +			memcpy(&pos->data.resp,
> +			       msg->sg_list[0].msg,
> +			       msg->hdr.s.sz);
> +			pos->done = 1;
> +			wake_up_interruptible_all(&oct->ctrl_req_wait_q);
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)

s/int/void

> +{
> +	static u16 msg_sz = sizeof(union octep_ctrl_net_max_data);
> +	union octep_ctrl_net_max_data data = {0};
> +	struct octep_ctrl_mbox_msg msg = {0};
> +	int ret;
> +
> +	msg.hdr.s.sz = msg_sz;
> +	msg.sg_num = 1;
> +	msg.sg_list[0].sz = msg_sz;
> +	msg.sg_list[0].msg = &data;
> +	while (true) {
> +		/* mbox will overwrite msg.hdr.s.sz so initialize it */
> +		msg.hdr.s.sz = msg_sz;
> +		ret = octep_ctrl_mbox_recv(&oct->ctrl_mbox,
> +					   (struct octep_ctrl_mbox_msg *)&msg,
> +					   1);
> +		if (ret <= 0)
> +			break;

wouldn't it be better to return error and handle this accordingly on callsite?

> +
> +		if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ)
> +			process_mbox_req(oct, &msg);
> +		else if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
> +			process_mbox_resp(oct, &msg);
> +	}
> +
> +	return 0;
> +}
> +

(...)

>  static const char *octep_devid_to_str(struct octep_device *oct)
> @@ -956,7 +935,6 @@ static const char *octep_devid_to_str(struct octep_device *oct)
>   */
>  int octep_device_setup(struct octep_device *oct)
>  {
> -	struct octep_ctrl_mbox *ctrl_mbox;
>  	struct pci_dev *pdev = oct->pdev;
>  	int i, ret;
>  
> @@ -993,18 +971,9 @@ int octep_device_setup(struct octep_device *oct)
>  
>  	oct->pkind = CFG_GET_IQ_PKIND(oct->conf);
>  
> -	/* Initialize control mbox */
> -	ctrl_mbox = &oct->ctrl_mbox;
> -	ctrl_mbox->barmem = CFG_GET_CTRL_MBOX_MEM_ADDR(oct->conf);
> -	ret = octep_ctrl_mbox_init(ctrl_mbox);
> -	if (ret) {
> -		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
> -		goto unsupported_dev;
> -	}
> -	oct->ctrl_mbox_ifstats_offset = OCTEP_CTRL_MBOX_SZ(ctrl_mbox->h2fq.elem_sz,
> -							   ctrl_mbox->h2fq.elem_cnt,
> -							   ctrl_mbox->f2hq.elem_sz,
> -							   ctrl_mbox->f2hq.elem_cnt);
> +	ret = octep_ctrl_net_init(oct);
> +	if (ret)
> +		return ret;

if it's the end of func then you could just

	return octep_ctrl_net_init(oct);

>  
>  	return 0;
>  
> @@ -1034,7 +1003,7 @@ static void octep_device_cleanup(struct octep_device *oct)
>  		oct->mbox[i] = NULL;
>  	}
>  
> -	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
> +	octep_ctrl_net_uninit(oct);
>  
>  	oct->hw_ops.soft_reset(oct);
>  	for (i = 0; i < OCTEP_MMIO_REGIONS; i++) {
> @@ -1145,7 +1114,8 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	netdev->max_mtu = OCTEP_MAX_MTU;
>  	netdev->mtu = OCTEP_DEFAULT_MTU;
>  
> -	err = octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
> +	err = octep_ctrl_net_get_mac_addr(octep_dev, OCTEP_CTRL_NET_INVALID_VFID,
> +					  octep_dev->mac_addr);
>  	if (err) {
>  		dev_err(&pdev->dev, "Failed to get mac address\n");
>  		goto register_dev_err;
> -- 
> 2.36.0
> 
