Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CAC40D201
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 05:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhIPD1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 23:27:50 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:42657 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234037AbhIPD1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 23:27:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UoXMJXX_1631762787;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UoXMJXX_1631762787)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Sep 2021 11:26:28 +0800
Subject: Re: [PATCH] net/tls: support SM4 GCM/CCM algorithm
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
References: <20210915111242.32413-1-tianjia.zhang@linux.alibaba.com>
 <20210915130600.66ce8b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <ed58d8aa-c21d-9ae5-3a29-2683d39d2a35@linux.alibaba.com>
Date:   Thu, 16 Sep 2021 11:26:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210915130600.66ce8b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 9/16/21 4:06 AM, Jakub Kicinski wrote:
> On Wed, 15 Sep 2021 19:12:42 +0800 Tianjia Zhang wrote:
>> +		memcpy(sm4_gcm_info->iv,
>> +		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
>> +		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
>> +		memcpy(sm4_gcm_info->rec_seq, cctx->rec_seq,
>> +		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
>> +		release_sock(sk);
>> +		if (copy_to_user(optval, sm4_gcm_info, sizeof(*sm4_gcm_info)))
>> +			rc = -EFAULT;
>> +		break;
>> +	}
>> +	case TLS_CIPHER_SM4_CCM: {
>> +		struct tls12_crypto_info_sm4_ccm *sm4_ccm_info =
>> +			container_of(crypto_info,
>> +				struct tls12_crypto_info_sm4_ccm, info);
>> +
>> +		if (len != sizeof(*sm4_ccm_info)) {
>> +			rc = -EINVAL;
>> +			goto out;
>> +		}
>> +		lock_sock(sk);
>> +		memcpy(sm4_ccm_info->iv,
>> +		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
>> +		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
>> +		memcpy(sm4_ccm_info->rec_seq, cctx->rec_seq,
>> +		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
> 
> Doesn't matter from the functional perspective but perhaps use the SM4
> defines rather than the AES ones, since they exist, anyway?
> 
> With that fixed feel free to add my ack.
> 

Thanks for pointing it out, I forgot to modify the macro name, this is 
not my intention, I was careless. will fix it in v2.

Best regards,
Tianjia
