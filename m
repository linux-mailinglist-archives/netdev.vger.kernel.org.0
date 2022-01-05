Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080B6484B7D
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiAEAIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:08:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:25352 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231153AbiAEAIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 19:08:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641341328; x=1672877328;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=JepRpJLYzlSaO6plfJUd7N28rd7f8sx/+iAnJFEy6K0=;
  b=C7uyUJDebfjsI2MkqTnRB1FaIn36Vl/mww3xK39DE1LxfAg3/u6c8xD1
   2mDKQ2ePB5kAybvni1ftiaYjgXSD47Jt80+t3bKR0cfEahFnfcAlPndsv
   mU8uCAxW7kOl3DoRVCmxnLNPIN86UF8lvemasIWswEK+Zy5tuWTjIr+dN
   Ba9A0M9ABGpaxGL318vYe9GQRe4NeiB5WhBK3y0/BjVSgFc9JJrY15wPE
   EA4Yz0qVe+6HO1Ev6en52q9QPNYV2k7AL7DAOjbnWek5yWAdmagQpouz2
   r/ppAx1U1qWg++3Xioo0nynQWuO594XIDdoEtQ2N/u5D0T+BmOy45ooUN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="266605095"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="266605095"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 16:08:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="611267959"
Received: from marcquat-mobl.amr.corp.intel.com ([10.212.247.3])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 16:08:48 -0800
Date:   Tue, 4 Jan 2022 16:08:47 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>
cc:     syzbot <syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [syzbot] WARNING in page_counter_cancel (3)
In-Reply-To: <Ycwo+++dToWQ1RMR@dhcp22.suse.cz>
Message-ID: <2bc36f6f-e1e5-52-e62-15adf696bdc@linux.intel.com>
References: <00000000000021bb9b05d14bf0c7@google.com> <000000000000f1504c05d36c21ea@google.com> <20211221155736.90bbc5928bcd779e76ca8f95@linux-foundation.org> <Ycwo+++dToWQ1RMR@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021, Michal Hocko wrote:

> On Tue 21-12-21 15:57:36, Andrew Morton wrote:
>> On Sat, 18 Dec 2021 06:04:22 -0800 syzbot <syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com> wrote:
>>
>>> syzbot has found a reproducer for the following issue on:
>>>
>>> HEAD commit:    fbf252e09678 Add linux-next specific files for 20211216
>>> git tree:       linux-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1797de99b00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7fcbb9aa19a433c8
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=bc9e2d2dbcb347dd215a
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135d179db00000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113edb6db00000
>>
>> Useful to have that, thanks.
>>
>> I'm suspecting that mptcp is doing something strange.
>
> Yes.
>
>> Could I as the
>> developers to please take a look?
>>

Andrew -

Yes, we'll get a fix in to net-next soon - thanks for adding the mptcp & 
netdev lists.

>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+bc9e2d2dbcb347dd215a@syzkaller.appspotmail.com
>>>
>>> R13: 00007ffdeb858640 R14: 00007ffdeb858680 R15: 0000000000000004
>>>  </TASK>
>>> ------------[ cut here ]------------
>>> page_counter underflow: -4294966651 nr_pages=4294967295
>
> __mptcp_mem_reclaim_partial is trying to uncharge (via
> __sk_mem_reduce_allocated) negative amount. nr_pages has overflown when
> converted from int to unsigned int (-1). I would say that
> __mptcp_mem_reclaim_partial has evaluated
> 	reclaimable = mptcp_sk(sk)->rmem_fwd_alloc - sk_unused_reserved_mem(sk)
> to 0 and __mptcp_rmem_reclaim(sk, reclaimable - 1) made it -1.

Thanks for the analysis Michal.

--
Mat Martineau
Intel
