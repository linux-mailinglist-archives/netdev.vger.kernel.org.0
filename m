Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8BDD3774
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 04:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfJKCRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 22:17:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41601 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbfJKCRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 22:17:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id v52so11711439qtb.8
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 19:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hkxzZutoMB4mL+d3Ug//lWHvkUJxUQSMy0n0jqoKL1M=;
        b=wTT3aAagQKQtlbtIxC5nKSFwQb7PwbfsDSTqjSB2TLJcRyFrZrHmOaNsDcT1oOQqKG
         KZrtSQV7XGijBUVPpP/0TRkP4SWIRyhWDR2vJBw1H0IYzvsHC/fDu5a2FfbAdUfLJIKX
         Nr2IATVQ0z27V0O6hCb5xgK81jPANhyzh7NeTVdD3aaBk5Im18822Fepc3bXbm/5SUVR
         ioTIVJn3wMmcWTlorKTAByvus/VqTwGzMha1bMw4fCqxvToLTzf7t26KGFn8z+SUhlmf
         //9wLyU3uMdnFjxZ1ZLn9TwUX5euyqkB5x03SLYEk2aHcU6xH9mFjMDieQZRaJid6hEp
         3GMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hkxzZutoMB4mL+d3Ug//lWHvkUJxUQSMy0n0jqoKL1M=;
        b=FTjgzMNaHhRAWr+jKB0/ReEe51SczKvK8m9c1hAMgPmdeFMUBNwaggMGjT7piO4+fm
         RVdfWoT0G6kwak8czFInUIYTqGEDAhq0wrM1xnBESlcIcKzHdwsMeMlBx6ZaKIhjNStr
         DKylm0Y+2em60oMnmGSZjDpRCA36xu1/lmYOz1ZwCUFMsXfpAuGXD3Pufl7iR2sIok9F
         6zGWSlE67uMyUjsEaFaeL5klnYKO/EiRjf8ImPckg8hvv6ujbRJBu91Oiv8VkVo140ua
         dKtS2seomp5Ig/Qt4V8ss/TzAFVDg6BJ5QY+xOwiePTNYc1BbGrzbtz4dP/ci8srjZ41
         +vqQ==
X-Gm-Message-State: APjAAAVcIA5o6Rt44FwvVdfrA2S+WwmixVZhxwjLoZh4kwr88yC83qRO
        0Z6mSOC1owA5JJdBUn/gEYkQKg==
X-Google-Smtp-Source: APXvYqzIn0S9ummLC74r3g9FqMdFkhi41XU2tWER3IiwCUIpjHJ14Oj4RC+eYohu8iGTOxdjyDbTYQ==
X-Received: by 2002:ac8:d04:: with SMTP id q4mr13985060qti.76.1570760229973;
        Thu, 10 Oct 2019 19:17:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m63sm3564290qkc.72.2019.10.10.19.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 19:17:09 -0700 (PDT)
Date:   Thu, 10 Oct 2019 19:16:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net 0/3] net/smc: fixes for -net
Message-ID: <20191010191653.35c93381@cakuba.netronome.com>
In-Reply-To: <20191010081611.35446-1-kgraul@linux.ibm.com>
References: <20191010081611.35446-1-kgraul@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 10:16:08 +0200, Karsten Graul wrote:
> Fixes for -net, addressing two races in SMC receive path and
> add a missing cleanup when the link group creating fails with
> ISM devices and a VLAN id.
> 
> v1->v2:
> - added fixes tags

Applied, queued for stable
