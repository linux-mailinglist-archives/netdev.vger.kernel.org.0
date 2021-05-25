Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D15390113
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhEYMio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhEYMio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:38:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901BAC061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:37:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 27so21327011pgy.3
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+njOJtR5X5krJ34+Gr/skiTyOmkhMZwvZJqGsqTmADc=;
        b=L4gv1dukbQnSKmADZwToS30kkKKtY/hM16hvVVQhXerlXlo57erCdcxbUiEJHuCgOY
         bb4UsrKQRlAnAaBsdp5Vvddr/7WqaBdtCGuPOEHBh2TXwy920q2bjs2/6tQGngyLn4B9
         /Upymy6+CJnWnnzdHFkOglvA8vzkhjs+4PMiNJ/xxc7G6L0dPyFQ/M94eBbKLyiI2zBu
         00z/w5ngGOh937xqYSpRiE8VJuyiK3jCtpMy0k5npMT5VN4tN7yEPMp8fgz43FO51kGp
         feFMMCgJkKSh8zYTO6ibI90ktzQ+hJo7bGyQALC9PrZ9OReU8XqIHStNbMUW8T/KgDAa
         1gbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+njOJtR5X5krJ34+Gr/skiTyOmkhMZwvZJqGsqTmADc=;
        b=pU/8JXDGgViuoyIrVZK9vTVP9z/EC358SnuI+CutBMjWwEjFX7c1PNicRLdphBiXvf
         aKeZr5fNlLUAsw4v2Z17a405Xbe9xc/DD19gSqr9GUnpqZV825Mu/gyCzfKnGGxNW0mU
         +dlotA4fDJUsX1QzwZx3jwz6Po4pH5Tm9VbcwVjtJS+r7U/WPVwBr9pUN4/e9UBx3vVg
         iL3AXAu5zAeZQq7LZbP4+NY6/SNz8pZbInbvMa3S5qxxKVdDb/aD98wtnlx4PIufRz1i
         OISaJPM0tuYL4lPWJVj1QP7w9zcFRTyBTnaVuYPyFP2Xydb+PxHyi2AlIx2UjKhtTEir
         ZbDQ==
X-Gm-Message-State: AOAM532gJDR018ycciUVpUekj0V7bs6+qgc8e6R0kJaoGrnJcVKiDtEa
        vdOFi0B9/Zke3HSQ23wYCH4=
X-Google-Smtp-Source: ABdhPJzkXh5AN/zbsi+pBHkz1TnERixVZn/GuZtbx5NWaIcCYJ/3rB2e9ileW9D37+BGE9A2FGG/YA==
X-Received: by 2002:a05:6a00:2ad:b029:2dc:900f:1c28 with SMTP id q13-20020a056a0002adb02902dc900f1c28mr29412534pfs.67.1621946234134;
        Tue, 25 May 2021 05:37:14 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g19sm13135392pfj.138.2021.05.25.05.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:37:13 -0700 (PDT)
Date:   Tue, 25 May 2021 05:37:11 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Message-ID: <20210525123711.GB27498@hoboy.vegasvil.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521043619.44694-8-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 12:36:19PM +0800, Yangbo Lu wrote:

> @@ -472,13 +473,36 @@ static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
>  	*tstamp = (u64)hi << 32 | tstamp_lo;
>  }
>  
> -static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
> +static int enetc_ptp_parse_domain(struct sk_buff *skb, u8 *domain)
> +{
> +	unsigned int ptp_class;
> +	struct ptp_header *hdr;
> +
> +	ptp_class = ptp_classify_raw(skb);
> +	if (ptp_class == PTP_CLASS_NONE)
> +		return -EINVAL;
> +
> +	hdr = ptp_parse_header(skb, ptp_class);
> +	if (!hdr)
> +		return -EINVAL;
> +
> +	*domain = hdr->domain_number;

This is really clunky.  We do NOT want to have drivers starting to
handle the PTP.  That is the job of the user space stack.

Instead, the conversion from raw time stamp to vclock time stamp
should happen in the core infrastructure.  That way, no driver hacks
will be needed, and it will "just work" everywhere.

We need a way to associate a given socket with a particular vclock.
Perhaps we can extend the SO_TIMESTAMPING API to allow that.

> +	return 0;
> +}

Thanks,
Richard
