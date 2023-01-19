Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCC067347E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjASJeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjASJeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:34:04 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EB15B84;
        Thu, 19 Jan 2023 01:34:03 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s21so2070203edi.12;
        Thu, 19 Jan 2023 01:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5Ge8uyMAXwH1kNbVoLVJMz5md/YXC3qDG0uqYv7JLg=;
        b=pY+ceUT5z37uTU7Y1gqA8WAVoJkOmuKK/1C6ouoZ6getUO4DtNM6wxQRLx5HwaCGMt
         acn3C1Co/vL2ciJLZY5ai84WZ4tmqecAFLJ1NBFpeDPE7MKbG129/AA+YIwvFAJAyDhU
         RdCAKmEb1uZvhlsDXlDbaDESg9tc0nTWVNi+ab5tYEITZrWBpqXAK6aP58qNNuWDYD+t
         OXeZalhSPmSHmVQSiRt2lLOoIRyvnlKMyGHl3NE0wF8O0EEPsMCp4vipxaHaFMxW78fz
         fdsOQ/t9jZ5sjLj881ECBUdsuF3BuGoU71VZOvxst6tRH0wSRVCbbukt9r/PGqLna/KP
         xXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s5Ge8uyMAXwH1kNbVoLVJMz5md/YXC3qDG0uqYv7JLg=;
        b=U+24cGaDPw4V+PIfihkgF4tb4gaoyGTXV7vK2W0VbXHyegN6m7da39VGXmrfqr9uM0
         WRtafYALphpX9pqYT32mDwNJ8/+c9aGsV7x1Vz8rmJtDOJwl8+6Wgp/TS+ZzWh43hqro
         paTJjOKfeWiEHG7bUBp2PTR1WOwWjVmFhZabgt5mOBWCOw8dSU+9ltFKplK4fF2WtrqD
         OE1xIBE8zuDyhdc/AumkzJHbZ4mr+kVkZk16duVs5Gpm3CD/YnOf9g6+ZZzJDMZ35yhd
         zb0Kk8S7yaTNRr21Q9bdxCniPFpSNFy8lskM7iFmhOm4YKSYfcXal//TvlNTERiVYMD+
         +erA==
X-Gm-Message-State: AFqh2kpXDghKAjwIVIJVVSFQhItM7n3hhKekgZOGqLGhEZ8Ai+o5cTzx
        lAFTP1+izgrCApkXPEZ41uQ=
X-Google-Smtp-Source: AMrXdXv/p9J+0LyxznivegZqBjv5p2sBwAfu5EYNt9IzkrSAyvVgO9ZtOW6iKd8IcEA7ooqkwi9I1w==
X-Received: by 2002:a50:fa8f:0:b0:49e:31d5:6769 with SMTP id w15-20020a50fa8f000000b0049e31d56769mr9558722edr.41.1674120841563;
        Thu, 19 Jan 2023 01:34:01 -0800 (PST)
Received: from skbuf ([188.27.185.85])
        by smtp.gmail.com with ESMTPSA id fd7-20020a056402388700b00483dd234ac6sm15055718edb.96.2023.01.19.01.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 01:34:01 -0800 (PST)
Date:   Thu, 19 Jan 2023 11:33:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [RFC PATCH net-next 1/5] net: bridge: add dynamic flag to
 switchdev notifier
Message-ID: <20230119093358.gbyka2x4qbxxr43b@skbuf>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
 <20230117185714.3058453-2-netdev@kapio-technology.com>
 <20230117230806.ipwcbnq4jcc4qs7z@skbuf>
 <a3bba3eb856a00b5e5e0c1e2ffe8749a@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3bba3eb856a00b5e5e0c1e2ffe8749a@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 11:14:00PM +0100, netdev@kapio-technology.com wrote:
> > > +	item->is_dyn = !test_bit(BR_FDB_STATIC, &fdb->flags);
> > 
> > Why reverse logic? Why not just name this "is_static" and leave any
> > further interpretations up to the consumer?
> 
> My reasoning for this is that the common case is to have static entries,
> thus is_dyn=false, so whenever someone uses a switchdev_notifier_fdb_info
> struct the common case does not need to be entered.
> Otherwise it might also break something when someone uses this struct and if
> it was 'is_static' and they forget to code is_static=true they will get
> dynamic entries without wanting it and it can be hard to find such an error.

I'll leave it up to bridge maintainers if this is preferable to patching
all callers of SWITCHDEV_FDB_ADD_TO_BRIDGE such that they set is_static=true.
