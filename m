Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A01067A9F9
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 06:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjAYF1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 00:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAYF1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 00:27:42 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B22422DC4;
        Tue, 24 Jan 2023 21:27:41 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso919371pjf.1;
        Tue, 24 Jan 2023 21:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bhprMAuemk+eh+KpYy16rh1sP3lhIZAgEc14EY/ZdhI=;
        b=Hlt67mgy/qitfayYabQVt5PYwLe+xwAiJQ9lOnHzjRWmp147bqBB1bTZPHxnH6ONNG
         gIFZYRTIFmkq0J2+vk3cE/w5BWt+d71HAXuYjrbLO603Ylsnc3zfr900DL0beuyZcHYu
         eVP7QWWlaz1nCyiiuGboDQ+2UMNabYvxNLDwLXUiLFIOwlWFT8rFeK0DwwwAy74yyicu
         5DHN81hYFR8ZpDMkwy5Er8rt0s9rnCtMkMzYSyEFbQTj4Xqtr/uUREdRLGKxhIo4VpUO
         4Sk4dc61iWHDRsw2K+J7ceyXh3zU/ncup7dH5uVqOcLPNxbg+7vUnqwxn+b8oAC6Rm+w
         CkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bhprMAuemk+eh+KpYy16rh1sP3lhIZAgEc14EY/ZdhI=;
        b=GUh3PeG3hnu+cCyLdwb4TKmTZMXc3a42m3YA0+0iqWUSaJc1WlLrYdLYTR58IlHEN+
         YjCbhkETXuTHDuvf0QhuwkuAZYPsP/VkidQA3HTZpx4cotdBsnhdyCrj3KO60d5Y8eT0
         AHENWZzp69v/76z78+VJ++FrMsAT7UVXKAPkhehm9Y90qrjkcscga3zmOVS2OLCqVFrg
         FojD5SrOaf0SW4X5sqo3tidCq13W+0rM7rCFgms9+ERZu7CVhutEY0LWHm1KuRs8dQS7
         zcQWieqYWauYxfqvGQkTeivcAeJTyaF7ltS8+w1UEl3DAkPlIqJFqVGgTcg4yksh/3/+
         Bwmw==
X-Gm-Message-State: AFqh2kqevfeoRHOGZjf19cGsZo4cvcfae7gC84VWF1kzY5lAjRRRU8Sa
        /+DJVkAldB0PnBSmmwrCJgAVWs8mb9w=
X-Google-Smtp-Source: AMrXdXvV27PJ/sKiL9xJjW3GLotLVohOVWVUajlUFNoaoSuWTbD51hzVrbD9MedFtdo4vZs2MYWxiA==
X-Received: by 2002:a17:90a:7e8d:b0:228:f893:bc4d with SMTP id j13-20020a17090a7e8d00b00228f893bc4dmr32159755pjl.23.1674624461035;
        Tue, 24 Jan 2023 21:27:41 -0800 (PST)
Received: from localhost ([98.97.33.45])
        by smtp.gmail.com with ESMTPSA id gz16-20020a17090b0ed000b00223f495dc28sm536330pjb.14.2023.01.24.21.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 21:27:40 -0800 (PST)
Date:   Tue, 24 Jan 2023 21:27:38 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Message-ID: <63d0bdca5fe7a_641f208c5@john.notmuch>
In-Reply-To: <20230113-sockmap-fix-v2-3-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
 <20230113-sockmap-fix-v2-3-1e0ee7ac2f90@cloudflare.com>
Subject: RE: [PATCH bpf v2 3/4] selftests/bpf: Pass BPF skeleton to
 sockmap_listen ops tests
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
> Following patch extends the sockmap ops tests to cover the scenario when a
> sockmap with attached programs holds listening sockets.
> 
> Pass the BPF skeleton to sockmap ops test so that the can access and attach
> the BPF programs.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
