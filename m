Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31ED3D350D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 09:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhGWG2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 02:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbhGWG2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 02:28:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50B1C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 00:09:17 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so7651289pja.5
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 00:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bhkkYXi3ADOrlZ4EDXCkVoxr0Z1zK3tnngVvHVFWdeg=;
        b=hl0ctl9eQf/deghA9nh2F3A9bSDcalSOUBylDo9UrRj/xMNNvhEBQ47eras39JlOb3
         nDYqMrJ94XVrPM1zhuoWIbTp1ep7unXJtcGWLmljj53mmc7UZgA7ErGQIfs+ac+Tm2e4
         n+6ntjRsOK6LUsLFMHIQDpaajbjAhQ0LDmOmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bhkkYXi3ADOrlZ4EDXCkVoxr0Z1zK3tnngVvHVFWdeg=;
        b=TIpd0K64VPbhBHFwvjuOJlI8wLqzJY2TTAz+fzjCG/S1gHkwGNqNT5cEdAjEJr2jOG
         vNJcxhmfuhhQPlLzWs9BQZG8GyzMyElCNX117lByNYKuWybnkmECakdm7KqKfi8wmI0t
         cpsiZ1OrUXtB9eTVI2RW3dg6MH0cgyqJ8xqyo27qMADFaMfe0hDOedPBliqGJ5ORGgi3
         aASeUJ4eiLYT5QAte81SXT4FdHWCbMjdypy2W7MjvCeJYV3PaiMHZQIsJtTFfLIaWG4z
         VMQdqVA2COxNG1FOTeARff7KyuifzPVtBT5Stmuen3FQGC9i2cqRjgSbrSQC+XuyclP0
         rJ2g==
X-Gm-Message-State: AOAM530/Zk4dL460JJMfgA/U+Iw4P7KIuFQOwTIsn45m48MMIhfUCac4
        tglktf7+Mq5j8PCPQhqfSoiceg==
X-Google-Smtp-Source: ABdhPJwrICfiLeYa9gCBf5xIwAD5tWSH0gN9yJptX5bd7661BAPnf7l+DlYUNUpSWU8tQ54XF+SpmA==
X-Received: by 2002:a17:90a:db52:: with SMTP id u18mr12684832pjx.56.1627024157295;
        Fri, 23 Jul 2021 00:09:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c19sm5895870pfp.184.2021.07.23.00.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 00:09:16 -0700 (PDT)
Date:   Fri, 23 Jul 2021 00:09:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [Patch net-next resend v2] net: use %px to print skb address in
 trace_netif_receive_skb
Message-ID: <202107230000.B52B102@keescook>
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 10:59:23PM -0700, Cong Wang wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> The print format of skb adress in tracepoint class net_dev_template
> is changed to %px from %p, because we want to use skb address
> as a quick way to identify a packet.

No; %p was already hashed to uniquely identify unique addresses. This
is needlessly exposing kernel addresses with no change in utility. See
[1] for full details on when %px is justified (almost never).

> Note, trace ring buffer is only accessible to privileged users,
> it is safe to use a real kernel address here.

That's not accurate either; there is a difference between uid 0 and
kernel mode privilege levels.

Please revert these:

	851f36e40962408309ad2665bf0056c19a97881c
	65875073eddd24d7b3968c1501ef29277398dc7b

And adjust this to replace %px with %p:

	70713dddf3d25a02d1952f8c5d2688c986d2f2fb

Thanks!

-Kees

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#p-format-specifier

> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> ---
>  include/trace/events/net.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> index 2399073c3afc..78c448c6ab4c 100644
> --- a/include/trace/events/net.h
> +++ b/include/trace/events/net.h
> @@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
>  		__assign_str(name, skb->dev->name);
>  	),
>  
> -	TP_printk("dev=%s skbaddr=%p len=%u",
> +	TP_printk("dev=%s skbaddr=%px len=%u",
>  		__get_str(name), __entry->skbaddr, __entry->len)
>  )
>  
> -- 
> 2.27.0
> 

-- 
Kees Cook
