Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F4F77AAA
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbfG0RDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:03:43 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42951 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387665AbfG0RDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:03:43 -0400
Received: by mail-ed1-f65.google.com with SMTP id v15so55837769eds.9;
        Sat, 27 Jul 2019 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0zfKxQlCcoPzfowpj4/wvzCrpm2d6GvaH4/w09yAZS4=;
        b=oidl+P9cmGPFYfK7Ys9tlta4zBX6KOObpf2TOgeOZOWRuzLo0+Gp7JrjSjLYCpr1J9
         NF4TRkHkVHQ+x9liq24F1FmiIk2xmvTFec0gRMkeliCySQkvIhN5eQK9s6jw3vKniWSZ
         7LB5zzzHzotDn5U3jizomrgHiJozDeKrTEP6ItloIf+v1SoWm0qxSh4GYtVQNKfuxa2d
         mpE6cjGysWodo2grh0ojoKFVXVSXv8yMtCmFOVKlxKHdQiFfrYmKpnUxxt83WuO0Uvlt
         BbcAYgo/xtLwIHMt1LRPb+RGWuCOGfAHXJ8d2dz2pwSLcukK/fkw8bJGM4cuhXdpiJJ9
         Mtlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0zfKxQlCcoPzfowpj4/wvzCrpm2d6GvaH4/w09yAZS4=;
        b=Q+EHWFL8SI6xZYbOrCSJeEuzicT9X3MfOG7eZfiP4WHqTjDbvz+JpsvelsmQC1Vy6M
         nHwGXSBORw6oS3aUBQZWMRabQ+BV2X3kifS41DPpqUe7rYgW5Y0LkHSMHtrhboCamkgh
         2TOuYaQVpLnajs92E12ylUYT0fxMLoJXRfvLnnzTw5C7JqfHTYXYf+zQ/ETD1XCeVvz/
         gegm1WALlDCZI+phbrMveLWjKAfHc266ysNEfCIf0XhWnt2Z3usGKkL65+R/yFqguT4h
         NQ72JmbEafUtnmRT55CLZKEneIdoGdLLrOVmQb0MU8T9Qz9+ffill5WkdxqYZuzedm+M
         yuYg==
X-Gm-Message-State: APjAAAUVBz5Ono3mMM5QPKjsLqu3R6llHBd/9QCueFkT9kL3j+j0sdGT
        K+78AV0AyRKgVhDyPmvh09WsLUb/NxE0xoGb3Q==
X-Google-Smtp-Source: APXvYqz78gHcRAxUTdXUMhht6YvbAA2kQzG2b8eVwIaQTz1353u2jb6YqZF5oeJ4JVliA1DZfVOlAYicwb3a9bRgxnQ=
X-Received: by 2002:a17:906:3507:: with SMTP id r7mr44806203eja.45.1564247021704;
 Sat, 27 Jul 2019 10:03:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190725204230.12229-1-brodie.greenfield@alliedtelesis.co.nz>
 <20190725204230.12229-2-brodie.greenfield@alliedtelesis.co.nz>
 <e5606cf7-6848-1109-6cbe-63d94868ed65@cumulusnetworks.com> <6e8c51a0-cd34-e14a-7661-6fa5945f278b@cumulusnetworks.com>
In-Reply-To: <6e8c51a0-cd34-e14a-7661-6fa5945f278b@cumulusnetworks.com>
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
Date:   Sat, 27 Jul 2019 13:03:31 -0400
Message-ID: <CAHapkUhEVGFRH=-R+obSUMh6rSVxZmEC9GQSnvUkvuj6dwVxjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ipmr: Make cache queue length configurable
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Brodie Greenfield <brodie.greenfield@alliedtelesis.co.nz>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz,
        luuk.paulussen@alliedtelesis.co.nz
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 7:18 AM Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:

> > You've said it yourself - it has linear traversal time, but doesn't this patch allow any netns on the
> > system to increase its limit to any value, thus possibly affecting others ?
> > Though the socket limit will kick in at some point. I think that's where David
> > was going with his suggestion back in 2018:
> > https://www.spinics.net/lists/netdev/msg514543.html
> >
> > If we add this sysctl now, we'll be stuck with it. I'd prefer David's suggestion
> > so we can rely only on the receive queue queue limit which is already configurable.
> > We still need to be careful with the defaults though, the NOCACHE entry is 128 bytes
> > and with the skb overhead currently on my setup we end up at about 277 entries default limit.
>
> I mean that people might be surprised if they increased that limit by default, that's the
> only problem I'm not sure how to handle. Maybe we need some hard limit anyway.
> Have you done any tests what value works for your setup ?

FYI: for ours, it is 2048.
