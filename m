Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000335BB12B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiIPQmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIPQmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:42:10 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4FD15FD0
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:42:09 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 207so12453410pgc.7
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=LEDsCQxg94Ho/eSvAXdsw7dBF4zL19ANIEnTAH5+po8=;
        b=zTYYsWG2PwhmbAyvgkK6bo8KmNvqXUMkrcoqnoeKOPAkmTjw0VkOHdf3CR3UagVMAS
         1yPP/O+QqYyWPdORQyguxxwh3bC9A8rYmFym65+nhzKErWIUquKhTp/gBV7Tz5aIbe/r
         IyUI9CL4D9uQvbINQSIqsqm9x528vlqldvtI/kg6eu6YaWSeodUcw+weRcT5bcWtPoCL
         E6tgPXrppmk9kC7l5AKwF1STKgv1RanxnOFXUSoc7U7kc0J+Azyl+gaYKa8QNLw1wI5W
         ZDJf+X1vyls+0Asa4owaigwZLJjMT8nhDxr/poQ6kG5xgZLzSeK14bWdnyMdwe2QqSEz
         Xg4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=LEDsCQxg94Ho/eSvAXdsw7dBF4zL19ANIEnTAH5+po8=;
        b=zlQS0VVgGj1kJ+FVofBc+dtbA7zglCUzWp8fbPQHPlGzkuy9dXHcUdv9wKX9VTLZ8i
         1aU80uKQ5inU3pp4D1q/fV+qz1FAmsmN3Q1IyaPdijeipT+DidVOV5IMYqnCEYsyg8sZ
         KhgOm2q4DR9xV3otXU4tCZOxFZ5F6HlyFK/+lK6SMfafttiJO5LqLnBrZjmKvXC3Xmh2
         rRFSSHNUFsZHFF+a7+fazLH0KXU8ZKrfd3xupljQBXQNWwh/zITqDq2VCgoJ+MDfSvX9
         y2aRgK1qy6pv84bDqIUI0z7BITwJbtHWDMRHZNusWmMUIWp9lGI7JCZzcYTCZOZKtPSH
         7D5w==
X-Gm-Message-State: ACrzQf14sQEYxODVK77YKYEYY0JG2zG3yWdrB2MiPuAuSteU7ih4F4r+
        X+BYdJLiAuq2GWnyfJLm4a664rX1PrGrl1QlKWPGiQ==
X-Google-Smtp-Source: AMsMyM6AxlzL2A98zdX6EJeu5CT29YoSqGXQTMp6kFIoV9p5CjQ8UX6T01Qfr5U8fhir2FL3+ygLrPrF0cmX8CTMWmg=
X-Received: by 2002:a63:1d1a:0:b0:433:f6ea:dce6 with SMTP id
 d26-20020a631d1a000000b00433f6eadce6mr5188833pgd.178.1663346528832; Fri, 16
 Sep 2022 09:42:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:8b26:b0:78:c13b:6a7a with HTTP; Fri, 16 Sep 2022
 09:42:08 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 16 Sep 2022 18:42:08 +0200
Message-ID: <CAMZdPi_+zQe41xSx+LHj_FDeHu7rs=TEgbWGBaMxcoSrOvXLRQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] wcn36xx: Add RX frame SNR as a source of system entropy
To:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Sept 2022 at 02:41, Bryan O'Donoghue <bryan.odonoghue@linaro.org>
wrote:
>
> The signal-to-noise-ratio SNR is returned by the wcn36xx firmware for each
> received frame. SNR represents all of the unwanted interference signal
> after filtering out the fundamental frequency and harmonics of the
> frequency.
>
> Noise can come from various electromagnetic sources, from temperature
> affecting the performance hardware components or quantization effects
> converting from analog to digital domains.
>
> The SNR value returned by the WiFi firmware then is a good source of
> entropy.
>
> Other WiFi drivers offer up the noise component of the FFT as an entropy
> source for the random pool e.g.
>
> commit 2aa56cca3571 ("ath9k: Mix the received FFT bins to the random
pool")
>
> I attended Jason's talk on sources of randomness at Plumbers and it
> occurred to me that SNR is a reasonable candidate to add.
>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Acked-by: Loic Poulain <loic.poulain@linaro.org>
