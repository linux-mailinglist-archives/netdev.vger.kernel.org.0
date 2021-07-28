Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B8E3D97B2
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhG1VlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:41:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230156AbhG1VlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 17:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627508471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mx31kKBVBEoAlz5cPxD8jYRoivcPG7uJktRgpDD2MsI=;
        b=U2AQjmwgXTVHVtZ+jBDN7IBBom1EsCuuhXV5MdxySyF4gmdkfHNeFvTnivc4RGZ1eM7qU0
        bW3JltT0r/dfQQPGIxRpTrVeZ6T0e19E4yhsmLkk4QFPEMgz6wXsZ/G3sGXus9NmBgLlJO
        //xYbyKdIyZKC2xSm01zGA6+Zc44/EE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-zekqLJAYOH6P4_rJ7rZHAg-1; Wed, 28 Jul 2021 17:41:09 -0400
X-MC-Unique: zekqLJAYOH6P4_rJ7rZHAg-1
Received: by mail-lf1-f72.google.com with SMTP id f13-20020a19380d0000b029037ad1141c33so1644182lfa.8
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 14:41:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=mx31kKBVBEoAlz5cPxD8jYRoivcPG7uJktRgpDD2MsI=;
        b=hrlXFrKVMd8SIiHZHVOKp3KWO2eIFcXIdtm7ZY3oWc/oxj7PUSJidoBidoyBRQrdER
         LA/hraUK+W5BZS1GyeBgnXJLWAWVgI8a7wjAf7isV0zADx/+Z5FPKvT7CqgbRhmgUmfb
         IuNZqbKymcPgoUCgkVGCMgsdQNcbGxd2EDm/crC2ALPhO1oFmWSL0lwmY7hf1O1SAPW4
         605JrA55SdY9bPkMlBBBWO0KLtA8ssPxgoaO59WukuJZxttM1/W1ELj3A/ika4ntr+XT
         tUtFwN6ns8eluYaKrvAgObIYUbSpGjG6zjB3cP3tLDK0miw4anZVTyal9xJj0dUhg0Io
         AjXw==
X-Gm-Message-State: AOAM530W+VMyd9UYkqMKQrBoC+I7F3nL7AzFUC6CC6x2kSv9D9ageVCW
        rVkZE6r7pp+x2FJp8VPCMmq7rvVZ+l+QeydYgyo2XsOrrfl/88P4BIIAEHCKohzsfwIiZy+dpvE
        YGr4TrjfWiTcCarsL3TF71jMiPx7CEs6s
X-Received: by 2002:a05:651c:b29:: with SMTP id b41mr1017776ljr.185.1627508468356;
        Wed, 28 Jul 2021 14:41:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTftXB9O45g6nMRLt/pkUh4eYLoLl27GPuzse0TyHZZQb7f5vlZFRdPNizNt8PqwMI4PIHYSRvmOBJ9zvZlLE=
X-Received: by 2002:a05:651c:b29:: with SMTP id b41mr1017769ljr.185.1627508468174;
 Wed, 28 Jul 2021 14:41:08 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Jul 2021 14:41:07 -0700
From:   mleitner@redhat.com
References: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
Date:   Wed, 28 Jul 2021 14:41:07 -0700
Message-ID: <CALnP8ZYTGAY4UGbZTbVaPJ7+6ziRN5S-7EZTtJg_voaZL9+REQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: store the last executed chain also
 for clsact egress
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alaa Hleilel <alaa@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 08:08:00PM +0200, Davide Caratti wrote:
> currently, only 'ingress' and 'clsact ingress' qdiscs store the tc 'chain
> id' in the skb extension. However, userspace programs (like ovs) are able
> to setup egress rules, and datapath gets confused in case it doesn't find
> the 'chain id' for a packet that's "recirculated" by tc.
> Change tcf_classify() to have the same semantic as tcf_classify_ingress()
> so that a single function can be called in ingress / egress, using the tc
> ingress / egress block respectively.
>
> Suggested-by: Alaa Hleilel <alaa@nvidia.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

