Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400122BFCEC
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 00:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgKVXKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 18:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgKVXKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 18:10:32 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC74C0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 15:10:31 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a15so15267175edy.1
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 15:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ur/EzcO9zQNaShCxJKL9ukTsCcBFichCqmT5Ax3AuuU=;
        b=BquU8Ezd3O0sbruKWlR03U+KPGLlKEoS+B+4qjFpMInyM+pnkg9AkZwGS9/FJp625v
         BV0Cgm2aZK6UeRnDNGZsy3hVOgnkz40iAXnWF+YHVfONawz2Pcju8H6mwKs6vUttMnlM
         9V8AWoM6NTF1BmEgHq+uDgBY0M8vz7/29SLjsZ7qvrSaWP84tWEeHhbCdmb0WlbBgdSi
         95zAaie/Zw0dt/L+M2WYACKOaWfjEzeG9Z6ywkIK63yLhXFIm7PZWrTv+Br63fK54Q7g
         K08ocmX7953gLjGY5XCHyB2goxtAf+VG0b1l5zhHqqPnJyyp/YIEURKUyt8AZ8Lv9Muu
         v2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ur/EzcO9zQNaShCxJKL9ukTsCcBFichCqmT5Ax3AuuU=;
        b=rUnaAHndpM4kFH0KiPhkTaP4neIYJveaWXCHfsdqAwOibvl7gUxTnWARxp68OT+Im0
         OWnMEcFArqVMUSC2va/DK16uc9FFUIAmGjy5UHEndo2tspsZUQSNfVt8incjkvKBdOhM
         NG0ZwOOsI33+2jLPCppsxaNfxoJTDYtXN+istKINe7JCMWxfJVlRBHJ4VtW0yEV/vp4k
         CFwB5KdetfRUf8ZNeM91ddnEu0t4LEA/03WW38cYVS70JRFhSoLJtuwn5inKLXqIiPDl
         lbBiUQf0SbLAtz/YN06fpIneI3U7TYalIwyg1UbtMRg0Rtr+ta3SuW9DM7zBu+d2lTO6
         3lmw==
X-Gm-Message-State: AOAM533ipfxkiswjajU83arm+inRS1Ep68P1L6JMz0YPvdBr9NlQ2Jx+
        YxkrHTeQPdEx0OZJq3jWTyhRp6evnEU=
X-Google-Smtp-Source: ABdhPJwXhN3AgjrtTmRWW1kyHhlIaDGp82uFBvUQXuKRRUcAM6AoHFaaHTdf3LJalYhBVsjP4BvNBQ==
X-Received: by 2002:a05:6402:3098:: with SMTP id de24mr43732162edb.155.1606086630030;
        Sun, 22 Nov 2020 15:10:30 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b7sm3149983ejj.85.2020.11.22.15.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 15:10:29 -0800 (PST)
Date:   Mon, 23 Nov 2020 01:10:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: hellcreek: Don't print error
 message on defer
Message-ID: <20201122231028.y6j2ygeqh7julhqi@skbuf>
References: <20201121114455.22422-1-kurt@linutronix.de>
 <20201121114455.22422-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121114455.22422-3-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 12:44:55PM +0100, Kurt Kanzenbach wrote:
> When DSA is not loaded when the driver is probed an error message is
> printed. But, that's not really an error, just a defer. Use dev_err_probe()
> instead.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
