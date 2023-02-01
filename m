Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F22686DD3
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBASX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBASX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:23:28 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77277CC92
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:23:27 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id bj22so7378449oib.11
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 10:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihU85W+Zd6aMHeXdhykYTrwhHFem52+nt0sDgSuV9Hg=;
        b=dt5mB2xJ1htBPMprJ/16I3Fe5aWGMbz7tTewXTpj4OCm1+MmJrr2JD497TquKNoMHN
         92VYPyTmoz7ijxfqN0cULy1dV/30HX2L9c1nWScYyE2bkLfxzzmy8jWfYbNVXnableIV
         f5E34NhScJoGlkDmOfyGYJiOhvNxcMXaBjn1/c/l5WQy9dj94QYEZtKbd0qxHddtuVZf
         haE64Faj07HkyTbrTorbqrajIQUr/PVNM+zf1JDpCmLfonZt5kfIzUb/sDkjHo/2RLOe
         DeTNf3ykV3toKmxQWbyKjuZmX+2MK/PlKbsYwxuqFFBdcK0UbFWg9wa8HEBEwcC91mR5
         BPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihU85W+Zd6aMHeXdhykYTrwhHFem52+nt0sDgSuV9Hg=;
        b=HbXkM1h8nj2LOcWrF+e/tXKqZLd6lvbjmhOhJYMOpBmyKJ0AAXxQV7HO+/TunAL5rx
         pD8Id266IwM2Y9S2Cm7JdBoZyLRObGXzmIx97tiwuOlgDrTQKSfbLm2ktaZgMhpYEZDG
         W+MfsAE/0BgbwUv8NUYUZHLiL4GbeRPGNEvlOGFMMAZFN1zpo88Yxb9rD0ytld8Akumv
         Di7GhQmqE0xNms55rgPXpVUvREskK0tU5VANT7gf7JpKOm7OPanjYwL/7yuWMeirz2YI
         b1ZFOHBeSANJlvIeAE7aDAyy1n9GElFVX7JpOlNAd78cPoP0VF/4CO1We4q2uSQ8HgV0
         rTnw==
X-Gm-Message-State: AO0yUKVAi6uBsj1mwYiFL4id0xzSdO4upeL+RYBU0kk9xIvtXAbLcl65
        8AFow/E9i3DHGdQ535+CdW0=
X-Google-Smtp-Source: AK7set840+JhIUuXC2zC+2ll0AjnRekkaSr9FuLTDJ9UdkiXRPMwgwPQadmSWf/InUVOCDG5VVZPXA==
X-Received: by 2002:a54:438f:0:b0:367:6c7:ba98 with SMTP id u15-20020a54438f000000b0036706c7ba98mr1359647oiv.23.1675275806930;
        Wed, 01 Feb 2023 10:23:26 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:4d4c:275c:ceaf:8c2a:93ca])
        by smtp.gmail.com with ESMTPSA id f8-20020a05680814c800b003785a948b27sm3319580oiw.16.2023.02.01.10.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 10:23:26 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 83C104B6E09; Wed,  1 Feb 2023 15:23:24 -0300 (-03)
Date:   Wed, 1 Feb 2023 15:23:24 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, nhorman@tuxdriver.com,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net 4/4] MAINTAINERS: update SCTP maintainers
Message-ID: <Y9quHA87DkE7iXAu@t14s.localdomain>
References: <20230201182014.2362044-1-kuba@kernel.org>
 <20230201182014.2362044-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201182014.2362044-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 10:20:14AM -0800, Jakub Kicinski wrote:
> Vlad has stepped away from SCTP related duties.
> Move him to CREDITS and add Xin Long.

Thanks Xin for accepting it.

> 
> Subsystem SCTP PROTOCOL
>   Changes 237 / 629 (37%)
>   Last activity: 2022-12-12
>   Vlad Yasevich <vyasevich@gmail.com>:
>   Neil Horman <nhorman@tuxdriver.com>:
>     Author 20a785aa52c8 2020-05-19 00:00:00 4
>     Tags 20a785aa52c8 2020-05-19 00:00:00 84
>   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>:
>     Author 557fb5862c92 2021-07-28 00:00:00 41
>     Tags da05cecc4939 2022-12-12 00:00:00 197
>   Top reviewers:
>     [15]: lucien.xin@gmail.com
>   INACTIVE MAINTAINER Vlad Yasevich <vyasevich@gmail.com>
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
