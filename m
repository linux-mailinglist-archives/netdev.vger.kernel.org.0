Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038983D95A4
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhG1S50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhG1S5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:57:25 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341B1C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:57:23 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id l17so4331304ljn.2
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wz3zSkFzjQntghr6ZqIZrO9ooDQ8NkXIW4sIoKf9LII=;
        b=erh9WZmKaNqQHnCbDmc/UVs3PMxojFdDOnh2teaK7xiadq49gjo61tfLnlD89XfG5M
         bkj9NDS9bdOTyv47cYV1oKYWM7mTogJCf2sLZ7aruoxXpg/bXq+8ZX4UAWWoy8hBb0qD
         kkfEqNi0r/geKhsh/ofHJskphQg6DBJp2cq+571fOPH4De6pRgYcyuSXIzi4boCT2JyK
         rEc3zTIUhFoIYcQkW4wgTtR1FDOpTilTlFoOk0zGZGSO+edUVpxnw/kcahOaiU9WaWsg
         hzSREd9n5DgchC5LT3CoqasYvaWNLWTfMI/MsW12AI+ZV4GWp+ZfdayXl9MCteyw2MH7
         /RIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wz3zSkFzjQntghr6ZqIZrO9ooDQ8NkXIW4sIoKf9LII=;
        b=L7GlUj2xX7b5ruFhDvAXU2Aa5wCueQRjQ8UiFIDidq0uCTXU1uwmzemE8Tq8BknWx/
         C1qBQ2Ay6BGhzMDBju3ZFlc/67o8vIiWP2wp6yjd4+0GnG9H0jZsHwCiIZvJuQABO/tK
         SyRA0JE0HyhjFIzS/rms5DlO/l9U4dDzmTJjvYTevHLzS9nF+b6fcHBbTOo/Ot37HLb2
         YfvCQbJPDYGbtA4aCgIIfMbUFmB9YVypUOWxN8vjHpYUctmV+hlRbONTAbSdb+gq1dvW
         UT4jS/hD/ied0t4LETlSzV2C7LiJPzsHzxZEsfewFcLysmXQNBdQD8AGoogGCnQojd1k
         n8Yw==
X-Gm-Message-State: AOAM531jdMXhEazXY8jlOQCfSg/r8sZsKH40hO9k0OZLJhKSiiLA4Oab
        aMQaaEewbIzNaNny+MjwbjWfXbHtQx/YgW6U9N8VXQ==
X-Google-Smtp-Source: ABdhPJzmD03VSAkTiDzk+W1Cgj85XGNlk2DPLdChRVx0hZZjmdQyZoM+U7EvgM2sc2Yr0a1ObQMzPP1l5SAUXRd4k2c=
X-Received: by 2002:a2e:8887:: with SMTP id k7mr735557lji.226.1627498641274;
 Wed, 28 Jul 2021 11:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
 <202107230000.B52B102@keescook> <CAG48ez0b-t_kJXVeFixYMoqRa-g1VRPUhFVknttiBYnf-cjTyg@mail.gmail.com>
 <20210728115633.614e9bd9@oasis.local.home> <202107281146.B2160202D@keescook>
In-Reply-To: <202107281146.B2160202D@keescook>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 28 Jul 2021 20:56:54 +0200
Message-ID: <CAG48ez358qhf2m3=WY-ngtQT9SOLkGTGMqeb7seFpNaSiqvtSQ@mail.gmail.com>
Subject: Re: tracepoints and %p [was: Re: [Patch net-next resend v2] net: use
 %px to print skb address in trace_netif_receive_skb]
To:     Kees Cook <keescook@chromium.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 8:48 PM Kees Cook <keescook@chromium.org> wrote:
> How does ftrace interact with lockdown's confidentiality mode?

Should be LOCKDOWN_TRACEFS ?
