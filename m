Return-Path: <netdev+bounces-4424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B02A70CABA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAF172810D9
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE8C174C3;
	Mon, 22 May 2023 20:18:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34395171D4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:18:19 +0000 (UTC)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41011705;
	Mon, 22 May 2023 13:17:59 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-56204ac465fso66064207b3.2;
        Mon, 22 May 2023 13:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684786678; x=1687378678;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4xh0i0HIFJ7RLsNn/gZPXgFeIIlqcue46B/GetkxR9o=;
        b=l/YX5F2NoOHFWkOPcuXjD7vyDDcRI+h3lD/NBPsHY/Nm8Qu3CvZ4z2A1JUClmd7q6k
         i1rNg+jBfhBP8INQp6vb0LWt+R32n1XJhvKz9RWI2HZllhlpe3QUHIZMGXAq8VzLQxWB
         tRHO9cC/mS4EdkFu3E2f7Ea1Ed1YfxWUt3DziHJLX3AdEi1q1eECJ6V0MIoAbga8enlp
         xzu4lmerjA8cUaa+u1Ry5jKs01GWHcS+S8w426iway4QqFjutlvJQyOwYKZ7LGbReIWn
         ROiURBqRf3WY7PoisSqY8UZEoD1a/t2m6ZX3fXIxvpVxJzcau3CadUpWImi0OTrGHRmx
         /i9g==
X-Gm-Message-State: AC+VfDzBXhJN2hbrjB5ioryVUrbW5Ow8U2bQ46TBbbCYmHmlnIj54ylh
	I5ChaKOnYKT1Ky0uwPcbXqyakTiupd3iHg==
X-Google-Smtp-Source: ACHHUZ6UrRiCZbXpdYppyVEKXWAnak6dNKzSBA6iu4jVoqBLel/pYUrRU1fpOgjhrKINCP298gX50g==
X-Received: by 2002:a81:4995:0:b0:561:6d72:f85b with SMTP id w143-20020a814995000000b005616d72f85bmr12677034ywa.40.1684786678638;
        Mon, 22 May 2023 13:17:58 -0700 (PDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id a133-20020a0dd88b000000b0055a1cd96212sm2320429ywe.33.2023.05.22.13.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 13:17:57 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-561a33b6d63so86099477b3.1;
        Mon, 22 May 2023 13:17:57 -0700 (PDT)
X-Received: by 2002:a81:834d:0:b0:561:b595:100e with SMTP id
 t74-20020a81834d000000b00561b595100emr11473012ywf.37.1684786677251; Mon, 22
 May 2023 13:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517113351.308771-2-aleksandr.mikhalitsyn@canonical.com>
 <202305202107.BQoPnLYP-lkp@intel.com> <20230522-sammeln-neumond-e9a8d196056b@brauner>
 <ZGtr1RwK42We5ACI@corigine.com> <20230522131252.4f9959d3@kernel.org>
In-Reply-To: <20230522131252.4f9959d3@kernel.org>
From: Luca Boccassi <bluca@debian.org>
Date: Mon, 22 May 2023 21:17:46 +0100
X-Gmail-Original-Message-ID: <CAMw=ZnQ-diFqFUCEpqBTDTNojfvqaGCtZSvh8+rE_z-KBNreqw@mail.gmail.com>
Message-ID: <CAMw=ZnQ-diFqFUCEpqBTDTNojfvqaGCtZSvh8+rE_z-KBNreqw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
To: Jakub Kicinski <kuba@kernel.org>
Cc: Simon Horman <simon.horman@corigine.com>, Christian Brauner <brauner@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>, davem@davemloft.net, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 22 May 2023 at 21:13, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 22 May 2023 15:19:17 +0200 Simon Horman wrote:
> > > TLI, that AF_UNIX can be a kernel module...
> > > I'm really not excited in exposing pidfd_prepare() to non-core kernel
> > > code. Would it be possible to please simply refuse SO_PEERPIDFD and
> > > SCM_PIDFD if AF_UNIX is compiled as a module? I feel that this must be
> > > super rare because it risks breaking even simplistic userspace.
> >
> > It occurs to me that it may be simpler to not allow AF_UNIX to be a module.
> > But perhaps that breaks something for someone...
>
> Both of the two options (disable the feature with unix=m, make unix
> bool) could lead to breakage, I reckon at least the latter makes
> the breakage more obvious? So not allowing AF_UNIX as a module
> gets my vote as well.
>
> A mechanism of exporting symbols for core/internal use only would
> find a lot of use in networking :(

We are eagerly waiting for this UAPI to be merged so that we can use
it in userspace (systemd/dbus/dbus-broker/polkitd), so I would much
rather if such impactful changes could be delayed until after, as
there is bound to be somebody complaining about such a change, and
making this dependent on that will likely jeopardize landing this
series.
v6 adds fixed this so that's disabled if AF_UNIX is not built-in via
'IS_BUILTIN', and that seems like a perfect starting point to me, if
AF_UNIX can be made non-optional or non-module it can be refactored
easily later.

Kind regards,
Luca Boccassi

