Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A37432B3E4
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840275AbhCCEHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhCCBIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 20:08:12 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322E3C06178C
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 17:07:29 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id p8so12628755ejb.10
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5oirzlV2WU9rV7hNoLo5ppfN4J1BC/5n5Erc832oZVc=;
        b=XP5VVf/l2QZ29V6quFuX5l8nQhnjKDLZ7I3tA6Ay0fYTS2PGgeyaZUuEN8Txtt2Hu8
         Pwd7cPhaOcFLEgREOE66OoNgDBUpVSwJxcLKOsTX9iDLkPvJ0YC6zIwoQTTtKUxjPmY3
         OXkj9VZLZa3AG/GyfVexXbOb0Sn+AsEyRbKZiCFBe0JGcDCOEZ/T+JUSfsswopWvkYMj
         F9Ze8a8IgRC1FZ2n+ljQ2Bi4o373T1jGvykrL8/mVaBlRQpVbquPxLaSg+T6kGw/1C1/
         qQCkp5Inv3xtMy/ym+GJs8k75/BugEeye3OXgdpSthFlKzVrD/R7XBP65qaB0Y7ZH4Lo
         WwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5oirzlV2WU9rV7hNoLo5ppfN4J1BC/5n5Erc832oZVc=;
        b=nQVS0OLXR6OQfWDER7sNvELP4m418Ju4FXFqPI2aW9WJ30941Ne3i823DqIrJc6g8a
         nFoM2wZ6PUqowVkmP6E70DJJVteoHg+WCcxcOWChK9dFSY9zXFAlMi9DLHIoUx4TfP4D
         AS2MSJY87i7I6aKKvsZ1XTV5J1xH81HfY5CAQictX6QUiGtTnYV4mebbUIGBfyESfpth
         7Hi44B9MXPrId7UIBvfRtGXSvzZ5bWy6UQrnhMJIasfwSeHj3fVTBIGTsxQGMbnV5+BL
         04ViBIYgXcKhhBWCaIxCtiEJeGYr5sQW1ZoWhd6V751M557SFTnq1RkA28P/ZF+Qwsq/
         d7Iw==
X-Gm-Message-State: AOAM53218zW/dcfPS7nQn6wGJ02ZterbZ7Y1h4QaFVaz/Mx8XIG4iJyH
        gs3AARS7F0Df5N5QS6Ibc0U=
X-Google-Smtp-Source: ABdhPJx0ExBE6Ghc530RjvMwAR06EYb5UuUZ74x7RScjOzJ5vDtU94TA1K/l9JVAlekEap4T2O8zgw==
X-Received: by 2002:a17:906:934c:: with SMTP id p12mr11654935ejw.131.1614733648004;
        Tue, 02 Mar 2021 17:07:28 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id si7sm5243418ejb.84.2021.03.02.17.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 17:07:27 -0800 (PST)
Date:   Wed, 3 Mar 2021 03:07:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v3 6/8] igc: Add support for tuning frame
 preemption via ethtool
Message-ID: <20210303010726.7rt6j53zg5xwwtex@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-7-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122224453.4161729-7-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 02:44:51PM -0800, Vinicius Costa Gomes wrote:
> diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
> index 0e78abfd99ee..c2155d109bd6 100644
> --- a/drivers/net/ethernet/intel/igc/igc_defines.h
> +++ b/drivers/net/ethernet/intel/igc/igc_defines.h
> @@ -410,10 +410,14 @@
>  /* Transmit Scheduling */
>  #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
>  #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
> +#define IGC_TQAVCTRL_PREEMPT_ENA	0x00000002
> +#define IGC_TQAVCTRL_MIN_FRAG_MASK	0x0000C000
> +#define IGC_TQAVCTRL_MIN_FRAG_SHIFT	14
> @@ -83,13 +89,22 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
>  	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_TSN);
>  	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
>  
> -	tqavctrl = rd32(IGC_TQAVCTRL);
>  	rxpbs = rd32(IGC_RXPBS) & ~IGC_RXPBSIZE_SIZE_MASK;
>  	rxpbs |= IGC_RXPBSIZE_TSN;
>  
>  	wr32(IGC_RXPBS, rxpbs);
>  
> +	tqavctrl = rd32(IGC_TQAVCTRL) &
> +		~(IGC_TQAVCTRL_MIN_FRAG_MASK | IGC_TQAVCTRL_PREEMPT_ENA);
>  	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
> +
> +	if (adapter->frame_preemption_active)
> +		tqavctrl |= IGC_TQAVCTRL_PREEMPT_ENA;

Question: when adapter->frame_preemption_active is false, does the port
have the pMAC enabled, and can it receive preemptable frames? Maybe we
should be very explicit that the ethtool frame preemption only configures
the egress side, and that a driver capable of FP should always turn on
the pMAC on RX. Are you aware of any performance downsides?

> +
> +	frag_size_mult = ethtool_frag_size_to_mult(adapter->add_frag_size);
> +
> +	tqavctrl |= frag_size_mult << IGC_TQAVCTRL_MIN_FRAG_SHIFT;
> +
>  	wr32(IGC_TQAVCTRL, tqavctrl);
>  
>  	wr32(IGC_QBVCYCLET_S, cycle);
