Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE482F1BFD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389394AbhAKRMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730923AbhAKRMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:12:36 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DDCC061795;
        Mon, 11 Jan 2021 09:11:56 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id h10so295938pfo.9;
        Mon, 11 Jan 2021 09:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mGQwOL0k8y1YfEAZ87QSjV7hnEWWuS5Kl92JzflD6+4=;
        b=eY0ufYub3BzHiGX2iBcjEqmOzasXvZkYv/lxVuTXonjmv+jcXbS5ZUbcqDUyeH79gq
         GWH1dEeqqVAp6sGjLewoKXGUDr5C1zViGl34J8ep4IsFxYaEQ2jcjcXGXnN57TlNez7V
         MjEWggvOyr7RQjgH2GTftJDFYaAwzEm1ZvNJXFQz8sADPQYGSzpi77AZ5vWpthYlGrAv
         xte561F0yisTKerHjdf/ujKjuCJGmCnZx7kHsON/pyv3uFNChJOdwpBbXWZNwv+GqdS2
         bYwGEKhX7xIP/MaVmFV4kJh8pTK0NZt05kcoMPr0ux6JaS566v0+XZEY8Xs9kd2b5fA2
         1Azg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mGQwOL0k8y1YfEAZ87QSjV7hnEWWuS5Kl92JzflD6+4=;
        b=JSGZvvcKjJBNynckhnrLYYS7izU+xl/mvi/rXsybSFniHdSK8PBopuooa0VNS+b9Ps
         81QPgrhsRwduuIdkDsRWTSErgWYqY1FcEsRr3PhGwbqGR8x5p/eLajdKoqCs4ey3EKFs
         tWdsMr8rVMahOgId7UBe3JkX9i2NmP83rqt7OxqewZolyN9jAJzLhTFL9lMzOMAd4QX8
         VRbtwL4fP8kkoPzsQZz3cuTvnG1YcFPwaHmh4rxlqs66XqaA0amH9KYjCMAiZ2I3riaO
         kwXkzuXri3QzMj/NxWezOXjhOtWzlEffg/04SnvlRnPRwdr6KSVBlXdr60HBaxjomGRB
         52dg==
X-Gm-Message-State: AOAM533LGVpkUzHVW2Qsnzp2yM+AZt2mxJxJUCVpOekQ+uxawXplO9QO
        sEJWLLjg/YvbrvEj14fkV4LbNi72Ih0=
X-Google-Smtp-Source: ABdhPJz82+JSR1ETgjpvtF76kt/0wg/n4Os9o31PyMVTZ1dLpDhmOVi3IOQuelvLx65ef7rxYCDboA==
X-Received: by 2002:a62:7f4c:0:b029:19e:23d1:cf0a with SMTP id a73-20020a627f4c0000b029019e23d1cf0amr315508pfd.67.1610385115633;
        Mon, 11 Jan 2021 09:11:55 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j12sm93373pjd.8.2021.01.11.09.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:11:54 -0800 (PST)
Date:   Mon, 11 Jan 2021 09:11:52 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] can: dev: add software tx timestamps
Message-ID: <20210111171152.GB11715@hoboy.vegasvil.org>
References: <20210110124903.109773-1-mailhol.vincent@wanadoo.fr>
 <20210110124903.109773-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110124903.109773-2-mailhol.vincent@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 09:49:03PM +0900, Vincent Mailhol wrote:
>   * The hardware rx timestamp of a local loopback message is the
>     hardware tx timestamp. This means that there are no needs to
>     implement SOF_TIMESTAMPING_TX_HARDWARE for CAN sockets.

I can't agree with that statement.  The local loopback is a special
"feature" of CAN sockets, and some programs turn it off.  Furthermore,
requiring user space to handle CAN sockets differently WRT Tx time
stamps is user-unfriendly.  So I would strongly support adding
SOF_TIMESTAMPING_TX_HARDWARE to the CAN layer in the future.

(This isn't a criticism of the current patch, though.)

Thanks,
Richard


