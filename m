Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1756F289036
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbgJIRoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732060AbgJIRoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:44:55 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6538C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 10:44:53 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id a16so2308150vke.3
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 10:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fJ14Dg4VkmXZoFhbERfcdHivYMl1FC5I45TKaPl6f3I=;
        b=HNpZIEJFAoMPpdsPI1Lx0toPZrOinPZS2LHIhLrvj++3dvjX2C0D/Ck03UbRg4M2z2
         mggHxyw5HOBQwzMtyrr1S1W2Ez5ko0x5ByuRyUwsxNUmqRBEWQfH3EGBVoNMaWhdPl5H
         ntJ7FISBy8rk/VAsdJyk2UWIOgQh8ZYl0aY3yK5VQ1WlrmGTTk92nMT8QWeBADMK+KeQ
         /44hWvH++ZOjJs/lmlS5qO9mlPRF+ouZkIhm+wpHRPOo9mkMiifnv1bfzmDOjKJuGGy0
         suNIXH2y1/UxZxBY7Gi5gxM9IgE7t93fgWI3Vu9vbnZ4rCxTFVtV1UYh0T65cuBOp4u8
         pwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fJ14Dg4VkmXZoFhbERfcdHivYMl1FC5I45TKaPl6f3I=;
        b=C6lyRpAb9nLHhE4Aoz9CCFmRPJIFrq7TzdzbJS02xgsh57SXb1hG6DssG7OaqodyaO
         j4eDzDSbbu+y4Rt6cImtG/UONJ+oignClHw/of7Mk08jfQzx1OCnfsyQ7wsBZNRDgQYs
         49P2BpnKNe2tGif/Db3/7SfWO5yViXErGauZgFa/gy0bigCayv/4lcoTXdOs0tNovOGs
         EuFH31VGXT0dlI9kuOLb6CFO+bywifIQhb6Mn32Um5WUpJXwDfgr5FPHRK6tBlzAuZHW
         Ydx7FJrsOQLZGTUkL9850JJ+LM5EPHriEOa0Krw4bA3xnqaadopCxbc9Gc7G5PMSAQRk
         1DVg==
X-Gm-Message-State: AOAM533oKIKdEBgTp/EadxbzwZuS9zdEt+UT2ihJuxtffXd/H4I9mGsa
        5JQQXMUoZp+SHO1Bcy7k/bSNP+KGg7g=
X-Google-Smtp-Source: ABdhPJytI4kofwXJNecTsJd5jcVUbvsHLnD4ZHaBuZo2h8gmJIqxP0Hz2KGsVhk56XGK7ujXO5G+dg==
X-Received: by 2002:a1f:8c87:: with SMTP id o129mr8477006vkd.2.1602265491981;
        Fri, 09 Oct 2020 10:44:51 -0700 (PDT)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com. [209.85.221.173])
        by smtp.gmail.com with ESMTPSA id r17sm1196471vsf.25.2020.10.09.10.44.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 10:44:51 -0700 (PDT)
Received: by mail-vk1-f173.google.com with SMTP id l23so1250935vkm.1
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 10:44:50 -0700 (PDT)
X-Received: by 2002:a1f:ae85:: with SMTP id x127mr5175020vke.8.1602265489907;
 Fri, 09 Oct 2020 10:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com> <20201007231050.1438704-4-anthony.l.nguyen@intel.com>
In-Reply-To: <20201007231050.1438704-4-anthony.l.nguyen@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 13:44:13 -0400
X-Gmail-Original-Message-ID: <CA+FuTSev=N4jDD3jT+JcB1dREkLK12jSi_R6wXOeRsx_1M_dmg@mail.gmail.com>
Message-ID: <CA+FuTSev=N4jDD3jT+JcB1dREkLK12jSi_R6wXOeRsx_1M_dmg@mail.gmail.com>
Subject: Re: [net-next 3/3] e1000: remove unused and incorrect code
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 7:11 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
> The e1000_clear_vfta function was triggering a warning in kbuild-bot
> testing. It's actually a bug but has no functional impact.
>
> drivers/net/ethernet/intel/e1000/e1000_hw.c:4415:58: warning: Same expression in both branches of ternary operator. [duplicateExpressionTernary]
>
> Fix this warning by removing the offending code and simplifying
> the routine to do exactly what it did before, no functional
> change.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Acked-by: Willem de Bruijn <willemb@google.com>

(for netdrv)
