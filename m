Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBEB2199FE
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 09:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgGIHc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 03:32:57 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39018 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgGIHc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 03:32:56 -0400
Received: by mail-ed1-f65.google.com with SMTP id d18so1023768edv.6;
        Thu, 09 Jul 2020 00:32:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j7DqbPSyBqq2qwNcdYTCxivolsap4LLnpECg1M+YJYk=;
        b=qZiNwlyRJ57VPjR+dosZ69Gym7GNS4FukUdkgaYsGriBesMWF22pXa3pVLiOfXPOJQ
         tqPklsHrjCnY4xSsVGStmBcWYDca3eRq3xqpWrLoLZuZkxUTIRZSAS5SVCN/jt7UBvfC
         JWkPCkrp2b7mAm7VCHEy3g5i2dU2f5qBGCOYds9I/9NHL+mxbckjgBUxczwV44RdlwiX
         VuOd4cuKP7tVGADCX94TArCvW7SI+nzGX6N/nbOwRfqgA+xd2Rvlyo+rGQW756j6YjI8
         RNUMh0ewYcb483hIjKyOB8jrUfNHW6gpl6RZ6jCN72lxM9HmtY9eqJ4CJ1sZY+/I4NUG
         Tx/Q==
X-Gm-Message-State: AOAM531GEd/SInI4qyhu3bABdWnHgQNCsywdZCeke95PuT+Mo+P9zEBG
        EuYDAHLIhUr+a0PVB8zlGxQ=
X-Google-Smtp-Source: ABdhPJwrkOg1VmskPen0ndAgGUffYWkrKR783vprCdOePKnp0T8h/KXoPOC3hmTqCSglRRVLLvqDkw==
X-Received: by 2002:a50:d8c2:: with SMTP id y2mr62468108edj.114.1594279973653;
        Thu, 09 Jul 2020 00:32:53 -0700 (PDT)
Received: from kozik-lap ([194.230.155.195])
        by smtp.googlemail.com with ESMTPSA id sa10sm1258696ejb.79.2020.07.09.00.32.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 Jul 2020 00:32:52 -0700 (PDT)
Date:   Thu, 9 Jul 2020 09:32:49 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 1/4] iomap: Constify ioreadX() iomem argument (as in
 generic implementation)
Message-ID: <20200709073249.GA6335@kozik-lap>
References: <20200709072837.5869-1-krzk@kernel.org>
 <20200709072837.5869-2-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200709072837.5869-2-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 09:28:34AM +0200, Krzysztof Kozlowski wrote:
> The ioreadX() and ioreadX_rep() helpers have inconsistent interface.  On
> some architectures void *__iomem address argument is a pointer to const,
> on some not.
> 
> Implementations of ioreadX() do not modify the memory under the address
> so they can be converted to a "const" version for const-safety and
> consistency among architectures.
> 
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I forgot to put here one more Ack, for PowerPC:
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

https://lore.kernel.org/lkml/87ftedj0zz.fsf@mpe.ellerman.id.au/

Best regards,
Krzysztof

