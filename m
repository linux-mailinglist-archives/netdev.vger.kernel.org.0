Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E4330131B
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbhAWEyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbhAWEyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 23:54:16 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C55C06178B
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:36 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 30so5228837pgr.6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ILT1zsp1gp4scssLPHXpg9nOq/pEWZdcrMBoO8vJPso=;
        b=FDHG9xt/uUv4UCDAT7XXiyEpUfYUbGqCzgr57SUu6eINvIsFKq9BvEJ0yPdg8PS69Q
         eYO5Cd/IqLEFKFUs0R5Q1cIUa1eYtwyOwemQhekp05pnQP1i9vW7pFzI+pZ7W0GyWOpD
         iRelljGFJ9W/a4ABlqWYz0SD0LBhTLTtpLM4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ILT1zsp1gp4scssLPHXpg9nOq/pEWZdcrMBoO8vJPso=;
        b=dcrbjXwUXsuwpm7hKaTw/HzD70NZHZBFct1mwNpjhtUzMLVz4pguYUYZ06cDSxbe2e
         H12IYdEFGbsyryyQKqs0f+SCC2e6xVZeFum5RLhPZjfzYBuVzTap1XziCIRFII8te1IX
         swCw3v/g656kypYBxvQ5niW9KHPNRq5pe2fXgxYXcuhh+UaXJXrXQLpr7b10LZmBdCYl
         pJEw2i0jDLrnMQPLp8zdis96cOWMdm231ekUAgJV0H3jHtUEEjDntX5/zNZlOeeFlA8X
         RCNFNz1SL2vR5jGHhDeFRaLAXvlrhx9Mw/kIFAhN1CdlUzSe1jIEoX998QgtFii8Bq60
         Y2Eg==
X-Gm-Message-State: AOAM531/NmTlx4ASbZHPTldehR+dS2Retw6vILBLeftgdcN29YWy1EYw
        8Azh7MFDaTbrCmQIJc1nHyN/wO3+nemP3NHjCiQ/qbHGf0+3+xe2YdvmewRZxJKHHJPkYACDrwf
        Ob1OW4tmAJNly4P/gjLFZee8sy5BD9wnBOmYXRWu88JNrsMFoJ2rakDgFj4L/alNn/M0736qh
X-Google-Smtp-Source: ABdhPJySCY33xJR4VeDi1DgVlWuCpV9QTkW315eyZKeZZEYSuPRBO3z+J86cBy7oIX+KFjtL3pqmwA==
X-Received: by 2002:a65:6405:: with SMTP id a5mr7953724pgv.389.1611377615593;
        Fri, 22 Jan 2021 20:53:35 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([2600:8802:d04:de02::77c])
        by smtp.gmail.com with ESMTPSA id d2sm10725832pjd.29.2021.01.22.20.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:53:34 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 4/4] rtnetlink: promote IFLA_VF_STATS to same level as IFLA_VF_INFO
Date:   Fri, 22 Jan 2021 20:53:21 -0800
Message-Id: <20210123045321.2797360-5-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123045321.2797360-1-edwin.peer@broadcom.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006621ca05b98a16b7"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006621ca05b98a16b7
Content-Transfer-Encoding: 8bit

Separating the VF stats out of IFLA_VF_INFO appears to be the least
impact way of resolving the nlattr overflow bug in IFLA_VFINFO_LIST.

Since changing the hierarchy does constitute an ABI change, it must
be explicitly requested via RTEXT_FILTER_VF_SEPARATE_STATS. Otherwise,
the old location is maintained for compatibility.

A new container type, namely IFLA_VFSTATS_LIST, is introduced to group
the stats objects into an ordered list that corresponds with the order
of VFs in IFLA_VFINFO_LIST.

Fixes: 3b766cd83232 ("net/core: Add reading VF statistics through the PF netdevice")
Fixes: c5a9f6f0ab40 ("net/core: Add drop counters to VF statistics")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/rtnetlink.h |  1 +
 net/core/rtnetlink.c           | 24 +++++++++++++++++++++---
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 2bd0d8bbcdb2..db12ffd2bffd 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -341,6 +341,7 @@ enum {
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
 	IFLA_PROTO_DOWN_REASON,
+	IFLA_VFSTATS_LIST,
 	__IFLA_MAX
 };
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index b841caa4657e..f2f4f9b4d595 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -789,6 +789,7 @@ enum {
 #define RTEXT_FILTER_MRP	(1 << 4)
 #define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
 #define RTEXT_FILTER_CFM_STATUS	(1 << 6)
+#define RTEXT_FILTER_VF_SEPARATE_STATS	(1 << 7)
 
 /* End of information exported to user level */
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 95564fd12f24..cddd3945bc11 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -933,6 +933,8 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 			 nla_total_size(sizeof(struct ifla_vf_rss_query_en)) +
 			 nla_total_size(sizeof(struct ifla_vf_trust)));
 		if (~ext_filter_mask & RTEXT_FILTER_SKIP_STATS) {
+			if (ext_filter_mask & RTEXT_FILTER_VF_SEPARATE_STATS)
+				size += nla_total_size(0); /* IFLA_VFSTATS_LIST */
 			size += num_vfs *
 				(nla_total_size(0) + /* nest IFLA_VF_STATS */
 				 /* IFLA_VF_STATS_RX_PACKETS */
@@ -1368,7 +1370,8 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		goto nla_put_vf_failure;
 	}
 	nla_nest_end(skb, vfvlanlist);
-	if (~ext_filter_mask & RTEXT_FILTER_SKIP_STATS) {
+	if (~ext_filter_mask & RTEXT_FILTER_SKIP_STATS &&
+	    ~ext_filter_mask & RTEXT_FILTER_VF_SEPARATE_STATS) {
 		if (rtnl_fill_vfstats(skb, dev, vfs_num))
 			goto nla_put_vf_failure;
 	}
@@ -1386,7 +1389,7 @@ static noinline_for_stack int rtnl_fill_vf(struct sk_buff *skb,
 					   struct net_device *dev,
 					   u32 ext_filter_mask)
 {
-	struct nlattr *vfinfo;
+	struct nlattr *vfinfo, *vfstats;
 	int i, num_vfs;
 
 	if (!dev->dev.parent || ((ext_filter_mask & RTEXT_FILTER_VF) == 0))
@@ -1407,8 +1410,23 @@ static noinline_for_stack int rtnl_fill_vf(struct sk_buff *skb,
 		if (rtnl_fill_vfinfo(skb, dev, i, vfinfo, ext_filter_mask))
 			return -EMSGSIZE;
 	}
-
 	nla_nest_end(skb, vfinfo);
+
+	if (~ext_filter_mask & RTEXT_FILTER_SKIP_STATS &&
+	    ext_filter_mask & RTEXT_FILTER_VF_SEPARATE_STATS) {
+		vfstats = nla_nest_start_noflag(skb, IFLA_VFSTATS_LIST);
+		if (!vfstats)
+			return -EMSGSIZE;
+
+		for (i = 0; i < num_vfs; i++) {
+			if (rtnl_fill_vfstats(skb, dev, i)) {
+				nla_nest_cancel(skb, vfstats);
+				return -EMSGSIZE;
+			}
+		}
+		nla_nest_end(skb, vfstats);
+	}
+
 	return 0;
 }
 
-- 
2.30.0


--0000000000006621ca05b98a16b7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg/a3p4xUq/vOPzYjaSuRy
R5nbZFQGKiE00NY3hRKMeEQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIzMDQ1MzM1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGe91Gui9peHErBa0enaJnZa62uF21k0RE0egFnj
CO+av7TQC98s5AJdQdxb/Ev/wWbsvQj//D/eZphhWbybEl39P/1bZll1VlBKleIrUskkWdUqIr7j
/gcZuwqQWw0MmowCnpuhxdH7iwy3+NDCPlDjBZL0qw+zoR7arbpWkTvV+WjJ0w5OdP6BxCIrzip3
jsJD7PyIrqS4Mw3CQ/s27gYCnCMc4idBSDv6gjufndh6m67M32hIrEZSPrBc1Gr/6d8Ft/TjgE4t
LrKEs9l05Y7TNArckz3NuQQtqNo3ZMp/pUB2uHW5AsJd0OOb4B1qLMhtymZkvpTweBWO/LvbwMk=
--0000000000006621ca05b98a16b7--
