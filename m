Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC41CB43E9
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 00:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733130AbfIPWT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 18:19:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46539 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728917AbfIPWT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 18:19:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so755292pgm.13;
        Mon, 16 Sep 2019 15:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8UPkN0k3OkeEe5RVBJgSIzoiC+//Dzbo9hfdnEI4PA0=;
        b=FvbOBGj3R8DqdGK0/5UefMBFXEROkPq4DDIShm+vvlHDppN8KYeHgTr5Mh4BWkTg3r
         ksKvj/3uVJnehLyFgDW1b19qjH5QmjmbMcf6Z4ZiuDv0hpUPRMdTHTsFHKM89DY8JSKr
         WX9KFakk3hgiKp9xiD/s8JUZBhFec6ZCpkJuE8v2+hmDwqHGJe1nK60LzpkxcCqwbCXT
         VlZpM2j88CLoZs267gbP3CywSj4cf1eWvZ7RPdNHC1RFBJYfWEUQyQH6EkhL1YIZj8PI
         W2cxBKuVSFFkTx0iQYVRmUwlz2yyWPPDoRkYOQoboFipZBqMwz5dR6glyUVJsIH2W5N5
         VbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8UPkN0k3OkeEe5RVBJgSIzoiC+//Dzbo9hfdnEI4PA0=;
        b=i5MXDQxIaeXJbeqs3o/T+PeSff+SRqqnQvd7qQE4BdfO3CCpIlA88GcOD+OL94pLeq
         MEChNeCduXz2WjzLUekgc0XR84psrQvSqBmMfcrALRIOz/wU++316cmf0nJvBMnpJm8K
         K1AZo6z75rl9BnGSVr5spKjJJSI+gILOR1FCOS+WyVWcPz9XK+7XHnuJDj0vv1NVjk4Q
         6QOENtuE8g4w36QaaBzKlTzuVEtKORMDwHZmdpCXRlmTbRGUUSeqwpyw0k1EpZnD1Xdq
         RHLS09g8vDHsqXo4OwQwRCULmqdWI+6BIli7KT3vnBM+0UqSv0aiAwS58qlA2bCPza6L
         DCqg==
X-Gm-Message-State: APjAAAV1hs3uxe026nYcNkvM/U/a9AfWh8JHqLsIpIC8pwgqMdTS1oQY
        bt9TUUxXm+lLU0qpwaA3V2w=
X-Google-Smtp-Source: APXvYqzEtcFgFdGhZnGrAsLh5bwceSi2fn9huT0JXWl0jMtxI+QnVBcxv/GJK0eLMjVdIXZHff/H7g==
X-Received: by 2002:a62:5ac1:: with SMTP id o184mr672863pfb.67.1568672398573;
        Mon, 16 Sep 2019 15:19:58 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::2:9e66])
        by smtp.gmail.com with ESMTPSA id f20sm82638pgg.56.2019.09.16.15.19.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 15:19:57 -0700 (PDT)
Date:   Mon, 16 Sep 2019 15:19:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christian Barcenas <christian@cbarcenas.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf] bpf: respect CAP_IPC_LOCK in RLIMIT_MEMLOCK check
Message-ID: <20190916221954.evj7er2xk22geyst@ast-mbp>
References: <20190911181816.89874-1-christian@cbarcenas.com>
 <678ba696-4b20-5f06-7c4f-ec68a9229620@iogearbox.net>
 <4f8b455e-aa11-1552-c7f1-06ff63d86542@cbarcenas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f8b455e-aa11-1552-c7f1-06ff63d86542@cbarcenas.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 07:09:06AM -0700, Christian Barcenas wrote:
> 
> bpf() is currently the only exception to the above, ie. as far as I can tell
> it is the only code that enforces RLIMIT_MEMLOCK but does not honor
> CAP_IPC_LOCK.

Yes. bpf is not honoring CAP_IPC_LOCK comparing to other places in the kernel,
but we cannot change this anymore. User space already using rlimit as an enforcement.
bpf_rlimit.h hack we use in selftests is not a universal way of loading bpf progs.
If we make such change root user will become unlimited and rlimit enforcement
will break.

