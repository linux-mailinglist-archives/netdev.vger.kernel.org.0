Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD343553A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFECZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:25:52 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:35735 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfFECZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:25:52 -0400
Received: by mail-pf1-f176.google.com with SMTP id d126so13913035pfd.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 19:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Rm5dZAs+aVhJQMUa7wbZZA6Tf+1dhoq3D+GnrhZV+0c=;
        b=MH5cmAEiyyqp/9oQ8moVImZjns0Ib6HEWie9Jbe33rwSY+kaQ7IWceoR99LYkim7sS
         WV7F3Jf0g1RgyMNgcngTIpbtOGKQg/7lXjjzB6YZ1rKbZk2OWo77IEOmr4Gdg1pw0R0C
         vWRcz0EU8pfec9wEhyENZxff02tfgAMA5jjo273O4iG1VsIvVX+ao18WqUFOAWvodLv5
         0EhNNMeK+bThfarhaMn4XOBPGSV+9s/V0LThJXjWVuekcupG4/mXDC0tAxATxH46OITt
         JkwlQD1VYYouhreiijtnQlGclV278sJLxewqOeVqid/nYCQuV/tR5A0+tT+KUR6e44yq
         rKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rm5dZAs+aVhJQMUa7wbZZA6Tf+1dhoq3D+GnrhZV+0c=;
        b=VC95ERefGtsGRmm3IEsqwYJISzlaiQcqjpf70OUVyPIKsGnAJbL2ud0tNU/FWOzbFR
         YgyslyJCl0xxWbi1euGSqFyvfTpSUvhTzYkvQMmRlc89NSIS5l3GnLdVw3ff39GCZrTn
         N7iJE2jt6wrKTSa4TMY/QV66YJW7TZvwNs6hqphucVv0EueU92YBof4EQiPbTspHsLCp
         7l8LSSUUfyO5nG9Q/GFfJJQ8Z3tvpu6bFdyM3SbVbTg8xUu2+0T1fOKc3feEu67hRQw7
         G+Qxi1t7XKrZ3tEyPn/CvMKiyaSOWOVGOesvvK988NmYWJmi/qZAVP/DqssCo+1rfYfZ
         WauA==
X-Gm-Message-State: APjAAAW8xichkW/Vt0viiwi5VEzN31pXrP2gSOmGKxs6wI7SyBrKKZUi
        S4Tzd8Hxvyq+kr6yC6M4K+g=
X-Google-Smtp-Source: APXvYqzWkRJppz8FfPjJEc0+cMw/7CVGzBV1wqcPaeSn/ZyORHI7cH+YMSGHNo5Ts98rNQxQgrUibA==
X-Received: by 2002:a17:90a:2ec5:: with SMTP id h5mr40127931pjs.93.1559701551018;
        Tue, 04 Jun 2019 19:25:51 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id i22sm19113591pfa.127.2019.06.04.19.25.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 19:25:50 -0700 (PDT)
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604213624.yw72vzdxarksxk33@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <33c5afc8-f35a-b586-63a3-8409cd0049a2@gmail.com>
Date:   Tue, 4 Jun 2019 19:25:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604213624.yw72vzdxarksxk33@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/2019 2:36 PM, Russell King - ARM Linux admin wrote:
> Normally the PHY receives traffic, and passes it to the MAC which
> just ignores the signals it receives from the PHY, so no processing
> beyond the PHY receiving the traffic happens.
> 
> Ultimately, whether you want the PHY to stay linked or not linked
> is, imho, a policy that should be set by the administrator (consider
> where a system needs to become available quickly after boot vs a
> system where power saving is important.)  We don't, however, have
> a facility to specify that policy though.

Maybe that's what we need, something like:

ip link set dev eth0 phy [on|off|wake]

or whatever we deem appropriate such that people willing to maintain the
PHY on can do that.
-- 
Florian
