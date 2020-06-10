Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446AD1F5604
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 15:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgFJNlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 09:41:46 -0400
Received: from mail-vi1eur05on2112.outbound.protection.outlook.com ([40.107.21.112]:38592
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbgFJNlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 09:41:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+iiAECvGY6HfaQ5zNqEp0e69M8bE1HDAJrzsxp5jZQLmU2+VNQHGEWuEaur2AlvaA5aCSqQA6JhepJcb1K/GyNykHESTGwE/G+xQQWT7coCtmeiK9GeEcc24YZtRYe60TnLECoeP89HGHcerSerhcGzh39khHSFIAHURmSJgsAYX/vnQVTuVhhKsT0ZWrVrdLCWxOGrUm7El1mKTB+l5lYskkRHEM/ocV8q/edn1LIsvuY3DBzN+k/fg8G7cCJFGlVWiRh5HjukF2QByOcYYmwLcdpbe23wt0ONI7+gSmeRW++Jy1LtE1HVCjOi2GDmP4j4tEWnh+z2cehZmsgLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PM5kyqA+AxZwmM1+LGmojBtxTS3YTJJuioINFvOdmBE=;
 b=ZzznOnMo8efaQ46HJCtlsHS7894cOkTYNzqjqHPdYIGIZiINAXQpole3bPKG74XIZf6MunoicI1aSV66QCV476sErrynA+gBKnQHzg9+UaxAfzkLmSqp5IPHCrNzi4TsGjOYHco6GdD9jN7I0XOBCX/90q8ta78BwBnMRVy5HQpWR8btSENltIQ0B4IDqbm2Kf+rB2q9yK8KOammkLsHZdWxjQRFlOWn9QMuxTy4AeC+L9023ImjkiqlEHAidfQU2K0bOudC7kwGiJQQXOv4V+VSAuqFAaSdSbJFFTmgmPekYLxnM+g6eT/X9Ai5G4TOkggYXop05RJFqTxOqy1wfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PM5kyqA+AxZwmM1+LGmojBtxTS3YTJJuioINFvOdmBE=;
 b=lr1MdfRSxBddGhRggwobnMxhI35U8v5/LQFdslw+L57WFHy/Q9uZzuFNQD+bNiZdSmKy+Sm3nY9x2mWwoJjc6kArdVrlLmFFXFtrTbOsazXMK7tsDb7i6TphS/E6vPrCEr7YSsv6DOJ6nspjucrAKu/HUEfYJ5um+ieNR9lSgFA=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0383.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 10 Jun
 2020 13:41:36 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3066.018; Wed, 10 Jun 2020
 13:41:36 +0000
Date:   Wed, 10 Jun 2020 16:41:32 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
Message-ID: <20200610134132.GB20123@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
 <20200603141632.GA2274@nanopsycho.orion>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603141632.GA2274@nanopsycho.orion>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P194CA0038.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::15) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P194CA0038.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Wed, 10 Jun 2020 13:41:35 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d28e5348-8b47-407b-2d34-08d80d43fee3
X-MS-TrafficTypeDiagnostic: VI1P190MB0383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB03831FC56A611906079FB62995830@VI1P190MB0383.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0430FA5CB7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3IY+a57U1NuAcPk6OOA/gLnCX94o8cX9VxAkhRsJy5YqZroK+IltzTYl90hG7Jy3Bbodl6V8tfHx/b3XUb0YPbJpO1zfHs42ZyNjlWJmVrCR+9rlPfoVCtSgnNoI5n3N2nPo6x+n4GBxggqE7tH4p078fCiQirA2mRZxvWjYCMR6FdIewp2jgVkA07DLKZoj76IgpAc+V5Zv3J55VrIWymmF3jpUGJ/1ttMQ2BLNFUbgF3CTBvRWnPTzMlaalSBpuikvkocno3hjw6yZcjzgYpk37pq820wbi+RaFQdUCqcH4eF+qEVRZMU+BRUQn/JKFtr0GC2WjOqSXXysgwCfbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(366004)(346002)(396003)(39830400003)(8676002)(30864003)(8936002)(66476007)(66946007)(26005)(36756003)(956004)(5660300002)(1076003)(66556008)(4326008)(2616005)(55016002)(52116002)(186003)(6916009)(54906003)(86362001)(6666004)(44832011)(83380400001)(508600001)(8886007)(16526019)(2906002)(33656002)(7696005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iLZ4DaSAWY7EHSrsJF5snbsZKdrJ/KgL2DdHbznUoJrFjmmXDdYb6F+y3PyRkPDHtFsx0Q1qhobp0SkaRBcDj9q36s2oBrxjCmxSTcHRM848XMMKhdgy2A+V3EYFnkHF1xj/KGyCuca/hsyhBjMBBj9fM2zQ/MLvISZ1BRQqYs1dTdpgSZ4bRNLQVZQyp2gjQJbMH8/XOGl2b379NuWhKsjrCtc2w1kKrpcySkazKMZqVlJAPeAtKWNKlH0b28n3KH/C3D1Cc0tm6Syx+L+5gDKvDf2CYA3rfeQ/x3RQUDTU31ed5Fzo+rp/wT9gSmJHFrv4HF8Dy1BeUIu/MewRd33XeOVyCOjAXUHQ7DBT4LH1/T3oC0WHBMMA/0wuk1RBId8b3CiAvVkqELFMKuRtQObI9RVQC1ZAHJr5d5pOtIb4fE6JQEsUK3vROiwGHezixi2eIrTCP1TqTBoW+EAvBGo2hPRS6gB9N9Fs4p4g0pk=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d28e5348-8b47-407b-2d34-08d80d43fee3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2020 13:41:36.5694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uI3AEeecHG3rqOafi9bkLHNTMBxyu5dbK+IxkMtI0yQLQc0FLb/VUlaJnQcS+H69FQQ9zyZ0beM34DZvMA0QPqUiHhE6ZS5KYcgxJ7VnBcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 04:16:32PM +0200, Jiri Pirko wrote:
> Thu, May 28, 2020 at 05:12:40PM CEST, vadym.kochan@plvision.eu wrote:
> 
> [...]
> 
> >+}
> >+
> >+int prestera_hw_port_info_get(const struct prestera_port *port,
> >+			      u16 *fp_id, u32 *hw_id, u32 *dev_id)
> 
> Please unify the ordering of "hw_id" and "dev_id" with the rest of the
> functions having the same args.
> 
OK, will do.

> 
> 
> >+{
> >+	struct prestera_msg_port_info_resp resp;
> >+	struct prestera_msg_port_info_req req = {
> >+		.port = port->id
> >+	};
> >+	int err;
> >+
> >+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_INFO_GET,
> >+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> >+	if (err)
> >+		return err;
> >+
> >+	*hw_id = resp.hw_id;
> >+	*dev_id = resp.dev_id;
> >+	*fp_id = resp.fp_id;
> >+
> >+	return 0;
> >+}
> >+
> >+int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac)
> >+{
> >+	struct prestera_msg_switch_attr_req req = {
> >+		.attr = PRESTERA_CMD_SWITCH_ATTR_MAC,
> >+	};
> >+
> >+	memcpy(req.param.mac, mac, sizeof(req.param.mac));
> >+
> >+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
> >+			    &req.cmd, sizeof(req));
> >+}
> >+
> >+int prestera_hw_switch_init(struct prestera_switch *sw)
> >+{
> >+	struct prestera_msg_switch_init_resp resp;
> >+	struct prestera_msg_common_req req;
> >+	int err;
> >+
> >+	INIT_LIST_HEAD(&sw->event_handlers);
> >+
> >+	err = prestera_cmd_ret_wait(sw, PRESTERA_CMD_TYPE_SWITCH_INIT,
> >+				    &req.cmd, sizeof(req),
> >+				    &resp.ret, sizeof(resp),
> >+				    PRESTERA_SWITCH_INIT_TIMEOUT);
> >+	if (err)
> >+		return err;
> >+
> >+	sw->id = resp.switch_id;
> >+	sw->port_count = resp.port_count;
> >+	sw->mtu_min = PRESTERA_MIN_MTU;
> >+	sw->mtu_max = resp.mtu_max;
> >+	sw->dev->recv_msg = prestera_evt_recv;
> >+	sw->dev->recv_pkt = prestera_pkt_recv;
> >+
> >+	return 0;
> >+}
> >+
> >+int prestera_hw_port_state_set(const struct prestera_port *port,
> >+			       bool admin_state)
> >+{
> >+	struct prestera_msg_port_attr_req req = {
> >+		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
> >+		.port = port->hw_id,
> >+		.dev = port->dev_id,
> >+		.param = {.admin_state = admin_state}
> >+	};
> >+
> >+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
> >+			    &req.cmd, sizeof(req));
> >+}
> >+
> >+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu)
> >+{
> >+	struct prestera_msg_port_attr_req req = {
> >+		.attr = PRESTERA_CMD_PORT_ATTR_MTU,
> >+		.port = port->hw_id,
> >+		.dev = port->dev_id,
> >+		.param = {.mtu = mtu}
> >+	};
> >+
> >+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
> >+			    &req.cmd, sizeof(req));
> >+}
> >+
> >+int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac)
> >+{
> >+	struct prestera_msg_port_attr_req req = {
> >+		.attr = PRESTERA_CMD_PORT_ATTR_MAC,
> >+		.port = port->hw_id,
> >+		.dev = port->dev_id
> >+	};
> >+	memcpy(&req.param.mac, mac, sizeof(req.param.mac));
> >+
> >+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
> >+			    &req.cmd, sizeof(req));
> >+}
> >+
> >+int prestera_hw_port_cap_get(const struct prestera_port *port,
> >+			     struct prestera_port_caps *caps)
> >+{
> >+	struct prestera_msg_port_attr_resp resp;
> >+	struct prestera_msg_port_attr_req req = {
> >+		.attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
> >+		.port = port->hw_id,
> >+		.dev = port->dev_id
> >+	};
> >+	int err;
> >+
> >+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
> >+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> >+	if (err)
> >+		return err;
> >+
> >+	caps->supp_link_modes = resp.param.cap.link_mode;
> >+	caps->supp_fec = resp.param.cap.fec;
> >+	caps->type = resp.param.cap.type;
> >+	caps->transceiver = resp.param.cap.transceiver;
> >+
> >+	return err;
> >+}
> >+
> >+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
> >+				 bool autoneg, u64 link_modes, u8 fec)
> >+{
> >+	struct prestera_msg_port_attr_req req = {
> >+		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG,
> >+		.port = port->hw_id,
> >+		.dev = port->dev_id,
> >+		.param = {.autoneg = {.link_mode = link_modes,
> >+				      .enable = autoneg,
> >+				      .fec = fec}
> >+		}
> >+	};
> >+
> >+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
> >+			    &req.cmd, sizeof(req));
> >+}
> >+
> >+int prestera_hw_port_stats_get(const struct prestera_port *port,
> >+			       struct prestera_port_stats *st)
> >+{
> >+	struct prestera_msg_port_stats_resp resp;
> >+	struct prestera_msg_port_attr_req req = {
> >+		.attr = PRESTERA_CMD_PORT_ATTR_STATS,
> >+		.port = port->hw_id,
> >+		.dev = port->dev_id
> >+	};
> >+	u64 *hw = resp.stats;
> >+	int err;
> >+
> >+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
> >+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> >+	if (err)
> >+		return err;
> >+
> >+	st->good_octets_received = hw[PRESTERA_PORT_GOOD_OCTETS_RCV_CNT];
> >+	st->bad_octets_received = hw[PRESTERA_PORT_BAD_OCTETS_RCV_CNT];
> >+	st->mac_trans_error = hw[PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT];
> >+	st->broadcast_frames_received = hw[PRESTERA_PORT_BRDC_PKTS_RCV_CNT];
> >+	st->multicast_frames_received = hw[PRESTERA_PORT_MC_PKTS_RCV_CNT];
> >+	st->frames_64_octets = hw[PRESTERA_PORT_PKTS_64L_CNT];
> >+	st->frames_65_to_127_octets = hw[PRESTERA_PORT_PKTS_65TO127L_CNT];
> >+	st->frames_128_to_255_octets = hw[PRESTERA_PORT_PKTS_128TO255L_CNT];
> >+	st->frames_256_to_511_octets = hw[PRESTERA_PORT_PKTS_256TO511L_CNT];
> >+	st->frames_512_to_1023_octets = hw[PRESTERA_PORT_PKTS_512TO1023L_CNT];
> >+	st->frames_1024_to_max_octets = hw[PRESTERA_PORT_PKTS_1024TOMAXL_CNT];
> >+	st->excessive_collision = hw[PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT];
> >+	st->multicast_frames_sent = hw[PRESTERA_PORT_MC_PKTS_SENT_CNT];
> >+	st->broadcast_frames_sent = hw[PRESTERA_PORT_BRDC_PKTS_SENT_CNT];
> >+	st->fc_sent = hw[PRESTERA_PORT_FC_SENT_CNT];
> >+	st->fc_received = hw[PRESTERA_PORT_GOOD_FC_RCV_CNT];
> >+	st->buffer_overrun = hw[PRESTERA_PORT_DROP_EVENTS_CNT];
> >+	st->undersize = hw[PRESTERA_PORT_UNDERSIZE_PKTS_CNT];
> >+	st->fragments = hw[PRESTERA_PORT_FRAGMENTS_PKTS_CNT];
> >+	st->oversize = hw[PRESTERA_PORT_OVERSIZE_PKTS_CNT];
> >+	st->jabber = hw[PRESTERA_PORT_JABBER_PKTS_CNT];
> >+	st->rx_error_frame_received = hw[PRESTERA_PORT_MAC_RCV_ERROR_CNT];
> >+	st->bad_crc = hw[PRESTERA_PORT_BAD_CRC_CNT];
> >+	st->collisions = hw[PRESTERA_PORT_COLLISIONS_CNT];
> >+	st->late_collision = hw[PRESTERA_PORT_LATE_COLLISIONS_CNT];
> >+	st->unicast_frames_received = hw[PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT];
> >+	st->unicast_frames_sent = hw[PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT];
> >+	st->sent_multiple = hw[PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT];
> >+	st->sent_deferred = hw[PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT];
> >+	st->good_octets_sent = hw[PRESTERA_PORT_GOOD_OCTETS_SENT_CNT];
> >+
> >+	return 0;
> >+}
> >+
> >+int prestera_hw_rxtx_init(struct prestera_switch *sw,
> >+			  struct prestera_rxtx_params *params)
> >+{
> >+	struct prestera_msg_rxtx_resp resp;
> >+	struct prestera_msg_rxtx_req req;
> >+	int err;
> >+
> >+	req.use_sdma = params->use_sdma;
> >+
> >+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_RXTX_INIT,
> >+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> >+	if (err)
> >+		return err;
> >+
> >+	params->map_addr = resp.map_addr;
> >+	return 0;
> >+}
> >+
> >+int prestera_hw_rxtx_port_init(struct prestera_port *port)
> >+{
> >+	struct prestera_msg_rxtx_port_req req = {
> >+		.port = port->hw_id,
> >+		.dev = port->dev_id,
> >+	};
> >+
> >+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_RXTX_PORT_INIT,
> >+			    &req.cmd, sizeof(req));
> >+}
> >+
> >+int prestera_hw_event_handler_register(struct prestera_switch *sw,
> >+				       enum prestera_event_type type,
> >+				       prestera_event_cb_t fn,
> >+				       void *arg)
> >+{
> >+	struct prestera_fw_event_handler *eh;
> >+
> >+	eh = __find_event_handler(sw, type);
> >+	if (eh)
> >+		return -EEXIST;
> >+	eh = kmalloc(sizeof(*eh), GFP_KERNEL);
> >+	if (!eh)
> >+		return -ENOMEM;
> >+
> >+	eh->type = type;
> >+	eh->func = fn;
> >+	eh->arg = arg;
> >+
> >+	INIT_LIST_HEAD(&eh->list);
> >+
> >+	list_add_rcu(&eh->list, &sw->event_handlers);
> >+
> >+	return 0;
> >+}
> >+
> >+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
> >+					  enum prestera_event_type type,
> >+					  prestera_event_cb_t fn)
> >+{
> >+	struct prestera_fw_event_handler *eh;
> >+
> >+	eh = __find_event_handler(sw, type);
> >+	if (!eh)
> >+		return;
> >+
> >+	list_del_rcu(&eh->list);
> >+	synchronize_rcu();
> >+	kfree(eh);
> 
> Try to avoid use of synchronice rcu. You can rather do:
> kfree_rcu(eh, rcu);
Thanks for this.

> 
> 
> >+}
> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> >new file mode 100644
> >index 000000000000..acb0e31d6684
> >--- /dev/null
> >+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> >@@ -0,0 +1,71 @@
> >+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> >+ *
> >+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> >+ *
> >+ */
> >+
> >+#ifndef _PRESTERA_HW_H_
> >+#define _PRESTERA_HW_H_
> >+
> >+#include <linux/types.h>
> >+
> >+enum {
> >+	PRESTERA_PORT_TYPE_NONE,
> >+	PRESTERA_PORT_TYPE_TP,
> >+
> >+	PRESTERA_PORT_TYPE_MAX,
> >+};
> >+
> >+enum {
> >+	PRESTERA_PORT_FEC_OFF,
> >+
> >+	PRESTERA_PORT_FEC_MAX,
> >+};
> >+
> >+struct prestera_switch;
> >+struct prestera_port;
> >+struct prestera_port_stats;
> >+struct prestera_port_caps;
> >+enum prestera_event_type;
> >+struct prestera_event;
> >+
> >+typedef void (*prestera_event_cb_t)
> >+	(struct prestera_switch *sw, struct prestera_event *evt, void *arg);
> >+
> >+struct prestera_rxtx_params;
> >+
> >+/* Switch API */
> >+int prestera_hw_switch_init(struct prestera_switch *sw);
> >+int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac);
> >+
> >+/* Port API */
> >+int prestera_hw_port_info_get(const struct prestera_port *port,
> >+			      u16 *fp_id, u32 *hw_id, u32 *dev_id);
> >+int prestera_hw_port_state_set(const struct prestera_port *port,
> >+			       bool admin_state);
> >+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu);
> >+int prestera_hw_port_mtu_get(const struct prestera_port *port, u32 *mtu);
> >+int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac);
> >+int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
> >+int prestera_hw_port_cap_get(const struct prestera_port *port,
> >+			     struct prestera_port_caps *caps);
> >+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
> >+				 bool autoneg, u64 link_modes, u8 fec);
> >+int prestera_hw_port_stats_get(const struct prestera_port *port,
> >+			       struct prestera_port_stats *stats);
> >+
> >+/* Event handlers */
> >+int prestera_hw_event_handler_register(struct prestera_switch *sw,
> >+				       enum prestera_event_type type,
> >+				       prestera_event_cb_t fn,
> >+				       void *arg);
> >+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
> >+					  enum prestera_event_type type,
> >+					  prestera_event_cb_t fn);
> >+
> >+/* RX/TX */
> >+int prestera_hw_rxtx_init(struct prestera_switch *sw,
> >+			  struct prestera_rxtx_params *params);
> >+int prestera_hw_rxtx_port_init(struct prestera_port *port);
> >+
> >+#endif /* _PRESTERA_HW_H_ */
> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> >new file mode 100644
> >index 000000000000..b5241e9b784a
> >--- /dev/null
> >+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> >@@ -0,0 +1,506 @@
> >+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> >+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
> >+
> >+#include <linux/kernel.h>
> >+#include <linux/module.h>
> >+#include <linux/list.h>
> >+#include <linux/netdevice.h>
> >+#include <linux/netdev_features.h>
> >+#include <linux/etherdevice.h>
> >+#include <linux/jiffies.h>
> >+#include <linux/of.h>
> >+#include <linux/of_net.h>
> >+
> >+#include "prestera.h"
> >+#include "prestera_hw.h"
> >+#include "prestera_rxtx.h"
> >+
> >+#define PRESTERA_MTU_DEFAULT 1536
> >+
> >+#define PRESTERA_STATS_DELAY_MS	msecs_to_jiffies(1000)
> >+
> >+static struct workqueue_struct *prestera_wq;
> >+
> >+struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
> >+						 u32 dev_id, u32 hw_id)
> 
> This is confusing. The called is calling this like:
> 	port = prestera_port_find_by_hwid(sdma->sw, hw_id, hw_port);
> 
> You are mixing hw_id and dev_id.
Yes, this is confusing, will fix it.

> 
> 
> 
> >+{
> >+	struct prestera_port *port;
> >+
> >+	rcu_read_lock();
> >+
> >+	list_for_each_entry_rcu(port, &sw->port_list, list) {
> >+		if (port->dev_id == dev_id && port->hw_id == hw_id) {
> 
> Note this is the fast path. I'm not sure what the values of dev_id or
> hw_id are, but didn't you consider having the port pointers in 2 dim
> array? Or, if the values are totally arbitrary, at least a hash table
> would be nice here.
The hash table may help.

> 
> 
> >+			rcu_read_unlock();
> >+			return port;
> 
> As Ido already pointed out, this is invalid use of rcu read.
> If you really need to do rcu read lock, the caller should hold it while
> calling this function and until it finisher work with port struct.
> 
> 
> >+		}
> >+	}
> >+
> >+	rcu_read_unlock();
> >+
> >+	return NULL;
> >+}
> >+
> >+static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
> >+						u32 port_id)
> >+{
> >+	struct prestera_port *port;
> >+
> >+	rcu_read_lock();
> >+
> >+	list_for_each_entry_rcu(port, &sw->port_list, list) {
> >+		if (port->id == port_id)
> >+			break;
> >+	}
> >+
> >+	rcu_read_unlock();
> >+
> >+	return port;
> >+}
> >+
> >+static int prestera_port_state_set(struct net_device *dev, bool is_up)
> >+{
> >+	struct prestera_port *port = netdev_priv(dev);
> >+	int err;
> >+
> >+	if (!is_up)
> >+		netif_stop_queue(dev);
> >+
> >+	err = prestera_hw_port_state_set(port, is_up);
> >+
> >+	if (is_up && !err)
> >+		netif_start_queue(dev);
> >+
> >+	return err;
> >+}
> >+
> >+static int prestera_port_open(struct net_device *dev)
> >+{
> >+	return prestera_port_state_set(dev, true);
> >+}
> >+
> >+static int prestera_port_close(struct net_device *dev)
> >+{
> >+	return prestera_port_state_set(dev, false);
> >+}
> >+
> >+static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
> >+				      struct net_device *dev)
> >+{
> >+	return prestera_rxtx_xmit(netdev_priv(dev), skb);
> >+}
> >+
> >+static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> >+{
> >+	if (!is_valid_ether_addr(addr))
> >+		return -EADDRNOTAVAIL;
> >+
> >+	if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
> >+		return -EINVAL;
> >+
> >+	return 0;
> >+}
> >+
> >+static int prestera_port_set_mac_address(struct net_device *dev, void *p)
> >+{
> >+	struct prestera_port *port = netdev_priv(dev);
> >+	struct sockaddr *addr = p;
> >+	int err;
> >+
> >+	err = prestera_is_valid_mac_addr(port, addr->sa_data);
> >+	if (err)
> >+		return err;
> >+
> >+	err = prestera_hw_port_mac_set(port, addr->sa_data);
> >+	if (err)
> >+		return err;
> >+
> >+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
> >+	return 0;
> >+}
> >+
> >+static int prestera_port_change_mtu(struct net_device *dev, int mtu)
> >+{
> >+	struct prestera_port *port = netdev_priv(dev);
> >+	int err;
> >+
> >+	err = prestera_hw_port_mtu_set(port, mtu);
> >+	if (err)
> >+		return err;
> >+
> >+	dev->mtu = mtu;
> >+	return 0;
> >+}
> >+
> >+static void prestera_port_get_stats64(struct net_device *dev,
> >+				      struct rtnl_link_stats64 *stats)
> >+{
> >+	struct prestera_port *port = netdev_priv(dev);
> >+	struct prestera_port_stats *port_stats = &port->cached_hw_stats.stats;
> >+
> >+	stats->rx_packets = port_stats->broadcast_frames_received +
> >+				port_stats->multicast_frames_received +
> >+				port_stats->unicast_frames_received;
> >+
> >+	stats->tx_packets = port_stats->broadcast_frames_sent +
> >+				port_stats->multicast_frames_sent +
> >+				port_stats->unicast_frames_sent;
> >+
> >+	stats->rx_bytes = port_stats->good_octets_received;
> >+
> >+	stats->tx_bytes = port_stats->good_octets_sent;
> >+
> >+	stats->rx_errors = port_stats->rx_error_frame_received;
> >+	stats->tx_errors = port_stats->mac_trans_error;
> >+
> >+	stats->rx_dropped = port_stats->buffer_overrun;
> >+	stats->tx_dropped = 0;
> >+
> >+	stats->multicast = port_stats->multicast_frames_received;
> >+	stats->collisions = port_stats->excessive_collision;
> >+
> >+	stats->rx_crc_errors = port_stats->bad_crc;
> >+}
> >+
> >+static void prestera_port_get_hw_stats(struct prestera_port *port)
> >+{
> >+	prestera_hw_port_stats_get(port, &port->cached_hw_stats.stats);
> >+}
> >+
> >+static void prestera_port_stats_update(struct work_struct *work)
> >+{
> >+	struct prestera_port *port =
> >+		container_of(work, struct prestera_port,
> >+			     cached_hw_stats.caching_dw.work);
> >+
> >+	prestera_port_get_hw_stats(port);
> >+
> >+	queue_delayed_work(prestera_wq, &port->cached_hw_stats.caching_dw,
> >+			   PRESTERA_STATS_DELAY_MS);
> >+}
> >+
> >+static const struct net_device_ops netdev_ops = {
> >+	.ndo_open = prestera_port_open,
> >+	.ndo_stop = prestera_port_close,
> >+	.ndo_start_xmit = prestera_port_xmit,
> >+	.ndo_change_mtu = prestera_port_change_mtu,
> >+	.ndo_get_stats64 = prestera_port_get_stats64,
> >+	.ndo_set_mac_address = prestera_port_set_mac_address,
> >+};
> >+
> >+static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
> >+				     u64 link_modes, u8 fec)
> >+{
> >+	bool refresh = false;
> >+	int err = 0;
> >+
> >+	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
> >+		return enable ? -EINVAL : 0;
> >+
> >+	if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
> >+		port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
> >+		port->adver_link_modes = link_modes;
> >+		refresh = true;
> >+	}
> >+
> >+	if (port->autoneg == enable && !(port->autoneg && refresh))
> >+		return 0;
> >+
> >+	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
> >+					   port->adver_fec);
> >+	if (err)
> >+		return -EINVAL;
> >+
> >+	port->autoneg = enable;
> >+	return 0;
> >+}
> >+
> >+static int prestera_port_create(struct prestera_switch *sw, u32 id)
> >+{
> >+	struct prestera_port *port;
> >+	struct net_device *dev;
> >+	int err;
> >+
> >+	dev = alloc_etherdev(sizeof(*port));
> >+	if (!dev)
> >+		return -ENOMEM;
> >+
> >+	port = netdev_priv(dev);
> >+
> >+	port->dev = dev;
> >+	port->id = id;
> >+	port->sw = sw;
> >+
> >+	err = prestera_hw_port_info_get(port, &port->fp_id,
> >+					&port->hw_id, &port->dev_id);
> >+	if (err) {
> >+		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
> >+		goto err_port_init;
> >+	}
> >+
> >+	dev->features |= NETIF_F_NETNS_LOCAL;
> >+	dev->netdev_ops = &netdev_ops;
> >+
> >+	netif_carrier_off(dev);
> >+
> >+	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
> >+	dev->min_mtu = sw->mtu_min;
> >+	dev->max_mtu = sw->mtu_max;
> >+
> >+	err = prestera_hw_port_mtu_set(port, dev->mtu);
> >+	if (err) {
> >+		dev_err(prestera_dev(sw), "Failed to set port(%u) mtu(%d)\n",
> >+			id, dev->mtu);
> >+		goto err_port_init;
> >+	}
> >+
> >+	/* Only 0xFF mac addrs are supported */
> >+	if (port->fp_id >= 0xFF)
> >+		goto err_port_init;
> >+
> >+	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> >+	dev->dev_addr[dev->addr_len - 1] = (char)port->fp_id;
> >+
> >+	err = prestera_hw_port_mac_set(port, dev->dev_addr);
> >+	if (err) {
> >+		dev_err(prestera_dev(sw), "Failed to set port(%u) mac addr\n", id);
> >+		goto err_port_init;
> >+	}
> >+
> >+	err = prestera_hw_port_cap_get(port, &port->caps);
> >+	if (err) {
> >+		dev_err(prestera_dev(sw), "Failed to get port(%u) caps\n", id);
> >+		goto err_port_init;
> >+	}
> >+
> >+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
> >+	prestera_port_autoneg_set(port, true, port->caps.supp_link_modes,
> >+				  port->caps.supp_fec);
> >+
> >+	err = prestera_hw_port_state_set(port, false);
> >+	if (err) {
> >+		dev_err(prestera_dev(sw), "Failed to set port(%u) down\n", id);
> >+		goto err_port_init;
> >+	}
> >+
> >+	err = prestera_rxtx_port_init(port);
> >+	if (err)
> >+		goto err_port_init;
> >+
> >+	INIT_DELAYED_WORK(&port->cached_hw_stats.caching_dw,
> >+			  &prestera_port_stats_update);
> >+
> >+	list_add_rcu(&port->list, &sw->port_list);
> 
> I still am not sure I fully follow. We discussed this before. Can one
> of the following cases happen?
> 
> 1) a packet is RXed while adding ports
> 2) a packet is RXed while removing ports
> 
> If yes, the rcu makes sense here. If no, you are okay with a simple
> list.
Well, I was afraid about the _fini part when ports are destroying and
the packets are flying at the same time. And referring to the previous
comment regarding rcu_read_lock()/..._unlock() - it needs only to
protect the ports list (while destroying/adding the ports) and using
just "rcu add/del list" looks enough because there is only 1 writer (or
use simply spinlock).

> 
> 
> >+
> >+	err = register_netdev(dev);
> >+	if (err)
> >+		goto err_register_netdev;
> >+
> >+	return 0;
> >+
> >+err_register_netdev:
> >+	list_del_rcu(&port->list);
> >+err_port_init:
> >+	free_netdev(dev);
> >+	return err;
> >+}
> >+
> >+static void prestera_port_destroy(struct prestera_port *port)
> >+{
> >+	struct net_device *dev = port->dev;
> >+
> >+	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
> >+	unregister_netdev(dev);
> >+
> >+	list_del_rcu(&port->list);
> >+
> >+	free_netdev(dev);
> >+}
> >+
> >+static void prestera_destroy_ports(struct prestera_switch *sw)
> >+{
> >+	struct prestera_port *port, *tmp;
> >+	struct list_head remove_list;
> >+
> >+	INIT_LIST_HEAD(&remove_list);
> >+
> >+	list_splice_init(&sw->port_list, &remove_list);
> 
> Why do you need a separate remove list? Why don't you iterate sw->port_list
> directly?
> 
> 
> >+
> >+	list_for_each_entry_safe(port, tmp, &remove_list, list)
> >+		prestera_port_destroy(port);
> >+}
> >+
> 
> [...]
> 
> 
> >+static int prestera_rxtx_process_skb(struct prestera_sdma *sdma,
> >+				     struct sk_buff *skb)
> >+{
> >+	const struct prestera_port *port;
> >+	struct prestera_dsa dsa;
> 
> What "DSA" stands for? Anything to do with net/dsa/ ?
Well, it uses special Marvell DSA tag which is used to extract
additional meta information like port number, etc (it differs from the
one which is supported in net/dsa, bacuse the latter are part of the DSA
infra).

> 
> 
> >+	u32 hw_port, hw_id;
> >+	int err;
> >+
> >+	skb_pull(skb, ETH_HLEN);
> >+
> >+	/* ethertype field is part of the dsa header */
> >+	err = prestera_dsa_parse(&dsa, skb->data - ETH_TLEN);
> >+	if (err)
> >+		return err;
> >+
> >+	hw_port = dsa.port_num;
> >+	hw_id = dsa.hw_dev_num;
> >+
> >+	port = prestera_port_find_by_hwid(sdma->sw, hw_id, hw_port);
> >+	if (unlikely(!port)) {
> >+		pr_warn_ratelimited("prestera: received pkt for non-existent port(%u, %u)\n",
> 
> Drop the "prestera: " prefix.
Okay.

> 
> 
> >+				    hw_id, hw_port);
> >+		return -EEXIST;
> >+	}
> >+
> 
> [...]
