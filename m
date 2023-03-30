Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6CA6D0DBD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjC3S3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjC3S3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:29:44 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374932133
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:29:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDwHku8GFXQQghxLJDeO5V1jY4wsqyFFDVR510/YBXZkPtzxRbItFNnnHeyn0dTDbN+Oh2SYG4NjUlBnpdYN6YCgfDP7OPE1EoTkKqQ12XnPSGC9xrnotod9OJrzcJWUSLI6hK9eKXF2u147Uw+b5WNyEdVWXGeIFwob4xJsdSxZ4H0FVNWKKKhs9o7oWK0GEAfrnbKD7VNOVv8J+nW3QNcA22fy1KZdY2ZIm/6KrD9tKGIN/GXQwhAIPnOjR/qqLFUHcxF/BZZlnk2GNbXplL2p5mY+lFmLVNAn9ypZvsIU4admFucCp19W+/lUDrY5rXgdolz5LjrpnJ69lQL7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzUKB4lx+7A6tr5oPH9ZnV+KtvZ3QPf3ihiyPM1wZoU=;
 b=IYiJyjC0vnRDKnURymMEsqmnWIb8ABSvmrmy2UCmZ3o4H43PVGraRcaeawGs4doGXwNlXkcnt1BaYflDMXUarXfuOr/J9a9s3buSlwH9X9TIG5DR1D9v2ngIbCugTYjy3Dm/qcpXjypTZs/no4m9wdrt9GEVME7hxlvA0KDgxmByEppxzlgpJh3zqBE6EQm6j82t7QibgyJl11QZB8SnPXXrrrMKs/mUdmPpU7U+staJAKVCrRZhRhhgd4twQho8BFpePJGDMfNTNG+7ZoRXmTe0/jgCF3XV8dlp/2N0q3aJnaBWLyi+Pfi9xujttYS18E134cQLOFdhOshjpO5K3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzUKB4lx+7A6tr5oPH9ZnV+KtvZ3QPf3ihiyPM1wZoU=;
 b=bBVJ2hu5p0gf3DzeePg56RobjW3L+J6hFn3V8ZVJnZFq1/1wgjqRk11oZdUIclqIyG8OJDdXiiagshh4jMYYVX6ndJWyrimcsyXpPAolp/3htPknsarGORJFlJXzexLy47Juz+cwa3MBjI+Hl7+osBuW1HHSrwQwtoN31ETa5vnNgqdWQFEOMoJe9iCcpLQByjbSnMG0H9tbzPuMsMGPlFF55GWOU1b88zhgUPaVlP7seOLT40BeOE6+DZ5/IMHMugBhUgoM88sUcIc1zhq5zVo9IMfHvniO4pA57Fx6qL0nhC2/1OsSbUzNbgjXQsunFka4dysNZPec1kTM6oSqug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 18:29:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 18:29:40 +0000
Date:   Thu, 30 Mar 2023 15:29:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Message-ID: <ZCXVE9CuaMbY+Cdl@nvidia.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <ZCV6fZfuX5O8sRtA@nvidia.com>
 <20230330102505.6d3b88da@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330102505.6d3b88da@kernel.org>
X-ClientProxiedBy: BL1PR13CA0342.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4084:EE_
X-MS-Office365-Filtering-Correlation-Id: bbb5063f-dba0-4bcf-3615-08db314cb9cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XoHBNhLt6jDhjmo06/W+h4iJrYjnviPw+aZrBsU8ki9Y9cgqjynCla/Q/PoPJtztJTA6kBUiTMfqfuaHRdCZ1f+gZK5q83aTN5WC5TxeVhRdJX9GxiZKfGvVgfzpyr3HxsxA5y6tqCnX4++d3fcotbY1YwAaKeFLIaleVLs6SSH6Cikz22HIkRcTWEWpFajBwqoErMALfgPuli71Pn/t5taAPbWYHQ9nBIiOLgpa/ITjogEDI8GZDgsxVTRURHcVqdY/ZvhnSPbzuTJWexW3eXj7SEhLDZmTd4d2RMUjG3xbZmlYWI8HtjOEFxiIEmAhFUCs2Y/fzgfAd4kVqTkJEQk8NL8HmmNDp56TgunrO4fiDLMPEx/+EngErB1OkQWY//CqjIN+I5MoSVFgtXd8QNRixnVx8PfTaalGPTuB8SPi6TTt6IAvkEKv7+0xmILFLME+r/J1R8wyZZzJtKCz7zahbUXU85eA+svh/sgcCKWfFIpGjg/33dqfdpJtFkf+AJp1mfV5swtk2rVYY74HGS2lGyfbbnbi+brLZpnFz3XxtpnFET9SpAD54HouPab8Rq7SWGwtEPznuSyb4D29Roz6+7lpTbtaRPq1s8Ei8BM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199021)(83380400001)(26005)(66556008)(478600001)(316002)(7416002)(54906003)(66946007)(36756003)(66476007)(6916009)(86362001)(41300700001)(4326008)(6506007)(8676002)(6512007)(2616005)(186003)(6486002)(38100700002)(2906002)(5660300002)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T19uVoTU6G+hTdEOzaDDWa16/6uziUfDNFSLo6zd4mKQ3H3gyYpaKSp5BgU/?=
 =?us-ascii?Q?lpVlzeeHC+saFSbWCxCBjan3np3pewF/h/okXm4Kqu/eLvBApwEfMN4x/8YG?=
 =?us-ascii?Q?+F9R5ODRT7vO4LV7idomT7U93N9as+201wbNdN1c9leBVN3eqrAxv0ocNs8s?=
 =?us-ascii?Q?e75UWetk6ljXgRwj/UX9IZRzTTlbF68CPeUGZuZu2C43HdWXtC9o96FrV7LA?=
 =?us-ascii?Q?y723vb1s+4th2pihkCYEnn5rCxhspI6ez2u/4wG9DrjRCu/K7lZSoY4wj9Ut?=
 =?us-ascii?Q?ueB8e8dPhm+6r0KMViaALCsRsYPF3V2VBNCUNt63zByKXSbn+mDss4HVVevM?=
 =?us-ascii?Q?wR3RiuLBQK19E58jU6go4e+ANAqeteV2tjPW7XvqjvrV5Sct+9wn+6/DAfW+?=
 =?us-ascii?Q?v2NQv2zog8h0FCmkQdpeAi4GBC23BbCduTM5XA16hi6PrI7Fet+c8w8HMiz9?=
 =?us-ascii?Q?R97uTWvVHKiZf3fO+wl+uowaIhkwMg2p8Ex92SBfIFU+gy6iaRbutEqRP9Fl?=
 =?us-ascii?Q?kTR0e/ugj/VXkoVz10qoIJfSgrI6XTb956sjvj4TR52kwf6wqnFV2toBql9o?=
 =?us-ascii?Q?crCSFtoPDAYT18/Zzx5+aD3e7QGL8IWCxrxpnx9MMNrhsMYQTquS6x2ZyFyc?=
 =?us-ascii?Q?iKYnmCHmJclcpIIn0QXb5+5JMoZNqlsCYv09Gd0bjIhx9wGZisFeQFKctmK2?=
 =?us-ascii?Q?VEvMCTZgugJ0HwyJ0kc/wb1s6duUraygL9eQLufKWBCG8jfQx3xrvt8ZiNWS?=
 =?us-ascii?Q?D4YVrfn1hMXLGpelFZHLfnQt2iKIRf5vMezuCBNsXVupqO6pEnukcgBwELYt?=
 =?us-ascii?Q?MMKcfFb0XCnIU3+0qoTqscii/zUZPoLz7/rM71b0ElG8PRqb1ErtrAiUuMiY?=
 =?us-ascii?Q?+SIIcuYRiCQ6ZOshJfoCiPif+WDOAitqQIdpS0hIeHARyCvj6XzIyS2QxgSt?=
 =?us-ascii?Q?KFYWSuTJOu5lZXrGonK7VVbAX8QTei+1TBAdi+a2EQjR2eByyRDad5Zkcty3?=
 =?us-ascii?Q?zlS9SPRjXmwlqkyImaaClU6X3ar7kKm++Kbd3OUWQRTrOH2QOV2Ar3oUNQBX?=
 =?us-ascii?Q?Ivwrne0oD2gjOy8cQWUWcRjY0nQ9IrXrR9KKIJH5RYiG4eAlWzBMmH1QLCzC?=
 =?us-ascii?Q?YcpObPcWdgo9O42zydXx1ntOud0ksqOnV5DS7AsIbZMB48QAbJTwh54O88se?=
 =?us-ascii?Q?jpcWNwatgQ3i+u2dVcBFIR+KY7uRaIVurQmsAAK1k2GC5QCm9z1h1WXwMEES?=
 =?us-ascii?Q?VhQpUfan0Mgvd5HBatWKF9EkpX5c2pmU1QbIAyYPjK1OyLe3z0NilRO2jHkV?=
 =?us-ascii?Q?oJ4onDYEP8dl4yfJ96z4CgunTBPG2hBcc5q9j6zSsvlmvfbZr4YvkQfvw9L6?=
 =?us-ascii?Q?jP/9midSC9N9OUHPK7mskxt5dS6gupHTWJJp1ajGLbZaP+hGNQBd3FLDFllD?=
 =?us-ascii?Q?jJ4GAM0rQ9IOBiS6TuZMpe07D01DPhIDjeGVTB2LNUniaNAUHmuI3STCumef?=
 =?us-ascii?Q?1rnL9UNrih0fj2mlN8d8rPtq77TZ6CuLz3+pFHg+qRb1NFiStdwXVGK5DcTY?=
 =?us-ascii?Q?1u7fL7ZhD/QBnVhuKi0veOfF8Lk9p8/c27+e8Ldt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb5063f-dba0-4bcf-3615-08db314cb9cb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 18:29:40.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOAnHLvkMx8bxkg5TDzKFzkritZrYMLpnaurv4FalwghCQKMPFgBt3U3GWRu9gNl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:25:05AM -0700, Jakub Kicinski wrote:
> On Thu, 30 Mar 2023 09:03:09 -0300 Jason Gunthorpe wrote:
> > On Wed, Mar 29, 2023 at 07:03:49AM -0700, Pavan Kumar Linga wrote:
> > > This patch series introduces the Infrastructure Data Path Function (IDPF)
> > > driver. It is used for both physical and virtual functions. Except for
> > > some of the device operations the rest of the functionality is the same
> > > for both PF and VF. IDPF uses virtchnl version2 opcodes and structures
> > > defined in the virtchnl2 header file which helps the driver to learn
> > > the capabilities and register offsets from the device Control Plane (CP)
> > > instead of assuming the default values.  
> > 
> > Isn't IDPF currently being "standardized" at OASIS?
> > 
> > Has a standard been ratified? Isn't it rather premature to merge a
> > driver for a standard that doesn't exist?
> > 
> > Publicly posting pre-ratification work is often against the IP
> > policies of standards orgs, are you even legally OK to post this?
> > 
> > Confused,
> 
> And you called me politically motivated in the discussion about RDMA :|
> Vendor posts a driver, nothing special as far as netdev is concerned.

The patches directly link to the OASIS working group, they need to
explain WTF is going on here.

The published doucments they link to expressly say:

 This is version 0.9 of IDPF Specification, to serve as basis for IDPF
 TC work. This is a work-in-progress document, and should not be used
 for implementation as is.

Further OASIS has a legal IPR policy that basically means Intel needs
to publicly justify that their Signed-off-by is consisent with the
kernel rules of the DCO. ie that they have a legal right to submit
this IP to the kernel.

It is frequent that people make IPR mistakes, it is something
maintainers should be double-checking when they are aware of it.

Frankly, this stopped being a "vendor driver" as soon as they linked
to OASIS documents.

More broadly we have seen good success in Linux with the
standards-first model. NVMe for example will not merge "vendor
extensions" and the like that are not in the published ratified
standard. It gives more power to the standards bodies and encourages
vendor collaboration.

It is up to netdev community, but it looks pretty wild to see patches
link to a supposed multi-vendor OASIS standard, put the implementation
under net/ethernet/intel/idpf/ and come before standard
ratification.

It is a legitimate question if that is how netdev community wants to
manage its standard backed drivers.

Jason
