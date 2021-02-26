Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B8B326215
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBZLom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 06:44:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhBZLoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 06:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614339793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2fgVufcTrJmZD93R7raUQEAmu7odu1BskLOilLiKQ0=;
        b=hRglKkI+9IlcrRP2B9Iz+CAyL/DVa83VF5iX2WZp5+9sLY3TuUVol3BTA8DKT9+J8pSYri
        wvmo9KEx9UNnYh9taa5Hx2fKcAjxZGY3iy/aFnuOfFwxDQ7MDpSJ4kwt74aebh+pIo1VLg
        qsddoYgc3emXOCbZzrwSwIa7Nf5GDLs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-61P20zBkO--MMSnBcooy0g-1; Fri, 26 Feb 2021 06:43:09 -0500
X-MC-Unique: 61P20zBkO--MMSnBcooy0g-1
Received: by mail-ed1-f71.google.com with SMTP id u2so4329114edj.20
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 03:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=t2fgVufcTrJmZD93R7raUQEAmu7odu1BskLOilLiKQ0=;
        b=SF7S310T0OodDrTUaJnzqnvMvOIWkrRE3nxCKUXc1fKCRIFToJYt6eRsNtI5KkZEuY
         m4J2E4Um4TOda2akDC8xDgHj8cyPtN+8m8Q0GwWs7tMquz50uTnzef9FwuQB8z9Nismj
         0VOjCOoTI2NthSlcohEfw1NfL1o4OQnzTrYBjNx+OfkC7Su9T2lnJdSXv2BTym3CGwqr
         4LRM1YwydD6BNZnZQW/eaNZMAyvzgoXsJHnV5XqVmS8vitKeWPXQlVWR2N4ijWzx4E+P
         rVbJdteMAKzfdViN7XBdqRP5yWRWG8Dx0693ZvrTU5lLxkrz3ZwkDEEf3mcFPuYJ8PXj
         YMiQ==
X-Gm-Message-State: AOAM532aPHqDj2NYRulrZFLyT48kHBG+vFbuR3+JtDrtGldtRVDI4VOo
        c0miOnvgOnzm5/eCo1Om14wLBUWo7CuEhFCKt656ga76vUTRX6Sac0vIE0XRMom4YJwjgxbedvB
        IEwV3bFFTd0W1QPRB
X-Received: by 2002:a17:906:503:: with SMTP id j3mr2885982eja.172.1614339788202;
        Fri, 26 Feb 2021 03:43:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwH0VmMX7NuXtztbUxTJFUFA710jWxAukUXoBUo3DQGO4ZwoqOZE0nQoVSDr2hnqyKvfQNtzQ==
X-Received: by 2002:a17:906:503:: with SMTP id j3mr2885962eja.172.1614339787958;
        Fri, 26 Feb 2021 03:43:07 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j17sm5595659edv.66.2021.02.26.03.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 03:43:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 64C55180094; Fri, 26 Feb 2021 12:43:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v4 0/2] Optimize
 bpf_redirect_map()/xdp_do_redirect()
In-Reply-To: <1759bd57-0c52-d1f2-d620-e7796f95cff6@intel.com>
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
 <87v9afysd0.fsf@toke.dk> <1759bd57-0c52-d1f2-d620-e7796f95cff6@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Feb 2021 12:43:07 +0100
Message-ID: <87pn0nyrzo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-02-26 12:35, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>=20
>>> Hi XDP-folks,
>>>
>>> This two patch series contain two optimizations for the
>>> bpf_redirect_map() helper and the xdp_do_redirect() function.
>>>
>>> The bpf_redirect_map() optimization is about avoiding the map lookup
>>> dispatching. Instead of having a switch-statement and selecting the
>>> correct lookup function, we let bpf_redirect_map() be a map operation,
>>> where each map has its own bpf_redirect_map() implementation. This way
>>> the run-time lookup is avoided.
>>>
>>> The xdp_do_redirect() patch restructures the code, so that the map
>>> pointer indirection can be avoided.
>>>
>>> Performance-wise I got 3% improvement for XSKMAP
>>> (sample:xdpsock/rx-drop), and 4% (sample:xdp_redirect_map) on my
>>> machine.
>>>
>>> More details in each commit.
>>>
>>> @Jesper/Toke I dropped your Acked-by: on the first patch, since there
>>> were major restucturing. Please have another look! Thanks!
>>=20
>> Will do! Did you update the performance numbers above after that change?
>>
>
> I did. The XSKMAP performance stayed the same (no surprise, since the
> code was the same). However, for the DEVMAP the v4 got rid of a call, so
> it *should* be a bit better, but for some reason it didn't show on my
> machine.

Alright, fair enough - pesky real world not lining up with expectations!
Maybe Jesper has additional suggestions, but I can live with the 4%
improvement ;)

-Toke

