Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608894D2415
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350635AbiCHWQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350595AbiCHWQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:16:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6346F54BE9
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 14:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646777705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ELpwnjudnka3fEDvbHfxHTpR5nqbjypRAXzu0I8fztU=;
        b=jDXve67EeHF3hhZDg9WMiH9GG0vZW7kgtSFaRtYym2hRFBi/6jmSas4F7kwm/42q2l5Qoq
        DuJNpa6isrgnvzQRqSRbBc6EsC0nl2phIKHg/3NmJLk1/2qeE6L19KwUTA35xFimNRW1ZZ
        ViTPkF7EXvzPzdjIzHmWFXPoayu2r8w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-CRkxCqbtO1yxTmjdSzWHig-1; Tue, 08 Mar 2022 17:15:04 -0500
X-MC-Unique: CRkxCqbtO1yxTmjdSzWHig-1
Received: by mail-wm1-f70.google.com with SMTP id 20-20020a05600c231400b00389886f6b23so301001wmo.6
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 14:15:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ELpwnjudnka3fEDvbHfxHTpR5nqbjypRAXzu0I8fztU=;
        b=Tc5iU9iDsP8NOX+oNySiymBKsHbZGNzKmlrBfYSO62OcD0argJtWxubvUry6ycv9YC
         G+TF3jv1Djwmn+iuz+LAzrkdd4DXhCD/NPBlEG/VXZAGIDKa8qGKGgkAGA1QrO1CuxZY
         LbIsdv9vQ1tMicq6oVnzHUnerBUMSomMEwyCNd48lUc4P65MOpt1pXVGK5KOCRQisPIj
         111YtTJfktKVOmZtVE2Hqr0EIYniSuHmQsiRA3IusN4dD5TPJPg1gEPuq6km49RW3GY7
         PzIoDTNSWmrUlOu/tvFYWxqLJyAKp6VwG/e2/O7Mk1oJXodJFRhIC3pJJdmlagcNPuc9
         Vrtw==
X-Gm-Message-State: AOAM5318R1onB2ZyOyhbv+HjmD/sRUxfR8uHFBcCxxwm2rJ2SzXLLQkk
        iLgic/4MJJ8L7RBiUjXlOxGjk6W+/3LD7MfD/BK7RZNxUzoRzy9LtzHzo3RhukXodO8iS4m4SV9
        DVuCcr0/wxQyFNdW0
X-Received: by 2002:a05:6000:1683:b0:1f1:eb7c:be70 with SMTP id y3-20020a056000168300b001f1eb7cbe70mr10378269wrd.129.1646777702896;
        Tue, 08 Mar 2022 14:15:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHMtCrmeazeUHh4F62qhxxUsIHBP4mefLMF4CUNEhC+M/2Dzt2H+6jL7QMEFw7arPxOI+6jw==
X-Received: by 2002:a05:6000:1683:b0:1f1:eb7c:be70 with SMTP id y3-20020a056000168300b001f1eb7cbe70mr10378255wrd.129.1646777702676;
        Tue, 08 Mar 2022 14:15:02 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c22cb00b00382a960b17csm3242256wmg.7.2022.03.08.14.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 14:15:02 -0800 (PST)
Date:   Tue, 8 Mar 2022 23:15:00 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net 1/2] selftests: pmtu.sh: Kill tcpdump processes launched
 by subshell.
Message-ID: <42a8a8194988cd3f37f437b11686a5e468efb0b2.1646776561.git.gnault@redhat.com>
References: <cover.1646776561.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1646776561.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cleanup() function takes care of killing processes launched by the
test functions. It relies on variables like ${tcpdump_pids} to get the
relevant PIDs. But tests are run in their own subshell, so updated
*_pids values are invisible to other shells. Therefore cleanup() never
sees any process to kill:

$ ./tools/testing/selftests/net/pmtu.sh -t pmtu_ipv4_exception
TEST: ipv4: PMTU exceptions                                         [ OK ]
TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]

$ pgrep -af tcpdump
6084 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
6085 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
6086 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
6087 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
6088 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
6089 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
6090 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
6091 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap
6228 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
6229 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
6230 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
6231 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
6232 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
6233 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
6234 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
6235 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap

Fix this by running cleanup() in the context of the test subshell.
Now that each test cleans the environment after completion, there's no
need for calling cleanup() again when the next test starts. So let's
drop it from the setup() function. This is okay because cleanup() is
also called when pmtu.sh starts, so even the first test starts in a
clean environment.

Also, use tcpdump's immediate mode. Otherwise it might not have time to
process buffered packets, resulting in missing packets or even empty
pcap files for short tests.

Note: PAUSE_ON_FAIL is still evaluated before cleanup(), so one can
still inspect the test environment upon failure when using -p.

Fixes: a92a0a7b8e7c ("selftests: pmtu: Simplify cleanup and namespace names")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 543ad7513a8e..2e8972573d91 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -865,7 +865,6 @@ setup_ovs_bridge() {
 setup() {
 	[ "$(id -u)" -ne 0 ] && echo "  need to run as root" && return $ksft_skip
 
-	cleanup
 	for arg do
 		eval setup_${arg} || { echo "  ${arg} not supported"; return 1; }
 	done
@@ -876,7 +875,7 @@ trace() {
 
 	for arg do
 		[ "${ns_cmd}" = "" ] && ns_cmd="${arg}" && continue
-		${ns_cmd} tcpdump -s 0 -i "${arg}" -w "${name}_${arg}.pcap" 2> /dev/null &
+		${ns_cmd} tcpdump --immediate-mode -s 0 -i "${arg}" -w "${name}_${arg}.pcap" 2> /dev/null &
 		tcpdump_pids="${tcpdump_pids} $!"
 		ns_cmd=
 	done
@@ -1836,6 +1835,10 @@ run_test() {
 
 	unset IFS
 
+	# Since cleanup() relies on variables modified by this subshell, it
+	# has to run in this context.
+	trap cleanup EXIT
+
 	if [ "$VERBOSE" = "1" ]; then
 		printf "\n##########################################################################\n\n"
 	fi
-- 
2.21.3

