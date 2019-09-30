Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81463C22CA
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbfI3OJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730902AbfI3OJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 10:09:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D443A215EA;
        Mon, 30 Sep 2019 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569852547;
        bh=/U2mWnQ3hZWiS3jNT4z8EXf/IrTBXAj8SVOnPY2H9Fg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qiVFE8ticxpzKPSnioikiMP00UpPTIt5REBJv1PmqF/QjCF2BIh8/oNsn1nkKQpgd
         R1WSbs+aNYHzXa4UJr0nQj7SWa37bkKJtRYYz2OpYWuNWi+yGYj1uzRXWVWkutlrpU
         9kJhymmzPgf/9n12vu80Ap9XS3WlllqKkZ5SrAaA=
Date:   Mon, 30 Sep 2019 16:07:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        jan.kiszka@siemens.com, Frank Iwanitz <friw@hms-networks.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 4/5] staging: fieldbus core: add support for FL-NET
 devices
Message-ID: <20190930140714.GC2280096@kroah.com>
References: <20190918183552.28959-1-TheSven73@gmail.com>
 <20190918183552.28959-5-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918183552.28959-5-TheSven73@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 02:35:51PM -0400, Sven Van Asbroeck wrote:
> Add the FL-NET device type to the fieldbus core.

What does this mean?

> 
> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
> ---
>  .../fieldbus/Documentation/ABI/sysfs-class-fieldbus-dev        | 1 +
>  drivers/staging/fieldbus/dev_core.c                            | 3 +++
>  drivers/staging/fieldbus/fieldbus_dev.h                        | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/drivers/staging/fieldbus/Documentation/ABI/sysfs-class-fieldbus-dev b/drivers/staging/fieldbus/Documentation/ABI/sysfs-class-fieldbus-dev
> index 439f14d33c3b..233c418016aa 100644
> --- a/drivers/staging/fieldbus/Documentation/ABI/sysfs-class-fieldbus-dev
> +++ b/drivers/staging/fieldbus/Documentation/ABI/sysfs-class-fieldbus-dev
> @@ -12,6 +12,7 @@ Description:
>  		Possible values:
>  			'unknown'
>  			'profinet'
> +			'flnet'
>  
>  What:		/sys/class/fieldbus_dev/fieldbus_devX/fieldbus_id
>  KernelVersion:	5.1 (staging)
> diff --git a/drivers/staging/fieldbus/dev_core.c b/drivers/staging/fieldbus/dev_core.c
> index 9903c4f3cba9..7e9405e52f19 100644
> --- a/drivers/staging/fieldbus/dev_core.c
> +++ b/drivers/staging/fieldbus/dev_core.c
> @@ -113,6 +113,9 @@ static ssize_t fieldbus_type_show(struct device *dev,
>  	case FIELDBUS_DEV_TYPE_PROFINET:
>  		t = "profinet";
>  		break;
> +	case FIELDBUS_DEV_TYPE_FLNET:
> +		t = "flnet";
> +		break;
>  	default:
>  		t = "unknown";
>  		break;
> diff --git a/drivers/staging/fieldbus/fieldbus_dev.h b/drivers/staging/fieldbus/fieldbus_dev.h
> index 3b00315600e5..f775546b3404 100644
> --- a/drivers/staging/fieldbus/fieldbus_dev.h
> +++ b/drivers/staging/fieldbus/fieldbus_dev.h
> @@ -15,6 +15,7 @@ struct fieldbus_dev_config;
>  enum fieldbus_dev_type {
>  	FIELDBUS_DEV_TYPE_UNKNOWN = 0,
>  	FIELDBUS_DEV_TYPE_PROFINET,
> +	FIELDBUS_DEV_TYPE_FLNET

You add an unspecified enumerated type and suddenly new hardware starts
working?  That feels really wrong to me...

greg k-h
