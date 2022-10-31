Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B4612F38
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 04:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJaDIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 23:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaDId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 23:08:33 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88BF9582;
        Sun, 30 Oct 2022 20:08:32 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id d6so17298490lfs.10;
        Sun, 30 Oct 2022 20:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+uZsjIKULsVOshVcFDmebEMGoN/bqKIXqxINsAqCIDY=;
        b=FhlRNd8Y8g8xmbiq7u7nn2UZXmiVYaDR1I5hnJpwY40qY334fcjQHj3ovw1dUHtGtX
         OX5JT5kwkkHIH4dRYJYJ2C7XbGOYvfOyMrL3UI1OZljeOXzpvtpfWILepT9XVfjonM6f
         HCmuqwVtYN/bfbqatqhpS3crti+FmcjXS4rfimL4ucAIwrQTK3mG6E8fhbTOu5XVxw9t
         hxWNpy8DPxxW3xiiZUQnYx9aVXt5eLRwjpVaq6aS9Y3fv2h9KmK0WGyy3awOOFEm/bfT
         MkiJf5YHOf2Ruy6YNwWdwHUksVnnz9/A+AWQJlWi63fThnOYRd4JMsH/adssJ3Ky2BMP
         /7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uZsjIKULsVOshVcFDmebEMGoN/bqKIXqxINsAqCIDY=;
        b=khwFBpD6rhOH6aSMqd6acNMNNHBuPIwucNQ8L2ylje0QmkklMy3zK/71N8Bxo8bEQB
         JloRjHnCl+kS8kZ7BOOOrg+LPEABnOEsuEZispKAOrg1DxBeOUnrnnNXJ6YrwuZ5IkwT
         jUoiSZeBZ0HqtGcXC+31yPStGyAMsgqr939DGCLgVVTo479tYPnoSwQVvmrtl4IRaYLc
         rIjk/qzSe53kvNge3Serr64vWLpGZZDldXR1boDTHUVvyl9GSM9T1e1SvqZbxdlcGY0i
         Q0rx6Dy5+KCmbToMv8iT6lLUjTvUfucaiYrw/Distg3PC/xdziMIkGSwSYXoGxWMjGHK
         LRfA==
X-Gm-Message-State: ACrzQf2RPeLt7E2oir0aUKT5wyDg7Bl0pHNItrGOgkvfn+y35fMUsw+M
        B9RQWC4xbvPqcdevObf0tZcU0iYAaCP2GEleRKw=
X-Google-Smtp-Source: AMsMyM64tOpy/IP5cUlW+1QLVzI07P8FfvqEelKTWCNC6h6hvR35QfSc07BPNhX5R4ONu7y9F6p84yDNgUpo44iSwCs=
X-Received: by 2002:ac2:4bd2:0:b0:4a8:29b8:8e5 with SMTP id
 o18-20020ac24bd2000000b004a829b808e5mr4393348lfq.542.1667185711238; Sun, 30
 Oct 2022 20:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221029130957.1292060-1-imagedong@tencent.com>
 <20221029130957.1292060-3-imagedong@tencent.com> <CANn89i+mK2VG2VnxPduSREHp70gJLP7oNp3SUoMW-YaSd7jJRA@mail.gmail.com>
In-Reply-To: <CANn89i+mK2VG2VnxPduSREHp70gJLP7oNp3SUoMW-YaSd7jJRA@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 31 Oct 2022 11:08:19 +0800
Message-ID: <CADxym3a2qsM_2s_thwv93QLr-KP4eDcqPaK6LPUGnhenraKZ_w@mail.gmail.com>
Subject: Re: [PATCH net-next 2/9] net: tcp: add 'drop_reason' field to struct tcp_skb_cb
To:     Eric Dumazet <edumazet@google.com>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        kafai@fb.com, asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, Oct 29, 2022 at 11:23 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Oct 29, 2022 at 6:11 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Because of the long call chain on processing skb in TCP protocol, it's
> > hard to pass the drop reason to the code where the skb is freed.
> >
> > Therefore, we can store the drop reason to skb->cb, and pass it to
> > kfree_skb_reason(). I'm lucky, the struct tcp_skb_cb still has 4 bytes
> > spare space for this purpose.
>
> No, we have needs for this space for future use.
>
> skb->cb[] purpose is to store semi-permanent info, for skbs that stay
> in a queue.
>

May I use it for a while? Or, can I make it a union with
some field, such as 'header'? As the 'drop_reason' field will
be set only if it is going to be freed.

> Here, you need a state stored only in the context of the current context.
> Stack variables are better.

It's hard to get the drop reason through stack variables,
especially some functions in TCP protocol, such as:

  tcp_rcv_synsent_state_process
  tcp_timewait_state_process
  tcp_conn_request
  tcp_rcv_state_process

And it will mess the code a little up, just like what
you comment in this series:

https://lore.kernel.org/netdev/20220617100514.7230-1-imagedong@tencent.com/

I hope to complete this part, or I think I can't move
ahead :/

Thanks!
Menglong Dong
