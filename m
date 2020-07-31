Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F77234E91
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgGaX3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgGaX3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:29:45 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1531CC06174A;
        Fri, 31 Jul 2020 16:29:45 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id f68so4817780ilh.12;
        Fri, 31 Jul 2020 16:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=a38FZC/Pmf9hXO4DPCWmNXTo7v5Ve8KnwuG37mEb9lA=;
        b=i4uO/QasTnxcnhtWS7rGRh1y0pgJfEXGNdesPwX5vVj2ON7Abkl1xCzjoa0OOwFrU7
         eIIsJGi5Y42u7/eRn4MsyMURezOJIlaZyQCDN9rWIUhJZxvJ+LXubh8tSubGOUTKQUpW
         HduzkH4gAtEkMzIKis7hFVxM3Mazbn2OLGYpmNFm+2prf45ChG0ifYc9gZavMfz82BS2
         YTjSl39KFtml+bWpkp7/oyueyn0TlNi02RImsxGorn1XhKEh7Et7YPrkWcJauZRO5sHl
         r7EkdGuSCETuDZgZ9k6KMa4hxzqAI9yox0hNEjLK6iIVvcq1r7FRBDxpz3m42yEt8w0m
         lKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=a38FZC/Pmf9hXO4DPCWmNXTo7v5Ve8KnwuG37mEb9lA=;
        b=JD74lCXt4ACJAq2NfmlDDKPVj0ouO9t1MCsbJT345cuWsu61QmUhEqScpnFkxwqIxV
         j7lBSNpH6HGHndcXRbDP2kTy1ewZmAEGWMbfWgZZ0jy1VXliKoor5YrUC88xUJQ7gIX3
         p+1lxXVliGfi/bEwNbp5Bz1Gp6Sfuwt6DctOJRbGEvzaKaiIJgYcgF3Y4Ct1wmSW9zHR
         AXWNHP/17MMCGdApDQNPxI5ishuryG6HNGwGfir/k7UGTGpInn2zfl2zYay4hJePaMJt
         auDH5Ilyt/24SE7oY97W4Ha1G3GrBcZP5zFlvBLdb6Q6WPZn5rx9LPB6HQYoID72WsPP
         d0NQ==
X-Gm-Message-State: AOAM530TNkak8iVV+FolDkLg9A8v2eK+gsHWpszGMilk8SUCjr7WK1mK
        KzwXRVXZumzjZl4goAJDcBM=
X-Google-Smtp-Source: ABdhPJyOqqT0+m8jupO5f6pRP4mAD4Vqhi4Qc/BDXfWtgHj6yLQ6FNUhkYe4bOVQu/dWS/8hHyVOwA==
X-Received: by 2002:a92:d392:: with SMTP id o18mr1340581ilo.224.1596238184352;
        Fri, 31 Jul 2020 16:29:44 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e84sm5846206ill.60.2020.07.31.16.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 16:29:43 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:29:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Message-ID: <5f24a95fb63de_54fa2b1d9fe285b426@john-XPS-13-9370.notmuch>
In-Reply-To: <20200731182830.286260-4-andriin@fb.com>
References: <20200731182830.286260-1-andriin@fb.com>
 <20200731182830.286260-4-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 3/5] selftests/bpf: add link detach tests for
 cgroup, netns, and xdp bpf_links
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add bpf_link__detach() testing to selftests for cgroup, netns, and xdp
> bpf_links.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
