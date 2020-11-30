Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30E82C808B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 10:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgK3JFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 04:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgK3JFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 04:05:14 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E06C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 01:04:34 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id t4so14964741wrr.12
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 01:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=l+bcBJwqAfWV/8VZ0H6sJqPXokbgLaSpuC3C5NWipKo=;
        b=nEjd4oBpWdWxFJ8NDaehVg6qFVZA+o6g9xHYlwiea+VpvwXnNUYAOb8q4cMjPzswbi
         2ltvcewj6zjeg4Yx88T6N+RqKuy+SefVLESvpcxML3HD3TGkNDc7jKU7Wd85rOaViVmG
         vTQm91OSrmTyBwIPv1A+NfW3EHY8ZQJfKiTldrjfxnSGm4iFi6P/scfQDDFRqauvcY8Y
         hbGb5B8yLalINEbZiQ3FdsI/gcztTKO+JjxuVmX5sTrEZfhHBZbMx8qNcGkYMwogIF9a
         6eMKy3RjG5XbQu9zsEo4reY0fLYZFf77Jk/iqCq8A0Hh4QYeLlbEekzSrr6Hh8QE0/Cd
         Nkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=l+bcBJwqAfWV/8VZ0H6sJqPXokbgLaSpuC3C5NWipKo=;
        b=oed6PGFD6IGiGNuLbi8YwfP6mXvFHCFv/KUWKX6ZaMAWammS93ruisSMojVtY/eCej
         xS8raLtKFkTuCs2u8QMmbd9dl/2IhQD38cwTWKolfc+rLm45igb5Ft0klyD41bGZyCGd
         I/DMhVYzI7khzTN79lcTNqwhmx83ITJcvMVjROd2WSqU+9OK6vEblIaEz1ZiLyLKZ33Q
         otVsZ3XJvPW2Tb6hFEJRyc+KoXBND12krq1yuLRLke/KpWwBaVT+P8RaXWBtWjfkEgbn
         pWZTvfKXxxSipOi75kpDkOq8v1H9wZmxg7Vn5GTDsSMKGX7Op/h2ULBRSZPrACidZuTW
         kzdA==
X-Gm-Message-State: AOAM531v5V0UZFvnt/lPiIBdJKlYh8+wnPvYZZ3QJR9+sRNdm+EB0Jaz
        U0gzbCW5sBz0a5a0zZ+aMA/Qcw==
X-Google-Smtp-Source: ABdhPJyNLbSZ/YPgf6JxTiBlfUJEqoJbkFK9dDmE50aedq7C+CHGYGIGWy7ii1w8s0OZnG5vokR3HQ==
X-Received: by 2002:a5d:538a:: with SMTP id d10mr27606899wrv.368.1606727072707;
        Mon, 30 Nov 2020 01:04:32 -0800 (PST)
Received: from dell ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id h83sm24486637wmf.9.2020.11.30.01.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 01:04:32 -0800 (PST)
Date:   Mon, 30 Nov 2020 09:04:30 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Santiago Leon <santi_leon@yahoo.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        John Allen <jallen@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 5/8] net: ethernet: ibm: ibmvnic: Fix some kernel-doc
 misdemeanours
Message-ID: <20201130090430.GD4801@dell>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
 <20201126133853.3213268-6-lee.jones@linaro.org>
 <20201129184354.GL2234159@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201129184354.GL2234159@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Nov 2020, Andrew Lunn wrote:

> Hi Lee
> 
> >  /**
> >   * build_hdr_data - creates L2/L3/L4 header data buffer
> > - * @hdr_field - bitfield determining needed headers
> > - * @skb - socket buffer
> > - * @hdr_len - array of header lengths
> > - * @tot_len - total length of data
> > + * @hdr_field: bitfield determining needed headers
> > + * @skb: socket buffer
> > + * @hdr_len: array of header lengths
> > + * @tot_len: total length of data
> >   *
> >   * Reads hdr_field to determine which headers are needed by firmware.
> >   * Builds a buffer containing these headers.  Saves individual header
> 
> The code is:
> 
> static int build_hdr_data(u8 hdr_field, struct sk_buff *skb,
>                           int *hdr_len, u8 *hdr_data)
> {
> 
> What about hdr_data? 
> 
> >  /**
> >   * create_hdr_descs - create header and header extension descriptors
> > - * @hdr_field - bitfield determining needed headers
> > - * @data - buffer containing header data
> > - * @len - length of data buffer
> > - * @hdr_len - array of individual header lengths
> > - * @scrq_arr - descriptor array
> > + * @hdr_field: bitfield determining needed headers
> > + * @data: buffer containing header data
> > + * @len: length of data buffer
> > + * @hdr_len: array of individual header lengths
> > + * @scrq_arr: descriptor array
> 
> static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
>                             union sub_crq *scrq_arr)
> 
> There is no data parameter.
> 
> It looks like you just changes - to :, but did not validate the
> parameters are actually correct.

Right.  This is a 'quirk' of my current process.

I build once, then use a script to parse the output, fixing each
issue in the order the compiler presents them.  Then, either after
fixing a reasonable collection, or all issues, I re-run the compile
and fix the next batch (if any).

This patch is only fixing the formatting issue(s).  As you've seen,
there is a subsequent patch in the series which fixes the disparity.

I can squash them though.  No problem.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
