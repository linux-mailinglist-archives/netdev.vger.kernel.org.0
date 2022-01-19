Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFB44932AC
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 03:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350835AbiASCEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 21:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350843AbiASCEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 21:04:34 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EF9C061574;
        Tue, 18 Jan 2022 18:04:34 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id p9so1274884qkh.3;
        Tue, 18 Jan 2022 18:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=++gAg+l0dN/7B7vv6NjXKWxl8eRkjPVp8VF/W6XAH48=;
        b=qIbZjUOjgsyq3RDMrd53p9/2IkNve51ftq1huuVJlh6tE7vUnupVpSUJXVn4NFOmqd
         3fbMWzt7XlAJQU6fo3pTlWpx7hPgqbDSvklbRhWkEux2Piqgy3AQlk0ui0mLPPEG9NPj
         9ix44G9XGNVm1l4ns4NXFPpwNkl9lbeu3w+raWCbnUx88QwVRrfPd13yrAogDJWqW+yo
         Kv5fvBNCyz/slme/Cku12Czn6c6lqvYa8tF5keGjBUkM4sbUxwNJl6AqeKZ3n5DpBRKW
         WjHkH1N3o5qx++0lah0zOEWo26pjTaEk+IuSaghm1SpI+1YJL47baQiI8EKXMbLT9V9L
         LdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=++gAg+l0dN/7B7vv6NjXKWxl8eRkjPVp8VF/W6XAH48=;
        b=2OkD0k2ZnlCSoHqKPYCovpm7ATZcVJ4me2k3KSzheqXcelNmHTLYc9oVXhmxdgSeDX
         iwQQrZAKM8zMnRNCDZMY1f4WT/YugZz7M7H8joKLomEwLz3OUBgIM9mv+7x+Glou2lDj
         wL+wJ/tC6s9EEflf+FRZmKHpEnmw98THahDjSwyrJMAIhHJ9lGbQ0jp5oiYbeHENHp4p
         k9rZjYXGbbHX929Lp2dRCgFkbVySMXMoACrpIc/x4sg4/6gNlElFo2t16Z2CLrua1/X/
         u+ltD21qNyxzo4EfZ3RvYt4Mkmf21tXeah5H5MYQrKuevtguLENKO2XhGfvVGeA2Y+1g
         jybQ==
X-Gm-Message-State: AOAM530qQ/EbO+vUbNjlSvzUZ0PCr6HNw13ST+czpYroDHd5YNoB6/jj
        VB2jiIcA0YSLyg++4GQTIig=
X-Google-Smtp-Source: ABdhPJyOnunO+GeIz4tAdGx9vUTvZUmec5ggQsTIda8EZTmduN+ZerZqvwBHMJs2byK+fi3GSwrZoQ==
X-Received: by 2002:a05:620a:410c:: with SMTP id j12mr5901891qko.636.1642557873672;
        Tue, 18 Jan 2022 18:04:33 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o4sm5121072qkp.105.2022.01.18.18.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:04:33 -0800 (PST)
From:   xu xin <cgel.zte@gmail.com>
X-Google-Original-From: xu xin <xu.xin16@zte.com.cn>
To:     kuba@kernel.org
Cc:     cgel.zte@gmail.com, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xu.xin16@zte.com.cn, yoshfuji@linux-ipv6.org
Subject: Re: Re: [PATCH] ipv4: Namespaceify min_adv_mss sysctl knob
Date:   Wed, 19 Jan 2022 02:04:27 +0000
Message-Id: <20220119020427.929626-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118112148.3e1acad4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220118112148.3e1acad4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > Different netns have different requirement on the setting of min_adv_mss
> > sysctl that the advertised MSS will be never lower than. The sysctl
> > min_adv_mss can indirectly affects the segmentation efficiency of TCP.
> > 
> > So enable min_adv_mss to be visible and configurable inside the netns.
> > 
> > Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> 
> CGEL ZTE, whatever it is, is most definitely not a person so it can't
> sign off patches. Please stop adding the CGEL task, you can tell us
> what it stands for it you want us to suggest an alternative way of
> marking.

CGEL ZTE is a team(or project) focusing on Embedded Linux System. With
the support of the team, I can devote myself to the development and 
maintenance of the kernel and related patch work.

I'm not sure how to mark it here accurately. I am willing to hear your
suggestions.

> # Form letter - net-next is closed
> 
> We have already sent the networking pull request for 5.17
> and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
> 
> Please repost when net-next reopens after 5.17-rc1 is cut.
> 
> Look out for the announcement on the mailing list or check:
> http://vger.kernel.org/~davem/net-next.html
> 
> RFC patches sent for review only are obviously welcome at any time.

OK, thanks a lot.
