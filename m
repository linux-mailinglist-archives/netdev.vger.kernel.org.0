Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B1F12660B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLSPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:47:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:50000 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfLSPrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:47:07 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihy13-0000Ip-BL; Thu, 19 Dec 2019 16:47:05 +0100
Date:   Thu, 19 Dec 2019 16:47:04 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Edwin Peer <epeer@juniper.net>
Cc:     Y Song <ys114321@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Message-ID: <20191219154704.GC4198@linux-9.fritz.box>
References: <20191219013534.125342-1-epeer@juniper.net>
 <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
 <69266F42-6D0B-4F0B-805C-414880AC253D@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69266F42-6D0B-4F0B-805C-414880AC253D@juniper.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 02:50:42PM +0000, Edwin Peer wrote:
> On 12/18/19, 23:19, "Y Song" <ys114321@gmail.com> wrote:
> 
> >  Added cc to bpf@vger.kernel.org.
>
> Thank you, I will remember to do this next time.
>
> > Have you tried your patch with some bpf programs? verifier and jit  put some
> > restrictions on unpriv programs. To truely test the program, most if not all these
> > restrictions should be lifted, so the same tested program should be able to
> > run on production server and vice verse.
> 
> Agreed, I am aware of some of these differences in the load/verifier behavior with and without
> CAP_SYS_ADMIN. In particular, without CAP_SYS_ADMIN programs are still restricted to 4k, some helpers are not available (spin locks, trace printk) and there are some differences in context access checks.
> 
> I think these can be addressed incrementally, assuming folk are on board with this approach in general?

What about CAP_BPF? IIRC, there are also other issues e.g. you could abuse
the test interface as a packet generator (bpf_clone_redirect) which is not
something fully unpriv should be doing.

Thanks,
Daniel
