Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE866164D
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjAHPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjAHPq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:46:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C3B22A
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 07:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673192756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FtjyxBTyHgcMmUp4eECMrOwxInBVUuzyxbE0sO3oxjs=;
        b=CXDxjwpbULXVgSe90mOKLu5c39yEAboj4609uuwQ1HMswR9bhOjX+eYe58TR4hC/auZ6Bx
        I0uzJ7Q+TfE3NtRoyCzuatuq9OJQ5gtoPBuJ7N1DdbNfKW5bTgtxn1yqwYr75pF3WAgwnt
        PVsXPqssGnnCXQV8F9tzi7ktvoFlmTo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-473-tX69ycueP0qXyzL-xQ0iRQ-1; Sun, 08 Jan 2023 10:45:54 -0500
X-MC-Unique: tX69ycueP0qXyzL-xQ0iRQ-1
Received: by mail-qk1-f198.google.com with SMTP id bi3-20020a05620a318300b00702545f73d5so4805040qkb.8
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 07:45:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FtjyxBTyHgcMmUp4eECMrOwxInBVUuzyxbE0sO3oxjs=;
        b=Cju6biY3elGESDGe/LtTggzaXBD28FQuNEU2eQygcLpYeiloL0MKJSBJCMQzmwn84m
         0p6+T7PnFKV0ugCpMVxIjf8zyGiY6liuWEIgNbm9EOmvKAuIENm/iW7U1eJtqXurZSQz
         Y70n83F5ufR3PFIGXR+Ku9ChifH69ZpvZA+/LH6IjRCu1xRmYkIRHHu873kbTWE9IDse
         p6A0/Q5EAtWFtnq1vrcnnMz9fCzbFK4HD3YR4h2cui8y7ESFhR9Ut59Zxl2HY01TYzNa
         Bc+iByqINa1TBDwUZwD838TtkVxKCQSZ0tMobSPgwrdVXzEJkFa2gtKae+U6rN4OgGlJ
         SWjw==
X-Gm-Message-State: AFqh2kq194+azULS0uMs9SS2hsV6W2cU/JbBnRN68ihnIfq0Gfmqflyy
        Q716jr5quBnQrFnDCcOmJGjicospkuPp+RfLszTMvKFxEgl4wmBwpujhGlFPJugD9muEPP+nHlG
        Wzs3kSchtYvNahUyN
X-Received: by 2002:a05:6214:5f92:b0:532:b90:1993 with SMTP id ls18-20020a0562145f9200b005320b901993mr20786116qvb.11.1673192754251;
        Sun, 08 Jan 2023 07:45:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsDbO0oNA6ey8fyoPjndADuq9SLkuSxCdXR9dYfR4KehLHX/0m9XDEUGayV889iIptyGs2GsQ==
X-Received: by 2002:a05:6214:5f92:b0:532:b90:1993 with SMTP id ls18-20020a0562145f9200b005320b901993mr20786106qvb.11.1673192754037;
        Sun, 08 Jan 2023 07:45:54 -0800 (PST)
Received: from debian (2a01cb058918ce0098fed9113971adae.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:98fe:d911:3971:adae])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a057000b006fafaac72a6sm3817988qkp.84.2023.01.08.07.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 07:45:53 -0800 (PST)
Date:   Sun, 8 Jan 2023 16:45:50 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Matthias May <matthias.may@westermo.com>,
        linux-kselftest@vger.kernel.org,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [PATCH net 3/3] selftests/net: l2_tos_ttl_inherit.sh: Ensure
 environment cleanup on failure.
Message-ID: <1fdc9f2de958c8eb2c6bc435f149cf0adde72114.1673191942.git.gnault@redhat.com>
References: <cover.1673191942.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1673191942.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'set -e' and an exit handler to stop the script if a command fails
and ensure the test environment is cleaned up in any case. Also, handle
the case where the script is interrupted by SIGINT.

The only command that's expected to fail is 'wait $ping_pid', since
it's killed by the script. Handle this case with '|| true' to make it
play well with 'set -e'.

Finally, return the Kselftest SKIP code (4) when the script breaks
because of an environment problem or a command line failure. The 0 and
1 return codes should now reliably indicate that all tests have been
run (0: all tests run and passed, 1: all tests run but at least one
failed, 4: test script didn't run completely).

Fixes: b690842d12fd ("selftests/net: test l2 tunnel TOS/TTL inheriting")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 .../selftests/net/l2_tos_ttl_inherit.sh       | 40 +++++++++++++++++--
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
index cf56680d598f..f11756e7df2f 100755
--- a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
+++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
@@ -12,13 +12,16 @@
 # In addition this script also checks if forcing a specific field in the
 # outer header is working.
 
+# Return 4 by default (Kselftest SKIP code)
+ERR=4
+
 if [ "$(id -u)" != "0" ]; then
 	echo "Please run as root."
-	exit 0
+	exit $ERR
 fi
 if ! which tcpdump > /dev/null 2>&1; then
 	echo "No tcpdump found. Required for this test."
-	exit 0
+	exit $ERR
 fi
 
 expected_tos="0x00"
@@ -340,7 +343,7 @@ verify() {
 		fi
 	fi
 	kill -9 $ping_pid
-	wait $ping_pid 2>/dev/null
+	wait $ping_pid 2>/dev/null || true
 	result="FAIL"
 	if [ "$outer" = "4" ]; then
 		captured_ttl="$(get_field "ttl" "$out")"
@@ -380,6 +383,31 @@ cleanup() {
 	ip netns del "${NS1}" 2>/dev/null
 }
 
+exit_handler() {
+	# Don't exit immediately if one of the intermediate commands fails.
+	# We might be called at the end of the script, when the network
+	# namespaces have already been deleted. So cleanup() may fail, but we
+	# still need to run until 'exit $ERR' or the script won't return the
+	# correct error code.
+	set +e
+
+	cleanup
+
+	exit $ERR
+}
+
+# Restore the default SIGINT handler (just in case) and exit.
+# The exit handler will take care of cleaning everything up.
+interrupted() {
+	trap - INT
+
+	exit $ERR
+}
+
+set -e
+trap exit_handler EXIT
+trap interrupted INT
+
 printf "┌────────┬───────┬───────┬──────────────┬"
 printf "──────────────┬───────┬────────┐\n"
 for type in gre vxlan geneve; do
@@ -409,6 +437,10 @@ done
 printf "└────────┴───────┴───────┴──────────────┴"
 printf "──────────────┴───────┴────────┘\n"
 
+# All tests done.
+# Set ERR appropriately: it will be returned by the exit handler.
 if $failed; then
-	exit 1
+	ERR=1
+else
+	ERR=0
 fi
-- 
2.30.2

