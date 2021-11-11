Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1C944D2B7
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 08:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhKKHxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 02:53:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231838AbhKKHxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 02:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636617050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/+lNzpFDTJisG1Ms+xEcP1P3xuZ2mXA6OOl2o5Rrgo=;
        b=a3S2ax2fyv4+wp1VD2XhYtn17NBHsvL6J55ZWgfQRSIVvrbPveha/Sb7nASuIY0SQqHNt/
        ox71hmZLLEgE40GVIl6dcei+7VbPS6tQLaVk+2Pr8dG5XGAghg5RNa9KEjxhM3YostVVaM
        m5LGDQx0bPGVnlD78yM9iwdxUNto82g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-tvYy-r0ENYukfqxvvyy_5g-1; Thu, 11 Nov 2021 02:50:49 -0500
X-MC-Unique: tvYy-r0ENYukfqxvvyy_5g-1
Received: by mail-ed1-f71.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so4659417edx.15
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 23:50:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d/+lNzpFDTJisG1Ms+xEcP1P3xuZ2mXA6OOl2o5Rrgo=;
        b=uNFOnwjoU/LeLLmXG1vzTTuvWGVqRVZ9eeidLnbG/gWS/7y6ICtJUGDtatALNiOPqq
         WkUXHyiHo7Ga3K4w33uO5nVBC+AsB4htnwqLdLEwKZAir9fdCk0HiSHuQq5v0ULawGgo
         hSzGO88/K6w9VYskLZdX/0Hz7ybxCRomI/jObkvaLpeNjSaFbXMcbQa/b7774Roa8mhc
         deZXnPQwYPITcC4kpVrxqQIaontUuOUFWQ2o9WpAA1hkqjonX7TTdSZVz9yipCBvILys
         e4x1VzyH4iFalvOBW+OJkwTKO6pKZrSW3fGIzYs9gp2XKl7MJO9eTngjXaImNDFjCojB
         rmag==
X-Gm-Message-State: AOAM5303SOj7U+Sg5OA9v/pW+jDv2N3MVjWaGYBatyshKQ7IlpSEym4m
        9wKbL6A1j2BfQe5aaVxe4C99ilDg9KB3oqiPxVmn4Op6P399+cHRt/Mlg375ZwGOv1lTHL9lQWm
        c8XiURh3pvNruP1dC
X-Received: by 2002:a17:906:974d:: with SMTP id o13mr6924587ejy.105.1636617048435;
        Wed, 10 Nov 2021 23:50:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykh1XKq+5z5k0e36cPH/KqMPOzuR0LECpBB3LdADAPzQHis/vHTcls7zSs4Yi6YldEGIC6GA==
X-Received: by 2002:a17:906:974d:: with SMTP id o13mr6924552ejy.105.1636617048194;
        Wed, 10 Nov 2021 23:50:48 -0800 (PST)
Received: from [10.39.192.251] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id hv17sm868527ejc.66.2021.11.10.23.50.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Nov 2021 23:50:47 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, jasowang@redhat.com, alexander.duyck@gmail.com,
        saeed@kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, tirthendu.sarkar@intel.com,
        toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 13/23] bpf: add multi-buffer support to xdp copy helpers
Date:   Thu, 11 Nov 2021 08:50:46 +0100
X-Mailer: MailMate (1.14r5820)
Message-ID: <7A7D4AD0-DF15-4721-B551-5DB177BEF0B1@redhat.com>
In-Reply-To: <YYktX7swvejoYdnN@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
 <637cb9a21958e1a5026faba6255debf21d229d1d.1636044387.git.lorenzo@kernel.org>
 <20211105162933.113ce3c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYktX7swvejoYdnN@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Nov 2021, at 14:59, Lorenzo Bianconi wrote:

>> On Thu,  4 Nov 2021 18:35:33 +0100 Lorenzo Bianconi wrote:
>>> -static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_bu=
ff,
>>> +static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
>>>  				  unsigned long off, unsigned long len)
>>>  {
>>> -	memcpy(dst_buff, src_buff + off, len);
>>> +	unsigned long base_len, copy_len, frag_off_total;
>>> +	struct xdp_buff *xdp =3D (struct xdp_buff *)ctx;
>>> +	struct skb_shared_info *sinfo;
>>> +	int i;
>>> +
>>> +	if (likely(!xdp_buff_is_mb(xdp))) {
>>
>> Would it be better to do
>>
>> 	if (xdp->data_end - xdp->data >=3D off + len)
>>
>> ?
>
> Hi Jakub,
>
> I am fine with the patch (just a typo inline), thx :)
> I will let Eelco to comment since he wrote the original code.
> If there is no objections, I will integrate it in v18.

Sorry for the late response, but both suggestions look fine to me.

>>
>>> +		memcpy(dst_buff, xdp->data + off, len);
>>> +		return 0;
>>> +	}
>>> +
>>> +	base_len =3D xdp->data_end - xdp->data;
>>> +	frag_off_total =3D base_len;
>>> +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
>>> +
>>> +	/* If we need to copy data from the base buffer do it */
>>> +	if (off < base_len) {
>>> +		copy_len =3D min(len, base_len - off);
>>> +		memcpy(dst_buff, xdp->data + off, copy_len);
>>> +
>>> +		off +=3D copy_len;
>>> +		len -=3D copy_len;
>>> +		dst_buff +=3D copy_len;
>>> +	}
>>> +
>>> +	/* Copy any remaining data from the fragments */
>>> +	for (i =3D 0; len && i < sinfo->nr_frags; i++) {
>>> +		skb_frag_t *frag =3D &sinfo->frags[i];
>>> +		unsigned long frag_len, frag_off;
>>> +
>>> +		frag_len =3D skb_frag_size(frag);
>>> +		frag_off =3D off - frag_off_total;
>>> +		if (frag_off < frag_len) {
>>> +			copy_len =3D min(len, frag_len - frag_off);
>>> +			memcpy(dst_buff,
>>> +			       skb_frag_address(frag) + frag_off, copy_len);
>>> +
>>> +			off +=3D copy_len;
>>> +			len -=3D copy_len;
>>> +			dst_buff +=3D copy_len;
>>> +		}
>>> +		frag_off_total +=3D frag_len;
>>> +	}
>>> +
>>
>> nit: can't help but feel that you can merge base copy and frag copy:
>>
>> 	sinfo =3D xdp_get_shared_info_from_buff(xdp);
>> 	next_frag =3D &sinfo->frags[0];
>> 	end_frag =3D &sinfo->frags[sinfo->nr_frags];
>>
>> 	ptr_off =3D 0;
>> 	ptr_buf =3D xdp->data;
>> 	ptr_len =3D xdp->data_end - xdp->data;
>>
>> 	while (true) {
>> 		if (off < ptr_off + ptr_len) {
>> 			copy_off =3D ptr_off - off;
>
> I guess here should be:
> 			copy_off =3D off - ptr_off;
>
>> 			copy_len =3D min(len, ptr_len - copy_off);
>> 			memcpy(dst_buff, ptr_buf + copy_off, copy_len);
>>
>> 			off +=3D copy_len;
>> 			len -=3D copy_len;
>> 			dst_buff +=3D copy_len;
>> 		}
>>
>> 		if (!len || next_frag =3D=3D end_frag)
>> 			break;
>> 	=

>> 		ptr_off +=3D ptr_len;
>> 		ptr_buf =3D skb_frag_address(next_frag);
>> 		ptr_len =3D skb_frag_size(next_frag);
>> 		next_frag++;
>> 	}
>>
>> Up to you.

