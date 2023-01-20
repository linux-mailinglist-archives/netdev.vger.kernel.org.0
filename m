Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3576760AD
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjATWt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjATWtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:49:49 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3175150853
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:49:08 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so10397030pjg.4
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ/yFU30ZaQe7SL+ifPv01udy7zfExyq62P60UgZOOM=;
        b=EWy4p9fpkVDvnKrvL23gY7/UdWJ4nXCW8t95seG1lCX5b+N5ogCc13KaYYZmNUPrnw
         Wb48KEl99T9w6w33UffoirV7BYzVJbDWpDonfyn+5JuN8wLfk0ch/5vIpzN5IfV28+tj
         0oRRtfNLg2wf7UiRgZrfUIoU+JnsyVb9yCupDLYoQVQKBQkqpO3l/IKhupQY/f8aMUxc
         pbvdoJ0x1ilew29ZEJM2+0p4rJjwedBlxuu999V+j3pi6bZ0OUmU1sDXc0g9HoOwgBbP
         gUruZoXmYLlAZf+AlB/kYAsOjzR0fvYSOXC/h4SasTsWhEK/pzMkXfvCAGIz8T0Al1IC
         cRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJ/yFU30ZaQe7SL+ifPv01udy7zfExyq62P60UgZOOM=;
        b=fEYloqOfwqszTCsEtQmLziNf37IfkwOU2q0I53ZLgrz5dEj98ExAejc3A5cz9f7X1/
         hVEu5t0ouE+urlcGdkXqmZWAqsolHyRwv07bHAp5cf+ks43N/p51sFDeh++cD7yc6MIY
         4juLd6gHsyqupn5B6gUIFEuBWVekzSf2FHHQMvwr+GlvEWo85si8e/dv2SIHzDTYAsTI
         4k/mvIxVUJJ08pC1HxeNoDrSegmM57FVMEJUzBZT9jXJq9uTImoX5fS6T1EvfJMwatKs
         730KCVuWYWsWSV3dY/kitGCipRjVzKCu9g8xG2Tn2wcNdYFT9cONsYSyqm6hWDJK1GgU
         urZA==
X-Gm-Message-State: AFqh2kq2mJWVhuWMmHqLqBOnNb1XAocHFDo1FvWYct+lJ4cSS9HYKpvM
        DfYXYFF9wrFriW7UsdrSQCtrKtj8fZ7ncsu5L6w30w==
X-Google-Smtp-Source: AMrXdXvQ0aVvDS0bOzE/h5aifh1HB4xJ8ZZ5kVJQikQZhvYxpafJo91ID7/8ufBLPKxHJ0ByucCr+0vV93sQkychbjg=
X-Received: by 2002:a17:90a:3fc1:b0:218:9107:381b with SMTP id
 u1-20020a17090a3fc100b002189107381bmr1734374pjm.75.1674254923608; Fri, 20 Jan
 2023 14:48:43 -0800 (PST)
MIME-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com> <20230119221536.3349901-12-sdf@google.com>
 <833e21d0-c320-7fac-0723-4791c9097f38@linux.dev>
In-Reply-To: <833e21d0-c320-7fac-0723-4791c9097f38@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 20 Jan 2023 14:48:31 -0800
Message-ID: <CAKH8qBtaH0uN9WJ_rhD5bHynvsGjrXK4X61fA+pa8kJwjxxwhQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 11/17] selftests/bpf: Verify xdp_metadata
 xdp->af_xdp path
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 2:19 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
> > - create new netns
> > - create veth pair (veTX+veRX)
> > - setup AF_XDP socket for both interfaces
> > - attach bpf to veRX
> > - send packet via veTX
> > - verify the packet has expected metadata at veRX
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile          |   2 +-
> >   .../selftests/bpf/prog_tests/xdp_metadata.c   | 410 ++++++++++++++++++
> The test cannot be run in s390x, so it needs to be in DENYLIST.s390x.

Ahh, good point, will add, thanks!
