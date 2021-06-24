Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA32C3B337F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFXQIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:08:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhFXQIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xn+g4Oy4TbzIlhU9jJ2+v158p0Us5HC5PaMOKTXC9pw=;
        b=cS2MtrCEEMS6zoSnQn23Th5xwxgnkXYqKvAr2h1hxn6vfEtxR+l//CuAHRahOaQmyjnNX6
        za5eSjsYFFEHRrwx3fJ95t7Xk3Z/byT3ow11GEkux2ulRZ4Qg33CxDU7QDEaQiD07tlNIa
        B6Qss5C0GdUYy9LKK1Hwx4IpnZB6cDU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-S9ACTl_yPFaM7FhK3AXP3w-1; Thu, 24 Jun 2021 12:06:18 -0400
X-MC-Unique: S9ACTl_yPFaM7FhK3AXP3w-1
Received: by mail-ej1-f69.google.com with SMTP id q14-20020a1709066aceb029049fa6bee56fso2158717ejs.21
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xn+g4Oy4TbzIlhU9jJ2+v158p0Us5HC5PaMOKTXC9pw=;
        b=D1XEcZ2DBMW+tsMrP5xg26+m9MLsYQlEcWMVSc/OsHyRKmOSAqtzLZt1NjqtlLciAj
         Scl9oybgB68htMfFP/Wy0IglGPCcCg8E9dC4sUIr4jIoLtYHeL6EJTml/7w4r7X4MhKC
         xUyhrWg2mM3NVcfkB2389tLWCetBa9qysNSnevz33JemOh2/x8lSuLOixDRomMoD6FKE
         nhhWKuJ4AIE35hf4E5YBlndcjUi/KZeZyuuhZKjCmSv6Qrmg50yUppk8MVgcpZMM3ELx
         MtRHQ3BGijrOPmMrV9KEyB1ilLsVrewxcquDWZrohdIHC7mPKZwDV3Or3wyFoOKS1VGp
         Pmzw==
X-Gm-Message-State: AOAM533eP7sHxYOL4mi0ypf0vITckf4sTdeDd+WxpOJOkTmpMfFOSggC
        UsJjoRDzupKnbyrrEFzdHIG3Fnm4+48qK3mnUR97BIItDg0MhDrv0YVOeHCZuFkTv1cEegn/Ybe
        UBGx9tXYApPhgOO1S
X-Received: by 2002:a05:6402:4cb:: with SMTP id n11mr8118338edw.292.1624550776918;
        Thu, 24 Jun 2021 09:06:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpnYPJAzm/4qtNBc7xfhD4QoTY11++wL13HFV4VgIRqY/z6BaZza/LEmUfZUO3YnT8+UY0ZA==
X-Received: by 2002:a05:6402:4cb:: with SMTP id n11mr8118313edw.292.1624550776778;
        Thu, 24 Jun 2021 09:06:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x17sm2267495edr.88.2021.06.24.09.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 53E8B180738; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>
Subject: [PATCH bpf-next v5 07/19] ena: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:05:57 +0200
Message-Id: <20210624160609.292325-8-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ena driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
turns out to be harmless because it all happens in a single NAPI poll
cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Guy Tzalik <gtzalik@amazon.com>
Cc: Saeed Bishara <saeedb@amazon.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 3bb0e66b2c7e..44ef6b88f715 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -382,7 +382,6 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
 
 	if (!xdp_prog)
@@ -439,8 +438,6 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
 out:
-	rcu_read_unlock();
-
 	return verdict;
 }
 
-- 
2.32.0

