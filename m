Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CE154CD59
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiFOPqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFOPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:46:10 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049F3286CD;
        Wed, 15 Jun 2022 08:46:05 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1D77E5A9;
        Wed, 15 Jun 2022 17:46:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1655307963;
        bh=m3A5dqZop5odCJRCkgs9BvSWyBpz30/KNAeaIHJZ1q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gz+qyRs9G+48QItleZ7QvFKhIzWdHGgYD3bsSj4cvZevz+vnv/bHuU11OCDz2zfvV
         mVSOAOmfirc3j3SuYgvLYBpRzrMfP0UyUXAilgSvgVHGUDVUOChMlva/17o7wLGv0O
         tPxdzNanUqOciJtQpE5RO6ZydGGmlUaux55rBxfs=
Date:   Wed, 15 Jun 2022 18:45:52 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Christian =?utf-8?B?R8O2dHRzY2hl?= <cgzones@googlemail.com>
Cc:     selinux@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Serge Hallyn <serge@hallyn.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, Ondrej Zary <linux@zary.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        David Yang <davidcomponentone@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 4/8] drivers: use new capable_any functionality
Message-ID: <Yqn+sCXTHeTH5v+R@pendragon.ideasonboard.com>
References: <20220502160030.131168-8-cgzones@googlemail.com>
 <20220615152623.311223-1-cgzones@googlemail.com>
 <20220615152623.311223-3-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220615152623.311223-3-cgzones@googlemail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

Thank you for the patch.

On Wed, Jun 15, 2022 at 05:26:18PM +0200, Christian Göttsche wrote:
> Use the new added capable_any function in appropriate cases, where a
> task is required to have any of two capabilities.
> 
> Reorder CAP_SYS_ADMIN last.
> 
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> v3:
>    rename to capable_any()
> ---
>  drivers/media/common/saa7146/saa7146_video.c     | 2 +-
>  drivers/media/pci/bt8xx/bttv-driver.c            | 3 +--
>  drivers/media/pci/saa7134/saa7134-video.c        | 3 +--
>  drivers/media/platform/nxp/fsl-viu.c             | 2 +-
>  drivers/media/test-drivers/vivid/vivid-vid-cap.c | 2 +-
>  drivers/net/caif/caif_serial.c                   | 2 +-
>  drivers/s390/block/dasd_eckd.c                   | 2 +-
>  7 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
> index 2296765079a4..f0d08935b096 100644
> --- a/drivers/media/common/saa7146/saa7146_video.c
> +++ b/drivers/media/common/saa7146/saa7146_video.c
> @@ -469,7 +469,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuf
>  
>  	DEB_EE("VIDIOC_S_FBUF\n");
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index d40b537f4e98..7098cff2ea51 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -2567,8 +2567,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
>  	const struct bttv_format *fmt;
>  	int retval;
>  
> -	if (!capable(CAP_SYS_ADMIN) &&
> -		!capable(CAP_SYS_RAWIO))
> +	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 4d8974c9fcc9..23104c04a9aa 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1797,8 +1797,7 @@ static int saa7134_s_fbuf(struct file *file, void *f,
>  	struct saa7134_dev *dev = video_drvdata(file);
>  	struct saa7134_format *fmt;
>  
> -	if (!capable(CAP_SYS_ADMIN) &&
> -	   !capable(CAP_SYS_RAWIO))
> +	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/platform/nxp/fsl-viu.c b/drivers/media/platform/nxp/fsl-viu.c
> index afc96f6db2a1..81a90c113dc6 100644
> --- a/drivers/media/platform/nxp/fsl-viu.c
> +++ b/drivers/media/platform/nxp/fsl-viu.c
> @@ -803,7 +803,7 @@ static int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_frameb
>  	const struct v4l2_framebuffer *fb = arg;
>  	struct viu_fmt *fmt;
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> index b9caa4b26209..918913e47069 100644
> --- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> +++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> @@ -1253,7 +1253,7 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
>  	if (dev->multiplanar)
>  		return -ENOTTY;
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	if (dev->overlay_cap_owner)
> diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
> index 688075859ae4..ca3f82a0e3a6 100644
> --- a/drivers/net/caif/caif_serial.c
> +++ b/drivers/net/caif/caif_serial.c
> @@ -326,7 +326,7 @@ static int ldisc_open(struct tty_struct *tty)
>  	/* No write no play */
>  	if (tty->ops->write == NULL)
>  		return -EOPNOTSUPP;
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_TTY_CONFIG))
> +	if (!capable_any(CAP_SYS_TTY_CONFIG, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* release devices to avoid name collision */
> diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
> index 836838f7d686..66f6db7a11fc 100644
> --- a/drivers/s390/block/dasd_eckd.c
> +++ b/drivers/s390/block/dasd_eckd.c
> @@ -5330,7 +5330,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
>  	char psf0, psf1;
>  	int rc;
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EACCES;
>  	psf0 = psf1 = 0;
>  

-- 
Regards,

Laurent Pinchart
