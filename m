Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634842B0857
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgKLP0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgKLP0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:26:06 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB30C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 07:26:05 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so6396889wrb.9
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 07:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EOQb8O713MWYvow0PtzHAqGajIqBfUVJt3v16q2UGow=;
        b=aiCtk0g4nFa+6R7y70FQ1VrpNMQHV4DKaaP8uelsKRqxbUOvUNo6enbrEPVLmFiCSe
         BgJRYxQIyqJeeI72nDnl6ZwMz0E8ym4+ZXLv0jMw8JJMUiS1Cq3TUsown5TUri8VQBYt
         mdO3JLhuGclqRKm8hSxNRV93Kn78visyOoCUJnI9yEstttBK9bLcayY7LFMe9zGQwGET
         Xrx1GcoYlNdEJqTqz5oxsj3peCEoWU+SOFPUCms0E4l688Ibu4uY26CBjf46LjFmrehJ
         LRl+ij7JT0bDSoyUsAnL5vbZpcyNteqZR/LAzQj7pp20+42YusnyViGgPlp1BHg96mSj
         Ifgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EOQb8O713MWYvow0PtzHAqGajIqBfUVJt3v16q2UGow=;
        b=gw4XW+tw90mD/TgCU+ISh5al1JLD4t2KO6NlGOq9Nn7xvuSXyt0nWX9lOwKAS0HXfZ
         l6TJsTGZAPdGtYPusHHIHg4x5KfmSLeZ6F6y/8rbxRE4sTWLTUkyuuNOsuKutCN11Cm7
         tdk7hFD4K1guQ/u2UX6gdE5+NjRtiT0a1kjPWa2Woz4MfssDTKea2/3wSHULnvLWkdek
         xu62WFUCCW+K9NEGMWqx7IpWo+DSvV1Av26AyrAQngFoh1jMp96Bz5ydppXqpwIfQYWx
         BVFSoU/BbEqKUHRwhuXNgIGSk1kghjihg8au7MPGarA/4uOVqVvx+2DzcC6SNppDaet/
         oGiw==
X-Gm-Message-State: AOAM531IJJdiMfG0Vqi5PVGCH/lnP1un+ILdmzZEe9P6Vc1lcFqU86kK
        /YtojKYHta/NuUMwNnhVXWqxZw==
X-Google-Smtp-Source: ABdhPJwrBah6ufYMOGrvvq8G9uj8QIoJ6cnPvXKHRu2xUsVIf144ik/dLCep+nXuAnm5oqOWNREAxw==
X-Received: by 2002:a05:6000:347:: with SMTP id e7mr39577wre.35.1605194764601;
        Thu, 12 Nov 2020 07:26:04 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id r10sm6740333wmg.16.2020.11.12.07.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:26:03 -0800 (PST)
Date:   Thu, 12 Nov 2020 16:26:03 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: Fix passing zero to 'PTR_ERR'
Message-ID: <20201112152602.GA13694@netronome.com>
References: <20201112145852.6580-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112145852.6580-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 10:58:52PM +0800, YueHaibing wrote:
> nfp_cpp_from_nfp6000_pcie() returns ERR_PTR() and never returns
> NULL. The NULL test should be removed, also return correct err.
> 
> Fixes: 63461a028f76 ("nfp: add the PF driver")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks, this does indeed seem to be the case.

Reviewed-by: Simon Horman <simon.horman@netronome.com>
