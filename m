Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3006425D2
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438952AbfFLMaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438948AbfFLMaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:30:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C1B9302451A;
        Wed, 12 Jun 2019 12:30:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D06B1001B07;
        Wed, 12 Jun 2019 12:30:38 +0000 (UTC)
Message-ID: <e11118334595e6517e618e80406e0135402cacf1.camel@redhat.com>
Subject: Re: tc tp creation performance degratation since kernel 5.1
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     vladbu@mellanox.com, pablo@netfilter.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, mlxsw@mellanox.com, alexanderk@mellanox.com
Date:   Wed, 12 Jun 2019 14:30:37 +0200
In-Reply-To: <20190612120341.GA2207@nanopsycho>
References: <20190612120341.GA2207@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 12 Jun 2019 12:30:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2019-06-12 at 14:03 +0200, Jiri Pirko wrote:
> I did simple prifiling using perf. Output on 5.1 kernel:
>     77.85%  tc               [kernel.kallsyms]  [k] tcf_chain_tp_find
>      3.30%  tc               [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
>      1.33%  tc_pref_scale.s  [kernel.kallsyms]  [k] do_syscall_64
>      0.60%  tc_pref_scale.s  libc-2.28.so       [.] malloc
>      0.55%  tc               [kernel.kallsyms]  [k] mutex_spin_on_owner
>      0.51%  tc               libc-2.28.so       [.] __memset_sse2_unaligned_erms
>      0.40%  tc_pref_scale.s  libc-2.28.so       [.] __gconv_transform_utf8_internal
>      0.38%  tc_pref_scale.s  libc-2.28.so       [.] _int_free
>      0.37%  tc_pref_scale.s  libc-2.28.so       [.] __GI___strlen_sse2
>      0.37%  tc               [kernel.kallsyms]  [k] idr_get_free
> 
> Output on net-next:
>     39.26%  tc               [kernel.vmlinux]  [k] lock_is_held_type

It looks like you have lockdep enabled here, but not on the 5.1 build.

That would explain such a large perf difference.

Can you please double check?

thanks,

Paolo

