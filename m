Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EDC3D406E
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhGWSNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 14:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWSNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 14:13:20 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBEEC061575;
        Fri, 23 Jul 2021 11:53:52 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id f13so214635edq.13;
        Fri, 23 Jul 2021 11:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S9T1PkvWtfV4IGqvCJCCGA1mrBnw6Dgx37hAkOOYcTo=;
        b=mR2i5ciQBWYm2081RdJ8h2rmT5pT3pP6qB46SZfENGGUWFSHvfl5N318UeDP04n/aT
         JmvVe6ZnmKln6CkKjEdbWmVxq8YQSWt+jsUuoYFjKGVDr1oN/Um5UjrIyNYwCBMj0asX
         /ukpVs5UtCD67CSiSWwJiVqG9RhGgsFDb2R+Ii+njp5ZBmcH/I2b5u5UH7klMgkTNT3o
         5UhUG+gkHg5KU0iDb1Jtg7dDm20oOnOBGvGeBQ2ri03dUks/b6ICKIkgtKJBOz6Kgy9K
         aZFrhL+8a3a6Cwi9uWlfcJj3wIg4lSSAUjXSvxSyQoWeYSd1xMLwrZ+/uVM7pIzLNV9y
         qyLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S9T1PkvWtfV4IGqvCJCCGA1mrBnw6Dgx37hAkOOYcTo=;
        b=CnPb/50MdZ0F9pGcxY4ZYumyRyUAUtkZBQpItaYjEI3QG1hEzrjVYGx1gf8Zg04HXd
         5HN/CO0FFNhg2Obno8GmRYdoTcxBvXkYEKIs7tTCOWovUklQIhq0NqX5YgApqr6G1cFz
         loyRJ3HEXBIqXW/lxDrC54V/Evu9FHj2IrfsqyUEcUsY7/RB01cM1JBe701v7f+VUDK9
         vcSyIxhxxc5e/AflYuKymS+GofUmcKOfFWoWJJ+BiJs48Y155m7ZH1RoUA92E+VOzUuK
         8enU0YtavHDaJEYX174PC6zS7jmt28dT6NUA5wf21gtb5XMElzoS98iXU3YyBiZ2rgT/
         6Ebg==
X-Gm-Message-State: AOAM5302ppcLTQ7bmubFFs1gEaRRtzSUn9Rr87+M+B4puLSIu10gTE30
        xHNWfrW/95eHzo26T8rkc5c=
X-Google-Smtp-Source: ABdhPJyxmeeW0Ledjs3jwsaPqp+Q1UnjqDfVWtKW15kcZ/6zsGZHzsInMfygQyrpWtRDhXqPyoFZKQ==
X-Received: by 2002:a05:6402:29a:: with SMTP id l26mr7189964edv.207.1627066429392;
        Fri, 23 Jul 2021 11:53:49 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id d4sm10914675ejy.86.2021.07.23.11.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:53:49 -0700 (PDT)
Date:   Fri, 23 Jul 2021 21:53:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 02/10] net: dsa: move mib->cnt_ptr reset code
 to ksz_common.c
Message-ID: <20210723185347.mopb3mtmfk3mnugt@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-3-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-3-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:01:00PM +0530, Prasanna Vengateshan wrote:
> mib->cnt_ptr resetting is handled in multiple places as part of
> port_init_cnt(). Hence moved mib->cnt_ptr code to ksz common layer
> and removed from individual product files.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
