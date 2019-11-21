Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01284105756
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKUQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:45:07 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:45625 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKUQpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 11:45:06 -0500
Received: by mail-lj1-f174.google.com with SMTP id n21so3943371ljg.12;
        Thu, 21 Nov 2019 08:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=21h+0RVMSN5bPJMsfn8C8MDLWl2wJXcidLyw5k/b5VE=;
        b=CXxgijnbjro9+D2ukT4DYoZobPeP0C4z+Ed8YK2o/dAU8FUUCKWG5Z3DQIHRk4I5Go
         5YVyHs5AWCh78ohQbr9w/b6ATDiLaEtDNutqWpnjYbn3HAywx2SCxfnBl4CmlLJtqT2r
         vRGQ2uh+ZOQleJQzXYdUahozM6tfSsoBtJlatLPnhdI1VoGgdV+BtjKZjh/4EfSkEoTq
         H7eFWE+I2oOKwQ+GqQP9KB5rJyfBh0dEZNwgr36gtoKg7+8LLpMJKJkN8Bnmv3DZaVZ2
         4avPoNFjO/LspJPwHKwCsozOdNYL6IZUQuWwpm7LpJniNil243dE3DA1nIvOsMEvi+p+
         x5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=21h+0RVMSN5bPJMsfn8C8MDLWl2wJXcidLyw5k/b5VE=;
        b=nhESxHnRXqv9LEdl7hnnTcLoTBxKVwdSAARpEXv15GuYo8OKLEFEgqUS4uveiPhRl0
         7rBRHHJ/tWPBtnWJkM1WLGsXYM0FNSbgEA4uk15AHpoJGLxQurahXpBlLsUeTIVj3jU5
         RjYQa0yof8nl3z+d123o20/HfMvs3nyBL1uUM5k2nsvDsOOdF1Ivzus7OOuFfcArN1m6
         jL7DcioGwAPSazJEWl7gqsDglth7SABu7Vf41zOlKDCHOOWfR8W5Scs7vIFgUUDamoTt
         QypB2fGqCr9yfnbBNvtrb5B3EZmpFDu1zlXvviMC53WQwAV5YD/5KGnVYvmHoyEZ2Ut8
         wySA==
X-Gm-Message-State: APjAAAWxf1CcYn1pZ7cvK0Pi5o5nzLToHczmAOmL36eUKwjk4sa070c0
        5xUihy3cMujC6U3qe87vRP+lCH2yDAd8LRNpDxKT7roL
X-Google-Smtp-Source: APXvYqxPP6pX2a3DQ7zx/cfVE3s5CRLYlkFBgnZuVcnBhWS6o+wQohnUz27w5P3JJktz4QNiFfbIomGw4JhOj+xOQh8=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr8769168lju.51.1574354703031;
 Thu, 21 Nov 2019 08:45:03 -0800 (PST)
MIME-Version: 1.0
References: <CAADnVQJ8NN3YV3Dws_V0gAiM21dH0=UDw6G=2O0OhYQ7Jj1CuA@mail.gmail.com>
In-Reply-To: <CAADnVQJ8NN3YV3Dws_V0gAiM21dH0=UDw6G=2O0OhYQ7Jj1CuA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Nov 2019 08:44:50 -0800
Message-ID: <CAADnVQJF3H=8_wLZOcC0jyOL-YsJ7-T5WpiiNA7XvvLOHfhCmA@mail.gmail.com>
Subject: Re: test failures after merge
To:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Olsa <jolsa@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 11:17 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Hi Andrii,
>
> after bpf-next got merged into net-next new failures appeared:
> ./test_progs -n 5/1
> test_core_reloc:FAIL:check_result output byte #0: EXP 0x01 GOT 0x01
> Could you please take a look?
> Thanks!

I bisected and turned out it was caused by audit patch.
For some reason the test is stable with auditctl -e 0
and randomly fails when audit is on.
