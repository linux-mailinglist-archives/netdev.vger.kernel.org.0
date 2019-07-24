Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B518874101
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfGXVqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:46:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGXVqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:46:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D9A51543AF1D;
        Wed, 24 Jul 2019 14:46:38 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:46:37 -0700 (PDT)
Message-Id: <20190724.144637.2001590133621908069.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, Tristram.Ha@microchip.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH 3/3] net: dsa: ksz: Add Microchip KSZ8795 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724134048.31029-4-marex@denx.de>
References: <20190724134048.31029-1-marex@denx.de>
        <20190724134048.31029-4-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 14:46:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 24 Jul 2019 15:40:48 +0200

> +static void ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
> +			      u64 *cnt)
> +{
> +	u32 data;
> +	u16 ctrl_addr;
> +	u8 check;
> +	int loop;

Reverse christmas tree for these local variable declarations.

> +static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
> +			      u64 *dropped, u64 *cnt)
> +{
> +	u32 data;
> +	u16 ctrl_addr;
> +	u8 check;
> +	int loop;

Likewise.

> +static int ksz8795_r_dyn_mac_table(struct ksz_device *dev, u16 addr,
> +				   u8 *mac_addr, u8 *fid, u8 *src_port,
> +				   u8 *timestamp, u16 *entries)
> +{
> +	u32 data_hi;
> +	u32 data_lo;
> +	u16 ctrl_addr;
> +	int rc;
> +	u8 data;

Likewise.

> +static int ksz8795_r_sta_mac_table(struct ksz_device *dev, u16 addr,
> +				   struct alu_struct *alu)
> +{
> +	u64 data;
> +	u32 data_hi;
> +	u32 data_lo;

Likewise.

> +static void ksz8795_w_sta_mac_table(struct ksz_device *dev, u16 addr,
> +				    struct alu_struct *alu)
> +{
> +	u64 data;
> +	u32 data_hi;
> +	u32 data_lo;

Likewise.

> +static inline void ksz8795_from_vlan(u16 vlan, u8 *fid, u8 *member, u8 *valid)

Never use the inline directive in foo.c files, let the compiler decide.

> +static inline void ksz8795_to_vlan(u8 fid, u8 member, u8 valid, u16 *vlan)

Likewise.

> +static void ksz8795_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
> +{
> +	u64 buf;
> +	u16 *data = (u16 *)&buf;
> +	u16 addr;
> +	int index;

Reverse christmas tree please.

> +static void ksz8795_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
> +{
> +	u64 buf;
> +	u16 *data = (u16 *)&buf;
> +	u16 addr;
> +	int index;

Likewise.

> +static void ksz8795_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
> +{
> +	struct ksz_port *port;
> +	u8 ctrl;
> +	u8 restart;
> +	u8 link;
> +	u8 speed;
> +	u8 p = phy;
> +	u16 data = 0;
> +	int processed = true;

Likewise.

> +static void ksz8795_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
> +{
> +	u8 ctrl;
> +	u8 restart;
> +	u8 speed;
> +	u8 data;
> +	u8 p = phy;

Likewise.

> +static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
> +				       u8 state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p = &dev->ports[port];
> +	u8 data;
> +	int member = -1;
> +	int forward = dev->member;

Likewise.

> +static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
> +{
> +	struct ksz_port *p;
> +	int cnt;
> +	int first;
> +	int index;
> +	u8 learn[TOTAL_PORT_NUM];

Likewise.

> +static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
> +				  const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	u16 data;
> +	u16 vid;
> +	u8 fid;
> +	u8 member;
> +	u8 valid;
> +	u16 new_pvid = 0;

Likewise.  And seriously, combine all of the same typed variables onto one line
to compress the space a bit:

	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
	struct ksz_device *dev = ds->priv;
	u16 data, vid, new_pvid = 0;
	u8 fid, member, valid;

Doesn't that look like 1,000 times nicer? :-)

> +static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
> +				 const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	u16 data;
> +	u16 vid;
> +	u16 pvid;
> +	u8 fid;
> +	u8 member;
> +	u8 valid;
> +	u16 new_pvid = 0;

Again, same thing.

> +static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
> +{
> +	u8 data8;
> +	u8 member;
> +	struct ksz_port *p = &dev->ports[port];

Likewise.
> +static void ksz8795_config_cpu_port(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p;
> +	int i;
> +	u8 remote;

Likewise.

> +static int ksz8795_setup(struct dsa_switch *ds)
> +{
> +	u8 data8;
> +	u16 data16;
> +	u32 value;
> +	int i;
> +	struct alu_struct alu;
> +	struct ksz_device *dev = ds->priv;
> +	int ret = 0;

Likewise.
> +static int ksz8795_switch_detect(struct ksz_device *dev)
> +{
> +	u16 id16;
> +	u8 id1;
> +	u8 id2;
> +	int ret;

Likewise.
