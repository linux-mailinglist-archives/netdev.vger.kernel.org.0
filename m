Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB2412A9B4
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLZCXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:23:07 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52291 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZCXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:23:07 -0500
Received: by mail-pj1-f65.google.com with SMTP id a6so2757004pjh.2;
        Wed, 25 Dec 2019 18:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TCUk4e84OM7ozr9fasOhB77j1Cy6vPaAzkFi/kzM/DM=;
        b=WxGUZCtCOatcYj6zMa84ZbATe3lknFdLPjExlr5y51rvLmDFnW9KN5BK12Wi7vU2fM
         DGX7Rn4EPjBVe8shWkkI+RMx2OM7MaxRwZ4W6bt9KlYV6vyITmviFl628RdhYFk+B9H2
         sU+7NbPiCIovK/EBvwahmdfYPsSQ9aZ5fZqoHKdpK40MEmMrvLXEFig1hXNxJAwnaLCc
         LFpp2OxgKYmjq2oEguhQoWK5O7UgRIGMCaqSdNk2qLimJepB0dQTcTOSj2ah8aF0+o0k
         R/0dOQOxYqo4j2/rAkga5nPlsInSz3xENDqWeKNCxvS6ieYfOK4YBanQZVyD5ZwZXqUA
         c3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TCUk4e84OM7ozr9fasOhB77j1Cy6vPaAzkFi/kzM/DM=;
        b=DM5qComGHQcTQlleYJEIIynk7snA3URJjdpX2ItRprFglibtccP28b+7M2hx+c0/Xe
         ckHRkZcWKsmbJG8O/FuvXHO3a9zg7/syKrKLat9ZkIwoarrQas8SBRLiKwAQ1pGwG0xg
         BRRyPsHRnsd4FHxuogzMFAIo652Q5HRFiqxalZGz2En/0PEzGwEOLHldskCAcPUrSjH7
         D7UWubi0GqTAJqU54vHT4SjXCK7yHqdOoj4y/vMoQ59SGjBue0xDzhLVuMuxB2FjK+kf
         LeXZDVB9C/uSu1QuLx16aC4DMBPZKjgCBGNUO4DdFTQ4bIXmNkLmEIyEma+VeubwEPeW
         sgww==
X-Gm-Message-State: APjAAAW2b0wwTg12G/B26RnPJUc+rsWxZV0LIE0cwlhOBRJ4odpQH9Mz
        tH+B9vYs1cX8y5SctWG07TU=
X-Google-Smtp-Source: APXvYqxLIr+xmeMIniOCx4LFbGEWJ27ZOmGHY0NifApVBetuWdE/P4gXJC/+VK0h6H2x347fFqAslg==
X-Received: by 2002:a17:902:8d83:: with SMTP id v3mr40460349plo.282.1577326986188;
        Wed, 25 Dec 2019 18:23:06 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n26sm32570428pgd.46.2019.12.25.18.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:23:05 -0800 (PST)
Date:   Wed, 25 Dec 2019 18:23:03 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacob.e.keller@intel.com, jakub.kicinski@netronome.com,
        mark.rutland@arm.com, mlichvar@redhat.com, m-karicheri2@ti.com,
        robh+dt@kernel.org, willemb@google.com, w-kwok2@ti.com
Subject: Re: [PATCH V8 net-next 00/12] Peer to Peer One-Step time stamping
Message-ID: <20191226022303.GA24487@localhost>
References: <cover.1576956342.git.richardcochran@gmail.com>
 <20191224.154713.990847792889689914.davem@davemloft.net>
 <20191224.161528.379031720244201153.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224.161528.379031720244201153.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 04:15:28PM -0800, David Miller wrote:
> Actually, I had to revert.  Richard, please fix this warning and resubmit:

Thanks for catching that.  I found yet another case (not flagged by
the compiler due to the driver not switching on the enum), and I put
the fixes into v9.

During my audit, I also found a couple of other unrelated problems
with drivers' HWTSTAMP ioctl implementations, but I'll put those up
separately.

Thanks,
Richard
