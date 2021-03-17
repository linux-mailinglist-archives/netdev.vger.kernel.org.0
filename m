Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1146133F257
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhCQOMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhCQOM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:12:27 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A598BC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:12:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bm21so2864424ejb.4
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u0yrVuf3fuA098/Z+brKv5109vQrs6IutRw9VxpYw1U=;
        b=i/dqiyZkfzyef+SI7k75nnGJaUzNUwGdgQGbToe8j+e5/inFGtdTi8+TJC4CvlbibX
         tBtD2ztmmPPyfdiuSyaZeZRHBlqgc8DPOsTncRarORbmNOIeRBmoDYdo8uep2cyZZxS7
         SB4Xq9FsZVHEQcyE9dM77LNhZO1y3NL4NDS+MGzpZUe0ZWKcEgMCnM78kITpVUYVA+by
         qeVfaJiL667Iu66Cr0Li/xkYQvEOA1+CVp+cjRn7o2VjFTfchq6hijGIyOExpE1D3C1R
         MxATLr3G/ulEjz9vLnTLIxk6LaI6drWE9i3gTSYw0iwTHStt14Fb8qWKlzVtdiYjlCEU
         xeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u0yrVuf3fuA098/Z+brKv5109vQrs6IutRw9VxpYw1U=;
        b=YhyyAF4kzKFZPm6+n887hcOVsDaVdDmicdJCqoEtIduySkfeN/D6J68ugZ45xax83M
         ZFCquWYAC3VfzcqgKq+/9H3W2jRUdyRzLyFwZP+xUp0OUHUKHNYSQ89nYCjDoPeFIt5N
         Svl19X0Uvpi0G4DSGS9Nwathzs0xYVEcmS5p0SjnY/eD0DBGNIvfINaISIj1FfZK+YTA
         r54RCNKsa4PtzXXam+O6MO/9mxKY4UmHCQNboP3aibRN3vPjLFxt71QaelXfBJm1OLqz
         /MbRZBIA9epQEQ10SY0SAfujJWWYKQXaXi2lRAy0QDsU3T3fcMLffTDr9WZzpJtFRZZ9
         DjVg==
X-Gm-Message-State: AOAM531inbHGvwZaaDroebm3USchsym8zQVzxMnPAJ7fabWn0tmpXBnO
        Isa9TFqnsrnORIe2IFDGTehUYAo97So=
X-Google-Smtp-Source: ABdhPJysWpUlpcmphks8d5QbJLdq7JAgLzfurLKSHit3a1Feqv79jvM6egI36Fhy7/pG950RNzkCfA==
X-Received: by 2002:a17:906:8408:: with SMTP id n8mr34235400ejx.152.1615990345452;
        Wed, 17 Mar 2021 07:12:25 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r17sm12888745edm.89.2021.03.17.07.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:12:25 -0700 (PDT)
Date:   Wed, 17 Mar 2021 16:12:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Offload bridge
 learning flag
Message-ID: <20210317141224.ssll7nt64lqym3wg@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315211400.2805330-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:13:59PM +0100, Tobias Waldekranz wrote:
> +	if (flags.mask & BR_LEARNING) {
> +		u16 pav = (flags.val & BR_LEARNING) ? (1 << port) : 0;
> +
> +		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
> +		if (err)
> +			goto out;
> +	}
> +

If flags.val & BR_LEARNING is off, could you please call
mv88e6xxx_port_fast_age too? This ensures that existing ATU entries that
were automatically learned are purged.
