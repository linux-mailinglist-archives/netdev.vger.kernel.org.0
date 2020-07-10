Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B141921AF2C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgGJGKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJGKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:10:02 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC8DC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 23:10:01 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c16so4855579ioi.9
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 23:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WWlMDib4ZepejPl9se7JfCcWYOyfU0YisJxo9quT0SU=;
        b=E+kLU2POjcNyZt0kFETKsET8Mr4MfS9Cg8KBsvPhvWlQey2zqLy3VQe/v6NCnpQDhJ
         6DqWHpvmfVdV4SJvKBgCWlydfVTAano63VdpZum6STPmbGz7u/kXsT4etci4pXvIQ/Ko
         SVw3lQk3RUvYx/cH4sobe4ksINI0LjjtWxZM7SCxLTmnqWarNHWY42xwYFUYKkXuj5LE
         fT5kxldXLMFIK+IUwyxgSN+LbbI0jAlyuOTdbUPJrU0NjBnXcHQW5C4W22drAQmMfBJE
         OHkOcOchsgq8ms9xpq/x0ZD1LQdnaQiZbFb67XMi59zJTXwVJVsMk3x194AxU/sF9HMp
         ivKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WWlMDib4ZepejPl9se7JfCcWYOyfU0YisJxo9quT0SU=;
        b=st6/XOMuqKB0qVVPgXbI3UvlkjZJByiSP8RKFWwvpw4dqluvvMvM87ixk19qDxVyTX
         nJgIbcZIQ425EE/stVJZJWuHggKMBgT4GgVXfOkePqh24Y06D3lthN415NH7u9dIxxW4
         pvs+roZAcW4/aHDGlzdIHpzBAvllme6xcbEOviHWFhsoTBO/8Hup7NV1Sw5khJtKlS9a
         erWN3teJ0O8vDR1Oa/RxrnEl18c25NeePGidKggNNziJSqc3wNGUtKf2fTqEyvROfRxR
         UT2CIrONIJB5R6o00sTxpOYc2T17wbngzDX0rBqo5a+u+6Nx2cU849cS80Jz4G8nSVNQ
         uXvg==
X-Gm-Message-State: AOAM530ass5QOzFzBHqNIReTKpt6MXltBBREsE5Ym8Lxkrd6ROhczhRx
        XEUE0k8hb67pXLpR3GJBSaE+H98K9r8h0y9GRZBn/hPmXYE=
X-Google-Smtp-Source: ABdhPJwZyt/ZPRERKLLjwSY5rINuZaOlvgPJC0duLOZEwwCaUesCA0ukmpeleBPCMKKmQORDya69w1shQ2/nfjV+hu4=
X-Received: by 2002:a02:c785:: with SMTP id n5mr77562342jao.75.1594361401216;
 Thu, 09 Jul 2020 23:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com> <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com> <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
 <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com> <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
 <a33f9de6-b066-6014-8be2-585203a97d89@alibaba-inc.com>
In-Reply-To: <a33f9de6-b066-6014-8be2-585203a97d89@alibaba-inc.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 23:09:49 -0700
Message-ID: <CAM_iQpUwACsXVe9GAkQ1XC1TTU8aT3pqnrkZYT+oVDrP_1pKzw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB) Qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 10:49 PM YU, Xiangning
<xiangning.yu@alibaba-inc.com> wrote:
>
> Well, we do ask packets from a flow to be classified to a single class, not multiple ones. It doesn't have to be socket priority, it could be five tuple hash, or even container classid.

I don't see how it is so in your code, without skb priority your code
simply falls back to default class:

+       /* Allow to select a class by setting skb->priority */
+       if (likely(skb->priority != 0)) {
+               cl = ltb_find_class(sch, skb->priority);
+               if (cl)
+                       return cl;
+       }
+       return rcu_dereference_bh(ltb->default_cls);

Mind to be more specific here?

BTW, your qdisc does not even support TC filters, does it?
At least I don't see that tcf_classify() is called.


>
> I think it's ok to have this requirement, even if we use htb, I would suggest the same. Why do you think this is a problem?

Because HTB does not have a per-cpu queue for each class,
yours does, cl->aggr_queues[cpu], if your point here is why we
don't blame HTB.

Thanks.
