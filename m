Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8735312090A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfLPO4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:56:44 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37322 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbfLPO4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:56:44 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep17so3090593pjb.4;
        Mon, 16 Dec 2019 06:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EP6RC8SxFHC8bjgm4EkgthTkPjwvPYc8poOn+2dNdIk=;
        b=VUpXMgAJ0oav+21NrqrRN+dB6G3KI83OYeiLUkjfvLunjnTEmJKIemRjoAwDiJBFXh
         qQW6OHEUC+GgglfdZR/re9mWc+q6dpnF5Rn8uG93u7nV+V3tiGvxWYhuB7OKVZsd0rkO
         aE1bAY3dsRHTFQEIsEx9HslcwgqLTySyYuhnbXg72/vK5SDa8O5tEkglJSrxlnjX9Pok
         L3kxlvYpWRhFd4jOS9nF9kGi7he9ZOy0iwttHagueX/47ytnroRoCEHm9Wktr1olJHDh
         Ktd2KMBghDG074jCSB/37lu0xVsSy+pwbJyoi9nhTpJkvForx5k8eGQt9PcCUPRjF4cf
         bQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EP6RC8SxFHC8bjgm4EkgthTkPjwvPYc8poOn+2dNdIk=;
        b=a5ieSOZkXZwGkJSOG2atbNIGSIePH+HViaAFo0aEWHfo7oadO525qbKIkFAH6PxRBb
         Ru7huB26u6hSv6+rAumflC0wSf4a83awef6qYKO52Qt6Wzt40zbJD1Jm6Q+B4oLMKiOU
         q0qhHxKhtexxDtmo5Jm+SwuHD5b5dCYgpTZmfn0O+cIeGjiJlVKuoIFT1u3dcvW3YLaG
         DNl3xN1cr6FqIiWy71Q2Hqtes6L0Gyo4azLGPN2N/1XKVJp0L9B7QutglTHUTcVM4d0b
         LoC+sidstPe7aKBKLdd9fuO+1zaOOLLPDgktZqbke76RWgN2z0yM9M1TaI7hBgFVVBhc
         xpjg==
X-Gm-Message-State: APjAAAUJHF8xxjrDnBlyLCWRtA//HFy4G7DhNe+RJNzQiQTO+6cPv55U
        ge2NAUHUqI7OZnjhHKivfFg=
X-Google-Smtp-Source: APXvYqykjmwgh3HQzNSaNR41mdUNn1L1ccnrdjRsX4JAvCz/Ew4kfCx6NgLZNel/A1CX+HHOgrNh4w==
X-Received: by 2002:a17:902:43:: with SMTP id 61mr16721923pla.88.1576508203055;
        Mon, 16 Dec 2019 06:56:43 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:ae2b:206e:59f8:9154:dc19])
        by smtp.gmail.com with ESMTPSA id l14sm22318230pgt.42.2019.12.16.06.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 06:56:42 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 151C8C08E0; Mon, 16 Dec 2019 11:56:39 -0300 (-03)
Date:   Mon, 16 Dec 2019 11:56:38 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     syzbot <syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_stream_init
Message-ID: <20191216145638.GB5058@localhost.localdomain>
References: <000000000000f531080599c4073c@google.com>
 <20191216114828.GA20281@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216114828.GA20281@hmswarspite.think-freely.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 06:48:28AM -0500, Neil Horman wrote:
> On Sun, Dec 15, 2019 at 12:35:09PM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    e31736d9 Merge tag 'nios2-v5.5-rc2' of git://git.kernel.or..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=126a177ee00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=bbf3a35184a3ed64
> > dashboard link: https://syzkaller.appspot.com/bug?extid=772d9e36c490b18d51d1
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15602ddee00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12798251e00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> > 
> > BUG: memory leak
> > unreferenced object 0xffff8881080a3000 (size 4096):
> >   comm "syz-executor474", pid 7155, jiffies 4294942658 (age 15.870s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000df094087>] genradix_alloc_node lib/generic-radix-tree.c:90
> > [inline]
> >     [<00000000df094087>] __genradix_ptr_alloc+0xf5/0x250
> > lib/generic-radix-tree.c:122
> >     [<0000000057cfa7bb>] __genradix_prealloc+0x46/0x70
> > lib/generic-radix-tree.c:223
> >     [<0000000029d02dac>] sctp_stream_alloc_out.part.0+0x57/0x80
> > net/sctp/stream.c:86
> >     [<00000000bb930a04>] sctp_stream_alloc_out net/sctp/stream.c:151
> > [inline]
> >     [<00000000bb930a04>] sctp_stream_init+0x129/0x180 net/sctp/stream.c:129
> >     [<00000000ba13c246>] sctp_association_init net/sctp/associola.c:229
> > [inline]
> >     [<00000000ba13c246>] sctp_association_new+0x46e/0x700
> > net/sctp/associola.c:295
> >     [<000000008eb57b4d>] sctp_connect_new_asoc+0x90/0x220
> > net/sctp/socket.c:1070
> >     [<00000000ea24e048>] __sctp_connect+0x182/0x3b0 net/sctp/socket.c:1176
> >     [<00000000aa2c530a>] __sctp_setsockopt_connectx+0xa9/0xf0
> > net/sctp/socket.c:1322
> >     [<0000000018934bfd>] sctp_getsockopt_connectx3 net/sctp/socket.c:1407
> > [inline]
> >     [<0000000018934bfd>] sctp_getsockopt net/sctp/socket.c:8079 [inline]
> >     [<0000000018934bfd>] sctp_getsockopt+0x1394/0x32f6
> > net/sctp/socket.c:8010
> >     [<000000005fd7e3c8>] sock_common_getsockopt+0x38/0x50
> > net/core/sock.c:3108
> >     [<00000000333baf72>] __sys_getsockopt+0xa8/0x180 net/socket.c:2162
> >     [<00000000de0f98e4>] __do_sys_getsockopt net/socket.c:2177 [inline]
> >     [<00000000de0f98e4>] __se_sys_getsockopt net/socket.c:2174 [inline]
> >     [<00000000de0f98e4>] __x64_sys_getsockopt+0x26/0x30 net/socket.c:2174
> >     [<00000000cf1dfee9>] do_syscall_64+0x73/0x220
> > arch/x86/entry/common.c:294
> >     [<000000000f416860>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> 
> Almost looks like we're processing a connectx socket option while the handling
> of a cookie echo chunk is in flight through the state machine (i.e.
> sctp_stream_update is getting called on the association while we're setting it
> up in parallel), though I'm not sure how that can happen

I'm seeing something different. In the console output there were 2
fault injections and they hit the genradix preallocation. And our
handling of that error within genradix is the responsible for it:

sctp_stream_alloc_out()
{
...
        ret = genradix_prealloc(&stream->out, outcnt, gfp);
        if (ret)
                return ret;

        stream->outcnt = outcnt;
}

int __genradix_prealloc(struct __genradix *radix, size_t size,
                        gfp_t gfp_mask)
{
        size_t offset;

        for (offset = 0; offset < size; offset += PAGE_SIZE)
                if (!__genradix_ptr_alloc(radix, offset, gfp_mask))
                        return -ENOMEM;

        return 0;
}

Note how it (and also __genradix_ptr_alloc()) doesn't clean up the
already, newly initialized, indexes.

Then it doesn't clean up the partially pre-allocated items on error
handling:

sctp_stream_init()
{
...
        ret = sctp_stream_alloc_out(stream, outcnt, gfp);
        if (ret)
                goto out;
...
        ret = sctp_stream_alloc_in(stream, incnt, gfp);
        if (ret) {
                sched->free(stream);
                genradix_free(&stream->out);   <--
                stream->outcnt = 0;
                goto out;
        }

out:
        return ret;
}

Considering that genradix_prealloc() failure is not fatal, seems the
fix here is to just ignore the failure in sctp_stream_alloc_out() and
let genradix try again later on.

  Marcelo
