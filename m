Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A47333848B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 05:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhCLEFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 23:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhCLEF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 23:05:26 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341F7C061574;
        Thu, 11 Mar 2021 20:05:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10431551pjv.1;
        Thu, 11 Mar 2021 20:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bhLsdKTKPsK8gXpEmj198G0NYLh6qAY7tBjV7BgQoSc=;
        b=UKS49ZrM/eMONEw0OIbkqsxF8jig8YJvNrVgrcF5VIQqHKEJrXlHWBIso99ozodTA6
         mkItFWPk38ujQ98P9iuswKEI96ReZw715CCWaIGF+ANIDB857/ERd6fL+wWtdhn6eajR
         cV8INdr573EuVmRZEOj5UZClfKEB0LZVOFEA+Fp1k/+5qzx8UNalnQVYqwZ0RbeBtOn8
         njBQh1zE2Nnwllg42HyENXdOlO2xlnkDNTseeLcnzpVMEgB4MnU5U77PIkoDkhQ73ymf
         Y1luXUx2DTvgP93zYuGALD6wbT8Q20jNx8x7i41i0JdwDstekfMMFJO7w27MfYSMB/Cs
         5xMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bhLsdKTKPsK8gXpEmj198G0NYLh6qAY7tBjV7BgQoSc=;
        b=a7EN/kKtGaLnMc/CSXU1xsddvJ02GsrfnzzcbtIuEBF9QfDrtYPkHy2ZbobDhv6XE3
         Z1wWiTfHfg2tq5WllqCN6ZSAah9JgYsnVjhlQMXZZHr44LLRgrxUL/pdtVVzu/Vb8sI8
         tmo5wSQOZXgCjYh+TVzHJAZjFZBLeJS9tJ3/80oMdYOYcw+I14z06KtLFn6YWg7ijX34
         Flj9O08fCeTu8Oh+pFBRiu1xhvXFqVYhf+DDql4Zt2P0KViueruAyvQfrwysF8vp9hjo
         +nWCiAC9Ww6IZCEM0sqyM4QSYzHsVovzqdJ3e7ngRddKT7RJO2b9AR+1n4tY13LDvFRC
         BVZw==
X-Gm-Message-State: AOAM532HC9Gsx+YChEnsCwQR8dWWADQWbE89kbkL0SjAvRXjcIB+VjQK
        yOkFnm7XRu5lAnnszAO/mTg=
X-Google-Smtp-Source: ABdhPJxRWSSCKUdAbY2ziGUv6hLcADfCUBAk+M4+oMSB7B1aREaTlUcbkwVaqlD0qTmmxVKsEU8wFw==
X-Received: by 2002:a17:90a:c249:: with SMTP id d9mr12275929pjx.104.1615521925628;
        Thu, 11 Mar 2021 20:05:25 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:1292:bfb3:b910:e5ec])
        by smtp.gmail.com with ESMTPSA id z68sm3664526pfz.39.2021.03.11.20.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 20:05:25 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        bkkarthik@pesu.pes.edu
Subject: Re: [PATCH] net: socket.c: Fix comparison issues
Date:   Thu, 11 Mar 2021 20:05:20 -0800
Message-Id: <20210312040520.12213-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210311044408.t6qut7taaagt4a63@kewl-virtual-machine>
References: <20210311044408.t6qut7taaagt4a63@kewl-virtual-machine>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What is the reason for this change? Why is the new way better than the
old way?
