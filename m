Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A574E74E6
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353403AbiCYOQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351680AbiCYOQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:16:24 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EEA81653
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:14:50 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id bp39so6584154qtb.6
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UgekVcnW1dqA2O83s5S/1crkpin0sYfZJhdrMknCsfc=;
        b=CRQ45YDEJBi4eABreUDPxeC8FyUr13BbiwkWO5mOA9Fez5hf+yFGOEKK5IcgzR77fz
         OGiF9L3yOG5lx4aHQ7z8L0lzfwTrdkHW2nHXZk6TAZ/9K0HtGmh3nBQ5CLEhhU6VcVzl
         rLfUvg+m4RSJKGaRuH0CeALdc1G45jrb8HvxNeNF6eHZH564fZQ3Ai8u1pYsEuJ1vf7k
         NuTvQ0OfSxhDysCp5EH1jpe5X9+j6x3IOgmTTFToMMErxI2CrlVzqs6LvDLwTcRK7dxQ
         rI612QU87LAvT0Y+e/7f7sbDtK/g1gsFwxnCoMKgwtws4n9MaSgaO+jFYIkncuehKxbQ
         b/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UgekVcnW1dqA2O83s5S/1crkpin0sYfZJhdrMknCsfc=;
        b=wj9nCui+aQbmsjOyLoxem9xeGYQq/ert3upiqKHnz6EP6LPFUr3B4u8+rg736wZJih
         R1Vj2N85mfqkIMh0uWkv8gQz0BAbPPbGtIge/tcVXSqTWSO+hEYaILN6oZO2k+2OS0LZ
         sLnjgd0bGOOZFu/bpThAXRxlSWSqW9WpXhDvo5wbcXNyhNQKldY2jLvPq9x7SBnJwel9
         GQIDnLtK7LQBDVctIhfKQtFvA3kuyfKZFOLGi8bf0qgMEtugFzbIiq/8OX5ckXeadk3Q
         nRKAKdE76AOWXcmYgmQkunM4jB+fpPs0kY4IJaYnHlWbmd/ud8jd4lN+sLppHhY+pOP2
         4nxA==
X-Gm-Message-State: AOAM533Z9yi3dFdAKb/jseWxZrQLBy4NtXGqnT14vWpOQnglTsurCb3Z
        X1r2oTYm5gUeQB/lxUQxhnobxxKMLhw=
X-Google-Smtp-Source: ABdhPJyWKBmVUQiDr7VOmmVMaY7COaoZg8wxnLbzX5j0/Ec/rjo1N99hLd5dpIWjlsuU9GBS/NdpxQ==
X-Received: by 2002:ac8:7d83:0:b0:2e1:eca2:afb0 with SMTP id c3-20020ac87d83000000b002e1eca2afb0mr9389665qtd.521.1648217689077;
        Fri, 25 Mar 2022 07:14:49 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id s21-20020a05620a16b500b0067b1205878esm3232519qkj.7.2022.03.25.07.14.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 07:14:48 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id x20so14144453ybi.5
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:14:48 -0700 (PDT)
X-Received: by 2002:a25:adc8:0:b0:633:b79d:92ee with SMTP id
 d8-20020a25adc8000000b00633b79d92eemr10286757ybe.457.1648217688412; Fri, 25
 Mar 2022 07:14:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220324213954.3ln7kvl5utadnux6@skbuf> <CA+FuTSe9hXG1x0-8e1P8_JmckOFaCFujZbJ=-=WTJW3y1sJQNQ@mail.gmail.com>
 <20220325133722.sicgl3kr5ectveix@skbuf> <CA+FuTSeJCZ1F3b9rrLpdcp6sbok8OXBA40jSmtxbJ7cnQayr+w@mail.gmail.com>
 <20220325140558.qdxl25ggqhpztbjh@skbuf>
In-Reply-To: <20220325140558.qdxl25ggqhpztbjh@skbuf>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 25 Mar 2022 10:14:13 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdQ57O6RWj_Lenmu_Vd3NEX9xMzMYkB0C3rKMzGgcPc6A@mail.gmail.com>
Message-ID: <CA+FuTSdQ57O6RWj_Lenmu_Vd3NEX9xMzMYkB0C3rKMzGgcPc6A@mail.gmail.com>
Subject: Re: Broken SOF_TIMESTAMPING_OPT_ID in linux-4.19.y and earlier stable branches
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
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

On Fri, Mar 25, 2022 at 10:07 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, Mar 25, 2022 at 09:48:41AM -0400, Willem de Bruijn wrote:
> > > Do you have any particular concerns about sending this patch to the
> > > linux-stable branches for 4.19, 4.14 and 4.9? From https://www.kernel.org/
> > > I see those are the only stable branches left.
> >
> > The second patch does not apply cleanly to 4.14.y and even the first
> > (one-liner) has a conflict on 4.9.y.
> >
> > It would be good to verify by running the expanded
> > tools/testing/selftests/net/txtimestamp.c against the patched kernels
> > first. That should serve as a good test whether the feature works on a
> > kernel, re: that previous point.
> >
> > If you want to test and send the 4.19.y patch, please go ahead. Or I
> > can do it, but it will take some time.
>
> I think I do have a setup where I can test all 3 stable kernels.
> I'll see if I can backport the SO_TIMESTAMPING fixes to them and
> validate using the kernel selftest and my app. If I'm successful,
> I'll attach the patchsets here for you to review, then send to stable if
> you're okay, would that work?

Awesome, thanks. Please don't send them as attachments to the list.
Standard text patches preferably. Off-list is fine too.
