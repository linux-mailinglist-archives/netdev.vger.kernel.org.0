Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E8A30131F
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbhAWEzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbhAWEyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 23:54:54 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756E1C0617A7
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:54:03 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id a20so2110435pjs.1
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=2HiPQbERNmDJsN7tLgdcD8TxeTumghftwa9JpFzrsGw=;
        b=IABNyNRTOlckv/zPzdqeMTlVKQFHP/wNME7+ExBFDp7V8jmAl4e/YcHwU/IBBpdDlR
         lKKr/7xuOZsqUTC2Kg1ZMi6hjrz6gxSuAKZuVkNstURCeicZHQxgFFx4xfHLrqxOAdX3
         EYBGXUY/fSa9dUrGJbtsEeE+uCevaH4oYhtCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=2HiPQbERNmDJsN7tLgdcD8TxeTumghftwa9JpFzrsGw=;
        b=HM/4lIkShcLdqGWOXRd3U/SH2yAdgrpPlXXIzNtL3L6yuZeUX3HAjFU5tt8aVgyfwq
         ctU0Nzyg6phfGdCeRq95yqEA1dAq/Qln1acvdnwMqajqClyreKOtsrz1nFcPS9ZYLudy
         rhQQ8gLiCae2JCWzUFEhaGe2Yjhfna0sMJzRAJ0C8zUVNbD9m67INib77zGnGL4Vvtml
         FeNn5ycimPnVHH1/R7i89JYXtjdWF7cyx+mXdnfus1d6Z/IZqpJ8R4c1NagpQw1GISys
         ZFqgO8Y+6F++io8iefExN5lZOwKtSonkHfkr6KTUoabYCDp4Ba/y+M19ea0/qOGtuZug
         narQ==
X-Gm-Message-State: AOAM53124MdtiKzWWhFn21PTB1xEPKjGt+e9aqigsuwikN35iye56ogB
        wyUkwBS+X7yYtvu87MlnIrve8GB96UBa/LIneszoFhukNpi36NmkdoBaBd8zYaoCYXr3gakSOiT
        lxBTWiAZVuy8juyGt6gw14yPr9wRoLM+gVE/4VUghntyxXLZZYuBYqvABZJdSZXzomhov8vLU
X-Google-Smtp-Source: ABdhPJz53qIoW4PMu7VJuoVvc9aV3hRpjMR7/ySPOnd5YTTlDdmeFWok0s8Cp3iQynzsL2EhQ1Kx7A==
X-Received: by 2002:a17:90a:c82:: with SMTP id v2mr9217635pja.171.1611377642233;
        Fri, 22 Jan 2021 20:54:02 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([2600:8802:d04:de02::77c])
        by smtp.gmail.com with ESMTPSA id k3sm9675743pgm.94.2021.01.22.20.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:54:01 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 4/4] iplink: render IFLA_VF_STATS from IFLA_VFSTATS_LIST
Date:   Fri, 22 Jan 2021 20:53:51 -0800
Message-Id: <20210123045351.2797433-4-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123045351.2797433-1-edwin.peer@broadcom.com>
References: <20210123045351.2797433-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fef04305b98a171c"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000fef04305b98a171c
Content-Transfer-Encoding: 8bit

The maximum possible length of a netlink attribute is 64KB, but the
IFLA_VFINFO_LIST exceeds this when stats are included and more than
about 220 VFs are present (each VF consumes approximately 300 bytes,
depending on alignment and optional fields). Exceeding the limit will
cause the list to be truncated by the kernel's nla_nest_end().

A recent ABI fix moves the VF stats into an independent list when
requested, thus avoiding the problem. Send requests using the new
RTEXT_FILTER_VF_SEPARATE_STATS filter and render the stats from
the alternate list instead.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 ip/ipaddress.c   | 14 +++++++++++---
 ip/iplink.c      |  1 +
 lib/libnetlink.c |  3 ++-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 75511881050d..a048b3db601c 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1200,12 +1200,20 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 
 	if ((do_link || show_details) && tb[IFLA_VFINFO_LIST] && tb[IFLA_NUM_VF]) {
 		struct rtattr *i, *vflist = tb[IFLA_VFINFO_LIST];
-		int rem = RTA_PAYLOAD(vflist), count = 0;
+		struct rtattr *j, *vfstats = tb[IFLA_VFSTATS_LIST];
+		int rem_stats, rem = RTA_PAYLOAD(vflist), count = 0;
 
+		j = vfstats ? RTA_DATA(vfstats) : NULL;
+		rem_stats = vfstats ? RTA_PAYLOAD(vfstats) : 0;
 		open_json_array(PRINT_JSON, "vfinfo_list");
 		for (i = RTA_DATA(vflist); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 			open_json_object(NULL);
 			print_vfinfo(fp, ifi, i);
+			if (show_stats && j) {
+				print_vf_stats64(fp, j);
+				j = RTA_OK(j, rem_stats) ?
+					RTA_NEXT(j, rem_stats) : NULL;
+			}
 			close_json_object();
 			count++;
 		}
@@ -1885,7 +1893,7 @@ static int iplink_filter_req(struct nlmsghdr *nlh, int reqlen)
 	__u32 filt_mask;
 	int err;
 
-	filt_mask = RTEXT_FILTER_VF;
+	filt_mask = RTEXT_FILTER_VF | RTEXT_FILTER_VF_SEPARATE_STATS;
 	if (!show_stats)
 		filt_mask |= RTEXT_FILTER_SKIP_STATS;
 	err = addattr32(nlh, reqlen, IFLA_EXT_MASK, filt_mask);
@@ -1923,7 +1931,7 @@ static int ipaddr_link_get(int index, struct nlmsg_chain *linfo)
 		.i.ifi_family = filter.family,
 		.i.ifi_index = index,
 	};
-	__u32 filt_mask = RTEXT_FILTER_VF;
+	__u32 filt_mask = RTEXT_FILTER_VF | RTEXT_FILTER_VF_SEPARATE_STATS;
 	struct nlmsghdr *answer;
 
 	if (!show_stats)
diff --git a/ip/iplink.c b/ip/iplink.c
index 6a973213dc11..3cce8aa2a0b7 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1117,6 +1117,7 @@ int iplink_get(char *name, __u32 filt_mask)
 			  name, strlen(name) + 1);
 	}
 
+	filt_mask |= RTEXT_FILTER_VF_SEPARATE_STATS;
 	if (!show_stats)
 		filt_mask |= RTEXT_FILTER_SKIP_STATS;
 	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index b1f07d4570cf..b4aa9d16b446 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -486,7 +486,8 @@ static int __rtnl_linkdump_req(struct rtnl_handle *rth, int family)
 int rtnl_linkdump_req(struct rtnl_handle *rth, int family)
 {
 	if (family == AF_UNSPEC)
-		return rtnl_linkdump_req_filter(rth, family, RTEXT_FILTER_VF);
+		return rtnl_linkdump_req_filter(rth, family, RTEXT_FILTER_VF |
+						RTEXT_FILTER_VF_SEPARATE_STATS);
 
 	return __rtnl_linkdump_req(rth, family);
 }
-- 
2.30.0


--000000000000fef04305b98a171c
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgGzPJa4FK/GE+Xryr/PIP
YNCZq4EjfZzaBcbl+SPAxUgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIzMDQ1NDAyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAE4s6t7r5Aee7ZrpcGXgmotNQ5mhLX10JB4WhsSl
4WTRZ9R0lzQP8jyJlLXq5KaGuYjypq/q3/FSshdXJm4pPAx6avwEwdpUCDjytwjRuyrpVHuvacam
Qvyyq/D1AwfnuamYv0FHmTuqNKwDIHmdgS+8zOqfqWZaVAAhyI3b9K/TaUaWRMtMDGPxeq/9mHzR
NwgMyJXv5G/XFiuCsQ/Cum1Gir338QdBgu1msvQBiR2ebLg+48N6EiarDOqs6hUFPQbzK7mbxDQA
bOpEE5bGUEIxu9poMyoBx+IyVpueOmA1RDR7FVBzt8yCAdd+Mg8xfZYNSXdYXD2gzC+nW/ff6sg=
--000000000000fef04305b98a171c--
