Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BAB324251
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhBXQmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbhBXQkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 11:40:02 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03227C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 08:39:17 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k66so2414762wmf.1
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 08:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8/7WIkygkwXpMQwOKTWFMy/O50s2dwSmAwW3okTy7SU=;
        b=LOrFmN5sWtCCD85DZj9Q7wVk/yGY65GzHtnsqHpOkM6ZRLAPyp9GiMmMRecuCsGzyY
         rZT6u09IFlRc2LPrgttIEBF71ScZbL+aYBybAf6BDdsZD9Wb77qKYcdKp+mvNelq1L0j
         YvjulcryYuSNcXyIq2c4JbxeurukJd1xrxRKTkT+T3gyf/WQcunICYU9CDVUGxa1XtL9
         WuBBZ8ZasSzWQJag/ToTMCenroT0VAU1c82/HhiwFeyCF+2fZ/t7wJew122TkB5rYgWb
         V/2/CvUOyXv1dRprJXYPFK4LBLRpQwTbDleq3GsH6o2konedqnN8xpGdeEDfVrfzF3bH
         Xx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8/7WIkygkwXpMQwOKTWFMy/O50s2dwSmAwW3okTy7SU=;
        b=ip24w+AEUU8HPR6awJRGPFtHb2cJXI8oQmfxputjJV0nZjYZGsGccdJVjgn12plMJv
         DO3in14RCWS1ALsavpqUkDmsYa6kJuwVBrJqrttjeQeafHUV7pZJ8yMq0O1Y8ryn+Ood
         WQFuf4bmb3kNM4NNNl4FTPz0McgQInWcLSUOiJL98jOODFhwS260OrNm//uGgKRB9Ni+
         LL/OYIyVb9vjflhb1p8O54fEIkUJs0vpDVmb3QZVk7wN5SZYaV1psT00VGu4hPO+mlSg
         wxvCAuvjPanLZrh5l0ib0AQIo0Uyw9WAadANXON/hY/SboxErOr5bbN0Y3RA/vFznKJ7
         EsSA==
X-Gm-Message-State: AOAM533D/w2FD06tfM87Be2XtLBenJHAWK6oGs+3YxuCpxfmRaidQKgS
        dZos5enRTW2vXyuUCvyn/EU2f1Ufz80=
X-Google-Smtp-Source: ABdhPJxC2n4EKm35CLzWvdVGI9ph2B7GSWM9XEQYrail0xCcUGf0ffT5AqPxohOw+P230kc/FiHCoQ==
X-Received: by 2002:a05:600c:2184:: with SMTP id e4mr4435865wme.107.1614184755828;
        Wed, 24 Feb 2021 08:39:15 -0800 (PST)
Received: from ?IPv6:2a00:23c5:5785:9a01:5df2:fdab:9690:bbff? ([2a00:23c5:5785:9a01:5df2:fdab:9690:bbff])
        by smtp.gmail.com with ESMTPSA id c11sm4217607wrs.28.2021.02.24.08.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 08:39:15 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: [PATCH] xen-netback: correct success/error reporting for the
 SKB-with-fraglist case
To:     Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
Message-ID: <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
Date:   Wed, 24 Feb 2021 16:39:14 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/02/2021 16:29, Jan Beulich wrote:
> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
> special considerations for the head of the SKB no longer apply. Don't
> mistakenly report ERROR to the frontend for the first entry in the list,
> even if - from all I can tell - this shouldn't matter much as the overall
> transmit will need to be considered failed anyway.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -499,7 +499,7 @@ check_frags:
>   				 * the header's copy failed, and they are
>   				 * sharing a slot, send an error
>   				 */
> -				if (i == 0 && sharedslot)
> +				if (i == 0 && !first_shinfo && sharedslot)
>   					xenvif_idx_release(queue, pending_idx,
>   							   XEN_NETIF_RSP_ERROR);
>   				else
> 

I think this will DTRT, but to my mind it would make more sense to clear 
'sharedslot' before the 'goto check_frags' at the bottom of the function.

   Paul


