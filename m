Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C87572BFA
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiGMDgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiGMDgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:36:16 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340F4D7B98;
        Tue, 12 Jul 2022 20:36:16 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id o18so9322953pgu.9;
        Tue, 12 Jul 2022 20:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yVeFSkEmO64ENxp6OwJH9yQxRclVRPX/S8GoXnifoJs=;
        b=Jp0EIuguvIfT6nTpvibnF455o2Z/zMNJF/YU9QGMqMtctxixq8+XSHucyOjWjqQB2n
         +zECdCdWCb+zQZSX8jz+e/vw+FTo+VrqRYmVjVszWH2e5U++Uyc5tT/ddZHYvdX8yhI6
         IPsonz+WmHSp0VL5xz2/J53mTXgp7AQtDuatWLTmNUTevQ8iIPaAvxceyqqHEraHqFYu
         sdbODjltqC7KaZw0Y1ZMT8y1ouyEsFMX1Xp7mGCe/hHWxB66b1/HyoCR6P0TME1HMhOw
         ReR/1DVExuDOruoz/R95CTcbQucfR5VY4zyn3ByTFzTMICA8F/+3yPnU04W2qOVPKPRb
         UC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yVeFSkEmO64ENxp6OwJH9yQxRclVRPX/S8GoXnifoJs=;
        b=OC0LqYucS4iWe5bsrWc+mJl/So/kRhTk59i4gqa9m49ogXXi2KuKV5gCodZ1yAjYhZ
         SKfiLMAyljUO+qd82/gThfod9ZT5KjFtvVoBkY+HOmVVA3UbdVfeL0wQD2JTqhqgx6Ar
         ld90s9OTabV6CLa1en9oJcteIQU1hnoksOA4EJ1+WHunHQ5+Q9GhGed8KLY9JQuWuel7
         cMS1Hm3hIkBkRAZ8lU3+jGRkPZZSMLvcRKrQdja/2c5g3ORliwP1MVTu5b/1TGQVcvHT
         007icQ4djbLnr0X3EXH0jnI4u+JVG1PdEY1i2YV0a3Thynu5Jymuwp17jMHIWCL2BafE
         LRkQ==
X-Gm-Message-State: AJIora/Bnux7dMzIYvMZSYvFxpI9xro8WHcQCP0xpbdF1zv6wx9jbCBd
        o7KZRRuA5Q5xchJ58x9pX3s=
X-Google-Smtp-Source: AGRyM1vI+wluVcFYvR2WTFV2uiw4Hura3WhTgF/TWxJ+8Q2pOc6qb1PHNWWn2zoSTl80hHPro3mVwg==
X-Received: by 2002:a63:d1e:0:b0:40d:379e:bff8 with SMTP id c30-20020a630d1e000000b0040d379ebff8mr1289986pgl.215.1657683375679;
        Tue, 12 Jul 2022 20:36:15 -0700 (PDT)
Received: from localhost.localdomain ([136.175.179.221])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d48500b001638a171558sm7634084plg.202.2022.07.12.20.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 20:36:15 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     dan.carpenter@oracle.com
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        guwen@linux.alibaba.com, john.fastabend@gmail.com, kafai@fb.com,
        kgraul@linux.ibm.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yin31149@gmail.com,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Date:   Wed, 13 Jul 2022 11:35:51 +0800
Message-Id: <20220713033551.59355-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220712094745.GM2338@kadam>
References: <20220712094745.GM2338@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 at 17:48, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Sat, Jul 09, 2022 at 10:46:59AM +0800, Hawkins Jiawei wrote:
> > From: hawk <18801353760@163.com>
>
> Please use your legal name like you would for signing a legal document.

Thanks, I will pay attention to it in the future.

>
> regards,
> dan carpenter
>
