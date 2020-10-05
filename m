Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA495283D66
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 19:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgJERgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 13:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbgJERgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 13:36:53 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBB8C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 10:36:53 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u6so10047443iow.9
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 10:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEhNeqE2jCOAsEwTKodA8eAmV7E43ESviSFVdgKMdRc=;
        b=Is65unyTHAXLv09OSYHbRePdwCc7l4IKtGsbz7zS+nJ6WMABIBdpkSUAJCqYHagwbE
         4013Ssr5YLWGWuYxypDUfHTzN3ZS4hlv7qDazy1TJz5H9f7Ua5vhBThiw0S9XuflQi7k
         8MSuperBTfCOOPGBHF9Ct3R24b43x2Txczj0Q2yyaPy8SGhV14MWq3wX6SteTEDBLcrt
         tZZqyMZ2yWZikobInvV2r5rRf+nZc89yM4ZUTJpHx5xtqZkV5pDfymFJzu3ua9E/YPIv
         EX84pe13sKLRhdY5Xy6A/V7sydIOkcjtLAzALYPltaayplG1bYXnijWss2qg1YFdSsv9
         DIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEhNeqE2jCOAsEwTKodA8eAmV7E43ESviSFVdgKMdRc=;
        b=iiCrW2Y5E9KANdttYOp8FjyaTbw8hljZ3mKNOtbfNuFMY5gQBzo2a5bFU7LdKAY1iy
         HvWCMJiZiXn6ukFvVzgRf/CI3QNaPj1Tk4NwO8nfihfcDuJNCf2t61jIrLQO97KE0yuL
         fcPAhinUAax5FaMPqWp0PjMjJ58bovZuM72F/UEEXapXmigLyIn4PqvWzVH3LMgT+elM
         31jlz0eN9l+DorpoBjlGazY8czOtle3fMaAd5NpTryole+7t99pv3vuRVClxb86l8RYF
         ryAe/8EplWEKF1otJrUaOQjnsDevXed7bbv4sqAoRxnTOReKbWRvA3wUEVfez+EBnVFB
         Qdug==
X-Gm-Message-State: AOAM533fP9Jz9YsqnUzz2ojSiaxh0yRr9r73G5ORPjdSQupDsgHle9I0
        CnuVTMxUY8BQUjl9po5Odzs1UJrPpjnmCsjfhjRHVg==
X-Google-Smtp-Source: ABdhPJxzXMjpLbbnB7WQJR0r3ek4593dRvwyFwWug+fohLYkK/UU4nFJuZKV3x/oUp2zFTjGCs+e5Kak5DQcuZM8NlE=
X-Received: by 2002:a6b:b2cb:: with SMTP id b194mr800311iof.132.1601919412350;
 Mon, 05 Oct 2020 10:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201001020504.18151-1-bimmy.pujari@intel.com>
 <20201001020504.18151-2-bimmy.pujari@intel.com> <20201001053501.mp6uqtan2bkhdgck@ast-mbp.dhcp.thefacebook.com>
 <BY5PR11MB4354F2C9189C169C0CE40A9B86300@BY5PR11MB4354.namprd11.prod.outlook.com>
 <CAADnVQJmmY_HER23=3bxCrrsbJoNs1Ue__P24KHj3YY1EkzuKQ@mail.gmail.com>
In-Reply-To: <CAADnVQJmmY_HER23=3bxCrrsbJoNs1Ue__P24KHj3YY1EkzuKQ@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 5 Oct 2020 10:36:40 -0700
Message-ID: <CANP3RGfyG9_vj5FkgJz2HV+8voLqP3N+6Qi5hpkqJntF0YSy-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 2/2] selftests/bpf: Selftest for real time helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Pujari, Bimmy" <bimmy.pujari@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>,
        "Alvarez, Daniel A" <daniel.a.alvarez@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Don't bother. This helper is no go.

I disagree on the 'no go' -- I do think we should have this helper.

The problem is it should only be used in some limited circumstances -
for example when processing packets coming in off the wire with real
times in them...  For example for something like measuring delay of
ntp frames.  This is of course testable but annoying (create a fake
ntp frame with gettimeofday injected timestamp in it, run it through
bpf, see what processing delay it reports).

Lets not make bpf even harder to use then it already is...
