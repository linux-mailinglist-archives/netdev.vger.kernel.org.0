Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8EA69473C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjBMNmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBMNmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:42:02 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBEE7EDE;
        Mon, 13 Feb 2023 05:42:01 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id dr8so31871412ejc.12;
        Mon, 13 Feb 2023 05:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U6I/N8Drrl5cHxyvpTweuS2aXRAsTRiT9hQassySM+I=;
        b=B/sRO7dV5Zi3qNSLCw4IW0Zgl5IZEMUkqBSZ3iK13NuxbfWCudV//E8VMJmiZisodN
         q/gtTmJTMsvEq5XfEHv0gEa6bXm9iN2pVAIQu1bZ99eQSJRIVaegn9j+ab7gw7YZFz8t
         +QP6E8TwauPTQKPDkzMYfEnx6YtR1B2sx6V+bmD7RblxwZKNvw2/YXAV+hzHH1j2kTHh
         KtdhqDqrmH3pxuG+c+8x3HQAwRHirchnSofAAQdNyyaV2Sw4D5ifQ1pKKhjBMcIjz9aV
         KP9qlwou0q/jpgTuCTzvSGiDmXtS1SOUmuu0y62nK/KsXu4PRkU1xC57PbmgGO2G/5sn
         3REA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6I/N8Drrl5cHxyvpTweuS2aXRAsTRiT9hQassySM+I=;
        b=BEGF/tvanMtMkKoXcsYDk16SS6DQbvI/j8Q4vLvR43aGYKHqHqaF/VHEYoj2k5//dL
         0ajZDcsm7xegE0VmhCewUkb1Z04JmLPHAU30NXNVSsSOTm2WciIt67WvNGoUaQ4Tqs44
         AVvRDpcglg4W9iZuABmkfvZFpZW9r39g6MBDug9ZfGQGRv8zym0x56mIR6cjuoE9YRZi
         d6rR/pke9orZTOM84a08FDzM507CTq4YwOjECWzLU+AZ7a+bjho67AXBxQ9/mCXv+cD+
         JlfFfO53YxJrtwBCgo6C2H2g+yZYl49dgPeSVKFUWoWVC/9/reHGAxm3G5eO0TzF+Y7D
         r40A==
X-Gm-Message-State: AO0yUKXMDMGuhP0u5Md67VyQrPtceKaVfskCJIkTj+2J4pRM6UWpJ2kF
        DWWTpoA5lVhBAtZ7F3vFJ2Y=
X-Google-Smtp-Source: AK7set9tjrJ0ch+fz5ahGpelRBq75D8nllqGF8czYP1fSFJ5Lf8JJzIx8PMXukUk2qUoucx6YZqJsw==
X-Received: by 2002:a17:906:700a:b0:88d:ba89:1831 with SMTP id n10-20020a170906700a00b0088dba891831mr19627765ejj.2.1676295720045;
        Mon, 13 Feb 2023 05:42:00 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id f13-20020a170906c08d00b00878003adeeesm6784525ejz.23.2023.02.13.05.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 05:41:59 -0800 (PST)
Date:   Mon, 13 Feb 2023 15:41:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard van Schagen <richard@routerhints.com>
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
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] Do not add all User ports to the CPU by default. This
 will break Multi CPU when added a seperate patch. It will be overwritten by
 .port_enable and since we are forcing output to a port via the Special Tag
 this is not needed.
Message-ID: <20230213134157.k5ty4kko7xjhuvpt@skbuf>
References: <20230212215152.673221-1-richard@routerhints.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230212215152.673221-1-richard@routerhints.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

If Documentation/process/submitting-patches.rst does not completely
clarify, I also recommend running the "git log" command and studying
some of the formatting differences between this patch and any of the
patches that have been accepted.
