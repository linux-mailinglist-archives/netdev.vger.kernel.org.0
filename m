Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F4B3F7F62
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhHZAm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhHZAm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:42:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735D0C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:42:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso5612913wmg.4
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 17:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LwS7DmUTL4xNho/cZYbh8o7wsKgzgnRNYEtLlbdiXb0=;
        b=XnOrrX321bYtcAA9MDgKXCCKw4IKyRyVLmLvQOKOyNBVPGgJOr8QiltqFkWgISv3wg
         DPEglHFVXdr/tqKtaibptw5TvSTHy6V/F9pFaPQaeOZG8iCtd2i4RPkwxBit3HkhwrH8
         zniGquwwQ/smEISPGh42rXj143A1hD5hXCNSBz5MLrfaqx8vNxjqNKZZpg64F8qSfaAv
         nCYDpd+osF0R48XOGuLh4SVmxr/0AsJNAQX5UDOCe4Rl45TwQ9E1akiWjrmJmpIw+AiH
         ffXFthWA/wc170NvViBeOy0yvl07E3Xb879P2ysEhP0eYURwlD6p65Wv2QoiTsmBQV8d
         jDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LwS7DmUTL4xNho/cZYbh8o7wsKgzgnRNYEtLlbdiXb0=;
        b=m3VTikWmA9/+R4+AqIMO4MCFTo0Ya23L0erRlt2tbLAHA6awXYB8NVGVz+/gMqbyHA
         Mtsiz2oC9bgcWLJhQ+XJIyV5zQkTJt1bi5tAqC1LcDvurCT2Pk8J+f+W1S+7v/LlKTvm
         2hZ2t8WwQgUC90ahTkKJ6YLZJXPfg2oHHpi3/oJevp+s52wEmxapwpHbIE3BkXws8aXe
         vMp963HHpj4fuYT1o/zp60Kl046SeSJWw3nChm/7XDCvKz4T/h6VjIN6no9yo5B1RCNq
         ECqdr/PLruJBNW90+9NGbYR18KldqB2B2Hbqqecv78zix903Fe7CgQoe8mY7rbzg+WD5
         BSYQ==
X-Gm-Message-State: AOAM530f4D5CAtdtki9pOr7iKokpa+T3v8aekHs+LX7wDLtrfqYVRd/E
        oUkNrQVfTI4Cm8OLR3SpcWg=
X-Google-Smtp-Source: ABdhPJwyBL0drR83tDL500JBHdmenF6fIqHRNsuwze9F05sbkrznNEv8npPtBgC+dC6BmAzUtby67w==
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr11821544wmj.85.1629938530127;
        Wed, 25 Aug 2021 17:42:10 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id k17sm7931659wmj.0.2021.08.25.17.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 17:42:09 -0700 (PDT)
Date:   Thu, 26 Aug 2021 03:42:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] bnxt: count discards due to memory
 allocation errors
Message-ID: <20210826004208.porufhkzwtc3zgny@skbuf>
References: <20210825231830.2748915-1-kuba@kernel.org>
 <20210825231830.2748915-4-kuba@kernel.org>
 <20210826002257.yffn4cf2dtyr23q3@skbuf>
 <20210825173537.19351263@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825173537.19351263@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 05:35:37PM -0700, Jakub Kicinski wrote:
> On Thu, 26 Aug 2021 03:22:57 +0300 Vladimir Oltean wrote:
> > 'Could you consider adding "driver" stats under RTM_GETSTATS,
> > or a similar new structured interface over ethtool?
> >
> > Looks like the statistic in question has pretty clear semantics,
> > and may be more broadly useful.'
>
> It's commonly reported per ring, I need for make a home for these
> first by adding that damn netlink queue API. It's my next project.
>
> I can drop the ethtool stat from this patch if you have a strong
> preference.

I don't have any strong preference, far from it. What would you do if
you were reviewing somebody else's patch which made the same change?
