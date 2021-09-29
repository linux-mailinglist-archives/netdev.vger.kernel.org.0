Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B6341BEA5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244229AbhI2FVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 01:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhI2FVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 01:21:08 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C4AC06161C;
        Tue, 28 Sep 2021 22:19:28 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id w19so2728348ybs.3;
        Tue, 28 Sep 2021 22:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lgPcYkJU04EEpDlUPbryRL95NQ/b023yl3dG0wdTb9U=;
        b=XYX/WxC97FCdYO9Z0vVYr0fxKM1o5Ns8apnLfDiKpNHSBGYz8BW7VcsEhRAUlAlGMn
         ehoHEWl7+OkkRYgLU3yT8wuh3TR0SIjLf0WZ0jW0nUPWN/3AUtkO51vd7rd+xtAVqnpj
         4TpIB7UBMAFm0JjWYeuYqSjbKqPFT/bltuadY8paEkm2f84bnEOnjcgHNRcclUkYKH8E
         fCx5W8Ngf3p8XlTP5tcLAyIzyMpfBx0yoTAVe33N6N3y/qgw9T0Ii0vGCJL0MT8D3yI4
         YJzqAbyvioiTEBxO+2LVkHZKYwqmrqzHE+Bpay9+32C9xfm9M7ZdVCJLWXnFsgGm8pQl
         b4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lgPcYkJU04EEpDlUPbryRL95NQ/b023yl3dG0wdTb9U=;
        b=YJPF7EAy5JHrNKgTKI3fmnG/XUwNB3Y38gnxAZi7Kj1pMd06c8+Qj3HCC44YH+igKx
         Xngg+Sb6R4erBVCmABmeh1XLMNKZLPZaiVhgPc1HmbliJG3t7MJxxorLkmwn2zf/aM6B
         JDuqqQLSxGHB9eTOG1P74KlGrBzfRQXD4CFThWMZU1vpMkaL3APF8/iMgAlR9P6oZoO/
         CbN8vr3LNpAJAZlScek6A6ROdjTZKZH8tVJaxt3EOBgG4JAt9pDjj7MnzVN/dJkcQgq6
         IxtZoUcxmyMXx6/rvDMkoOSfBFgNjfgcdVJzG4Lv0PeUFhkcU3IEAo20Yax17BG04ZDW
         Nx5g==
X-Gm-Message-State: AOAM531a2t/1A8skKamK+u4IZN8VNTaSmUCSQYkbo9DOyJhtwJuJwF6z
        hptsYO9k6tn6eYlkHMqo7XdtPAUXA67k1UEAn2o=
X-Google-Smtp-Source: ABdhPJyEa8hSnRrt5QytS0deYF5qTNw6fqoa4RniKdtM5kH/CXV2VpIr+UeOkK1Memxg+jYivYyt2CE2oAVM9Lg/3d0=
X-Received: by 2002:a5b:507:: with SMTP id o7mr10361642ybp.491.1632892767289;
 Tue, 28 Sep 2021 22:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210929020642.206454-1-liujian56@huawei.com>
In-Reply-To: <20210929020642.206454-1-liujian56@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 28 Sep 2021 22:19:16 -0700
Message-ID: <CAM_iQpVCJYDCdh_ZUjMpc3QMU5861Yixs+P_YPs1gpdzE1c-5g@mail.gmail.com>
Subject: Re: [PATCH v4] skmsg: lose offset info in sk_psock_skb_ingress
To:     Liu Jian <liujian56@huawei.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 7:06 PM Liu Jian <liujian56@huawei.com> wrote:
>
> If sockmap enable strparser, there are lose offset info in
> sk_psock_skb_ingress. If the length determined by parse_msg function
> is not skb->len, the skb will be converted to sk_msg multiple times,
> and userspace app will get the data multiple times.
>
> Fix this by get the offset and length from strp_msg.
> And as Cong suggestion, add one bit in skb->_sk_redir to distinguish
> enable or disable strparser.
>
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: fix build error when disable CONFIG_BPF_STREAM_PARSER
> v2->v3: Add one bit in skb->_sk_redir to distinguish enable or disable strparser
> v3->v4: Remove "#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)" code;
>         and let "stm" have a more precise scope.

Looks much cleaner now.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
