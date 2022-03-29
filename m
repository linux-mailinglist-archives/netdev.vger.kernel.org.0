Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986F54EB345
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 20:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbiC2SVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 14:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbiC2SVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 14:21:00 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D21160C3C;
        Tue, 29 Mar 2022 11:19:17 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bc27so15519875pgb.4;
        Tue, 29 Mar 2022 11:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4V+A8U9+/U1HY+QmUa76p1ZLk5bcF0qKz/18mpVzUpQ=;
        b=Ff/ZYvYRHhCDvO7p0QwXHMkZZb5HCuQSdZ38sk38zGUcqGghqpsQTCqm8k+KvtuSA9
         2fWYb2RLdARVlK9R5QyQgebE8Rt6l1h1ntLiwpato2tf2EGadJtkSPqPvo3YooCwwBH1
         xM88JqP7QskkE8pcO8o/cqkL1zYtlldY9Ww+mvow4EShNqR3cFN1W26Pbpn+P1w4otu9
         3k3yFnFtXvnCfuW+oBJ3NMZf/F/jVYcTFlJk1JRs2/S0nmnpNjwl4hWJZxQRYqX32eZ2
         Uucp4/QlBIGzsj1J3I0MMIiQtCTiu1w7u9HrTV1t9Gs0LuvGtsajmoUL5nwfaReBTwW4
         rkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4V+A8U9+/U1HY+QmUa76p1ZLk5bcF0qKz/18mpVzUpQ=;
        b=XN1HXLaOb3C6TcYj2pAcaxuUpoCHX5BlWhIF3lY4oCy8n37pqIM6GFhcPeLgjRfkG9
         hullzgHex14TDWD10+TCbpgOxb5JjFwEasyZVF03RG9GTaNFuQ6uXrSSp0imwbzDW3Vt
         d+WSm0pUWDqWRJXV9JWB2OzxhNFgB7DvHjQ8/mJ2H8IJcHMgpHkCBLCbHYhmLdWi9z5o
         FJonB7EGnTt9CWMQ6MtNZiumxEJrgcNW4qHcAXdagpw9q0KuIWVjoVmLG9IkfvtRU9fS
         5ORdCoYuT82EJzBWeq3zCMvJ9vtmro/HH1ErRC1B5OwiDJtTsex5xk3xD4xdTvPlcEFQ
         Fn8w==
X-Gm-Message-State: AOAM530p/QmwjEfO6fdtHJswcdZDn+R9UNpw2Izpq4dv3Rz0LQhFJQAX
        0tMK0ub7AbRekLx03rWelm7ooQeLHDSgoha/4siEx5EG
X-Google-Smtp-Source: ABdhPJy0Q6rWY21BBj88lFiHi3x/iUNMDwcyN5eu27Y5S0YAOy9ROG6O83QyVNFYcMKriy7fPIh2V1r+JGLey8UQoDI=
X-Received: by 2002:a05:6a00:1c9e:b0:4fa:d946:378b with SMTP id
 y30-20020a056a001c9e00b004fad946378bmr29229178pfw.46.1648577956565; Tue, 29
 Mar 2022 11:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220329173051.10087-1-beaub@linux.microsoft.com>
In-Reply-To: <20220329173051.10087-1-beaub@linux.microsoft.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Mar 2022 11:19:05 -0700
Message-ID: <CAADnVQKG0LxsUMFGsFSEA4AqpSa8Kqg5HpUfKzPo9Ze463UDgw@mail.gmail.com>
Subject: Re: [PATCH] tracing/user_events: Remove eBPF interfaces
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 10:30 AM Beau Belgrave
<beaub@linux.microsoft.com> wrote:
>
> Remove eBPF interfaces within user_events to ensure they are fully
> reviewed.
>
> Link: https://lore.kernel.org/all/20220329165718.GA10381@kbox/
>
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>

Thanks for the quick revert.

Steven,

since you've applied the initial set please take this one and
send pull req to Linus asap.

Thanks
