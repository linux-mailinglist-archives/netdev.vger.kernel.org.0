Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E2261637F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiKBNMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiKBNML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:12:11 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150134.outbound.protection.outlook.com [40.107.15.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509EF2A951;
        Wed,  2 Nov 2022 06:12:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InWEfc3lBcHi+WfpQHHqmOVbVlQrCce8fBK0dupEe/s8D7wQIbp7ur6hvSMFvUddv78qu7LkmuBCLtIYpOFkMWRNiBB/NkwSx+dcIWk9edDE4bxyAlAA7JCgBXS5z+eVDo+e2CqURYsYe0IB2JsuoyhdyRjql0zHz1RLVtjhWnrzzNMPte/pc/smRjzpK32py9YQIDpt/+uUlRVqJuCx1gS1/M8H5X1a9/wSDsWj9kNAKcl6pRE46KNJH7GwDl3yvq2lXM+JwM+spR6j09WDp0fYw0b4S+r4Uw7MAAvgEdUZ1zZL3rl6q8d5w9C8hDpZMYcFbfHc11proMDpGfO6sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuTgNIgRcLKjEuuSrqx6l2FVfZdPDBdbO6JARPrYLzs=;
 b=APjqeQ5CC7hhVyjwnqj5lIYbarymtytO8jW6ZrA52iKkD5UAZx58bwcFjR86ljWhGzdVW19VqTLYPK2+Kx1f2CsiCgq/JMgiGP6oiAEUa5N9yDOJE21LxloC/ZkmRh5uFrbDNSxi+r37o5Gmu/lixvnlOP+UYB/lN3+0gn6ZmzFgWTb6IWsYO8CeZRWzhx15vfdmIf6YaflS+mrfTiF1c/1GSxjcbWzjCxnEkyxwuXFUWA6oRyIj2FCTPOhusVTXVjhkt7qs4wMrEBfKdP4HmTDrUHkZa3/fZ+AUxcSrF9HeIx2VA5i7aVicGxM7p1YRgFoyTHhvZjOigaT66iQB5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=gmail.com smtp.mailfrom=arri.de; dmarc=none
 action=none header.from=arri.de; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuTgNIgRcLKjEuuSrqx6l2FVfZdPDBdbO6JARPrYLzs=;
 b=gkbsC0j9bwjqR//N0utcdywnzLigNNoVpb7x/KekDVdEgOPU4EL0KpKfHbWjditNbJzmjd2RXCrw8McEQalyIqVGfuXEjyPVatstOTHVgBNRBCtdvjJz56H+0YwRx38ejagEDtjY6G8lHdJzgvE+L/PtAJN6qFlHKyIxZ16NoAY=
Received: from AS8P250CA0019.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::24)
 by VI1PR07MB6365.eurprd07.prod.outlook.com (2603:10a6:800:137::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Wed, 2 Nov
 2022 13:12:00 +0000
Received: from AM0EUR02FT025.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:330:cafe::7a) by AS8P250CA0019.outlook.office365.com
 (2603:10a6:20b:330::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.21 via Frontend
 Transport; Wed, 2 Nov 2022 13:12:00 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 AM0EUR02FT025.mail.protection.outlook.com (10.13.54.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Wed, 2 Nov 2022 13:12:00 +0000
Received: from n95hx1g2.localnet (192.168.54.23) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.32; Wed, 2 Nov
 2022 14:11:59 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <Arun.Ramadoss@microchip.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <linux@armlinux.org.uk>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <b.hutchman@gmail.com>
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support for LAN937x switch
Date:   Wed, 2 Nov 2022 14:11:59 +0100
Message-ID: <2219283.iZASKD2KPV@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20221026214455.3n5f7eqp3duuie22@skbuf>
References: <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com> <20221026164753.13866-1-ceggers@arri.de> <20221026214455.3n5f7eqp3duuie22@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.23]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0EUR02FT025:EE_|VI1PR07MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: 5210adc1-66bc-4067-c495-08dabcd3d3ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5BrYXCsGVp5YhlcjlC4az69gqqf+K2l8M+Z5MxHVOu7Vahh7AvGS5KxawkJhZJNSlJQ1WS2vQr46Qsos0vptBNARJ/72xpXA7qvR2X4d0PmE36yyaHXA2jnRuMCetJ0vvGxPhoGlC43bcyaqmZJMH2XiFH5JGH+D9CcMfAH2Fx/8SnITnSVAHOJJlJXfDTI74BzVU7rCMhqE++OIVCkOdB9VsWwsq9BKxtvXycAO5JM0DOFdPg3715kiq7NJQidzWQhQUde0PQ0jiNkFq5SKNIFkt4zzJu9h/v0Ao46hBG9ccjKr31LMTofZoo9nIpr5zEQeYkSM1pGtxHtKR3Kg9I2vN4sEy5uqeEU12NydGsJ5FNgz2dInj5OKejQQqKr3qx0JTIneHELBRhp8DdHjXhTlAF2pLS1zQ5dJlhkMva3KHvMVU1J+cSpB/TYhIKAONTYWWCPrLNfJtLWCfa0TME2VxSXtRUF0QHfmtRhZDBOOiOSNEiDMipppA2UG1OoXZrq/JWqUaiKpAJqizjDP6u0XujsgI5qvzv9bPpvVEwguJa2sSmaB7FfUtD9Y9eT+6bPMmmfXy91KeO1yzKgHTBvrL0tuXuXGm+uTZUGaQp67DQHMfuUAmaAcDsXf4JR4xbWjdAo3bmn1r4q4L0US+QuWS0jXOEDtsxBqwHeyBRddvfbhVXyqXouCMgD+gZIkWp6jRbWNu6e2JK0Wl6t+D9pikUKrCWVFqjroP5ecZzRAhD5KR5qUmasUgpcRjYBskJuH4WOBjEhaQavLrMSngsyLVt3k43UFyoFuUABUbHoELb7UsOk6b4P8F4wbKF6Sr1rbS+sVCQZG9KbzBQFvWAXBaTd8Qg7Dq7aPqGEojH/Qopjg23HnVmYg2K0TsAGA9pe7IDD/B1vENmLoVLKaradMV7uIaEQjUdtAf5Hhgg=
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39850400004)(451199015)(36840700001)(40470700004)(46966006)(82740400003)(82310400005)(5660300002)(9576002)(41300700001)(8936002)(47076005)(83380400001)(186003)(336012)(33716001)(16526019)(86362001)(54906003)(40460700003)(316002)(356005)(81166007)(426003)(966005)(9686003)(26005)(36916002)(40480700001)(36860700001)(6862004)(8676002)(450100002)(478600001)(4326008)(70206006)(70586007)(107886003)(2906002)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 13:12:00.5705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5210adc1-66bc-4067-c495-08dabcd3d3ef
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: AM0EUR02FT025.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6365
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wednesday, 26 October 2022, 23:44:55 CEST, Vladimir Oltean wrote:
> Arun didn't share the PPS output patch publicly, so I don't know why
> we're discussing this here. Anyway, in it, Arun (incorrectly)
> implemented support for PTP_CLK_REQ_PPS rather than PTP_CLK_REQ_PEROUT,
> so there will not be any n_periodic_outputs visible in sysfs. For now,
> try via pps_available and pps_enable.
I can continue testing this week.  I can either try with the (incorrect)
PTP_CLK_REQ_PPS or I can try to forward port my earlier patches.

> > BTW: Which is the preferred delay measurement which I shall test (E2E/P2P)?
> 
> As this time around there is somebody from Microchip finally on the
> line, I will not interfere in this part. I tried once, and failed to
> understand the KSZ PTP philosophy. I hope you get some answers from
> Arun. Just one question below.
> 
> > I started with E2E is this was configured in the hardware and needs no 1-step
> > time stamping, but I had to add PTP_MSGTYPE_DELAY_REQ in ksz_port_txtstamp().
> 
> Hm? So if E2E "doesn't need" 1-step TX timestamping and KSZ9563 doesn't
> support 2-step TX timestamping, then what kind of TX timestamping is
> used here for Delay_Req messages?
> Perhaps you mean that E2E doesn't need moving the RX timestamp of the
> Pdelay_Req (t2) into the KSZ TX timestamp trailer of the Pdelay_Resp (t3)?
I think that Delay_Req is not related to 1-step / 2-step time stamping. As far
as I understand, this is only relevant for SYNC and PDelay_Resp.

> > > May be this is due to kconfig of config_ksz_ptp  defined bool instead
> > > of tristate. Do I need to change the config_ksz_ptp to tristate in
> > > order to compile as modules?
> > 
> > I'm not an expert for kbuild and cannot tell whether it's allowed to use
> > bool options which depend on tristate options. At least ksz_ptp.c is compiled
> > by kbuild if tristate is used. But I needed to add additional EXPORT_SYMBOL()
> > statements for all non-static functions (see below) for successful linking.
> 
> If ksz_ptp.o gets linked into ksz_ptp.ko, then yes. But this probably
> doesn't make sense, as you point out. So EXPORT_SYMBOL() should not be
> needed.
> 
> > I'm unsure whether it makes sense to build ksz_ptp as a separate module.
> > Perhaps it should be (conditionally) added to ksz_switch.ko.

So let's conditionally add ksz_ptp.o to ksz_switch.ko.

> >  static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
> >  				   struct hwtstamp_config *config)
> > @@ -106,7 +108,7 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
> >  	case HWTSTAMP_TX_OFF:
> >  		prt->hwts_tx_en = false;
> >  		break;
> > -	case HWTSTAMP_TX_ON:
> > +	case HWTSTAMP_TX_ONESTEP_P2P:
> 
> One shouldn't replace the other; this implementation is simplistic, of course.
> 
> Also, why did you choose HWTSTAMP_TX_ONESTEP_P2P and not HWTSTAMP_TX_ONESTEP_SYNC?
Because my (old) ptp4l.conf was configured for P2P+p2p1step.  When I started working on
KSZ9563 PTP two years ago, you suggested doing P2P first, because E2E is affected by nasty
packet filters on the switch hardware...  But for the first tests now I switched to E2E
for the reasons you mentioned above.

Probably HWTSTAMP_TX_ON needs to be rejected for KSZ9563 and only HWTSTAMP_TX_ONESTEP_SYNC
(for E2E) and HWTSTAMP_TX_ONESTEP_P2P (for P2P) should be accepted.

> 
> >  		prt->hwts_tx_en = true;
> >  		break;
> >  	default:
> > @@ -162,6 +164,7 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
> >  	mutex_unlock(&ptp_data->lock);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(ksz_hwtstamp_set);
> > diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> > index 582add3398d3..e7680718b478 100644
> > --- a/net/dsa/tag_ksz.c
> > +++ b/net/dsa/tag_ksz.c
> > @@ -251,17 +251,69 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9477);
> >  #define KSZ9893_TAIL_TAG_OVERRIDE	BIT(5)
> >  #define KSZ9893_TAIL_TAG_LOOKUP		BIT(6)
> > 
> > +/* Time stamp tag is only inserted if PTP is enabled in hardware. */
> > +static void ksz9893_xmit_timestamp(struct sk_buff *skb)
> > +{
> > +//	struct sk_buff *clone = KSZ9477_SKB_CB(skb)->clone;
> > +//	struct ptp_header *ptp_hdr;
> > +//	unsigned int ptp_type;
> > +	u32 tstamp_raw = 0;
> > +	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
> > +}
> 
> This is needed for one-step TX timestamping, ok.
Yes, here is some work left for 1-step PDelay_Resp.

> 
> > +
> > +/* Defer transmit if waiting for egress time stamp is required.  */
> > +static struct sk_buff *ksz9893_defer_xmit(struct dsa_port *dp,
> > +					  struct sk_buff *skb)
> 
> No need to duplicate, can rename lan937x_defer_xmit() and call that.
I wanted only "to make it run", I let the details for Arun.

> 
> Although I'm not exactly clear *which* packets will need deferred
> transmission on ksz9xxx. To my knowledge, such a procedure is only
> necessary for 2-step TX timestamping, when the TX timestamp must be
> propagated back to the socket error queue via skb_complete_tx_timestamp().
> For one-step, AFAIK*, this isn't needed.
As far as I remember, deferred xmit is needed for outgoing time stamps,
which are reported back to the application via the socket's error queue.
Because the KSZ time stamp unit only reports the time stamp itself (but
no sequence number or similar), only a single outgoing packet is allowed
to pass the TS unit at once. Otherwise no mapping between the TS and the
skb would be impossible.

> 
> This is not used, right? Because the function call is shortcircuited by
> the "if (test_bit(KSZ_HWTS_EN, &priv->state))" test earlier.
I am, quite sure that ksz9893_defer_xmit() is actually required.

> 
> *Or is this intended to be used for the "Software Two-Step Simulation
> Mode in hardware 1-Step Mode" that was suggested in the errata sheet,
> where one-step Sync messages still get their TX timestamp reported to
> user space as if they were two-step?
> http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9563R-Errata-80000786B.pdf
No, I didn't try to got that way.

regards,
Christian



