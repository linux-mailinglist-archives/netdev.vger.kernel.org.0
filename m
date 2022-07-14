Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D4457441F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 07:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiGNFCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 01:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbiGNE77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:59:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91881F604;
        Wed, 13 Jul 2022 21:56:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id y14-20020a17090a644e00b001ef775f7118so7195258pjm.2;
        Wed, 13 Jul 2022 21:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3XqwSVcbb9SNK7x/sWrwPwBFr5F6BGp/JwEon2mZrVk=;
        b=P348rrdn7T5kYz2X3RAIhcop6zscRlqzSFEJfvHz/EHDUg6n4TmF493nncgb39jhki
         +1UHrhqCw0l+g/L7AiFT7GcpLcNUOXSgWjA5esYQXGMsElssKWWuOA3ZRnWcOM6tTXag
         Jhvmf7ZbLlX5tylcNA9sN7TaDUYVM89FxySn/XqsQJEgY0fd8LJJBERWr3+WSUx3qG2c
         he5YEy3dn4XY/nYQGbxJ4qkiJIsnIl6BcX6s6RJbIGGMPUV2uz3acqDFzAICd7DjA491
         3VYK8NkcdCVc/QaxvEaD4SivsyBntGKbc8qrZeHoQ6W3lgEB39fPifWbC6e4Es+W7hBM
         bjwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3XqwSVcbb9SNK7x/sWrwPwBFr5F6BGp/JwEon2mZrVk=;
        b=TGNAPg1KBFH4SNsMiUBMcIxYkacKGzqNUpo675ceYe5mQ1AFA9LalqhfU0/iz/XBe7
         NCr7r5gZWu3+IoUzoPPx8uGcQrpfe3DWcZf5jVfA7LgY3sqCqLZbYgsT3khFLeOc2wrR
         6G3ka7YHKeg6MJIE+//BP2GGuh5cOm4tjqyEr2xR46R/LyCSORXA9wvC+bVjH6KUf93+
         LZWZQnNO2xRLyIlIA1JCTRohna/wcViGHLlpw4V2+YyaAnlEnEQg7HO2jPJ7t8Zj9NAL
         dcO+m7C6hrIIojgva430sH0FB52byUfFQdDlrFPS3cjp+J43mrviBzKZcA6/eNW0x6xF
         lIHA==
X-Gm-Message-State: AJIora+szPWD9JYZCb5RJGX48aCLTxbboqckLv05G8/CT+BZ96ZejGvf
        iLxYzSqahfd/cK7cRSOBWN4=
X-Google-Smtp-Source: AGRyM1vR/ayn5IWrvE2UjQQvJ4olCUUXwUgyU1CWXvJDfOEua9aBkb2D/f/KyZLEmhAev2NyHEDc2Q==
X-Received: by 2002:a17:90a:c088:b0:1ef:b85c:576b with SMTP id o8-20020a17090ac08800b001efb85c576bmr14203728pjs.237.1657774602374;
        Wed, 13 Jul 2022 21:56:42 -0700 (PDT)
Received: from fedora.. ([103.230.106.53])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709026e0900b0016bdd124d46sm320845plk.288.2022.07.13.21.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 21:56:41 -0700 (PDT)
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     chuck.lever@oracle.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        yhs@fb.com, syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com,
        Khalid Masum <khalid.masum.92@gmail.com>
Subject: Re: [PATCH v1] net: Add distinct sk_psock field
Date:   Thu, 14 Jul 2022 10:55:17 +0600
Message-Id: <20220714045517.185599-1-khalid.masum.92@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165772238175.1757.4978340330606055982.stgit@oracle-102.nfsv4.dev>
References: <165772238175.1757.4978340330606055982.stgit@oracle-102.nfsv4.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 10:26:21 -0400 Chuck Lever wrote:
> The sk_psock facility populates the sk_user_data field with the
> address of an extra bit of metadata. User space sockets never
> populate the sk_user_data field, so this has worked out fine.
> 
> However, kernel socket consumers such as the RPC client and server
> do populate the sk_user_data field. The sk_psock() function cannot
> tell that the content of sk_user_data does not point to psock
> metadata, so it will happily return a pointer to something else,
> cast to a struct sk_psock.
> 
> Thus kernel socket consumers and psock currently cannot co-exist.
> 
> We could educate sk_psock() to return NULL if sk_user_data does
> not point to a struct sk_psock. However, a more general solution
> that enables full co-existence psock and other uses of sk_user_data
> might be more interesting.
> 
> Move the struct sk_psock address to its own pointer field so that
> the contents of the sk_user_data field is preserved.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

The patch seems to fix the syzbot bug: 
[syzbot] KASAN: slab-out-of-bounds Read in sk_psock_get
Reported-by: syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
As the reproducer no longer triggers the warning.

Tested-by: Khalid Masum <khalid.masum.92@gmail.com>
