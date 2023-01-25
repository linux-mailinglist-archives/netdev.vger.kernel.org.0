Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBC667A9EB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 06:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjAYFVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 00:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYFU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 00:20:59 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF4830195;
        Tue, 24 Jan 2023 21:20:58 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id 5so11571185plo.3;
        Tue, 24 Jan 2023 21:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0wqobX42+jPft4wi+d49pOlp4pavL14KKEXI/auMKM=;
        b=MANr6L36u1DHBHZmstTrNb+y1pPFozpf0LFzQRjOP+y5dLGM2GgJ9QgXaQSwu1XxVq
         lnJP7hyIBmPpQJyMdohDT2WvXYzCpSLUgJ90aIBROgyP4yLe2tYKd4MkxQ93JuDiYOtP
         WIofjtAdTqV1N9ugk0SzFN9aQ30yxO90O//7en9b7C/MXFg5Tcga8Z/UABdO10RQZAa+
         8+eY1qYYT7kXRCSJOgrgNt9JtmemYNgmroqA5Sl/066N0R7QqcHPDH0Zsacrj7AuBf7n
         ZpwZ0iWsaXiTJbUAodg3E2MTWM1KfhLTeOsBp0UfRQM7pXlAcHN3QjDUDPQyL09DQ4mJ
         pg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l0wqobX42+jPft4wi+d49pOlp4pavL14KKEXI/auMKM=;
        b=LOVxXuqH18j2oA7nNTVvhB4m+bGCkaoMYta77X8Ms0gPcEOZ/slwIXJyC8SdFtb+2i
         GNQiuxSEMz2VJ8x2R/atzxg9ZLJT+6/1KpTSs8haGvd605mvOkjbvizVWHhaNrgmwPp7
         MZTWKlNHPcUjYgMrmdMeWmv9KzbUFhL0RJJGYE3afdUrtWeXHZatqXYOSRjlwACV9wAS
         2n1ouh7qQhAJ1KIqROBmOUqHouCr6Sfx8wZkv/wukT8N0MmFQYHaBy3m8wLq75abEe8F
         gdRc/W7h3CH9HVy39kD59h6BavrsJSpk5K57apTR1x8O2VAyPCXnS3qMp2kNnZXMlTRF
         qlZw==
X-Gm-Message-State: AFqh2kqFkw3+t9gwAi74rBcOl977wfdfUnoVz4grxQR1Mo7vdB2WbCJW
        2P8BzXfXQLqXApDcuF56qfQ=
X-Google-Smtp-Source: AMrXdXs2mGzaDF7W2ejZry1cuP8hXZOrWooldPFTeHDTcSyJWfju2vtuZG5iJpxiofhDhkxShmn2mQ==
X-Received: by 2002:a17:902:7049:b0:194:c241:f604 with SMTP id h9-20020a170902704900b00194c241f604mr24866919plt.57.1674624057892;
        Tue, 24 Jan 2023 21:20:57 -0800 (PST)
Received: from localhost ([98.97.33.45])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902849200b001754fa42065sm2596350plo.143.2023.01.24.21.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 21:20:57 -0800 (PST)
Date:   Tue, 24 Jan 2023 21:20:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Message-ID: <63d0bc37484e8_641f20813@john.notmuch>
In-Reply-To: <20230113-sockmap-fix-v2-1-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
 <20230113-sockmap-fix-v2-1-1e0ee7ac2f90@cloudflare.com>
Subject: RE: [PATCH bpf v2 1/4] bpf, sockmap: Don't let
 sock_map_{close,destroy,unhash} call itself
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> sock_map proto callbacks should never call themselves by design. Protect
> against bugs like [1] and break out of the recursive loop to avoid a stack
> overflow in favor of a resource leak.
> 
> [1] https://lore.kernel.org/all/00000000000073b14905ef2e7401@google.com/
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM and warn once logic should be fine IMO.

Acked-by: John Fastabend <john.fastabend@gmail.com>
