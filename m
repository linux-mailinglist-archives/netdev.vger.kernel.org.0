Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3E86AD6C6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 06:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCGF2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 00:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjCGF15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 00:27:57 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E9755046
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:27:50 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso6498281wmo.0
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 21:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678166869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8M/ZNHm41J+Clg6mlxXrqT98RL27ba318OGQ7b+J+Q=;
        b=AXz8IE3BfGxvgHWARVu3cvmOd6P97RlW9noY25nWVCy6dXQ2vvPVZ9Py6kBKTNXlj3
         RGGCQe8dv+KR7SlUXWeg4O/QW8LuIHTN3sz2+J49IWOWaWZSnqHG+zwdQuVY+H/pQVAu
         F9xnuSl0vF/CiPxxoqZdBY5As2d0bOFPf01iGsYIwKPrv+7UuMKjhKDUTJ/CjAuIkHqe
         QiF24XnHbg6mgGw/2JMNF1CRC89YDDxSsVTPSCGpyM4sMgyw3xMrNYXJ+P/6jUxfQQGo
         zYkZjnrGLZrVFDSGBEFopoY1j+UVtcWWTiIotD6oCoQoVZsBz60ZhyC3s+t5/o19HC0v
         rNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678166869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A8M/ZNHm41J+Clg6mlxXrqT98RL27ba318OGQ7b+J+Q=;
        b=nm/tjiCQEqsUCluPcDKZnkbp4zhRae6RksCwWA3B4Of60FB065ufDdHHR2bc/IE1/F
         omR3/3nBgjUUyPAj+dzFkKOmmhV2hQdSX9tnmFH0ie/2JGfv3+c0tIBTi+5UD5Asoh+9
         1KGvB8xAxDJ9zNF6qpFa/OARKaBUBUWatY3vffIvF1S9Z0sKH33V0Fncjpv+X9BuU/al
         cJwkto6LtvrY2aOa4PPNoTsKReuM5rlbIBuQT61JGhDrT5t+pukrIXT9BOUdBvawJ6TB
         rtqJcyaC5OUJaxS/IxF9wbn+Z8bYqVEbe35M7VTlkrdOjaD2kuW+lgWkmVTdzrh8gP2q
         /ZFg==
X-Gm-Message-State: AO0yUKVMJWLV1Gnk+vFnbScTD92wPX5wLLPJxtI4kbOXb3mxmlAbsehE
        D5J+fzzWmDJwiECZVjPdPVstmNSbBFpJJFxMWgF4Hw==
X-Google-Smtp-Source: AK7set+xWDoE/FuWr9saZhwuqb1gnA/rnnySOj/6SiypapxLJrV26Ug57td0Fc5DRpB4SqTyaxspNyemmIW2im9XebY=
X-Received: by 2002:a05:600c:688:b0:3e1:eaca:db25 with SMTP id
 a8-20020a05600c068800b003e1eacadb25mr2801113wmn.6.1678166869199; Mon, 06 Mar
 2023 21:27:49 -0800 (PST)
MIME-Version: 1.0
References: <20230307052254.198305-1-edumazet@google.com>
In-Reply-To: <20230307052254.198305-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Mar 2023 06:27:37 +0100
Message-ID: <CANn89i+sfROgQUaNR+eMc2BWxtOjMmLgqsv52A1iLGhyydrBbg@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: conntrack:
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 6:22=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:
>
> Customers using GKE 1.25 and 1.26 are facing conntrack issues
> root caused to commit c9c3b6811f74 ("netfilter: conntrack: make
> max chain length random").
>
> Even if we assume Uniform Hashing, a bucket often reachs 8 chained
> items while the load factor of the hash table is smaller than 0.5
>

Sorry for the messed patch title.

This should have been:

netfilter: conntrack: adopt safer max chain length

Florian, Pablo, let me know if you want me to send a v2, thanks !
