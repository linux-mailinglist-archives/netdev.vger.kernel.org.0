Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C56E307D
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjDOKNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 06:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjDOKMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 06:12:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D08B5FCA
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 03:12:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id q23so42263296ejz.3
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 03:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681553557; x=1684145557;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=noUmBjusnKF8bP4EcQltb+prOBD2flUzDYK4UCpcnnA=;
        b=gtKAnRt5hz44Q83qpCGn2YNoRprwxFEmjiLtSrZKQn+2Nlps8yDvQPmEQ38gVq77DC
         7YUowLagt4Ioh9f9E8yaYxMFVLA5um/hPIW4/FCTpLJA+hSua/CvTloYd/Zx4R93CIs6
         HxXAKN5xI02dofafd5q9ruky6ge0OARsmYtAeSjo0BGjGCMQAGUuz08aSVM9714QCMVO
         x+L0/3BTRSMIjrCbguDzc9d2tvJRDFBQsgrrcaanf3nyLSjQ+gGRmLJO1/IRi69hrCKf
         2gWkZPBGPRnjocqcj/5Xs1iBwzY6n5OuTOSPUIzXsk3bTdy45jX5NyZsM8RaRGIxllX+
         GuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681553557; x=1684145557;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=noUmBjusnKF8bP4EcQltb+prOBD2flUzDYK4UCpcnnA=;
        b=dBjcaloDETfhcjfbFRe0k/3yctAvfj9DeG20kUGOT0cYFcNtQ6dOp5z+nQzBKv5qXa
         Hwi5frevyl9XABaB3u2/2OTdXZwgN+yGnXI8d96UXCQMvPs9gXOTG7T2U7hqYjnnXIBl
         2UIaUfXsBVfBdEaeoV/MQdc0pAY+pmgxfsB2g/RoTMGV9F70Ndm2XXXylwgJhOCaJVWC
         0bNeeQYfN8cxbN9QPan6oU2CIJ9OVxy+FTV5s1ZloF7LNoFfJbfOZHs50vJAms2owd++
         4Y62vzXlgvxMu5U0jXw+6oV4tzd/NJiYwQKiS+oRmwWaF4jnD9a7zkeoluoxQAQSukkb
         Of1Q==
X-Gm-Message-State: AAQBX9cg0ljzdaI54rlo2EumtvOHxcLw1vUlu4rkppsSUj5DNXuohDXm
        K1SmZXx4vga3au00hbZsV7c=
X-Google-Smtp-Source: AKy350bv/mpgb0y0aguMq2kRGUej8BB1r1i3fbtPUflWAsPyL0Edo7vhN0g/w8bwJF4Zhwq1bfrMPg==
X-Received: by 2002:a17:906:5e53:b0:94e:c97b:e3ba with SMTP id b19-20020a1709065e5300b0094ec97be3bamr1686623eju.37.1681553557318;
        Sat, 15 Apr 2023 03:12:37 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id x12-20020a170906b08c00b0094e6a138170sm3598064ejy.72.2023.04.15.03.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 03:12:36 -0700 (PDT)
Date:   Sat, 15 Apr 2023 13:12:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <20230415101234.rmo3b27iv3p5o42l@skbuf>
References: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 01:41:07AM +0300, Arınç ÜNAL wrote:
> I moved enabling the regulators from mt7530_setup() to mt7530_probe().
> Enabling the regulators there ends up with exception warnings on the
> first time.

Have you read what the WARN_ON() in _regulator_put() has to say?

	/* Docs say you must disable before calling regulator_put() */
	WARN_ON(regulator->enable_count);

If you call regulator_enable() during probe, do you also call
regulator_disable() during the probe error path?
