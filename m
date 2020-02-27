Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81303172487
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgB0RHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:07:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33494 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729382AbgB0RHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:07:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582823222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1dmE1nT25qJuhF6Hudij24GkCM1UWqvkNuYRWlgecPA=;
        b=YAlr7r3eLgwOEfB33+gZ8d2E4oYU35AMn2R0BCTulPp6yiewww85WqCy5I3+d5VT4omm8G
        7AfY9uZ1Vfp5b4roBJI0yAUMmPHWVVJJErvP/yK/Owvtk9pn8OoVEtqaOgaiC27Cq9XFGP
        wDH6shLhq/4HStxQUU1G98spzwCjN3s=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-qtFgY09AMKaxBB1mk0XlpA-1; Thu, 27 Feb 2020 12:07:00 -0500
X-MC-Unique: qtFgY09AMKaxBB1mk0XlpA-1
Received: by mail-lf1-f70.google.com with SMTP id q2so10811lfo.5
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 09:07:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1dmE1nT25qJuhF6Hudij24GkCM1UWqvkNuYRWlgecPA=;
        b=j5aHjFCQn8Le2htpicxatPFbGWCZOmFidUPOK4F+Cu9Fe7Y8EMct7Bgj29dx6Ey39o
         uv/DpRlv2RK7NM4MyW2yNXxJ8fJD+K8zKHRh5bVhUkgplOyWTsJISvVaFsQFxnOmxhwq
         1DKYANjUFU/eto6wuAaNAfQZgR7Zev8egnnFFWfPPhvqKbGxbjDp6Yk2618HEFmRUNfa
         /8CSSHJxjU2Tb3MYKPf9bo4EOimCdacGHi8qM6E+m1NmbJLs10bX90+/irlOxMPlCH5O
         yVZoKhYOnGKWSMJvpBiMPNgYVj2yDg4nMd5Qbr77wKc4vbTlnErckg6JypyegvlPt4DF
         J/RQ==
X-Gm-Message-State: ANhLgQ0msRQXTyjP7iMUNvA4UHPeflXtXdQcR5pmBdpcWQAJ2C9atFzX
        XJIoNWDAdphPnjbXvvqULKt0nG0fAIJpWc/bAX55Vd+rtZ0hnRVhz/YPuKb5tYXfG4WUixskrdw
        rnLYCFGsm/LZBFJ3a
X-Received: by 2002:a19:691e:: with SMTP id e30mr212181lfc.104.1582823219176;
        Thu, 27 Feb 2020 09:06:59 -0800 (PST)
X-Google-Smtp-Source: ADFU+vu7ubVqHLj7qbDv+LZbhdA4NcJdbH8ihQ1g8lIiUVfZRb1G4UNKhmLrIjOrHBs+PQ4xL8L71A==
X-Received: by 2002:a19:691e:: with SMTP id e30mr212161lfc.104.1582823218938;
        Thu, 27 Feb 2020 09:06:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e17sm3654102ljg.101.2020.02.27.09.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 09:06:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6583D180362; Thu, 27 Feb 2020 18:06:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC v4 bpf-next 00/11] Add support for XDP in egress path
In-Reply-To: <CAADnVQJOZNP+=woGk8OjUgT8yApkrZ1mCKOgzD1mdqi91F1AYw@mail.gmail.com>
References: <20200227032013.12385-1-dsahern@kernel.org> <87a754w8gr.fsf@toke.dk> <CAADnVQJOZNP+=woGk8OjUgT8yApkrZ1mCKOgzD1mdqi91F1AYw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 27 Feb 2020 18:06:57 +0100
Message-ID: <87r1ygufgu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Feb 27, 2020 at 3:55 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> However, my issue with this encoding is that it is write-only: You can't
>> inspect a BPF program already loaded into the kernel and tell which type
>> it is. So my proposal would be to make it explicit: Expose the
>> expected_attach_type as a new field in bpf_prog_info so userspace can
>> query it, and clearly document it as, essentially, a program subtype
>> that can significantly affect how a program is treated by the kernel.
>
> You had the same request for "freplace" target prog.

Yes, and for the same reason; I'm being consistent here :)

> My answer to both is still the same:
> Please take a look at drgn and the script that Andrey posted.
> All this information is trivial to extract from the kernel
> without introducing new uapi.

I'm sorry, but having this kind of write-only data structure is a
horrible API design; and saying "you can just parse the internal kernel
data structures to see what is going on" is a cop-out. The whole point
of having a stable UAPI is to make it possible for people to write
applications that make use of kernel features with an expectation that
those applications will keep working. XDP is a networking feature;
people building networking applications shouldn't have to chase internal
kernel APIs just to keep their packet processing programs working.

Besides, it's already UAPI - there's a setter for it! If we introduce
this new egress program type that is still going to be a de facto new
program type with different semantics than the RX program, whether we
try to hide the fact or not. Even if we end up completely changing the
internal data structures, we're still going to have to support someone=20
loading a program with type=3D=3DXDP and attach_type =3D=3D XDP_EGRESS. So =
why
can't we allow the user to query the state of a previously loaded
program as well?

-Toke

