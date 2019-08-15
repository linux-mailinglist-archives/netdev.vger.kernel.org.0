Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2224F8E248
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 03:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfHOBO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 21:14:26 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:32791 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfHOBO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 21:14:26 -0400
Received: by mail-qk1-f170.google.com with SMTP id r6so755868qkc.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 18:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KfKxg/+eNORAa627t9rJEYEbGWldHm9d8KIPv9SGRGs=;
        b=kV39JoaABRDbEPbTo0W9KhQzsKJdNUqAvpE3RdbXB43Nnr70IKxE8tjcK1W1P0HoZ8
         /XSW/jfRRjdOSFpU/6bL/YerzwdcG2NM0ty62wuNw4dHxp0EWCLSIlFxDdm66I0UKdfE
         SP36GkZTHijuLQyEZZ1u7Cij5Ek9NLWV6GC9DXZc4Q3TwQzyjuy9DPEZClaQy0lwGg3m
         gAcdSw79a9ZFcbye7Ok1YhxIIXaqd7Lw0AIj91nCzVUS3X6ORsIDBUUJhB8n6Jeb7sdT
         FRjbXm0ncBB6n0DFzZJdfHaekxi/3G3IrxiuXToE5hupqmxOxD2Wpyb3lsSHRxleqfWN
         L0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KfKxg/+eNORAa627t9rJEYEbGWldHm9d8KIPv9SGRGs=;
        b=Pv8YG6g/kuaXvb6LGtsINestoAhP17w71uqASLDia8mp9IA+7heavMt1r1uzc0jrBV
         tjUHyZ/ZTjKBuhWV1pqLf4iEpD2J+IcuidJlwW0+yIGwd+uwwxcdvqGLfXM+Mu6H4Rti
         RNRMq8YQY71+xYsIkkUYs4wqOKnYqdeCHjapyMQs36abUcpPwRqTeWUCea9JtyVr9daY
         XXd9UiZVBAFVagXQqc8hvSXZlP0/CvLadg5YJ0BIrjgfnnNCMDKVYfGBAOe47IDZT58Z
         CMUXcmqNcIN4uDxoCrCdh199bFjIE6u02P/FxqfGXsYa4i5LscVOZUZAoiZJiu4W0g+r
         0y2w==
X-Gm-Message-State: APjAAAW1bzyAc6GqlYaT79/rJyJ4BcaS+fulIzRW7Y409aeKeYUxfPVK
        Uv0jC0Fn9Adq8MNO82HqIkmxwA==
X-Google-Smtp-Source: APXvYqxLl6t/LPwwcg6pmawL1L6rJI1KbNGjKCBRfAOL7wA9EpxQCavCpuvebRYM3rjxVfd2xa450g==
X-Received: by 2002:a05:620a:11a6:: with SMTP id c6mr1986553qkk.275.1565831665364;
        Wed, 14 Aug 2019 18:14:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r4sm801280qta.93.2019.08.14.18.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 18:14:25 -0700 (PDT)
Date:   Wed, 14 Aug 2019 18:14:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 1/2] netdevsim: implement support for
 devlink region and snapshots
Message-ID: <20190814181412.0d3fbd21@cakuba.netronome.com>
In-Reply-To: <20190814153735.6923-2-jiri@resnulli.us>
References: <20190814153735.6923-1-jiri@resnulli.us>
        <20190814153735.6923-2-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 17:37:34 +0200, Jiri Pirko wrote:
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 08ca59fc189b..125a0358bc04 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -27,6 +27,41 @@
>  
>  static struct dentry *nsim_dev_ddir;
>  
> +#define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
> +
> +static ssize_t nsim_dev_take_snapshot_write(struct file *file,
> +					    const char __user *data,
> +					    size_t count, loff_t *ppos)
> +{
> +	struct nsim_dev *nsim_dev = file->private_data;
> +	void *dummy_data;
> +	u32 id;
> +	int err;

If you have to rebase on top of Ido's changes and repost, please do
reverse xmas tree.
