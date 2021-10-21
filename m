Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D21436B42
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhJUTYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUTYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:24:06 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B1FC061764;
        Thu, 21 Oct 2021 12:21:50 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 188so2329884iou.12;
        Thu, 21 Oct 2021 12:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OoSkpRzjLKQ5u06P/45xU7uH8Rb3tyeHtxdYA2h0eYw=;
        b=K3wabqXzcWjDQp7bq+BpwGmAYhIOz7Sci+y4S2U/vZr9WhLOwBxZ9I7g27AHdarb2P
         o2n4ELPoz1kE/x2E2MeJKtv99XHxIWHmOsScnrtGHKj9qBeb8nGzP1WmdVuX8xWpzEgb
         ZtgyCGWpQG9vEkoQUeda6gZk7F9GzXyJjXX4bDNUNAXwOiYs8HUan7yuPuehorh3p3cO
         v/yA5ondJx75vr2tDbvuD/EvzwvxajA0ev5jn8n9XbdoHnSeaWWm5WAyY2SuYlLNcyrk
         +s3sK7TV1MV+0h4aFbmiKsyGy/TjdUOWOYcrGwXQX3lDJZJn1wPCXFoiWIAzYf+wO9sD
         EIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OoSkpRzjLKQ5u06P/45xU7uH8Rb3tyeHtxdYA2h0eYw=;
        b=EXBFXGBgdo8lo7Mk/sLvaZja3jBXJN/dowwgwgim0XztzePqx5btuYZ9MoGQeQ5lkP
         NCRJaic9/EsYdh6H+7mQmbyHwG6ZOQI2cw235gx0nelsz2nEbHwHBm1Z6XiUiFM52dpb
         gyl97/A20fU0aKiINXZUo6PKL1+l7jH1hHGlnIHwhYgEkIVla/6cY01eB3rIxqdL4psJ
         YNqwvRW7XrZ5oNSwrOEPOQwhIp0pIVCgKlxkpVGfdmlp2AqU51HTptjH73g9QQ+xLaZG
         u+iktbeQJ4jq4CeAsLhbGBt9D4Cmyn84kz3V2GICuBv5jfpmQlI74n/qX3IewRYwejdX
         fDxA==
X-Gm-Message-State: AOAM5315zDk5XH7Vz4u/0HctCxWxmTHWa/3jMci78+vhGf/Hu0aQb5Sv
        K8WSDcUhnYLEMfk5rayYEOU=
X-Google-Smtp-Source: ABdhPJxFm3mFAM30OQBPDX49zx9fL7ZfUKt9sUSsIbaRmbUd2W4ZStXhNAzNzqfbTSUNLPpdYUxpvg==
X-Received: by 2002:a02:2a04:: with SMTP id w4mr5123085jaw.107.1634844109711;
        Thu, 21 Oct 2021 12:21:49 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s17sm2927857ioc.28.2021.10.21.12.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 12:21:49 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:21:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pu Lehui <pulehui@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, nathan@kernel.org, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        pulehui@huawei.com
Message-ID: <6171bdc513e4e_663a7208a5@john-XPS-13-9370.notmuch>
In-Reply-To: <20211021123913.48833-1-pulehui@huawei.com>
References: <20211021123913.48833-1-pulehui@huawei.com>
Subject: RE: [PATCH bpf-next] samples: bpf: Suppress readelf stderr when
 probing for BTF support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pu Lehui wrote:
> When compiling bpf samples, the following warning appears:
> 
> readelf: Error: Missing knowledge of 32-bit reloc types used in DWARF
> sections of machine number 247
> readelf: Warning: unable to apply unsupported reloc type 10 to section
> .debug_info
> readelf: Warning: unable to apply unsupported reloc type 1 to section
> .debug_info
> readelf: Warning: unable to apply unsupported reloc type 10 to section
> .debug_info
> 
> Same problem was mentioned in commit 2f0921262ba9 ("selftests/bpf:
> suppress readelf stderr when probing for BTF support"), let's use
> readelf that supports btf.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---

Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
