Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFDCE89F9
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 14:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbfJ2NvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 09:51:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48916 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388983AbfJ2NvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 09:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572357066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIRfkARawuYx5E17weGS9sdJ1VOiUwg/d8BMqTS+xF4=;
        b=KfYIdTLGO9WHu6aAwygoMR35rdPkxUGAll58jFy29U1CtvY6wsP1hOl4/YAWrSyPXAQQiv
        CQlvFIy/Bwj2+gj/w/HpHaZnLSEMECxz3V3MCBi/swb1yM4+WLJDUeLc2GjSjwSho3IJH7
        tzT1lzeiLM0Gc7e1PkScu37rOpB5XtE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-ZFe2rKfbOe2p_5iy3UQYog-1; Tue, 29 Oct 2019 09:51:04 -0400
Received: by mail-wm1-f69.google.com with SMTP id a81so891035wma.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 06:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SMEGf4c6Ma+Bze2+ZiGp43bjN8huF03EIdt6wvA9wXw=;
        b=FE3D63yl9mUHt/WZb7o8XbfHEPWTaiKPPsWFTSGEcReLquWggO7pLGb/XApi6nQoX4
         Q8dJV7MqCxt5SuH8gp1WL0r4WudPayT84+WMuOi9egW+eBYQ8fM6ajHuk9ziNVFA3YLL
         3SEIT1a1K5QLQrfewu0wfEYLV6iBQImRkNLPfSbcTUeG798knKOxOLQnD1dcYjzbIFtr
         94TM8G0iD2nu9UPUCz5+DARCySCxFR5a9JBTEe2ZAVfm/6QYT1j9qNjTB6XvPP5FZm7w
         Kw6O/5/Stg6UnS/HDQ4sfAPdKecGUGwGuK1IOQNS5DY1nqj5Xt9SLpilBlWpszuLqhBp
         J6Zw==
X-Gm-Message-State: APjAAAXFxx7SDUutR/DmA0tBuUazXLYsnBjkyiLfX7YeIg1nd4WqcoyA
        dFumIjcdTlRe8H8wEMArA9hqZzZHym5m++MBFyvYQ0XDsTcw0s1I+j51MuCyKmT2EbiscEGzRid
        oHYyXw0ml8fVc/SC1
X-Received: by 2002:adf:828c:: with SMTP id 12mr19790479wrc.40.1572357063581;
        Tue, 29 Oct 2019 06:51:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzjCJGyJ/tvm+foMGtEVPFNTayDFfATM7pwPRhzRETLIFTFzBxqPMY9xxiE5XklQiPQGzHwRQ==
X-Received: by 2002:adf:828c:: with SMTP id 12mr19790460wrc.40.1572357063387;
        Tue, 29 Oct 2019 06:51:03 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 189sm2556920wmc.7.2019.10.29.06.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:51:02 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/4] flow_dissector: add meaningful comments
Date:   Tue, 29 Oct 2019 14:50:50 +0100
Message-Id: <20191029135053.10055-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029135053.10055-1-mcroce@redhat.com>
References: <20191029135053.10055-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: ZFe2rKfbOe2p_5iy3UQYog-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documents two piece of code which can't be understood at a glance.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/net/flow_dissector.h | 1 +
 net/core/flow_dissector.c    | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 90bd210be060..7747af3cc500 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -282,6 +282,7 @@ struct flow_keys {
 =09struct flow_dissector_key_vlan cvlan;
 =09struct flow_dissector_key_keyid keyid;
 =09struct flow_dissector_key_ports ports;
+=09/* 'addrs' must be the last member */
 =09struct flow_dissector_key_addrs addrs;
 };
=20
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 7c09d87d3269..affde70dad47 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1374,6 +1374,9 @@ static inline size_t flow_keys_hash_length(const stru=
ct flow_keys *flow)
 {
 =09size_t diff =3D FLOW_KEYS_HASH_OFFSET + sizeof(flow->addrs);
 =09BUILD_BUG_ON((sizeof(*flow) - FLOW_KEYS_HASH_OFFSET) % sizeof(u32));
+=09/* flow.addrs MUST be the last member in struct flow_keys because
+=09 * different L3 protocols have different address length
+=09 */
 =09BUILD_BUG_ON(offsetof(typeof(*flow), addrs) !=3D
 =09=09     sizeof(*flow) - sizeof(flow->addrs));
=20
@@ -1421,6 +1424,9 @@ __be32 flow_get_u32_dst(const struct flow_keys *flow)
 }
 EXPORT_SYMBOL(flow_get_u32_dst);
=20
+/* Sort the source and destination IP (and the ports if the IP are the sam=
e),
+ * to have consistent hash within the two directions
+ */
 static inline void __flow_hash_consistentify(struct flow_keys *keys)
 {
 =09int addr_diff, i;
--=20
2.21.0

