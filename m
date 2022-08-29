Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454765A4F6B
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 16:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiH2Oim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 10:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiH2Oil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 10:38:41 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC1397527
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 07:38:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id l3so8181939plb.10
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 07:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=I+cBHGDccWtAyYl3QUfVv20NcAk88LIFskgL4QvSfkk=;
        b=McSuuimZqnqTkNmxPjNMo0MQvkN5aW9oUmXylM4U08rHIuXlQM4z729e33xWAaduMX
         6vNa8M/181WGjh1fkv5VKXrcaf2eCIUVyK8fQpixeim6nMSKZH/F4zqdE6SlPb7+HsUO
         XAE0iZ9jAq8Yn/f80Ki5dSXt8mZULrwkZFTy+vuI2JK5BJnngUAK9E29hUJIOQ6vz06S
         JURTQGdfg1/tgIqdNnKY3c7vZVBIdclp+ICzLY+rd5WWAccD4sLEue5s8P3M/BL4QHl5
         MoBRNm7HFakK4JP1aIPEQAbzoK9UP/fnCjXJCdojygl6VvSUwV/0aje1HrVJ2eDMMWUt
         RBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=I+cBHGDccWtAyYl3QUfVv20NcAk88LIFskgL4QvSfkk=;
        b=ITUJx1Jo0rc2XGzL6MGEwseZ6LeTxigtMXbRiIbEP5HuHP2PnV6Le6bm/yA7EVjv2h
         rUm1wkEBC+xdEZj/aqaFHU9JH2xVKQyEm7myosTJua4cHns+Q1vj+6dmB/7T37Xz0D/c
         XfZx5q9qXg1nVHTiXQS9paPC8DW3xqyJD8oxoo/zcrdI1J7X5X6ZM0VkE4LUnM0IX1uf
         oKeANmKwt/siB8uW/jdDO/wntOvKoAdHaICxUInI33/26B7Rou1z9DocIgocJ5fcrU9K
         tueKqrPt8xSErJOJ42yfbRWfg5K5ZlFNC1pooGb//3PKrcn0G6zg44+e/W6+wwyhd1EW
         ql+A==
X-Gm-Message-State: ACgBeo2naKHX7LuqkVv4OregxUj1zbc8tndJ4uVoxXgCeLEV2PoC0X0f
        8mt1Au7XZLX1NQxKJvHZn6Q=
X-Google-Smtp-Source: AA6agR6wHsZcPgDu3foR725dtQKXxzfWnPM6IwaSSMmi9z2FBqdXusHarhzU7GkNPCcfvyumY2PCqQ==
X-Received: by 2002:a17:903:2449:b0:174:f61a:17b1 with SMTP id l9-20020a170903244900b00174f61a17b1mr1974029pls.95.1661783919435;
        Mon, 29 Aug 2022 07:38:39 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902f54800b00174b337c0ebsm3220950plf.163.2022.08.29.07.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 07:38:38 -0700 (PDT)
Date:   Mon, 29 Aug 2022 07:38:36 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] sfc: add support for PTP over IPv6 and
 802.3
Message-ID: <YwzPbIxDOaC5h1pK@hoboy.vegasvil.org>
References: <20220819082001.15439-1-ihuguet@redhat.com>
 <20220825090242.12848-1-ihuguet@redhat.com>
 <YwegaWH6yL2RHW+6@lunn.ch>
 <CACT4oufGh++TyEY-FdfUjZpXSxmbC0W2O-y4uprQdYFTevv2pw@mail.gmail.com>
 <YwjB84tvHAPymRRn@lunn.ch>
 <CACT4oudsW5LNdwDbaKK7=DX9wiPua1cYdQ7DLuRsNoZmV8=tmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oudsW5LNdwDbaKK7=DX9wiPua1cYdQ7DLuRsNoZmV8=tmQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 09:09:48AM +0200, Íñigo Huguet wrote:
> Richard, missed to CC you in this patch series, just in case it's of
> your interest.

I do appreciate being on CC for anything PTP related.

Thanks,

Richard
