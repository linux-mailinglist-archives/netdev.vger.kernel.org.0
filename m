Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E016326B2C
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 03:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhB0Crz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 21:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhB0Cry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 21:47:54 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E1DC06174A;
        Fri, 26 Feb 2021 18:47:13 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id k12so3825753ljg.9;
        Fri, 26 Feb 2021 18:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=CpsQVQE1mHS5xfIguujwlhwRqKuGkg7MjVvds/uqdUk=;
        b=MfC5QpgWU5xYWyZpMyKaVoEnQtRUqv6RUwinfQ6NMmC2QtfBwb9mzS/U82n1V34dHJ
         8f27Onx1/ZqNvMx9zxjJL4WwWvynTWVFlSYsQ3FH07i8ipQsfrF4sb60CnrAt8u15eTY
         zqvreRwwUawZuGucYKBVfsE7I7Az/zwSpu3YQLp0QbHV7GVJJOd6inw542jeYE8HJDDE
         QkmIWpNCSSbn+i8ppQtBZ1iAHnZdNxKdU2HovyFCkXvoHzwh41p+V0VFBygjpe9+J+xW
         efEA4MPJG/pmke766dKZWoS7Mh8HKjruiV9rwCXraqXHft0T/FYACZ1PcwL17X/ImLQR
         pddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=CpsQVQE1mHS5xfIguujwlhwRqKuGkg7MjVvds/uqdUk=;
        b=VfpfE/YdMiB+G+JnfpXULBWuWTHIwC1awf2vFU3yMeqzQx7s3yuzYS27EWC0hkC+av
         ka/lkskjkOqdIEj/fzaWFIEY8CyahPSps2ybZXNgIBH3uF5z8txGRdIMuigdxVFDlDnq
         gdH3a4trs4HtJs5ACyykcJ+CgBTMCb14HN8zdqKMhJApQBCOEZ/d5EZ2z4dFamFRKlGH
         mUM/+B7cui/iKLXNlxRHtZCsHSPc2WQpNmOceaA/XDaC0Q1tl/El26qxzqqTSEGuXchH
         WNjBs8aewAd1rmcdvu/k+wpNJHwpPxpPU6dDWEPx0ywdILplITzjIhqeBYrQqiowARL7
         lPHg==
X-Gm-Message-State: AOAM531g5ocK0Re7NsCyAiS8wMfCCKlKj4jiAfvUCvIWm3GA1rDwC28u
        G1HcsSuSXc+PVi1fzeP7c4Q6rGMKqPLTLtNAmmU=
X-Google-Smtp-Source: ABdhPJwCdmfbIEjyV8vZQuJFNldslom9kchlRXyueoLYNXb98zZwnkoNykgaqpOy1S5zE4oaqC5ZGdh4+ptbAkgvy20=
X-Received: by 2002:a2e:964e:: with SMTP id z14mr3305724ljh.204.1614394031938;
 Fri, 26 Feb 2021 18:47:11 -0800 (PST)
MIME-Version: 1.0
References: <CAADnVQLfu8L06R96fHV9-7055yVwVQe=7vrHeHkTxN4tuqyCsw@mail.gmail.com>
In-Reply-To: <CAADnVQLfu8L06R96fHV9-7055yVwVQe=7vrHeHkTxN4tuqyCsw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Feb 2021 18:47:00 -0800
Message-ID: <CAADnVQJaHQ+5seWm8TO5b1KXZi=1TdWn8Y89Fgz7KxFNV2Jw3A@mail.gmail.com>
Subject: Re: sk_lookup + test_bprm = huge delay
To:     KP Singh <kpsingh@google.com>, Lorenz Bauer <lmb@cloudflare.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 5:59 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Crazy ideas are welcome :)

So it was my .bashrc.
Something in it was causing a delay.
I've added this line to choke it for non-interactive shell:
[ -z "$PS1" ] && return
