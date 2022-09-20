Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD8B5BF17B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiITXpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiITXpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:45:40 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB243F1DB
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:45:39 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bj12so9814682ejb.13
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ufkjCshDfU9jGUp6s89rCE9sgU4QMahYoSFfrC6sIeg=;
        b=gzdYTmMsBjdO8oLWmLhpf4OYDreoEJUcPpuvF6NCCR02mV0uF6rFyQVuH8fheoB3uY
         28Hap40doumcjy9ooqX6cpU97+yvfGq7NOQ83G/F5QO5vUSgo2rLeA4pXAVBJkO7Ivwm
         bt1N3nUoyr8fiayR9j9Mj4LcG1l6prCWoyb8FeuMJRbedIEpmWoNtMVuYzRI7iqWDTHx
         7FdZ2ac0iEr2lHOnlACKLRHElbgSaTltz8SgwOy9vAXbbM/aMqRDetxWBvzT4GAZq9Kk
         E1b/2IfgMHXla3tap/Da8LAN0Kfk+1ufcjGufe3XUpbtjrwJRNqbMKnKSvcD8aRYYSqs
         0big==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ufkjCshDfU9jGUp6s89rCE9sgU4QMahYoSFfrC6sIeg=;
        b=XCfzmOYvtSapzqfJ1SdTUW4D/0mOiVw7iD4139wEpL7oBNabJW4V66AMkYR/4kj7Ah
         y0vVzwHcvQ8F/Swyf3iL1v/l8yzDMBDYaMS00TOq1gR/4wQUpxDfHbScAH1Y6JLUBNd9
         Wx/dR85/Kx/YibeoeNbCaWSohX5IA+Tp3Oo7/UQ91uNgm7RgcYRn52V/vf8cXGbbXCjq
         ly22C0ZXvSzrp3Z4odGkbiwoc6FVXFxLYr9Wy0r/0lUh1VqburwtEhvUTG81tod/rMav
         KEPv/M5/Tqt51ILfWuAEPXX4WFjW/YZJMx4JNXTsz3oCnKYBxEZq61hbxHkISunH8B1h
         ngkg==
X-Gm-Message-State: ACrzQf1PddI/JqWejVp/LakmSfuja1K62kvJmv807hMsohT4K6f9aZNQ
        gQ3FotBd/OkVTs4JHS3Dfw7akSDyyFzVE1c9
X-Google-Smtp-Source: AMsMyM5lrhsgU+noQftPlyKyb1U6QcQK7yTD/77mwZofMRN2cCi7A9BMXEG2JutCQaZXNDxSrDtFIA==
X-Received: by 2002:a17:906:8a76:b0:781:7530:8b05 with SMTP id hy22-20020a1709068a7600b0078175308b05mr7827682ejc.489.1663717538290;
        Tue, 20 Sep 2022 16:45:38 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id kw12-20020a170907770c00b0076ff600bf2csm548363ejc.63.2022.09.20.16.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 16:45:37 -0700 (PDT)
Date:   Wed, 21 Sep 2022 02:45:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH -next 1/3] net: dsa: microchip: remove unnecessary
 spi_set_drvdata()
Message-ID: <20220920234535.foehn5ugotbschfi@skbuf>
References: <20220913144406.2002409-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913144406.2002409-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 10:44:04PM +0800, Yang Yingliang wrote:
> Remove unnecessary spi_set_drvdata() in ksz_spi_remove(), the
> driver_data will be set to NULL in device_unbind_cleanup() after
> calling ->remove().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---

I would like all drivers in drivers/net/dsa/ to follow the same
convention, which they currently do. They all call .*_set_drvdata.*NULL
from ->remove(), why just patch the spi_set_drvdata() calls?
