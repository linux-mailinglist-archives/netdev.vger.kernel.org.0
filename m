Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B80390331
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhEYN6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbhEYN6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 09:58:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FF1C06138A
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 06:56:54 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h16so36296405edr.6
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 06:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WGPyF9cLnTz2QZ4yWAoBXLvmWhnOB2cEFuUlKJPyncE=;
        b=RiFgZo3qUq9fklWiwHZyfsLfVJtuLmU14pHsogMjVV26Ww02bWIHblvr4b9vSMeNjW
         0Hc9yHVVAMVnUhYn4LRBh6dC61eeKUPbPvk5XM00SvQJgyZ+e6bnu5epyzAh55EP4fZ2
         ntpJizTq7iKKadc9OtbXDV64guNh9/6aaOpDoZyLrte96zSaVWeeqacLWTpyGmCS/DKa
         amMSCT20XSbqgLWoRlz3cQnVBsbRGi9WSnHykFdmqjUgVEQCGAjbtNV1A0iKvkY6rE/d
         gXGsN45x6VA6T0xY3A37rC6lBzOalYog2z8SyWV2jIe+JHG1zkeK/Z7e/3SJHBa1h5pu
         Dxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WGPyF9cLnTz2QZ4yWAoBXLvmWhnOB2cEFuUlKJPyncE=;
        b=UnBACj+q6FWju+qE29mEU7ac5RgE1pPhdPWudzTOVN/UCYYcEo6AHqo1/TOd97+Cjn
         fI4ILHomOhXC10ujWElSEpJBOhR8wQ1uaDVHd1yFdftcbxJet6cGJv0P7T6ndu2T/7ev
         766HN0IcxeehTaWAmmb3zf/QJ4Jj7b6CodNM1mnh2GAsgzF+y2/EX+itVCCOI81y734h
         Fh19hOAKz8ITZtdBrDAzw7RNOW4sdcLgUmcPNm7S1mo2BpASFLn+H2+bGXzMPlScDelc
         Yh+RnXTwY8Zk2oPYQQrzAAJKMlXHY60Q7uyfb91sOCG+oYnmVuyNWzekLjtAEKCA6IZh
         tj7Q==
X-Gm-Message-State: AOAM532KYD5Xa9d6DzprWb/L2LwIS8jHAlhKwxjVfLIkCzY+wpRXrufa
        VIA5Y8kH2sTwwcnH7Zm8JVOR0SDEtdmVqg==
X-Google-Smtp-Source: ABdhPJyE4aqQUETU432hXPLmEKrZ+EA35vTXX4smREQkdS697uXAmaBJg39SM9csQyvAROXi8h4/KA==
X-Received: by 2002:a50:9b06:: with SMTP id o6mr8821009edi.284.1621951012189;
        Tue, 25 May 2021 06:56:52 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id d25sm9071828ejd.59.2021.05.25.06.56.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 06:56:50 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id z17so32355545wrq.7
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 06:56:50 -0700 (PDT)
X-Received: by 2002:adf:fa42:: with SMTP id y2mr27555296wrr.12.1621951009929;
 Tue, 25 May 2021 06:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210525061724.13526-1-po-hsu.lin@canonical.com>
In-Reply-To: <20210525061724.13526-1-po-hsu.lin@canonical.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 May 2021 09:56:12 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc19dDYaRyJZV5qqwz7rFy+5KXHzX_0OkwAFFyJH6aU6Q@mail.gmail.com>
Message-ID: <CA+FuTSc19dDYaRyJZV5qqwz7rFy+5KXHzX_0OkwAFFyJH6aU6Q@mail.gmail.com>
Subject: Re: [PATCH] selftests: Use kselftest skip code for skipped tests
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, skhan@linuxfoundation.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>, nikolay@nvidia.com,
        Guillaume Nault <gnault@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, idosch@nvidia.com,
        baowen.zheng@corigine.com, danieller@nvidia.com, petrm@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 2:17 AM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
>
> There are several test cases still using exit 0 when they need to be
> skipped. Use kselftest framework skip code instead so it can help us
> to distinguish the proper return status.
>
> Criterion to filter out what should be fixed in selftests directory:
>   grep -r "exit 0" -B1 | grep -i skip
>
> This change might cause some false-positives if people are running
> these test scripts directly and only checking their return codes,
> which will change from 0 to 4. However I think the impact should be
> small as most of our scripts here are already using this skip code.
> And there will be no such issue if running them with the kselftest
> framework.
>
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Perhaps it's a good time to mention this patch to add a kselftest
helper library for shell tests again:

[PATCH] tools/testing: add kselftest shell helper library
https://lore.kernel.org/linux-kselftest/20201123162508.585279-1-willemdebruijn.kernel@gmail.com/

That can avoid redefining this constant in every file.
