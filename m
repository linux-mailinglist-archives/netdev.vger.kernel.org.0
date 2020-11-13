Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12CC2B25F7
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgKMUy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKMUyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:54:25 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FF3C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:24 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id i7so8071193pgh.6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=YduKD2rXdXWGOe7iQm3bM6ks4nExuiBwwreytNlrTgg=;
        b=Wo48JlEZ89dgUmkz5g8/nRAwhBNwozX//DIvzSSX6xKPc80VSsnM3SRHG6MLFSIR46
         yL0BuaolRcEhXWrboAxa8OVyszrkUuaiEBHOD3xnNrPDjh0pYFUO5aUQXhQQ1y10Yr1/
         fEGBktg4pFaOocl/NK4dEmdQ19I1G+2VHgLTljyhFDU7yTmc4PjfzZc2uueVmlg1bvqn
         LpAuo5S89r9H+wwY9XdGnnHONjhQ7Ewclqi3pB1+hLJ8ovBSvBYlf6WmmKNach4JlhCM
         AuJetWO1yVMiry+gTKOC+NeYOPsGlEqmfeIo/gwBPVlV5UEPJdN7N832+IrVV6EbXpgR
         Z3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YduKD2rXdXWGOe7iQm3bM6ks4nExuiBwwreytNlrTgg=;
        b=AMQlCoJj7LET7s4Fe8kqmsIAq0Tf00hqLrj/LIvrOssZX9ve0E/fmObCqHkviqg1XE
         Q2Hl1JVcU0g+ljZ9MSQXGI632jiVbuiQsv+5Fe2bK0dCAq7COR3GA3nZH4thRIEyFuNw
         v6CbLOkQACUa7rrJOTOVNvo5UWUuT1nQNhLL/iQYqU81UMTUTanNGZhvs8o4asbTjuU9
         NX6NBO5rMExYND6gR9WeT3OKr5MRs0gMBPmaDqxDXVOulgZooZ+UzNX3VwVQyslXOSmh
         V4uRNm9nhSTFce3oKdNQ/XEOu3t2F6StgWokQL5E+oN9HxDovdVvCWAI9UXCzvWcSKxO
         VQwg==
X-Gm-Message-State: AOAM532qxsCO7I61cGcOlJf2q+JoScYo+oj5nPDQzs8xvh2+1rmtLz3T
        hML4V5Un159Qs5z0bZQjdbU=
X-Google-Smtp-Source: ABdhPJx1LTmHtK8uWNvSkPn//luob9UN8kBWpV0PCNtHdENti++LSjyTudapeHdCetubMJU9myGIqw==
X-Received: by 2002:a62:1ccf:0:b029:18b:c80f:cf0c with SMTP id c198-20020a621ccf0000b029018bc80fcf0cmr3551779pfc.24.1605300864445;
        Fri, 13 Nov 2020 12:54:24 -0800 (PST)
Received: from ?IPv6:2601:648:8400:9ef4:34d:9355:e74:4f1b? ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.gmail.com with ESMTPSA id 143sm2962200pgh.57.2020.11.13.12.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:54:23 -0800 (PST)
Message-ID: <30091c4aab58aba9e75fd591becf7a91cd7b46e9.camel@gmail.com>
Subject: Re: [PATCH 2/3] icmp: define probe message types
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Date:   Fri, 13 Nov 2020 12:54:23 -0800
In-Reply-To: <20201113050241.8218-1-andreas.a.roeseler@gmail.com>
References: <cover.1605238003.git.andreas.a.roeseler@gmail.com>
         <20201113050241.8218-1-andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 21:02 -0800, Andreas Roeseler wrote:
> Types of ICMP Extended Echo Request and ICMP Extended Echo Reply are
> defined in sections 2 and 3 of RFC 8335.
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com> 
> ---
>  include/uapi/linux/icmp.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> index fb169a50895e..6cabb6acc156 100644
> --- a/include/uapi/linux/icmp.h
> +++ b/include/uapi/linux/icmp.h
> @@ -66,6 +66,10 @@
>  #define ICMP_EXC_TTL           0       /* TTL count
> exceeded           */
>  #define ICMP_EXC_FRAGTIME      1       /* Fragment Reass time
> exceeded */
>  
> +/* Codes for EXT_ECHO (Probe). */
> +#define ICMP_EXT_ECHO          42
> +#define ICMP_EXT_ECHOREPLY     43
> +
>  
>  struct icmphdr {
>    __u8         type;


