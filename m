Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16046D66B1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbjDDPES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjDDPER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:04:17 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758443C3D;
        Tue,  4 Apr 2023 08:04:16 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id x37so19815099pga.1;
        Tue, 04 Apr 2023 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680620656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VGuVc9iWmN4VQupgkCqNpttr0xfto+0leXdufB0lGw=;
        b=mU6DmiDhAZ7UKCCNlA9Mtptj6wsDlsEuRXLNXv+C6PjQQ9+eohPqqbUSBjYq+/4Y9T
         QiprHnZ+yMpXkAwaQcl3tiCq6dpc+Uedhzbl2DhoUL9k3RFW8VHXn/NtowIgjn0cqoM8
         TS0JAaQBY2ey+rD9zftcrrWOMy+58aHXAZmG2otfCc3NJU4hF5AVLD0+pXERrjk3V3NJ
         SEV+sddGs1ZAAvGy5AbGcz5D7MozmdIUqFukGurdCKUl52OfAowZJqTdc+UPizJboWhP
         SC7XZi0QhILRISAMbMXQ9xDm8/OM5igATyLqIvX64XFLy0NhvKXGBiMfKLkIljHE0Pn1
         gjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7VGuVc9iWmN4VQupgkCqNpttr0xfto+0leXdufB0lGw=;
        b=7HYIFmUcTbzFANvcIThxWkn8GtoCof2ZqkRbOmCeIg/CnhNYXO6ALDiK4gp2Bya5vL
         Mxn6R+hMhNTtVVVTeXTxkKRmQBI5KOilfZYalilslEIjJWpZHA3RMAdwy1j7kuvcVhyx
         /sFRl0Xn/WE1jAjztFnCXtDIGmbYzVmsm2JMp5a98bjAQYo0vFFm22eCwbLL17CFYIKi
         /5o9qD1E16Zoau4t1UN01hoc2jZfGm0aSwqMG8NwM4vNrKFUgIuziyzaAdLI66+tIOQO
         050r4NE4IkK6kNdaaYsxiJp0FWLmc1KOVd9f5hxrRaeeEL0Z9nZmT8i7r3g8bLMl3HOZ
         fKow==
X-Gm-Message-State: AAQBX9eJyWi/XIWar8bV8NvU00cxLwd0rlDeNqmfkK9D/lBUK1LrIMwF
        e4z3Vouc/BmCCkogCX4JDidaz+cp0Z9Df6uqDCo=
X-Google-Smtp-Source: AKy350YmOuTFOmWeT7kjqpqgAOLQymxtocjWP1PXl0+xBXseHoBxU6EgnEB1xSvqvADaoRwE6vE+yx/8hNIwIi0K7NI=
X-Received: by 2002:a05:6a00:22d5:b0:625:a545:3292 with SMTP id
 f21-20020a056a0022d500b00625a5453292mr1419728pfj.0.1680620655557; Tue, 04 Apr
 2023 08:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <30549453e8a40bb4f80f84e1a1427149b6b8b9e8.camel@gmail.com> <20230404080024.31121-1-arefev@swemel.ru>
In-Reply-To: <20230404080024.31121-1-arefev@swemel.ru>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 4 Apr 2023 08:04:04 -0700
Message-ID: <CAKgT0Udf_tMn-oeE_Oqu3P+ZqD0Pg65EGoSOoF0qfHeHynU5jw@mail.gmail.com>
Subject: Re: [PATCH] net: Added security socket
To:     Denis Arefev <arefev@swemel.ru>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, trufanov@swemel.ru, vfh@swemel.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 1:00=E2=80=AFAM Denis Arefev <arefev@swemel.ru> wrot=
e:
>
> Hi Alexander. I understand your concern.
> That's right kernel_connect is in kernel space,
> but kernel_connect is used in RPC requests (/net/sunrpc/xprtsock.c),
> and the RPC protocol is used by the NFS server.
> Note kernel_sendmsg is already protected.

Can you add a write-up about the need for this in the patch
description? Your patch description described what you are doing but
not the why. My main concern is that your patch may end up causing
issues that could later be reverted by someone if they don't
understand the motivation behind why you are making this change.

Calling out things like the fact that you are trying to add security
to RPC sockets would be useful and would make it easier for patch
review as people more familiar with the security code could also tell
you if this is the correct approach to this or not.

Thanks,

- Alex
