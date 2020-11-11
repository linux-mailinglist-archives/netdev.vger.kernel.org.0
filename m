Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4312AF600
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgKKQQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:16:26 -0500
Received: from mail-eopbgr00094.outbound.protection.outlook.com ([40.107.0.94]:65441
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgKKQQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:16:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K53YQgN8ex0jwhXvibQ4SfPIKMN8+6ai/fR8hmXJjcgV0SH8J8bAl23NonDNQYK6D6iB8Q+KiRQ/yO3Exm3sDC7xq6E5KF/WfqPId8Z2mZFsk79rraK6xrmQJ/dqa0Y3XfC+epGV+IYotH2Wr5ZZIG+uoLwz5OcEMlIKfl4UwR+ddV/XGko5Ofb+AXmOGrl01lKAupmKkug9NtkmX3iBUkbLxtIehWk9LtMeSmu3JyeZuPob0YooruLqpXWIDunc49/CkvOb5vUOOHhB6XJEq6iKVhgpKJ1f5rihKuvgNSFt2cU7nvzasieEeNyw0YAln5TtEnOvRolhux3dsdzpEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqKAch4QxZUfV3SzIYqcGGQASmYIDzKZePv/CGmVc64=;
 b=nMjR/KtSnXdZNamISG0JpG37c9O9Sfk1G6abl8qDZWS78g8aKzE2fTfypE5Pw0bWI/s2ZLDlJE9ok2PAmW+TXXF5JU2zECoFclXEDFbfD30nDnKfqDTGT8H7ScdnH44LRHjb4q3sIndjMe71r9yL4sPQuFzBJutoF7UPgyAgnbv9ZRzViwlubIBBIiPakaJMLCsGaayhqJ18UudGO+332kYR8A4cNTtIym4MlTNWLu7ttgKR9H2jY6wnX+Vn80TBFRQsnyV3+4O3Fv0ePbTfOHRrOpl2OT4HBr+RIp8Jc7v4FVyXsg4u+JRC3k79JMU+FhI5xnG6WyGoMBHGKEPzzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqKAch4QxZUfV3SzIYqcGGQASmYIDzKZePv/CGmVc64=;
 b=WydxbKN3zMUddlFlthV3ZHc4b9i8ckCapihi79ahLUXVvBUyiT5KG73scmbGX42HZkYrf34TWdWLRS/LwgfqPuqJheJ8yoBjWIUvGq6ko3D3ReDa94GscEuvVaYHsw1OdPH9T4acKNvauYEGMhP5KUaupe9dBiEZLT/JcSDbjeA=
Authentication-Results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6466.eurprd05.prod.outlook.com (2603:10a6:208:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Wed, 11 Nov
 2020 16:16:13 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 16:16:13 +0000
Date:   Wed, 11 Nov 2020 17:16:11 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, nhorman@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, brouer@redhat.com,
        davem@davemloft.net, sassmann@redhat.com
Subject: Re: [Intel-wired-lan] [PATCH net v3 3/6] igb: XDP extack message on
 error
Message-ID: <20201111161611.xf7yzdm5eoio73hx@SvensMacBookAir-2.local>
References: <20201019080553.24353-1-sven.auhagen@voleatech.de>
 <20201019080553.24353-4-sven.auhagen@voleatech.de>
 <fc1f6aad-b587-25e2-0632-ea43f1032aad@molgen.mpg.de>
 <20201111101050.ffvl7cy34nkin27d@SvensMacBookAir.hq.voleatech.com>
 <f54c2612-0d42-0422-3b0c-ecfdadd31dce@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f54c2612-0d42-0422-3b0c-ecfdadd31dce@molgen.mpg.de>
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: AM0PR10CA0088.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::41) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir-2.local (37.209.79.82) by AM0PR10CA0088.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 16:16:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a643fbb-0176-4ad0-e415-08d8865d1bae
X-MS-TrafficTypeDiagnostic: AM0PR05MB6466:
X-Microsoft-Antispam-PRVS: <AM0PR05MB64663A5844A2927940C022FEEFE80@AM0PR05MB6466.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONjMDknm92p0k/OxOiIQQgRXnh+kczOzUkRXE6zhsuhC22TjY8PKqVBN29ZRKxIw4qUwS77w8tNvxsL8WOdTIY5339mWxdJXDWtwf9Cz/bXK22zXIX+c0YfhN8yDhLj4BEFbRfrSq1wT0xIix/ABsanK/91Plg/1cPpmwZX+z9U9PEAnWA8LqueLXI8xaztDi5egx8ySLrvB/BzN3J8SY4P7T0QakxgMOacxLDVHyGDOO+TBAPATaruyzT2slYof++mmRFqcqa7w1a4lBKYna21ajWVtHkw3jGANW8gS0vHycgEGeB3wRpLaTCj4pe029znXlgPLf/MQ0kpCRcZpFVOLT9eik6WIwSQm9A6ydMbYvO37vLfPFjXXWC5iaILE2IsfO+RfLgWSHrwh+W3RdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39830400003)(136003)(366004)(8676002)(8936002)(5660300002)(4326008)(16526019)(66556008)(186003)(6506007)(83380400001)(956004)(7696005)(52116002)(316002)(66946007)(66476007)(1076003)(44832011)(86362001)(9686003)(7416002)(55016002)(2906002)(45080400002)(15650500001)(26005)(6916009)(966005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: imNmHxZFLPjkSY8UXj2uhs6OuuDsEqHgtW4OF0nU+bTdWTYt6Wm1GNjQlz1dmrIXQjx3D1nyjquHvmMx6u1J0IC6z7AJYAeGYodP5l1kP9sMCwFvB4WelFN/rGteJ5jC+FiggWbNO9lQxfPfhCjTR8YPihoClwavGRjo0/GERDWgrjck2BO21zZw1WGUpdg7UtGEiFApPn9de3HCL0OJebQIiqnbQyaLkPZ+LW7oimxFvR7/unp1bkp5xnUxuaKxaOc7ihmGm+Hr8NffDtrQxCBadAUx7oYd1V7tvJ6irxknBEB/IHeHtqWUZVW8pXGupdTI3gZU2LEHSeryWgzpDmkTh/nctjvxSRgKTbWYgVjRGI32f0C1+Brm3bA5Lv+68C2A8iGVHYYCBaVYpHpvBliI+zsk7u73DjeHbiUAbgJ67Q6QQ5OFwZ+eqFPwcC6TB6cfai6Ceb/UM2jnVqn6BjnINB58lG1itRTPKsNSOxKi1OfgGdH9pZcEoe10/YVMS4tSKho3vmuXoMpIZkUjW3ctRxHRkfHZT+Fw1R8WHr03xhZvnddPVU78mWur/oJbUGf0vdqZpwIh84ZJ9vVVeB/kCWjveDRXT6qS0vWTi+SztBF9zKtL8cJho3qrDHk32Rk3V9XAnU6Trc8LrzscfA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a643fbb-0176-4ad0-e415-08d8865d1bae
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 16:16:13.0508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJcvs3MHbMC9fBPB5Prurj3F7OmfHh/bZD5lu38lM6OFiU/44n2/GhH5yJnyRWjeVrdMNztnIvRhKtFQ6m8lXpArmvmZGdaJx36fTgye36c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6466
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:35:44AM +0100, Paul Menzel wrote:
> Dear Sven,
> 
> 
> Am 11.11.20 um 11:10 schrieb Sven Auhagen:
> > On Wed, Nov 11, 2020 at 08:11:46AM +0100, Paul Menzel wrote:
> 
> > > Am 19.10.20 um 10:05 schrieb sven.auhagen@voleatech.de:
> > > > From: Sven Auhagen <sven.auhagen@voleatech.de>
> > > > 
> > > > Add an extack error message when the RX buffer size is too small
> > > > for the frame size.
> > > > 
> > > > Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > > Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > > Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > > ---
> > > >    drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++++-----
> > > >    1 file changed, 7 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > > > index 0a9198037b98..088f9ddb0093 100644
> > > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > > @@ -2824,20 +2824,22 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
> > > >    	}
> > > >    }
> > > > -static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> > > > +static int igb_xdp_setup(struct net_device *dev, struct netdev_bpf *bpf)
> > > >    {
> > > >    	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
> > > >    	struct igb_adapter *adapter = netdev_priv(dev);
> > > > +	struct bpf_prog *prog = bpf->prog, *old_prog;
> > > >    	bool running = netif_running(dev);
> > > > -	struct bpf_prog *old_prog;
> > > >    	bool need_reset;
> > > >    	/* verify igb ring attributes are sufficient for XDP */
> > > >    	for (i = 0; i < adapter->num_rx_queues; i++) {
> > > >    		struct igb_ring *ring = adapter->rx_ring[i];
> > > > -		if (frame_size > igb_rx_bufsz(ring))
> > > > +		if (frame_size > igb_rx_bufsz(ring)) {
> > > > +			NL_SET_ERR_MSG_MOD(bpf->extack, "The RX buffer size is too small for the frame size");
> 
> > just to verify, NL_SET_ERR_MSG_MOD does not take any variable arguments
> > for the text to print.
> 
> Ah, Jesper remarked that too. Can the macro be extended?

It probably can be not as part of this patch series.

> 
> > What seems to be the common practice is to add a second log line
> > with netdev_warn to print out the sizes.
> > 
> > Is that what you are looking for?
> 
> Yes, though it sounds to cumbersome. So, yes, that’d be great for me, but up
> to you, if you think it’s useful.
> 

Let me add a netdev warn here so this patch can move forward
and the information is available.

Best
Sven

> 
> Kind regards,
> 
> Paul
> 
> 
> > > Could you please also add both size values to the error message?
> > > 
> > > >    			return -EINVAL;
> > > > +		}
> > > >    	}
> > > >    	old_prog = xchg(&adapter->xdp_prog, prog);
> > > > @@ -2869,7 +2871,7 @@ static int igb_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> > > >    {
> > > >    	switch (xdp->command) {
> > > >    	case XDP_SETUP_PROG:
> > > > -		return igb_xdp_setup(dev, xdp->prog);
> > > > +		return igb_xdp_setup(dev, xdp);
> > > >    	default:
> > > >    		return -EINVAL;
> > > >    	}
> > > > @@ -6499,7 +6501,7 @@ static int igb_change_mtu(struct net_device *netdev, int new_mtu)
> > > >    			struct igb_ring *ring = adapter->rx_ring[i];
> > > >    			if (max_frame > igb_rx_bufsz(ring)) {
> > > > -				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP\n");
> > > > +				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP. Max frame size is %d\n", max_frame);
> > > >    				return -EINVAL;
> > > >    			}
> > > >    		}
> > > > 
> > > 
> > > 
> > > Kind regards,
> > > 
> > > Paul
> > > 
> > > 
> > > PS: For commit message summaries, statements with verbs in imperative mood
> > > are quite common [1].
> > > 
> > > > igb: Print XDP extack error on too big frame size
> > > 
> > > 
> > > [1]: https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fchris.beams.io%2Fposts%2Fgit-commit%2F&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7C832ea50c701b4d89fd5508d8862d8c92%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637406877489969478%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=ITPcipxk%2Bg%2FR0QRssfiF5lm1K3mGJsB5wFkdF3SqiA0%3D&amp;reserved=0
