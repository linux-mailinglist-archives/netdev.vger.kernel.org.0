Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332AB196800
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 18:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgC1RPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 13:15:45 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38569 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgC1RPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 13:15:44 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so13442194ljh.5;
        Sat, 28 Mar 2020 10:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7exri8zrodsXC4FlGnPp6owqK68HPJA0l5YKpA/BVCo=;
        b=GyR45Q3XZZUq2E9F0kKki+IuMI5yicC5lgNFwERNkQz0Fbzugi5P+Di9eyswpUCE9h
         Lxb7npOC+cXaYfo52sjglX+12R2iWj2ZoeOAo/z7yG4GgMAY5fyw+HBxQZweqU942ykA
         lOV7dUJbJaBog3nrK9hiyNFQvaby8WERd+oo3SsmqIQx+nhdXoy7DORUOK6KGZagshkw
         b2xWNHbsApNpyyIeAZO3PCIQKPddZIalVQzetmBr2Uo/afM830auEmnCgOFiueVtmVRu
         OlrejOttAYmdpqkkhSoSo3mQrnxHiF/WPZZ8b3zG2PjumORkk8IDdk1is3VOI9wrARHV
         MCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7exri8zrodsXC4FlGnPp6owqK68HPJA0l5YKpA/BVCo=;
        b=J+D/k6BUQM31Yunr/6B8OnTBudeosxjQkkzB75nBV0lUWOogXxuxCFrm0RNR6wjkTI
         FahRN+hestaEI+AuGrmuwQhIrTLbNj2ahL9KXElDKQAZJXYvtGbArQphEAAliY81GJQ9
         +Rash7lS6kw9hCCOBURWQvZfoG4uNQnh7LMvwzLNxcwesSvJBxip92puMw8EJED5ISzv
         K4EiL0q57ZsBnbcAI5DhucQ/9CWZWa3gjxgdsWtMcCizgG3xSszRWrlzFNHeFIqOXPrn
         cB/c7qLRDHzTpXO9+uD8MLn5zS+xVoGDiOlqkvC4aOVSpJZCwHlBkNqTLXdwH+XBU+D/
         sJiw==
X-Gm-Message-State: AGi0PuZd+3wgDOF4LE0AXWpyG4l1ebfllLv2g7vTjK7GXbeV6PPnA7Yr
        K9ADCwNMfdMHYx56Qe4y1Lu189bMeyHEPwcZyzM=
X-Google-Smtp-Source: APiQypLRqvVrummPMpgy91IdjOEYjOgFZpq4qdE6UOaQCTLbTnpKGkgQiDGai0RymrhxccmMKhab1dqm2KkwhIGH4UI=
X-Received: by 2002:a2e:988c:: with SMTP id b12mr2704094ljj.138.1585415741617;
 Sat, 28 Mar 2020 10:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <202003281643.02SGhPH7029961@sdf.org>
In-Reply-To: <202003281643.02SGhPH7029961@sdf.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 28 Mar 2020 10:15:29 -0700
Message-ID: <CAADnVQLA4GHShQp7=zEgkpvKiUY65Gsr2Mso2ivCnTqPbQtY8g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 47/50] kernel/bpf/core.c: Use get_random_max32()
To:     George Spelvin <lkml@sdf.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 9:46 AM George Spelvin <lkml@sdf.org> wrote:
>
> Smaller, faster, and a smidge more uniform than %.
>
> Signed-off-by: George Spelvin <lkml@sdf.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: bpf@vger.kernel.org
> Cc: netdev@vger.kernel.org

If Linus is going to pick up the whole set at once:
Acked-by: Alexei Starovoitov <ast@kernel.org>
