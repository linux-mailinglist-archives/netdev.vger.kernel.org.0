Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379C742949
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfFLOcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:32:02 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:10731 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729515AbfFLOcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:32:02 -0400
Received: (qmail 7291 invoked by uid 89); 12 Jun 2019 14:31:59 -0000
Received: from unknown (HELO ?172.26.107.103?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4y) (POLARISLOCAL)  
  by smtp6.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 12 Jun 2019 14:31:59 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>
Cc:     "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, toke@redhat.com, brouer@redhat.com,
        bpf@vger.kernel.org, saeedm@mellanox.com
Subject: Re: [PATCH bpf-next v3 0/5] net: xdp: refactor XDP program queries
Date:   Wed, 12 Jun 2019 07:31:54 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <EE1DFA29-96A7-4887-9A34-92FD50927487@flugsvamp.com>
In-Reply-To: <980c54f7-e270-f6cf-089d-969cebad8f38@intel.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com>
 <20190610152433.6e265d6c@cakuba.netronome.com>
 <980c54f7-e270-f6cf-089d-969cebad8f38@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; markup=markdown
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11 Jun 2019, at 0:24, Björn Töpel wrote:

> On 2019-06-11 00:24, Jakub Kicinski wrote:
>> On Mon, 10 Jun 2019 18:02:29 +0200, Björn Töpel wrote:
>>> Jakub, what's your thoughts on the special handling of XDP offloading?
>>> Maybe it's just overkill? Just allocate space for the offloaded
>>> program regardless support or not? Also, please review the
>>> dev_xdp_support_offload() addition into the nfp code.
>>
>> I'm not a huge fan of the new approach - it adds a conditional move,
>> dereference and a cache line reference to the fast path :(
>>
>> I think it'd be fine to allocate entries for all 3 types, but the
>> potential of slowing down DRV may not be a good thing in a refactoring
>> series.
>>
>
> Note, that currently it's "only" the XDP_SKB path that's affected, but
> yeah, I agree with out. And going forward, I'd like to use the netdev
> xdp_prog from the Intel drivers, instead of spreading/caching it all over.
>
> I'll go back to the drawing board. Any suggestions on a how/where the
> program should be stored in the netdev are welcome! :-) ...or maybe just
> simply store the netdev_xdp flat (w/o the additional allocation step) in
> net_device. Three programs and the boolean (remove the num_progs).

A flat allocation does seem like the best path forward.

Thanks for keeping at this!
-- 
Jonathan
