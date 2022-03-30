Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAD04ECF29
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 23:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351411AbiC3VyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 17:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiC3VyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 17:54:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9A055491
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 14:52:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so921482pjb.4
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 14:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8pN4x4urDMgILmbpfuyZgrK6rPuXHQpRBN52cyAK1tw=;
        b=jTlxh6fXzyeThgGQUNpy2O1vmk1I5LvjQT0PnDUWot9VO3fQluuKBRePIg/mQcWYMX
         3tsGtQeE0IqMjlz4hkH/hv2jWbGNtMImHQbVJZNkviadoaERc6TQWRGimG6t688ti9iY
         ktKC1iIg/KEeIkIkgVzBL4sEXJUHBzq9nqdNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8pN4x4urDMgILmbpfuyZgrK6rPuXHQpRBN52cyAK1tw=;
        b=nEWsjsKJXjrzuWYRtgQdZZMaAKiuz9kT9891/X+g4GEn6Q6CrV2XtGzmX73tZyggK8
         d+2OhB4v+gsA8oRYUunT6TXUAil0s53ogB1Av8lYfu4evxIIzLoAtTvJBJjT5LaxgJqW
         xzYmWxntFbhNjCr1lOp/cXtFcI0K9VRKV+ADG4EO7afe6qt2wOhg0h/Y2DtqQvXLXBzR
         8CIqaE0yyJK3wbQ/DHQAUwZSEgMS8JBsovui2IkFEPEj8wnXyEvm3wrzOOftX5XxwuwR
         J0DUyDV8xdvwNyuk73jm65Ki6uSouT4/FLvQMJCexEHa5ZEp7Xgy6RkDwvUzBoB1cVTU
         BEtg==
X-Gm-Message-State: AOAM531pRIkdmxdA5R16OSCEBOwj4fOGtea6ie4tQyYmkVzqvESI5ZnS
        lHrrxuC945/MWtJDEDWzK4be2A==
X-Google-Smtp-Source: ABdhPJxpYIm1yCSWRFWW5O65IjC+/QinMTcuZOT6kN3I6XJzhlGoRzyKil4e7oiuhQ7c535ifFf+sw==
X-Received: by 2002:a17:902:d2c1:b0:156:2e07:28d7 with SMTP id n1-20020a170902d2c100b001562e0728d7mr1816655plc.39.1648677158260;
        Wed, 30 Mar 2022 14:52:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o17-20020a639a11000000b0038160e4a2f7sm21464311pge.48.2022.03.30.14.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 14:52:38 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     davidcomponentone@gmail.com
Cc:     Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        andrii@kernel.org, kpsingh@kernel.org, songliubraving@fb.com,
        luto@amacapital.net, john.fastabend@gmail.com,
        Yang Guang <yang.guang5@zte.com.cn>, wad@chromium.org,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, ast@kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>, yhs@fb.com
Subject: Re: [PATCH v2] selftests/seccomp: Add SKIP for failed unshare()
Date:   Wed, 30 Mar 2022 14:52:33 -0700
Message-Id: <164867715060.3856906.16524830270315239725.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <7f7687696a5c0a2d040a24474616e945c7cf2bb5.1648599460.git.yang.guang5@zte.com.cn>
References: <7f7687696a5c0a2d040a24474616e945c7cf2bb5.1648599460.git.yang.guang5@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 08:22:10 +0800, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Running the seccomp tests under the kernel with "defconfig"
> shouldn't fail. Because the CONFIG_USER_NS is not supported
> in "defconfig". Skipping this case instead of failing it is
> better.
> 
> [...]

Applied to for-next/seccomp, thanks!

[1/1] selftests/seccomp: Add SKIP for failed unshare()
      https://git.kernel.org/kees/c/8a3d3ea66f0d

-- 
Kees Cook

