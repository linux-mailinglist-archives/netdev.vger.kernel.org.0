Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D5167867B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjAWTh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjAWThZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:37:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83B430E93;
        Mon, 23 Jan 2023 11:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674502643; x=1706038643;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fWE7fXUV3noQmhVatxVszEUWFlHGbLpp3PSDU8TVkTo=;
  b=cPibl0PP40vQCkEnDWQvBiSf8sFxvwzVYuMTzO/fa1hKoBazpVS1IfxA
   8yIRqkqc45QAxAwceYN90cC+rwLh3zu+7BJlCYuj3SPreFabS95mbMWXp
   Ock6+2+NYMKi9px3+4mD70gOrAy7q9NA9eOf/sXDa3NdJS8yjJ+eCucTM
   JU1L0+we8+rGI39AioJoW2jRDbS9JvK3ftqGJQqu1MPc/n5PRhNA0RLkd
   mrhyZ+C1tEvKkSJRy/1K8XC4ZyLQWEGTSAjlFirz4k2Mtg6hFBMzAbDzB
   t4R8v2lwVr6cQoAWItOOXv0L8fXiwG0C84fx2AdWJx8fu5aXFr/Dx8jIb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="353398268"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="353398268"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 11:37:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="835704957"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="835704957"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 23 Jan 2023 11:36:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 11:36:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 11:36:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 23 Jan 2023 11:36:59 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 23 Jan 2023 11:36:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpFn8bz7DGy/yi/hyGMHdK1rIYmQmPcPLB2PbTfOTPcekAF5eElkRNq5x7b+2Mmi4llM6X/aVBR8tgSG2AK0LZr55yolTw/qpSzUjGnUPqWueyykt/vZcXe12Fkd3BPnEDITZW9kQ4keQ99gxHj2KTzPrQWJWBeASf2HS7Bi7KY8d6V+JkC6tZV0KF8gcCdvzMObt9ov/Z5VCeB7C5AtE0YVnO3E4L/heSkOJOrRUI2noAltKw2ei1LtEqsxowYujLfWJk2dbEVyupKsFVQEFrG+PZcIkp+VMas31REu8YTxmixbFWKWipjMjxavnNPmsP7eXytGNvOSCpr9Z2hwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3OWV2qNjdtk6u1SAvuae1nuuT5C/EB8Evcd6w4YhHnY=;
 b=fgpJ+dBK+3jHc0f+bfqqUyZyjfFiptHWYQrxD0zrBuPGE3H2EZTQ0waRwnSES423MVaXv6j3WZ467uBEc3SMZ6pWff4cIUnXacTJdHeJMhbHPMd+W5+UubmTeUi05OLXZK1X5SD2R24WtNt4y1ePvfYCGHoN3gN++TXEMcQ4NAuQ7guqQ7YNheHdceG2J9Uiw/MNs6aMDNlduoPwH06fU4iZNioqy+NUftht+m6ZTv0qCQfg8dYyf828QzRedlG77Nn6hsaMCkh/zsJ6gw4RB2txhJqIG0NYIDalxJSvBDKoOu3v5FjGypbVcPF3gtZdEYPqXCXsuWljKC8eVa8ptw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BL1PR11MB5462.namprd11.prod.outlook.com (2603:10b6:208:31e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 19:36:54 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 19:36:54 +0000
Date:   Mon, 23 Jan 2023 11:36:51 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Jason Gunthorpe via Lsf-pc <lsf-pc@lists.linux-foundation.org>,
        <lsf-pc@lists.linuxfoundation.org>, <linux-mm@kvack.org>,
        <iommu@lists.linux.dev>, <linux-rdma@vger.kernel.org>
CC:     <nvdimm@lists.linux.dev>, <linux-rdma@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>, <linux-block@vger.kernel.org>,
        <linux-mm@kvack.org>, <dri-devel@lists.freedesktop.org>,
        <netdev@vger.kernel.org>, Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [Lsf-pc] [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <63cee1d3eaaef_3a36e529488@dwillia2-xfh.jf.intel.com.notmuch>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8v+qVZ8OmodOCQ9@nvidia.com>
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BL1PR11MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: 3129eca5-d5b5-4c94-912d-08dafd792ec1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6G2IM9r36nfqTkgrrMRqAdZugSY60YUNKe5iDMSCQ/60dqL2L6eiHbNkk+L9gINgHFv9lJTNg8jrS3t8CLRZMIQi+lq//9OvCYfe3Jvw6xtfJKHFt7eOOy/YgkoX2lJHscfwpGnpdeKhR0ZkdLk/U8kLTuUnNct8tc+kFfKNFEYaGPS43bcjTH9pXkiZP+tSqmy5TaGRS1dClW5Lnr+L/8h0BVT8saAGOLvf5leBpJ/8Zi2cF8fDH609P6d9aOYBYx049LPALukwAN4YM9L8S0iDRK5CZ9Bs+kLQpvHQyIDYS+5sCdSF0xoiULnxzdiZUrLE87xNoXDhvDXGwaPxawGxHw3LYNS+4Db+lkfwxPY8p1MikoYToxnUtwABTi39co8TcrthibugOXxvsegZCSvLoPL1/r2En73A9hfXBjyG9XzlvXmpW5lxM85v/H0iAEne4uRD+gupFf3lN1bydH1cE3904iesa0eGHKLV1ZVZtU7icfcaPm8poH9M6OujgwjaTOrkG3zvKf6uua1e1dHkTbO3CqaR9+ygojtBvpo1sAXyq4nDhZ3QkA7rfUxNWndurrGqHsxlxEj+W6wTF3M5cxTp7BBEDD10vdPspTjXmVFJmNs102Zych+lDPRntNRcGXvu9AfOQjxBxFrt5vZiwHZKXVDBv5UE/qk9htWyyD03GQ2yOCQNu5sGd8N/HvoHapBayFqQYz/WxgwHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199015)(66556008)(86362001)(66946007)(66476007)(8676002)(4326008)(316002)(54906003)(6506007)(6666004)(9686003)(26005)(186003)(6512007)(6486002)(478600001)(966005)(8936002)(7416002)(5660300002)(2906002)(41300700001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iFnT0yTiRsz75pCPonFuGUlUToHKQRPYkIeZBORevmdc2GAiFB5Ipe6FwDhu?=
 =?us-ascii?Q?7cGlqd7qdNmblXxqHbyjBQoW0aZp6vg1oKKUOw0WRinGcepejjBXwG7cJMLl?=
 =?us-ascii?Q?fqAv5SoanokTkwzVfUiSqwiHvAUZiqaap+qcwgzwnkLvuuyKkctRRDFxeBzb?=
 =?us-ascii?Q?rXe8gqN4LQmPvuqJX3hmQpYxWOuwE0PWM7JyLqCCcQpC836NLYOE5ZNt/1pr?=
 =?us-ascii?Q?8p1NjUPGavcgO8NGU+RcPwlQKbA/a7kV7Fb9UeDyK2oOaSIpYBJYvBpgvt5x?=
 =?us-ascii?Q?2FYGTgV3Tkq4kQgjvnC+9UNEMeVVnD668Lb0ObjrO6T0Jtn8APwrQ/T+lmTm?=
 =?us-ascii?Q?GFIPvdBwRr1IrMyI39ykolmkaubNRcEjrBCAYdtPpj/8Ix81GYt1g2UGCwQ7?=
 =?us-ascii?Q?M1OQ0ibO/j2lMk5hdMBiEiexEfaG/RYHvyW1+nUUdtZJkm5fjIShPMQKnFuf?=
 =?us-ascii?Q?JuU82yaUHgNyQitKqnO7UPS9KMZfiNuznQzUq9rEbP1k2k/1j3KBm6mfj0em?=
 =?us-ascii?Q?Qp2gBdhhx0Vyw2MC4iGOdSu+O0SV8ONYHM5oM1OKqwwLz/69/N3lUsD3JMqc?=
 =?us-ascii?Q?EX0eksn75enKvDPIZ/iOhwGSeaWWMl5jwxb+04S7FuCxB7EadX8yxL2mGxok?=
 =?us-ascii?Q?bKWgHOE4yAia3ihy6id5FAzWNOo/tBLxj3RgpXzGhWElIh5w8BSR0nplppnk?=
 =?us-ascii?Q?w/UI21bb4OVWM3Mp4RJBjIMpNwmyOPnZhVoqj5l2KP/VXLT5omPoulojKtlC?=
 =?us-ascii?Q?3TWef9nRL5XHdESKBsuxx5ld4g7jwAy7baEGMcYulIJd48ZFLYL9BQhPprNs?=
 =?us-ascii?Q?YwDrQQiGTwdLeBzpu7yNM8NneNV9dMPuNKbHTFyg0Qtdnj4cbsBacXiIDLC5?=
 =?us-ascii?Q?RUAT3km93Vc7lMaoovK+mCE4q4UU7bahkdBQVOj62IAbuSCZoikhgfMZlVyN?=
 =?us-ascii?Q?TkYuSQ6/a2QyByNaCD/ybZll1jS3qFm2+oxwPvdHA4V9B88lrfQROGt7Fs8a?=
 =?us-ascii?Q?UoZ/UJSwFucCkW/I4v9xDCoX415DteSydaCBH2nyFBAJLX/UQqpG7EL1njlq?=
 =?us-ascii?Q?9gH32sYE9uL9FSDQBcbrc0oqCl5KGNS0eIWiHcQjRl1d8CNN6+z5uHbtCgEV?=
 =?us-ascii?Q?nk4WIQ3Efm0PYxeLo2OiMQ0o0GA3IafG5iVC+I+OiCHIIwogH6zqKRGuc20J?=
 =?us-ascii?Q?gxbFbL+E07g+5j50HrKL/A9btDGr4FbNUMiOi4dVJYNKmfvMCHdS6m3DV8v7?=
 =?us-ascii?Q?YrsNDZLayYsXOfVh1xqVoP75JBiscsNrHkCgdQY6HL/gttP8ZDSb8YGRtD6d?=
 =?us-ascii?Q?QxthYbf+TIqsI6Vt3Exg/bJYKrs1lxvcA7xqQcaseJuaX473On/xBiU2ZYuO?=
 =?us-ascii?Q?GA0kDJcGdcb5Vj2Mjf/IvGi7SpvJHPDVKoPA4HtGI7N4eUVp/XXf+Zmbtn/Y?=
 =?us-ascii?Q?srpwkbqZsZjXZH9MCaJmUPBlPx30Xy7U5TCsbolK+suinjkCORK/AjnGpfsy?=
 =?us-ascii?Q?FKufIEs4uxXpIJnJORVajJKgDdof05xSUHZnUt53R0R+28RckCESnG4SmSuU?=
 =?us-ascii?Q?lI1xYOE9ifXRs2XqJAx1XohHO4yLCJgJq27R3bs/Dwi4wZCV7ySt2pkC898N?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3129eca5-d5b5-4c94-912d-08dafd792ec1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 19:36:54.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjGoPu0Qc9MhztxEeQB4dcqWJraLAsqfKAJ8uGdvKGNZsnZfZwFN0mMcv+vVBoUihvAxMvI1xuh9hsEf2Na7GAEJAMlEM+ESyfj0Wy5dQ6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5462
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

Jason Gunthorpe via Lsf-pc wrote:
> I would like to have a session at LSF to talk about Matthew's
> physr discussion starter:
> 
>  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> 
> I have become interested in this with some immediacy because of
> IOMMUFD and this other discussion with Christoph:
> 
>  https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/

I think this is a worthwhile discussion. My main hangup with 'struct
page' elimination in general is that if anything needs to be allocated
to describe a physical address for other parts of the kernel to operate
on it, why not a 'struct page'? There are of course several difficulties
allocating a 'struct page' array, but I look at subsection support and
the tail page space optimization work as evidence that some of the pain
can be mitigated, what more needs to be done? I also think this is
somewhat of a separate consideration than replacing a bio_vec with phyr
where that has value independent of the mechanism used to manage
phys_addr_t => dma_addr_t.

> Which results in, more or less, we have no way to do P2P DMA
> operations without struct page - and from the RDMA side solving this
> well at the DMA API means advancing at least some part of the physr
> idea.
> 
> So - my objective is to enable to DMA API to "DMA map" something that
> is not a scatterlist, may or may not contain struct pages, but can
> still contain P2P DMA data. From there I would move RDMA MR's to use
> this new API, modify DMABUF to export it, complete the above VFIO
> series, and finally, use all of this to add back P2P support to VFIO
> when working with IOMMUFD by allowing IOMMUFD to obtain a safe
> reference to the VFIO memory using DMABUF. From there we'd want to see
> pin_user_pages optimized, and that also will need some discussion how
> best to structure it.
> 
> I also have several ideas on how something like physr can optimize the
> iommu driver ops when working with dma-iommu.c and IOMMUFD.
> 
> I've been working on an implementation and hope to have something
> draft to show on the lists in a few weeks. It is pretty clear there
> are several interesting decisions to make that I think will benefit
> from a live discussion.
> 
> Providing a kernel-wide alternative to scatterlist is something that
> has general interest across all the driver subsystems. I've started to
> view the general problem rather like xarray where the main focus is to
> create the appropriate abstraction and then go about transforming
> users to take advatange of the cleaner abstraction. scatterlist
> suffers here because it has an incredibly leaky API, a huge number of
> (often sketchy driver) users, and has historically been very difficult
> to improve.

When I read "general interest across all the driver subsystems" it is
hard not to ask "have all possible avenues to enable 'struct page' been
exhausted?"

> The session would quickly go over the current state of whatever the
> mailing list discussion evolves into and an open discussion around the
> different ideas.

Sounds good to me.
