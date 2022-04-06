Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17124F642F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiDFQD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiDFQDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:03:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 367374781E1
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 06:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649252051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xqJrO6dmU5SvkPcGw8UCuWuh5/5NxvMZsaumTowIu8c=;
        b=XayyjZV8LUoA1PLyX9HsXMdMLGZaFEXs0y+MHC/k2malIRQa8pIxqmDgyGvWDCDryJrUpc
        Enc/tNBWsdHmbB9EHf2l0XJCfsFvXaJl7RKNzwGy3O4DMM+g7mtqAEEbaq2dU9Dukiwd+j
        /qgYJoKIZpq+sZAiLqas7cSpOBdoH8o=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-FVS7h3UjMLiXxpAfrwyC0g-1; Wed, 06 Apr 2022 09:34:09 -0400
X-MC-Unique: FVS7h3UjMLiXxpAfrwyC0g-1
Received: by mail-yb1-f198.google.com with SMTP id k206-20020a2524d7000000b0063db1bacae1so1789074ybk.4
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 06:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xqJrO6dmU5SvkPcGw8UCuWuh5/5NxvMZsaumTowIu8c=;
        b=2eIpo/h+AbAr+yJ63mK2R0PaIovrRgjnJ9KH7zwiHWzXPHBTv4QcRnpIlvWRf/fE3E
         xiHuRGnE3RuZCnZonpPu2KIXOABeSXKjJzie2feY+zCruQtjhMZyFZFY5i+jVtaXvtZO
         MyALfRNaiq5Xvzh6Ye7sCHizgK6lfFG2EoDe4tF1/GHvOBisURhe+JqzlXgV/rvvQkgE
         T/sE6IFconHse6XhYsSfHnaYjEdmAJVJ2+TJTV2hJgRayz7sfSFPKZimCPDReppj6sEN
         j2qlZeU0co2Hr9fijz5cyY5RxLqD9PP2UWOucfRKi6Qa3OkrYOe5uC8JQrXfQCOG2ZoW
         kBbg==
X-Gm-Message-State: AOAM530Fg+x5lzBp2VUBrx9lzjjVTDyOtYxDAmJ+CGFye0LSepak7BEn
        2ucSJXc+i+jNMHrIPliKTfTYPyxcgpNEbGklebM9R5LNLoH6Mp628S0u7LrlnzMQVcSnmc/GwZ/
        tpphp6EX4vON9k6aFE5EQ+toDf7fNRDV5
X-Received: by 2002:a0d:e64d:0:b0:2e6:43f8:234f with SMTP id p74-20020a0de64d000000b002e643f8234fmr7012371ywe.12.1649252049392;
        Wed, 06 Apr 2022 06:34:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVRyzw7tB7nHauTQeSQg7Hj0WMwzeDSc4tOVfXZNCRQWMlZ043KzTYBmx0XGbMf0eIBPqtGUja+rJ6sTcquoA=
X-Received: by 2002:a0d:e64d:0:b0:2e6:43f8:234f with SMTP id
 p74-20020a0de64d000000b002e643f8234fmr7012342ywe.12.1649252049081; Wed, 06
 Apr 2022 06:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com>
 <CAFqZXNt=Ca+x7PaYgc1jXq-3cKxin-_=UNCSiyVHjbP7OYUKvA@mail.gmail.com> <CADvbK_fTnWhnuxR7JkNYeoSB4a1nSX7O0jg4Mif6V_or-tOy3w@mail.gmail.com>
In-Reply-To: <CADvbK_fTnWhnuxR7JkNYeoSB4a1nSX7O0jg4Mif6V_or-tOy3w@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 6 Apr 2022 15:33:57 +0200
Message-ID: <CAFqZXNss=7DMb=75ZBDwL9HrrubkxJK=xu7-kqxX-Mw1FtRuuA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: use the correct skb for security_sctp_assoc_request
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 5, 2022 at 1:58 PM Xin Long <lucien.xin@gmail.com> wrote:
> On Mon, Apr 4, 2022 at 6:15 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >
> > Adding LSM and SELinux lists to CC for awareness; the original patch
> > is available at:
> > https://lore.kernel.org/netdev/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/T/
> > https://patchwork.kernel.org/project/netdevbpf/patch/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/
> >
> > On Mon, Apr 4, 2022 at 3:53 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > Yi Chen reported an unexpected sctp connection abort, and it occurred when
> > > COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> > > is included in chunk->head_skb instead of chunk->skb, it failed to check
> > > IP header version in security_sctp_assoc_request().
> > >
> > > According to Ondrej, SELinux only looks at IP header (address and IPsec
> > > options) and XFRM state data, and these are all included in head_skb for
> > > SCTP HW GSO packets. So fix it by using head_skb when calling
> > > security_sctp_assoc_request() in processing COOKIE_ECHO.
> >
> > The logic looks good to me, but I still have one unanswered concern.
> > The head_skb member of struct sctp_chunk is defined inside a union:
> >
> > struct sctp_chunk {
> >         [...]
> >         union {
> >                 /* In case of GSO packets, this will store the head one */
> >                 struct sk_buff *head_skb;
> >                 /* In case of auth enabled, this will point to the shkey */
> >                 struct sctp_shared_key *shkey;
> >         };
> >         [...]
> > };
> >
> > What guarantees that this chunk doesn't have "auth enabled" and the
> > head_skb pointer isn't actually a non-NULL shkey pointer? Maybe it's
> > obvious to a Linux SCTP expert, but at least for me as an outsider it
> > isn't - that's usually a good hint that there should be a code comment
> > explaining it.
> Hi Ondrej,
>
> shkey is for tx skbs only, while head_skb is for skbs on rx path.

That makes sense, thanks. I would still be happier if this was
documented, but the comment would best fit in the struct sctp_chunk
definition and that wouldn't fit in this patch...

Actually I have one more question - what about the
security_sctp_assoc_established() call in sctp_sf_do_5_1E_ca()? Is
COOKIE ACK guaranteed to be never bundled?

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

