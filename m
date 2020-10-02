Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B214828175B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 18:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgJBQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387856AbgJBQDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 12:03:09 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912E4C0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 09:03:09 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s2so1301319pgm.18
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 09:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=E4Qed5f4PPfa2+kwFerLIwM88C8GTQsQcm2i22EJA4A=;
        b=Yc+fr9v7mG39Fn2HJU9HJi+x/gdUsYaExTEbtLbErBt2vFh/lx6Wsj+XXUu8qYZaDf
         bHCq2hT6zGCmK+02+zKdgw2Ib0O8GICqusuWcFvgA7EEXd3YbhRBE+O6zpqj5sLTLQAZ
         G4GQyQF9Rxqb7J0EE3jVzdPOXqCP2HV0GySdKpCmRkmpLLbf2aCuDrolIgTwKAUnmMRQ
         8fvxYzrjb803aMs6+wIqAcmUtDKy40t1LAO4T0RYIQn4R/hzSKhnOfjAPFfXAQM7+5+9
         FyxtMRttXbW8ctwixhqcxiRORdUN6MZe7Bff008WZXiG4DC5uEnb7aExd9mOdz6mSqYx
         QwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E4Qed5f4PPfa2+kwFerLIwM88C8GTQsQcm2i22EJA4A=;
        b=pRQMc4BDsvLroeYrr90DlpEwLdJagmVcsC/eUaqivojHATI009LI/R48JNPRNGIjTw
         ILnZYzTMzN82ZLnJIcrlr6sk8IAJfCAzdrX1QWsuvLOm/QTs0g6+GEPv7IoIUhKIJ6K7
         HmCoRuCQQdO+avv5alO1sfPhFOSw94xxQ5A4GWeOSrwoQFd0a3G3TpbU/390z5CCSdfP
         IRt7pU6PxA9zxUnRnVURTCu0Kzdk59J7nAgiR0YilEdNGAiAkw0Ngxihggtsw3j3qUMZ
         bjko4YBQAvLoKSgcQDeJdELDzJ4LPfkDJkZqv0XiN/GcAUbx7dQ/055rljKwxGHNM1n1
         uamg==
X-Gm-Message-State: AOAM533qjYlLcVx/X3lCwiJc/kYO9W/kyE+e6lmHkevNWeXyvq3h7p7v
        woSPEaVKgUltqrsds5TCimgjpx4=
X-Google-Smtp-Source: ABdhPJzWIGXQ2gCrOYJlvG1/+1R/2hixN85sq06CdYv+tiJNXM6h50KKasSBJolZz4XTOdvN9rZX5ko=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90b:4a4b:: with SMTP id
 lb11mr3331428pjb.111.1601654588631; Fri, 02 Oct 2020 09:03:08 -0700 (PDT)
Date:   Fri, 2 Oct 2020 09:03:06 -0700
In-Reply-To: <20201002013442.2541568-1-kafai@fb.com>
Message-Id: <20201002160306.GB1856340@google.com>
Mime-Version: 1.0
References: <20201002013442.2541568-1-kafai@fb.com>
Subject: Re: [PATCH bpf-next 0/2] Do not limit cb_flags when creating child sk
 from listen sk
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01, Martin KaFai Lau wrote:
> This set fixes an issue that the bpf_skops_init_child() unnecessarily
> limited the child sk from inheriting all bpf_sock_ops_cb_flags
> of the listen sk.  It also adds a test to check that.
Thank you, that fixed it for me!

Tested-by: Stanislav Fomichev <sdf@google.com>
