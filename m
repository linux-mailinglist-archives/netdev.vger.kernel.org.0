Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C83D1826E4
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 02:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgCLB61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 21:58:27 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46784 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387501AbgCLB61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 21:58:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id w12so1967306pll.13;
        Wed, 11 Mar 2020 18:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dWvFdO44Kj54hlSYxXpeiqKsW+JU3dNGWlR7+2Sm0+g=;
        b=ctBO863dW2CnnEwYFKPcxYyHIU4eQPldoh3fMM+a6qMZk0gX5FqcHKo8rZ15B5CriG
         C0EKw2eDmdXfsP+7IhZpztKkAKTbUpIoZA+mkp4QCAdEetjPVJsaKqoJpO53aOcIm8A4
         alaTMyIi5wR3/Ni2wqYbqS2TLsegHf3kE9pHHNFljeLvbw7MOkwdwnqMhHEGSIrvFIaf
         Whib6P/5PJaalsdbh7NDS6kFOXuc9sPZ6KgI4OZrOtyX/HPXVSkHx+3YBy3eA5LDVDAd
         +sbc7j+1Stjon5v2Xp2TmBjlL1rTyLCww0DkWMRH759BQr2OZMYl9QcnVUzfIWDRhXTb
         77UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dWvFdO44Kj54hlSYxXpeiqKsW+JU3dNGWlR7+2Sm0+g=;
        b=Ph4ShzGAtIMgqD+19Eth4yUsITXeg/89KGTjnmi3+EBkAyndKY+waYtPOOB1PrVmfH
         xDQd1cXk7nQYb5NPIa/639/d6yeNX+WRwbzVi/+rBq7798lhp129t5udNjkpqmVxQaC4
         3Rj0/Ntr035/ZukF2YtV/JQrJDeXn74YDlIfqBhExKjhJoRhO9NgdlsKd/s6mTZMARZf
         VXGhmHBnShnUc9owO+FUP62G+w0R4Zf1+HXE5FgkxtQBvQ+pmBeIuDovOFF4MUJt2AiB
         qZym+yjMwkbFR/j0llqmRJt5pQcjI5Kpro/kFstw38YH5otAbS6f38wdt4aB+Dbn7P2y
         j79Q==
X-Gm-Message-State: ANhLgQ12r3YfyxEMgBODBnylw8HIKnylP2YiBSn+qJvvRQqPPyx/yjk8
        Qy1GCgMRHjFvbfLeTr9u6NNjCIqE
X-Google-Smtp-Source: ADFU+vvIo+wMmnV71g5J6fSq9m5ap5omMtG+rrVqWBf6Jvg2f9GwhWZCE5mmbgGD5sX6op+lxpYKDg==
X-Received: by 2002:a17:902:8307:: with SMTP id bd7mr5618919plb.74.1583978305728;
        Wed, 11 Mar 2020 18:58:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::7:6792])
        by smtp.gmail.com with ESMTPSA id 70sm7100686pjz.45.2020.03.11.18.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 18:58:24 -0700 (PDT)
Date:   Wed, 11 Mar 2020 18:58:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
Message-ID: <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
References: <20200310174711.7490-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310174711.7490-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:06PM +0000, Lorenz Bauer wrote:
> We want to use sockhash and sockmap to build the control plane for
> our upcoming BPF socket dispatch work. We realised that it's
> difficult to resize or otherwise rebuild these maps if needed,
> because there is no way to get at their contents. This patch set
> allows a privileged user to retrieve fds from these map types,
> which removes this obstacle.
> 
> The approach here is different than that of program arrays and
> nested maps, which return an ID that can be turned into an fd
> using the BPF_*_GET_FD_BY_ID syscall. Sockets have IDs in the
> form of cookies, however there seems to be no way to go from
> a socket cookie to struct socket or struct file. Hence we
> return an fd directly.

we do store the socket FD into a sockmap, but returning new FD to that socket
feels weird. The user space suppose to hold those sockets. If it was bpf prog
that stored a socket then what does user space want to do with that foreign
socket? It likely belongs to some other process. Stealing it from other process
doesn't feel right.
Sounds like the use case is to take sockets one by one from one map, allocate
another map and store them there? The whole process has plenty of races. I
think it's better to tackle the problem from resize perspective. imo making it
something like sk_local_storage (which is already resizable pseudo map of
sockets) is a better way forward.
