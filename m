Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E797617017
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiKBVx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKBVxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:53:55 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161F56396
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:53:54 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id o70so172591yba.7
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 14:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3EwqQdy31sqBkxYtqTdrt4QtPfV/deRLFG8225Ldd98=;
        b=UZf0joM4l549onip8pFdW8OQgY6aZiYaKkEt4TgxX+IBBaQBpQ5KUQnNlv1iGJpn7R
         NFBoW3we16LE5CJa/rZsAT3XtuSi05dKvw2VkVSX9B4dWS/G8jSsobKTP0ZL0nCwoI/a
         gSy4Lrf/1fAH2y94u89/5CQU8GT/Acl3mGow3Bdum1mxKsUzkxrCitC8XJLyJWTzsqdv
         eFIqOK5fpC9n5xMwlgkwvrN9vT1Ke8OSvOquY7n1/qoNdeAS3KEpSQxYHFl0xhZlIgpP
         lAl4WYlhkZMmD1XoDIFgwpuPFL5fna+vTI3Jn2YOnuuK5zs/jRVw/lwxxY5Cz1phPPwv
         F+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3EwqQdy31sqBkxYtqTdrt4QtPfV/deRLFG8225Ldd98=;
        b=ZbEXV1mpgL8JxNErNQ34I0CwOCgZugCugNNnj1Qbco0k/8SqZTWk8ZUaa+DazqGlgr
         4McIclQvqhQYAF1dBNcffZaRu6/0KBAQPepgQDLUogJlAQr8wbTO8C1VpzzwlbEHyKT0
         /xLK8G+84OZpSKyvkdLd+md5tgBFL5zsJg/6A2SlzeaZ4mss6Tycy3XvnhjFv4R+ttwF
         oiK7A93STYrtFEXHqZfLsjpSFzKOrc8xN85O+0fCFdAMFPkln3aKDJv95KzLIng90VZL
         GCnUbINv3fo97SFJLh4ZTNMBoDTcP2k2V390qyRcKigifU93oyuZnS6jSWHTudnPNifO
         hjag==
X-Gm-Message-State: ACrzQf2FPXfuDGLN/rBExafngRK/I4nxIUNGih3lzlld1l7l/bWu1Iza
        b+12NCccYLfZtAfeQ+GXqiI0GKv3TWh2oEKaGp43WA==
X-Google-Smtp-Source: AMsMyM4Aqe3QOvqVwoxzyp8kfGjuhdRDMSZxrZzqEdr6wWhKTu98K6UxfkrKnjSuqs/r4TfsspLWLsHS5wzxCFDx6nM=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr24647957ybx.427.1667426033028; Wed, 02
 Nov 2022 14:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221102211350.625011-1-dima@arista.com> <20221102211350.625011-3-dima@arista.com>
 <CANn89iLbOikuG9+Tna9M0Gr-diF2vFpfMV8MDP8rBuN49+Mwrg@mail.gmail.com>
 <483848f5-8807-fd97-babc-44740db96db4@arista.com> <CANn89i+XyQhh0eNMJWNn6NNLDaMtrzX3sq9Atu-ic7P5uqDODg@mail.gmail.com>
In-Reply-To: <CANn89i+XyQhh0eNMJWNn6NNLDaMtrzX3sq9Atu-ic7P5uqDODg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Nov 2022 14:53:42 -0700
Message-ID: <CANn89i+UxgHwm9apzBXV-afpcfXfuX2S+6i4vPzF2ec4Dr6X0A@mail.gmail.com>
Subject: Re: [PATCH 2/2] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 2:49 PM Eric Dumazet <edumazet@google.com> wrote:

>
> Are you sure ?
>
> static_branch_inc() is what we want here, it is a nice wrapper around
> the correct internal details,
> and ultimately boils to an atomic_inc(). It is safe for all contexts.
>
> But if/when jump labels get refcount_t one day, we will not have to
> change TCP stack because
> it made some implementation assumptions.

Oh, I think I understand this better now.

Please provide a helper like

static inline void static_key_fast_inc(struct static_key *key)
{
       atomic_inc(&key->enabled);
}

Something like that.
