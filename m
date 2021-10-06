Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E88424141
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhJFP0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbhJFP0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 11:26:45 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A2AC061746;
        Wed,  6 Oct 2021 08:24:53 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b78so3269646iof.2;
        Wed, 06 Oct 2021 08:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MPoP4imfnKaab1dhzJozVR5xGC+0Ss3b1IJx3fLusAs=;
        b=WL5xJW7f5vdS7w8Q7EMxl9LXY7NsNog9MvfhMXSUzrv0p3cY7FTb8I8cMV5P+WPjcA
         UgLvqSq11vyWuCQGcTWGjVfwkSuoxMzWaeC1q9LLqcd+7yIzEOmDz6/JoAKffkvRW/4B
         ZCuPqxEXE6yokrCGuGz8kiiWqZkb3qg6I0Ce0nzXzOlq3f0Qwto1P4/UQS9fAgmHUynd
         9ar4BJZCcllaXlbDhjGPawW20XmNDnzINop753LXeP5IZ29Q4ighHJ3QvygTP1GiQ4I3
         1uWQog6c83YPg6smSoodP/MR7SbjEEaeKLbIBKljhTooeVglO2nJNQqYavwJP7riwXTF
         bO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MPoP4imfnKaab1dhzJozVR5xGC+0Ss3b1IJx3fLusAs=;
        b=opV9aQwMdKWC6X15Q2ouqKs7QldCByu4U/Yn5lVy+TgWAnw0XNrFgT1HVTTCa6br9Q
         x5SaOmlOsLA7tZqcQqa7i+qVWoS/qY+DlwY1GTYHfRuDaRmceyeTz0tE4H78T0OfgQ5a
         Qe4phJ2BYYWd/ez9bNjeIXpBtJPnpudREvllDNyq51FF2BJNfMVTeO+VCUAYLB/Bq31g
         4JrYzq4b5nhn5Z3/wG0phRxHOk4NVpMAEwNCFtcObb4KTq2X3CCPpljbIgXiGpGAXnKF
         HrUuujpjtDctkiwJdCOudrInvf4Id8nIlCrP7ITzXSEUePO4XBhoJ/foSudzPMalclg+
         9pPQ==
X-Gm-Message-State: AOAM531mQ9uaSjsf4qqBQglZVKnlR4tco4y4qqYhxSXgufkKxJGGJjLE
        U3l/SdLScXw65ayp7Byo0tc=
X-Google-Smtp-Source: ABdhPJy3r8bv8G3OLVWBkc1Vn45RGq43UkL5TZe/G1SZcNyKGebiDDZN3WLNOkZrgox+DmNbPKyyeA==
X-Received: by 2002:a05:6638:3052:: with SMTP id u18mr7683141jak.148.1633533892709;
        Wed, 06 Oct 2021 08:24:52 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x18sm10303342ile.18.2021.10.06.08.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:24:52 -0700 (PDT)
Date:   Wed, 06 Oct 2021 08:24:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Message-ID: <615dbfbbdd602_1309c208cf@john-XPS-13-9370.notmuch>
In-Reply-To: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v3 0/4] sock_map: fix ->poll() and update selftests
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
> This patchset fixes ->poll() for sockets in sockmap and updates
> selftests accordingly with select(). Please check each patch
> for more details.
> 
> Fixes: c50524ec4e3a ("Merge branch 'sockmap: add sockmap support for unix datagram socket'")
> Fixes: 89d69c5d0fbc ("Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP'")

Looks good thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
