Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60BCD13A086
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 06:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgANFYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 00:24:04 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40233 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgANFYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 00:24:03 -0500
Received: by mail-lj1-f194.google.com with SMTP id u1so12810929ljk.7;
        Mon, 13 Jan 2020 21:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xOe8cEwY/+ggWSrDf4teIOpCv6NdYHvbvkF1XKTEocs=;
        b=LOtEzdzO4P0gGkSt2/IoHR9VPfhIc06dybg249hC4fdFHKqGeaO8YxYjcto8GZcco6
         HX2osGkURrzyuWIDMmPjKH6D5ziJteWrS8nP6g8cIpsmxO3g6xKeyta0lNcLNXqImGgD
         C61+M2tHogtE/Tl8QJKImmlO9aOGwRqlrM74DKpVkzILRUlW2Xd3NWS6eUv1BHk1+oxv
         6Nz/uoqwbBG4FLBT0+T4Qdp3BXsK2hZReGH8l838Wpi3S4hKpZI+O6PN3yd+BgnhdqGt
         70U3ZQqzxQXRssZfvaI+neH8/KYxh+qMbdUQS85U95UhbJwfqdQbTlh4qpLZ9gE8FNO/
         Mnog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xOe8cEwY/+ggWSrDf4teIOpCv6NdYHvbvkF1XKTEocs=;
        b=Q8eDO77pETAyZ5dNyBs0evbD+ZGsOWpADSCg4uQMl3tZNOfdlDB2ChnXbEMNwSLUW5
         xLn6M8JqgrPNHD/4ScpbJKioGZzvJgSFXPfUOF2WrmG4/jSrG6CHwP1NG0I5v7LUG5XX
         VKwznSaY2cePVU8ykwSzZ1wQF3+m3Z2OV+RFBk6kkfb2UMs1Oz42PkMRH4ISK+GVxfF2
         9+ZdevaC+KKBUA4B/BC71fgNAfTr+WkKyVplubxUxMzkPH4Keku/rnJF8I59Dsi0ZYD6
         SDWNZLNyzu/Cil2rVL2kePYJ50+RXh+hfnCDswQYBvf02BK0HDTeEB2tSGuNXXAimFfS
         Uxhw==
X-Gm-Message-State: APjAAAXl43d0NEDHzMjnkgviIAiptTfUABSRdQ1popCKxkG5D1htywna
        /hq/xL0ztfyVqQkhocJJJOe2l+MgucIXapAU8ZI=
X-Google-Smtp-Source: APXvYqwLRjvJGcaSQN7MdhbIG50V/jBBlGzk43plCv5NgKLK461rA5mo+qyywlltVwtQwDPfSOV1dXQ6+y5OCmX7tEU=
X-Received: by 2002:a2e:884d:: with SMTP id z13mr13271564ljj.116.1578979441504;
 Mon, 13 Jan 2020 21:24:01 -0800 (PST)
MIME-Version: 1.0
References: <a367af4d-7267-2e94-74dc-2a2aac204080@ghiti.fr>
 <20191018105657.4584ec67@canb.auug.org.au> <20191028110257.6d6dba6e@canb.auug.org.au>
 <mhng-0daa1a90-2bed-4b2e-833e-02cd9c0aa73f@palmerdabbelt-glaptop>
 <d5d59f54-e391-3659-d4c0-eada50f88187@ghiti.fr> <CANXhq0pn+Nq6T5dNyJiB6xvmqTnPSzo8sVfqHhGyWUURY+1ydg@mail.gmail.com>
In-Reply-To: <CANXhq0pn+Nq6T5dNyJiB6xvmqTnPSzo8sVfqHhGyWUURY+1ydg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Jan 2020 21:23:50 -0800
Message-ID: <CAADnVQ+kbxpw7fxRZodTtE7AmEmRDgO9fcmMD8kKRssS8WJizA@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Zong Li <zong.li@sifive.com>
Cc:     Alexandre Ghiti <alexandre@ghiti.fr>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 12, 2020 at 8:33 PM Zong Li <zong.li@sifive.com> wrote:
>
> I'm not quite familiar with btf, so I have no idea why there are two
> weak symbols be added in 8580ac9404f6 ("bpf: Process in-kernel BTF")

I can explain what these weak symbols are for, but that won't change
the fact that compiler or linker are buggy. The weak symbols should work
in all cases and compiler should pick correct relocation.
In this case it sounds that compiler picked relative relocation and failed
to reach zero from that address.
