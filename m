Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A2369BF3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243960AbhDWVUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbhDWVUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 17:20:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8EEC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 14:19:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nk8so10587781pjb.3
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 14:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T9yXzQugqh9AHE/cogFMor5jnSvYK0iv9WxUJJcIFpk=;
        b=JkUJl0SPPNTvtByA5BQg0Q32aNv8cKvifeYsGpEgjIKcyc9cb4zn7AvDQPofzAnHbG
         N6nyQEz9Q/4jwc2v+3Y8uFVArBO7c5FTt80sMWgO4CXaD3XJqPPf9u19rie0/XAUAEAh
         b2V7mJML690eWeJyqyoC3EiE1b/Hde+4ZHMyurM2C5MaNfSH3Sc1C12w3XQSq2uexczl
         LtKcXk27xO4t2NrLo0tOxA/bsZlkVvcKBm5+1MSBpcGB73CdIaYtN8vlhkGsRWG5/XuD
         fckjnKAHuYTd25JKThcPhuEpjQhCHUFBPfzKm/JbUzwCuJTN3zcr5BO4pnmmOL/Mpwl8
         pMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9yXzQugqh9AHE/cogFMor5jnSvYK0iv9WxUJJcIFpk=;
        b=AruNGufhbwfcvuTQghJJ6THAqVQjUisyi7H2QDtEnb5cjr6PuTjnj4n2mi46Zk9Qh4
         S33KdM+TwBIc3eJ0ujpCiAje+rpF0wgKVMOjXftBP5ETjpV7MrG/rmB1u9+ymP450g6v
         hOWVdw9uFAI464ohBczEpaCtDpS+AsQj4uAdzkS+0VbDuX+/1ul47lDASWnd4bu7HwFk
         cEZVmkW9mBuRMzv74Mpk2vKbnFd/2pUy5KYWAcr9BvPF+pEsVgPLlAbgJ70Ozr4TmTPl
         c+2jt9X66E2ncfWEVFXTCMDLlmgyldLNhN2ypI3o5ZfPt8taLmv2YbaepZc+dceWeMMF
         fCPQ==
X-Gm-Message-State: AOAM532qRI56f5eh4IG0xax9wVq1VofnMkLA3uFniIn0lElMEd4uqdmH
        lX+cQaK6wCjix5NPHbyf/4BAblDXEWQtCQ==
X-Google-Smtp-Source: ABdhPJzs/lhs5mL/BVSpw5HW6n3rkmwdrMC27cG+CHZ3q2j/z3dhM11S3dS0dagYoUgUXlJS7kSBwg==
X-Received: by 2002:a17:90b:344a:: with SMTP id lj10mr8038525pjb.101.1619212780961;
        Fri, 23 Apr 2021 14:19:40 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id 130sm5374335pfy.75.2021.04.23.14.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 14:19:40 -0700 (PDT)
Date:   Fri, 23 Apr 2021 14:19:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        john.fastabend@gmail.com, alexander.duyck@gmail.com,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        sridhar.samudrala@intel.com
Subject: Re: [net-next,RFC PATCH] net: Extend TC limit beyond 16 to 255
Message-ID: <20210423141937.3c8a8da1@hermes.local>
In-Reply-To: <161921234046.33211.14393307850365339307.stgit@anambiarhost.jf.intel.com>
References: <161921234046.33211.14393307850365339307.stgit@anambiarhost.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Apr 2021 14:12:20 -0700
Amritha Nambiar <amritha.nambiar@intel.com> wrote:

> Extend the max limit of TCs to 255 (max value of 8-bit num_tc)
> from current max of 16. This would allow creating more than 16
> queue-sets and offloading them on devices with large number of
> queues using the mqprio scheduler.
> Also, changed the static allocation of struct
> tc_mqprio_qopt_offload mqprio to dynamic allocation on heap to
> fit within frame size as the size of attributes increases
> proportionally with the max number of TCs.
> 
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>

This breaks the userspace API, similar things have been proposed
before and rejected.
