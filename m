Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B93021A8CA
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgGIURx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIURw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:17:52 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB27C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 13:17:52 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n2so2841827edr.5
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 13:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UL3rtnxDILGZSwOugpEhMXR4hXN3YzcbjPZ+baYBkj0=;
        b=mCxY//Dnq1ABkpCjbcMJ/Jw+CLR3ZYpbT2il0wr6QaaWRXKfhBrZU6uxxuEuQBuah1
         glA02DK351TousIRxmtot5F1ZwecIT8MFy4/2Anzy8F8ymXfCUlCCeswU7wakIigb6OS
         YDFOi4r29WPrAxI/svU+5I/W39LEoQIc13+xeiRPMiD2R9ItzQpU2oC7Q90/+TxL0MfR
         MVmAt6rOIHj+6ThjQEbJSBK+TC1e0RSCDn1J7b1y+FwcqcS+2G81vN14sHavtC3G1036
         oEhRq/mq/RQZiqpwJvd+AtMgJAp1dzCFRu78d7jRrAN6pO8iRWX8tjsszrnIbV05BcOR
         H/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UL3rtnxDILGZSwOugpEhMXR4hXN3YzcbjPZ+baYBkj0=;
        b=hnsLp1Hq7qKzUsLjKiIYzPupRRnFfz+81lR7fM79vsnvN7OgpYgR+oTinc0bSAat6M
         iRM7ecKlcIk/Kv5u9WjRJrotcXN0T8Cij+wB56r+dlwCOwUQovC7pDe5tZUEE/nXt5Wn
         DrRwxM1Lz7MAlAuK8TQtOr1DljJFbvyd744LlTqmqXlhpH08ZxwOg1p60akIjnRkRs7H
         +GfZXuCdNOeCzZ31BNUpA95282elrwe073GibOSXovTklqHcwcbFm3w2txrnJBm3oE8K
         CKUTrt5wnRgrf0WNZD4PBNqbKyiT6Bf19AANHm3+VpPhRRbkEM1GagHZZTUleziPVdbz
         LvJg==
X-Gm-Message-State: AOAM5302raBqNl1v75ojQuMWJg5ngkDaCaIcbmFuU/tm48rjdTey40CS
        312t/rDRfsNvxNE3RdeeGeINa4nh
X-Google-Smtp-Source: ABdhPJzFbbxJ+H5ZSFXjfBn4Btani17odJ/UAuLagOv+idDzXc3VCu0idC3awtF9yZZC+vIlLG0mKQ==
X-Received: by 2002:a05:6402:1655:: with SMTP id s21mr71544676edx.289.1594325870729;
        Thu, 09 Jul 2020 13:17:50 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id gu16sm2380467ejb.35.2020.07.09.13.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 13:17:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     richardcochran@gmail.com, sorganov@gmail.com, andrew@lunn.ch
Subject: [PATCH v2 net-next] docs: networking: timestamping: add section for stacked PHC devices
Date:   Thu,  9 Jul 2020 23:17:33 +0300
Message-Id: <20200709201733.71874-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The concept of timestamping DSA switches / Ethernet PHYs is becoming
more and more popular, however the Linux kernel timestamping code has
evolved quite organically and there's layers upon layers of new and old
code that need to work together for things to behave as expected.

Add this chapter to explain what the overall goals are.

Loosely based upon this email discussion plus some more info:
https://lkml.org/lkml/2020/7/6/481

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
---
Changes in v2:
Applied Richard's and Sergey's change suggestions.

 Documentation/networking/timestamping.rst | 165 ++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 1adead6a4527..03f7beade470 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -589,3 +589,168 @@ Time stamps for outgoing packets are to be generated as follows:
   this would occur at a later time in the processing pipeline than other
   software time stamping and therefore could lead to unexpected deltas
   between time stamps.
+
+3.2 Special considerations for stacked PTP Hardware Clocks
+----------------------------------------------------------
+
+There are situations when there may be more than one PHC (PTP Hardware Clock)
+in the data path of a packet. The kernel has no explicit mechanism to allow the
+user to select which PHC to use for timestamping Ethernet frames. Instead, the
+assumption is that the outermost PHC is always the most preferable, and that
+kernel drivers collaborate towards achieving that goal. Currently there are 3
+cases of stacked PHCs, detailed below:
+
+3.2.1 DSA (Distributed Switch Architecture) switches
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+These are Ethernet switches which have one of their ports connected to an
+(otherwise completely unaware) host Ethernet interface, and perform the role of
+a port multiplier with optional forwarding acceleration features.  Each DSA
+switch port is visible to the user as a standalone (virtual) network interface,
+and its network I/O is performed, under the hood, indirectly through the host
+interface (redirecting to the host port on TX, and intercepting frames on RX).
+
+When a DSA switch is attached to a host port, PTP synchronization has to
+suffer, since the switch's variable queuing delay introduces a path delay
+jitter between the host port and its PTP partner. For this reason, some DSA
+switches include a timestamping clock of their own, and have the ability to
+perform network timestamping on their own MAC, such that path delays only
+measure wire and PHY propagation latencies. Timestamping DSA switches are
+supported in Linux and expose the same ABI as any other network interface (save
+for the fact that the DSA interfaces are in fact virtual in terms of network
+I/O, they do have their own PHC).  It is typical, but not mandatory, for all
+interfaces of a DSA switch to share the same PHC.
+
+By design, PTP timestamping with a DSA switch does not need any special
+handling in the driver for the host port it is attached to.  However, when the
+host port also supports PTP timestamping, DSA will take care of intercepting
+the ``.ndo_do_ioctl`` calls towards the host port, and block attempts to enable
+hardware timestamping on it. This is because the SO_TIMESTAMPING API does not
+allow the delivery of multiple hardware timestamps for the same packet, so
+anybody else except for the DSA switch port must be prevented from doing so.
+
+In code, DSA provides for most of the infrastructure for timestamping already,
+in generic code: a BPF classifier (``ptp_classify_raw``) is used to identify
+PTP event messages (any other packets, including PTP general messages, are not
+timestamped), and provides two hooks to drivers:
+
+- ``.port_txtstamp()``: The driver is passed a clone of the timestampable skb
+  to be transmitted, before actually transmitting it. Typically, a switch will
+  have a PTP TX timestamp register (or sometimes a FIFO) where the timestamp
+  becomes available. There may be an IRQ that is raised upon this timestamp's
+  availability, or the driver might have to poll after invoking
+  ``dev_queue_xmit()`` towards the host interface. Either way, in the
+  ``.port_txtstamp()`` method, the driver only needs to save the clone for
+  later use (when the timestamp becomes available). Each skb is annotated with
+  a pointer to its clone, in ``DSA_SKB_CB(skb)->clone``, to ease the driver's
+  job of keeping track of which clone belongs to which skb.
+
+- ``.port_rxtstamp()``: The original (and only) timestampable skb is provided
+  to the driver, for it to annotate it with a timestamp, if that is immediately
+  available, or defer to later. On reception, timestamps might either be
+  available in-band (through metadata in the DSA header, or attached in other
+  ways to the packet), or out-of-band (through another RX timestamping FIFO).
+  Deferral on RX is typically necessary when retrieving the timestamp needs a
+  sleepable context. In that case, it is the responsibility of the DSA driver
+  to call ``netif_rx_ni()`` on the freshly timestamped skb.
+
+3.2.2 Ethernet PHYs
+^^^^^^^^^^^^^^^^^^^
+
+These are devices that typically fulfill a Layer 1 role in the network stack,
+hence they do not have a representation in terms of a network interface as DSA
+switches do. However, PHYs may be able to detect and timestamp PTP packets, for
+performance reasons: timestamps taken as close as possible to the wire have the
+potential to yield a more stable and precise synchronization.
+
+A PHY driver that supports PTP timestamping must create a ``struct
+mii_timestamper`` and add a pointer to it in ``phydev->mii_ts``. The presence
+of this pointer will be checked by the networking stack.
+
+Since PHYs do not have network interface representations, the timestamping and
+ethtool ioctl operations for them need to be mediated by their respective MAC
+driver.  Therefore, as opposed to DSA switches, modifications need to be done
+to each individual MAC driver for PHY timestamping support. This entails:
+
+- Checking, in ``.ndo_do_ioctl``, whether ``phy_has_hwtstamp(netdev->phydev)``
+  is true or not. If it is, then the MAC driver should not process this request
+  but instead pass it on to the PHY using ``phy_mii_ioctl()``.
+
+- On RX, special intervention may or may not be needed, depending on the
+  function used to deliver skb's up the network stack. In the case of plain
+  ``netif_rx()`` and similar, MAC drivers must check whether
+  ``skb_defer_rx_timestamp(skb)`` is necessary or not - and if it is, don't
+  call ``netif_rx()`` at all.  If ``CONFIG_NETWORK_PHY_TIMESTAMPING`` is
+  enabled, and ``skb->dev->phydev->mii_ts`` exists, its ``.rxtstamp()`` hook
+  will be called now, to determine, using logic very similar to DSA, whether
+  deferral for RX timestamping is necessary.  Again like DSA, it becomes the
+  responsibility of the PHY driver to send the packet up the stack when the
+  timestamp is available.
+
+  For other skb receive functions, such as ``napi_gro_receive`` and
+  ``netif_receive_skb``, the stack automatically checks whether
+  ``skb_defer_rx_timestamp()`` is necessary, so this check is not needed inside
+  the driver.
+
+- On TX, again, special intervention might or might not be needed.  The
+  function that calls the ``mii_ts->txtstamp()`` hook is named
+  ``skb_clone_tx_timestamp()``. This function can either be called directly
+  (case in which explicit MAC driver support is indeed needed), but the
+  function also piggybacks from the ``skb_tx_timestamp()`` call, which many MAC
+  drivers already perform for software timestamping purposes. Therefore, if a
+  MAC supports software timestamping, it does not need to do anything further
+  at this stage.
+
+3.2.3 MII bus snooping devices
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+These perform the same role as timestamping Ethernet PHYs, save for the fact
+that they are discrete devices and can therefore be used in conjunction with
+any PHY even if it doesn't support timestamping. In Linux, they are
+discoverable and attachable to a ``struct phy_device`` through Device Tree, and
+for the rest, they use the same mii_ts infrastructure as those. See
+Documentation/devicetree/bindings/ptp/timestamper.txt for more details.
+
+3.2.4 Other caveats for MAC drivers
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Stacked PHCs, especially DSA (but not only) - since that doesn't require any
+modification to MAC drivers, so it is more difficult to ensure correctness of
+all possible code paths - is that they uncover bugs which were impossible to
+trigger before the existence of stacked PTP clocks.  One example has to do with
+this line of code, already presented earlier::
+
+      skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+Any TX timestamping logic, be it a plain MAC driver, a DSA switch driver, a PHY
+driver or a MII bus snooping device driver, should set this flag.
+But a MAC driver that is unaware of PHC stacking might get tripped up by
+somebody other than itself setting this flag, and deliver a duplicate
+timestamp.
+For example, a typical driver design for TX timestamping might be to split the
+transmission part into 2 portions:
+
+1. "TX": checks whether PTP timestamping has been previously enabled through
+   the ``.ndo_do_ioctl`` ("``priv->hwtstamp_tx_enabled == true``") and the
+   current skb requires a TX timestamp ("``skb_shinfo(skb)->tx_flags &
+   SKBTX_HW_TSTAMP``"). If this is true, it sets the
+   "``skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS``" flag. Note: as
+   described above, in the case of a stacked PHC system, this condition should
+   never trigger, as this MAC is certainly not the outermost PHC. But this is
+   not where the typical issue is.  Transmission proceeds with this packet.
+
+2. "TX confirmation": Transmission has finished. The driver checks whether it
+   is necessary to collect any TX timestamp for it. Here is where the typical
+   issues are: the MAC driver takes a shortcut and only checks whether
+   "``skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS``" was set. With a stacked
+   PHC system, this is incorrect because this MAC driver is not the only entity
+   in the TX data path who could have enabled SKBTX_IN_PROGRESS in the first
+   place.
+
+The correct solution for this problem is for MAC drivers to have a compound
+check in their "TX confirmation" portion, not only for
+"``skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS``", but also for
+"``priv->hwtstamp_tx_enabled == true``". Because the rest of the system ensures
+that PTP timestamping is not enabled for anything other than the outermost PHC,
+this enhanced check will avoid delivering a duplicated TX timestamp to user
+space.
-- 
2.25.1

