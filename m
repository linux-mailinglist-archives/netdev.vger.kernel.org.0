Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FEA1C4CDD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 06:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgEEEB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 00:01:56 -0400
Received: from mail-am6eur05on2098.outbound.protection.outlook.com ([40.107.22.98]:56033
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726093AbgEEEBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 00:01:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFxVd/5PhJz9Rvt7irGBJr6ubevWDX6JdLZexcuy9Ul1U0evzrG96+F3LdzrI3DtORs+hLEA4l0aKNQ+nkHadvhJAIvAcVsGu0S9A1tc3aaTHC4d+9TexjnQYivQqfM4OhyevHEQhv0jIcuDO324Xqky8xBnRmEdomlOIqwpBL8ncu3kKOhi6qJC8NzkH6XhrRVyrsZl48ER09yS7cZ/MVyVPfzW7ZRLou1aYwKbGN/H8KyGrQVjjyxub18hqi/n+FRkupMq2fZLkusTw8xbWen77Vk/ciCRDRRw203Eq8aX0IbG0kL4duzDbFOu1QXctGAHHZEOQatSgBW0va0jhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYtO+JowFlxyedys5xZ7moNd78uh18V7S2FikwlpD3w=;
 b=DA7CepExGd+itu1FvK6vfHjC+xt72XBV6BVkW5R75ehaw6snT8s/M0fXbPSVyyBkluT/0KkHqxlU0vqBaxji+Bn998Kn9ysVbQ9AmZLVTkhZG15RGEJpdWtZFGaa3opNIFkm47rt1JvD84Cn0M11K8XTdIZgk1s76CoyTTuRkQqrPnAStkLiY0RIrPnGxbJ2LWfXo8TS5VFMygTvQn3CEOqjrAPn1na+b7pNZYWCaDPtLL/TnwrclkRVlMP/826olerUbxvf51k1Ub7CG40bGxSXWPfUt5gRfV1lswguksQ64vqLqkXna1f7kfzzm+XyEfBFPrDGD1Q+0x89AjOgdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYtO+JowFlxyedys5xZ7moNd78uh18V7S2FikwlpD3w=;
 b=mmmKx2rtAFsyU8qj9xWqOHrNYOOkpZK4ucU7NHrK1/YsulbY3JeHyhomTk6vRVrSU2b9+fPbC33bs3lvHB+csXaPzU9Udh4he4pd6JO8JrgfoPaFk9/GSbtQ8PGu+fuvzcnbO4/RW1z58TRJzpf+QPuxk+Xm8S3aT3AnIPbjvmE=
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0031.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Tue, 5 May
 2020 04:01:51 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2958.029; Tue, 5 May 2020
 04:01:51 +0000
Date:   Tue, 5 May 2020 07:01:43 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Message-ID: <20200505040143.GA18414@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200305144937.GA132852@splinter>
 <20200502152049.GA8513@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502152049.GA8513@plvision.eu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR10CA0030.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::43) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR10CA0030.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 04:01:49 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12857473-317f-489a-a973-08d7f0a90a1e
X-MS-TrafficTypeDiagnostic: VI1P190MB0031:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0031B8B18034A78A3B3BD3EE95A70@VI1P190MB0031.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7TnD8XDuZF2whlhWkGaFTT6/MCu8olFU1DuT9m5Jnal6ri0LqRt2SsOyGgH/kmfd098rSU2zu3j1exDq6rQcGQ05z5Oc+YJSgneHRqab2sF4AdOWzDp5D4SpSEhM47ZPoT/pR+ItF1akdS2A71zEbYYDuOUGmtKmslGYWtpPF/7onqO9m8hy7GwQCqqfmV9OOWBPVRCpzh6iOIpNi2/bz4eJ+jDv+VHFZCcAFTSM24QEMBOtkByGW0o3Bb7VL+ke+1SxAU1Adg7ausBK5j8sTasjplQyHEHYnd4aJlkjv12TixUKIHvLO+BEK0e/60AKp9uBcMvRSVPAy0iQiazLvNCLUjDEvGieTXe/P6IF2vBPtbuPVyivbmEnD/zYtHrS49oXzs365hZsQ60G1cxfj8MZjnYY9HOAZm6lX9PE73itBSUDD/e3F+BDqEb+IIHIRgKzHL6ZhXRpqD3mqbyX9t0kys1E/oqdeiYiiJR3BoZYGgMy28NL9ipeu4yFN5SCiZG9jHkXUkDMYghPN/Yfaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(396003)(346002)(39830400003)(366004)(33430700001)(8936002)(8676002)(36756003)(16526019)(6916009)(107886003)(7696005)(52116002)(86362001)(186003)(4326008)(66476007)(8886007)(956004)(2616005)(55016002)(66556008)(33656002)(66946007)(26005)(508600001)(44832011)(6666004)(1076003)(316002)(54906003)(5660300002)(2906002)(33440700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jmbVq/eBI3UM4K2Sjk8yesoxFwkUVriGfGzW1r3mrh9l3oXw/SI245zZtUvJ5XSYdYiSRgYMhsrY/6VM3uuxa72J4YMFfQQ+wc6Fnu1tf7K5FQjFLyF4sKAGW/HsIsEm2F/wBewKdaQpAkkSHUM4tmuotnaWaGLN/tCm1YrrDREjr8U8lMhdd2F1LFO2qqX1PrVIDsNzpViSSo2x5se9GJ8WUKpyaERiubc9LgOKv8UYyAMnYggRixoo4VYlKlQFg9nhjMbtiEMq9/z1vSW+j+4MxeZLZ0UjJRTnjjgwS4Fd46+5pFYSezaCeAk/ad59DwgLh5/hdLc+MDNaYjwOGy5i1xsqBxD8igQMTTXTwy8FlD2tINllM0Y2GaJfl+DsQFfue3QFiiuVVrVXmILDaf18/jx+/jPzv11sHNjN65Y5p7JeRpA7DyWJYDUrdsbN9aE0sCdI0Cz5Nnd1q80SQyfk5wrCNrk60EjqYpPCn4b/RrXHrlTSvOk/k+u2f+61ramT05j1xWG0Pdx+k49yuPJ/zpWgl53Cp7j/WB1EJyz/GyGx2PAaAZ4io0adCidDuYA14gJmygmXZgJm1dVb0nXo0CvUIMOco46D42aobIHSahXPJzleEg6MUhuktr1CqjQ0Ye54uQWdNMF81w7TA8WARAdtWPHpmG9hjFz2guxzKnM+cLR7vbV4NVPdCBgK633GddLPFlZ75sAvqW4Zt0t/YIK5n4mpdWCDBwfDpmLVFyIrLW6gzbTmq2z0gk2t7sPvGBc3tNdBm3QSZXHG0+9ncZd+XEcEuNjdW21iMh0=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 12857473-317f-489a-a973-08d7f0a90a1e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 04:01:50.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUAEsVX6XbrTIJXpmhNzGqR9bgFyZ2elefBMargDQA8wsE/Q1BdiIOdOOSLUXhCtEdwKyZEbYZdv9GSd6AtqO9FUa9bs7M4A5j+pFHRv35g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0031
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Sat, May 02, 2020 at 06:20:49PM +0300, Vadym Kochan wrote:
> Hi Ido,
> 
> On Thu, Mar 05, 2020 at 04:49:37PM +0200, Ido Schimmel wrote:
> > On Tue, Feb 25, 2020 at 04:30:54PM +0000, Vadym Kochan wrote:
> > > +int mvsw_pr_port_learning_set(struct mvsw_pr_port *port, bool learn)
> > > +{
> > > +	return mvsw_pr_hw_port_learning_set(port, learn);
> > > +}
> > > +
> > > +int mvsw_pr_port_flood_set(struct mvsw_pr_port *port, bool flood)
> > > +{
> > > +	return mvsw_pr_hw_port_flood_set(port, flood);
> > > +}
> > 
> > Flooding and learning are per-port attributes? Not per-{port, VLAN} ?
> > If so, you need to have various restrictions in the driver in case
> > someone configures multiple vlan devices on top of a port and enslaves
> > them to different bridges.

Yes, and there is no support for vlan device on top of the port.

> > 
> > > +
> > > +
> > > +	INIT_LIST_HEAD(&port->vlans_list);
> > > +	port->pvid = MVSW_PR_DEFAULT_VID;
> > 
> > If you're using VID 1, then you need to make sure that user cannot
> > configure a VLAN device with with this VID. If possible, I suggest that
> > you use VID 4095, as it cannot be configured from user space.
> > 
> > I'm actually not entirely sure why you need a default VID.
> > 
>  
> > > +mvsw_pr_port_vlan_bridge_join(struct mvsw_pr_port_vlan *port_vlan,
> > > +			      struct mvsw_pr_bridge_port *br_port,
> > > +			      struct netlink_ext_ack *extack)
> > > +{
> > > +	struct mvsw_pr_port *port = port_vlan->mvsw_pr_port;
> > > +	struct mvsw_pr_bridge_vlan *br_vlan;
> > > +	u16 vid = port_vlan->vid;
> > > +	int err;
> > > +
> > > +	if (port_vlan->bridge_port)
> > > +		return 0;
> > > +
> > > +	err = mvsw_pr_port_flood_set(port, br_port->flags & BR_FLOOD);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	err = mvsw_pr_port_learning_set(port, br_port->flags & BR_LEARNING);
> > > +	if (err)
> > > +		goto err_port_learning_set;
> > 
> > It seems that learning and flooding are not per-{port, VLAN} attributes,
> > so I'm not sure why you have this here.
> > 
> > The fact that you don't undo this in mvsw_pr_port_vlan_bridge_leave()
> > tells me it should not be here.
> > 
> 
>  > +
> > > +void
> > > +mvsw_pr_port_vlan_bridge_leave(struct mvsw_pr_port_vlan *port_vlan)
> > > +{
> > > +	struct mvsw_pr_port *port = port_vlan->mvsw_pr_port;
> > > +	struct mvsw_pr_bridge_vlan *br_vlan;
> > > +	struct mvsw_pr_bridge_port *br_port;
> > > +	int port_count;
> > > +	u16 vid = port_vlan->vid;
> > > +	bool last_port, last_vlan;
> > > +
> > > +	br_port = port_vlan->bridge_port;
> > > +	last_vlan = list_is_singular(&br_port->vlan_list);
> > > +	port_count =
> > > +	    mvsw_pr_bridge_vlan_port_count_get(br_port->bridge_device, vid);
> > > +	br_vlan = mvsw_pr_bridge_vlan_find(br_port, vid);
> > > +	last_port = port_count == 1;
> > > +	if (last_vlan) {
> > > +		mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> > > +	} else if (last_port) {
> > > +		mvsw_pr_fdb_flush_vlan(port->sw, vid,
> > > +				       MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> > > +	} else {
> > > +		mvsw_pr_fdb_flush_port_vlan(port, vid,
> > > +					    MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> > 
> > If you always flush based on {port, VID}, then why do you need the other
> > two?
> > 
> 
>  > +
> > > +static int mvsw_pr_port_obj_attr_set(struct net_device *dev,
> > > +				     const struct switchdev_attr *attr,
> > > +				     struct switchdev_trans *trans)
> > > +{
> > > +	int err = 0;
> > > +	struct mvsw_pr_port *port = netdev_priv(dev);
> > > +
> > > +	switch (attr->id) {
> > > +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> > > +		err = -EOPNOTSUPP;
> > 
> > You don't support STP?
> 
> Not, yet. But it will be in the next submission or official patch.
> > 
> > > +		break;
>  
> > > +	default:
> > > +		kfree(switchdev_work);
> > > +		return NOTIFY_DONE;
> > > +	}
> > > +
> > > +	queue_work(mvsw_owq, &switchdev_work->work);
> > 
> > Once you defer the operation you cannot return an error, which is
> > problematic. Do you have a way to know if the operation will succeed or
> > not? That is, if the hardware has enough space for this new FDB entry?
> > 
> Right, fdb configuration on via fw is blocking operation I still need to
> think on it if it is possible by current design.
> 
> 
> > 
> > Why do you need both 'struct mvsw_pr_switchdev' and 'struct
> > mvsw_pr_bridge'? I think the second is enough. Also, I assume
> > 'switchdev' naming is inspired by mlxsw, but 'bridge' is better.
> > 
> I changed to use bridge for bridge object, because having bridge_device
> may confuse.
> 
> Thank you for your comments they were very useful, sorry for so late
> answer, I decided to re-implement this version a bit. Regarding flooding
> and default vid I still need to check it.
> 
> Regards,
> Vadym Kochan
