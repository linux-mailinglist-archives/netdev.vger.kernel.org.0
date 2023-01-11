Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAB566608A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbjAKQcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbjAKQbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:31:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2166C638E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:31:21 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so2689928pjl.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jFmcRJ1cbFQbfjpWNG5O3Vorlsqq9xS7GUkBLcSqvqU=;
        b=i0BHOKaVS+jzitPBcKINn/ULc8QQdP6bgmuOQMnFGC5Z3+usevUEShME6cgD7sGZTH
         AzSX04enoD7siOuZAERnFKmr8YXEIWZjmqTuuSJc0uK/MfEhiYvvWrlEks8Ts4ZWddSi
         +SPYZIMZLT9l9TMqymRPt18iNr/M7NKtihDxdUrd3vZDXL8L9LAoWDHlM8BxvH8tknR/
         hJA/hdB34EMbaCyqJpORJNqcfHppL2pHtrHl6XtHqzdObX6eGextwrM31x1GSlNUQtnq
         IHoYN0KjtsQQphMFFA3D71kP9/QjrWCdYRb0CAKtW1uZtbHJqGMlkPdMs9FkFgIeqROU
         8k1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jFmcRJ1cbFQbfjpWNG5O3Vorlsqq9xS7GUkBLcSqvqU=;
        b=2xXS2zOVbRPwtodV9S9lkLtkKu7GV0Fozz+ZiXgix9bCwmdpAVRQFMDsG9nIQBGffy
         drIrXZI2risVQYVFl+vsmgYu4DUv4km9dxgQXzRvAQuvCgYUO3eQ0rZnBXMYhgq5ciqa
         v3WgIpIBCcLueQzF/NeeAW7wcAXWIX8EbGL4iIMAtMrjBXvTKXc5/zomWfEC4oUy/sp3
         bNcejqewqe4RHD88gvtyOFvFVGMaCHG8PsIx5JR/n1AW8Q2Z270vl1H+xtZezR54h0ma
         Fapf5C26yr58ku2G3S5GyEDa1KlxXTY4hKA+6aYDkB8CQyUoIDixFhoGnB2gBwbto4mU
         o3wA==
X-Gm-Message-State: AFqh2koe6jM95hJEUzY2OliNmYevnhupUjJStr/8qbFT9Gzt+dvK4bZe
        VDS0U+huEXvxDPD2BhzEpSI=
X-Google-Smtp-Source: AMrXdXuDHNy0SACS2Pwq61AhuPmHMUDrYwt0jSVIls+r5FxVrq6UPBFoaK67c3MY5SncVknIbsEQJA==
X-Received: by 2002:a05:6a20:3c8a:b0:af:8128:757 with SMTP id b10-20020a056a203c8a00b000af81280757mr113354015pzj.61.1673454680773;
        Wed, 11 Jan 2023 08:31:20 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id a14-20020a170902710e00b00194516b2d88sm1114564pll.260.2023.01.11.08.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 08:31:20 -0800 (PST)
Message-ID: <f2e3a02cd2a584aa1ed036e90c5c71764e0b8373.camel@gmail.com>
Subject: Re: [PATCH net] net: hns3: fix wrong use of rss size during VF rss
 config
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Hao Lan <lanhao@huawei.com>, davem@davemloft.net, kuba@kernel.org
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        shenjian15@huawei.com, wangjie125@huawei.com,
        netdev@vger.kernel.org
Date:   Wed, 11 Jan 2023 08:31:18 -0800
In-Reply-To: <20230110115359.10163-1-lanhao@huawei.com>
References: <20230110115359.10163-1-lanhao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-10 at 19:53 +0800, Hao Lan wrote:
> From: Jie Wang <wangjie125@huawei.com>
>=20
> Currently, it used old rss size to get current tc mode. As a result, the
> rss size is updated, but the tc mode is still configured based on the old
> rss size.
>=20
> So this patch fixes it by using the new rss size in both process.
>=20
> Fixes: 93969dc14fcd ("net: hns3: refactor VF rss init APIs with new commo=
n rss init APIs")
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> Signed-off-by: Hao Lan <lanhao@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/=
drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> index 081bd2c3f289..e84e5be8e59e 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> @@ -3130,7 +3130,7 @@ static int hclgevf_set_channels(struct hnae3_handle=
 *handle, u32 new_tqps_num,
> =20
>  	hclgevf_update_rss_size(handle, new_tqps_num);
> =20
> -	hclge_comm_get_rss_tc_info(cur_rss_size, hdev->hw_tc_map,
> +	hclge_comm_get_rss_tc_info(kinfo->rss_size, hdev->hw_tc_map,
>  				   tc_offset, tc_valid, tc_size);
>  	ret =3D hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset,
>  					 tc_valid, tc_size);

I can see how this was confused. It isn't really clear that handle is
being used to update the kinfo->rss_size value. Maybe think about
adding a comment to prevent someone from reverting this without
realizing that? It might also be useful to do a follow-on patch for
net-next that renames cur_rss_size to orig_rss_size to make it more
obvious that the value is changing.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
