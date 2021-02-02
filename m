Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC1730BE59
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhBBMhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhBBMhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:37:43 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4802AC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 04:37:03 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id t63so19569156qkc.1
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 04:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m+8umcHYCahgU78eNYPd/exZ1t0XPvpy0AAn4cpQgIs=;
        b=tGJMvCerFcUO8PcZfTpWr23mf9nzFXPOSfNXsWAorCDvosaeiSRnwWrZ5H7iAfFFSA
         DaG2z+Nx4l9TC8+FuRql+dh17KjtYYuZ7ejRXFK+0WL0Ziv6BUfgR7LdkT2PV7Q26VSZ
         cjqy1q7bMre9rXbq80frdh+NV8GRn2OqCKxwTHm0wBr10/yRHT4pVuyOuG/RuMwApTZk
         y+fCHRCCk5l4MTNi6dELJ/ePGnkDEsV8TOePS3ZSM5BC4Ps5a+bVBw/PH44s5NLQm/qy
         o18MdLNfuLAMysFPFaoHu2UoltHVm69BI8yRqxljNxBArxfohq6B30r3xYOKLZX3v1Aj
         T79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m+8umcHYCahgU78eNYPd/exZ1t0XPvpy0AAn4cpQgIs=;
        b=OqPK0VgA63ShHRGqsWVwMBabxkMSpPXv8Vp2XTIm/KLa3xZaqWDEpMQP+yQkNeZQXv
         oSujb2vHmR6GeT6Ja2MBx4dFEfILAO6kix9JKkpyA+2LYDmVgA2qxiGKTmq2K73w5wc2
         gGgGRF4jHO/4FL4RiY8tkv3tIPU1EQDPyZGE11Ck/SfPvVJENboT5IdHstduRu9BUrEz
         e1gl5vdPM3bGCmq9hDhw3obu211CoTPHPnDY2n8SukUdyquJsXwDPIVsvDm2IGHikeWk
         BdX3cOhArTgnvDiKff5Smzz2szifveZ1R6b0EPUZlZpcRT5XDzo3H0WKcgEu/F2kMbnK
         IlaQ==
X-Gm-Message-State: AOAM530IpMpQFUej3QJDAuONeogu1fjz4EjG/09UNILgrinEShJhH/m9
        LSjzYc15eMl94Wyuq/zDeoulDfHxyGf87wpd
X-Google-Smtp-Source: ABdhPJzGelnWhjNQoLFrmctFMwp+Sq2MYI9dGGkrTygiWrQC/HfLBdi8jO1c2bLlvrYurH37TwRHLw==
X-Received: by 2002:a37:8b46:: with SMTP id n67mr20566506qkd.167.1612269422487;
        Tue, 02 Feb 2021 04:37:02 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f013:89ca:fde2:42b9:c0d1:d526])
        by smtp.gmail.com with ESMTPSA id f14sm11958353qkl.76.2021.02.02.04.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 04:37:01 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 8C5BCC02BD; Tue,  2 Feb 2021 09:36:59 -0300 (-03)
Date:   Tue, 2 Feb 2021 09:36:59 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 3/3] net/mlx5: CT: Add support for matching on
 ct_state reply flag
Message-ID: <20210202123659.GA3405@horizon.localdomain>
References: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
 <1611757967-18236-4-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611757967-18236-4-git-send-email-paulb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 04:32:47PM +0200, Paul Blakey wrote:
> Add support for matching on ct_state reply flag.

Sorry for the late reply, missed the patchset here. (just noticed
because of the iproute2 patch, thanks for the Cc in there)

Only one question though. Is it safe to assume that this will require
a firmware update as well?

Thanks,
Marcelo
