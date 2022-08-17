Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D2459776B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbiHQUJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241590AbiHQUIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:08:20 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FBE1025;
        Wed, 17 Aug 2022 13:08:19 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q74so7380686iod.9;
        Wed, 17 Aug 2022 13:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JCgNCnBmoMTmDvvCiS4lXyw582xnOmRe3hBk8pGv54A=;
        b=Jw3DxXzUB1rR7pOYgySvosGI70W3Z4JpmQOZUAIlOMR2rfMjlBBAT9xnsrQus8QDCy
         hK6SCOF8Ki+W1NDTasXIFK1Jtp0xOfSTpnxpfLtNePSjMgmBUTHFeNZqo6rGAjMKpEv5
         T2DN0lvCgmWG9YxPuEyOkSUs5Oj9/eMsdUSZWW2fpCWmDBGrwM/TrRH6JQtHyLsejUzl
         2CQnXHIWutGaeP2TyqfMbPjlhxMs6FOOwDGxgcXKEBj/ccRrVcFv77rMOpzBTtsCjpD7
         qSn8SzOTtCbMsnlET3H9dDgnli69SBpxNqhghAnfgqokaQyypoR4dx4mFzNh8rw4mtnN
         baZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JCgNCnBmoMTmDvvCiS4lXyw582xnOmRe3hBk8pGv54A=;
        b=sNGeACltLTtiqw9uL2s8aCOdsVcwcfC7WS/W/GnpwtLOIg1WMSeziy0OrOcyu/xddd
         XCpYh5iCWbnzidyaQk+CcNgVeR2s81FojVilRWYn36sMzvBmUQOXhz25d+3zDISyUiXy
         StlXXbs7sCNdymwLIAb4WM0O0JFuHNBKBnwD1Czr4MZLZkm+2G8/g4GBdIl3oyEohZk2
         iHrxwI7EsLmjV+v5nb/6XJtk2n53/WIGJfgnkVJXUjFbWbWXmtOLy89ghec0iXjxesrf
         LUBq20YWhxIr9KP1bUgOmsWBZhNIHHUozlOQSwIjjdPE+fMFzj2+OTLrTcwrJXEnnDTX
         fIMg==
X-Gm-Message-State: ACgBeo3DAglrqwg8OFrO6hffTuedU84SqAzzW3I7tP3AUnFacjqvSu2+
        lb/Ku1ec2lvTaD5hYHct2kazewswgMcsPrAz9QI=
X-Google-Smtp-Source: AA6agR4Z9yJ9LvneZHFRhrCvN4J6stu2Qk3WYhEcKR4FDLl5XM5VN3tFVf4DBBjoVdEEMKKhv/6zN3seiz3wtZMGCcM=
X-Received: by 2002:a05:6602:150c:b0:67c:149b:a349 with SMTP id
 g12-20020a056602150c00b0067c149ba349mr11920881iow.168.1660766899208; Wed, 17
 Aug 2022 13:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660761470.git.dxu@dxuuu.xyz> <3a707dd1ec4a2441425a8882072c69ffb774ed4d.1660761470.git.dxu@dxuuu.xyz>
In-Reply-To: <3a707dd1ec4a2441425a8882072c69ffb774ed4d.1660761470.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 17 Aug 2022 22:07:43 +0200
Message-ID: <CAP01T76-nocaXY9B28a6cvwLY_3irFyOTF8xgoV9ZdcChj4T+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] bpf: Add stub for btf_struct_access()
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 17 Aug 2022 at 20:43, Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Add corresponding unimplemented stub for when CONFIG_BPF_SYSCALL=n
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
