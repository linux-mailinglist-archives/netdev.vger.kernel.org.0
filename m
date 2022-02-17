Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDBA4BA714
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243675AbiBQRYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:24:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbiBQRYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:24:02 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E902B1677
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:23:48 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id p19so14475367ybc.6
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rn1UhOGd2jyYt1jyUwHR/RpMNYObYlqIMiFuVL6W8QY=;
        b=bs3y8mR28JingYLfV44XsP5rfYWXhdR3zI962dHfCXaUsbPS1a7CFrdcWJYonXjfMx
         MaYvIsVKfp7grQqrb6k5kStf5YjTj4ExSIiba7UetDeVQSpp2OabuDPOrovLo6Yq3hHV
         avkWf243yOY7SpvCiRottd3AeTPA8rRNDHv7EhObG9RBeMAvG1DunDn2Oqhrjk6v7EAM
         inf2nqOqT+11E/ATvN80MrvhUadq5bJZp++oDmGzbUCcOt7YN75sshNC908EjOSkpGFz
         U/5Vp7Tw+tkEoiI9oQzai/v0nFLtoLhHwt8/EXbc2+tiVjkVIm7HD9exN7qQYlAH+4lP
         9pyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rn1UhOGd2jyYt1jyUwHR/RpMNYObYlqIMiFuVL6W8QY=;
        b=ZGulSIaLuLX+WMt2eu7gIc6jpHSCvjwosvZo56+qYWxW5dfJ2HiAtec2mN6p0x7SZ3
         lZp/aoySKpt3/A5LPEAKYThtPkxeXqNS8wz6JtfQ69mue/yp58qYnNwgfLe6OIi8Bdhs
         yvz8vD7CFYG6ksdOWiLY2VFU+9PjshLbMh8E+VIReLYzN97hbDPL9XAhz+9X1SEF0hL4
         z6m6yPp+3gA9LJV+WWO0wfFLy6ge4MvRKwxHUUbTjdkn86Xi1GJPpRJxqxXfhSYFg5q9
         Tz6U7l/upxbfOf80mvSebwaTGK7POp8Nl/i3h20Hj+q/m95U8ZVe6PLO9qy8g4Zqidt4
         VWxg==
X-Gm-Message-State: AOAM532TUef/XjCDIIEF7ojBisn89LwpzW68KqFHbmsPJVau7tvGVQTm
        Bv9IaIC9NsCzVOwL4hlohxH5FzIzawPpx4qjvJv8uA==
X-Google-Smtp-Source: ABdhPJyBP5hZ0CceAaNWeKl3/EKtmgd5ZWCIerzxgl0dIvxqbmbhrCZz5vcKYXM4naXnV84zQMkdkVHSsGvzQvdhxgc=
X-Received: by 2002:a25:d614:0:b0:61d:bb22:8759 with SMTP id
 n20-20020a25d614000000b0061dbb228759mr3546658ybg.231.1645118627191; Thu, 17
 Feb 2022 09:23:47 -0800 (PST)
MIME-Version: 1.0
References: <20220217170502.641160-1-eric.dumazet@gmail.com> <CANpmjNMR_3Z9BfB9hYzHvjqwJV4AetHAm+ZPAOPFJhZin=jD_A@mail.gmail.com>
In-Reply-To: <CANpmjNMR_3Z9BfB9hYzHvjqwJV4AetHAm+ZPAOPFJhZin=jD_A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Feb 2022 09:23:36 -0800
Message-ID: <CANn89iLnwGDq7qn1cheYk-=ed9UT__eYc3Gbze8s_tYyb=KOkw@mail.gmail.com>
Subject: Re: [PATCH net] net-timestamp: convert sk->sk_tskey to atomic_t
To:     Marco Elver <elver@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 9:18 AM Marco Elver <elver@google.com> wrote:
>
>
>
> We also have atomic_fetch_inc() in case it'd make this simpler.

This was not the case back in 2014, I did not want to add more work
for stable teams.

Thanks !
