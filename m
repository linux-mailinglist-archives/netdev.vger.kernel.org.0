Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D77663ECDF
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiLAJsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiLAJsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:48:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0813D911;
        Thu,  1 Dec 2022 01:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669888089; x=1701424089;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rDAe2kQfpvbvGbtHIdt/8h/yij6HnvtvEPNK7N+IFkw=;
  b=oaEEWgfGyA9jfpKKRhDKlGEQELgE8yLa0nMzDBHEqbpUnyJ/RzOFQeso
   PKnKVCT1N2vmoyb8eiOO74JVTS7Y1xqZABIYwPOSXJSvzzhF0N2AW65P6
   XeBtqw7SgLReLllYS0MxJfDM8nB7qPfovmPvBmTEaEdTON0eV0gXLrMNq
   3YQHe2RSCSgJzI2m6wiFj+jeRPrl/oKibbVVLFMN/GCCHvAV3M+AQi4ai
   tq5VXe1tNxTD/GknAVm1uo1M3Tb3I0Qj1jdJkRP59jJiszYsNDlqVnPVj
   kCtHpTnZT6ldK5slnpsTjmm/t0i+Qc/mSk6avz3zrhKiaBJdGRgN1hk/c
   g==;
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="189518671"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 02:48:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 02:48:06 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 1 Dec 2022 02:48:06 -0700
Date:   Thu, 1 Dec 2022 10:53:10 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221201095310.qw5ckd6fp7lrxypr@soft-dev3-1>
References: <20221130143525.934906-1-horatiu.vultur@microchip.com>
 <20221130143525.934906-1-horatiu.vultur@microchip.com>
 <20221130143525.934906-5-horatiu.vultur@microchip.com>
 <20221130143525.934906-5-horatiu.vultur@microchip.com>
 <20221130165443.ewjwm3z7nbwmktcv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221130165443.ewjwm3z7nbwmktcv@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/30/2022 18:54, Vladimir Oltean wrote:
> 
> Hello Horatiu,

Hi Vladimir,

> 
> On Wed, Nov 30, 2022 at 03:35:25PM +0100, Horatiu Vultur wrote:
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> > index e5a2bbe064f8f..1f6614ee83169 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> > @@ -3,6 +3,8 @@
> >  #include <linux/ptp_classify.h>
> >
> >  #include "lan966x_main.h"
> > +#include "vcap_api.h"
> > +#include "vcap_api_client.h"
> >
> >  #define LAN966X_MAX_PTP_ID   512
> >
> > @@ -18,6 +20,17 @@
> >
> >  #define TOD_ACC_PIN          0x7
> >
> > +/* This represents the base rule ID for the PTP rules that are added in the
> > + * VCAP to trap frames to CPU. This number needs to be bigger than the maximum
> > + * number of entries that can exist in the VCAP.
> > + */
> > +#define LAN966X_VCAP_PTP_RULE_ID     1000000
> > +#define LAN966X_VCAP_L2_PTP_TRAP     (LAN966X_VCAP_PTP_RULE_ID + 0)
> > +#define LAN966X_VCAP_IPV4_EV_PTP_TRAP        (LAN966X_VCAP_PTP_RULE_ID + 1)
> > +#define LAN966X_VCAP_IPV4_GEN_PTP_TRAP       (LAN966X_VCAP_PTP_RULE_ID + 2)
> > +#define LAN966X_VCAP_IPV6_EV_PTP_TRAP        (LAN966X_VCAP_PTP_RULE_ID + 3)
> > +#define LAN966X_VCAP_IPV6_GEN_PTP_TRAP       (LAN966X_VCAP_PTP_RULE_ID + 4)
> > +
> >  enum {
> >       PTP_PIN_ACTION_IDLE = 0,
> >       PTP_PIN_ACTION_LOAD,
> > @@ -35,19 +48,229 @@ static u64 lan966x_ptp_get_nominal_value(void)
> >       return 0x304d4873ecade305;
> >  }
> >
> > +static int lan966x_ptp_add_trap(struct lan966x_port *port,
> > +                             int (*add_ptp_key)(struct vcap_rule *vrule,
> > +                                                struct lan966x_port*),
> > +                             u32 rule_id,
> > +                             u16 proto)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     struct vcap_rule *vrule;
> > +     int err;
> > +
> > +     vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
> > +     if (vrule) {
> > +             u32 value, mask;
> > +
> > +             /* Just modify the ingress port mask and exit */
> > +             vcap_rule_get_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK,
> > +                                   &value, &mask);
> > +             mask &= ~BIT(port->chip_port);
> > +             vcap_rule_mod_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK,
> > +                                   value, mask);
> > +
> > +             err = vcap_mod_rule(vrule);
> > +             goto free_rule;
> > +     }
> > +
> > +     vrule = vcap_alloc_rule(lan966x->vcap_ctrl, port->dev,
> > +                             LAN966X_VCAP_CID_IS2_L0,
> > +                             VCAP_USER_PTP, 0, rule_id);
> > +     if (!vrule)
> > +             return -ENOMEM;
> > +     if (IS_ERR(vrule))
> > +             return PTR_ERR(vrule);
> > +
> > +     err = add_ptp_key(vrule, port);
> > +     if (err)
> > +             goto free_rule;
> > +
> > +     err = vcap_set_rule_set_actionset(vrule, VCAP_AFS_BASE_TYPE);
> > +     err |= vcap_rule_add_action_bit(vrule, VCAP_AF_CPU_COPY_ENA, VCAP_BIT_1);
> > +     err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE, LAN966X_PMM_REPLACE);
> > +     err |= vcap_val_rule(vrule, proto);
> > +     if (err)
> > +             goto free_rule;
> > +
> > +     err = vcap_add_rule(vrule);
> > +
> > +free_rule:
> > +     /* Free the local copy of the rule */
> > +     vcap_free_rule(vrule);
> > +     return err;
> > +}
> > +
> > +static int lan966x_ptp_del_trap(struct lan966x_port *port,
> > +                             u32 rule_id)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     struct vcap_rule *vrule;
> > +     u32 value, mask;
> > +     int err;
> > +
> > +     vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
> > +     if (!vrule)
> > +             return -EEXIST;
> > +
> > +     vcap_rule_get_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK, &value, &mask);
> > +     mask |= BIT(port->chip_port);
> 
> Does the VCAP API not abstract away the negative mask representation of
> the IGR_PORT_MASK field?

It doesn't look like. I think some of the reasons are:
- the vcap library interprets this key as any other key. It doesn't do
  anything special, as this library is used by other chips which might
  not the negative mask (currently there is no chip like this).
- also usually the user doesn't need to add this mask, because is added
  by default if the key doesn't exist. Of course this case with ptp is
  more special because we try to reuse the rules in HW.

> I guess someone will stumble upon this in the
> future and introduce a bug. In ocelot, struct ocelot_vcap_filter ::
> ingress_port_mask ended being used quite in a wide variety of places.
> It would be quite messy, unintuitive and tiring to treat it like a
> reverse port mask everywhere it is used. In ocelot_vcap.c, it is just
> reversed in the vcap_key_set() call.

...

> > +static int lan966x_ptp_add_l2_key(struct vcap_rule *vrule,
> > +                               struct lan966x_port *port)
> > +{
> > +     return vcap_rule_add_key_u32(vrule, VCAP_KF_ETYPE, ETH_P_1588, ~0);
> > +}
> > +
> > +static int lan966x_ptp_add_ip_event_key(struct vcap_rule *vrule,
> > +                                     struct lan966x_port *port)
> > +{
> > +     return vcap_rule_add_key_u32(vrule, VCAP_KF_L4_DPORT, 319, ~0) ||
> 
> s/319/PTP_EV_PORT/
> 
> > +            vcap_rule_add_key_bit(vrule, VCAP_KF_TCP_IS, VCAP_BIT_0);
> > +}
> > +
> > +static int lan966x_ptp_add_ip_general_key(struct vcap_rule *vrule,
> > +                                       struct lan966x_port *port)
> > +{
> > +     return vcap_rule_add_key_u32(vrule, VCAP_KF_L4_DPORT, 320, ~0) ||
> 
> s/320/PTP_GEN_PORT/

Great catch! I will update these in the next version.

> 
> > +             vcap_rule_add_key_bit(vrule, VCAP_KF_TCP_IS, VCAP_BIT_0);
> > +}
> > +
> > +static int lan966x_ptp_add_l2_rule(struct lan966x_port *port)
> > +{
> > +     return lan966x_ptp_add_trap(port, lan966x_ptp_add_l2_key,
> > +                                 LAN966X_VCAP_L2_PTP_TRAP, ETH_P_ALL);
> > +}
> > +
> > +static int lan966x_ptp_add_ipv4_rules(struct lan966x_port *port)
> > +{
> > +     int err;
> > +
> > +     err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_event_key,
> > +                                LAN966X_VCAP_IPV4_EV_PTP_TRAP, ETH_P_IP);
> > +     if (err)
> > +             return err;
> > +
> > +     err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_general_key,
> > +                                LAN966X_VCAP_IPV4_GEN_PTP_TRAP, ETH_P_IP);
> > +     if (err)
> > +             lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV4_EV_PTP_TRAP);
> > +
> > +     return err;
> > +}
> 
> There's a comical amount of code duplication between this and ocelot_ptp.c,
> save for the fact that it was written by different people. Is there any
> possibility to reuse code with ocelot?

There is some code duplication but not much, as both of the
implementation have the same goal, to add vcap rules in HW when enabling
timestamping.
The main difference between the lan966x and ocelot is that they are
having a different API for the vcap. So they will need many function
pointers back to the drivers to fill up the keys and then also to add
the rules in vcap. I would lean reuse this code when we add
similar support for sparx5.

-- 
/Horatiu
