Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D046A3F65
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjB0KV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjB0KV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:21:28 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27709136D7
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 02:21:27 -0800 (PST)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0AC893F04C
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677493285;
        bh=zsCDCB3XtidP3kEhU8Gi1pJlYQVOTcLpAGwHtfPU994=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=YvwHehFomSdFUN58yw1ZzNtrmwPxac3sGgiemfVfwi+xG+3EgoydWluMpGRGe/pXc
         QXVCzCgpDYZ19MgpXYFEtPL2+6hN4C5P5SnwrkJQ9QdqKEuVb2Ws1b0Q5MjN1QFDoU
         A8nSvxLBfN+VkSmlvn3dLYoSVTkZ//hRerRhg9eBZethlbw4SkCpfYqmKpJEMgqqb3
         ulIXO29DrtciYNixrg0eEguYLS7i8acSKrrmW1zTsfgWRX+WHPk7uc9qvYkK4iPOw/
         bkhBzAabsmMmkjSPUdeDhEHSX18zFoq0GWkBiT7rSE+xrG9pctNyIohZcG7KXJUo0e
         41gp6Kkik+WzQ==
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-536cb268ab8so130972837b3.17
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 02:21:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zsCDCB3XtidP3kEhU8Gi1pJlYQVOTcLpAGwHtfPU994=;
        b=D2Eu2VSz1cBShfLXVCnWy4OzukgOaQ4/+Rrumt10zPAVLYos0I+4meE8ARKSWTVRfr
         DTN8Fgp9etfpxMqCsW6d1RwM1djQVesuFMwXLlLtU7owa2sYlbwE6EThRw2pkVs4O9u0
         Jq4E+SoT/cDjIObs+E00P7bONFuNs4Y6h/8VL+nlzACxb/Ph9pYPQPtzoUTeu6dZLLbB
         H4rinL92x+LkOjxt1igPUz17d48Q5YAMApdB0Okb8LHo0NoaSDYfJwQTluoeXkgcvdeC
         1EQKEshrL1HkLDkXsuRavLwnIL7SvBqYxzBs15q9KUx98MQXpK4ZdQnOuMYJTmHmvAFO
         R74A==
X-Gm-Message-State: AO0yUKVJmLxLgevHEK4ZrL81hfJSYFkpmej6eV2+1NQUC18EUfY31ZAA
        wqPXI/zFjTnyudWOJBdKF26h1dFqHMqgqUM1KOlFmuXcekycL7FmrKXGAMyRri4KxJS+OwuN800
        HkFCajhHEPmSMoL0PFv9PEON0hhVqlA6EBqE8B1ilRVYNHVA/bA==
X-Received: by 2002:a05:6902:158c:b0:8bd:4ab5:18f4 with SMTP id k12-20020a056902158c00b008bd4ab518f4mr6961221ybu.6.1677493284161;
        Mon, 27 Feb 2023 02:21:24 -0800 (PST)
X-Google-Smtp-Source: AK7set+rGvI3MUFePg0BXtepXu6AiPdqPrF6Mljz9WZ2to+nM0MjGJbbnUKymUpWGEx7DqGAjleENMoMOF+dRFPkK7s=
X-Received: by 2002:a05:6902:158c:b0:8bd:4ab5:18f4 with SMTP id
 k12-20020a056902158c00b008bd4ab518f4mr6961213ybu.6.1677493283931; Mon, 27 Feb
 2023 02:21:23 -0800 (PST)
MIME-Version: 1.0
References: <20230226201730.515449-1-aleksandr.mikhalitsyn@canonical.com> <CANn89iKtiwF6AwBT3CgMUVvtA7pGON5O-aOUG4aQSSgmxDMVbg@mail.gmail.com>
In-Reply-To: <CANn89iKtiwF6AwBT3CgMUVvtA7pGON5O-aOUG4aQSSgmxDMVbg@mail.gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Mon, 27 Feb 2023 11:21:13 +0100
Message-ID: <CAEivzxeZKUkL2-gSeK8R+PJ2NppB-OKcVYbvLbX-uKbtahf1SA@mail.gmail.com>
Subject: Re: [PATCH net-next] scm: fix MSG_CTRUNC setting condition for SO_PASSSEC
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 11:01=E2=80=AFAM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Sun, Feb 26, 2023 at 9:17=E2=80=AFPM Alexander Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > Currently, we set MSG_CTRUNC flag is we have no
> > msg_control buffer provided and SO_PASSCRED is set
> > or if we have pending SCM_RIGHTS.
> >
> > For some reason we have no corresponding check for
> > SO_PASSSEC.
>

Hi Eric,

> Can you describe what side effects this patch has ?
>
> I think it could break some applications, who might not be able to
> recover from MSG_CTRUNC in this case.
> This should be documented, in order to avoid a future revert.

Yes, it can break applications but only those who use SO_PASSSEC
and not properly check MSG_CTRUNC. According to the recv(2) man:

       MSG_CTRUNC
              indicates that some control data was discarded due to lack
              of space in the buffer for ancillary data.

So, there is no specification about a particular SCM type. It seems more co=
rrect
to handle SCM_SECURITY the same way as SCM_RIGHTS / SCM_CREDENTIALS.

>
> In any case, net-next is currently closed.

Oh, I'm sorry.

Kind regards,
Alex
