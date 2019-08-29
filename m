Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D16A2A8C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfH2XKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:10:54 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35747 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbfH2XKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:10:54 -0400
Received: by mail-ed1-f68.google.com with SMTP id t50so5886982edd.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fKFCHIiJ49PeNFC8i1ZZA0wWwBiNJFUuoSJTtBwuYEM=;
        b=x1LJvSLNCCdabeAr0sKHbxfDG1+Wtnb/Ug1EA6MKo/qzN1Kx/LklvmX1Hx56Njzxvq
         PfY+Z4usi8l6NYygyPh67CB/Ts69C1UdfXECriMhZQekId/WFep5J0+0e/kJtN+JHkBO
         hck8IYxW/eN/47LifpAtyTqR0G8CuuC0ZOBMnC/Zm1iMsUg63fA+VLVS1yUTyoki3Y2L
         iPuupr4yicSE7dVu9x+AzxhtJuy33FjInvxK4hQt1YQiEbzF1IvndOSik6c1q2IMDnJV
         yJzTL8EhQrIUVZ+8D+c0/Snn90aGKQs1JO025uqOFy6xw5Yb+z8HPNJrnfv39Y8+LaCQ
         AQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fKFCHIiJ49PeNFC8i1ZZA0wWwBiNJFUuoSJTtBwuYEM=;
        b=lonVMv0tY0x/J7qtzSHTH2mnMbA6fy1eBUKnZ2rTXsbL/qj2lCEc7gR1UWyKkKRmJf
         84qLLzDS/Wo0MCC0Sv8r03mXhjxvoYrXpx+OIwcmvrp7jva7yiSNXY2JWfux7bAOrcws
         r+NOTR5sc6vP3E1z/vZeP1LAIf4zgSvlT4G7QvgOQavotHL8q/+OC9aLcKB/Ph58pZvM
         t0OsX0tvxyLqqFCgsdZ12VHo+GysEmSJMrzAUwwXW/HN345oMlB8xdIGQVIYdPkZEDxs
         dx0oL7Ni3MmXkbfRoXPIMxq6AQVtCqmjMkwrBuheKrgtRkx643WgnheHsjKIlBaEmxUn
         YssQ==
X-Gm-Message-State: APjAAAW/RW42h6+mC/UVTdk/dlifcC3xfNEd44X2Nu2O4Us+90ywlnOf
        Y91dy7aNq+G+XnQyyMLhYUZ/vg==
X-Google-Smtp-Source: APXvYqw/ecsyzLuu36xhPfaeNd7xt0gP7UmaW/2YWeDl8UzAVYzHGq50nXS4Ls1bqh6JTN30lTZZVQ==
X-Received: by 2002:a50:c38f:: with SMTP id h15mr12504027edf.256.1567120252350;
        Thu, 29 Aug 2019 16:10:52 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r27sm694868edc.17.2019.08.29.16.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 16:10:52 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:10:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 14/19] ionic: Add initial ethtool support
Message-ID: <20190829161029.0676d6f7@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-15-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-15-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:15 -0700, Shannon Nelson wrote:
> +static int ionic_get_module_eeprom(struct net_device *netdev,
> +				   struct ethtool_eeprom *ee,
> +				   u8 *data)
> +{
> +	struct ionic_lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	struct ionic_xcvr_status *xcvr;
> +	char tbuf[sizeof(xcvr->sprom)];
> +	int count = 10;
> +	u32 len;
> +
> +	/* The NIC keeps the module prom up-to-date in the DMA space
> +	 * so we can simply copy the module bytes into the data buffer.
> +	 */
> +	xcvr = &idev->port_info->status.xcvr;
> +	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
> +
> +	do {
> +		memcpy(data, xcvr->sprom, len);
> +		memcpy(tbuf, xcvr->sprom, len);
> +
> +		/* Let's make sure we got a consistent copy */
> +		if (!memcmp(data, tbuf, len))
> +			break;
> +
> +	} while (--count);

Should this return an error if the image was never consistent?

> +
> +	return 0;
> +}
