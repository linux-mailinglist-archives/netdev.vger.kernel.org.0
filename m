Return-Path: <netdev+bounces-7573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 121EC720A58
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1025281B00
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC0E1F93E;
	Fri,  2 Jun 2023 20:30:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1261F93A
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 20:30:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CC9E5B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685737841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EgKfP9AbuoSBTzMbn1uV6HerF5HUDAS8HMnZsL2qkJ4=;
	b=FcZT64dt8bfpsXDHVO5qe62hgnhC1xmN6dOw8Muv/mOWuIdQLnu/gL8j3PzeoZk9vZqm6M
	8HNFgpq3xHJXtPexelzf8mf9D8AK98aZ426QPRKnfj1AFHwnkIfmnXsTADGmUXxU+X97dL
	j0wPaaOqdnwncVjXDhI7Z8hFD9Rq99k=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-UdFlm01SM4CAxOFnPVx1Zw-1; Fri, 02 Jun 2023 16:30:40 -0400
X-MC-Unique: UdFlm01SM4CAxOFnPVx1Zw-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-789adaf5182so841421241.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 13:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685737840; x=1688329840;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgKfP9AbuoSBTzMbn1uV6HerF5HUDAS8HMnZsL2qkJ4=;
        b=QvV7yeSdNd4+t5Q+oRTNv3VZIyjq36PaX/WRQbljTA4VIX1aR7VMwnyzk2edQolpsT
         aOllcKqiHuXDTPTAckztdbOUlyePKxJS3UM4Bzv0TSPdeTacW2/dfou7PyOcJWzEl5sS
         Ny9LHqZSbBQdeOOOezByClyY/jlviI4lA2UJyji3s+wo2hSPmAn6MkqQCDIj8YI9D7yb
         PWsDoBHUhqOiWkhTAoSJLZ+fDaQoe6Ky3tZxMqQA5toxMIMy4MQn1xcKZTisbLzgisBG
         BP906h1bZM/ScZpK9V90kniHoYbv1gdvzfioxpDuhT5w1IN6d4dPOuUZ03UUCtMupAMz
         +84Q==
X-Gm-Message-State: AC+VfDxzQTgDwS3xYZSolxaC6NhqXE3hKzFMU9HCTOvV5Wh9GfKtMBJl
	96VHXGh00vZKjTDl11c78M4ql35q2/R6NVSch39lQlT34ViCbTQnlJU4B5gFHJC7PF0ZmQ4Bz/6
	1d7a1tiIIJQ4OUFffbw6rYEg2ubR6iFss
X-Received: by 2002:a67:fe97:0:b0:437:db1d:7edb with SMTP id b23-20020a67fe97000000b00437db1d7edbmr5626346vsr.6.1685737839634;
        Fri, 02 Jun 2023 13:30:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6FROtjx8Mxi1OsExYeNOSibtQDsQb5aCnR+NQbW9yl56xV0YRkPBCmEEmN9SXG4CMV8AAVqKfUYSk5LuRwFiw=
X-Received: by 2002:a67:fe97:0:b0:437:db1d:7edb with SMTP id
 b23-20020a67fe97000000b00437db1d7edbmr5626320vsr.6.1685737839395; Fri, 02 Jun
 2023 13:30:39 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Jun 2023 13:30:38 -0700
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-9-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517110232.29349-9-jhs@mojatatu.com>
Date: Fri, 2 Jun 2023 13:30:38 -0700
Message-ID: <CALnP8ZZk8-ZowUcvD1UZTBsVjxth7xaTY1CwvJUYj8XJEKhkeg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 09/28] p4tc: add P4 data types
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:13AM -0400, Jamal Hadi Salim wrote:
> +bool p4tc_type_unsigned(int typeid)

Nit, maybe name it p4tc_is_type_unsigned() instead.

> +{
> +	switch (typeid) {
> +	case P4T_U8:
> +	case P4T_U16:
> +	case P4T_U32:
> +	case P4T_U64:
> +	case P4T_U128:
> +	case P4T_BOOL:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +int p4t_copy(struct p4tc_type_mask_shift *dst_mask_shift,
> +	     struct p4tc_type *dst_t, void *dstv,
> +	     struct p4tc_type_mask_shift *src_mask_shift,
> +	     struct p4tc_type *src_t, void *srcv)
> +{
> +	u64 readval[BITS_TO_U64(P4TC_MAX_KEYSZ)] = {0};
> +	const struct p4tc_type_ops *srco, *dsto;
> +
> +	dsto = dst_t->ops;
> +	srco = src_t->ops;
> +
> +	__p4tc_type_host_read(srco, src_t, src_mask_shift, srcv,
> +			      &readval);
> +	__p4tc_type_host_write(dsto, dst_t, dst_mask_shift, &readval,
> +			       dstv);
> +
> +	return 0;

The return value on these (write) functions seems to be inconsistent.
All the write functions are returning 0. Then, __p4tc_type_host_write
itself propagates the return value, but then here it doesn't.

> +}
> +
> +int p4t_cmp(struct p4tc_type_mask_shift *dst_mask_shift,
> +	    struct p4tc_type *dst_t, void *dstv,
> +	    struct p4tc_type_mask_shift *src_mask_shift,
> +	    struct p4tc_type *src_t, void *srcv)
> +{
> +	u64 a[BITS_TO_U64(P4TC_MAX_KEYSZ)] = {0};
> +	u64 b[BITS_TO_U64(P4TC_MAX_KEYSZ)] = {0};
> +	const struct p4tc_type_ops *srco, *dsto;
> +
> +	dsto = dst_t->ops;
> +	srco = src_t->ops;
> +
> +	__p4tc_type_host_read(dsto, dst_t, dst_mask_shift, dstv, a);
> +	__p4tc_type_host_read(srco, src_t, src_mask_shift, srcv, b);
> +
> +	return memcmp(a, b, sizeof(a));
> +}
> +
> +void p4t_release(struct p4tc_type_mask_shift *mask_shift)
> +{
> +	kfree(mask_shift->mask);
> +	kfree(mask_shift);
> +}
> +
> +static int p4t_validate_bitpos(u16 bitstart, u16 bitend, u16 maxbitstart,
> +			       u16 maxbitend, struct netlink_ext_ack *extack)
> +{
> +	if (bitstart > maxbitstart) {
> +		NL_SET_ERR_MSG_MOD(extack, "bitstart too high");
> +		return -EINVAL;
> +	}
> +	if (bitend > maxbitend) {
> +		NL_SET_ERR_MSG_MOD(extack, "bitend too high");
> +		return -EINVAL;
> +	}

Do we want a condition for
 +	if (bitstart > bitend) {
 +		NL_SET_ERR_MSG_MOD(extack, "bitstart after bitend");
 +		return -EINVAL;
 +	}
?

> +
> +	return 0;
> +}
> +
> +//XXX: Latter immedv will be 64 bits
> +static int p4t_u32_validate(struct p4tc_type *container, void *value,
> +			    u16 bitstart, u16 bitend,
> +			    struct netlink_ext_ack *extack)
> +{
> +	u32 container_maxsz = U32_MAX;
> +	u32 *val = value;
> +	size_t maxval;
> +	int ret;
> +
> +	ret = p4t_validate_bitpos(bitstart, bitend, 31, 31, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	maxval = GENMASK(bitend, 0);
> +	if (val && (*val > container_maxsz || *val > maxval)) {
> +		NL_SET_ERR_MSG_MOD(extack, "U32 value out of range");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct p4tc_type_mask_shift *
> +p4t_u32_bitops(u16 bitsiz, u16 bitstart, u16 bitend,
> +	       struct netlink_ext_ack *extack)
> +{
> +	u32 mask = GENMASK(bitend, bitstart);
> +	struct p4tc_type_mask_shift *mask_shift;
> +	u32 *cmask;
> +
> +	mask_shift = kzalloc(sizeof(*mask_shift), GFP_KERNEL);
> +	if (!mask_shift)
> +		return ERR_PTR(-ENOMEM);
> +
> +	cmask = kzalloc(sizeof(u32), GFP_KERNEL);
> +	if (!cmask) {
> +		kfree(mask_shift);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	*cmask = mask;
> +
> +	mask_shift->mask = cmask;
> +	mask_shift->shift = bitstart;

AFAICT, mask_shift->mask is never shared. So maybe consider
embedding mask onto mask_shift itself, to avoid the double allocation.
I mean, something like
+	mask_shift = kzalloc(sizeof(*mask_shift)+sizeof(u32), GFP_KERNEL);
+	cmask = mask_shift+1;

This may also help with cache miss later on.

> +
> +	return mask_shift;
> +}


