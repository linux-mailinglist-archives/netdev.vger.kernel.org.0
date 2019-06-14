Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405CD465A2
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfFNRXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:23:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42818 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfFNRXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:23:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so3324948wrl.9;
        Fri, 14 Jun 2019 10:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jzZPVNKvIqUnLAnTZJfqYcJAqoVMUTg4RgDz59BwLdo=;
        b=JpUb+/3G7vn8sY5/+Dq8rBZn6qOeoQXPV+rexL0ETfp4lK+SrRDqsnA+D6sfs03HIP
         2V7vH+Lo1K6UMwx2qBpp+XBifHJadBX/7WVFtmeHSfmVmpHFSPq2Ll5f6DAs3mFXdizh
         /qL33pIFXYLoUi1mNITzoX+PJQxiwD4pnkkCOQcWG2Bax5KlZEzONEtIyalouBOgxnvL
         tGgNfmMyFm7YYA0mwUDuE0kAH+LwaPy/BHiW7LOhQX0cdIoeqWwMk1cZwcbdOXSLgN99
         9qgR1hQCOwL5KWS94YPi/acIm1vwK2YyEVgoqJJ3bpFI+NYn7cH7fbvbDSKCZ1hhGiAY
         Bc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jzZPVNKvIqUnLAnTZJfqYcJAqoVMUTg4RgDz59BwLdo=;
        b=UjqZgpEkCd8ZRBGUvqGreOqckUzDgGS5qBrBvFV5QR2LuGD6zHhDG+R+4fd6OBe7H8
         SLS89mQR4SOui3bAeyhYqqPAXaawyQjvbxFodT7YfIc1MwXBqZQPtM4ect1NQmFntAt9
         Y/gsgZPjQkHKnlAyvfw08ocCbYfNI2bzRWVagRbGFZJxE3s0Fi+gZwmrLRRYaRSrdhhF
         l3fBghHs+Y9NVUQ6jmZE0sUd+cUyCVsKEtmY53y7AoutaWafPjGwdEPHlQeKa58+pMq/
         RP1/3S83jROyODGQRCtFkVxJEGTtPHeOhc7KgkRxchu2fubGbH5aeqfOel3uoEJx1C4n
         9HfQ==
X-Gm-Message-State: APjAAAWE1Vkkwr0Y8HItRHj4PY1t/SKwj78DsvB/WlkmEYyr5qJhdhWX
        ni854ky4MpEhepD59mFarKs=
X-Google-Smtp-Source: APXvYqzxYP1cbsOOCYPWmIbvJ1xl5Lko+tCkE0rpk+wdhu18dJhKiS/EwaA9FDMz67KxPa+Dn7N5Jg==
X-Received: by 2002:adf:8044:: with SMTP id 62mr17657298wrk.20.1560532996451;
        Fri, 14 Jun 2019 10:23:16 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r12sm4387641wrt.95.2019.06.14.10.23.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 10:23:15 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:23:13 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next] net: stmmac: Fix wrapper drivers not detecting
 PHY
Message-ID: <20190614172313.GA24955@Red>
References: <f4f524805a81c6f680b55d8fb084b1070294a0a8.1560524776.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4f524805a81c6f680b55d8fb084b1070294a0a8.1560524776.git.joabreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 05:06:57PM +0200, Jose Abreu wrote:
> Because of PHYLINK conversion we stopped parsing the phy-handle property
> from DT. Unfortunatelly, some wrapper drivers still rely on this phy
> node to configure the PHY.
> 
> Let's restore the parsing of PHY handle while these wrapper drivers are
> not fully converted to PHYLINK.
> 
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>

Thanks for the quick fix

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
