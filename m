Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A81E0FC999
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:13:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41168 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726179AbfKNPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573744379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=saBDJmV1x06ULPsmrMHAoa5+D/94U002h0vazNsaVYs=;
        b=dE8R6ohInOysT6e4nVkIqQ2G9v3msueJMoB58Ob8GdzTpia/hbN1xeSgmUJI8S+bvG2Etu
        Y8kynBLCNxwKgalgkPmlBHW90v9UCKjB3mskUEJBxcF4gzyO9NDTEHidLJkoiiqYBF3osM
        RpV8d1s9cKW/uN2gRpAaxzddV63yqG4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-D_WJjrzEM-i4ibaeei32QQ-1; Thu, 14 Nov 2019 10:12:58 -0500
Received: by mail-lf1-f72.google.com with SMTP id v204so2061811lfa.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:12:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=saBDJmV1x06ULPsmrMHAoa5+D/94U002h0vazNsaVYs=;
        b=MPzyaRs1RjbxmXofbnCppLejKq9T5nxTsFTY8DuXqC5yiMipDbgvQWGBBHlACYl0Dm
         wiMdAH5uvA4hSXncP3w51JUCRP/oKytn1LoTwl+Z3eB/ykrpC0zU9Fa6Q1gzF59ec0/g
         3KKN5bpr6c+/iEv14W8CN8OZimIxlPvXRrDu1sRHm86LBdU6JKm6jF/1wvNCwOPy3gqd
         PMTC3v+1ljSqB1Ua4GRvr8cmHHat/JGniVuTH/7XPCMXcWQ1FuLdi5LOIPQpGqWl1F8y
         s3RWEglSuUKZqOAsrmY9/aDFes8KrKqT8dNMWGvTeQ4ioTjt+RILQ8Fj6NjFR9pTd+0H
         UQYg==
X-Gm-Message-State: APjAAAUiwXG9i3hKknhlPLXy4EqwscjmYt4h7r4bZXaIcb+tdTi6+lhG
        bajtNp7hmm3vFV06grVi7TVk5WfY6R4U8nhJxcqP2UH3sYziewkThUuJP6BmuOX5S4io7NpJnot
        84OkfZNCwRkbLkC6+
X-Received: by 2002:a2e:8188:: with SMTP id e8mr6876390ljg.152.1573744376760;
        Thu, 14 Nov 2019 07:12:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqyR3hOl1r/+4IMQ77SCzqRaGbTOCJ72EfhYKK32L9FD0YeYmGfO7LrV+Bl0wvY93gIwyT3Bfg==
X-Received: by 2002:a2e:8188:: with SMTP id e8mr6876360ljg.152.1573744376457;
        Thu, 14 Nov 2019 07:12:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id k10sm2684829lfo.76.2019.11.14.07.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:12:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1E4D01803C7; Thu, 14 Nov 2019 16:12:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
In-Reply-To: <CAJ+HfNhRKFGOsv5Nbq5T9NHk=ZcHnK40_jR8bpqNC1GYk8ovTA@mail.gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com> <87o8xeod0s.fsf@toke.dk> <7893c97d-3d3f-35cc-4ea0-ac34d3d84dbc@iogearbox.net> <CAJ+HfNhPhCi4=taK7NcYuCvdcRBXVDobn7fpD3mi1eppTL7zLA@mail.gmail.com> <874kz6o6bs.fsf@toke.dk> <CAJ+HfNhRKFGOsv5Nbq5T9NHk=ZcHnK40_jR8bpqNC1GYk8ovTA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Nov 2019 16:12:55 +0100
Message-ID: <87zhgymqyw.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: D_WJjrzEM-i4ibaeei32QQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Thu, 14 Nov 2019 at 15:55, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>>
> [...]
>> I don't really have anything to back it up, but my hunch is that only 4
>> entries will end up being a limit that people are going to end up
>> hitting. And since the performance falls off quite the cliff after
>> hitting that limit, I do fear that this is something we will hear about
>> quite emphatically :)
>>
>
> Hmm, maybe. I have 8 i40e netdevs on my test machine, all running XDP,
> but I don't think that's normal for deployments. ;-)

Well, the fact that products like this exist kinda indicates that this
is something people are doing, no?

https://small-tree.net/products/10gbe-switches/p3e10g-6-sr/

-Toke

