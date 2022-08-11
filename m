Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBA858FCD1
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbiHKMwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiHKMwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:52:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABFA12BB24
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 05:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660222324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fZR1rg29jmUTn0ZaHr80FrLXJcO6qark0sdTnOhFYqg=;
        b=HFnYWFvrW0S1b8SA++vbvHv6cX+cebH6rqoqjHPwZiDE/YuHxJJbIF8Fu7MorqbBNGkDbN
        iAritYp9Om/J/Hx9a2hQabwEaHYzlUICaY1Tr2VAjiMCZnz4LO7+Jq858ENNFHMUD7e1Lm
        yuVFSYvwS5p5n4lzX9ZFoIAWM2DT4Ls=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-547-oyB9JZJlMzel34Dhk2AR9w-1; Thu, 11 Aug 2022 08:52:03 -0400
X-MC-Unique: oyB9JZJlMzel34Dhk2AR9w-1
Received: by mail-ed1-f71.google.com with SMTP id t13-20020a056402524d00b0043db1fbefdeso10789417edd.2
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 05:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=fZR1rg29jmUTn0ZaHr80FrLXJcO6qark0sdTnOhFYqg=;
        b=Z3pEv7UqlxQKgh+vOMxba3et6Vr8zq2vI1sO3F1eJ3oKgg4DwPHVw6hCc2xG1kQ9Oi
         FA/rHouX3tfonud5FhTVQ7dewPQ3NiTdELUPZ9Of+yUMD89+zCEDtDHWnCtGS7v3umtL
         eTbZHhWrvb0dZDRKQWb67xyfH11APOM2coVGI1v3JddOhuNctK47XWoiwjJPJNLr/Lbb
         7l0QAyhAacBFn1DxIKW03wmmU3yaLEszgQqFsYM2utUue1E911ligjxinbg0Ujlldlf0
         4oK3NAu4x0VOLsD6CPpw5vkp3vWFIJVK9cVDc0VU6fvTAkZBwiiklBkRZG7S8vOsFzWL
         T/mA==
X-Gm-Message-State: ACgBeo2k6uWGWOPYqT9Klzvd/etXlAyWBsVx75wSHRzrLfW9suUJ4oXh
        TBpmXETjW/XmcDIymQwoiFyM4yB1GTuoE4mfpo4wSqnKI1aBDANhm9p9syKwavXRLn6R7Wm37zN
        FdPHL3nFtnhapqFg/
X-Received: by 2002:a05:6402:424e:b0:43d:9d9f:38f9 with SMTP id g14-20020a056402424e00b0043d9d9f38f9mr30995446edb.411.1660222322560;
        Thu, 11 Aug 2022 05:52:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Uonm4Tt4dUrVuSW7DOj4CixZE71gE99A8Xg5JVQuHVDIdMz6RS86ZeW5EQJ50fie/SzlXCQ==
X-Received: by 2002:a05:6402:424e:b0:43d:9d9f:38f9 with SMTP id g14-20020a056402424e00b0043d9d9f38f9mr30995425edb.411.1660222322396;
        Thu, 11 Aug 2022 05:52:02 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id w21-20020a170906131500b0072ab06bf296sm3424029ejb.23.2022.08.11.05.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 05:52:01 -0700 (PDT)
Date:   Thu, 11 Aug 2022 08:51:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Andrew Melnychenko <andrew@daynix.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] virtio_net: fix endian-ness for RSS
Message-ID: <20220811125156.293825-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using native endian-ness for device supplied fields is wrong
on BE platforms. Sparse warns about this.

Fixes: 91f41f01d219 ("drivers/net/virtio_net: Added RSS hash report.")
Cc: "Andrew Melnychenko" <andrew@daynix.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d9c434b00e9b..6e9868c860bc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1208,7 +1208,7 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 	if (!hdr_hash || !skb)
 		return;
 
-	switch ((int)hdr_hash->hash_report) {
+	switch (__le16_to_cpu(hdr_hash->hash_report)) {
 	case VIRTIO_NET_HASH_REPORT_TCPv4:
 	case VIRTIO_NET_HASH_REPORT_UDPv4:
 	case VIRTIO_NET_HASH_REPORT_TCPv6:
@@ -1226,7 +1226,7 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 	default:
 		rss_hash_type = PKT_HASH_TYPE_NONE;
 	}
-	skb_set_hash(skb, (unsigned int)hdr_hash->hash_value, rss_hash_type);
+	skb_set_hash(skb, __le32_to_cpu(hdr_hash->hash_value), rss_hash_type);
 }
 
 static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
-- 
MST

