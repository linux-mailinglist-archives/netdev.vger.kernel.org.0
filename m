Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A222BB90A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgKTWbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgKTWbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:31:35 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D52AC0613CF;
        Fri, 20 Nov 2020 14:31:35 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id k9so205271ejc.11;
        Fri, 20 Nov 2020 14:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+ieqCyGByJn126byCee1Fi9XlhMi2vP1nRVyFQa4fLA=;
        b=nxcKEZ7KhpJfcIOiAyG6wte100o8LD9EqGrIp5GIkg2VZsxFU/X8IT4C9IauguoX0B
         Up7NNUmmWyWavdIz1ekTits6hApArSIOFmkrrzVJ/usetht1xMZtzTd6rRzYJyWHWKws
         H/Z3KC+hIOJ44bm4arPFs2BzumhX7S0hJEExiV/V3Zzmc+liOZ5iL7d0Kby9/4uIAaL1
         NTmrFBtrgeU70EGhBYyzpbZDEgsceisKvLrY2Hu8t/nVyb55NdjXyH4RZX8xNztskKpG
         GAcqgmHX/ptTsdvpu7M1MsvR+6n22XGWTLtZsRnGkxb8pfiD7NnjC1GKuAyeWtSgDWc+
         5ajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ieqCyGByJn126byCee1Fi9XlhMi2vP1nRVyFQa4fLA=;
        b=jbmjogiJREKCKafitU9wK5sEHcJM7HTte4ipBtgtdP7zEETkoC6srvEKIsMMj798r8
         GBTp02yFSCP0uq1WW/GO5qmVts3e9RwFo6yJFuvwp7jY1S0oZ7HU+fS3phutWtyRAdA9
         6PukFAkuGC8kZV0zypv9A3BIh1XEfok2ykWp7sh2rYAvpRHHMP6UDxSk+nTxKVB4tNKk
         3ETDE8rCJcavP2teknSyUYG2a8S36KYmRGKjjEhHZtvKlZzazm0zu8YiIQX86wtW3mlB
         AI4oNdUeBddVD2bJjVDV8LjYiRJgoeDIHDcByrDXV5xMhtdQsSSjx3x2+jsTSxPOxMoi
         Mx4w==
X-Gm-Message-State: AOAM532LvLjgV2Czm3p8cbhnEGkfC9LOt8uEDowurTN1XLU5ZNRncv/T
        +VzfvArU3t8+ExQC9s6wpok=
X-Google-Smtp-Source: ABdhPJzDjlIr0E6V75Fji92YmulO0IKU3aoV445BmS8g2C94CemgPie2XKC6/TaEiJx60iTu7YpDYA==
X-Received: by 2002:a17:906:f1d8:: with SMTP id gx24mr33880142ejb.73.1605911494127;
        Fri, 20 Nov 2020 14:31:34 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b1sm1588381edw.27.2020.11.20.14.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 14:31:32 -0800 (PST)
Date:   Sat, 21 Nov 2020 00:31:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next v3 2/3] dpaa2-eth: use new PTP_MSGTYPE_*
 define(s)
Message-ID: <20201120223131.pk25lq3rxfs6aadt@skbuf>
References: <20201120084106.10046-1-ceggers@arri.de>
 <20201120084106.10046-3-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120084106.10046-3-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 09:41:05AM +0100, Christian Eggers wrote:
> Remove usage of magic numbers.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
> Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Cc: Yangbo Lu <yangbo.lu@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
