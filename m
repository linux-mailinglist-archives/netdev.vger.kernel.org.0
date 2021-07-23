Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2623D3BC0
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhGWNoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:44:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235360AbhGWNnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 09:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627050265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ms3j5GjcBhU2kzOEyerWT/jDkz2YpaxMmXa1WE0AxlE=;
        b=JmApfvepjGtP6H4GRjLR5KRJwbwoWHBQ/vG7ZT2Jnth0qYXH7TnwLIWB1nNR5VAna0ywnc
        9S8RgbPU7PSvCkZBYwnJABbctJll9X2e+ke8WZO3BADDuddQGin045JX6jXYFMd0/ih0Ow
        FbB81zs/+59XxbpBdZytY/NaposLNs0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-EeuIDFOmMDSsTNQ8pqSPLQ-1; Fri, 23 Jul 2021 10:24:24 -0400
X-MC-Unique: EeuIDFOmMDSsTNQ8pqSPLQ-1
Received: by mail-wm1-f70.google.com with SMTP id q188-20020a1ca7c50000b0290241f054d92aso144416wme.5
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ms3j5GjcBhU2kzOEyerWT/jDkz2YpaxMmXa1WE0AxlE=;
        b=XkB5XGkxHQbSnjubcUpeLpGgfMQvisl39QSlhkJMuBvKW8jY5dHF+4Vm7osPm52WDS
         TWSwhh3d1Q/wFp6hW1Jia6YWPA2QLSyzGIQjTB5SO4G2f1UsiYlxHOd7lGjjKfvsw7Nc
         t2ul+3qAu3Hi86psQN2wI26gkUiW3bYcBA1BJHrQZ8cYaZKbsizUHauXWrDJYKXFRrRg
         qfVPUJ9LQeF12A8pWc6vY476l+jVV7O8Goe9ST5ApNN+SHWttIbYkaMPmN6TxbqsbLMe
         L2NXbX9SQVTBxDa7I9mYzkQXs3COYM12AJEu0igr5cK8ox/VS7Vr0OssZXMIEvVrb/HL
         lQeQ==
X-Gm-Message-State: AOAM530DovZ75AhMgupGt9JaheznNzriTaO/tss4FBHz3RO0ZR0EvpoU
        02vFcO4kvESaOE2bjNWq4ZcH8nCnpB6xbSN/DAa+iTfW39xUkYyw4oeOS1N+Fom84e/nv1yujUy
        p3tQr+Li4j6VBjvU5Ho6mQjLoAugVsVW1rI5SYXPSmIpit0hgy8y+ARRO7X2/RLuUejiLXCik
X-Received: by 2002:a5d:4748:: with SMTP id o8mr5574711wrs.202.1627050263268;
        Fri, 23 Jul 2021 07:24:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQYL1EwUw2+n2YspnNZJtv0xA5geEcgc8zV6Pp/liXGLyPRoKoYuVWVc0wo1y1zWxulURbRQ==
X-Received: by 2002:a5d:4748:: with SMTP id o8mr5574688wrs.202.1627050263042;
        Fri, 23 Jul 2021 07:24:23 -0700 (PDT)
Received: from wsfd-netdev76.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p2sm27182180wmg.6.2021.07.23.07.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 07:24:22 -0700 (PDT)
From:   Mark Gray <mark.d.gray@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        Mark Gray <mark.d.gray@redhat.com>
Subject: [PATCH net-next 3/3] openvswitch: fix sparse warning incorrect type
Date:   Fri, 23 Jul 2021 10:24:14 -0400
Message-Id: <20210723142414.55267-4-mark.d.gray@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723142414.55267-1-mark.d.gray@redhat.com>
References: <20210723142414.55267-1-mark.d.gray@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix incorrect type in argument 1 (different address spaces)

../net/openvswitch/datapath.c:169:17: warning: incorrect type in argument 1 (different address spaces)
../net/openvswitch/datapath.c:169:17:    expected void const *
../net/openvswitch/datapath.c:169:17:    got struct dp_nlsk_pids [noderef] __rcu *upcall_portids

Found at: https://patchwork.kernel.org/project/netdevbpf/patch/20210630095350.817785-1-mark.d.gray@redhat.com/#24285159

Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index e6f0ae5618dd..67ad08320886 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -168,7 +168,7 @@ static void destroy_dp_rcu(struct rcu_head *rcu)
 	free_percpu(dp->stats_percpu);
 	kfree(dp->ports);
 	ovs_meters_exit(dp);
-	kfree(dp->upcall_portids);
+	kfree(rcu_dereference_raw(dp->upcall_portids));
 	kfree(dp);
 }
 
-- 
2.27.0

