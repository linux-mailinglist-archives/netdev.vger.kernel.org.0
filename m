Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7BAB03E4
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbfIKSsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:48:20 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46795 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730140AbfIKSsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:48:20 -0400
Received: by mail-pg1-f179.google.com with SMTP id m3so11939775pgv.13
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 11:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5uS7AldvfLJCxsGiq97UF7+oGzAGDIAEXSt2SqMBcXo=;
        b=nfOqQCh7B6eZA1sgWKXGnU5/zt5ibfTBUiYM3abEesHomiys6FhHWqDY4Ip3K1NPOZ
         Jq2qKKCEXTpYnqX/3X5nb6Ff3bM/fsYjRPGayZhqDjFOFn/2FNk8dHcfKN0kI1cuA70r
         MgoVLEKWLT22DF/y7tR9ujBhUTvkZhEaCYdsVPRrzNHu39KxIORMscPCDW/FSnc+krRy
         Otw2hGsE+zBhR4vnGoXQx0oY3nsdyHVDEYq16tBwZ/7PVQyJMu+H+lyRxVVQAZbNWXgC
         c4mG5itAy5Iq96/8e3+PJsCiIZcSLPE7MsjRxYO6OM2IpJuHAfayw2wLt0DLv9kRfQh1
         ODng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5uS7AldvfLJCxsGiq97UF7+oGzAGDIAEXSt2SqMBcXo=;
        b=bfMcuUFZ9M575YVbY6FIzlFrrAnIg3w9XNRRqZJWhudSFcNlkX6X8jsTZHYZYMfRzV
         405D0c87dY65uR4TxToJjB/J24/Ubric3ognGXiYxZEf0AXykSh9TF3w6dU+nMM98Dlh
         DzyantOeg6ksqtIU4aDsItDHYUs2xKZXOHqhefUlWiRgqKMhFlhT+IQ8s52Vs3TSYMsQ
         ZOUjAuH+RONaNonIDqHdfsUtlI+kEZHzuMHVEFRXc5qey74u+mBHXLaXuoBFOQWdk/24
         JsNbnr4AP6lhDyGBtoj3tuoWm1TliEVQ6WJCMhpu44Lf8eXVk2O14c5r7wHpydJ314qn
         volg==
X-Gm-Message-State: APjAAAVf1zAUj18Ml9+NZ1Nwq+yjQQGVKoawADVIO/H8C5g9EVBqfSTq
        aOoYU9kAlAwuShostLKoMA==
X-Google-Smtp-Source: APXvYqzvtJTfReuRxTp0j0VdyETcJh7+DGNsxBz8zyVobipoQyVYyfxlwuYBJZSVDdV9Z1vzdfPw4g==
X-Received: by 2002:a63:2006:: with SMTP id g6mr33668387pgg.287.1568227697297;
        Wed, 11 Sep 2019 11:48:17 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id n9sm2810282pjq.30.2019.09.11.11.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 11:48:16 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [v2 2/3] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
Date:   Thu, 12 Sep 2019 03:48:06 +0900
Message-Id: <20190911184807.21770-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190911184807.21770-1-danieltimlee@gmail.com>
References: <20190911184807.21770-1-danieltimlee@gmail.com>
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
 samples/pktgen/functions.sh | 122 ++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 4af4046d71be..8be5a6b6c097 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -163,6 +163,128 @@ function get_node_cpus()
 	echo $node_cpu_list
 }
 
+# Extend shrunken IPv6 address.
+# fe80::42:bcff:fe84:e10a => fe80:0:0:0:42:bcff:fe84:e10a
+function extend_addr6()
+{
+    local addr=$1
+    local sep=: sep2=::
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
+    local addr sep
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
+    local octet=$[ IP6 ? 16 : 8 ]
+
+    local addr=$1
+    local net prefix
+    local min_ip max_ip
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
+        local min_mask max_mask
+        local min max
+        local ip_bit
+        local ip sep
+
+        # set separator for each IP(v4/v6)
+        [[ $IP6 ]] && sep=: || sep=.
+        IFS=$sep read -ra ip <<< $net
+
+        min_mask="$(printf '1%.s' $(seq $prefix))$(printf '0%.s' $(seq $shift))"
+        max_mask="$(printf '0%.s' $(seq $prefix))$(printf '1%.s' $(seq $shift))"
+
+        # calculate min/max ip with &,| operator
+        for i in "${!ip[@]}"; do
+            digit=$[ IP6 ? 16#${ip[$i]} : ${ip[$i]} ]
+            ip_bit=${D2B[$digit]}
+
+            idx=$[ octet*i ]
+            min[$i]=$[ 2#$ip_bit & 2#${min_mask:$idx:$octet} ]
+            max[$i]=$[ 2#$ip_bit | 2#${max_mask:$idx:$octet} ]
+            [[ $IP6 ]] && { min[$i]=$(printf '%X' ${min[$i]});
+                            max[$i]=$(printf '%X' ${max[$i]}); }
+        done
+
+        min_ip=$(IFS=$sep; echo "${min[*]}")
+        max_ip=$(IFS=$sep; echo "${max[*]}")
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

