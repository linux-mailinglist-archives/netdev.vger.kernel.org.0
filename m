Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57446DC074
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDIOt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 10:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDIOt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 10:49:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B94935AE
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 07:49:25 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id jw24so18599060ejc.3
        for <netdev@vger.kernel.org>; Sun, 09 Apr 2023 07:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681051764;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=65LSbWKUrmCArl+LXVPE7dMWtbfbmdZlWVztuN2QWX0=;
        b=b0gnqKuPzGxBDzcrGs8eDqLRGoQBwJSNtdIQW7jdBZj187QJuJhpCg5slpnkGD2r1g
         JBtHIXOz0t36TBewgWRcItyvOujSFDwZ4lsvBJxvlDfbjOAzNYSah373BzCo29W5s/mJ
         zqP+1d9/mJ0YA/jQzKcOVnEmCysltQfFGuw2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681051764;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65LSbWKUrmCArl+LXVPE7dMWtbfbmdZlWVztuN2QWX0=;
        b=0npag308j/zXoE5XWo21YshFh87zSqBvOay9EnOlN5eLRvkIDyujkGYAX5WYZmkdJ7
         c8hgChd18J/VsXFzRRTe+F2jvi5nPn09v1g1uoYrO2V86X75whnoOsbBysnQh0ZmyBMb
         fwsIqGMSeBgoKodeFCiGhkBE/+2FHyLCsF8k/M5+L9f9plCHWDWc3C+EF6skvXCpan/S
         4YQbW1eL7orlJUb3R56+iP8ZWvIJtQgIN3hj7mQDssrlaDK6wNjDpr9C/8j+lqdvh6Tr
         SUt7PB5XaXghzuYbagu1olsLTfaHtXk1qyHeRsPaZ1DadwxQsmuxNefSWjkAgq/MHmPQ
         sOPg==
X-Gm-Message-State: AAQBX9eASEoBJpZBPQuxzDq2fmbsrBzqLNg0WjbJ8XAmfmncuLbFHeRg
        dNAJyEUeqgrPHfkh4GApBOJkYBTaWg4VTTJNMI3Z9A==
X-Google-Smtp-Source: AKy350Y//avkrDNCiYLj+3hant+G2KKsf7lq85OXJkIr+RhU38AdQal5f9HWvuw7i/JuxgMRJVbuorj3x81kC4LvY7A=
X-Received: by 2002:a17:907:a68a:b0:92e:7a67:668a with SMTP id
 vv10-20020a170907a68a00b0092e7a67668amr2381028ejc.0.1681051763891; Sun, 09
 Apr 2023 07:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230406212136.19716-1-kal.conley@dectris.com>
In-Reply-To: <20230406212136.19716-1-kal.conley@dectris.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Sun, 9 Apr 2023 16:54:05 +0200
Message-ID: <CAHApi-=CZcRcD+knw6TgFxEnk+16bN4nPJKLVbfmsHHL7crtnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: Elide base_addr comparison in xp_unaligned_validate_desc
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +       addr = xp_unaligned_add_offset_to_addr(desc->addr);
> +

I guess this assignment should simply be combined with the variable
declaration. This will shorten the function by an additional two lines
of code.
