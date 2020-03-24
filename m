Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A09C191703
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgCXQyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:54:20 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38267 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbgCXQyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 12:54:20 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so1715412pje.3;
        Tue, 24 Mar 2020 09:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rPZBl+QbGFAFlz2fLf98Z5n8K3I+qd2EtNADkBNRMLw=;
        b=UWo5YyX/rz4iT22TlUFvMncYW1HL4F8dFNN2Pn6WdGpvsGKs7lRciWnF92mV3MrHXt
         g9G8ed0fy9z8RVLHDli/tFxC3mdwGVVW2GsLGtBC5d37nzjvaMo+9ZOdpDp96qeNtqrs
         CsVV5RX+XdgMbCB2HOYg5pK+q2Nyab6kDG8jbCUdlceMncwfXrCuJDlTFiiPfa2PBEkt
         eKWxH0c0T5nOS+/UvxLM5qEVXPEbvWXIUFX3aVPP1L/BO7ZYnwewjGGZxW79s7XV/y1z
         Hif8WRbKqmEisX7as5ZgPCdUdDXUY9bUHS9/9w+BegZ6VvoWfR0NiMIeh/K0Tmyxg5y5
         UCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rPZBl+QbGFAFlz2fLf98Z5n8K3I+qd2EtNADkBNRMLw=;
        b=q0dOQgLdBal38HyppEhhlO8qoTULaTS1JwtPGaxxoDRg/018UYRW02WvQVpAIWM/Cc
         Nprz+JrFhTFhhsS7WUAT3jQAbvI7CKT/4MbfsjUiChNvFao7NGSX7h7oBFgjgvXnVK+N
         XYkFiQv+YNqadLu5iL0jylGCovjso+7DjX1EVRT27fSvgUYaV7FqP2xcb4kNZL6y7QHx
         Df6gYcYHAt9CBhOJFGU23GdS2l3vpkWOadZdrM0Ap7u5XpgAQGEHgED7IFDKrI5AcYXZ
         CKV14kEeTmdzgYBzqwYwXtRYvcLYJVScmAx5kMP6fsNkZHuOEQZ7RB1e+m/SQRUbMAAF
         yMmA==
X-Gm-Message-State: ANhLgQ2rfRzXXMbNf8ZjP4L6CNooEJKQMWT4Jwm+Um4fwHcepZu5muqS
        dk6H8/IwLvkT45cUrIjTbaU=
X-Google-Smtp-Source: ADFU+vvVT3/hBoL79iWLOhKZfIHg0UIA7zdlV4T9CvIkuEaERJ0ookWRmQeJVoKdWNDIJKR+yO5Owg==
X-Received: by 2002:a17:90a:bd0c:: with SMTP id y12mr6554330pjr.82.1585068857320;
        Tue, 24 Mar 2020 09:54:17 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n30sm8678428pgc.36.2020.03.24.09.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 09:54:16 -0700 (PDT)
Date:   Tue, 24 Mar 2020 09:54:14 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 08/11] net: ethernet: ti: cpts: move rx
 timestamp processing to ptp worker only
Message-ID: <20200324165414.GA30483@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-9-grygorii.strashko@ti.com>
 <20200324134343.GD18149@localhost>
 <13dd9d58-7417-2f39-aa7d-dceae946482c@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13dd9d58-7417-2f39-aa7d-dceae946482c@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 05:34:34PM +0200, Grygorii Strashko wrote:
> I tested both ways and kept this version as i'v not seen any degradation,
> but, of course, i'll redo the test (or may be you can advise what test to run).

Measure the time delay from when the frame arrives in the stack until
that frame+RxTimestamp arrives in the application.  I expect the round
about way via kthread takes longer. 
 
> My thoughts were - network stack might not immediately deliver packet to the application

The network stack always delivers the packet, but you artificially
delay that delivery by calling netif_receive_skb() later on from
cpts_match_rx_ts().

> and PTP worker can be tuned (pri and smp_affinity),

That won't avoid the net softirq.

> resulted code will be more structured,

I am afraid people will copy this pattern in new drivers.  It really
does not make much sense.

Thanks,
Richard
