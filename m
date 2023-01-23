Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1736782F9
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbjAWRW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbjAWRWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:22:53 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DBC6A7C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:22:46 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-15ff0a1f735so6506491fac.5
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iV7xTuqDPuMS5TGtVcxuX2q5J84XhGpf3ROd8RPLafM=;
        b=eBnyHg9SCw9ra7ym+A8Mxirv74+X95xh9Unag8Cp3SFi3zCW62Y4a70pc1UgiYYkJv
         iNWO7eii+UwKsmIR5dx1ybda+qO2hYwmL2cWKOxtY+sDcw9oMSEIlMlTYfytJcghhf+s
         w0RkILMpbjnjzBlQ3nuOGexX6Ng03EH5WWSt8Yb6Yu8z3/4bfKrH1slWGHWxsRaP2kr4
         WkA92+OAb8xa0hgod0gH/I6+2MXca+8LHD19fcCrW0eYA//wvPutvCAFCS+gxfSCkIUk
         XEFYOoiL/2Ky0uRyJVDEk8HYkxD9l1G0xCPjmBr7PHJrS03C5dxev+iiYubbRLUdd5T3
         pm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iV7xTuqDPuMS5TGtVcxuX2q5J84XhGpf3ROd8RPLafM=;
        b=1ef+rYltrCPKjshSGm8ZpVvy09291JhLTHUu6oDl1qywQ8rTx6rjEl+kZINQOFBJZO
         FIVBFV2hQo2iBKG5bBam+fc9YiUFM6z4uESdqvTwZNf2lRNJCQ+WEeMfEAO/CTNKVsLY
         /+FtFGwfSxwdVqhqUZ6C+co3u0fFo/K/4DOKDSWlePC9EzyrGj55es68V0Kmqgj23Ey5
         kNJyHYccDFcD7nJ92gWd2WSsEYQ9/4EmUP+pTfP1Iw24e3TP1aR6Z1jnYHeoVXHthAEw
         SLtBFnATUIT/5VUD0to+6iC1lt/y+gcl7a/gGuPrYrcazgSOFhCs0E69/ezhy3fF9dZk
         SbGQ==
X-Gm-Message-State: AFqh2kpExqxNSr1V3YzBCVzdA3lQFBfDICklrlfOA7KUWOi4vN+/cH0x
        uic/l7BrJnbYHGRjrqmISEY=
X-Google-Smtp-Source: AMrXdXtCWPUC4dIFxkS0pSrXt6FcZDUueY30IpLR+MoxBe75mi+UXTn9heV5MUV/VWNrEvw6hMlr1g==
X-Received: by 2002:a05:6870:81a:b0:15e:ad43:9ae1 with SMTP id fw26-20020a056870081a00b0015ead439ae1mr14682847oab.8.1674494565816;
        Mon, 23 Jan 2023 09:22:45 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:d30f:6272:a08b:2b30:ac0e])
        by smtp.gmail.com with ESMTPSA id m17-20020a056870561100b0013bc95650c8sm7252555oao.54.2023.01.23.09.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 09:22:45 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id C6AA84AEC8A; Mon, 23 Jan 2023 14:22:43 -0300 (-03)
Date:   Mon, 23 Jan 2023 14:22:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, lucien.xin@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH net-next 2/2] act_mirred: use the backlog for nested
 calls to mirred ingress
Message-ID: <Y87CY5aQwZAcVU1A@t14s.localdomain>
References: <cover.1674233458.git.dcaratti@redhat.com>
 <5fdd584d53f0807f743c07b1c0381cf5649495cd.1674233458.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fdd584d53f0807f743c07b1c0381cf5649495cd.1674233458.git.dcaratti@redhat.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 06:01:40PM +0100, Davide Caratti wrote:
> William reports kernel soft-lockups on some OVS topologies when TC mirred
> egress->ingress action is hit by local TCP traffic [1].
> The same can also be reproduced with SCTP (thanks Xin for verifying), when
> client and server reach themselves through mirred egress to ingress, and
> one of the two peers sends a "heartbeat" packet (from within a timer).
> 
> Enqueueing to backlog proved to fix this soft lockup; however, as Cong
> noticed [2], we should preserve - when possible - the current mirred
> behavior that counts as "overlimits" any eventual packet drop subsequent to
> the mirred forwarding action [3]. A compromise solution might use the
> backlog only when tcf_mirred_act() has a nest level greater than one:
> change tcf_mirred_forward() accordingly.
> 
> Also, add a kselftest that can reproduce the lockup and verifies TC mirred
> ability to account for further packet drops after TC mirred egress->ingress
> (when the nest level is 1).
> 
>  [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
>  [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain/
>  [3] such behavior is not guaranteed: for example, if RPS or skb RX
>      timestamping is enabled on the mirred target device, the kernel
>      can defer receiving the skb and return NET_RX_SUCCESS inside
>      tcf_mirred_forward().
> 
> Reported-by: William Zhao <wizhao@redhat.com>
> CC: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
