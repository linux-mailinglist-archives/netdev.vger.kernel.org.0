Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723321D2C86
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgENKWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:22:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:32966 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgENKWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:22:08 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZAzy-0007F0-Dx; Thu, 14 May 2020 12:21:54 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZAzx-000RXX-Tr; Thu, 14 May 2020 12:21:53 +0200
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     David Laight <David.Laight@ACULAB.COM>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "bgregg@netflix.com" <bgregg@netflix.com>
References: <20200513160038.2482415-1-hch@lst.de>
 <20200513160038.2482415-12-hch@lst.de>
 <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
 <20200513192804.GA30751@lst.de>
 <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
 <20200513232816.GZ23230@ZenIV.linux.org.uk>
 <866cbe54-a027-04eb-65db-c6423d16b924@iogearbox.net>
 <6ca8d8499bf644aba0b242d194df5a60@AcuMS.aculab.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2cc83197-3ecc-b8c2-742d-e953c1f7bf8c@iogearbox.net>
Date:   Thu, 14 May 2020 12:21:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6ca8d8499bf644aba0b242d194df5a60@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 12:01 PM, David Laight wrote:
[...]
> If it's not a stupid question why is a BPF program allowed to get
> into a situation where it might have an invalid kernel address.
> 
> It all stinks of a hole that allows all of kernel memory to be read
> and copied to userspace.
> 
> Now you might want to something special so that BPF programs just
> abort on OOPS instead of possibly paniking the kernel.
> But that is different from a copy that expects to be passed garbage.

I suggest you read up on probe_kernel_read() and its uses in tracing in
general, looks like you haven't done that.
