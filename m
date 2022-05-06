Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7F251E08C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345367AbiEFVDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444045AbiEFVDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:03:22 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D0D6EB22;
        Fri,  6 May 2022 13:59:14 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e15so9373154iob.3;
        Fri, 06 May 2022 13:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Nq1jhHTyUB0btWPNhxYltvYS+C1e550wDIkKCw2n7r8=;
        b=lkHY4dcyhn0aLJYJtjuECXL00hq+a5aXvIQuS07AUtCk2pp5v+kL+zQEv1IEnqjjOO
         mtbYsn1zwyFOUBBHPbiyHe+ysF5d7YabJD4V1h7rI2vrhjl8PZT8tncjWgYlcDNbgzsw
         fQquVpRC0FSG1QjbxEgS6kiYOuBEsRlzr5ViJRgYEz3ng2GKTXX/6ca+jlEFEZZ2izsV
         LvDovelBQEfAtvAkBH9OFhQv2LE7P263ta2DxvdRwfGIYj9qxD450fMUpweD7thuZUZG
         nlm9B0P+ILI+t8zpOtHrON123wiBek/ha99cInddIIQ29URp1shIyEDKAphV7Vall/0G
         8iKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Nq1jhHTyUB0btWPNhxYltvYS+C1e550wDIkKCw2n7r8=;
        b=u3e2/5/leqs4ruLepg9do9r9MX2qYJtEmTQEosIP28Q3PJX5CheH1hLSTmRx0DCHJL
         1/b308ZTZj7gX5W5tf4H6LtIJgVt7teVk4hsbCL0H8QO69lFOkMzHysJHOr9RnkASCJu
         vo+VFfyx7xWaLIA5s45JJL3QNpUJv5fS2hdQptcJeAMnL5TFqPAFNbQCubwd4QsUUsbl
         TxZ8MRgnv2WP+DThQ5OmMs3wItyeBtSemtHg5+/dZuiUKWE7wZmuGeC/x0smQDRi6/QC
         R2X18sqPONYWwF6iSuu9z6+itHrlsq+WUUQANLeEj2grQUpuIt2r7LBKPpVWgQurDIcC
         hIWw==
X-Gm-Message-State: AOAM531LxwroQnXVnZebd76yU9J/qUxsaSZqyQi5u79vRP36YJ3wp7hs
        otiFlOpQuB/CW8oMlrTDacs=
X-Google-Smtp-Source: ABdhPJyNAi7sSCmw+K0BxgixB4ZYe/BbE15nYIBlfT3Fjv26X5cL9B+ZFQMdx+YQ0c+0dwiyNeXZJw==
X-Received: by 2002:a05:6638:502:b0:32b:8c53:f737 with SMTP id i2-20020a056638050200b0032b8c53f737mr2223887jar.121.1651870754254;
        Fri, 06 May 2022 13:59:14 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id b15-20020a5ea70f000000b0065a47e16f5bsm1485608iod.45.2022.05.06.13.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:59:13 -0700 (PDT)
Date:   Fri, 06 May 2022 13:59:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Message-ID: <62758c1abea39_196b72087a@john.notmuch>
In-Reply-To: <20220429014240.3434866-3-pulehui@huawei.com>
References: <20220429014240.3434866-1-pulehui@huawei.com>
 <20220429014240.3434866-3-pulehui@huawei.com>
Subject: RE: [PATCH bpf-next v2 2/2] riscv, bpf: Support riscv jit to provide
 bpf_line_info
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

Pu Lehui wrote:
> Add support for riscv jit to provide bpf_line_info.
> We need to consider the prologue offset in ctx->offset,
> but unlike x86 and arm64, ctx->offset of riscv does not
> provide an extra slot for the prologue, so here we just
> calculate the len of prologue and add it to ctx->offset
> at the end. Both RV64 and RV32 have been tested.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---

Looks reasonable to me, but would be good if someone with RISC
knowledge takes a lookt hough.
