Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BAD3FB23C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 10:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhH3IJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 04:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbhH3IJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 04:09:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48194C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 01:08:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e15so8064217plh.8
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 01:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=Wiu1FEXxNi8q3+jf3o6ohTaA6seSu3nnUW/wk1qbuJ8=;
        b=YgrG4I5pEsBy6Qy1bC0BRYQu3PgnMT7faU4I/WPQRT7N+6vQWYZq4cz+OoYV0zYSTe
         7PtHmM8/RtHIf/9hIaGXipPkdVMAiGQcjmU1tv0N7hJnmuXCAyeH9mpsUJ/pqwGQx7Sa
         hEBOr60zuZq1ghmprrWpWHrFLgfcr69xe/1Ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=Wiu1FEXxNi8q3+jf3o6ohTaA6seSu3nnUW/wk1qbuJ8=;
        b=emlLkdYFR8Y4cEBHhThcB68fV2v5uDf2Sl6EE9mHj1Hxw+vGCyz/6ZyT9TfQ0yBbKC
         +6XQvZGeEQwoy+FH9qCfx4nebr3o16Duir5tUqKMZRw3J5/Xzupkn2Vvgd4M8t2FmOyr
         h0jVpOrvLknz7uc3O6IKubIqFUheBcwgUt9kZclHx+uhGBalFb1IwZYg4GYU78iVsf0s
         eRUzJz9d2xNARk9F1KQOZ4RP4Y8VOvrMKIDkc/iyse9z6JOJdOQx/AKCycJGMvK6wNvM
         tsswUYUMl1zZ/BdvWCrc0e9npwbJXbJf/Z1criXTv9lvj5swnk0sKPu5PTMeiUM/6s91
         LA7g==
X-Gm-Message-State: AOAM531Byj0INOCkez5lJVMQrttzltpluDnZJAG55kc8uoyDlLH/3LDV
        dtQeLrn5m2BSS+KP3JoyfhO6M5xB0Hd3TXihhhxqhbBITxsu04Lsi+FWJZ9F1/z20Vy47ZwfOuV
        0XhPp0YJ+enMBvSDL0PHpgIT58g/ykh2CEODRNXgSMLLHE9A9gRrursWMPLBBy55B5/Iz2Wxxw/
        WZcYDpD+19Bg==
X-Google-Smtp-Source: ABdhPJzn9utCPDeoTPubseZOFARNUeAul+TRSpFmgLOdGDZbXQ2CCgCRZ5w/zHJNfHcDNJ4UTmmHzA==
X-Received: by 2002:a17:90a:a88b:: with SMTP id h11mr25166904pjq.44.1630310905969;
        Mon, 30 Aug 2021 01:08:25 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id h21sm16052088pgg.8.2021.08.30.01.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 01:08:25 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
Date:   Mon, 30 Aug 2021 11:08:00 +0300
Message-Id: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007704c205cac2569f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007704c205cac2569f
Content-Transfer-Encoding: 8bit

The following flower filter fails to match packets:

tc filter add dev eth0 ingress protocol 0x8864 flower \
    action simple sdata hi64

The protocol 0x8864 (ETH_P_PPP_SES) is a tunnel protocol. As such, it is
being dissected by __skb_flow_dissect and it's internal protocol is
being set as key->basic.n_proto. IOW, the existence of ETH_P_PPP_SES
tunnel is transparent to the callers of __skb_flow_dissect.

OTOH, in the filters above, cls_flower configures its key->basic.n_proto
to the ETH_P_PPP_SES value configured by the user. Matching on this key
fails because of __skb_flow_dissect "transparency" mentioned above.

Therefore there is no way currently to match on such packets using
flower.

To fix the issue add new orig_ethtype key to the flower along with the
necessary changes to the flow dissector etc.

To filter the ETH_P_PPP_SES packets the command becomes:

tc filter add dev eth0 ingress flower orig_ethtype 0x8864 \
    action simple sdata hi64

Corresponding iproute2 patch follows.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 include/net/flow_dissector.h |  9 +++++++++
 include/uapi/linux/pkt_cls.h |  1 +
 net/core/flow_dissector.c    | 12 ++++++++++++
 net/sched/cls_flower.c       | 15 +++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ffd386ea0dbb..083245a2d408 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -251,6 +251,14 @@ struct flow_dissector_key_hash {
 	u32 hash;
 };
 
+/**
+ * struct flow_dissector_key_orig_ethtype:
+ * @orig_ethtype: eth type as it appears in the packet
+ */
+struct flow_dissector_key_orig_ethtype {
+	__be16	orig_ethtype;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -280,6 +288,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_META, /* struct flow_dissector_key_meta */
 	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
 	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
+	FLOW_DISSECTOR_KEY_ORIG_ETH_TYPE, /* struct flow_dissector_key_orig_ethtype */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 025c40fef93d..238dee49f450 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -583,6 +583,7 @@ enum {
 	TCA_FLOWER_KEY_HASH,		/* u32 */
 	TCA_FLOWER_KEY_HASH_MASK,	/* u32 */
 
+	TCA_FLOWER_KEY_ORIG_ETH_TYPE,	/* be16 */
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 4b2415d34873..23051e0d02fd 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -924,6 +924,7 @@ bool __skb_flow_dissect(const struct net *net,
 	struct flow_dissector_key_vlan *key_vlan;
 	enum flow_dissect_ret fdret;
 	enum flow_dissector_key_id dissector_vlan = FLOW_DISSECTOR_KEY_MAX;
+	__be16 orig_proto = proto;
 	bool mpls_el = false;
 	int mpls_lse = 0;
 	int num_hdrs = 0;
@@ -934,6 +935,7 @@ bool __skb_flow_dissect(const struct net *net,
 		data = skb->data;
 		proto = skb_vlan_tag_present(skb) ?
 			 skb->vlan_proto : skb->protocol;
+		orig_proto = proto;
 		nhoff = skb_network_offset(skb);
 		hlen = skb_headlen(skb);
 #if IS_ENABLED(CONFIG_NET_DSA)
@@ -1032,6 +1034,16 @@ bool __skb_flow_dissect(const struct net *net,
 		memcpy(key_eth_addrs, &eth->h_dest, sizeof(*key_eth_addrs));
 	}
 
+	if (dissector_uses_key(flow_dissector,
+			       FLOW_DISSECTOR_KEY_ORIG_ETH_TYPE)) {
+		struct flow_dissector_key_orig_ethtype *orig_ethtype;
+
+		orig_ethtype = skb_flow_dissector_target(flow_dissector,
+							 FLOW_DISSECTOR_KEY_ORIG_ETH_TYPE,
+							 target_container);
+		orig_ethtype->orig_ethtype = orig_proto;
+	}
+
 proto_again:
 	fdret = FLOW_DISSECT_RET_CONTINUE;
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index d7869a984881..bf6e88819f7d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -70,6 +70,7 @@ struct fl_flow_key {
 	} tp_range;
 	struct flow_dissector_key_ct ct;
 	struct flow_dissector_key_hash hash;
+	struct flow_dissector_key_orig_ethtype orig_ethtype;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct fl_flow_mask_range {
@@ -710,6 +711,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_FLAGS]		= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_HASH]		= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_HASH_MASK]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ORIG_ETH_TYPE]	= { .type = NLA_U16 },
 
 };
 
@@ -1696,6 +1698,11 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		       &mask->hash.hash, TCA_FLOWER_KEY_HASH_MASK,
 		       sizeof(key->hash.hash));
 
+	fl_set_key_val(tb, &key->orig_ethtype.orig_ethtype,
+		       TCA_FLOWER_KEY_ORIG_ETH_TYPE,
+		       &mask->orig_ethtype.orig_ethtype, TCA_FLOWER_UNSPEC,
+		       sizeof(key->orig_ethtype.orig_ethtype));
+
 	if (tb[TCA_FLOWER_KEY_ENC_OPTS]) {
 		ret = fl_set_enc_opt(tb, key, mask, extack);
 		if (ret)
@@ -1812,6 +1819,8 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 			     FLOW_DISSECTOR_KEY_CT, ct);
 	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
 			     FLOW_DISSECTOR_KEY_HASH, hash);
+	FL_KEY_SET_IF_MASKED(mask, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ORIG_ETH_TYPE, orig_ethtype);
 
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
@@ -3037,6 +3046,12 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 			     sizeof(key->hash.hash)))
 		goto nla_put_failure;
 
+	if (fl_dump_key_val(skb, &key->orig_ethtype.orig_ethtype,
+			    TCA_FLOWER_KEY_ORIG_ETH_TYPE,
+			    &mask->orig_ethtype.orig_ethtype, TCA_FLOWER_UNSPEC,
+			    sizeof(key->orig_ethtype.orig_ethtype)))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.29.2


--0000000000007704c205cac2569f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDDSzinKpvcPTN4ZIJTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNzMwMDRaFw0yMjA5MDUwNzM3NTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAy/C7bjpxs+95egWV8sWrK9KO0SQi6Nxu14tJBgP+MOK5tvokizPFHoiXTymZ
7ClfnmbcqT4PzWgI3thyfk64bgUo1nQkCTApn7ov3IRsWjmHExLSNoJ/siUHagO6BPAk4JSycrj5
9tC9sL4FnIAbAHmOSILCyGyyaBAcmiyH/3toYqXyjJkK+vbWQSTxk2NlqJLIN/ypLJ1pYffVZGUs
52g1hlQtHhgLIznB1Qx3Fop3nOUk8nNpQLON/aM8K5sl18964c7aXh7YZnalUQv3md4p2rAQQqIR
rZ8HBc7YjlZynwOnZl1NrK4cP5aM9lMkbfRGIUitHTIhoDYp8IZ1dwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtBmGs9S4
t1FcFSfkrP2LKQQwBKMwDQYJKoZIhvcNAQELBQADggEBAJMAjVBkRmr1lvVvEjMaLfvMhwGpUfh6
CMZsKICyz/ZZmvTmIZNwy+7b9r6gjLCV4tP63tz4U72X9qJwfzldAlYLYWIq9e/DKDjwJRYlzN8H
979QJ0DHPSJ9EpvSKXob7Ci/FMkTfq1eOLjkPRF72mn8KPbHjeN3VVcn7oTe5IdIXaaZTryjM5Ud
bR7s0ZZh6mOhJtqk3k1L1DbDTVB4tOZXZHRDghEGaQSnwU/qxCNlvQ52fImLFVwXKPnw6+9dUvFR
ORaZ1pZbapCGbs/4QLplv8UaBmpFfK6MW/44zcsDbtCFfgIP3fEJBByIREhvRC5mtlRtdM+SSjgS
ZiNfUggxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw0
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKCEOo1D8DmwWgeq
vo4l3IN2hWO2J2UjOLr6/ehHycIfMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDgzMDA4MDgyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCDXpDYDoW5g9no0tMa7LDeC60Yw0a5qKSl
rygm/i9y1TwU4a5V71FKCdRQDSO/ks8Kmv3iu3OZv63eHHJG9EQsjL2FffeocMn3ysF0hv6P5hqH
fMEzK3S/sxtbbqPtnXZr4QtfoxarsAObXktUb0ct7bozZvzkY5Q+JhLRvQmmB5hvwpfBjP0CaD2g
nvnGQH1eOrfAaD5kgjAocBmWHgA34ayziLRKReIj8O3yGpOTOYdQe0NQz9dZf+mG5gvZSUdNgIfa
iSnAL7dUpKQsXmMuty70v0ijmTW14GYYgBg+YZWDQY8xZBoIibOSyBKSjYukmFoYu5Ta1voA/oZP
Uo0A
--0000000000007704c205cac2569f--
