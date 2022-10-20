Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A4E606BA5
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJTWw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiJTWwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:52:55 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B2B21E109;
        Thu, 20 Oct 2022 15:52:53 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a26so3082704ejc.4;
        Thu, 20 Oct 2022 15:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L2G/9Nt1UPxsYT32uFvEw5BhWk6FA6rHpv/vvZ1BQSE=;
        b=L7KL7Cmq5BeuUdYGMW3cAgtIcuVZg5ASkJ/IZNJWWUiJ+/Qt6gVlScz1u/W2UurieC
         StTRCMiF1gayWtat9yR1jxy03jHzqPRpY+d/GgJ1K8lmNPRqj47kEmjBivrdxwcQlJRP
         gqfaCFKJCe0cSgQC/Xx9MVQoKg98NUMWFRqSK3/+nRYCXn1Q7yrGT4PHRNV43mZeBqb1
         cVtzyuggTcE1Pu9cpikwolaS6fyiZ1HlsdnyB5HAFFtEAPY8oUGlBvmr4xSRLlq7VRIk
         7rfYUfkbEQcY9aYc3JzsWSeJh1CqZ0CXrIEVX1+mmeRiMEa2Rwrz9msL2vRPepDcIKvz
         1T1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L2G/9Nt1UPxsYT32uFvEw5BhWk6FA6rHpv/vvZ1BQSE=;
        b=dhwJv04hCIZT/VPN6Q7cb18sc6g3DaXpAxwAirdY3Jaainq3iLmmALw0QK7+W8x1Ug
         1DrvGDOl5/TBlynCuatReW7AeCD14d7qdvNfJlf4WXLTRPgnUNFkhDul/7SMS62pw5zM
         kdJdeV/xy6blwtIxzhTswIVanGSesXNdJ7SxTBuOCzItM9Mtl2bOhHeLlcagY+q0xrAy
         nmtBW9KqdlFtkKXQ7GSlKkP1Bc2YWgn0yYFEqA7QxjMNZd1+UTiL8es7Q7drAR3iIzMV
         SRCUxBTZDQ8WU8GYRN8W+218f87nktmjZhNRUwzjmiRi/h68BdRqDe7ADhPuG8CUh3DZ
         2oxQ==
X-Gm-Message-State: ACrzQf0z1EcO+Ivt007VdVCWgmsCz3w8hz4dSAD8AGvIPh2oGf8zQ5KF
        TWGApTr4XvzhM9IHQgPp5iY=
X-Google-Smtp-Source: AMsMyM5+9yiqphjFjNrH8KW/esDJUp/n6M5wxHkOVHLIro1ZznSRDyfo73CoezEZIlBBqvJ8bUzutw==
X-Received: by 2002:a17:907:9602:b0:780:8c9f:f99a with SMTP id gb2-20020a170907960200b007808c9ff99amr12947250ejc.465.1666306371826;
        Thu, 20 Oct 2022 15:52:51 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v25-20020a17090651d900b0078da24ea9c7sm10939361ejk.17.2022.10.20.15.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 15:52:51 -0700 (PDT)
Date:   Fri, 21 Oct 2022 01:52:47 +0300
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
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
Message-ID: <20221020225247.acy4cejhcmtmf6ua@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <715c068915c9f07ad62d9837e70df7a1@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715c068915c9f07ad62d9837e70df7a1@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 09:43:40PM +0200, netdev@kapio-technology.com wrote:
> I guess you mean, why it differs from the inherit flag mask list?
> 
> If so it is explained in the update to v7 in 00/12.

The following is written there:

|        v7:     Remove locked port and mab flags from DSA flags
|                inherit list as it messes with the learning
|                setting and those flags are not naturally meant
|                for enheriting, but should be set explicitly.

Can you go one level deeper with the explanation? What messes with the
learning setting? Why are those brport flags not naturally meant for
inheriting?

It's pretty hard to take your patch set seriously if you don't provide
proper explanations.
