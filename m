Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F7C6C28A6
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCUDlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCUDlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:41:08 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD51632E50
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 20:41:07 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id g9so4873614uam.9
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 20:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679370067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SbFRU8ncLb4JFFgBXKSLhLrwz/fBmjp1H0evTIG2RUc=;
        b=iSQiF/JGItJkDJ+eUj+UcnVuk9yiaCb0KexFUOIcStnRWKrbvRY/KjbEAFB/TLdin7
         sbYWLIZV1PaQoXZq+oN1Ctrj3f2wKiIqhu7E5AxmKEq8AQxSOVMFdXkg3xG1ULoBFHfz
         F+WtRCLBHtk8d37APoAggFVIPm+UjdH363l53mJ54t4qz9h4Kn02klcaTuhVgjfxuKDm
         r0pcPXD02e4tRsADF0yz4JzaleFBOlxoqqz3RJdWVQmos2pczOgiKsVb7ttd23BjN833
         7rdF2nNJiZr8mVPVzqk7YnpHGLhf0i8/1DmmXDr8m7/yEWO0j2igTUUV23T6FQ8FZphT
         /yHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679370067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SbFRU8ncLb4JFFgBXKSLhLrwz/fBmjp1H0evTIG2RUc=;
        b=T0lTxqEE/wEOf6ONIxrjtxm9pvPhQUodKhxm7Rk06dC8XQ/TYz+JiDj2FP0JEiMyK/
         djbBEJ/2kjnU8Udmm4ka4yNHRWfjIeo7QNQrlpJTaFU8VQYj5Sz0vocCyS6vsXSJf5DQ
         HcLEHe5D0U8Gte7B8VqpTKXkYYJhMkDiiCrQS5rfmNao11GV4ijGS+jB0RcoZnlM/2DV
         7bYUaOxrHS7Wsnw/iimPWwS1FyipI7muOJGbpHHuxROZgASJWK7PLntsnRTbQV5jpkY9
         JIlJRFkVqmtf87kiPpuaah5Sw1X27JBwWNljpf5JuKYVXG8+D0OJEMTbSOW+U0ZFwFAW
         RuIg==
X-Gm-Message-State: AO0yUKUVHsEKPttJEL+58zV2UtHTJMio1hwGNHvLdrrUP+L+sEV7ck+G
        /g587wRP0nftzjsfWeYIASiHJw1+CebZTkzmjjTG3Q==
X-Google-Smtp-Source: AK7set8YR6oHt/L1BYxtPy2ZRlcHhaf99SRNAgW53EwhS1zY46Xv9QX+Tx7VpYcIKNzmfJr/oLHS9KXDMeskbgFc5Jw=
X-Received: by 2002:a1f:3805:0:b0:436:4a89:bb1e with SMTP id
 f5-20020a1f3805000000b004364a89bb1emr455128vka.1.1679370066659; Mon, 20 Mar
 2023 20:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230321033704.936685-1-eric.dumazet@gmail.com>
In-Reply-To: <20230321033704.936685-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 20 Mar 2023 20:40:55 -0700
Message-ID: <CANn89i+cKOrOCOK07B=AEd38VuEYe5ggqr59OVQXfChMjYyhuw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: introduce a config option to tweak MAX_SKB_FRAGS
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 8:37=E2=80=AFPM Eric Dumazet <eric.dumazet@gmail.co=
m> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Currently, MAX_SKB_FRAGS value is 17.
>
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.


Hmm... for some reason this old patch triggers a build error in
net/packet/af_packet.c, let me sort this out.
