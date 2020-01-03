Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA4F12F52B
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgACIBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 03:01:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40850 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACIBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 03:01:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so41566475wrn.7
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 00:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wU0TvupZ5BJU9ETN87LE6rZxtzRHnVPyyKAP6+wDyhU=;
        b=o7qsgNXcDU696J7nLRgPax/ERGxBHjC+k0WCNKU4RRBs6nPDL3fapYBhHnuHwYzR2Z
         u3Z1OrLQCN7dZHCIfTDKiKOiz6Of7FqcmxTYW6K8eUhoqmzJizeLd6/TlYM0O4sn1JT4
         1L9iN607Dj4Pioq0TT2F+io2LDVEE9VuWPPdgkU5SFWXbmsQNnKXlb5cozjsZcx3FNxh
         kO1J1C3K7JKV6rZgIoSHlS7tvotAREcPQhC97zpXCbzA2d/L+yGVOAvwvYTXOCJV4Rev
         iAnuJnFbgBeJHwUdcE0m6nMPFQbe9MaIoGoSs2JtLEArEbQuwforPrS3LZVRHob0Qtyr
         H+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wU0TvupZ5BJU9ETN87LE6rZxtzRHnVPyyKAP6+wDyhU=;
        b=GUJaKge1y+IiLmLh9V5ocHpzTnOieW14l2xMvh8RJIRuQUudeWoQncYh8+UkU8evQf
         FsxvrrbWzTCC6BIWSV5LI2RB0GfqONdaZ1DCzuyFNrwffCKjz3pix4sDc0qLMDsohH2r
         d1vnVsFsScA9eEQrZ1poWe0jpuBAMwWrfcHie5pp+yuHhjmM0m71qxQlTl1uCdo/NNUI
         dR8lRuZvVIngyhSHfrUeIFn4RwrUDl6AJ6DvYacpCmyIdX/WXBdHDc7V8BbzVMo6qCpr
         HWlSsZWVDwaE8WAIqhGVdgsosCkGSsfrpA+Vyx2qkoAskPPT2X5Zyk+SI4kouBIjCTlX
         HHPQ==
X-Gm-Message-State: APjAAAVCva/9H2eH3jDupGGTo/UXKoiEPk7GSHogcJplUdr6gJq4iriJ
        1hUjIm5P+wdV3y2+oLaOal14IWALndM=
X-Google-Smtp-Source: APXvYqwZJsA0NgVJMGEx09Vlphl40as8tcL015upc4gHE/2zsQl258HowzcLyxnQqModvnS27iQkuw==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr83428682wrv.86.1578038506041;
        Fri, 03 Jan 2020 00:01:46 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id j2sm11450736wmk.23.2020.01.03.00.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 00:01:45 -0800 (PST)
Date:   Fri, 3 Jan 2020 09:01:45 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: Correct type of tcp_syncookies sysctl.
Message-ID: <20200103080144.GC12930@netronome.com>
References: <20200102.160818.1273976528943190177.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102.160818.1273976528943190177.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 04:08:18PM -0800, David Miller wrote:
> 
> It can take on the values of '0', '1', and '2' and thus
> is not a boolean.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  Documentation/networking/ip-sysctl.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied and pushed out to 'net'.
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index fd26788e8c96..48ccb1b31160 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -603,7 +603,7 @@ tcp_synack_retries - INTEGER
>  	with the current initial RTO of 1second. With this the final timeout
>  	for a passive TCP connection will happen after 63seconds.
>  
> -tcp_syncookies - BOOLEAN
> +tcp_syncookies - INTEGER
>  	Only valid when the kernel was compiled with CONFIG_SYN_COOKIES
>  	Send out syncookies when the syn backlog queue of a socket
>  	overflows. This is to prevent against the common 'SYN flood attack'
> -- 
> 2.20.1
> 
