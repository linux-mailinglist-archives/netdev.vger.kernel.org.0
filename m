Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7404F2BB90D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgKTWd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbgKTWdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:33:25 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68608C0613CF;
        Fri, 20 Nov 2020 14:33:25 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id gj5so15019213ejb.8;
        Fri, 20 Nov 2020 14:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ariZHu4QnrFDJhB72D0q29W4pUB786w40LHU6l1b5DU=;
        b=eT9/8f8uSD4IyX5Vde9lVGmmyRkJQVDxH6aRnvg471DnfooKuPbU3Gzn/zdSl3R7F+
         Nw9e3IM05Jaqn+hmqBAWpKazVACTFcflwEgTjmJfv3OOtgxgy4pWkKPv6ZQPGmFxglvU
         9oYOhgiXEFHLfTJ/Bd0VHDbxXUblgl+GSfVYHZVSCYZ4ruM5zSfAksn8CZjtoO/Sinmc
         UGwLB8falHNaSMRU4qmNvNb2R1D8FgT2fuq2VRvcuXZlzz5BjPBR36L5EFP/st0JOdPy
         t7c1LD6lFpnmHsGgFl2lxJJFIoOE/OBnd+SWNdkt6sfFJGsld5KRNZUsCNKQgLj59aYF
         87kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ariZHu4QnrFDJhB72D0q29W4pUB786w40LHU6l1b5DU=;
        b=Nkng32P4j4sFs9lNY7I3ZUFAl/epZXkfFOMJlmbm94EHTJlneijf5cIEFuu9kZMt6Y
         A37bbQjp7k8RcX4TB5Y7hBGVIG0Eco++3iFKTEStuk4qo3xGi7+jNKcesCgt4Q1SbgZv
         lI86PTu9fp2gdkSabpYKX7bsAIsYR0oTBDJNv6Ygjrrk+X0Z238/qPODHpPEFAREiAWB
         tbvPVLNSuAbyaK7GQklHnBHttVpBXAENcWJEJFZSz6/ak6naBqUyXdRxOHHg26LsEae2
         1+vIGg71UG1bs/QNUWPSS1ngvuHvVeFGiVXcxbOyLDSiV2X5aNiCBPDXVeFjTW0VMLKc
         iW2Q==
X-Gm-Message-State: AOAM530np+YsYhfA+IkD7WwpvYc7irMeBlsD2xngwvaslEA0ugtUCnAz
        wD+6GzYqTduDeoS3410sNyQ=
X-Google-Smtp-Source: ABdhPJziecAnlLPLapNnPRtwUypi3/6eYPKGVB7Ap19cU7cMteSfSkGyvEo9WCCNXrXQhaf5+hZMhg==
X-Received: by 2002:a17:906:3a59:: with SMTP id a25mr36120583ejf.546.1605911604169;
        Fri, 20 Nov 2020 14:33:24 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id n1sm1660454ejb.2.2020.11.20.14.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 14:33:23 -0800 (PST)
Date:   Sat, 21 Nov 2020 00:33:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next v3 3/3] ptp: ptp_ines: use new PTP_MSGTYPE_*
 define(s)
Message-ID: <20201120223322.fcvixiuipkus4kqq@skbuf>
References: <20201120084106.10046-1-ceggers@arri.de>
 <20201120084106.10046-4-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120084106.10046-4-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 09:41:06AM +0100, Christian Eggers wrote:
> Remove driver internal defines for this. Masking msgtype with 0xf is
> already done within ptp_get_msgtype().
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
