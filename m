Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0311C6D1453
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjCaAsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCaAsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:48:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F625C15B;
        Thu, 30 Mar 2023 17:48:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x3so83491886edb.10;
        Thu, 30 Mar 2023 17:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680223723; x=1682815723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxHd84F2YH6oOwsy7pHR9az94Ed8YsAsJQFPynfdEj0=;
        b=oq4fk0yCNhZEmVxXW478SNrK3s6VHVNaDGFVaSi2MrBL3kcngpprw7+EaNhYcsM8ZG
         SlYV6Y8n5JlCsEmv1RZu4QFpMo/0n2iKDIuGKWxbLbmpWwWb1vVzSFafsjUXJtxJ+b/F
         lzo4PFCygxjf83IdkfN485CKTmiiK2uxblne1zWs3oziefsHFdDL5dL/QGJukElBxpdm
         5cFTKITVbUaxQrweJCrbc3UxGFA1y5eWp4PTVOQR73jUOwmEUpB0lMXYrM72X1IH9i7J
         MLf4oJVqK2FklC5857nhFehFQpsR6e+lkVV7grix+yzFSp3vBKB2gruuQmirZVP/GOHJ
         SB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680223723; x=1682815723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nxHd84F2YH6oOwsy7pHR9az94Ed8YsAsJQFPynfdEj0=;
        b=X1qyQd0QTJud3t/VPwH/CFLInksTIyrlUcSuQs+orP4cXKE6y0AzBBX69c/r8zE1Di
         yc5A+5B0VjWmiqafooe3JY5vT+USGUzG3AGldw/qt+kWE0qxBFYT09laQvPQPHJr9mUK
         otT80uRSORsO5P8eRXAKWvcWs+Rk5uPh6e3jGFRMFO946+kwRfKcn3YSPFyxi2UBA34M
         IoRPHcGlS+kgw9paQzOF9wKl0nZoJZ2kbclQos2Zu2nCJyyzBVwUIzxKzXOu0y/JSvoe
         /9csssm0Ils1kCvBZkJDLV4Il6A5WbSAcyjW6X+QBBRJXDnxOc/ZNQdEZfxhQQ/ouTuR
         +6MQ==
X-Gm-Message-State: AAQBX9fPK/emuCwpVkJz4LhnR/prHTVjuHAW7GiQKR7n8/pcOiY7F85L
        u1tt659xqekW/mhkvxbU9Rq2Vmqm5S+gnFpf6/9EoSl/iqU=
X-Google-Smtp-Source: AKy350a58GhEasY6NBm5jpQpEPK92a6/P1D+P/Rc6xbWllvA2TDH/OTjFwDpvFKW+Et+k04vlDvO4BEfKy0DwYA/ego=
X-Received: by 2002:a17:907:cb86:b0:930:42bd:ef1d with SMTP id
 un6-20020a170907cb8600b0093042bdef1dmr12997961ejc.11.1680223723470; Thu, 30
 Mar 2023 17:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com> <20230316172020.5af40fe8@kernel.org>
 <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
 <20230316202648.1f8c2f80@kernel.org> <CAL+tcoCRn7RfzgrODp+qGv_sYEfv+=1G0Jm=yEoCoi5K8NfSSA@mail.gmail.com>
 <20230330092316.52bb7d6b@kernel.org>
In-Reply-To: <20230330092316.52bb7d6b@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 31 Mar 2023 08:48:07 +0800
Message-ID: <CAL+tcoBKiVqETEAPPawLbS_OF0Eb6HgZRHe-=W81bVKCkpr4Rg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
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

On Fri, Mar 31, 2023 at 12:23=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Thu, 30 Mar 2023 17:59:46 +0800 Jason Xing wrote:
> > I'm wondering for now if I can update and resend this patch to have a
> > better monitor (actually we do need one) on this part since we have
> > touched the net_rx_action() in the rps optimization patch series?
> > Also, just like Jesper mentioned before, it can be considered as one
> > 'fix' to a old problem but targetting to net-next is just fine. What
> > do you think about it ?
>
> Sorry, I don't understand what you're trying to say :(

Previously this patch was not accepted because we do not want to touch
softirqs (actually which is net_rx_action()). Since it is touched in
the commit [1] in recent days, I would like to ask your permission:
could I resend this patch to the mailing list? I hope we can get it
merged.

This patch can be considered as a 'fix' to the old problem. It's
beneficial and harmless, I think :)

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/co=
mmit/?id=3D8b43fd3d1d7d

Thanks,
Jason
