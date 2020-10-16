Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EEC290DD6
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 00:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390253AbgJPWpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 18:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731757AbgJPWpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 18:45:05 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D51C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 15:45:05 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id t25so5474822ejd.13
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 15:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5QaKDhHA51i+ao4lZH/mlb5XFtbpdEQDvqKAwWDWSZ0=;
        b=VuFKVselKxE/NUPSVlsuYLYd+xx2jwi+8XSf6ypnndGdpKkTr/0ZQh8HPFI8TsTf+e
         wUUHk9zZHsWk3mI0Np7VPe9nC0s1S93zaDHhYhE258JygaQu4jqbLyOMYY0F2KlnUHz1
         kQVb/MgB00krpNhPeDFFcCFRvu6eGxqAz0DZfTv0HPk/8DOzga2C1cp2i4IJ/wbIPcWT
         rsxvq45XE+3sr33v05goCHLnXrISJbjFbwAeDqAie7dS7EwZExX9kAzDDl1YNYie9PBS
         LQY0ggvdwfdSHU13+nr0BQQQ/LHV8lyaTQc/8zCnqiPAR8dM/I/ziJ5HUWZ21mxtzKD/
         FuUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5QaKDhHA51i+ao4lZH/mlb5XFtbpdEQDvqKAwWDWSZ0=;
        b=CjsGnHv366z/DqAZ+qO2SfDXqtuTn+bgVGoLsd3gw+/Ja6HeMLIz4FUohQe3xzN5Na
         Fv/IzvMtza7Qe5bkmrws8fK4VtoWzpwFp4QLJxy/CWXuhbszqdELn/GqW6uQVBK2WSnR
         BzuzGVRLVSCv8UtocxDJ1dTE6sJY43ska2i852ijF6hybh+1bCM+YFJwa7M+CLipJGix
         x3UKarNNd9t9hXwcH0VWVV1wB7fBVrE3UyG8NBk68NtPTR1jJq/82vcacseScCKC3S/D
         74y5T2hCPyMXQP58PJ/FSNHZ6gBt6NK8cz2sgnBZw3yystB9qk0fUPHaKl64lhZpMaIl
         27Ow==
X-Gm-Message-State: AOAM530fgbYlomS8z1AXdJhkAjPGTon1+vRuKRPNPKp7COcloB0yi9uD
        SfNH1U9qBjOatjym8Vi4LEk=
X-Google-Smtp-Source: ABdhPJxSjLpm0FHn2gf4h9Q2yCwN9jBTlgXmXL8RqAVAvTy/gfMSgVAs9TODPD8ue176xKtrcMmI9Q==
X-Received: by 2002:a17:906:1e04:: with SMTP id g4mr6010027ejj.72.1602888304297;
        Fri, 16 Oct 2020 15:45:04 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id jw9sm3059899ejb.33.2020.10.16.15.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 15:45:03 -0700 (PDT)
Date:   Sat, 17 Oct 2020 01:45:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     zhudi <zhudi21@huawei.com>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, rose.chen@huawei.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201016224502.wztzj45gxepygzqd@skbuf>
References: <20201016020238.22445-1-zhudi21@huawei.com>
 <20201016143625.00005f4e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201016143625.00005f4e@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 02:36:25PM -0700, Jesse Brandeburg wrote:
> > Signed-off-by: zhudi <zhudi21@huawei.com>
> 
> Kernel documentation says for you to use your real name, please do so,
> unless you're a rock star and have officially changed your name to
> zhudi.

Well, his real name is probably 朱棣, and the pinyin transliteration
system doesn't really insist on separating 朱 (zhu) from 棣 (di), or on
capitalizing any of twose words, so I'm not sure what your point is.
Would you prefer his sign-off to read 朱棣 <zhudi21@huawei.com>?
