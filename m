Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4389D45F251
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354881AbhKZQpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355061AbhKZQnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 11:43:53 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D771FC06173E;
        Fri, 26 Nov 2021 08:31:11 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so7041482plf.3;
        Fri, 26 Nov 2021 08:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o9MceRLJD/LK0oUJD3Z/j/giiPcX33lKKAl7TKvOZtM=;
        b=nqXrI/MQ7o/MTStk/Gc1h+ZN3AuCkLOXk/QnwFq0K5WDyJ/hQYeYz6yJ1pKbbyXFKI
         3FYWZ31xRTwZX8CBJ8GKBtm3UQ4HAwR2NHtpb47cmz8GWYa2RB8k+Oa541q1VPtEetPE
         93LACuAeyQfg0k6eJqV5m2wMRiyCCRXH1uAa+HhSXBTC+1QyRBlriPbeTVO2YRDuOB/r
         vmGdO9/Ptv30xLJUHekKjsEl8VHKgBko/U196z0PPtAllAUoM5PTgOa0vSGaifjeULAN
         z/++9L3gutw7uW72U2XLYMrmIpLWZNHbFXGpWLv2B3WqkfANRUPmrHPYeCJToSDBHvxg
         SfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o9MceRLJD/LK0oUJD3Z/j/giiPcX33lKKAl7TKvOZtM=;
        b=VTQAIxAGeAV0a1a+68iSKYGBA6arSmlsTLoBKW1i/6DIQ0bZEYn9EYmM4Ic1zC+AZ3
         XVCjZ1gD/tmOBGyF1MrYnArf091RcxpC5SJK/I+ieNrhsitcuikLOrdDqAa/gmCiMX2V
         nKSlxMc9PghZO1VDDdgT/1uy4L0BMyJ8Lqr0280kV37UwlnH3XTh8G4VxJD4nbxUQhhj
         YfLgfwBPs0F/yrDGfHqokjSNiqFDSD9KE/MKHSo7r2Xpnx8hoTq10PSELJj2Q/fLkYC+
         XAzfJcJ+13TKsm8hg9peY1/iil3/4nkl0Xw0rpBCWzjZG4RTsBQTbuU79gwOEv2oopeE
         GqCA==
X-Gm-Message-State: AOAM532lo41YJWIs8drgXnpQTk1pczCQIDMU/bHNsE1HhhAleXD8SiVU
        9pGr/ZSMYNQPVMrBUqP/8X4=
X-Google-Smtp-Source: ABdhPJwjR5RuZ3/Vu9y2ZKHm6WYrPDr9VGE5IT+grhc1tL1uVjQC5xeCQ/9tzm3kufLOJSjLQkHOlg==
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr16957714pjb.10.1637944271442;
        Fri, 26 Nov 2021 08:31:11 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w142sm7488193pfc.115.2021.11.26.08.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 08:31:10 -0800 (PST)
Date:   Fri, 26 Nov 2021 08:31:08 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
Message-ID: <20211126163108.GA27081@hoboy.vegasvil.org>
References: <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org>
 <20211107142703.tid4l4onr6y2gxic@skbuf>
 <20211108144824.GD7170@hoboy.vegasvil.org>
 <20211125170518.socgptqrhrds2vl3@skbuf>
 <87r1b3nw93.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1b3nw93.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 09:42:32AM +0100, Kurt Kanzenbach wrote:
> On Thu Nov 25 2021, Vladimir Oltean wrote:
> > Richard, when the request is PTP_V2_EVENT and the response is
> > PTP_V2_L2_EVENT, is that an upgrade or a downgrade?
> 
> It is a downgrade, isn't it?

Yes.  "Any kind of PTP Event" is a superset of "Any Layer-2 Event".

When userland asks for "any kind", then it wants to run PTP over IPv4,
IPv6, or Layer2, maybe even more than one at the same time.  If the
driver changes that to Layer2 only, then the PTP possibilities have
been downgraded.

Thanks,
Richard
