Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD3D25383B
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHZTXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgHZTXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:23:31 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80119C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:23:30 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id o184so1567500vsc.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8fgLP4c/3TihGH7ObpGdD5jxy+H0l+gPpxGoeajT8+E=;
        b=UNYe6+oz/uzwqiReACZPv0k74RGSZtXSFqhCnRiqR2lhjaFnJUX93yPXlHdWmEfPBK
         pABMmT0ixe+TQ3tZbz7PP3BzYBfC62zzIABqGjQNZHyTFMxvSqQ/jtMs1lQTAXT9VrVL
         1UsGCsMdsyHDe3tiMbojhpD2gsPStMuxczQLUWjVR+ICie9HMz3cpgHSbkzgWhfUsmFo
         3YE7L83iJXRQ0UngxCKBVEd6xUKJvzXqMmcQUgkXkHQM485BUInOFI1lPeADYywh7wpC
         hHkrX0YYpRe3QrJhjtu6VyVJiYbZ+iaX/1HLqYYF2gLhNtN6vOUQ5Ck5pnj4W1VzLCAh
         xTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8fgLP4c/3TihGH7ObpGdD5jxy+H0l+gPpxGoeajT8+E=;
        b=Bi8eK+RdL07cf3mLIjdr4+sdtwe24MvbtQRq0TS8hcFZq5/6Wt4hWOXDQFT4JncTm/
         RJd0BSan24D0S+JhtHOf2XSSTpYm6fp5S9mAgx2yJ/vrp+tPbNLsp+FA+cgPoMXOCsBh
         WayjCZktytQ0843Ih8Y7UnWnhUeMoBdG6lH4qRYJ/iBRMakCnUGX1K277xGByJmq5IoT
         0jkyLmYjli9ldf5ZwjPRaKTO6Ycv03iNV3sV4aHFZ+RLggGXsCIaQggGymZctJ/8KSvF
         43JHkkvE4fmNS5A2mYunBg9DEbC1G75tgvoF+xqvQGnp4uL0OmXuYzK9w1JXUhDp9tMB
         hASA==
X-Gm-Message-State: AOAM531+NpDkwmElmXZAf5MjX2TFahVGVimEWGqAYvePazNrHoF7oMI5
        zOsb8ueYqSPvAVFTNfdqT8kJIPAsB6eY0yqeTx1wfL9E
X-Google-Smtp-Source: ABdhPJw8XZs9/OIS+Uyq2VC1pmheHqVjnuS093zgmHnf1gk/J3fVA7N2bte9OLLSa203uI/V2wmJwhrkuDO4bgt0zaU=
X-Received: by 2002:a67:f555:: with SMTP id z21mr10386029vsn.187.1598469809825;
 Wed, 26 Aug 2020 12:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com> <20200825050636.14153-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200825050636.14153-3-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 26 Aug 2020 12:23:18 -0700
Message-ID: <CAOrHB_D3+R0uCav_3vV_PGCdix8F3g_w39CwX6h2Z+bhEwYi9A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: openvswitch: refactor flow free function
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 10:08 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Decrease table->count and ufid_count unconditionally,
> because we only don't use count or ufid_count to count
> when flushing the flows. To simplify the codes, we
> remove the "count" argument of table_instance_flow_free.
>
> To avoid a bug when deleting flows in the future, add
> WARN_ON in flush flows function.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Looks good.

Acked-by: Pravin B Shelar <pshelar@ovn.org>
