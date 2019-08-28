Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F261AA0BBC
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH1UnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:43:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44025 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfH1UnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:43:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so515622pfn.10
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UOQMKR/KYWZsP9KXA50kuAkXuQwtRtjSuqSfJHgaV8g=;
        b=IArOh3h/rFAI//QPZrcfTxJA6a8ji9ju/0Yr8MUsjMt5c58XIEH7X3k0bqCS5cYN4+
         hhyQREF5V69F49XILBzTLnzkK/V9gkOOIUXW6qEe3ayjD0TBgSLMBIN8c51j9gGLg3zv
         t9fogYpWH75qsyfZrglMwGAQZK7wtNW+SNQEayH9nMcU2D+kBrEI4nbmh49d9BjTQ2Kw
         azNGJ0fDAAr6Mq4DtLUP2IJ0MPc5vtU3xqcH07r3zCrFehD5KWunpZUJvtNZJdMD1xk9
         019nX4tgITbLfUEV0IKCfzXZl/AevYhMXVRAT2l6WAfzk1J0ixhufyNnXwE6lalfDRWs
         jkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UOQMKR/KYWZsP9KXA50kuAkXuQwtRtjSuqSfJHgaV8g=;
        b=BPDOhV7GaOFlm5MVK9RU/aIU1mqHFxZHK7EDAbuc6rvKPBpzdGaqpSNSPluAhPAXUF
         kEXOCYWB78aliize1JuPtXJz3+Lnunm3mPNkF1jlJxX0CdR7cC4dWNMO0bDfyxlCjEMy
         LE+oUMJwAQ0hKqQTt91u5We7y0ULAAVRcj+3eXSx8B6vi3TNGjIPneCK0cqnFerWQajc
         UB9sZn0ocKV90SNjJHTA3F0CTLeOFWdsanOb3CCQsSxZksXXj0M0m0aAWEamCirUbglp
         cMLQAYUZU6jELkF5zLvGtgqEmZDv0lhFeVQpr1M+0F1dV8mDLLqqtNRswk45AWRS7mhD
         dxvg==
X-Gm-Message-State: APjAAAV6Qudo8aBYyKQLcD6zbdXJtr9CtNOudFuneeQViWWhW2Sem5UY
        ihE/yWC/9HqiBw67FycdHA==
X-Google-Smtp-Source: APXvYqwqkmiYnRqzyJP+i28Bzi7bTz1/cF5PukZxFy3sfryxHHIGOHOV8tkfU1jEZpuwqF0qh1hFHw==
X-Received: by 2002:a17:90b:8ca:: with SMTP id ds10mr5992702pjb.139.1567024990611;
        Wed, 28 Aug 2019 13:43:10 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id z14sm36320pjr.23.2019.08.28.13.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 13:43:10 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 2/3] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
Date:   Thu, 29 Aug 2019 05:42:42 +0900
Message-Id: <20190828204243.16666-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828204243.16666-1-danieltimlee@gmail.com>
References: <20190828204243.16666-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds CIDR parsing and IP validate helper function to parse
single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)

Helpers will be used in prior to set target address in samples/pktgen.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/pktgen/functions.sh | 134 ++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 4af4046d71be..eb1c52e25018 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -163,6 +163,140 @@ function get_node_cpus()
 	echo $node_cpu_list
 }
 
+# Extend shrunken IPv6 address.
+# fe80::42:bcff:fe84:e10a => fe80:0:0:0:42:bcff:fe84:e10a
+function extend_addr6()
+{
+    local addr=$1
+    local sep=:
+    local sep2=::
+    local sep_cnt=$(tr -cd $sep <<< $1 | wc -c)
+    local shrink
+
+    # separator count : should be between 2, 7.
+    if [[ $sep_cnt -lt 2 || $sep_cnt -gt 7 ]]; then
+        err 5 "Invalid IP6 address sep: $1"
+    fi
+
+    # if shrink '::' occurs multiple, it's malformed.
+    shrink=( $(egrep -o "$sep{2,}" <<< $addr) )
+    if [[ ${#shrink[@]} -ne 0 ]]; then
+        if [[ ${#shrink[@]} -gt 1 || ( ${shrink[0]} != $sep2 ) ]]; then
+            err 5 "Invalid IP$IP6 address shr: $1"
+        fi
+    fi
+
+    # add 0 at begin & end, and extend addr by adding :0
+    [[ ${addr:0:1} == $sep ]] && addr=0${addr}
+    [[ ${addr: -1} == $sep ]] && addr=${addr}0
+    echo "${addr/$sep2/$(printf ':0%.s' $(seq $[8-sep_cnt])):}"
+}
+
+
+# Given a single IP(v4/v6) address, whether it is valid.
+function validate_addr()
+{
+    # check function is called with (funcname)6
+    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
+    local len=$[ IP6 ? 8 : 4 ]
+    local max=$[ 2**(len*2)-1 ]
+    local addr
+    local sep
+
+    # set separator for each IP(v4/v6)
+    [[ $IP6 ]] && sep=: || sep=.
+    IFS=$sep read -a addr <<< $1
+
+    # array length
+    if [[ ${#addr[@]} != $len ]]; then
+        err 5 "Invalid IP$IP6 address: $1"
+    fi
+
+    # check each digit between 0, $max
+    for digit in "${addr[@]}"; do
+        [[ $IP6 ]] && digit=$[ 16#$digit ]
+        if [[ $digit -lt 0 || $digit -gt $max ]]; then
+            err 5 "Invalid IP$IP6 address: $1"
+        fi
+    done
+
+    return 0
+}
+
+function validate_addr6() { validate_addr $@ ; }
+
+# Given a single IP(v4/v6) or CIDR, return minimum and maximum IP addr.
+function parse_addr()
+{
+    # check function is called with (funcname)6
+    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
+    local bitlen=$[ IP6 ? 128 : 32 ]
+
+    local addr=$1
+    local net
+    local prefix
+    local min_ip
+    local max_ip
+
+    IFS='/' read net prefix <<< $addr
+    [[ $IP6 ]] && net=$(extend_addr6 $net)
+    validate_addr$IP6 $net
+
+    if [[ $prefix -gt $bitlen ]]; then
+        err 5 "Invalid prefix: $prefix"
+    elif [[ -z $prefix ]]; then
+        min_ip=$net
+        max_ip=$net
+    else
+        # defining array for converting Decimal 2 Binary
+        # 00000000 00000001 00000010 00000011 00000100 ...
+        local d2b='{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}'
+        [[ $IP6 ]] && d2b+=$d2b
+        eval local D2B=($d2b)
+
+        local shift=$[ bitlen-prefix ]
+        local ip_bit
+        local ip
+        local sep
+
+        # set separator for each IP(v4/v6)
+        [[ $IP6 ]] && sep=: || sep=.
+        IFS=$sep read -ra ip <<< $net
+
+        # build full size bit
+        for digit in "${ip[@]}"; do
+            [[ $IP6 ]] && digit=$[ 16#$digit ]
+            ip_bit+=${D2B[$digit]}
+        done
+
+        # fill 0 or 1 by $shift
+        base_bit=${ip_bit::$prefix}
+        min_bit="$base_bit$(printf '0%.s' $(seq $shift))"
+        max_bit="$base_bit$(printf '1%.s' $(seq $shift))"
+
+        bit2addr() {
+            local step=$[ IP6 ? 16 : 8 ]
+            local max=$[ bitlen-step ]
+            local result
+            local fmt
+            [[ $IP6 ]] && fmt='%X' || fmt='%d'
+
+            for i in $(seq 0 $step $max); do
+                result+=$(printf $fmt $[ 2#${1:$i:$step} ])
+                [[ $i != $max ]] && result+=$sep
+            done
+            echo $result
+        }
+
+        min_ip=$(bit2addr $min_bit)
+        max_ip=$(bit2addr $max_bit)
+    fi
+
+    echo $min_ip $max_ip
+}
+
+function parse_addr6() { parse_addr $@ ; }
+
 # Given a single or range of port(s), return minimum and maximum port number.
 function parse_ports()
 {
-- 
2.20.1

