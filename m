Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D392B7260
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgKQXYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbgKQXYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:24:42 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BA0C0613CF;
        Tue, 17 Nov 2020 15:24:42 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id w13so38620eju.13;
        Tue, 17 Nov 2020 15:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i6RVgl+K3ML+5PVXUdqwR/4VZ02Q4BTpTLQVaFvPT+c=;
        b=PsCgL260YOZjfdv3pT1AKS1mv6FOmyVhdsk7xRXaKkE7/kTUY+MRsPeTmCOwfz8Btc
         mRE2PWQwE3k3CdPTKgQS5SSumSCXRXtnBTSnDUvrHv1mQzN9kXhiKix+BV0rDGF3yFRp
         sbuhjuOUJx96exTowNdmQQ9NZzoM0vqo7EEOCK8rN2ybaXso9UB/N+R9Ittg1ESpCNfZ
         C0PfTd8bU1Eqr/uAemS1xWdya4EAU3Rffm/+ry592er4IX0rIfIapw9mO6jDHPZXnmzH
         0er9SVzzAJqEMwT7s8MMNIMKGieJFKii/8MhQ4oRZEZdAd3YRTjxVHHAjrD1O74TcZK1
         rpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i6RVgl+K3ML+5PVXUdqwR/4VZ02Q4BTpTLQVaFvPT+c=;
        b=GrhFvBARdyS7O4jgL6ivspMVZ0qPXee/oFr1iZv39z3psSooTnjOesH8o+7qduU6ZB
         XY1328GwvSa1gS3ceHfdeytppruR4SfSm91I2MI5KjVdu8KACwxbRvi/0f6GWPTLB8n/
         SDM7s9iwAKJh3W8UdYDg1L90gQJ6MWarwCCI57fkRO6wUUPxb3gTh3lyb+0c73RXFqHf
         MMxTCF3xYqNThRaHtLKTbULKLdHAQoOHdvsKFSsbS83VHntA36fgI6wfOgRxMmWwvJ2K
         jyJoXIGeKFBQxVQODE0oYfGMETh+87zRnSifmugrS75/BQwPLZo7VkPTwZT6Gacj4aks
         Jd7Q==
X-Gm-Message-State: AOAM532X7sctpE4zXHumpKnGb6ehdJrK84aBqMrgXU6xgBiAOIsPVcDv
        UqvXKMw6kYX3rOqc0rzmPgk=
X-Google-Smtp-Source: ABdhPJyI1A3oa+IAQpeXvhHDsLWy013pASD5EspAWMMhSBKljB0gVNObL21Cps0tvREo1+FKT5xAHg==
X-Received: by 2002:a17:906:a186:: with SMTP id s6mr22217864ejy.193.1605655481311;
        Tue, 17 Nov 2020 15:24:41 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id v1sm9638595eds.25.2020.11.17.15.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 15:24:40 -0800 (PST)
Date:   Wed, 18 Nov 2020 01:24:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] ptp: ptp_ines: use enum ptp_msg_type
Message-ID: <20201117232439.m3o45csuh6qs6cwr@skbuf>
References: <20201117193124.9789-4-ceggers@arri.de>
 <202011180758.0o8fM3th-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011180758.0o8fM3th-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 07:17:41AM +0800, kernel test robot wrote:
> >> drivers/ptp/ptp_ines.c:690:26: error: conflicting types for 'tag_to_msgtype'
>      690 | static enum ptp_msg_type tag_to_msgtype(u8 tag)
>          |                          ^~~~~~~~~~~~~~
>    drivers/ptp/ptp_ines.c:178:11: note: previous declaration of 'tag_to_msgtype' was here
>      178 | static u8 tag_to_msgtype(u8 tag);
>          |           ^~~~~~~~~~~~~~

Wait for the patches to simmer a little bit more before resending. And
please make sure to create a cover letter when doing so.
