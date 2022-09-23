Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7715E7169
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiIWBeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiIWBeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:34:15 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C79ED5E8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 18:34:14 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id a10so13082056ljq.0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 18:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yxVkj8vMOj0M4F+ZY9bcIhgF0+ag1p/3PWCPUQB0x8s=;
        b=jKIGElwC44o0+qFhSH9ox495eEa9xYjEc6Xbg2IUlKg0eEFJS+B+0tz6rJy5EIGr0a
         b5wlLi38UDghN50Dj+LJ4nu54hvgsW8KzNTjWeE3ARd7mVrjMFwhllo3KbdvkZk/Ih6V
         sA3HmrarXYEM6EtepyirenrufNKoUM+k/ZhUyA0q1tKkCllrpCAqoY3d8CjDQb+A+KII
         TMIQP2eBlaEF7xyjzrjgqSv7ZkhrsfuoIfpnp2IlEe7nadvV+jVzuSDCEHEvd9TcG9eV
         1HC5aGmgL+Z7Mj2pZhHgALG2Hj7ElXoEG/Ur45Y9dknyesuxgQpyI9FTyRSX/QTAbIpS
         Z5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yxVkj8vMOj0M4F+ZY9bcIhgF0+ag1p/3PWCPUQB0x8s=;
        b=TGyFzuVYrbeGTL6+wyGUTBKZ0Hl/C+qegzfD+1Wzz0i/tXwzB0i51Y7PyYXjcvnEN+
         1a2UY38v6k/i5jm5kgD6tAYsMM8ENh5k2aK0DumtEwopIIyj47yi+LoZpw0Y9vC1t1lz
         cA8Z1nD6lSgB/guocDsno3YuxygDQNfyxR7BSkt9x9N9JAEbFrvEauI4sUPPUh1KUHlS
         LnbGGmRTuE2/4tavbzIELSeT4yDs/jgz/Cw//4Uvu3/daQ8SEr6gBz97Yi9OWMEryAcU
         oRTFdAMm7icVxPlT2UJSQJ+4AhfimnMPSr09DFp9hHZ2dTZ95qwLF5QNkKsdASirKgGi
         5fkA==
X-Gm-Message-State: ACrzQf3+cs8Shcgk4UxUy2kBloUS0IgherdVVWQdJUfx8iXvK3vSeNgd
        89hsnqHh/ltSzi5JAXZEyrp7rJCRhiMs0m2OA2hvyC/8p5o=
X-Google-Smtp-Source: AMsMyM7Ct1Rq0whbC2lGQwkd3jNYclXeT6SVe/WH/WZSiqd3lchmATXlsVEuxdO3PwJh7YGFFf9EYdiOwkY/vjC3sBA=
X-Received: by 2002:a2e:9545:0:b0:26c:400d:47db with SMTP id
 t5-20020a2e9545000000b0026c400d47dbmr2145821ljh.404.1663896852750; Thu, 22
 Sep 2022 18:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220824221252.4130836-1-benedictwong@google.com>
 <20220824221252.4130836-3-benedictwong@google.com> <20220830062529.GM2950045@gauss3.secunet.de>
 <CANrj0bYOU0Ekwn6nVQr+c2znbX6wHFry7TUi-Hd4BW78DEw7qA@mail.gmail.com> <20220922062710.GE2950045@gauss3.secunet.de>
In-Reply-To: <20220922062710.GE2950045@gauss3.secunet.de>
From:   Benedict Wong <benedictwong@google.com>
Date:   Thu, 22 Sep 2022 18:33:55 -0700
Message-ID: <CANrj0bZ16_QOr8Tw6Cp6Dv0dM3MzkWKfwFfb7WqT-X3QbvJ8cA@mail.gmail.com>
Subject: Re: [PATCH v2 ipsec 2/2] xfrm: Ensure policy checked for nested ESP tunnels
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, nharold@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ahh, I've never had an IPv4 server without a NAT to test against, I'd presume
this is identical there. The only comparison that I've been able to do  was IPv4
UDP-encap vs IPv6 ESP.

We could instead add the policy check to the ESP input path if that is
the correct place.


On Wed, Sep 21, 2022 at 11:27 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Fri, Sep 16, 2022 at 10:44:42PM -0700, Benedict Wong wrote:
> > Thanks for the response; apologies for taking a while to re-patch this
> > and verify.
> >
> > I think this /almost/ does what we need to. I'm still seeing v6 ESP in v6
> > ESP tunnels failing; I think it's due to the fact that the IPv6 ESP
> > codepath does not trigger policy checks in the receive codepath until it
> > hits the socket, or changes namespace.
> > Perhaps if we verify policy unconditionally in xfrmi_rcv_cb? combined
> > with your change above, this should ensure IPv6 ESP also checks policies,
> > and inside that clear the secpath?
>
> Hm, do you know why this is different to IPv4? IPv4 and IPv6 should
> do the same regarding to policy checks.
>
