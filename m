Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAB3FD045
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhIAAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhIAAUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:20:48 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7958C061575;
        Tue, 31 Aug 2021 17:19:52 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id b7so1894361iob.4;
        Tue, 31 Aug 2021 17:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xhG57U7JrmDsiFQBDiJGiwHMw7BIlxsGZmvQIZGT1IM=;
        b=FgXx2SCYnR82wLB7jWUrVTIbaiJIKzyjV+hr9V2xall/dI68PdAaMqKmYZ3G5cN0nz
         6d+ikq0al4tPqQFKIxzOZyGS681bk9qmTTFVCHwSx2Z4UFfqx4WwAICo3U9bzzD81Ohf
         xxYqgDWOX8dwUfbjTj6YqCmSGGno6/PBHXzlhjNZ8NGMZBAE/fI6/VJQxNqIjrm0Gw/7
         sY4f0qkDWDt7cMbTsY3/9LgL5CWZJHcBAyOKiNHuBKDJFO6hILTGvaAsvnYQyj216FTW
         2Krgu0iY1LvjbTR8xYJQc3ERtLQYJ2ttuTU3BaWy0GlEhHPCjNKtFoR3R5XOXxk7km8H
         skmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xhG57U7JrmDsiFQBDiJGiwHMw7BIlxsGZmvQIZGT1IM=;
        b=G0M9hjkX5Kjp7ZXTZ5vZmeK8xbgsMBa5exMWsqZSKuirMBr6Z8/2yn9yZGHdhyAnNe
         l3qycTYoZ4ItQIB4GI+2Fo2dmtip8lgRLlQpaPbWOzdgmIQdt7ZM6vlDEOjRBmYXf63U
         hQdmy1uAH9w9ypm4IHBW5HlbKxr6baqYTJQFIFng+tMxpEO/FgVsfMT3TT64W4Ervl1E
         49ufdozixbMCj/ZcRQFJsEXiIYxpLOk/jhqSw5rpBJiw7UjqDTh9H/ifurpnfGdWKFCn
         ebVVYNy5NqEIKPNDFuRzNR6QP1cNII9t4rYHnlseSH089Fiz29upy+AwWayVp0MAZbR/
         KAFw==
X-Gm-Message-State: AOAM5324ogh6kCOW3iteULIRUYlW1Uf4SoZqh44BmQk+ePwQzgdo2A5j
        5F6X23mNKPGcqP4W8wzR19U=
X-Google-Smtp-Source: ABdhPJyTSJxDsX5jj54PlO+UYZLrJwS5pbB9bduKDJfrgZ9XvyMHHCjp5Hsy7IdqDTh8AwrWKieBOQ==
X-Received: by 2002:a5d:9681:: with SMTP id m1mr24660828ion.113.1630455592056;
        Tue, 31 Aug 2021 17:19:52 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p15sm10610283iop.15.2021.08.31.17.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:19:51 -0700 (PDT)
Date:   Tue, 31 Aug 2021 17:19:45 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ec721caf5f_6b87208c0@john-XPS-13-9370.notmuch>
In-Reply-To: <8b4f550ff48f3058b89d0fd5f6d82a922c9c8c9d.1629473234.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <8b4f550ff48f3058b89d0fd5f6d82a922c9c8c9d.1629473234.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 12/18] bpf: add multi-buffer support to xdp
 copy helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This patch adds support for multi-buffer for the following helpers:
>   - bpf_xdp_output()
>   - bpf_perf_event_output()
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
