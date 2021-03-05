Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE5232EDEE
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhCEPJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 10:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhCEPJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 10:09:00 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A314C061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 07:09:00 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l12so3056188edt.3
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 07:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JjTJfcQAXeOWcp9QkQJCNvSpKl1Ds2qR5zvC+5VzgvI=;
        b=CpyWh+9m1kcl9bm6CS/WtsL7nEetdYXq/2VszRk50K4nPPdMtT736vpXI66iJE+BnP
         t8M5VYEFLqkXwIEad8lE8fLWYnkJMGaBvSLvWwSvibSg8gdi+vB6cm6o3ema3ymJDQCr
         eF5qaICjAyLicS6JRBJ5Q+SM4a9temU0s9hUkJtp/QsB3KWbgOJRQFC9XJr14GCTDkj8
         MsijxkYsXAqGstSCZWDAn3d9H/XiLJICOFqB2MaG/DRPPjEHUTt7cfphfPT0TdG1PRnF
         TFVOapdBPLFDGav+yFTXhp7qDZ/uuVWuH++U/k3g/b2dk2ztzQksQfKYu6AC3nr/AftS
         zG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JjTJfcQAXeOWcp9QkQJCNvSpKl1Ds2qR5zvC+5VzgvI=;
        b=N2mlllnz/lSbl4g+ehHbFZofDfKIdtKvtCW7WrLgSCbG8lpcc3juAAg8g237UbHHzS
         /z5Tf7a6ogEAdIH1MlpKTJ+TzDnvVWo08lxvEz6sDKv4swuzd5IX6A8Y5J5NBagwa4EO
         8HsXVie78j8RQoFnG70y1R0huHQvG51RPCdh2aG+40U0UF3BGjxrXbU87SbgF5niRO1/
         VlJxmIiP0VqoCYB8NBmVfy8fjETTpi86PHMydaiK+YWpF1HcqpiChuHL7F0+ri6H0DHX
         BRXilziuGPFqmZRDFsTgJpkT9CA4FbpoNMbrFn5tE0l+0J7BcQ2ruHaQaAdzcXx7Nqk+
         N7Dw==
X-Gm-Message-State: AOAM531sSb4uoKtkUnFRSee7wO0ifg7cz9OpLdbP17W+DV4hdOU7Dn+B
        LBOWPXqWGOklwotj+8V2Rbp8TWuri6w=
X-Google-Smtp-Source: ABdhPJzxYXB0fSfP/LpLuhR5XcSqJDQV0rU07EpYwidNpaHbwTe/rvz6ZS4d7K7mkl8hEXW1fSinKA==
X-Received: by 2002:aa7:c4d1:: with SMTP id p17mr9564391edr.387.1614956938514;
        Fri, 05 Mar 2021 07:08:58 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id k22sm1735260edv.33.2021.03.05.07.08.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 07:08:57 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id w11so2436203wrr.10
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 07:08:56 -0800 (PST)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr9605831wru.327.1614956936586;
 Fri, 05 Mar 2021 07:08:56 -0800 (PST)
MIME-Version: 1.0
References: <20210305123347.15311-1-hxseverything@gmail.com>
In-Reply-To: <20210305123347.15311-1-hxseverything@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 5 Mar 2021 10:08:20 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc_RDHb8dmMzfwatt89pXsX2AA1--X98pEGkmmfpVs-Vg@mail.gmail.com>
Message-ID: <CA+FuTSc_RDHb8dmMzfwatt89pXsX2AA1--X98pEGkmmfpVs-Vg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests_bpf: extend test_tc_tunnel test with vxlan
To:     Xuesen Huang <hxseverything@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 7:34 AM Xuesen Huang <hxseverything@gmail.com> wrote:
>
> From: Xuesen Huang <huangxuesen@kuaishou.com>
>
> Add BPF_F_ADJ_ROOM_ENCAP_L2_ETH flag to the existing tests which
> encapsulates the ethernet as the inner l2 header.
>
> Update a vxlan encapsulation test case.
>
> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
> Signed-off-by: Li Wang <wangli09@kuaishou.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>


Please don't add my signed off by without asking.

That said,

Acked-by: Willem de Bruijn <willemb@google.com>
