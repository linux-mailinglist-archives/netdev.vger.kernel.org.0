Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47EFCF4A8
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbfJHIJj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Oct 2019 04:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbfJHIJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 04:09:38 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8D6C2026F
        for <netdev@vger.kernel.org>; Tue,  8 Oct 2019 08:09:37 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id j10so4061003lja.21
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 01:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kYDmbLHk/9d7NfrTCWV0Mv6CJV1qIpwez3d+yPbTwTA=;
        b=kcQLh04oGzx61uRWR0Wkah+iaXwFLFw/MPgUMLKlT8GsF5UhmjMgDCUfxVLe7gZrFK
         DFdfj0PkzPgVEkwGNiQ7s+/+4RiEjS+SdfOiR/pxKW42qSqGeVrK1Il3/2x/kAaTH1ba
         NowqP0C7ab67wedBq7FeFXUiO5T1zfpwkLTsmGExGXWPlRb9KLLL6kP9S/zHNzhV4Ajm
         LSpnQozBvM9Atp8p09ZEHyAOQJj8+5fK53Rv4exE7BpNyL1PXcWco7ph9hHjxNO0DRFv
         MGaU31KyUmCnY0U6Rvx+gI7Q0us/ZeHkUxzvjS2touwXI+gu9hTrW2lsu5Cplqu1AjDx
         vDCw==
X-Gm-Message-State: APjAAAXZAr0VYzFIcKS38utI01abPWlZtaRwI1zrPO5uNU5WqwKKa0BK
        LBE/v8BMePX4WMZpQj8ONXYcG0EI2gJq106gZQZ+cX0Plofk1L/Nn9rqztym5KizwFJdN8Enshd
        pPjcSbWyOPqRmziZk
X-Received: by 2002:ac2:46d0:: with SMTP id p16mr19089029lfo.190.1570522176077;
        Tue, 08 Oct 2019 01:09:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxAle2Dm5tkCYnO9J0WNp0pWXk447zxc1i+Ur/5bkOCZdo2MGSXCFM3n4kvLgPWHNE+pTpZ6Q==
X-Received: by 2002:ac2:46d0:: with SMTP id p16mr19089017lfo.190.1570522175832;
        Tue, 08 Oct 2019 01:09:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id m6sm3807131ljj.3.2019.10.08.01.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:09:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5ACB218063D; Tue,  8 Oct 2019 10:09:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/5] bpf: Add support for setting chain call sequence for programs
In-Reply-To: <20191007203855.GE27307@pc-66.home>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1> <157046883723.2092443.3902769602513209987.stgit@alrua-x1> <20191007203855.GE27307@pc-66.home>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Oct 2019 10:09:34 +0200
Message-ID: <87pnj7lku9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On Mon, Oct 07, 2019 at 07:20:37PM +0200, Toke Høiland-Jørgensen wrote:
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> This adds support for setting and deleting bpf chain call programs through
>> a couple of new commands in the bpf() syscall. The CHAIN_ADD and CHAIN_DEL
>> commands take two eBPF program fds and a return code, and install the
>> 'next' program to be chain called after the 'prev' program if that program
>> returns 'retcode'. A retcode of -1 means "wildcard", so that the program
>> will be executed regardless of the previous program's return code.
>> 
>> 
>> The syscall command names are based on Alexei's prog_chain example[0],
>> which Alan helpfully rebased on current bpf-next. However, the logic and
>> program storage is obviously adapted to the execution logic in the previous
>> commit.
>> 
>> [0] https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/commit/?h=prog_chain&id=f54f45d00f91e083f6aec2abe35b6f0be52ae85b&context=15
>> 
>> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  include/uapi/linux/bpf.h |   10 ++++++
>>  kernel/bpf/syscall.c     |   78 ++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 88 insertions(+)
>> 
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 1ce80a227be3..b03c23963af8 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -107,6 +107,9 @@ enum bpf_cmd {
>>  	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
>>  	BPF_MAP_FREEZE,
>>  	BPF_BTF_GET_NEXT_ID,
>> +	BPF_PROG_CHAIN_ADD,
>> +	BPF_PROG_CHAIN_DEL,
>> +	BPF_PROG_CHAIN_GET,
>>  };
>>  
>>  enum bpf_map_type {
>> @@ -516,6 +519,13 @@ union bpf_attr {
>>  		__u64		probe_offset;	/* output: probe_offset */
>>  		__u64		probe_addr;	/* output: probe_addr */
>>  	} task_fd_query;
>> +
>> +	struct { /* anonymous struct used by BPF_PROG_CHAIN_* commands */
>> +		__u32		prev_prog_fd;
>> +		__u32		next_prog_fd;
>> +		__u32		retcode;
>> +		__u32		next_prog_id;   /* output: prog_id */
>> +	};
>>  } __attribute__((aligned(8)));
>>  
>>  /* The description below is an attempt at providing documentation to eBPF
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index b8a203a05881..be8112e08a88 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -2113,6 +2113,79 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
>>  	return ret;
>>  }
>>  
>> +#define BPF_PROG_CHAIN_LAST_FIELD next_prog_id
>> +
>> +static int bpf_prog_chain(int cmd, const union bpf_attr *attr,
>> +			  union bpf_attr __user *uattr)
>> +{
>> +	struct bpf_prog *prog, *next_prog, *old_prog;
>> +	struct bpf_prog **array;
>> +	int ret = -EOPNOTSUPP;
>> +	u32 index, prog_id;
>> +
>> +	if (CHECK_ATTR(BPF_PROG_CHAIN))
>> +		return -EINVAL;
>> +
>> +	/* Index 0 is wildcard, encoded as ~0 by userspace */
>> +	if (attr->retcode == ((u32) ~0))
>> +		index = 0;
>> +	else
>> +		index = attr->retcode + 1;
>> +
>> +	if (index >= BPF_NUM_CHAIN_SLOTS)
>> +		return -E2BIG;
>> +
>> +	prog = bpf_prog_get(attr->prev_prog_fd);
>> +	if (IS_ERR(prog))
>> +		return PTR_ERR(prog);
>> +
>> +	/* If the chain_calls bit is not set, that's because the chain call flag
>> +	 * was not set on program load, and so we can't support chain calls.
>> +	 */
>> +	if (!prog->chain_calls)
>> +		goto out;
>> +
>> +	array = prog->aux->chain_progs;
>> +
>> +	switch (cmd) {
>> +	case BPF_PROG_CHAIN_ADD:
>> +		next_prog = bpf_prog_get(attr->next_prog_fd);
>> +		if (IS_ERR(next_prog)) {
>> +			ret = PTR_ERR(next_prog);
>> +			break;
>> +		}
>> +		old_prog = xchg(array + index, next_prog);
>> +		if (old_prog)
>> +			bpf_prog_put(old_prog);
>> +		ret = 0;
>> +		break;
>
> How are circular dependencies resolved here? Seems the situation is
> not prevented, so progs unloaded via XDP won't get the __bpf_prog_free()
> call where they then drop the references of all the other progs in the
> chain.

Yeah, that's true. My plan was to just walk the "call graph" on insert
and reject any circular inserts. Just haven't gotten around to adding
that yet; will fix that in the next version.

-Toke
