Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEE56D804D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 17:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238632AbjDEPCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 11:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbjDEPCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 11:02:44 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384B05272;
        Wed,  5 Apr 2023 08:02:35 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id r14so21172122oiw.12;
        Wed, 05 Apr 2023 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680706954;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EhRyIgjjw/8FQdnlDM5/FtJDO4uPLSvO16WmWcJwo24=;
        b=lkMbyXN0+Gr5hyqRu+Zh9p5RVRfg+ReWqCPNJ7jdZsha+KknsOJo+mt5KVBUSKx3QZ
         rqC/1T9VIoLIsAL5nQLonAPIo8jqW8Q4Xum8/WK738sk0d/WYq166ZCace5xfurGM8/s
         YOaiqcARQBZSSqvZv3j3MLAhK3QmCy/MPNm46qlSKki02kOZp8Eu6dFs1LokB2ZPPEX5
         xegaqUhe12PytLTkFm2SnhXRqdjwEB4po+Us6DeWjFmOlLFzbhVCn3uVNxG59FZtuEDP
         Qb5TdZ0sdRfuRn2CtzZrdfQPFWryS5xf0nc5sxlPZjgICd5t8xKsDyZ6LhG6XbQY8fan
         PxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680706954;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EhRyIgjjw/8FQdnlDM5/FtJDO4uPLSvO16WmWcJwo24=;
        b=038xOcDiuMBqfsS+406SsyKdKbTGSjH48wOPctKvfVNbOIagLHF2OdPob9uXeMBWBO
         TA/5/xy410CfzbihgZzjYuTZnjyu9Q5o1vy6z4YXPlL7Tn2Be7pixnyM945EgFLG4l2s
         /vw6pVj6iYq0OErEmtYOSmFjmes/oR1YbbNWbMUPTkO0JWsLmoOHqiJUFOrchi25frCr
         d0g6BWR00GYHPVN4rKvudPL3UO4oQlURxXdDWDcnAaJFmxOfIbFChMCD3AHP6xyzG5xj
         63HGET7JRfhRR2mIYWixJnvniEQMPTb8Rl+y0baaOnDEbYSB+VuTa8hWN/PSY+XN9Vu3
         ZLUQ==
X-Gm-Message-State: AAQBX9dpUy1YkCR/5p3T9/Q8AZgvoI9S+yfMzoEdvr4oY3Ow4iEgLkAt
        gyePIFWVoP1rl+6TwlU6/ck=
X-Google-Smtp-Source: AKy350Yov0sMo2NJt0LYV9mCs+JV37iFxk0Ys3SbZ149H8aH8DmTFJ9rnf3su4Ql91BmzF3OAyyQVA==
X-Received: by 2002:a05:6808:a0c:b0:384:833:2a79 with SMTP id n12-20020a0568080a0c00b0038408332a79mr1502838oij.48.1680706954285;
        Wed, 05 Apr 2023 08:02:34 -0700 (PDT)
Received: from neuromancer. (76-244-6-13.lightspeed.rcsntx.sbcglobal.net. [76.244.6.13])
        by smtp.gmail.com with ESMTPSA id r84-20020acac157000000b003845f4991c7sm6349303oif.11.2023.04.05.08.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:02:14 -0700 (PDT)
Message-ID: <642d8d76.ca0a0220.c2c2e.0f02@mx.google.com>
X-Google-Original-Message-ID: <ZC2NaS2ohG7oCdLh@neuromancer.>
Date:   Wed, 5 Apr 2023 10:02:01 -0500
From:   Chris Morgan <macroalpha82@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v4 9/9] wifi: rtw88: Add support for the SDIO based
 RTL8821CS chipset
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
 <20230403202440.276757-10-martin.blumenstingl@googlemail.com>
 <642c609d.050a0220.46d72.9a10@mx.google.com>
 <CADcbR4LMY3BF_aNZ-gAWsvYHnRjV=qgWW_qmJhH339L_NgmqUQ@mail.gmail.com>
 <CAFBinCC2fr42FiC_LqqMf2ASDA_vY1d-NJJLHOF6pW1MjFRAzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFBinCC2fr42FiC_LqqMf2ASDA_vY1d-NJJLHOF6pW1MjFRAzw@mail.gmail.com>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 11:27:49PM +0200, Martin Blumenstingl wrote:
> Hello Chris,
> 
> On Tue, Apr 4, 2023 at 8:16 PM Chris Morgan <macroalpha82@gmail.com> wrote:
> >
> > Please disregard. I was building against linux main not wireless-next.
> > I have tested and it appears to be working well, even suspend works now.
> Thanks for this update - this is great news!
> It's good to hear that suspend is now also working fine for you.
> 
> It would be awesome if I could get a Tested-by for this patch. This
> works by replying to the patch with a line that consists of
> "Tested-by: your name <your email address>". See [0] for an example.

Sorry, bad manners on my part.

Tested-by: Chris Morgan <macromorgan@hotmail.com>

> 
> 
> Best regards,
> Martin
> 
> 
> [0] https://lore.kernel.org/linux-wireless/4a76b5fe-c3d6-de44-c627-3f48fafdd905@lwfinger.net/
