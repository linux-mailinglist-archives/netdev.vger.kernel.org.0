Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C1A4B114D
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243472AbiBJPIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:08:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243413AbiBJPIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:08:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09DB1BF
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644505694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CxpRwE6hONkDkRgiexuXx1SBzzlwtBumMhl9fi1tHTo=;
        b=b6aotZdiEwCZk9RNi+URV8ifnL8RXzXJb4v8qBcdl3nP51Sv7qGOjoYAkXaOa/I1IUlspP
        GQUywPT7hH8miu4UdAWS4cO+bH51yAJl38oq4I7u/7GCTyX7FaLEZ+BiglXWqj23ywxJH/
        bwjyP3pUzbaF1Igyial93vrSgZpbk+Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-lAAc-iHdPIWFOHMghCEExA-1; Thu, 10 Feb 2022 10:08:11 -0500
X-MC-Unique: lAAc-iHdPIWFOHMghCEExA-1
Received: by mail-wr1-f69.google.com with SMTP id j8-20020adfa548000000b001e33074ac51so2634386wrb.11
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:08:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=CxpRwE6hONkDkRgiexuXx1SBzzlwtBumMhl9fi1tHTo=;
        b=QrJDDFv4j9jgifYv3Dr4ohar2HK3cSSGLYb6d53OxCYvH6SVBcCNvz32UDFhgo6lYE
         msCRzzRCDNIGge7dLmRRP7ikCjEs9zBi4upbHAsHCUpewet2LTW7+L2YLP3cr6Ia0HKz
         Y4k325Is07QTdN2SyVfDbfY3i5+0/jeXulkNX0+e7OqDUsVZL4uh7FXpt3TTkatADXT0
         SCD4CBBBa9656ggsqrCMxyRHK6CAaopkVfJLq/RR89X4KZi+bBaip7fZwcPzpdZJ2EQt
         UZxDnRsm98CQxdyzDVAIsS9+CQzXdjFI6RcGlYqNxV5aJP3ZWxKe6ExrjH75Siu68qK9
         PZmg==
X-Gm-Message-State: AOAM533qC9eTIa8YV/OvzaoRyIdZFKbkgbIo3ZZ8h4gZVF6lbP1Xvl3j
        YmFbUZ83tFcHlprf87reuexP7DN5mU8nM5uwGjhfm8W80pcMAwgEOrUzWfxjrTNYZxxITXzEBEZ
        e0OfgTwmUIz8kCXDZ
X-Received: by 2002:a1c:43c2:: with SMTP id q185mr2529975wma.189.1644505690506;
        Thu, 10 Feb 2022 07:08:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPaotSdxyRu1Y0F7j94LUik5qG4lyVUd6RdPuuptEs7sgTbjXFVO8vGPo8qaIv50ZEv7QLpA==
X-Received: by 2002:a1c:43c2:: with SMTP id q185mr2529954wma.189.1644505690290;
        Thu, 10 Feb 2022 07:08:10 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u17sm1707483wmq.41.2022.02.10.07.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:08:09 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:08:08 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next] ipv6: Reject routes configurations that specify
 dsfield (tos)
Message-ID: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ->rtm_tos option is normally used to route packets based on both
the destination address and the DS field. However it's ignored for
IPv6 routes. Setting ->rtm_tos for IPv6 is thus invalid as the route
is going to work only on the destination address anyway, so it won't
behave as specified.

Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
The same problem exists for ->rtm_scope. I'm working only on ->rtm_tos
here because IPv4 recently started to validate this option too (as part
of the DSCP/ECN clarification effort).
I'll give this patch some soak time, then send another one for
rejecting ->rtm_scope in IPv6 routes if nobody complains.

 net/ipv6/route.c                         |  6 ++++++
 tools/testing/selftests/net/fib_tests.sh | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f4884cda13b9..dd98a11fbdb6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5009,6 +5009,12 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = -EINVAL;
 	rtm = nlmsg_data(nlh);
 
+	if (rtm->rtm_tos) {
+		NL_SET_ERR_MSG(extack,
+			       "Invalid dsfield (tos): option not available for IPv6");
+		goto errout;
+	}
+
 	*cfg = (struct fib6_config){
 		.fc_table = rtm->rtm_table,
 		.fc_dst_len = rtm->rtm_dst_len,
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index bb73235976b3..e2690cc42da3 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -988,12 +988,25 @@ ipv6_rt_replace()
 	ipv6_rt_replace_mpath
 }
 
+ipv6_rt_dsfield()
+{
+	echo
+	echo "IPv6 route with dsfield tests"
+
+	run_cmd "$IP -6 route flush 2001:db8:102::/64"
+
+	# IPv6 doesn't support routing based on dsfield
+	run_cmd "$IP -6 route add 2001:db8:102::/64 dsfield 0x04 via 2001:db8:101::2"
+	log_test $? 2 "Reject route with dsfield"
+}
+
 ipv6_route_test()
 {
 	route_setup
 
 	ipv6_rt_add
 	ipv6_rt_replace
+	ipv6_rt_dsfield
 
 	route_cleanup
 }
-- 
2.21.3

