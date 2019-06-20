Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57164D242
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfFTPhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:37:15 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39554 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfFTPhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:37:15 -0400
Received: by mail-lj1-f195.google.com with SMTP id v18so3133080ljh.6;
        Thu, 20 Jun 2019 08:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sdFhQUOmy0HUAK5VEgiFaGF1/IYr6NuyuE67mdG7njg=;
        b=fn5YZ4i8JYfgEW/htWLS9IPeR0JzfnFjzhT1gsxJf9+dDPvqeh+hpVdv7lpNAaJcGM
         MQBdidhg56n22SRHF2wt2Q1q9ICjoNWcHfCPw55QkB1jRqAXc0p0t0u1Ph1XdC+mZD+i
         JwgCHU7IzLWn2+jM/83rxbapJnnOnuVUv8OkGFPHOyrBZClKr/EWcGMfKaFsFo0gsBnW
         tO2O/hQn5Zt7/+X3EZ3l+5oD+aJ3Op2A/Zu+Nivt+swkFUAZTNo2KSpLjbeNXokh9GbH
         HMYKov+FHouZ4rv5Qc2jv/hdeV2qSFOKfVmI47x3Tm+EcW4AnqaddEG9UmrcKI1F0YQl
         Tkcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdFhQUOmy0HUAK5VEgiFaGF1/IYr6NuyuE67mdG7njg=;
        b=Vt2kopjSQBKg6NS71xIEeGPoOhY20eEeaCA2ay7XgTq5U8ETTIwuyC4EKI/7vRFv+M
         8LKJUpYQSrrSUjd85EcgnUPpVSZEQzTHHKREajOZloDij9+pO/dz5VwI+FLIcvenh/1T
         x+Op2ZXXalQjOemxhKNG+4oeqhXTioiFCx9Pd9Cmwy9YFeJykuzH0m6dEw2yGS+zRuoQ
         PueqIN96lxPIz1rN4jk0yx1V4XuOc9bI2s5J3bhvBl2eUt6ttdA9LvfIiiKpaYr80pT1
         CLSGi8iJ/im+o3NMGw6jma1stxthHVCHqPVUFpPGBemvB3kgizif96zA1XJkWtJshA2O
         l4Og==
X-Gm-Message-State: APjAAAUuxzZm1lJEXF95QERZu2xqoVS8BQjDjMhjKUFyH5a2S68544QY
        qYzDa89RVIUFscEXf8036o5WxA1lMU0zSXOPxKM=
X-Google-Smtp-Source: APXvYqzswEM46HvJ9q00SI3Pbqvu7kkgprJoqkGjWIGakUNmc4JZyLCnYieYrkq8hZ1yNVxSXNUVi/BM/Sqppa0EwmE=
X-Received: by 2002:a2e:94c9:: with SMTP id r9mr23364870ljh.210.1561045033229;
 Thu, 20 Jun 2019 08:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190615191225.2409862-1-ast@kernel.org> <20190615191225.2409862-2-ast@kernel.org>
 <5d0ad24027106_8822adea29a05b47c@john-XPS-13-9370.notmuch>
 <20190620033538.4oou4mbck6xs64mj@ast-mbp.dhcp.thefacebook.com> <5d0b13c990eaa_21bb2acd7a54c5b4a0@john-XPS-13-9370.notmuch>
In-Reply-To: <5d0b13c990eaa_21bb2acd7a54c5b4a0@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Jun 2019 08:37:00 -0700
Message-ID: <CAADnVQ+dA1+KH=vDzEW7idVH5Lsgrcwy+GjuzX-bNTYV4nDt7A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/9] bpf: track spill/fill of constants
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 10:04 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> working my way through the series now, but for this patch
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Thanks a lot for review!
It's landed now, but if you find anything I'll send
follow up patches.
Which I plan to do anyway for few things in backtracking logic.
