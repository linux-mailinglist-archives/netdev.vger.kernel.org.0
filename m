Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E936F1174E3
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLISvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:51:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38917 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLISvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:51:55 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so17364128wrt.6;
        Mon, 09 Dec 2019 10:51:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=h+sQ4sK8cIE8NAUw1oXiUPeww5UNSFO+9BWSRabj8Io=;
        b=B7MyiEEhBBSdOrGyxZpoeddOabWDXdGIMSeVgYqQHBdnkK+l0rrIOTeEm/3TAwwiYG
         YUYonnxaYsSCkFWpqddNQ48eiHtJTA5yDTHA5OA6TitCyV4kjXluxix6dMk/HxYn2pNl
         5Dii7XoL+q34CRNPQE1itg647Ho3yImjqoh3jTvkN98E6JVGdOhzV/H91A1wPZPtF1QD
         oEUjQHeAxjVfZGTTYLea0FuhEFBqA3NyL2zGwdJMuvaPE76uAp9JNFd0PhGyunQ/lsgw
         sJm/cDADVbFR+hQx+ApkVW4y3cry/CAxTSs8mlb3rz7rt1iIpJc6Tgreh45pym6WtXHA
         NgjA==
X-Gm-Message-State: APjAAAVmQq6Bjr4LN5iEbrpaWdhxwII/EVYwamAesDwzwbDcwNxu6B+G
        cCVMg9f+q6lgQ7q1/0mWpL8=
X-Google-Smtp-Source: APXvYqz2GpJMlLqv85B7cSey8jLFDodJd7CJ/le5Ct4Rya8RPS47FI9WVWSctcZgBWubsiHCXPmXsw==
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr3739018wrj.344.1575917513422;
        Mon, 09 Dec 2019 10:51:53 -0800 (PST)
Received: from Jitter (lfbn-idf1-1-987-41.w86-238.abo.wanadoo.fr. [86.238.65.41])
        by smtp.gmail.com with ESMTPSA id q3sm433905wrn.33.2019.12.09.10.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:51:53 -0800 (PST)
Date:   Mon, 9 Dec 2019 19:51:52 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Paul Burton <paulburton@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Mahshid Khezri <khezri.mahshid@gmail.com>, paul.chaignon@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf 0/2] Limit tail calls to 33 in all JIT compilers
Message-ID: <cover.1575916815.git.paul.chaignon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF interpreter and all JIT compilers, except RISC-V's and MIPS',
enforce a 33-tail calls limit at runtime.  Because of this discrepancy, a
BPF program can have a different behavior and output depending on whether
it is interpreted or JIT compiled, or depending on the underlying
architecture.

This patchset changes the RISC-V and MIPS JIT compilers to limit tail
calls to 33 instead of 32.  I have checked other BPF JIT compilers for the
same discrepancy.

Paul Chaignon (2):
  bpf, riscv: limit to 33 tail calls
  bpf, mips: limit to 33 tail calls

 arch/mips/net/ebpf_jit.c      | 9 +++++----
 arch/riscv/net/bpf_jit_comp.c | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.17.1

