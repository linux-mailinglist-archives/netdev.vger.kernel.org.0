Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D539F48CB3B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356488AbiALSrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356474AbiALSr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:47:29 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD1C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:47:29 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id n68so8219992ybg.6
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l8e6N4DmYcgGmLkLSMG1X37N0RSZtXSQUoXgm/VDy6g=;
        b=hH8hsMu0AFPjoF11C79kFoa0tzELSu4lQfbkDnviq1lECt+ARe8QeJXSH/xEH0eNUe
         7yqVoxRRwvml/XRCZLRqj0RnMJwl2Un01dyCC+dum8fxgOVfnRa13K8Pec7TVsQPkuDd
         9sNK+PgH8lN1d8HIZN7n5DhABxSKlsUEUamEsd+kSVrl5+jH2NTHqEs2I/j01iB9AGBO
         LEmXGBgeumbCIgHS27f+jWV0/Wa0wnnjL+JvcsGBD0uEpvBMXvGwageziUdrx64iMMqB
         s23QxQ4tEC5dF7dUkJz4jY14C2YlDgbcxGst29h0fV+L6UlVvPMxZbsRyKXO/YLGhLGW
         IiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l8e6N4DmYcgGmLkLSMG1X37N0RSZtXSQUoXgm/VDy6g=;
        b=AjX4eNf9KHL3usqwlgSNDIpX+alLjeNUGdn9Dq1L75/Qb3EQrGZLQwOMt2PvO9U96Y
         M6+Gj692IKgm8aItdib1k8un0q0hz2ydAPzAK6Fwg0Vlb4VnvgsTmkPRu/0elU/6uqrg
         dDpFGNNGvgf/ofr7u3PQp4eXJr0sZedGeEmH1JisXizIM1LMMpI0EFkLRFAgzJI5ncX3
         bvDWoNJbUc0e8YXWWwxM4XOkIxh5UBY4eCjOCDll+S8AZnvAgLd0i4YL0PwhgKzY28fU
         bLoT3mEnMrwMjfqFgH7UeUTeZVZHUYemblbLDM1VQIYKBUz7CLrm57pvm32d1EsW0fJF
         R6HA==
X-Gm-Message-State: AOAM532F8etptSg5wy3QnHiAXxhqcNkIhY+orasiInkkjJah+MFcOpuT
        tCOGgodXoP4GQXHTlOQZki911GfAlcS47mRDNQ2x5Q==
X-Google-Smtp-Source: ABdhPJyNQ7R1JSrILHsHXmFKh2x5BnmKcX4ryLTb1sTcVpqh9bfvXMO22wUrB4OprolUgVrDS1CQ5S31SaixtaHPSqM=
X-Received: by 2002:a25:b29c:: with SMTP id k28mr1327342ybj.711.1642013248231;
 Wed, 12 Jan 2022 10:47:28 -0800 (PST)
MIME-Version: 1.0
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
 <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com> <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
 <a6ec30f5-9978-f55f-f34f-34485a09db97@candelatech.com> <CADVnQym9LTupiVCTWh95qLQWYTkiFAEESv9Htzrgij8UVqSHBQ@mail.gmail.com>
 <b60aab98-a95f-d392-4391-c0d5e2afb2cd@candelatech.com> <9330e1c7-f7a2-0f1e-0ede-c9e5353060e3@candelatech.com>
 <0b2b06a8-4c59-2a00-1fbc-b4734a93ad95@gmail.com> <c84d0877-43a1-9a52-0046-e26b614a5aa6@candelatech.com>
 <CANn89iL=690zdpCS7g1vpZdZCHsj0O1MrOjGkcg0GPLVhjr4RQ@mail.gmail.com>
 <a7056912-213d-abb9-420d-b7741ae5db8a@candelatech.com> <CANn89i+HnhfCKUVxtVhQ1vv74zO1tEwT2yXcCX_OoXf14WGAQg@mail.gmail.com>
 <a503d7b8-b015-289c-1a8a-eb4d5df7fb12@candelatech.com> <a31557d8-13da-07e2-7a64-ce07e786f25c@candelatech.com>
In-Reply-To: <a31557d8-13da-07e2-7a64-ce07e786f25c@candelatech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Jan 2022 10:47:16 -0800
Message-ID: <CANn89iK2iM=fM=EN3v3jfOfHRS4HKzbShLcnHt78U+OjnmeVjg@mail.gmail.com>
Subject: Re: Debugging stuck tcp connection across localhost [snip]
To:     Ben Greear <greearb@candelatech.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 10:44 AM Ben Greear <greearb@candelatech.com> wrote:

> Well, I think maybe I found the problem.
>
> I looked in the right place at the right time and saw that the kernel was spewing about
> neigh entries being full.  The defaults are too small for the number of interfaces
> we are using.  Our script that was supposed to set the thresholds higher had a typo
> in it that caused it to not actually set the values.
>
> When the neigh entries are fully consumed, then even communication across 127.0.0.1
> fails in somewhat mysterious ways, and I guess this can break existing connections
> too, not just new connections.

Nice to hear this is not a TCP bug ;)

>
> We'll do some more testing with the thresh setting fix in...always a chance there is more than one
> problem in this area.
>
> Thanks,
> Ben
