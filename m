Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA744D67AD
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350785AbiCKRdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350449AbiCKRda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:33:30 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910709E;
        Fri, 11 Mar 2022 09:32:25 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o26so7999359pgb.8;
        Fri, 11 Mar 2022 09:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cbDLeYZRi3PqTVaN32FtTtne4st0hjAXHY6M3Yx/o8A=;
        b=FkSaP+tFeaUnxuXRQ5zN60/7gn/yqDwAXboaWrqdslqeBLlMs5igjMMUejA3P/qmEu
         J/3ukDCZCus8xAsgZMowit5rIGLsJNUSE7chKpBvxTHVMoLGk3phMsQPP/YKRZdx2DX1
         GQjQJlbyKQXmmsW7hzZPfMdml5a8WrSpK/6MiTWOp5IIK3FokpXeymXkLwjebIP78x7V
         934NDnUQoc7UeqAYv46sjWnZhndvu/9nxAN4tyN6TZRxjbP9yn+PCEtxJOgp4eA8teyU
         hOESS0Y5V+FhpRE6/Of6HHBnReYDAfyhVdwmjgA/61T/01D0zCSkUHcHTaiYRBOnZ05f
         sXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbDLeYZRi3PqTVaN32FtTtne4st0hjAXHY6M3Yx/o8A=;
        b=V0cWpaUxCDleCWLW8o2g3sDK69+tc2WLCyzIHt5FPmH04cHnor4VV+iDYYkdVpLfrG
         at57Ki+1ACpN+Llr5aOpKgH3S0mfI5Kg/ozi+0FuQCOcgmHX2VH643rvFr0uASTCOkZm
         6FqV52NeuncYWPIq0hN3qpY9YqorsKDwYFqhI98ecsCYaYTXiBAOFkioJ++BxUHrWSsV
         gDn2uHCShPROLnHDVy2PoEPlAKPzF27dM3E7ynF6zF/N61fDCoDAW3k0lm6dsZKQFWG0
         vurlwuRWEd8Y/KDEXBEwC7XA7wa+oxkJ7FwQA5lnyqu/e5welH9YKutBOp+6iKVCDNmG
         jqiQ==
X-Gm-Message-State: AOAM530ajKCjA2MQHXq5Rmf9bGzVGrd4J+VYst69Yqw1nT+iXI3Tl44g
        ClVne3y8vqUlWHrr0ddj7GMCNpssNiUGRjPm1y4=
X-Google-Smtp-Source: ABdhPJxFv04mzpS3rjhpBqnAXWY1YzbhG51F0XOEBMnPnPhGJ2eeM0JWj/NAnE9UXXZciR8dZUEK0BJsiaH+pd24h3g=
X-Received: by 2002:a63:c00c:0:b0:37c:942e:6c3c with SMTP id
 h12-20020a63c00c000000b0037c942e6c3cmr9480160pgg.336.1647019945064; Fri, 11
 Mar 2022 09:32:25 -0800 (PST)
MIME-Version: 1.0
References: <20220222105156.231344-1-maximmi@nvidia.com> <DM4PR12MB51508BFFCFACA26C79D4AEB9DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB51508BFFCFACA26C79D4AEB9DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 11 Mar 2022 09:32:14 -0800
Message-ID: <CAADnVQKwqw8s7U_bac-Fs+7jKDYo9A6TpZpw2BN-61UWiv+yHw@mail.gmail.com>
Subject: Re: [PATCH bpf v3] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 8:36 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> This patch was submitted more than two weeks ago, and there were no new
> comments. Can it be accepted?

The patch wasn't acked by anyone.
Please solicit reviews for your changes in time.
