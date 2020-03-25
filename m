Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65920191EB2
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 02:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCYBq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 21:46:28 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44924 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbgCYBq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 21:46:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id 142so353133pgf.11;
        Tue, 24 Mar 2020 18:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Q00wK/evMOzaEHdxPK0u8vlS+HxhMRr0kSu9Z/o6YUc=;
        b=vhG+CoeUTYNSI9zAjK+hhpX2BkhFSndC1pkQ9PjsBkFNi+BsjRsBuLyDw9Og46PTCy
         seQPlbUcIB356def41k7JHVz8Xc5993l0jLq67uBow5ppNw0136vWeJzETOi+M3OQt2J
         vwv+tJL7KclSTiYetHR7YyU5QHkrHCvdrFWBBVofknW0dGNUfC0oETO6Xo5kQjE4Wlti
         WZytY1UDqPJnFru4UieG5Qd/wXr8NoyN/0pi4B5/UD+LG+Rci40OWkL0zZEhMvI4GJ6T
         Zq67xosgGPHdp4uCtmgNbptOqPP5aXvLxPr72ohirgQG2bfHUiXq3T5sDDzWxg5pLBb9
         E40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Q00wK/evMOzaEHdxPK0u8vlS+HxhMRr0kSu9Z/o6YUc=;
        b=FdDfqSG+9F6Q8viUz8f8PXH3PjDu3mKdAF+ZlevP4b3RrBtVFNDK8PEP27gQ43jUxA
         sI0w0xxOWu832/VBaNqD3qXxa14MLxwBOJFTfK055E+ThsGJVjDHwf61eSvyuCkovGab
         bTPDr3NnazdU1lMccFjjkcRmzwMWdAimMQ2ra7eZPabAuArcxbDJTTkkAplVDXHuT6BY
         hY8qoCpY/KBMuqvvwJPZXxtnaizO5mqTI7+kjQZlXhuz0Gpf1ZHbMxZoSx4/r65UbelR
         RlFaEgLVW9zD/ASJtW3LrHuFwM1v/YCw0260vs98WNS9oZ74v388s/zbCHgNH4ae8QEz
         lwaA==
X-Gm-Message-State: ANhLgQ36QfZwjEopjB+jVhDF1FSk0bvxCMo4Ecig5DRCmuUtw7jzKQ9O
        hobA9MX/oUDI4Df7XkjhAjI=
X-Google-Smtp-Source: ADFU+vtVJtk+wfaEch5OWCOaEb7w6NqJBoPgRfTMeB3wMCNc0VQygxb89PqwVYaILQx5ATww0dOYmQ==
X-Received: by 2002:a62:520a:: with SMTP id g10mr720673pfb.271.1585100786045;
        Tue, 24 Mar 2020 18:46:26 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:8308])
        by smtp.gmail.com with ESMTPSA id c190sm17014302pfa.66.2020.03.24.18.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 18:46:25 -0700 (PDT)
Date:   Tue, 24 Mar 2020 18:46:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 1/4] xdp: Support specifying expected
 existing program when attaching XDP
Message-ID: <20200325014622.ilhqpfdwgb65jpnq@ast-mbp>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk>
 <158507357313.6925.9859587430926258691.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158507357313.6925.9859587430926258691.stgit@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 07:12:53PM +0100, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> While it is currently possible for userspace to specify that an existing
> XDP program should not be replaced when attaching to an interface, there is
> no mechanism to safely replace a specific XDP program with another.
> 
> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_ID, which can be
> set along with IFLA_XDP_FD. If set, the kernel will check that the program
> currently loaded on the interface matches the expected one, and fail the
> operation if it does not. This corresponds to a 'cmpxchg' memory operation.
> Setting the new attribute with a negative value means that no program is
> expected to be attached, which corresponds to setting the UPDATE_IF_NOEXIST
> flag.
> 
> A new companion flag, XDP_FLAGS_EXPECT_ID, is also added to explicitly
> request checking of the EXPECTED_ID attribute. This is needed for userspace
> to discover whether the kernel supports the new attribute.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Over the years of defining apis to attach bpf progs to different kernel
components the key mistake we made is that we tried to use corresponding
subsystem way of doing thing and it failed every time. What made the problem
worse that this failure we only learned after many years. Attaching xdp via
netlink felt great back then. Attaching clsbpf via tc felt awesome too. Doing
cgroup-bpf via bpf syscall with three different attaching ways also felt great.
All of these attaching things turned out to be broken because all of them
failed to provide the concept of ownership of the attachment. Which caused 10k
clsbpf progs on one netdev, 64 cgroup-bpf progs in one cgroup, nuked xdp progs.
Hence we have to add the ownership model first. Doing mini extensions to
existing apis is not addressing the giant issue of existing apis.

The idea of this patch is to do atomic replacement of xdp prog. It's a good
idea and useful feature, but I don't want to extend existing broken apis to do
add this feature. atomic replacement has to come with thought through owner
model first.
