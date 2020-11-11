Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F48F2AEDF4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgKKJjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:39:21 -0500
Received: from mail-vi1eur05on2092.outbound.protection.outlook.com ([40.107.21.92]:56072
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbgKKJjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 04:39:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWzIRd/AUeF4dCPQLqiRAocYdOnKk3Z5XX2zYMKoh0ypV5vKB4+aNiHLjfhl+OQGEEtZ3BqdZ7Fgp0E14vto2pxFi6s1geDe7oLteuOE3dEm3JVeGKMbcnnPkYDB6hnMsSDDjpRYEcbG7zlbU0yIPR7btWTDCKSpzVZ7eS9vAlPOW0BqbbSC/ZTlNJdHwLL1Otov2yt6bkrqghnBCet+jW4HzvNrULUcMhGC6rt+PJMAyIn2yd4lbcrE6KOIHehRzdn+Z3nD3AEJqg1S5nmLyQtgbw2pi6vDsPcRlsexqvm7tJKviAIwb0Y4G7Uq4hjLTfdejVjhBM2Q1jVjtOjbjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekLyt+6oWWJvOqHM28gK4T7P2tBMLYf7chXGNYqtNBM=;
 b=kGkaJRWylQgHc2E+030IIk8s/g3957fBhC0tQy7MdJamHSxoBHfTnNgBWw/zlDj3V9ADueFKnYmBC+ZPX6Dc7unWET1PhSp3Xtg471Rlgg9WPvSPsp5aQ9tqoOoDut+W1dWMD1xRVX7weSvWUdgr46EEtybpbWutDZWD5FyZrvFyOy/yrn65D9vWuUhSgpVKZg8YMF1uwaNAHABcFY00EOzhcYKNjKJzzDbzujjZQ17EMuvKiMjRxwTNrQR6WZHaKOm8IkTVtO6cGzPZw118dR2lkeM5/G88W1fRD4bjps5HRH+PCEbH1YFVH3pr5LX9EptI+GyDgM4PNw1CWuQ5+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekLyt+6oWWJvOqHM28gK4T7P2tBMLYf7chXGNYqtNBM=;
 b=b2sU+RFjjXnyesm1rrSb7+3qofn1S73WxYDYrROgiXTzIntfwVtESRbF0qV/jKK6V9LhOoB9PnLXtoduL3GppTq+yyB/pTTcjytJ9B9MpAhG03WukNHM+6EcWh2B3J1Z3Rrz36TveBbvMv3J0EkWECAYsjcjfYAzY5H4RZiVepw=
Authentication-Results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM9PR05MB7793.eurprd05.prod.outlook.com (2603:10a6:20b:2c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 09:39:11 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 09:39:11 +0000
Date:   Wed, 11 Nov 2020 10:39:09 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, nhorman@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, brouer@redhat.com,
        davem@davemloft.net, sassmann@redhat.com
Subject: Re: [Intel-wired-lan] [PATCH net v3 3/6] igb: XDP extack message on
 error
Message-ID: <20201111093909.wukhqafy3khycks5@SvensMacbookPro.hq.voleatech.com>
References: <20201019080553.24353-1-sven.auhagen@voleatech.de>
 <20201019080553.24353-4-sven.auhagen@voleatech.de>
 <fc1f6aad-b587-25e2-0632-ea43f1032aad@molgen.mpg.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc1f6aad-b587-25e2-0632-ea43f1032aad@molgen.mpg.de>
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM0PR08CA0033.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::46) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.41) by AM0PR08CA0033.eurprd08.prod.outlook.com (2603:10a6:208:d2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 09:39:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 501f687c-dd5b-4187-fe11-08d88625a4f4
X-MS-TrafficTypeDiagnostic: AM9PR05MB7793:
X-Microsoft-Antispam-PRVS: <AM9PR05MB77931C36353554CC9A71D97FEFE80@AM9PR05MB7793.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9tQ/zZzpOZdCvTBvln7B0bgp+sKtDf2pE3rwtQZAGlpHGJKo6H3h4bIfKTZG6XKYRocQctyBaOuWOpJCAYeTlaXj05WcAL+x1xT4e0JoXfYN5j4EzAI8FnrYJ5fjRQA8cZgRxdcS8ZtvnLBfZgZxWCGjSAl29ckSxAtLP+fxSdEf2qhINkNNwDEa7wBu3D0KkqkyJOT5Od5D/HA5EF1SuZ3fHeR+U+hN+YvJdx5EWLdr2poPRa/WFpyP6QCFE+nG5m2tGPR7ZNLwuCLPlT0rU7wTsYcAlq6uGhS6Ie/yei5MskaThH05ucI5DT3FgoZ79BBfzeevlP1g5ZsRyktNp+AauCgTQmp4Zg33FTVPUNnpHUIk717je/QzW0HEfeBYrDovsklvzj4ZNNPIVLfoJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(39830400003)(136003)(83380400001)(44832011)(7696005)(186003)(26005)(956004)(6916009)(6506007)(4326008)(16526019)(316002)(8676002)(52116002)(7416002)(86362001)(66556008)(8936002)(9686003)(1076003)(2906002)(55016002)(66476007)(5660300002)(45080400002)(15650500001)(966005)(66946007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DrQVhNYt45PH4UAUnVYly/Os7Ql27yqx0SKyZhoDgEAZ+iZ5tPfLtxHl5Q/qgtRKZXj9e6XO10ktlpdvOUkMkC7OWcl7ocGu7rIkWhnOmp6NVW55Sh34mH9cmg8OirvAJtpDqpnfvhYC56Rrz9sVZuv96ytIiiPf5XspKBBAFt8g/zBKkZ25G8q9orVLAeFQcdmm4rPE1OMM2L4f9DZVDDEtMkBKDLwvYBM6jPzcBWGgs/xxTK/ZLj68hUCGXxCAt3IoxFToHrZLf8y/k5wkA/odt8hzVPQ6Ex/NqbP4NZ77QUiflKnxbr5MFRG+o7bc/lLPZlEKblJHJvswtvDJ50fSTFJ6gDlM6+YaYQ6/urQNJVaLL7xhPMe2uDChLXcW64jFeJq3veu2DEzhKfZ/r3YoZR3eVpaeQtQykfkA4WFxRl/QCSl2YWyFhs0wFkA0lxCtYL9ML+WY73g1Zmcr4yonkomK4HIGRT9FqEKT3GDiwMkL+CHfCetkpUvo/CWG9q+ydf3LXAMRzNqudkitDn4B9Euz4zyPVQFydYC+i3MifYlevrPpXK9FJKDj7pKvIlUzVX0BGk1xrMU+BVQ2Q3HAp8nw1+0TdE5iSk5+qye8Msrnfs/cCkbaJCeyMlwvAALSg/G4WEn5P7B+LpMnRg==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 501f687c-dd5b-4187-fe11-08d88625a4f4
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 09:39:11.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8rR8egJPpJShXtd1bm+jqDILQlu3XYLhHud4RJZ2cGngJoESW6YegtM5wMl1RhXMgs+8j+LrS+XVoduhn/hm8GENqvSOMLN4e7E9xlREDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR05MB7793
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 08:11:46AM +0100, Paul Menzel wrote:
> Dear Sven,
> 
> 
> Am 19.10.20 um 10:05 schrieb sven.auhagen@voleatech.de:
> > From: Sven Auhagen <sven.auhagen@voleatech.de>
> > 
> > Add an extack error message when the RX buffer size is too small
> > for the frame size.
> > 
> > Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > ---
> >   drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++++-----
> >   1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > index 0a9198037b98..088f9ddb0093 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -2824,20 +2824,22 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
> >   	}
> >   }
> > -static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> > +static int igb_xdp_setup(struct net_device *dev, struct netdev_bpf *bpf)
> >   {
> >   	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
> >   	struct igb_adapter *adapter = netdev_priv(dev);
> > +	struct bpf_prog *prog = bpf->prog, *old_prog;
> >   	bool running = netif_running(dev);
> > -	struct bpf_prog *old_prog;
> >   	bool need_reset;
> >   	/* verify igb ring attributes are sufficient for XDP */
> >   	for (i = 0; i < adapter->num_rx_queues; i++) {
> >   		struct igb_ring *ring = adapter->rx_ring[i];
> > -		if (frame_size > igb_rx_bufsz(ring))
> > +		if (frame_size > igb_rx_bufsz(ring)) {
> > +			NL_SET_ERR_MSG_MOD(bpf->extack, "The RX buffer size is too small for the frame size");
> 
> Could you please also add both size values to the error message?

Dear Paul,

yes, sure.
I will send a new series with that change.

Best
Sven

> 
> >   			return -EINVAL;
> > +		}
> >   	}
> >   	old_prog = xchg(&adapter->xdp_prog, prog);
> > @@ -2869,7 +2871,7 @@ static int igb_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> >   {
> >   	switch (xdp->command) {
> >   	case XDP_SETUP_PROG:
> > -		return igb_xdp_setup(dev, xdp->prog);
> > +		return igb_xdp_setup(dev, xdp);
> >   	default:
> >   		return -EINVAL;
> >   	}
> > @@ -6499,7 +6501,7 @@ static int igb_change_mtu(struct net_device *netdev, int new_mtu)
> >   			struct igb_ring *ring = adapter->rx_ring[i];
> >   			if (max_frame > igb_rx_bufsz(ring)) {
> > -				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP\n");
> > +				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP. Max frame size is %d\n", max_frame);
> >   				return -EINVAL;
> >   			}
> >   		}
> > 
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> PS: For commit message summaries, statements with verbs in imperative mood
> are quite common [1].
> 
> > igb: Print XDP extack error on too big frame size
> 
> 
> [1]: https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fchris.beams.io%2Fposts%2Fgit-commit%2F&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Cc2916e4caf384512cdf808d886110df9%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637406755112287943%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=wBvX6q4trM7FQLp5Nxccqrbo%2ForvF5KG1YG7TRc7cKQ%3D&amp;reserved=0
