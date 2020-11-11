Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C412AEDE0
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgKKJeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgKKJeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:34:20 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD758C0613D1;
        Wed, 11 Nov 2020 01:34:19 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id k26so1527366oiw.0;
        Wed, 11 Nov 2020 01:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=36NotezYoC/yyfzMqnUfq9zBlq7QxW9QNIrKCRtwRLY=;
        b=pox7M5sP0Uml+SVYXZ08brVDykvoVVYnZgc8mI0lk93NjnXTmtpK1ZYotFvDa5qcux
         dlxxF/miW84iYycj9tSsv9N2V18A+StM1WI7N+xcCi3WDkkFKPZSI+733Uv+bMyzexGn
         c3uhgUZIJhDMtX3sIxNyjApC0U5zJzjEX1lh1jCeW0cWRGi51pdLmHRBGyoErj29fakz
         SBOohq3UMWrlzkNllxkf4zixaqOAwu8svdoowwW6QzlPOxjtfFgkWjNQhyoIi3zbwHYD
         oBBD4ZkLGHy509OP4bqbI4kD+MomUXeI1zsA83Rw58cFkK84vInW0gdmsjDDpWcFy78X
         7S7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=36NotezYoC/yyfzMqnUfq9zBlq7QxW9QNIrKCRtwRLY=;
        b=qOkngKCC2WMXthS+9m2gisXo4uaV8+DY5Ps8yxKD6pWWeGINxbevR7JtOTozARk+mt
         PHVoGUIGBigNAXfvoX5iTIH3QsFfYRaCcuvkZsrss3njY42cNss1IIlCuExzpH5Wksuq
         T1z3LgM8726gDKvLSwO25qbeRwJK4kbEvPKz7gdCFCadpXACRTjIylvTFT/+WWh7mzTM
         RjyElHfVBAh2OCYF0fnKV5D19IdeiFLAiO6rBc4zh6nAxs9AxZ4IP30QuvwX4gtxZ+r8
         aIoYgf4vC1P4cP94q77CNFhM4EvejUUqEPWIfoKFVKvghcjkLiG/1ypSQeL12Yd6crTg
         rZGw==
X-Gm-Message-State: AOAM531Zi2mf0tHmuMfETw0WHn9ekPosHmZ/NpXQJ5iWBlN6cX7FiWru
        wTU/Drg3pW1bfgqadXiY0H8=
X-Google-Smtp-Source: ABdhPJxhY6BIamR+E6BAfcKKF3uledUuIVKFBCbjublGaqm/oVke/eYtwlyVeUJgab9VzMzvQto6kA==
X-Received: by 2002:aca:4a0d:: with SMTP id x13mr1603348oia.155.1605087259295;
        Wed, 11 Nov 2020 01:34:19 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q18sm392421otf.46.2020.11.11.01.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 01:34:18 -0800 (PST)
Date:   Wed, 11 Nov 2020 01:34:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>, xiakaixu1987@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Message-ID: <5fabb0135718_bb260208a8@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZzGZTFky0F=U1_XKSBu8AqhuNzQgY7yibWYokrMbWK0Q@mail.gmail.com>
References: <1605071026-25906-1-git-send-email-kaixuxia@tencent.com>
 <CAEf4BzZzGZTFky0F=U1_XKSBu8AqhuNzQgY7yibWYokrMbWK0Q@mail.gmail.com>
Subject: Re: [PATCH v3] bpf: Fix unsigned 'datasec_id' compared with zero in
 check_pseudo_btf_id
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Tue, Nov 10, 2020 at 9:03 PM <xiakaixu1987@gmail.com> wrote:
> >
> > From: Kaixu Xia <kaixuxia@tencent.com>
> >
> > The unsigned variable datasec_id is assigned a return value from the call
> > to check_pseudo_btf_id(), which may return negative error code.
> >
> > Fixes coccicheck warning:
> >
> > ./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared with zero: datasec_id > 0
> >
> > Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> > Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> > ---
> 
> Looks good.
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Acked-by: John Fastabend <john.fastabend@gmail.com>
