Return-Path: <netdev+bounces-10670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EEFF72FB11
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BF5C28142A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3F01385;
	Wed, 14 Jun 2023 10:34:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA987F2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:34:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB251BC5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686738885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w2Ted0gM7ElzMgeYGQqf93ltWdm3250w9HIYlm+YPA0=;
	b=WhON6+Td+kjGiR8Mv5sSAJQsRUzjQza29gvdUP2dGa99QVzKhaxyID9aJ8zndRZ03c27Il
	BxEKdayiL/jqbhTCBqFaGVY6/cD9fO7Kan6OprG76qaLA0hS9GuIjl0mjOMm6/H3fubtTF
	X4af8FDlMbihtCcl7BIB1Co/l/VRY/8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-pEhyloTkNuKmQblG2WQUhA-1; Wed, 14 Jun 2023 06:34:44 -0400
X-MC-Unique: pEhyloTkNuKmQblG2WQUhA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-75eb82ada06so149377785a.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:34:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686738883; x=1689330883;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w2Ted0gM7ElzMgeYGQqf93ltWdm3250w9HIYlm+YPA0=;
        b=ZrRRcUHzt9MmADi6Y4fQCatLvmzu3xShg9pQGEqOGRqvHpg3YnKpN8xCBhpucH8RcG
         tuVFhQOXrg4U8wXwSfTfN/OWYxvqW4EKqnNTJ7Dp0GuMALdURfjM4oKqKVfN8wLsCdyx
         l3CkTD14q1n9/BrVjwCGpWEwrifSMlNpwc1EQ65b+fuqON7TcuEoWnpWSg8hVywAkaR6
         rCCN5YEoey8ZR+PCzmJUSY53tHDpg8Vzhdn1ah3eE32s4iFC3aj2RZ1Mmc2Diel7N0N6
         KKaOILTh9UimLQAWPQ57Qbzt/qH/L7mZ2GWsf6GH9Aq4iiJengctbWcfzGdDvJ+jvtni
         YmTA==
X-Gm-Message-State: AC+VfDyQdSDzQTAszdBwoFJ8XUG6PI+fiLsTCrkJlhhaLNBeYrZaUEP4
	kOB6PD5TtWo+favvI/R99DRjZcFBTUCoPGJQb4oP/j6QKXMDUGU5/0Kh0F8KpZ3zOgHSf2FY9q6
	yjXjjvP2WGhbQWeQ0zogrfa6W
X-Received: by 2002:a05:620a:1923:b0:75e:ce67:c665 with SMTP id bj35-20020a05620a192300b0075ece67c665mr18765597qkb.5.1686738883411;
        Wed, 14 Jun 2023 03:34:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5sxdFuGOAeR2sUKOI9aS2gZy/O0qqT6DfclX1jfAcUc8DubGhDp4TxjyEs78Dz5sPIuL6+jg==
X-Received: by 2002:a05:620a:1923:b0:75e:ce67:c665 with SMTP id bj35-20020a05620a192300b0075ece67c665mr18765583qkb.5.1686738883140;
        Wed, 14 Jun 2023 03:34:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-67.dyn.eolo.it. [146.241.244.67])
        by smtp.gmail.com with ESMTPSA id g25-20020a05620a13d900b007577ccf566asm4176518qkl.93.2023.06.14.03.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 03:34:42 -0700 (PDT)
Message-ID: <8e84a4a13d25ceed6ad2ad2e4137b2fc35a086e4.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/4] net: hns3: fix strncpy() not using
 dest-buf length as length issue
From: Paolo Abeni <pabeni@redhat.com>
To: Hao Lan <lanhao@huawei.com>, netdev@vger.kernel.org
Cc: yisen.zhuang@huawei.com, salil.mehta@huawei.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, richardcochran@gmail.com, 
	wangpeiyang1@huawei.com, shenjian15@huawei.com, chenhao418@huawei.com, 
	simon.horman@corigine.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com, 
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Date: Wed, 14 Jun 2023 12:34:38 +0200
In-Reply-To: <20230612122358.10586-4-lanhao@huawei.com>
References: <20230612122358.10586-1-lanhao@huawei.com>
	 <20230612122358.10586-4-lanhao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-06-12 at 20:23 +0800, Hao Lan wrote:
> From: Hao Chen <chenhao418@huawei.com>
>=20
> Now, strncpy() in hns3_dbg_fill_content() use src-length as copy-length,
> it may result in dest-buf overflow.
>=20
> This patch is to fix intel compile warning for csky-linux-gcc (GCC) 12.1.=
0
> compiler.
>=20
> The warning reports as below:
>=20
> hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on
> the length of the source argument [-Wstringop-truncation]
>=20
> strncpy(pos, items[i].name, strlen(items[i].name));
>=20
> hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before
> terminating nul copying as many bytes from a string as its length
> [-Wstringop-truncation]
>=20
> strncpy(pos, result[i], strlen(result[i]));
>=20
> strncpy() use src-length as copy-length, it may result in
> dest-buf overflow.
>=20
> So,this patch add some values check to avoid this issue.
>=20
> ChangeLog:
> v1->v2:
> Use strcpy substitutes for memcpy
> suggested by Simon Horman.
>=20
> Signed-off-by: Hao Chen <chenhao418@huawei.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/lkml/202207170606.7WtHs9yS-lkp@intel.com/=
T/
> Signed-off-by: Hao Lan <lanhao@huawei.com>
> ---
>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 31 ++++++++++++++-----
>  .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 29 ++++++++++++++---
>  2 files changed, 48 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers=
/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> index d385ffc21876..0749515e270b 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> @@ -438,19 +438,36 @@ static void hns3_dbg_fill_content(char *content, u1=
6 len,
>  				  const struct hns3_dbg_item *items,
>  				  const char **result, u16 size)
>  {
> +#define HNS3_DBG_LINE_END_LEN	2

IMHO this macro should be defined outside the function (just before)
for better readability.

>  	char *pos =3D content;
> +	u16 item_len;
>  	u16 i;
> =20
> +	if (!len) {
> +		return;
> +	} else if (len <=3D HNS3_DBG_LINE_END_LEN) {
> +		*pos++ =3D '\0';
> +		return;
> +	}
> +
>  	memset(content, ' ', len);
> -	for (i =3D 0; i < size; i++) {
> -		if (result)
> -			strncpy(pos, result[i], strlen(result[i]));
> -		else
> -			strncpy(pos, items[i].name, strlen(items[i].name));
> +	len -=3D HNS3_DBG_LINE_END_LEN;
> =20
> -		pos +=3D strlen(items[i].name) + items[i].interval;
> +	for (i =3D 0; i < size; i++) {
> +		item_len =3D strlen(items[i].name) + items[i].interval;
> +		if (len < item_len)
> +			break;
> +
> +		if (result) {
> +			if (item_len < strlen(result[i]))
> +				break;
> +			strcpy(pos, result[i]);
> +		} else {
> +			strcpy(pos, items[i].name);
> +		}
> +		pos +=3D item_len;
> +		len -=3D item_len;

I think it would be better using 'strscpy' instead of papering over
more unsecure functions.

Thanks,

Paolo


