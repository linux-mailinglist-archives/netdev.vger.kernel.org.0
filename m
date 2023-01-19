Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D1E673581
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjASK3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjASK2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:28:20 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7754DE19
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:28:18 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id p188so1909925yba.5
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHfo1kQOrHc/qt5QryKNnJO+LQYZnr1UzCOCTPTkvIc=;
        b=UCY8799w0tLCZ7KkiPTdHG82jRn59KXqatESWD0FDzPfeRhRWR8p12jSDerFyW44Kt
         bqcPDNGcgZiZ+Ztq59ROers0Euh+BaHzg9NEM2bNVINOzFzRzrTR1EuwV0x2vv8T/Acv
         6T3DcSFdTHFRtazdR82Ad3EDA3LBkRqxAkypJ+JDChzfTydLlbCBiyIFjsfBwVjTd0tr
         89zZfW9TW9uBT8aUpUDf1Gwu46xb73pzP79LpbuIsM7QcmlmvLKSLTNKtYnhNeHS6aBQ
         uAoK+GPVVsq9JpOntI0ZyTukIh4lk56FuZZcp+GA6PTHueVpJ3hJ3oFyqZW17zRKRayD
         Khug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZHfo1kQOrHc/qt5QryKNnJO+LQYZnr1UzCOCTPTkvIc=;
        b=wzkcQQuSEjWyE5YNkfQeY33dhB1J/PMx4Xpe6ySBZ+d+EyRO4x9GiTLP+PDyoSJyAq
         wuv0LDK3Ji1E3A3sNXlIuYtVcjuT+uW3V0jS5TcUnFfeBFI8rBq66D1C7/zUqjZk4u5i
         JHobTv8Y2ol4+p3YzrVSQDvc0gDWoI2+PiME7MZDKn9jRQFEA2O8GPOX7B4IqsaQX09j
         Zyg/sOjqoNk4F6WZdiASEIFDW9/PJ+8EFGhpev93re2V7BJKhWt7t8CqSV1MT5S6n7YC
         2zxqAF/vl+u7riAZcAZ2VtgsZF+nk1KTUgBdcuICqRiRsw6ffpIiZep52azkaT756fHH
         hwMg==
X-Gm-Message-State: AFqh2kqyFl6kkLZRigq4Vw4aWk5o9GBldda/B8MZeQjwOyknni/wG5wD
        vZ8iR1mOtdzpPabO0gOw09bs9/9+20dZx0Owekr6s4nj/j7/bHhL
X-Google-Smtp-Source: AMrXdXtRfA1FSBB2m3EciD0q6wy1wXrvG/eGlsOzTQPurKq/zVTetBYBeOIEJY6LKXWmqGK1VbiJpdMR7p098fPzyD8=
X-Received: by 2002:a25:c543:0:b0:7d5:dc31:81ed with SMTP id
 v64-20020a25c543000000b007d5dc3181edmr1280884ybe.407.1674124097944; Thu, 19
 Jan 2023 02:28:17 -0800 (PST)
MIME-Version: 1.0
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul> <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
 <20230118182600.026c8421@kernel.org> <e564a0de-e149-34a0-c0ba-8f740df0ae70@redhat.com>
In-Reply-To: <e564a0de-e149-34a0-c0ba-8f740df0ae70@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Jan 2023 11:28:06 +0100
Message-ID: <CANn89iJPm30ur1_tE6TPU-QYDGqszavhtm0vLt2MyK90MYFA3A@mail.gmail.com>
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use kmem_cache_free_bulk
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, brouer@redhat.com,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jan 19, 2023 at 11:18 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 19/01/2023 03.26, Jakub Kicinski wrote:
> > On Wed, 18 Jan 2023 22:37:47 +0100 Jesper Dangaard Brouer wrote:
> >>> +           skb_mark_not_on_list(segs);
> >>
> >> The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().
> >>
> >> I don't understand why I cannot clear skb->next here?
> >
> > Some of the skbs on the list are not private?
> > IOW we should only unlink them if skb_unref().
>
> Yes, you are right.
>
> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
> returns true, meaning the SKB is ready to be free'ed (as it calls/check
> skb_unref()).


This was the case already before your changes.

skb->next/prev can not be shared by multiple users.

One skb can be put on a single list by definition.

Whoever calls kfree_skb_list(list) owns all the skbs->next|prev found
in the list

So you can mangle skb->next as you like, even if the unref() is
telling that someone
else has a reference on skb.

>
> I will send a proper fix patch shortly... after syzbot do a test on it.
>
> --Jesper
>
