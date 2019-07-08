Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241FD62AF1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405214AbfGHVZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:25:58 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33973 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbfGHVZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:25:57 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so14504149qkt.1;
        Mon, 08 Jul 2019 14:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YdeqtZytdEyqoIG26b8RfEFGIJ1HXoW9pGi40CoP3hY=;
        b=rWWOnVX/gGIKyfUtaGpmot+HNvA3cWtH0kVO0h4nl6tXbcIquARDq4K26S34Z+yLSt
         KEymIIbwKOsR2MSPrTptFunTkS886ieLQW8eLX4xHg4NImEfiwT9bZ/2qohqwFF/l2Lr
         ayJvIuw6+8NpOTb6k0WbGIy/YCs/BHvl2cDlDYf9A74AylUKTwivq2or6XJpYn4UHJih
         6qf5VXPpM9Iy8rffFKoXRWB04wHiXVNE8HC5XIlzb7ovwrP7Gjc6Sce3Z50iit7CDHVu
         rRCyn8hXPB7LGtdY/BUIJHdfKtA31poSQtFyzaDW81y0biywXp/wAE1SLCQqu4gP9Pku
         7Rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YdeqtZytdEyqoIG26b8RfEFGIJ1HXoW9pGi40CoP3hY=;
        b=scBuc1+xmHvWbbDJ/BDG6a6c/dmzdepPZHhaOXoF/t9WfI62d3bbO0VpL9y+YdNZQl
         d0z9nYMCqWPHQ361TDps0izE53nytbLPY2gwjYZXkidVhhl8q+WM/LHwNNhbHg87r6VK
         uQdC+GsELLpw7FpMaie8hpRSirYFT/BIN4x5ZPBaHCK0zL6zE2Kenwh2I/qwA3frdkZz
         gwK977gmvn+4BRSNC/GfyZL/Lkgfv0d8JdLRZtV1Nsz29bzKgOzVqC6aAWj05H8TKyvP
         QNEkBhMl6iZkJU2oa7zjnOo4D+cW9AHFCjEh8YXf2VilSARGz+C/QyGn6ZP6nJm6A5nO
         GJxA==
X-Gm-Message-State: APjAAAUZid8i28aEvFuSF7obdHZYDWF2BOE+5CQpf9Z4vkkTOOMRE1jW
        9IkcYNa7g+loTTAlZkj9ZRH1vQ54hMf01Rx6dtY=
X-Google-Smtp-Source: APXvYqwulGSqlqNeD6kh5CTROsEPVi3dGZ1cSE/R5NXoTMe6Mr8ScvM8gHkHmsWbgHbuNefYNtUh9BpV/qdomz9XXbw=
X-Received: by 2002:ae9:de05:: with SMTP id s5mr13692127qkf.184.1562621156638;
 Mon, 08 Jul 2019 14:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
 <20190704142503.23501-1-i.maximets@samsung.com> <CAJ+HfNi2EdLwtq9SfccZBymDMv_cW5+vxB-JLqxyvYS_TG3ScA@mail.gmail.com>
In-Reply-To: <CAJ+HfNi2EdLwtq9SfccZBymDMv_cW5+vxB-JLqxyvYS_TG3ScA@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 8 Jul 2019 14:25:20 -0700
Message-ID: <CALDO+SYaR+txmTq_xhaw1cD4v7svtE7BD3mOsBx-X=MEVeZzzA@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: fix possible cq entry leak
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Ilya Maximets <i.maximets@samsung.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 11:49 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Thu, 4 Jul 2019 at 16:25, Ilya Maximets <i.maximets@samsung.com> wrote=
:
> >
> > Completion queue address reservation could not be undone.
> > In case of bad 'queue_id' or skb allocation failure, reserved entry
> > will be leaked reducing the total capacity of completion queue.
> >
> > Fix that by moving reservation to the point where failure is not
> > possible. Additionally, 'queue_id' checking moved out from the loop
> > since there is no point to check it there.
> >
>
> Good catch, Ilya! Thanks for the patch!
>
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
Thanks
Tested-by: William Tu <u9012063@gmail.com>
