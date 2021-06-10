Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB633A3249
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFJRkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJRki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:40:38 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBFDC061574;
        Thu, 10 Jun 2021 10:38:31 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ci15so427738ejc.10;
        Thu, 10 Jun 2021 10:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1+01fpdAz6oGiXmjSnA5iELz52spEMgsysU/FzjkqH0=;
        b=hyM9O+zLFGbAi+DDCTmo0BkZBObbElydwddxNCHevP16AbiwOdV0+SDR0sSzPh50+f
         SMXl0LNEBIgmhFQ8JwntcTvltzPPJ1a6w51gPuoSrin+exoIaYdFJFVubHOBIEBwbZp8
         LffZH9WInr82QExD9mZzmbrH8z6HTOUAvm8lq5eNHE806yUgNdV8hopn7d27e1e5c0DK
         lWORVAfk4lOIQZ+aFf4g5Id6GiEMEsaPv6BVwhpKFwqXHFmeWRCap+Lxm2W0VeN0eBD8
         eL+X3WwJPBqroo2Xe68zQeeHkuCDhegnS/h+OQhuXIpURSIpu2BwfwyBUERJr5PrCCXO
         Q52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1+01fpdAz6oGiXmjSnA5iELz52spEMgsysU/FzjkqH0=;
        b=IIL/7+IHM9IEKrxiT6IpyknjlGipKtobI+US3EgBd11nUMSRW2Ix2BdRZ7+qR9Esyf
         T/oZB7/V0GcBCWPhrF5MGCw1Tq31alyFxsXpM0NSjbAtp0sPG9UfiNTdY0m5i29zZlaG
         LlqEw9dOLD5p7/FrEkgbfGBKfBwbwu0Z+MfA+vcTDiyuJdIPw3lSub8sgrjLGQL0MBV4
         zJGFKmHrCZh3Yu6DDsRxn0dr+sQlsXRHxee7qFJNug198iEPqmPLsUSkWbFCPGaUOgfl
         7cH7RxerttmUIvVIx5m6WBHtruQVvDFMSdz0+ahBhibooT2s1RTlJL8OULnJxPlByUVQ
         nJZQ==
X-Gm-Message-State: AOAM5336hQPyMn4X/AxviUTHdsxsjy8/zaLhPLTqFD1G836I4KlvbzhY
        3JaAYroXOKmMWX7FhthZY98=
X-Google-Smtp-Source: ABdhPJz+ZL/XX9PVH2VNIlKTm45Njkr8yH/gz/k8g5kZ5aJmRIn8MIBUEZJY/tFl+C7VJ3S0LjrRPA==
X-Received: by 2002:a17:906:757:: with SMTP id z23mr656467ejb.537.1623346709693;
        Thu, 10 Jun 2021 10:38:29 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1273174eje.123.2021.06.10.10.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:38:27 -0700 (PDT)
Date:   Thu, 10 Jun 2021 20:38:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH v2 0/3] net: marvell: prestera: add LAG support
Message-ID: <20210610173826.pe6tyaipzfbb3gcu@skbuf>
References: <20210610154311.23818-1-vadym.kochan@plvision.eu>
 <20210610160828.GB29315@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610160828.GB29315@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 07:08:28PM +0300, Vadym Kochan wrote:
> Sorry, I did not mark it with a "net-next", will resend.

Don't - let it simmer for a while, 24 hours at the very least is
generally a good time to resend if there isn't any other feedback and
you still want to make some changes. I think in this case it is pretty
obvious that you are targeting net-next, so that wouldn't be enough of a
reason to resent.
