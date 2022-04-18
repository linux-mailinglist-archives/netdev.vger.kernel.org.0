Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9D504B27
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 05:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbiDRDHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 23:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbiDRDHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 23:07:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8D4B12;
        Sun, 17 Apr 2022 20:04:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id md4so11933986pjb.4;
        Sun, 17 Apr 2022 20:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MxqIUjNDmotUpRJvqMX8HiRsI8PcgO9pEtW2E7+We90=;
        b=YqY1IpEAJtY+3nSKPKovbX5ZPmB16lHTBhps7tBI5vu7uRBP7DyQW0OBOeRSOJDOn+
         0ctKzKpzcQrGT0CvL014ak+s7bBvi4a2CsEfzfNgxKQx0KwryTGuqW41B6qcXdLyLHuX
         L5yWrUrNqmcI9tLvM4o+DuVY9kg8G7EEVaXrmowaWOrnXobd6koUunt8Nou+iInsahHq
         +yNKAO51p7Ti1HP7o7NWUMDr73mB66aY5o+XSnhSodHYN+Kn62U4J0dWnueB3nWQ4AWw
         l08EQ3IhEbMApmH00CrWqw9kNQ30sQPGlKBScnJGBrsCeoLzoqod0z+qv2PHcynSm0Oj
         GidQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MxqIUjNDmotUpRJvqMX8HiRsI8PcgO9pEtW2E7+We90=;
        b=lfPOgAEoZt9V2y+eD++O5AR6HeuAQV5QvvBwY7b7ibO5UyGKbh5EY7STl1s/baqAAg
         gKnfRvRluHjPqG4UUWwa9135bQQsRswPZVuB8xEQkbylIli5pV6q/codPbEanns8AC4k
         /tmf3kY/GL3ifYuAIR3Z5Jr/SSDoLgq7sPq3atNYIcSPTdRAVoP/Yn4PJ4xG+/KUkevb
         68euZGLOyuWR8f2fEYknQX6eX5So8ZbysM1sA4Ia/m/3z0Q4X86Qld8oJQpgQouoEqqz
         LJtUjipSVNf5rAkxzQiwp+9lR39qKghGKg2YN5U7d5EhO5NP/5KzqVQNBK8KlVZdgiOG
         I8Qg==
X-Gm-Message-State: AOAM531M+mB+VbxwnbGH4JNDViNFYmr2UyePFEHXAo2ZgTdT39LtQ1Xy
        YDjb+IXIKgs5M4UVB4l6mUQxrFF1LfN0P8XRus11l2wOyLkCRQw=
X-Google-Smtp-Source: ABdhPJzLwuwIwIsKQeNrnOR1eH70BULF3eMjhhDGorPZ/67ziabUCa8Bt5AjvyU66TFxRjL2ouuiqWiDVlNuMvGSADM=
X-Received: by 2002:a17:902:b18d:b0:158:9e97:deee with SMTP id
 s13-20020a170902b18d00b001589e97deeemr9006742plr.31.1650251093000; Sun, 17
 Apr 2022 20:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220409062449.3752252-1-zheyuma97@gmail.com> <CA++WF2Np7Bk_qT68Uc3mrC38mN5p3fm9eVT7VA8NoX6=es2r2w@mail.gmail.com>
In-Reply-To: <CA++WF2Np7Bk_qT68Uc3mrC38mN5p3fm9eVT7VA8NoX6=es2r2w@mail.gmail.com>
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Mon, 18 Apr 2022 11:04:41 +0800
Message-ID: <CAMhUBjkWcg4+YYynsd90jX1A+zp95tUUcLgYrTPAqSmbxM7TJA@mail.gmail.com>
Subject: Re: [PATCH] wireless: ipw2x00: Refine the error handling of ipw2100_pci_init_one()
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc:     kvalo@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 2:40 AM Stanislav Yakovlev
<stas.yakovlev@gmail.com> wrote:
>
> On Sat, 9 Apr 2022 at 02:25, Zheyu Ma <zheyuma97@gmail.com> wrote:
> >
> > The driver should release resources in reverse order, i.e., the
> > resources requested first should be released last, and the driver
> > should adjust the order of error handling code by this rule.
> >
> > Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> > ---
> >  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 34 +++++++++-----------
> >  1 file changed, 16 insertions(+), 18 deletions(-)
> >
> [Skipped]
>
> > @@ -6306,9 +6303,13 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
> >  out:
> >         return err;
> >
> > -      fail_unlock:
> > +fail_unlock:
> >         mutex_unlock(&priv->action_mutex);
> > -      fail:
> > +fail:
> > +       pci_release_regions(pci_dev);
> > +fail_disable:
> > +       pci_disable_device(pci_dev);
> We can't move these functions before the following block.
>
> > +fail_dev:
> >         if (dev) {
> >                 if (registered >= 2)
> >                         unregister_netdev(dev);
> This block continues with a function call to ipw2100_hw_stop_adapter
> which assumes that device is still accessible via pci bus.

Thanks for your reminder, but the existing error handling does need to
be revised, I got the following warning when the probing fails at
pci_resource_flags():

[   20.712160] WARNING: CPU: 1 PID: 462 at lib/iomap.c:44 pci_iounmap+0x40/0x50
[   20.716583] RIP: 0010:pci_iounmap+0x40/0x50
[   20.726342]  <TASK>
[   20.726550]  ipw2100_pci_init_one+0x101/0x1ee0 [ipw2100]

Since I am not familiar with the ipw2100, could someone give me some
advice to fix this.

Thanks,
Zheyu Ma
