Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A433584E1
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhDHNjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhDHNjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 09:39:48 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A25DC061760;
        Thu,  8 Apr 2021 06:39:37 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v8so1057170plz.10;
        Thu, 08 Apr 2021 06:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TCMbN67zPDSJit9fceiv1PfmTEjOqEWhzynX3KI/avE=;
        b=jRyttuUGcY4GZfechVDgRZbItEfjCp+wTRhw/JLjWNbW5tMWnJnNiCSl30uxdD7NAP
         iap15PciQEgaptwGq6a9LZHl6FwvHjBuxV11eSBE1SYMVJTURXLUM90APvtm+I2/a9bb
         ECdms8Unpp6t2gwEcqBhczZ0fOH/UEm3sDPuuk/bRs2bIv+W5U6ctEMwWZ+2WNvC5q6u
         /AmRimnoRGNt2fzRDvmkeIlScwZ+GpBz5Mu0oeSgH/du1nZ+9SMPubKox1EPtKkVCX5j
         IfJBtdHrxHTN8vovP3elBlrEOaS9VSYXOUX0sq66jH0LcWBU/i7KZ2Q/kvWfQh7l7mwp
         RDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TCMbN67zPDSJit9fceiv1PfmTEjOqEWhzynX3KI/avE=;
        b=YhEeZwTUHSaqlV4ndCy1wXivoBLHIv6DDpMClH0gM25VYgqs70jFBqF7H0td40kMky
         s5EPr8U5QB7+OzBa18TJFWcQxR708Erzc0Vg7K9Q5g9W0ROlMju5xURynH6gpaXWyJ1F
         1Wd/GAqPjnGerQ3JA28JB4kvLGn6MhqQeNOD6gTe3efMgOVJ/tPwbaUdPLiCKFEPNPYg
         Sa+a/IUUmcj7/b/Qy5eAIv/srRZ3XpZIbciK1itWG9/1R+81p6r56xx6GOZHBm6eqAO0
         zjRL7foDgWN6190TfHN0/HVGpJqYmmG/qmruwWsZ6QEFuDIrfmX/79+YoSxJMZdKXPOc
         IQLw==
X-Gm-Message-State: AOAM532K/i1kgD4U3oMRk6yoiYtI5nr7PNHIefOLiJbaxHBOqVeEsW6G
        rhlVoUriQEf61uET7aW5/D8=
X-Google-Smtp-Source: ABdhPJy70kpaVS41I820D4qY4DsG5eb1qU2Lbp5RoOF36A00i1qu2pEiNZ5kUlw5ovXQU/pWlsTHwg==
X-Received: by 2002:a17:90a:1b25:: with SMTP id q34mr8523162pjq.230.1617889176437;
        Thu, 08 Apr 2021 06:39:36 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a191sm25002410pfa.115.2021.04.08.06.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 06:39:35 -0700 (PDT)
Date:   Thu, 8 Apr 2021 16:39:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 02/14] xdp: add xdp_shared_info data structure
Message-ID: <20210408133922.qa7stbwue44nfvcv@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <b204c5d4514134e1b2de9c1959da71514d1f1340.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b204c5d4514134e1b2de9c1959da71514d1f1340.1617885385.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Thu, Apr 08, 2021 at 02:50:54PM +0200, Lorenzo Bianconi wrote:
> Introduce xdp_shared_info data structure to contain info about
> "non-linear" xdp frame. xdp_shared_info will alias skb_shared_info
> allowing to keep most of the frags in the same cache-line.
> Introduce some xdp_shared_info helpers aligned to skb_frag* ones
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Would you mind updating all drivers that use skb_shared_info, such as
enetc, and not just mvneta? At the moment I get some build warnings:

drivers/net/ethernet/freescale/enetc/enetc.c: In function ‘enetc_xdp_frame_to_xdp_tx_swbd’:
drivers/net/ethernet/freescale/enetc/enetc.c:888:9: error: assignment to ‘struct skb_shared_info *’ from incompatible pointer type ‘struct xdp_shared_info *’ [-Werror=incompatible-pointer-types]
  888 |  shinfo = xdp_get_shared_info_from_frame(xdp_frame);
      |         ^
drivers/net/ethernet/freescale/enetc/enetc.c: In function ‘enetc_map_rx_buff_to_xdp’:
drivers/net/ethernet/freescale/enetc/enetc.c:975:9: error: assignment to ‘struct skb_shared_info *’ from incompatible pointer type ‘struct xdp_shared_info *’ [-Werror=incompatible-pointer-types]
  975 |  shinfo = xdp_get_shared_info_from_buff(xdp_buff);
      |         ^
drivers/net/ethernet/freescale/enetc/enetc.c: In function ‘enetc_add_rx_buff_to_xdp’:
drivers/net/ethernet/freescale/enetc/enetc.c:982:35: error: initialization of ‘struct skb_shared_info *’ from incompatible pointer type ‘struct xdp_shared_info *’ [-Werror=incompatible-pointer-types]
  982 |  struct skb_shared_info *shinfo = xdp_get_shared_info_from_buff(xdp_buff);
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
