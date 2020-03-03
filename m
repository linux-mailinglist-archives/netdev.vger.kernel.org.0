Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53478177FC1
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 19:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732214AbgCCRwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:52:44 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:44886 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730142AbgCCRwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:52:43 -0500
Received: by mail-pf1-f176.google.com with SMTP id y26so441250pfn.11;
        Tue, 03 Mar 2020 09:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MzE0w5ZgUnQDQhue+zqO2Bzi6fljQ8hIr+fH2PP/wGc=;
        b=jILafzsqC/V0g5dtcuf/Xa3kbLY2FofgS0c1DikXbePcEH+wKUNX3/GqSm2OzpmW/3
         yh2QzkFaYFMU7OEBQYl7X19vRhCln4h5DPpG9cTTfCz+1ZEhwieERjOhrVe7GXlxXqrd
         wvUOGnnG8QknzsNp7nrwbr8Pvjf1G+AVEb4MnM8N0XGObTL9JpQZok1IrSofAu8P/gVI
         U7TPp/D2OUa1X0z0GDNLgEsWb6N7JIW2m7bLWHGiQdMxc20fsiQEC6sd/3/i4kflzwyC
         jdpH3JlhilGWNepAUWzpU7u2pl5N6aaflSBULT2bebA2rpvlA3WacmUnTm3Jt8tA2bco
         vSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MzE0w5ZgUnQDQhue+zqO2Bzi6fljQ8hIr+fH2PP/wGc=;
        b=HYazkNgY2h+spM5diuvG6qPQimeLIu8VMkruzeWzaMrJSbt2rESVbPdGfClh3Py2rf
         ZqDCzk2zhXBrEdIRAjTir7iYJoEFyiXXUrcbV5Xuk9S2/tTCLg73e/nIynrvv59698K9
         MErUb4tLf2d9B89fUCFMg3aLbybTm9IAdY1+eA8nmn1aDDBNRc887ywDiJN9za0x5VOO
         Lp06BiCRkTFrGvg5PUE9DxtCRAMeAEU/CUjShdx2vwZLfa40gv1ulQzyGcK970tomlEN
         T0Sdbtfqb5+FIdFWpykDmLLGyDgoq6Hxionhon8mvZSKs0AgPl0LJrtpkOh/tTSWCgSm
         BF/w==
X-Gm-Message-State: ANhLgQ3aJEa4792BjYeM1WHZxYCm3AYTlxJMTSeoeTbbIeunSqZvPR9v
        8iED9egaFL7bi+nqmF7omqQ=
X-Google-Smtp-Source: ADFU+vvVYIy44uw6ULK2C86UEzoSOMhwJqP9jcOslCjVbnNrE6OfgP2cPFR7+L2P1rMmLxfjkNLpiA==
X-Received: by 2002:aa7:8b17:: with SMTP id f23mr5288473pfd.197.1583257962058;
        Tue, 03 Mar 2020 09:52:42 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m20sm3315891pff.172.2020.03.03.09.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 09:52:41 -0800 (PST)
Date:   Tue, 03 Mar 2020 09:52:34 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e5e996236c01_60e72b06ba14c5bccf@john-XPS-13-9370.notmuch>
In-Reply-To: <20200228115344.17742-4-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
 <20200228115344.17742-4-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 3/9] bpf: sockmap: move generic sockmap hooks
 from BPF TCP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> The close, unhash and clone handlers from TCP sockmap are actually generic,
> and can be reused by UDP sockmap. Move the helpers into the sockmap code
> base and expose them. This requires tcp_bpf_(re)init and tcp_bpf_clone to
> be conditional on BPF_STREAM_PARSER.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/linux/bpf.h   |  4 ++-
>  include/linux/skmsg.h | 28 ----------------
>  include/net/tcp.h     | 15 +++++----
>  net/core/sock_map.c   | 77 +++++++++++++++++++++++++++++++++++++++++--
>  net/ipv4/tcp_bpf.c    | 59 ++++-----------------------------
>  5 files changed, 92 insertions(+), 91 deletions(-)

No changes just moving code around it seems.

Acked-by: John Fastabend <john.fastabend@gmail.com>
