Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9EE3807B5
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhENKvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhENKvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 06:51:02 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCE7C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 03:49:50 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id p20so13368831ljj.8
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 03:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=tLXYr9FRmgWUeZYIBm0XdxDuEUGBAcMG+g+2Ty3DMhM=;
        b=vXSbgkx54XgqfbnCPtZQKOH1q5eloLh0jp9c9AXy6RkhCzfxLw/UTHJLMa/qOUpRmT
         Q4YqrEo2RuQE2feJtrbqM3NGxYYo3sNONO8YUre8HItaEQlP//XP25zQAHW7q8GZRlP5
         3Th1eNEgycBnhx1T8PSrfynavLmdQ3EpATidEW+eJZmPpDlDGIbmVxRhGyjI8lOylfnV
         IQuI1nD0CR0imHaSiR5xv+nBRTxFJxNRutYE1+almPSdhadJR9XEcqXV0NEEksYXQlQu
         4lkhtEGI6T7QG1W7MfQPqH7ZzwlPOQX76WPZTRYEClCR9x8Jg9GN1QkeXUxZwmtMpDPL
         8+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=tLXYr9FRmgWUeZYIBm0XdxDuEUGBAcMG+g+2Ty3DMhM=;
        b=uOGAoDQ4S8AEN7GL7k5PXnnDCXT3qaZkOe+jCrKAU/9Bvg/+utJgjjqVu/2KFuZOX+
         Sc/jxX4dCkpH4vKLkjxYzB00N769qgZuQG8JAtRiFd0cTbUxdXskX3K9A5RFAwRwdc9s
         GhkdIsL5D8UW5phHSR99qAYw1AOMQF9tQmmWMLcZ7p0RHsCYIMphRj7sj1EEyXbXD8G7
         pufZ9uVDFrwUu1/kh91XU8Mib21+ncYz8KKYBlV/aKEkLMO/HY+Rl3kquYGfujQvVjYS
         9psPdRlgf59jtY4up3/i83AtgbKlhQ/6SnJEqLt75OwUZSlA7GvUhRIIKbKm8LuAKfIx
         AJ5A==
X-Gm-Message-State: AOAM531CLUbKrKS3IGd5M0lnzKdZbI7j9qhPP6RmE3qeUwu7eoK8zeOA
        jqZDNUMlZlZogLGiOegNlw28bNEnBrk=
X-Google-Smtp-Source: ABdhPJxIoW0ATmFim1iDablLNHaUroHg6jAWOrMquCKQj3cOBva9QQ5ybf1ZqLff42Zz72OzeyHY/w==
X-Received: by 2002:a2e:bf2a:: with SMTP id c42mr36253912ljr.208.1620989388692;
        Fri, 14 May 2021 03:49:48 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id h19sm982581ljg.119.2021.05.14.03.49.48
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 14 May 2021 03:49:48 -0700 (PDT)
Message-ID: <609E5817.8090000@gmail.com>
Date:   Fri, 14 May 2021 13:59:35 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] alx: use fine-grained locking instead of RTNL
References: <20210512121950.c93ce92d90b3.I085a905dea98ed1db7f023405860945ea3ac82d5@changeid>
In-Reply-To: <20210512121950.c93ce92d90b3.I085a905dea98ed1db7f023405860945ea3ac82d5@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

12.05.2021 13:19, Johannes Berg:
> In the alx driver, all locking depended on the RTNL, but
[...]
> @@ -232,7 +240,7 @@ static int alx_set_pauseparam(struct net_device *netdev,
>   	if (pause->autoneg)
>   		fc |= ALX_FC_ANEG;
>
> -	ASSERT_RTNL();
> +	mutex_lock(&alx->mtx);
>
>   	/* restart auto-neg for auto-mode */
>   	if (hw->adv_cfg&  ADVERTISED_Autoneg) {
> @@ -254,6 +262,7 @@ static int alx_set_pauseparam(struct net_device *netdev,
>   		alx_cfg_mac_flowcontrol(hw, fc);
>
>   	hw->flowctrl = fc;
> +	mutex_unlock(&alx->mtx);
>
>   	return 0;
>   }

Isn't this fragment missing a mutex_unlock(&alx->mtx) for the "return 
err" codepath in the middle? I'm not sure, its like very suspicious, 
please have a look.


Thank you,

Regards,
Nikolai
