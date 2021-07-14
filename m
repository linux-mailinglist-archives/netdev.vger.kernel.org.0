Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9303C7A89
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 02:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbhGNAXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 20:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhGNAXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 20:23:23 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95733C0613DD;
        Tue, 13 Jul 2021 17:20:32 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e2so8478737ilu.5;
        Tue, 13 Jul 2021 17:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=O3GExnVczfUOt4y6aHmFDd/ImVOXZspx323TdrIBemg=;
        b=qQ6Nye1cZ7NtyHjGfVkQQo3BD1WAJ9czkzPzt+ikSvAoPA/bL2NMJlyIHY0zgrpweW
         QK2M1zpmdU2Epg4s4aooXVgnMssTdCORwm8fdtOrDOLBGjXorfuETGFswmbP8eMj677q
         YEOm+gwQikLXPfTe1Nlf/bKVJ7Yi7AxHQpehy7YsmQm0xThCOhkDJ8Hsxf3W2RK4R1to
         4Tn97waNXUt34FMC7E+0rx7oiLqT2JXSss2qKLr6qgiEEUC/N00SPTk1T/QxRgHq7qLC
         oMD9P4MO30FNRuf0Ok53PEBLq26VlIW2CztDNwDA+772Mfx4vNC6EkFu4K2Q3H0F3pkk
         9dww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=O3GExnVczfUOt4y6aHmFDd/ImVOXZspx323TdrIBemg=;
        b=LWjE7W27VmUClMS16b5CTiNlAHhmcgMb24eY5ux743hsIwVjpBxCjVf0UQA2+U1mWN
         4X467JRqTrE0879Zmp290vWEzwfhfm1QvD0pjsg68lOIkShdEjwgZJnp8ULLPA1gEM75
         IbAhydJjBUl3+0pSrwaN+F+Gkaiv88Pcf9hnpOUEDP3RAAcfmECoeO9a3khagDzUknZj
         b406conUAsarwfIfXXJQwZkudwPV1xjf7FhAIfUKtin+aLU/F3M6mP5i6jzU6RoLnR6o
         W9ZF5rwcNXLgRotKWO6xbfqPrmXv3X6fQUuIsZCA+abhhsT/X/3ZgSSw+F/IAmfKQH9A
         vGNA==
X-Gm-Message-State: AOAM531KSeGOIhJFrk1XnNfOcJ8JvT+Q6pbI8YADr/Zi7/hwg93aStvJ
        fRUVMzYWsG2Qx7GuyHO3KR4=
X-Google-Smtp-Source: ABdhPJx7cYCy3SoqVdvOnw+gGpQu31dUzwdkbm/T/30anr7Cv7o5V3/kgnzuFZR0o4nQyvqwtJIWdg==
X-Received: by 2002:a92:c504:: with SMTP id r4mr4654610ilg.131.1626222032028;
        Tue, 13 Jul 2021 17:20:32 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r6sm314516ilh.35.2021.07.13.17.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 17:20:31 -0700 (PDT)
Date:   Tue, 13 Jul 2021 17:20:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Roy, UjjaL" <royujjal@gmail.com>, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Networking <netdev@vger.kernel.org>, BPF <bpf@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Message-ID: <60ee2dc76ac1c_196e22088d@john-XPS-13-9370.notmuch>
In-Reply-To: <20210712173723.1597-1-royujjal@gmail.com>
References: <"Roy, UjjaL" <royujjal@gmail.com>>
 <20210712173723.1597-1-royujjal@gmail.com>
Subject: RE: [PATCH v2 bpf-nxt] Documentation/bpf: Add heading and example for
 extensions in filter.rst
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roy, UjjaL wrote:
> [1] https://www.kernel.org/doc/html/latest/bpf/
> 
> Add new heading for extensions to make it more readable. Also, add one
> more example of filtering interface index for better understanding.
> 
> Signed-off-by: Roy, UjjaL <royujjal@gmail.com>
> Acked-by: Song Liu <songliubraving@fb.com>

Looks OK to me. I thought the original was readable without the header, but
if it helps someone seems easy enough to do.

Acked-by: John Fastabend <john.fastabend@gmail.com>
