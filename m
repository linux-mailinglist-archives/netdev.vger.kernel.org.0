Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76066606BCF
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJTXBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJTXBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:01:01 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0251A6522;
        Thu, 20 Oct 2022 16:01:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b2so3085473eja.6;
        Thu, 20 Oct 2022 16:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KSyGYu5mB1+N4wjZMirWYKsm/OR0IsapLyRpo6UTXsY=;
        b=Q56oC/qBd5xz35WvyWQaS0SIowWdUGsQJGKXPYPkAnTa/HBtAJArmBFWpYa4LsxwZM
         dRlIx8DC4hBSeGgM//j/8NzY/dw+Mei+dUBUkDFIh3SWNbBNewoDZE8vZ/mFvCJkaweH
         0CKHQ+Vq2hMhLVz/iryTvkBEYh0mrRiBrB4oYDVCPYsjTyYcfL3/8OWk6wBEmwcnyunB
         bfZj7X3bwD0eLmPx25r+dHE2SgvNwcmrhiVxN7WFCmB6G9CggNc4ICHBDYecYO19eAPq
         BVOtx5Sl6l9g0jIebCbhH8xJIrdO3wx8ylyCdfSuAbVFe17RATgQJ8cNesesZpShl+Zx
         k8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSyGYu5mB1+N4wjZMirWYKsm/OR0IsapLyRpo6UTXsY=;
        b=772rIMpKKObUMlNT2FZl3N58UhovdTai2x6beGngYZ25DuYdTrFXXRcjclNAt8XU4N
         2ftvhNKjw4pfo//N6sA/mSoBb6GkiSH0TmAc0v6pqo3Jh8s9y25n/ta6qJsUGjnXUZv2
         soWjQvkhWF6E0Xxv56PuOtBb8KZFOSxYgTVT5KglI1SfOpL2pJ32MLNL2BR6c/YXgZ/S
         y8y7VPRqKIJ23OZqvXvTXISL27Gf0ZH3KEINFxL7VS7k5YAkxk8gqTnlaBm2dNDefYy/
         wrzVc6FqceSEGAM0Ku+yh4q2PH6lzXWlXwT3lokqNk8a3wWDpGvvmUlDUU6Y1Gl304wP
         bzVQ==
X-Gm-Message-State: ACrzQf0Ijm8XhVkmUrCK2MklpUqsK9mepHjjHrE0TpHsKbBxxLaRs+/e
        jIaqurxB8+q3ejcuzo3xDWQ=
X-Google-Smtp-Source: AMsMyM6W8HBBWWLJ65JA6laSIwE+MvNKCBJ9YiwTN1w3VFyEQBNnKUt3QnC4rR1yG5+HdC0wZCFkKA==
X-Received: by 2002:a17:906:fd8d:b0:780:997:8b7b with SMTP id xa13-20020a170906fd8d00b0078009978b7bmr13065061ejb.635.1666306858463;
        Thu, 20 Oct 2022 16:00:58 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id x24-20020a170906b09800b0078d46aa3b82sm10779489ejy.21.2022.10.20.16.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 16:00:57 -0700 (PDT)
Date:   Fri, 21 Oct 2022 02:00:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221020230054.542nmf66rvaswr32@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <3e58594c1223f4591e56409cd5061de7@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e58594c1223f4591e56409cd5061de7@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 11:09:40PM +0200, netdev@kapio-technology.com wrote:
> > Again, dsa_port_fast_age() is also called when dp->learning is turned
> > off in dsa_port_bridge_flags(). I don't want to see the mv88e6xxx driver
> > doing this manually.
> 
> Maybe I am wrong, but I have only been able to trigger fast ageing by setting
> the STP state of the port to blocked...

Maybe you didn't try hard enough? On a DSA bridge port that is up and in
the FORWARDING state and with 'learning' on, running "ip link set dev
swp0 type bridge_slave learning off" triggers dsa_port_fast_age().
