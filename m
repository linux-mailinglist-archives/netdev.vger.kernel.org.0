Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C150060614A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiJTNQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiJTNQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:16:09 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAF018F928;
        Thu, 20 Oct 2022 06:15:55 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l22so29837197edj.5;
        Thu, 20 Oct 2022 06:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmxhzVAL1YB+RE9j89rBigO8T8NiP9SDGEamja0kPTU=;
        b=mtCezQ/4ENLZOEF1WPhS7b4U4jsIGRd8/PAJOEm4TbfJXF5yRk8XLRAdPGb1rZLIEM
         p/oxZEQmdwWqqUzKL/pPjO8GgLAAJ5r5hhmM34UPgM2OefKojgPmrTT91upH6Idws/FY
         ggCCKG5kyBEaOPcLbYuFVfsMgl9HGFLc9LowwDzC/70CU5++MaQRW0jxIwp/MtZ4Njb8
         g7nXKV6aP1OMxofbQWswWF1s7ZavDCGMKolxCBlolWPqeoVZ0K9oZ3YFJ8cdDNSNXlQs
         Rv487MwL3WQScTQ1iSPS1IcoxpYanEBF8b2q4R5j1hQiKwsY70oHAanDE4HAvgVLUdTa
         gBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmxhzVAL1YB+RE9j89rBigO8T8NiP9SDGEamja0kPTU=;
        b=b8+XNYleBO3DSdPeAf8Kbaj8PGFZtme+5dAnPx86XhTdsD5KdBHc0ir1MPE6MGyFrh
         YjFWW2jMWRFPR6RAGBRgOORIx7RE8Kn6tIv11PZDnKWgKx8FMka8c49wCK5Ot+xCj4gS
         spsmRevf2WUhhaOqtUkFTuaW7EpOp591xR7mtezZy/aWot/D6ypjdKtdgCNpckMRAEAv
         UXFX5jjcDO+FBSkw9iF9Xweto8Aqjz74g30fYE7hbb+I1DtDJ/4t3y97nAtVie3J4T8Y
         PW9K4N6sl/tpYuUZ4k+ouLqZXzO3TSSNAawEDCoOaT4IMOhKtANh1YztKVxXfocKohd6
         OuVA==
X-Gm-Message-State: ACrzQf0duL60TQUIxZF6inPfCVryaCUCOOVKiYwJAbBdiH4T+rB2okBB
        Ar5TfR8p0hDAKyWizcI/cQs=
X-Google-Smtp-Source: AMsMyM4Ro4f7VYfhx3De04CJsNdaKBFDdssfYHLOp4Ppvmyr+30/eGDqR8g/m7v0AgMhLMN1ZRJjHw==
X-Received: by 2002:a05:6402:d75:b0:459:fad8:fbf with SMTP id ec53-20020a0564020d7500b00459fad80fbfmr11979743edb.0.1666271546990;
        Thu, 20 Oct 2022 06:12:26 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id p7-20020a170906784700b0078d9e26db54sm10373833ejm.88.2022.10.20.06.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 06:12:26 -0700 (PDT)
Date:   Thu, 20 Oct 2022 16:12:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
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
Subject: Re: [PATCH v8 net-next 08/12] drivers: net: dsa: add fdb entry flags
 incoming to switchcore drivers
Message-ID: <20221020131222.fzgq7ashy6cdatyt@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-9-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018165619.134535-9-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 06:56:15PM +0200, Hans J. Schultz wrote:
> Ignore fdb entries with set flags coming in on all switchcore drivers.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---

Some very thorough documentation in Documentation/networking/dsa/dsa.rst
is necessary. I'm interested in seeing what those flags are, and what
are drivers supposed to do when they see them, other than ignoring them.
