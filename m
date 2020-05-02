Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A911C2680
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 17:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgEBPVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 11:21:05 -0400
Received: from mail-eopbgr00090.outbound.protection.outlook.com ([40.107.0.90]:6406
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728134AbgEBPVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 May 2020 11:21:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vjyvqu2MWlIQgvNnuwVJO5eCvbLd3/9IygmkwM9o2BB1h+9axZV+5E68hcHJp1DOk4KMJwEoqsom9W65Lzma8rcVUWLkyWKTgmhwTlTzQBJ7dZqh0K/OdoVP3O55YFlep5fzSH/DPHyPuqSfZDpBtoLkKGKGx3DeY3WUulzHW2h7jJyobU6QchJToNegVoJwZyPdmZRrJR859FlneCYIqAfb6R8vvcUfp/07nLZhTI6gnUsLiu9vUpjEG82pD83lKeHhTTstGb2SVG9+/Jk0NY8vRzMKxRxdy98HTO4tlnqxYCPDmD1H3FMJRLmrUPU8dD3ZG7/Q9RpLQrOkloVKnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSslYt5PAaBYEr24Gssti0TxlOPFQ47ACcbUO2o1Ocs=;
 b=kAQ7e+Bs5d4EO9YLXMTSnlxsx3WTZc3ZHF8MQ3mt1G41rcFJLd+49nfWwmbBiPB6n7nlILGLF9YWSdsw1BsGCQ3yljKtXwMdba/vq9AY+7dyNg1jFXLRYFF7TbGJUh7rSebCAEh1oXLW/TDx2qGNHTurjSO+8S6Ox1hZz2hX8an3uPIWuc5mzHaLYTB54TyaguL0TxLw+hMGEtfhr/LRHqEQwcdiKo/L5aINQpd2gyKE7ml4B08S9XqiLG8nOOWcLMcBlTxRzwBnb928SwutyUoFjVBBljZUW52IBWw4ViHKxtXsEcoaYWLi2GHYsUSQmyAMVI205qWEZXOEPkdD6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSslYt5PAaBYEr24Gssti0TxlOPFQ47ACcbUO2o1Ocs=;
 b=JYTqwl9HyDsAmyiiG012PXJP48cQtYR61yA6aoYtAEJx63KfvBO9hI4gAlmyPfqa83gXslbZGoVh9gIYjeedQz33QNTj8Zi51ZJj/wuxUFMoeabZJKOP9/OF6yA0c2UspLxipif4Jpt5Zaf/41qlx+88o9F+sJTdu6dL/ZzwgOs=
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0527.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Sat, 2 May
 2020 15:20:59 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 15:20:59 +0000
Date:   Sat, 2 May 2020 18:20:49 +0300
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
Message-ID: <20200502152049.GA8513@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200305144937.GA132852@splinter>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305144937.GA132852@splinter>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0502CA0009.eurprd05.prod.outlook.com
 (2603:10a6:203:91::19) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0502CA0009.eurprd05.prod.outlook.com (2603:10a6:203:91::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Sat, 2 May 2020 15:20:56 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5923cd46-1d45-4318-a9d8-08d7eeac69cd
X-MS-TrafficTypeDiagnostic: VI1P190MB0527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB052744B8FF59ECC76407E26E95A80@VI1P190MB0527.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 039178EF4A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkmnTCiXv4ZpyrQ9WLip4ZZ7I+Nif8mYMf//nQuWyzL83m6/bOUx00pi39EAA9FNICWd42f8nfFFaYos9FUO/0VmZNf9Yc51+0J2/I/RQAY3NNQRRPz7daQx4QYIjCd0r6DMpkL+U0nvShI4e4et/jOpuwG1Twp2ZPkbOs9tBWhl9nRIwx/fN0YnAte1PnvCXOtPFM29RjQoVinnHFRqKR7I5D97Oyam8i4q9hCV7kLg/SGbw8fHv7ZexSgmKzN19tagY2W3YXfIegk6wOZXk8Z5W8h510aLh6xJq0S8fesLJCaAqSTFWewXXOxWy7Fqxuj4NOTirWqNu2Zt9xe1LVLkR9ovAuPK9UwBs5lQ8ZsVX7ajHSKS6RQ6gdPXEWechPGGeckb1YKm3avGz+WfrUiUF9b2lWNM/llnUEVKilUhGJsx/GdhEoqGp18u3IAs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(346002)(396003)(376002)(39830400003)(26005)(6916009)(186003)(54906003)(66946007)(66476007)(16526019)(4326008)(107886003)(7696005)(52116002)(55016002)(316002)(36756003)(6666004)(8886007)(66556008)(1076003)(508600001)(86362001)(44832011)(33656002)(2616005)(2906002)(956004)(5660300002)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +CLS0h1vZRdYjsa9WFwltmVahZ5oTAJVL/DMGXWomo12nOPnJri91ZPh+lhwTJws3xo92t+SaSDoB1Yi3vC+g45mBs2Ch1Mci2EOs6zzR0WVcVe3u5BW8z50ymI65rkT7ZFmvuaL6+BsqGZFw1E96G7v5vETSNhTLMI83AxhehDryLn4MiRZn6/3iPbuXJCjdtIImLyFnPfqqpA+lvKCTRINUFina+jBrSu10SO3Dhd/V+QSRvQtg3AZFkvZhNCs68Cgia7E3CcEmZPyIbQc/sW/XBsbgs8F3IS05TrGuzr/xwmXLAQj0HaK3HiMEgyCZF6dRO8rusz8izYtE90FGf+XNjGuwSrglh3/p2WCPtfnFZDpRmBEPAiJ3jM2p/lybkpI2G+uNU34jJb1mQ1jRR7p+1Qpou4UqobnSWVL2SgPt+q23OWePqjZkUFb+DCvA1lYuC9b5xUXkfDWG19R30bLFC3UgNEBu2p1SUhWXPrucSdAePx+vy4mFSma7fExeiO4I4L0tx5ETPHVhNrgkYG1agCYvlHhE0dO37j7HdroDmTVTtBzK6QgFhCl9qUz/qpZE52LXRE7cRImJbwd5I4ykNsJtffIjp7EnKhQxwyJJg1Gm3/Ynxm93x92Pp66jTszbInuOJ2pLKxkWgv8ygicc1AY0mt+jHJ8T0mwnqQXJ6ZUrtc0oar4Jomnw7vTl4Kw0eHq1drQDMQ1yYDc4pNh65KexIfkuF8lnYg4gIrZHJ+Hc4EAyYNEZx5hjuLTwePiFdSIMj3pHvH3QTuCL9NNdzvVX7P9b6p3cnul35s=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 5923cd46-1d45-4318-a9d8-08d7eeac69cd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2020 15:20:58.7787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwhQXvQCLejn5K1+6YP9pNl7xMOHIrdDkgpbrgbqJn7hnhCHIDf3D6KytYp7/MpmHEWV5S6BoC/RFavxthrxAnaaxp1WK3Pj4+T87z7ul6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Thu, Mar 05, 2020 at 04:49:37PM +0200, Ido Schimmel wrote:
> On Tue, Feb 25, 2020 at 04:30:54PM +0000, Vadym Kochan wrote:
> > +int mvsw_pr_port_learning_set(struct mvsw_pr_port *port, bool learn)
> > +{
> > +	return mvsw_pr_hw_port_learning_set(port, learn);
> > +}
> > +
> > +int mvsw_pr_port_flood_set(struct mvsw_pr_port *port, bool flood)
> > +{
> > +	return mvsw_pr_hw_port_flood_set(port, flood);
> > +}
> 
> Flooding and learning are per-port attributes? Not per-{port, VLAN} ?
> If so, you need to have various restrictions in the driver in case
> someone configures multiple vlan devices on top of a port and enslaves
> them to different bridges.
> 
> > +
> > +
> > +	INIT_LIST_HEAD(&port->vlans_list);
> > +	port->pvid = MVSW_PR_DEFAULT_VID;
> 
> If you're using VID 1, then you need to make sure that user cannot
> configure a VLAN device with with this VID. If possible, I suggest that
> you use VID 4095, as it cannot be configured from user space.
> 
> I'm actually not entirely sure why you need a default VID.
> 
 
> > +mvsw_pr_port_vlan_bridge_join(struct mvsw_pr_port_vlan *port_vlan,
> > +			      struct mvsw_pr_bridge_port *br_port,
> > +			      struct netlink_ext_ack *extack)
> > +{
> > +	struct mvsw_pr_port *port = port_vlan->mvsw_pr_port;
> > +	struct mvsw_pr_bridge_vlan *br_vlan;
> > +	u16 vid = port_vlan->vid;
> > +	int err;
> > +
> > +	if (port_vlan->bridge_port)
> > +		return 0;
> > +
> > +	err = mvsw_pr_port_flood_set(port, br_port->flags & BR_FLOOD);
> > +	if (err)
> > +		return err;
> > +
> > +	err = mvsw_pr_port_learning_set(port, br_port->flags & BR_LEARNING);
> > +	if (err)
> > +		goto err_port_learning_set;
> 
> It seems that learning and flooding are not per-{port, VLAN} attributes,
> so I'm not sure why you have this here.
> 
> The fact that you don't undo this in mvsw_pr_port_vlan_bridge_leave()
> tells me it should not be here.
> 

 > +
> > +void
> > +mvsw_pr_port_vlan_bridge_leave(struct mvsw_pr_port_vlan *port_vlan)
> > +{
> > +	struct mvsw_pr_port *port = port_vlan->mvsw_pr_port;
> > +	struct mvsw_pr_bridge_vlan *br_vlan;
> > +	struct mvsw_pr_bridge_port *br_port;
> > +	int port_count;
> > +	u16 vid = port_vlan->vid;
> > +	bool last_port, last_vlan;
> > +
> > +	br_port = port_vlan->bridge_port;
> > +	last_vlan = list_is_singular(&br_port->vlan_list);
> > +	port_count =
> > +	    mvsw_pr_bridge_vlan_port_count_get(br_port->bridge_device, vid);
> > +	br_vlan = mvsw_pr_bridge_vlan_find(br_port, vid);
> > +	last_port = port_count == 1;
> > +	if (last_vlan) {
> > +		mvsw_pr_fdb_flush_port(port, MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> > +	} else if (last_port) {
> > +		mvsw_pr_fdb_flush_vlan(port->sw, vid,
> > +				       MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> > +	} else {
> > +		mvsw_pr_fdb_flush_port_vlan(port, vid,
> > +					    MVSW_PR_FDB_FLUSH_MODE_DYNAMIC);
> 
> If you always flush based on {port, VID}, then why do you need the other
> two?
> 

 > +
> > +static int mvsw_pr_port_obj_attr_set(struct net_device *dev,
> > +				     const struct switchdev_attr *attr,
> > +				     struct switchdev_trans *trans)
> > +{
> > +	int err = 0;
> > +	struct mvsw_pr_port *port = netdev_priv(dev);
> > +
> > +	switch (attr->id) {
> > +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> > +		err = -EOPNOTSUPP;
> 
> You don't support STP?

Not, yet. But it will be in the next submission or official patch.
> 
> > +		break;
 
> > +	default:
> > +		kfree(switchdev_work);
> > +		return NOTIFY_DONE;
> > +	}
> > +
> > +	queue_work(mvsw_owq, &switchdev_work->work);
> 
> Once you defer the operation you cannot return an error, which is
> problematic. Do you have a way to know if the operation will succeed or
> not? That is, if the hardware has enough space for this new FDB entry?
> 
Right, fdb configuration on via fw is blocking operation I still need to
think on it if it is possible by current design.


> 
> Why do you need both 'struct mvsw_pr_switchdev' and 'struct
> mvsw_pr_bridge'? I think the second is enough. Also, I assume
> 'switchdev' naming is inspired by mlxsw, but 'bridge' is better.
> 
I changed to use bridge for bridge object, because having bridge_device
may confuse.

Thank you for your comments they were very useful, sorry for so late
answer, I decided to re-implement this version a bit. Regarding flooding
and default vid I still need to check it.

Regards,
Vadym Kochan
