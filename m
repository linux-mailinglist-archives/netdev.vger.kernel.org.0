Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B21063A51
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfGIRxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:53:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33515 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfGIRxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 13:53:42 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B046B30BD1A5;
        Tue,  9 Jul 2019 17:53:41 +0000 (UTC)
Received: from krava (ovpn-204-17.brq.redhat.com [10.40.204.17])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4ED1F871C6;
        Tue,  9 Jul 2019 17:53:34 +0000 (UTC)
Date:   Tue, 9 Jul 2019 19:53:33 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Michael Petlan <mpetlan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv2] tools bpftool: Fix json dump crash on powerpc
Message-ID: <20190709175333.GE9579@krava>
References: <20190704085856.17502-1-jolsa@kernel.org>
 <20190704134210.17b8407c@cakuba.netronome.com>
 <20190705121031.GA10777@krava>
 <20190705102452.0831942a@cakuba.netronome.com>
 <83d18af0-8efa-c8d5-3d99-01aed29915df@netronome.com>
 <5168f635-a23c-eac3-479d-747e55adfc4c@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5168f635-a23c-eac3-479d-747e55adfc4c@iogearbox.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 09 Jul 2019 17:53:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 12:00:44AM +0200, Daniel Borkmann wrote:
> On 07/05/2019 07:26 PM, Quentin Monnet wrote:
> > 2019-07-05 10:24 UTC-0700 ~ Jakub Kicinski <jakub.kicinski@netronome.com>
> >> On Fri, 5 Jul 2019 14:10:31 +0200, Jiri Olsa wrote:
> >>> Michael reported crash with by bpf program in json mode on powerpc:
> >>>
> >>>   # bpftool prog -p dump jited id 14
> >>>   [{
> >>>         "name": "0xd00000000a9aa760",
> >>>         "insns": [{
> >>>                 "pc": "0x0",
> >>>                 "operation": "nop",
> >>>                 "operands": [null
> >>>                 ]
> >>>             },{
> >>>                 "pc": "0x4",
> >>>                 "operation": "nop",
> >>>                 "operands": [null
> >>>                 ]
> >>>             },{
> >>>                 "pc": "0x8",
> >>>                 "operation": "mflr",
> >>>   Segmentation fault (core dumped)
> >>>
> >>> The code is assuming char pointers in format, which is not always
> >>> true at least for powerpc. Fixing this by dumping the whole string
> >>> into buffer based on its format.
> >>>
> >>> Please note that libopcodes code does not check return values from
> >>> fprintf callback, but as per Jakub suggestion returning -1 on allocation
> >>> failure so we do the best effort to propagate the error. 
> >>>
> >>> Reported-by: Michael Petlan <mpetlan@redhat.com>
> >>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >>
> >> Thanks, let me repost all the tags (Quentin, please shout if you're
> >> not ok with this :)):
> > 
> > I confirm it's all good for me, thanks :)
> > 
> >> Fixes: 107f041212c1 ("tools: bpftool: add JSON output for `bpftool prog dump jited *` command")
> >> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> >> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> 
> Given merge window coming up, I've applied this to bpf-next, thanks everyone!
> 
> P.s.: Jiri, please repost full/proper patch next time instead of inline reply.

will do, thanks
jirka
