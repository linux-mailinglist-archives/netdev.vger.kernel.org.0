Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6EE145E65
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAVWKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:10:07 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41150 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVWKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:10:07 -0500
Received: by mail-oi1-f194.google.com with SMTP id i1so969362oie.8;
        Wed, 22 Jan 2020 14:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tzE/usQUC+/qHervq9qIJkerRx4RijErGd72FUWsdgM=;
        b=gtZOmaZSaQA1RT0gYAY3tpH2TX8tqCQrvkx0lHqwRJqlYa9AUwawy8ZprbPbfwpvsG
         6rakUY0G3Vkv8cHjk1tshjNXUrlLZ4cvEtrK8AhoQmRCk+v00Mtcd+55QW8dAssRccah
         D0gdYwfGpTQSMeXo3ynX2P4ZzxinEJfasyaKk3p8mjZKFEDwxgvE5kjBzjlSG5E7eGw3
         wo72JBSn+hFrMQTjT8P9HN7M7U7q/LbR7hn054GnIkawXrCXbzDwsKai2wV7rz9f1tw/
         cGIJJw9I9s0fzWGdQcJuxzN7xkjjJWSSTM1lkGW1wWMugV9OLR6sv/xWf/1xUDL/RvRo
         fKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tzE/usQUC+/qHervq9qIJkerRx4RijErGd72FUWsdgM=;
        b=AOj5mmawQsZ5Ynn9bSh2uY9fvh3s4hTGD+m8mIZFPolHEGrueUI0fS3uJlxNsB1Aqi
         C5omgYQsPRcvBGnZFZVW8V+QBOUJZFCHJvzdpYZR7gdyQ4oJqrKJVD/syemajHIe+VnL
         ciK9WkP479WwLfixvrem/vUOGU8eEDoMU3V2JQ+WTOMSZxwSAW6eV1newlsxXxvExry0
         k4KmiE/1BuFTVOrBYODxbkAqedtcN9/bte+KXKX0hVi9go3kD7XoRg1iQh34Ue+EpVw4
         4lgInSqHkWxBknGKLPolB6CvGNMYQ0pMmp8JQ533LDzLMkTj7hv1W0or8COr9OH+nFjy
         wQQQ==
X-Gm-Message-State: APjAAAUfGCXCM7CEuyATlO0j2NzlETNxh3tjG4w+WaYwQRz5l8c9O5Dy
        hj3G5MhQBm4szpGbDkdrJhXD3dJG49CBJTaMA8hgRwSKFT0=
X-Google-Smtp-Source: APXvYqzLaIvFXXa9sDzzeC+7Der05z+2y7PvAqMVLAjIHy8ILzkiBB98xdRD6ZfV72sFmE1yONU6J0ZcD+whAVa6nj8=
X-Received: by 2002:aca:1011:: with SMTP id 17mr8450834oiq.72.1579731006685;
 Wed, 22 Jan 2020 14:10:06 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006370ef059cabac14@google.com> <50239085-ff0f-f797-99af-1a0e58bc5e2e@gmail.com>
 <CAM_iQpXqh1ucVST199c72V22zLPujZy-54p=c5ar=Q9bWNq7OA@mail.gmail.com> <7056f971-8fae-ce88-7e9a-7983e4f57bb2@gmail.com>
In-Reply-To: <7056f971-8fae-ce88-7e9a-7983e4f57bb2@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 22 Jan 2020 14:09:55 -0800
Message-ID: <CAM_iQpWw_pP0zm8VgRoYgeMu=b8v8ECmXAcfSC8WGraQ8CNk+Q@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in __nla_put_nohdr
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 12:33 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 1/22/20 12:27 PM, Cong Wang wrote:
> > On Tue, Jan 21, 2020 at 11:55 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> em_nbyte_change() sets
> >> em->datalen = sizeof(*nbyte) + nbyte->len;
> >>
> >> But later tcf_em_validate() overwrites em->datalen with the user provide value (em->datalen = data_len; )
> >> which can be bigger than the allocated (kmemdup) space in em_nbyte_change()
> >>
> >> Should net/sched/em_nbyte.c() provide a dump() handler to avoid this issue ?
> >
> > I think for those who implement ->change() we should leave
> > ->datalen untouched to respect their choices. I don't see why
> > we have to set it twice.
> >
> >
>
> Agreed, but we need to audit them to make sure all of them are setting ->datalen
>

I audited all of them, either sets ->datalen in ->change() or just
implements a ops->datalen. I will send the patch out once passed
syzbot test.

Thanks.
