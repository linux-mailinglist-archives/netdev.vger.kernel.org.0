Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2151153C30B
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 04:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbiFCCAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 22:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbiFCCAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 22:00:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D09C3969D
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 18:59:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so6214827pjq.2
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 18:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqFSQ7JwrMu9gS/4dQgsYHyf/4qxkz4eNPGGpzXZITY=;
        b=i/Kgrw1Rj0fKj9Pg49Qkv4AU+DYwf8ZXFE+VvjF/yTVYP0bJwkmXluKpL9FHNEcAtN
         /kNixOh2GYdhptkc1OECX4CmsKwbsQU5G/ct4qyohNSdG5+PztJxcC0Rs8iOBneGOCEX
         onHaj6tRl/FkSHAQ3ihoMPEygoOjkeJNwac0qblicqTQ6t7IzYqUAYOxq3Kekv+4jJIh
         etgMO08bb0MdkUXLgq25tAArgu7AVshD9PACc/OLQvPEhdbh5sZgXsqNp1/PcqoBMBLq
         3SdvKRnWHHOGHw0IsdpvPXVDxIxKUiuLPHDvDcmSDtpMNpH3l69+5mjQEDUFUg+lEehF
         0rAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqFSQ7JwrMu9gS/4dQgsYHyf/4qxkz4eNPGGpzXZITY=;
        b=ptqvILcxIKKgKfpUeHws/NTPTBNHzMwnjJhG3i3B6D+wn3uR0o6qCzD0rIOxYDOB11
         ZaPpvVL5cVzttVCpa8+T/0I97c5iYDLeiZa113F7AWFS4GJWTjmJsx7pbhZgdG4rUShs
         2qtyM1BvWrWf0jVz3cMX1R3MyeK2vUgJFLendA2XHejdlNolaiITtSJ0oje8V2gLuJNg
         HYqTjGqJKRdg6I5CDDa0Wv+UQ5/FkUeV3JZrBqSTsyP4dGCme033IOM3vOwo8lhPYcf0
         yg6WKpyZnDdnqHLQu8kfQ4d0gTtik49yEiBmW9nTzUEQwcEn99XsCKrCPG2IEBy3v/WX
         eNOQ==
X-Gm-Message-State: AOAM530f3x+G4UCJLd0NJWHmyJp38Cjd8sV3pTNBGTdHOe1Q7rEpX0A+
        b9a2/FiCQzCdeUDNVGw9VT2dI3goNXqTaKA/dOG3eQ==
X-Google-Smtp-Source: ABdhPJyc3j6ZtNOJqT3kHLnbUcM2qz/0qtcGJgjhUrAJw71cTq3wpbWhIvr/BXKF8PZIjKNQI8wFZ50zKJVkDxM9A8w=
X-Received: by 2002:a17:90b:1a86:b0:1e8:2b80:5e07 with SMTP id
 ng6-20020a17090b1a8600b001e82b805e07mr1844193pjb.31.1654221598859; Thu, 02
 Jun 2022 18:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-12-sdf@google.com>
 <20220603015225.lc4q3vkmsfnkgdq2@kafai-mbp>
In-Reply-To: <20220603015225.lc4q3vkmsfnkgdq2@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 2 Jun 2022 18:59:47 -0700
Message-ID: <CAKH8qBs6Wz+vukFomy7LEyohzM6mumsrgRRcyfy-0J_8drJ3ZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 11/11] selftests/bpf: verify lsm_cgroup struct
 sock access
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 6:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jun 01, 2022 at 12:02:18PM -0700, Stanislav Fomichev wrote:
> > sk_priority & sk_mark are writable, the rest is readonly.
> >
> > One interesting thing here is that the verifier doesn't
> > really force me to add NULL checks anywhere :-/
> Are you aware if it is possible to get a NULL sk from some of the
> bpf_lsm hooks ?

No, I don't think it's relevant for lsm hooks. I'm more concerned
about fentry/fexit which supposedly should go through the same
verifier path and can be attached everywhere?
