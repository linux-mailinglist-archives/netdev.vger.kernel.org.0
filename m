Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D263644E14A
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 06:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhKLFJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 00:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhKLFJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 00:09:30 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DE5C061766;
        Thu, 11 Nov 2021 21:06:39 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n85so7491055pfd.10;
        Thu, 11 Nov 2021 21:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/n+GN0QL32ZPG4TXED297nA7LqFZql5MFrW4dGLFaWU=;
        b=kyImFrLY7nztfPU+Fic0Iz1UiJOcf+NrBP40K0Drnv2IUQqHM7HVuWtZm0sbf6Wvb3
         l8Q1Hg4lI/tFLw0MTOnHnA6fVb7jwQimraXKNUX+K/0P2UDOjI8tT/CbPFvo9fIjGtJd
         YSf8Efkws2ons0TdbXw9/Rob4JctFiOkZ3dDdowcurGjbkKLcDaN7oc4E9BEjc/uDeaY
         Fex/1TxTxiRpFaeK/txB+epvlkTvCnH2tTIAxWCaYLjJGdS7foGDk+YJ50ofEvAZ+B2b
         e+mVR5D0GuyzXYc09rHd6SoX3/SQ1NC8O5i9Sf/2zytRsQ/ycww8hV6ecYRuIvDWREoP
         Zc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/n+GN0QL32ZPG4TXED297nA7LqFZql5MFrW4dGLFaWU=;
        b=WEw2K72grd7qnk/4o6boYpVdXvy6xig7RVMj9J1F+yHI0PkfJBRriQ2tgCHajII5W3
         uOprhFtmCC9dA1FhIE3/j7EhbsjyDj9egZkHCcRnTB8gDVdbGYkscBIU+d3IgwsrXLGx
         JP5rIQhsbXZq2RXCSNRztEJnUrbgalJj1GHJLzKJZAAGqic4t6kFMYeDr1lv5V439dhy
         joLbcUQXR354a5hOw9wgwVfVylUKiQU/C7MzNT2xpcvB2S36wBPhWYc7qf8YSapJqhdu
         /UhlKf/o2SUEj3x+rJcIVQdW0J/M3CkERV2psCSV5eS4syoIdk1NLiT0WMa9ayCO0WbD
         L62w==
X-Gm-Message-State: AOAM532lc/4YYMDnY2reTOKTRur4tSnZNn4ZNKPJ3k9RKsj6JMj4vXVd
        X2LhqvbxVvx/TqN7ndAWuPaYNEzBQM2imvuEp4M=
X-Google-Smtp-Source: ABdhPJwjASYotgwsahISTtFJ+UEq2OrcDTFdcqWJsYYHCQGtoCuNCus82SrbXfrtqy8PARFf94k0Xl0yF0QylVOtaFE=
X-Received: by 2002:aa7:9a4e:0:b0:4a2:71f9:21e0 with SMTP id
 x14-20020aa79a4e000000b004a271f921e0mr1918802pfj.77.1636693598591; Thu, 11
 Nov 2021 21:06:38 -0800 (PST)
MIME-Version: 1.0
References: <20211112032704.4658-1-hanyihao@vivo.com>
In-Reply-To: <20211112032704.4658-1-hanyihao@vivo.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 11 Nov 2021 21:06:27 -0800
Message-ID: <CAADnVQJ3XvUQQe67OYe=9Dq_LKbUO4E4WdNO3LWFnKJvzM9qow@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: use swap() to make code cleaner
To:     Yihao Han <hanyihao@vivo.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 7:27 PM Yihao Han <hanyihao@vivo.com> wrote:
>
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.
>
> Signed-off-by: Yihao Han <hanyihao@vivo.com>

The point of the selftest is to open code it.
