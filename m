Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EB841E41C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 00:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245144AbhI3WuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 18:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhI3WuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 18:50:19 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ADBC06176A;
        Thu, 30 Sep 2021 15:48:36 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id d11so8592597ilc.8;
        Thu, 30 Sep 2021 15:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Pag7zgoHZ+BNdk4C5f2J6xPTwZR0FZPwgx6uGE49y3o=;
        b=nSh3AuosI4LbU2AuULLrkvvBswNZilhqHmLBpyrmmB+OWFSxScYvkeh4Tz9o8WrOvY
         hX8WOo460cxgt3bETHdbn/eiNPixE7PsUpPMX/VUCAAjzq6u8eL2Z1u0sHbDEaXxD9s2
         F9uvgOh9o1GL+aCXqxK1GUWcV+d/v4mqSFVjgrqYRZtzt7iu4Ws+t+ZgsM3ow6EH9IfA
         38QtDbYq2Lgfb9b8FUsJMm80WWtR1KcS2DF+AUgEWjJdPZPTpO81O92BAUQFmvAs1mmx
         Y+SzbLofh1mK9bCpE2W1WpGLPZzCKMI1jrL+uAzVbr5NdM+tAy97LpSLpY5Xr9jSlk2k
         mRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Pag7zgoHZ+BNdk4C5f2J6xPTwZR0FZPwgx6uGE49y3o=;
        b=6hvB2j+A/Xy+lugMgMqcfpPRBDDhHBOin36nRI3VZr/fD01umdC3fQDp+QrKJgUb+8
         tM3u/5OxW8ejRuAc2uyQcOiewHapO1tt9NmlClFV21Y3elVrSmju0554nc6ESWI/1id3
         V1gFRn/5kBbNM4mcOvH+8ZXP9jF+htfM63abs7ucGdCoB0E6hEG04Quk0lB/rJKPI0vZ
         6ECTMDHE8sbngSagiwjESOVbQdT7m+eNmeEg/VjUQ38rKawsPgjgvFVaOAG0JpqX2yLU
         N6fJBOuaRZuPfz0tPDE6s2V3/MXfO9avGiFsVSnAv0Eend0Hy2wQAZyVeQUrEWT99kw/
         +gbw==
X-Gm-Message-State: AOAM531pMHrHUcJ9cExUIajFSXU9U5kKV1Dc57M5QI/ASl+Xlye061DA
        wLm0eROVNOM6nkQe7dThoXE=
X-Google-Smtp-Source: ABdhPJzrpXN2wjlvorCigubltK+0WlmJn81EiJkms8feNYYfst/hmcZArir1kcppq3mSkYxUW2gwXQ==
X-Received: by 2002:a05:6e02:1c4d:: with SMTP id d13mr6082287ilg.49.1633042116062;
        Thu, 30 Sep 2021 15:48:36 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id j20sm2370066ioo.35.2021.09.30.15.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 15:48:35 -0700 (PDT)
Date:   Thu, 30 Sep 2021 15:48:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        xiyou.wangcong@gmail.com
Cc:     liujian56@huawei.com
Message-ID: <61563ebaf2fe0_6c4e420813@john-XPS-13-9370.notmuch>
In-Reply-To: <20210929020642.206454-1-liujian56@huawei.com>
References: <20210929020642.206454-1-liujian56@huawei.com>
Subject: RE: [PATCH v4] skmsg: lose offset info in sk_psock_skb_ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> If sockmap enable strparser, there are lose offset info in
> sk_psock_skb_ingress. If the length determined by parse_msg function
> is not skb->len, the skb will be converted to sk_msg multiple times,
> and userspace app will get the data multiple times.
> 
> Fix this by get the offset and length from strp_msg.
> And as Cong suggestion, add one bit in skb->_sk_redir to distinguish
> enable or disable strparser.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---

Thanks. Please add Fixes tags so we can track these I've added it here.

This has been broken from the initial patches and after a quick glance I
suspect this will need manual backports if we need it. Also all the
I use and all the selftests set parser to a nop by returning skb->len.

Can you also create a test so we can ensure we don't break this
again?

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Acked-by: John Fastabend <john.fastabend@gmail.com>
