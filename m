Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3013956E93
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFZQTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:19:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40714 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZQTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:19:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so2707075wmj.5
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1YRbbL1zJVJoWoVoQm9kbJCN2wAbmppSfe/Tw2PYPk=;
        b=IbRd6OnvvUkTULP+hOMTgu+B5eoTjicKyb8rEt0+9b1UwUZ/YGvfAoMQFYtZL3zeWN
         0LW57MBIQIpsg7k0zEFrB9zKbrVu3kDwPxhL0hv/j166zAdOctRGa73in3D8R2QjRdfK
         NVwRyjgnTKcdGhZhO6g0K6JVOCRQO2bP+Awygau5xT8PUL1ahtBAaDAw7xJYp5Lr7tgw
         ujPRJsVJo3W8ytRIsTUiRBcuXCMtgEaRHqYfUDs/7SsC+TMQuf1qvZlbVc2sdSX9reOd
         DU1V7DL/kihlGJRp9VMRXiI5uAP2dvPQPeNS4jEepjVIgzGjZcmNtzaYGkf1ZzurnxtV
         REUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1YRbbL1zJVJoWoVoQm9kbJCN2wAbmppSfe/Tw2PYPk=;
        b=Yt4p8Je3x6LJLrU5RxFS749XveEEyFhAPUxsdxe3v3irDNdkIc9Omm4MZ4CnHPHYte
         Jc4rqCKvCt1307t/biN8DK5MKmv0OUCujwZmxtElG3MADhiADJUWX8iEyAN/tFme2x4y
         SCjlbUrOqUTziwdL3zjegGKhFZwKanftbu1yWQwrzQoFxt6ooiaMEQI7dDk/kXFxp2b2
         R5S1C6mGvRPQloXbZWwlJ25DTyKGuyUEmrKCf3Yn72mC1xX3IGpQQ9bpgeXfZ0rDdyBw
         q+9Q9Je50X7epvhPOXVSeqQgR7Lm4enG5ThwsPg4i622uaVGfWw0uaeHazL/zbo3snPU
         rfyw==
X-Gm-Message-State: APjAAAUldxr+c4dUq0ZlFTUV4QxX4o1boamlv6SZ2KcVn3AcuaRRKwo0
        jcQQbQWtobrTIXtWWt6nnKI=
X-Google-Smtp-Source: APXvYqz9fHRdlw56KVONHKrO4GSya+zHyIQ+SbFU99EZmwAy+pF2Sr2aNClGXy6rJCMMFXBz3bqZKA==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr3406209wmk.40.1561565945170;
        Wed, 26 Jun 2019 09:19:05 -0700 (PDT)
Received: from eyal-ubuntu ([176.230.77.167])
        by smtp.gmail.com with ESMTPSA id 128sm3748252wme.12.2019.06.26.09.19.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Jun 2019 09:19:04 -0700 (PDT)
Date:   Wed, 26 Jun 2019 19:18:35 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, jhs@mojatatu.com
Subject: Re: [PATCH net-next v2 3/4] net: sched: em_ipt: keep the
 user-specified nfproto and use it
Message-ID: <20190626191835.1e306147@eyal-ubuntu>
In-Reply-To: <20190626155615.16639-4-nikolay@cumulusnetworks.com>
References: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
        <20190626155615.16639-4-nikolay@cumulusnetworks.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On Wed, 26 Jun 2019 18:56:14 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> For NFPROTO_UNSPEC xt_matches there's no way to restrict the matching
> to a specific family, in order to do so we record the user-specified
> family and later enforce it while doing the match.
> 
> v2: adjust changes to missing patch, was patch 04 in v1
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/sched/em_ipt.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
..snip..
> @@ -182,8 +195,8 @@ static int em_ipt_match(struct sk_buff *skb,
> struct tcf_ematch *em, const struct em_ipt_match *im = (const void
> *)em->data; struct xt_action_param acpar = {};
>  	struct net_device *indev = NULL;
> -	u8 nfproto = im->match->family;
>  	struct nf_hook_state state;
> +	u8 nfproto = im->nfproto;

Maybe I'm missing something now - but it's not really clear to me now
why keeping im->nfproto would be useful:

If NFPROTO_UNSPEC was provided by userspace then the actual nfproto used
will be taken from the packet, and if NFPROTO_IPV4/IPV6 was specified
from userspace then it will equal im->match->family.

Is there any case where the resulting nfproto would differ as a result
of this patch?

Otherwise the patchset looks excellent to me.

Thanks!
Eyal.

