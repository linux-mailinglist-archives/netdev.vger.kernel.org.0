Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6167257420F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiGNDzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNDzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:55:31 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B088B27140;
        Wed, 13 Jul 2022 20:55:30 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id d4so329285ilc.8;
        Wed, 13 Jul 2022 20:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNyP+5NLoIYdbnOPNtBQI41XzXYGbPB6hlgDygq+CQo=;
        b=iBIU8/Hi3FVeFXM4r+X+Iiek+ikFrHQ3n1wyem5Te+kit8fC1JlOldH0IflUOxt2H1
         AVqU/ZWslS5EyQNy1d6bM2H0+lYCvNr6W8y440Z5tNkyOGlpa7KL0PxargtwnS40smar
         EYHPmWw1N0PX0BI6LvHWfXhmIkPlPWI3wyP3FJfY6irBaq8oGUCjetoOJt6U5GGOMhjL
         QJ8odfQlCGx4INsW1GYDap+xQ5S3247BFNJZRoEzOIr2IJ6Rfgdpb5RmhxbALx2Tqt4y
         7DAFwWDvVJ3GjYLgFNoI6Pfm8y7lt4F8Gds32jdgKfRJUTZUmJVrNaSj80FfjHwMRinK
         OdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNyP+5NLoIYdbnOPNtBQI41XzXYGbPB6hlgDygq+CQo=;
        b=3XC78RSXL8+tYgmdROivI7kds4wIDzPd+VoalOcbWrIwv0WYclpQ3MpcDcGZc8KoHK
         CnGEBJKZ22wgmxK0cAXjuDJCMfpIOyijLPaVEeHbMBtJtte4OOSyt1Fk9/N+2snOSbd0
         VdVxvLmhc9ocaQdq/F+WuinDLZQnwfbKsXUTkvKgxcpcWU961FGbgO1xaXDO144rXRWS
         tvgk3EOyvIfzBCR3n+EsKohmoz03/vOCLTBwY6v2vCVxEX2ZecGdC47aJDFSiToB484J
         wLG13DrMA1JB6JuZOletaCnKyIWF1Kd0nOpzWc2Sdfc/H0+CzaMM5W9/W7ZOLwcUHNuq
         J+xw==
X-Gm-Message-State: AJIora+a6gJrbaDDm8tbFRqAKip62NyNghXtuydJ/TOw9fU/y74Ftrzo
        7lVMZQuPMxoO9oGlDP1L41xPwoGlag+oNdgGMXk=
X-Google-Smtp-Source: AGRyM1tP1Lbn5B5LY3qZmXAsZhmPaWNY9k1H11Z+iNNUJ95Sbg3GqIedQmm2sjRFIq0o7rjWv4EtJoi64FFhlcIPqzg=
X-Received: by 2002:a92:b10:0:b0:2dc:e3e:195a with SMTP id b16-20020a920b10000000b002dc0e3e195amr3656509ilf.259.1657770929958;
 Wed, 13 Jul 2022 20:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220713181324.14228-1-khalid.masum.92@gmail.com> <20220713115622.25672f01@kernel.org>
In-Reply-To: <20220713115622.25672f01@kernel.org>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Thu, 14 Jul 2022 09:55:18 +0600
Message-ID: <CAABMjtG9PDPUm9vrK-Kho7WW+V5h9MmMox1EiLuvfKfiCNp=xw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1][RESEND] Fix KASAN: slab-out-of-bounds Read in sk_psock_get
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
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

On Thu, Jul 14, 2022 at 12:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 14 Jul 2022 00:13:23 +0600 Khalid Masum wrote:
> > Using size of sk_psock as the size for kcm_psock_cache size no longer
> > reproduces the issue. There might be a better way to solve this issue
> > though so I would like to ask for feedback.
> >
> > The patch was sent to the wrong mailing list so resending it. Please
> > ignore the previous one.
>
> What happened to my other off-list feedback?
>
> I pointed you at another solution which was already being discussed -
> does it solve the issue you're fixing?

Yes, this patch solves the issue I am fixing.

thanks,
Khalid Masum
