Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742F125513B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgH0Wil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgH0Wil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:38:41 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1620C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:38:40 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id s15so3499732qvv.7
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gm9yFXXiZvCthKk4pDSHuzet7PICSEE2S3fe/9edihs=;
        b=YBVzAHMOmZn3qLVNGdk0sBckXX9okPlan12HR7uN0U8bWXRx/qqaMDhhZEES7qBcYM
         cHCcCvZ1T2mfzxVGP5G2uIQZ8+20PN/i6vjvAg/s9iekfuKWauOId+S9gDV3xu4t3b4z
         Q2vYmOuJ+HaQ0m+ftwtvXUECAqpT0U4uThwGrNe6XPQ4ABKQEHpqTpFp3kXg09g1HJk7
         zc4SEybKjJ785AcNHki4Tvu+EhJmwFVsezMH5Q4CMZYHa3y1M3pBUB+FRSfMPcXqN0zw
         xynYWmbZ4DKOATv8TxTJ7m1fqhRf9AI/M8pCIrcYza1/XkF4NURVvje+6xECrDttLuFz
         bCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gm9yFXXiZvCthKk4pDSHuzet7PICSEE2S3fe/9edihs=;
        b=JJ98mQE+p2G6JgNqgsbEvwBRCmJHE4ifinCqSSswKqjeVkR/f99cH19eBNBzhdDtOO
         zbx+7Cf/0dTjynHf7wSdKUVzMfgHX0lp1ZuEGygJqyYqd1O6HaOQP7H0jJARD5iSm9w8
         ldJctr3nqaxtvnt7Xs5/JjoxLcIJbMiymMhITXTgXzbU+Oef+6MensvrincuPnRV6+OW
         +B5EkKhSX0/d7im4+7+OKUKvdnvrr3W7afzlGVjd4aP2f+IT0WiYM1ca7iQ5Umz2ri7m
         se5mVY88/n+G/yB28lf811r2kF/+1ipzi7SMOC7gFHxxO45bfnWgAZddFzmBORu16vmQ
         1PlA==
X-Gm-Message-State: AOAM5309g8xv3wWZMq0ACMhMZhfEB3VXZfzdgMbHFBsQ5uvQ2rFpD+r/
        Iqa0X+dCvsHPo8KXLAbA718z29jwcN7bcw==
X-Google-Smtp-Source: ABdhPJwn1t3A63/f77V95gilAttKAiHFOgEJE3cHx/aFnnt9WTq4CWHRZdeLDxlA/GJq3AgPTFO15g==
X-Received: by 2002:a0c:f84b:: with SMTP id g11mr20973789qvo.184.1598567920095;
        Thu, 27 Aug 2020 15:38:40 -0700 (PDT)
Received: from localhost.localdomain ([177.220.174.181])
        by smtp.gmail.com with ESMTPSA id w32sm3206790qtw.66.2020.08.27.15.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 15:38:39 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 91438C1B7C; Thu, 27 Aug 2020 19:38:36 -0300 (-03)
Date:   Thu, 27 Aug 2020 19:38:36 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     wenxu@ucloud.cn, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] ipv6: add ipv6_fragment hook in ipv6_stub
Message-ID: <20200827223836.GB2443@localhost.localdomain>
References: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
 <1598524792-30597-2-git-send-email-wenxu@ucloud.cn>
 <20200827.075147.1030378285544511842.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827.075147.1030378285544511842.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 07:51:47AM -0700, David Miller wrote:
> From: wenxu@ucloud.cn
> Date: Thu, 27 Aug 2020 18:39:51 +0800
> 
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > Add ipv6_fragment to ipv6_stub to avoid calling netfilter when
> > access ip6_fragment.
> > 
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> 
> Please test these changes with ipv6 disabled.
> 
> It will crash, you have to update the default stub in
> net/ipv6/addrconf_core.c as well.

I didn't test it myself but I'm not seeing how the crash could happen.
The next patch does check for it being NULL before using it:

-               if (!v6ops)
+               if (!ipv6_stub->ipv6_fragment)
                        goto err;

Wenxu?

  Marcelo
