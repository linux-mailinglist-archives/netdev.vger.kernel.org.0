Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DDA6BD9AF
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 20:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjCPT61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 15:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjCPT6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 15:58:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FBFBBB07
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 12:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678996656; x=1710532656;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YHaZQNJFCEVmiUH4/Fy/E8o89DkcEu7XAp8SRbEw4c4=;
  b=P+kPvWJLyQYS496CohuRHfL1o0KJcdZpvJJ7zCLRMwA8yy0CuHdLM6B7
   WiKo/9+5DpwmvIRV8nW173RM/2v1itknh4henUmLlfgJRN79Nml7PCRyO
   qbom3t/NKfO/jEkxox8KoorUFkDkz7blX2onR4VDXwqKNDCUA3b/NQKxM
   5fGI219bJhx1nz7Qhe/R5Wi6tedoDElVe+IUF4mcep1vbeNT6KytXGRDq
   hNzQaU3b/3jAfBJzMyVCjT/jLPGaGcT+06CIQg1qQg/5znclLNUqBR0BQ
   S2Wv4T/vqtAJgcsrrHBT1la/BPJGBakGT9vpvOx6INgzCVQhC0neQAB2r
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317753477"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317753477"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 12:57:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="680020955"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="680020955"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 12:57:02 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 12:57:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 12:57:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 12:57:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCO1u/P2jPXl6g/QVRyk5rVmCxPgvn91FE5Yi8e1mzBPFeKaqcXN3dHaiEGvSgRz7BeUaC+ElaunA3FMEM305bwrYMMRAw32bSv+RojLgO8OVUs352rTHgg4fxBu99lNtPdmwmMs+aakR82I7QiwZbhN3Q5cdk8tD94e/FCZxqEmdMVv4tuwlFHaBn9lSo1Am5q5qD5ZQTUPQXhQDsTd79dEbOkeFT2XZfJn3gebYvYBSPE+k/T2wOk90ALiBccNdlmJYG4LpaB7N8grP+gRZ6SA1PBIcSlnRdyP4YiP222MJ8S2MTt2yykRxJuwJx3VclpGFEvuB3OmEOJWniFclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxYA4ZimMJwJ+yhb7eoyGK88pGvDHgVco0sEdX/uM44=;
 b=FtlLmlMlialUAIHOLuda732GmaL15LjEbmgkIV2I37krq4dw7bwZj34XIBxb0iC8rx25Y1BopYGiJeTaRBV0hel4AnH9TN2eXvbZBiNRyNBm2TnW5Q7ofFj20B2fQKsEoH+4gaTrlLott6Q2p6V+DKt1n694vQYEoCZiso4y0NAYAVJvgpcQ4tiuaBvjAqKoTLuPtgnDVGK9J87C/AHXTJDG6O1dhdMAixWHSdgWqgRHLdNRm5fiMYm4BnPGHl3uz11LL76AaT5/Ri8o3H0UCAXnenbq/faxlRiuPmoT8dS2OSIbYxD2WQ1htI3TZFQrZMlu7Zk1Mh/HWE3PzfGY1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SA1PR11MB6989.namprd11.prod.outlook.com (2603:10b6:806:2be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.23; Thu, 16 Mar 2023 19:56:53 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 19:56:53 +0000
Date:   Thu, 16 Mar 2023 20:56:39 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Shay Agroskin <shayagr@amazon.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Saeed Bshara" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v5 net-next 1/6] ethtool: Add support for configuring
 tx_push_buf_len
Message-ID: <ZBN0d8Rn2aib/Akx@localhost.localdomain>
References: <20230316142706.4046263-1-shayagr@amazon.com>
 <20230316142706.4046263-2-shayagr@amazon.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230316142706.4046263-2-shayagr@amazon.com>
X-ClientProxiedBy: DB6PR07CA0088.eurprd07.prod.outlook.com
 (2603:10a6:6:2b::26) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SA1PR11MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: 06a86bc9-1e6a-4c42-a927-08db265896c0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhjBhs5d+ugkcrEOYUko1ho721A3sZvyXb2DYbgbv63vfEo8WaHbMqzOkDRLnVWk9pXrO6kOceKpqlH4C1Jnh16r+HB8ppe4zyuE+iuVHfAD6MMFXu7GoK7P35CQ2mN6jBrXXAdqWTYtvFk1Aasnc++D7qkieSG5OLBSf8JevbfunIKzqIFLqq8A0cjOsJOfeuo/agcJ+WFeBG5xS5hMsNiZXB27e0vi7JyykhOiuTHJwhhJY4+Uf61tVQFNoQ4ATRNTZ+UZB+c7See6ldHViO2+rVsStw76vvY/By+QMX6x7BN0iC/b/+1bSatj19DIoXA/B/+ehKHw0VORC79fFN+0kIo/M1JXU2VOizmsjQYvTInSewGGqk9ZgxqJP15IY31OKtnDUFItmgRypOsjExGpq2rwQBxvNq9GhKQRaVBdR4qLvIGFKiuqGiDtUAi6FPrIN0RuCqaX0nE1q4f59rTkEu8U9nWOADNTfM7hDjEqSv42QSCTuk13iBF6Yf52x9mxqChv0G5Ql2yCH0eAta0emycTtJ16ryU8LbqU3uYfV92rduchwIrfQmiKPceoQbxRU0KHoU3q1xyI48QJET1uK9niaASyFazvZhtDYjEGNrk5EKQxs5GnVhNzrAZ1aG5tNmwOpt3u/9jjg44lnNe+5Ms7CLmgipbr9wh8V1/eYwIjF8zK0pnga05csaYUMbB1XgQf1Un5WXWnH+5cnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199018)(82960400001)(2906002)(83380400001)(7416002)(30864003)(8936002)(44832011)(54906003)(41300700001)(186003)(6916009)(66476007)(66946007)(316002)(38100700002)(8676002)(86362001)(9686003)(6486002)(6506007)(478600001)(6666004)(66556008)(26005)(4326008)(5660300002)(6512007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?efDKGSlobqm8M/IDvpsTupEcAu38eDGLDufPUXzeCqWisgBvLANDlMmqim8n?=
 =?us-ascii?Q?KoG60JL0qyt4ZL1SsdTMhBlFfokke0KRSllN3sXoiptKwLYOceYFVVNQe+Cl?=
 =?us-ascii?Q?MpKldUlmDKAm3ZGcw937XUam/UiWapyEBKYE5n4MpFDF25PqBbAPY7K3v4gr?=
 =?us-ascii?Q?tBebTdlZto0C3V0V8xBz3DgW6+/0dZOwgts57zzUlIP6bbf0x86u1JmwoX3Q?=
 =?us-ascii?Q?gm6sncX0KNdOZAjlaa5fAEXGmjrxlvsy6yQ4Xh8j44WbpLMd6RpE8esncSXZ?=
 =?us-ascii?Q?ESsAVrfdEal82Ds+IgWPyV01W7gnrk7VQYW8AihheKHrROAZueIOmVGa4mEg?=
 =?us-ascii?Q?d++l98oSHPMa8OWDevCKVx21+hqxwyovG6WQZ+2QfhtoTvLBK3B9Hz1LF4zl?=
 =?us-ascii?Q?tma7DO9+VvuiDTBD7pyBPGDqVh7gJitZr8Cim8d+8K/z61sbmcqaKfNkN4i6?=
 =?us-ascii?Q?qfic18+MFdauRw2kFXToNgxkD3D/0YMLVA2RBAbImji+TUAZqOhnlAZFYPnc?=
 =?us-ascii?Q?kHvXZerCbDh088LTZwQq9aP2xd7V+czrlSun9g5WFolUrvqf2cbiBQOZc9Og?=
 =?us-ascii?Q?dtn/EE5VR4EpbGmHs9RucuGn8F9pIeIW7WYvHMiBP7/qNgb9hKa10ZbemDiH?=
 =?us-ascii?Q?LbcqP6cNUcrjV2goKBEUBuU0jTAqeqfll4zIUD7Pxgcoqe9FykW6c2p1udlk?=
 =?us-ascii?Q?eGU0WjbGc5KO+FxgaXUKYWt36Sovo2DEg89VGOQkOs9dkkQL4xyNYMKIhPpP?=
 =?us-ascii?Q?21NvgBw5luF2XjQLT8tgTFmJSw4+gAmr9hgbkFLlu0nYjXK165gl0Y5cQ2WI?=
 =?us-ascii?Q?gvw2venbbPn/t43L5KeGWixCIZ6ChS50jFO6Slisrd2DHeJNMzYUbEEBO96I?=
 =?us-ascii?Q?Q+m8L6pACUrumXY/E3kuOimQdcGnpjZlF1BWGW4G35acbwfV5XqUteOl/n8f?=
 =?us-ascii?Q?RYhL0Tcgwyr5yEZierqUjAmjvkTZNUBAYre+ufOLRILiLUsyjEB/EvjacNVr?=
 =?us-ascii?Q?rUUjztjzXwWwck9pLD/Coc6+bWMeAkjhpZ9o44H2sCdb+vLnzIItjFy/olXT?=
 =?us-ascii?Q?oPua4cgmXhgXPK+EwajEuDGmZ0Ve2j/CdaIbB3nHcaDh1nyC5pDedEwHhdjb?=
 =?us-ascii?Q?m0BtwCzcOT9SE6zclcnof25mqZ17JbfzqB24fLeSi+dA+YUTiIuuKpQKOx/X?=
 =?us-ascii?Q?OI91Vhl33v4+yZxGxgvN1YFyTK2gqjC4voEhQWEhQt65weuXO8gZLY/fpDoi?=
 =?us-ascii?Q?M6ebmXIG1vaiqlp5XFtJs6i3Kx8IgoIMbeHR0E4YK9k8T3az5xnwAWYK07KL?=
 =?us-ascii?Q?qlPimX6BNrq/oN91IoCei62HhwRolEzj9eLASQ7G7BAQwb6jTgIOYopCeNg+?=
 =?us-ascii?Q?X1Sh9/nI06ZujJLG3lHp/7hYtza2NWorUsOQuhVGxAzpUJAFqHzSLw36T7Cp?=
 =?us-ascii?Q?kfF5EudSqs3W0XGbRcYUqmVLxsHgp8VrX4muRmExINQm1xn9Be7IjGN9Ck12?=
 =?us-ascii?Q?ulclDcu7VBV0ucoxpHXwZfJbzUSc9UwrSCfWrT2D8hRdO8p6jB3f0utHEz5u?=
 =?us-ascii?Q?1vhHDNPfxk6taU5F9AVj8bii5RyLI9G4w0W/vk03QKAqL3CvQm7Ezrnjv9UN?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a86bc9-1e6a-4c42-a927-08db265896c0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 19:56:53.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNJFXY8AT0lKz628ZfXYV6r49pAfFbcj35mqTlnczQWPDslTJ6UK226BtFP7k1qE2f9ZeXczyEKyLBBuVcpxgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6989
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 04:27:01PM +0200, Shay Agroskin wrote:
> This attribute, which is part of ethtool's ring param configuration
> allows the user to specify the maximum number of the packet's payload
> that can be written directly to the device.
> 
> Example usage:
>     # ethtool -G [interface] tx-push-buf-len [number of bytes]
> 
> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> ---
>  Documentation/netlink/specs/ethtool.yaml     |  8 ++++
>  Documentation/networking/ethtool-netlink.rst | 47 +++++++++++++-------
>  include/linux/ethtool.h                      | 14 ++++--
>  include/uapi/linux/ethtool_netlink.h         |  2 +
>  net/ethtool/netlink.h                        |  2 +-
>  net/ethtool/rings.c                          | 33 +++++++++++++-
>  6 files changed, 83 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
> index 18ecb7d90cbe..ea9b0cc10fdf 100644
> --- a/Documentation/netlink/specs/ethtool.yaml
> +++ b/Documentation/netlink/specs/ethtool.yaml
> @@ -165,6 +165,12 @@ attribute-sets:
>        -
>          name: rx-push
>          type: u8
> +      -
> +        name: tx-push-buf-len
> +        type: u32
> +      -
> +        name: tx-push-buf-len-max
> +        type: u32
>  
>    -
>      name: mm-stat
> @@ -311,6 +317,8 @@ operations:
>              - cqe-size
>              - tx-push
>              - rx-push
> +            - tx-push-buf-len
> +            - tx-push-buf-len-max
>        dump: *ring-get-op
>      -
>        name: rings-set
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index e1bc6186d7ea..cd0973d4ba01 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -860,22 +860,24 @@ Request contents:
>  
>  Kernel response contents:
>  
> -  ====================================  ======  ===========================
> -  ``ETHTOOL_A_RINGS_HEADER``            nested  reply header
> -  ``ETHTOOL_A_RINGS_RX_MAX``            u32     max size of RX ring
> -  ``ETHTOOL_A_RINGS_RX_MINI_MAX``       u32     max size of RX mini ring
> -  ``ETHTOOL_A_RINGS_RX_JUMBO_MAX``      u32     max size of RX jumbo ring
> -  ``ETHTOOL_A_RINGS_TX_MAX``            u32     max size of TX ring
> -  ``ETHTOOL_A_RINGS_RX``                u32     size of RX ring
> -  ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
> -  ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
> -  ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
> -  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
> -  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
> -  ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
> -  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
> -  ``ETHTOOL_A_RINGS_RX_PUSH``           u8      flag of RX Push mode
> -  ====================================  ======  ===========================
> +  =======================================   ======  ===========================
> +  ``ETHTOOL_A_RINGS_HEADER``                nested  reply header
> +  ``ETHTOOL_A_RINGS_RX_MAX``                u32     max size of RX ring
> +  ``ETHTOOL_A_RINGS_RX_MINI_MAX``           u32     max size of RX mini ring
> +  ``ETHTOOL_A_RINGS_RX_JUMBO_MAX``          u32     max size of RX jumbo ring
> +  ``ETHTOOL_A_RINGS_TX_MAX``                u32     max size of TX ring
> +  ``ETHTOOL_A_RINGS_RX``                    u32     size of RX ring
> +  ``ETHTOOL_A_RINGS_RX_MINI``               u32     size of RX mini ring
> +  ``ETHTOOL_A_RINGS_RX_JUMBO``              u32     size of RX jumbo ring
> +  ``ETHTOOL_A_RINGS_TX``                    u32     size of TX ring
> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN``            u32     size of buffers on the ring
> +  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``        u8      TCP header / data split
> +  ``ETHTOOL_A_RINGS_CQE_SIZE``              u32     Size of TX/RX CQE
> +  ``ETHTOOL_A_RINGS_TX_PUSH``               u8      flag of TX Push mode
> +  ``ETHTOOL_A_RINGS_RX_PUSH``               u8      flag of RX Push mode
> +  ``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN``       u32     size of TX push buffer
> +  ``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX``   u32     max size of TX push buffer
> +  =======================================   ======  ===========================
>  
>  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
>  page-flipping TCP zero-copy receive (``getsockopt(TCP_ZEROCOPY_RECEIVE)``).
> @@ -891,6 +893,18 @@ through MMIO writes, thus reducing the latency. However, enabling this feature
>  may increase the CPU cost. Drivers may enforce additional per-packet
>  eligibility checks (e.g. on packet size).
>  
> +``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN`` specifies the maximum number of bytes of a
> +transmitted packet a driver can push directly to the underlying device
> +('push' mode). Pushing some of the payload bytes to the device has the
> +advantages of reducing latency for small packets by avoiding DMA mapping (same
> +as ``ETHTOOL_A_RINGS_TX_PUSH`` parameter) as well as allowing the underlying
> +device to process packet headers ahead of fetching its payload.
> +This can help the device to make fast actions based on the packet's headers.
> +This is similar to the "tx-copybreak" parameter, which copies the packet to a
> +preallocated DMA memory area instead of mapping new memory. However,
> +tx-push-buff parameter copies the packet directly to the device to allow the
> +device to take faster actions on the packet.
> +
>  RINGS_SET
>  =========
>  
> @@ -908,6 +922,7 @@ Request contents:
>    ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
>    ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
>    ``ETHTOOL_A_RINGS_RX_PUSH``           u8      flag of RX Push mode
> +  ``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN``   u32     size of TX push buffer
>    ====================================  ======  ===========================
>  
>  Kernel checks that requested ring sizes do not exceed limits reported by
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 2792185dda22..798d35890118 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -75,6 +75,8 @@ enum {
>   * @tx_push: The flag of tx push mode
>   * @rx_push: The flag of rx push mode
>   * @cqe_size: Size of TX/RX completion queue event
> + * @tx_push_buf_len: Size of TX push buffer
> + * @tx_push_buf_max_len: Maximum allowed size of TX push buffer
>   */
>  struct kernel_ethtool_ringparam {
>  	u32	rx_buf_len;
> @@ -82,6 +84,8 @@ struct kernel_ethtool_ringparam {
>  	u8	tx_push;
>  	u8	rx_push;
>  	u32	cqe_size;
> +	u32	tx_push_buf_len;
> +	u32	tx_push_buf_max_len;
>  };
>  
>  /**
> @@ -90,12 +94,14 @@ struct kernel_ethtool_ringparam {
>   * @ETHTOOL_RING_USE_CQE_SIZE: capture for setting cqe_size
>   * @ETHTOOL_RING_USE_TX_PUSH: capture for setting tx_push
>   * @ETHTOOL_RING_USE_RX_PUSH: capture for setting rx_push
> + * @ETHTOOL_RING_USE_TX_PUSH_BUF_LEN: capture for setting tx_push_buf_len
>   */
>  enum ethtool_supported_ring_param {
> -	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
> -	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
> -	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),
> -	ETHTOOL_RING_USE_RX_PUSH    = BIT(3),
> +	ETHTOOL_RING_USE_RX_BUF_LEN		= BIT(0),
> +	ETHTOOL_RING_USE_CQE_SIZE		= BIT(1),
> +	ETHTOOL_RING_USE_TX_PUSH		= BIT(2),
> +	ETHTOOL_RING_USE_RX_PUSH		= BIT(3),
> +	ETHTOOL_RING_USE_TX_PUSH_BUF_LEN	= BIT(4),
>  };
>  
>  #define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index d39ce21381c5..1ebf8d455f07 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -357,6 +357,8 @@ enum {
>  	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
>  	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
>  	ETHTOOL_A_RINGS_RX_PUSH,			/* u8 */
> +	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,		/* u32 */
> +	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,		/* u32 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_RINGS_CNT,
> diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
> index f7b189ed96b2..79424b34b553 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -413,7 +413,7 @@ extern const struct nla_policy ethnl_features_set_policy[ETHTOOL_A_FEATURES_WANT
>  extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_HEADER + 1];
>  extern const struct nla_policy ethnl_privflags_set_policy[ETHTOOL_A_PRIVFLAGS_FLAGS + 1];
>  extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_HEADER + 1];
> -extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_RX_PUSH + 1];
> +extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX + 1];
>  extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
>  extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
>  extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
> diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
> index f358cd57d094..574a6f2e57af 100644
> --- a/net/ethtool/rings.c
> +++ b/net/ethtool/rings.c
> @@ -11,6 +11,7 @@ struct rings_reply_data {
>  	struct ethnl_reply_data		base;
>  	struct ethtool_ringparam	ringparam;
>  	struct kernel_ethtool_ringparam	kernel_ringparam;
> +	u32				supported_ring_params;
>  };
>  
>  #define RINGS_REPDATA(__reply_base) \
> @@ -32,6 +33,8 @@ static int rings_prepare_data(const struct ethnl_req_info *req_base,
>  
>  	if (!dev->ethtool_ops->get_ringparam)
>  		return -EOPNOTSUPP;
> +
> +	data->supported_ring_params = dev->ethtool_ops->supported_ring_params;
>  	ret = ethnl_ops_begin(dev);
>  	if (ret < 0)
>  		return ret;
> @@ -57,7 +60,9 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
>  	       nla_total_size(sizeof(u8))  +	/* _RINGS_TCP_DATA_SPLIT */
>  	       nla_total_size(sizeof(u32)  +	/* _RINGS_CQE_SIZE */
>  	       nla_total_size(sizeof(u8))  +	/* _RINGS_TX_PUSH */
> -	       nla_total_size(sizeof(u8)));	/* _RINGS_RX_PUSH */
> +	       nla_total_size(sizeof(u8))) +	/* _RINGS_RX_PUSH */
> +	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX_PUSH_BUF_LEN */
> +	       nla_total_size(sizeof(u32));	/* _RINGS_TX_PUSH_BUF_LEN_MAX */
>  }
>  
>  static int rings_fill_reply(struct sk_buff *skb,
> @@ -67,6 +72,7 @@ static int rings_fill_reply(struct sk_buff *skb,
>  	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
>  	const struct kernel_ethtool_ringparam *kr = &data->kernel_ringparam;
>  	const struct ethtool_ringparam *ringparam = &data->ringparam;
> +	u32 supported_ring_params = data->supported_ring_params;
>  
>  	WARN_ON(kr->tcp_data_split > ETHTOOL_TCP_DATA_SPLIT_ENABLED);
>  
> @@ -98,7 +104,12 @@ static int rings_fill_reply(struct sk_buff *skb,
>  	    (kr->cqe_size &&
>  	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, kr->cqe_size))) ||
>  	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, !!kr->tx_push) ||
> -	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, !!kr->rx_push))
> +	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, !!kr->rx_push) ||
> +	    ((supported_ring_params & ETHTOOL_RING_USE_TX_PUSH_BUF_LEN) &&
> +	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
> +			  kr->tx_push_buf_max_len) ||
> +	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,
> +			  kr->tx_push_buf_len))))
>  		return -EMSGSIZE;
>  
>  	return 0;
> @@ -117,6 +128,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
>  	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
>  	[ETHTOOL_A_RINGS_TX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
>  	[ETHTOOL_A_RINGS_RX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
> +	[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN]	= { .type = NLA_U32 },
>  };
>  
>  static int
> @@ -158,6 +170,14 @@ ethnl_set_rings_validate(struct ethnl_req_info *req_info,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN] &&
> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH_BUF_LEN)) {
> +		NL_SET_ERR_MSG_ATTR(info->extack,
> +				    tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN],
> +				    "setting tx push buf len is not supported");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	return ops->get_ringparam && ops->set_ringparam ? 1 : -EOPNOTSUPP;
>  }
>  
> @@ -189,6 +209,8 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
>  			tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
>  	ethnl_update_u8(&kernel_ringparam.rx_push,
>  			tb[ETHTOOL_A_RINGS_RX_PUSH], &mod);
> +	ethnl_update_u32(&kernel_ringparam.tx_push_buf_len,
> +			 tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN], &mod);
>  	if (!mod)
>  		return 0;
>  
> @@ -209,6 +231,13 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
>  		return -EINVAL;
>  	}
>  
> +	if (kernel_ringparam.tx_push_buf_len > kernel_ringparam.tx_push_buf_max_len) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN],
> +				    "Requested TX push buffer exceeds maximum");

Would it make sense to display this maximum value (tx_push_buf_max_len)
in the message to the user (for convenience)?

Thanks,
Michal

> +
> +		return -EINVAL;
> +	}
> +
>  	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
>  					      &kernel_ringparam, info->extack);
>  	return ret < 0 ? ret : 1;
> -- 
> 2.25.1
> 
