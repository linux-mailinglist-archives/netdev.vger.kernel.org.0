Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D7065C9BA
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbjACWjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbjACWju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:39:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923FBD11C
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 14:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672785543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZSxVsidlURjfCTf/sklHgcAsOaFB54//b7lhu9c7Po=;
        b=S15fQivPYpXJyj0+lX7TnFsUYf8helSLE+ybgeVnaz8OZwX7lEz1SL1EIRryeWuuUKyZZC
        XoxUiGn0FGl3yterVpLyh0tPKONDfGXNh7LVZadl/W7iAoPIrSdTq2KN68rz0hpWaxVZey
        +NLvpilZ8GAYp7yQEXeJaHU/5PHjtk8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-XoJpvSZFPZ6emIC44UsUYg-1; Tue, 03 Jan 2023 17:39:02 -0500
X-MC-Unique: XoJpvSZFPZ6emIC44UsUYg-1
Received: by mail-wr1-f72.google.com with SMTP id w20-20020adf8bd4000000b00272d0029f18so3421434wra.7
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 14:39:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZSxVsidlURjfCTf/sklHgcAsOaFB54//b7lhu9c7Po=;
        b=KQ3kEQ+Db1ND/ehs2TziQ6Yj2X3VK17m85rUBepZv7oj4biHyxVLQ+jc08bro7Q3i1
         b38iaMuDhs1PQ21/YlPXM0qIg6SEtkcFhdhxB34NoEgCFMwKnaS43aeirgzrkCbscc5t
         GoRAyU5p7yR8qoRx0B3ayZDUapPoSXnK0iesfqmfjIpfhb4THd2OjqKG59DDVO4Yzbuh
         8wr/CtMF7UfKRKy6GiZP2DrJ5voCk+qwHwxYtM2TnghbDM54UstwyKIsE9ohikTC0p8k
         jvSyogGqxHWZju8wtZoiwBEMHCsaOBkewaLgqSoxqyRVvuIwRH0hQdD4c0OLUtyWUOeU
         g9qQ==
X-Gm-Message-State: AFqh2kqYc8zvI6qLUGzc06J+hkE2NaWJLIw2KUEk85IVy/Oqrl9ziooF
        6WZ50fy3eeCCZJafMejwsn9AH29uzk1vbKP3VIfpi1rqhvQrxGPFP4bgUZjsW+Dw9XJxYbxO3Ls
        gOx5DtMiadiBXboE/
X-Received: by 2002:a05:600c:4f83:b0:3d2:3f55:f73f with SMTP id n3-20020a05600c4f8300b003d23f55f73fmr32383696wmq.8.1672785541215;
        Tue, 03 Jan 2023 14:39:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtjYDSYmjOr8KdInXwXMxZ68TMoyVCJRO5A9yjLblcaYACf4AX/Suu7VAiG05N6u9S3+ruW+Q==
X-Received: by 2002:a05:600c:4f83:b0:3d2:3f55:f73f with SMTP id n3-20020a05600c4f8300b003d23f55f73fmr32383687wmq.8.1672785541040;
        Tue, 03 Jan 2023 14:39:01 -0800 (PST)
Received: from debian (2a01cb058918ce00dbd9ec1bc2618687.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dbd9:ec1b:c261:8687])
        by smtp.gmail.com with ESMTPSA id m185-20020a1c26c2000000b003c6f1732f65sm47686532wmm.38.2023.01.03.14.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 14:39:00 -0800 (PST)
Date:   Tue, 3 Jan 2023 23:38:58 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com,
        Benjamin Coddington <bcodding@redhat.com>
Subject: Re: [PATCH net] inet: control sockets should not use current thread
 task_frag
Message-ID: <Y7SugtXYKCnE0gFg@debian>
References: <20230103192736.454149-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103192736.454149-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 07:27:36PM +0000, Eric Dumazet wrote:
> Because ICMP handlers run from softirq contexts,
> they must not use current thread task_frag.
> 
> Previously, all sockets allocated by inet_ctl_sock_create()
> would use the per-socket page fragment, with no chance of
> recursion.

Acked-by: Guillaume Nault <gnault@redhat.com>

Thanks for the fix!

