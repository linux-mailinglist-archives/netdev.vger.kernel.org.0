Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE321BD94
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgGJTYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 15:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgGJTYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:24:46 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71816C08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 12:24:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k15so3809260lfc.4
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 12:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=4Vr2AZgZniEXewC9xAQKzNmLuU22NOIzV1lBzaMmNY4=;
        b=ICgcKrJdMrQVfzVYYyLc9LVDmgFs5iCW4N829rjqCff+MNewsk/ItBTvX3dZem4NqR
         GF9A6EqK5RjnpNrvJh1P3RgDIxiCeYGlWjGvaRCi/rMRhMLaBvOigT//ViXCHMEc9gxg
         C8BEhjg1S6Ykm9jwfIStnaNdWzShuhWGzH5ik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=4Vr2AZgZniEXewC9xAQKzNmLuU22NOIzV1lBzaMmNY4=;
        b=SmYup7rNw+uLuWEk/Hq2yiFrcBn97/Q5EPCD/vNwasEwj/6YjZ5gQTlHI+q4ArcyqK
         5tgIJ97M59ZKbW1TsMSDx59+5whrWcDdY8n46zKyYalUY28OMvsHtOMgyOnhM9be0xu/
         xZSLIwopSMKofv8VZOPhshsZHybSpFvRh/ob/49gJvwc8RQVA8Qmb2AMTEJUahCS9eib
         byKhmorYdly2nHEKVFHkF0YQyuch3WVk3IqXN/Y/ISeHiiRLZr3PagELzLul3fS9ydK5
         FWhODEv4Wze5OL++F1g+fsXpsG7UMG4056eLY6fALbTksSoWU1t0kfzbbPX/0XKjjYwo
         qtAQ==
X-Gm-Message-State: AOAM530Uq7WTpVxgpuEDQiSy5uhBRlZiJHRuh6NIQqOJWGkZr01ZNirB
        GWY5th5y9U3sFYn/mv0V3WIf6w==
X-Google-Smtp-Source: ABdhPJxSofShlNFCDTNj5wuUKktPnfqZkNqtTKb3WW9anql7gup+ARvEvEskOAvK9ZYrKZN9JHeOXw==
X-Received: by 2002:a19:811:: with SMTP id 17mr42574455lfi.197.1594409084968;
        Fri, 10 Jul 2020 12:24:44 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id r15sm2193032ljd.130.2020.07.10.12.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 12:24:44 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-13-jakub@cloudflare.com> <CAEf4BzbrUZhpxfw_eeJJCoo46_x1Y8naE19qoVUWi5sTSNSdzA@mail.gmail.com> <87h7ugadpt.fsf@cloudflare.com> <CAEf4BzY75c+gARvkmQ8OtbpDbZvBkia4qMyxO7HCoOeu=B1AxQ@mail.gmail.com> <87d053ahqn.fsf@cloudflare.com> <CAEf4Bzbxiwk6reDxF78V36mRhavc9j=woQiib7SjsQ=LbcGJQg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 12/16] libbpf: Add support for SK_LOOKUP program type
In-reply-to: <CAEf4Bzbxiwk6reDxF78V36mRhavc9j=woQiib7SjsQ=LbcGJQg@mail.gmail.com>
Date:   Fri, 10 Jul 2020 21:24:43 +0200
Message-ID: <878sfr9nr8.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 08:55 PM CEST, Andrii Nakryiko wrote:
> On Fri, Jul 10, 2020 at 1:37 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:

[...]

>> I've been happily using the part of section name following "sk_lookup"
>> prefix to name the programs just to make section names in ELF object
>> unique:
>>
>>   SEC("sk_lookup/lookup_pass")
>>   SEC("sk_lookup/lookup_drop")
>>   SEC("sk_lookup/redir_port")
>
> oh, right, which reminds me: how about adding / to sk_lookup in that
> libbpf table, so that it's always sk_lookup/<something> for section
> name? We did similar change to xdp_devmap recently, and it seems like
> a good trend overall to have / separation between program type and
> whatever extra name user wants to give?

Will do. Thanks for pointing out it. I didn't pick up on it.
