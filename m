Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7079F3D8D6B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhG1MEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:04:14 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:44165 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbhG1MEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 08:04:09 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.11]) by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee161014794d62-a754f; Wed, 28 Jul 2021 20:03:32 +0800 (CST)
X-RM-TRANSID: 2ee161014794d62-a754f
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.26.114] (unknown[10.42.68.12])
        by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee661014793ec2-c63e1;
        Wed, 28 Jul 2021 20:03:32 +0800 (CST)
X-RM-TRANSID: 2ee661014793ec2-c63e1
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Mark Brown <broonie@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210728105423.1064-1-broonie@kernel.org>
From:   tangbin <tangbin@cmss.chinamobile.com>
Message-ID: <72a0bb43-3c60-7958-062b-c77037d9e725@cmss.chinamobile.com>
Date:   Wed, 28 Jul 2021 20:03:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210728105423.1064-1-broonie@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Mark:

On 2021/7/28 18:54, Mark Brown wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>    drivers/nfc/s3fwrn5/firmware.c
>
> between commit:
>
>    801e541c79bb ("nfc: s3fwrn5: fix undefined parameter values in dev_err()")

Yesterday, I have send this patch to fix the problem.

And nathan proposed another way to fix this problem, so I send v2 for 
maintainer today. And waiting for the result.

Thanks

Tang Bin

>
> from the net tree and commit:
>
>    a0302ff5906a ("nfc: s3fwrn5: remove unnecessary label")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> diff --cc drivers/nfc/s3fwrn5/firmware.c
> index 1340fab9565e,1421ffd46d9a..000000000000
> --- a/drivers/nfc/s3fwrn5/firmware.c
> +++ b/drivers/nfc/s3fwrn5/firmware.c
> @@@ -421,10 -421,9 +421,9 @@@ int s3fwrn5_fw_download(struct s3fwrn5_
>    
>    	tfm = crypto_alloc_shash("sha1", 0, 0);
>    	if (IS_ERR(tfm)) {
> - 		ret = PTR_ERR(tfm);
>    		dev_err(&fw_info->ndev->nfc_dev->dev,
>   -			"Cannot allocate shash (code=%d)\n", ret);
>   +			"Cannot allocate shash (code=%ld)\n", PTR_ERR(tfm));
> - 		goto out;
> + 		return PTR_ERR(tfm);
>    	}
>    
>    	ret = crypto_shash_tfm_digest(tfm, fw->image, image_size, hash_data);


