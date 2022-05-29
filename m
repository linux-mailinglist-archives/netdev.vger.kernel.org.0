Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67358536EF9
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 02:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiE2Aex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 20:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiE2Aew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 20:34:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E3B9D4E4
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 17:34:50 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id bo5so7534891pfb.4
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 17:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fL0vTkTmOld4IH8ZQCpmkRcHGTx86AIT4iKQ1TBlwlc=;
        b=Zp30KBilhftoj+J2yuSfliXKQtjJ+72Xzal4mPPy3zp1E6NG6kOI2WG3HgBtJtEf1y
         EIvT2rmoOtOLqUEQXDh1LJfSAP0lwrc4KNtVvr3WYJErx1fIxCziMDoG6APcVOe7lGxm
         /3pcQXyyhP9Z6hTWj6k0nHtwYtpeyw568jPxSWmoe7hFnB5W1f/y1hYPUcnagOHN7NZ9
         rZGnYsrBS5rQY7/8M2XFPIUOpdF+WI2voXeknSgucZ1ZJJTDipGsnXvo8Duhy/VibB9c
         Q3W/aTJB+Ifev7+2Xm4s5n9SY8gNKVAHYjBanure2XfCjxU0ZnMjnFDqB79427aIxIyy
         4yOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fL0vTkTmOld4IH8ZQCpmkRcHGTx86AIT4iKQ1TBlwlc=;
        b=AYigmQLEHMYXWDSYeCSbl2PC05pBPV+xX1dt5i6iAtLOPLWOiJy0GkKwXiNJhnWgWL
         xYL31+hR+hB+mDMa8AmvuaHLHR0vitiCc9WtIiDVw3r8oxCteE1yxUyZGCdWHYs2u8RM
         sfzClHrZ/T8yHYdYk/1FVNOZndZuaZ/wQ3wPpzB/jgeWERUFjQi6EwjTI6bIbDVFATuk
         kRVsJv5ppfBlWxXV1ZBvmjMgMztNoo9JEZYCyg3xruRkW8hy9DLNy8a/EHe+Nduo7KOi
         uFKYagAWlD7zAfDM/OtpRUyMYjsAx8qmL+1LPtn2AryHesZWIXYFjVLaArqW3GEryPgy
         K28A==
X-Gm-Message-State: AOAM532gHumuGeENVJ8EtpHa0SmMA7E02MCIoHaS12tg1P3GGfoaqNU4
        N2FkEqPmhBaiThEyYAYY88I=
X-Google-Smtp-Source: ABdhPJwGIT6P1XM+/dALylPtc4Dtk0b92zvaCBDwLIfULl6N1hOpGvm/2OrhRlO5Js9Uar0yQPvQnA==
X-Received: by 2002:a63:8ac3:0:b0:3fa:e447:ec3 with SMTP id y186-20020a638ac3000000b003fae4470ec3mr16496966pgd.606.1653784490118;
        Sat, 28 May 2022 17:34:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b15-20020a17090a10cf00b001dd11e4b927sm2769847pje.39.2022.05.28.17.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 17:34:49 -0700 (PDT)
Date:   Sat, 28 May 2022 17:34:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, kernel-team@fb.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220529003447.GA32026@hoboy.vegasvil.org>
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220518223935.2312426-3-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518223935.2312426-3-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 03:39:35PM -0700, Jonathan Lemon wrote:

> +static int bcm_ptp_adjtime_locked(struct bcm_ptp_private *priv,
> +				  s64 delta_ns)
> +{
> +	struct timespec64 ts;
> +	int err;
> +
> +	err = bcm_ptp_gettime_locked(priv, &ts, NULL);
> +	if (!err) {
> +		set_normalized_timespec64(&ts, ts.tv_sec,
> +					  ts.tv_nsec + delta_ns);

This also takes a LONG time when delta is large...

> +		err = bcm_ptp_settime_locked(priv, &ts);
> +	}
> +	return err;
> +}

Try this instead:

	s64 ns;

	err = bcm_ptp_gettime_locked(priv, &ts, NULL);
	if (err) {
		return err;
	}
	ns = timespec64_to_ns(&ts);		
	ns += delta_ns;
	ts = ns_to_timespec64(ns);
	err = bcm_ptp_settime_locked(priv, &ts);

	return err;

Thanks,
Richard

