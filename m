Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD363219149
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGHUQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgGHUQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:16:34 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF40CC061A0B;
        Wed,  8 Jul 2020 13:16:33 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id o3so66877ilo.12;
        Wed, 08 Jul 2020 13:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tM+7BVPh8bMDO5y+heD1FnDYRPNX3xnpgeW4SZPgUBs=;
        b=Mjlo4UFs8AnPv/x6lCF+93YSRpR+fKu6PkR5OT2yzA8OJwy3OISUHmMMI2LYDfAt9n
         zWzVNek5CF637yYus2Ob5sFoXxK5Q0nEQVw6fLzbXqqfqu/QWo/iDLfsecc+USn8gQga
         ZbtMu5rU2Knx5ze8ujrMw08ywsd1t/TrbvLH588u+xiQSWrUFh/T5MPMy03pR8OUBrvg
         4Ht780LJFEjDbYjXAHdhGYOcL4fjtWOpn1R2eYBykZTZIMly8wGoONrS0TGTsa+aoKaB
         fW3K+MK/gyO2+ViudQD+xpElbmtKoX83nX3Gqm3vE0gd3IP9j7DhoN3ZIBRe9aCkRujL
         IBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tM+7BVPh8bMDO5y+heD1FnDYRPNX3xnpgeW4SZPgUBs=;
        b=PmY/8MUhi0yLyc1913t11OvK455FwSPChzvq/uVrdB3ZXxFEJAFVwXGMF5nQge8dA8
         bu8L1D7HvUuz82f8rcYOi6C0gS4wVLiOHlHruUQOvvHJsA54CGaiRtj5JjoWFjlvy/Ua
         OmVIHu5SlaJzW3aSI8rXoH1jYE7Y0rLuz9CzXT+vOiR/p7RDoTL1qR/4oB3Px7624Rv6
         NY7sII7Cn1SQpNI+TU2xCXI6CaeJH31+iv/OuGksJ4o9fGLcZP7PtwLKp9EEPkD6DNKo
         0h45ZqkcfOTXgmYvFhFZbbrMrALEN7+efEI4IW08meJnbbOM3Z/Bt5KRSy2x6AzvABvr
         Zlhw==
X-Gm-Message-State: AOAM5325XHkS2nAIcpVBhES9Mt9igQOg052YC1KliT7QfSfi0vgYNBSm
        G/mDOQrDeAPRWLj08EzHjOUciA/4ipzX7PpRrh4fj06WvW4=
X-Google-Smtp-Source: ABdhPJxpXGW/XExlj6KBTGiyRrFl/+MjnQ+qdbj4oYc+N0X3PIgJ62PIGVETRSlrpuixkk1XzG9K9wbBJuYIlvkYfJA=
X-Received: by 2002:a92:5857:: with SMTP id m84mr42874500ilb.144.1594239393335;
 Wed, 08 Jul 2020 13:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <e54b0fe2ab12f6d078cdc6540f03478c32fe5735.camel@redhat.com>
In-Reply-To: <e54b0fe2ab12f6d078cdc6540f03478c32fe5735.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Jul 2020 13:16:22 -0700
Message-ID: <CAM_iQpVZ4_AEV6JR__u-ooF7-=ozABVr_XPXGqwj2AK-VM1U5w@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 7:18 AM Paolo Abeni <pabeni@redhat.com> wrote:
> So the regression with 2 pktgen threads is still relevant. 'perf' shows
> relevant time spent into net_tx_action() and __netif_schedule().

So, touching the __QDISC_STATE_SCHED bit in __dev_xmit_skb() is
not a good idea.

Let me see if there is any other way to fix this.

Thanks.
