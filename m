Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237BC2AEE86
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgKKKK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:10:57 -0500
Received: from mail-eopbgr70120.outbound.protection.outlook.com ([40.107.7.120]:23038
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726031AbgKKKK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 05:10:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwU3iRW6vPXNLtQQtiHFg43RZ2vCzM9efIGQZ2Er+/lRV2OAg5FCVQM+vAVpxK4DCz+DxY9VyttHjhj1C8eX96eSiFVzQ0ipRHRxLQD13qDRnka/dmgfGmjBBTVfqYf5YTPJNMHktrmu4A+fpXZotZOERajea+pxnDNP8VBzifwIvbgR0eB+VnFL4fEx1lj8MMROsnc++kzQxEO1g9NaKnrSX2Qf6stI7e4tsnidW0wj0BEbdEbTXSxJDq6QaeEQdDrNz1WfZIu+aUIBWJTNatiTeAROS7M3fyEFMKgqL/DpJyfk5jO8FND5R8UtVMcqvtr0yKw0HDYJtI4PDBOQvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUuLxvjNnwDeAo91C7TEahavFAxen0sIEuYpK4Frjfk=;
 b=bv/c513NuKjVM2UchdiNWWniAzPY/oycoqPhrroqOEhxFzAmxWpR3oKp8bAB7/AEpBWH7UbpsTPgwPz8psu/vFHU5ZautIC1Lypa5GlPU543uMiBM16i235ti4BE6YjaAOv3PqJOqOmaHBFs6BtbnHb3XmHe5dmpFX/jYpIFrlpDXHMxtybr/7vxs9Efx1DJuSRogc+E9MyxqMyZ7OAHb+HrLq1qKvsVAoWexqyE0TO09KlyS6WqFe33abJeHBGnaSFGLD675eItX+4WucsVBhYWdVf4HG3VyTAqtNYtcH3Beweulsz6wvX2Qe5f5RkfpwnJuEjnxp9aKpuIaQPnqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUuLxvjNnwDeAo91C7TEahavFAxen0sIEuYpK4Frjfk=;
 b=XK8rK0S9yvoT1ZT1HRlYpyw0mFDp16reC/fAdj66/0TmcEW77dJ8nu7XMiEskRklqARnjN5rECn88KUHujQCNh1o8ZK5DXQesdi7LHyLDNL4mak3OBwiKTG7X+v6QC8oRaF2jA+iZhiZSL1jD9CGT8jR7LNtLwbv4JYsi74qYvI=
Authentication-Results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB5186.eurprd05.prod.outlook.com (2603:10a6:208:f3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 10:10:52 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 10:10:52 +0000
Date:   Wed, 11 Nov 2020 11:10:50 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, nhorman@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, brouer@redhat.com,
        davem@davemloft.net, sassmann@redhat.com
Subject: Re: [Intel-wired-lan] [PATCH net v3 3/6] igb: XDP extack message on
 error
Message-ID: <20201111101050.ffvl7cy34nkin27d@SvensMacBookAir.hq.voleatech.com>
References: <20201019080553.24353-1-sven.auhagen@voleatech.de>
 <20201019080553.24353-4-sven.auhagen@voleatech.de>
 <fc1f6aad-b587-25e2-0632-ea43f1032aad@molgen.mpg.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc1f6aad-b587-25e2-0632-ea43f1032aad@molgen.mpg.de>
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM4PR0501CA0066.eurprd05.prod.outlook.com
 (2603:10a6:200:68::34) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.41) by AM4PR0501CA0066.eurprd05.prod.outlook.com (2603:10a6:200:68::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 10:10:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 102971d9-e889-42f2-18b8-08d8862a11d9
X-MS-TrafficTypeDiagnostic: AM0PR05MB5186:
X-Microsoft-Antispam-PRVS: <AM0PR05MB518602A20744E7E9A814D080EFE80@AM0PR05MB5186.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: deowtK0/Lb7r6SyFvb001oyssizE3zI4iwmRAHkpagn09GyaY3JHpw96NxSguftyuD5lwUiPFKh/8nszpSJLWbjllmKq96GBZSoMZ8HB0N9cvnRCSXIYLgKImzKo61+e12Q24wpVEpVejShOZIbuhUCglG5dGj8neANd7Qay1rpguQA7WYlMFHefdN19NM6GzQtDg8qziToynu8QXUV1MkLSNCh6VpFVf/UlVN8v03d8rb8LFLzfnoIkhnQWrPInm07yzBvZ31N5aRvyw1TBIJREBkE6qBUSfQkhlNa8S9DbZPpa83zqhn9W972/T3n1shnu9i6u/Hd/1UpbjPKuXd1cjGylE0spqKUv0ZbOX9Ck7jJ2rSrTp1DBpcIvUe6rZECpxQ3e1PASfC3QoqShUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39830400003)(396003)(136003)(366004)(45080400002)(86362001)(15650500001)(16526019)(6916009)(186003)(1076003)(8936002)(66556008)(2906002)(966005)(66946007)(52116002)(66476007)(956004)(55016002)(5660300002)(6506007)(9686003)(26005)(7416002)(83380400001)(8676002)(316002)(4326008)(44832011)(7696005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: P3c7vX8CbZ/Y++lhXD8tNvwNODOGpMTHLWnaZn0C95OGDMpcSAaSzNUa+BLhdaBK22SnHtHmd5ONKnAuxi9Azqn3RPzx/Beprxx3dRF+GW7FWZXKk9EMElJR05Gsr0pstPKy/UdHN9VIQSH0YDvt8nlt5u+dw0TGhb6HiBGX5Pxw1X8tdWdL771JFyiTr6g0lEz1xpiVhDK43px6l0xlwlMrl+0VHz/zsz9Eo7BSehRpc2PZ/MMPtGgiAXaSZ/U9XH0H5qAuZCgXDYZyUlyPC3FTty4tLv0mX6j0ZLrj68I9+IhvS+h+Ug1RfBmvvvxxuR0qR28KT1rKp6Mq5dZt7trU93wMntMrjaDuF4hxHCoTaJ76slNAJCGY1ZYJdywc8snoP5AdpdNyqLPz5e1IdPACAP2MkQdxeKsiFAXik5zCrHp3HDB04Rkua1IY0Vd1mdTdczdqSgaP0Oyy19N722hOY1AlACxNcRmLLrjh7gvsSqcQ0bDOwj22KfGSvcjpXXOQeptgCZWGhvPqNO0VDfSo9mJxOkoLcX8W3h62cz4zh7jUbU/eUu9WW+JNv+TJl6IaWkz1QC928uQlAzz83fGx/IuqmRqRuEPc2zwpD3b6AT06kXIKJSVOCfRnS+ATIZgVlcgt5jrLVPt2xcbzww==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 102971d9-e889-42f2-18b8-08d8862a11d9
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 10:10:52.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHEQ+RLkjFjc488/r+m7drq+U2dTK2YkYcBLogmxDUSM4iowJfh6IZxbo9/cbIaLjFLS5cl5749blbT2hBy3L4PVSabsIYWoOCKxKWHXsnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5186
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

Dear Paul,

just to verify, NL_SET_ERR_MSG_MOD does not take any variable arguments
for the text to print.
What seems to be the common practive is to add a second log line
with netdev_warn to print out the sizes.

Is that what you are looking for?

Best
Sven

> 
> Could you please also add both size values to the error message?
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
