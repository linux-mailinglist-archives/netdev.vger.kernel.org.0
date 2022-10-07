Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BC25F75A5
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJGIyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJGIyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB52A11829
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 01:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665132880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=erTMAY0Lz1mBTM5QiEVhhkwV7oze28OkA0csFjC86zk=;
        b=I6a8ugkvSOCUnReQ3bECFZSeXJip/9ZuzJWf1ItcXtHV9qyoAsGVFc4lS5IYB/EQI7e423
        dlsvun8v/YQq63+f+aiLIlDPG5bDYEUUZ+ZJC4oiU8N0NnsjzSypBWhvLR4yHXgJiw7aVe
        v3dDYMXeRJ85PaDCvXZU8tGHSfI7eBQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-475-lIEnzQJnPSq5nGRTyY4J5A-1; Fri, 07 Oct 2022 04:54:36 -0400
X-MC-Unique: lIEnzQJnPSq5nGRTyY4J5A-1
Received: by mail-wr1-f72.google.com with SMTP id m20-20020adfa3d4000000b0022e2fa93dd1so1186781wrb.2
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 01:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=erTMAY0Lz1mBTM5QiEVhhkwV7oze28OkA0csFjC86zk=;
        b=yG1nv+CiXd0ZQGLMIHHv4kTvO0PhPLYmOXVSTmaPats4lBfkhQD/sPc4YDf2b0sUry
         iy/P/b4L2WctSo3TskRkhaJMY7C+kcYFEk21hOIoe+QQmXoaEqYcVg1hpKW0vYhrgBNi
         yVZF+vMh+rbRRsbXUxXUdGmlo8XiUUVFfv06hBT3KKLEMTkdiKglegiSIuEnSvsiNA8C
         upqBy7Zoxj4oHJg2/Q2sS9gYPQepiGOf75nHMI8VG+9nFYoLGzngJvyUfMVTC13ICJB6
         sQNvXryLwAc0Vna6K2ZiB16vDf6d3DZjLUNIiKTpBYlASkU0BubwCxCgTLYuHrlcEO7g
         f5OQ==
X-Gm-Message-State: ACrzQf0zA/jeQoJ6vNXTdzy3VgLflNCulBSOJ3N3+o7w3tARsZQH/vLJ
        L+AYlSFffqDrzo+rLfNvqSat4CFbVCKliscSBna+8L2drXfKznEVqtGP1PadeEjxSFILlKUV32I
        DFqgu5wgWyo7kwd44
X-Received: by 2002:adf:a3da:0:b0:22c:d73b:38a5 with SMTP id m26-20020adfa3da000000b0022cd73b38a5mr2354741wrb.541.1665132875068;
        Fri, 07 Oct 2022 01:54:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4DF1bSRv8hQLgWk5KKniXnteS+urv1Jd80jb6Ho4Z//modUXSHY7aP8w9k2YsEdsxR69AeaA==
X-Received: by 2002:adf:a3da:0:b0:22c:d73b:38a5 with SMTP id m26-20020adfa3da000000b0022cd73b38a5mr2354728wrb.541.1665132874854;
        Fri, 07 Oct 2022 01:54:34 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00228cbac7a25sm1505933wrp.64.2022.10.07.01.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 01:54:34 -0700 (PDT)
Date:   Fri, 7 Oct 2022 10:54:31 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2 3/7] net: add basic C code generators for
 Netlink
Message-ID: <20221007085431.GA3365@localhost.localdomain>
References: <20220930023418.1346263-1-kuba@kernel.org>
 <20220930023418.1346263-4-kuba@kernel.org>
 <20221006125109.GE3328@localhost.localdomain>
 <20221006075537.0a3b2bb2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006075537.0a3b2bb2@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 07:55:37AM -0700, Jakub Kicinski wrote:
> On Thu, 6 Oct 2022 14:51:09 +0200 Guillaume Nault wrote:
> > > v2: - use /* */ comments instead of //  
> > 
> > Probably not a very interesting feedback, but there
> > are still many comments generated in the // style.
> 
> It's slightly unclear to me what our policy on comments is now.
> I can fix all up - the motivation for the change in v2 was that
> in uAPI apparently its completely forbidden to use anything that's 
> not ANSI C :S

I didn't realise the v2 comment was for uapi headers only. So I was
surprised to see // comments in the generated files.

> Gotta keep that compatibility with the all important Borland compiler
> or something?

Personnaly, I like the /* */ style, but I don't think my personnal
taste should influence this patch set. I genuinely thought you wanted
to convert all comments, hence my feedback. Feel free to ignore it :).

