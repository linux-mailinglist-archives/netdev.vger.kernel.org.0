Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB5321BA
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 06:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfFBESq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 00:18:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39830 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfFBESp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 00:18:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so6302598pgc.6
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 21:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=pMJ8L8I70hKCFx1peo1Tj4AQ1YX+T2CWcjBLbH4nK4Q=;
        b=ecFO1wQGVq63FJhBerluLfjzAGPKqcLho0ZxyYdhU2E+S0GcDb/spPnGN1CtXTsq/N
         PuOTTB/z8SCpw82LU6dUnKlIoeFABiMGClML017Ucv0t6BRGYIyIuiLW6Sunq3EB6T3E
         K1qjA1YInTvFedUXc2H7dgS+UdWpQsJXOn4BFB/2V3tjekAD0LUUayyCFJU6e4DwhVDb
         O9lh3N55EYApEKTQ0C6/dZUmlsQv2mDA/UX6fLTNnWJMW0zQlp8z4s8YMoExADwktS79
         vpoToB38/q36Xom598E1aASN8Q2jyr7WzXYSAHebUo6Vs+DRwIISUfjaoIyPbG1Uyw3e
         Zljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=pMJ8L8I70hKCFx1peo1Tj4AQ1YX+T2CWcjBLbH4nK4Q=;
        b=mT1K9eBbkZR8hPtzfyfWeb9mDB3EbIDXa2rrxlxASbEEQ4jtbEODGqzbG0HIRff3+R
         q7Lm/cn3NVNn/5dx97qGBe3LCSTZMQSYb12ItHyq6JoAcvvgbPQWpbQqnuh/6526a0QD
         fkKwijsUJG+m4YXMCiAb3F4XHbS5eeKytQO/yqaUyN+OzpuVzZhlwdQrS8/NsoEXf6/U
         6PSFHW20eU7SZ0+Dk6Djh1I6HQZ0AW91dW+C2IAJXjlDXscXEWCn/Gl+GC5km+MZJS3I
         XlUR9F0uzOlA5RsLQb2TUyb33Lwq3YfHpR0m1CUxQznUZbJxO68BDjPHH8KMDRAazL4O
         3X1Q==
X-Gm-Message-State: APjAAAV85aJtJ9IWutL31qWPj2VYAhNnhXYqVV6XPMfslvhOmAUrY6Fl
        OTP9EoHvfk0DNinhQ4ZU+Uc=
X-Google-Smtp-Source: APXvYqww4dmRKiTCrWeKwr/bQV3tmp/bv4xvsgXEu860wrGbiJQ2LMbfJ/MN4kWiDTP9YmID+1h7iQ==
X-Received: by 2002:a62:e718:: with SMTP id s24mr22085703pfh.247.1559449124947;
        Sat, 01 Jun 2019 21:18:44 -0700 (PDT)
Received: from [172.26.118.241] ([2620:10d:c090:180::4267])
        by smtp.gmail.com with ESMTPSA id j64sm26031597pfb.126.2019.06.01.21.18.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 21:18:44 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Song Liu" <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v3 bpf-next 2/2] libbpf: remove qidconf and better support
 external bpf programs.
Date:   Sat, 01 Jun 2019 21:18:42 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <A2F3C0B9-FFA2-4EB3-8A20-A0D5D89A8C63@gmail.com>
In-Reply-To: <02CA9EF5-1380-4FE0-9479-C619C1792C2E@fb.com>
References: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
 <20190531185705.2629959-3-jonathan.lemon@gmail.com>
 <02CA9EF5-1380-4FE0-9479-C619C1792C2E@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1 Jun 2019, at 16:05, Song Liu wrote:

>> On May 31, 2019, at 11:57 AM, Jonathan Lemon 
>> <jonathan.lemon@gmail.com> wrote:
>>
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
>> tools/lib/bpf/xsk.c | 79 
>> +++++++++------------------------------------
>> 1 file changed, 16 insertions(+), 63 deletions(-)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index 38667b62f1fe..7ce7494b5b50 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -60,10 +60,8 @@ struct xsk_socket {
>> 	struct xsk_umem *umem;
>> 	struct xsk_socket_config config;
>> 	int fd;
>> -	int xsks_map;
>> 	int ifindex;
>> 	int prog_fd;
>> -	int qidconf_map_fd;
>> 	int xsks_map_fd;
>> 	__u32 queue_id;
>> 	char ifname[IFNAMSIZ];
>> @@ -265,15 +263,11 @@ static int xsk_load_xdp_prog(struct xsk_socket 
>> *xsk)
>> 	/* This is the C-program:
>> 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>> 	 * {
>> -	 *     int *qidconf, index = ctx->rx_queue_index;
>> +	 *     int index = ctx->rx_queue_index;
>> 	 *
>> 	 *     // A set entry here means that the correspnding queue_id
>> 	 *     // has an active AF_XDP socket bound to it.
>> -	 *     qidconf = bpf_map_lookup_elem(&qidconf_map, &index);
>> -	 *     if (!qidconf)
>> -	 *         return XDP_ABORTED;
>> -	 *
>> -	 *     if (*qidconf)
>> +	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
>> 	 *         return bpf_redirect_map(&xsks_map, index, 0);
>> 	 *
>> 	 *     return XDP_PASS;
>> @@ -286,15 +280,10 @@ static int xsk_load_xdp_prog(struct xsk_socket 
>> *xsk)
>> 		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
>> 		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
>> 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
>> -		BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
>> +		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
>> 		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>> 		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
>> -		BPF_MOV32_IMM(BPF_REG_0, 0),
>> -		/* if r1 == 0 goto +8 */
>> -		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
>> 		BPF_MOV32_IMM(BPF_REG_0, 2),
>> -		/* r1 = *(u32 *)(r1 + 0) */
>> -		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
>> 		/* if r1 == 0 goto +5 */
>> 		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
>> 		/* r2 = *(u32 *)(r10 - 4) */
>> @@ -366,18 +355,11 @@ static int xsk_create_bpf_maps(struct 
>> xsk_socket *xsk)
>> 	if (max_queues < 0)
>> 		return max_queues;
>>
>> -	fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "qidconf_map",
>> +	fd = bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
>> 				 sizeof(int), sizeof(int), max_queues, 0);
>> 	if (fd < 0)
>> 		return fd;
>> -	xsk->qidconf_map_fd = fd;
>>
>> -	fd = bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
>> -				 sizeof(int), sizeof(int), max_queues, 0);
>> -	if (fd < 0) {
>> -		close(xsk->qidconf_map_fd);
>> -		return fd;
>> -	}
>> 	xsk->xsks_map_fd = fd;
>>
>> 	return 0;
>> @@ -385,10 +367,8 @@ static int xsk_create_bpf_maps(struct xsk_socket 
>> *xsk)
>>
>> static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
>> {
>> -	close(xsk->qidconf_map_fd);
>> +	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
>> 	close(xsk->xsks_map_fd);
>> -	xsk->qidconf_map_fd = -1;
>> -	xsk->xsks_map_fd = -1;
>> }
>>
>> static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>> @@ -417,10 +397,9 @@ static int xsk_lookup_bpf_maps(struct xsk_socket 
>> *xsk)
>> 	if (err)
>> 		goto out_map_ids;
>>
>> -	for (i = 0; i < prog_info.nr_map_ids; i++) {
>> -		if (xsk->qidconf_map_fd != -1 && xsk->xsks_map_fd != -1)
>> -			break;
>> +	xsk->xsks_map_fd = -1;
>>
>> +	for (i = 0; i < prog_info.nr_map_ids; i++) {
>> 		fd = bpf_map_get_fd_by_id(map_ids[i]);
>> 		if (fd < 0)
>> 			continue;
>> @@ -431,11 +410,6 @@ static int xsk_lookup_bpf_maps(struct xsk_socket 
>> *xsk)
>> 			continue;
>> 		}
>>
>> -		if (!strcmp(map_info.name, "qidconf_map")) {
>> -			xsk->qidconf_map_fd = fd;
>> -			continue;
>> -		}
>> -
>> 		if (!strcmp(map_info.name, "xsks_map")) {
>> 			xsk->xsks_map_fd = fd;
>> 			continue;
>> @@ -445,40 +419,18 @@ static int xsk_lookup_bpf_maps(struct 
>> xsk_socket *xsk)
>> 	}
>>
>> 	err = 0;
>> -	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
>> +	if (xsk->xsks_map_fd == -1)
>> 		err = -ENOENT;
>> -		xsk_delete_bpf_maps(xsk);
>> -	}
>>
>> out_map_ids:
>> 	free(map_ids);
>> 	return err;
>> }
>>
>> -static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
>> -{
>> -	int qid = false;
>> -
>> -	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
>> -	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
>> -}
>> -
>> static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>> {
>> -	int qid = true, fd = xsk->fd, err;
>> -
>> -	err = bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, 
>> &qid, 0);
>> -	if (err)
>> -		goto out;
>> -
>> -	err = bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id, &fd, 
>> 0);
>> -	if (err)
>> -		goto out;
>> -
>> -	return 0;
>> -out:
>> -	xsk_clear_bpf_maps(xsk);
>> -	return err;
>> +	return bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id,
>> +				   &xsk->fd, 0);
>> }
>>
>> static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>> @@ -514,6 +466,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket 
>> *xsk)
>>
>> out_load:
>> 	close(xsk->prog_fd);
>> +	xsk->prog_fd = -1;
>
> I found xsk->prog_fd confusing. Why do we need to set it here?

I suppose this one isn't strictly required - I set it as a guard out of 
habit.
xsk is (currently) immediately freed by the caller, so it can be 
removed.


The main logic is:

         xsk->prog_fd = -1;
         if (!(xsk->config.libbpf_flags & 
XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
                 err = xsk_setup_xdp_prog(xsk);

The user may pass INHIBIT_PROG_LOAD, which bypasses setting up the xdp 
program
(and any maps associated with the program), allowing installation of a 
custom
program.  The cleanup behavior is then gated on prog_fd being -1,

>
> I think we don't need to call xsk_delete_bpf_maps() in out_load path?

Hmm, there's two out_load paths, but only one needs the delete maps 
call.  Let
me redo the error handling so it's a bit more explicit.


>
>> out_maps:
>> 	xsk_delete_bpf_maps(xsk);
>> 	return err;
>> @@ -643,9 +596,7 @@ int xsk_socket__create(struct xsk_socket 
>> **xsk_ptr, const char *ifname,
>> 		goto out_mmap_tx;
>> 	}
>>
>> -	xsk->qidconf_map_fd = -1;
>> -	xsk->xsks_map_fd = -1;
>> -
>> +	xsk->prog_fd = -1;
>> 	if (!(xsk->config.libbpf_flags & 
>> XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
>> 		err = xsk_setup_xdp_prog(xsk);
>> 		if (err)
>> @@ -708,8 +659,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>> 	if (!xsk)
>> 		return;
>>
>> -	xsk_clear_bpf_maps(xsk);
>> -	xsk_delete_bpf_maps(xsk);
>> +	if (xsk->prog_fd != -1) {
>> +		xsk_delete_bpf_maps(xsk);
>> +		close(xsk->prog_fd);
>
> Here, we use prog_fd != -1 to gate xsk_delete_bpf_maps(), which is
> confusing. I looked at the code for quite sometime, but still cannot
> confirm it is correct.

See above reasoning - with INHIBIT_PROG_LOAD, there is no 
library-provided
program or maps, so cleanup actions are skipped.
-- 
Jonathan
