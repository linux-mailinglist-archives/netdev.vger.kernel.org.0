Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBA31A45FC
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 13:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDJLyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 07:54:11 -0400
Received: from mail.efficios.com ([167.114.26.124]:56282 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgDJLyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 07:54:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 65477286A26;
        Fri, 10 Apr 2020 07:54:10 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id OhLL-sJwWh0w; Fri, 10 Apr 2020 07:54:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E8B8E2869AC;
        Fri, 10 Apr 2020 07:54:09 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com E8B8E2869AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1586519650;
        bh=Kx29Iw92OSXy/7Br9e44Ry8pSnBhQoTqdlzG5LH6z+I=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=mrrR35HUGZSzy+NZ0lff/kgO/vY/SPCeCemzFSZwzT2Xido3zbebm8VooRF5JGH5w
         K/mcB46yYWlgjHx2KzzSPOk1jDe8g6GEN2EVunnnO6z1gfCXMvwhPiJVj0wXrgD2w7
         rDNeNfwOSjluxTVqkt9UEy2Wvd7NVEkIi92PU7HF16u5AahMBXW87wbza3ErQ5Gnrz
         3JFE04nAM5/PDTpIOV+gwXiWuIAR81DlrqYsBGaoWFk9OmMl4OdUdQj420XkWjGR7P
         8FGFRfzUlkfFY8OyX6QfTpIlBdPZPD35GNmZYA986NcEKmR2JsFn3rplbx6z0z5yHw
         XfgQOjDjpdmUw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6dCVKayr5x8p; Fri, 10 Apr 2020 07:54:09 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id D7DE42869AB;
        Fri, 10 Apr 2020 07:54:09 -0400 (EDT)
Date:   Fri, 10 Apr 2020 07:54:09 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        K <prasad@linux.vnet.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Message-ID: <1752398220.29905.1586519649766.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200409223335.ovetfovkm2d2ca36@ast-mbp.dhcp.thefacebook.com>
References: <20200409193543.18115-1-mathieu.desnoyers@efficios.com> <20200409193543.18115-4-mathieu.desnoyers@efficios.com> <20200409223335.ovetfovkm2d2ca36@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [RFC PATCH 3/9] writeback: tracing: pass global_wb_domain as
 tracepoint parameter
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3918 (ZimbraWebClient - FF74 (Linux)/8.8.15_GA_3895)
Thread-Topic: writeback: tracing: pass global_wb_domain as tracepoint parameter
Thread-Index: e+wVNcVKwMIZDlfQgTHJ8mySzrviLA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Apr 9, 2020, at 6:33 PM, Alexei Starovoitov alexei.starovoitov@gmail.com wrote:

> On Thu, Apr 09, 2020 at 03:35:37PM -0400, Mathieu Desnoyers wrote:
>>  		if (pause < min_pause) {
>> -			trace_balance_dirty_pages(wb,
>> +			trace_balance_dirty_pages(&global_wb_domain,
>> +						  wb,
>>  						  sdtc->thresh,
>>  						  sdtc->bg_thresh,
>>  						  sdtc->dirty,
> 
> argh. 13 arguments to single function ?!
> Currently the call site looks like:
>                        trace_balance_dirty_pages(wb,
>                                                  sdtc->thresh,
>                                                  sdtc->bg_thresh,
>                                                  sdtc->dirty,
>                                                  sdtc->wb_thresh,
>                                                  sdtc->wb_dirty,
>                                                  dirty_ratelimit,
>                                                  task_ratelimit,
>                                                  pages_dirtied,
>                                                  period,
>                                                  min(pause, 0L),
>                                                  start_time);
> Just pass sdtc as a pointer instead.
> Then another wb argument will be fine.

Good point! In order to do that I would need to move the declaration
of struct dirty_throttle_control from mm/page-writeback.c to
include/linux/writeback.h so it can be used from the tracepoint.

Seems fair ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
