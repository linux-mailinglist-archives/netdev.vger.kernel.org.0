Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00131EB8EF
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgFBJzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgFBJzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:55:38 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61171C08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 02:55:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d7so10196829ioq.5
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 02:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+2qftdfGzvqFPSmH85T6+Wlrzo4v4AkH7We72qGJ2eU=;
        b=L5EPPNuHxm+R/ngrL7D/bDzm3jmI1xC3ugAs/xTro4ziY/ln+VksSDvLj07BXsJlPJ
         QEPbyHM3n/O7ty52fObri7ykLRUuozKTCN2tl3yO4uZXR/S3OS16z+oO87Ys3UhtbHJv
         q8X53AR1So3Vcqr+asssBUYXNUWKyMj3vQlW/dK8FVb2LCqkWPeQrz4wO7Ud0OZAM7c/
         JZm8lcJyKmuc0ju4+p6+XUM6xvs6Vz2GtkJ7LBtrx1O7OHxXvDSR5fHTLswMM1bfOur8
         a6zCCwTJ5yfY6h6E687BMFRK8iXGpQwVU7m3D+Bc1LG77pfGtHCIr0Z0MCctvPbLng4z
         jr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+2qftdfGzvqFPSmH85T6+Wlrzo4v4AkH7We72qGJ2eU=;
        b=OheSXLm8P8okk/hHP8RQCbjSOXC74a9NlVnc3vJbdLT5EJ1EpXZJ5i8Th5Yq42fX9F
         FE374nsAiXP7957W9k5fyNHcs57adEfY2oSK8TubIyVcfVQYw/9d5XEcU+K9c3J2I7i1
         J76+SSxjlEory5jKwgYI9YmV56OmG1SWNX6KvYsPkIrZ/9gZWCYIdr7GxBbaS8QPYCNK
         x4ivSq50OIlL9uVv7YuyGwOJjg90SHiC9MJOBxETQ+Es5XnMmo+9Jb5n8JWarqfbotVy
         /U2zZYL0NicL0gITtqgm/Aekw2pVtRhXsmGqq3/sfBxWL01XNlpwU6T1z+SE1s2NHull
         trdA==
X-Gm-Message-State: AOAM5309h+v87i1fiRS+Zzi6lRm07k1mY7gZvEW2wYFtM3Il2x3avXV8
        4y+U+ex9tiYBoszTZA7FAwxQ5T5j393ywwr3a3jrpN+P8BgTlQ==
X-Google-Smtp-Source: ABdhPJz/sNHTbROYRhioqzwB9NACNHROQYmM/8M/yaBo1Mh6x/rcwCj0ypBt17Yn74Em1cI0O5ED8T3Tr3MtqWgPB44=
X-Received: by 2002:a05:6638:209:: with SMTP id e9mr25205965jaq.48.1591091737258;
 Tue, 02 Jun 2020 02:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200525154633.GB22403@atlantis> <20200530123912.GA7476@arkam>
In-Reply-To: <20200530123912.GA7476@arkam>
From:   Christophe Gouault <christophe.gouault@6wind.com>
Date:   Tue, 2 Jun 2020 11:55:26 +0200
Message-ID: <CADdy8HodW1HLvO-36T0uiXji11km83ZDhYgEAavD9EVz+wCq8Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] xfrm: introduce oseq-may-wrap flag
To:     =?UTF-8?Q?Petr_Van=C4=9Bk?= <pv@excello.cz>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le sam. 30 mai 2020 =C3=A0 14:39, Petr Van=C4=9Bk <pv@excello.cz> a =C3=A9c=
rit :
>
> RFC 4303 in section 3.3.3 suggests to disable anti-replay for manually
> distributed ICVs in which case the sender does not need to monitor or
> reset the counter. However, the sender still increments the counter and
> when it reaches the maximum value, the counter rolls over back to zero.
>
> This patch introduces new extra_flag XFRM_SA_XFLAG_OSEQ_MAY_WRAP which
> allows sequence number to cycle in outbound packets if set. This flag is
> used only in legacy and bmp code, because esn should not be negotiated
> if anti-replay is disabled (see note in 3.3.3 section).
> (...)

Hi Petr,

Thank you for taking my comment into account.
This new patch looks good to me.

Acked-by: Christophe Gouault <christophe.gouault@6wind.com>

Regards,
Christophe
