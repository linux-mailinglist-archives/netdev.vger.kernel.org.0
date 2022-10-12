Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37B5FCA1B
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJLR5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJLR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:57:22 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F0ACE9AD;
        Wed, 12 Oct 2022 10:57:21 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1364357a691so13807600fac.7;
        Wed, 12 Oct 2022 10:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AdY2upGu3PKFhlNCranhBSH0eiafPTkseasEdjQaa3I=;
        b=L6te7nMBxbCmWHFIiy+cBYPK4VNOG0fe05bq+QjCKa9NbVIsJtlM8i0HdNFgGACCJg
         YOTpdQJlX9bz4/vlP90+SxUSkTYBvnTtPpcEIqdiz4GkypA632KEo7vC1b8kAL4NLBer
         aBE57rcxwwE/CXwJrA5fhbdcC79ADH4thIQaIFJnlI4CeQi7vSSOl2DjmnN05Z5zieGM
         rVkzx8EaxZ+kJRUMoE8ire5IIoLBeTAs1GFq8hNPrKXgnp4J08IW/rdUJhjqHhoAEUxn
         o8jSBm09apszXisgGfDfqF7RxcrhBygJwQMM9vyO/u8lksC+KIuD9ssy1npMRE7t0AaY
         BoKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdY2upGu3PKFhlNCranhBSH0eiafPTkseasEdjQaa3I=;
        b=uu3/eycCQttXPjT/ABbjjrCekAo4bZ+17yXPMs4quoll4+BAPTtcSyal1/KhHQgVG+
         pTZuHcejh/lRPF4xjgYP90emoLFFNYiNqMlDRwrRw/Tc93uNDqxmMCY9+zcUziympA+H
         mtU+8AW2mepaTMgt8ZfR4mWUTLjyanUE2Wy5qS5r+fjXgcbMMDRKJXUVtk2AjVhtwseG
         cJwA4i9CaaaPVDJ5LF+egWUcUW9VYuX42bm1vKyPW4ygLRRV7AfYKHa21EdBHeTgW3rM
         2sB9TRmzUuPd4c+UX8mpPCP4XabDmZgcLwCHs6aRyfKJHgz8ig4S9kIb9uwLAsaftUKl
         eTVA==
X-Gm-Message-State: ACrzQf1eiBZXuJxAb0vu2ay5GcMepJIxLN/x/exKxSwxm8U6wR5PSzCt
        QVcsiMnEHI7ybGdkyWsOPQ==
X-Google-Smtp-Source: AMsMyM4jd4vrIegykWWlvsxsRc7igCBJUc91fX8+i8/IFDevYvTAoJM7djy913Xfh9HcZX1JNOp+RA==
X-Received: by 2002:a05:6870:d187:b0:136:4db6:2980 with SMTP id a7-20020a056870d18700b001364db62980mr3252715oac.230.1665597440426;
        Wed, 12 Oct 2022 10:57:20 -0700 (PDT)
Received: from bytedance ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id p7-20020a9d6947000000b0065bf42c967fsm7554426oto.19.2022.10.12.10.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 10:57:19 -0700 (PDT)
Date:   Wed, 12 Oct 2022 10:57:17 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net/sock: Introduce trace_sk_data_ready()
Message-ID: <20221012175717.GA26425@bytedance>
References: <20221007221038.2345-1-yepeilin.cs@gmail.com>
 <20221011195856.13691-1-yepeilin.cs@gmail.com>
 <Y0ZXiDiqxYb7yYmS@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0ZXiDiqxYb7yYmS@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 08:58:32AM +0300, Leon Romanovsky wrote:
> > +	trace_sk_data_ready(sk, __func__);
> >  	pr_debug("Entering iscsi_target_sk_data_ready: conn: %p\n", conn);
> 
> This can go.

<...>

> __func__ repetitive pattern hints that it is not best API interface.
> 
> 
> > +TRACE_EVENT(sk_data_ready,
> > +
> > +	TP_PROTO(const struct sock *sk, const char *func),
> > +
> > +	TP_ARGS(sk, func),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(const void *, skaddr)
> > +		__field(__u16, family)
> > +		__field(__u16, protocol)
> > +		__string(func, func)
> 
> TRACE_EVENT() is macro defined in .h file, you can safely put __func__
> instead.

Thanks for the suggestions!  I will update in v4.

Peilin Ye

