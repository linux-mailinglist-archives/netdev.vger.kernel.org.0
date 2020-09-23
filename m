Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D67B274FF9
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgIWE0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIWE0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 00:26:47 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B7AC061755;
        Tue, 22 Sep 2020 21:26:47 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id e23so17751469otk.7;
        Tue, 22 Sep 2020 21:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6kaKOsZsneMgxoXHhfZEN2Ti1z0+Ude/VsqPGzx61t4=;
        b=tm9IuO7aksQGL/0aIxG2KHbDkqOFIrIDj25Xm5slwCD+BFL2SrLEunrzZf2DIdFvyg
         R64g6f9fhV7HC7+8BeJ1MkhMPW4KrYPRftUtfdPkuCpyHWMJRKT0NhwlPynIy9UZv6QA
         9qbrwoDTykK0eeSQ7NR65pBpIDHYVUlFA6oBy45QSeBuOuZ/WyUlUBtXX3zmqniSS/JQ
         Z/a/mzLc51tuS6G4rIHcISuQZLZQBcNyhbJCSDyTP2EhiLzO13KxVAmDJfL+0ZgJ5Xa3
         VJ9PIRA60oPvrhmMHzqxudZEsHveGLWGtD8cdWI9rwnJC+t3CUv65BkgeEVZgl1/rN5f
         vyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6kaKOsZsneMgxoXHhfZEN2Ti1z0+Ude/VsqPGzx61t4=;
        b=c1KV4S6KvJiOOFZPa6RJq/n9EnbNjvJ9vf0tCBzmwYkKlCQVKw8Jo7pOdQJlvzMsHf
         iHEXTtPNEAXPX/V2UD/Nlq/VFp/Dve2HvWSM3/n+EQiUUIkAyJOBHfN52/OgULtc7zds
         +mZtJ7bA9bu3D/NigIKdGIXpagzFWCn/a0pSucFkk65dTvVlCG/ZVPLqK8lW2G6ChE+q
         I2HV+SwKqMBw7n+ytwve3Ls4Vrr2g0DEdkeBGAMT0noZ/InVfsK+6re/pnZW/L9auDCF
         GNquGUG8Uf8yMeV4RPHgSXTOLOTCQt9/nPeOv0ubuOrT/2szhRyEmauKKlZaxZRnAWhA
         MLIw==
X-Gm-Message-State: AOAM533Fw8KIjI4lnFlSj9pfRwsGEkhQNgCEsVSZ3mCYg4se5DjOi2ri
        wb3Aq4nwWCUkXQJfPGd7g+c=
X-Google-Smtp-Source: ABdhPJylW4JrD1gnvu7NurtDfWHgX8N8gzHGH33pFL/edDYXTXjbbYg3Vt4cTSYBKfh22gg9R3RmaQ==
X-Received: by 2002:a9d:70d8:: with SMTP id w24mr4868144otj.275.1600835206988;
        Tue, 22 Sep 2020 21:26:46 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y25sm7375266oti.26.2020.09.22.21.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 21:26:46 -0700 (PDT)
Date:   Tue, 22 Sep 2020 21:26:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        Song Liu <songliubraving@fb.com>
Message-ID: <5f6ace7d5a51a_365782084f@john-XPS-13-9370.notmuch>
In-Reply-To: <20200923012841.2701378-3-songliubraving@fb.com>
References: <20200923012841.2701378-1-songliubraving@fb.com>
 <20200923012841.2701378-3-songliubraving@fb.com>
Subject: RE: [PATCH bpf-next 2/3] libbpf: introduce
 bpf_prog_test_run_xattr_opts
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu wrote:
> This API supports new field cpu_plus in bpf_attr.test.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
