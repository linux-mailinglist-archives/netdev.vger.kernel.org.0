Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68870243A4E
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgHMMvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgHMMvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 08:51:03 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673A9C061384
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:51:03 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id q13so2818488vsn.9
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6U+MzbkuK7qE2zWXiIV5fubuG6u2ECbr/eqjOujnCU=;
        b=JmZ+2cVCvH/NJLMcB8pNKwvmqjinr9zVEEkYBcwRynp3GponnTUIozTMBlSYJeFfdu
         zD8Gr/YxyMtB/RJR/6DfEFywcsMIfSWRrl3ggZHURB/YMtF/G3hdC7TLebysrh6wtSD7
         9ftV1qKlcsrxlYfB4KeEN5mi0vMsKes6XHx72Aedcwhs4MDLGD1juvHcouOvufrxtgS3
         pMLyGwMmSw1uCWFgvjSZZ3LIZE7Q7sTiizR01fR8QcaawF6JfindNjLcZN8R9TPVNljU
         TDhHRrvmqgKXeV00svNQfAoQ+RGhYBfSep1c/wkp7oP1r+c6h5wl7cX1DJCstRJVnZKK
         z03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6U+MzbkuK7qE2zWXiIV5fubuG6u2ECbr/eqjOujnCU=;
        b=V0yNoRQ9k7Uhq3m+S9zEcxGPUQpYD+F8QW7rmplS5vJLOhhrlzZh1L1QEalJPsZqkc
         pn2i0bICrvn2e3wvwXCh50Zqrk/VUIwTSNgfcJ4lfgxjmDRlvJmpPTjAa/28B868lI3h
         BuFgyW6k7hZ1TISlyl1MPKGPFrzs8oAnZqhr6k5aJImrLqOskoHSe+Byd40uMezZLxVX
         4IubejYmp8toRR2MwS8WOcKWX2TkrQlPVjLPi9+Acv9bHJgrpUK0+AtnM0IMAkmWqJmn
         id6LLYJimwiR/AMkqmJfOutxoVLBYlvmQ9dJ8OG2sVfzcLn87CDooc+RU9wVuOWJ50ds
         jk8A==
X-Gm-Message-State: AOAM531gjSP18+zwBTTlyW2PAE62YDkF38KibGGiOY08RHmzr+9jZpGm
        YXtLfL6lQRuvoqZQHWhYVfzLOfbnez4=
X-Google-Smtp-Source: ABdhPJyHgu+GNz9E3ghppOngKB0FktxEjAprM8YW5pU2F0q10VWtrN0ZThGZQ9EHNwxpDu1VObZMdg==
X-Received: by 2002:a67:fd8a:: with SMTP id k10mr2900104vsq.59.1597323061266;
        Thu, 13 Aug 2020 05:51:01 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id b21sm785053vkb.30.2020.08.13.05.50.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 05:51:00 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id s81so1232785vkb.3
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:50:59 -0700 (PDT)
X-Received: by 2002:ac5:c925:: with SMTP id u5mr3013838vkl.68.1597323059280;
 Thu, 13 Aug 2020 05:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200813121310.23016-1-linmiaohe@huawei.com>
In-Reply-To: <20200813121310.23016-1-linmiaohe@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 13 Aug 2020 14:50:22 +0200
X-Gmail-Original-Message-ID: <CA+FuTSeS9eE_1bsik-0i3qb-WXtQnb3q=mo6+iHOciQjLZ+sHQ@mail.gmail.com>
Message-ID: <CA+FuTSeS9eE_1bsik-0i3qb-WXtQnb3q=mo6+iHOciQjLZ+sHQ@mail.gmail.com>
Subject: Re: [PATCH] net: add missing skb_uarg refcount increment in pskb_carve_inside_header()
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>, martin.varghese@nokia.com,
        pshelar@ovn.org, dcaratti@redhat.com,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        sowmini.varadhan@oracle.com,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 2:16 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
>
> If the skb is zcopied, we should increase the skb_uarg refcount before we
> involve skb_release_data(). See pskb_expand_head() as a reference.

Did you manage to observe a bug through this datapath in practice?

pskb_carve_inside_header is called
  from pskb_carve
    from pskb_extract
      from rds_tcp_data_recv

That receive path should not see any packets with zerocopy state associated.


> Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
