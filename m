Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B8534E0D6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 07:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhC3Frm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 01:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhC3FrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 01:47:17 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11879C061762;
        Mon, 29 Mar 2021 22:47:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y2so5566155plg.5;
        Mon, 29 Mar 2021 22:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1C3VfLzjCTXkC2qKsS67QGxadJ4WA9at0RKzJ4iXaE4=;
        b=WvU6GjTLX7+fvneGZVbEgag6P4mmzVef/M+J+5ln3rXUlWd/kHpfAwlRlDbAEcp43Y
         KUePzrDtGoD9XptqvaZmhb9lQh1h2G5BKPIgoSpD1bYxOwHFRKX9uUn401sdJ4pICoWE
         n1jO4Sor4ya9Iqr7pyDR5OwMDw7bzIo0TZrsWtNqfM7cgDQFwRTHpazZOrkztAj3XfMG
         kWR6umtT54RJmo5I8MzZvjuoZNmwzh1EXFPpL5JuP1WlOqIgPQWSYAUP6T7SZ8sqkeEd
         bqkm4nituwX8WuflE69OyfL2jqKusO2ncieW/f3YkRLk8Juogbg4ouy+p+J/OO/n9y8E
         /prQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1C3VfLzjCTXkC2qKsS67QGxadJ4WA9at0RKzJ4iXaE4=;
        b=aozE0WPYaGoypcDPSzd4+LYuGdNiddq/ZLsH9Manjsshlxdr5baFDSoUKtlX/Bs49y
         n6AP1SmSIi+bvaOKPi7YS05vn7/FhOyxFtQQKhd0sj6xWL3bHP9Ssfrvj+mZYBDKt02z
         GK2K9thYKTWag+D/GZGXT+k9/SwUytIx1TFcQvPGPOfnt92qtnkoQesviB1JNxiFtcs0
         tpD6bzcHJXhpDiLRoSlOvGRgnFp4mkfcvwlfQwEJFAPj8WH/pPFQa4jcX3w9B9eZo0iS
         RGTcrDpDfVuAPHzhJpIFxS7e4jV/5yyOD8bk5xGXCq2CNgpBHMCjT+IX0kbE7bwthxVj
         pz3A==
X-Gm-Message-State: AOAM531B7nqsq++qgphg7PtGrjgnQ5j/cqYxPIXi8IcEKNQgqli1703a
        ornt51MfM7d2YkxNt4AUv/EYLBELvNtEW59OuVs=
X-Google-Smtp-Source: ABdhPJyUGhIKdIh//vs6DVvXSTEmWSY6DzNNfqlX9XlO86oth/9jAlf7bVs3VgEGRx4Agm0w7FGCWOTh3aPLawYPIuk=
X-Received: by 2002:a17:90a:68cf:: with SMTP id q15mr2690124pjj.231.1617083236531;
 Mon, 29 Mar 2021 22:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-13-xiyou.wangcong@gmail.com> <60625e778b72_401fb2084b@john-XPS-13-9370.notmuch>
In-Reply-To: <60625e778b72_401fb2084b@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Mar 2021 22:47:05 -0700
Message-ID: <CAM_iQpUZSJ-8sW6vOrYDXThYiGOkfrqC6ho2T2_1XP0LE4UuBQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 12/13] sock_map: update sock type checks for UDP
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 4:10 PM John Fastabend <john.fastabend@gmail.com> wrote:
> I think its a bit odd for TCP_ESTABLISHED to work with !tcp, but
> thats not your invention so LGTM.

It has been there for many years, so why it is suddenly a problem with
my patchset? More importantly, why don't you change it by yourself
as it looks odd to you? Please go ahead to do whatever you want,
your patches are always welcome.

Thanks.
