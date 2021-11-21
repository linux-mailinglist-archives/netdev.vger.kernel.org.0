Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3400D4585F1
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhKUSkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbhKUSkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:40:02 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90150C061574;
        Sun, 21 Nov 2021 10:36:57 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so66879423eda.12;
        Sun, 21 Nov 2021 10:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CWMWQR2Fk6+1Fwg9OyzRWLxEs16TiBQAkR7gojx8NEI=;
        b=BpJNuMhYJs9WOihgjq/uPJ9E7uSLiiNTjX2avrTrAZOayAVMDD0yQpjChrL6fhPrrB
         HWfxO5g2Ss0FsTjFRy/h5eL949JVlGPoS+tERCIs1xWglc7VHUZAh4kUZSl5d0X0rVq6
         EANIL12FH69kAx/4qACNNDiwr3zaA7VobSImzbBot7uWyq9ES3lOqXeL2ZFfOGfmhwcI
         iTKinrx+H6PqRrw2Oqne/RvFdPc+nwaewvIc9R1MbuDTMjyhoFRScQr5AbOyGJmRGllp
         ybP+1pkFTu0aH9P4KR4NBZTUqvnez0eXpsKDI9NsaqnK+bNVtkY828sUP85KnyUraw8h
         mReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CWMWQR2Fk6+1Fwg9OyzRWLxEs16TiBQAkR7gojx8NEI=;
        b=1aWv6N02pe0NJfJuRZ/0fR8QSjjUOlGuZkEstv/D/L/nkSIfx+POFX+gX6YOv9l/FX
         dhhrzaI51bWLWmJs1fqq/jXy3FAWfXCmunJocATIipGEAneS4yenXJ1/VQjiVBJJC+65
         eZ5JOXaKxuwO3KtdtAH6wSGEQi5ZrnNbOzle7RHUN0JXN9amlgKJ40KlhijA3FJnzS9e
         xvwbT42jUJWyNtzXlAMFsZCV2l2F5LDGeHtEHMuzCJwcBRmBp04yLNanncVTEVrSDOx+
         bH4JgU6gAIa0yu5QxqrH+yp7pTXwGqZyqwnAMto6aQlDX5WmXTH49pUazhbydm8GgOik
         8S5g==
X-Gm-Message-State: AOAM533kfyFh14vtkUdazyccadTnmblTWhIvtcGV1D4cRA17ZaXa0A+H
        bch1IxuzlSGK8DJ26hG3XdU=
X-Google-Smtp-Source: ABdhPJxs2taMUELpmnL8h151n9HHy6iuhjCAJQQKYqzWuuq3tuAwJszMEzwVEmbetN1L88rJxLdHCg==
X-Received: by 2002:a17:906:6549:: with SMTP id u9mr33473354ejn.514.1637519816158;
        Sun, 21 Nov 2021 10:36:56 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id z22sm3002685edd.78.2021.11.21.10.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:36:55 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:36:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix internal delay applied to
 the wrong PAD config
Message-ID: <20211121183654.yifgatrkxnepsp5a@skbuf>
References: <20211119020350.32324-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119020350.32324-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 03:03:49AM +0100, Ansuel Smith wrote:
> With SGMII phy the internal delay is always applied to the PAD0 config.
> This is caused by the falling edge configuration that hardcode the reg
> to PAD0 (as the falling edge bits are present only in PAD0 reg)
> Move the delay configuration before the reg overwrite to correctly apply
> the delay.
> 
> Fixes: cef08115846e ("net: dsa: qca8k: set internal delay also for sgmii")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
