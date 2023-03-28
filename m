Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED6E6CBCEE
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 12:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjC1K5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 06:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjC1K5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 06:57:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616F472AA
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 03:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680000975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tx6w/NoxDwZy1sJXzEpKewVTB38oj2z0f8QKEmor2kM=;
        b=D47Jro1zActPrE+a2ZjgXoP89jynZTmjaJRXkbSC8ALinUBqZMJPa1Ilc9KMwpTOwWsFde
        kpUbfcVvPw3jCMplZDx7u0f9GvSshMOYAsEvnCIVX+wdo0vSLg2Lqk7u3LnhPw28FrZhHI
        FZuGvhPCL5eeqHHesw8ko+zzv4RbWW0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-XJNRV9lwM8u_dw8XEylGHw-1; Tue, 28 Mar 2023 06:56:14 -0400
X-MC-Unique: XJNRV9lwM8u_dw8XEylGHw-1
Received: by mail-qt1-f200.google.com with SMTP id l13-20020a05622a174d00b003e4df699997so5722462qtk.20
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 03:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680000973;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tx6w/NoxDwZy1sJXzEpKewVTB38oj2z0f8QKEmor2kM=;
        b=KGdLhBi4iz7RN6BVC5f8FwZ3FT77FERQRUeZIMVqfsN2VHF3y7VRKDNcQfm12Qg240
         7SaevREAObGVE9GZ3xxknbaeVj0f3Is4SwyXSQvo71ryfWfpeI0olAolmlYZzS7vBzNP
         ajZUaPDODhhuomm5Kec9Kn7Lzw9rVMSf1El23rBe8oQ9AbQk0lYF+Sla9jglzRjfpeCA
         FCjbLFp7uodkDCqUdsZ7K7csvN0157Zp85fX6WY8dy15ihc1oFlI0TIAAgeCQBQNF/XO
         Q7e9NtmeAwjdkn1tpkhFFamxWed0+yLBc4inO7ABH+w91ECh+eAQBj9I5aFawjBSK4PM
         qw9g==
X-Gm-Message-State: AAQBX9crUKPZB+Vuhr2ILWWlJ8kRsmkDEjExEX6VrZ8uDcTXsLXsGdB6
        Qks3wzWdUsQwDi60C2C5xKMZXBL4Viv5m+X5zpGXeZ+WNe+tOnPNvbkOea/Z427BmCDVlJIrs2c
        iKLULYgqtbH5bo+E71CXEhX8t
X-Received: by 2002:a05:6214:27c6:b0:5ac:463b:a992 with SMTP id ge6-20020a05621427c600b005ac463ba992mr23570851qvb.0.1680000973762;
        Tue, 28 Mar 2023 03:56:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350YoJ1hu+cmlWRCRMngdhv9I0pHFod7SIKCQg1c/gYLu9JE0o2UCKpqfgcuCH709qp40s94LAw==
X-Received: by 2002:a05:6214:27c6:b0:5ac:463b:a992 with SMTP id ge6-20020a05621427c600b005ac463ba992mr23570827qvb.0.1680000973448;
        Tue, 28 Mar 2023 03:56:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-148.dyn.eolo.it. [146.241.232.148])
        by smtp.gmail.com with ESMTPSA id u13-20020a0cee8d000000b005dd8b9345f2sm3684704qvr.138.2023.03.28.03.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 03:56:12 -0700 (PDT)
Message-ID: <e6b7c24026e3750ea3e10a5ebf26bf2dd903e2a1.camel@redhat.com>
Subject: Re: [net-next Patch v5 5/6] octeontx2-pf: Add support for HTB
 offload
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvel.com,
        edumazet@google.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, maxtram95@gmail.com
Date:   Tue, 28 Mar 2023 12:56:08 +0200
In-Reply-To: <20230326181245.29149-6-hkelam@marvell.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
         <20230326181245.29149-6-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-03-26 at 23:42 +0530, Hariprasad Kelam wrote:
[...]
> +static int otx2_qos_root_add(struct otx2_nic *pfvf, u16 htb_maj_id, u16 =
htb_defcls,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct otx2_qos_cfg *new_cfg;
> +	struct otx2_qos_node *root;
> +	int err;
> +
> +	netdev_dbg(pfvf->netdev,
> +		   "TC_HTB_CREATE: handle=3D0x%x defcls=3D0x%x\n",
> +		   htb_maj_id, htb_defcls);
> +
> +	INIT_LIST_HEAD(&pfvf->qos.qos_tree);
> +	mutex_init(&pfvf->qos.qos_lock);

It's quite strange and error prone dynamically init this mutex and the
list here. Why don't you do such init ad device creation time?

> +
> +	root =3D otx2_qos_alloc_root(pfvf);
> +	if (IS_ERR(root)) {
> +		mutex_destroy(&pfvf->qos.qos_lock);
> +		err =3D PTR_ERR(root);
> +		return err;
> +	}
> +
> +	/* allocate txschq queue */
> +	new_cfg =3D kzalloc(sizeof(*new_cfg), GFP_KERNEL);
> +	if (!new_cfg) {
> +		NL_SET_ERR_MSG_MOD(extack, "Memory allocation error");

Here the root node is leaked.

> +		mutex_destroy(&pfvf->qos.qos_lock);
> +		return -ENOMEM;
> +	}


[...]

Cheers,

Paolo

