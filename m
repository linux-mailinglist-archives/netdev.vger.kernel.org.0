Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC176CAE01
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjC0S4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjC0S4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:56:17 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8108D2697;
        Mon, 27 Mar 2023 11:56:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ew6so40213031edb.7;
        Mon, 27 Mar 2023 11:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679943375;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9kdFzEqP1sLEIpGSE6bD26PwKxdQuQNtb+UIdaFS6w4=;
        b=UGymmXiuIlLml8ijpf+xg6TTWxqyOmO29fMqond0Chl519oazCi6HipKFEmbHhcRyr
         kFd+NhLJL3R6Ik/DjNFUBBPD4ptYE7ntse3turxwUSZctRayA3G7gdNU+x0tvIG0CkdW
         HQqz5n0+Q3XHZoIBK58G+nO3yfnyykbwx3QREmxdBgiuTe7P7XF9W3K/q4cQDrlaB25v
         Zw+9STo270ZfEmqSBD/n63vOUPQnfgz9sijrU8Xni/DZsLb0HqhzF2VGIUYL+L6Kbllw
         aBno+V12LnQbwPUiyVYuvTpxZM/Whl0JoawAMyrj9U+fbAl62+noh7WAqEpTD6QuKnhc
         OiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679943375;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kdFzEqP1sLEIpGSE6bD26PwKxdQuQNtb+UIdaFS6w4=;
        b=JSnDKtWUCyhTx2b46w0YCs49Pra82ie8A40mc8EOBE9CY1hs96icN21ciXhEyXv3QG
         CSOLlycsJkDk/m0hrDMYyykTbpSCg3T6ywMOU4mwJRjhS5TLjkdHSlgd9LkvVVq/GAGS
         4Eo16qxTSAZVclDGOq/eJ8hbWuxIOMk+BMgI0jl+0i+7T3GpzGxM8n+l/W8TiqlYpTa9
         jMZNpsoOjWV2d/aE1sUhXJQQLAkxa16Sn6sDWNppRr3tMqqlyJac5Fe8l9QzzoSN8/mW
         dqHp1K+QLYWeyWYwXtMRDh5HRpYhCB9OsnTNgt9sE3PJFHb7zrs2U/J9yUbO506AygJh
         FYiw==
X-Gm-Message-State: AAQBX9fVGrs5QLUkNXfJmM9gKIPYdgqlYBfcn/xX4ausXFETARPeX5UU
        8HMIo3+cmkC1uAv7VS4GUfY=
X-Google-Smtp-Source: AKy350YAx3rW1SyuJCnBZhBxCFQ7rsS3Tq/yQDzMp69TUHeQbWPH6REg0eDj/nLcvQWAEZQjxF/XiQ==
X-Received: by 2002:a17:907:8687:b0:933:499e:62a7 with SMTP id qa7-20020a170907868700b00933499e62a7mr16565873ejc.49.1679943374605;
        Mon, 27 Mar 2023 11:56:14 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u27-20020a170906069b00b00923bb9f0c36sm14288264ejb.127.2023.03.27.11.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 11:56:14 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:56:11 +0300
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
Subject: Re: [PATCH net 3/7] net: dsa: mt7530: do not run
 mt7530_setup_port5() if port 5 is disabled
Message-ID: <20230327185611.gjwlrmhaiorfpj5q@skbuf>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
 <20230326140818.246575-1-arinc.unal@arinc9.com>
 <20230326140818.246575-4-arinc.unal@arinc9.com>
 <20230326140818.246575-4-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230326140818.246575-4-arinc.unal@arinc9.com>
 <20230326140818.246575-4-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 05:08:14PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There's no need to run all the code on mt7530_setup_port5() if port 5 is
> disabled. Run mt7530_setup_port5() if priv->p5_intf_sel is not P5_DISABLED
> and remove the P5_DISABLED case from mt7530_setup_port5().
> 
> Stop initialising the interface variable as the remaining cases will always
> call mt7530_setup_port5() with it initialised.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Again, not sure what is the problem, and how this solution addresses
that problem. I see Fixes tags for all patches, but I don't understand
what they fix, what didn't work before that works now?
