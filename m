Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FADE35E893
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348542AbhDMVwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348528AbhDMVw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:52:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA14C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:52:08 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id r12so28297405ejr.5
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=laREoPxw+nui17XJ9tVianRcjb8xMSVZa35q9KjxbHA=;
        b=uD1raBkLKe8y3cyMXrdOb0fj5YPlOqQBYehCM50YnB02GPiqgfbZz/WeNDMyfxDpio
         OBQ9vdyD4K3C4RDem+xP0jJWdd9jKHJ+VZAeHw+9gfsGr8UTg1Vbo66zJNebtQ2Sq+zY
         XJNOgU8U1Xlq7x1//zSX/7E90OhnoGeewrDZ8wO18SGpYKC5BDwzLKPTBXwEjhN4e3Vd
         xPgwcVqj0Dnp+BDyY5Y1lp8EeUSEBKTaCkdfcS23Q4t43ELFX8Ifhv7qPXfEx0WP9FjL
         9oKdi5Uu2KfZd/0z2wgE7OLcPONwahZQGQCdqT1uFKu6m0/sHHYggUFssmRVtpDg+S8y
         38Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=laREoPxw+nui17XJ9tVianRcjb8xMSVZa35q9KjxbHA=;
        b=pfGMLd4eboxhAKGqK2nVcAiXzxZEalQfGTZJF5HJdyENW2pVFkHBpS90OLREZHrjv4
         p1epxXHN++RrmmshTrPsLYkpbOl9VwstF89BUPyl9AtKCzbMQ7C/Ykj1CrWah3ukhc5y
         xJLoEBsPpb/Gku4Nrt5Ha5/gNQTLPAo/GbdMLayNfVHaJqQNBo+4tFeBMDyhTfWWoGhW
         4RF6D49AYL4PYbMqvDEmYTVMtekAPsUVfLheuTZOJr0mIgfEqpULxxdUgQKjt3p2GaUP
         Bl9gCATYofFRQG1+PETEj6fDaZhGi6ptEoLXA/K05DDm3Q8Lf+m2SKRYUcb3K+YtccyU
         FwCw==
X-Gm-Message-State: AOAM531ho3dHfWUSKyiBRc4X5ge2fjdu/nwr1Cu5jRcGHQYCt+teWipj
        DrYc68uGT0SreueOxeG26mdjLzxJXpRH8g==
X-Google-Smtp-Source: ABdhPJzyMnx3l1Q7kUjAT/PfkVbmWi42+Q5tPYu5JsjWL9RrzAOyce1ILUQH0sW7Hxxswxy7aCz1RA==
X-Received: by 2002:a17:906:e48:: with SMTP id q8mr34865092eji.84.1618350726841;
        Tue, 13 Apr 2021 14:52:06 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id t1sm10389511edy.6.2021.04.13.14.52.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 14:52:06 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id u20so4985549wmj.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 14:52:06 -0700 (PDT)
X-Received: by 2002:a7b:cb05:: with SMTP id u5mr1821534wmj.183.1618350725643;
 Tue, 13 Apr 2021 14:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210412212356.22403-1-andreas.a.roeseler@gmail.com>
In-Reply-To: <20210412212356.22403-1-andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 17:51:27 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfNxNj1o3QE=PL=NQ9ux27xiW7vVgjwgoWMeUb-GyBuUQ@mail.gmail.com>
Message-ID: <CA+FuTSfNxNj1o3QE=PL=NQ9ux27xiW7vVgjwgoWMeUb-GyBuUQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2] icmp: ICMPV6: pass RFC 8335 reply messages to ping_rcv
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 5:25 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> The current icmp_rcv function drops all unknown ICMP types, including
> ICMP_EXT_ECHOREPLY (type 43). In order to parse Extended Echo Reply messages, we have
> to pass these packets to the ping_rcv function, which does not do any
> other filtering and passes the packet to the designated socket.
>
> Pass incoming RFC 8335 ICMP Extended Echo Reply packets to the ping_rcv
> handler instead of discarding the packet.
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

for future patches: please add reviewers of previous revisions
directly to the CC:
