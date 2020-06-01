Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5AC1EA244
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFAKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:50:25 -0400
Received: from mail-eopbgr60090.outbound.protection.outlook.com ([40.107.6.90]:16669
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgFAKuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 06:50:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auVPzkxTmKKHVAq7z1Fd1ULAEANtxQ1h+FtqnerWLMbHTHgGDuTi7A937VJpPhlqETgk9/kacr3HgnZd5NnB7EgOCgmEF962e3JPXzSlzkLK+854OC2R1FzmQhisRXvWjnVTum5TOZBp8Djj+SVKiGFsw60k2zkrpzAP06fWvHqQFHdSfSuzVmzEHbsIdKvNIJ6D0t/b61KrHY8bORJusCT4RVMGyHwOc3+0EUdTE7UOhYlZVOtVxsMZR8RTkRvytHkx8qK2qur1K86K5Drguv9Wx9/uMYDPXYIDZg+5wfWiZEM9cwlyicRSR1FRqRtWBHgfyYUfOtFeElkq0pWqGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3ovHKN0rM9KOjxwu85wIfSKv4yD5PkUjvjMYVT6s1Y=;
 b=XgcgVz1xyxK7wnAGmuqE2/xqiJE+5hhk5Py2sgmDQLVU23X9ilPb50v+si/RjAG7h2WScdoJh7uxEF3fpQRUTJ3AfxJNtJvMq3a4XAFRE2jBYy/M/+mqA3AUsUvHiPC0FKrrDNKcL+IxzIN1B5+wFiOX21XqigAFzrt6B+6yBY6XSgMk8CjClQBZBL9UWrLIhoucu72CHtybjZYohsePSRr/hC9aiHJDwRcp4CkKPw8lHykATfvld2e1tY6V+x5Y7jjoQYzf9P0BXal+Smian+hGGGkOeilbdG6e1aPLpjmiRkY1G4QzjiYeJyTZBDPeZmWHHnGU8gUJW5D7ZGVSew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3ovHKN0rM9KOjxwu85wIfSKv4yD5PkUjvjMYVT6s1Y=;
 b=bpu6BolnMY9HayKEC2R06FVoU8kI2KrV923w3wdSTNy1wFsTPzEPAgBwaByFB08wy/TdN9V3CNQRObVwVr1Y9qTWDljQrZ04Aq8ykcJQBNii3sa10WRbZR1O6xZCdChi6IL/2+LQZgA0kRqUtp1sZH40dNF5hBJCKZ0LsvRtobg=
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0062.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:9e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Mon, 1 Jun
 2020 10:50:17 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.022; Mon, 1 Jun 2020
 10:50:17 +0000
Date:   Mon, 1 Jun 2020 13:50:13 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
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
Message-ID: <20200601105013.GB25323@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
 <20200530154801.GB1624759@splinter>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530154801.GB1624759@splinter>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM3PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:207:1::11) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM3PR05CA0085.eurprd05.prod.outlook.com (2603:10a6:207:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Mon, 1 Jun 2020 10:50:15 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93632e74-407b-414a-0665-08d80619921a
X-MS-TrafficTypeDiagnostic: VI1P190MB0062:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB006228ECF43CA9E5E070F6FE958A0@VI1P190MB0062.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t7SbO6bAUS2CryDuO+aAZRC+T9iSVe1CaIWrNbTotB3Ghnfffe5Sl67Y1/vFRIZO8DhgzJ6p2j1TwtJWlH/tWvN9qA30nvsXuQElG58RZs4VMpFRtlLTJrxeAJepgIN31XOqmESRLiQFUnC/aWCzUwtDF8ZrWoRhF102avuv5k7NFn6ueRE4YKvFAoOZ5gtT9r6T3F3uLSvZWtOWy3S7aiaupAulJyr+kIxJNxgRpBwdyLBDl9rsKYuj8SUFxvu8CfILk8+voN8JTXE/NpbTruR9eyMl0WGFAwMhq+4kObdIg59BLUqvicmJJ7aKUickDokSyn7T3K/eoI3gM0Wum/qbmk6TFzJ+HOGZSlLz6IX7VxlCXHK4Y+7fiqh2xfbf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(136003)(366004)(396003)(39830400003)(8936002)(1076003)(5660300002)(36756003)(66556008)(66476007)(33656002)(8886007)(30864003)(2906002)(44832011)(6916009)(2616005)(66946007)(956004)(54906003)(316002)(7696005)(86362001)(52116002)(55016002)(83380400001)(16526019)(26005)(186003)(8676002)(4326008)(508600001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: pZsV92sr1Zh1KYmpH97mUD6BYcqcy+cYopV9MmB1peRVxYDp284tI3HtwujNrPRtu4unw8q0xv60zsOgwb/nayjdX/xugcfjHcxYGD0b+/f/lSj8qh9zzES3uvEig7qAaK2DX7Hta7iID2PtgWHtmWDEGpOZa/MMYRac4wEU1fQ7lQi8Hz+SQT7R/KsydIqSDrhboz1gAR5ZVDdTsMPE0C/S2b9PZ1OFcy5BTT0+NyZ8CrP1BtD3ZMluDjFzjBIYR8a7ZeApfaHIQpHnBifOhuFxe5kZ5iG7sYHYgxxSY6jS9fJe55yBV0DLHAaAnrSFAabdUHuLRmpUjYtbeh1XP+D+t1qXP4LZlTb+L+NkXVYmwbY0gG4XbLfk8BZBp+4FPS1ohzfM+h44uVbUW43Ouxs7phM0JJhUABXHWaXGGoSk58JuQPLQFkoc2qz1Zs+VRj59OFheBUX7wWE7gWsBI+f6IRvTlveXnUrDLcly4hg=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 93632e74-407b-414a-0665-08d80619921a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 10:50:17.0601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3TN9550Ckn9Ii+lZa+eYbfNn5d0J5FpmrxqqhnCi2OCSndfn6lbqVX/3MMys9UejN9IEgvrMCeENAR4wFlTVl7mb8EqkTMiIf+iS06fVlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Sat, May 30, 2020 at 06:48:01PM +0300, Ido Schimmel wrote:
> On Thu, May 28, 2020 at 06:12:40PM +0300, Vadym Kochan wrote:
> 

[...]

> Nit: "From" ?
> 
> > +	PRESTERA_DSA_CMD_FROM_CPU,
> > +};
> > +
> > +struct prestera_dsa_vlan {
> > +	u16 vid;
> > +	u8 vpt;
> > +	u8 cfi_bit;
> > +	bool is_tagged;
> > +};
> > +
> > +struct prestera_dsa {
> > +	struct prestera_dsa_vlan vlan;
> > +	u32 hw_dev_num;
> > +	u32 port_num;
> > +};
> > +
> > +int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf);
> > +int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf);
> > +
> > +#endif /* _PRESTERA_DSA_H_ */
> > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> > new file mode 100644
> > index 000000000000..3aa3974f957a
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> > @@ -0,0 +1,610 @@
> > +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> > +/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
> > +
> > +#include <linux/etherdevice.h>
> > +#include <linux/ethtool.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/list.h>
> > +
> > +#include "prestera.h"
> > +#include "prestera_hw.h"
> > +
> > +#define PRESTERA_SWITCH_INIT_TIMEOUT 30000000	/* 30sec */
> 
> Out of curiosity, how long does it actually take you to initialize the
> hardware?
> 
> Also, I find it useful to note the units in the name, so:
> 
> #define PRESTERA_SWITCH_INIT_TIMEOUT_US (30 * 1000 * 1000)
> 
> BTW, it says 30 seconds in comment, but the call chain where it is used
> is:
> 
> prestera_cmd_ret_wait(, PRESTERA_SWITCH_INIT_TIMEOUT)
>   __prestera_cmd_ret(..., wait)
>     prestera_fw_send_req(..., waitms)
>       prestera_fw_cmd_send(..., waitms)
>         prestera_fw_wait_reg32(..., waitms)
> 	  readl_poll_timeout(..., waitms * 1000)
> 
> So I think you should actually define it as:
> 
> #define PRESTERA_SWITCH_INIT_TIMEOUT_MS (30 * 1000)
> 
> And rename all these 'wait' arguments to 'waitms' so it's clearer which
> unit they expect.
> 
[...]
> > +static int __prestera_cmd_ret(struct prestera_switch *sw,
> > +			      enum prestera_cmd_type_t type,
> > +			      struct prestera_msg_cmd *cmd, size_t clen,
> > +			      struct prestera_msg_ret *ret, size_t rlen,
> > +			      int wait)
> > +{
> > +	struct prestera_device *dev = sw->dev;
> > +	int err;
> > +
> > +	cmd->type = type;
> > +
> > +	err = dev->send_req(dev, (u8 *)cmd, clen, (u8 *)ret, rlen, wait);
> > +	if (err)
> > +		return err;
> > +
> > +	if (ret->cmd.type != PRESTERA_CMD_TYPE_ACK)
> > +		return -EBADE;
> > +	if (ret->status != PRESTERA_CMD_ACK_OK)
> 
> You don't have more states here other than OK / FAIL ? It might help you
> in debugging if you include them. You might find trace_devlink_hwerr()
> useful.
Thanks, I will consider this.

> 
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int prestera_cmd_ret(struct prestera_switch *sw,
> > +			    enum prestera_cmd_type_t type,
> > +			    struct prestera_msg_cmd *cmd, size_t clen,
> > +			    struct prestera_msg_ret *ret, size_t rlen)
> > +{
> > +	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, 0);
> > +}
> > +
> > +static int prestera_cmd_ret_wait(struct prestera_switch *sw,
> > +				 enum prestera_cmd_type_t type,
> > +				 struct prestera_msg_cmd *cmd, size_t clen,
> > +				 struct prestera_msg_ret *ret, size_t rlen,
> > +				 int wait)
> > +{
> > +	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, wait);
> > +}
> > +
> > +static int prestera_cmd(struct prestera_switch *sw,
> > +			enum prestera_cmd_type_t type,
> > +			struct prestera_msg_cmd *cmd, size_t clen)
> > +{
> > +	struct prestera_msg_common_resp resp;
> > +
> > +	return prestera_cmd_ret(sw, type, cmd, clen, &resp.ret, sizeof(resp));
> > +}
> > +
> > +static int prestera_fw_parse_port_evt(u8 *msg, struct prestera_event *evt)
> > +{
> > +	struct prestera_msg_event_port *hw_evt;
> > +
> > +	hw_evt = (struct prestera_msg_event_port *)msg;
> > +
> > +	evt->port_evt.port_id = hw_evt->port_id;
> > +
> > +	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED)
> > +		evt->port_evt.data.oper_state = hw_evt->param.oper_state;
> > +	else
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct prestera_fw_evt_parser {
> > +	int (*func)(u8 *msg, struct prestera_event *evt);
> > +} fw_event_parsers[PRESTERA_EVENT_TYPE_MAX] = {
> > +	[PRESTERA_EVENT_TYPE_PORT] = {.func = prestera_fw_parse_port_evt},
> > +};
> > +
> > +static struct prestera_fw_event_handler *
> > +__find_event_handler(const struct prestera_switch *sw,
> > +		     enum prestera_event_type type)
> > +{
> > +	struct prestera_fw_event_handler *eh;
> > +
> > +	list_for_each_entry_rcu(eh, &sw->event_handlers, list) {
> 
> It does not look that this is always called under RCU which will result
> in various splats. For example in the following call path:
> 
> prestera_device_register()
>   prestera_switch_init()
>     prestera_event_handlers_register()
>       prestera_hw_event_handler_register()
>         __find_event_handler()
> 
> You want to make sure that you are testing with various debug options.
> For example:
So, right. Currently this prestera_hw_event_handler_register is called
synchronously and as I understand does not require additional locking
when use list rcu API. I will check with these options which you
suggested.

> 
> # Debug options
> ## General debug options
> config_enable CONFIG_PREEMPT
> config_enable CONFIG_DEBUG_PREEMPT
> config_enable CONFIG_DEBUG_INFO
> config_enable CONFIG_UNWINDER_ORC
> config_enable CONFIG_DYNAMIC_DEBUG
> config_enable CONFIG_DEBUG_NOTIFIERS
> ## Lock debugging
> config_enable CONFIG_LOCKDEP
> config_enable CONFIG_PROVE_LOCKING
> config_enable CONFIG_DEBUG_ATOMIC_SLEEP
> config_enable CONFIG_PROVE_RCU
> config_enable CONFIG_DEBUG_MUTEXES
> config_enable CONFIG_DEBUG_SPINLOCK
> config_enable CONFIG_LOCK_STAT
> ## Memory debugging
> config_enable CONFIG_DEBUG_VM
> config_enable CONFIG_FORTIFY_SOURCE
> config_enable CONFIG_KASAN
> config_enable CONFIG_KASAN_EXTRA
> config_enable CONFIG_KASAN_INLINE
> ## Reference counting debugging
> config_enable CONFIG_REFCOUNT_FULL
> ## Lockups debugging
> config_enable CONFIG_LOCKUP_DETECTOR
> config_enable CONFIG_SOFTLOCKUP_DETECTOR
> config_enable CONFIG_HARDLOCKUP_DETECTOR
> config_enable CONFIG_DETECT_HUNG_TASK
> config_enable CONFIG_WQ_WATCHDOG
> config_enable CONFIG_DETECT_HUNG_TASK
> config_set_val CONFIG_DEFAULT_HUNG_TASK_TIMEOUT 120
> ## Undefined behavior debugging
> config_enable CONFIG_UBSAN
> config_enable CONFIG_UBSAN_SANITIZE_ALL
> config_disable CONFIG_UBSAN_ALIGNMENT
> config_disable CONFIG_UBSAN_NULL
> ## Memory debugging
> config_enable CONFIG_SLUB_DEBUG
> config_enable CONFIG_SLUB_DEBUG_ON
> config_enable CONFIG_DEBUG_PAGEALLOC
> config_enable CONFIG_DEBUG_KMEMLEAK
> config_disable CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> config_set_val CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE 8192
> config_enable CONFIG_DEBUG_STACKOVERFLOW
> config_enable CONFIG_DEBUG_LIST
> config_enable CONFIG_DEBUG_PER_CPU_MAPS
> config_set_val CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT 1
> config_enable CONFIG_DEBUG_OBJECTS
> config_enable CONFIG_DEBUG_OBJECTS_FREE
> config_enable CONFIG_DEBUG_OBJECTS_TIMERS
> config_enable CONFIG_DEBUG_OBJECTS_WORK
> config_enable CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
> config_enable CONFIG_DMA_API_DEBUG
> ## Lock debugging
> config_enable CONFIG_DEBUG_LOCK_ALLOC
> config_enable CONFIG_PROVE_LOCKING
> config_enable CONFIG_LOCK_STAT
> config_enable CONFIG_DEBUG_OBJECTS_RCU_HEAD
> config_enable CONFIG_SPARSE_RCU_POINTER
> 
> > +		if (eh->type == type)
> > +			return eh;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static int prestera_find_event_handler(const struct prestera_switch *sw,
> > +				       enum prestera_event_type type,
> > +				       struct prestera_fw_event_handler *eh)
> > +{
> > +	struct prestera_fw_event_handler *tmp;
> > +	int err = 0;
> > +
> > +	rcu_read_lock();
> > +	tmp = __find_event_handler(sw, type);
> > +	if (tmp)
> > +		*eh = *tmp;
> > +	else
> > +		err = -EEXIST;
> > +	rcu_read_unlock();
> > +
> > +	return err;
> > +}
> > +
> > +static int prestera_evt_recv(struct prestera_device *dev, u8 *buf, size_t size)
> > +{
> > +	struct prestera_msg_event *msg = (struct prestera_msg_event *)buf;
> > +	struct prestera_switch *sw = dev->priv;
> > +	struct prestera_fw_event_handler eh;
> > +	struct prestera_event evt;
> > +	int err;
> > +
> > +	if (msg->type >= PRESTERA_EVENT_TYPE_MAX)
> > +		return -EINVAL;
> > +
> > +	err = prestera_find_event_handler(sw, msg->type, &eh);
> > +
> > +	if (err || !fw_event_parsers[msg->type].func)
> > +		return 0;
> > +
> > +	evt.id = msg->id;
> > +
> > +	err = fw_event_parsers[msg->type].func(buf, &evt);
> > +	if (!err)
> > +		eh.func(sw, &evt, eh.arg);
> > +
> > +	return err;
> > +}
> > +
> > +static void prestera_pkt_recv(struct prestera_device *dev)
> > +{
> > +	struct prestera_switch *sw = dev->priv;
> > +	struct prestera_fw_event_handler eh;
> > +	struct prestera_event ev;
> > +	int err;
> > +
> > +	ev.id = PRESTERA_RXTX_EVENT_RCV_PKT;
> > +
> > +	err = prestera_find_event_handler(sw, PRESTERA_EVENT_TYPE_RXTX, &eh);
> > +	if (err)
> > +		return;
> > +
> > +	eh.func(sw, &ev, eh.arg);
> > +}
> > +
> > +int prestera_hw_port_info_get(const struct prestera_port *port,
> > +			      u16 *fp_id, u32 *hw_id, u32 *dev_id)
> > +{
> > +	struct prestera_msg_port_info_resp resp;
> > +	struct prestera_msg_port_info_req req = {
> > +		.port = port->id
> > +	};
> > +	int err;
> > +
> > +	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_INFO_GET,
> > +			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> > +	if (err)
> > +		return err;
> > +
> > +	*hw_id = resp.hw_id;
> > +	*dev_id = resp.dev_id;
> > +	*fp_id = resp.fp_id;
> > +
> > +	return 0;
> > +}
> > +
> > +int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac)
> > +{
> > +	struct prestera_msg_switch_attr_req req = {
> > +		.attr = PRESTERA_CMD_SWITCH_ATTR_MAC,
> > +	};
> > +
> > +	memcpy(req.param.mac, mac, sizeof(req.param.mac));
> > +
> > +	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
> > +			    &req.cmd, sizeof(req));
> > +}
> > +
> > +int prestera_hw_switch_init(struct prestera_switch *sw)
> > +{
> > +	struct prestera_msg_switch_init_resp resp;
> > +	struct prestera_msg_common_req req;
> > +	int err;
> > +
> > +	INIT_LIST_HEAD(&sw->event_handlers);
> > +
> > +	err = prestera_cmd_ret_wait(sw, PRESTERA_CMD_TYPE_SWITCH_INIT,
> > +				    &req.cmd, sizeof(req),
> > +				    &resp.ret, sizeof(resp),
> > +				    PRESTERA_SWITCH_INIT_TIMEOUT);
> > +	if (err)
> > +		return err;
> > +
> > +	sw->id = resp.switch_id;
> > +	sw->port_count = resp.port_count;
> > +	sw->mtu_min = PRESTERA_MIN_MTU;
> > +	sw->mtu_max = resp.mtu_max;
> > +	sw->dev->recv_msg = prestera_evt_recv;
> > +	sw->dev->recv_pkt = prestera_pkt_recv;
> > +
> > +	return 0;
> > +}
> 
> Consider adding prestera_hw_switch_fini() that verifies that
> '&sw->event_handlers' is empty.
> 
As I see it can just warn on if list is not empty, right ?

> > +
> > +int prestera_hw_port_state_set(const struct prestera_port *port,
> > +			       bool admin_state)
> > +{
> > +	struct prestera_msg_port_attr_req req = {
> > +		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
> > +		.port = port->hw_id,
> > +		.dev = port->dev_id,
> > +		.param = {.admin_state = admin_state}
> > +	};
> > +
> > +	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
> > +			    &req.cmd, sizeof(req));
> > +}
> > +

[...]

> > +
> > +struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
> > +						 u32 dev_id, u32 hw_id)
> > +{
> > +	struct prestera_port *port;
> > +
> > +	rcu_read_lock();
> > +
> > +	list_for_each_entry_rcu(port, &sw->port_list, list) {
> > +		if (port->dev_id == dev_id && port->hw_id == hw_id) {
> > +			rcu_read_unlock();
> > +			return port;
> 
> This does not look correct. You call rcu_read_unlock(), but do not take
> a reference on the object, so nothing prevents it from being freed. 
> 
Currently there is no logic which can dynamically create/delete the
port, so how do you think may I just use synchronize_rcu() when freeing
the port instance on module unlolad ?

> > +		}
> > +	}
> > +
> > +	rcu_read_unlock();
> > +
> > +	return NULL;
> > +}
> > +
> > +static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
> > +						u32 port_id)
> > +{
> > +	struct prestera_port *port;
> > +
> > +	rcu_read_lock();
> > +
> > +	list_for_each_entry_rcu(port, &sw->port_list, list) {
> > +		if (port->id == port_id)
> > +			break;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +
> > +	return port;
> 
> Same here.
> 
> > +}
> > +
> > +static int prestera_port_state_set(struct net_device *dev, bool is_up)
> > +{
> > +	struct prestera_port *port = netdev_priv(dev);
> > +	int err;
> > +
> > +	if (!is_up)
> > +		netif_stop_queue(dev);
> > +
> > +	err = prestera_hw_port_state_set(port, is_up);
> > +
> > +	if (is_up && !err)
> > +		netif_start_queue(dev);
> > +
> > +	return err;
> > +}
> > +

[...]

> > +static void prestera_port_destroy(struct prestera_port *port)
> > +{
> > +	struct net_device *dev = port->dev;
> > +
> > +	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
> > +	unregister_netdev(dev);
> > +
> > +	list_del_rcu(&port->list);
> > +
> 
> I'm not sure what is the point of these blank lines. Best to remove
> them.
Will fix it.

> 
> > +	free_netdev(dev);
> > +}
> > +
> > +static void prestera_destroy_ports(struct prestera_switch *sw)
> > +{
> > +	struct prestera_port *port, *tmp;
> > +	struct list_head remove_list;
> > +
> > +	INIT_LIST_HEAD(&remove_list);
> > +
> > +	list_splice_init(&sw->port_list, &remove_list);
> > +
> > +	list_for_each_entry_safe(port, tmp, &remove_list, list)
> > +		prestera_port_destroy(port);
> > +}
> > +
> > +static int prestera_create_ports(struct prestera_switch *sw)
> > +{
> > +	u32 port;
> > +	int err;
> > +
> > +	for (port = 0; port < sw->port_count; port++) {
> > +		err = prestera_port_create(sw, port);
> > +		if (err)
> > +			goto err_ports_init;
> 
> err_port_create ?
> 
> > +	}
> > +
> > +	return 0;
> > +
> > +err_ports_init:
> > +	prestera_destroy_ports(sw);
> 
> I'm not a fan of this construct. I find it best to always do proper
> rollback in the error path. Then you can always maintain init() being
> followed by fini() which is much easier to review.
As I understand you meant to move this destroy_ports() recovery to the
error path in xxx_switch_init() ?

> 
> > +	return err;
> > +}
> > +
> > +static void prestera_port_handle_event(struct prestera_switch *sw,
> > +				       struct prestera_event *evt, void *arg)
> > +{
> > +	struct delayed_work *caching_dw;
> > +	struct prestera_port *port;
> > +
> > +	port = prestera_find_port(sw, evt->port_evt.port_id);
> > +	if (!port)
> > +		return;
> > +
> > +	caching_dw = &port->cached_hw_stats.caching_dw;
> > +
> > +	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED) {
> > +		if (evt->port_evt.data.oper_state) {
> > +			netif_carrier_on(port->dev);
> > +			if (!delayed_work_pending(caching_dw))
> > +				queue_delayed_work(prestera_wq, caching_dw, 0);
> > +		} else {
> > +			netif_carrier_off(port->dev);
> > +			if (delayed_work_pending(caching_dw))
> > +				cancel_delayed_work(caching_dw);
> > +		}
> > +	}
> > +}
> > +
> > +static void prestera_event_handlers_unregister(struct prestera_switch *sw)
> > +{
> > +	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_PORT,
> > +					     prestera_port_handle_event);
> > +}
> 
> Please reverse the order so that register() is first.
> 
> > +
> > +static int prestera_event_handlers_register(struct prestera_switch *sw)
> > +{
> > +	return prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_PORT,
> > +						  prestera_port_handle_event,
> > +						  NULL);
> > +}
> > +
> > +static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
> > +{
> > +	struct device_node *base_mac_np;
> > +	struct device_node *np;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "marvell,prestera");
> > +	if (np) {
> > +		base_mac_np = of_parse_phandle(np, "base-mac-provider", 0);
> > +		if (base_mac_np) {
> > +			const char *base_mac;
> > +
> > +			base_mac = of_get_mac_address(base_mac_np);
> > +			of_node_put(base_mac_np);
> > +			if (!IS_ERR(base_mac))
> > +				ether_addr_copy(sw->base_mac, base_mac);
> > +		}
> > +	}
> > +
> > +	if (!is_valid_ether_addr(sw->base_mac)) {
> > +		eth_random_addr(sw->base_mac);
> > +		dev_info(sw->dev->dev, "using random base mac address\n");
> > +	}
> > +
> > +	return prestera_hw_switch_mac_set(sw, sw->base_mac);
> > +}
> > +
> > +static int prestera_switch_init(struct prestera_switch *sw)
> > +{
> > +	int err;
> > +
> > +	err = prestera_hw_switch_init(sw);
> > +	if (err) {
> > +		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
> > +		return err;
> > +	}
> > +
> > +	INIT_LIST_HEAD(&sw->port_list);
> > +
> > +	err = prestera_switch_set_base_mac_addr(sw);
> > +	if (err)
> > +		return err;
> > +
> > +	err = prestera_rxtx_switch_init(sw);
> > +	if (err)
> > +		return err;
> > +
> > +	err = prestera_event_handlers_register(sw);
> > +	if (err)
> > +		return err;
> > +
> > +	err = prestera_create_ports(sw);
> > +	if (err)
> > +		goto err_ports_create;
> > +
> > +	return 0;
> > +
> > +err_ports_create:
> > +	prestera_event_handlers_unregister(sw);
> > +
> 
> You are missing prestera_rxtx_switch_fini() here... With init() always
> followed by fini() you can easily tell that the error path is not
> symmetric with fini().
Yeah, for some reason I mixed this fix with Switchdev patch, I will fix
this.

> 
> > +	return err;
> > +}
> > +
> > +static void prestera_switch_fini(struct prestera_switch *sw)
> > +{
> > +	prestera_destroy_ports(sw);
> > +	prestera_event_handlers_unregister(sw);
> > +	prestera_rxtx_switch_fini(sw);
> > +}
> > +
> > +int prestera_device_register(struct prestera_device *dev)
> > +{
> > +	struct prestera_switch *sw;
> > +	int err;
> > +
> > +	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
> > +	if (!sw)
> > +		return -ENOMEM;
> > +
> > +	dev->priv = sw;
> > +	sw->dev = dev;
> > +
> > +	err = prestera_switch_init(sw);
> > +	if (err) {
> > +		kfree(sw);
> > +		return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(prestera_device_register);
> > +
> > +void prestera_device_unregister(struct prestera_device *dev)
> > +{
> > +	struct prestera_switch *sw = dev->priv;
> > +
> > +	prestera_switch_fini(sw);
> > +	kfree(sw);
> > +}

[...]

> > +int prestera_rxtx_port_init(struct prestera_port *port)
> > +{
> > +	int err;
> > +
> > +	err = prestera_hw_rxtx_port_init(port);
> > +	if (err)
> > +		return err;
> > +
> > +	port->dev->needed_headroom = PRESTERA_DSA_HLEN + ETH_FCS_LEN;
> 
> Why do you need headroom for FCS?
> 
I had issue when the SKB did not have additional bytes for the FCS, so I
thought to added this to the needed_headroom to be sure.

> > +	return 0;
> > +}
> > +
> > +netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
> > +{
> > +	struct prestera_dsa dsa;
> > +
> > +	dsa.hw_dev_num = port->dev_id;
> > +	dsa.port_num = port->hw_id;
> > +
> > +	if (skb_cow_head(skb, PRESTERA_DSA_HLEN) < 0)
> > +		return NET_XMIT_DROP;
> > +
> > +	skb_push(skb, PRESTERA_DSA_HLEN);
> > +	memmove(skb->data, skb->data + PRESTERA_DSA_HLEN, 2 * ETH_ALEN);
> > +
> > +	if (prestera_dsa_build(&dsa, skb->data + 2 * ETH_ALEN) != 0)
> > +		return NET_XMIT_DROP;
> > +
> > +	return prestera_sdma_xmit(&port->sw->rxtx->sdma, skb);
> > +}
> > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> > new file mode 100644
> > index 000000000000..bbbadfa5accf
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> > @@ -0,0 +1,21 @@
> > +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> > + *
> > + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> > + *
> > + */
> > +
> > +#ifndef _PRESTERA_RXTX_H_
> > +#define _PRESTERA_RXTX_H_
> > +
> > +#include <linux/netdevice.h>
> > +
> > +#include "prestera.h"
> > +
> > +int prestera_rxtx_switch_init(struct prestera_switch *sw);
> > +void prestera_rxtx_switch_fini(struct prestera_switch *sw);
> > +
> > +int prestera_rxtx_port_init(struct prestera_port *port);
> > +
> > +netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
> > +
> > +#endif /* _PRESTERA_RXTX_H_ */
> > -- 
> > 2.17.1
> > 

Thank you for review.
