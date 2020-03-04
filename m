Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A7F1793F3
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388255AbgCDPsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:48:12 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42308 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388183AbgCDPsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 10:48:03 -0500
Received: by mail-pl1-f193.google.com with SMTP id u3so1168492plr.9;
        Wed, 04 Mar 2020 07:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=lsWAeXZgBvBbCxC4IAxRGnZoAnoDvQlT1AZte/UXDV0=;
        b=NsuuqGjkya7feqvFBE6g6oY52nnBVNFxBNljmZ2YA9w5jjAogqrB3Jaoe07dHLuRBw
         wNPNMTCR68hUQyn1q0Gomp2VDlF5pbVi5ZrwcHkjmcG6G3EOP0ksxXpGqpLoDWNaTIMv
         r9tlrHqiFjTfMgRbtVdFjVKWZaxPb8W/1Jd+1JMnzu7VfNmAJME63PEHG2Lp+vx7jdry
         U0RrZDvT9dmrm1lJBZ6A9MZaD24iAAw7HSsK+zok3VpGn8jmCXf6czjCMI7qkiFGKqd/
         lG38AttRuHIIeH4RcQINYe2Op8mMLpRVuMrQzEbDdozCp0up/F7woMCMNXyUm3y9rW/1
         RxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=lsWAeXZgBvBbCxC4IAxRGnZoAnoDvQlT1AZte/UXDV0=;
        b=Elz0bCMLMv6WQ8uZz0raAttVtgoaSMzZBjkwic6wFyMM52A5n/LDlYthwtI/udlrG1
         pfoVayMNYczQhAcwi6nTZCRXfAxTjgbtPyJ69+Sb9Ht+CcEsOn5y4rV5MXijKMVJ5cmz
         UiKPt4qdWREHzJ4IFpodA1Bcd+2oaEJfNvCP85iG9EflVFF/IhE5j2lkvoSqIr4xHcpM
         Rzl6RulTwVu4eQdbNQEgliTyfHI4t2ZpRtzG9v0dcv+IX55ST/GU6Gm+Hf4vfHDfzbnQ
         UZ9LFM16HAIqMwST3nUPYAAnCmBl5yfhhhAUkCO4WqmY/GLyw2eZqNKd+PLYRzNUc4fO
         M/oQ==
X-Gm-Message-State: ANhLgQ3BF1PuF+Z2AKUVPmKVQomdtdazSuC8TKT+FueGerBf6b1wjjch
        AfHFP0DhXr2ea2/rTY1+AN8=
X-Google-Smtp-Source: ADFU+vvbx0EnyqEzXhldgMhINMlenuDyh18RuOp21ymS/wutAr6VqgEy0CQJQMogybcgm6n2tWd8cg==
X-Received: by 2002:a17:902:7007:: with SMTP id y7mr3490155plk.208.1583336882172;
        Wed, 04 Mar 2020 07:48:02 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:c694])
        by smtp.gmail.com with ESMTPSA id s7sm27917016pgp.44.2020.03.04.07.48.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 07:48:01 -0800 (PST)
Date:   Wed, 4 Mar 2020 07:47:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200304154757.3tydkiteg3vekyth@ast-mbp>
References: <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
 <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
 <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
 <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
 <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
 <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
 <87h7z44l3z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7z44l3z.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 08:47:44AM +0100, Toke Høiland-Jørgensen wrote:
> >
> >> And what about the case where the link fd is pinned on a bpffs that is
> >> no longer available? I.e., if a netdevice with an XDP program moves
> >> namespaces and no longer has access to the original bpffs, that XDP
> >> program would essentially become immutable?
> >
> > 'immutable' will not be possible.
> > I'm not clear to me how bpffs is going to disappear. What do you mean
> > exactly?
> 
> # stat /sys/fs/bpf | grep Device
> Device: 1fh/31d	Inode: 1013963     Links: 2
> # mkdir /sys/fs/bpf/test; ls /sys/fs/bpf
> test
> # ip netns add test
> # ip netns exec test stat /sys/fs/bpf/test
> stat: cannot stat '/sys/fs/bpf/test': No such file or directory
> # ip netns exec test stat /sys/fs/bpf | grep Device
> Device: 3fh/63d	Inode: 12242       Links: 2
> 
> It's a different bpffs instance inside the netns, so it won't have
> access to anything pinned in the outer one...

Toke, please get your facts straight.

> # stat /sys/fs/bpf | grep Device
> Device: 1fh/31d	Inode: 1013963     Links: 2

Inode != 1 means that this is not bpffs.
I guess this is still sysfs.

> # mkdir /sys/fs/bpf/test; ls /sys/fs/bpf
> test
> # ip netns add test
> # ip netns exec test stat /sys/fs/bpf/test
> stat: cannot stat '/sys/fs/bpf/test': No such file or directory
> # ip netns exec test stat /sys/fs/bpf | grep Device
> Device: 3fh/63d	Inode: 12242       Links: 2

This is your new sysfs after ip netns exec.

netns has nothing do with bpffs despite your claims.

Try this instead:
# mkdir /tmp/bpf
# mount -t bpf bpf /tmp/bpf
# stat /tmp/bpf|grep Device
Device: 1eh/30d	Inode: 1           Links: 2
# stat -f /tmp/bpf|grep Type
    ID: 0        Namelen: 255     Type: bpf_fs
# mkdir /tmp/bpf/test
# ip netns add my
# ip netns exec my stat /tmp/bpf|grep Device
Device: 1eh/30d	Inode: 1           Links: 3
# ip netns exec my stat -f /tmp/bpf|grep Type
    ID: 0        Namelen: 255     Type: bpf_fs
# ip netns exec my ls /tmp/bpf/
test

Having said that we do allow remounting bpffs on top of existing one:
# mount -t bpf bpf /var/aa
# mkdir /var/aa/bb
# stat -f /var/aa/bb|grep Type
    ID: 0        Namelen: 255     Type: bpf_fs
# mount -t bpf bpf /var/aa
# stat -f /var/aa/bb|grep Type
stat: cannot read file system information for '/var/aa/bb': No such file or directory
# umount /var/aa
# stat -f /var/aa/bb|grep Type
    ID: 0        Namelen: 255     Type: bpf_fs

Still that doesn't mean that pinned link is 'immutable'.
