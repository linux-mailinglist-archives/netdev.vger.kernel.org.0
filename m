Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BD14BDB6B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358101AbiBUMih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:38:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358072AbiBUMig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:38:36 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D60219290
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 04:38:12 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f17so1953319wrh.7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 04:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LKx7tTbFFTJnPN+u30WrvTluvsJNKvcCbVga5G4cng4=;
        b=euLhhZZCAI7A/+S/XKiME2KJm3o1oTmFVCPDGgzFxPD2ZbJ1lTYg7afyyVyL3gRe98
         idxSTePdGLX9d7sOwTHhzwAEWxOh9vHhERxV3oXp6U/pHUot27L8awxSYKn43JgEk9VO
         xMoaXpKHXp/XPZDkz7aGntl2MjCvslMxkER2B5OVMkqBxRsO+tvKorJ/2YRTj2go2DYy
         Ao/Jv886fKTdXfeFsccbc2ocJU51YG/+RctufqIhNMKqdkpkTjGfiMa+jJ0BPchvN3Zp
         6ed29r/PqxTv4NtEV3O9aeq+xkTgM2hKtwH9kJX+P4Ib7K6K0TjwFSUIuLcUh4EPHgM4
         gYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LKx7tTbFFTJnPN+u30WrvTluvsJNKvcCbVga5G4cng4=;
        b=UuYJSPhThJQae7I9m1GvpGDTwJs7t1YBd4ji1OIUUthhgZDf7Gp7bRuRhQ1FQo5UB3
         HKVGMQSxUNDMQ/BPCslZn6ZsgLronns7FSOsGahavKsHkDXf2BDpMYtL7XzgihWyihsR
         KgdIsn5YpTR9ndiRprv68qE3uitRz7/9XbTuq4V+0K6jPovGm1qr5ef77yXSgS7WgdGu
         Mz5XQ/IZW3SxEWLXr/jNXBxCYlqc3lpS7HtUpA3ioUHeHtMnCuUqlmnTjU2E0sdFnlJx
         SfWtguJIRkA6ABAgc8DOtGvlAn+f67DmpHkG1l9qlc3H5JxmGhZIrEAkEbzVF8j7DECJ
         Y44Q==
X-Gm-Message-State: AOAM533NXXDhtguZZBusk5uuktzUS094vseCS3XTZxHnYfTi0+PHbWph
        E1pMMcv1QQqcMaR4l+MV7PCwJA==
X-Google-Smtp-Source: ABdhPJxHAdNPhIyEhEY/h4/cryx14gzxwTvnqDvWQ2edSk5VVdfaR7tSY1L1Bei9A1l58+XEvcEKig==
X-Received: by 2002:a5d:6a09:0:b0:1e3:3f5e:e8d with SMTP id m9-20020a5d6a09000000b001e33f5e0e8dmr15590128wru.670.1645447090808;
        Mon, 21 Feb 2022 04:38:10 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id t1sm60536942wre.45.2022.02.21.04.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 04:38:10 -0800 (PST)
Date:   Mon, 21 Feb 2022 12:38:08 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH v4 0/7] Provide and use generic_handle_irq_safe() where
 appropriate.
Message-ID: <YhOHsD4jB9pHpfdl@google.com>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
 <Ygu6UewoPbYC9yPa@google.com>
 <Ygu9xtrMxxq36FRH@linutronix.de>
 <YgvD1HpN2oyalDmj@google.com>
 <YgvH4ROUQVgusBdA@linutronix.de>
 <YgvJ1fCUYmaV0Mbx@google.com>
 <87a6ekleye.ffs@tglx>
 <875yp8laj5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875yp8laj5.ffs@tglx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Feb 2022, Thomas Gleixner wrote:

> Lee & al!
> 
> On Mon, Feb 21 2022 at 10:57, Thomas Gleixner wrote:
> > On Tue, Feb 15 2022 at 15:42, Lee Jones wrote:
> >> What is your preference Thomas?
> >
> > I suggest doing it the following way:
> >
> >  1) I apply 1/7 on top of -rc5 and tag it
> 
> That's what I did now. The tag to pull from is:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-api-2022-02-21
> 
> >  2) Driver maintainers who want to merge via their trees pull that tag
> >     apply the relevant driver changes
> >
> >  3) I collect the leftovers and merge them via irq/core
> 
> So everyone who wants to merge the relevant driver changes, please pull
> and let me know which driver patch(es) you merged. I'll pick up the
> leftovers after -rc6.

Ideal.  Thanks Thomas.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
