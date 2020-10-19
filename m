Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EC2292455
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 11:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbgJSJH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 05:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730093AbgJSJHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 05:07:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D8BC0613CE;
        Mon, 19 Oct 2020 02:07:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a1so5317220pjd.1;
        Mon, 19 Oct 2020 02:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BTdIvCYY2ACQ9hUso0JLIbSbpqDhsm4trrDjhU6YtoM=;
        b=TgfKtM7gfws12vxqSsJUC1j2dgqbKLKXG+aP15a0PYSPfiHJZBppN9qUVnnSVC/VcR
         2swdEkQNfInRBX20eaNIuk8kY5aKZlm9COvzQXhJN479vOp2BjM9n6DsvTqKfhcKJuAL
         37XvERUXuIfG2rySsw/2MN3rqr59qH5CKIMlAGC+X0TKcQ0hy4ZCVYaHFrRO5j/VwZ/C
         Bv3Mf408rHWBgUDfDHJ+NCELUns45SczHTgaVPeYEvW8ShFYlDJfwhRdkRAfqLEk525o
         SjWJF7OTAvKketeQKYc8oF9ZUXeO2t9DL/W81ndc+Pa2FsgfcAQwkvaYMSR2LZK4aIJO
         wWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BTdIvCYY2ACQ9hUso0JLIbSbpqDhsm4trrDjhU6YtoM=;
        b=VU8XxIYKOx8CY406p8N4FxmeeHisRE6jiW3mb3s6OFaf7eZ9tQhd4ZDTnCizTQjByQ
         1gWnY+NkC8OGPcCgAfHxLvUA9r7UQb0UJ6HH+XtkQGdf2KA8ME+d0Kq5c79VvVfeSw+b
         THvHRKgupuTiK6NJIALrLMJRq3JI+z/qaEhxT+4PeXHfIpHUWSZOJCtz1fEyYuhpTiq2
         jjR1aH9ktlYPjc0464sFV1R6PjYO4jnAMfqv9tbY2usBVF4zRnjUDo7jDCHcqsTFwM4C
         WnXnJVA1U1wCP/hwwYTRRxxGg4Dwj3v3COWucsikKU/zs9SZbJgHex3JS1LorZ8bjcOv
         wViQ==
X-Gm-Message-State: AOAM530YlthKmtEVZQrJ/YlXh0tP4fVW+bP1hlCrBXQ9w0LCNqWIu2/p
        UuTlgCVsHNSoh6ufzMR67OTkl55VlWg=
X-Google-Smtp-Source: ABdhPJy0+CVlS3XOpiOvw1GDjffymAMgu+r9sf7UEQHEZp3w7oKRO383u8Rrymz+ZX8hwFFzqJZO5A==
X-Received: by 2002:a17:902:bc47:b029:d3:f1e5:b629 with SMTP id t7-20020a170902bc47b02900d3f1e5b629mr15740113plz.51.1603098444781;
        Mon, 19 Oct 2020 02:07:24 -0700 (PDT)
Received: from ZB-PF0YQ8ZU.360buyad.local ([137.116.162.235])
        by smtp.gmail.com with ESMTPSA id e1sm11263016pfd.198.2020.10.19.02.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 02:07:24 -0700 (PDT)
From:   Zhenzhong Duan <zhenzhong.duan@gmail.com>
To:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, mst@redhat.com,
        jasowang@redhat.com, Zhenzhong Duan <zhenzhong.duan@gmail.com>
Subject: [PATCH 2/2] KVM: not link irqfd with a fake IRQ bypass producer
Date:   Mon, 19 Oct 2020 17:06:57 +0800
Message-Id: <20201019090657.131-2-zhenzhong.duan@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201019090657.131-1-zhenzhong.duan@gmail.com>
References: <20201019090657.131-1-zhenzhong.duan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case failure to setup Post interrupt for an IRQ, it make no sense
to assign irqfd->producer to the producer.

This change makes code more robust.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce856e0..277e961 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10683,13 +10683,14 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 	int ret;
 
-	irqfd->producer = prod;
 	kvm_arch_start_assignment(irqfd->kvm);
 	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
 					 prod->irq, irqfd->gsi, 1);
 
 	if (ret)
 		kvm_arch_end_assignment(irqfd->kvm);
+	else
+		irqfd->producer = prod;
 
 	return ret;
 }
-- 
1.8.3.1

