Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249B9496219
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 16:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381572AbiAUPbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 10:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351009AbiAUPbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 10:31:14 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D76C06173B;
        Fri, 21 Jan 2022 07:31:14 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c9so8705265plg.11;
        Fri, 21 Jan 2022 07:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/G7+clHUhhCtppUp4kO5KSxYFpGjyevCSgFS15NA9oE=;
        b=h99IrY+PCy1QkuJvA0z+a5K3v4CdSDQrUlu/sQLpIt44cVEnh5Kyz2OnvfHKZ3e2Zm
         VWAjZRujxylipTLZnwc9YJZGuXTVbuLTaGcOh/Fbvid0M+bAobfvwS4EZXMFxjHyqxHC
         0UtwkVPEic4S5lrhQ+wamJ7QIM2zoXhyAhjQQt29kbvhQlz8mA4UkScHgTvaBgeJKRFt
         k/NVZnoY1pi+NH7BJKSZgliuRxTAOUoVQCzmiiRpN15LJrr/yqUKfZFgE9JLm5JHo+o1
         Ji77JkVXwKhbQmi0orUpxOF3yYEr/6TfQS1vi7f/iPD5Simyn2SESQbBieyKr4q0VR8O
         bt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/G7+clHUhhCtppUp4kO5KSxYFpGjyevCSgFS15NA9oE=;
        b=vdhKpYUjSXDQsJ5rxRbKO0/vaLk2Ew3cUOG4hq5YpUvs7mmx91IG+syCVUAzEfZvQO
         LlnG4/zSAGNSkT4ljnYrY1UdDloakSG7Mcmk2ycRD4SO9/gjwS/+H+RQs9nBbvUGNyyb
         anZZ/eVcetjW/gfLtEBRxPm8pUvEGGIzMpKS2X+3qkycn/+GoGNPo1TsB/siuuDtJk6l
         mRBOvQqOWWy2SrVpmM44A+PJXe7LJJ+t6+duyvRkQeY40l8y0IiZqHNKlkb+cnemN0vN
         j0f7hSnVw/FFBcZznxlbQTU/rXOKlPI89Y76fhrw4ImeYrOTcUND6S8So+wfUNrRKpbH
         Xrzg==
X-Gm-Message-State: AOAM532BjloW2FmvBi3rOXGnBBUOU0IBQFTSH2/zO/hzTq0r+v6B0/K7
        j5jkWxYKl79R0nFF/GF7IGY=
X-Google-Smtp-Source: ABdhPJy1b12e/b7lUDd+WZiWhtJK/DC4WWf77+KnVmHa8sVQpEjHAfoHzYdbW/DFHNrTkysg8yB0Qw==
X-Received: by 2002:a17:902:b944:b0:14a:b045:4d00 with SMTP id h4-20020a170902b94400b0014ab0454d00mr4233223pls.52.1642779073877;
        Fri, 21 Jan 2022 07:31:13 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s6sm6092637pjg.22.2022.01.21.07.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 07:31:13 -0800 (PST)
Date:   Fri, 21 Jan 2022 07:31:11 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220121153111.GB15600@hoboy.vegasvil.org>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
 <878rv9nybx.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rv9nybx.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 12:05:22PM +0100, Kurt Kanzenbach wrote:
> On Thu Jan 20 2022, Vladimir Oltean wrote:
> > Hi Richard,
> >
> > On Mon, Jan 03, 2022 at 03:25:54PM -0800, Richard Cochran wrote:
> >> Make the sysfs knob writable, and add checks in the ioctl and time
> >> stamping paths to respect the currently selected time stamping layer.
> >> 
> >> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> >> ---
> >
> > Could we think of a more flexible solution? Your proposal would not
> > allow a packet to have multiple hwtstamps, and maybe that would be
> > interesting for some use cases (hardware testing, mostly).
> 
> One use case i can think of for having multiple hwtimestamps per packet
> is crosstimestamping. Some devices such as hellcreek have multiple PHCs
> and allow generation of such crosstimestamps.

That may well be nice to have, but that is not in scope for this series.

Thanks,
Richard
