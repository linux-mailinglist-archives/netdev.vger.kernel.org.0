Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D44516C02
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379079AbiEBIbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344174AbiEBIbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:31:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39DF657177
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651480068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NWS8dl4Ge0rcbF+guhgHso8AyjIuR8kYgTFPU1sWQmQ=;
        b=Nmbzk0saURu8AuDNX1ENGK2j+FyvGp70l/UdRr8pKh6yiVFH9X5zmzzDrvHH8hFasrp/mO
        FnkxBkl2QKES+TJlm4PjjFPPj2pRsYw+wGk2TEZJFbBJx2Y9rKx3lZ3WS5gKNuzp8mUmN6
        AyqOuWaIKf1/gWHE0aACuFYSXQLYIbs=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-S3wfIpVpMUa8T12qcodH7g-1; Mon, 02 May 2022 04:27:47 -0400
X-MC-Unique: S3wfIpVpMUa8T12qcodH7g-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-2f7dbceab08so128845737b3.10
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 01:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWS8dl4Ge0rcbF+guhgHso8AyjIuR8kYgTFPU1sWQmQ=;
        b=q/MyWHI0JrMwR2noq49TRcXp0R0gkqBsZhv5J6q2ShSuuuv9AFJ2tOcce04Z94tial
         zqWyANjARMo6JqAviD2VbXxUFWMryyeJ5uSK4uWIJb12fcRDWGP1DN88laPb38Fpr7YE
         lW9QyZAMGog6zW4S38hl/tv92+cqMN1s171AT6+bucsKnRcoY9gfAFzbKifiJrWBHFjl
         nygPdb9a1qtCyTvq0yePnTOKkESvGwwIYg+iHc35II9I5l58sjuMGHd3Gb7nrLiNklmV
         c6l5sMuJRty8Kbp4G81XYfiyJjfJCrC1Ba43F54C1gVx4w0D2eLqSMIzV2uzg8KymEAk
         N+QQ==
X-Gm-Message-State: AOAM5302wnwMVC8V5athosjL1b0azwuOMV7GWy+SzJvmFHKwj1/anTXp
        tEDQshXml1l8V55yL4D7X2USNM/x8UOKxJKRJxfHjst/yeBWjqbnSEVfuTSyH89mrXj9AdsQfkE
        cRlfGjIQf/JgKLgUYCxI2fIoZm9YllUM/
X-Received: by 2002:a25:74cc:0:b0:648:4697:9722 with SMTP id p195-20020a2574cc000000b0064846979722mr9508905ybc.21.1651480067053;
        Mon, 02 May 2022 01:27:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxC69ilmYF+AKCeSULyRhBxjoPrDy93I3TNVKgiOtV8+nVSrH45pb5si+kiNrqC8+bjPgBwY4IlNJoFwfpkCGE=
X-Received: by 2002:a25:74cc:0:b0:648:4697:9722 with SMTP id
 p195-20020a2574cc000000b0064846979722mr9508901ybc.21.1651480066870; Mon, 02
 May 2022 01:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <87r15gngfj.ffs@tglx> <165142141033.5854.5996010695898086875.git-patchwork-notify@kernel.org>
In-Reply-To: <165142141033.5854.5996010695898086875.git-patchwork-notify@kernel.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 2 May 2022 10:27:35 +0200
Message-ID: <CAFqZXNtC8vL=JFYUX_ahX-Y4J+Uh0yvOy5SYD6wPzSmNeHodfQ@mail.gmail.com>
Subject: Re: ['[PATCH] net: thunderx: Do not invoke pci_irq_vector() from\n
 interrupt context', '']
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>, sgoutham@marvell.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Sun, May 1, 2022 at 6:10 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Fri, 29 Apr 2022 15:54:24 +0200 you wrote:
> > pci_irq_vector() can't be used in atomic context any longer. This conflicts
> > with the usage of this function in nic_mbx_intr_handler().
> >
> > Cache the Linux interrupt numbers in struct nicpf and use that cache in the
> > interrupt handler to select the mailbox.
> >
> > Fixes: 495c66aca3da ("genirq/msi: Convert to new functions")
> > Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Sunil Goutham <sgoutham@marvell.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: netdev@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Link: https://bugzilla.redhat.com/show_bug.cgi?id=2041772
> >
> > [...]
>
> Here is the summary with links:
>   - net: thunderx: Do not invoke pci_irq_vector() from interrupt context
>     https://git.kernel.org/netdev/net/c/6b292a04c694

It seems the patch got mangled when applying? The commit is missing
the subject line.

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

