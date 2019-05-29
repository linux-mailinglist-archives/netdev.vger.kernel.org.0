Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AE62E808
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfE2WSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:18:49 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:39546 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfE2WSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:18:49 -0400
Received: by mail-qt1-f176.google.com with SMTP id i34so4630105qta.6
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 15:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Wc/2ZTn3bTmajEUQNWRtv6uulelmq6BsGRobTvdNAko=;
        b=SksXRdsB8O7xv2f88XfT5zyPQ0rks09KzTEHjOnbw/ryUGuywHy5C96zm7m55V4q1S
         6pOsPtw7TOD4SVxUkZVF6hQVs99zRYAPUXoTYJjTjUlXY9L9EvD9Cu3uYN3qX+rlsoQx
         WWgrHNM4W/Dqq8MGzbR7W8JMqj5bR8alEOxERhiCFvJGCcSL4H4Jc5HW66kKpESk8wmh
         6KVbUPIhHzmYlipsNDxxyrG8BX5og+rz5KIOWdRFvXWw618m0zTP4qATl5bw61Z6KRvf
         ey9UjpJwQOjMA7VP5vq5C7zNgR67G428HtZ2cSushTk7wJyPG4qSakQr9c1C8A6E0ppa
         mVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Wc/2ZTn3bTmajEUQNWRtv6uulelmq6BsGRobTvdNAko=;
        b=AqULn0T1j7jkkROApuSScNgrz4/iYnTRJ+TictlUPi0v1klDigttMVNt7Nq6IItcct
         6jP13v3oUBbNj05rjimz/FBisG4DCEZs6LpZrnzApiEAQ1oRJlOQSK9wuhgHLrzzaCXJ
         BoaQukzVrBYfHLp8qmlBIX6FiIWo4VEK+0QvsZ1bCzoP80V8U7ZBmfUdaYfEZxLOIniR
         b+myhtQjuCkMXut1niCqrfXfsbDSFuaoLR7XhjDu5of1q7N/mJqjTCfY8KV5ECDh34vl
         ++DTVIfa8VjOpMZ2j4yV0IY34yK8hKCya/dcAJN/n7b2rWDszKKstAojvwhyYvEFOoeE
         MS7A==
X-Gm-Message-State: APjAAAXAjlr8pc92IWVLERGfQiz7dki7STouQSg+BkZUCi5W8R2QWzLI
        0OtbJWDB7gLc2wmGsGlKxUEdAw==
X-Google-Smtp-Source: APXvYqyrWklChrPKL+Kd4yWTw1qaxtz9fRC45MEyUccJVW59QWt96Dd3OtsUvwdgNreRsyBaN2yHeg==
X-Received: by 2002:aed:39e5:: with SMTP id m92mr394942qte.106.1559168328672;
        Wed, 29 May 2019 15:18:48 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s28sm400345qtc.81.2019.05.29.15.18.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 15:18:48 -0700 (PDT)
Date:   Wed, 29 May 2019 15:18:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Paul Burton" <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-mips@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net: mscc: ocelot: Hardware ofload for
 tc flower filter
Message-ID: <20190529151802.19aa82a2@cakuba.netronome.com>
In-Reply-To: <1559125580-6375-3-git-send-email-horatiu.vultur@microchip.com>
References: <1559125580-6375-1-git-send-email-horatiu.vultur@microchip.com>
 <1559125580-6375-3-git-send-email-horatiu.vultur@microchip.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 12:26:20 +0200, Horatiu Vultur wrote:
> +static int ocelot_flower_replace(struct tc_cls_flower_offload *f,
> +				 struct ocelot_port_block *port_block)
> +{
> +	struct ocelot_ace_rule *rule;
> +	int ret;
> +
> +	if (port_block->port->tc.block_shared)
> +		return -EOPNOTSUPP;

FWIW since you only support TRAP and DROP actions here (AFAICT) you
should actually be okay with shared blocks.  The problems with shared
blocks start when the action is stateful (like act_police), because we
can't share that state between devices.  But for most actions which just
maintain statistics, it's fine to allow shared blocks.  HTH
