Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFFB6A5746
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjB1K47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjB1K4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:56:35 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F13302B1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:55:42 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-536af432ee5so261501767b3.0
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1677581741;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0ByzrG1DNrO2v9eUo35sUjr/+tSq62I3qy0upjoBdQo=;
        b=2EHzWpmLkXjtkEecsfe29xtlYImApGzHvssgCOdEf1VUskBNY4kaCqJiqgZg1ePfh4
         RW/GNZoTfr/Bt9ruAl9+8Dn0PuRIlYlhBTEKMQKHcXGFvy2gyEDj64yFgAbk4pZWaf6V
         w1ZKVNb/ZMSWRgjFuo7Rl112o2XkNxkOqNmuloO+FKP4qKfYD3xi/qvdu53OdsiBLQDU
         gtf+QcWGB8oDWKqlJcw4bVv7rwBeHasjJLatFnkrCeR6ki1dGLYH/XczKkfNFsudWvdf
         nxxiL9YRQfk2TUt2UOGISpW9K1LIfcekOzkal5b6kiKo7y5F8W/Uw4+bANkXr8395y9s
         QUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677581741;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ByzrG1DNrO2v9eUo35sUjr/+tSq62I3qy0upjoBdQo=;
        b=H4UPrH7Ja/D/WA+PIsgWN3TGZzThaLer3LwaCRRAyCt5gtpkICReF6nQCtF8onq66y
         ImTKVDqQp6YwlFcTosSbii8XJjCCyCQf5gYcbhWol2P0fTeKGKdNnA8BxwVA5yACK2t3
         OncWw8ITuEzID0al/ihFp2mlAzny04rh2uw9DNPxg7Y8G6sNKREH26EJccMLwSGkDWrC
         2WxMb4ZNnlWTquZ16u6so42i2l0nNrA5DNq9LeaB/dKJvci7N9wLWFhMb0BPTJWZhgvq
         yb+IHfB3dZFQlC3q8nJch5frpLNod7QFiO98pu5V+DKTX9YFqFte0pdCJSAiCU8HyuI5
         EB0g==
X-Gm-Message-State: AO0yUKV3bs9bs9b5OH3beec41sq8bWp+ulNVZyj//098qaUvpRcEdhmb
        uA/7Y+pBPDRwftJhuLZKjBZptRq/zZFGPnT9MqN2Fw==
X-Google-Smtp-Source: AK7set9ClaSSsJq2rMTiGddWyRu2iOmdcVNQunJpI3R5g8sWEdTssHa0N4cEMxJn8QNgO/MVXwsHe1a4kr/2QJsJ4q4=
X-Received: by 2002:a05:690c:609:b0:52e:b74b:1b93 with SMTP id
 bq9-20020a05690c060900b0052eb74b1b93mr2707065ywb.0.1677581741598; Tue, 28 Feb
 2023 02:55:41 -0800 (PST)
MIME-Version: 1.0
References: <20230228034955.1215122-1-liuhangbin@gmail.com>
In-Reply-To: <20230228034955.1215122-1-liuhangbin@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 28 Feb 2023 05:55:30 -0500
Message-ID: <CAM0EoM=-sSuZbgjEH_KH8WTqTXYSagN0E6JLF+MKBFDSG_z9Hw@mail.gmail.com>
Subject: Re: [PATCH iproute2] u32: fix TC_U32_TERMINAL printing
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin,
Can you please run tdc tests on all tc (both for iproute2 and kernel)
changes you make and preferably show them in the commit log? If you
introduce something new then add a new tdc test case to cover it.

cheers,
jamal

On Mon, Feb 27, 2023 at 10:50 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> We previously printed an asterisk if there was no 'sel' or 'TC_U32_TERMINAL'
> flag. However, commit 1ff22754 ("u32: fix json formatting of flowid")
> changed the logic to print an asterisk only if there is a 'TC_U32_TERMINAL'
> flag. Therefore, we need to fix this regression.
>
> Fixes: 1ff227545ce1 ("u32: fix json formatting of flowid")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tc/f_u32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tc/f_u32.c b/tc/f_u32.c
> index bfe9e5f9..de2d0c9e 100644
> --- a/tc/f_u32.c
> +++ b/tc/f_u32.c
> @@ -1273,7 +1273,7 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
>         if (tb[TCA_U32_CLASSID]) {
>                 __u32 classid = rta_getattr_u32(tb[TCA_U32_CLASSID]);
>                 SPRINT_BUF(b1);
> -               if (sel && (sel->flags & TC_U32_TERMINAL))
> +               if (!sel || !(sel->flags & TC_U32_TERMINAL))
>                         print_string(PRINT_FP, NULL, "*", NULL);
>
>                 print_string(PRINT_ANY, "flowid", "flowid %s ",
> --
> 2.38.1
>
