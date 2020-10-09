Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5728908D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390341AbgJISE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731625AbgJISE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:04:27 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFF0C0613D5;
        Fri,  9 Oct 2020 11:04:26 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id n6so10941105ioc.12;
        Fri, 09 Oct 2020 11:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=R/sIESc007MlFJwZDD0eVR4HOtnSmHJWZpDiVrrftQU=;
        b=OsqVcNROsfR1RWzMNPs274n4Ab/hR5LGOZco6B/zyxVXEPdYbhFG/4iJOH7Tezijj/
         jzdTdRbuiZHM5A92JlpII/ed/1kz/cvoiJlx2/TECsICJkyelYW4xnmbA+rOUdN5vlZL
         o0cFYMhx4NL02gBSsN6kBGO/fU3NKG3dJQvdCtor/P7NX+Z9m9bnH4VhjiFHqeTb8e7r
         0oFGnMjQ4h7JMEikQzg7ijbg2Qo8iAHQAXPd1qFIx3J4J5D+xvvMEbLzDUZW5fwCWUfz
         heytl20m18xKob9a3DItCqIL5OSrEW65PptsnBQiRvlreoWd66CDBSuiC6C7EX/wS55C
         BC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=R/sIESc007MlFJwZDD0eVR4HOtnSmHJWZpDiVrrftQU=;
        b=DSDq5GQtLEhaQGRWNxop6CUWGn6tx/4IYWCbowyKfserOI+KzY49LCv/rCiaH8ON7O
         ExrV+lO4/8a198ZMQTnhR7WYVTh/pU6mJhk3ti0PO4xYIf+TD/QKXYxkX3ksNfbpxZ90
         kGHAa3RAPBxfMsuYdn4fC8zio8KtaB9hx6sEjXvlWAdNlKVUUWDqk7ednf/IQak7Q/mF
         EPKdzgSdk9K1qxZFnn0HH4z/MVoJiK525yLj4My1dqXlIGtQvVc5Nxkg3qcVJNLCmTU3
         MMuGmsuhd96gmZtMdg92OE28WEXtS7EPXPDUE/cJ82pM/xvBaMNfeojNUMTQaMRiQ9+S
         +Tww==
X-Gm-Message-State: AOAM532TJtAmWUjN/Yxcu2tVMXcyJ99f4Q9qcH4kW42q+EUxCv8n4aVG
        RU/uDj8Cyr4POjmQHJfXM05lDNr6oD8FGw==
X-Google-Smtp-Source: ABdhPJzbEwoFuUKC+lnQRXz7kAfkfEMJx84Kc6VnT69sBAt2hpHBUNpNYz5Dc2SmJ272I2NHgDG5yA==
X-Received: by 2002:a05:6602:2ac9:: with SMTP id m9mr8925074iov.20.1602266666251;
        Fri, 09 Oct 2020 11:04:26 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v124sm3852674iod.53.2020.10.09.11.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:04:25 -0700 (PDT)
Date:   Fri, 09 Oct 2020 11:04:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Message-ID: <5f80a621d81e0_d21e20870@john-XPS-13-9370.notmuch>
In-Reply-To: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
References: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
Subject: RE: [bpf-next PATCH v2 0/6] sockmap/sk_skb program memory acct fixes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Users of sockmap and skmsg trying to build proxys and other tools
> have pointed out to me the error handling can be problematic. If

Will need a v3 to fix a typo, should be ready after fix, rebuild
and retest.

> v1->v2: Fix uninitialized/unused variables (kernel test robot)
> 

v2->v3: patch2: err = 0 needs to be err = -EIO to use workqueue

> ---
> 
> John Fastabend (6):
>       bpf, sockmap: skb verdict SK_PASS to self already checked rmem limits
>       bpf, sockmap: On receive programs try to fast track SK_PASS ingress
>       bpf, sockmap: remove skb_set_owner_w wmem will be taken later from sendpage
>       bpf, sockmap: remove dropped data on errors in redirect case
>       bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
>       bpf, sockmap: Add memory accounting so skbs on ingress lists are visible
> 
> 
>  net/core/skmsg.c |   83 +++++++++++++++++++++++++++++-------------------------
>  1 file changed, 45 insertions(+), 38 deletions(-)
> 
> --
> Signature
