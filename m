Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A4247708
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgHQTov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732640AbgHQToj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:44:39 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C4DC061344
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:44:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m34so8593370pgl.11
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RbvZkl+VFld3/SGn1wsxs528WtxH0u9kRcCVuGkaSCQ=;
        b=eDQAepLdsvf97NBV5qq+WRJIVRJOwcaBUEQzU1Umr707qRYx4QRlzqc9mvYICR5qcE
         Z80/4jpH1yQKaDx3y9tFLp0rKDCe3FRG43PteBr3FE3YUZWfrJNvo2A07Qed+3UcCsN9
         s5CQ7VZkr+RU13eLsg7JqtGvKfQe5/QbQEDhtIQ/fQRAevUnbKDsU8sT+8Oir7osRYfi
         OOsn0xCbEKjXVC3GhIKiF3HeFg0qdLk9pHusk8bhReZ06DWjOPvxxBuB+mi4tP7KMeob
         tjizXIrZys9cTA8SqeNNSyIdKevoj4mE09Mdo+ZLYql+H9fjqeZUU2UTeTozMQghU4RV
         02oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RbvZkl+VFld3/SGn1wsxs528WtxH0u9kRcCVuGkaSCQ=;
        b=XUFZvYmG0Mun4DFv9BVqO7epaKsdTjTCN2Z1LrwsIbr0h1GxNzwbqJqViKqtcCoZWb
         IL2i5VGaWbbOcY4si5JL8Kk42MZshk1am34qqqeIGnaRpSmLExfhivCiIO2o8iEiil9G
         RJEzwDxF35OzL9eXSB5Ekw6pinTsleqSjtHsS4HBwAjxHpp/MAQfrOC1ShduuYg5XdCs
         LDGvhhMQcy3QIyI3G/3co+sNlXIBSKcxI9FVdSVks1LIqdcTqqa1jEGPCaahK25Kx7Xi
         Wsno7k2QFFEONVjNljT/WDWPLaEXac/XyOuvsXonzCKslz/Z2msibf4n5FFgJtkjVHIc
         3NkA==
X-Gm-Message-State: AOAM530VqnBGXxIQcAryblpp11f1xAMo2NNGBATtrk3Dm/Ud5mFri8ZB
        sTSZiC76mZpGQPdhcnGg6BfjEg==
X-Google-Smtp-Source: ABdhPJzFEoQnnFd028Ohjr70q+LK0HAhTgnBlIVjwMDee7dOwAHF3XJdqTZIG2jx09EV04eBp8JK3g==
X-Received: by 2002:aa7:9833:: with SMTP id q19mr5334525pfl.240.1597693478569;
        Mon, 17 Aug 2020 12:44:38 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:bd62:5cef:d7f8:5bff? ([2605:e000:100e:8c61:bd62:5cef:d7f8:5bff])
        by smtp.gmail.com with ESMTPSA id y128sm21118788pfy.74.2020.08.17.12.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 12:44:37 -0700 (PDT)
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
To:     Kees Cook <keescook@chromium.org>
Cc:     Allen Pais <allen.cryptic@gmail.com>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        stefanr@s5r6.in-berlin.de, airlied@linux.ie, daniel@ffwll.ch,
        sre@kernel.org, James.Bottomley@HansenPartnership.com,
        kys@microsoft.com, deller@gmx.de, dmitry.torokhov@gmail.com,
        jassisinghbrar@gmail.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, maximlevitsky@gmail.com, oakad@yahoo.com,
        ulf.hansson@linaro.org, mporter@kernel.crashing.org,
        alex.bou9@gmail.com, broonie@kernel.org, martyn@welchs.me.uk,
        manohar.vanga@gmail.com, mitch@sfgoth.com, davem@davemloft.net,
        kuba@kernel.org, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-2-allen.cryptic@gmail.com>
 <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
 <202008171228.29E6B3BB@keescook>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
Date:   Mon, 17 Aug 2020 12:44:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <202008171228.29E6B3BB@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/20 12:29 PM, Kees Cook wrote:
> On Mon, Aug 17, 2020 at 06:56:47AM -0700, Jens Axboe wrote:
>> On 8/17/20 2:15 AM, Allen Pais wrote:
>>> From: Allen Pais <allen.lkml@gmail.com>
>>>
>>> In preparation for unconditionally passing the
>>> struct tasklet_struct pointer to all tasklet
>>> callbacks, switch to using the new tasklet_setup()
>>> and from_tasklet() to pass the tasklet pointer explicitly.
>>
>> Who came up with the idea to add a macro 'from_tasklet' that is just
>> container_of? container_of in the code would be _much_ more readable,
>> and not leave anyone guessing wtf from_tasklet is doing.
>>
>> I'd fix that up now before everything else goes in...
> 
> As I mentioned in the other thread, I think this makes things much more
> readable. It's the same thing that the timer_struct conversion did
> (added a container_of wrapper) to avoid the ever-repeating use of
> typeof(), long lines, etc.

But then it should use a generic name, instead of each sub-system using
some random name that makes people look up exactly what it does. I'm not
huge fan of the container_of() redundancy, but adding private variants
of this doesn't seem like the best way forward. Let's have a generic
helper that does this, and use it everywhere.

-- 
Jens Axboe

