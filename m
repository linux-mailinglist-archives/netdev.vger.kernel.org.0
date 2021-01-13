Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF142F4012
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbhAMAoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbhAMAnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 19:43:33 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA50C061786;
        Tue, 12 Jan 2021 16:42:53 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s2so370471oij.2;
        Tue, 12 Jan 2021 16:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1YCMS0WB2gu8/A3DVzRsBYDPWPSiXcpD4uySCn4i6iI=;
        b=urYDJJA4jLdxKX6QV9O5A9eKzh3WAefL17zggGVKkmSZlD5VJwB7946TXWFyjOlfDt
         T6Ko4vkk55MM0GTWS3PPqE+Ojaen57nwmgjnthXiVoDnIgXYFOzGVOjoJl5SfAnM0aih
         fBKP0r2xtr2JcimP3skyq1PgdlJMWX3ueRSeZbglURFqWH5qFxxnY7GaaPpqOIcI6txx
         Mh6uBi2QlPeJbegrpTZ31+ifHVSLleMCBU3+L9o950CCHXAEi74HSX0xsL2q7CYqzBT1
         CYtzGeNX6ZHnWFDXEUDMgBJYWt+J0Zj7mVLTmhhU+EODE7FUx/N9/blRRA1xtEV4BZVX
         p/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1YCMS0WB2gu8/A3DVzRsBYDPWPSiXcpD4uySCn4i6iI=;
        b=YopfPekJ4CMnobZA3PpwtlfncBXA9hITQ3VNdpKfkUUS37Mh4hj1i0YyfHG5UlbmeT
         bBEg0Yvx3OsVJfhNfp5Xc/TfjcaV3O5WMKduldOym/OXayTaMwQd2yDDnPgsM/N3pfDS
         sU/l06BRYqo0IFEOHpxuLAnarzHNM4b47YO9T9suj7q5NlARTtEonYs9NEd0C9BjXwxS
         9+1Kk7y5awqrX5jehjKUGxOmptTwgr4CPgJ3fcbSKrUk7hLWCQ/wd15QEoae0jiqhevk
         4WHWAO3iSnC9BbD+CKcnugXu1RDEqIf5zhxuCKCAXjTvpQtKH/niv0fU0jl+A85hV6c5
         GC0Q==
X-Gm-Message-State: AOAM533yY2PJxU5akBoofjYix1F5wyafabpzQdAhpFebK5DiLyTmlKVE
        8eyDo3B4ckG7/bLo3qAuhjk=
X-Google-Smtp-Source: ABdhPJwixKnHkNeaIO0rzMFmR0xZszxr+TuXzDoJOAjmjxJVagOqZgnRWh4LtXZzu6JJtIf1E5cpoQ==
X-Received: by 2002:aca:5792:: with SMTP id l140mr138785oib.175.1610498572768;
        Tue, 12 Jan 2021 16:42:52 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id a195sm91429oib.52.2021.01.12.16.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 16:42:52 -0800 (PST)
Date:   Tue, 12 Jan 2021 16:42:49 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>, enkechen2020@gmail.com
Subject: Re: [PATCH] tcp: keepalive fixes
Message-ID: <20210113004249.GA2358@localhost.localdomain>
References: <20210112192544.GA12209@localhost.localdomain>
 <CAK6E8=fq6Jec94FDmDHGWhsmjtZQmt3AwQB0-tLcpJpvJ=oLgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK6E8=fq6Jec94FDmDHGWhsmjtZQmt3AwQB0-tLcpJpvJ=oLgg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Yuchung:

I have attached the python script that reproduces the keepalive issues.
The script is a slight modification of the one written by Marek Majkowski:

https://github.com/cloudflare/cloudflare-blog/blob/master/2019-09-tcp-keepalives/test-zero.py

Please note that only the TCP keepalive is configured, and not the user timeout.

Thanks.  -- Enke

On Tue, Jan 12, 2021 at 02:48:01PM -0800, Yuchung Cheng wrote:
> On Tue, Jan 12, 2021 at 2:31 PM Enke Chen <enkechen2020@gmail.com> wrote:
> >
> > From: Enke Chen <enchen@paloaltonetworks.com>
> >
> > In this patch two issues with TCP keepalives are fixed:
> >
> > 1) TCP keepalive does not timeout when there are data waiting to be
> >    delivered and then the connection got broken. The TCP keepalive
> >    timeout is not evaluated in that condition.
> hi enke
> Do you have an example to demonstrate this issue -- in theory when
> there is data inflight, an RTO timer should be pending (which
> considers user-timeout setting). based on the user-timeout description
> (man tcp), the user timeout should abort the socket per the specified
> time after data commences. some data would help to understand the
> issue.
> 

------
#! /usr/bin/python

import io
import os
import select
import socket
import time
import utils
import ctypes

utils.new_ns()

port = 1

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
s.bind(('127.0.0.1', port))
s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 1024)

s.listen(16)

tcpdump = utils.tcpdump_start(port)
c = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
c.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 1024)
c.connect(('127.0.0.1', port))

x, _ = s.accept()

if False:
    c.setsockopt(socket.IPPROTO_TCP, socket.TCP_USER_TIMEOUT, 90*1000)

if True:
    c.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
    c.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPCNT, 5)
    c.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPIDLE, 10)
    c.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPINTVL, 10)

time.sleep(0.2)
print("[ ] c.send()")
import fcntl
TIOCOUTQ=0x5411
c.setblocking(False)
while True:
    bytes_avail = ctypes.c_int()
    fcntl.ioctl(c.fileno(), TIOCOUTQ, bytes_avail)
    if bytes_avail.value > 64*1024:
        break
    try:
        c.send(b"A" * 16384 * 4)
    except io.BlockingIOError:
        break
c.setblocking(True)
time.sleep(0.2)
utils.ss(port)
utils.check_buffer(c)

t0 = time.time()

if True:
    utils.drop_start(dport=port)
    utils.drop_start(sport=port)

poll = select.poll()
poll.register(c, select.POLLIN)
poll.poll()

utils.ss(port)


e = c.getsockopt(socket.SOL_SOCKET, socket.SO_ERROR)
print("[ ] SO_ERROR = %s" % (e,))

t1 = time.time()
print("[ ] took: %f seconds" % (t1-t0,))
