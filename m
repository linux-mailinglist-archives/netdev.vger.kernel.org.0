Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22294B7116
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240962AbiBOP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:56:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239731AbiBOP4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:56:19 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412B99E57A;
        Tue, 15 Feb 2022 07:56:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTX0kKSs60Pnecxb2/PTG95Y7QbFn/09PMJvPwI8ZTaNTRakLYQpsNZXplaQ/D1bvcKFk6RPPGtsm96B+XLhfs0pmnu+C6ZWWHKt5hTisXsQFa+Du+MKO0+CJKQ+4Dglm6SzriJYUtIdXy1XVqQui157yZG3vtsetkQEqTk41Qa8VvUH7n8avI/asvoRFGGlmwvMf5mSMUNWMsO/H5wt5rFoEG6hV9AUrKwuiAUOI9nthysokOYN1/B4M+osTX0hinQheFt13UN6Dzj2w6qkiKTM5oQbLOpUazrA0ax3R3+HJUkYX1LW/pPQMhLnqYbbcfuh/nXUnwpWVRwwFsI7Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JULRuBXTDT2NSj8/68Dvu12VImVPZwhhvXTRAjqfIgc=;
 b=CknymNw/o75Pcn6uq56TBp+LdPMj87Tp2PvDHDwlKvnBDLHCs7qkCmjC8iZfOt/0q5wpbsl/c2UQxhGTiGntCcoLw7Oeciz+iTmrK0sHbGcGHzKJH6NwxAMtQyzZCl+priVIoiqs3i/Z+S/9CFxa1Hd3J2ZfYyoo+iAAtx34qpXJSrKLaY8gaFvwDczQ+bkPpHKNDP2HEn+x5zoWIuS3/F9nXSLMY9k1iI1rX5GcnFuICNMGSBKnqMXgQbCmr7Gw7le67pfECwovqEAqB8rkC3gqNBGQvgEau2duGHGtwYD9ReqGYj5lFGemfDbamWCtS/vGi/pp01AcaFQWT2xs7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JULRuBXTDT2NSj8/68Dvu12VImVPZwhhvXTRAjqfIgc=;
 b=Kz9fYNqv6kKeqjAavbU3V365mdVjjSRfhQOabZBZkYd+vx40YkCde1yqMvRQiZy3UC2d1QQd6rne0zBJhtM9bkh2diSnpC+khqk0TGu9iapIqQ6XvohtGlrOUzhsLjS0C2nn/ISYLQwcRe93iXxHgY578p4lBKSe8mqaDIHRcZAS0won5qtn4L2EYxv9kFNMdjxxXtiZ86oapFajTL9GR/UCoJa4TLxnpYZl138n1eQECb7A80RXc/6UQ5ZY2BH4l8rI+XBnzmkYl9/lvoNyCVq2elgJMSw8UcHmCJAhD2YFuN3O9JJpvMYRzkT3GueS/lXWB/hkPOZQEMtN+JIAGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BN6PR1201MB2466.namprd12.prod.outlook.com (2603:10b6:404:b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 15:56:03 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 15:56:03 +0000
Date:   Tue, 15 Feb 2022 11:56:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220215155602.GB1046125@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-10-yishaih@nvidia.com>
 <BN9PR11MB5276D169554630B8345DB7598C349@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D169554630B8345DB7598C349@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4afdd80-c1db-4a99-e871-08d9f09bab1e
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2466:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB246615D212491BF17FA77C1BC2349@BN6PR1201MB2466.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjTNLQSGtl/oPX98AQGQRBDfmJNrBcd9bUY1Pwj1ba57NgskZqXybOIOywFNlZNr5QAVOoKiOp3oiXGKn+VfG/PbFioOiAU+Im78hteRGClh3W+YzzSVNRiWsR8uIjg+oJOuzkrb0qX6a89CQYKfy8nRPlkpBV7meiua1UgN1UIADn0i3TW21QCmlOjPoAudXO0r8JCzz62lYztmF19Mp4MkibyY4l2ebQnZhoQJPZ38cDATCwCVcjUdN+dapwK2EgL9W7GPH1PGOEjMUGXzObWfSFheIqHIcqp+kZ0Uo3RKb88VDup2rAgbIVFulDYjc4YbvkCQCe7rTKd5a5NxiKgMNwAIFQ0+LuWYn7YKkfGiEGvQ9NqNSSIJVb7pG3/qhvwQxx8WjCsJNlL8rGXkDvwMVp2wHHfPgrKtgUioMheOkCR4cR+Ii5PuyN3yby9aVSvEcSQfq1q+DANdHVU2G7LFjd3o6HHo6ES5NREWHuNzDR1NoWd1kImtpXNFO7pzZxV+HOims/C2ob6t3MhjG0+0akvo7gkXXeU4FTO3/ofWd0dKRKCpcwYibHxGhQ/qf8ZxHYA8879OjUAAH0N+zPXvoeI8cc5GLIBHABFBBcoFHTib1mV0lw5pX6cxFMNLZymlnhHqXRUBc0xhgHfr/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(8936002)(6486002)(508600001)(5660300002)(66946007)(8676002)(6916009)(66476007)(66556008)(54906003)(316002)(26005)(186003)(4326008)(2906002)(2616005)(1076003)(6512007)(6506007)(86362001)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xaRLavEEre+H7JQUZuI23q5YgvVOZ7G8tTdaBENjMi0/wx5I9wlL3C7jmye5?=
 =?us-ascii?Q?mHsb7h51R96FLIL2q+PfJTBeOJvuqIu++DEoR73SvXhApC36jY91mYKz3BNK?=
 =?us-ascii?Q?gnxBBO1ibXbiXMj43n9yA4Mlua2JdghcsIJ46gc1KRUKUfc03ezx6GKabICs?=
 =?us-ascii?Q?+eiI6uLL0Y9pUyFKBKYhXT/IBc4QZ45EwGvbbHdvAEnAveuhBbDVjaVn/51W?=
 =?us-ascii?Q?aJtrW4h6drtApUKcRniTGlKjtJGOi+NwVElGyO351354qk835U6b7jY0ar26?=
 =?us-ascii?Q?t0t0vq6Ac/6kwihCdOy3ajlQ60KjKab0LL/KfcrXlhBUO7Tv556QsPCn4bWT?=
 =?us-ascii?Q?UnaBbPeins1m1eUdnffXusok+8TYt6IP+6h/6/ZQ2Saq6g0UhfGzdp5tFchR?=
 =?us-ascii?Q?RNAl3gZKJqyfpDM3krIZQpbjevdnn+G1pfuStRUABEySjky+XjNmodvdRMC8?=
 =?us-ascii?Q?A1NPDsZX6CPY+dFwTBvtpKUVUMO7k+hoaXNZZ5wXoUiQQiYx83gvw/X9m3JY?=
 =?us-ascii?Q?qNJyG/P6C17nk4ofSt451sbGps+CJxC9Hboh5oB6oTzQqZ92r2st3aXjpFYw?=
 =?us-ascii?Q?+LjFP1rWTaFd8InE3RFWKkp3zYF2AeWip/E+26mHnHKrZeAHjh6RZvVhq/1u?=
 =?us-ascii?Q?PiKYf5TKvS141iesxfSZI48wKGXO8QBb+lYZvqBmKYCdJVAcxll/0X/kCW24?=
 =?us-ascii?Q?df8F+3bIvKOQ7vMrqCOfe1KjbTGCDdnfjK+g4+ZallpAN7xE0nwQy1CCVD+1?=
 =?us-ascii?Q?tZAzzBAXPJHmZZCYgApOc36iEdIZ2xhXe5anMY/vOI5yOYsACHI8vRV5l1OL?=
 =?us-ascii?Q?Fwep/2rcEGjk/Ev6RShEWrqKzW8qLBlP/2yjOfm1KJP+zaPhtRwJSSECI2aj?=
 =?us-ascii?Q?ZBu8IIgv9mIzlTsYSzNqiXK87QDK1i+1In95WLSQjqoBVQvevWu7CsPKCj8v?=
 =?us-ascii?Q?6ROJtzbiFM23Fi6rKjqaDlJQHwOhY6E+aHNHqCrTOdTwAlDGXhlVzWgATJjD?=
 =?us-ascii?Q?iExP/gqOjuZBaKryoCiRjzf3PMtbCZy69Okc0YGtYrY4h6ryYtwaGOK6eIH/?=
 =?us-ascii?Q?dX39wbeJhgq7u2JUtU2jM7PF/1ym+UN2VYnc4N+sLSb4FPmLYxGydQrfMb3e?=
 =?us-ascii?Q?ic/csc23mtNaDyl07Pxq/2Z6x/OK2ZICtia9dkwDfmDXAwcQaFJfupcoRlHZ?=
 =?us-ascii?Q?c1Wb6ewa9BAPT/+w4t7zoDWPPJjdmv7Y9aKSGvemRXU2ttYr9FVAB9PCwuBe?=
 =?us-ascii?Q?2bKcnnHzQQEvzsV6f1pvKqXitA/7TfKMPmzyo63xJPvg6p5tR+7y/e41o7eC?=
 =?us-ascii?Q?GGZDaHR0uU9/SSO8k7/T8aO6Tq98LgZGqhMxC0AeFk42b842NSFSOANzIwWj?=
 =?us-ascii?Q?7jhdxNm6taNTfw1Env/ZD5TVLt0c9tpd/agVqTBSX3d5h+UR1Bh3nr16Q5yC?=
 =?us-ascii?Q?YZnUlL/OM5GTOuM6fwi/x/zUfM0wndsYTitLbPCaXnN+tJu//hG4ze5R5OOo?=
 =?us-ascii?Q?+we5qggfj9VJewHfaCPx04h9WOH1wY6B71aAjU1EBFKs5Fg8SZcZtkS/VV0d?=
 =?us-ascii?Q?Ul4+ub5+4DF2BgQ8lps=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4afdd80-c1db-4a99-e871-08d9f09bab1e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 15:56:03.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxwX/41INSAF0myux8qa7hE41Ka5WNO+vo7sHXaA/A9WCLz4SU18rVKBxw4q7+Bj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2466
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 10:18:11AM +0000, Tian, Kevin wrote:
> > From: Yishai Hadas <yishaih@nvidia.com>
> > Sent: Tuesday, February 8, 2022 1:22 AM
> > 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > The RUNNING_P2P state is designed to support multiple devices in the same
> > VM that are doing P2P transactions between themselves. When in
> > RUNNING_P2P
> > the device must be able to accept incoming P2P transactions but should not
> > generate outgoing transactions.
> 
> outgoing 'P2P' transactions.

Yes

> > As an optional extension to the mandatory states it is defined as
> > inbetween STOP and RUNNING:
> >    STOP -> RUNNING_P2P -> RUNNING -> RUNNING_P2P -> STOP
> > 
> > For drivers that are unable to support RUNNING_P2P the core code silently
> > merges RUNNING_P2P and RUNNING together. Drivers that support this will
> 
> It would be clearer if following message could be also reflected here:
> 
>   + * The optional states cannot be used with SET_STATE if the device does not
>   + * support them. The user can discover if these states are supported by using
>   + * VFIO_DEVICE_FEATURE_MIGRATION. 
> 
> Otherwise the original context reads like RUNNING_P2P can be used as
> end state even if the underlying driver doesn't support it then makes me
> wonder what is the point of the new capability bit.

You've read it right. Lets just add a simple "Unless driver support is
present the new state cannot be used in SET_STATE"

> >  	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
> > +	while ((state_flags_table[*next_fsm] & device->migration_flags) !=
> > +			state_flags_table[*next_fsm])
> > +		*next_fsm = vfio_from_fsm_table[*next_fsm][new_fsm];
> > +
> 
> A comment highlighting the silent merging of unsupported states would
> be informative here.

	/*
	 * Arcs touching optional and unsupported states are skipped over. The
	 * driver will instead  see an arc from the original state to the next
	 * logical state, as per the above comment.
	 */

> Defining RUNNING_P2P in above way implies that RUNNING_P2P inherits 
> all behaviors in RUNNING except blocking outbound P2P:
> 	* generate interrupts and DMAs
> 	* respond to MMIO
> 	* all vfio regions are functional
> 	* device may advance its internal state
> 	* drain and block outstanding P2P requests

Correct.

The device must be able to recieve and process any MMIO P2P
transaction during this state.

We discussed and left interrupts as allowed behavior.

> I think this is not the intended behavior when NDMA was being discussed
> in previous threads, as above definition suggests the user could continue
> to submit new requests after outstanding P2P requests are completed given
> all vfio regions are functional when the device is in RUNNING_P2P.

It is the desired behavior. The device must internally stop generating
DMA from new work, it cannot rely on external things not poking it
with MMIO, because the whole point of the state is that MMIO P2P is
still allowed to happen.

What gets confusing is that in normal cases I wouldn't expect any P2P
activity to trigger a new work submission.

Probably, since many devices can't implement this, we will end up with
devices providing a weaker version where they do RUNNING_P2P but this
relies on the VM operating the device "sanely" without programming P2P
work submission. It is similar to your notion that migration requires
guest co-operation in the vPRI case.

I don't like it, and better devices really should avoid requiring
guest co-operation, but it seems like where things are going.

> Though just a naming thing, possibly what we really require is a STOPPING_P2P
> state which indicates the device is moving to the STOP (or STOPPED)
> state.

No, I've deliberately avoided STOP because this isn't anything like
STOP. It is RUNNING with one restriction.

> In this state the device is functional but vfio regions are not so the user still
> needs to restrict device access:

The device is not functional in STOP. STOP means the device does not
provide working MMIO. Ie mlx5 devices will discard all writes and
read all 0's when in STOP.

The point of RUNNING_P2P is to allow the device to continue to recieve
all MMIO while halting generation of MMIO to other devices.

> In virtualization this means Qemu must stop vCPU first before entering
> STOPPING_P2P for a device.

This is already the case. RUNNING/STOP here does not refer to the
vCPU, it refers to this device.

> Back to your earlier suggestion on reusing RUNNING_P2P to cover vPRI 
> usage via a new capability bit [1]:
> 
>     "A cap like "running_p2p returns an event fd, doesn't finish until the
>     VCPU does stuff, and stops pri as well as p2p" might be all that is
>     required here (and not an actual new state)"
> 
> vPRI requires a RUNNING semantics. A new capability bit can change 
> the behaviors listed above for STOPPING_P2P to below:
> 	* both P2P and vPRI requests should be drained and blocked;
> 	* all vfio regions are functional (with a RUNNING behavior) so
> 	  vCPUs can continue running to help drain vPRI requests;
> 	* an eventfd is returned for the user to poll-wait the completion
> 	  of state transition;

vPRI draining is not STOP either. If the device is expected to provide
working MMIO it is not STOP by definition.

> One additional requirement in driver side is to dynamically mediate the 
> fast path and queue any new request which may trigger vPRI or P2P
> before moving out of RUNNING_P2P. If moving to STOP_COPY, then
> queued requests will also be included as device state to be replayed
> in the resuming path.

This could make sense. I don't know how you dynamically mediate
though, or how you will trap ENQCMD..

> Does above sound a reasonable understanding of this FSM mechanism? 

Other than mis-using the STOP label, it is close yes.

> > + * The optional states cannot be used with SET_STATE if the device does not
> > + * support them. The user can disocver if these states are supported by
> 
> 'disocver' -> 'discover'

Yep, thanks

Jason
