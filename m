Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF6F523F67
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 23:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343526AbiEKVXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 17:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiEKVXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 17:23:49 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D09C5DD34;
        Wed, 11 May 2022 14:23:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso3143826pjb.5;
        Wed, 11 May 2022 14:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VvDCd/At1ikMVmsEgnubdI0TPPYRdjzMNNE8etT+OBU=;
        b=bsjlM7Pq6U03CPBLLJDkeXSVF+7dcAW8JJvWtSeLe3wG3Wk4iITnyn6kHrORor7KUb
         Yd+6z2UzXJz6Wbpu6MmN/4Kd23s9shnjUqgHH+9ZlGemr+n0h8vk/tmlGOUaAddX+WZm
         e3kTtx1ThpBpq/dWwZBa3DYxz4fIR02c+fbvwHeJEY9wpb91YbSBcqTRW2A3zTO8kCJG
         fG5lUcM5XLXBkeMLi7R6hodzQSLbq78d2QkLIR9vKcYMQ9nrj3MiTjiaXN+oqBkfAGDb
         EXYfZTMKCL2mgMTE6Wmj78hLWa0k+IBEK+uwsjjEpUNL4me04Oj8K3KYdKi5P6VyVBb4
         bluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VvDCd/At1ikMVmsEgnubdI0TPPYRdjzMNNE8etT+OBU=;
        b=zHWqJCD43Ojg+U51x2MkBUZ46y4MDyrSmqjypf5+o/eMERXRVrS3C+hrC04/MTaTp9
         tdK5k0qjiT52Wl0gfE4YHHPodOMsPwJynDKw45xFl42Q0zsVVOdT+vJBg90ETJwXsGpk
         AJZlm4XKSCxmtBmjW4r9t1p6xDjErCyfXC5TTJsqW+a7UC3CfhPFl3056pymLEeigNz+
         pEhe5vv2kkxk0N5/5WfgTbnk9Ar/OAmM9X/tGqX3AnvMKQmumB7JBxU0SKIYzG/G2EcI
         ivMdioQNFVEqYgyTTxLLOfp62XM9Nhbty7gdL22JFtBWEHsHqgejMWuQNXO4E5yFH/hV
         LpKg==
X-Gm-Message-State: AOAM533v2JuZhCrZbn4hOEp3C5DGdCx1kg1YIlp03QD56oaSAv7sWOsT
        abQ+5LAeT9dysVUxXUG+gftAfiH0A2cncPcGhn8=
X-Google-Smtp-Source: ABdhPJzH3GqZYny/2c0KD7LAm2yheDLy0TMd0D9kGLu2hsACI+zrLgcPCJAau+hJ0XZIcfaMBR8jTv7d+hKy66JgZHU=
X-Received: by 2002:a17:90a:528f:b0:1dc:9a7c:4a3 with SMTP id
 w15-20020a17090a528f00b001dc9a7c04a3mr7244557pjh.112.1652304227558; Wed, 11
 May 2022 14:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220509140403.1.I28d2ec514ad3b612015b28b8de861b8955033a19@changeid>
In-Reply-To: <20220509140403.1.I28d2ec514ad3b612015b28b8de861b8955033a19@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 11 May 2022 14:23:35 -0700
Message-ID: <CABBYNZ+qpWTX-FQ8QCiey0kf_rghDMnfQi3tt8zsv-5cuudbtg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Fix Adv Monitor msft_add/remove_monitor_sync()
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
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

Hi Manish,

On Mon, May 9, 2022 at 2:05 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> Do not call skb_pull() in msft_add_monitor_sync() as
> msft_le_monitor_advertisement_cb() expects 'status' to be
> part of the skb.
>
> Same applies for msft_remove_monitor_sync().
>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
>
>  net/bluetooth/msft.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index f43994523b1f..9990924719aa 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -387,7 +387,6 @@ static int msft_remove_monitor_sync(struct hci_dev *hdev,
>                 return PTR_ERR(skb);
>
>         status = skb->data[0];
> -       skb_pull(skb, 1);
>
>         msft_le_cancel_monitor_advertisement_cb(hdev, status, hdev->msft_opcode,
>                                                 skb);
> @@ -506,7 +505,6 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
>                 return PTR_ERR(skb);
>
>         status = skb->data[0];
> -       skb_pull(skb, 1);

Well if it expects it to be part of the skb then there is no reason to
pass it as argument in addition to the skb itself.

>         msft_le_monitor_advertisement_cb(hdev, status, hdev->msft_opcode, skb);
>
> --
> 2.36.0.512.ge40c2bad7a-goog
>


-- 
Luiz Augusto von Dentz
