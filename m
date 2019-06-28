Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480CC5A2B2
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfF1Rst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:48:49 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:38949 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF1Rst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:48:49 -0400
Received: by mail-lj1-f181.google.com with SMTP id v18so6805634ljh.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PRw08HLxNyoBCuJSeyl7dQOkr8umpTCXomJ68E4Im7M=;
        b=Sm3FAvhXbc+UXLu1IX81ePi8LkNSUKxYLiLouPSfFncQX/jGKhbVMqAPvp5Eo1WmWd
         WgNJ1tEFzdixsxtxxqbygk0hVKS/OWlIz+AFRMShERE86khyVZqbn88cwJ9PmehqmUg5
         Hwuti9ZqbM2OYaVSw6hanTPqgL0fqOhIvyYIW6fjNpNrFoNImmWsdi9g4gt8ot3jymf7
         5LQUNMR3muMnWG/PcHPw6l5qAGN0eK1JbAcNwnWHNGG4pzOane658TZMk9fFc07VkRqa
         XAB1NU3AkOVXo4umGPDGD5Ixy/n0D7laIAKLCtYdxotWuBRH3uNFRi3Un0Rb+nnojvQI
         emtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PRw08HLxNyoBCuJSeyl7dQOkr8umpTCXomJ68E4Im7M=;
        b=oibn1VBjNrjArRmExiL5GX0ytjgb66SpWtZI+uGBbp0TBCsuwXkfzvKk05mKj9f6z3
         77+V3m3cBwQhjqeqYXv0zKIefa0redf/Xfx/XgKfm2huXZtIEks3x2uvqZCpIXmpldx8
         +2aLSE44LgMYm5Sd9rhIoFOSkTNcF31JvyqmAMG51prveWlpTT0Ig4rmFRZWomDIRKdD
         /8l3Oo4C8Hw5GPEtkLrpVq1xk6ufdVRk9t7mQz6DYBFpEOcY+EJ5dAABGNKSn3Bq6q09
         tfyPBYQ6KaK3lLo8KvZojcMbQCpS+7AJ+8s5FLLSzg7JIZ+ssVTaSNgvk1ezhro4KxCM
         dHyg==
X-Gm-Message-State: APjAAAU4kNQ54FOzsiAa6443WlJhz2LJMSXxQmj5K+TZQ7KWY8c+smKy
        mucghyzsl+79yWwBcVi27HcUysdUw3mL5BsTXyRZww==
X-Google-Smtp-Source: APXvYqwW/dH/Dp8XB5r+DcyW+PZs57rlSLjHN/1UR8dpFxyi1nqDOGaA3gV6n8BbAX6+UHCsHlNCA5pjmlyup+5ZLi0=
X-Received: by 2002:a2e:970d:: with SMTP id r13mr6895649lji.126.1561744126640;
 Fri, 28 Jun 2019 10:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190626185251.205687-1-csully@google.com> <20190626185251.205687-3-csully@google.com>
 <20190626.124917.1144578915345631665.davem@davemloft.net>
In-Reply-To: <20190626.124917.1144578915345631665.davem@davemloft.net>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 28 Jun 2019 10:48:35 -0700
Message-ID: <CAH_-1qwCjsH_Q7pXzKvPPgRYZZuk5XcWsh+9CRnfvQHtCh=gvQ@mail.gmail.com>
Subject: Re: [net-next 2/4] gve: Add transmit and receive support
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 12:49 PM David Miller <davem@davemloft.net> wrote:
>
> From: Catherine Sullivan <csully@google.com>
> Date: Wed, 26 Jun 2019 11:52:49 -0700
>
> > +#ifdef __LITTLE_ENDIAN
> > +#define GVE_SEQNO(x) ((((__force u16)x) >> 8) & 0x7)
> > +#else
> > +#define      GVE_SEQNO(x) ((__force u16)(x) & 0x7)
> > +#endif
>
> This can be simply "le16_to_cpu(x) & 0x7" or similar.  No need to
> messy ifdefs.
>

Will fix in v2.
