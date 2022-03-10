Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834494D5258
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245128AbiCJTIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245755AbiCJTHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:07:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD9A91704EB
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 11:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646939209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gomJ66m2qIlCZfTfMR2uUo9YuZhsZ2IeOLlcOAVHMx8=;
        b=cOaoUdzS4qjSkupOrQQxwBV9I3w49cqViUMv5K8Hlc1J9079l8ilX5CMfTw30tAepOYNKT
        5iuQuIZEsRAj5Lnsf/DDMv7qUGNIJKdTjzjhRRrH4W0ATO59/M3wjs48ExEFh45+1zc9uS
        8uz2AevqkMFyQBK1NKIsXfx1YY+kfPs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-0KwpklbGMKCcTBdHHNV-Ww-1; Thu, 10 Mar 2022 14:06:47 -0500
X-MC-Unique: 0KwpklbGMKCcTBdHHNV-Ww-1
Received: by mail-ed1-f69.google.com with SMTP id z19-20020a50cd13000000b0041693869e9aso3425795edi.14
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 11:06:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gomJ66m2qIlCZfTfMR2uUo9YuZhsZ2IeOLlcOAVHMx8=;
        b=PkES4wjmC3yZVhLldk8eodhBsbCTII5bK88UqYIuFKJonVhi2NYv1PXul1me2Nhnrn
         cUPdUaselTE6Cg5HHxky0BIQomWzvqts/r+jamleSGqDM08DcGk6HCnIi4miYBt0IlIl
         yg2kwTJ4M2ZmlJgqQwWn+8j5wjS07fPn+iyQmXm+nJWltqFl3P3sX1ZtfmxyRKWq6x0J
         MC/Jrsp+8AKkEpGhUm2N0y3ouHPeIRnZTd9V0J9/HJzvMDAGEgMThXS7BXd7Ly8qOJkX
         vNH4XOcFASy+C3Nbv2dW4eMgf6BJGwIlCxGnLlczg9W+3zHaJwNUPnx+fYWahYAHSqdg
         I/UQ==
X-Gm-Message-State: AOAM530YuSyDrFDQnGKcXRGW1v1eABfk2ZZ7ccnVSpYQiuLICRadqOH2
        vYYWiKE+gxsxJVJGXGwKaXHmocpEDvy7IU8YBQn0dNm4776XFUB7wsZmKZmO9QNuMKwkvOWZO8R
        C9e2UJrHxgS3TdzOI
X-Received: by 2002:a17:907:392:b0:6da:8608:e09e with SMTP id ss18-20020a170907039200b006da8608e09emr5532695ejb.89.1646939204175;
        Thu, 10 Mar 2022 11:06:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxiaHEhq5PmuQ5pJpUk7YD48G/C26A5LJOE3qDro5wWyMo7FbML/7K1pzZyXja5yksV3kfa9Q==
X-Received: by 2002:a17:907:392:b0:6da:8608:e09e with SMTP id ss18-20020a170907039200b006da8608e09emr5532549ejb.89.1646939201654;
        Thu, 10 Mar 2022 11:06:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q9-20020a170906770900b006d20acf7e2bsm2100313ejm.200.2022.03.10.11.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 11:06:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 338381A8960; Thu, 10 Mar 2022 20:06:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH v4 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order
 to accept non-linear skb
In-Reply-To: <YinkUiv/yC/gJhYZ@lore-desk>
References: <cover.1646755129.git.lorenzo@kernel.org>
 <24703dbc3477a4b3aaf908f6226a566d27969f83.1646755129.git.lorenzo@kernel.org>
 <87ee3auk70.fsf@toke.dk> <YinkUiv/yC/gJhYZ@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Mar 2022 20:06:40 +0100
Message-ID: <87ilsly6db.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
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

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> 
>> > Introduce veth_convert_xdp_buff_from_skb routine in order to
>> > convert a non-linear skb into a xdp buffer. If the received skb
>> > is cloned or shared, veth_convert_xdp_buff_from_skb will copy it
>> > in a new skb composed by order-0 pages for the linear and the
>> > fragmented area. Moreover veth_convert_xdp_buff_from_skb guarantees
>> > we have enough headroom for xdp.
>> > This is a preliminary patch to allow attaching xdp programs with frags
>> > support on veth devices.
>> >
>> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> 
>> It's cool that we can do this! A few comments below:
>
> Hi Toke,
>
> thx for the review :)
>
> [...]
>
>> > +static int veth_convert_xdp_buff_from_skb(struct veth_rq *rq,
>> > +					  struct xdp_buff *xdp,
>> > +					  struct sk_buff **pskb)
>> > +{
>> 
>> nit: It's not really "converting" and skb into an xdp_buff, since the
>> xdp_buff lives on the stack; so maybe 'veth_init_xdp_buff_from_skb()'?
>
> I kept the previous naming convention used for xdp_convert_frame_to_buff()
> (my goal would be to move it in xdp.c and reuse this routine for the
> generic-xdp use case) but I am fine with
> veth_init_xdp_buff_from_skb().

Consistency is probably good, but right now we have functions of the
form 'xdp_convert_X_to_Y()' and 'xdp_update_Y_from_X()'. So to follow
that you'd have either 'veth_update_xdp_buff_from_skb()' or
'veth_convert_skb_to_xdp_buff()' :)

>> > +	struct sk_buff *skb = *pskb;
>> > +	u32 frame_sz;
>> >  
>> >  	if (skb_shared(skb) || skb_head_is_locked(skb) ||
>> > -	    skb_is_nonlinear(skb) || headroom < XDP_PACKET_HEADROOM) {
>> > +	    skb_shinfo(skb)->nr_frags) {
>> 
>> So this always clones the skb if it has frags? Is that really needed?
>
> if we look at skb_cow_data(), paged area is always considered not writable

Ah, right, did not know that. Seems a bit odd, but OK.

>> Also, there's a lot of memory allocation and copying going on here; have
>> you measured the performance?
>
> even in the previous implementation we always reallocate the skb if the
> conditions above are verified so I do not expect any difference in the single
> buffer use-case but I will run some performance tests.

No, I wouldn't expect any difference for the single-buffer case, but I
would also be interested in how big the overhead is of having to copy
the whole jumbo-frame?

BTW, just noticed one other change - before we had:

> -	headroom = skb_headroom(skb) - mac_len;
>  	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> -	    skb_is_nonlinear(skb) || headroom < XDP_PACKET_HEADROOM) {


And in your patch that becomes:

> +	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
> +		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
> +		goto drop;


So the mac_len subtraction disappeared; that seems wrong?

>> > +
>> > +	if (xdp_buff_has_frags(&xdp))
>> > +		skb->data_len = skb_shinfo(skb)->xdp_frags_size;
>> > +	else
>> > +		skb->data_len = 0;
>> 
>> We can remove entire frags using xdp_adjust_tail, right? Will that get
>> propagated in the right way to the skb frags due to the dual use of
>> skb_shared_info, or?
>
> bpf_xdp_frags_shrink_tail() can remove entire frags and it will modify
> metadata contained in the skb_shared_info (e.g. nr_frags or the frag
> size of the given page). We should consider the data_len field in this
> case. Agree?

Right, that's what I assumed; makes sense. But adding a comment
mentioning this above the update of data_len might be helpful? :)

-Toke

