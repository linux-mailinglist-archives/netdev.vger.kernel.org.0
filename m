Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E884109A62
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 09:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfKZIrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 03:47:18 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54242 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfKZIrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 03:47:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id u18so2213376wmc.3
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 00:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GJbIW+cgWxothzsbwQSs9lMlWanOIsxjPxxWe2RS+4M=;
        b=aUS0uNlenG8HkR42Xk2jwkJNInG8utDi0FDRsJDqi1/TyPC1vA6Y2U0GJ5iS9YOrAt
         Lkn9K705PLr92FhUdv9e3sm/ztFTh8FAC/O+Hq7QO9RO+QO1E7ZM8pnABhv5r7MRTxNF
         3LsAFskT17L1zCY1XYmm1komUDa31yRmBdE2GyuiUZ7RQ8JaRna53glcTeSb5UhegeR0
         SH0GQMc/s1lJzu/DZkzmMERrJIiiGiXTkESVi/k5HTWmPssYpSAphe8Nf5UDRb79MAHq
         Y92hKU0CKTYyYylID26yfmOUumVrwS5bUZxxRB/2tM/HPW4XD3OLMyW8oLQ1gQbDuKdB
         qAAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GJbIW+cgWxothzsbwQSs9lMlWanOIsxjPxxWe2RS+4M=;
        b=SVOC+gvXvbBstrD/VNvwiQ4A2Fi9CgGw13CWY0loLyPFeF1kkbFWwzzbO66ShfNjze
         s/pPczgRsGMABDYQ+fFgBWsMwUEayqih6fXNRRY4iYb4XSgnnFKtCO8LtgvK/4RYCPQU
         4tOJASSGxc6Eq4KgbTHMwOrjUFCmx/kMUS1Ug1J1UxVPk7kzRwVWG09djxd8xj07D4hd
         g11fdHuZUk8gUB466LO648899nmh/c4F6nIB9tWAzYLMyKn0lunnbl5K6Yizq0JM8trp
         T+R0RI+x2bCEqTO2qHZgncXt+/RNd1Fh/G1YXgvUC0NLzhb2HB5ifqNHCV1Gjh5QCryl
         rY2Q==
X-Gm-Message-State: APjAAAWnMAHAxziBFqHebkHqwd+6qObIdOY0gKtZfBf6wSNXKuGDiGHr
        6ZJjBHEtUGHct66B4CT1tbhl6GbhjY7IV0a2WqE=
X-Google-Smtp-Source: APXvYqynLGJZlLfKbHGHmoj3J+eW247QyIX8cayaamv2ijiEDy51H+TquWrkp3QWXM7HI3n3yx/Qe7N6O/0CwinPOm4=
X-Received: by 2002:a1c:6746:: with SMTP id b67mr1119742wmc.16.1574758036416;
 Tue, 26 Nov 2019 00:47:16 -0800 (PST)
MIME-Version: 1.0
References: <3743d1e2c7fc26fb5f7401b6b0956097e997c48c.1574662992.git.lucien.xin@gmail.com>
 <20191125.145336.1803100409578989775.davem@davemloft.net>
In-Reply-To: <20191125.145336.1803100409578989775.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 26 Nov 2019 16:47:11 +0800
Message-ID: <CADvbK_dmOiNskAZ_m0wjSqn-MYwVqPfSk4Cmf4fO+Sqc8D5HVw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: set lwtstate for ns and na dst
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Benc <jbenc@redhat.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 6:53 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon, 25 Nov 2019 14:23:12 +0800
>
> > This patch is to fix an issue that ipv6 ns and na can't go out with the
> > correct tunnel info, and it can be reproduced by:
>
> And why shouldn't RS and redirects get this treatment too?
RS daddr is using IN6ADDR_LINKLOCAL_ALLROUTERS_INIT.
I didn't think it could be an address that users may use to configure
a lwtunnel state.

>
> And then, at that point, all callers of ndisc_send_skb() have this
> early route lookup code (and thus the "!dst" code path is unused), and
> the question ultimately becomes why doesn't ndisc_send_skb() itself
> have the dst lookup modification?
>
> I'm not too sure about this change and will not apply it.
I'm not so sure about this fix either, but I couldn't see other fixes for it.
Hope to get more developer's opinions, especially from router's.
besides the above, do you have other concerns?

Thanks.
