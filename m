Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE840287391
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgJHLtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgJHLta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:49:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513BDC061755;
        Thu,  8 Oct 2020 04:49:30 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id md26so7638336ejb.10;
        Thu, 08 Oct 2020 04:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Vqhz+balQqIa3/yKYqGTZatT3KbBMTEeLTANkQK3a0=;
        b=VQPUGNQfhA5c55qB+x/VtPcRZH8VCfHJsH46BPkmGkYATnfCMD55DcxMWXha6QzEip
         pesgudbkUmlYkZsYWEzBgiuIfHuZmKsUhwpx4D2kfxWq7WyQ8J2hnrG30CpQb7frLq/M
         L4s+q7CQD42gXYjXiiVr/wT9xO6OIFHkKP9LE3F2ZypAJB1JITEGLJL9M4HJui9omkvf
         IUCsg72ReMsCJGgNv0eyRF0xsEhzZe1FHvUbkJ2lk0uBYP9ymjOm1SxlFerTZUfILmSl
         FaO5MTBPkg1mdN+FRBAXf/XLVFwQlK2YdJUG3nAZPsR5BF97CbUAuAi5QscmB0Gy/ucj
         142Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Vqhz+balQqIa3/yKYqGTZatT3KbBMTEeLTANkQK3a0=;
        b=YYItZuS6qae0hTr1t/koVVQC90Te6k99gxlbTdHStwrSe8QMZqJv5ym8OW8v34SvHc
         a0OfrPKcJ+GPTAaiVGu/tadFEUi0DFYnSpord0zqQI7TLqotWgJcy0XD78/qeW1+Mfoz
         laBpp3ywbzSIHT2IOG0rydMVpyBZuEYBZRRufdztN1Hajdsr50aeOcxvCsfZjY+1vGhq
         lTlV4LVGiSPEUOmx/eVFy7Ki4PLRQS8IBWmT+EuWiNCqzYDMVk3HZtq7uqcvXCw3Svry
         UaTK0J2zFRoSgjcKh27iBjEWpHlnQJIteKioPRh8AgX2d+YKXd/E2PJ6ZqDUjlmdy0FN
         0yYA==
X-Gm-Message-State: AOAM53179KC/nCr8CUA46NaOMdV7ClG2ATaHNp1bAlZVDrRyj8bQS6oj
        mvw03nXRTqEQNzwbZERo9Kg=
X-Google-Smtp-Source: ABdhPJzBm0rQeK+Y7nj0NlFKOkYml8Tnxw0fnThwGQ0htFTZQkJGwhWAmUjZN6MNMpYdv3gGOUF34w==
X-Received: by 2002:a17:906:b784:: with SMTP id dt4mr8880618ejb.376.1602157768915;
        Thu, 08 Oct 2020 04:49:28 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id m6sm3892989ejb.85.2020.10.08.04.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 04:49:28 -0700 (PDT)
Date:   Thu, 8 Oct 2020 14:49:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201008114926.2c4slmnmqkncsogz@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878scj8xxr.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 12:13:04PM +0200, Kurt Kanzenbach wrote:
> >> >> +static const struct hellcreek_platform_data de1soc_r1_pdata = {
> >> >> +	.num_ports	 = 4,
> >> >> +	.is_100_mbits	 = 1,
> >> >> +	.qbv_support	 = 1,
> >> >> +	.qbv_on_cpu_port = 1,
> >> >
> >> > Why does this matter?
> >> 
> >> Because Qbv on the CPU port is a feature and not all switch variants
> >> have that. It will matter as soon as TAPRIO is implemented.
> >
> > How do you plan to install a tc-taprio qdisc on the CPU port?
> 
> That's an issue to be sorted out.

Do you have a compelling use case for tc-taprio on the CPU port though?
I've been waiting for someone to put one on the table.
If it's just "nice to have", I don't think that DSA will change just to
accomodate that. The fact that the CPU port doesn't have a net device is
already pretty much the established behavior.
