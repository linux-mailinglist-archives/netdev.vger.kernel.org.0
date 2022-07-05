Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572E35672E4
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiGEPnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiGEPnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:43:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA51A060
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 08:43:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmdfPBf3C6TdYKV/XDwG/E1zrSdR5mxMLchLzLil08YQOGF5KwsaxnRV6e1oBCDXz7e6W7P6grIkFlQaLbZ6qJR59mL9HsPASMEKL6B6YA6OXnoyMxPfRZMYCicLXIbr6esqVQ5pNobe6dABeji5JprThnVsWal9eXr+MLuKqNcmrv6MKGkKXETTZOTWBhLx0hCALwgyaiciQqHbLaAoXWlW2M+EVnf/8+JSik3kV6sOWKggqIUiX9PRZiSXS1bZwHUPt9abQSQc/6OTmgFMRn8qJYfqYoo4qPWZGQLR7f9uKCpeBLWdcGximHG4+6n87w+u2jY/bHNuVzbqcrHTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNPNMY1MevMjDAVMyOE2H48oIJppqLIUm9sEJXnt+Sc=;
 b=lGmKA4vUVcky+e8uihwDL3C0gJcfY013lBDTxJskgIHA9/uyRknZnx824EqGwMlkNAH7Q4um4+qZ0PbG4XXVHCR8CNKDnV9ZZw15xS5kMKpNfzm8Db+Rjzz2TtnTyNpoowbodJoswe7aZrwqw5DvNKFo/HQteLDfi2WwmD+wY+h4Us3ntMFSZ0I2Ql1sGlGvOdjEcEWxa1jpNLbKsu8ijOJdDUCjTHQ+pQzpw0IPDm3PT1+m6MLsihcdd1kVHXsuoqYU9qH1eoMdJs7vX441a5xPGmnfeJzDNohuiuplY18ODx+cRyxQlvFWusah6R07eLU+pj+MFMgm1KmKHm3H2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNPNMY1MevMjDAVMyOE2H48oIJppqLIUm9sEJXnt+Sc=;
 b=URn9oGf3qZvO52cYG8cUaF00lxWYgzyiSUE5Wf99PJo6C/G7Bp+/WDdoUFM5R4FZbtuoPI1Us615hmLBnOUgE68TWHZGc1NPM0i5fFAqtMNaX2FoUHVbBElx6iNxeocpAewYDv2bv3/rdNB7nQZqB+XPlI6QRNZLg6O+tLpf+z85X07rwdkPs8nxrjariZ/VIrYEck7Lc35gG5IiTvLsmsa+t/YrvpiSLPC9M4xLdZgfOPYPl9a98Df+3CZUsLZQKqQk3f4PDXYpJvrWk5sTzMhdwjgh10DP4+hMv4g4vB6jFTy7GeW6DUmPmPG0bfvx4pnfewz8TPidyOnHLM1L9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1364.namprd12.prod.outlook.com (2603:10b6:404:1e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 15:42:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 15:42:58 +0000
Date:   Tue, 5 Jul 2022 18:42:53 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, razor@blackwall.org
Subject: Re: Bridge VLAN memory leak
Message-ID: <YsRb/cJJ+zSKQkdD@shredder>
References: <87a69oc0qs.fsf@nvidia.com>
 <YsRCzTrajO5GZemf@shredder>
 <875ykbboi0.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875ykbboi0.fsf@nvidia.com>
X-ClientProxiedBy: LO2P265CA0332.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcbb9dfd-9c88-471e-920f-08da5e9d08f9
X-MS-TrafficTypeDiagnostic: BN6PR12MB1364:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwMxQ3JQHUzEvGLxyjNW8CHOa6GjiNkPXEdqtgw7LX6NGkUfBtYu394eJPeVs87DfutOgirpNjXsGPubKO4vir7Fl72c40eQGyplDFWIM92enj4/WHW+DiDqxa/KDALdY1nuvYH4871/1smNHV72ZYVWYrMRcJCdL+WK9yW0WbcfKdN1k5rbBxycVaPVckFuo711pi43YiEHBHMAZ0nl/0mltn2OfueMgGVMd5STWD9m8aUdhxrK4txZ5F9dtrrTHRPy3ck/8PQ6/bhDadc0Pdvwvgs5HSmM2ExQxca2FecB5Duph0ZuisnDEw1AcK+klgtw2irlVoUEJwl5SoMZ9m8wbZJcCRJGix9RCgAp/mZ8G4Zal96ql882F/BvsvvgLRnSPqPBkU9Q82eVmpMKZTcyaLP1q522cXgh1DtICd85QKZcREbBhfiH3ziKFJMewGY9ixfxxvh0POG7wviOou4c69Vg6ecuBzukdUoK8OLOEm3sxSo05x6lC3B7ywwg9mxzeLKN7uhs8YHYrWv8EKKkNXIkN175zB1lJyptC1GFbaBAXQlIsZMsZYxPicVfM9idVLQrt0veva+sLGDxxwOEyOiHkgpzdgMeM50zirNvsZjQySVaFF9C3m4uELWULNLEJzxKaKWOc7BWjrQu16Qk4pqR/HQ61f/Orpl1XR625vZ1WKX/OsTEGmuXRz5ILq0myjmI5IVDbbwdj331q58Z5biFcm2l/3Wf5xnztqZKOfXnNKrUBM/yVA/gqZmg/ntVj8V0z9nTWlTuw5u8gLHdxY4kTzy7qxGZIwNzuwAyJtuTGbHbglzOWNJ4yd5WnzVgE1GXTfgdnapboY+cA9w9bekuogTsuCsmtGDLClipS4y+mqs9il5UVoZBrouXZLrXvR/f5Mc/NdNtywSRrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(8676002)(4326008)(33716001)(66946007)(66556008)(66476007)(478600001)(6486002)(966005)(186003)(6666004)(6506007)(41300700001)(54906003)(6636002)(9686003)(83380400001)(316002)(26005)(86362001)(6512007)(2906002)(38100700002)(3480700007)(8936002)(6862004)(5660300002)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u0sBc7Z/oeNbBTNIHQoGq7VTRwv655JI8AF1tKJ7O7rYv+9ZHN1EWk9AY7/V?=
 =?us-ascii?Q?BMGNg+uv0R91+RkIgb6v9xAUTSyti9eARCYgCdNUALzIFjyCobSn2PPmyUZd?=
 =?us-ascii?Q?pPzr8nYSMhmHNe0SrBK/X7bgmPCoz+1P6TrM8kOtrRZREpAEz8+iSEuNTSQw?=
 =?us-ascii?Q?MddFDlSuJ8oFF8vorWtR7KIqn2SrTvJ+eHtt1Mc0erpgU73vylvnO0KfndPW?=
 =?us-ascii?Q?OHks2mk/kv+zlsejB+BLQWY4EcBEK3ohkn/I7PJ+xMwO9NlxeE9eZcxvfIfB?=
 =?us-ascii?Q?H2KrWoRrjdm1TIPBfC8kQBu1a9EkYnQsu/AbMrV3q11OME7tE6RLTqHqEgc4?=
 =?us-ascii?Q?oYOgx8b365+ExPxzbmEjfoJM1oqvvFtOCL0ipCHLMJzjIFWBt+5Zk5PiWJ1J?=
 =?us-ascii?Q?DAVL9z2x3UVVu6P3Yc1pE6z7jT2DVReyiYs+a1n5KamnoC5fpOUxu4NktU11?=
 =?us-ascii?Q?ENYzXV4aaExNdbym9ZoDl9CTPSkWmrll4aUCs6Q2dp7E/SVJEvyH5GCJO54B?=
 =?us-ascii?Q?aRgbLpYi+PvkgudANmyb4I4ko3kB0FLI3/aWzZn1byCHdYtZ1qgHM/x4qIgZ?=
 =?us-ascii?Q?IcKExSyEPeFw0ah0cLlyz+2JbXHw3J51SY8l4UlXC6EGYRIqNMPoKjuvClWk?=
 =?us-ascii?Q?Htuj1wVuLJKZ6vKhI3WMNILDFDIW/HCoBq9z152lNYbPUtmmOlmkkM31BvUi?=
 =?us-ascii?Q?IvsXjGmKzuthNUy7IW8OlS792BPsa4GSIdW6Simg+uMZDPe1cWrh/3o1y9P0?=
 =?us-ascii?Q?9dWRmV/5t2avOtSFDINgVXRMmzFcUkrw4/uzW+fReER8ql8U7I7GX/UnEU5/?=
 =?us-ascii?Q?BMpnUyHR1Nnw4ODU3iU0nHNf+TISnHqOrfPkpWgpf/enC34I2PwF/vsTEpgt?=
 =?us-ascii?Q?ouo2z9c7LVR9NmVhfZ9AH3WsOE3KlsJsRtGwafhVKWcBOL0boYNLzJc+jYP8?=
 =?us-ascii?Q?e19OxKlzou/sTn5D+3xwSv0nJIIIARQnXlzjowT+UkG2OHY/ilOjRbCgVA8+?=
 =?us-ascii?Q?TVrqyGufOrDJwKGDiOfTXMJWlUqz7m7MnGhICFm09Da9M90NmL2xkJT9sSQi?=
 =?us-ascii?Q?s0ytnpmm8lrIcJURTASmRW9eWhvPb4GjUlxAjjIOferq6IR/DCRV+ztfUekW?=
 =?us-ascii?Q?uht8z7iQZyTNkwtc/umqUEx0sfcVv+/lGaBXmTdINSj2IQJrP/Kp1zUGTHWC?=
 =?us-ascii?Q?ITmDrhNiHbgbhbUiEG2XJt2TqV3qrD4U2h8QjGM+o4D+7w8PkgdpMMk//ykc?=
 =?us-ascii?Q?TisZMX5Ssrz1gLP/knOCnKUA5T3wmAHLdlVbMQpEQMEkifCj0dbYv6r6wowJ?=
 =?us-ascii?Q?phs6U/MaCkFSZ4JXlxPWH7CQqUtXuY5AlxOjHIOfACL4z3nYHdUSqjN/MApd?=
 =?us-ascii?Q?C3ap04kj48Mj1xfWADU+HqYepsu6Ghs/oN+SPFLi0oM1uH+60wwJEXFXSRNt?=
 =?us-ascii?Q?lSr9ThcOgUuuKULDw5160nvlOmdBVF0aObOMSCT3VVAb2Bd5Rf3YzYj+Bqky?=
 =?us-ascii?Q?Bs51+bhI7ambnlHSlfNhYbHFp+eB6NbQj0KsamyYEm9i9slp8mwFSnhlRn+m?=
 =?us-ascii?Q?iSc2gvMmKEFL1kazjQ0oqUQ09xQF3hd2jbN3f6Uw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcbb9dfd-9c88-471e-920f-08da5e9d08f9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 15:42:58.1827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUE+RXPXEFv/hD7GlA3Fk/QECdkCsawySAy7YcR2k/VzfYOqkSrSxDZ115r9K0W4Dr7f8JfLyeijs6/3RUEz1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1364
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 05:46:49PM +0300, Vlad Buslov wrote:
> On Tue 05 Jul 2022 at 16:55, Ido Schimmel <idosch@nvidia.com> wrote:
> > On Mon, Jul 04, 2022 at 06:47:29PM +0300, Vlad Buslov wrote:
> >> Hi Ido,
> >> 
> >> While implementing QinQ offload support in mlx5 I encountered a memory
> >> leak[0] in the bridge implementation which seems to be related to the new
> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag that you have recently added.
> >
> > FTR, added here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=279737939a8194f02fa352ab4476a1b241f44ef4
> >
> >> 
> >> To reproduce the issue netdevice must support bridge VLAN offload, so I
> >> can't provide a simple script that uses veth or anything like that.
> >> Instead, I'll describe the issue step-by-step:
> >> 
> >> 1. Create a bridge, add offload-capable netdevs to it and assign some
> >> VLAN to them. __vlan_vid_add() function will set the
> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag since br_switchdev_port_vlan_add()
> >> should return 0 if dev can offload VLANs and will also skip call to
> >> vlan_vid_add() in such case:
> >> 
> >>         /* Try switchdev op first. In case it is not supported, fallback to
> >>          * 8021q add.
> >>          */
> >>         err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, extack);
> >>         if (err == -EOPNOTSUPP)
> >>                 return vlan_vid_add(dev, br->vlan_proto, v->vid);
> >>         v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
> >> 
> >> 2. Enable filtering and set VLAN protocol to 802.1ad. That will trigger
> >> the following code in __br_vlan_set_proto() that re-creates existing
> >> VLANs with vlan_vid_add() function call whether they have the
> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set or not:
> >> 
> >>          /* Add VLANs for the new proto to the device filter. */
> >>          list_for_each_entry(p, &br->port_list, list) {
> >>                  vg = nbp_vlan_group(p);
> >>                  list_for_each_entry(vlan, &vg->vlan_list, vlist) {
> >>                          err = vlan_vid_add(p->dev, proto, vlan->vid);
> >>                          if (err)
> >>                                  goto err_filt;
> >>                  }
> >>          }
> >> 
> >> 3. Now delete the bridge. That will delete all existing VLANs via
> >> __vlan_vid_del() function, which skips calling vlan_vid_del() (that is
> >> necessary to clean up after vlan_vid_add()) if VLAN has
> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag set:
> >> 
> >>          /* Try switchdev op first. In case it is not supported, fallback to
> >>           * 8021q del.
> >>           */
> >>          err = br_switchdev_port_vlan_del(dev, v->vid);
> >>          if (!(v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV))
> >>                  vlan_vid_del(dev, br->vlan_proto, v->vid);
> >
> > Looking at the code before the change, I'm pretty sure you will be able
> > to reproduce the leak prior to above mentioned commit:
> >
> > ```
> > -	err = br_switchdev_port_vlan_del(dev, vid);
> > -	if (err == -EOPNOTSUPP) {
> > -		vlan_vid_del(dev, br->vlan_proto, vid);
> > -		return 0;
> > -	}
> > -	return err;
> > ```
> >
> >> 
> >> 
> >> The issue doesn't reproduce for me anymore if I just clear the
> >> BR_VLFLAG_ADDED_BY_SWITCHDEV flag when re-creating VLANs on step 2.
> >> However, I'm not sure whether it is the right approach in this case.
> >> WDYT?
> >
> > As a switchdev driver you already know about the new VLAN protocol via
> > 'SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL' so do we really need the VLANs
> > to be programmed again? The VLAN protocol is not communicated in
> > 'SWITCHDEV_OBJ_ID_PORT_VLAN' anyway.
> 
> In my WIP implementation of 802.1ad offload I just re-create all
> existing VLANs in hardware with new protocol upon receiving
> SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL notification.

Would it be easier for you if you got the VLAN protocol in
'SWITCHDEV_OBJ_ID_PORT_VLAN' and __br_vlan_set_proto() would invoke
__vlan_vid_add() and __vlan_vid_del() instead of calling the 8021q
driver directly?

> 
> >
> > Can you try the below (compile tested only)?
> 
> With the patch applied memleak no longer reproduces.
> 
> >
> > ```
> > diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> > index 6e53dc991409..9ffd40b8270c 100644
> > --- a/net/bridge/br_vlan.c
> > +++ b/net/bridge/br_vlan.c
> > @@ -959,6 +959,8 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
> >  	list_for_each_entry(p, &br->port_list, list) {
> >  		vg = nbp_vlan_group(p);
> >  		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
> > +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> > +				continue;
> >  			err = vlan_vid_add(p->dev, proto, vlan->vid);
> >  			if (err)
> >  				goto err_filt;
> > @@ -973,8 +975,11 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
> >  	/* Delete VLANs for the old proto from the device filter. */
> >  	list_for_each_entry(p, &br->port_list, list) {
> >  		vg = nbp_vlan_group(p);
> > -		list_for_each_entry(vlan, &vg->vlan_list, vlist)
> > +		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
> > +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> > +				continue;
> >  			vlan_vid_del(p->dev, oldproto, vlan->vid);
> > +		}
> >  	}
> >  
> >  	return 0;
> > @@ -983,13 +988,19 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto,
> >  	attr.u.vlan_protocol = ntohs(oldproto);
> >  	switchdev_port_attr_set(br->dev, &attr, NULL);
> >  
> > -	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
> > +	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist) {
> > +		if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> > +			continue;
> >  		vlan_vid_del(p->dev, proto, vlan->vid);
> > +	}
> >  
> >  	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
> >  		vg = nbp_vlan_group(p);
> > -		list_for_each_entry(vlan, &vg->vlan_list, vlist)
> > +		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
> > +			if (vlan->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
> > +				continue;
> >  			vlan_vid_del(p->dev, proto, vlan->vid);
> > +		}
> >  	}
> >  
> >  	return err;
> > ```
> >
> >> 
> >> [0]:
> >> 
> >> unreferenced object 0xffff8881f6771200 (size 256):
> >>   comm "ip", pid 446855, jiffies 4298238841 (age 55.240s)
> >>   hex dump (first 32 bytes):
> >>     00 00 7f 0e 83 88 ff ff 00 00 00 00 00 00 00 00  ................
> >>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>   backtrace:
> >>     [<00000000012819ac>] vlan_vid_add+0x437/0x750
> >>     [<00000000f2281fad>] __br_vlan_set_proto+0x289/0x920
> >>     [<000000000632b56f>] br_changelink+0x3d6/0x13f0
> >>     [<0000000089d25f04>] __rtnl_newlink+0x8ae/0x14c0
> >>     [<00000000f6276baf>] rtnl_newlink+0x5f/0x90
> >>     [<00000000746dc902>] rtnetlink_rcv_msg+0x336/0xa00
> >>     [<000000001c2241c0>] netlink_rcv_skb+0x11d/0x340
> >>     [<0000000010588814>] netlink_unicast+0x438/0x710
> >>     [<00000000e1a4cd5c>] netlink_sendmsg+0x788/0xc40
> >>     [<00000000e8992d4e>] sock_sendmsg+0xb0/0xe0
> >>     [<00000000621b8f91>] ____sys_sendmsg+0x4ff/0x6d0
> >>     [<000000000ea26996>] ___sys_sendmsg+0x12e/0x1b0
> >>     [<00000000684f7e25>] __sys_sendmsg+0xab/0x130
> >>     [<000000004538b104>] do_syscall_64+0x3d/0x90
> >>     [<0000000091ed9678>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >> 
> >> 
> >> Regards,
> >> Vlad
> 
