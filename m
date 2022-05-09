Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CCA51FA2B
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiEIKuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiEIKtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:49:50 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DC0165D5F;
        Mon,  9 May 2022 03:44:13 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id n6-20020a05600c3b8600b0039492b44ce7so1027208wms.5;
        Mon, 09 May 2022 03:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/AsWycpf07jduXjzH2VNWrB+QTWZXkpPIzj9j/mTLnY=;
        b=WGDzzNprLAPAUZdI9HQvEBLWWgqFG3Gadgv7ghlmlOVTukZlTZvmGp//DST9QwME5g
         HLY7/xUJwOCTUldW4z7g6bOcOIGNNFkd30NGr8xN4KLXdM6GBvqtaEuQoAni8cepVEV5
         7WQc+tyZDEpYYgPma54VlV5a0iGHFG5DsMmysegbyVJVF59jV0xSfrpQ2nb9GCaiwPs7
         AQMnDfbGfZ7IiC2a/irvNpxoNPdiTDV1DZSvtAVT7iz3/pDoSHmoaCB5LiVYeXUKf+Ok
         YP4NTC3fbzhqgVKOarTh14OjQROOYXzu//314z841oM+4g0+rMD68w4BU2GCfWo1mz0d
         Iwrg==
X-Gm-Message-State: AOAM5301iRr2GATQToqmHjJFu2ClevfbjrTFRwtRB3w8poCd/sH2lkay
        yjd3MAEsnmavQRhLknQK2GM=
X-Google-Smtp-Source: ABdhPJwyu0UVEUzmpQEdWqmiHLLdF4bAT8AIED/6I8B1uHX2KqdbK4FXRu7TbYZQRO9V4fkufneL3A==
X-Received: by 2002:a05:600c:26d2:b0:393:fb8c:dc31 with SMTP id 18-20020a05600c26d200b00393fb8cdc31mr22167324wmv.129.1652093052075;
        Mon, 09 May 2022 03:44:12 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id k21-20020adfb355000000b0020c5253d905sm13727381wrd.81.2022.05.09.03.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 03:44:11 -0700 (PDT)
Message-ID: <09374557-8c8d-1925-340c-784f29630ec5@kernel.org>
Date:   Mon, 9 May 2022 12:44:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 4/8] drivers: use new capable_or functionality
Content-Language: en-US
To:     =?UTF-8?Q?Christian_G=c3=b6ttsche?= <cgzones@googlemail.com>,
        selinux@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Ondrej Zary <linux@zary.sk>,
        David Yang <davidcomponentone@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Colin Ian King <colin.king@intel.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Du Cheng <ducheng2@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <20220217145003.78982-2-cgzones@googlemail.com>
 <20220502160030.131168-1-cgzones@googlemail.com>
 <20220502160030.131168-3-cgzones@googlemail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220502160030.131168-3-cgzones@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02. 05. 22, 18:00, Christian Göttsche wrote:
> Use the new added capable_or function in appropriate cases, where a task
> is required to have any of two capabilities.
> 
> Reorder CAP_SYS_ADMIN last.
> 
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> ---

>   drivers/net/caif/caif_serial.c                   | 2 +-

For the above:
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>


>   7 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
> index 66215d9106a4..5eabc2e77cc2 100644
> --- a/drivers/media/common/saa7146/saa7146_video.c
> +++ b/drivers/media/common/saa7146/saa7146_video.c
> @@ -470,7 +470,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuf
>   
>   	DEB_EE("VIDIOC_S_FBUF\n");
>   
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>   		return -EPERM;
>   
>   	/* check args */
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 5ca3d0cc653a..4143f380d44d 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -2569,8 +2569,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
>   	const struct bttv_format *fmt;
>   	int retval;
>   
> -	if (!capable(CAP_SYS_ADMIN) &&
> -		!capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>   		return -EPERM;
>   
>   	/* check args */
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 48543ad3d595..684208ebfdbd 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1798,8 +1798,7 @@ static int saa7134_s_fbuf(struct file *file, void *f,
>   	struct saa7134_dev *dev = video_drvdata(file);
>   	struct saa7134_format *fmt;
>   
> -	if (!capable(CAP_SYS_ADMIN) &&
> -	   !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>   		return -EPERM;
>   
>   	/* check args */
> diff --git a/drivers/media/platform/nxp/fsl-viu.c b/drivers/media/platform/nxp/fsl-viu.c
> index afc96f6db2a1..c5ed4c4a1587 100644
> --- a/drivers/media/platform/nxp/fsl-viu.c
> +++ b/drivers/media/platform/nxp/fsl-viu.c
> @@ -803,7 +803,7 @@ static int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_frameb
>   	const struct v4l2_framebuffer *fb = arg;
>   	struct viu_fmt *fmt;
>   
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>   		return -EPERM;
>   
>   	/* check args */
> diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> index b9caa4b26209..a0cfcf6c22c4 100644
> --- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> +++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> @@ -1253,7 +1253,7 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
>   	if (dev->multiplanar)
>   		return -ENOTTY;
>   
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>   		return -EPERM;
>   
>   	if (dev->overlay_cap_owner)
> diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
> index 688075859ae4..f17b618d8858 100644
> --- a/drivers/net/caif/caif_serial.c
> +++ b/drivers/net/caif/caif_serial.c
> @@ -326,7 +326,7 @@ static int ldisc_open(struct tty_struct *tty)
>   	/* No write no play */
>   	if (tty->ops->write == NULL)
>   		return -EOPNOTSUPP;
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_TTY_CONFIG))
> +	if (!capable_or(CAP_SYS_TTY_CONFIG, CAP_SYS_ADMIN))
>   		return -EPERM;
>   
>   	/* release devices to avoid name collision */
> diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
> index 8410a25a65c1..9b5d22dd3e7b 100644
> --- a/drivers/s390/block/dasd_eckd.c
> +++ b/drivers/s390/block/dasd_eckd.c
> @@ -5319,7 +5319,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
>   	char psf0, psf1;
>   	int rc;
>   
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>   		return -EACCES;
>   	psf0 = psf1 = 0;
>   


-- 
js
suse labs
