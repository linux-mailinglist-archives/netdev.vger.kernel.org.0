Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847EB3694AF
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242208AbhDWO2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhDWO23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 10:28:29 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54144C061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 07:27:53 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id z25so13773487qtn.8
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 07:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YLPJWY/azRbnnEeqJelTHQDU3rlCapQE7SWi8gOkxo8=;
        b=X8DMnOvJWz6RVRUcb6+nr43WXMARL/jS3IeUBfx0zbIDKsAcmX69OndHPl+ndP2HGJ
         VH9VgVugzyWKzbcfFKLCIUxTRIlbynnxGumlG227wFnOYYHOx51GidlswE9k5kFwkIQt
         RwmBGsmDEtfnn56saGev6jZPLRffF5TngdXYcHxlLYUz2WcXvKiBzcD89hdg1t88bu3t
         MK7Xwt6gXFikn7F7kEx/P/Gmyn6y2iizIGswNP9TlXVlUByT+nGEJXJvixkqNjWCF6Ry
         SOGd19Xj3sG7YdJVb22Uhkv/NtXAot/N51k1rPmwGqBIkXRY4pKNEBBuxAqpatiFjJ2f
         2CfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YLPJWY/azRbnnEeqJelTHQDU3rlCapQE7SWi8gOkxo8=;
        b=WmjVxVoWroYGqmdq3QnhxQAIIgKaafYaRcC71Zpc0Zq51u5lWrqw2Ak79KePv4mk5N
         TBwVEgVkMks9jOQfBXh4ItC7ueCC+EGpQrD5bp/Kk3ZHnDrQi//Lt062KUBd185YkzAl
         Qeuu/U/tT4nCHiuqW3fVdCAiHMPvixNn6IL9stiMnwsUdfH63xscTRip1EQaCqgcLj+9
         00kWm+4xF1kPLRorVX2Qev8264d3e3X67KjKZy2AV3YGeTL03wtwgPHW8eR4zguRwwYf
         +Auem7olffHVjFwh2YNMZk9Pb1zINXi1+rrB3zKWRcsXKzbsIZaHEEpwTrMacJBRbcGC
         DgZA==
X-Gm-Message-State: AOAM530Lj8buI4HvTTGnQU3e+GpOLNYgrCWjA4mcrdTbD+i0dT5crpx3
        CVDsy6AaEWwuYqxP9ucF8JCvag==
X-Google-Smtp-Source: ABdhPJxkzemfNaJUgp3rIDqZFUObtNumgoSWIwZ/JIcNRt5n2hkELchTzx5suzsRW3S+A6j/ytkumg==
X-Received: by 2002:ac8:488f:: with SMTP id i15mr4193224qtq.75.1619188072605;
        Fri, 23 Apr 2021 07:27:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id x20sm4412854qkf.42.2021.04.23.07.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 07:27:52 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lZwmd-00AbSa-Gy; Fri, 23 Apr 2021 11:27:51 -0300
Date:   Fri, 23 Apr 2021 11:27:51 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
Message-ID: <20210423142751.GI2047089@ziepe.ca>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
 <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
 <40c21bfe-e304-230d-b319-b98063347b8b@acm.org>
 <20210422122419.GF2047089@ziepe.ca>
 <782e329a-7c3f-a0da-5d2f-89871b0c4b9b@acm.org>
 <YIG5tLBIAledZetf@unreal>
 <53b2ef14-1b8a-43b1-ef53-e314e2649ea0@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53b2ef14-1b8a-43b1-ef53-e314e2649ea0@acm.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 01:30:00PM -0700, Bart Van Assche wrote:
 
> But where does that Cc-list come from? If I extract that patch and run the
> get_maintainer.pl script, the following output appears:

Andrew takes it from the email CC list in the original email that the
patch came from

Jason
