Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269FA43237C
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhJRQJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhJRQJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:09:18 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C73C06161C;
        Mon, 18 Oct 2021 09:07:06 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z69so13769221iof.9;
        Mon, 18 Oct 2021 09:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/mTRsShBa0RedCL/8LYjfYhzL4WnaAlgO3es86cebV8=;
        b=cUk+7h7TIexWwHkAj4k6UnkOyxoX7UzvYwSdOx5wPRXGQJ7ChybSfiEt/jBkF+r+MK
         TEQAOCr/v/RxGCI5V8bkRLGrZSRsoJHgUIdGhHITt0WLzfgz4MOvf//KK+46br7Vn9aw
         GEPt6iEeyl4s+NSOoyMYMyq1I2P8ZGKFLxP3vwjW85Vn5ULakJk4xzKYhKIxyF5F+hrG
         U6T/riKd6XMRANLoMwH4U8HR8leER6nef159R0fyqF/zk5tHSyPmFk33KEE+XloBFogL
         5xMgkrLGEv3WzDXiirrdDk4eVwq6z42FVTQ1GFtrHAPlLuQ4wROxbQSXhO3E10i7oKQR
         vSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/mTRsShBa0RedCL/8LYjfYhzL4WnaAlgO3es86cebV8=;
        b=fC+79xY63hQf3iKBNDbs6aSNHRQSSX0axO16YtFbCINUOEpFZKFBo/zY1YuRdSejMq
         KnGTZpi+wWuA2ctzsMGmGK80dDiX0hMx3ur8q4PZkHZxpPr1RvGy+Kv9ObzIbs7nG0W9
         P+SBZ/7/BQYJY+H69Vkvxim7F61hl2aOH9vhCMZpKSzu4AD+LvkufEsTAFX7R+3rSh0v
         biKf1MyC3EE4UVfDwGvAeRdug9wqIJ+Lb3CI5/s3L8U95Pq38cNfx4UDWHRrL1gwoOVe
         DosodrbXRI0UC0X7Ld93bzSgX7G7mAk8ZVJF6aCsv8iy66jc5j7cWuqEOeXJ5OgQYeSt
         CDxw==
X-Gm-Message-State: AOAM533dZX9sOHmb282YzCzzQu0M+cpJZgwRu0xr+x9bHnS+OwomeEUp
        lpCi4NZsS6/5nA1HJPdlrhA=
X-Google-Smtp-Source: ABdhPJyWIHgwW8gcHHZCBaExCk/ZbXnX2pGmMUfJ3ykpnFTd5jPFQGtHwf9Iz1Nf1IBavCvlHxpumg==
X-Received: by 2002:a6b:f816:: with SMTP id o22mr15689164ioh.106.1634573226289;
        Mon, 18 Oct 2021 09:07:06 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id i15sm7114153ilb.30.2021.10.18.09.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 09:07:05 -0700 (PDT)
Date:   Mon, 18 Oct 2021 09:06:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wan Jiabing <wanjiabing@vivo.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Message-ID: <616d9ba173075_1eb12088b@john-XPS-13-9370.notmuch>
In-Reply-To: <20211012023231.19911-1-wanjiabing@vivo.com>
References: <20211012023231.19911-1-wanjiabing@vivo.com>
Subject: RE: [PATCH] [v2] selftests: bpf: Remove duplicated include in
 cgroup_helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wan Jiabing wrote:
> Fix following checkincludes.pl warning:
> ./scripts/checkincludes.pl tools/testing/selftests/bpf/cgroup_helpers.c
> tools/testing/selftests/bpf/cgroup_helpers.c: unistd.h is included more
> than once.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
> Changelog:
> v2:
> - Fix the commit description.
> ---

The Subject is a bit unusual. Typically it would be something like,

 "[PATCH bpf-next] selftests, remove duplicated include in cgroup_helpers"

For the actual patch though LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
