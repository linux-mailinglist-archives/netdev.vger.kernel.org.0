Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247646CA5F7
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjC0Nbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 09:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjC0Nbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 09:31:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEA359FD
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679923815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rnHz54xfyL+gglmIyJKJy5abDhVgwniJPLQmnnklQbc=;
        b=hOFfzCu9iFd7v0hSh4b+wX75wA4m+oDpUfVqyn2TINjjM/n4p78vpbQdhK30KiHc6S4qa0
        1USCshkucJLE0l5RlrXxE1qqjItL0oklCMpcBkH451AHN9h2GvjIPd4fgTF4NrqQFvc5BP
        jOEHGa9SRThhcMCYGReSetEwzhzgPis=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-fsOlhQKJNSqVv3khPlQHDg-1; Mon, 27 Mar 2023 09:30:14 -0400
X-MC-Unique: fsOlhQKJNSqVv3khPlQHDg-1
Received: by mail-wm1-f71.google.com with SMTP id v11-20020a05600c444b00b003ef6803b3cdso2668201wmn.4
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679923813;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnHz54xfyL+gglmIyJKJy5abDhVgwniJPLQmnnklQbc=;
        b=LcHYa4EdTqRFT4O7ERYlXEKFuttLTy8o9A/Y16aMdUssRiDR/ITMPKrnII+x0vycpw
         omrPtr4sidHURE4sL/2lMPjv/+vgANU52zSscLkROdZUtPcSWo1nLShsJGD34xe+mspJ
         1XI2RrwyYC/1K4ENNwSS6ZkaMOCG0nkU/0kxt0yi23CGPa0DaP3ZthTTeIJkPiZ1Ogml
         c+Z/qlkfQSFYfbcBkWQkSlxM1qqOHeKq+xNtoHcKJaN8oQc7k/sD8JYfnx6knwvIJK1V
         1JzNbhv2Lqs+2NVY8w8hRZWUCetIQA2D9qCqcETUjnm1UjaNDVMDnyIzqNBaAwoYdeMf
         Xpag==
X-Gm-Message-State: AO0yUKX+hv4B0pkXUzuC5auDmp8Z0+X1sVAfXkB2TezR1TcCMzNZG53l
        Yp1l6M0PykSJfV3QVAGng8/bENRmMwYiB42WnnMWtzY93UKNr4t+sQhAi5886iwyRWowQ+JqIob
        v0oFf515NzfPo6xLy
X-Received: by 2002:a05:600c:2114:b0:3ed:492f:7f37 with SMTP id u20-20020a05600c211400b003ed492f7f37mr8747290wml.10.1679923813046;
        Mon, 27 Mar 2023 06:30:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set9UiwP8XvEO+pMF2nbKcdfIrVKf+Fs5lq6Q+1t1gZjOUKhdS1XmGs2yy9FXpB/ck95uX2096g==
X-Received: by 2002:a05:600c:2114:b0:3ed:492f:7f37 with SMTP id u20-20020a05600c211400b003ed492f7f37mr8747274wml.10.1679923812717;
        Mon, 27 Mar 2023 06:30:12 -0700 (PDT)
Received: from redhat.com ([2.52.153.142])
        by smtp.gmail.com with ESMTPSA id g8-20020a05600c310800b003ee610d1ce9sm8981395wmo.34.2023.03.27.06.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:30:12 -0700 (PDT)
Date:   Mon, 27 Mar 2023 09:30:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com
Subject: Re: [GIT PULL] vdpa: bugfix
Message-ID: <20230327092909-mutt-send-email-mst@kernel.org>
References: <20230327091947-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327091947-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like a sent a bad pull request. Sorry!
Please disregard.

On Mon, Mar 27, 2023 at 09:19:50AM -0400, Michael S. Tsirkin wrote:
> The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:
> 
>   Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 8fc9ce051f22581f60325fd87a0fd0f37a7b70c3:
> 
>   vdpa/mlx5: Remove debugfs file after device unregister (2023-03-21 16:39:02 -0400)
> 
> ----------------------------------------------------------------
> vdpa: bugfix
> 
> An error handling fix in mlx5.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>




> ----------------------------------------------------------------
> Eli Cohen (1):
>       vdpa/mlx5: Remove debugfs file after device unregister
> 
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

