Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74F3F3D01
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 03:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhHVB0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 21:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhHVB0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 21:26:36 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7A3C061575;
        Sat, 21 Aug 2021 18:25:56 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id x4so13122689pgh.1;
        Sat, 21 Aug 2021 18:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uhQUv8RqFzAiliaNh7mZeYamCoPUY3mAves2nkndBfA=;
        b=M0aunCSGOz9EN86Xmb8Wj5OyWi3/c0Eih31tXxb2SZcd64Ot7YvEkUNKS94ddVOr7t
         MhYxJOpRGOHpaAEc5WnGUMiBrRIuFi9vNcHuaTMzexMRn9XOpTjhaMbc9KlkHJrE87TJ
         L9aInV3qB1eTlaFesbTP6WGonGb03G8VsJC/anu443nXS/jGQ1UMn48r/u9yFwVFJ5BZ
         Zpnslu0sT/7gL7keRTAJlvCRx0PpV9kI2dUhuY2MRQ8rXIJAhtsRIgAACY3RTuX72EWL
         7i2FdKFlei8MT+LTOxAniJoMyY/uxKUjw6jFd5aGjGeV5Hk/M+EzuS34dhO/ylEA7Nwf
         RhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uhQUv8RqFzAiliaNh7mZeYamCoPUY3mAves2nkndBfA=;
        b=ChEz+EEWPu+NDXkhqpJPg2GK0I0lXFFSUxutXmPdgk0aUawWharY3w9Cu0CbCUKhss
         eyxiKn1tfkDvW44oJqrcM4FjeB3TWXUs8jKhuNdDdIo7ZYNrgavxkvSfjN+IgsI1WCIB
         lfUd4CYYIwuvff9K7Xal0CJnwwge24G/CTkeMGP7yvQDl4z+g44r7CJVkD4wn+nO4m6i
         Zh7RkNm158QpEV3dIqSbs1tP6fmxBsFgtMMSgn4Uq3hbhkyw0JMMHPfhS+UBY2lq3ZpT
         GjCyp+zL8OfQmHfGdJ6RLg7lyXFLS+JdOFXNhV8kmraL8/CcLeLecN7yQJBj6f/JPUk6
         gjOA==
X-Gm-Message-State: AOAM532nfQFHEYwIlbghkSiqEEKMSHu1PEljI3HzexKEUDCduHAoIfv0
        odtJJ04S+ccd8J110saIsXQ=
X-Google-Smtp-Source: ABdhPJzyuuk99pLRVPhdOqhP5AWTiNrfvA7xkqIz09D976/BUIGS8IY84uid60S5TmZRvIQLw3kuLw==
X-Received: by 2002:a65:414a:: with SMTP id x10mr13183658pgp.403.1629595555843;
        Sat, 21 Aug 2021 18:25:55 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m2sm11512054pfo.45.2021.08.21.18.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 18:25:55 -0700 (PDT)
Date:   Sat, 21 Aug 2021 18:25:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        arnd@arndb.de, nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: Re: [RFC net-next 4/7] net: add ioctl interface for recover
 reference clock on netdev
Message-ID: <20210822012552.GA4545@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-5-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816160717.31285-5-arkadiusz.kubalewski@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:07:14PM +0200, Arkadiusz Kubalewski wrote:

> +/*
> + * Structure used for passing data with SIOCSSYNCE and SIOCGSYNCE ioctls
> + */
> +struct synce_ref_clk_cfg {
> +	__u8 pin_id;

How can the user know what values of 'pin_id' are valid and useful?

> +	_Bool enable;
> +};

Thanks,
Richard
