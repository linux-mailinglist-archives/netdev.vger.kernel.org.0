Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3235AF787
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiIFV7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiIFV7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:59:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AC483F04;
        Tue,  6 Sep 2022 14:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41390B818B2;
        Tue,  6 Sep 2022 21:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22DEC433D7;
        Tue,  6 Sep 2022 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662501546;
        bh=3gb6aVJSTAxppU+E5RUKb50GSyp3R1llE1FD4JAyk90=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BcWxtrysHaxuVsP2SthkDRgacDoAVVqjk/uVYYhH48XeI2gi0evcW07T7P+ltPige
         nmeTtcgnNC1/ZwDxFeSXn/ojHRi890YMixcd5PZ06rVvO0Xbbo0LrOiG0WZcSwTDJ1
         Eo901GkKAPmTH3CoxHKxYduZ2pvsjCNSlLDTH3KdFxlxsUpwE2f4HMvi/yiwRtve5B
         A5byJUYu3+yZnA4ixBH0f7gx6d9oP6dmuys8yBXyhARWO8t6lCgkEHeZ9aIDIsSIKQ
         cr6fSTeFwqD4/tFBTvnng2m33Jk9iqrM/b+h6Q47oU8glOSLDv405F0H3yPQaJwV2v
         wBTiehqxZ8O2w==
Received: by mail-ot1-f48.google.com with SMTP id d18-20020a9d72d2000000b0063934f06268so9028517otk.0;
        Tue, 06 Sep 2022 14:59:05 -0700 (PDT)
X-Gm-Message-State: ACgBeo0oU058UkzZ5kt8ZLpWDWndbla6ZEflPpMwMY6PpYSz1yPm5eRm
        0Scqcah55lkxiLnjsMRyhl33wuUPloMxJKoqA2w=
X-Google-Smtp-Source: AA6agR72DSReC/R+9LMrOjcM15Bhbfjjxz88hMwuaSxkeq8HEICvzO4Z+f1KtvIVeSVPwOnYLvCN9somqW20yJKf7Rs=
X-Received: by 2002:a9d:7c94:0:b0:636:f74b:2364 with SMTP id
 q20-20020a9d7c94000000b00636f74b2364mr233074otn.165.1662501545114; Tue, 06
 Sep 2022 14:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220905193359.969347-1-toke@redhat.com> <20220905193359.969347-2-toke@redhat.com>
In-Reply-To: <20220905193359.969347-2-toke@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Sep 2022 14:58:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7iA7wFsT8WXksfyX1tsASGxSZJW2zC_BrMtgz6PwXVBQ@mail.gmail.com>
Message-ID: <CAPhsuW7iA7wFsT8WXksfyX1tsASGxSZJW2zC_BrMtgz6PwXVBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] dev: Move received_rps counter next to
 RPS members in softnet data
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 12:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Move the received_rps counter value next to the other RPS-related members
> in softnet_data. This closes two four-byte holes in the structure, making
> room for another pointer in the first two cache lines without bumping the
> xmit struct to its own line.
>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Song Liu <song@kernel.org>

> ---
>  include/linux/netdevice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 1a3cb93c3dcc..fe9aeca2fce9 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3100,7 +3100,6 @@ struct softnet_data {
>         /* stats */
>         unsigned int            processed;
>         unsigned int            time_squeeze;
> -       unsigned int            received_rps;
>  #ifdef CONFIG_RPS
>         struct softnet_data     *rps_ipi_list;
>  #endif
> @@ -3133,6 +3132,7 @@ struct softnet_data {
>         unsigned int            cpu;
>         unsigned int            input_queue_tail;
>  #endif
> +       unsigned int            received_rps;
>         unsigned int            dropped;
>         struct sk_buff_head     input_pkt_queue;
>         struct napi_struct      backlog;
> --
> 2.37.2
>
