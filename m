Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C5356FE7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353373AbhDGPNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244915AbhDGPNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:13:48 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C54C061756;
        Wed,  7 Apr 2021 08:13:38 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s11so13121283pfm.1;
        Wed, 07 Apr 2021 08:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8gSjC0WXXO0hyXex8pLBlZgJJ3C7tLcObU3Ri/R7BbE=;
        b=FWLkxi8L5ScjBYku9DHP82+AoKKDTgiXDj5CeSLW9WZ7l02g+wa9AaAR0DefJ72Tlk
         tTgx2RnGgHCH7V6Y7E5SnVAdcg2Qo09HuigOiyIL+eJDYdYOn75ia5NROQ4/PPjrB6Im
         SdotBRwae7sMhDq5ujnlQAXuBRoAhlmZJfv47BFwvls8Zwflvh4WaRpWqiabpGK3Iwq/
         Aq6IRIvcPC5/A8UNEc3BFAA9FhRnBYjrM5Y2gpSiYEbqE2XxUh3A3jv+Z6g/emsSH9vh
         +YmcErc3p+N1BR5pfSmgJKXOQbgiltEG/c2v/avbdp2VW3i4xivIhvc6kJ0aw4LTSH5w
         xqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8gSjC0WXXO0hyXex8pLBlZgJJ3C7tLcObU3Ri/R7BbE=;
        b=TvjupKdpyzyTloBdlMXo7W42YYn7MRrB/vvT4MwqvZxsB9zeQtbLgGZhmx0wyoZuaX
         It/lVkX72vtSuz+ltf4SKbzXb+mxWSHmxQ+X+TNTAl4M0ll+joMKPRdcHORl1uCJROqg
         bkOhpNlMxjHm76vqrJToRsJoOT4l/yemmAo2Im1N5ZjepC+mZIkIDdBKj8ZpXlWLJS8G
         eSWCTeCMjamfVaYVUczZLZCZAkXp+0eqHRkSmberUJeYovV95LoBxFxrUzta5hP2cV/n
         rjtBrQ5VYScJM1A1oidOikw3jJoJIP8+7P0ZHqO+7TqSCQITm17jUoGJek9Nx3Jhmtur
         puvQ==
X-Gm-Message-State: AOAM5320Red8FgT3rBVdbhJM3fzVbITu8sUe57jbB3pMc3WOFZPb8Q2C
        FIT71rbkKR1kXf/DzgEFRtc=
X-Google-Smtp-Source: ABdhPJy5ZPRmaIO7nEBFmAuQOQ0Y8GY3inREsOnbc9BdLsN540bPamng3WsIf87RWRfNOC3QrsUeFA==
X-Received: by 2002:a05:6a00:2301:b029:204:9bb6:de72 with SMTP id h1-20020a056a002301b02902049bb6de72mr3386966pfh.62.1617808417948;
        Wed, 07 Apr 2021 08:13:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g5sm23385518pfb.77.2021.04.07.08.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 08:13:37 -0700 (PDT)
Date:   Wed, 7 Apr 2021 08:13:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        john.stultz@linaro.org, tglx@linutronix.de, seanjc@google.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, steven.price@arm.com,
        lorenzo.pieralisi@arm.com, sudeep.holla@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        kernel-team@android.com
Subject: Re: [PATCH v19 3/7] ptp: Reorganize ptp_kvm.c to make it
 arch-independent
Message-ID: <20210407151334.GB7379@hoboy.vegasvil.org>
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-4-maz@kernel.org>
 <87eefmpho3.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eefmpho3.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 10:28:44AM +0100, Marc Zyngier wrote:
> On Tue, 30 Mar 2021 15:54:26 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > From: Jianyong Wu <jianyong.wu@arm.com>
> > 
> > Currently, the ptp_kvm module contains a lot of x86-specific code.
> > Let's move this code into a new arch-specific file in the same directory,
> > and rename the arch-independent file to ptp_kvm_common.c.
> > 
> > Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/20201209060932.212364-4-jianyong.wu@arm.com
> 
> Richard, Paolo,
> 
> Can I get an Ack on this and patch #7? We're getting pretty close to
> the next merge window, and this series has been going on for a couple
> of years now...

For both patches:

Acked-by: Richard Cochran <richardcochran@gmail.com>
