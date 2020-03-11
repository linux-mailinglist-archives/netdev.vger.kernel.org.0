Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7CB181670
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 12:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgCKLBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 07:01:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37094 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCKLBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 07:01:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id a141so1591576wme.2
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 04:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oflwp/Lw4kwK+Upeh1L0PxMQlJBMqbLuj84dJ152Stk=;
        b=dg7hymJo4Wot+U4205afT91cmOPE15WaQb4t0dPmwKd/DZAzSk64vqNa0rOyexpodb
         2rqRLWWVPmPstgdAfexm+n4zgXXLeBNBy5d3OgW0TZc629OWO48QIjI7Wnvzcx7xhyyL
         3prHPaaxweFy93fu/ijMzDOJS+XXP9NHWhMgr8FjFQZSenA6hBMgOxQF4yKAbK7yuINE
         Ksyw6JngBVRdRyutQl/qHpP13qo2DNP3EGMaN17GzOAm57yCMGoJcFyPmeAlaan147Dr
         3X5cbXNka0c7GR5UWpye8AgrgXSbgDR6uJrtEGRjYNa75bk3gwaJqsER2rR/c+YfyC1I
         Nh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oflwp/Lw4kwK+Upeh1L0PxMQlJBMqbLuj84dJ152Stk=;
        b=qr1x8Gx7IybWZ4FiG6MPiYsxyPoSan8ox585PH2jjtWmCZ8asTdIvYEcaIjplGAQQW
         kgI/s4eEpdZspeOLZ23C5wzdLqEwdj1EJa3USo06aofwHwyE7kYUbHHjmz7jcih5uaFb
         uRPPg0ruC0NxKv1wXpjeXVCBFHWthjV4ykexoVh002iHs919U9dsmTuHkp6Yz12glLaO
         p/hEkQIAqOJlF1uwsTFTL8jDiiUOiVUprPJb+acJnC5fzfkFKK9kXhZbQz7JGfmxUVli
         2YFBcbyksBu9kBfELbR6joUteUhpUK5ntDHpXKH/Lb6SmidQ9G7FS9X5iTj/X5GmQ3/S
         ZNZQ==
X-Gm-Message-State: ANhLgQ0qG64ufv+oJ/WJ+H6qJz10z2xXUxMOQ4KwXHzssYe0/BZ9HksY
        YZs93878fKPvJQ9+jq5pY6fmRg==
X-Google-Smtp-Source: ADFU+vs36xSc4zePJast+CJLYR5pjfL/e+IALZ/xbFjkcj9ozwXRtwRjBSR/2a+Lbu10aPneM4m1SA==
X-Received: by 2002:a7b:c0cf:: with SMTP id s15mr3418147wmh.106.1583924473942;
        Wed, 11 Mar 2020 04:01:13 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id b5sm28306406wrj.1.2020.03.11.04.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:01:13 -0700 (PDT)
Date:   Wed, 11 Mar 2020 12:01:12 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oss-drivers@netronome.com
Subject: Re: [oss-drivers] [PATCH 4/7] nfp: Use scnprintf() for avoiding
 potential buffer overflow
Message-ID: <20200311110111.GA304@netronome.com>
References: <20200311083745.17328-1-tiwai@suse.de>
 <20200311083745.17328-5-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311083745.17328-5-tiwai@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 09:37:42AM +0100, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: oss-drivers@netronome.com
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Reviewed-by: Simon Horman <simon.horman@netronome.com>
