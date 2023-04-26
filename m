Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387746EF5D6
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbjDZNwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbjDZNwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:52:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AE65BA1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:52:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-524db748169so888282a12.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682517169; x=1685109169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4gSM07DoDWfFt89LgxkFwiUUObh6+nWrAZQMGG1Q19c=;
        b=MV0lUcPiV7HHeLvcxwPApEvBZkMiY113+czy++oE9g+V6EsgmaEJlpPGVPq2HlcKly
         JagcvVG25sVnn5rQoyZj4JnDdF+OhRX8tdkvl4sYr8+6IGjPc2iZ/eBM34n3maYfT47/
         Jz95vCYPtAYMT2CguLaRnmCUGZBefLFKKnI7repMgyBG4WlnrXVkSYarPo+isE59m/OL
         AyCiyl44Dit8isNVk2kQZmQSjqLYeLss452vh1JQmciUdKm5veuvzGNHKwdy7+Y8qzXZ
         /99ilB4SeKmY/mGUbRlcmR7j9y8rnSYnbCRHv0K87TZL7DVWFCzCqn3PdCwBYeLE2Ewc
         +bQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682517169; x=1685109169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4gSM07DoDWfFt89LgxkFwiUUObh6+nWrAZQMGG1Q19c=;
        b=aRxQNoXJZWykSdlLZuAsuH1Sx1bUU1D4SaiSGop9AReq+jpQuN4FntzJeTVFlty/tc
         tob2u0CMOw3jmAhps5pJWDrh1cMN1iu3vFt42B3GiyUjYAnUXCZ9bkYAsb4ToBY9bT7T
         a3Ei4AoKD7PyopwOxH/NkzBTCF9Qwptj0ohRgz7PiiRfd7rMXJhJuO9x0n/xFXv2CWPH
         fw8sswmCNpAqc9ryV0/qfa0XeEz0uRyX0iDFoeEEUXO8Ip62LaapIWnsFk6SNK6y++w9
         XgNAdokTv/W5H3W7I0Vd5kalSit0IbikRcNzk2QKNfnOYXDGcDoiFC3TukKmSw4Kntto
         /EMA==
X-Gm-Message-State: AAQBX9c2REW5rO5XLz79uCBW5wDiE5hJemxWqLMX0MxyfCiC2lGNcU2M
        oAJXpGf0hQjq4df+zCjE2/A=
X-Google-Smtp-Source: ACHHUZ77Al+lKig7GuKc4tR6J9shcz1XPaBN+LycYEyX7+ypOhHKyKqvm5+rS+DWsTnHvmQxFV+zmw==
X-Received: by 2002:a17:90a:34c:b0:249:78db:2635 with SMTP id 12-20020a17090a034c00b0024978db2635mr5197670pjf.0.1682517169116;
        Wed, 26 Apr 2023 06:52:49 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090abf8c00b00230b8431323sm9724187pjs.30.2023.04.26.06.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 06:52:48 -0700 (PDT)
Date:   Wed, 26 Apr 2023 06:52:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, Andrii Staikov <andrii.staikov@intel.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: Re: [PATCH net 1/1] i40e: fix PTP pins verification
Message-ID: <ZEksrgKGRAS0zbgO@hoboy.vegasvil.org>
References: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
 <20230426071812.GK27649@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426071812.GK27649@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 10:18:12AM +0300, Leon Romanovsky wrote:
> On Tue, Apr 25, 2023 at 10:04:06AM -0700, Tony Nguyen wrote:
> > From: Andrii Staikov <andrii.staikov@intel.com>
> > 
> > Fix PTP pins verification not to contain tainted arguments. As a new PTP
> > pins configuration is provided by a user, it may contain tainted
> > arguments that are out of bounds for the list of possible values that can
> > lead to a potential security threat. Change pin's state name from 'invalid'
> > to 'empty' for more clarification.
> 
> And why isn't this handled in upper layer which responsible to get
> user input?

It is.

long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
{
	...

	switch (cmd) {

	case PTP_PIN_SETFUNC:
	case PTP_PIN_SETFUNC2:
		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
			err = -EFAULT;
			break;
		}
		...

		pin_index = pd.index;
		if (pin_index >= ops->n_pins) {
			err = -EINVAL;
			break;
		}

		...
	}
	...
}
