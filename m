Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB1D590ABB
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 05:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbiHLD37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 23:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbiHLD34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 23:29:56 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261FCA3D55
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 20:29:55 -0700 (PDT)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5C6103F13E
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 03:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660274992;
        bh=lY1KV5n+d5ZpFbygaAz+OcIJE9BFkKwpGeAuYVt7yJc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=QvH/4bjfeC8VcekESsXXuqYQ4nq8plUozOJzgc73okUAdcSj6uubrIQv8JAho95C9
         D1ollZzCTBAgz9judNrpuacPeZZI8iLqH6sV3vziyPXr5te5RqlVhzEEM2SNRfyjCI
         XSMGgoqmqbwifQzSVfrGDtcSqvsxcS8OFT3IkADcKvPh0GGAA05CdhxFk3LWc3T+Ek
         tjvUyh4E6fyOEOP8IS9eMo7bv7iN+g24AwiHzHnmDaqTHdx8C2XN91fpa9WEbW7pqE
         5uYqpsLVtdRInTPOlaVHtEO0Ozb82YE//r430GtVxYXaoG0jse/wAaYozlmseue9b4
         K8JBh/IssRADA==
Received: by mail-pf1-f197.google.com with SMTP id j10-20020a62b60a000000b0052b30f6626bso8395222pff.17
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 20:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=lY1KV5n+d5ZpFbygaAz+OcIJE9BFkKwpGeAuYVt7yJc=;
        b=Ly0KcQv7Xy1NjFPI7w1nk4laN3VO7LOPdnR9tILQuOkw6Zv7+P0iOfPUkH7j62885R
         Lgxf5AgL3FeZBYKxvU4FxgyeUDoSnzKRaVxNJqo0y4I6byRFQbhB7mRsvtQFxgi6Mkq4
         fvOQgUYz++tOTvGyVtJpVwNjzMxBXTwuBP4ufiP9Cx86a1ZE5OyQ0sZmBdknu+CEzeNi
         88QbppeYHVIV/2IL1Nj8h0u+MIQh53VsngsBT7AchuxURJvm72wVUAM91f/9Snj9CIMm
         +Lf1081Jnq0zweRiBuMAlCec/5yRpBx07xKGYrMhXfvII1k6mNXbet8RON1mlb1F2qfd
         FQdw==
X-Gm-Message-State: ACgBeo0mIqzVafcO45Xe5yQljs0XTnKmOGkGRkf//gI3gLaIVqtx3uoz
        0km+guwFSTmyax3iCzyOAEAwa0av9pc1ub8erTVkjQI7mnICm7KIareBSKXBMK83j47SUl+JziH
        yrMSaTvjYUmUbdlZPs+pICLbgDzmLpExTLw==
X-Received: by 2002:a17:902:8b86:b0:170:d739:9a35 with SMTP id ay6-20020a1709028b8600b00170d7399a35mr2118816plb.35.1660274989364;
        Thu, 11 Aug 2022 20:29:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ZcN5tzJ9ceO68Lj9niDNDPtdHQUSTEps4e4+GC16mdOfmTiQNYrKo2eCELu0bCfYN2VYGmQ==
X-Received: by 2002:a17:902:8b86:b0:170:d739:9a35 with SMTP id ay6-20020a1709028b8600b00170d7399a35mr2118799plb.35.1660274989125;
        Thu, 11 Aug 2022 20:29:49 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902758400b0016d62ba5665sm434360pll.254.2022.08.11.20.29.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2022 20:29:48 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 3FFA96119B; Thu, 11 Aug 2022 20:29:48 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 391939FA79;
        Thu, 11 Aug 2022 20:29:48 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] bonding: return -ENOMEM on rlb_initialize() allocation failure
In-reply-to: <20220812032059.64572-1-jiapeng.chong@linux.alibaba.com>
References: <20220812032059.64572-1-jiapeng.chong@linux.alibaba.com>
Comments: In-reply-to Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
   message dated "Fri, 12 Aug 2022 11:20:59 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1826.1660274988.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 11 Aug 2022 20:29:48 -0700
Message-ID: <1827.1660274988@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

>drivers/net/bonding/bond_alb.c:861 rlb_initialize() warn: returning -1 in=
stead of -ENOMEM is sloppy.

	I'll disagree; the return value is only ever tested for being
non-zero.

	-J

>Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3D1896
>Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>---
> drivers/net/bonding/bond_alb.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 60cb9a0225aa..96cb4404b3c7 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -858,7 +858,7 @@ static int rlb_initialize(struct bonding *bond)
> =

> 	new_hashtbl =3D kmalloc(size, GFP_KERNEL);
> 	if (!new_hashtbl)
>-		return -1;
>+		return -ENOMEM;
> =

> 	spin_lock_bh(&bond->mode_lock);
> =

>-- =

>2.20.1.7.g153144c
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
