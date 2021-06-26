Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A503B4EDA
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 16:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFZOFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 10:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZOFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 10:05:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05F6C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 07:02:48 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso7247499pjp.5
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 07:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4SEWOxMzTxgbS1tKIa+Exfhl1Q8OqdN7piWJ2MSt6Qw=;
        b=Iknf70hdUI5k+6dAQsb93dN/n7Ne3X/RuVQ8pkRfR4f0PlPOTP74dr2Ruxlom7EHgw
         vkdHBghsLvOKx38xnSJcUz+/FyZGjth6kNoLaIaOfnUM2ZGfjfHGAliZMqcBTzMnT3Fp
         anxwzXFgSY1iCWPQU+1vx3DnGeBIqrXHw9bDnYWv/oJ5WSULxgMrzNjGZAWFj2IZK3Uh
         mTj0xcsNNbxAOCeWqiJbnYIrBpfqlgYQShCpoCzbhz5aTd8puEuV6fcj7bwzLvOis4pA
         OJ0xudngXdkMi3JAWdGTJtN7QtsyOeXSAP94e0djEAEDkZRxKYkwuwF74FgvI9TM4Qmr
         ho0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4SEWOxMzTxgbS1tKIa+Exfhl1Q8OqdN7piWJ2MSt6Qw=;
        b=NQrLQhZQ6OljviWG0B3cK0GsrhzGYxK5UHwc7utVf8s8pNvoJV3TfPfW4jh5hAxROT
         XycWmcCBwmsN91l5qrPVnTHvTXYguAAry+Ft4tWm/kd2r7GXfx3pBGBR8ZPH95VH0rDm
         fm3SrJfZa2kz0fgeOyVAijl2EAFQKzT59Nin/e2uXhlkhWQUb5OzkZ/hay8VG5X11RAQ
         M+/a7IHzy8xG3ODYHo/UvPPwUfYAikIKZlUDXmjexvDXYB6xtwDrhI94R/iZdB/UlZvd
         9mpTPZZ4dXuwa5ZYIOAVHWWj6Y1MgmAJ1tdw124XmiF7mv03yU1LuGhFbYda56WUkLRs
         gziw==
X-Gm-Message-State: AOAM531fEc04G1qFdULrZvWDlLFhxjDgAkFD8pjn9GKjUsh9RfkfO6rS
        IWJMz+uQF5KcGp7HMxoD/ItSZKARAXU=
X-Google-Smtp-Source: ABdhPJwahR8J74e4gJNLGSh2evJ/k60Oo6sw4u6563Da9lGDtHx0V69f0SgshEb7T+fcrsJYxxRH1w==
X-Received: by 2002:a17:902:b110:b029:121:74a8:25e5 with SMTP id q16-20020a170902b110b029012174a825e5mr14158596plr.44.1624716168220;
        Sat, 26 Jun 2021 07:02:48 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ml5sm13240788pjb.3.2021.06.26.07.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 07:02:47 -0700 (PDT)
Date:   Sat, 26 Jun 2021 07:02:45 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 2/5] ice: add support for auxiliary input/output
 pins
Message-ID: <20210626140245.GA15724@hoboy.vegasvil.org>
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
 <20210625185733.1848704-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625185733.1848704-3-anthony.l.nguyen@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 11:57:30AM -0700, Tony Nguyen wrote:

> @@ -783,6 +1064,17 @@ static long ice_ptp_create_clock(struct ice_pf *pf)
>  	info = &pf->ptp.info;
>  	dev = ice_pf_to_dev(pf);
>  
> +	/* Allocate memory for kernel pins interface */
> +	if (info->n_pins) {
> +		info->pin_config = devm_kcalloc(dev, info->n_pins,
> +						sizeof(*info->pin_config),
> +						GFP_KERNEL);
> +		if (!info->pin_config) {
> +			info->n_pins = 0;
> +			return -ENOMEM;
> +		}
> +	}

How is this supposed to worK?

- If n_pins is non-zero, there must also be a ptp_caps.verify method,
  but you don't provide one.

- You allocate the pin_config, but you don't set the .name or .index fields.

Thanks,
Richard


