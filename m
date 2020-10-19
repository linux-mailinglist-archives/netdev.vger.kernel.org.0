Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1790292D16
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgJSRqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgJSRqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 13:46:21 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374E2C0613CE;
        Mon, 19 Oct 2020 10:46:21 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t20so156525edr.11;
        Mon, 19 Oct 2020 10:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tuz0iMfzR0PaX63JhJ+Y+JYTOZifsMKunZ+jRj1PPWc=;
        b=AiD2naRA+g265roabohxoxhWaPF+PUikrxTN9dxYfmlUhRi/5GaI+LYzDX7MeO+Yk/
         py8Bcn+taOtG+xHZCMiy0fir7t+JMxVRRAo/BkoePskQeOGeWs8qodBhY3DUukunOZ7L
         aOuEV/NbdRG7dGSJeGzEWgitlgBlCOfWUae9KZSSBIwkuZ1PW4+K6vZw6A3ObYFAyJt1
         zAsoQnbNz0Gd+tKTIujijvlKt+pklUIkXW4jYWpbubVYtBVMKkorrXWat/0kS54OjZS8
         Ns2i+0Itn7gZlrMBijyJWR1BepIMC1WvFQgAmqqMPUF7Mj1hzk8iTJtsfli5LfREUMTn
         36lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tuz0iMfzR0PaX63JhJ+Y+JYTOZifsMKunZ+jRj1PPWc=;
        b=rAwznMvhfi6vixnt7aB5G0IPP9OsjW9TFqirclCMI0uoMqGdBS0PKtzOK61JolFPNJ
         7+UNWKsdxPUWD3+zyY1uqQr4vjzxfDQHXDJv//FSUsEBS1zVd1pNydpm8pV/Y/ihG1oo
         5s2wMt9MSVw9C3OeeSrFyqS6SAQ1AgLLoYFnVPOpqm3HH+KlgZAEIx6+rsEdBEjKu1SF
         3W7Jd/1TxS0k8GD0Q3Oo4Cg2BANXzFkbCSC8Z/mgKz3OURqawdYv5DWwBTUVyzFmJRxD
         bk7h7t4ePkVgOST5xmy3sqoavBTteUAcvzFq36gSoQYJGVdYbdzbOfsKJtPhkhRBu32E
         PWWw==
X-Gm-Message-State: AOAM532g3Mu23hg3tWqztEixCTH+9iY9xV6bPeOhq7N+MLajN2LV+3ap
        w0fZsJiESorhsjO9f8l5wMw=
X-Google-Smtp-Source: ABdhPJxbj7UpK2ke725+NFP3GSc5o+CSr4ihINkGPA+1asBuoXo6CcBNMksFSAb/8+lNMryveZ/RhA==
X-Received: by 2002:a50:bf0d:: with SMTP id f13mr988697edk.48.1603129579912;
        Mon, 19 Oct 2020 10:46:19 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id j24sm896755ejf.21.2020.10.19.10.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 10:46:19 -0700 (PDT)
Date:   Mon, 19 Oct 2020 20:46:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 8/9] net: dsa: microchip: ksz9477: add Pulse
 Per Second (PPS) support
Message-ID: <20201019174617.uf7andznyij75mpd@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-9-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019172435.4416-9-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 07:24:34PM +0200, Christian Eggers wrote:
>  static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_request *req, int on)
>  {
> -	return -ENOTTY;
> +	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
> +	int ret;
> +
> +	switch (req->type) {
> +	case PTP_CLK_REQ_PPS:
> +		mutex_lock(&dev->ptp_mutex);
> +		ret = ksz9477_ptp_enable_pps(dev, on);
> +		mutex_unlock(&dev->ptp_mutex);
> +		return ret;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
>  }

Nope, this is not what you're looking for. Please implement
PTP_CLK_REQ_PEROUT.
