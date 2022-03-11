Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC34D643E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347402AbiCKPDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347307AbiCKPDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:03:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A55E1A41F2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647010937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhFk1vrA84GqSz25RsRFDbGtNHQdmxiZdJu+41NtC5A=;
        b=Oev2s7NmT00NEg1cljtvaHCha5HBDPUfMo0dz9JYwC2YUAmfJcaeG7m6/w7eT8piGQpI35
        Ip5Adg8jP+rsxJBSav0533FEZR9hBlzsHoGVDy9jhoqK1A29ab3b4NQoUyOttlKFZ/av38
        nah5Y0wC+EvipUO1Hx1K2HdQJhq70p8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-rZo9iPZSMyCFlDrvHQf0xg-1; Fri, 11 Mar 2022 10:02:15 -0500
X-MC-Unique: rZo9iPZSMyCFlDrvHQf0xg-1
Received: by mail-ej1-f69.google.com with SMTP id el10-20020a170907284a00b006db9df1f3bbso1667333ejc.5
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:02:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bhFk1vrA84GqSz25RsRFDbGtNHQdmxiZdJu+41NtC5A=;
        b=YQG6bouOZhO/aPs1VG/JmSOabK7brgU3VGCf7acPXSs49CsPLow6gz0TpnFbWKFh9Z
         hLj+Y+6Y1SuA5i214FuU9WKaTH8CDCB40b7SqEHS0jKQA+Ax35v6lqQfPzMk0PCg56yd
         AuuHMFL4Hk24oGnj6WYLJ/ZmS8q2vNxF9kV3nABtrxnZYYWtOhx1TLOmryfLwM/7ibOF
         oUphr9PiaQc1qgKeC/39ypdsJOFM2gPKUQyBFKBnh/rXcSVbx5E3q8tD468cSR3eWu/V
         2vP/01CjK2iGp8JJW2C32/H2jmluO8asJSTShpgjEuaYlnTjBXqEH4ybAzoIkI1wT9MR
         NtTQ==
X-Gm-Message-State: AOAM531xEaXYigqYPyT7jbsNEeqPhPOLIeT4z7QLZyl7AtgQRWBTl+s9
        MQvoQmeuN1WitEC67KnsrEWHKWyERskKe5S8UU7GKT4m5UMU6VkzQOeuFYrWz1UTJCuEIk6OBPH
        vrvVymPZ50+IfHn9A
X-Received: by 2002:a05:6402:51cd:b0:416:a841:22a0 with SMTP id r13-20020a05640251cd00b00416a84122a0mr9249843edd.292.1647010931890;
        Fri, 11 Mar 2022 07:02:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQqG7/HKprlozH6n4cYd5+WV/+EBJ822bf0OnhKKBU64innPa8mWZQ3flMcquO9EbmlWsSog==
X-Received: by 2002:a05:6402:51cd:b0:416:a841:22a0 with SMTP id r13-20020a05640251cd00b00416a84122a0mr9249685edd.292.1647010930106;
        Fri, 11 Mar 2022 07:02:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b006b2511ea97dsm3033434ejc.42.2022.03.11.07.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 07:02:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E251F1AB573; Fri, 11 Mar 2022 16:02:08 +0100 (CET)
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
        syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpf, test_run: Fix packet size check for
 live packet mode
In-Reply-To: <20220311000511.atows3k5uzggg6wf@kafai-mbp.dhcp.thefacebook.com>
References: <20220310225621.53374-1-toke@redhat.com>
 <20220311000511.atows3k5uzggg6wf@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Mar 2022 16:02:08 +0100
Message-ID: <87sfrown0v.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Thu, Mar 10, 2022 at 11:56:20PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> The live packet mode uses some extra space at the start of each page to
>> cache data structures so they don't have to be rebuilt at every repetiti=
on.
>> This space wasn't correctly accounted for in the size checking of the
>> arguments supplied to userspace. In addition, the definition of the frame
>> size should include the size of the skb_shared_info (as there is other
>> logic that subtracts the size of this).
>>=20
>> Together, these mistakes resulted in userspace being able to trip the
>> XDP_WARN() in xdp_update_frame_from_buff(), which syzbot discovered in
>> short order. Fix this by changing the frame size define and adding the
>> extra headroom to the bpf_prog_test_run_xdp() function. Also drop the
>> max_len parameter to the page_pool init, since this is related to DMA wh=
ich
>> is not used for the page pool instance in PROG_TEST_RUN.
>>=20
>> Reported-by: syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com
>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RU=
N")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  net/bpf/test_run.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>> index 24405a280a9b..e7b9c2636d10 100644
>> --- a/net/bpf/test_run.c
>> +++ b/net/bpf/test_run.c
>> @@ -112,8 +112,7 @@ struct xdp_test_data {
>>  	u32 frame_cnt;
>>  };
>>=20=20
>> -#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head)	\
>> -			     - sizeof(struct skb_shared_info))
>> +#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
>>  #define TEST_XDP_MAX_BATCH 256
>>=20=20
>>  static void xdp_test_run_init_page(struct page *page, void *arg)
>> @@ -156,7 +155,6 @@ static int xdp_test_run_setup(struct xdp_test_data *=
xdp, struct xdp_buff *orig_c
>>  		.flags =3D 0,
>>  		.pool_size =3D xdp->batch_size,
>>  		.nid =3D NUMA_NO_NODE,
>> -		.max_len =3D TEST_XDP_FRAME_SIZE,
>>  		.init_callback =3D xdp_test_run_init_page,
>>  		.init_arg =3D xdp,
>>  	};
>> @@ -1230,6 +1228,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, c=
onst union bpf_attr *kattr,
>>  			batch_size =3D NAPI_POLL_WEIGHT;
>>  		else if (batch_size > TEST_XDP_MAX_BATCH)
>>  			return -E2BIG;
>> +
>> +		headroom +=3D sizeof(struct xdp_page_head);
> The orig_ctx->data_end will ensure there is a sizeof(struct skb_shared_in=
fo)
> tailroom ?  It is quite tricky to read but I don't have a better idea
> either.

Yeah, the length checks are all done for the non-live data case (in
bpf_test_init()), so seemed simpler to just account the extra headroom
to those checks instead of adding an extra check to the live-packet
code.

> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks!

-Toke

