Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A136BD6A4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCPRDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCPRDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:03:34 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36179E7EC7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:03:10 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id h19so2493604qtn.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678986183;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAod1DMG+zVz3yh8TeSFuiqJSt/MFn84bd9f0Eo7v6A=;
        b=kSvsfqjKQugtMPSVFY9jx+UpEjL5ZY36Zep8gWMo7SjBv3p9jDKNJlDLbqWR/ZLbUy
         Jn0Zft3dMEmbrcmVGWCMnez2iHbWzJWbvKfnwsGlAhvyaCFg219ueofXkG3CPbQgT+Hr
         xWOO5fpn7tqFsHBsoKI6C7CYQtydDFIy7cxYlXHO8UsbGMX98ol6JQP9tEA++RHXMY9/
         Ch5xJOB68uPA4LWTKFQvt3a2G/QRo40JD1q392XuX35O2gTQnlbUEospZavK0HDIIDpm
         2csDPJ09VOKDceXU8dDuqa4cqFYoPIH7kWbsaKMhGuz4lNc2B3W0x4bTDavjn4I9EBrq
         lq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678986183;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uAod1DMG+zVz3yh8TeSFuiqJSt/MFn84bd9f0Eo7v6A=;
        b=fn+aksn6pBKyfxQYJt2qWaazM6dK93Pg6HYnK7TptgfffqgHWBVvyHF+vimvTURHvT
         t/xSjqS0XawGjf180SDzgJdAe8rMrO+cUGRvvJEszNCGmtC0HeuSEUw/fynHoI0sK4uy
         VndAR5EprjFH3zgGNPbLydTiekkhDPh1zfOmsQjhrN5rv3imL2bwvYB3wj+KQf9hpAYb
         iQK8ZrbVQutzg4VbjiZHB9aH5Cn4xpo5jb5Bpiuo82RdKSkb5BXLsa1As9sZDCuabDDe
         RLLpaeYH4StAr6a3UeLzuiKwdeZtn+t/cdjA7NLzSv18P5DQMFEG2ga+L8K7VvT6bWHz
         WrvA==
X-Gm-Message-State: AO0yUKXZb15m2FV5hkFSpKF+ScucUwTmpC2w8MbGadnVKbgofC+WqIgi
        aTrxLWLuNAzsrClK1rKuT0g=
X-Google-Smtp-Source: AK7set+GBcoaiNoE7zGEI4mQUd+gugSHFzNFz1mfst97yBqBJO8nzOPFshz4n8iyZSUTdCRpongALQ==
X-Received: by 2002:ac8:5d93:0:b0:3bf:c0fb:53a2 with SMTP id d19-20020ac85d93000000b003bfc0fb53a2mr7802670qtx.48.1678986183178;
        Thu, 16 Mar 2023 10:03:03 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id j11-20020ac874cb000000b003b0766cd169sm1208qtr.2.2023.03.16.10.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 10:03:02 -0700 (PDT)
Date:   Thu, 16 Mar 2023 13:02:47 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>, eric.dumazet@gmail.com
Message-ID: <64134bb72b142_337f512085f@willemb.c.googlers.com.notmuch>
In-Reply-To: <CANn89iLWoJEp+GsBvHqDDB8sogpq78Rkare8c+msNqjwG1EWrA@mail.gmail.com>
References: <20230316011014.992179-1-edumazet@google.com>
 <20230316011014.992179-2-edumazet@google.com>
 <641333d07c6b0_3333c72088e@willemb.c.googlers.com.notmuch>
 <CANn89iLWoJEp+GsBvHqDDB8sogpq78Rkare8c+msNqjwG1EWrA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/9] net/packet: annotate accesses to po->xmit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Eric Dumazet wrote:
> On Thu, Mar 16, 2023 at 8:20=E2=80=AFAM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> =

> > We could avoid the indirect function call with a branch on
> > packet_use_direct_xmit() and just store a bit?
> >
> =

> =

> Sure, I can add this in a separate patch, unless you want to implement
> this idea.

Either way. Great if you want to send it after this series is merged.=
