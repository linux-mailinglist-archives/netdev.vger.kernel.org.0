Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2296D9C7B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbjDFPfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239581AbjDFPfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:35:08 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463167AA6
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 08:35:06 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-316d901b2ecso382555ab.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 08:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680795305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUL9Ul78Bpb3XRyOISIrcWSMNz2ErChRMmovjR4Alg0=;
        b=OYF148h4Nm9P6PgvskOIuWTx30F1Bwm7sbtDJbrJbROEL6DvXKusP6nniCeRlURmqR
         Bj2InPvg2FA4L1hHmkdJMUGoq+ezpYia8hiEp0SJQBf39ETQ75/GR2XsYCc8SFs1gUGj
         Jf4DLn0zPZ0GlGNIpf+McheP0yGY5MwfsfoMtXPV96d4guPMxk/R7YSuetOPL3y+1scw
         En0Dk0K+jo9iVfkcLHvTAX/VoDqS7L/4lxFgnddiTGSXicaTmbnwBfISMqbET7wnlqlr
         8lZFgnbtACkUXk5Z9UmfE1fEuCigYlm6OgLjM5ppw/fUxFUJ9+u7Rmfu02TIZR1YcTUO
         49CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680795305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUL9Ul78Bpb3XRyOISIrcWSMNz2ErChRMmovjR4Alg0=;
        b=YjJgGQehL37QtP/vwQJqTqT40S18QcJkW0dO9VUxXdEfxLXwQjSSfDhy3L0LRFdPac
         MZboLtwATVXfAWkrM5mgx8oUrt3FzFzu/ex4M91Nni+U2N06fiENXRG6PY6CAePlQGj/
         /C5+1agEbH1u0tTCslG0ly9Q0bFrlRxCn7GLoKzZ552mDdDvXAy3FDuRleIbphsWriU3
         2lw5Hc6599eJawI8RzfmgmCzayUxZLpgRjdbbf+wE2WCRCLvza25lusW0xqZHFKW49jM
         Zxcxha2jphHyiodt2DN2C2FqciTJjZbrRJRMRK8qvjWForo0teAvcOPYir2/KLXP8gzm
         YJ9A==
X-Gm-Message-State: AAQBX9eQSZHE4uer2E6LEkCMO4vxi7f7qafnUZ0NZ0mGgEq22o3mBtpN
        1J62NSrlNwWDQZxVD0XVH5HSP4zWp+aM2g3DX6QSlg==
X-Google-Smtp-Source: AKy350bLXM1iysCDol/VAUBxZbdWNsWUekgKrBjhx1FHLZIm5wLO/EyiDgMXj5s262GeacHOp+oPA919pqPuO2gqhqY=
X-Received: by 2002:a05:6e02:216b:b0:325:a6fe:11fc with SMTP id
 s11-20020a056e02216b00b00325a6fe11fcmr223040ilv.17.1680795305527; Thu, 06 Apr
 2023 08:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230406144330.1932798-1-leitao@debian.org>
In-Reply-To: <20230406144330.1932798-1-leitao@debian.org>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 6 Apr 2023 11:34:28 -0400
Message-ID: <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        edumazet@google.com, pabeni@redhat.com, davem@davemloft.net,
        dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 10:45=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> From: Breno Leitao <leit@fb.com>
>
> This patchset creates the initial plumbing for a io_uring command for
> sockets.
>
> For now, create two uring commands for sockets, SOCKET_URING_OP_SIOCOUTQ
> and SOCKET_URING_OP_SIOCINQ. They are similar to ioctl operations
> SIOCOUTQ and SIOCINQ. In fact, the code on the protocol side itself is
> heavily based on the ioctl operations.

This duplicates all the existing ioctl logic of each protocol.

Can this just call the existing proto_ops.ioctl internally and translate fr=
om/to
io_uring format as needed?
