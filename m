Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5CFA9F4D
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732802AbfIEKNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:13:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33250 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732767AbfIEKND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:13:03 -0400
Received: by mail-lj1-f194.google.com with SMTP id a22so1867657ljd.0
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 03:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WM4svmPInntGde0Mb4h49CeOyrkMQizTssxeoRTCMZs=;
        b=vRnmheRVRIyNu1yOxwrrhCtj/3kZ1d0t5JyKsRuOscwUyBBy5Pen7wUCNYp6TyopQk
         w2rxw6vPsm17LHzDCBNT332TPFMbfozti2ysHnKH3+7FWmvupoa0+YDyizlOQQkePcy2
         oADtXPAeLdN/7Z84sFKLuro+l6/WEm4W9nHiUTTkcyZ4tUCSlsN9OLzu3ARVvnGjLGaQ
         4rbITO+SdwYFNpYHbiVRAOx2MbYvSIDDhzP0/TIUqIogBHKFiRLNX/Ql0TbNy0woI2Op
         CnnPVM92pl0riCp3TInQGvtHDW9+8kaeObZ1UR58Olez4CoE/d0ZCHLN3BzEYtZBtUH1
         wXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WM4svmPInntGde0Mb4h49CeOyrkMQizTssxeoRTCMZs=;
        b=FrQuIOvzqSH/dhAm7xoyKDAuejYnVJvkNiPim7zd5cvAypu53unngxaQILfclAL07O
         cuXLUnCgFJzq+A1YiKE1QU8dL4MpFYelWvvSRtqoA/PJtJvyyHUbDTJCVK15V1OVGhgK
         CzuH6mJ2ca2xqwYUA/qTuJD7pl5QAvIyIj7ZeLVC6uHvg4udwMnqGCkgKZAJWM2TL2L/
         Gk9uSiFrPmP66nfVX0ihlrvyoFsEQsyaqkIxqKwaOliAD0LILglFbZSjuY1tkEVK8GN4
         aE755333jCIjZWFeGp8mrd1rZJ5+ZwYCzHgRPnwM0bjdIIjceyvMrH1LiNvkpnCxRIBE
         tkQg==
X-Gm-Message-State: APjAAAWlFojmHYlcpl10vuyOZCeIeNcg4Vmngr0YV/WtgYLkOhNgQ7B5
        3txHXguZgOCrdjUK5E6tB5bnnQ==
X-Google-Smtp-Source: APXvYqy3A+azbPbg/1KwTZbN5fOs8mzxKRC4QS8uK+LhfmrAK7TY/oNz5c8RHtwqX0w9skwFxCyxQQ==
X-Received: by 2002:a2e:878a:: with SMTP id n10mr1526787lji.117.1567678381628;
        Thu, 05 Sep 2019 03:13:01 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:413:7297:c53b:e0f7:7608:d21c? ([2a00:1fa0:413:7297:c53b:e0f7:7608:d21c])
        by smtp.gmail.com with ESMTPSA id w1sm349824lfe.67.2019.09.05.03.13.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 03:13:00 -0700 (PDT)
Subject: Re: [PATCH net-next 4/7] net: hns3: add client node validity judgment
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com,
        Peng Li <lipeng321@huawei.com>
References: <1567606006-39598-1-git-send-email-tanhuazhong@huawei.com>
 <1567606006-39598-5-git-send-email-tanhuazhong@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b0aa6da6-cd42-dd31-8ff7-ca3f48de58ff@cogentembedded.com>
Date:   Thu, 5 Sep 2019 13:12:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567606006-39598-5-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.09.2019 17:06, Huazhong Tan wrote:

> From: Peng Li <lipeng321@huawei.com>
> 
> HNS3 driver can only unregister client which included in hnae3_client_list.
> This patch adds the client node validity judgment.
> 
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>   drivers/net/ethernet/hisilicon/hns3/hnae3.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
> index 528f624..6aa5257 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
> @@ -138,12 +138,28 @@ EXPORT_SYMBOL(hnae3_register_client);
>   
>   void hnae3_unregister_client(struct hnae3_client *client)
>   {
> +	struct hnae3_client *client_tmp;
>   	struct hnae3_ae_dev *ae_dev;
> +	bool existed = false;
>   
>   	if (!client)
>   		return;
>   
>   	mutex_lock(&hnae3_common_lock);
> +
> +	list_for_each_entry(client_tmp, &hnae3_client_list, node) {
> +		if (client_tmp->type == client->type) {
> +			existed = true;
> +			break;
> +		}
> +	}
> +
> +	if (!existed) {
> +		mutex_unlock(&hnae3_common_lock);
> +		pr_err("client %s not existed!\n", client->name);

    Did not exist, you mean?

[...]

MBR, Sergei
