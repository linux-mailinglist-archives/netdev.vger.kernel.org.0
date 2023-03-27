Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177826CADE3
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjC0SuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbjC0St6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:49:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527931709;
        Mon, 27 Mar 2023 11:49:49 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eh3so40123745edb.11;
        Mon, 27 Mar 2023 11:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679942988;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WV8Ob0uf4bBIKDlLtZZnzrbTAhR4hy3V64r28D4o5YY=;
        b=Gqu/bFJ31hSb6EVqByUP2G55oy+x+jxUsnrUTS9y/idimRggaf3K4hUFSzP+hG9MRI
         sQfcvDM5RNFMd5ZDGyrznKLDx6NMzwD7SsllmCmntS4xXcKolnrK4SYXEncVSWCjcRRL
         ncut7EiyGFCMxso6b2qPxijfjp7cdtfRPUII5fzp4l31zRGZtGd+VwfkUzSowqA3Htq3
         wokXFQRRkH7XOQAtjUDnqjcxcfpQ4e2MyXfjc3NKEGCddkxy7hiCNDfUBbZlUa001tt9
         qJl1aqUEQ31uhApIu1qt02Lh8KzRABWxTuZGK6rcjgkuclGDQYi++LLK5FyNx5RdjYxN
         3YFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679942988;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WV8Ob0uf4bBIKDlLtZZnzrbTAhR4hy3V64r28D4o5YY=;
        b=u+QRZTsPPqtqxn1vpFf3vDt3wXRwbdl8izk2rPMHvQNVqPFVmNj6umjeHoyL0KiZFn
         bG38/BNDbnOi+kB7ekTuMPn26bipUa8OOfhlWxiugGoSgMawaW0sEo+u+J6oQ4HqKAR0
         YBwnPDDfTOCmGxXBWHh5o31ezXfVBrVy0KKfEzRd4gXMW/KIy8oh4Ua4YjoMfAEVhJOy
         hBMYsJO5NrytxbI2ROBuDad2nrWE5CEYBeVUx9Dr0ouDQ6R4cDGmAH76ZMszYoJgz/4l
         G+Q0fterqVpG0rgYy6xgpJM5naIeP7SE1h46OeDQbddJByHJsV48qxaFy+kl3y4UdHx7
         8YQA==
X-Gm-Message-State: AAQBX9ej6CWIGn5ZJdfw6wI360tXXX5RxLrIcDynjyCBCRIfw3ICoouO
        LXP6Uu7D952v1Q5jg7c6acQ=
X-Google-Smtp-Source: AKy350YOQCzEGffLYub7F2SVGrQDvP3iDvPNDUkaIZbZqUsO6bIeX5ddq3lF1+dztJqbY3lmGpgvpQ==
X-Received: by 2002:a17:907:8b88:b0:925:f788:d76d with SMTP id tb8-20020a1709078b8800b00925f788d76dmr13593874ejc.27.1679942987666;
        Mon, 27 Mar 2023 11:49:47 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b26-20020a170906195a00b00930a4e5b46bsm14301659eje.211.2023.03.27.11.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 11:49:47 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:49:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
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
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 2/7] net: dsa: mt7530: fix phylink for port 5 and fix
 port 5 modes
Message-ID: <20230327184944.oahce2iizpauw4nm@skbuf>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
 <20230326140818.246575-3-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230326140818.246575-3-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 05:08:13PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There're two call paths for setting up port 5:
> 
> mt7530_setup()
> -> mt7530_setup_port5()
> 
> mt753x_phylink_mac_config()
> -> mt753x_mac_config()
>    -> mt7530_mac_config()
>       -> mt7530_setup_port5()
> 
> The first call path is supposed to run when phy muxing is being used. In
> this case, port 5 is somewhat of a hidden port. It won't be defined on the
> devicetree so phylink can't be used to manage the port.
> 
> The second call path used to call mt7530_setup_port5() directly under case
> 5 on mt7530_phylink_mac_config() before it was moved to mt7530_mac_config()
> with 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a
> new hardware"). mt7530_setup_port5() will never run through this call path
> because the current code on mt7530_setup() bypasses phylink for all cases
> of port 5.
> 
> Leave it to phylink if port 5 is used as a CPU port or a user port. For the
> cases of phy muxing or the port being disabled, call mt7530_setup_port5()
> directly from mt7530_setup_port5() without involving phylink.

You probably don't mean "call X() from X()" (that would make it recursive),
but maybe from mt7530_setup(). But it was already called from mt7530_setup(),
so I don't understand what is being transmitted here...

> 
> Move setting the interface and P5_DISABLED mode to a more specific
> location. They're supposed to be overwritten if phy muxing is detected.
> 
> Add comments which explain the process.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Sorry, I didn't understand... so what was the problem, and how does the
movement of the mt7530_setup_port5() call that isn't under phylink solve
that problem?
