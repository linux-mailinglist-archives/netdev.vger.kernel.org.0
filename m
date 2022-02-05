Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1F04AA6B8
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 06:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiBEFOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 00:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiBEFOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 00:14:31 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EDEC061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 21:14:30 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id j2so24846339ybu.0
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 21:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+I5R1Tzn6Y/4HaTXJrdJSNQ6sSMv1i3VLowark/057M=;
        b=ZS9Zru5BcoQHPcw4PYIDao7sWhWgjJDWZUG+xK7E+yCLVUmKkPk4Kj6ZyvNvOThgEA
         w5Vn0ERD62FdRTUoPIvVbECj8fVMmOfhsstbmhvjEQR/L1EgD+csrEuWqSmt2y5qHnhU
         hEIPKjQWln7xtVqs6P4pYlqv9c3qkMkm7wtD+9OJPE3c4MNuFkFrYL8LfvQNmckExzts
         wo/AJNLrLtoc/BOQjo0XJdndfI5e/+ya+Dzb3LeSKeshuykrbzgB9TDIo58PnAKnT2hl
         MqCkLOc5faZluGhLlky1vlMxtSdK3rF+C5ZcgDVn/zu+Mj0AIHzBaqxvaB8hSxYAbCzn
         MaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+I5R1Tzn6Y/4HaTXJrdJSNQ6sSMv1i3VLowark/057M=;
        b=LOqA5wimbHq8wuCfTRm+h1Q7koLbTB0dAgRUHOGsNp1UvtBoWjovS3k0g2vafkoS9B
         qpM8G72ZuMlCUIO8gJ5Il7PibzXn25sbJ0x0SYIPUza8oUH573H+n+W6RMWqc26zmcpD
         LLPQGacmeISF66BSXioqllmvGFpyK/Wd1HBGrgo7hT3sxf44dr6N8SExMb7eQEGEz+wv
         oUx7+ky+qoR7TeqwoiYEdld6lsqEb9rwoO1XEdGcmKctllB4/vbv9RbxhtfENXnhkyGK
         4TyHAkRTa9cngGE41wtjQiGpME/h5xXRAr3tp3+88ad0B3G1t7Yxt8eB2TBEqH+wZbb7
         XrwQ==
X-Gm-Message-State: AOAM533geQLcqAoX6eIoLQKq9m4uX6TBx5fVR2mhnXc3SxM7fQS2Whpr
        PVFhHt1bmqiZJqOXn62Rz24DXxev6RupL0ucrSzLKoRIUR4dw5rl
X-Google-Smtp-Source: ABdhPJwi8v1ce4uaEU+2ZXquzg/R5Vj8o4/fItJ+FQiQonke0pj9qywbAt0tR1WNQ5Hub7X4+Qk+PRg8zTb3mnSrpHs=
X-Received: by 2002:a81:80d:: with SMTP id 13mr2291815ywi.40.1644038069652;
 Fri, 04 Feb 2022 21:14:29 -0800 (PST)
MIME-Version: 1.0
References: <20220204105902.1421-1-claudiajkang@gmail.com> <20220204193438.2f800f69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204193438.2f800f69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Sat, 5 Feb 2022 14:13:53 +0900
Message-ID: <CAK+SQuQ=HOXtPNYOXHzPnWFOjJkNAW5zuSHgh4-EAOtU_XyFbA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: hsr: use hlist_head instead of list_head
 for mac addresses
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Networking <netdev@vger.kernel.org>
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

On Sat, Feb 5, 2022 at 12:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  4 Feb 2022 10:59:02 +0000 Juhee Kang wrote:
> > Currently, HSR manages mac addresses of known HSR nodes by using list_head.
> > It takes a lot of time when there are a lot of registered nodes due to
> > finding specific mac address nodes by using linear search. We can be
> > reducing the time by using hlist. Thus, this patch moves list_head to
> > hlist_head for mac addresses and this allows for further improvement of
> > network performance.
> >
> >     Condition: registered 10,000 known HSR nodes
> >     Before:
> >     # iperf3 -c 192.168.10.1 -i 1 -t 10
> >     Connecting to host 192.168.10.1, port 5201
> >     [  5] local 192.168.10.2 port 59442 connected to 192.168.10.1 port 5201
> >     [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> >     [  5]   0.00-1.49   sec  3.75 MBytes  21.1 Mbits/sec    0    158 KBytes
> >     [  5]   1.49-2.05   sec  1.25 MBytes  18.7 Mbits/sec    0    166 KBytes
> >     [  5]   2.05-3.06   sec  2.44 MBytes  20.3 Mbits/sec   56   16.9 KBytes
> >     [  5]   3.06-4.08   sec  1.43 MBytes  11.7 Mbits/sec   11   38.0 KBytes
> >     [  5]   4.08-5.00   sec   951 KBytes  8.49 Mbits/sec    0   56.3 KBytes
> >
> >     After:
> >     # iperf3 -c 192.168.10.1 -i 1 -t 10
> >     Connecting to host 192.168.10.1, port 5201
> >     [  5] local 192.168.10.2 port 36460 connected to 192.168.10.1 port 5201
> >     [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> >     [  5]   0.00-1.00   sec  7.39 MBytes  62.0 Mbits/sec    3    130 KBytes
> >     [  5]   1.00-2.00   sec  5.06 MBytes  42.4 Mbits/sec   16    113 KBytes
> >     [  5]   2.00-3.00   sec  8.58 MBytes  72.0 Mbits/sec   42   94.3 KBytes
> >     [  5]   3.00-4.00   sec  7.44 MBytes  62.4 Mbits/sec    2    131 KBytes
> >     [  5]   4.00-5.07   sec  8.13 MBytes  63.5 Mbits/sec   38   92.9 KBytes
> >
> > Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
>
> Does not apply to the current net-next tree, please rebase.



Hi Jakub,
Thank you for your review!

So, I will send a v3 patch after some tests.
Thank you so much!!

-- 

Best regards,
Juhee Kang
