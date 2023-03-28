Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD56C6CBD56
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjC1LUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjC1LUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:20:08 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DCD19D;
        Tue, 28 Mar 2023 04:20:06 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id q7-20020a05600c46c700b003ef6e809574so3887957wmo.4;
        Tue, 28 Mar 2023 04:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680002405;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fAQImpnQP0GAv34nwxb4A/1+q39BUDZ/O6A+p8S3rBY=;
        b=H1MABtWfJIUIayq6bepL/MKgHiFtHlkQyfEpqGH9thGfkT7r/KkaJlKniNP0Gl29Fc
         CFeYEvToTOk9UZ07hZlWCLDPrvadWy56lUuR4J1ldz/5r/4+5CUGSbWMP67yI5+mqUkT
         3j0Q9/bjnLHlNks146DA+DdiM/uGLJrzz2X3FYJDp0iZ5FjZDSR2jjYUDTYYHg+5Ury4
         OVLUtndAwAnMACSb0VzKxRRkh+YraEAsImxIW0enn5jda3VSUy8+2t8G+K0FBjNQ3xOz
         3ZWmBsbw+RXcfwxqWfZucUclJ9/u+xjCnW89QH03j1ekX47HDjWdaBm5nBttSrCfMPcm
         hodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680002405;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAQImpnQP0GAv34nwxb4A/1+q39BUDZ/O6A+p8S3rBY=;
        b=3VklrEfLV6kmwaKrAWRJ5YkGQNE3CyJuwl4WAhhdNu2zBuVPyRyz93P2rOUYTM5IgQ
         j7M8n3IsNao+E4aRdoE/3QrirPHLdOZIPdZJTPWFMy8C6dCmsyTrA24OzCBulUFQAQMZ
         1F0+kaiFgCFgd2K4lW+xcrWqlwQuE/bICNFmD7TDmYK2EqEkLPbFH9WyrT6ksqvGIpI+
         bPmhJ1KMIXRUQ0/JQ8gB6R5VwidoAg/o31PeKJw9FSBfXXvmwSfmoKCf/lb9vvgLUCix
         mOHHuhNbv94Kw1Y76xw4DrvWH9AqxdP18STenmX1e7B4ZXP6wzjlZhFSKhoVgXPm+Ruw
         ZvwQ==
X-Gm-Message-State: AO0yUKWNk10iK1IHznrdzUzUVZKGy+qMWQ4iw2rhCszxm9RAQXZZ/2HC
        +98G1BnKCFFq0Z6WecoI0LQ=
X-Google-Smtp-Source: AK7set9sW2CNkTzeBb1i+Tw8DSAJQEexXoH1tDNeUkgCs29kSQhdJ4uChgVBKJKZ9buerEsJ7QTfWw==
X-Received: by 2002:a1c:4c13:0:b0:3ee:a492:e95e with SMTP id z19-20020a1c4c13000000b003eea492e95emr11763199wmf.6.1680002405248;
        Tue, 28 Mar 2023 04:20:05 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id fc9-20020a05600c524900b003ee2a0d49dbsm12523567wmb.25.2023.03.28.04.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 04:20:05 -0700 (PDT)
Date:   Tue, 28 Mar 2023 14:20:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 4/7] net: dsa: mt7530: set both CPU port interfaces
 to PHY_INTERFACE_MODE_NA
Message-ID: <20230328112002.2p7r6estix3dpijm@skbuf>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
 <20230326140818.246575-5-arinc.unal@arinc9.com>
 <20230327191242.4qabzrn3vtx3l2a7@skbuf>
 <8450084e-1474-17fa-32c2-a4653b74ff17@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8450084e-1474-17fa-32c2-a4653b74ff17@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 12:57:57AM +0300, Arınç ÜNAL wrote:
> I don't appreciate your consistent use of the word "abuse" on my patches.

Consistent would mean that, when given the same kind of input, I respond
with the same kind of output. I'm thinking you'd want a reviewer to do that?

Last time I said: "It's best not to abuse the net.git tree with non-bugfix patches."
https://patchwork.kernel.org/project/netdevbpf/patch/20230307220328.11186-1-arinc.unal@arinc9.com/

If anything, Jakub was/is slightly inconsistent by accepting those previous
non-bugfix patches to the net.git tree, and then agreeing with me. He probably
did that thinking it wasn't a hill worth dying on, which I can agree with.
But I'm afraid that this didn't help you realize that yes, maybe you really
are abusing the process by submitting exclusively non-bugfix commits to the
net tree. There's a fine balance between trying to be nice and trying not to
transmit the wrong message.

It would be good if you could clarify your objection regarding my consistent
use of the word "abuse" on your patches.

There is a document at Documentation/process/stable-kernel-rules.rst
which I remember having shared with you before, where there are some
indications as to what constitutes a legitimate candidate for "stable"
and what does not.

> I'm by no means a senior C programmer. I'm doing my best to correct the
> driver.
> 
> Thank you for explaining the process of phylink with DSA, I will adjust my
> patches accordingly.
> 
> I suggest you don't take my patches seriously for a while, until I know
> better.

Whether you're a junior or a senior C programmer is entirely irrelevant
here. I have no choice but to take your patches seriously unless otherwise
specified, in the commit message, cover letter, or by marking them as
RFC/RFT (but even then, their intention must be very clearly specified,
so that I know what to comment on, or test).

I don't think you really want what you're asking for, which is for
people to not take your patches seriously. I recommend forming a smaller
community of people which does preliminary patch review and discusses
issues around the hardware you're working on, prior to upstream submission.
That would, at least, be more productive.
