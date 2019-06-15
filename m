Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC74B46D18
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 02:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfFOAEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 20:04:47 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43705 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFOAEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 20:04:47 -0400
Received: by mail-lf1-f65.google.com with SMTP id j29so2809371lfk.10
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 17:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RUc6aybVSmfgt+Ryn6DHj05g9oP7kpQC3F+3kYf5eCo=;
        b=Dg09vgPKDdjNcvltoNBK87TgfbvZARVpMn+NSf0ZB3yKiCchPRQq2HwkGZ9zcAP1SP
         9mWvsJYPdHELiIZuNtyYG+LV2tC2KCbRqXtmLjO+AKl+SO24/HImdl1GRmm+NOkzbGrf
         4fiUBIfofEngPQmumqmxhZnZLl4U1P51Bo8udahkkXj4K5sSxx7vdooG8REuy1umSMuW
         tPiTjZLURtWQ0lWkTQ2LwKx1whdEvRWJ8KpsmqmTfvhzFnuYmIwqhfDIlB62ntNLC8n0
         9h46vJ/znSeletBHrb+3n5ftOSieIcO6D7mxiEl6NHmt1cwVGAFUx6K3EV7vJXMgUUU6
         Ga0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RUc6aybVSmfgt+Ryn6DHj05g9oP7kpQC3F+3kYf5eCo=;
        b=FVDKI5XZY5XRvlBpKYFsR/un5OeiSJQSvBsbMqiGPigxd9JEU6rULiarQIjQJVg1H1
         XMeeVmNE5PZbK1FwhgLJEKT76Zg15cOeK4g/kG5r/QhKr2VBLbGo0fDmjTaSJvI/A4bB
         zz0/HV8ZuqZ0yKmlJbTbwIT4/TWutcNyQazXEaBormtZ6mFE8xvvy4VI19/9emxRBOkr
         sAgUBn04QYn3PJAdisBz5a23ZmNFj3Q9y+U/iWA783Xq0PTh8pKlL4wmdQluhnpy7NhT
         G4b3/Rdu+iXOfbcFSaBhtLw2wnwqc3x/oIg+USqNWIlPIq8jOaFYAPZ5cA9TR+F/t4Dx
         7Ofg==
X-Gm-Message-State: APjAAAXgYFgjQRGqtSsP4pzSU0jxU3oDiEdxaxGh4Sl9Z+r9Hy4Sy7Pv
        wrKohZhpN9R6JE/d81XwxkWr0B/YZZz6qSSgFss=
X-Google-Smtp-Source: APXvYqyNrXV3lWblsk44w3RzkGD3Eq/GDe06fCy801fYdaMaoxJu2/XJe8gxz4szEmyBhjWx/JwDV3AI1hq42Ui5MG4=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr11525522lfe.6.1560557085297;
 Fri, 14 Jun 2019 17:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190614232221.248392-1-edumazet@google.com> <20190614232221.248392-2-edumazet@google.com>
 <20190614234506.n3kuojutoaqxhyox@ast-mbp.dhcp.thefacebook.com> <a98fd64c-48b4-d008-d563-24cea01822d2@gmail.com>
In-Reply-To: <a98fd64c-48b4-d008-d563-24cea01822d2@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 17:04:33 -0700
Message-ID: <CAADnVQJKpTJitoPernxEHP+R0tMAqwdOuDMcQAszu-ZM4D9Oow@mail.gmail.com>
Subject: Re: [PATCH net 1/4] sysctl: define proc_do_static_key()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:55 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 6/14/19 4:45 PM, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 04:22:18PM -0700, Eric Dumazet wrote:
>
> > maxlen is ignored by proc_do_static_key(), right?
>
> That is right, I was not sure putting a zero or sizeof(int)
> would make sense here.
>
> Using sizeof(...key) is consistent with other sysctls,

yes. that makes sense. I was just curious whether I missed something.

> even of proc_do_static_key() uses a temporary structure and
> a temporary integer in its current implementation.

yep.
Acked-by: Alexei Starovoitov <ast@kernel.org>
