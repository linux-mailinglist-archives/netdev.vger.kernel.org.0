Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B2D28BF6F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 20:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404152AbgJLSKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 14:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgJLSK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 14:10:26 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6AEC0613D0;
        Mon, 12 Oct 2020 11:10:26 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id o18so16849906ill.2;
        Mon, 12 Oct 2020 11:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xR8AOR8eDZo7fnV3At7W3eM/Qc/oh+pJSD36MDXE/G0=;
        b=XuDG/L0RfxJB847IqpUl+7XylAB97uctjercI7rUxi+fisT7vSdfkDGz6EV9+lhA+6
         JyLuTVByVAOWbk3Ap7XneG1lV03lstZV+ug/6smlvu/adPx9YGgo4g/KCIGirSS5DVT7
         qsun3dEAT6RkPFCxr45MT/R18e5JJgaCh5iauKnIfvltFHrXMd8CNNSxpLcu4EDENE85
         fBUAw/qOmrojCvE64Sf7FOeOCJ12DDqcA4JL5LDCcXyQS59DvYtL22Mf09NuQ5nobzuO
         z0rSdws9cqOTck4xbTXC3PLtva98DSoScc0TY7tnMriND8yuRQ18YumQNnKxgkbX/JBB
         oLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xR8AOR8eDZo7fnV3At7W3eM/Qc/oh+pJSD36MDXE/G0=;
        b=l6OquZdj5bw9A/M9J9CAt+xX4rPzBxDtpQuR5vMcm6I42haugvCH8EQ0fa9983+0ge
         h7Ts3G2q3UFAhALDLoxMQHMGYu0Jzg1IaegO4JqXWux1aGtuFUtL5ZKP1WT/oGGxtoTp
         bRTBWRG0ehEBXBHHCvlB/QIb+cfL7C4vy2t+vkNjStweMO+mYldsBeojGnFsC0rp+i6q
         1z5DyJFCrIslQFpg40awt+vB3ckgyzM8uDzwO16iD4Nb1+aYSo54YYDvgUBqp3wopm2U
         v4Bm8rbG2YeHg5E/teJeOEyNTGq1pBcNWVEEd9F3omMTk6qXQoQY4je8k3LB6a6p/0qN
         n4JA==
X-Gm-Message-State: AOAM533zwzvuUdDVWmI4oXJYfbeSh8KBin2KmsO/lPHnrnQ4EqpLIk+f
        CYVgaHrWPWXHni8wDuNpXWg=
X-Google-Smtp-Source: ABdhPJz4M4dlw5xD1aH36xOzXW50kJLl2vrns7fVQv+u1NmZ2qNS/Idl9fPgNbgaaJGWeWXvj8so9Q==
X-Received: by 2002:a92:1bd6:: with SMTP id f83mr88501ill.274.1602526226214;
        Mon, 12 Oct 2020 11:10:26 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x13sm5157024iob.8.2020.10.12.11.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 11:10:25 -0700 (PDT)
Date:   Mon, 12 Oct 2020 11:10:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
Cc:     kernel-team@cloudflare.com, kernel test robot <lkp@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5f849c0a5229e_370c208d3@john-XPS-13-9370.notmuch>
In-Reply-To: <20201012091850.67452-1-lmb@cloudflare.com>
References: <20201012091850.67452-1-lmb@cloudflare.com>
Subject: RE: [PATCH bpf] bpf: sockmap: add locking annotations to iterator
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> The sparse checker currently outputs the following warnings:
> 
>     include/linux/rcupdate.h:632:9: sparse: sparse: context imbalance in 'sock_hash_seq_start' - wrong count at exit
>     include/linux/rcupdate.h:632:9: sparse: sparse: context imbalance in 'sock_map_seq_start' - wrong count at exit
> 
> Add the necessary __acquires and __release annotations to make the
> iterator locking schema palatable to sparse. Also add __must_hold
> for good measure.
> 
> The kernel codebase uses both __acquires(rcu) and __acquires(RCU).
> I couldn't find any guidance which one is preferred, so I used
> what is easier to type out.
> 
> Fixes: 0365351524d7 ("net: Allow iterating sockmap and sockhash")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>
