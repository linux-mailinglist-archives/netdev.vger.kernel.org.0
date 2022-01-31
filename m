Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7154A4ACF
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379770AbiAaPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:42:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242802AbiAaPmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643643729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hkxchTylyBIw36KxB2bjQj4NjTJ8gEN7NWBvja/ptEI=;
        b=OtgrpUGvsyy2TZRhrjCjDfrMqRL3pJE9NqjoBlqkwIosAY+5OPsm3AOUqkcZ/2cCD+FCm6
        0g9EsnFuSn7jds4Sj4r5Zf1w0qmIZ7Dk86CukO6jaWzuewCsZ/jSyVtVr06ZEukX25IMf3
        hngVqQaopH5dvbaVKT0lfHzD+lKCnM0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-WqJ9Tvl9NPqiwKkJkly9lQ-1; Mon, 31 Jan 2022 10:42:07 -0500
X-MC-Unique: WqJ9Tvl9NPqiwKkJkly9lQ-1
Received: by mail-wr1-f72.google.com with SMTP id m17-20020adfa3d1000000b001dd66c10c0cso4968397wrb.19
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hkxchTylyBIw36KxB2bjQj4NjTJ8gEN7NWBvja/ptEI=;
        b=a6J+TlXd15zDuCk748D4i+wNAXiAWnnj4T5e+mzBrhR2/FP9Aho3f3wlRaqVAuQkd+
         HxrHkwFIeKoH8ihUXqcOh2kO33Dz4mxVORxVexbWaudMnNUeHfxepo0z45aMnY2NtEYc
         Kw/V1K6BZdMpbryV1xH1aN5AGNJ1XoBtM02rNaZiHbR8HRK+Bo6TBufrYNthN2xNdgaF
         Nxx2W+YXGP3VjuSwbJxmvhuTk/QMI2FxwpnYpFXyK2/cRspCtZ8FSFkJ335B6T1y1lz1
         OyWel6vZaVY5Yn1U9nzwPaDkE7sDNwvRn4+DfVmav/u6LaMT0Ue6mK+VVMY7ETVQvDzk
         qE0A==
X-Gm-Message-State: AOAM531eh563Knsu5JByBlMuC1yBrkD6AHwEbNwsAZswRAHjBYHMFmW/
        ypghURCqFAnZW4g/EXbq75H9Ty+9XGyH+c2yoUwAwXQCI4oIr1wjqZdp4UmMLom5Z688vSbRtaT
        X6KbgPcvatycY0meb
X-Received: by 2002:adf:9dc6:: with SMTP id q6mr17692040wre.679.1643643726601;
        Mon, 31 Jan 2022 07:42:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1DwCI3Fw2wTecxht4WC3IQ8a5vpBieNVHkhHesxDAYIX779C8wLRFnFWyOh+KqnTZ7JI11A==
X-Received: by 2002:adf:9dc6:: with SMTP id q6mr17692030wre.679.1643643726417;
        Mon, 31 Jan 2022 07:42:06 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id i9sm14449262wry.32.2022.01.31.07.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:42:06 -0800 (PST)
Date:   Mon, 31 Jan 2022 16:42:04 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net-next 2/4] selftests: fib rule: Drop erroneous TABLE
 variable
Message-ID: <f9dd17fc0be13b359361056dc0337b33d187459b.1643643083.git.gnault@redhat.com>
References: <cover.1643643083.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1643643083.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fib_rule6_del_by_pref() and fib_rule4_del_by_pref() functions use
an uninitialised $TABLE variable. They should use $RTABLE instead.
This doesn't alter the result of the test, as it just makes the grep
command less specific (but since the script always uses the same table
number, that doesn't really matter).

Let's fix it anyway and, while there, specify the filtering parameters
directly in 'ip -X rule show' to avoid the extra grep command entirely.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index f04f337dd7c6..012f9385d68c 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -96,7 +96,7 @@ fib_rule6_del()
 
 fib_rule6_del_by_pref()
 {
-	pref=$($IP -6 rule show | grep "$1 lookup $TABLE" | cut -d ":" -f 1)
+	pref=$($IP -6 rule show $1 table $RTABLE | cut -d ":" -f 1)
 	$IP -6 rule del pref $pref
 }
 
@@ -168,7 +168,7 @@ fib_rule4_del()
 
 fib_rule4_del_by_pref()
 {
-	pref=$($IP rule show | grep "$1 lookup $TABLE" | cut -d ":" -f 1)
+	pref=$($IP rule show $1 table $RTABLE | cut -d ":" -f 1)
 	$IP rule del pref $pref
 }
 
-- 
2.21.3

