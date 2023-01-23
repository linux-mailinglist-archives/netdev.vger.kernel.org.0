Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B36788AC
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjAWUvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjAWUvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:51:08 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8909A33476;
        Mon, 23 Jan 2023 12:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674507065; x=1706043065;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wch3fhSPrU6ja15nPwNjrsokw1vuXZlOb/LfSKk4eys=;
  b=XBPc5JXAKGKulppBDZJm1KPvMWFswgDJrUQ0Axgcm7cimT+uO3IuMuCG
   lsGYCSwc2fDHyGEI7KcgTp9t/0+ujBRykkHGZlC+1NXFOxQ7Q/A4z2IUF
   lU9lHGSTddtpWRBTI12pWudnjeojxq422KpyfwI1SL74Q66HeIdRNRuZy
   ttd9ykFasbDIVgcz3dP9DdQid55iUnH5KsUeGUlSqbWlIkz3yyIt8FFLQ
   g2HTsNWjR9PNZBjG71qNfUpu7eA6cRYWdSG88DAFvI7JwZKRXGd8x9zOX
   OfSS9FcwFN3xoupsOn0K5E0PCQ8MlFbu0/xVM6lFk4Nn01xxmhOwFQfSG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="314043940"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="314043940"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 12:51:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="655163371"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="655163371"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 23 Jan 2023 12:51:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 12:51:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 12:51:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 23 Jan 2023 12:51:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 23 Jan 2023 12:51:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erN8cY2ngWhpKA8FRUc6IG5z58d1idmNHGTbYSerPirdW8KGVwb0Q0MMx38fI96n1WqStJZwi/WL0WBPAZ+yMTU1gRj3deEBO5DRlwEzPhz9yN2l1/zc99UxyEBRIPVFA0lJSrUpsnwKwnIi8ujpRaqImqnSnJuuDuIRy0LRJrhOND2umu2YnV9AAG1xJ5M7U9UcSocWgHQDi8bWMLJBvaujiOieLnc8bir5ibK+P/g4MCzANyrDqdEEHF3MpRqXyTPj1v8JeO5wbXgpTKG0MLwu4n5qiE96aD+tSnozuRJtnnIzI2NYkWWE5k7EaUgASgY4dQLf7LyqAMflc8HMRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=De2U4/v80nL/Cl6qXqgV078b1PxrmKfcN+rLrErdx2I=;
 b=i1koApZZVtkvbJp0fildIJlEBswWxepDbUfWJN4c0RzFZkS6F+PWyC0KhHH4kJnyUHmyTg+kkJKGmForBH6uE1e26jyw1DqeYjV5003rYdwzXBD/zAhBWOIubl0DLcopskRmqXQr7Uy43SfheI6/WoAgxYkaUbLqnez6T7T2dQjqR0l/ELEmI6SdBtX3wBbmimuiBeRzU/HfFrpF25DBIP7k9UjtWkC9oT+1bZ3U8PWZ2Nyew0eRQVcm9QFwSNM4FFOdP+snkz4SxTX9hF8WyyNltfWD8Ih/9cNUP+9omb3J105kaW4FnB4gOYVcjZzOQvLjRnCCzbyDO9o64paPGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6954.namprd11.prod.outlook.com (2603:10b6:510:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 20:50:55 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 20:50:55 +0000
Date:   Mon, 23 Jan 2023 12:50:52 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>
CC:     <nvdimm@lists.linux.dev>, <lsf-pc@lists.linuxfoundation.org>,
        <linux-rdma@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>,
        <dri-devel@lists.freedesktop.org>, Ming Lei <ming.lei@redhat.com>,
        <linux-block@vger.kernel.org>, <linux-mm@kvack.org>,
        <iommu@lists.linux.dev>, <netdev@vger.kernel.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Jason Gunthorpe via Lsf-pc" <lsf-pc@lists.linux-foundation.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [Lsf-pc] [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <63cef32cbafc3_3a36e529465@dwillia2-xfh.jf.intel.com.notmuch>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <63cee1d3eaaef_3a36e529488@dwillia2-xfh.jf.intel.com.notmuch>
 <Y87p9i0vCZo/3Qa0@casper.infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y87p9i0vCZo/3Qa0@casper.infradead.org>
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d7cdb1-0b72-4b3e-db45-08dafd8385a8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: meB/kCa5WAJ2u1PPqnnmd+a5omvH5uOIlK1ELbao1EKB3Qp6V9plBhmK9wIQq1BkEtrhoo/aU43ipyH79vRqoU2RIuQDf8bShllUQwUjmCND5jfV92sBh8DJe221ZC4z0pIz/oQLSrScdCdk6VorvlPQAzEuez7+KJHTPkrvtxbfEhIdUESeocKhuPANB5mcmNqeHkcUBVy43Lcv3fF0V6erEMwDiARI+ooARSl+2H2ywiSsLc2Pj46eOgu5mlrNpShcqkxjffAdn52FFJ3oeHiJxNI0IzLYs30QUv1AvPsJOOiLLC+7oMNoiqccBVCoF6B38OQc0spzxYrlgsIeYLDVprqo+W0SPlEikG9IklmnN9lQco8twvVtDiILUvl7kQIdJTbrX5ITgdAL7/clOOgC3s2yl5a7ImvhZIekJJGGgMpEAAxWAr+7uBDUuvMk2Brngr/dHyZAP8odFTZVQwNDg+h0Myx9utlXf5FG5xovHeGcW5U5CDhK0r42SEBqA+TgUBUm/HxVjxNa1ji/oxRFELE+1HUfbG05O6ph05wOwfCS+yKOHStdCMI1rEQ1WjhUa3Pg5VGdsI1oqmOgru5GSpcBurV1XB8GP0/fS6/b8KpGVvpETWcrQZ7Z3WRYhWcSoEBLY9HuZl8DzK2gD72d0h9WyLiO9hEw6UEYT/WJFouVEZbKy6OdU53BOtAyOWzSF2PmbtO0smms6htsRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(2906002)(41300700001)(8936002)(66946007)(66476007)(66556008)(7416002)(5660300002)(4744005)(54906003)(316002)(110136005)(966005)(6486002)(6666004)(6512007)(9686003)(6506007)(26005)(478600001)(186003)(82960400001)(38100700002)(8676002)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hmeaceUeHBoUQYF3ljb1t96FAcNUCpK5yvUetbU+oatfmEGi4Z1VmS0vvW5E?=
 =?us-ascii?Q?oiBCgIsSvxWoLCPmWhdbzE9Mk7D7N1QlOoiTHt4x7FWoufM8Rp2GcmgxaH5f?=
 =?us-ascii?Q?X1LnaCeC0H1Zg7j30ZDh6N+AXmtq+BTUPby8+sd7OGZmo2evSrYEzXzibDku?=
 =?us-ascii?Q?rO9cpWxozavhGIZ9cf3qyvJOoZdRYqxZDhxE1xFuyy+dEHBT5/bcYbfT4sdi?=
 =?us-ascii?Q?eiINUqfZmp9DideQTlrcZCqPZYBeAZ1L9haMBstJ97PH1QkFpgth99OHd15R?=
 =?us-ascii?Q?8F+YqWSbe/FY88InLXbx5TrKkbuAFVj2pAP8KxNJ6bQjhKGAqrb9El8mvZfI?=
 =?us-ascii?Q?Jg5Wyza0Bg8HeXVW1t15onF3ipgBAQ5PaIeXmSMbi8QPbjvA/B5EFopZkgA2?=
 =?us-ascii?Q?gK5VHpAvZCloQfEfgcB8f6KD7wfA6lh2hJKBaXbtTw4HDdJo7SK7znDkdW0M?=
 =?us-ascii?Q?oeD9wnMFGNqjmcC8F055PcpG8zKYh+3jeEA73PoYAGFU/EiD3/kxn4hKSlWu?=
 =?us-ascii?Q?fJ7AzORMGdFn27py6pd95qX7tYxZo5urPD0oUa2BlaGPFUs58xZ21F+/EKuM?=
 =?us-ascii?Q?S7PyFn9S6k/Rn6Cm3/oc9SC1LQHd8ySOjYvadt0YmFV53G7z3i2HTCzzCBUl?=
 =?us-ascii?Q?6VzaMoJbPvynWeX2+hY6taI/RgG9cvZhFy4Zm6FZf0bFahoQ8peSYSE+4bnK?=
 =?us-ascii?Q?WZsQmgWmHjpBfKQ83OL7mhYAw9jCaxnNUD4a4hJOYjNxms81TbDvVy+xs3PP?=
 =?us-ascii?Q?NcQ1QmptekZpfTOj+x0lMBFOKQ46KIQW2ov+mifVpApRACM1s/j1Cok/Wpej?=
 =?us-ascii?Q?VwwbQY8ofcCwkvkfx8FPueMO6zGJ6glKDz71Ksmx0+1Eh+OmYP5qh4qNayYB?=
 =?us-ascii?Q?k0x9y642GsqJTCZkaf1ss3e75syTS/oUfWxPNIW3VYQEDSV9x9QTYLLnah/t?=
 =?us-ascii?Q?by8ycOUyCt69x2gRC3BO5CgVbTQ+0ljJiE9hLL3dmM3NzEnu4+5J882b4Lgi?=
 =?us-ascii?Q?h1r9kLB8VmtaXYt57Mb0bqFA1eKiuacZAGtNSmFRuZXTlJo5QvRfVQqSiGyZ?=
 =?us-ascii?Q?RTcYk4OFl0zMIXetzuu40VM3fIljJQamvs5WCeIYBbtMaTn/mibYnTwX2AuO?=
 =?us-ascii?Q?S7HY7pkGSVKD9fnc9vGa9WVevkLAyf7NW5ma0wLIWpy8RQnFQpDNO5ivf5Ps?=
 =?us-ascii?Q?KWLY0iKMZShtprLNPhbUtFD2In9y9EucnrnClaQrpJ7x3SXi+vEqVCo1Kqhm?=
 =?us-ascii?Q?837oZy8F5Btdha4Hbvl1L+oq4rqEbDosOOCyjOM8uT39nl14xqNLuO8BwG4h?=
 =?us-ascii?Q?XL/1dO0C9eBZzXA8xIcLVwChQlmUtCpouuwkfak8Aspkbe3w8ujtXU1D1Hn0?=
 =?us-ascii?Q?rsDCPel2TiLKLqPsGW2oiP/jwAN1B0nh3iLIISRIB8YA86FysKXSUEXInZnp?=
 =?us-ascii?Q?jem3kXlUuY2dGLdMJEV8Zt7NFfAFwb7kR2lV35vK6vTH6QV91ecLx1kULqYe?=
 =?us-ascii?Q?lfBGzvbfU/dH6IGCtBf0NQ6wvs8fo2VedLhnsxElx7sozHPDNEG0UJ2tP0By?=
 =?us-ascii?Q?FO4PTGh5y8LS7BNywLqpDrqgqJYNj4tc723zfmJJsCJLwrUKpGhzNkVjkXCJ?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d7cdb1-0b72-4b3e-db45-08dafd8385a8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 20:50:55.2888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/D0Otf1JxJUHUpX+E6+jFl3rC5Q6izt5iti4xvyh6eh1GKqQt7CxzkNKbjQfaunIKhaz/owagKKSEB2tWmaKOi6EjJ7hlx7bpY2NAQxEf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6954
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

Matthew Wilcox wrote:
> On Mon, Jan 23, 2023 at 11:36:51AM -0800, Dan Williams wrote:
> > Jason Gunthorpe via Lsf-pc wrote:
> > > I would like to have a session at LSF to talk about Matthew's
> > > physr discussion starter:
> > > 
> > >  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> > > 
> > > I have become interested in this with some immediacy because of
> > > IOMMUFD and this other discussion with Christoph:
> > > 
> > >  https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
> > 
> > I think this is a worthwhile discussion. My main hangup with 'struct
> > page' elimination in general is that if anything needs to be allocated
> 
> You're the first one to bring up struct page elimination.  Neither Jason
> nor I have that as our motivation.

Oh, ok, then maybe I misread the concern in the vfio discussion. I
thought the summary there is debating the ongoing requirement for
'struct page' for P2PDMA?
