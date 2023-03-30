Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB42C6D0D92
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjC3SQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3SQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:16:40 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2287D306;
        Thu, 30 Mar 2023 11:16:38 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id by14so1365476ljb.12;
        Thu, 30 Mar 2023 11:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680200197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9h2GvUNNoLQAB8LDpXTAOuV+zteZS3OOQfkay6SCnQ=;
        b=GVCrY1TUpJ9FmQOJgtwEpuW8SU3t65Qd7/THjNZ+CwyTKHuHSzz3Bpec41R4qLqSvQ
         M3XurktFxv/n/JHFMsOE4zhzn5bzmkHup48j+jrb0ixvqh1bUnHeHO5hXqACzy6I6L80
         b7F+/floOZbeFeCwUBllaojfIq/LHyb+FquDYWcFq8hCHf1wxOWInG6qv4OIvE3rFJM2
         xRuAlWb+yXpGwIc063hC8uc8IGmhTB1KEBy/Y8CX4ueB91j8Fp+zBYmYwsy4a1TdKGFx
         oXzUkPhp7uUivnKkAwn54MlntgNPY408GLY3VLrA6V5vXS+5u5Eb/DOpySvTATd6buT5
         Vl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680200197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D9h2GvUNNoLQAB8LDpXTAOuV+zteZS3OOQfkay6SCnQ=;
        b=fTcL5eelOXOf1GXS/XefP67RSbyt5uE0wo4rvZUPHHOsOkn/bFUADbPq276vp3K62V
         5oWA9z0liaAOI5u0Jk00ivrDdljBRK++hF6VONHrK+6DG6yDTNBjxXSYWW7oYjAc3PXz
         7jaOAlrkf+GtYf0JqUdH+2LdSU20sV1Ct7RdsR/rvQ3qLVYw99tyZJW7iSAOj1ugOrQb
         Arj3QL9ylqP38ZzLCozOMoy/HSLNaAzpc6E/vesL8yHH4c+PAGQrzkFc2U+Kid1tvXNG
         DUZMiu2i8YrQYPMN6Ch9ji4T8OLO0HeSCfOQRRrghF51TZjzCKf0lHzJaVwb8xv6ZlSm
         WaFA==
X-Gm-Message-State: AAQBX9e/ZhjjoWHht7feg08gHAEG5Jt2ClHTKez5YP4EOhLjmH/c4jl4
        HEvuG6EouJJUBOk+MGSCMDGL1zxkB8XGGoJzNmI=
X-Google-Smtp-Source: AKy350Yqc4ilqAsTqUl0WSGgkMAXCRaM87jJ1cjkCjT4KKrGsB28GvRHHn4Khc1dR28W4j5uEReLow8XgRr0LXEcMug=
X-Received: by 2002:a2e:8697:0:b0:295:acea:5875 with SMTP id
 l23-20020a2e8697000000b00295acea5875mr2300855lji.2.1680200196984; Thu, 30 Mar
 2023 11:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230330095714.v13.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
 <168019982448.20045.10207710004218277745.git-patchwork-notify@kernel.org>
In-Reply-To: <168019982448.20045.10207710004218277745.git-patchwork-notify@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 30 Mar 2023 11:16:25 -0700
Message-ID: <CABBYNZLcS3uEkYgkokR5a0YHRfdJczm5XFbxXCEUfmrZg3ifnw@mail.gmail.com>
Subject: Re: [PATCH v13 1/4] Bluetooth: Add support for hci devcoredump
To:     patchwork-bot+bluetooth@kernel.org
Cc:     Manish Mandlik <mmandlik@google.com>, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org, abhishekpandit@chromium.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Thu, Mar 30, 2023 at 11:10=E2=80=AFAM <patchwork-bot+bluetooth@kernel.or=
g> wrote:
>
> Hello:
>
> This series was applied to bluetooth/bluetooth-next.git (master)
> by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:
>
> On Thu, 30 Mar 2023 09:58:23 -0700 you wrote:
> > From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >
> > Add devcoredump APIs to hci core so that drivers only have to provide
> > the dump skbs instead of managing the synchronization and timeouts.
> >
> > The devcoredump APIs should be used in the following manner:
> >  - hci_devcoredump_init is called to allocate the dump.
> >  - hci_devcoredump_append is called to append any skbs with dump data
> >    OR hci_devcoredump_append_pattern is called to insert a pattern.
> >  - hci_devcoredump_complete is called when all dump packets have been
> >    sent OR hci_devcoredump_abort is called to indicate an error and
> >    cancel an ongoing dump collection.
> >
> > [...]
>
> Here is the summary with links:
>   - [v13,1/4] Bluetooth: Add support for hci devcoredump
>     (no matching commit)

Note that I did a small change to convert from bt_dev_info to
bt_dev_dbg that is why the no matching commit is shown above.

>   - [v13,2/4] Bluetooth: Add vhci devcoredump support
>     https://git.kernel.org/bluetooth/bluetooth-next/c/d5d5df6da0aa
>   - [v13,3/4] Bluetooth: btusb: Add btusb devcoredump support
>     https://git.kernel.org/bluetooth/bluetooth-next/c/1078959dcb5c
>   - [v13,4/4] Bluetooth: btintel: Add Intel devcoredump support
>     https://git.kernel.org/bluetooth/bluetooth-next/c/0b93eeba4454
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>


--=20
Luiz Augusto von Dentz
