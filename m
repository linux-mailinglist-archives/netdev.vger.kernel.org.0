Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3964295FA
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhJKRpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:45:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:4157 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhJKRpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 13:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633974224; x=1665510224;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+F9l5T5x2PMp6M/KDfNyBQ/u3YF2P+eW3/LZuRhLqB0=;
  b=RH+H42EfcoxmM/kzqPBnHztha3v32H026a34vh/d2W7wo457rDULmDsh
   zMqma0ne6QA4/Ja0k+SlHeiHJRjS2lzq+KngdFJEEWfM366jhhy4mQCAy
   m5ASkv3EjluLknsUk19o9/VRApmdgFBQ78bwgBxIdq/hPMtMyqjbmld7N
   EacFZEJYsXhq6VxuVx/0Y1+rkewEHsCnz7rH7wj5iZcLD2gVv/v+TWa9s
   FPVai+CIUIyc+078hw6jMq0NgHVLfi04gIDxW3KxJGm17S5TFppdGC1iY
   kTIDo/avxF8LmSQMIH5A1ybHvdAwfFCWrLHI4QNimjrcvdaROZcwmNXiE
   A==;
IronPort-SDR: YJjfVilpcqhcgN6hjFOU8uvyBBQ7GvCHcIhebE8NRgOG1L6Uv96E4TrLrnvook/IBUG7ahoH56
 k5zlWGCEieevyNqqOnpFgADJyAe7E52G5ttIspqsIoJkJjwsehIYqOFcpkLjJxU3s/6lj4lvkr
 AOYhCaBgQm1gUVqHdlcuHsyk4+8lzyRx1easPmdA95V9VtXtYbduksnVeUcOS/RoBktmQo+04U
 nYw5DcJFs+oYNSOQxFJAqAGvn2C38qV8Oj374tICfCRmnd8eMuuzw6ATzbVj8Sh9LH7Qaz7gCZ
 V/pu7PitMXQaQATPAVw/QfFW
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="135122494"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Oct 2021 10:43:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 11 Oct 2021 10:43:42 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 11 Oct 2021 10:43:37 -0700
Message-ID: <6c97e0771204b492f31b3d003a5fd97d789920ef.camel@microchip.com>
Subject: Re: [PATCH v4 net-next 10/10] net: dsa: microchip: add support for
 vlan operations
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 11 Oct 2021 23:13:36 +0530
In-Reply-To: <20211007201705.polwaqgbzff4u3vx@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
         <20211007151200.748944-11-prasanna.vengateshan@microchip.com>
         <20211007201705.polwaqgbzff4u3vx@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-10-07 at 23:17 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> > +static int lan937x_port_vlan_filtering(struct dsa_switch *ds, int port,
> > +                                    bool flag,
> > +                                    struct netlink_ext_ack *extack)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     int ret;
> > +
> > +     ret = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE,
> > +                       flag);
> 
> If you're going to resend anyway, can you please check the entire
> submission for this pattern, where you can eliminate the intermediary
> "ret" variable and just return the function call directly?
> 
>         return lan937x_cfg(...)
Sure

> Do you have an explanation for what SW_VLAN_ENABLE does exactly?
Enabling the VLAN mode and then act as per the VLAN table.
Do you want me to add this explanation as a comment? or?



> > 
> > 
> > +static int lan937x_port_vlan_del(struct dsa_switch *ds, int port,
> > +                              const struct switchdev_obj_port_vlan *vlan)
> > +{
> > +     bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> > +     struct ksz_device *dev = ds->priv;
> > +     struct lan937x_vlan vlan_entry;
> > +     u16 pvid;
> > +     int ret;
> > +
> > +     lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
> > +     pvid &= 0xFFF;
> > +
> > +     ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
> > +     if (ret < 0) {
> > +             dev_err(dev->dev, "Failed to get vlan table\n");
> > +             return ret;
> > +     }
> > +     /* clear port fwd map */
> > +     vlan_entry.fwd_map &= ~BIT(port);
> > +
> > +     if (untagged)
> > +             vlan_entry.untag_prtmap &= ~BIT(port);
> 
> This is bogus.
> The user can add a VLAN entry using:
> 
> bridge vlan add dev lan0 vid 100 pvid untagged
> 
> and remove it using
> 
> bridge vlan del dev lan0 vid 100
> 
> so BRIDGE_VLAN_INFO_UNTAGGED is not set on removal.
> 
> Considering the fact that it doesn't matter whether the port is
> egress-tagged or not when it isn't in the fwd_map in the first place,
> I suggest you completely drop this condition.
Sure, i agree with you.

> 
> > +
> > +     ret = lan937x_set_vlan_table(dev, vlan->vid, &vlan_entry);
> > +     if (ret < 0) {
> > +             dev_err(dev->dev, "Failed to set vlan table\n");
> > +             return ret;
> > +     }
> > +
> > +     ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
> 
> What is the point of reading the pvid and writing it back unmodified?
> Is the AND-ing with 0xFFF supposed to do anything? Because when you
> write to REG_PORT_DEFAULT_VID, you write it with nothing in the upper
> bits, so I expect there to be nothing in the upper bits when you read it
> back either.
I had a feedback for not to reset the PVID as per the switchdev documentation
during vlan del. As part of the fix , i just removed PVID reset code alone but
missed these. Read/write PVID to be completely removed. I had a test case to
make sure that the PVID is not reset during vlan del. Since this is
reading/writing back the same values, could not catch them. I will clean up in
the next patch.


> 
> > +     if (ret < 0) {
> > +             dev_err(dev->dev, "Failed to set pvid\n");
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> 
> Also, consider the following set of commands:
> 
Step (0)
> ip link add br0 type bridge vlan_filtering 1
> ip link set lan0 master br0
> bridge vlan add dev lan0 vid 100 pvid untagged
Step (1)
> bridge vlan del dev lan0 vid 100
Step (2)
> ip link set br0 type bridge vlan_filtering 0
> 
> The expectation is that the switch, being VLAN-unaware as it is currently
> configured, receives and sends any packet regardless of VLAN ID.
> If you put an IP on br0 in this state, are you able to ping an outside host?

I have numbered the commands above.
Results are,
Before Step (0). Am able to ping outside.
After Step (0). Am not able to ping outside because the vlan table is set
After Step (1). Am not able to ping outside
After Step (2). Am able to ping outside because of vlan unaware mode.

