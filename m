Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29DE6065E9
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJTQeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 12:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiJTQej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 12:34:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4968114016
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 09:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666283659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iFX+Je1+5VjilA4nu1QFlaYd99bLwTzHit3WzGmVmo8=;
        b=Pzj2iO11a/8tYYzfiSY0YsC8Nlo+LNfaItWGvt+lvblGStShc3m/2oS9sE++nreNtrO1+U
        9R6JvrRE90CPEqWWFnIhU5YfQPjmrhb2ZHbwu8PKtdp6sasLrcquLNN2Qs5Kx8bUtkMWHU
        50Av1gOik+VtF/l5BVxan8E1/8VFWvA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-190-dlvLNt7CM5GuMFrhHbEB6w-1; Thu, 20 Oct 2022 12:34:17 -0400
X-MC-Unique: dlvLNt7CM5GuMFrhHbEB6w-1
Received: by mail-ej1-f69.google.com with SMTP id sa6-20020a1709076d0600b0078d84ed54b9so136219ejc.18
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 09:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iFX+Je1+5VjilA4nu1QFlaYd99bLwTzHit3WzGmVmo8=;
        b=KBh74a2u2taQN1QypwhpPxCCoiA+v6chxs/qvCEPPhnMc6NnoIYSeTk3ag5krhJWhP
         YAGNrwoUXGHIces1dp60BxCF0pZskvGz15Bi/bByziiBRytdHy5++FyicFRId+ogduMv
         6+6TbtNefcezEM0F/WFONVRJcPRjkuk9h1BB8nXx86aCsANV1uNupgcP8dCwsGPROPf3
         HXcO5Xe34QtrvnKt1mGg7XnwxO0mmX+egiaMy1aUVRjLAPppPVEbGWDfTemjIyI2j4aS
         eDCOoMda8RXwS8kBHv8SuFbO8QDf3UCO7TqXMzb/kBxZwqKXyaBczQY5nmq3tFB0Os8b
         C2Bg==
X-Gm-Message-State: ACrzQf2l5A5ExfcGU+pd6oMuUow3VVtI8LU8juaYpC27hqLmtYfc9PUf
        Z7PRvWSVKRaY+O2IDi6A5Ilkj9xHhMFsZfdd/OJjj7vYinXH0AgWvPKPCcW7pNv+o9TKMNg4fgI
        BRh/M/7O7e9RPcmHh
X-Received: by 2002:a17:907:7245:b0:78d:ec9c:e743 with SMTP id ds5-20020a170907724500b0078dec9ce743mr11937179ejc.466.1666283654290;
        Thu, 20 Oct 2022 09:34:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7KRuB4bQjHQh2P5gLUINzx7swd+TyxlaC5D8RG3Jyk6kK3vmnITIkZ+QnBk+5FLm+3S061Ig==
X-Received: by 2002:a17:907:7245:b0:78d:ec9c:e743 with SMTP id ds5-20020a170907724500b0078dec9ce743mr11937115ejc.466.1666283653343;
        Thu, 20 Oct 2022 09:34:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906201100b007803083a36asm10435224ejo.115.2022.10.20.09.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 09:34:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 579B76EA0D8; Thu, 20 Oct 2022 18:34:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
In-Reply-To: <c128d468-0c87-8759-e7de-b482abf8aab6@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
 <87wn9proty.fsf@toke.dk>
 <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
 <87v8p7r1f2.fsf@toke.dk>
 <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
 <567d3635f6e7969c4e1a0e4bc759556c472d1dff.camel@redhat.com>
 <c1831b89-c896-80c3-7258-01bcf2defcbc@linux.alibaba.com>
 <87o7uymlh5.fsf@toke.dk>
 <c128d468-0c87-8759-e7de-b482abf8aab6@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 20 Oct 2022 18:34:12 +0200
Message-ID: <87bkq6v4hn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heng Qi <hengqi@linux.alibaba.com> writes:

> maybe we should consider a simpler method: when loading xdp in veth,
> we can automatically enable the napi ring of peer veth, which seems to
> have no performance impact and functional impact on the veth pair, and
> no longer requires users to do more things for peer veth (after all,
> they may be unaware of more requirements for peer veth). Do you think
> this is feasible?

It could be, perhaps? One issue is what to do once the XDP program is
then unloaded? We should probably disable NAPI on the peer in this case,
but then we'd need to track whether it was enabled by loading an XDP
program; we don't want to disable GRO/NAPI if the user requested it
explicitly. This kind of state tracking gets icky fast, so I guess it'll
depend on the patch...

-Toke

