Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D0531C221
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhBOTEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhBOTEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:04:14 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7056FC061756;
        Mon, 15 Feb 2021 11:03:34 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id m20so6297031ilj.13;
        Mon, 15 Feb 2021 11:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=L+DKcIzIeJt7ixsS1TZgOAa0/yaak5A4jgYqb14Umfg=;
        b=VnW0N1/yFF7yX8wRrv4wBbpWADvujkYdVmeYS/Lr7+gkNHPzW3k/eAzbYs2rkKMltb
         AISqiq3vWVny3TRaRBMpcZpLu/Edq1c55lPsK2jkg3ITLKC5HUbReHM2TnSgVjSCzGxH
         nLd7IlsAHV524epvrziyvWuL4tf4D4e49h09WSEyz+ywxTsx5A0N03epopQyeFx+KARF
         grLdshdcBcyCa97jDVyyJfPHHIIatey8VQMMXhtHUt8corKZWFFQmarDlSXVM4iJzR7X
         ut9yA+omlpyKYlx7UzStPxIQglg2l7/5Liz4mH35cixm6guqcbegQCvNPf8GYTcskruP
         VZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=L+DKcIzIeJt7ixsS1TZgOAa0/yaak5A4jgYqb14Umfg=;
        b=ncLwk9DrdJIQ6FU9ohXnqR6ififv2BD4kq8qWs0aYbool/0biaGYWYHfS44jwND4A5
         uc7Zsqej5mvrngqKnN3xrpnqd8jLMCvFESQFgtUDrYTLW07ouCiBf9TbOaCbkG5R1Xop
         lDr/Ai+oRR7r2t4D0Lx5YMklQ6kNGaWzj/KnED35J19vHih1mjY1lByYnamt0lxSCAAL
         8537DSBTp9Y1Op7IMoVRQXL9YQ0TT9FHWtc1DfslZPDm+ShKDkjGRm9H85oww9HwLUTW
         7/jxAoaJM8SiGvH7+uvpSu6WjqAD2vlRHJVOWyc3E6tfk95JbwBufPJ/IVe2rgUbVcni
         cSig==
X-Gm-Message-State: AOAM530xjllvME/KMbDjf4E4+n6uBLJQ+VHKwYjKTK1AtVcacTtgbARg
        ZAPJrVlnWB3Hu5ek2wdtmiI=
X-Google-Smtp-Source: ABdhPJyfX3U4x85B6ky3GEvUf7G6to8CnAInVi/pDgmgi8FAclbW7ggunU7QYlWzG0YxWj15ChiUIg==
X-Received: by 2002:a05:6e02:1a25:: with SMTP id g5mr13915036ile.2.1613415813994;
        Mon, 15 Feb 2021 11:03:33 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id r9sm9958368ill.72.2021.02.15.11.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:03:33 -0800 (PST)
Date:   Mon, 15 Feb 2021 11:03:26 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602ac57e7535c_3ed412089a@john-XPS-13-9370.notmuch>
In-Reply-To: <20210213214421.226357-4-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-4-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 3/5] bpf: compute data_end dynamically with
 JIT code
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Currently, we compute ->data_end with a compile-time constant
> offset of skb. But as Jakub pointed out, we can actually compute
> it in eBPF JIT code at run-time, so that we can competely get
> rid of ->data_end. This is similar to skb_shinfo(skb) computation
> in bpf_convert_shinfo_access().
> 
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
