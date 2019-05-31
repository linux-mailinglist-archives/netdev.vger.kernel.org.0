Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F78E31261
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfEaQaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:30:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34319 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfEaQaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:30:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id w7so4209595plz.1;
        Fri, 31 May 2019 09:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+TC1ZEuJVMf9cYDscNN1L/YA+s3eaLT61FuMkopOfdA=;
        b=E4rSsxlIiPunscjhQIDe68AkOavfgmSZMRTKh0S9besP15p5CNnZFUwLWNlkbwtTZa
         c7DulZJnDJWmb6DcFEpg92Ae7bCrBghecqE2bw9FKKVcF8EuWOYZO1rYGrYgZpQhRRSg
         W1oXLshlloyQmwUB0b+UhQVA6QU0SIkxNICwaOrw96dt2ubtJSYPVkjiOhAj+xJCSgCy
         GLkOIppXA1+Ucm1sknXyBHJbGE0MWdtWLQWICOBalb4M9H5RTFvTiue2vV/smCBsNV4s
         lPz6X0pyuwVzDc8Vbjd1Yiu3x4cx94X4meSw7GVsEGiV50LY4mU1WXfx+4u2Em4J9P3I
         QANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+TC1ZEuJVMf9cYDscNN1L/YA+s3eaLT61FuMkopOfdA=;
        b=XGgwBs7d1tUM0YjGPt46GBKpWFU9Jb4duXkWsCVvpPwOD/QeeXwErU5nxgCQjTdbKl
         YFJ3XwHQADJ/8I8bZvvPIeCeUP2aQFSqvcqtw7oCDOYaWDM7T49EqBxnotfuTtdTrFbu
         qg6zqCOptJ1Rr7Vv+hardqDt99CFTmMuBWSSnhEAunVeg7GOroYSI1E6I8vocaUJeSj3
         +qBNiq36jyXSIBcScziVL/nureOWVNCdTnzYpLvbb7belrRWZmC8PwqgD40nSjkxXX/b
         uOW/lhEZt1fsYzHazWasx3z0TO2RYzhUjr4HDsNogMEnmOvoKdLCioi56WPuU/eI1J8b
         3Low==
X-Gm-Message-State: APjAAAXTlqhQL22K1Kzjcsg/tSzDxO9jdlaIdJL5PE3MzAHJgHa8QErg
        KHEJFn8vsLOJHE4rbxky3kA=
X-Google-Smtp-Source: APXvYqxk8QJNglowg7DP3kiiLTiEF8CoWeOPAV86xptfZMBPpWU2izlSPKZK1iYOfPsg/OSj/UTdtw==
X-Received: by 2002:a17:902:c7:: with SMTP id a65mr10528473pla.182.1559320207933;
        Fri, 31 May 2019 09:30:07 -0700 (PDT)
Received: from [172.26.115.243] ([2620:10d:c090:180::779])
        by smtp.gmail.com with ESMTPSA id p63sm5858209pgp.65.2019.05.31.09.30.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:30:07 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        kernel-team@fb.com, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/2] libbpf: remove qidconf and better support
 external bpf programs.
Date:   Fri, 31 May 2019 09:30:06 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <80213576-3DE9-4FCA-8B9F-D8C1F85C9378@gmail.com>
In-Reply-To: <9ad272ae-936c-1bb1-5a56-657b13ac69ba@intel.com>
References: <20190530185709.1861867-1-jonathan.lemon@gmail.com>
 <20190530185709.1861867-2-jonathan.lemon@gmail.com>
 <9ad272ae-936c-1bb1-5a56-657b13ac69ba@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 May 2019, at 4:55, Björn Töpel wrote:

> On 2019-05-30 20:57, Jonathan Lemon wrote:
>> Use the recent change to XSKMAP bpf_map_lookup_elem() to test if
>> there is a xsk present in the map instead of duplicating the work
>> with qidconf.
>>
>> Fix things so callers using XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD
>> bypass any internal bpf maps, so xsk_socket__{create|delete} works
>> properly.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>   tools/lib/bpf/xsk.c | 79 
>> +++++++++------------------------------------
>>   1 file changed, 16 insertions(+), 63 deletions(-)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index 38667b62f1fe..a150493d51ec 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -60,10 +60,8 @@ struct xsk_socket {
>>   	struct xsk_umem *umem;
>>   	struct xsk_socket_config config;
>>   	int fd;
>> -	int xsks_map;
>>   	int ifindex;
>>   	int prog_fd;
>> -	int qidconf_map_fd;
>>   	int xsks_map_fd;
>>   	__u32 queue_id;
>>   	char ifname[IFNAMSIZ];
>> @@ -265,15 +263,11 @@ static int xsk_load_xdp_prog(struct xsk_socket 
>> *xsk)
>>   	/* This is the C-program:
>>   	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>>   	 * {
>> -	 *     int *qidconf, index = ctx->rx_queue_index;
>> +	 *     int index = ctx->rx_queue_index;
>>   	 *
>>   	 *     // A set entry here means that the correspnding queue_id
>>   	 *     // has an active AF_XDP socket bound to it.
>> -	 *     qidconf = bpf_map_lookup_elem(&qidconf_map, &index);
>> -	 *     if (!qidconf)
>> -	 *         return XDP_ABORTED;
>> -	 *
>> -	 *     if (*qidconf)
>> +	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
>>   	 *         return bpf_redirect_map(&xsks_map, index, 0);
>>   	 *
>>   	 *     return XDP_PASS;
>> @@ -286,15 +280,10 @@ static int xsk_load_xdp_prog(struct xsk_socket 
>> *xsk)
>>   		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
>>   		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
>>   		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
>> -		BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
>> +		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
>>   		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>>   		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
>> -		BPF_MOV32_IMM(BPF_REG_0, 0),
>> -		/* if r1 == 0 goto +8 */
>> -		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
>>   		BPF_MOV32_IMM(BPF_REG_0, 2),
>> -		/* r1 = *(u32 *)(r1 + 0) */
>> -		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
>>   		/* if r1 == 0 goto +5 */
>>   		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
>>   		/* r2 = *(u32 *)(r10 - 4) */
>> @@ -366,18 +355,11 @@ static int xsk_create_bpf_maps(struct 
>> xsk_socket *xsk)
>>   	if (max_queues < 0)
>>   		return max_queues;
>>  -	fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "qidconf_map",
>> +	fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "xsks_map",
>>   				 sizeof(int), sizeof(int), max_queues, 0);
>>   	if (fd < 0)
>>   		return fd;
>> -	xsk->qidconf_map_fd = fd;
>>  -	fd = bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
>> -				 sizeof(int), sizeof(int), max_queues, 0);
>> -	if (fd < 0) {
>> -		close(xsk->qidconf_map_fd);
>> -		return fd;
>> -	}
>
> Uhm, you're removing the XSKMAP here, replacing it with an ARRAY. Have
> you run this?

Err... I've been running the code, but this version is wrong.   Let me 
respin this.
-- 
Jonathan
