Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD4E23D6BF
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgHFGV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgHFGV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:21:57 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73581C061574;
        Wed,  5 Aug 2020 23:21:56 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i138so33581734ild.9;
        Wed, 05 Aug 2020 23:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wY00eTnzImSHFbnGU9dEOiDoigiPbBYuD3FSszlDv/g=;
        b=WEzP/F2VxsTBJP8O/WXbvUsBJkseqkgRj0GFmenqbPNHApCep1F4DIqruSfUS60SYf
         RS9QZFSYxzB7cwXF1CzIizyGUkmvYy+oY63qL5vA8xWKhh9p5jf70ZlQwfFFJTVDh14a
         kU8+Vcl5PUSjKA4jv7potTMuRHKgQc0sojkM87glOEbik9Rj48L1cJ2ecXnwODw06m3C
         QTIpTAS/RZzJ0R1Cota5NNcyQwmdC4fXsGASvMCkYF8iitB1dAO2Y2Y7+8lasPdyQVpg
         W0Ek7OdbVyVqWJf+yRsp0dlMEy/vNOIsNPXl0ikmvJ3YtbWtjOank+65w7k5RdQ3xy/L
         5zuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wY00eTnzImSHFbnGU9dEOiDoigiPbBYuD3FSszlDv/g=;
        b=Om4PaC7dpJKzu8d9YcMoRTQWDQs3E8ffC8/kqAE+A71Y+7AuinAwyXGGxfqW4MavVr
         gkkUbNltnefInSDbTBViGZP4a9jP2PsZmslj2YI/XbUd8wRAyXXHtEf2eZ1CxIUuxAn4
         tj1X62GugrjDQpYzxL2E+EerezsDiLRLYBa+m2ul2Sg8o2mU4eNqdqqx3BCHoWeie/wQ
         Lzjo97+2dOM6Yae3psd7rENw9wYwv56kcjshbpmNyLl6i8O6qzBSbQaYTofraXeaevu/
         Rz6ikeDhxv2HEyyNNZK0fQKTuACNIEr6E1T7TxheKwUPfPdY8DnjAx5vzPvOVRxBvEx4
         qPtA==
X-Gm-Message-State: AOAM533+BolgGDPjzeUBaTRB5eHOWd+CbuXRjDxwZc/EeNxVwDJKl675
        FPUCtNZFu5En2oG20VilE3c=
X-Google-Smtp-Source: ABdhPJwiR6w2OrJVojqrowtGz6C5JucRToTtEUhFYULog79oqZle/T2zi0iZJk36FzrR034lX32zcw==
X-Received: by 2002:a05:6e02:4a2:: with SMTP id e2mr8768196ils.70.1596694914771;
        Wed, 05 Aug 2020 23:21:54 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k204sm2586767iof.55.2020.08.05.23.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 23:21:54 -0700 (PDT)
Date:   Wed, 05 Aug 2020 23:21:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5f2ba174c65a7_291f2b27e574e5b81@john-XPS-13-9370.notmuch>
In-Reply-To: <20200805223359.32109-1-danieltimlee@gmail.com>
References: <20200805223359.32109-1-danieltimlee@gmail.com>
Subject: RE: [PATCH bpf-next] libbf: fix uninitialized pointer at
 btf__parse_raw()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel T. Lee wrote:
> Recently, from commit 94a1fedd63ed ("libbpf: Add btf__parse_raw() and
> generic btf__parse() APIs"), new API has been added to libbpf that
> allows to parse BTF from raw data file (btf__parse_raw()).
> 
> The commit derives build failure of samples/bpf due to improper access
> of uninitialized pointer at btf_parse_raw().
> 
>     btf.c: In function btf__parse_raw:
>     btf.c:625:28: error: btf may be used uninitialized in this function
>       625 |  return err ? ERR_PTR(err) : btf;
>           |         ~~~~~~~~~~~~~~~~~~~^~~~~
> 
> This commit fixes the build failure of samples/bpf by adding code of
> initializing btf pointer as NULL.
> 
> Fixes: 94a1fedd63ed ("libbpf: Add btf__parse_raw() and generic btf__parse() APIs")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Unless errno is zero this should be ok in practice, but I guess compiler
wont know that.

Acked-by: John Fastabend <john.fastabend@gmail.com>
