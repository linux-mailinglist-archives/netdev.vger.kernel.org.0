Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE45662BA
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbfGLAUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:20:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33883 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfGLAUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:20:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so5181227qkt.1;
        Thu, 11 Jul 2019 17:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dwDUYBtNlHf7CSZi5qWRT+gVqqsYoNg6nfx/dJsJ9/o=;
        b=XitFzXSZX2DTaxQD1YJNlo2w7NRkGMcnxFYZvvfkCFyblntGFKd5uRM/lTcZrxg+XC
         ndS8mSgrUVtD+EhPWA1pcSbxCSSm+Q1cDLYvwii3WYI4kJzGzSOScVVhykwzwM9iyL7f
         /wKlVfEJFdZLlRv2pJMBAnPjh+An46HAwS/1UjN7tEdMCJSacbwQ6LB2DEVTe0VVq9Wj
         P2V5fNSVbCcE9MrVvH4ZU+dAIynuqk8ugma+6TKN5Lw7qVYHja5di948iSIh3mf/AbIb
         DI4TFo0Q/AH+ATT0R/0LF0d9ev9jpJnyoRyamF7hjgPWUMUQfbM0OKWhxtY8VLdaYjOO
         8soA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dwDUYBtNlHf7CSZi5qWRT+gVqqsYoNg6nfx/dJsJ9/o=;
        b=BSPExkWaHDMuaBhidRMEVhG5vI+puLzF+b3O8kmFTxaa+P9ry1L1FXevmsMqgn8+JF
         ncI9/dq9pbouG+KxeEEDtYrAkWobt3HS2bBU5jjecxqBVh7jFxQpJ6+i5BVPlgv0FS1a
         xF/eMGHAfzGFoGQExH2TKp1Hw8u9gPD1dwA3yGwzRof4D/UoeZTcHPyDhMSHt3V/kmiF
         jXMTnkeLGIcg/1r1S0lobVah5cjUW8VxAup94MIIvP4SI9f/1bZ1yBAaQ89e43R2hFxR
         DT1mqoKEZEhEExpnjYgk689BUfNIBCcA8BwGavqCJ+uzyi03mUS2dyDstAfuHFHXQ7R+
         mRbw==
X-Gm-Message-State: APjAAAWKxLVsMeYN5N+uoCR0dnZ55XczTzCpGKnNehU4qJrpGHYk0gMq
        XIi0hppnPKBJYDrzhMLh2OOvrqTTqMY1zclDmkc=
X-Google-Smtp-Source: APXvYqwqXkIpnxrcFBI4+O94Wj6JMHWybc5SRzKyyiFggxyCAeuI2MsA2M2xV73fOfuIXcSIH717fUZx4AeQ0QqP0Vs=
X-Received: by 2002:a37:b646:: with SMTP id g67mr4009950qkf.92.1562890800939;
 Thu, 11 Jul 2019 17:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-8-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-8-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:19:50 -0700
Message-ID: <CAEf4BzZSApnfQ7Z527WqM3ejz5C3BQS9eWdrgJ=k=hqhWADynw@mail.gmail.com>
Subject: Re: [bpf-next v3 07/12] tools headers: Adopt compiletime_assert from
 kernel sources
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> This will come in handy to verify that the hardcoded size of the
> context data in bpf_test struct is high enough to hold some struct.
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/include/linux/compiler.h | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
> index 1827c2f973f9..b4e97751000a 100644
> --- a/tools/include/linux/compiler.h
> +++ b/tools/include/linux/compiler.h

[...]
