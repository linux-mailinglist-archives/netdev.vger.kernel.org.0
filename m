Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5484E133C60
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgAHHkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 02:40:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36912 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgAHHkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:40:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so2253034wru.4
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 23:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vSmXwBn2AR3fxtJigVCv7P0HAA4z7xXMzI8QIwHygZY=;
        b=VnayRjxnxRPSG7FcqpWm55V4hTIFurPcd5F7kKk+WtJFqrYH8Dr3cxuzp9E+9FkN/0
         ExVW6wYRxU35sEXoWv8z7lq0FtmrRcZKEpbvh1+cv5i1GoMowMbPPmY0+cX12MmIxo8L
         4dWzeTVMp7l3FQoQk6LAkBHuvVt+Axq8pKR1/CLzB9SUr06+mxSG81vY1FaGOiKoNDQb
         AFV7Pq5paITG02NL7jHHAeJlI+EEmMrdn+3Solniv959co+pxQ+/aGxLWMhN46d2+Vx3
         TJFJxlRu1WlalBp6/yGS7XeB2fFYyqzc+88E8RUZxe8BkrGNe6GTywf16PFVRaXBGzAe
         uoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vSmXwBn2AR3fxtJigVCv7P0HAA4z7xXMzI8QIwHygZY=;
        b=hccGXhJ3DF19Z0wn8fq422rbsPtCCOVhk5/f0Vh+3To21mGxHFnppoSDiPEWFO2eo5
         h4fANii9ZuYqzWUwAhv6X+mAvOsoqzSVF6zUvQHhAwAFZyXgCYxnWhV7gYjjLsFdeW0+
         G/pPt8U649vhUlqiusqj1wDjDMhOnVx7LgTl2PfkHNp1BvWcSC+jyBgu916yU1KWDYmO
         Vmvaljxg38zcILUyunMdonfZomfTgUemKDx6gVHIxu4Q8DtS20JcLpxeepoa46x6/Ko+
         aY6W7mXbEDSLjri5YB3YG4bJ2mJs+xNYDMDIT183kM87gd4pf+yfLyE38zCqzCHxze8U
         9lMw==
X-Gm-Message-State: APjAAAUEtBHwO0kOdEZiuyoJokmyUzwBXL3AOcsc7VhA5Oae2Zsrh+Ug
        l+vojddcuAcMFdoF2i9DX3FjHA==
X-Google-Smtp-Source: APXvYqz9FEcQdGQc0YS8qK1JJnoGFNGqthccEUkGMfgP/cnH4wsppaslw1AkA5K5Qpz+tKFdutsMMw==
X-Received: by 2002:adf:9c8a:: with SMTP id d10mr2821293wre.156.1578469201237;
        Tue, 07 Jan 2020 23:40:01 -0800 (PST)
Received: from myrica (adsl-84-227-176-239.adslplus.ch. [84.227.176.239])
        by smtp.gmail.com with ESMTPSA id p17sm3218208wrx.20.2020.01.07.23.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 23:40:00 -0800 (PST)
Date:   Wed, 8 Jan 2020 08:39:55 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        hdegoede@redhat.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on
 brcm43362
Message-ID: <20200108073955.GA896413@myrica>
References: <20191226092033.12600-1-jean-philippe@linaro.org>
 <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <141f055a-cd1d-66cb-7052-007cda629d3a@gmail.com>
 <20200106191919.GA826263@myrica>
 <c2bb1067-9b9c-3be1-b87e-e733a668a056@gmail.com>
 <20200107072354.GA832497@myrica>
 <34dbd037-0a40-bf5f-4988-6b821811ffcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34dbd037-0a40-bf5f-4988-6b821811ffcd@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 07:23:32PM +0300, Dmitry Osipenko wrote:
> >> Hello Jean,
> >>
> >> Could you please clarify whether you applied [1] and then the above
> >> snippet on top of it or you only applied [1] without the snippet?
> > 
> > I applied [1] without the snippet
> > 
> > Thanks,
> > Jean
> > 
> >>
> >> [1] brcmfmac: Keep OOB wake-interrupt disabled when it shouldn't be enabled
> 
> Will you be able to test *with* the snippet? I guess chances that it
> will make any difference are not high, nevertheless will be good to know
> for sure.

I tested it with the snippet and didn't notice a difference

Thanks,
Jean

