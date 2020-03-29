Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1D5196E13
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgC2PIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 11:08:36 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35491 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgC2PIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 11:08:36 -0400
Received: by mail-pj1-f67.google.com with SMTP id g9so6190543pjp.0
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 08:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5cQuOrqIr84aAT4ooE/xX1JT79FfWfOmlCr6GbSPzG0=;
        b=YhWHHl0CyU1cuOjOCfpdhPS231QHRHyagCyiWXtLm6QhNPOAi7HsdrSsR+l2L6leyR
         YS/r1ZnFrmEtNrdybPQpDcF1r+pdZUaISLd9iVT5C1Gh0tTa2tm6Yst4nD/JdMemFa6U
         1fvxlW4jzwvnW7qf8NRstRPohNsBOOcIxKp1uTWdwtpa0gGQ+Dbc7BDpQ44EyUkM+HKh
         +GkWc5erjXkv+7JQNM2r+7nTCuyTFXbN49A+bdUxsRCNc2eAiZfL+oLevayvBKwb7SBO
         xoIClH+2hKiiG1XYHa6tCAIyqSckMxbsqRUul/JqwZtYKsihebNPpXXzfzfvFf525qN5
         tAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5cQuOrqIr84aAT4ooE/xX1JT79FfWfOmlCr6GbSPzG0=;
        b=OquwWbxz/OVRd16Kvi+pq/nMJCLPVXXKNLaUd4K1YmLrsDHxXhvSrJSQVMTIbaY/R7
         26I2IVGPFx2tNjWDafpCK4Xfr45YflPbMmmFAsg/wmKYZWPKR88HHB0KG4ctAn3r78u6
         W5LP0Dg4AaONV8zkYj7itvs8aKnTIvNzl12ONCSJLGaJgmqwprWm7VxWbnJ+QLsHH77/
         vN4jJlRimBbWgUCHd1Qj3fkTT8q/edX4Z4NypfkAUtVs4pAq/CvrSf+cSLM3Sxu7A03l
         Oo1sO5Q9Mkz6OlUn4wGJfWRgUa9vMUchUduGwxrzABsfvmQWqTbKCQusSLCRGIp1iVd7
         Q72A==
X-Gm-Message-State: ANhLgQ3Cm4F8QwUeDLrdGoVzg9/fIiCnznXK5XZhjI/mABtv65SFEN2z
        YRUBk0vEjnzzNwcAwrOet9M=
X-Google-Smtp-Source: ADFU+vtY2pEi7w1i1XcS0yY61GqEAMYN6B4L/cgxeDl8IoF1B8Y9jgF6Qkce/0qj5uyT0nCoJHhyGg==
X-Received: by 2002:a17:902:14b:: with SMTP id 69mr8661201plb.121.1585494513827;
        Sun, 29 Mar 2020 08:08:33 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v123sm8058145pfv.41.2020.03.29.08.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 08:08:33 -0700 (PDT)
Date:   Sun, 29 Mar 2020 08:08:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 1/1] ptp: Avoid deadlocks in the programmable
 pin code.
Message-ID: <20200329150831.GB1825@localhost>
References: <2f3ba828505cb3e8f9dc8a7b6c5a58a51a80cd90.1585445576.git.richardcochran@gmail.com>
 <CA+h21hoXhGLE9vsTAqgv8+1UCa_yXsJ5OTGKTR5dOAj_RNFF1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoXhGLE9vsTAqgv8+1UCa_yXsJ5OTGKTR5dOAj_RNFF1w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 03:56:18PM +0300, Vladimir Oltean wrote:
> > @@ -175,7 +175,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
> >                 }
> >                 req.type = PTP_CLK_REQ_EXTTS;
> >                 enable = req.extts.flags & PTP_ENABLE_FEATURE ? 1 : 0;
> > +               if (mutex_lock_interruptible(&ptp->pincfg_mux))
> > +                       return -ERESTARTSYS;
> 
> Is there any reason why you're not just propagating the return value
> of mutex_lock_interruptible?

Yes, this return code lets the system call be able to be restarted
after interruption by a signal.

Thanks,
Richard
