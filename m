Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BAF315547
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhBIRj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhBIRhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:37:16 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD050C061797;
        Tue,  9 Feb 2021 09:36:35 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g10so24910780eds.2;
        Tue, 09 Feb 2021 09:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3IKSUC2PbMBLcmAxJNHDlsNxrnoGLUkLdRWIm40sEpc=;
        b=LGw97nE1cdPwc3VbbdI7b3jcHyQ5rDSJXCpydItAPA5Duy7SnDry4v7J4PxhT0geS6
         Q4VfKF0h844R3hVgCo54tdyExYyz5Mey9SqemYKef05Yhwl4eX8VZhJCjjGd2Xa90O01
         PnHKbpH7BtHXyaPZdZzcY8cS02pRNsKUyPv6GdpdSnLDmd10xlE6NysARS0+T9Q2KY8d
         x+HvCxriBjgv2a78wFPePpW0sqjFfX106VbA50dcMre5AA483PPmKFWlhW2zJyqeYOF0
         C+PC6bAZ12wwNYmvAyxSoUAZXPDe8phSMQd5gPunsSFUMFjEqG1rYCstOM4qG53nb86p
         roMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3IKSUC2PbMBLcmAxJNHDlsNxrnoGLUkLdRWIm40sEpc=;
        b=TKcPyy6FzhnpwokROG+zMzAruQU3MC6unz5LtIjLiBBHtIJI2MZMAMQ7fHrUYZwN6o
         lERcjUkzdhD+3kSNH616dIkJVwPJnPTNg1YwHdoqvnksFJfd/ym4SjRdw2UqolK7wMlh
         I0Mx+uZozasC2OppyoQYH8AsKOm1KSgGpjT2AeG+Yi2OtRBaFTybIa3mQgRClMUe6Dnn
         jx56y6zdbtQfEB5ZFCKXKspJK/fVhsS9rW34qaRBEjZNokpJqqm+Ck2vCnRqMOrfmBvi
         ljIAH+NxzCpkX+wev3deLrdTnNraGIddZRQr2LzvT/RAHvvJnoifmv8xTlnHMIY/MV/9
         x/EA==
X-Gm-Message-State: AOAM5311dDX1xkSa2OF3ZOGmv5j8Lfqp8ctotWyfH9cnXBnSQRYlAjNj
        oKRh8AAmceLbXZY7IEqGaEk=
X-Google-Smtp-Source: ABdhPJzwBwXcr3FNir+11tzCbCmVt5tv5onkeBPfFP5BzJvTttLymfdZC3IkFLRtUk/UOK6Q6I7vng==
X-Received: by 2002:aa7:c58e:: with SMTP id g14mr24696022edq.318.1612892194600;
        Tue, 09 Feb 2021 09:36:34 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z16sm6721317ejd.102.2021.02.09.09.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 09:36:33 -0800 (PST)
Date:   Tue, 9 Feb 2021 19:36:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 03/11] net: bridge: don't print in
 br_switchdev_set_port_flag
Message-ID: <20210209173631.c75cdjxphwzipeg5@skbuf>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209151936.97382-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:19:28PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Currently br_switchdev_set_port_flag has two options for error handling
> and neither is good:
> - The driver returns -EOPNOTSUPP in PRE_BRIDGE_FLAGS if it doesn't
>   support offloading that flag, and this gets silently ignored and
>   converted to an errno of 0. Nobody does this.
> - The driver returns some other error code, like -EINVAL, in
>   PRE_BRIDGE_FLAGS, and br_switchdev_set_port_flag shouts loudly.
>
> The problem is that we'd like to offload some port flags during bridge
> join and leave, but also not have the bridge shout at us if those fail.
> But on the other hand we'd like the user to know that we can't offload
> something when they set that through netlink. And since we can't have
> the driver return -EOPNOTSUPP or -EINVAL depending on whether it's
> called by the user or internally by the bridge, let's just add an extack
> argument to br_switchdev_set_port_flag and propagate it to its callers.
> Then, when we need offloading to really fail silently, this can simply
> be passed a NULL argument.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

The build fails because since I started working on v2 and until I sent
it, Jakub merged net into net-next which contained this fix:
https://patchwork.kernel.org/project/netdevbpf/patch/20210207194733.1811529-1-olteanv@gmail.com/
for which I couldn't change prototype due to it missing in net-next.
I think I would like to rather wait to gather some feedback first before
respinning v3, if possible.
