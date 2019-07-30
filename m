Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40BE7AB4C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbfG3Opz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:45:55 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35598 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731546AbfG3Opy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:45:54 -0400
Received: by mail-qk1-f193.google.com with SMTP id r21so46847628qke.2;
        Tue, 30 Jul 2019 07:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Gyy/wgw+NjLfDqJ8CTxLYMhmCESsXrdKPDwhF/BGKvo=;
        b=qBd5PeI+kgGkUV1XPyp7VKPXUaBjXobIqLisOrVgBO7x16HzWWHIf2A7gisbRWHJz4
         Lq+ijUNC1dp7udDOp9QYyuhDXxIrdAx2NTQ9sifYDrNZ6YZ3UcX3Kk7q3NZGkulavE9W
         fJKRuI29T4/b/GCMcAJ7r84WmsUeOe66E0IjBMlye/QdConqGzdGMTUVHGaplZ2LEJOf
         xqBH3mAWW6BZkBgacjgCoeWXfOKWGZ4UXYlZGSoV8adHXkV9O2QuK6U/Dxr4dckMJMRb
         CweyNrjaiZBmTnDKeB80d0wZS8tTSwOK3jfxeWUCBtPt8loT471sXgfkpnIvg9PzDlkz
         kgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gyy/wgw+NjLfDqJ8CTxLYMhmCESsXrdKPDwhF/BGKvo=;
        b=shg3KE2VlE6K8ccsJ3pIz6m72TYOm9AbFbzpkhd1rQYbY1LBkdmgniBBeDcO/8ZXvH
         CcnVWBayfnbT5XqyD9fw+8L7Nxe1lJAsfUdvM3qt+aJauW52jf7AWz9zdOzWdZhzUwLC
         Qc+WNNWr0lgPesmBNn8fIEi6vOK6LGU8/h2zY3e0YKdhPxeanNWy5xDWAu6GDcXqDwha
         7R8VVCHO+gfeX4LZpIhJ4lYb31UF/aZ6T0LyL8B9EzkAP1Ck2I+hyv0QqY+znyfKdKwp
         z0FZ2GPZDKLUVdmhwdwOnxOtcyXd/I9B968sAjxX1cqhYyhQ1S1Gx9Vk08dPlDV06VGS
         vpFQ==
X-Gm-Message-State: APjAAAXp1smBxAO1N9So/YBvguwA5ljYsdCazllxp1yGC68TWORk7TZV
        4D07jHI7VpEgdAkQYS7ZYiQ=
X-Google-Smtp-Source: APXvYqxLpvppITpqwpznGhoXST9yEXJiTxUooA40D6znKWWUb8zKhCb8lnntr0w6SDIGj3NP/ovI6A==
X-Received: by 2002:ae9:ebc3:: with SMTP id b186mr78092642qkg.222.1564497953291;
        Tue, 30 Jul 2019 07:45:53 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.104])
        by smtp.gmail.com with ESMTPSA id b1sm3981716qkk.8.2019.07.30.07.45.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 07:45:52 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EA87BC0AD9; Tue, 30 Jul 2019 11:45:49 -0300 (-03)
Date:   Tue, 30 Jul 2019 11:45:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qian Cai <cai@lca.pw>
Cc:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        David.Laight@aculab.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Message-ID: <20190730144549.GP6204@localhost.localdomain>
References: <1564497488-3030-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564497488-3030-1-git-send-email-cai@lca.pw>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 10:38:08AM -0400, Qian Cai wrote:
> In file included from ./include/linux/sctp.h:42,
>                  from net/core/skbuff.c:47:
> ./include/uapi/linux/sctp.h:395:1: warning: alignment 4 of 'struct
> sctp_paddr_change' is less than 8 [-Wpacked-not-aligned]
>  } __attribute__((packed, aligned(4)));
>  ^
> ./include/uapi/linux/sctp.h:728:1: warning: alignment 4 of 'struct
> sctp_setpeerprim' is less than 8 [-Wpacked-not-aligned]
>  } __attribute__((packed, aligned(4)));
>  ^
> ./include/uapi/linux/sctp.h:727:26: warning: 'sspp_addr' offset 4 in
> 'struct sctp_setpeerprim' isn't aligned to 8 [-Wpacked-not-aligned]
>   struct sockaddr_storage sspp_addr;
>                           ^~~~~~~~~
> ./include/uapi/linux/sctp.h:741:1: warning: alignment 4 of 'struct
> sctp_prim' is less than 8 [-Wpacked-not-aligned]
>  } __attribute__((packed, aligned(4)));
>  ^
> ./include/uapi/linux/sctp.h:740:26: warning: 'ssp_addr' offset 4 in
> 'struct sctp_prim' isn't aligned to 8 [-Wpacked-not-aligned]
>   struct sockaddr_storage ssp_addr;
>                           ^~~~~~~~
> ./include/uapi/linux/sctp.h:792:1: warning: alignment 4 of 'struct
> sctp_paddrparams' is less than 8 [-Wpacked-not-aligned]
>  } __attribute__((packed, aligned(4)));
>  ^
> ./include/uapi/linux/sctp.h:784:26: warning: 'spp_address' offset 4 in
> 'struct sctp_paddrparams' isn't aligned to 8 [-Wpacked-not-aligned]
>   struct sockaddr_storage spp_address;
>                           ^~~~~~~~~~~
> ./include/uapi/linux/sctp.h:905:1: warning: alignment 4 of 'struct
> sctp_paddrinfo' is less than 8 [-Wpacked-not-aligned]
>  } __attribute__((packed, aligned(4)));
>  ^
> ./include/uapi/linux/sctp.h:899:26: warning: 'spinfo_address' offset 4
> in 'struct sctp_paddrinfo' isn't aligned to 8 [-Wpacked-not-aligned]
>   struct sockaddr_storage spinfo_address;
>                           ^~~~~~~~~~~~~~
> 
> This is because the commit 20c9c825b12f ("[SCTP] Fix SCTP socket options
> to work with 32-bit apps on 64-bit kernels.") added "packed, aligned(4)"
> GCC attributes to some structures but one of the members, i.e, "struct
> sockaddr_storage" in those structures has the attribute,
> "aligned(__alignof__ (struct sockaddr *)" which is 8-byte on 64-bit
> systems, so the commit overwrites the designed alignments for
> "sockaddr_storage".
> 
> To fix this, "struct sockaddr_storage" needs to be aligned to 4-byte as
> it is only used in those packed sctp structure which is part of UAPI,
> and "struct __kernel_sockaddr_storage" is used in some other
> places of UAPI that need not to change alignments in order to not
> breaking userspace.
> 
> Use an implicit alignment for "struct __kernel_sockaddr_storage" so it
> can keep the same alignments as a member in both packed and un-packed
> structures without breaking UAPI.
> 
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
> 
> v2: Use an implicit alignment for "struct __kernel_sockaddr_storage".
> 
>  include/uapi/linux/socket.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 

SCTP-wise, LGTM.
