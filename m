Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC83FE43E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhIAUsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhIAUsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:48:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BB8C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 13:47:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so621169pjx.5
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SCHnJfUNurDt0jhBUdRhrGAXCjDumm2atE4LQxnOY1I=;
        b=hdg6pT0eC8J6wQxw1cuE+MCnMOm2HY1ZbrbY0vtMfR2g9osNvPrqrWzaDgoUX8M37R
         Ye/7pE9XMxAd/kXBOxvyUqRe3kQANrD24b0WI/h6O1UjmNIVr6v/iy56tozc/5+M84/m
         40zgGq4FPb7HseHK2KVALnAA8yNnHMwrbZcgvNBco8pbZ0nLzgK7DPNXvswIegw2fOgx
         pqn6xuwZe3ZUvNTYkrj7BBYmCk+H71mISVDwJrbED6yGNXruOXpINAheRMje7WO2Sexe
         Tfr/U+oQD2GdcvrBqKqxMNn/mlN62hiJSSBzv3bVOMabKVbT5wNpHq72HmDayX/sLG/s
         M1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCHnJfUNurDt0jhBUdRhrGAXCjDumm2atE4LQxnOY1I=;
        b=ORvnj3zxGmplKFc/fYXxAtrznRKwLHQ053PRa+FZsFQT2mUROVfO+9hTX5b513n+oU
         26ElFLYuBL6Y2cbl0ZlMpUCAkyJvr+1VPrb057j08TDQLogAwbXDdOexAzQ8R9rNh9m3
         QJzGwEe2DK6Z5zgtBzKsnhPhnPbL7KlC/UrfcxYnUo8C1kl2EvTuyx7simQgCr3HXz5k
         t0jRLt2oyR1k/c+aqybqB0ucvc+yLKHF5ceLsHZQXDYMzxEqcvbQHGkFUbAlWuFMftuQ
         kfyZjVa0Z5KS/9KtdOhuL1PfdzC19QO/lzrXZW7iWP63sP/H1rp1AhbDlJ3NLpAzUiKF
         awDw==
X-Gm-Message-State: AOAM533ihbawj8B7sLmxUcTYn6Kh20fi8xQrzDOEmndbee6rjg0vrJVE
        W72QeQrJdYhFRKc89RtWFrXX8Rw5sD/Lrg==
X-Google-Smtp-Source: ABdhPJxj5eISC6B7Ty9DODIYtwh244k5X8epxVd1q3Mo4XP7p6j2esM9nGYyBfhRoPAvBXcfUl2+nw==
X-Received: by 2002:a17:90a:448f:: with SMTP id t15mr1212023pjg.21.1630529225935;
        Wed, 01 Sep 2021 13:47:05 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g26sm565073pgb.45.2021.09.01.13.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:47:05 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 2/4] ip: remove ifcfg script
Date:   Wed,  1 Sep 2021 13:46:59 -0700
Message-Id: <20210901204701.19646-3-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901204701.19646-1-sthemmin@microsoft.com>
References: <20210901204701.19646-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

This script was from olden days of ifcfg.
I don't see any distribution using it and it is time to put
it out to pasture.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/Makefile      |   2 +-
 ip/ifcfg         | 150 -----------------------------------------------
 man/man8/ifcfg.8 |  48 ---------------
 3 files changed, 1 insertion(+), 199 deletions(-)
 delete mode 100755 ip/ifcfg
 delete mode 100644 man/man8/ifcfg.8

diff --git a/ip/Makefile b/ip/Makefile
index a3b4249e7e06..e27dfa097877 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -18,7 +18,7 @@ RTMONOBJ=rtmon.o
 include ../config.mk
 
 ALLOBJ=$(IPOBJ) $(RTMONOBJ)
-SCRIPTS=ifcfg routel routef
+SCRIPTS=routel routef
 TARGETS=ip rtmon
 
 all: $(TARGETS) $(SCRIPTS)
diff --git a/ip/ifcfg b/ip/ifcfg
deleted file mode 100755
index 5b34decd4480..000000000000
--- a/ip/ifcfg
+++ /dev/null
@@ -1,150 +0,0 @@
-#! /bin/sh
-# SPDX-License-Identifier: GPL-2.0
-
-CheckForwarding () {
-  local sbase fwd
-  sbase=/proc/sys/net/ipv4/conf
-  fwd=0
-  if [ -d $sbase ]; then
-    for dir in $sbase/*/forwarding; do
-      fwd=$(( fwd + $(cat "$dir") ))
-    done
-  else
-    fwd=2
-  fi
-  return $fwd
-}
-
-RestartRDISC () {
-  killall -HUP rdisc || rdisc -fs
-}
-
-ABCMaskLen () {
-  local class;
-
-  class=${1%%.*}
-  if [ "$1" = "" -o $class -eq 0 -o $class -ge 224 ]; then return 0
-  elif [ $class -ge 224 ]; then return 0
-  elif [ $class -ge 192 ]; then return 24
-  elif [ $class -ge 128 ]; then return 16
-  else return 8; fi
-}
-
-label="label $1"
-ldev="$1"
-dev=${1%:*}
-if [ "$dev" = "" -o "$1" = "help" ]; then
-  echo "Usage: ifcfg DEV [[add|del [ADDR[/LEN]] [PEER] | stop]" 1>&2
-  echo "       add - add new address" 1>&2
-  echo "       del - delete address" 1>&2
-  echo "       stop - completely disable IP" 1>&2
-  exit 1
-fi
-shift
-
-CheckForwarding
-fwd=$?
-if [ $fwd -ne 0 ]; then
-  echo "Forwarding is ON or its state is unknown ($fwd). OK, No RDISC." 1>&2
-fi
-
-
-deleting=0
-case "$1" in
-add) shift ;;
-stop)
-  if [ "$ldev" != "$dev" ]; then
-    echo "Cannot stop alias $ldev" 1>&2
-    exit 1;
-  fi
-  ip -4 addr flush dev $dev $label || exit 1
-  if [ $fwd -eq 0 ]; then RestartRDISC; fi
-  exit 0 ;;
-del*)
-  deleting=1; shift ;;
-*)
-esac
-
-ipaddr=
-pfxlen=
-if [ "$1" != "" ]; then
-  ipaddr=${1%/*}
-  if [ "$1" != "$ipaddr" ]; then
-    pfxlen=${1#*/}
-  fi
-  if [ "$ipaddr" = "" ]; then
-    echo "$1 is bad IP address." 1>&2
-    exit 1
-  fi
-fi
-shift
-
-peer=$1
-if [ "$peer" != "" ]; then
-  if [ "$pfxlen" != "" -a "$pfxlen" != "32" ]; then
-    echo "Peer address with non-trivial netmask." 1>&2
-    exit 1
-  fi
-  pfx="$ipaddr peer $peer"
-else
-  if [ "$ipaddr" = "" ]; then
-    echo "Missing IP address argument." 1>&2
-    exit 1
-  fi
-  if [ "$pfxlen" = "" ]; then
-    ABCMaskLen $ipaddr
-    pfxlen=$?
-  fi
-  pfx="$ipaddr/$pfxlen"
-fi
-
-if [ "$ldev" = "$dev" -a "$ipaddr" != "" ]; then
-  label=
-fi
-
-if [ $deleting -ne 0 ]; then
-  ip addr del $pfx dev $dev $label || exit 1
-  if [ $fwd -eq 0 ]; then RestartRDISC; fi
-  exit 0
-fi
-
-
-if ! ip link set up dev $dev ; then
-  echo "Error: cannot enable interface $dev." 1>&2
-  exit 1
-fi
-if [ "$ipaddr" = "" ]; then exit 0; fi
-
-if ! arping -q -c 2 -w 3 -D -I $dev $ipaddr ; then
-  echo "Error: some host already uses address $ipaddr on $dev." 1>&2
-  exit 1
-fi
-
-if ! ip address add $pfx brd + dev $dev $label; then
-  echo "Error: failed to add $pfx on $dev." 1>&2
-  exit 1
-fi
-
-arping -q -A -c 1 -I $dev $ipaddr
-noarp=$?
-( sleep 2 ;
-  arping -q -U -c 1 -I $dev $ipaddr ) >/dev/null 2>&1 </dev/null &
-
-ip route add unreachable 224.0.0.0/24 >/dev/null 2>&1
-ip route add unreachable 255.255.255.255 >/dev/null 2>&1
-if [ "`ip link ls $dev | grep -c MULTICAST`" -ge 1 ]; then
-  ip route add 224.0.0.0/4 dev $dev scope global >/dev/null 2>&1
-fi
-
-if [ $fwd -eq 0 ]; then
-  if [ $noarp -eq 0 ]; then
-    ip ro append default dev $dev metric 30000 scope global
-  elif [ "$peer" != "" ]; then
-    if ping -q -c 2 -w 4 $peer ; then
-      ip ro append default via $peer dev $dev metric 30001
-    fi
-  fi
-  RestartRDISC
-fi
-
-exit 0
diff --git a/man/man8/ifcfg.8 b/man/man8/ifcfg.8
deleted file mode 100644
index 1a3786c1b0d9..000000000000
--- a/man/man8/ifcfg.8
+++ /dev/null
@@ -1,48 +0,0 @@
-.TH IFCFG 8 "September 24 2009" "iproute2" "Linux"
-.SH NAME
-ifcfg \- simplistic script which replaces ifconfig IP management
-.SH SYNOPSIS
-.ad l
-.in +8
-.ti -8
-.B ifcfg
-.RI "[ " DEVICE " ] [ " command " ] " ADDRESS " [ " PEER " ] "
-.sp
-
-.SH DESCRIPTION
-This manual page documents briefly the
-.B ifcfg
-command.
-.PP
-This is a simplistic script replacing one option of
-.B ifconfig
-, namely, IP address management. It not only adds
-addresses, but also carries out Duplicate Address Detection RFC-DHCP,
-sends unsolicited ARP to update the caches of other hosts sharing
-the interface, adds some control routes and restarts Router Discovery
-when it is necessary.
-
-.SH IFCONFIG - COMMAND SYNTAX
-
-.SS
-.TP
-.B DEVICE
-- it may have alias, suffix, separated by colon.
-
-.TP
-.B command
-- add, delete or stop.
-
-.TP
-.B ADDRESS
-- optionally followed by prefix length.
-
-.TP
-.B peer
-- optional peer address for pointpoint interfaces.
-
-.SH NOTES
-This script is not suitable for use with IPv6.
-
-.SH SEE ALSO
-.RB "IP Command reference " ip-cref.ps
-- 
2.30.2

