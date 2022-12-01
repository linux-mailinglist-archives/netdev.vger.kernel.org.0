Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B86663EE7A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLAKzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLAKzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:55:17 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9476307
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:55:14 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bj12so3198805ejb.13
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 02:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aKIzDjXBvdbdKIk4IVSzVJ0/6F9SR8eFepx3TDoXJgM=;
        b=GR1VfgeXQBPw5yeX8WVt7AkOP4vEHhtEv2noELsBX8Gpex6DukJoXydwoi4awxxYEg
         /DdePfKIGQ0+w0dWiWEZXmDhjQNDjL4ULlGqCdwKgdCYnMMDQh0TmI1ZU+K2/EjDK5AK
         sHzpOEN8zlGEVWKrN4TlgQWmvKvviXL16pYhihwjaguyKiSRGvigEeOx0kXA4z7LNP9Q
         wdENEbszGYi1pjIhrilAPt6htyroaFW1JtgmDy6XTomFfbmzzm72Vj3dJak2BLb15WsB
         lRPISqpg5w5fc2vZCfZF9kTQMEAXn/8KkEQXYyS98t8mvpvtl+1sSV27x+uBdVNKZAYq
         mRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aKIzDjXBvdbdKIk4IVSzVJ0/6F9SR8eFepx3TDoXJgM=;
        b=Cni5pC0sjtNnow5mFUh9OXi6v3TkAy3Gk+Mx6ulxR1D9kEAPeHLQzNv9h7QNDSVA/3
         UaY60YHP4Kon4s6eeNyU6sdFlNwWRzbOCCqQcRRJ3K+QkzJFRnVqvMMJE2v1sVUHq//z
         Br6jJ9KksChG/PDEw2g3fdAPzItqvGqY3uoTFuj6PLyrHk86a2O/sOWXthGSvfSvUQey
         j/UttOF1nROrnXzfe46u7izVCN84pgP1jxS8kOfDW4ZjaANOZssthbFu+CNKIvT3I6p4
         CeJ1wSD1Sw8tyUIitcbFPtFRkxuQ2tikhr529TK+NNQ9G1gS5+V3OJ+SKqhw979VijIe
         yb7w==
X-Gm-Message-State: ANoB5pk68425qUa7o3UpuWsSeYgc5MbuyfIOUlaUK3/FQjEx9HIu9X8o
        NdlJezz65fK50fGX18zVmCj5MgpOXEf3YKhBAnA=
X-Google-Smtp-Source: AA0mqf5qqUp6boyU5LZatOjwhCLRIDurRplsXpqsxJPzzx/+q3qodUh2YGmuYBNBwGYyYzhvbIBoVSL9GmZk6fsLBWo=
X-Received: by 2002:a17:906:2998:b0:78d:3ff8:6ec8 with SMTP id
 x24-20020a170906299800b0078d3ff86ec8mr39554030eje.568.1669892110981; Thu, 01
 Dec 2022 02:55:10 -0800 (PST)
MIME-Version: 1.0
References: <20221130124616.1500643-1-dnlplm@gmail.com> <CAA93jw58hiRprhvCiek+YSOSb_y2QsQVWQMzrPARgGJGj9gEew@mail.gmail.com>
In-Reply-To: <CAA93jw58hiRprhvCiek+YSOSb_y2QsQVWQMzrPARgGJGj9gEew@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Thu, 1 Dec 2022 11:48:32 +0100
Message-ID: <CAGRyCJGAMGxW04_XQjrUforZ6G7Y4gcR=CvkzZDiP0vqHnB-pg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] add tx packets aggregation to ethtool and rmnet
To:     Dave Taht <dave.taht@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave,

Il giorno mer 30 nov 2022 alle ore 16:04 Dave Taht
<dave.taht@gmail.com> ha scritto:
>
> On Wed, Nov 30, 2022 at 5:15 AM Daniele Palmas <dnlplm@gmail.com> wrote:
> >
> > Hello maintainers and all,
> >
> > this patchset implements tx qmap packets aggregation in rmnet and generic
> > ethtool support for that.
> >
> > Some low-cat Thread-x based modems are not capable of properly reaching the maximum
> > allowed throughput both in tx and rx during a bidirectional test if tx packets
> > aggregation is not enabled.
> >
> > I verified this problem with rmnet + qmi_wwan by using a MDM9207 Cat. 4 based modem
> > (50Mbps/150Mbps max throughput). What is actually happening is pictured at
> > https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/view
>
> Thank you for documenting which device this is. Is it still handing in
> 150ms of bufferbloat in good conditions,
> and 25 seconds or so in bad?
>

New Flent test results available at
https://drive.google.com/drive/folders/1-rpeuM2Dg9rVdYCP0M84K4Ook5kcZTWc?usp=share_link

From what I can understand, it seems to me a bit better, but not
completely sure how much is directly related to the changes of v2.

Regards,
Daniele
