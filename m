Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65EB267BC4
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 20:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgILScE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 14:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgILSb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 14:31:56 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111ECC061573;
        Sat, 12 Sep 2020 11:31:55 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g4so13753222edk.0;
        Sat, 12 Sep 2020 11:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IahDpW8KduCgmdilexV0pvPO9dBrI7YuzvIXpB6GfVY=;
        b=JiaipIOEK74ETsuEqzlAv7RZy6ux3ifORKJRAK8LBx17q44FOLe6F2iiVeStKzx48b
         Tc1/PZTErkydjZnzsJu3l3PoX3HZRzj8nwsYer+THJo0ZhPfTznbJvec7LjfSTwTrJHV
         s01OTjtyY/DssdMTirsgUfMTICPXlg3E/TCfF1uaG0sD1yY+AI8sfZjbgdoEoD/QnpFt
         BulCL9HLYvEVj3A0Rt7WH4KzWxGeBYl7aS6jE4hVuqfeT8BjFq/IOGGPgKkxZHU89nLB
         +URRozngpobcllAZjTShKnSFnPHkUOCkkTYhPifLKQhQg84iR8WcIz1aB7kEYs+/dLcV
         Bk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IahDpW8KduCgmdilexV0pvPO9dBrI7YuzvIXpB6GfVY=;
        b=XGqRQVTE0c7tsmU21qYHj3F1O+PWX9c5EzYwVppHRUdjd9ZRTOx3RsmjOdqtl423NF
         PC1AS2g2JKLGKNbIvMgFnDHIbEQQpH8YBD1c23MRoGySGHNAQANCr6wcOYXjmVDJqkBj
         G05GeptShAzbcZ69CLMxNU2/4QuWqTqniShs8aEFWqb9IRCckzZnend4I4smybiTiGJ1
         efJY5fEHBW1nESMK6zt5O4yKK4Q5lUzD83l8DJXzqu+Ra49qT7e8lkt5LCpi5qL7/JYl
         0YRxbH4Yso5KWZXD0tYxa+KECsXOTtvCZYOhn5pIbK8G1x2WwHzgcNP6fvxzTtHijdy9
         T0ag==
X-Gm-Message-State: AOAM533q+w62DmAEETTxFGcjEgbqMFY61mZM5lb87eQw0GoIT8GdyINW
        S12jY/VPrgykdIynAyjNmfc=
X-Google-Smtp-Source: ABdhPJxHBr7kAmx9qpDCptweZ3qvIkTfz6qCuzQhLkgMlN9cpfU3ajsVoNnRL1fXYTSownR3XoJH7A==
X-Received: by 2002:a50:cbc7:: with SMTP id l7mr9493832edi.148.1599935514518;
        Sat, 12 Sep 2020 11:31:54 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id dt8sm3536254ejc.113.2020.09.12.11.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 11:31:53 -0700 (PDT)
Date:   Sat, 12 Sep 2020 21:31:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] ptp_qoriq: support FIPER3
Message-ID: <20200912183151.y5e4rjsfiiy57chm@skbuf>
References: <20200912033006.20771-1-yangbo.lu@nxp.com>
 <20200912033006.20771-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912033006.20771-3-yangbo.lu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 12, 2020 at 11:30:06AM +0800, Yangbo Lu wrote:
> The FIPER3 (fixed interval period pulse generator) is supported on
> DPAA2 and ENETC network controller hardware. This patch is to support
> it in ptp_qoriq driver.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---

Would you also want to add the debugfs support for the 3rd FIPER
loopback?

Thanks,
-Vladimir
