Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24B2607EE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 03:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgIHBIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 21:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgIHBIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 21:08:12 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7EEC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 18:08:11 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l17so14193325edq.12
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 18:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aMxTA5hMeRHlB7QEUVotIMvd37GA7LvdlT/HUpiUX3Q=;
        b=tOFUTIpa5dWFOX40OuoW37NucAgHJwZ6iK6D1XWaq8TikMJnIgtsGIUEkOzD0Co6Pb
         jnDZsj3GtJBESS+CrNAagy0TNCDj4fLSES0S3oYB9U887qdOw5fucO6z+xnGi4P1OTUW
         bO4BvDcG1uZw+Fw4xcNNi+hfIzBFsAplVDBrhn7gNZRrYxj7vFDEAeGbuteeiwoTETlZ
         ji8vC21Jckx5kEpUi3/Q2RGkoqUI79toHXf0kicXO6GAd/eGg3oAgpVFxLYNyIX2t20S
         u7MIA5NfkrpcttHcU0TjrSoQHB8Fc2go5bgGZWQoLLMEkZRRStizo6SZS+lA78lO2kpC
         S6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aMxTA5hMeRHlB7QEUVotIMvd37GA7LvdlT/HUpiUX3Q=;
        b=n4UDvd9Usm1Qh7/7vmJ2w1qKBNOBMIJdbKiv6BBeVss/1u+FIZsN4SI+GFv37pK0PQ
         f0105lnis9u9DoAs6RpLzlBI7E80s/UAkz+MQJAzmKsjSMMEZEzUPKxcadKiu4p9USM8
         7/Kxpx6uccXk1q4POzSkSVerCrqSOUAoqtpa8HBGa5JV+Mmf3LvWWRo3kTq5h2hsq2LE
         FNrjwbTWb4UAPdBtf/4MiVbR8WuJzCOZoJnEcpqbnAW7HndPEfhug2okv0F7QQKbvLs2
         xFFfsoggMllknrzpmP+O4bPg30DJUneDnUZJcXtCET+KUpiD/Ub7q2X0b8esv6x5K+ex
         oL1w==
X-Gm-Message-State: AOAM533etsOhCccp3f8jmOURMKxXbXi2XMkgBZyB3OwoNPNiMj/J8RtD
        lR7vmkelChrLUGNJDMK+JLaM2mq/A+g=
X-Google-Smtp-Source: ABdhPJw32RdDo3W1An+LENVw08NjCwOPkYeWY5Gf9a6TbhV3jAIwbM4q7XWzI4OcP1W3zMtpQ/hI/A==
X-Received: by 2002:a50:8c24:: with SMTP id p33mr18959170edp.330.1599527289352;
        Mon, 07 Sep 2020 18:08:09 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k6sm16713348ejr.104.2020.09.07.18.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 18:08:08 -0700 (PDT)
Date:   Tue, 8 Sep 2020 04:08:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: don't print non-fatal MTU error if
 not supported
Message-ID: <20200908010806.innpkij2q7uf6s2p@skbuf>
References: <20200907232556.1671828-1-olteanv@gmail.com>
 <20200908005709.GB3267902@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908005709.GB3267902@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 02:57:09AM +0200, Andrew Lunn wrote:
> Hi Vladimir
>
> In some ways, this has been good. A lot more DSA drivers now have MTU
> support and jumbo packet support.

Yes, I suspect this is because many people wanted to experiment with
jumbo frames anyway, and the warning in dmesg acted as a sort of
reminder that the infrastructure is there. If it weren't for this
pre-existing interest, I would have expected a patch that silenced this
warning sooner, and not from me (the switches that I have don't print
this message).

Thanks,
-Vladimir
