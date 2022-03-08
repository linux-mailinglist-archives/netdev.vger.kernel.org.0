Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026014D1AA0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347487AbiCHOca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiCHOc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:32:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A00714C401
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 06:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646749890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11rSMqkt5h4J9wgWOO8VPCq+RX8Ja7zQktk67NCGg1A=;
        b=U8rH7HV5a9L/7jy/JocptcvQP2sQA3xAr2R0v7lT+RDErw8zfBnKBhLa14/PODB/PLiZcc
        HbTgf/YLeSF8bWEEHSNAS8hrlpApGD2HjUMNH20GPcUPW6FW+RP+6kR9b8taROGgDfPT91
        g3KJD/bJ6XEScfHzhPFjeaBJJ6BqI9U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-XXrGHj3wPuyYiOv_p6NCnw-1; Tue, 08 Mar 2022 09:31:28 -0500
X-MC-Unique: XXrGHj3wPuyYiOv_p6NCnw-1
Received: by mail-ed1-f71.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so10710924edb.2
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 06:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=11rSMqkt5h4J9wgWOO8VPCq+RX8Ja7zQktk67NCGg1A=;
        b=QHawqOwLkfjMxx0KxpDrfPIU+h+GpWXiR7T/sPye72x8AlQ87fNiVeH8hwqKrhRZoK
         8wYV4yMsqVZQbc/wr7h7Ag9CwyEp9cAksEJHb8xRXhUkHepoOUUdg3MG5m2bqPxWhUxa
         9craKvCxnsLz/rWnJEDP+KSZW9G09vK85A/g9wyNS50HOpueqcGT33iDjWwhUFzNOdOq
         KhOHJwdxVPrIJqMd4SiaxjoV7seOZRG0kdJROuXWl8CG5iAtLhOV8zfxZhihYtItVxPp
         hWrmIXSNff5YZ5K3YH0OA0cq0vBhv1k6V9UK33UoZuGuAHBHnAqpjXr208q8DZRuTjnC
         enIg==
X-Gm-Message-State: AOAM533YFNtE3YpcfkIGddq3GtgRahISEY90LYNTIVBhSQ6izm0v5A1u
        z+BtaM3M11WV/HrdKv3gLNZFNOY7qfU3d+8OuRM03mpT+UorD9fOEDZTcQ5ZFnsTg921xZEZgrb
        A30DaEbBLsoYYtD13
X-Received: by 2002:a17:907:9691:b0:6d1:711d:9050 with SMTP id hd17-20020a170907969100b006d1711d9050mr14189782ejc.755.1646749887115;
        Tue, 08 Mar 2022 06:31:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9TM63YED6kWCsyd9Q1X/xwPSpTCvLWHajMO/2ixeFbzuUTm7V1cblirjITbwrjBFrAZTAOA==
X-Received: by 2002:a17:907:9691:b0:6d1:711d:9050 with SMTP id hd17-20020a170907969100b006d1711d9050mr14189739ejc.755.1646749886623;
        Tue, 08 Mar 2022 06:31:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t4-20020a056402524400b00415b90801edsm7898726edd.57.2022.03.08.06.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:31:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C053C1928C6; Tue,  8 Mar 2022 15:31:24 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Add "live packet" mode for XDP in
 BPF_PROG_RUN
In-Reply-To: <20220308013517.b7xyhqainqmc255o@kafai-mbp.dhcp.thefacebook.com>
References: <20220306223404.60170-1-toke@redhat.com>
 <20220306223404.60170-2-toke@redhat.com>
 <20220308013517.b7xyhqainqmc255o@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Mar 2022 15:31:24 +0100
Message-ID: <877d94y0qr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Sun, Mar 06, 2022 at 11:34:00PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 4eebea830613..a36065872882 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -1232,6 +1232,10 @@ enum {
>>=20=20
>>  /* If set, run the test on the cpu specified by bpf_attr.test.cpu */
>>  #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
>> +/* Guaranteed to be rejected in XDP tests (for probing) */
>> +#define BPF_F_TEST_XDP_RESERVED	(1U << 1)
>> +/* If set, XDP frames will be transmitted after processing */
>> +#define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 2)
>>=20=20
>>  /* type for BPF_ENABLE_STATS */
>>  enum bpf_stats_type {
>> @@ -1393,6 +1397,7 @@ union bpf_attr {
>>  		__aligned_u64	ctx_out;
>>  		__u32		flags;
>>  		__u32		cpu;
>> +		__u32		batch_size;
>>  	} test;
>>=20=20
>>  	struct { /* anonymous struct used by BPF_*_GET_*_ID */
>
> [ ... ]
>
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index db402ebc5570..9beb585be5a6 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -3336,7 +3336,7 @@ static int bpf_prog_query(const union bpf_attr *at=
tr,
>>  	}
>>  }
>>=20=20
>> -#define BPF_PROG_TEST_RUN_LAST_FIELD test.cpu
>> +#define BPF_PROG_TEST_RUN_LAST_FIELD test.batch_size
> Instead of adding BPF_F_TEST_XDP_RESERVED,
> probing by non-zero batch_size (=3D=3D 1) should be as good?

Hmm, yeah, good point; added the RESERVED flag before the batch_size;
guess it's not needed anymore.

> [ ... ]
>
>> +static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_pro=
g *prog,
>> +			      u32 repeat)
>> +{
>> +	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>> +	int err =3D 0, act, ret, i, nframes =3D 0, batch_sz;
>> +	struct xdp_frame **frames =3D xdp->frames;
>> +	struct xdp_page_head *head;
>> +	struct xdp_frame *frm;
>> +	bool redirect =3D false;
>> +	struct xdp_buff *ctx;
>> +	struct page *page;
>> +
>> +	batch_sz =3D min_t(u32, repeat, xdp->batch_size);
>> +
>> +	local_bh_disable();
>> +	xdp_set_return_frame_no_direct();
>> +
>> +	for (i =3D 0; i < batch_sz; i++) {
>> +		page =3D page_pool_dev_alloc_pages(xdp->pp);
>> +		if (!page) {
>> +			err =3D -ENOMEM;
>> +			goto out;
>> +		}
>> +
>> +		head =3D phys_to_virt(page_to_phys(page));
>> +		reset_ctx(head);
>> +		ctx =3D &head->ctx;
>> +		frm =3D &head->frm;
>> +		xdp->frame_cnt++;
>> +
>> +		act =3D bpf_prog_run_xdp(prog, ctx);
>> +
>> +		/* if program changed pkt bounds we need to update the xdp_frame */
>> +		if (unlikely(ctx_was_changed(head))) {
>> +			err =3D xdp_update_frame_from_buff(ctx, frm);
>> +			if (err) {
>> +				xdp_return_buff(ctx);
>> +				continue;
>> +			}
>> +		}
>> +
>> +		switch (act) {
>> +		case XDP_TX:
>> +			/* we can't do a real XDP_TX since we're not in the
>> +			 * driver, so turn it into a REDIRECT back to the same
>> +			 * index
>> +			 */
>> +			ri->tgt_index =3D xdp->dev->ifindex;
>> +			ri->map_id =3D INT_MAX;
>> +			ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
>> +			fallthrough;
>> +		case XDP_REDIRECT:
>> +			redirect =3D true;
>> +			err =3D xdp_do_redirect_frame(xdp->dev, ctx, frm, prog);
> err of the previous iteration is over written.
>
>> +			if (err)
>> +				xdp_return_buff(ctx);
>> +			break;
>> +		case XDP_PASS:
>> +			frames[nframes++] =3D frm;
>> +			break;
>> +		default:
>> +			bpf_warn_invalid_xdp_action(NULL, prog, act);
>> +			fallthrough;
>> +		case XDP_DROP:
>> +			xdp_return_buff(ctx);
>> +			break;
>> +		}
>> +	}
>> +
>> +out:
>> +	if (redirect)
>> +		xdp_do_flush();
>> +	if (nframes) {
>> +		ret =3D xdp_recv_frames(frames, nframes, xdp->skbs, xdp->dev);
>> +		if (ret)
>> +			err =3D ret;
> but here is trying to avoid over writing the err if possible.
>
>> +	}
>> +
>> +	xdp_clear_return_frame_no_direct();
>> +	local_bh_enable();
>> +	return err;
> so only err happens in the last iteration will break the loop in
> bpf_test_run_xdp_live()?

Ah, excellent catch. This is also an artefact of earlier revisions where
any error would break the loop. Since that is no longer the case, we
should only propagate fatal errors (i.e., memory allocation errors
during the run); will fix!

-Toke

