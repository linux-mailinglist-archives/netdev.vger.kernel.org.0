Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C680B486606
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 15:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbiAFO2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 09:28:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239914AbiAFO2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 09:28:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641479326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wKJ1mPwObqH/MnKEsnkO0BZSurZ6kA0eO6sa4cHwvAc=;
        b=boQs4DudgarEZ0dj4NBDiA7Dtk1PSXLPrHCIa4t9u1Vosd9AUyiubhKutg93s+LjVaGvYu
        eHXDuan3Y7QdPhkoBePVfWpDXFEinRVSnlqIfzixQSLmPUMz8qJrZgVKdPiOz1DVnxb4aS
        qe+OW6/1W25G4ExLnd+uXagBzsWMEJc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-V2HJdASOPdOwz-tCVoibWg-1; Thu, 06 Jan 2022 09:28:45 -0500
X-MC-Unique: V2HJdASOPdOwz-tCVoibWg-1
Received: by mail-ed1-f69.google.com with SMTP id x19-20020a05640226d300b003f8b80f5729so2052503edd.13
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 06:28:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wKJ1mPwObqH/MnKEsnkO0BZSurZ6kA0eO6sa4cHwvAc=;
        b=EW9zzFnLVKoig4oEpKCBycSccB609P71ukq0iTI1mJXbG1YvAtS3cvq4xcTgiplExf
         MCEwFty4R0N3xm5GHuKKAp7o9P5sfugwzgGacY6OhUuvjTHwUsFPlCeBIMj7qBg/jMEM
         wtYo+r4pAIea76tOQbMkVWCGmwFOPpT827nYXpVE8GTYiMK8jydLIgreUabMOxPMeo2b
         mbgrHx4TQpGBKBtWkqXXTpj4a3hSnFlTWK0CxMbm5eNFgpTe7SPA0EQ7g10tkYZKa/qz
         9YJ7bPyjKPI4/S9bs1ok1yCHa6EmccQLtni2U3p9gcW/4ydi2wnaN4CUzcj4OnumDfmo
         4YLQ==
X-Gm-Message-State: AOAM531mLVzENhLiSiILIvKR1AG/DE+7iniSox6ye0Id3+eS4ZKiyuKX
        nHMe0qT+wu/ve0GP38sEqvPMEOR/mROEbNDgwRgOHTX2Ejll1pvhW3h+kgGPnNpo/+hylLG09JA
        TWuS6x3rdiupeVC9i
X-Received: by 2002:a05:6402:2211:: with SMTP id cq17mr6668207edb.380.1641479324039;
        Thu, 06 Jan 2022 06:28:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyrK9obIO+dlnSMkar0Yt/gFfV8kj1kacu79HPEVklYuiNK8OzMZNtW3ES9rdxF3Rm9mS27w==
X-Received: by 2002:a05:6402:2211:: with SMTP id cq17mr6668181edb.380.1641479323715;
        Thu, 06 Jan 2022 06:28:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sg39sm530674ejc.66.2022.01.06.06.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 06:28:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E004E181F2A; Thu,  6 Jan 2022 15:28:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 6/7] bpf: Add "live packet" mode for XDP in
 bpf_prog_run()
In-Reply-To: <20220106042618.kperh3ovyuckxecl@ast-mbp.dhcp.thefacebook.com>
References: <20220103150812.87914-1-toke@redhat.com>
 <20220103150812.87914-7-toke@redhat.com>
 <20220106042618.kperh3ovyuckxecl@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 06 Jan 2022 15:28:41 +0100
Message-ID: <871r1laqg6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Jan 03, 2022 at 04:08:11PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> +static void xdp_test_run_init_page(struct page *page, void *arg)
>> +{
>> +	struct xdp_page_head *head =3D phys_to_virt(page_to_phys(page));
>> +	struct xdp_buff *new_ctx, *orig_ctx;
>> +	u32 headroom =3D XDP_PACKET_HEADROOM;
>> +	struct xdp_test_data *xdp =3D arg;
>> +	size_t frm_len, meta_len;
>> +	struct xdp_frame *frm;
>> +	void *data;
>> +
>> +	orig_ctx =3D xdp->orig_ctx;
>> +	frm_len =3D orig_ctx->data_end - orig_ctx->data_meta;
>> +	meta_len =3D orig_ctx->data - orig_ctx->data_meta;
>> +	headroom -=3D meta_len;
>> +
>> +	new_ctx =3D &head->ctx;
>> +	frm =3D &head->frm;
>> +	data =3D &head->data;
>> +	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
>> +
>> +	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
>> +	xdp_prepare_buff(new_ctx, data, headroom, frm_len, true);
>> +	new_ctx->data_meta =3D new_ctx->data + meta_len;
>
> data vs data_meta is the other way around, no?
>
> Probably needs a selftest to make sure.

Yup, you're right; nice catch! Will fix and add a test for it.

>> +static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
>> +			   struct net_device *dev)
>> +{
>> +	gfp_t gfp =3D __GFP_ZERO | GFP_ATOMIC;
>> +	void *skbs[TEST_XDP_BATCH];
>> +	int i, n;
>> +	LIST_HEAD(list);
>> +
>> +	n =3D kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
>> +	if (unlikely(n =3D=3D 0)) {
>> +		for (i =3D 0; i < nframes; i++)
>> +			xdp_return_frame(frames[i]);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	for (i =3D 0; i < nframes; i++) {
>> +		struct xdp_frame *xdpf =3D frames[i];
>> +		struct sk_buff *skb =3D skbs[i];
>> +
>> +		skb =3D __xdp_build_skb_from_frame(xdpf, skb, dev);
>> +		if (!skb) {
>> +			xdp_return_frame(xdpf);
>> +			continue;
>> +		}
>> +
>> +		list_add_tail(&skb->list, &list);
>> +	}
>> +	netif_receive_skb_list(&list);
>
> Does it need local_bh_disable() like cpumap does?

Yes, I think it probably does, actually. Or at least having it can
potentially improve performance since we're then sure that the whole
batch will be processed at once. Will add!

> I've applied patches 1 - 5.

Thanks! Will respin this and the selftest :)

