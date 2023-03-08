Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE586B114A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCHSrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCHSrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:47:10 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C103BC7BC
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 10:47:06 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id ky4so18596594plb.3
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 10:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678301226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QOWD8Gif2VsQSAwlsm89ThQElVvyPXDuimxBPVCUmw0=;
        b=HMjzStOaPa4UCoNNdGP57yQmAUv4jVLETwELgxn1dWJWj86TnOSzRn/TgFqSYNxmT6
         1lUfKTpdB0GwT1aNPNT+3CVA2mxrTind+sFScwXM0xSiOHnNe0Dm4BS0oiG+GSvGOs3U
         FTP94roDeXXmfUD7fXD2Kv1hiLriJcZChb6l82SkgFW5X2oDeGqWx98ZXxhjIuLQUIKY
         YiewFu5Q4XE8R5yyImq537ArQXRuiWz/LprwB2i1LRnK4S7CEJ5WX12wMMQBkptjXHur
         7gH3edj/aigl6k5wZBz5XkL1blRpnnr5jO33laFJPnuM3KfiIK+qgLI82FjzRdQ/Pgjj
         m96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678301226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QOWD8Gif2VsQSAwlsm89ThQElVvyPXDuimxBPVCUmw0=;
        b=RTktZoc7tYQv30xen/3qdh3tW1Kxraz3aSvZj7HadCtdYrrSZDb1lAADCrtC67p59P
         FU2ImEmLiksnmd/0se7eVvnP0vQ1ieL9grnN9XFiBIYZ57bSTyrJM8jYVsNESgHdutcF
         OwwHVHtBfBi6LYUyay7UUbBU3xYemW/pFT+/igqPTBwn3F9nNBaHZ+V1lWMZ7IJN0ai5
         Uu0lGuXa3Di9+pycqqiXxY0wTBXBDRv6oUXyajyG3C8Kq/Aeg5AbrUhtpuxo6xkvC5o2
         ZRPRjxAx3PqZ69LgyUrQ9mQZ2euFnm119LDzGK8dr4fSW/c4zumBHG/17RKocSFoIAxx
         Y4ww==
X-Gm-Message-State: AO0yUKX+1eAz+ctySbFsF/a0PARAKPLAWpmSg1VNXRn6dJ4LymPcbsJ5
        30U7YwkT9/WDkFxqxtbtEcgJidZyA0z5hS20cLBwcw==
X-Google-Smtp-Source: AK7set8l1vJScGVSiAsExKCVxZfjC8H8k1rxGqjkTL7kSgC7n02bPyD45v7nj3OcXDLu2vwB28FPrg==
X-Received: by 2002:a05:6a21:78a6:b0:cc:5f27:d003 with SMTP id bf38-20020a056a2178a600b000cc5f27d003mr19914446pzc.56.1678301225445;
        Wed, 08 Mar 2023 10:47:05 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x8-20020a634a08000000b00502f1256674sm9608765pga.41.2023.03.08.10.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 10:47:04 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] man/netem: rework man page
Date:   Wed,  8 Mar 2023 10:47:02 -0800
Message-Id: <20230308184702.157483-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup and rewrite netem man page.
Incorporate the examples from the old LF netem wiki
so that it can be removed/deprecated.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/tc-netem.8 | 423 ++++++++++++++++++++++++++++++--------------
 1 file changed, 289 insertions(+), 134 deletions(-)

diff --git a/man/man8/tc-netem.8 b/man/man8/tc-netem.8
index 217758541dea..b7172cddf955 100644
--- a/man/man8/tc-netem.8
+++ b/man/man8/tc-netem.8
@@ -1,6 +1,6 @@
 .TH NETEM 8 "25 November 2011" "iproute2" "Linux"
 .SH NAME
-NetEm \- Network Emulator
+netem \- Network Emulator
 .SH SYNOPSIS
 .B "tc qdisc ... dev"
 .IR DEVICE " ] "
@@ -20,7 +20,7 @@ NetEm \- Network Emulator
 .IR TIME " [ " JITTER " [ " CORRELATION " ]]]"
 .br
        [
-.BR distribution " { "uniform " | " normal " | " pareto " |  " paretonormal " } ]"
+.BR distribution " { "uniform " | " normal " | " pareto " | " paretonormal " } ]"
 
 .IR LOSS " := "
 .BR loss " { "
@@ -64,135 +64,173 @@ NetEm \- Network Emulator
 .BR bytes
 .IR BYTES " ]"
 
-
 .SH DESCRIPTION
-NetEm is an enhancement of the Linux traffic control facilities
-that allow one to add delay, packet loss, duplication and more other
-characteristics to packets outgoing from a selected network
-interface. NetEm is built using the existing Quality Of Service (QOS)
-and Differentiated Services (diffserv) facilities in the Linux
-kernel.
-
-.SH netem OPTIONS
-netem has the following options:
-
-.SS limit packets
-
-maximum number of packets the qdisc may hold queued at a time.
-
-.SS delay
-adds the chosen delay to the packets outgoing to chosen network interface. The
-optional parameters allows one to introduce a delay variation and a correlation.
-Delay and jitter values are expressed in ms while correlation is percentage.
-
-.SS distribution
-allow the user to choose the delay distribution. If not specified, the default
-distribution is Normal. Additional parameters allow one to consider situations in
-which network has variable delays depending on traffic flows concurring on the
-same path, that causes several delay peaks and a tail.
-
-.SS loss random
-adds an independent loss probability to the packets outgoing from the chosen
-network interface. It is also possible to add a correlation, but this option
-is now deprecated due to the noticed bad behavior.
-
-.SS loss state
-adds packet losses according to the 4-state Markov using the transition
-probabilities as input parameters. The parameter p13 is mandatory and if used
-alone corresponds to the Bernoulli model. The optional parameters allows one to
-extend the model to 2-state (p31), 3-state (p23 and p32) and 4-state (p14).
-State 1 corresponds to good reception, State 4 to independent losses, State 3
-to burst losses and State 2 to good reception within a burst.
-
-.SS loss gemodel
-adds packet losses according to the Gilbert-Elliot loss model or its special
-cases (Gilbert, Simple Gilbert and Bernoulli). To use the Bernoulli model, the
-only needed parameter is p while the others will be set to the default
-values r=1-p, 1-h=1 and 1-k=0. The parameters needed for the Simple Gilbert
-model are two (p and r), while three parameters (p, r, 1-h) are needed for the
-Gilbert model and four (p, r, 1-h and 1-k) are needed for the Gilbert-Elliot
-model. As known, p and r are the transition probabilities between the bad and
-the good states, 1-h is the loss probability in the bad state and 1-k is the
-loss probability in the good state.
-
-.SS ecn
-can be used optionally to mark packets instead of dropping them. A loss model
-has to be used for this to be enabled.
-
-.SS corrupt
-allows the emulation of random noise introducing an error in a random position
-for a chosen percent of packets. It is also possible to add a correlation
-through the proper parameter.
-
-.SS duplicate
-using this option the chosen percent of packets is duplicated before queuing
-them. It is also possible to add a correlation through the proper parameter.
-
-.SS reorder
-to use reordering, a delay option must be specified. There are two ways to use
-this option (assuming 'delay 10ms' in the options list).
-
-.B "reorder "
-.I 25% 50%
-.B "gap"
-.I 5
+The
+.B netem
+queue discipline provides Network Emulation functionality
+for testing protocols by emulating the properties of real world networks.
+
+The queue discipline provides a number of network impairments
+such as: delay, loss, duplication and packet corruption.
+
+.SH OPTIONS
+.TP
+.BI limit " COUNT"
+Limits the maximum number of packets the qdisc may hold when doing delay.
+
+.TP
+.B delay
+.IR TIME " [ " JITTER " [ " CORRELATION " ]]]"
 .br
-in this first example, the first 4 (gap - 1) packets are delayed by 10ms and
-subsequent packets are sent immediately with a probability of 0.25 (with
-correlation of 50% ) or delayed with a probability of 0.75. After a packet is
-reordered, the process restarts i.e. the next 4 packets are delayed and
-subsequent packets are sent immediately or delayed based on reordering
-probability. To cause a repeatable pattern where every 5th packet is reordered
-reliably, a reorder probability of 100% can be used.
+Delays the packets before sending.
+The optional parameters allow introducing a delay variation and a correlation.
+Delay and jitter values are expressed in milliseconds;
+Correlation is a percent.
+
+.TP
+.BI distribution " TYPE"
+Specifies a pattern for delay distribution.
+.RS
+.TP
+.B uniform
+Use a equally weighted distribution of packet delays.
+.TP
+.B normal
+Use a Gaussian distribution of delays.
+Sometimes called a Bell Curve.
+.TP
+.B pareto
+Use a Pareto distribution of packet delays.
+This is useful to emulate long-tail distributions.
+.TP
+.B paretonormal
+This is a mix of
+.B pareto
+and
+.B normal
+distribution which has properties of both Bell curve and long tail.
+.RE
 
-.B reorder
-.I 25% 50%
+.TP
+.BI loss " MODEL"
+Drop packets based on a loss model.
+.I MODEL
+can be one of
+.RS
+.TP
+.BI random " PERCENT"
+Each packet loss is independent.
+.TP
+.BI state " P13 [ P31 [ P32 [ P23 P14 ]]]"
+Use a 4-state Markov chain to describe packet loss.
 .br
-in this second example 25% of packets are sent immediately (with correlation of
-50%) while the others are delayed by 10 ms.
-
-.SS rate
-delay packets based on packet size and is a replacement for
-.IR TBF .
-Rate can be
-specified in common units (e.g. 100kbit). Optional
+.I P13
+is the packet loss.
+Optional parameters extend the model to 2-state
+.IR P31 ,
+3-state
+.IR P23 ,
+.I P32
+and 4-state
+.IR P14 .
+
+The Markov chain states are:
+.RS
+.TP
+.B 1
+good packet reception (no loss).
+.TP
+.B 2
+good reception within a burst.
+.TP
+.B 3
+burst losses.
+.TP
+.B 4
+independent losses.
+.RE
+
+.TP
+.BI gemodel " PERCENT [ R [ 1-H [ 1-K ]]]"
+Use a Gilbert-Elliot (burst loss) model
+based on:
+.RS
+.TP
+.I PERCENT
+probability of starting bad (lossy) state.
+.TP
+.I R
+probability of exiting bad state.
+.TP
+.I "1-H"
+loss probability in bad state.
+.TP
+.I "1-K"
+loss probability in good state.
+.RE
+.RE
+
+.TP
+.B ecn
+Use
+Explicit Congestion Notification (ECN)
+to mark packets instead of dropping them.
+A loss model has to be used for this to be enabled.
+.TP
+.BI corrupt " PERCENT"
+modifies the contents of the packet at a random position
+based on
+.IR PERCENT .
+.TP
+.BI duplicate " PERCENT"
+creates a copy of the packet before queuing.
+.TP
+.BI reorder " PERCENT"
+modifies the order of packet in the queue.
+.TP
+.BI gap " DISTANCE"
+sends some packets immediately.
+The first packets
+.I "(DISTANCE - 1)"
+are delayed and the next packet is sent immediately.
+
+.TP
+.BI rate " RATE [ PACKETOVERHEAD [ CELLSIZE  [ CELLOVERHEAD ]]]"
+delays packets based on packet size to emulate a fixed link speed.
+Optional parameters:
+.RS
+.TP
 .I PACKETOVERHEAD
-(in bytes) specify an per packet overhead and can be negative. A positive value can be
-used to simulate additional link layer headers. A negative value can be used to
-artificial strip the Ethernet header (e.g. -14) and/or simulate a link layer
-header compression scheme. The third parameter - an unsigned value - specify
-the cellsize. Cellsize can be used to simulate link layer schemes. ATM for
-example has an payload cellsize of 48 bytes and 5 byte per cell header. If a
-packet is 50 byte then ATM must use two cells: 2 * 48 bytes payload including 2
-* 5 byte header, thus consume 106 byte on the wire. The last optional value
-.I CELLOVERHEAD
-can be used to specify per cell overhead - for our ATM example 5.
+specify an per packet overhead in bytes.
+Used to simulate additional link layer headers.
+A negative value can be used to artificial strip the Ethernet header (e.g. -14) or simulate header compression.
+.TP
+.I CELLSIZE
+simulate link layer schemes like ATM.
+.TP
 .I CELLOVERHEAD
-can be negative, but use negative values with caution.
-
-Note that rate throttling is limited by several factors: the kernel clock
-granularity avoid a perfect shaping at a specific level. This will show up in
-an artificial packet compression (bursts). Another influence factor are network
-adapter buffers which can also add artificial delay.
-
-.SS slot
-defer delivering accumulated packets to within a slot. Each available slot can be
-configured with a minimum delay to acquire, and an optional maximum delay.
-Alternatively it can be configured with the distribution similar to
-.BR distribution
-for
-.BR delay
-option. Slot delays can be specified in nanoseconds, microseconds, milliseconds or seconds
-(e.g. 800us). Values for the optional parameters
-.I BYTES
-will limit the number of bytes delivered per slot, and/or
-.I PACKETS
-will limit the number of packets delivered per slot.
+specify per cell overhead.
+.RE
+
+Rate throttling is limited by several factors including the kernel clock
+granularity. This will show up in an artificial packet compression (bursts).
+
+.TP
+.BI slot " MIN_DELAY [  MAX_DELAY  ]"
+allows emulating slotted networks.
+Defer delivering accumulated packets to within a slot.
+Each available slot is configured with a minimum delay to acquire,
+and an optional maximum delay.
+.TP
+.B slot distribution
+allows configuring based on distribution similar to
+.B distribution
+option for packet delays.
 
 These slot options can provide a crude approximation of bursty MACs such as
 DOCSIS, WiFi, and LTE.
 
-Note that slotting is limited by several factors: the kernel clock granularity,
+Slot emulation is limited by several factors: the kernel clock granularity,
 as with a rate, and attempts to deliver many packets within a slot will be
 smeared by the timer resolution, and by the underlying native bandwidth also.
 
@@ -201,36 +239,153 @@ where either the rate, or the slot limits on bytes or packets per slot, govern
 the actual delivered rate.
 
 .SH LIMITATIONS
-The main known limitation of Netem are related to timer granularity, since
-Linux is not a real-time operating system.
+Netem is limited by the timer granularity in the kernel.
+Rate and delay maybe impacted by clock interrupts.
+.PP
+Mixing forms of reordering may lead to unexpected results
+For any method of reordering to work, some delay is necessary.
+If the delay is less than the inter-packet arrival time then
+no reordering will be seen.
+Due to mechanisms like TSQ (TCP Small Queues), for TCP performance test results to be realistic netem must be placed on the ingress of the receiver host.
+.PP
+Combining netem with other qdisc is possible but may not always
+work because netem use skb control block to set delays.
 
 .SH EXAMPLES
 .PP
-tc qdisc add dev eth0 root netem rate 5kbit 20 100 5
+.EX
+# tc qdisc add dev eth0 root netem delay 100ms
+.EE
+.RS 4
+Add fixed amount of delay to all packets going out on device eth0.
+Each packet will have added delay to be 100ms ± 10ms.
+.RE
+.PP
+.EX
+# tc qdisc change dev eth0 root netem delay 100ms 10ms 25%
+.EE
+.RS 4
+This causes the added delay to be 100ms ± 10ms with the next random element depending 25% on the last one.
+This isn't true statistical correlation, but an approximation.
+.RE
+.PP
+.EX
+# tc qdisc change dev eth0 root netem delay 100ms 20ms distribution normal
+.EE
+.RS 4
+Delays packets according to a normal distribution (Bell curve)
+over a range of 100ms ± 20ms.
+.RE
+.PP
+.EX
+# tc qdisc change dev eth0 root netem loss 0.1%
+.EE
+.RS 4
+This causes 1/10th of a percent (i.e 1 out of 1000) packets to be
+randomly dropped.
+
+An optional correlation may also be added.
+This causes the random number generator to be less random and can be used to emulate packet burst losses.
+.RE
+.PP
+.EX
+# tc qdisc change dev eth0 root netem duplicate 1%
+.EE
+.RS 4
+Causes one percent of the packets sent on eth0 to be duplicated.
+.RE
+.PP
+.EX
+# tc qdisc change dev eth0 root netem loss 0.3% 25%
+.EE
+.RS 4
+This will cause 0.3% of packets to be lost,
+and each successive probability depends by a quarter on the last one.
+.RE
+.PP
+There are two different ways to specify reordering.
+The gap method uses a fixed sequence and reorders every Nth packet.
+.EX
+# tc qdisc change dev eth0 root netem gap 5 delay 10ms
+.EE
+.RS 4
+This causes every 5th (10th, 15th, …) packet to go to be sent immediately
+and every other packet to be delayed by 10ms.
+This is predictable and useful for base protocol testing like reassembly.
+.RE
+.PP
+The reorder form uses a percentage of the packets to get misordered.
+.EX
+# tc qdisc change dev eth0 root netem delay 10ms reorder 25% 50%
+.EE
+In this example, 25% of packets (with a correlation of 50%) will get sent immediately, others will be delayed by 10ms.
+.PP
+Packets will also get reordered if jitter is large enough.
+.EX
+# tc qdisc change dev eth0 root netem delay 100ms 75ms
+.EE
+.RS 4
+If the first packet gets a random delay of 100ms (100ms base - 0ms jitter)
+and the second packet is sent 1ms later and gets a delay of 50ms (100ms base - 50ms jitter);
+the second packet will be sent first.
+This is because the queue discipline tfifo inside netem,
+keeps packets in order by time to send.
+.RE
+.PP
+If you don't want this behavior then replace the internal
+queue discipline tfifo with a simple FIFO queue discipline.
+.EX
+# tc qdisc add dev eth0 root handle 1: netem delay 10ms 100ms
+# tc qdisc add dev eth0 parent 1:1 pfifo limit 1000
+.EE
+
+.PP
+Example of using rate control and cells size.
+.EX
+# tc qdisc add dev eth0 root netem rate 5kbit 20 100 5
+.EE
 .RS 4
 delay all outgoing packets on device eth0 with a rate of 5kbit, a per packet
-overhead of 20 byte, a cellsize of 100 byte and a per celloverhead of 5 byte:
+overhead of 20 byte, a cellsize of 100 byte and a per celloverhead of 5 bytes.
 .RE
 
+.PP
+It is possible to selectively apply impairment using traffic classification.
+.EX
+# tc qdisc add dev eth0 root handle 1: prio
+# tc qdisc add dev eth0 parent 1:3 handle 30: \
+   tbf rate 20kbit buffer 1600 limit  3000
+# tc qdisc add dev eth0 parent 30:1 handle 31: \
+   netem delay 200ms 10ms distribution normal
+# tc filter add dev eth0 protocol ip parent 1:0 prio 3 u32 \
+   match ip dst 65.172.181.4/32 flowid 1:3
+.EE
+.RS 4
+This eample uses a priority queueing discipline;
+a TBF is added to do rate control; and a simple netem delay.
+A filter classifies all packets going to 65.172.181.4 as being priority 3.
+.PP
 .SH SOURCES
 .IP " 1. " 4
 Hemminger S. , "Network Emulation with NetEm", Open Source Development Lab,
 April 2005
-(http://devresources.linux-foundation.org/shemminger/netem/LCA2005_paper.pdf)
+.UR http://devresources.linux-foundation.org/shemminger/netem/LCA2005_paper.pdf
+.UE
 
 .IP " 2. " 4
-Netem page from Linux foundation, (https://wiki.linuxfoundation.org/networking/netem)
-
-.IP " 3. " 4
 Salsano S., Ludovici F., Ordine A., "Definition of a general and intuitive loss
 model for packet networks and its implementation in the Netem module in the
-Linux kernel", available at http://netgroup.uniroma2.it/NetemCLG
+Linux kernel", available at
+.UR http://netgroup.uniroma2.it/NetemCLG
+.UE
 
 .SH SEE ALSO
 .BR tc (8),
-.BR tc-tbf (8)
 
 .SH AUTHOR
-Netem was written by Stephen Hemminger at Linux foundation and is based on NISTnet.
-This manpage was created by Fabio Ludovici <fabio.ludovici at yahoo dot it> and
-Hagen Paul Pfeifer <hagen@jauu.net>
+Netem was written by Stephen Hemminger at Linux foundation and was
+inspired by NISTnet.
+
+Original manpage was created by Fabio Ludovici
+<fabio.ludovici at yahoo dot it> and Hagen Paul Pfeifer
+<hagen@jauu.net>
-- 
2.39.2

