Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335851EF600
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 13:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgFELBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 07:01:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726966AbgFELBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 07:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591354865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=99VNPYJGoMPl79e21WOZdb+KAZocUbilTfddS29tBis=;
        b=EMrUf8eV50QDlKmjTPF7TXEYpAZTcj2nGGcteieg1bOQG+SMrL2cXnK9/gUyNRjkbp0AC/
        eW/VLrhxyPKbZrRHneuCuqMZpNbQZBiRYua+qQ+q6tmjM1ZQRjz2hBbYt47ncitDZYBccR
        QBXF8ZY5DqcFR4v8AWe9QNoCd0Mnyio=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-cVJQIMRMMruv2oa7zOgvpw-1; Fri, 05 Jun 2020 07:01:04 -0400
X-MC-Unique: cVJQIMRMMruv2oa7zOgvpw-1
Received: by mail-ej1-f69.google.com with SMTP id a20so3434482ejt.19
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 04:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=99VNPYJGoMPl79e21WOZdb+KAZocUbilTfddS29tBis=;
        b=OPgpMwRBWsJC4SMq4FXk7dzWaIcD7BiGn2sIF6VuPLLLbhjETTTAv0iI8rA0zDgJj+
         ZAoxBHx3RknDHhoUrMHfR/chbL+uOFViQCiqc1TWA4t1HPxfn2CM+KpqIpmUPXnBQ+n3
         VRnTo/V9V0xaWINMKSgCojeg/fjpKksf8ROuuF8jt0yrhWHNpHTqVspbCasu8dGEuhif
         Pm56GX3n7pzYI33lMxumtWMGq4QmvqHExBns+sAh+MS6hGQGrVKCIhdZ+7hfBrpRzmyn
         QcOyeH8wqbOyYoMpA+rP5C7v7a9oj9uFNvJ0N+w50rnOwpytNxFz/NbkPosmheYXZTCn
         qrVg==
X-Gm-Message-State: AOAM532DAD78h4/Atq3HrQYbmsZtjcDj4C80oy27u2qH3mqEkxVAgYdF
        jgThL/Xt0W/mV6JlT+MSLoCAiR1lIayOnLQK8T4rCa18NaVOTPPofswewv7Q0vaNuuqwGj4mIY6
        +zETqjjzMdwJUmjAH
X-Received: by 2002:aa7:d158:: with SMTP id r24mr8533238edo.272.1591354862326;
        Fri, 05 Jun 2020 04:01:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3FkyT1V4vxoO2SrH/qvQCMvKtyEkE41uXCPhuRSVuJBMRq0wXuv5atvbNLgcHzJTRm/uNKA==
X-Received: by 2002:aa7:d158:: with SMTP id r24mr8533193edo.272.1591354861927;
        Fri, 05 Jun 2020 04:01:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h8sm4703487edk.72.2020.06.05.04.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 04:01:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9910818200D; Fri,  5 Jun 2020 13:01:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Miller <davem@davemloft.net>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on BTF
In-Reply-To: <20200605102323.15c2c06c@carbon>
References: <159119908343.1649854.17264745504030734400.stgit@firesoul> <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com> <20200604174806.29130b81@carbon> <205b3716-e571-b38f-614f-86819d153c4e@gmail.com> <20200604173341.rvfrjmt433knl3uv@ast-mbp.dhcp.thefacebook.com> <20200605102323.15c2c06c@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 05 Jun 2020 13:01:00 +0200
Message-ID: <87y2p1dbf7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 4 Jun 2020 10:33:41 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
>> On Thu, Jun 04, 2020 at 10:40:06AM -0600, David Ahern wrote:
>> > On 6/4/20 9:48 AM, Jesper Dangaard Brouer wrote:  
>> > > I will NOT send a patch that expose this in uapi/bpf.h.  As I explained
>> > > before, this caused the issues for my userspace application, that
>> > > automatically picked-up struct bpf_devmap_val, and started to fail
>> > > (with no code changes), because it needed minus-1 as input.  I fear
>> > > that this will cause more work for me later, when I have to helpout and
>> > > support end-users on e.g. xdp-newbies list, as it will not be obvious
>> > > to end-users why their programs map-insert start to fail.  I have given
>> > > up, so I will not NACK anyone sending such a patch.  
>> 
>> Jesper,
>> 
>> you gave wrong direction to David during development of the patches and
>> now the devmap uapi is suffering the consequences.
>> 
>> > > 
>> > > Why is it we need to support file-descriptor zero as a valid
>> > > file-descriptor for a bpf-prog?  
>> > 
>> > That was a nice property of using the id instead of fd. And the init to
>> > -1 is not unique to this; adopters of the bpf_set_link_xdp_fd_opts for
>> > example have to do the same.  
>> 
>> I think it's better to adopt "fd==0 -> invalid" approach.
>> It won't be unique here. We're already using it in other places in bpf syscall.
>> I agree with Jesper that requiring -1 init of 2nd field is quite ugly
>> and inconvenient.
>
> Great. If we can remove this requirement of -1 init (and let zero mean
> feature isn't used), then I'm all for exposing expose in uapi/bpf.h.

If we're going to officially deprecate fd 0 as a valid BPF fd, we should
at least make sure users don't end up with such an fd after opening a
BPF object. Not sure how the fd number assignment works, but could we
make sure that the kernel never returns fd 0 for a BPF program/map?

Alternatively, we could add a check in libbpf and either reject the
call, or just call dup() before passing the fd to the kernel.

Right now it's quite trivial to get a BPF program ref with fd0 - all you
have to do is open a BPF program is the first thing you do after closing
stdin (like a daemon might). I'd really rather not have to help anyone
debug that...

-Toke

