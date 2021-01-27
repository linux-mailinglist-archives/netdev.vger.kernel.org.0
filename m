Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AFB3066CC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhA0Vvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhA0VvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:51:18 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C677AC061756;
        Wed, 27 Jan 2021 13:50:36 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id a1so3340827ilr.5;
        Wed, 27 Jan 2021 13:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GVrPheh8vPdTboVv6uFpQpyWv1YK0YXeLPT2TfyWdU4=;
        b=P/kg5OHLOFFm71THnZtOzqiPYWNCKgbvZJcempQ68sU7JI4U8+kbMgby5ViBPp6hls
         tyFhPlbGn4h4kFd89i1z36w+HlvUPTxtXoGOX+8YeYYLGpUHJNW2Sd7tdJdnTuqywdQe
         N2apvU50m/zkoGIZxJ5R96y6l30U7VwmCW9MCDJOUJkv9f3CAhq+bPUeMp0prfBdD1/Y
         Sy+/X9F8wwa3fxMUAQNv+R0p/T8qY2Vzh0AFtCoZTsVlqqXvEuiC5DSNTkHgsIVwJYnQ
         VkrDZgGxxh01UUTaQN+6yvlrRRtGkqKCkNfe3vHeiPtZIhVFuH+KdQz/h2dIathZmLQr
         uFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GVrPheh8vPdTboVv6uFpQpyWv1YK0YXeLPT2TfyWdU4=;
        b=qtqFXG07/rmRZvfztVDOZJGPOS5Lp5dQujibvBOb6ZAOEJpzejFigXsi8Yil1/8hMS
         0ty0CO7WilSwly6+K/BoEqLNfL8f0+8Qgo6hLyeSvPda81B5xoEh86c/4QaWWfsNKdid
         Lh561eVv6vb8VdaYhIzMvao6Mpu6rx9gbmxZFnZOsEi7AmlnqRJWw6DhIp+SKj0XWDtE
         q6LPFBJ36R5JDg5SMLACAHdE7EXqCoWfIXYWiZ0ybFoLXs+x/M3L8tAvxHGqmwJUXkun
         STVqga8srw0XGW6ogs28MM/hA0gi5SdOql/pGwjywbpUzVavrVXgF4EdkoiRnCIEp5bl
         cVPA==
X-Gm-Message-State: AOAM532V0WPC4Fy09o5ZZzhWdVlpvv97rmUruB3XZxvagTXDqyseQJO5
        j98mYJdVW6vPQoHUBk6Hjxc=
X-Google-Smtp-Source: ABdhPJzmk6QgANGqS778QNp8gYiYIEOVXcwzOm0Y5oGysXa7vN686DE3LnIgEeSAuqPwUqinZCMSRw==
X-Received: by 2002:a05:6e02:108e:: with SMTP id r14mr10323250ilj.285.1611784236285;
        Wed, 27 Jan 2021 13:50:36 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id b3sm1501706iob.10.2021.01.27.13.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:50:35 -0800 (PST)
Date:   Wed, 27 Jan 2021 13:50:27 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <6011e023c65ba_a0fd9208f0@john-XPS-13-9370.notmuch>
In-Reply-To: <20210125124516.3098129-3-liuhangbin@gmail.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-3-liuhangbin@gmail.com>
Subject: RE: [PATCHv17 bpf-next 2/6] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
> used when we want to allow NULL pointer for map parameter. The bpf help=
er
> need to take care and check if the map is NULL when use this type.
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> =

> ---
> v13-v17: no update
> v11-v12: rebase the patch to latest bpf-next
> v10: remove useless CONST_PTR_TO_MAP_OR_NULL and Copy-paste comment.
> v9: merge the patch from [1] in to this series.
> v1-v8: no this patch
> =

> [1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gma=
il.com/
> ---

LGTM

Acked-by: John Fastabend <john.fastabend@gmail.com>=
