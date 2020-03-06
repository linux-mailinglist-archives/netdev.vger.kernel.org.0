Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED7A17C116
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgCFPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:00:22 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:33743 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgCFPAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:00:21 -0500
Received: by mail-pg1-f176.google.com with SMTP id m5so1213756pgg.0;
        Fri, 06 Mar 2020 07:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MKEmgwlqImsxarOX2o7kC0mazgsEGwxs8c0oeOuM3CM=;
        b=B4vpLS/AUvQrd88ytL5Wvq2bco/f6qnYtm0MQiielcC4LzZ85jVsab+E14oCofZ3MH
         7mPxuNbntryzhL2l22hhupQ+fDhrM+mC4s9zRyiULGqYBFnlzMN5St1z5PsyhD4nhFT2
         /D3k3H71VHU9956jrxPZOLKLUjtFEm5DhaZ7E98ISW+nMERBx3qgl/sfTfq1abrVsNc0
         UgYHMMlRZwTnUbtMDp/Oyon4ULlUGxCHwtzDblx2hjbcIepA6uYBX0WGMgtBaPRFkPN4
         QzXp7/iWC7gbI5QoFDOOL13kkzFvQG1cDQu2YQfXyXEWoMkpLWg7XXEgthI/ySGbJ5Bo
         ma5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MKEmgwlqImsxarOX2o7kC0mazgsEGwxs8c0oeOuM3CM=;
        b=JllNqIhpBwTOye6eVOBXj5sqb/xycBnSA1JYO6aBHu2JrNLSKxYnfGiCxiE3+4SMvU
         Z80ZdwmzC7WvcAqIAF08x99SVKFPSLhjFQqyJn7yMtRxm+QMO92qFpwhR8sSfRTvz+97
         zx521YB9dUnThyaHiZIcYor12XJkmb4sO6oFZSpoHxPz8TLXVUrHanc56Mp0DwDjJd64
         0eST7fORPWJWaawsnSeQPLPF0XLDT4jUUv1lpDgPmUpNwP+6DA87lkBONpVOSGe5bON+
         EkYVkJtPQ1Nz5++r7uUgJdXumWndMNyue6RJ06IaslWXZ/C5Kl0Hs0N+N5YwIeigbRT4
         P9lg==
X-Gm-Message-State: ANhLgQ33CvizxrPn/WjwkhbksDEqXmSxH74px73SntvXjTB2wfNlxZ1z
        OZOTUkpMaD54vxrTBAgfcLM=
X-Google-Smtp-Source: ADFU+vviqkVpH4QiwaiJdmQ+yhFp9Oxc07sYl5jRDmd+qhfObFfVUpP/+vlqlx9bBes/OmEmcvj1tA==
X-Received: by 2002:a63:a062:: with SMTP id u34mr3850216pgn.286.1583506820741;
        Fri, 06 Mar 2020 07:00:20 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y23sm17165459pfb.76.2020.03.06.07.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:00:19 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:00:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e62657bb6fe8_17502acca07205b4b2@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-3-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-3-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 02/12] skmsg: update saved hooks only once
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Only update psock->saved_* if psock->sk_proto has not been initialized
> yet. This allows us to get rid of tcp_bpf_reinit_sk_prot.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Nice bit of cleanup thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
