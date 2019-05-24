Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626292A009
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391239AbfEXUnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:43:50 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46954 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389242AbfEXUnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:43:49 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so4593274pls.13;
        Fri, 24 May 2019 13:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/k/A5c9T6gaLP2pJ+tOkAg4n/fO0cio23a3iFow74S0=;
        b=Ho9CHtBsuKUCyBWkAW/mjh2L4z3Z1e37UaMUcmyPWpvTMGxasUKhFO0rFKuuYl8/EP
         k2Koh2hkBeh1vbIvfXS7Cd0vifZbAqiVxOmWCDrh6PZnmxt78MlcMHas7KIvsRHyvdgh
         23NaAxmNqSN/ouQ8qna3fJnjAORv/mP/y/M7U+enVo6dsPUR3djL2YGM3i5niiZsk5zr
         8cnxjtrF1UUMkr4w77ztbmvbsTKIyHU1UNlPcZxHZPxsGxSQ1UtGn8Rw20BA41Bcg6QE
         5Fe/md8S6qr1HZNPF3+QC5wi1GNcFScwobxYbLnhx06BXlPgcAPAzm81s8+mREDlrHH/
         S/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/k/A5c9T6gaLP2pJ+tOkAg4n/fO0cio23a3iFow74S0=;
        b=JBifNTmciaCoZzGx+f9Cw04R36K9JQ0LrTCxVqFoyEzZAXDD7o0kNB1IpI1bIlvsMz
         BQRMa3Z529on8ftya5P2iyOXGzcSYptSnae18ZUFTupUA9pVd8gW4UR8zGCmdBOMRqkM
         x2Lfu6ucXPs12eF2J7qKxuQqoHzgINTGRil8/JEijmB5Eb3qGcISy8Oko6ROeq9au4Ng
         czKN40y4o05OEZzBmM0Do6RPPYGjhwd9ELM7MaFJ5Z6TF4KsxHtBS6S+H8eTAHLBBiR8
         ljpDePmApqKawWhMfr2rnqG9gjARMio4R9x4JyzTH6818Ftw46Y4kwiDFHBaKdct1GwE
         6kDg==
X-Gm-Message-State: APjAAAXaI6jhHXv0WTdPOFSGmfcUWLbhffplPyVBy6QhSHdrGBuEsPFY
        aaFqpaIapcwkK9WlD1pO+bs=
X-Google-Smtp-Source: APXvYqxbfVOU1z1dSJ3w8p3a7MygfoOTGdRThcymLv48MhA9X4o8OfU8RcJCVQcK4LdK8IUHMCZmWQ==
X-Received: by 2002:a17:902:8ec3:: with SMTP id x3mr53195885plo.340.1558730628947;
        Fri, 24 May 2019 13:43:48 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::93e9])
        by smtp.gmail.com with ESMTPSA id b16sm3534317pfd.12.2019.05.24.13.43.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 13:43:47 -0700 (PDT)
Date:   Fri, 24 May 2019 13:43:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        andriin@fb.com
Subject: Re: [PATCH v8 bpf-next 05/16] bpf: introduce new bpf prog load flags
 "BPF_F_TEST_RND_HI32"
Message-ID: <20190524204343.kprqtget3pwireak@ast-mbp.dhcp.thefacebook.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
 <1558697726-4058-6-git-send-email-jiong.wang@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558697726-4058-6-git-send-email-jiong.wang@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 12:35:15PM +0100, Jiong Wang wrote:
> x86_64 and AArch64 perhaps are two arches that running bpf testsuite
> frequently, however the zero extension insertion pass is not enabled for
> them because of their hardware support.
> 
> It is critical to guarantee the pass correction as it is supposed to be
> enabled at default for a couple of other arches, for example PowerPC,
> SPARC, arm, NFP etc. Therefore, it would be very useful if there is a way
> to test this pass on for example x86_64.
> 
> The test methodology employed by this set is "poisoning" useless bits. High
> 32-bit of a definition is randomized if it is identified as not used by any
> later insn. Such randomization is only enabled under testing mode which is
> gated by the new bpf prog load flags "BPF_F_TEST_RND_HI32".
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  include/uapi/linux/bpf.h       | 18 ++++++++++++++++++
>  kernel/bpf/syscall.c           |  4 +++-
>  tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++++
>  3 files changed, 39 insertions(+), 1 deletion(-)

one more nit:
could you please split this patch into two?
Our mostly automatic sync of kernel/libbpf into github/libbpf will fail
when tools/../bpf.h is not a separate commit.

