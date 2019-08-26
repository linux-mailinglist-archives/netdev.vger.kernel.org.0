Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5619D295
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbfHZPUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:20:52 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38682 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbfHZPUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:20:52 -0400
Received: by mail-qk1-f194.google.com with SMTP id u190so14359798qkh.5
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 08:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=VCaBvk0BL10hd2BT2oeHc3DkCFnlBM3MGFmf8gbn22s=;
        b=EZMz6gO73zHbvX69avyvi2xlQY+nfGHE5z8mmjxTcw8i6fm1vIWKotYj7vtI57HzMA
         LFlqCgcUOJBSTzI3FL3EWDZzBgJyGX0HD/pWEUi8mTKa6AuYvQru82KnhAouMNMllY/h
         +If5SC4eRgD6yR4t1dCjzApuqJlha0Nru00ZWT8XOCgPXPxJ+QpZxx6F0MTzka4Y+PSn
         lMU3MhO6R5Q/KgZ+oNpVDMZqyhL7a+1GBwKRl7GkmyujtnmpZY9h2Ac9SrVW8JHnXlb2
         hMXZ1XeSFQBYCK4lp6kuyoO1+531ps+2jitDMPxJNS+I14/NAy3Ax0f8ihhsg+pJPw0o
         8+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=VCaBvk0BL10hd2BT2oeHc3DkCFnlBM3MGFmf8gbn22s=;
        b=Nu0qYUjCPoZPtnivhHUmzfgKYeXwASLY830Ovxj000KlMX4Lj3FaheScS0EW/62Ye8
         GhwwxlYFS0Y9+LF4sIZaekdj8hljm+qfXSJmp5bRNilgmroO2QP8Yb733c0To+EKU+Fu
         rs8Wh7wDhBf9LGtHE3M2/W0ErH+ng1jiUvWwjoMajnfahAgxOxG+2bsMEloEsB5ooowj
         KALRyFoH/yOtqyLdhFeYz3bzjs7jGNxvQg8Z7FFeS/FgbnnlRd7mPoGxEViakoi7j4gE
         k7c7Z2fMpTwDhMM3RJnCQp12kngCSJygl4veea8x8CcgNFCINnxQhC0SKLFpvid7zEa5
         gF1A==
X-Gm-Message-State: APjAAAVHrvEMPw03tY7dhsW/rbiXjwrKDa0U4+4d94gFKLn9WIHoSbxp
        7tgUBDwxlzGZL3YHH2IaaBQ=
X-Google-Smtp-Source: APXvYqy2nPRqjKcDg1crybytJcZ4ZdS/68FlRv+rATFhtgHeJ4JxC+WsEn2E3eUidiCdXDSoxqpH6A==
X-Received: by 2002:a37:a358:: with SMTP id m85mr17061391qke.190.1566832851234;
        Mon, 26 Aug 2019 08:20:51 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z4sm6175553qtd.60.2019.08.26.08.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:20:50 -0700 (PDT)
Date:   Mon, 26 Aug 2019 11:20:49 -0400
Message-ID: <20190826112049.GB27025@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: tag_8021q: Restore bridge VLANs
 when enabling vlan_filtering
In-Reply-To: <20190825184454.14678-3-olteanv@gmail.com>
References: <20190825184454.14678-1-olteanv@gmail.com>
 <20190825184454.14678-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sun, 25 Aug 2019 21:44:54 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> -	if (enabled)
> -		err = dsa_port_vid_add(upstream_dp, tx_vid, 0);
> -	else
> -		err = dsa_port_vid_del(upstream_dp, tx_vid);
> +	err = dsa_8021q_vid_apply(ds, upstream, tx_vid, 0, enabled);
>  	if (err) {
>  		dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
>  			tx_vid, upstream, err);
>  		return err;
>  	}
>  
> -	return 0;
> +	if (!enabled)
> +		err = dsa_8021q_restore_pvid(ds, port);
> +
> +	return err;
>  }

I did not dig that much into tag_8021q.c yet. From seeing this portion,
I'm just wondering if these two helpers couldn't be part of the same logic
as they both act upon the "enabled" condition?

Otherwise I have no complains about the series.


Thanks,

	Vivien
