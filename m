Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709883D3BBF
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhGWNoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:44:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235351AbhGWNnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 09:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627050264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LgEGRf0r9pG6iGueMngVEeX6+gNDsBolpxeUHq/dBWY=;
        b=MlWK9enDEUVwaEpVz8QJmfDQ+0vrzAnhD+fhA4HotsWnvdI/Z+4uCd8H/fXJUimKdK/wA8
        gi9UV+H+MK537wrVSpqodmcHQRD3EFQ0H6QFAePKNcawpFFLh/5zWaj04IXS/dqhj2EjUw
        lb3aDjXDkTNeG4Lqz30/9UmvG11BE2I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-6HDV_Ld0O4Knsvl6k8HOiA-1; Fri, 23 Jul 2021 10:24:21 -0400
X-MC-Unique: 6HDV_Ld0O4Knsvl6k8HOiA-1
Received: by mail-wr1-f72.google.com with SMTP id s8-20020a5d42480000b02901404c442853so1045075wrr.12
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LgEGRf0r9pG6iGueMngVEeX6+gNDsBolpxeUHq/dBWY=;
        b=EGhdXr7tAdOR80wa+hwmKejnfn1Bc2dWbQG4azJXTh731Co0eoNXW9bW7q+UUFrv+f
         GscQc6NeVqmyvgYhVR3T+RlHi3FzyiA7hKKRZNeCUNyPsSsmT1TNOcI70uE/GNQRlWGT
         OicgT+i3rxnm/FfvXp60zTjWrG5yCyaajst96O5lMZOKGUXEUOed6jBEvzJcxIcMbvns
         PKRYO5V96YSeFvgmGOf894Sn1N/tKhKBVcibAy5Efv8BwGMy1sBMS/Hu9Ok70Q87WvIp
         Ahbt2YickfzHyRWsJYRlcEY3+0zwD8UpMLbldGZZqhz4XNvZ2T8hL64W3L3B9EVhHeF2
         Mf/Q==
X-Gm-Message-State: AOAM5327whKXBFj4AmGrf2i0In8eJ4QrhlEpP4/wcaYt96iTo1LcNfPa
        bTwgWzjSy4RMDLRAveycZPUw2F9ODK+TAS+Sq3CCYdF+Eu2wJ3J/r1rPdJjyQ1l/KFmPzp2LNgx
        F/T6Y7Lg7HDQGsLCaMg/bZz3CnRIvw9AivXz7lHQeXvVTxj4t3pBno9XC7pWOBr7v4Q5lGodP
X-Received: by 2002:a05:600c:198f:: with SMTP id t15mr2991848wmq.60.1627050259836;
        Fri, 23 Jul 2021 07:24:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDijy+ap2y/5URC3wgY6NeZfXoUcXHiZHxJ8JounJ/mno/fnufOwj8SJXCA+qzUV+6c0HhRA==
X-Received: by 2002:a05:600c:198f:: with SMTP id t15mr2991829wmq.60.1627050259650;
        Fri, 23 Jul 2021 07:24:19 -0700 (PDT)
Received: from wsfd-netdev76.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p2sm27182180wmg.6.2021.07.23.07.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 07:24:19 -0700 (PDT)
From:   Mark Gray <mark.d.gray@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        Mark Gray <mark.d.gray@redhat.com>
Subject: [PATCH net-next 1/3] openvswitch: update kdoc OVS_DP_ATTR_PER_CPU_PIDS
Date:   Fri, 23 Jul 2021 10:24:12 -0400
Message-Id: <20210723142414.55267-2-mark.d.gray@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723142414.55267-1-mark.d.gray@redhat.com>
References: <20210723142414.55267-1-mark.d.gray@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
---
 include/uapi/linux/openvswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 6571b57b2268..0e436a3755f1 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -70,7 +70,7 @@ enum ovs_datapath_cmd {
  * set on the datapath port (for OVS_ACTION_ATTR_MISS).  Only valid on
  * %OVS_DP_CMD_NEW requests. A value of zero indicates that upcalls should
  * not be sent.
- * OVS_DP_ATTR_PER_CPU_PIDS: Per-cpu array of PIDs for upcalls when
+ * @OVS_DP_ATTR_PER_CPU_PIDS: Per-cpu array of PIDs for upcalls when
  * OVS_DP_F_DISPATCH_UPCALL_PER_CPU feature is set.
  * @OVS_DP_ATTR_STATS: Statistics about packets that have passed through the
  * datapath.  Always present in notifications.
-- 
2.27.0

