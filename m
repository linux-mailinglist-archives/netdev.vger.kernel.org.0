Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F6D25A1B5
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIAW6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgIAW6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:58:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B210EC061244;
        Tue,  1 Sep 2020 15:58:45 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so1317527plt.3;
        Tue, 01 Sep 2020 15:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Z6lznRG9/Iqho0xWpHP0iTcZfXXeRHi0Gycs+Q4/cJE=;
        b=gxQzMJ7WVJb6WYTDKt0GktFrxho8i4W2vBzsKQL/A0CYfKEwjGKOiosrkhphBOmpBK
         dZoHa07nrGbKK2V/Fnt17MgriEzZzg0aukXFaKXNLxwKaPUYJ373DN83hsq0UgPIJfZb
         ssnVQJHugommP6wn+d98G0SQpMcNIi15AfkhYKJB0UdtKeR2nA9v+DgOzeGRnTYsq+VV
         4VjsAPHHcpCMYW1Yqdvb7kxjlCNdNht8XLmQZKH5ihBAPIM0Bf6fYyeoNLIlqKjicDTL
         xbjtEkT1C2fW2UA3jFyvJ7IrQ+XmYF6PVPs2LQiHPJ63Z4fYv4D1ragUx41CFYBmpPSh
         9Ecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z6lznRG9/Iqho0xWpHP0iTcZfXXeRHi0Gycs+Q4/cJE=;
        b=BBT9xNW/AaGNf2pTTUFPz02xCDZRymxK/BXBBJC/Ffd9TpWoOMe1Y63ZaMVS1+jAS/
         r0c/Z/7kZcKCKRHxoIa4jKPvIJ+pzeIS3I+6MbgZkbPIFwAIWm7XkSyLqreJx9kAISNy
         nFK6/dgqgr/iPi8K5fAh0IUIMOIHcBHwfmECDbNaYMLr5/eLU+MIqpaMG517u8oQT8b/
         GTS+1+IOqEW+yWb+O/luZpn/hcei6qlUd2l5gyOUVzRMX7Uaov3tZ+KwalNazEy84Jsl
         iwcCt2vn/0tH1H8SqraY9dRbM5cw7+ksGRbHllFOAU5ViHEcZSp2XXwL8HO+dw/dmcq9
         L0IQ==
X-Gm-Message-State: AOAM531zlAxL8TxEQq8szGBvEfALFQcu6WyZ1AzmmkpTOeWruDVSEEMJ
        kcjtnTxmdgPIMsgOvzLJ+TU=
X-Google-Smtp-Source: ABdhPJyzqYOjI8vlsKtCbX2ekCE+VDluHXj0/UpzaFVPk7/eQ5SngFU6mJDqdfDqxf12ANeZI2vvyQ==
X-Received: by 2002:a17:90b:3cb:: with SMTP id go11mr3377640pjb.152.1599001125191;
        Tue, 01 Sep 2020 15:58:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:19aa])
        by smtp.gmail.com with ESMTPSA id s8sm3188382pfm.180.2020.09.01.15.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:58:43 -0700 (PDT)
Date:   Tue, 1 Sep 2020 15:58:41 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei1999@gmail.com>, andriin@fb.com
Subject: Re: [PATCH bpf-next v3 4/8] libbpf: implement bpf_prog_find_metadata
Message-ID: <20200901225841.qpsugarocx523dmy@ast-mbp.dhcp.thefacebook.com>
References: <20200828193603.335512-1-sdf@google.com>
 <20200828193603.335512-5-sdf@google.com>
 <874koma34d.fsf@toke.dk>
 <20200831154001.GC48607@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200831154001.GC48607@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 08:40:01AM -0700, sdf@google.com wrote:
> On 08/28, Toke H�iland-J�rgensen wrote:
> > Stanislav Fomichev <sdf@google.com> writes:
> 
> > > This is a low-level function (hence in bpf.c) to find out the metadata
> > > map id for the provided program fd.
> > > It will be used in the next commits from bpftool.
> > >
> > > Cc: Toke H�iland-J�rgensen <toke@redhat.com>
> > > Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/lib/bpf/bpf.c      | 74 ++++++++++++++++++++++++++++++++++++++++
> > >  tools/lib/bpf/bpf.h      |  1 +
> > >  tools/lib/bpf/libbpf.map |  1 +
> > >  3 files changed, 76 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > > index 5f6c5676cc45..01c0ede1625d 100644
> > > --- a/tools/lib/bpf/bpf.c
> > > +++ b/tools/lib/bpf/bpf.c
> > > @@ -885,3 +885,77 @@ int bpf_prog_bind_map(int prog_fd, int map_fd,
> > >
> > >  	return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
> > >  }
> > > +
> > > +int bpf_prog_find_metadata(int prog_fd)
> > > +{
> > > +	struct bpf_prog_info prog_info = {};
> > > +	struct bpf_map_info map_info;
> > > +	__u32 prog_info_len;
> > > +	__u32 map_info_len;
> > > +	int saved_errno;
> > > +	__u32 *map_ids;
> > > +	int nr_maps;
> > > +	int map_fd;
> > > +	int ret;
> > > +	int i;
> > > +
> > > +	prog_info_len = sizeof(prog_info);
> > > +
> > > +	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	if (!prog_info.nr_map_ids)
> > > +		return -1;
> > > +
> > > +	map_ids = calloc(prog_info.nr_map_ids, sizeof(__u32));
> > > +	if (!map_ids)
> > > +		return -1;
> > > +
> > > +	nr_maps = prog_info.nr_map_ids;
> > > +	memset(&prog_info, 0, sizeof(prog_info));
> > > +	prog_info.nr_map_ids = nr_maps;
> > > +	prog_info.map_ids = ptr_to_u64(map_ids);
> > > +	prog_info_len = sizeof(prog_info);
> > > +
> > > +	ret = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &prog_info_len);
> > > +	if (ret)
> > > +		goto free_map_ids;
> > > +
> > > +	ret = -1;
> > > +	for (i = 0; i < prog_info.nr_map_ids; i++) {
> > > +		map_fd = bpf_map_get_fd_by_id(map_ids[i]);
> > > +		if (map_fd < 0) {
> > > +			ret = -1;
> > > +			goto free_map_ids;
> > > +		}
> > > +
> > > +		memset(&map_info, 0, sizeof(map_info));
> > > +		map_info_len = sizeof(map_info);
> > > +		ret = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
> > > +		saved_errno = errno;
> > > +		close(map_fd);
> > > +		errno = saved_errno;
> > > +		if (ret)
> > > +			goto free_map_ids;
> 
> > If you get to this point on the last entry in the loop, ret will be 0,
> > and any of the continue statements below will end the loop, causing the
> > whole function to return 0. While this is not technically a valid ID, it
> > still seems odd that the function returns -1 on all error conditions
> > except this one.
> 
> > Also, it would be good to be able to unambiguously distinguish between
> > "this program has no metadata associated" and "something went wrong
> > while querying the kernel for metadata (e.g., permission error)". So
> > something that amounts to a -ENOENT return; I guess turning all return
> > values into negative error codes would do that (and also do away with
> > the need for the saved_errno dance above), but id does clash a bit with
> > the convention in the rest of the file (where all the other functions
> > just return -1 and set errno)...
> Good point. I think I can change the function signature to:
> 
> 	int bpf_prog_find_metadata(int prog_fd, int *map_id)
> 
> And explicitly return map_id via argument. Then the ret can be used as
> -1/0 error and I can set errno appropriately where it makes sense.
> This will better match the convention we have in this file.

I don't feel great about this libbpf api. bpftool already does
bpf_obj_get_info_by_fd() for progs and for maps.
This extra step and extra set of syscalls is redundant work.
I think it's better to be done as part of bpftool.
It doesn't quite fit as generic api.
