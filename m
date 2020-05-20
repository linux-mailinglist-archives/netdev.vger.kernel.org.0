Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7291DBD48
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgETStW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETStW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:49:22 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77240C061A0E;
        Wed, 20 May 2020 11:49:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id n18so3982562wmj.5;
        Wed, 20 May 2020 11:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9MAZUaH2FpicdvVI3HcykUlAGlRNDh7OXyxReOax4TM=;
        b=r7zQmQSNU1Fo1td8Pe/7x/xmeyQTZotByhyQ+YR2sGFOX+XK1mWv6zLbGS9yiAbqKX
         W3yhBBrTZCDH2crFbO06NgMNkPYQi/gdUSJghnXgyh/46c43dq3tVyBHY3tlx25CuShI
         TFz77nWTFNazE3FJ0F77apYOLZrDPqLmxEhMcy1LjOJm2qSQX7w0RUdzIYckcV9UnfuG
         amT+0RiM1npCuo6NwH84rXTUrbYQULf2lk4L+l17iOt6rhvdFttdHu4O+LBSvtG1U1f/
         4J7DXaYbLzow59uykTpyPlzEUY97tLd0ZC3Jjqv7pBjOQLTgo0fHK767h6MVbH1RvQyb
         Begw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9MAZUaH2FpicdvVI3HcykUlAGlRNDh7OXyxReOax4TM=;
        b=p5v+NGeqgNjgbeydF60dam4dAr4BvqIBIpTSi2J+xB8wz0RaaodFeo3fmRCCCWmO/q
         cpQP04nn4kNvU6iY+uPMEmscUlPbtdaQFc4JXkZttTYUH1THaUbj7evGjlqF+lZhH433
         wzS0zHHDU+xyT6QoljDXen5HcanSO+nLSUjg0e3NRjfyVUgzcjDyt8VbAlUPT5+qLIko
         O5Y4WSjvx4/LZi/aQ2EaVudyCBCCoOmwkzrKOTUZ6X9AtnEq5ZoPsfM8UaTwnZcEpB0q
         9/pND4tSToFjPXZD2uA7nhk+4Cn1qCZzAxUNxoVi+7l6Y8SLk+CBtpyjBb+sLpOz6Hn6
         okDA==
X-Gm-Message-State: AOAM533NiEsany+bp9n1rXvTodcHHEdrGf0ZbsRWpq0NiN78ih2JbHrp
        44P5o2tlNew1gTEW04B5qHvJYXik300Ka5Y1L/w=
X-Google-Smtp-Source: ABdhPJxLkp2Xmd8sAvxhzriGAbPzwFmT1KKfc9VIbsXtX2tfnURnEVwfwFYrt1091BD4Y3W3QMHnigOJ5XKZPAFzGsI=
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr5686176wmm.107.1590000559656;
 Wed, 20 May 2020 11:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
 <20200520094742.337678-10-bjorn.topel@gmail.com> <20200520100342.620a0979@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520100342.620a0979@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 20 May 2020 20:49:08 +0200
Message-ID: <CAJ+HfNiy3YQmOEs0OzM+LLU6h0vM40gM7eHrVNoH_PFCOdtSZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 09/15] ice, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 at 19:03, Jakub Kicinski <kuba@kernel.org> wrote:
>
[...]
>
> patch 8 also has a warning I can't figure out.
>

Found and fixed. Thanks Jakub!


Bj=C3=B6rn
