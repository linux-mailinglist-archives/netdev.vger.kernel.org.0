Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A272D9E73
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 19:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408754AbgLNSD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 13:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408264AbgLNSCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 13:02:53 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D87C0613D3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 10:02:13 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id t13so16223962ybq.7
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 10:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p4tiVtNUkOWB1X6MSLZHWD0N2bDe1nYJx4GncjugFhE=;
        b=r2YDl1Eqtv/5RcVBtGOb1IywULN7TLWcM2jAElFhiLeEEZR/iqPJ/hqMxkFsCINdY9
         m59hIMXxbzjc68vJtynZsqqLNIOxwhA4OrJLwCp+k5UpzZW1hQDRBnA/KbsQkr1UZIyq
         T8QfHdhN8UgAg6ykJy+gDOY4HWUcPfoi6ZzG+5YGCZIxUoYC2xKXb/Odt1Vj4LywSKBo
         CyC4+h8Guy6CQOwbOot/VV//ZTrdS4yy04Yo8bKTe5KQlVGz+pfV85SjYq8p2kML1W7B
         y0YDAgGlpr9BR9cj6L0X/aLakULbCP6KfTf4GX1890iQJCn796ASkOqYQQjWSQqPxkmN
         Of1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p4tiVtNUkOWB1X6MSLZHWD0N2bDe1nYJx4GncjugFhE=;
        b=qC194hYfr5sXs/kPKpDn7epex74ALIijOwLwei8DYy9UrKtzx97VsxIsQN7Z4JEZVG
         9AMFfYzvH80AIVl21SJhA5gtYbzf9FInHV92EYbj2shPtXeKZa4wJvn79XH4aYSMcmGr
         tr+u4R0n1QCnRS38YL5/TxUGL2tFZqHWRlMUMLo7N6sJZRbMqdGaEohhNR4ePJZkiVFW
         ZVjlN2q01VSuaD+EI4FYJ7QrjfjkmptatHAuYqFO2TFNX+E76R2vwSE9B0f/+VoQAjRJ
         z1sHaj02t6UxwcCBWdQZEpmCsQ3btEfKVpQd5GZeznXh5t+/RD7dHnjOZN9pFpH6Ptar
         fC5Q==
X-Gm-Message-State: AOAM530YdBHFYikkPRuJ4ZCiVMwss+dontnL1tj6G4lzO0DSOMqzvYy0
        FdZK8WIMsy0abppDa2qWc5pCYOuhP1dEyHcsEl5PmA==
X-Google-Smtp-Source: ABdhPJz7k6RlsD7s+O+cmnTmG2WYqMlEgYqxGqcUowfSS79ZHsZPC88I70TnqtMhbP/vvaqOFaL8w0Uwh9D8Tj7rMC0=
X-Received: by 2002:a25:8201:: with SMTP id q1mr7685131ybk.351.1607968931934;
 Mon, 14 Dec 2020 10:02:11 -0800 (PST)
MIME-Version: 1.0
References: <20201209005444.1949356-1-weiwan@google.com> <20201209005444.1949356-4-weiwan@google.com>
 <20201212145902.1285a8ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212145902.1285a8ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 14 Dec 2020 10:02:01 -0800
Message-ID: <CAEA6p_Bwd=Zodzp3H6vjrmGjtPvQWCmj9efsb1QX2mHEtj50JQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/3] net: add sysfs attribute to control napi
 threaded mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 2:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  8 Dec 2020 16:54:44 -0800 Wei Wang wrote:
> > +static void dev_disable_threaded_all(struct net_device *dev)
> > +{
> > +     struct napi_struct *napi;
> > +
> > +     list_for_each_entry(napi, &dev->napi_list, dev_list)
> > +             napi_set_threaded(napi, false);
> > +}
>
> This is an implementation detail which should be hidden in dev.c IMHO.
> Since the sysfs knob is just a device global on/off the iteration over
> napis and all is best hidden away.

OK. Will move it.

>
> (sorry about the delayed review BTW, hope we can do a minor revision
> and still hit 5.12)
>
> > +static int modify_napi_threaded(struct net_device *dev, unsigned long val)
> > +{
> > +     struct napi_struct *napi;
> > +     int ret;
> > +
> > +     if (list_empty(&dev->napi_list))
> > +             return -EOPNOTSUPP;
> > +
> > +     list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > +             ret = napi_set_threaded(napi, !!val);
> > +             if (ret) {
> > +                     /* Error occurred on one of the napi,
> > +                      * reset threaded mode on all napi.
> > +                      */
> > +                     dev_disable_threaded_all(dev);
> > +                     break;
> > +             }
> > +     }
> > +
> > +     return ret;
> > +}
