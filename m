Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F1A501299
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbiDNOZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348222AbiDNOCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 10:02:38 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DCBF04;
        Thu, 14 Apr 2022 07:00:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u15so10178889ejf.11;
        Thu, 14 Apr 2022 07:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uYldqlfvDnUO//XnpL4/gJepKZlc0bM1hOqCfUDNXHQ=;
        b=hskXrMh1N9NmYRDTvxW0ec01jIgWA993bv1y/GsRkBmbTF28G2+VMlnMu4qN+Zwbb9
         TgaW0UQnmQR/k+m62R2GhWbDQ6yKD1gI/QMfCKcPgeJtJxIZZ8vjBapbZT7bDzkGzoQ8
         vqcWMY2+P50WGkhM1i0sjP2RYnZu/s4ibVgiVK7yxrYaBV45EnnMlwByJuRGFxRYjvKj
         7Gly2BTlU0rhrcP3xBQ4a9VLxxWPfoZsI/SwiGADF5r/AI2mQXDTY5zCJcBSVI3ZH3zl
         2ZpiAcCeo7Fg4owqDDGVZLW5xGddnlKy/m4102X/WcNfMzgNax8V8VtLCYwDEmF4gA7A
         PZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uYldqlfvDnUO//XnpL4/gJepKZlc0bM1hOqCfUDNXHQ=;
        b=TVt8CcXK1Q3ueATtP0Hee+6+5z/sJNz/vctL443DZPGJ/ZJC6oeQlQNBpSTv4+EVr0
         RjurO0IRJg7RXSKCVNCQDrzlysCgs95n0PV0uvFlr2YPieJKy0tGFYtVfEdgGx8A2zkL
         WhA7dG+IDEjjTl6JNbb92/A1zyL8YBPU2y6lw5H2aAsP5rqKKckiJ6at2nD23xbbermh
         EbNiqfLj6A8FTDM4miHemb9xf9b5XXCw+APu8jGhnq8vwOt+4IJ34MJlfKMQySRwEPnf
         +MCgsLG/ryHRiMVWMtfCzHGm3K+zvEIxvlHGKiPU7EJR0OkzhpSgWim/vBHpsDYE+6xv
         hn9w==
X-Gm-Message-State: AOAM530HwOwXZm6IAFmP3Wgnjd1RCL1K5Gj5QBOd8O9uyxfXYV1SdxGu
        QVQjWXdI64PldV7HC8KZN332frmPs1EJ0vvMBbiippn//HE=
X-Google-Smtp-Source: ABdhPJyOygFKO+afsVUqX3DdPz4sed3ITgkgQl1oxS4o0XSnUaTgC1kuQTMo1AuwJCyAua90KZGknDI/5amZ8fSCNRY=
X-Received: by 2002:a17:907:a423:b0:6e8:8ffd:6e5e with SMTP id
 sg35-20020a170907a42300b006e88ffd6e5emr2382624ejc.708.1649944808390; Thu, 14
 Apr 2022 07:00:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220409120901.267526-1-dzm91@hust.edu.cn> <CAHp75Vc4hGOJ8gr9R5WqgZ1QkC-uEeQ7WXAqO0YjynDx9jOvnw@mail.gmail.com>
In-Reply-To: <CAHp75Vc4hGOJ8gr9R5WqgZ1QkC-uEeQ7WXAqO0YjynDx9jOvnw@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 14 Apr 2022 21:59:41 +0800
Message-ID: <CAD-N9QU2A58QKs9JkYmbH2hdLZOU6Qeqk1WG0Ftv1i9nYjq0tw@mail.gmail.com>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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

On Mon, Apr 11, 2022 at 10:55 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Sun, Apr 10, 2022 at 5:14 AM Dongliang Mu <dzm91@hust.edu.cn> wrote:
> >
> > From: Dongliang Mu <mudongliangabcd@gmail.com>
> >
> > cdc_ncm_bind calls cdc_ncm_bind_common and sets dev->data[0]
> > with ctx. However, in the unbind function - cdc_ncm_unbind,
> > it calls cdc_ncm_free and frees ctx, leaving dev->data[0] as
> > a dangling pointer. The following ioctl operation will trigger
> > the UAF in the function cdc_ncm_set_dgram_size.
>
> First of all, please use the standard form of referring to the func()
> as in this sentence.

OK, no problem.

>
> > Fix this by setting dev->data[0] as zero.
> >
> > ==================================================================
> > BUG: KASAN: use-after-free in cdc_ncm_set_dgram_size+0xc91/0xde0
> > Read of size 8 at addr ffff8880755210b0 by task dhcpcd/3174
> >
>
> Please, avoid SO noisy commit messages. Find the core part of the
> traceback(s) which should be rarely more than 5-10 lines.

Sure. I will revise them in the v2 patch.

>
> ...
>
> The code seems fine.
>
> --
> With Best Regards,
> Andy Shevchenko
