Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4692A10D26D
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfK2I1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:27:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43919 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725892AbfK2I1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575016067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WyZJEooqY157FQmuO7+hU0ElGstNoXM7pKnTNDwtZp8=;
        b=MyNS1D2Mc4STEOuRlvkbQLZddhaTtqD4EmKZ1yPmXpg2r9Ro7wZr6qgkocB+ptesgVQe3T
        TphWh54pSgRPgZY03W5CNNEDMSutwygYC0iQGtn0iP0Oq5sABJvLgNPwMw7KhokdK9tSto
        w8/Io4EICpKzwLRBk6Ef0Pn1zny59BU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-ik4DrbyCOT2mldSeQypFoQ-1; Fri, 29 Nov 2019 03:27:43 -0500
Received: by mail-lj1-f199.google.com with SMTP id d9so1971008lji.1
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 00:27:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WyZJEooqY157FQmuO7+hU0ElGstNoXM7pKnTNDwtZp8=;
        b=qhs3W9GqtfzMycTdgScuRiKmm1J6TD/QoOOl7ToTUjZ9ZGe3zHLtjk1FtOMbe6kSI5
         RMfU7uZtSvYTdz7U7ZHBAYYS6qIEb6fV8o+QT1XWOo3Muz/B/ksockm1mfl2ArCaGjDx
         lix6Yvot1zUbKkaLztjh/DdbugTLsrGNYlTv1Fe82yeRA5lbu/WGeymZg+6q4iWst8Tu
         Yf7OpeWm3Dqd1CTud0o0HE+Dn+VBHDu12RTcJyNaK692sAUihS3CW9OekrpRM/07fJhy
         SbNlxCGQZQGcTmsFNrzE+dHfpZlVIGkUHN0CyDBpDyt022pFTDTtc7+Bqut8IHdWlxzX
         8fQQ==
X-Gm-Message-State: APjAAAUQDytrmtrucEofceO1v1o1emwBeEGYeawzNppz/XwH3YUpomNk
        lhRzp9OTqH26j5sySZScGmM5dVgCj/87pNLBUBrtQ9nBxhBL+ywHfMjCGq/OK40Bk8W/MOrW+37
        QDcpj9D7bklNH1b/k
X-Received: by 2002:a2e:9906:: with SMTP id v6mr11844357lji.90.1575016062485;
        Fri, 29 Nov 2019 00:27:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjsnwesS88bOXjqUaGt57AMxaYdThD0WrofOCAs5gajMzZRA087w0B+ybbHRoLVjBZaRciog==
X-Received: by 2002:a2e:9906:: with SMTP id v6mr11844349lji.90.1575016062351;
        Fri, 29 Nov 2019 00:27:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 145sm4998765ljj.69.2019.11.29.00.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 00:27:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EDF571818BD; Fri, 29 Nov 2019 09:27:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Better ways to validate map via BTF?
In-Reply-To: <CAEf4BzY3jp=cw9N23dBJnEsMXys6ZtjW5LVHquq4kF9avaPKcg@mail.gmail.com>
References: <20191128170837.2236713b@carbon> <CAEf4BzY3jp=cw9N23dBJnEsMXys6ZtjW5LVHquq4kF9avaPKcg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 Nov 2019 09:27:40 +0100
Message-ID: <87pnhbulxf.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: ik4DrbyCOT2mldSeQypFoQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Nov 28, 2019 at 8:08 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
>>
>> Hi Andrii,
>
>
> Hey, Jesper! Sorry for late reply, I'm on vacation for few days, so my
> availability is irregular at best :)
>
>>
>> Is there are better way to validate that a userspace BPF-program uses
>> the correct map via BTF?
>>
>> Below and in attached patch, I'm using bpf_obj_get_info_by_fd() to get
>> some map-info, and check info.value_size and info.max_entries match
>> what I expect.  What I really want, is to check that "map-value" have
>> same struct layout as:
>>
>>  struct config {
>>         __u32 action;
>>         int ifindex;
>>         __u32 options;
>>  };
>
> Well, there is no existing magical way to do this, but it is doable by
> comparing BTFs of two maps. It's not too hard to compare all the
> members of a struct, their names, sizes, types, etc (and do that
> recursively, if necessary), but it's a bunch of code requiring due
> diligence. Libbpf doesn't provide that in a ready-to-use form (it does
> implement equivalence checks between two type graphs for dedup, but
> it's quite coupled with and specific to BTF deduplication algorithm).
> Keep in mind, when Toke implemented map pinning support in libbpf, we
> decided to not check BTF for now, and just check key/value size,
> flags, type, max_elements, etc.

Yeah. Probably a good idea to provide convenience functions for this in
libbpf (split out the existing code and make it more general?). Then we
can also use that for the test in the map pinning code :)

-Toke

