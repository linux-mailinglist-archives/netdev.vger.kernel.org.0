Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D46B3ABAC2
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhFQRpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFQRpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 13:45:02 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2496BC061574;
        Thu, 17 Jun 2021 10:42:54 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l1so11237660ejb.6;
        Thu, 17 Jun 2021 10:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7MHD7EiSpY3e0ERtwOHvIB+KaRhM2Um7f/06TGmH7Gg=;
        b=ISiz3+CBB3cS1Fjzms1hdR9IOCuWXdV/3OZsAmuGA0u24iyp1VIHRdmDtsT0ZCTDEr
         6xRvIJTzHq19O7CIonVqvqT5KoNboIJFFofrV9S1qL6xWomF76y1mqpy96Ayf09PDu8Y
         1F/iId/lDj1MLIEAdk7KjCspqeheaGab+uxzjCKK+tRfDzZi73Scn+qjPBfxHRJniFVl
         Mh3LLnvEYE8eiKmUVob2T5c0J84jhYChrB+V3br1n5fVFc1nhVxZlUQPGbiF/zQqroVs
         iwuUT0RO25hRq1026WPDY/sFUqqW89zfqf7etBnfS8mRpohw9uv5ffFsayrcCTX+EUU4
         UFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7MHD7EiSpY3e0ERtwOHvIB+KaRhM2Um7f/06TGmH7Gg=;
        b=kHEQP+8i58cnd2kmN3dFcUUxo9uPyn/OMAUWUkJcKdCARAiDlg35krq9jn4Zj5haUL
         HQsmzTgTDCp1AuWosOvmvpP/0bx28yqL34mjJ8M7OUS4SklwFEzKiN1RGL5C0EdcrOKH
         aFyoooRdANdisBNGT6ZuVIV1FxD+q1aQj1z+7FpiBh7uCvXr+seLLAGkmVJ0mBqiegw4
         JE53Fxo2kuqcgV2I5pykiRW54WZHAjOMRiJsE0oTlyBdfroBTsRnnRlA7gE7BTFtDE1h
         HMUdiEDuqpwoK44XrppKQPqrgnRJsWUVTriX3clRyvvwuudyqOFRKyc/+3DNFn4UhkmX
         vSwA==
X-Gm-Message-State: AOAM533M2YRA+Di00pQtKOrL1KayuUGzUf767iSyehXlOd/8tCf5KUUv
        kymQrJ2bdYQvva32WnQ3CdU=
X-Google-Smtp-Source: ABdhPJwWNLIULh5OpxfozVq/mF6ozU+8u/EdBodGq5HallWZ8jCIVaPdxjyiv0YLWeBZz65OeLTGJQ==
X-Received: by 2002:a17:907:3f08:: with SMTP id hq8mr6490774ejc.150.1623951772740;
        Thu, 17 Jun 2021 10:42:52 -0700 (PDT)
Received: from localhost ([185.246.22.209])
        by smtp.gmail.com with ESMTPSA id b10sm4776610edf.77.2021.06.17.10.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:42:52 -0700 (PDT)
Date:   Thu, 17 Jun 2021 19:42:47 +0200
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Message-ID: <20210617174247.GB4770@localhost>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615094517.48752-3-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 05:45:09PM +0800, Yangbo Lu wrote:

> diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
> index 2363ad810ddb..2ef11b775f47 100644
> --- a/Documentation/ABI/testing/sysfs-ptp
> +++ b/Documentation/ABI/testing/sysfs-ptp
> @@ -61,6 +61,19 @@ Description:
>  		This file contains the number of programmable pins
>  		offered by the PTP hardware clock.
>  
> +What:		/sys/class/ptp/ptpN/n_vclocks
> +Date:		May 2021
> +Contact:	Yangbo Lu <yangbo.lu@nxp.com>
> +Description:
> +		This file contains the ptp virtual clocks number in use,
> +		based on current ptp physical clock. In default, the
> +		value is 0 meaning only ptp physical clock is in use.
> +		Setting the value can create corresponding number of ptp
> +		virtual clocks to use. But current ptp physical clock is
> +		guaranteed to stay free running. Setting the value back
> +		to 0 can delete ptp virtual clocks and back use ptp
> +		physical clock again.

The native speaker in me suggests:

		This file contains the number of virtual PTP clocks in
		use.  By default, the value is 0 meaning that only the
		physical clock is in use.  Setting the value creates
		the corresponding number of virtual clocks and causes
		the physical clock to become free running.  Setting the
		value back to 0 deletes the virtual clocks and
		switches the physical clock back to normal, adjustable
		operation.

Thanks,
Richard

