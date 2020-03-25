Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3C1192F90
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgCYRnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:43:24 -0400
Received: from mail-oi1-f170.google.com ([209.85.167.170]:34024 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgCYRnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:43:20 -0400
Received: by mail-oi1-f170.google.com with SMTP id e9so2921057oii.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 10:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EBuswx/VhY2g5nBAtpKZItk0ICDD3SnQNz8sS8cu6rg=;
        b=GQ1nQPzGeyq0Ynq3Fsl4poXloZ7294na994wubEonZvt04FhWqWZzsGCDB6gToLxaS
         gbxZ/kBggxpYYLVS7JMSUMwEexrdMvLSPbk/5eITV1OWgIS4U3l1FeBtGzgBYNNNRRxh
         Rh2jRp97lYBv/VnElZCVONwYKp5fYqoKKcyjKOc/nltSJ43RUB5ANuq3ucUH2BSM9uqM
         sH3NH1ICJvjkRAmdFcIQwYaKLP59BKtjaC9JrkNdKcJ1GL2ja+shbLBT4m1Q/mr8T8XO
         E3MAoBEwr48c024p/K32uABZyh1MH/9YpZdBJXPwV4wEgmNhwr5uf49kXzsqDmItdiin
         icUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBuswx/VhY2g5nBAtpKZItk0ICDD3SnQNz8sS8cu6rg=;
        b=r+zEnPM75l3c66nMYXuBb0cnakLm73EZc3z4Oc8q5RUnqGBv2qO/Wigty1/9WpsmFN
         7hgrpHl66qQ7szd0fLzoEQbSNByaVbW7eadzhcTsFoh0BaGqdCYiW1Yu4pjR6kLJFkT4
         urLzU3HiyAdnU9UHQ92dfTzCAkO+CCqOhuUiDj6sN1H4MU9R9406VHzkSZgVJIv0Mnt0
         boqaZkE2TkiNm7ilcEQEI31MZsd1+zu7PLsvGAGy4orLUZ9JCW73neoPoiuTZpQRTKqq
         e+/reVrCg14bnHwsRh4UtPX4lCjLxDUUxjXiXLlLyWWG8jrZlbGE7MSbg/W9eKqhWevk
         F6dw==
X-Gm-Message-State: ANhLgQ0OJ0x/EihCvtekCzA05A8NHTavLi2qNzLugcz0MzKW+o7Y+eQz
        s664W2WrTNQGrbJ1NfDNOLE8BzLxxBUrjJDl/hc=
X-Google-Smtp-Source: ADFU+vsj2hW/SY/9P58UCT5xevvngzZSVM0illp6dY4QoQ6hKVbDoxyFWSGdBHuJ0sXdnuplpg3XiExXgQyHdc0Lttk=
X-Received: by 2002:a05:6808:648:: with SMTP id z8mr3399019oih.72.1585158199705;
 Wed, 25 Mar 2020 10:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com> <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
In-Reply-To: <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 25 Mar 2020 10:43:08 -0700
Message-ID: <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000690aaa05a1b167bc"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000690aaa05a1b167bc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2020 at 4:28 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> On Tue, Mar 24, 2020 at 11:57 PM Cong Wang <xiyou.wangcong@gmail.com> wro=
te:
> > Hm, my bad, please also run `perf report -g` after you record them,
> > we need the text output with stack traces.
>
> No problem. I've created reports on two servers with different cards.
> See here https://github.com/zvalcav/tc-kernel/tree/master/20200325

That is great!

Your kernel log does not show anything useful, so it did not lead to
any kernel hang or crash etc. at all. (This also means you do not need
to try kdump.)

Are you able to test an experimental patch attached in this email?

It looks like your kernel spent too much time in fq_codel_reset(),
most of it are unnecessary as it is going to be destroyed right after
resetting.

Note: please do not judge the patch, it is merely for testing purpose.
It is obviously ugly and is only a proof of concept. A complete one
should be passing a boolean parameter down to each ->reset(),
but it would be much larger.

Thanks for testing!

--000000000000690aaa05a1b167bc
Content-Type: application/octet-stream; name="fq_codel_reset.diff"
Content-Disposition: attachment; filename="fq_codel_reset.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_k87m1hmx0>
X-Attachment-Id: f_k87m1hmx0

ZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9zY2hfZnFfY29kZWwuYyBiL25ldC9zY2hlZC9zY2hfZnFf
Y29kZWwuYwppbmRleCA5Njg1MTlmZjM2ZTkuLmRmNzgxZmQ0ZmY1NiAxMDA2NDQKLS0tIGEvbmV0
L3NjaGVkL3NjaF9mcV9jb2RlbC5jCisrKyBiL25ldC9zY2hlZC9zY2hfZnFfY29kZWwuYwpAQCAt
MzM3LDYgKzMzNywxNSBAQCBzdGF0aWMgdm9pZCBmcV9jb2RlbF9yZXNldChzdHJ1Y3QgUWRpc2Mg
KnNjaCkKIAlzdHJ1Y3QgZnFfY29kZWxfc2NoZWRfZGF0YSAqcSA9IHFkaXNjX3ByaXYoc2NoKTsK
IAlpbnQgaTsKIAorCWlmIChyZWZjb3VudF9yZWFkKCZzY2gtPnJlZmNudCkgPT0gMCkgeworCQlm
b3IgKGkgPSAwOyBpIDwgcS0+Zmxvd3NfY250OyBpKyspIHsKKwkJCXN0cnVjdCBmcV9jb2RlbF9m
bG93ICpmbG93ID0gcS0+Zmxvd3MgKyBpOworCisJCQlmcV9jb2RlbF9mbG93X3B1cmdlKGZsb3cp
OworCQl9CisJCXJldHVybjsKKwl9CisKIAlJTklUX0xJU1RfSEVBRCgmcS0+bmV3X2Zsb3dzKTsK
IAlJTklUX0xJU1RfSEVBRCgmcS0+b2xkX2Zsb3dzKTsKIAlmb3IgKGkgPSAwOyBpIDwgcS0+Zmxv
d3NfY250OyBpKyspIHsK
--000000000000690aaa05a1b167bc--
