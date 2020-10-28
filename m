Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C87229E1CA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgJ2CDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbgJ1VsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:48:02 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4731C0613CF;
        Wed, 28 Oct 2020 14:48:02 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f16so1035472ilr.0;
        Wed, 28 Oct 2020 14:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjoE+tzypCEtS7yiBCk3OWZo4ySiRdknqbsS3rd6Koo=;
        b=UA74odV1u8y9zCYz8HDLWk1kqif5HPQIVEIyAElhXPzDJj9YaPWe4yr54HQr9E6Fv0
         J3c0cYVoGqVIJQ2R3Vxq/kN5+/VreCwqrOqFohd3rJmmCoOB9cP/f+m2yybD7Flz9JBT
         xIElODi0UXPVftikztKD4fWKvoYbOcM7v87wa0hKc6dLfjZErPRogYrzJBf6LaPVr3L5
         PF3zHCe7JLLdHImOH7wrMxQFripMSw3h5auobKKdB3FmQoddNeKBE7kyEi4i463AYlLy
         lgllkUyQePNsGRkQrKicWTWP+tJLU6J6YE93Ueji/PTnjFN8u/PxH5QvE1iu6jpZRQRh
         QU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjoE+tzypCEtS7yiBCk3OWZo4ySiRdknqbsS3rd6Koo=;
        b=XbV0grSU3y14vWqJdIE1A7aXnBz3FBP03C1JNugsnKd8vZoRZwZtxMjR1rFisO0QWv
         DG5Q+TdV1svW6oDWTZbteoguesh3zsoQkrfBpf/deAedEcVqZJfDip1+WEbHulkNeQK2
         GVIVIcbnh+l+EtTBNjOJG81jipyvTaz5J4pbmaW+36n99UiG8ElcFOBQ4tMIQRuriKcz
         uBB1Mra+rHs/puvIMcF2YQoVUs7TATZs4rAbKm1GastlW7c8IXAqe6jsyVCi4wzxT2Fh
         k0UFNhATijk6lUCp+DAtqG/m0eq96BT1+fgqf3FjBmG9rKytk3PuNCpJ05zNrPAuHrAA
         +UjA==
X-Gm-Message-State: AOAM533hOYKcKnyE0qM737dz0n6F4KSIpPG4qGcIUHo7cXbc5/TAfZK1
        sXgQlGkc/3tSxqNb7NMnKgUbKLzl/tvx1HKrRzCtIR2X5rk=
X-Google-Smtp-Source: ABdhPJx89Xd2UyzBIE/BtAh/GE0S0/apcl6iinS8R0TCmPHKH3LmYPResJ+6KSqnAAInNXLPnW7Op7VYju4zPQ1NZtc=
X-Received: by 2002:a05:6e02:ea8:: with SMTP id u8mr132042ilj.305.1603907261705;
 Wed, 28 Oct 2020 10:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com> <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <CAP12E-+3DY-dgzVercKc-NYGPExWO1NjTOr1Gf3tPLKvp6O6+g@mail.gmail.com> <AE096F70-4419-4A67-937A-7741FBDA6668@akamai.com>
In-Reply-To: <AE096F70-4419-4A67-937A-7741FBDA6668@akamai.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 28 Oct 2020 10:47:30 -0700
Message-ID: <CAM_iQpX0XzNDCzc2U5=g6aU-HGYs3oryHx=rmM3ue9sH=Jd4Gw@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     "Pai, Vishwanath" <vpai@akamai.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "Hunt, Joshua" <johunt@akamai.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 8:37 AM Pai, Vishwanath <vpai@akamai.com> wrote:
> Hi,
>
> We noticed some problems when testing the latest 5.4 LTS kernel and traced it
> back to this commit using git bisect. When running our tests the machine stops
> responding to all traffic and the only way to recover is a reboot. I do not see
> a stack trace on the console.

Do you mean the machine is still running fine just the network is down?

If so, can you dump your tc config with stats when the problem is happening?
(You can use `tc -s -d qd show ...`.)

>
> This can be reproduced using the packetdrill test below, it should be run a
> few times or in a loop. You should hit this issue within a few tries but
> sometimes might take up to 15-20 tries.
...
> I can reproduce the issue easily on v5.4.68, and after reverting this commit it
> does not happen anymore.

This is odd. The patch in this thread touches netdev reset path, if packetdrill
is the only thing you use to trigger the bug (that is netdev is always active),
I can not connect them.

Thanks.
