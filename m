Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3CD4FC171
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348268AbiDKPvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348265AbiDKPvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:51:32 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5581024A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:49:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bh17so31758702ejb.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7HMEzWbN7ITXolnBsGkXpOFUjmkBFWZ9jNPVuIYfuxc=;
        b=NpzAZqrtSceEtPtYVhrpsRCrKKSzk4tY7fhs3P7iVIOVCb6GMY/l+GNYZYa/Vdz+9w
         fn9kmYAeQs5ehZ6lVGJbHmiiZYJaqkWQ05GXHCAcfdkRgbEkQMLp9dQEmR5FVZPUMUcE
         44oGNHPQZeLwKIM4Ki+0zuwuMQ4bVrnz2js2kzy6Et9e47NRVN0NcEnRtN9kTPc+3MQ2
         /8WWhs3fwcO0bmeruHomEgztlKS6QCWRFqmMFduPLDsf+VKPa6OnwNDIgdQG0ZrQqZu7
         +mICKJ5LNCpePwINVVUhJPrgqwe7/J7bI+WY2RnBRd13d/eo3WEFYmCFSvKSnMhK29Uk
         pBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7HMEzWbN7ITXolnBsGkXpOFUjmkBFWZ9jNPVuIYfuxc=;
        b=jNDBuddbssTanJXBstXOFLI1txKFdwqm+jQ/no9mW9kjpXpm20qXjW4Dqv0VMoWWIK
         OAy7U9FmTFJC0WrO23qciGwrBDfY9+wRqeOqSy8zmQXa7tIUwNY2UfTQalNuhCfuTKK4
         oivRVDkTgGY2ZV4kYXbe3z8rVENddoyyJ0bIMQFVlgTC3Zna4AUAueyX52645fAeYy6h
         +Xap9jt/w5UqjhW41GTFf/Oppr48VKE6G7ono35CFCZ/YItoyqNVaPsBRjW018rqwIFq
         lDoqisOfJL0rTpbxZyTRIZZnM//r+rWuSaVmQmsDzR0rq4YvhEAgwsN7ry7RpVOGrDal
         k++Q==
X-Gm-Message-State: AOAM532QMRWUTVcFdWTJnRWMcDHece5jN6v1cVmYwwuyglYISUAgP/vK
        zm/UWIvfuCRuGgIZ4IETszA=
X-Google-Smtp-Source: ABdhPJySGEef33vQvJJBMAGMOAc2t6mWHhKRdZWMXeKWcRmHdgZFW515Gw4mlNyzFq4QDpFt293Q1Q==
X-Received: by 2002:a17:907:3f10:b0:6da:818d:4525 with SMTP id hq16-20020a1709073f1000b006da818d4525mr29836236ejc.47.1649692153319;
        Mon, 11 Apr 2022 08:49:13 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id oz20-20020a170906cd1400b006e872188edbsm2954952ejb.104.2022.04.11.08.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:49:12 -0700 (PDT)
Date:   Mon, 11 Apr 2022 18:49:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: What is the purpose of dev->gflags?
Message-ID: <20220411154911.3mjcprftqt6dpqou@skbuf>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org>
 <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
 <20220411153334.lpzilb57wddxlzml@skbuf>
 <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 05:43:01PM +0200, Nicolas Dichtel wrote:
> 
> Le 11/04/2022 à 17:33, Vladimir Oltean a écrit :
> [snip]
> > Would you agree that the __dev_set_allmulti() -> __dev_notify_flags()
> > call path is dead code? If it is, is there any problem it should be
> > addressing which it isn't, or can we just delete it?
> I probably miss your point, why is it dead code?

Because __dev_set_allmulti() doesn't update dev->gflags, it means
dev->gflags == old_gflags. In turn, it means dev->gflags ^ old_gflags,
passed to "gchanges" of __dev_notify_flags(), is 0.
