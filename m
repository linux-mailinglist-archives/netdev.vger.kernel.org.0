Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B90E550404
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiFRKbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiFRK3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:29:45 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C3820BEF
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:29:45 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id x9so6175099vsg.13
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yr4V91Ql5vq5x7R/7c/M8oTVYSEkHQmIFi2ib2ceSOE=;
        b=mKOmlMa7z930ONV/rhit1mBuyHljk5tq6hJV7loQ8v4j0uHmSGNDFlb79LPTIor/Ek
         RfPf7Q8U3iHHZF/GYHR7c1GEsstlToYIVV/gaPMmn0ZkJdeHgqw1s4D7gXIOA9S9QzGq
         hz9cFj4bP3L+5MYKKkoBK7BYYwtrYWE9MqNld48AjYGN2metIlPS83hyxI2oFjrNDR6Q
         WGx7XdCXLFP4Cbsr98xO/CeLh3WW6MiKPqm2ABFXJK+vKRanfFBhEgmCIpDPoHVF6yMd
         IaHbknG0ybx9zJLeSDsdT51iXmUkGeKSW9QJVYtK4ZQMQLrTVr969US0qo7B6m6RO8Jf
         qWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yr4V91Ql5vq5x7R/7c/M8oTVYSEkHQmIFi2ib2ceSOE=;
        b=F91Fnj9JtJmYHOFc6sNghe+597H24DJwe8CtUXQNq863LeImBmhmR3GefcuPsuudP5
         rz74fNtEKjn9R45IAgDZXxy1S6cRUKyYBuOeNlFo8b7jYLnkXckvHIf0Bj+qHNDLXCDP
         1KGJklLbwEHi4Kpuhd48BmG7E1GR30TGuOH+5Q57VuMVHBfyKTs7Srz521zq3dRh4CZ+
         r+sQzxjPLy9KDuElmWq/vPM9idJEbdDScqB1uCBGrxBINyMmxzOfIp/pA1RkxqkX0EsX
         uIOiaalAIRkXp1xjT13cMbzM3Wm1zAHDqVf8Ai1EsuS2Y0HIVxUrV1WZibfzy3PFLLpP
         oCLA==
X-Gm-Message-State: AJIora8f7Wob7t2H7gXFKDeKhqzTHzrlVZElncvTS3Qr1QZh6uIYqWtQ
        NZNt4qOOuN0rYRovkAwZUbGrUH5arDqNr046wto=
X-Google-Smtp-Source: AGRyM1vJevo6RHUo99IO/P/OW6ppipZHQKsXlhD/DWeDAYG/CSipbWI/K6sCmS+kaWphwLSp6kxcmIeJUSGQsVZbNTY=
X-Received: by 2002:a67:f28d:0:b0:34b:a293:a6fe with SMTP id
 m13-20020a67f28d000000b0034ba293a6femr5639204vsk.26.1655548184172; Sat, 18
 Jun 2022 03:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
 <20220609105725.2367426-3-wangyuweihx@gmail.com> <101855d8-878b-2334-fd5a-85684fd78e12@blackwall.org>
 <CANmJ_FNXSxPtBbESV4Y4Zme6vabgTJFSw0hjZNndfstSvxAeLw@mail.gmail.com>
 <57228F24-81CD-49E9-BE4D-73FC6697872B@blackwall.org> <20220615163303.11c4e7ef@kernel.org>
 <CANmJ_FN-U7HOn8+meVYVpUaN9diEwH6aDduCw5t9zk31AoO-mA@mail.gmail.com>
In-Reply-To: <CANmJ_FN-U7HOn8+meVYVpUaN9diEwH6aDduCw5t9zk31AoO-mA@mail.gmail.com>
From:   Yuwei Wang <wangyuweihx@gmail.com>
Date:   Sat, 18 Jun 2022 18:29:33 +0800
Message-ID: <CANmJ_FOHz-=X4piNPwSZ6NzAyi4G-LAR0RiV7y_gb=KsMqe+4w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net, neigh: introduce interval_probe_time
 for periodic probe
To:     wangyuweihx <wangyuweihx@gmail.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
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

On Sat, 18 Jun 2022 at 18:24, Yuwei Wang <wangyuweihx@gmail.com> wrote:
>
> - make this option configured as ms, and rename it to `interval_probe_time`

typo: make this option configured as ms, and rename it to
`interval_probe_time_ms`

> - add documentation to Documentation/networking/ip-sysctl
> - fix damaged whitespace
> - fix missing `proc_*_jiffies_minmax` on `CONFIG_PROC_SYSCTL` is not defined
