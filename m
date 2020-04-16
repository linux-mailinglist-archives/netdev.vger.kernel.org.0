Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B531AC64B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393678AbgDPOL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393617AbgDPOLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:11:19 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736D6C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:11:19 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id da9so2052709qvb.3
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=40cy5isK1BuwSUGtcZQJ3IWWx8TM50GTUQra1UlFHA4=;
        b=HwXVmOO6dy7WfG8vCaePFPMwrWLY6ivndT91lnM3ssoIvKJfTIVupc038Ioe/GFws+
         fIQY+NPgpX0xfs9LWrnYNWkDNmM0MLd7+ikz84wkyut0TeQ+xA9Tr7UwGTSXhepyNLiC
         HrWXanNyVTEVTTLWtEbDRBkrha6Yw5TbRJKMg+DcR9ITeO4ANc5dcCJddTls8dfNuPFD
         JECNPxw2Baoc1SZxUc7OtNnREM66eiPFLZn0lVkHFXTsTYrG+DJIrnF6Fyqp6AQV8uq4
         IQLG7P3EschqrnQdqGG+RQ0xRorj2M3+mMwxd2DF+U1e5Z6Dx0VbKzx1yDFGt9NNo3b0
         cLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=40cy5isK1BuwSUGtcZQJ3IWWx8TM50GTUQra1UlFHA4=;
        b=luFLSwP+i3b1ECkCCorcOK/qZj2LTQsJPJPIP9nWW5WfkWs/fFOo75nVLOK1Lye12t
         P7GPcGE/MtEPWYI2CZYvPAnOgU0K3O6npHxgbXdMAxQFnZEkaGYXBVA68deLIleqFU+q
         tahU6A2H0K11t7Q73uUXa/qDQFJx55EyNeWbV6fT2jOfO0zjio70Iy/BFRq+MzrR8xnu
         yTzHzty3gP7XN8sFGfKEb6wspibLUHKm4MdsQXiOmjXfXqIhdkjNJ6wPn3WtUMcG5CQt
         TF7+IyXxWXYe4r26WQqEJTD38YDaF44NqrHCbpKtGA0v3G+vSYJWBD7noyDCIfV6yRGD
         cw7Q==
X-Gm-Message-State: AGi0PuYeSkc2134rcvovkmvilhcvyxH/0Qu4DHefSBM+92yO1O+K5vRy
        B5h2t+UjfsJVVmSEsDmNu+pGGIFWOel6Aj0coKemYVhRfI/Md40W
X-Google-Smtp-Source: APiQypIO+Ld5eB9joMjyx5SRANY94n0SlCYSnhq9qj84htLR5LvE+G8fGqoaEsLx6+VsWWM+C4Br3+wsVQUj7JSKB18=
X-Received: by 2002:a0c:ed51:: with SMTP id v17mr10412849qvq.84.1587046278712;
 Thu, 16 Apr 2020 07:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200415143936.18924-1-odin@ugedal.com> <20200415143936.18924-4-odin@ugedal.com>
 <877dyfn7bn.fsf@toke.dk>
In-Reply-To: <877dyfn7bn.fsf@toke.dk>
From:   Odin Ugedal <odin@ugedal.com>
Date:   Thu, 16 Apr 2020 16:11:07 +0200
Message-ID: <CAFpoUr1F=1kVfzYhH2-++fYEQxC34mRyfbqmSbodfcJNoV3RtQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] q_cake: detect overflow in get_size
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good catch, thanks! Will (try to) resend patch 3/3 with updated changelog.

tor. 16. apr. 2020 kl. 10:49 skrev Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com>:
>
>
> This is not strictly a change to q_cake, so think you have to change the
> subject prefix (e.g. to "tc_util: detect overflow in get_size"). You can
> still say in the commit message that you found the issue while testing
> the cake code, though.
>
> With that change:
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
