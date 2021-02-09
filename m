Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB1F31483F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 06:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBIFcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 00:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhBIFcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 00:32:35 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22DDC061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 21:31:54 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r38so11725045pgk.13
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 21:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Es1GdAlUGQj8jvxU9L2mbmTr2aezEuOKz5fxGjCRcg=;
        b=YRlFv4ssrgJ8GE90hEUV7OcvagfuecikdW3NBvPX6mJubf3BJM0iTaAB8JL0V9JWQf
         xgOP2VVdZxixQQzuVydBnJAKWQoG1Ng9wfBKdJWSIVahPt2OS/fhE0bz3+LZxrilLfQJ
         Yqc62dEiFoqpjO4DAkr0PBxGh7sAqVwK0a7w3PTFVlaGjU9Cs8o04AO5gfCe5B+1viGH
         qGOIMZNGKa9KXXfHxetdtx2eHoJ3O6zrTIr7r4RzbLBere364wP3jIavzx8CKY0p72Ze
         3/+sVw5HhITWMUfKlUqVwwNjdpESkKshNBL7kPj0s1d5q6WAovyTiLWdD+LnMD1J8Hgg
         Enaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Es1GdAlUGQj8jvxU9L2mbmTr2aezEuOKz5fxGjCRcg=;
        b=Z+Aq7xk2dgpDG11n0/hk9Rs1ziuz/Z+qW1IQdJv9F9VsyHnnykYJSRbtkT+94bxSU8
         +PGKSTqfr0NMLAYVO9R1f/JA9YE35nduri4CG9W9xY6/3g41FYItJ+8w1VGZAxBxafJN
         20tBCajfGmNVQMWcdH59RlOl9vbdEfaC6+qDPzN1lM7YxgrozcsUOm373oka4BF4d0Rk
         zshqrocbeZsY6NF9jENMheIKFy6XyU5hbzEa2ZYakoXJB1a3ExeZymog1AAYcj/Y53Zt
         GeS0Yv2gl8AKnjvAzcHGiGHAOFrHsNalSCRRgubZicED8irNOBriZhKB/xdPiuM/G6LS
         4QlA==
X-Gm-Message-State: AOAM533BNzAou+NBVy0ZbIuwvWsm+O7JNkqBTmHeHsH2Jlm2YRvRcV8f
        3BZqloLfJyXAllbUQBTK6t09UbHqkgSB2B0K2b4kKFzF768=
X-Google-Smtp-Source: ABdhPJyn1rKc1BHOXxEH3Nhl2HlqjAsI8ZYQYtnAtmgWQaTOfMLbXdLMWDzjFjP8zyLb0/7RkyBO/m/Kxg5Iqge43HQ=
X-Received: by 2002:aa7:9981:0:b029:1d4:2f7b:e0d with SMTP id
 k1-20020aa799810000b02901d42f7b0e0dmr21439569pfh.10.1612848714027; Mon, 08
 Feb 2021 21:31:54 -0800 (PST)
MIME-Version: 1.0
References: <20210208175010.4664-1-ap420073@gmail.com> <CAM_iQpU5Z_pZvwKSVBY6Ge8ADsTxsDh+2cvtoO+Oduqr9mXMQA@mail.gmail.com>
 <CAMArcTXXsWoRqcsg0-zkDTwPbAonBCo1tBiKTr7_ZBF1Y5NxqQ@mail.gmail.com>
In-Reply-To: <CAMArcTXXsWoRqcsg0-zkDTwPbAonBCo1tBiKTr7_ZBF1Y5NxqQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 21:31:42 -0800
Message-ID: <CAM_iQpU=GXHQ=j+f5F9nHY8XA=v_qrfc0YDvEKJJ=nv02BXZTw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8] mld: change context from atomic to sleepable
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 6:17 PM Taehee Yoo <ap420073@gmail.com> wrote:
> You're right, this patchset contains many unnecessary changes.
> So I will send a v2 patch, which contains only the necessary changes.
> And target branch will be 'net', not 'net-next'.

Just to be clear: this is up to you. I am not suggesting they should
target 'net', I am fine with 'net' or 'net-next'. All I suggest is to split
them.

Thanks!
