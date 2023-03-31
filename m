Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660046D2468
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjCaPti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjCaPta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:49:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C787B20C1B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:49:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqQWthoHWXK/mNfHKGpEW+m//seA1ROu6UsTwmZIr7JTjSHOcwEQkp4K6CrAV/RoOAFx+bM1lkLh7NOimusDIBMS8ErVs+wy2pzhwzjubA4A2IJFQvvX9QTCOdEjq/uavR71BOUlpc9EQOLKS+qaAeuqYbFSmQ4gHArYWrIPEjmaMvGPZILJwJMP+hYw/OolT3EK6184awcJd3nRKsStoDPXeF6Mo5zcyaMcAS30HEJN+q3UYkbSqhx6urlY5XXpUJEQ6v6jWsjIN+JxSFVcpmzPJ1EpMiSA3sjf10K4ywuFy+jWNXBo5n9BwejJEGHIc5iHmofYRtxzR7TlQAAyXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lh1tIdbqO97iPLYbdtCGuBjSoXbkKiGxrsy52NYxkWA=;
 b=TZDKu0YFUXTLhsBPyZrx9tMAeJnh9FZrWf4sWc2dbnNMguUBXQWfqD8Kt6qT00QXQPEaopMyzLmSz0IEryuc8nPwDVKfGMLMwzVXu9dSwyONj7PyPl9AQ4ziEd5JKYrqJIBpYVSDArz4eDQ+Q2IJu+47bJI5ZOTCWuBPmyXjQjqqzZdMy5a0Pvt/xdc4p9uarmo7QJGUNJX8q/uVPLjZAVX3R6tv+z7d/+I2XBKhoL/HhpM1sOI7ZKul9wvrBWUbRVhN5Jvea4vzNxSGpnYxFHX9AmN3yI+MR7ZjdcPwSMzAU8OX4/cMZ62TE7M8QH6r0nCK5425/1Vj7Cig/W7lyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lh1tIdbqO97iPLYbdtCGuBjSoXbkKiGxrsy52NYxkWA=;
 b=jJfqYDYNo5/ZrhHKluf0Neh9JQWOa0b+uCjgie6NPITLVOA/mBN/ucCc0hkLcXLCMrDGekiaXTHX1z/og+aPPEzB+4TjSxOVZA3O+FLtA/XYCOFvwmQuDfb3lMbTL9uWTVjU3o+pqcEGSQv6x7fS9g9toCfKSh+/RB2v2CCeqHs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5151.namprd13.prod.outlook.com (2603:10b6:408:152::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 15:49:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 15:49:20 +0000
Date:   Fri, 31 Mar 2023 17:49:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 07/15] idpf: configure
 resources for TX queues
Message-ID: <ZCcA+a/f+D5hu2GC@corigine.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-8-pavan.kumar.linga@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329140404.1647925-8-pavan.kumar.linga@intel.com>
X-ClientProxiedBy: AS4P189CA0037.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5151:EE_
X-MS-Office365-Filtering-Correlation-Id: 43629e8b-cb23-48a5-fb4a-08db31ff7dd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /TcypfBw/WqufUOANNKmMdTO2aAum9X/+oFjD8jG5Dk7O0oR2vS+//f8FvfT6zMo0QO3nVwq9jA+Bo6ZDg95gmK9QfEHTrldR63RQlPjiOqM0oKNdH2BVhlKu+Ok7WhRvn3127zhKZgFW73EUwMPofZyWp+Jq3gfBQJNxbJIrEDPUkzGb7Ew3rqbdfydS0AWw4WVCk0bLJXaLd23iFsrftaA43sRrN9OxSrIPrfxvwsY05vQLh+NDkXRho8xxklDLzP/K/sMYhafl2ujH267FfNVIrd1GyItFEOF/AL6o+H3N8JO2prtbtE+50mrsnbuIO8OEQ+FhGVDhbZMs3giPee/10H4irKCJ0aFHUdVm4c+zgufuFToDzexaSKYp5VDhExcfRd2+NJiQfP5m/CSZd3450UTloy8voPktgOkCB9ZknUYUphjQSSyn6JXjX2oMj8wzrPaPHMU7BHv/KuQvdf792dc/2xXYYjhQxxuYFlM6OAeVZjUVwsCx0Ab7PnQny5AzSUGNhGk9zYO80wPylSFcX2og8y4xyPPUqDzShpUl47EFfqL63GgQsv0qKeHzmKs07AS5Wg+QNvarRLaD0qI+5gIlRiHN1Z57SpfQwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(396003)(376002)(366004)(451199021)(478600001)(54906003)(316002)(83380400001)(2616005)(6512007)(6506007)(36756003)(186003)(38100700002)(86362001)(6666004)(6486002)(44832011)(6916009)(41300700001)(7416002)(4326008)(66476007)(66556008)(66946007)(8676002)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WCZdv5AfCF1k612g2awv5zwTbPKJ1qQ1LRe5slcu1FR2sJBK2Zc4BEpM1uBm?=
 =?us-ascii?Q?07PMLvOxFXy2PxPTMSkphCNM2uvRRwlbQQO9NICHNLiKMB6YOpz/J2uFhjGq?=
 =?us-ascii?Q?MizJ7rztHd4wbqIPSxT0kDoVp0OtJJaVjYaRYEYSyP1b+0uQhQJDdUhM61rc?=
 =?us-ascii?Q?rXGDLgUzOcjDmRAYqyc50FTMKLBr0xHVhMTJeVNQWEwQ2GIGOzW0Y5/o3x49?=
 =?us-ascii?Q?+2qyWMSwyIueTD20NrmSQgKUBn/oYJHf0jzNnloEKhtP9kdC8DEm0/KpdRWz?=
 =?us-ascii?Q?98s63X03blkhH03vxMJTfEEgsuL4ByRqeQeM+O37W4+UxfTBXTP+yq7e/hoq?=
 =?us-ascii?Q?6kfxvrWvBGytRs8N8ITU9DGTebicaJELBReIXm8gsi6tnVEfS1IZVtGpe4Le?=
 =?us-ascii?Q?5C1zzydLQ7PIW/crNlaNUuc9PkCNV/QtS3NLHZxkTEa1gh+KPq8u7v/mbaTg?=
 =?us-ascii?Q?apfT0vHoUGQzIYLnb2CWxE7ATxRZbPnlTD+JtDEKv6CLb8odEM+majz1jvYT?=
 =?us-ascii?Q?6fhNC7ha2d+7fjybsZdx4d5dJy1MvmUuoE4w1ez/rnGKHfAUR28oDv2Thjwj?=
 =?us-ascii?Q?w268m6QAyOSkP4xXOqVH7vwpBMj3/QnjFWvuVHJZ/SPEF9/EU9RzwcV6TfVD?=
 =?us-ascii?Q?Vli1YLMbXNJKtBXSBDnqwbtOVMTIbMU1m+sRZnbXekSlhp/8gdx3BVSFRywY?=
 =?us-ascii?Q?nS+783zvuzsUPJHK13bcm4auIVmbqtOh7iAk/auceSuRHqeDWINWphVKKnHI?=
 =?us-ascii?Q?J2OCXfpVdozEij+B/A805f+A8Iw6yChZDgFmqr32/uQAimNA/QOpUEZsZpGX?=
 =?us-ascii?Q?/8lgmEhZCAbuZbqt7I034Zdf8cSbdC3PvvnQfh8jSs6fc7wmlJhAhJnX9eT2?=
 =?us-ascii?Q?VD9J2rrY05R30Aky8BEVaBznNYXULCXriIOBEXyuMH6cg932XCR6zebS5ITL?=
 =?us-ascii?Q?0kNpGSDJfgQrXNHU/RCe+21wuNwpC8073ItxzOQwMnJD0PuBr9j7f9u++uLh?=
 =?us-ascii?Q?qQ3fN9dht5yEpbbTKiXvdcmBJc1l1pQuNmpV7UeCTJBF4Bx7Z2enGws+Vcwq?=
 =?us-ascii?Q?za1NhKufpS9YbVt7nsf9flqRdpEc3HSFEANGyX1QmKWKbYemYxJXMycvC4g2?=
 =?us-ascii?Q?MemDfU7mhAKqKfhhDtWu2G3kXXCAUboe+K6SQF8nJM4QhMhlX0JIQdQs1YVm?=
 =?us-ascii?Q?R7IP7J05ukUn/mmKa1K77aAojrJGZjZWfu2QFcWgLXl/hS//KvmP4sgR9PxF?=
 =?us-ascii?Q?Ndun74nV14kWgjJ67xP+xXkOt4UjDAeVyCWPMuTowgwXsrv+/wLzsuTgBKRA?=
 =?us-ascii?Q?BFz+1p+v8n76sefhJlbb55/cUweoMN8ksjaa7L3CjKl/SIuIchvTRK4ZV84Q?=
 =?us-ascii?Q?oudTJn8xWh0Be6duKT5n30zLSyooFWR9pw4419ecsiO9D2htrQyWzhQe8Rjw?=
 =?us-ascii?Q?UvumTYTOoc7ipoeRHZWYluWLBIFugeKgAxZj/v9IHGOC7+uHtfqJAwFlMdr2?=
 =?us-ascii?Q?4warNgnooiLfBGJBNEPSXvRLKaZwTwGalViM20XuFLoLbOzTGb/gE5+d8xi4?=
 =?us-ascii?Q?8zSI/dfQHRpTfd2WIVSCsv74ZHn41pGAL8PSaEXB0QOWpvPvO4L8Ggd6HO4b?=
 =?us-ascii?Q?iFbntGaxe06L2fUt0tHPh4hQk64kK0RzzrmVZ1Ov7sNDGLby9/XsxDMe0uf8?=
 =?us-ascii?Q?RwmbsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43629e8b-cb23-48a5-fb4a-08db31ff7dd3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:49:20.2563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3a7W8IOJWg7Eyeo2QESOqv1uRwZn/TjpVrjgc7FgVdtrhvc4pmwH857oowXfjoggt4sXebjPB+E8OqHwr+vWZAeTkxrL/i/BbvjIs7jhObg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5151
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:03:56AM -0700, Pavan Kumar Linga wrote:
> From: Alan Brady <alan.brady@intel.com>
> 
> IDPF supports two queue models i.e. single queue which is a traditional
> queueing model as well as split queue model. In single queue model,
> the same descriptor queue is used by SW to post descriptors to the HW,
> HW to post completed descriptors to SW. In split queue model, "TX Queues"
> are used to pass buffers from SW to HW and "TX Completion Queues"
> are used to post descriptor completions from HW to SW. Device supports
> asymmetric ratio of TX queues to TX completion queues. Considering
> this, queue group mechanism is used i.e. some TX queues are grouped
> together which will be serviced by only one TX completion queue
> per TX queue group.
> 
> Add all the resources required for the TX queues initialization.
> To start with, allocate memory for the TX queue groups, TX queues and
> TX completion queues. Then, allocate the descriptors for both TX and
> TX completion queues, and bookkeeping buffers for TX queues alone.
> Also, allocate queue vectors for the vport and initialize the TX queue
> related fields for each queue vector.
> 
> Initialize the queue parameters such as q_id, q_type and tail register
> offset with the info received from the device control plane (CP).
> Once all the TX queues are configured, send config TX queue virtchnl
> message to the CP with all the TX queue context information.
> 
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

Another spelling nit from me.

...

> diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h

...

> +/* queue associated with a vport */
> +struct idpf_queue {
> +	struct device *dev;		/* Used for DMA mapping */
> +	struct idpf_vport *vport;	/* Backreference to associated vport */
> +	struct idpf_txq_group *txq_grp;
> +	/* bufq: Used as group id, either 0 or 1, on clean bufq uses this
> +	 *       index to determine which group of refill queues to clean.
> +	 *       Bufqs are use in splitq only.
> +	 * txq: Index to map between txq group and hot path Tx ptrs stored in
> +	 *      vport. Used in both singleq/splitq
> +	 */
> +	u16 idx;
> +	/* Used for both queue models single and split. In splitq model relevant
> +	 * only to txq
> +	 */
> +	void __iomem *tail;
> +	/* Used in both singleq and splitq */
> +	struct idpf_tx_buf *tx_buf;
> +	u16 q_type;
> +	/* Queue id(Tx/Tx compl/Rx/Bufq) */
> +	u32 q_id;
> +	u16 desc_count;		/* Number of descriptors */
> +
> +	/* Relevant in both split & single txq & bufq */
> +	u16 next_to_use;
> +	/* In split q model only relevant for tx complq and rxq */
> +	u16 next_to_clean;	/* used in interrupt processing */
> +	/* Used only for Rx. In splitq model only relevant to rxq */
> +	u16 next_to_alloc;
> +	/* Generation bit check stored, as HW flips the bit at Queue end */
> +	DECLARE_BITMAP(flags, __IDPF_Q_FLAGS_NBITS);
> +
> +	/* Used for both queue models single and split. In splitq model relavant
> +	 * only to Tx compl Q and Rx compl Q
> +	 */

s/relavant/relevant/

...
