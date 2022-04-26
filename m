Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987AF50F68E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345231AbiDZI4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346383AbiDZIyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:54:45 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578B7DB0E4
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 01:41:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so403756wmj.1
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 01:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1rB49bGMkJR5uLmyzDybc3DHUQDGXOVppj6eyR1iU9A=;
        b=icXRxAucDRXfurq3XZKsqxqmCnu2lVii+SeDxiSpb8hPHpJgojuKrES3S16YVFhgYq
         Y3pkkJq9mul7mIbSpSmBY+lw9ePq9KcW8SVOeitmpEI3Hw+/giFME529XDjHJybhXSBZ
         rHNSrPEjvk1gz/7ck0lwDIoR84yayDgk8HUVDyMm1I+br+StfIjyahdz2vBMRHGpUu4V
         FElI06h3/WVVXlwWz70RmyH1cAPcIFROmjzOaJ6cf56cwowPgo0WeybZ47hreuOSo2iq
         Vu8+Gs3Aa1GRPqxJltAe+mEceodzNpyhhUl5gZuEUkvXZtHJOCKU7Ge5O1MxqiVanQYl
         llqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1rB49bGMkJR5uLmyzDybc3DHUQDGXOVppj6eyR1iU9A=;
        b=ZwBsjmU3rR22JqprozLQRB7a9lW/YkEjJ+lL7q3KAwekY8kCAcdux39GjhKQ9FCz9g
         6bveK7h28+Cggik0FnnmHXFuOvQTZzb2M/fBGWOF0zB05zZjJ4Nu1c4ctMuZy8HRkUbd
         iRoqO/UTc9/Y0MZ59KsriO5xErR5ZJJQ73+d86JHYhWqWRxvOHpbXfZiqpOUcExZqPvx
         35ygxCC4/bcXSAyRGGjFmW9BfjHYnOWjMsYtwYM/QQuPKcul30ZMoJjOzX1AKgvjsvUP
         z1NmnDf/9jZZnCHbwT3kuZPvVHfy5Ki+WNnuUpQpVVCZIk7UBxF2rz6OfyLS4xP2X6H6
         qK+w==
X-Gm-Message-State: AOAM5306ZmeKxj17ATvk0sCOFXfol7bQ7llPjSutngYMusRz1AxfU1yj
        +GWa5jgOeATJAgA/D6E4EZViAiBhpLE3XA==
X-Google-Smtp-Source: ABdhPJzsxoZL2X4jA4RbbNbyIE3W5Dvis7iqo6KPFcMRZJIgm9ZLPPD89C08fRTs52mfRmJbv1XjMA==
X-Received: by 2002:a05:600c:a42:b0:393:d831:bf05 with SMTP id c2-20020a05600c0a4200b00393d831bf05mr18262477wmq.187.1650962471797;
        Tue, 26 Apr 2022 01:41:11 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id s13-20020a5d4ecd000000b00207b4c92594sm10418449wrv.59.2022.04.26.01.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 01:41:11 -0700 (PDT)
Subject: Re: [PATCH net-next 03/28] sfc: Copy shared files needed for Siena
To:     Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
 <165063946292.27138.5733728538967332821.stgit@palantir17.mph.net>
 <20220423065007.7a103878@kernel.org>
 <20220425072257.sfsmelc42favw2th@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <26dbc7da-890f-2263-d0d7-f75dacbbbea0@gmail.com>
Date:   Tue, 26 Apr 2022 09:41:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220425072257.sfsmelc42favw2th@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/2022 08:22, Martin Habets wrote:
> I'll probably need 2 or 3 series, and it means our Siena NICs will
> not work after the 1st series.
Maybe instead leave the sfc.ko binding to Siena until you get to the patch
 that creates sfc-siena.ko?  That way there's no intermediate broken state.

-ed
