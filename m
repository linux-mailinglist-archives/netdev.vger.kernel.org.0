Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E434DA910
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353504AbiCPDwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353510AbiCPDwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:52:10 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEDA5F8FB;
        Tue, 15 Mar 2022 20:50:57 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id r11so1014240ioh.10;
        Tue, 15 Mar 2022 20:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2YWxnhGUr74RaA4Fgl+4zc1b50wr4mfFgMA+iq41ak4=;
        b=o/lz198jRvsibNYSqyw3ViIzpHrrgK9q6aYamrFp9Jfp4zWkxSLpU9chGHYWYC0v8A
         8E4ieefk0+31bTHvQUElhD5/JpzBWMfIiuzc45MNfYb3sXbVZb9qoXgXWMUWczsVZwto
         waIH0lLisRW62rByXg9hWAMTwC2OGoEakIezCj6fl7vq3duUqjFn3M/Dg3UvdAtwIhEW
         YpHJwhUuNhL2gmT7Ib5ESD9dn+X9X0x3kU/xyqdw8WgSssArH4xwRCILIVc1bvmy8rBw
         yPu0KRj8P4d8TcFkrWUHz5tpgnx/MTQNRfBLrkP54eARSwXcW1B+zJrCKmtTvNd16Fqb
         RVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2YWxnhGUr74RaA4Fgl+4zc1b50wr4mfFgMA+iq41ak4=;
        b=yoIM55yBWnppnuOssGMmZM3+chfYIczboh8Xe68hBm6bJJzIefR1F/pVH2SUfTPTgQ
         BVmJP1nEGHesOpeo5k7K/Y4E1oQqccb6nQsf788uye/ydSKGBfAMnHFO1MFHs0ppPQMQ
         zUza5rLqy4ZG6X6MgJlyeTx7g0ifGuY8auo8ku3xZrHNDhRXLtX3s946pt1/oDpvy1cT
         WfR3RhM7bp9LBxXde+IWHeCYcXMby2ZDKxt8cQ5Bbb9kKzSV4pgqxnPpqJDVYPWScCBd
         0Z86UMw0YB9xIWJeXwaEG248xcJ6YYsuMoShSGAzhI4lHMqTTftDyPzR00S5yNhU0wLD
         htdw==
X-Gm-Message-State: AOAM531efFg5KqkYQavM7DdEkBfo4o2mOk5nDbxR7U3GcfOVcj6ZIxjQ
        shiTiscLv4gp88Kmdx6uRc8=
X-Google-Smtp-Source: ABdhPJwwAp0GszTQYy7vNBG0qrRUvl6Ugq29iZ5kHySCCaseDTpZvwEIZ2uk97Sgfla93mx8LzSzMA==
X-Received: by 2002:a02:666b:0:b0:31a:104a:c484 with SMTP id l43-20020a02666b000000b0031a104ac484mr6114487jaf.172.1647402656568;
        Tue, 15 Mar 2022 20:50:56 -0700 (PDT)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id l1-20020a056e021aa100b002c790f388c6sm531750ilv.77.2022.03.15.20.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 20:50:56 -0700 (PDT)
Date:   Tue, 15 Mar 2022 20:50:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Message-ID: <62315e99df50b_94df208c8@john.notmuch>
In-Reply-To: <d5dc039c3d4123426e7023a488c449181a7bc57f.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
 <d5dc039c3d4123426e7023a488c449181a7bc57f.1646989407.git.lorenzo@kernel.org>
Subject: RE: [PATCH v5 bpf-next 3/3] veth: allow jumbo frames in xdp mode
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Allow increasing the MTU over page boundaries on veth devices
> if the attached xdp program declares to support xdp fragments.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Thanks!

Acked-by: John Fastabend <john.fastabend@gmail.com>
