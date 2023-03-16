Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA326BD412
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjCPPkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjCPPkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:40:35 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB36CADC2D
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:39:46 -0700 (PDT)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 959FC445A2
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 15:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678980735;
        bh=KVIq8frzkYdGyawUi6qd1wFCqEV16Aek+JcarG9lTBU=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=bIX9+sPflBZiDQIew8yVZ4MRz1NTfyjYe2cWoQ5Sr1vsmHuR1j3e2xEm8MkmM4v+8
         hfmzrVtXZfWoBCDLQPnXPFzTwTrp3Vn/gN0eI1JDTzkA9xXeE4r5s9mfo1ZsoSque5
         ci+59G9KLEy0KnfoPwX/W7uDHFIeqwjCLyn0OKX4ZJswVZRNJY+hPYYo4qJuODFLoq
         +syIl/5UrLVxrWxj9kEOLlD9xSHFYlsNert1Wof6pFsuYCpcXz36rm1g7owNjcmLii
         eoKHtfZ6oNoFtwIv+kZfYbXGmQsH9RpoPksgO+a2HuC1UmQQbeLuLWSRwuUZ7HupaI
         Nv/m6erMETq2A==
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-544539a729cso19004677b3.5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVIq8frzkYdGyawUi6qd1wFCqEV16Aek+JcarG9lTBU=;
        b=C7nIqXcjvoWN24QIGpHkfT42y5AxgrKBDQP7guJHtral1nEBtHUpwSCV98978AjRNs
         TLUgCiAF9TW2H63xfKpHESaPFxjBqwZeCtp4Kmaoey57beELdCPGxsX5wYt3plJvMGwk
         nRzsVNJ+B4dx183QBckQT8zEsgxTzTaI6zzkZHeVKD+3nrsR3mFqWL++RDYVELnAzDFF
         SPPuWWYRaAmmGkylkBCLr7/pgZptSs9N2k3XUTyY8Nfmm4x+BT0Dis9rAVslasUFp2I4
         JtVfw+cQIvQZi7LVQAUGrcdpGUDebl/BFHckV0+geEQbFuWypd4oO1Z7IJM1cmKDrHds
         XvCg==
X-Gm-Message-State: AO0yUKUu60GJK833TZHthLnV+8USTqP3nRTjIrIzX/Agq6KT2hXSVmwe
        AKqZNAvNNlsEeLTe3GC7S+DbMxRQVS21W2IN5/GhQuN2lM2gC1OnTewK9hzi+KexmZ87mbS7YSS
        icODJ/9Kp7eUuQLJFgKx1fXcBBQSMpLxR37lg2E0bYfSdjKKsLw==
X-Received: by 2002:a05:6902:188c:b0:b50:77a7:ccb with SMTP id cj12-20020a056902188c00b00b5077a70ccbmr4389522ybb.2.1678980734584;
        Thu, 16 Mar 2023 08:32:14 -0700 (PDT)
X-Google-Smtp-Source: AK7set/T8hptIk8bQ8iXc1WeL/l0iwLZJ0ztNydSEqdYIoVsP9byAaK3AKcDXGJ+LkqNOm3NZiCKiaxqYDoVsZPZnJ8=
X-Received: by 2002:a05:6902:188c:b0:b50:77a7:ccb with SMTP id
 cj12-20020a056902188c00b00b5077a70ccbmr4389505ybb.2.1678980734376; Thu, 16
 Mar 2023 08:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
 <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com> <CANn89i+s7TG4jqC1qanboKff=-DRmDjB-vEkoLKbEDwv195ytg@mail.gmail.com>
In-Reply-To: <CANn89i+s7TG4jqC1qanboKff=-DRmDjB-vEkoLKbEDwv195ytg@mail.gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 16 Mar 2023 16:32:03 +0100
Message-ID: <CAEivzxeXx51+R=Pws_ZDyidrNOLcyi=xfS7KR8oRebRR9H6=3g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 3:34=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Thu, Mar 16, 2023 at 6:16=E2=80=AFAM Alexander Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTI=
ALS,
> > but it contains pidfd instead of plain pid, which allows programmers no=
t
> > to care about PID reuse problem.
>
> Hi Alexander

Hi Eric

Thanks for the fast reply! ;-)

>
> This would add yet another conditional in af_unix fast path.
>
> It seems that we already can use pidfd_open() (since linux-5.3), and
> pass the resulting fd in af_unix SCM_RIGHTS message ?

Yes, it's possible, but it means that from the receiver side we need
to trust the sent pidfd (in SCM_RIGHTS),
or always use combination of SCM_RIGHTS+SCM_CREDENTIALS, then we can
extract pidfd from SCM_RIGHTS,
then acquire plain pid from pidfd and after compare it with the pid
from SCM_CREDENTIALS.

>
> If you think this is not suitable, it should at least be mentioned in
> the changelog.

Kind regards,
Alex

>
> Thanks.
