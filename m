Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A2A4D2412
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350642AbiCHWQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350595AbiCHWQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:16:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E203546B3
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 14:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646777708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6nIHOJmJA+rkjvbg8O1o1KH0J2z0YqG4K70ZRzEJTXc=;
        b=aKHQeQcGLsSV7wZF+hUASjuVUffkP39f7RXVIAMut7HlrL4mk77j1rV3zOFzCPkVZrLDTS
        Vd+M2r16Vjheh7shMBFHgoA2hsQ00+5nWN73Nim9QoLC60Z8X0+wFJejv6cHfINh8NaqAB
        XivCuI0ousLxXzXraQ8mRcGs3EtqYx4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-_Cimn6tkOsWYSrDsRvgMOw-1; Tue, 08 Mar 2022 17:15:07 -0500
X-MC-Unique: _Cimn6tkOsWYSrDsRvgMOw-1
Received: by mail-wm1-f69.google.com with SMTP id l13-20020a7bcf0d000000b0038982c6bf8fso298386wmg.7
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 14:15:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6nIHOJmJA+rkjvbg8O1o1KH0J2z0YqG4K70ZRzEJTXc=;
        b=74zb7GxBEONcCK/YCcObnmenxutJnOsi/U/OCQ1R87wCJyrRPEyDvaeBg7KjzWZbs9
         pGhUtzEF83RnZVAUUH+ORowMGC4dSD3NePyBlUNzNVISmPzkKgaF4LHj3IUQsI1q1UKH
         2/i0fBafJW+5y4CGS4F981ubcBhxQJSwbZQPJ4daCkCdffCoCMUw9sikCKmMzDCx+8BD
         bFbq4ZOBJv7OqVqBcMD0uQjH/zx3D1IctgiK6zBho9q62XJex2WqzGZYN2IPxjheimCK
         h1LOmy6J+GO80vIn6s5l6Q4GrrCd2bepJ8wWXylwLruSksi7CAr/zKGAXff4l1rRkdm6
         95iQ==
X-Gm-Message-State: AOAM5308bd4OhoQtY/l7bARploP/p4sGmAv663bcq3nBxsxZeTLKzMso
        Jp0T/lXVYpMBTgDVMW+5mY6EaEfQgL+A6kpbhuAnERtBOKxLw/CC/PmS0AxhkR5Jxr1yT3ep+U2
        lcxM+DIvSDaqb7Gd8
X-Received: by 2002:a5d:61ca:0:b0:1f0:22ef:bb9f with SMTP id q10-20020a5d61ca000000b001f022efbb9fmr14177715wrv.56.1646777706060;
        Tue, 08 Mar 2022 14:15:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUAdR2fAB8NkHsGlS31dTIoi/XqT+nhHeo0/XxxKYEYFt+c1zOjvRcGUy9zE1VzDBSBimJzA==
X-Received: by 2002:a5d:61ca:0:b0:1f0:22ef:bb9f with SMTP id q10-20020a5d61ca000000b001f022efbb9fmr14177703wrv.56.1646777705864;
        Tue, 08 Mar 2022 14:15:05 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id a17-20020a5d5091000000b001edb61b2687sm126364wrt.63.2022.03.08.14.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 14:15:05 -0800 (PST)
Date:   Tue, 8 Mar 2022 23:15:03 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net 2/2] selftests: pmtu.sh: Kill nettest processes launched
 in subshell.
Message-ID: <55cb9255471e73eaa481779329d9d47c430dbd0a.1646776561.git.gnault@redhat.com>
References: <cover.1646776561.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1646776561.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using "run_cmd <command> &", then "$!" refers to the PID of the
subshell used to run <command>, not the command itself. Therefore
nettest_pids actually doesn't contain the list of the nettest commands
running in the background. So cleanup() can't kill them and the nettest
processes run until completion (fortunately they have a 5s timeout).

Fix this by defining a new command for running processes in the
background, for which "$!" really refers to the PID of the command run.

Also, double quote variables on the modified lines, to avoid shellcheck
warnings.

Fixes: ece1278a9b81 ("selftests: net: add ESP-in-UDP PMTU test")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 2e8972573d91..694732e4b344 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -374,6 +374,16 @@ run_cmd() {
 	return $rc
 }
 
+run_cmd_bg() {
+	cmd="$*"
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "    COMMAND: %s &\n" "${cmd}"
+	fi
+
+	$cmd 2>&1 &
+}
+
 # Find the auto-generated name for this namespace
 nsname() {
 	eval echo \$NS_$1
@@ -670,10 +680,10 @@ setup_nettest_xfrm() {
 	[ ${1} -eq 6 ] && proto="-6" || proto=""
 	port=${2}
 
-	run_cmd ${ns_a} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	run_cmd_bg "${ns_a}" nettest "${proto}" -q -D -s -x -p "${port}" -t 5
 	nettest_pids="${nettest_pids} $!"
 
-	run_cmd ${ns_b} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	run_cmd_bg "${ns_b}" nettest "${proto}" -q -D -s -x -p "${port}" -t 5
 	nettest_pids="${nettest_pids} $!"
 }
 
-- 
2.21.3

