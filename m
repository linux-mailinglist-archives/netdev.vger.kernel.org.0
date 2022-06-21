Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093275536A9
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353167AbiFUPvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353129AbiFUPvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:51:44 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8F52CE21;
        Tue, 21 Jun 2022 08:51:43 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id o4so2843799ilm.9;
        Tue, 21 Jun 2022 08:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zBZb647A5JWWJ7wBT3x+zsfDMTyFWupMzBDefNrfeDs=;
        b=DS30ubZxgUz9LLQlV8/zuyl4hIa76tN4A0tWhwcdQtKE9KfI+D6i0W+0kzrEd2rUk3
         LeRFxUIHT65gDPzvPgZoGifWNfn5Vd+u2raTnWveQokaEcMpJ6+1ST311ywU/xVr+8nT
         j1kWzJfDMijceLUTV3R1VvPdmbIXCP+m+uAw8HYhJ5O4Vx4cuYV5E3wewNEvr/oWPBUq
         xNiHXjOt8WQ6LZYP7oZ7c96kzUURar3iwJAi5OFa1zTY89NRnKu6ZrQH0nvNxqiFYt0h
         db/fo9bEna509U2u+h2ZjkbQA5jduHMg3VS/XxdudbIcIYMuw434fjlrPvQ2RqmKR05x
         2o5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zBZb647A5JWWJ7wBT3x+zsfDMTyFWupMzBDefNrfeDs=;
        b=eXFhuCj6IzG35Y3dp95EPc/vqtwxpdkBxOIqCzzViesB2eamu92zbkIQG2cBlAPL14
         ABOJpCOtG6lqa+qgWcW4I8CuaHVbV6i3CCSod96eQs+NJaes1OyePQP9p93sflNIBfIC
         wZd/w4q+ZKPi3CY+wPk21gCXSnGZWySYSFENPNuZYJV3aSu5LyML8Thj43lDRo96quZ3
         WmIX4TaUrv/lQfFevOVboO+fZgq6r95jI9cuL9q6mzxYs4Yz9sjsD7E9QY7auVyjys6a
         6Kv3c+hhL9n6mLBaeIuL+x5Nj4OzgqoEEgo4U25iE+OmK96S/gRF4du3PPM5woaARa+Q
         AZ8A==
X-Gm-Message-State: AJIora8zE2QUgFxJujyl2nZaZ2FJMkboV+/jsxsVF6eW4+9PkxIqfZ3h
        AlGQ+ybgHd/BsJt9USTFz/A=
X-Google-Smtp-Source: AGRyM1s/9MidBaAVp7Fbd50I4g4VQ5ZhzFb1XLiaPlWucaSkRdWxcjs4t+J+9vIW/6a+qr3cPz3efw==
X-Received: by 2002:a05:6e02:1c25:b0:2d1:c551:65e1 with SMTP id m5-20020a056e021c2500b002d1c55165e1mr16525797ilh.246.1655826703290;
        Tue, 21 Jun 2022 08:51:43 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id s18-20020a02cf32000000b00331c58086d8sm643942jar.147.2022.06.21.08.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 08:51:42 -0700 (PDT)
Date:   Tue, 21 Jun 2022 08:51:34 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, toke@redhat.com, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Andy Gospodarek <gospo@broadcom.com>
Message-ID: <62b1e906cb539_13fa92084a@john.notmuch>
In-Reply-To: <20220617220738.3593-1-gospo@broadcom.com>
References: <20220617220738.3593-1-gospo@broadcom.com>
Subject: RE: [PATCH net-next] samples/bpf: fixup some xdp progs to be able to
 support xdp multibuffer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Gospodarek wrote:
> This changes the section name for the bpf program embedded in these
> files to "xdp.frags" to allow the programs to be loaded on drivers that
> are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
> the buffers, the packet data is now accessed via xdp helper functions to
> provide an example for those who may need to write more complex
> programs.
> 
> Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> ---

OK. Although we lose the non frag example, but I guess that is fine and
highlights we don't maintain samples.

Acked-by: John Fastabend <john.fastabend@gmail.com>
