Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8D64464AF
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhKEOQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhKEOQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 10:16:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472A1C061714;
        Fri,  5 Nov 2021 07:13:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s5so9004399pfg.2;
        Fri, 05 Nov 2021 07:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BiGPCYKYphS9RJL3ExNnhuFCSkEwiUXIckp0DQsVl8Y=;
        b=A3J3Kn/TpF2ay0J6Jkh1O4otZZtkEyDKNa5SrthAMqhScV7v6P3SiOWOVSfKD4K/F8
         mVUiXf3WgotAFbFJ0fqzqtzmeGR+EEqrn4P4+GUjGeOZqVDijTpTgXiQ78K+Z6wziHMj
         EsLVz1iD3f72mqIPFSMg6sqK67jM0hyAsoD1yXrQZGOLL4MIODixG7cWGow4TfyH2qCa
         I0JlOtB/6M+iFQ0b5HF7974sNCxW84bzXaqCIGErhvpSV85N6s4c5gkz1xi/kCCeDNq/
         eN+UmbQuoAnnLFD6SS80QtLSXGTCHMV9L/KBrq7CtOHrvv2U5LyTnRi+G8WQR3kI4Vdm
         NOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BiGPCYKYphS9RJL3ExNnhuFCSkEwiUXIckp0DQsVl8Y=;
        b=yMSI9EhFZCOjIcErZi/R3ZpSz+5uR4ZXd30FTFXsIalFoMa+8JaMXZydeugYFT5QaR
         iEnpDxqs3ZgD0gBAIMEdrAb2mxr1Mo2HJu3r0By8o7O1zmWEHlMZllI6Sxwi87M0veGB
         s814HeRRJaoTuKJXvQLn3dRaGm5+CnlKKRMCDz/9H6TIscv06A+/3FZfK8AQSEk1UooO
         8064jlLI1ddhb9OBgAniDogPi+BZ8lfpTsf3CSZIzHdHYa2g9QLG/MNs4kOxQVv8DfPH
         o+JEJxq6AtTwOXHqyn2OHxSxGKs7S3FOaCxaWC6YnzL60DwdJFyagu65F3e2PxRiFUq8
         bNFA==
X-Gm-Message-State: AOAM532b23hM8KtH0Gxa2H8iBU8jwHTQ5JsMRQ2GCYYMIRaufNc/+zfp
        oYZlSJs0R0z42FgtHZjsAS4=
X-Google-Smtp-Source: ABdhPJyU8Wm0XUOtdWaul81QvM1b4vVUQbDH+l7nIH94FsmQrv/eKdPKibO821zMznJ6oIQ4fW7MUQ==
X-Received: by 2002:a05:6a00:1354:b0:494:5227:42c7 with SMTP id k20-20020a056a00135400b00494522742c7mr13334363pfu.53.1636121601839;
        Fri, 05 Nov 2021 07:13:21 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d20sm8172320pfl.173.2021.11.05.07.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 07:13:21 -0700 (PDT)
Date:   Fri, 5 Nov 2021 07:13:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211105141319.GA16456@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 02:38:01PM +0100, Martin Kaistra wrote:
> Ok, then I will remove HWTSTAMP_FILTER_PTP_V2_(EVENT|SYNC|DELAY_REQ) from
> this list, what about HWTSTAMP_FILTER_ALL?

AKK means time stamp every received frame, so your driver should
return an error in this case as well.

Thanks,
Richard
 
