Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE1653D764
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbiFDPAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 11:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiFDPAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 11:00:01 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0392EA13;
        Sat,  4 Jun 2022 08:00:00 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id x12so9430606pgj.7;
        Sat, 04 Jun 2022 08:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z7T9gBedk0FnMdkGXsYeXk14xh6RRT1/9ZpwTpf8w7k=;
        b=NcHzmcmtlm1wtDaGGqff7ZeWLsl10tm4yZxzjHT8cyZdaBAUWxlTQRRbyIKkZ18mAd
         a7C9q3R8xTMgg71PvM5KcjxMXEl5TsBljqEfPJLfOHKILeUmZaXS93v9Zwj7ZcwPBzw6
         bs7jWLIBAySe53iZqBYbjdAWJXv+M92zuhfJvXUIuCHpxbdGmO/7L8VNkjBpsiTBE9+i
         ulV7vd7WKFNpdcv/AaSHhmCVmefuM/8nlPe/xdGQoOaBxCU8eJstF3LoR/T2a9hZaz6+
         gW/A4su1Q6JqFUJGFbYO+9tEcGW8EKl6/JeEu7Pp51/OYi9rIFndnMXa/gmPwU+JziQV
         KY6A==
X-Gm-Message-State: AOAM5324iK8HH8ylA6VCKL0xOzNqXJxN2RwQ2KnByiNXMlyhdJ3tIDpx
        T600yI6fz+nHgf9gOUAbaw6Jt+hGksyEyRmtz0s=
X-Google-Smtp-Source: ABdhPJx7icftLDYBE7O/E6OEhKgfoo+sJumEYaitWywDxy3PqnIXpsTyomq+JXW9Dd2vnD+demIi5HaUJ53/4Po0HK4=
X-Received: by 2002:a63:8bc7:0:b0:3fc:bd28:c819 with SMTP id
 j190-20020a638bc7000000b003fcbd28c819mr12865767pge.378.1654354799921; Sat, 04
 Jun 2022 07:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
 <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com> <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de>
In-Reply-To: <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 4 Jun 2022 23:59:48 +0900
Message-ID: <CAMZ6RqJ7qvXyxNVUK-=oJnK_oq7N94WABOb3pqeYf9Fw3G6J9A@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 4 June 2022 at 22:55, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 04.06.2022 22:05:09, Vincent MAILHOL wrote:
> > On Sat. 4 juin 2022 at 20:46, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > Hello Vincent,
> > >
> > > wow! This is a great series which addresses a lot of long outstanding
> > > issues. Great work!
> >
> > Thanks.
> >
> > > As this cover letter brings so much additional information I'll ask
> > > Jakub and David if they take pull request from me, which itself have
> > > merges. This cover letter would be part of my merge. If I get the OK,
> > > can you provide this series as a tag (ideally GPG signed) that I can
> > > pull?
> >
> > Fine, but I need a bit of guidance here. To provide a tag, I need to
> > have my own git repository hosted online, right?
>
> That is one option.

This suggests that there are other options? What would be those other options?

> > Is GitHub OK or should I create one on https://git.kernel.org/?
>
> Some maintainers don't like github, let's wait what Davem and Jakub say.
> I think for git.kernel.org you need a GPG key with signatures of 3 users
> of git.kernel.org.

Personally, I would also prefer getting my own git.kernel.org account.
It has infinitely more swag than GitHub. But my religion does not
forbid me from using GitHub :)

Yours sincerely,
Vincent Mailhol
