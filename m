Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0D157F529
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 15:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiGXNNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 09:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGXNNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 09:13:24 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29631D10C;
        Sun, 24 Jul 2022 06:13:23 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id a14-20020a0568300b8e00b0061c4e3eb52aso6743181otv.3;
        Sun, 24 Jul 2022 06:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CoQ0KoviDbRVpj+LdP1eKJqa/kfzAhSHBZf5JTD1W18=;
        b=XSAWLZsyiD75hw2bgYvivcGJkwP7cyaQ3Z6k5ssfX+4cFHjYtRYRYoFMdtNUcHmDWd
         daa8zaNhkVI2mHr+hvMFw1GXPMI8fz4qsHDi2dgAg9gnDglKxgVCxNcfCyHReqz2ZjAV
         zbPmdujF1xwiZOe/quYsfwnfmbpivn8r+X+xyyIpqPPPTmQzn9IRdoG/BwxMvja6I4Rc
         H9VT/8RrLzl0vG57pvuu+Ikq6XpbYRaPpSlggLVGsIYy4b0I2LD+B7Op+Tun8WecDNRI
         shZBH0AI+l5cS3KfzGCZZN8iGRVFJinWJUedDMxjib/cPLBgKJmHCXvXgoz8CNauDf5B
         OVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CoQ0KoviDbRVpj+LdP1eKJqa/kfzAhSHBZf5JTD1W18=;
        b=DRCyEFEJ12SKLzHRBrYbL1WpvpsYMAMyNVe5qamex/4oNkrk55mO8xslHG2uo3t8hf
         y2BscdWfKoNTgKXXfvzX/hTwtEbuua4h5nBrYCMwfTDcguTxj3q/QGYupkhAda/6ulC1
         4OnidHXvbj2lWGrJnQS6hPSz9PGOlOqT6S6+01xWE6TUUHTGxTnQuoDQFowGphGoQd45
         myJELEp89fkcwCBL+B8/VSvvK/VRSRg9g5rLtd3OXz6hatBgbisLOyUDtDpnVPb0mgCM
         sMUhXOpO5OTgtFynob12tSOLQDuUKockgYZ6e0LDlyqV7z0JE4YpBOQZTFQZZNAVvwdv
         /ofQ==
X-Gm-Message-State: AJIora/NqSUjJEIxw8j/IFxwC1EP6zYUMn4/nvYSwCDxcLen40SXkVh2
        dRrJFYzCOmpvr3dRal5X/FE=
X-Google-Smtp-Source: AGRyM1shTLufFVF7QwpnPzwIswJroi70ssc5QXRWwjSkGCz6E0tki2f0n4m8l6jG/7Iwut/W7PYgxQ==
X-Received: by 2002:a9d:58cc:0:b0:61c:efc0:5c75 with SMTP id s12-20020a9d58cc000000b0061cefc05c75mr2031012oth.167.1658668402451;
        Sun, 24 Jul 2022 06:13:22 -0700 (PDT)
Received: from t14s.localdomain (201-24-138-64.user3p.brasiltelecom.net.br. [201.24.138.64])
        by smtp.gmail.com with ESMTPSA id r2-20020a4aa2c2000000b004359da266b4sm3869152ool.14.2022.07.24.06.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 06:13:22 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id DD0EA35B3B1; Sun, 24 Jul 2022 10:13:18 -0300 (-03)
Date:   Sun, 24 Jul 2022 10:13:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sctp: fix sleep in atomic context bug in timer
 handlers
Message-ID: <Yt1Fbv9t/BBeYe1Z@t14s.localdomain>
References: <20220723015809.11553-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723015809.11553-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Jul 23, 2022 at 09:58:09AM +0800, Duoming Zhou wrote:
> There are sleep in atomic context bugs in timer handlers of sctp
> such as sctp_generate_t3_rtx_event(), sctp_generate_probe_event(),
> sctp_generate_t1_init_event(), sctp_generate_timeout_event(),
> sctp_generate_t3_rtx_event() and so on.
> 
> The root cause is sctp_sched_prio_init_sid() with GFP_KERNEL parameter
> that may sleep could be called by different timer handlers which is in
> interrupt context.
> 
> One of the call paths that could trigger bug is shown below:
> 
>       (interrupt context)
> sctp_generate_probe_event
>   sctp_do_sm
>     sctp_side_effects
>       sctp_cmd_interpreter
>         sctp_outq_teardown
>           sctp_outq_init

This sequence is odd but it is used when handling dup cookies. It
tears down whatever was in there and re-inits it. With that,

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

>             sctp_sched_set_sched
>               n->init_sid(..,GFP_KERNEL)
>                 sctp_sched_prio_init_sid //may sleep
