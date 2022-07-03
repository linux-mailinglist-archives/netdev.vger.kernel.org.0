Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D910564556
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 07:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiGCF6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 01:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCF6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 01:58:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED4964FA
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 22:58:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g7so1404893pfb.10
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 22:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TwQJby18uY6+gkiZHiPrZc2fqELxMEt7o9EOL4vv9tg=;
        b=Qw3rF0TfGQixXLvfFWjoq/pKbAT9RT2r077OIYt8Ejio0sCClO8ErEwqvybpDm9i+H
         2swnA5hite1Se16ZSlfAvtJmY2V8IllLLBz0dv2hmwtAS+ABCH+pejkbWpQew1oNI3Di
         /BdTm8vkz6cBJxp/9RHDbfXAFzWismItnAoZEO6BMRozzpP7ETIdnnwxDYM9N3wV4Lbh
         ai76JGjgjmsr9nxmqDcpH2DJf9Thj6t09vA2xJ4Fk4u4LYPovtbkiNQIS8MjtIN7URE/
         tEFm6eCRaEY6YEIz5ewy3DDLUBJ5EBcrdfTqk5DbNBWQccJXpbcwx3uFLgDwJQGE6G3L
         carg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TwQJby18uY6+gkiZHiPrZc2fqELxMEt7o9EOL4vv9tg=;
        b=MOfkYf2O5W029eI0gNWllbv9T8815iEjjcD/6D3yAHgDeS7WtUTxsiEHQ2mUAIuDI2
         o0267Go9upji/F2Bm+DXjmuKNB2WszoNICsz1+se7p3RgsW4gJ+Um5Y2EnXtfuZQiPiJ
         EdjNt0QOCYDqlQq0jMGDkAui6fdtoTxbeBhQ3xyzJ22eOMRjO/KM1it5UR7ues0WV3jc
         jooJuSM6J7ktOQQG3ZU57ccvtn/DpUcYIgpDE2ZfViM/3mqHN7Drx4BTYC/7D75UC0iw
         JeGrAb88DJP7r0fYSGhbnzKL2cSpagsUdPgiLPRYI93EEe+cqr2DipMorb9hHfhcLWUi
         N5/w==
X-Gm-Message-State: AJIora/xgnY0xBsCwwg3/RVZbhVz5MNvAwi4rrwU1Mox+dgDcC+IbEWs
        JS+1CzbnlzeSDi6LhhvMMaCEgbJL5MWp1w3lLuA=
X-Google-Smtp-Source: AGRyM1te3DTmMeCNqYRbdAXFXWmw2aSri+cXd/JCB3Vqwqo/I7z6jbjHZ1o3/4/bxvW393GEjPIk5+uKSXi3H0SLPw0=
X-Received: by 2002:a63:1e49:0:b0:3fd:cf48:3694 with SMTP id
 p9-20020a631e49000000b003fdcf483694mr19861329pgm.275.1656827912994; Sat, 02
 Jul 2022 22:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
 <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
 <YroEC3NV3d1yTnqi@pop-os.localdomain> <CANn89i+X4+w91MwZNW7qsb9dK3W0s72iehh5Kkb077ApTis_Vg@mail.gmail.com>
 <CAM_iQpXF4cvuMe3yM_G2Xzab_3Q_D1oUcfchaAZE6cYNcMoe9Q@mail.gmail.com>
 <CANn89iKRU6QDfmRa=YikyGHjC=v-8RepTWHtHPMQivAqP=gt2Q@mail.gmail.com> <CAM_iQpU9f4XmvPve5ex_ya6Xqugxo3RTm1f08uquBmJz+qbKBQ@mail.gmail.com>
In-Reply-To: <CAM_iQpU9f4XmvPve5ex_ya6Xqugxo3RTm1f08uquBmJz+qbKBQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 2 Jul 2022 22:58:21 -0700
Message-ID: <CAM_iQpVQYZ8+7QLs2Z-4BbuOH7NfZkh2HbrUgHFhNkoTTeDKiQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
To:     Eric Dumazet <edumazet@google.com>
Cc:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
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

Hmm, I just noticed there is actually a hash-ptr option for trace ring
buffer:

  hash-ptr
        When set, "%p" in the event printk format displays the
        hashed pointer value instead of real address.
        This will be useful if you want to find out which hashed
        value is corresponding to the real value in trace log.

I am glad people noticed the usefulness of real addresses in tracepoint
before I did.

I will backport this to our 5.10 kernel.

Thanks.
