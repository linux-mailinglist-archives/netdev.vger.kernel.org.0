Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A194A9ED5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377492AbiBDSSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbiBDSSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:18:48 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606CBC06173D
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:18:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 77so2846874pgc.0
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VlMC9FJl3TdvYdT39rVO3OLo3KjpapwEJoY/bJ8He8g=;
        b=r2oXo+ndzrNvdwAzkfDia+zTKZzyVUvY8VLaoqp74eeI4pkelv8raKUud3khJUv4t+
         /dJX5KAsYkfN636cNnMPvz2V3N4DTheDui/Yjicbf9doTFTmGRJ2Wge65e5pAxfjc6md
         BKc5UbNoSe9pqhxLXSOWhy2UNoohlov+fzPTsLBC7nfCmJkyzqw8xT6mJRce4UsB2Iqj
         DyLy7JZVVYTLN5k5y6X/TTuS68j0tlo0O/FzkjhR96a2z4jEY/CwU/aFdsqI5sTDR/6O
         DNc+PsuSprve1BP7Q6Wn7ZOCZoINJ4sZou7wk7zmImpzpGOKTXflfkQmkvA9wzDCbYO5
         8Diw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VlMC9FJl3TdvYdT39rVO3OLo3KjpapwEJoY/bJ8He8g=;
        b=TpQeuJPxwBezzVN+tKOcx1NLZWVst6/+zsyJDF37WyNtZPncwHUHC5lSY+QCeIgUG/
         Xungcej4RN24mxwbMD5dRop5Ex0Gy6YZBIeVNNNTblhN+JoAdlT9AM0Je1sS8CKaqK4A
         T8eu0USYQuyrPEWyO+q/cFP35qehW1/unJaMDEODhdl5ho0xvclrN2F/1pAQGcdZ1qEU
         yFvrAzip7NRqs8PwFakNITxBTO95w8oyoNKZam062mBlEf92KFDdRiL+au0amfw9gmYw
         W+TkQOgeMX9I4LWzIR9FIQcxkHJHXOOSc5lWAgbn49+DkTseiZImZRBztU0wq/Kr8Q+0
         C6LQ==
X-Gm-Message-State: AOAM533PSoh3WuOUX9x43lwvbZB3w9j3/Gf5WhFxbIBzqRmWiDMDg0BH
        TDTJGAyZZ7wEgaymMNSydKPuqQ==
X-Google-Smtp-Source: ABdhPJzvOsH2Yd9ruUf05gmgP03fujqpLKTy2t1eKXYihRz4wLhQy6ZFGhubEht1a0xnhvYx63gdeg==
X-Received: by 2002:a63:2b11:: with SMTP id r17mr198610pgr.83.1643998727911;
        Fri, 04 Feb 2022 10:18:47 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id y27sm2218795pga.22.2022.02.04.10.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:18:47 -0800 (PST)
Date:   Fri, 4 Feb 2022 10:18:44 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com
Subject: Re: [PATCH iproute2-next v2 1/2] ip: GTP support in ip link
Message-ID: <20220204101844.1b7725ed@hermes.local>
In-Reply-To: <20220204165821.12104-2-wojciech.drewek@intel.com>
References: <20220204165821.12104-1-wojciech.drewek@intel.com>
        <20220204165821.12104-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Feb 2022 17:58:20 +0100
Wojciech Drewek <wojciech.drewek@intel.com> wrote:

> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -57,7 +57,7 @@ void iplink_types_usage(void)
>  		"          macsec | macvlan | macvtap |\n"
>  		"          netdevsim | nlmon | rmnet | sit | team | team_slave |\n"
>  		"          vcan | veth | vlan | vrf | vti | vxcan | vxlan | wwan |\n"
> -		"          xfrm }\n");
> +		"          xfrm | gtp }\n");
>  }
>  

options are in alpha order, please insert in the correct place.
