Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B37E286E11
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 07:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgJHFZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 01:25:36 -0400
Received: from mail-eopbgr30127.outbound.protection.outlook.com ([40.107.3.127]:8770
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725858AbgJHFZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 01:25:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lS+kiVMIw/IlB5K5+7RHJcV65SNFmhbv93Hr690/ZQna/pYp+6hH+yrRC3bVyRzuOlDHqhCEDqbBheTK1odOD1bnBwqSz2B3nEKpVvYfjlFDSAX8+qNEm4umEZJRryr7g+W5ypLElHL93us3NNF6L/7CFRuCJNLl1AVPvynXeNkLDsKcm7CtRLwA0ibBgXeGXKw/2Pb+n1QCfDHIozpkfGSOz0FJulVOpbwQNFK50kWJ3HLlj4238ENj/mLguOVmfo8IQtaxdpYgaHIOzbWTncGKY0G4BBfjuGpyTRcJRmE5XFt6dp81d4nrqinbhDEDJ7eqfCrvAnSNtHg9JenjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uh5UG3UXWe5qtD3DwQjCni/+bl9LYiS17ym6q1sFE/Q=;
 b=oY53yxTeIQcBI4SBYZ8TqXFGbQj8RZH0FEyjtbESbmy+3uhvdfYlemh6ks4EFNJOMpRoodPjC2bg6vA7/wI7xrLp6DsH3U2Jtf5LcZTNksuitF/+cEoYoI4nHHEWUGB3BOT/RcIEIi02X/4fEvI9FCqbg4FHCMGZfQmHoYtrwWte2EK+3iuwi0se+qbJKDGJkt0NrVbOkolkFEQfwRsFOmHiZbrV7DaS9+gViLONgU1CiJIcjybpURTTKZ+KPp5Fz56DIu615EPO6FJn4+JuM+Dm1dcLl2IbXlyLdMQrjLUkWvy1SF3JXc9hIsXt3YjA09ufyKGnWG0HItE6/IDqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uh5UG3UXWe5qtD3DwQjCni/+bl9LYiS17ym6q1sFE/Q=;
 b=TcfianNIaO/CG+r5Bw5TCSeAfUPSeaVb7A34mrdJi1RZqlx4eP3XtkMdoNNvy0op333VL4A6BgsUSzInZZbKHG+Eh2Y4nY8+ypvBw6BdwSGVi4OmYoh1wRhxWjFuUg9Y08YB0Zj//bA4Vxlge47mycp5dIuM03cnWGiw3G6MRyc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM4PR05MB3460.eurprd05.prod.outlook.com (2603:10a6:205:6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Thu, 8 Oct
 2020 05:25:31 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 05:25:31 +0000
Date:   Thu, 8 Oct 2020 07:25:30 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 2/7] igb: take vlan double header into account
Message-ID: <20201008052530.e5knx3p2edak22cp@svensmacbookair.sven.lan>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-3-sven.auhagen@voleatech.de>
 <20201007210615.GA48010@ranger.igk.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007210615.GA48010@ranger.igk.intel.com>
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR04CA0111.eurprd04.prod.outlook.com
 (2603:10a6:208:55::16) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR04CA0111.eurprd04.prod.outlook.com (2603:10a6:208:55::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Thu, 8 Oct 2020 05:25:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ced54e6d-d3d8-4742-ec42-08d86b4a9316
X-MS-TrafficTypeDiagnostic: AM4PR05MB3460:
X-Microsoft-Antispam-PRVS: <AM4PR05MB3460B2AE18D1C0B88123E898EF0B0@AM4PR05MB3460.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /uQ8WnP3mJOLWqn6I4OPKfcmPeWAniac+F0c13W18fD5EUURwQQsflA8be+BbPktiRMdeWIL6JD5BLLi20f3YCnwcUfQY8rdY5n/bMLH1m7COs+3IhYUlwgbmaQY/G3gtr3s+23EJR5JmsWnZnTgi8ihWn2XcLkvZ73Km09ycgXpoIUs7UAu8S9ANzAF56+MYlSiclJD7prwqdUTEzhGUfLD0xw37SqDuPZxcC5wfNAiY5d1tbvTRxpcwvR30YNjz5mtyrKafscB0yK8fRIn5Wbc4SPLzHosxQz0RzBe4TNQ5UyaTKorUbTtr/Yi9MbfmczccY5EYS54rFyqAxdjbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39830400003)(4326008)(86362001)(66946007)(66476007)(66556008)(8936002)(16526019)(316002)(8676002)(26005)(7696005)(478600001)(186003)(6506007)(83380400001)(52116002)(5660300002)(2906002)(9686003)(1076003)(956004)(6916009)(44832011)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0JbGk77qUmBkpb88s8JvSmmfGv5l+18ujH5g29iaXMSeexFyCBFAL7TmUsHvRYO2j43SYLBUcqQWtWaV0be3aH8tiVt+gBedjrhDMli+jaA+dOSLtO457KihMWurfMQoTXEqCuzHX0BAldUpgMXQKSTl4BMqL0btU55K4rw4u82915iIxT+hgBeqzqj+fTi2RqdX205YLYasgUoq7byaERVUG93JNHvJicoQKX+t0nsUwjXDzHGptxSdEYWiaRb1sqom7aPczCLCNp04uD83XnAo7sv2iUkoWBmvOSnnAVcg8+3U6GKJHZZJIw8jd2qCbpxO5fwpEBNR08hg94iFIHbvLzIpoq33FKWnZWWX0sOvQK0WwJY+qBJCIsw4rwEmqLRgiuQ2yc1tJXKaqPInlaRBkE7Ull4CNNUC3PLV87mnorKDaawWl7RtHS6vIpWZU3WB929f0gYpbmDmz3xJpR3s50wA6iKZcnZDudiw+wLiByeErpAASd48V4IZQegnyerKDmGTWnz0pieC+Gx8Vah3qq0tmb0jIOKZ1oab6Gi/2BMPpsgbL3jnj497ZL3/rUbc5NWcy3h7Uj6+xLuW/3me64ob8vnx7t7kB2isbi5DG/tag9C74C6bjYfHXXIgwscs7H6Tyfsbly7INRUDNg==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ced54e6d-d3d8-4742-ec42-08d86b4a9316
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 05:25:31.4182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpOxXrWAHjxC6amVXhXe9Mnj4XFYHD8ERKs+JGPG7sqIRwjIIL4fXNUqgjhcwQcw/NmH8QFoP2SV+gyfUUaF0bt3oLiELeMr8xnBLtoKnSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3460
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 11:06:15PM +0200, Maciej Fijalkowski wrote:
> On Wed, Oct 07, 2020 at 05:25:01PM +0200, sven.auhagen@voleatech.de wrote:
> > From: Sven Auhagen <sven.auhagen@voleatech.de>
> > 
> > Increase the packet header padding to include double VLAN tagging.
> > This patch uses a macro for this.
> > 
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > ---
> >  drivers/net/ethernet/intel/igb/igb.h      | 5 +++++
> >  drivers/net/ethernet/intel/igb/igb_main.c | 7 +++----
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
> > index 0286d2fceee4..7afb67cf9b94 100644
> > --- a/drivers/net/ethernet/intel/igb/igb.h
> > +++ b/drivers/net/ethernet/intel/igb/igb.h
> > @@ -138,6 +138,8 @@ struct vf_mac_filter {
> >  /* this is the size past which hardware will drop packets when setting LPE=0 */
> >  #define MAXIMUM_ETHERNET_VLAN_SIZE 1522
> >  
> > +#define IGB_ETH_PKT_HDR_PAD	(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
> > +
> >  /* Supported Rx Buffer Sizes */
> >  #define IGB_RXBUFFER_256	256
> >  #define IGB_RXBUFFER_1536	1536
> > @@ -247,6 +249,9 @@ enum igb_tx_flags {
> >  #define IGB_SFF_ADDRESSING_MODE		0x4
> >  #define IGB_SFF_8472_UNSUP		0x00
> >  
> > +/* TX ressources are shared between XDP and netstack
> > + * and we need to tag the buffer type to distinguish them
> > + */
> 
> s/ressources/resources/
> 
> This comment sort of does not belong to this commit but I'm not sure what
> place would be better.

I had the same problem.
I don't think it is enough for an extra patch so I just added it here.
I fix the spelling.

> 
> >  enum igb_tx_buf_type {
> >  	IGB_TYPE_SKB = 0,
> >  	IGB_TYPE_XDP,
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > index 08cc6f59aa2e..0a9198037b98 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -2826,7 +2826,7 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
> >  
> >  static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> >  {
> > -	int i, frame_size = dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
> > +	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
> >  	struct igb_adapter *adapter = netdev_priv(dev);
> >  	bool running = netif_running(dev);
> >  	struct bpf_prog *old_prog;
> > @@ -3950,8 +3950,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
> >  	/* set default work limits */
> >  	adapter->tx_work_limit = IGB_DEFAULT_TX_WORK;
> >  
> > -	adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN +
> > -				  VLAN_HLEN;
> > +	adapter->max_frame_size = netdev->mtu + IGB_ETH_PKT_HDR_PAD;
> >  	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
> >  
> >  	spin_lock_init(&adapter->nfc_lock);
> > @@ -6491,7 +6490,7 @@ static void igb_get_stats64(struct net_device *netdev,
> >  static int igb_change_mtu(struct net_device *netdev, int new_mtu)
> >  {
> >  	struct igb_adapter *adapter = netdev_priv(netdev);
> > -	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
> > +	int max_frame = new_mtu + IGB_ETH_PKT_HDR_PAD;
> >  
> >  	if (adapter->xdp_prog) {
> >  		int i;
> > -- 
> > 2.20.1
> > 
