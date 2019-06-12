Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393034310A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388755AbfFLUkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:40:06 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33735 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388447AbfFLUkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:40:06 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so11300338qkc.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 13:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=8XJTaq0AJcPrpuI6FU98bkxBA4XHPGjpp4wmEqoyFkA=;
        b=jIHF7/YMsk20Ez4VkYuRtWawaKxAOQ1p18wEqzgP/SXLtD24vg0Rpdrf2i3rTbQpFR
         zzZNOHseqMU2oe/uYP7dK3X+wNBmuhTGj1mc2ChdW/hqX7br0BntJ7FueMhJ6gBQB/15
         dOe5lERTq2XaGL4IEemAYrfv7dSviFlvW8EHU8LOkur0kSB9+Gj899hN4bvSHRcEfZ39
         r1wKCMBCHfIvZXc3k+nHOXKXVtPkntARgevERsWjM5PLQaS3KXft5YIqBe7FZZjXqXUj
         WKRQ3Q8e7fiY0P5+oP8918NovYrl6dM5xnft8UKKRK+BFIahw8j78OGZqeZJuVOY3snI
         LHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=8XJTaq0AJcPrpuI6FU98bkxBA4XHPGjpp4wmEqoyFkA=;
        b=WYJctm2R8C4zuHDGP9lAr2hbw7qhZrYrb7JNt0iw4kpABIZyr7YQW2LwaFD6eCr4xK
         fNiXxUwQvW108GLjbgCmtjd4L5SkmvZKO0y3GUUgccHHAIIDKX1VszazaQjoxGuW8JNy
         xT9YrRrGd2L3RfN0TxxRtZlA2Fl8OrAyQF1dj4DFNa9NYTLZ434wXT/yWEJrg6c2G+wN
         2x14SpjhWdp+f2/ENU4DkzM6QF9IL1PkH3D4whUg8WGCEWVlUFZRvqtJiAqH1PDuJv70
         fro3bcykt29mfQRkCUxcFj+LfWAPt6/G6OaKdr0BcCSnYLSOZl+EdTDwKaGO2FJpQyAY
         vOkg==
X-Gm-Message-State: APjAAAVuAaoumvczq4Ah8UDRlc7sYDUkQwEPdnBs3RdPEoHndAQSTfSV
        TVNICwA3SY0csAZDCgN5G1VFKuizRuk=
X-Google-Smtp-Source: APXvYqzGw3lCEWgxniIcyTtsZHZpOOH9vTwY3NNkao2BMJlo6P/3NIPuFLosoDfpb2blArjO0BcBIg==
X-Received: by 2002:ae9:df07:: with SMTP id t7mr66783319qkf.193.1560372004947;
        Wed, 12 Jun 2019 13:40:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s35sm505751qts.10.2019.06.12.13.40.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 13:40:04 -0700 (PDT)
Date:   Wed, 12 Jun 2019 16:40:03 -0400
Message-ID: <20190612164003.GB7893@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: Re: [PATCH net] net: dsa: microchip: Don't try to read stats for
 unused ports
In-Reply-To: <1560371612-31848-1-git-send-email-hancock@sedsystems.ca>
References: <1560371612-31848-1-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 14:33:32 -0600, Robert Hancock <hancock@sedsystems.ca> wrote:
> If some of the switch ports were not listed in the device tree, due to
> being unused, the ksz_mib_read_work function ended up accessing a NULL
> dp->slave pointer and causing an oops. Skip checking statistics for any
> unused ports.
> 
> Fixes: 7c6ff470aa867f53 ("net: dsa: microchip: add MIB counter reading
> support")
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
