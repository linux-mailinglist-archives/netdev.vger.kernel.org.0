Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33A34BEF90
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbiBVC2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:28:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239197AbiBVC2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:28:23 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E5425C6B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:27:58 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id bt13so38094449ybb.2
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+XUt1JheGNhukseTP2vJALo7ev4DNIDxPQcElkQvY4k=;
        b=OxsBSq4ZKQ+bA1eIUbI/lUky5pPRL3zKymAU5oQddMud1CsHEKFxcKEWJailnDno8n
         QHgaaAdO+faLkZnINmKKn7sdFGhyGcb9OeAcziC/AaLOEeSTxkiddOQ0AJPUdtbtiZPj
         Le2mECsBPz3blTmHMan5JShlpJH/SatuPFoIQrtOZR5AxCbx6tjIx/FIl6LyGpN3Lpf/
         BeJp2kYdYC9quN9POleUYtEAb0Dz1Ps378rDYkvavNdIjTf8Y0UhW5jak/dlzGSXV0nq
         lHbxXqouP9GPWIAUH+wprOXn/IWu9gm101wKHH920+/IwYqnxRDy0Hby2CfFfoh2MrpP
         aH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+XUt1JheGNhukseTP2vJALo7ev4DNIDxPQcElkQvY4k=;
        b=j0r1EoEHWwePW/6M1uLp/67odqc01aQqtxCNHlPTRuPh4pwr1Ww07+hSBz6hEXFcpR
         O0R1d9cd3WXZUapjU9J+VULvLnhTtefvzrjmJnNtRsgk04jqB/tfcSsv0Cdqei3OBUth
         F/9mBGRGM5BGg4GHT6RMTz3RqLY7QyNUlC5UwHhsq+N6fxec/MduiiEblsKdUmXWRDUB
         t/F3cC8bgX3YxjCvVmzcB4KfwZ6S7XEQirLZWpSjVD26dG4/PdqyHG7fWGlJxvHkyQpw
         1rPZ+Kyjb1wnrecvDwg+EVCS3zhTeCgOsYMsNhZbtX+2xkVtiRKu6QqBf/npzNc745f2
         I5dQ==
X-Gm-Message-State: AOAM532vVqnnomPibcP9I2sggmCv7NM87TwlVXq6y1SODvVVo05s3X2c
        OEa91ar04Cla4hCMeXTvoqr9M66gah0BLsz0e99PzgGaw80Zo38M46U=
X-Google-Smtp-Source: ABdhPJz9f7j8kwnQUc3IirZItDk38zJ8bQCtyP6b7n0qiePeOHuTh7iCQtOX1MZZh0KibLTz8RHbcApUyD56/oNXdUY=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr21664619ybe.598.1645496877423; Mon, 21
 Feb 2022 18:27:57 -0800 (PST)
MIME-Version: 1.0
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
 <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
 <YhQ1KrtpEr3TgCwA@gondor.apana.org.au> <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
In-Reply-To: <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Feb 2022 18:27:46 -0800
Message-ID: <CANn89iLf2ira4XponYV91cbvcdK76ekU7fDW93fmuJ3iytFHcw@mail.gmail.com>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 6:06 PM Ziyang Xuan (William)
<william.xuanziyang@huawei.com> wrote:
>
> > On Mon, Feb 21, 2022 at 07:43:18AM -0800, Eric Dumazet wrote:
> >>
> >> Herbert, do you recall why only a decrease was taken into consideration ?
> >
> > Because we shouldn't override administrative settings of the MTU
> > on the vlan device, unless we have to because of an MTU reduction
> > on the underlying device.
> >
> > Yes this is not perfect if the admin never set an MTU to start with
> > but as we don't have a way of telling whether the admin has or has
> > not changed the MTU setting, the safest course of action is to do
> > nothing in that case.
> If the admin has changed the vlan device MTU smaller than the underlying
> device MTU firstly, then changed the underlying device MTU smaller than
> the vlan device MTU secondly. The admin's configuration has been overridden.
> Can we consider that the admin's configuration for the vlan device MTU has
> been invalid and disappeared after the second change? I think so.

The answer is no.

Herbert is saying:

ip link add link eth1 dev eth1.100 type vlan id 100
...
ip link set eth1.100 mtu 800
..
ip link set eth1 mtu 256
ip link set eth1 mtu 1500

-> we do not want eth1.100 mtu being set back to 1500, this might
break applications, depending on old kernel feature.
 Eventually, setting back to 800 seems ok.

If you want this new feature, we need to record in eth1.100 device
that no admin ever changed the mtu,
as Herbert suggested.

Then, it is okay to upgrade the vlan mtu (but still is a behavioral
change that _could_ break some scripts)

Thank you.
