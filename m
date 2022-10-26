Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D341860D851
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 02:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiJZAIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 20:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJZAIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 20:08:41 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C85C4C10
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 17:08:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j15so13216518wrq.3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 17:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vb9LsN2ztd6tfmUfrbBQyWrxYjb6d/m6sJvevuQZp8Q=;
        b=WopKAH0MDXjBAZBPwBzsvwfKmareSqX6w2ooB0jVAzptWd665XgcY/H3DFId1VkAjl
         hLBs3N71VjtgwV5pput0/IKSD7FjsByeTdzjjBEbTIEcSt1gwKqPbc3Pkp/EtpxsO81t
         nJTv+q/xqmUi4kQ3nsK5FZl1W+cZW9v1rbIYatWjK3R7zavKWgPQJlouFBYyGwljDOCd
         3KXK6yTmxn/awV9mBV43b8lTf50kafoW98o0Yfjs8pTQ1ULjQOue/tcyDz5/6gbsteVz
         46GZX8VShCIwm7qG85MgJ3PAw2HFD5eRaPeacGuOH41THKG8gqVSK//42BlukdQQ4VJ/
         cdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vb9LsN2ztd6tfmUfrbBQyWrxYjb6d/m6sJvevuQZp8Q=;
        b=nd94SJSiKt0qaF6FND45uFnd/+ec3H0nI2NX87epzCEc0sDbQ0VDirvln5S3Mlfq4N
         RTfCMpR3p6VqpYP872oUogfjMSENVCBjY/lTqRWtwnlkKGY1Jl11nIzSC49pRON+5iVk
         BdZRY/CTiPudvtMcIfXrBm5AKUfhJYqgZQN7FdUb0TwynNWlMqSPZn+GBvXh7V8RdfpH
         7ZM26R+8SLk/MOEw5ox7MIL0yWBpE+s/cFgzaKvsqnD9971UnAMbEjZaNG1ognHOcBV7
         c65lkudBpbFnRgcOc3vC8t2yreujuNQffVNCHaa98cjCN3UzKMeJWVtsQmrJR0VBno6+
         mQow==
X-Gm-Message-State: ACrzQf0X3NyfgLz8zMgkuYLN+NcBP6eZb2Ex3g6XFufIRmNhUtdebcDl
        idh3tA/luyw9j5QXs9PKL6HYLMJn1yyv3AySTKuLTX5s
X-Google-Smtp-Source: AMsMyM6g2SxX2Zvl/paIzfQQrwDy6oztdtTpbw6Xtn8JYoEMdyKOeO1gIlV6Djq2T7Yb6m5jrsiEYst7GDmZ3URIK5k=
X-Received: by 2002:a05:6000:3cf:b0:231:6ed6:e978 with SMTP id
 b15-20020a05600003cf00b002316ed6e978mr26378415wrg.500.1666742918776; Tue, 25
 Oct 2022 17:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221024213828.320219-1-nnac123@linux.ibm.com>
 <20221025114148.1bcf194b@kernel.org> <b4492820-a2d5-7f86-75e4-cb344e050a8f@linux.ibm.com>
 <20221025151031.67f06127@kernel.org>
In-Reply-To: <20221025151031.67f06127@kernel.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 25 Oct 2022 17:08:26 -0700
Message-ID: <CAA93jw5reJmaOvt9vw15C1fo1AN7q5jVKzUocbAoNDC-cpi=KQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/1] ibmveth: Implement BQL
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Child <nnac123@linux.ibm.com>, netdev@vger.kernel.org,
        nick.child@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 3:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 25 Oct 2022 15:03:03 -0500 Nick Child wrote:
> > Th qdisc is default pfifo_fast.
>
> You need a more advanced qdisc to seen an effect. Try fq.
> BQL tries to keep the NIC queue (fifo) as short as possible
> to hold packets in the qdisc. But if the qdisc is also just
> a fifo there's no practical difference.
>
> I have no practical experience with BQL on virtualized NICs
> tho, so unsure what gains you should expect to see..

fq_codel would be a better choice of underlying qdisc for a test, and
in this environment you'd need to pound the interface flat with hundreds
of flows, preferably in both directions.

My questions are:

If the ring buffers never fill, why do you need to allocate so many
buffers in the first place?
If bql never engages, what's the bottleneck elsewhere? XMIT_MORE?

Now the only tool for monitoring bql I know of is bqlmon.

--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
