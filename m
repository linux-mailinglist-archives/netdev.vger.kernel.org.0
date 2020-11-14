Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72002B3139
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKNWqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNWqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:46:22 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D560CC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:46:21 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id l2so13211412qkf.0
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bVCSUU/uj/utaT9rkZEZGrrU6ZwquVHeGzxjO+usyeg=;
        b=ca4f9kfWlAzK5biHscPNK08cD7bUTocm6syQeyDAkskMgt4mxdkZ2jFyYU8YcnVtqs
         B3fVgNK4KeV7KeZhFSSUeLmERfv8wT0yIOgy3zAe5DNutIvmwYYqpUNWQWZXfQ0fmRoo
         NEy/mdzFWPlERgz6Y/MGA+FA7N5DGrE7bl8n0zWa0cgKjndHGHNnrP9XoPIpbYkqBF/M
         xvmO9+LrCSbf4CrZfSZtd+T0h0VCeCBl6gpuIg82g5W7PbTJpXmwcwx5TmWK/l/ydPOD
         Y7WEAHeVad3v2i0ou1M5Mo92DpRh9YL20AfpNafCpLzG9NWDMr09WrpMb8bg7zpImV09
         VEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bVCSUU/uj/utaT9rkZEZGrrU6ZwquVHeGzxjO+usyeg=;
        b=qQDaGMnoGyDwlfPGml7lmoX8HFw9tC2jb5ug2aGxSaHCn5fHfJMHHPir4C2zvybtwF
         lLePMBPPL5wkzx0s9H5tINzYpda42ruJbOpVRkAjhB+W7VH1qiD8T74ZAr+NNa5zrUfZ
         fFv0zHGC6le2Z5T8vS+TsstmaB2WkJDEq3LJ0dgQ31o/Dcgr21jnnDATuthAcPqGUOoS
         Xn8KX/lTa5w0QoE0ImSHJ0JlLlK0bzwFgeJmwuskYhVF4pP5B6sZv4s0ge3RAlPUdi8F
         9/9tWkSbhvOHZReXAf3sWOn01qRNx/JVRzt2KM89QhaCZouDnP0VA5S+Ui9mK6dNYf/L
         KGEw==
X-Gm-Message-State: AOAM531XevIlggSYUvGpad32uuUd3WNdKWPKrCoPeTDZsf0oxF0k1P7B
        k+bfE0WAUoDc03HTORgWkfw=
X-Google-Smtp-Source: ABdhPJwznu6/v7NBYq5TvTIVUkwdv7QGweJ4A02AhBBzF9wqRNtVufItatHTk8L1LSMbN423DWNhwA==
X-Received: by 2002:a37:ac11:: with SMTP id e17mr8281664qkm.238.1605393981019;
        Sat, 14 Nov 2020 14:46:21 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:9364:c85c:d058:8418:f787])
        by smtp.gmail.com with ESMTPSA id p72sm9862280qke.110.2020.11.14.14.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 14:46:20 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B4915C2B35; Sat, 14 Nov 2020 19:46:17 -0300 (-03)
Date:   Sat, 14 Nov 2020 19:46:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>, Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201114224617.GK3913@localhost.localdomain>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 10:05:39AM -0800, Cong Wang wrote:
> On Wed, Nov 11, 2020 at 9:44 PM <wenxu@ucloud.cn> wrote:
> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > index 9c79fb9..dff3c40 100644
> > --- a/net/sched/act_ct.c
> > +++ b/net/sched/act_ct.c
> > @@ -1541,8 +1541,14 @@ static int __init ct_init_module(void)
> >         if (err)
> >                 goto err_register;
> >
> > +       err = tcf_set_xmit_hook(tcf_frag_xmit_hook);
> 
> Yeah, this approach is certainly much better than extending act_mirred.
> Just one comment below.

Nice. :-)

> 
> 
> > diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
> > new file mode 100644
> > index 0000000..3a7ab92
> > --- /dev/null
> > +++ b/net/sched/act_frag.c
> 
> It is kinda confusing to see this is a module. It provides some
> wrappers and hooks the dev_xmit_queue(), it belongs more to
> the core tc code than any modularized code. How about putting
> this into net/sched/sch_generic.c?

Davide had shared similar concerns with regards of the new module too.
The main idea behind the new module was to keep it as
isolated/contained as possible, and only so. So thumbs up from my
side. 

To be clear, you're only talking about the module itself, right? It
would still need to have the Kconfig to enable this feature, or not?

Thanks,
Marcelo
