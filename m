Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559624BBA67
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 15:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiBROGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 09:06:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbiBROGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 09:06:40 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385061A6A6D;
        Fri, 18 Feb 2022 06:06:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n76pgRFU/e+Hk6CCNmBXCeZnyvGlqiaZkZHYQly3qnOK637J9gLV6/3QjmGFygTCCNGtsIYz5Hf3BLhY2IyL9GMuDo2EW9HZ7ai/4OjZ58RIdNtyfsgqy0sUxC7qH7y9c2ZYQ6wbRJ3Ujy3MOjBE4cPLRubBnXZ3zguH/WLXteeXsutypXZy6g/IrBMd4iDlochRZ6KUd6NE9Jagt3HcUe1LSNZhzZmo7dZt2mX3hcAPzkPeekDb3vHVuL/OOKJOG8RQ883M8V3GBiTdDeoBqb9jiUDZpKrN+eMQo26gzzqxA5NgnuKHf0BsCfiSihB+dvyXlvfbqCjZbtpem/xeng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjmjNV6n2ajws89g2hYoNYGmr1iLKwYQK8HAeANBEDk=;
 b=m1TMU65Y5s+oEpfyCREU/5l150R1rteZNE5Sg+/AFFhXS40McuR3z/nF8gwv+Nuf2QQCnTJGDucGwBv80L/3kYsrPfq+MJxyPhbgJK8vL6sXfvhubJdMf0oNTKEaZSIzvcnwFTHvRIIvIH6NiUzYq0A6IsJNLKVAjX8pdeIJcjYcj4yCJ+2AXOC0829IPeJqx9zBcn2cD3076I9Um22ngdTcL9s/xxlNqnE+ZAN14BjL39eQtbA97TikRFK6G40+RMpbRaoopfrGn67bsCT2dmxSVQBPuq4kwIaepcqIFWs056l4OJLU0WLbahmHf4Qn9Xnw6oBphzx+fgAFQb0nAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjmjNV6n2ajws89g2hYoNYGmr1iLKwYQK8HAeANBEDk=;
 b=mA4YJaA8e0oc1XaM9abQmjRVQOGqjtDpII7w71t/D4jGm8l/AWCCvIiQmnsyxuA3CD1jlkRiTglnIf61Rlb6grYNEdeM1dmQYPNsKuU+PPWgedgOtMrW1vpba53NixdI/PB23wIurNyQfd8lD4tU2ufYvZHka7m1DKXgw7keI6ZhRLMBfgzin7jds4QMlNLlNTWLQfnQ2TsgYgM3ZwiMDuFHLkpSdFzfU09qerX/p4PcAHPyS9F1xmq/dVZ1K9lmzPPVQdPpGJHbb5qRFoc1nV0mUZQJlNgZnR5fy7/rWh6MabPzy1GumqrRrtZH1s/BrqQheLaRaGgcdgPkvkZ7PQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2450.namprd12.prod.outlook.com (2603:10b6:207:4d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 14:06:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 14:06:20 +0000
Date:   Fri, 18 Feb 2022 10:06:18 -0400
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
Subject: Re: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Message-ID: <20220218140618.GO4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-16-yishaih@nvidia.com>
 <BN9PR11MB527683AAB1D4CA76EB16ACF68C379@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527683AAB1D4CA76EB16ACF68C379@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR16CA0004.namprd16.prod.outlook.com
 (2603:10b6:208:134::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ebca669-7750-42df-1326-08d9f2e7d69e
X-MS-TrafficTypeDiagnostic: BL0PR12MB2450:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2450253E9F5A699CBA6A4E09C2379@BL0PR12MB2450.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZL5uMozRLEUczP9NRqMFjB97bCD7UpoXnzvFRC4Mgg9bnYYVp7lTrF+1xtRfBYFYZtqTPNOEULiezHyINe4M6bsbjHoIU+76AhQxMReMzExXR+LRzQoTKqaJvbGbmGx9v55r79ucXQGi3c/xhL/F1HYx+xAKlR5jrn/IDzwp3F6EkDU6/bCuznczP2VsNV1E2hm9up0NM5zJBNEyhoYagO2gNlJ0UjQnE3csh5Kk08frGHGtIYb0zSV8V5GlKS3Bh1Ic1JiyJKIuNyvhlzFkRSWHahFudnLt96ATLNJ4lgRWPfWGxR6GTvwC8usOSHNCQrLJF1ZjuCKMTSzLOimVOrkEg7g+6CakZgWBldkE1Pw8N0PxwJG2ToZK52dtL17fO0fiK2vaet2EqQOZcSPcLTD4GvT7YXYod+PBnRZ3OzVWOFqQNwKSbyZ5O5SDg0c4pTfjz6In5GPRFyHBVKvQ3YJJ+6y5D/MHXmIwA9Oxef1CcdNQJ0r88vWWmiPbv9jqyzfOJg6VkuHrXk4El0ELcdW1rwSu5SEyzniTdcOIWtdEmEZWviFPPVnLXcbrtRcWsugieqKnaBJZUmEC5jJXt3tL3QNIdbRevDCDBc4a2Q50yItWql6E5b61h4PxXVUvwmB8f8U52l1eWRvZUHwMHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(508600001)(8936002)(1076003)(2616005)(186003)(26005)(66946007)(38100700002)(54906003)(33656002)(316002)(2906002)(83380400001)(6916009)(5660300002)(66556008)(8676002)(4326008)(36756003)(66476007)(6506007)(86362001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBGVKL3sEt8Yyz7eeJVCyev58um9mCVWH9ysft6fk73jIAlgJpurSa8kJelZ?=
 =?us-ascii?Q?SFwuYwOZxg+QFjyJNuNyNtTBSixKqV16IC38/worKbFz3q8aKoPElfEyhGR3?=
 =?us-ascii?Q?cYj05gA4zq3xjwHU6WghUJWWfEyWKzHbxsJXQIJIQcwVvtUSdEf65oGfu2r7?=
 =?us-ascii?Q?JBRD4zE/GA3vnoMU/q6x+GBIEa1K197GsRXSf09P5WLlS2RvRFUCo6+7VePr?=
 =?us-ascii?Q?Oj/yCJSBW2xEDiHB4sOK+Q0W/9LwmDdNoJWPY/ZO91B/aM2rEkCz2nFFOjNz?=
 =?us-ascii?Q?/tst80APCBGCAZTUT4IlQaRLzr4MetiBNfhqVZzw0Sd795SSAId3/pGdMSZX?=
 =?us-ascii?Q?PkCjHpP/bW8KSYbWdNmRsWevPbQiPGVX6Aj2SekF0Saqf+T1G791idNHp/dk?=
 =?us-ascii?Q?L4TqeshorgPN3zoFRLT0yfSFLacfdLbCc1Yu78OVzdwTuXkTXWNi7Iudr7s7?=
 =?us-ascii?Q?ckbzkqxqsX6SiO+5PlvzUvWvIDjVCpdhZjySKesACaQ+oxQkY6ZcoFmzuGPQ?=
 =?us-ascii?Q?tQlb3A/Q1pPMPBYQ9Jp09pgrC3ghLwypw1XbOn03wiFKE0rxZjyMyIAxkNB5?=
 =?us-ascii?Q?sULizUmLToxxmWSIOi5L5QU9l4f0SLsS1T1Y/98SNdB0YyjoHAtu1qWwtT85?=
 =?us-ascii?Q?m8M7aTwVCcPsZT76KDkgr34OFFXCvi/PN6kS9lxy6TEMjTg8szQQR014MVl8?=
 =?us-ascii?Q?WsithoXG3K7bDpnv23dVxBsmVmasIVrr2UnsixEICyw59fWP1jUMcXQTMOgf?=
 =?us-ascii?Q?IMYwRl2KLkazgRSFn/PNho9F+8ifCGreMBZBgxAtJzbMV8qbwfQ6FbNb3hFa?=
 =?us-ascii?Q?0eZGASefywWlj3vgOa9PnWnjrGFgE53YiVzDdLSvUWcE8cTilLm8CeMy/Ck2?=
 =?us-ascii?Q?jP6uLpYtOIPDjpn6TGHGAEhSysMTGwFbw80iCSbf0AoBMoS5VDr+Vrr9JTEC?=
 =?us-ascii?Q?wKPb2zg+s/Kdt/9pyDVIBPGb/pbwA+rhhZkC0Mj3A1+RvV+2W8B80gSc0Y6w?=
 =?us-ascii?Q?EjP43Z8/9EDuE4RiQ3qUta8VSLKcOoEM8+aPSuSi/bgsRSRQEvg9UxHdXWIN?=
 =?us-ascii?Q?bhIGPrMMJhdgl2ZEXTgOGB4ckIG9wqoT1YOmtQ7KFj1c6zUGHQSIQKKSmaC3?=
 =?us-ascii?Q?/NZY35N3OxERLo6ZTKVH8VAcoIMsNr8dAJjfQzP/bq3jW5GTb1xdxGElIp54?=
 =?us-ascii?Q?NxIOACUmfQVtcbxhLUxQHQ0bsQzFkD/QHdGSYtOuHP7PpcOcprMJUeX+FW2t?=
 =?us-ascii?Q?k14PlJQU0rOJOe2sPXril78GKGlSE/UFKX8EzEZTja1ukOGOEQOZ7H5TgzSe?=
 =?us-ascii?Q?ycHUUITtN1kL7A+E8QeBJgN/v4tuc5NBdDvP0EpwG3IhVe38RN25Ww8Snek4?=
 =?us-ascii?Q?B0sLTziUUH8D+TUmAtSEH1BIIi4JYn880Wal72NCzfjmG9vnMiYWoYrlJe3D?=
 =?us-ascii?Q?qcJiD/1jVqtT733M5/R1HViOobnBx5lhJVjLiy1Fuicpj758jmBo25g+YElk?=
 =?us-ascii?Q?NbilriBauw/fitZM7GpiqpLnMWX7dARD8zwTLE7AmZvYD+4+JcOTbw5Lvr77?=
 =?us-ascii?Q?3jZaTi+T2Ur8llaAIlA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ebca669-7750-42df-1326-08d9f2e7d69e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 14:06:20.4980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZc4ZKMi6zIK4vuYm38165Ldxd0YihqSPwX9LPAV0PFRwhANwWKQTDvJVMKjz5Ma
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2450
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 08:01:47AM +0000, Tian, Kevin wrote:
 
> > A new ioctl VFIO_DEVICE_MIG_PRECOPY is provided to allow userspace to
> > query the progress of the precopy operation in the driver with the idea it
> > will judge to move to STOP_COPY at least once the initial data set is
> > transferred, and possibly after the dirty size has shrunk appropriately.
> > 
> > We think there may also be merit in future extensions to the
> > VFIO_DEVICE_MIG_PRECOPY ioctl to also command the device to throttle the
> > rate it generates internal dirty state.
> > 
> > Compared to the v1 clarification, STOP_COPY -> PRE_COPY is made optional
> 
> essentially it's *BLOCKED* per following context.

Yes I suppose now that we have the cap bits not the arc discovery this
isn't worded well

> > and to be defined in future. While making the whole PRE_COPY feature
> > optional eliminates the concern from mlx5, this is still a complicated arc
> > to implement and seems prudent to leave it closed until a proper use case
> 
> Can you shed some light on the complexity here?

It is with the data_fd, once a driver enters STOP_COPY it should stuff
its final state into the data_fd. If this is aborted back to PRE_COPY
then the data_fd needs to return to streaming changes. Managing this
transition is not trivial - it is something that has to be signaled to
the receiver.

There is also something of a race here where the data_fd can reach
end-of-stream and then the user can do STOP_COPY->PRE_COPY and
continue stuffing data. This makes the construction of the data stream
framing "interesting" as there is no longer a possible in-band end of
stream marker. See the other discussion about async operation why this
is not ideal.

Basically, it is behavior current qemu doesn't trigger that requires
significant complexity and testing in any driver to support
properly. No driver proposed

> Could a driver pretend supporting PRE_COPY by simply returning both 
> initial_bytes and dirty_bytes as ZERO?

I think so, yes.

> and even if the driver doesn't support the base arc (STOP_COPY->
> PRE_COPY_P2P) what about the combination arc (STOP_COPY->STOP->
> RUNNING_P2P->PRE_COPY_P2P)?

Userspace can walk through this sequence on its own, but it cannot be
part of the FSM because it violates the construction rules. The
data_fd is open in two places.

> current FSM already allows STOP->RUNNING_P2P->PRE_COPY_P2P and in
> concept STOP_COPY and STOP have exact same device behavior.

This is allowed because it follows the FSM rules. The data_fd is the
key difference.

> with that combination arc the interim transition from STOP_COPY to
> STOP will terminate the current data stream and RUNNING_P2P to
> PRE_COPY_P2P will return a new data fd. This does violate the definition
> about transition between three 'saving group' of states, which says
> moving between them does not terminate or otherwise affect the
> associated fd.

Right, and because this happens the VMM wuld have to terminate the
resuming session as well. Remember the output of a single saving
data_fd can be sent to a single receiving resuming data_fd - they
cannot be spliced.

> > is developed. We also split the pending_bytes report into the initial and
> > sustaining values, and define the protocol to get an event via poll() for
> 
> I guess this split must have been aligned in earlier discussion but it's still
> useful if some words can be put here for the motivation. Otherwise one 
> could easily ask why not treating the 1st read of pending_bytes as the 
> initial size.

As everything is estimates the approach allows the estimate to be
refined as we go along. PRE_COPY can stop at any time, but knowing
some initial mandatory stage has passed is somewhat consistent with
how qemu seems to treat this.

> > @@ -1596,25 +1596,59 @@ int vfio_mig_get_next_state(struct vfio_device
> > *device,
> >  	 *         RUNNING -> STOP
> >  	 *         STOP -> RUNNING
> 
> The comment for above should be updated too, which currently says:
> 
> 	 * Without P2P the driver must implement:
> 
> and also move it to the end as it talks about the arcs when neither
> P2P nor PRECOPY is supported.

Yes

> > + * PRE_COPY_P2P -> RUNNING_P2P
> >   * RUNNING -> RUNNING_P2P
> >   * STOP -> RUNNING_P2P
> >   *   While in RUNNING_P2P the device is partially running in the P2P
> > quiescent
> >   *   state defined below.
> >   *
> > + *   The PRE_COPY arc will terminate a data transfer session.
> 
> PRE_COPY_P2P

Yes

> 
> > + *
> > + * RUNNING -> PRE_COPY
> > + * RUNNING_P2P -> PRE_COPY_P2P
> >   * STOP -> STOP_COPY
> > - *   This arc begin the process of saving the device state and will return a
> > - *   new data_fd.
> > + *   PRE_COPY, PRE_COPY_P2P and STOP_COPY form the "saving group" of
> > states
> > + *   which share a data transfer session. Moving between these states alters
> > + *   what is streamed in session, but does not terminate or otherwise effect
> 
> 'effect' -> 'affect'?

yes

> > @@ -959,6 +1007,8 @@ struct vfio_device_feature_mig_state {
> >   * above FSM arcs. As there are multiple paths through the FSM arcs the
> > path
> >   * should be selected based on the following rules:
> >   *   - Select the shortest path.
> > + *   - The path cannot have saving group states as interior arcs, only
> > + *     starting/end states.
> 
> what about PRECOPY->PRECOPY_P2P->STOP_COPY? In this case
> PRECOPY_P2P is used as interior arc.

It isn't an interior arc because there are only two arcs :) But yes,
it is bit unclear.

> and if we disallow a non-saving-group state as interior arc when both 
> start and end states are saving-group states (e.g. 
> STOP_COPY->STOP->RUNNING_P2P->PRE_COPY_P2P as I asked in
> the start) then it might be another rule to be specified...

This isn't a shortest path.

> > @@ -972,6 +1022,9 @@ struct vfio_device_feature_mig_state {
> >   * support them. The user can disocver if these states are supported by using
> >   * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the
> > user can
> >   * avoid knowing about these optional states if the kernel driver supports
> > them.
> > + *
> > + * Arcs touching PRE_COPY and PRE_COPY_P2P are removed if support for
> > PRE_COPY
> > + * is not present.
> 
> why adding this sentence particularly for PRE_COPY? Isn't it already
> explained by last paragraph for optional states?

Well, I thought it was clarifying about how the optionality is
constructed.

> > + * Drivers should attempt to return estimates so that initial_bytes +
> > + * dirty_bytes matches the amount of data an immediate transition to
> > STOP_COPY
> > + * will require to be streamed.
> 
> I didn't understand this requirement. In an immediate transition to
> STOP_COPY I expect the amount of data covers the entire device
> state, i.e. initial_bytes. dirty_bytes are dynamic and iteratively returned
> then why we need set some expectation on the sum of 
> initial+round1_dity+round2_dirty+... 

"will require to be streamed" means additional data from this point
forward, not including anything already sent.

It turns into the estimate of how long STOP_COPY will take.

Jason
