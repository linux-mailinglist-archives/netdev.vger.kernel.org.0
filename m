Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C72368EE6E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjBHMFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjBHMFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:05:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2091.outbound.protection.outlook.com [40.107.243.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EF54902F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:05:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2ddzwM6aCEloBMbLpOXWGOI3DG8QD4qgg5YB3ORBPXklIR/i1AT5Kjpjv6pP7HtMloaFfkTsJhZ8sw5gNn2LkiOlkbviY/acKhxUGu02nXyLOHxUeczsW9B+gKJWLjpTqIgKQYbpwv2WtLM3Aws5EEHl/7xoBBQrbMxPRDSSNsLkc53K3inBWEIAgUj454VrsmgdUnCqnJug/SJLQ06g/lLsEpA5UIZ622dxTpVxcWvTfC53C2fHy6VTnTrHYz8OxLH1Fwar8M/bUC4z/Fv+o2zyHkUiZqGY9Fqw03pAcPBkPPuCVGkSa5Iu/oBiTAqmV/tsLYgJpsZ/MGpoIzDLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QcqXPDJQxf/vFDTySnlT2Jc8TiHAB2JD1kSqG/SxFc=;
 b=G2FCCVolKWngtdfcr1P7OraLCunfBg598ng4Zr1vCl1zSA9icjic9XkOAtrzCb50cOat7hDt9Jya8G4Ja4sCc6IFh19QjHFskqSsN8KNlcG2iVt/W1/aYXLWHhC4uZrZ/DN3gIW+B7OQFcRrPL51JpPupyUmh4VZvUnooe8R6KnfA5J0Gq96lGazOH1g21cGTseUmTdtKIatGInqr28VETE+wQNYrmXPwObyqyp+5KWpfZC30VRxlgc/RS7V88I3D8WqHBvoZ0oE8HjIDITsZHhmJy2HUq8d4OqeGNj7e28txomPK5PyD8IMtCjGmSkidfJJUB56hhEB/Z2jX7o3AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QcqXPDJQxf/vFDTySnlT2Jc8TiHAB2JD1kSqG/SxFc=;
 b=sVKDhja00awEUP4xOxI6JFyKX6qwvpE0zlAmu4U30IHbRkWcnmGlDJWZsKgsXUPUZoIyPQzySvBuDN6v0T5TnfHFKFJENKRLGuHrLTtmtpxy0aEp+laMCuY8CpF3GhcsF+IdbDK3ari294lL+Ork1VvMRAaP4sZFzsQwehs5ap0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5512.namprd13.prod.outlook.com (2603:10b6:303:191::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 12:05:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 12:05:09 +0000
Date:   Wed, 8 Feb 2023 13:05:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OP7rIQ+iB5NgUw@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
 <Y+ONTC6q0pqZl3/I@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+ONTC6q0pqZl3/I@unreal>
X-ClientProxiedBy: AS4P191CA0024.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5512:EE_
X-MS-Office365-Filtering-Correlation-Id: 093b25f9-2b25-4c56-5113-08db09ccb993
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B2j7OSJ6ghn8KHgGS1ugKpXjviHJFWCH64lea3GLJiwD3mJXHizreaWwLLc2VvdH+EqhLTM4uOQdXu4/QdU3udSzSA3P+JVlQgZ2TUVep/QymzVYoZudJDTjcanzxu11JWO4TmVdtbvmv6Kb+d3Z7NNqk/U1doAdUVJpYu33MeVC+/ivF+5+9l63YFdpt7/l59Z5cy5udrEuEc0gglAut1adTAB5i9ZQNwhmC5VZ/RSmCFiXoQztwdUffPV1TMWX0YFG87aYE/JEBA4hd0VklAsV0Ozm50BlXEwQV5Vt69CE96IgvStz+1/0Czftgy847rqoTi9r9rAKUPfP063bzdScwwNe12jPXWp+mb4YXcU6hViMnb56IqnPhA+rFur4k6RXa2nVo2rpM5h0URMQxHeh9yfL3pwgkXOV2rG428xh9HN5lCrdMBE416Z2xlRktf7yBZ/5wFizlP/zP8lbHMOXm8ioJYW9A79mfze+i9DrdANzgs48Q+gWpqHbbnYdOFrSZ5rgiTmI2CvQhr510KY5+dTTD/UJBMtY15zWrhLEg3X/+tZGKPZ0HP9dTEnERM/Q7ErFtLwW3BMaceW9k5XCGxlMssEUhnjkmEU393GfSN7HABkXszIGZelXSJT0KJ8jZlKecM9pFzKHwa9OpgAfy2SnYpjLamJG35SnaVbxmtXXf/kyKCQVBNt82ods
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(346002)(376002)(396003)(366004)(451199018)(36756003)(7416002)(44832011)(5660300002)(66556008)(66476007)(4326008)(66946007)(6916009)(8936002)(86362001)(8676002)(41300700001)(316002)(2906002)(38100700002)(54906003)(6666004)(107886003)(2616005)(6506007)(186003)(6512007)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sKYWnJu82ijf0uPfxy4Z+deIIxK85eIx1JxG58hFtI3/nvbzOVY38CeWinTU?=
 =?us-ascii?Q?dRgmx6aaOiRUo0wKf2iKBQViJpaaBILMyvcawLgsuJvsTj/Bn+95qj4Q3YxH?=
 =?us-ascii?Q?eWWDJ0wSstFl5m7bZ7vpna9LturYHYwl75Yy0tsAry7xbATltJ3D9mYHEcUb?=
 =?us-ascii?Q?tl/UZuxa22InMTRSwUSpDqHtbPc1PX4Bim+HEep37MHY7nohONbhAtXlmNus?=
 =?us-ascii?Q?UKZx0yIpeYBx7vZ7gs4QQlo0IP1g64KuQgJOk+7BGeWVviBkIwgPMeRiN0+w?=
 =?us-ascii?Q?idDo24Oj72E1t1a0j9tpSc/Ap2AHRfey/wbMZyXRUj255sJ5AwiLgi05NnUu?=
 =?us-ascii?Q?Lte1O4yPEATfEaE+j97QFh/fP9cowGtEEmyJzCW0IQmjprzN8k5XMyPl8BCC?=
 =?us-ascii?Q?VYpze0uYFk8Je8U1dCNmo/UgOefmcnu9XVwSrRw6oCDS66NLw8WTM0zlmXYH?=
 =?us-ascii?Q?fZn90LexCOoftiICMwfRtWDOmVSPgao/jaG0j3uBJwRXBWZcF3Y3IpOcOEFx?=
 =?us-ascii?Q?+94JhZkYwpaDNYWdW5hZqCJMYB65c7QRkafXzFZX0h56fytC+SHKpcd/D2dQ?=
 =?us-ascii?Q?/GYpqdgzKD77BA/RcT9CMtaUcvlePX2Zw3XlA1VWP+JWVRktkmjG66grlK0+?=
 =?us-ascii?Q?xkpfh0pBgZ+fLgb18dlQ+aNzw6od3B8vbsLN9gBHXoqWe5zF0d1U09E88Nyg?=
 =?us-ascii?Q?Qk5hzn4xs2meUQVdn+nvLYjGX9pHN0LlcJaGVDyVjj5nuTT1Bd8U3t2Q2tdx?=
 =?us-ascii?Q?R47WfmEgPOWIU07bN93nJxyb8uD1v1BZUEeXOjRtegIu560LtiHv1EtQFk+6?=
 =?us-ascii?Q?pqQAXjt9NUl3E7gaVYa4YmeqcrWlDXJpfMiZJcxQL228YLnNzuU9oJEogbxd?=
 =?us-ascii?Q?8tFYfZjhkslKf78QQ1wWap7jj25nN0LDPSGkyCex5vsw38KAZ7c8JKGSwaJu?=
 =?us-ascii?Q?zJwIeO+ZmvwBEplPaXUs7Z/edwnkRpWtWxdBWHbPas2WG3ON2YIcrT9ugRnK?=
 =?us-ascii?Q?COnMp5IcH15Ax/k8JvMLQE/4+pSMCej9FrVXsNQgJyPqjhlOICQZW8oCRxk/?=
 =?us-ascii?Q?jX+dknGtGuI7nXma0Q8Dknbom7Q9Ah7GxsHgE/9azsE/8Zr6oXl8DzYT+FY0?=
 =?us-ascii?Q?xqRqslYFf0wOqfrNLmqSY8EKcdULXyuqGpWovcKISXKc38hu30xRFwyl7Cx4?=
 =?us-ascii?Q?WCkLFayMkJwyUZFc/Vnq/tYPM+xDJZievFqbaJ2WZI+XbsIKjXe1XsGK1Do9?=
 =?us-ascii?Q?MnYxeYzzoHFapSzBKOEqzg1g0DrEDpEMCHWcZ6Qb4TAHPpSS7FhtTnu8op4K?=
 =?us-ascii?Q?uW0lZNyRgcRQpZBzcn+91ixkn+5hpZVdU7Ca5ZbZ21HVaGGRjfuTETUMm87m?=
 =?us-ascii?Q?rxBHYSTQSesayNY5uJxf2anKGzGdsWB+rhVhUhEny2ENxN0OMeEWf7/tzy0h?=
 =?us-ascii?Q?QlH/kMJ+ra5eubiXtMBxDBRf+ASpTuW8cMD9xRgXjhhxwHsUPqAz4QDNtIFZ?=
 =?us-ascii?Q?azfr1pA7hJdfeFJVdpDh0fdq0L97o2itv3O6CuWHh8Q4stQDAVt2BUfsbp0J?=
 =?us-ascii?Q?yuDDovnudlqCYYNJECTYqECINvq7JhYf8mHmgGuQZCv58TeHuVL4VIgLOIDv?=
 =?us-ascii?Q?nAOBOPQi6s+PZU0MPkuffNpVtSa7tEEoj7tT7a/0SkqvAhUT0V+Y+AO7XieP?=
 =?us-ascii?Q?DdtlMQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 093b25f9-2b25-4c56-5113-08db09ccb993
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 12:05:09.6193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q88pl7RaEar+uasGsxW3UDcLBwynuaf6ulmN9wTbUossvoZLDzUVV41XPt4scuCsdEfhp3pzp1uCT/j8PCXMyHgZh1wsZ5yUHLHP7Ip3T50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 01:53:48PM +0200, Leon Romanovsky wrote:
> On Wed, Feb 08, 2023 at 12:36:53PM +0100, Simon Horman wrote:
> > On Wed, Feb 08, 2023 at 01:21:22PM +0200, Leon Romanovsky wrote:
> > > On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
> > > > On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
> > > > > +VF assignment setup
> > > > > +---------------------------
> > > > > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
> > > > > +different ports.
> > > > 
> > > > Please make sure you run make htmldocs when changing docs,
> > > > this will warn.
> > > > 
> > > > > +- Get count of VFs assigned to physical port::
> > > > > +
> > > > > +    $ devlink port show pci/0000:82:00.0/0
> > > > > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
> > > > 
> > > > Physical port has VFs? My knee jerk reaction is that allocating
> > > > resources via devlink is fine but this seems to lean a bit into
> > > > forwarding. How do other vendors do it? What's the mapping of VFs
> > > > to ports?
> > > 
> > > I don't understand the meaning of VFs here. If we are talking about PCI
> > > VFs, other vendors follow PCI spec "9.3.3.3.1 VF Enable" section, which
> > > talks about having one bit to enable all VFs at once. All these VFs will
> > > have separate netdevs.
> > 
> > Yes, that is the case here too (before and after).
> > 
> > What we are talking about is the association of VFs to physical ports
> > (in the case where a NIC has more than one physical port).
> 
> We have devices with multiple ports too, but don't have such issues.
> So it will help if you can provide more context here.
> 
> I'm failing to see connection between physical ports and physical VFs.
> 
> Are you saying that physical ports are actual PCI VFs, which spans L2 VFs,
> which you want to assign to another port (PF)?

No, a physical port is not a VF (nor a PF, FWIIW).

The topic here is about two modes of behaviour.

One, where VFs are associated with physical ports - conceptually one might
think of this as some VFs and one phys port being plugged into one VEB,
while other VFs and another phys port are plugged into another VEB.

I believe this is the mode on most multi-port NICs.

And another mode where all VFs are associated with one physical port,
even if more than one is present. The NFP currently implements this model.

This patch is about allowing NICs, in particular the NFP based NICs,
to switch modes.
