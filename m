Return-Path: <netdev+bounces-7823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E6B721B9F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F3A92810B9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 01:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BAC389;
	Mon,  5 Jun 2023 01:51:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D0019B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:51:39 +0000 (UTC)
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ABCA8
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 18:51:38 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-33b1e83e204so16442555ab.1
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 18:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1685929898; x=1688521898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nn/2raZaCEyxkUMRUrTbO96sBipL80hG5ePyrz6qFx0=;
        b=vLTLo9Hga0Ar/isQv1thQ6LMwe4TSJJTmb7rjkogfP78xWUerUFwJaFlInNN9Rsbzl
         dV3v3LxF/3LdvZNssfF5mechwpN6sod6eFwCoqa7HtKcHPuPRa7K45x+vrJl8H7NSh7J
         SKxSlhKhnaKyUjqxey0rcUj2iDvQ4aqXRWBlGgBtJemIoMoJdEJhtkzT/XbQDP0vyvWO
         UzKUdFE+vNvkmZQlYZF0/l/ScJmT7Axe37yNY59/I/EzH1+1zDSZx78qAuTda7bY1vuH
         G+oPjEz37oRdwRPJZL7qx321ELEIQWoAeqUm5KJBPrMQAUQkpq3YuWiKkabMXOAjRaI5
         BqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685929898; x=1688521898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nn/2raZaCEyxkUMRUrTbO96sBipL80hG5ePyrz6qFx0=;
        b=VuryFki0Fs+NTBau9CbjA2wjmMD/4LRppgztWAbaWUn+TLvGFoKHKRnnwt4hxbTuQ0
         82yzZ5c/EWuBBrEXfsrObReCZpao6zGj1Xe5hCOyqLDOGG/y6/9OCEydwz/4WhTPHWlB
         Ow5n20wqUHN0pqxPa0vO0Apw6A9QuNT/a5KaSUmr397ASFGK++U+LvU9l+T8zjF+mDJk
         ykAOi+BHJR9fM0nXelrwIMTmArlT9dpELzPsRaap2SskBnM6WyXnAAsN3dJv9hL6WgqX
         jTRauvcG3nKas2ysHlmnktv1wY7TkllKlWIK4CKMRDJhxzWZvtHyzxSaXJf5BWcVlTe8
         Qdzw==
X-Gm-Message-State: AC+VfDyeYF3M3ATaNr1e4tjmEvSr1XfShuMQZo0NRBErkzqeazc1vO0l
	AkpKSjxR5lQ0tTThtHxOyxoh1cAzk3VxgNy2KY8=
X-Google-Smtp-Source: ACHHUZ6j59fPcF9quNXpef0zZealPMWzACLlBgD6zknXufz/5SoUGHY373Tr8l3QoY7c6Dv6Vp7NDg==
X-Received: by 2002:a92:d20d:0:b0:33d:ab70:3447 with SMTP id y13-20020a92d20d000000b0033dab703447mr3111921ily.19.1685929898002;
        Sun, 04 Jun 2023 18:51:38 -0700 (PDT)
Received: from [10.16.161.199] (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id 4-20020aa79244000000b0065d2f009f9esm56628pfp.115.2023.06.04.18.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 18:51:37 -0700 (PDT)
Message-ID: <78f77d87-5499-b68c-298d-d49e740a2cc1@igel.co.jp>
Date: Mon, 5 Jun 2023 10:51:34 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH v4 1/1] vringh: IOMEM support
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230602055211.309960-1-mie@igel.co.jp>
 <20230602055211.309960-2-mie@igel.co.jp> <ZHtQybyy3qg+xw10@corigine.com>
From: Shunsuke Mie <mie@igel.co.jp>
In-Reply-To: <ZHtQybyy3qg+xw10@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon-san,

On 2023/06/03 23:40, Simon Horman wrote:
> On Fri, Jun 02, 2023 at 02:52:11PM +0900, Shunsuke Mie wrote:
>> Introduce a new memory accessor for vringh. It is able to use vringh to
>> virtio rings located on io-memory region.
>>
>> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> ...
>
>> +/**
>> + * vringh_iov_pull_iomem - copy bytes from vring_iov.
> Hi Mie-san,
>
> as it looks like there will be a v2,
> please consider documenting the vrh parameter here.
It was missing an explanation. I will address that and review this patch.
Thank you.
>
>> + * @riov: the riov as passed to vringh_getdesc_iomem() (updated as we consume)
>> + * @dst: the place to copy.
>> + * @len: the maximum length to copy.
>> + *
>> + * Returns the bytes copied <= len or a negative errno.
>> + */
>> +ssize_t vringh_iov_pull_iomem(struct vringh *vrh, struct vringh_kiov *riov,
>> +			      void *dst, size_t len)
>> +{
>> +	return vringh_iov_xfer(vrh, riov, dst, len, xfer_from_iomem);
>> +}
>> +EXPORT_SYMBOL(vringh_iov_pull_iomem);
>> +
>> +/**
>> + * vringh_iov_push_iomem - copy bytes into vring_iov.
> And here.
I do the same.
>> + * @wiov: the wiov as passed to vringh_getdesc_iomem() (updated as we consume)
>> + * @src: the place to copy from.
>> + * @len: the maximum length to copy.
>> + *
>> + * Returns the bytes copied <= len or a negative errno.
>> + */
>> +ssize_t vringh_iov_push_iomem(struct vringh *vrh, struct vringh_kiov *wiov,
>> +			      const void *src, size_t len)
>> +{
>> +	return vringh_iov_xfer(vrh, wiov, (void *)src, len, xfer_to_iomem);
>> +}
>> +EXPORT_SYMBOL(vringh_iov_push_iomem);
> ...

Best regards,

Shunsuke


