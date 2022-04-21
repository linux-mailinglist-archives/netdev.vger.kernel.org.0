Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D4650A3A1
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389872AbiDUPH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389854AbiDUPHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:07:55 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC35F18E0F;
        Thu, 21 Apr 2022 08:05:05 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id s16so5957997oie.0;
        Thu, 21 Apr 2022 08:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xLor6/Xj3EvLocbzobxHoEoN8lu7POLOghqs8nlDmio=;
        b=kHqG+cBHBNI3DGVus1vb1Y4g3joHDFRAU2KbaMh5XSHMTFlDG1gLVzP69Alz9ftxIT
         wDgzBzEPDbtJlnXVRvylqHxAmEtQWt0Tx71H3aG2DMhdlp8kllq+K6L5yv8Gwq3cq3ey
         o8ipGibf44xeCsOkbqcv8JCI4fxTEiVWSz0zTZsrubg6YTuVquatRZJefyeG7i3Ahxze
         ewPpea2QHf64YUIfZ/Ls/TrS5TXNOEO9k+2mtYtzA3AzVN8X8CtMOVfrMY9L+MvbQw2J
         Uc8UfIeURX2TJGDoQS/kJN3to+1aFJpCNbZ0XMM7Zy5zNO4XgeSoq/0c+Uueh6AHyStI
         KmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xLor6/Xj3EvLocbzobxHoEoN8lu7POLOghqs8nlDmio=;
        b=HoLS8wU1fEnvc2tMzUU+/eNX0Qy8l5YW68YSn6mcJPmSpX0jrTsxxNLBgysTBgDgdd
         zsmWXoLiXd7lmA+lJNIdQaYCuPx1GAEjLeEhWZCiDedXSdloIrWQ09+Pyhc7g7ssXuhG
         9qhAnJLRkGCUbJ825tgvFkuP4bn4e8SZ+PkCt5NWCpcu9cQioSsIUyLBxLxMhCrvP8xL
         rjWQgk2R5o9+g0mWQNQ+oUY6+dwAibdQTSIky8j1Cp23StV89J4QAEvp73HNPm1nutCR
         V+HGQGEZ+8ogu99W+13C3mXB5oxrfHYzaCdlkOd/8E504w8AdAv7hUWB8yfu5eSM/zS+
         oxBA==
X-Gm-Message-State: AOAM533lu3Np46Opqgq1f+bULxidFEYNK5CjoPEjEHiTpaMN0EvyskpX
        PhKE/oTyexnt7/ikIZ8wD/TlRvJ3T6x5aPLsH5Y=
X-Google-Smtp-Source: ABdhPJxHwWK91/XvkJro4FEJXDwXJ6yssCSShTkoNymF8jT/xa4P5N6b84T3cgscvMGPJjNUscf/CQfCnjEdC6ZE+tQ=
X-Received: by 2002:aca:5941:0:b0:2f7:5c90:ad61 with SMTP id
 n62-20020aca5941000000b002f75c90ad61mr4372128oib.190.1650553505289; Thu, 21
 Apr 2022 08:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
 <20220421.111807.1804226251338066304.davem@davemloft.net>
In-Reply-To: <20220421.111807.1804226251338066304.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 21 Apr 2022 11:04:42 -0400
Message-ID: <CADvbK_f+kga=QxOmCQmUFX6TxEaZabOj=R+b+ifJ_ugfLMfdWw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: check asoc strreset_chunk in sctp_generate_reconf_event
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
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

On Thu, Apr 21, 2022 at 6:18 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Wed, 20 Apr 2022 16:52:41 -0400
>
> > diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> > index b3815b568e8e..463c4a58d2c3 100644
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -458,6 +458,10 @@ void sctp_generate_reconf_event(struct timer_list *t)
> >               goto out_unlock;
> >       }
> >
> > +     /* This happens when the response arrives after the timer is triggered. */
> > +     if (!asoc->strreset_chunk)
> > +             goto out_unlock;
> > +
> This will return 0 because that is error's value right there, intentional?
intentional, this won't be treated as an error.
