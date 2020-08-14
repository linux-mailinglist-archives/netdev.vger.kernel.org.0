Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3B2244836
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 12:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHNKmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 06:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgHNKmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 06:42:33 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD81C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 03:42:32 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id o18so9430960eje.7
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 03:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=Ye+/u63n45jdsDXa+Zl5gyzWrNkHv4h4sh38WVBJOjE=;
        b=gGwVYjLR6XPROdmfW0rF5NKRXPmgSNIwN8zH43BKJmXMEv2as3bA4kDh9+lJMtwFWA
         v/AzxgrdDvuNKMNhvDHSRpGGDEMCjzjY7J8x+BTk4GZ7UDQb6pjxysUjhY7CQHub39Oi
         683tZZGieRvSqprQxuU4D5myoWXuREzkiwQZ8vKujcS1sckLoEQnw17wapQmmPLNtP7p
         PA4t1pRA0S0b/QeAWM3uqxpByr7YrNEckIHgRJ3D4NW8NC7xPw/GX9arc3Lrh99MY5Wu
         QxG6Dwl0Ot14FpEa7rbS6HLF4sM+BiPc6gAzgwCZB02NyZ+bj++8LRoHh7qJpWLEmi67
         43Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=Ye+/u63n45jdsDXa+Zl5gyzWrNkHv4h4sh38WVBJOjE=;
        b=W1aogL22u0oZh0FUF62xZ9P9fYvNo1depRVIWKW5m+mGW1BWpgiIo9S9UYq8UCVebY
         xICI+qeqLMq3ZuWHNYpiawVCfV46jHyA/IVV1HsX2pIF3stiNjIXu+WL2Q2OWGp1egeE
         gsjzpvk5WEc0ckzbqwO6OWOYeF8rV4b/LeDQsZ4mzUs3FBC2fSVNep1nUHM4wEhfraT1
         QrAPIKMGMCCQA3DdAAobT85JuVab5SWACSXnyvWBndtyaFiMlol2AAjc/TqW+3yIMTUE
         mxQHzbxmwXskkT0Kq3Qv1cE1Ers8f3l7VJuphGwChxybIBJbsitoIgRZWP8oE9jKtksR
         ZSxw==
X-Gm-Message-State: AOAM532ClPNo+WF9P2S2W5EcsQEwYdxFXsigsDND4CWNWUL0K/DbdU/H
        29KseuYv4kgkqr48Ab/RwZanVoZdTTY=
X-Google-Smtp-Source: ABdhPJxR1JoLajHvqS9eGKxnLkUe2gGazixu07iM3WJM9T5BxA8Kewh6vUmf60zy7xXu3LuMRoEvnw==
X-Received: by 2002:a17:907:1183:: with SMTP id uz3mr1781250ejb.216.1597401751317;
        Fri, 14 Aug 2020 03:42:31 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id bx22sm6607827ejc.18.2020.08.14.03.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 03:42:30 -0700 (PDT)
Date:   Fri, 14 Aug 2020 13:42:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: devlink-sb on ocelot switches
Message-ID: <20200814104228.eidqu7fd7mfyur5n@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry in advance for the long message, I am trying to summarize with as
few words as possible, however the topic is not completely trivial so
explanation is needed.

I have a switch supported by drivers/net/mscc/ocelot*.c code, and I
would like to expose resource consumption watermarks through devlink-sb.

This switch family tracks consumption of memory and of frame references.
My switch has 128 KB of packet buffer and 1092 available frame
references. Packet buffers are accounted for in cells of 60 bytes each,
and frame references in units of 1.

There are 1024 watermarks inside the switch. Their role is fixed
according to their index. There are 16 types of watermarks (the
cartesian product between BUF_xxxx_I etc, and xxx_Q_RSRV_x etc).

The switch has queues on both ingress and egress.

/* The queue system tracks four resource consumptions:
 * Resource 0: Memory tracked per source port
 * Resource 1: Frame references tracked per source port
 * Resource 2: Memory tracked per destination port
 * Resource 3: Frame references tracked per destination port
 */
#define OCELOT_RESOURCE_SZ		256
#define OCELOT_NUM_RESOURCES		4

#define BUF_xxxx_I			(0 * OCELOT_RESOURCE_SZ)
#define REF_xxxx_I			(1 * OCELOT_RESOURCE_SZ)
#define BUF_xxxx_E			(2 * OCELOT_RESOURCE_SZ)
#define REF_xxxx_E			(3 * OCELOT_RESOURCE_SZ)

/* For each resource type there are 4 types of watermarks:
 * Q_RSRV: reservation per QoS class per port
 * PRIO_SHR: sharing watermark per QoS class across all ports
 * P_RSRV: reservation per port
 * COL_SHR: sharing watermark per color (drop precedence) across all ports
 */
#define xxx_Q_RSRV_x			0
#define xxx_PRIO_SHR_x			216
#define xxx_P_RSRV_x			224
#define xxx_COL_SHR_x			254

/*
 * Reservation Watermarks
 * ----------------------
 *
 * For setting up the reserved areas, egress watermarks exist per port and per
 * QoS class for both ingress and egress.
 */

/*
 *  Amount of packet buffer
 *  |  per QoS class
 *  |  |  reserved
 *  |  |  |   per egress port
 *  |  |  |   |
 *  V  V  v   v
 * BUF_Q_RSRV_E
 */
#define BUF_Q_RSRV_E(port, prio) \
	(BUF_xxxx_E + xxx_Q_RSRV_x + 8 * (port) + (prio))

/*
 *  Amount of packet buffer
 *  |  for all port's traffic classes
 *  |  |  reserved
 *  |  |  |   per egress port
 *  |  |  |   |
 *  V  V  v   v
 * BUF_P_RSRV_E
 */
#define BUF_P_RSRV_E(port) \
	(BUF_xxxx_E + xxx_P_RSRV_x + (port))

/*
 *  Amount of packet buffer
 *  |  per QoS class
 *  |  |  reserved
 *  |  |  |   per ingress port
 *  |  |  |   |
 *  V  V  v   v
 * BUF_Q_RSRV_I
 */
#define BUF_Q_RSRV_I(port, prio) \
	(BUF_xxxx_I + xxx_Q_RSRV_x + 8 * (port) + (prio))

/*
 *  Amount of packet buffer
 *  |  for all port's traffic classes
 *  |  |  reserved
 *  |  |  |   per ingress port
 *  |  |  |   |
 *  V  V  v   v
 * BUF_P_RSRV_I
 */
#define BUF_P_RSRV_I(port) \
	(BUF_xxxx_I + xxx_P_RSRV_x + (port))

/*
 *  Amount of frame references
 *  |  per QoS class
 *  |  |  reserved
 *  |  |  |   per egress port
 *  |  |  |   |
 *  V  V  v   v
 * REF_Q_RSRV_E
 */
#define REF_Q_RSRV_E(port, prio) \
	(REF_xxxx_E + xxx_Q_RSRV_x + 8 * (port) + (prio))

/*
 *  Amount of frame references
 *  |  for all port's traffic classes
 *  |  |  reserved
 *  |  |  |   per egress port
 *  |  |  |   |
 *  V  V  v   v
 * REF_P_RSRV_E
 */
#define REF_P_RSRV_E(port) \
	(REF_xxxx_E + xxx_P_RSRV_x + (port))

/*
 *  Amount of frame references
 *  |  per QoS class
 *  |  |  reserved
 *  |  |  |   per ingress port
 *  |  |  |   |
 *  V  V  v   v
 * REF_Q_RSRV_I
 */
#define REF_Q_RSRV_I(port, prio) \
	(REF_xxxx_I + xxx_Q_RSRV_x + 8 * (port) + (prio))

/*
 *  Amount of frame references
 *  |  for all port's traffic classes
 *  |  |  reserved
 *  |  |  |   per ingress port
 *  |  |  |   |
 *  V  V  v   v
 * REF_P_RSRV_I
 */
#define REF_P_RSRV_I(port) \
	(REF_xxxx_I + xxx_P_RSRV_x + (port))

/*
 * Sharing Watermarks
 * ------------------
 *
 * The shared memory area is shared between all ports.
 */

/*
 * Amount of buffer
 *  |   per QoS class
 *  |   |    from the shared memory area
 *  |   |    |  for egress traffic
 *  |   |    |  |
 *  V   V    v  v
 * BUF_PRIO_SHR_E
 */
#define BUF_PRIO_SHR_E(prio) \
	(BUF_xxxx_E + xxx_PRIO_SHR_x + (prio))

/*
 * Amount of buffer
 *  |   per color (drop precedence level)
 *  |   |   from the shared memory area
 *  |   |   |  for egress traffic
 *  |   |   |  |
 *  V   V   v  v
 * BUF_COL_SHR_E
 */
#define BUF_COL_SHR_E(dp) \
	(BUF_xxxx_E + xxx_COL_SHR_x + (1 - (dp)))

/*
 * Amount of buffer
 *  |   per QoS class
 *  |   |    from the shared memory area
 *  |   |    |  for ingress traffic
 *  |   |    |  |
 *  V   V    v  v
 * BUF_PRIO_SHR_I
 */
#define BUF_PRIO_SHR_I(prio) \
	(BUF_xxxx_I + xxx_PRIO_SHR_x + (prio))

/*
 * Amount of buffer
 *  |   per color (drop precedence level)
 *  |   |   from the shared memory area
 *  |   |   |  for ingress traffic
 *  |   |   |  |
 *  V   V   v  v
 * BUF_COL_SHR_I
 */
#define BUF_COL_SHR_I(dp) \
	(BUF_xxxx_I + xxx_COL_SHR_x + (1 - (dp)))

/*
 * Amount of frame references
 *  |   per QoS class
 *  |   |    from the shared area
 *  |   |    |  for egress traffic
 *  |   |    |  |
 *  V   V    v  v
 * REF_PRIO_SHR_E
 */
#define REF_PRIO_SHR_E(prio) \
	(REF_xxxx_E + xxx_PRIO_SHR_x + (prio))

/*
 * Amount of frame references
 *  |   per color (drop precedence level)
 *  |   |   from the shared area
 *  |   |   |  for egress traffic
 *  |   |   |  |
 *  V   V   v  v
 * REF_COL_SHR_E
 */
#define REF_COL_SHR_E(dp) \
	(REF_xxxx_E + xxx_COL_SHR_x + (1 - (dp)))

/*
 * Amount of frame references
 *  |   per QoS class
 *  |   |    from the shared area
 *  |   |    |  for ingress traffic
 *  |   |    |  |
 *  V   V    v  v
 * REF_PRIO_SHR_I
 */
#define REF_PRIO_SHR_I(prio) \
	(REF_xxxx_I + xxx_PRIO_SHR_x + (prio))

/*
 * Amount of frame references
 *  |   per color (drop precedence level)
 *  |   |   from the shared area
 *  |   |   |  for ingress traffic
 *  |   |   |  |
 *  V   V   v  v
 * REF_COL_SHR_I
 */
#define REF_COL_SHR_I(dp) \
	(REF_xxxx_I + xxx_COL_SHR_x + (1 - (dp)))

Now comes the tricky part. Here is how, to the best of my understanding,
the switch admission control based on watermarks works.

First it checks for buffer reservations for the associated QoS class
(tc) of the ingress port.

Then it checks for buffer reservations for the entire port, regardless
of tc.

If the reservation thresholds for the ingress port are exceeded, it
tries to consume buffers from the reservations of the egress port
(decided through forwarding).

If this doesn't work out either, the watermarks for shared (not reserved
to any port) buffers are checked. All sharing watermarks must be below
their configured thresholds.

For a frame to pass the controlling watermark checks, both buffers need
to be available, and frame references need to be available. The check
for frame references is identical to the one for buffers, in principle,
and shown to the right of the diagram below.

              Start
                v
                v
           Memory check               +>>>>>>>>>> Frame reference check
                v                     ^                    v
                v                     ^                    v
           Ingress memory             ^            Ingress references
           is available?              ^              are available?
                v                     ^                    v
                v        not exceeded ^                    v    not exceeded
           BUF_Q_RSRV_I >>>>>>>>>>>>>>+               REF_Q_RSRV_I >>> accept
                v                     ^                    v
       exceeded v                     ^           exceeded v
                v        not exceeded ^                    v    not exceeded
           BUF_P_RSRV_I >>>>>>>>>>>>>>+               REF_P_RSRV_I >>> accept
                v                     ^                    v
       exceeded v                     ^           exceeded v
                v                     ^                    v
           Egress memory              ^             Egress references
           is available?              ^              are available?
                v                     ^                    v
       exceeded v                     ^           exceeded v
                v        not exceeded ^                    v    not exceeded
           BUF_Q_RSRV_E >>>>>>>>>>>>>>+               REF_Q_RSRV_E >>> accept
                v                     ^                    v
       exceeded v                     ^           exceeded v
                v        not exceeded ^                    v    not exceeded
           BUF_P_RSRV_E >>>>>>>>>>>>>>+               REF_P_RSRV_E >>> accept
                v                     ^                    v
       exceeded v                     ^           exceeded v
                v                     ^                    v
           Shared memory              ^             Shared references
           is available?              ^              are available?
                v                     ^                    v
   exceeded     v                     ^                    v      exceeded
drop <<<< BUF_PRIO_SHR_E              ^              REF_PRIO_SHR_E >>>> drop
                v                     ^                    v
                v not exceeded        ^       not exceeded v
   exceeded     v                     ^                    v      exceeded
drop <<<< BUF_COL_SHR_E               ^              REF_COL_SHR_E >>>>> drop
                v                     ^                    v
                v not exceeded        ^       not exceeded v
   exceeded     v                     ^                    v      exceeded
drop <<< BUF_PRIO_SHR_I               ^             REF_PRIO_SHR_I >>>>> drop
                v                     ^                    v
                v not exceeded        ^       not exceeded v
   exceeded     v                     ^                    v      exceeded
drop <<< BUF_COL_SHR_I                ^             REF_COL_SHR_I >>>>>> drop
                v                     ^                    v
                v not exceeded        ^       not exceeded v
                v                     ^                    v
                +>>>>>>>>>>>>>>>>>>>>>+                 accept

Now, I was trying to understand whether these watermarks can be exposed
through devlink-sb.

Step 1:

   devlink sb show - display available shared buffers and their attributes
       DEV - specifies the devlink device to show shared buffers.  If
       this argument is omitted all shared buffers of all devices are
       listed.

       SB_INDEX - specifies the shared buffer.  If this argument is
       omitted shared buffer with index 0 is selected.  Behaviour of
       this argument it the same for every command.

What should this list for ocelot?
I was thinking it could list 2 shared buffers:
- SB_INDEX 0: this is the packet buffer. Its size is 128 KB. Its cell
  size is 60 bytes.
- SB_INDEX 1: this is the group of frame references. Its size is 1092.
  Its cell size is 1.

Step 2:

   devlink sb pool show - display available pools and their attributes
       DEV - specifies the devlink device to show pools.  If this
       argument is omitted all pools of all devices are listed.

       Display available pools listing their type, size, thtype and
       cell_size. cell_size is the allocation granularity of memory
       within the shared buffer. Drivers may round up, round down or
       reject size passed to the set command if it is not multiple of
       cell_size.

Hmmmmm....
I have 2 conflicting thoughts here.

First would be that both SB_INDEX 0 and SB_INDEX 1 would have a single
pool, POOL_INDEX 0. The size of this pool would be equal to the size of
the SB_INDEX it belongs to.

The other thought is that maybe it would be overall simpler if I could
just add a new DEVLINK_ATTR_SB_POOL_NAME attribute, which is a string,
and expose all the BUF_Q_RSRV_E_PORT0_TC6 stuff as its own pool. Then,
configuring the size of this pool would in fact configure its threshold.
See more below on why I think this is simpler.

Step 3:

   devlink sb pool set - set attributes of pool
       DEV - specifies the devlink device to set pool.

       size POOL_SIZE
              size of the pool in Bytes.

       thtype { static | dynamic }
              pool threshold type.

              static - Threshold values for the pool will be passed in Bytes.

              dynamic - Threshold values ("to_alpha") for the pool will
                        be used to compute alpha parameter according to
                        formula:
                              alpha = 2 ^ (to_alpha - 10)

                        The range of the passed value is between 0 to
                        20. The computed alpha is used to determine the
                        maximum usage of the flow:
                              max_usage = alpha / (1 + alpha) * Free_Buffer

Ok, so if I go with first thought, to only implement POOL_INDEX 0, then
nothing is configurable. The size is fixed, and the thtype is static.

Step 4:

   devlink sb port pool show - display port-pool combinations and
                               threshold for each
       DEV/PORT_INDEX - specifies the devlink port.

       pool POOL_INDEX
              pool index.

   devlink sb port pool set - set port-pool threshold
       DEV/PORT_INDEX - specifies the devlink port.

       pool POOL_INDEX
              pool index.

       th THRESHOLD
              threshold value. Type of the value is either Bytes or
              "to_alpha", depends on thtype set for the pool.

Ok, the 'port pool' is what? Is it BUF_P_RSRV_E (egress reservation) or
BUF_P_RSRV_I (ingress reservation)? Unlike traffic classes, the port
pool does not have a "type { ingress | egress }".

Also, I cannot assign a pool to a port dynamically. The design of this
switch is as such that the assignment is fixed.

Step 5:

   devlink sb tc bind set - set port-TC to pool binding with specified
                            threshold
       DEV/PORT_INDEX - specifies the devlink port.

       tc TC_INDEX
              index of either ingress or egress TC, usually in range 0
              to 8 (depends on device).

       type { ingress | egress }
              TC type.

       pool POOL_INDEX
              index of pool to bind this to.

       th THRESHOLD
              threshold value. Type of the value is either Bytes or
              "to_alpha", depends on thtype set for the pool.

The 'tc' pool should be BUF_Q_RSRV_E, if type==egress, or BUF_Q_RSRV_I,
if type==ingress. This is, I think, the only aspect that maps well over
the hardware. The POOL_INDEX could only be zero, same as the POOL_INDEX
for the port.

Step 6:

What isn't shown:

1. How could I model the sharing watermarks?
- Buffers that frames with tc={0,1,2...7} can consume, irrespective of
  source or destination port, when the reservation watermarks are
  exceeded. Per ingress and per egress direction.
- Buffers that frames with dp={0,1} can consume when reservations are
  exceeded. Per ingress and per egress direction.
- Ports can be configured to draw from the sharing watermarks or only
  from their own reservations.

2. Is it ok if I model the frame references as another shared buffer?
   There are some places that refer to devlink-sb as bytes, and these
   wouldn't be that.

3. What I've shown here is _not_ tail dropping. It is _congestion_
   dropping. These watermarks are used for:
   - Flow control, if the port is in pause mode.
   - Congestion dropping, if the port is in drop mode.
   But each port also has a setting called INGRESS_DROP_MODE and another
   one called EGRESS_DROP_MODE. When these are set to zero, the
   controlling watermarks do not cause packet drops. The watermarks are
   simply allowed to exceed, and the packets are kept in the ingress
   queues (not transferred to the egress ones).
   The packets _will_ be dropped eventually, when the tail drop
   watermarks are reached. A packet will be tail dropped when:
   - The ingress port memory consumption exceeds the
     SYS:PORT:ATOP_CFG.ATOP watermark
   AND
   - The total consumed memory in the shared queue system exceeds the
     SYS:PORT:ATOP_TOT_CFG.ATOP_TOT watermark.
   Aka: when there's no memory left, drop the traffic of the offending
   ingress ports.
   How can I configure the tail dropping watermarks (global and per
   port)? Still through devlink-sb or through a different mechanism?

Step 7:

   devlink sb occupancy show - display shared buffer occupancy values
                                for device or port
       This command is used to browse shared buffer occupancy values.
       Values are showed for every port-pool combination as well as for
       all port-TC combinations (with pool this port-TC is bound to).
       Format of value is:
                       current_value/max_value
       Note that before showing values, one has to issue occupancy
       snapshot command first.

       DEV - specifies the devlink device to show occupancy values for.

       DEV/PORT_INDEX - specifies the devlink port to show occupancy values for.

   devlink sb occupancy snapshot - take occupancy snapshot of shared
                                   buffer for device
       This command is used to take a snapshot of shared buffer
       occupancy values. After that, the values can be showed using
       occupancy show command.

       DEV - specifies the devlink device to take occupancy snapshot on.

   devlink sb occupancy clearmax - clear occupancy watermarks of shared
                                   buffer for device
       This command is used to reset maximal occupancy values reached
       for whole device. Note that before browsing reset values, one has
       to issue occupancy snapshot command.

       DEV - specifies the devlink device to clear occupancy watermarks
       on.

There are 2 aspects when it comes to the ocelot switches:
1. There isn't any way to atomically snapshot all the 1024 watermarks.
2. Each watermark has 2 status values: INUSE (current) and MAXUSE
   (maximum since last time it was read). But the MAXUSE counter resets
   on its own when reading it...

Also, there is another major issue, I think. The occupancy is per pool,
am I right? And I have a single pool...

Thanks,
-Vladimir
