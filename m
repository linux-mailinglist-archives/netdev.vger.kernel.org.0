Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C08F526F1C
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiENCeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 22:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiENCeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:34:09 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7400C3320A2;
        Fri, 13 May 2022 17:35:02 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id k8so8585165qki.8;
        Fri, 13 May 2022 17:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s1kbN3Mmp5+Lk+oKdZJFTs+4qDj5+hrlbzkKJ/sOC7Q=;
        b=L4Eo5SzXtcXZ1ZqgmcB3pFT6peaQuEjTQW8XHbdAPbGuRrJ32T+9GFmpLfV3NZzuMU
         R4NTESVE2tQ31Tn/FKWcyQ6npgdqmzNHSaMiQIHmXy0EXJT488qBHi2PkEmYH/32GN82
         IesAw3ivYOxpYN7Ae9P8fd3fkLZ3VQk5LwgdRZCgKTaLXsNR5/pMkZbbQ97uqyvXa99D
         aYGzwgrr4jcXKVlQnlGPKWsEEANe0HAIbzGJPCFy0lnhdcBXXz4tCUbzrCFT2KXSlLpf
         yrrRAAC7mzN7FGJ1nT3fOT3w0Jou5QvjaToBuSXvXU7Nmj2EbESLRuEMPClKMUI/sH/y
         H5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s1kbN3Mmp5+Lk+oKdZJFTs+4qDj5+hrlbzkKJ/sOC7Q=;
        b=TUypximYlx4uioOsq+3JVPw+FGCpnX5OF33vkA9i4WBTx91qWmMgPB+5/JpY7ZuWLC
         sek5tla4hHfglgXO8tkfE/v8mdmGj8uLrIF9Q7EEnFj8wmIPS2MglQbgy/iuu3It4cHV
         eZvImiOOCYP+2+WZqTvvpcZC092DdpB2px4yGg2Fjk0jP1f9LjqjM5cryWPnEYp2mG2g
         eoHcROlw2HQe9jwK9zkUR+dp0t70FpAODi6z/GZTCvsLjz/n1vqLkLi7we05MBk2Vt12
         n5o0lM8s1byuMNi+cDtTxjlqQkN4WgRErGkOvWzZt1EFHFtBdttSM6iVsvnnwzkOLTw8
         MJyg==
X-Gm-Message-State: AOAM531nyZ6BeLcsOMtwP7YwIBeTpKbJPh3DqiPPas5NZlJ3/PsBq+Sa
        tNYKE20HPk0k/5lBXcu0MOwfiPQs3FTFSmWy9cuQ9bynuPc=
X-Google-Smtp-Source: ABdhPJwfXOPE01/yRywnhBxbSsxVVjM3bYlxPufGQhDRtonP1eQsYBGqhDjggwn/0i+bSSSXMd+uK6TB9UbVmkSUHEE=
X-Received: by 2002:ac8:570f:0:b0:2f3:db0a:4c37 with SMTP id
 15-20020ac8570f000000b002f3db0a4c37mr6930864qtw.471.1652487707423; Fri, 13
 May 2022 17:21:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652372970.git.lorenzo@kernel.org> <4841edea5de2ce5898092c057f61d45dec3d9a34.1652372970.git.lorenzo@kernel.org>
In-Reply-To: <4841edea5de2ce5898092c057f61d45dec3d9a34.1652372970.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 May 2022 17:21:36 -0700
Message-ID: <CAADnVQKys77rY+FLkGJwdmdww+h2pGosx08RxVvYwwkjZLSwEQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add selftest for
 bpf_ct_refresh_timeout kfunc
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 9:34 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Install a new ct entry in order to perform a successful lookup and
> test bpf_ct_refresh_timeout kfunc helper.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

CI is failing:
test_bpf_nf_ct:FAIL:flush ct entries unexpected error: 32512 (errno 2)
test_bpf_nf_ct:FAIL:create ct entry unexpected error: 32512 (errno 2)

Please follow the links from patchwork for details.
