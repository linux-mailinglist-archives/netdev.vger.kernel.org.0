Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05E18036F
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbfHCAWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:22:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40078 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388721AbfHCAWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 20:22:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so75699108qtn.7
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 17:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/AsxNX/HoiCUTitgu7Zhub4nXA9wkO6WI1FPkvPAZO4=;
        b=RzDTgJabyerl3vdx1kIKMxh/tHGv2muBmet8U/xA+dZkaLu2rOeUztjTgWs5oERUiQ
         MgL/39L5coy2iW+yPmpfxSZ+Lli1Xz6jgEa17jdQXcFFPCFJgw8Xse678EoHsomL2xVm
         zlSSAHQ3IVlU8vsoqmKT2aTR+1K3OIMc4FGvyu1/SYa04baeJz1YyPog4K4Kqyx/yhgn
         mpQjCx/wn6R8Tq586bM6MK7JUAAz4e2uH+NlthYh7BGyIWg0iZ6MPAFWuCamF+RkZry0
         1HdMfv0rdTUrcVAq++gY9XS0vkRKl9b2BT+MWuTg6He4CC0B+rrMh1328cSxEBYXKuIk
         ijxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/AsxNX/HoiCUTitgu7Zhub4nXA9wkO6WI1FPkvPAZO4=;
        b=I0k7sYWCwW0vg34twdcpB8JDLDHnMjAT1LhbsyipIZcouzjKvWfvhEpdlwEtT923VJ
         t4Dhv8yZG8R+Fict/CubOVjYbnzla0jMWUybIcCoG19a5s8We5wBmKzTLORyhh4w86hp
         lDq9NuXLJQxWI0WowWUp5T6322oDrSD3yJlAzRCMbQVwCuqjp6bG+V1fDWL+jtVNi+xq
         /WdvGXS3aX7aSTUVryPfQ9qnucFdd8rGHfEWjI9oeYXynC4ylMftNd+ZgHsDpLE0b+c2
         gQXZ4C9rHzjpoKLEKH1cXIw2wAPe2e1pALN6hiyBOTa/HNwxqLw+kHXiAX3D94K1VtVt
         tcwg==
X-Gm-Message-State: APjAAAXXZntoYWdyg8fI+6eQnQdFV+00qoYvcJwOyKza9JlHeYa99IWL
        JHWeGIh41lX+c1jDoIovrmR5Eg==
X-Google-Smtp-Source: APXvYqz4U2PA6UBDmArGdcdkCyRLC4FBXI+2UX6SDy50EtxpWhrV57FEoTIDbobfxn6BxqpxKJVH6A==
X-Received: by 2002:aed:3747:: with SMTP id i65mr99964140qtb.166.1564791735391;
        Fri, 02 Aug 2019 17:22:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m27sm37873964qtu.31.2019.08.02.17.22.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 17:22:15 -0700 (PDT)
Date:   Fri, 2 Aug 2019 17:21:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
Message-ID: <20190802172155.7a36713d@cakuba.netronome.com>
In-Reply-To: <45660f1e-b6a8-1bcb-0d57-7c1790d3fbaf@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
        <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
        <20190801161129.25fee619@cakuba.netronome.com>
        <bac5c6a5-8a1b-ee74-988b-6c2a71885761@ucloud.cn>
        <55850b13-991f-97bd-b452-efacd0f39aa4@ucloud.cn>
        <20190802110216.5e1fd938@cakuba.netronome.com>
        <45660f1e-b6a8-1bcb-0d57-7c1790d3fbaf@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Aug 2019 07:19:31 +0800, wenxu wrote:
> > Or:
> >
> > device unregister:
> >   - nft block destroy
> >     - UNBIND cb
> >       - free driver's block state
> >   - driver notifier callback
> >     - free driver's state
> >
> > No?  
> 
> For the second case maybe can't unbind cb? because the nft block is
> destroied. There is no way to find the block(chain) in nft.

But before the block is destroyed doesn't nft send an UNBIND event to
the drivers, always?
