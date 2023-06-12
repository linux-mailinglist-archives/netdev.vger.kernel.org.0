Return-Path: <netdev+bounces-10132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6AD972C6E1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5E241C20B1E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADD019E72;
	Mon, 12 Jun 2023 14:05:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE4219BA9
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:05:29 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6BDE78
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:05:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-5162d2373cdso7818980a12.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686578724; x=1689170724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIbTMp6zxCR1AsfVVYCAVOxF4J8Ah7pNmjkGa2IpCMM=;
        b=euEZCwlLUVXqBBkQ4wlYn/OvC+5PS154VrBjhMefj4KeGD3CWaBnziBSLibqrHWqGE
         J5x/kvCzmsks2Lzjy9zNDlIco/02NyqCJYNeUrx7oA/WfpDaeWO9kLNKNSdQAgSRyNnz
         Cc9j1KrKrb8VN4fj1AY07HChJq+Cif8vmGBMA0XWogoCPACqndo6WNFA43iWOhNYjt+l
         vhjQpcebHI4OHKyUfSyujeXzeJUjEzNGXeSmuR6TE+d2VZUtapagSWov7tx2HObPmSbA
         Qk1HQFx4RxrNd0W9L8ZOAwaIO6104yvki8/9Qm+miUQWhxFEV6pHLvFLA8upuzXclPUm
         4fGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686578724; x=1689170724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIbTMp6zxCR1AsfVVYCAVOxF4J8Ah7pNmjkGa2IpCMM=;
        b=I9kX2XJ+xEWL4GROe1ygOqwtKrovMordJ+Myu7Q8UVoqgXoe2ueQQAfQ+aAqgdL5UP
         mU5gsqRjvxrq/YtdF9cUTuOG8fbrkrdJ8sVscQIf439SG5qh3CR68piK5X0iDhbKHe0f
         xSkNJYX4/beLy11HP7OFV4ZBdFQ8r3Qfx18AZbEv33NvdoAvGdd3yTSlf9Ar6h6nAP5I
         iPUc+b6AlcSzp1jZq6HCHSujUckvaeTTvmZvkPNHNL1rLpTB9/KyvmTGgp3QW9jRJHH+
         bNeYcX1bfXUe3kBbMQk3pvCqe4m9iwKgYfFhIh8on/N/2KOcKQoR7wMZ/WvUZcvlZSgO
         Kutg==
X-Gm-Message-State: AC+VfDwQct97LzpltMvCw0b7AzEB4laH8XNFbN2CXvuvpUFi23kH2tU1
	BdgbYytRV/5aXfnWDktT0HE=
X-Google-Smtp-Source: ACHHUZ5ngo6kdD32mxmT+Cv3eZ93IFVorlAVDkQZZio/8F5OfhWnt8CcLlygMHTZDc1aY71sWfFsAQ==
X-Received: by 2002:a17:907:9495:b0:974:6026:a312 with SMTP id dm21-20020a170907949500b009746026a312mr9734136ejc.51.1686578723929;
        Mon, 12 Jun 2023 07:05:23 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u13-20020a1709064acd00b009787ad3157bsm5319487ejt.39.2023.06.12.07.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 07:05:23 -0700 (PDT)
Date: Mon, 12 Jun 2023 17:05:21 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230612140521.tzhgliaok5u3q67o@skbuf>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612133853.GT12152@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 04:38:53PM +0300, Leon Romanovsky wrote:
> On Mon, Jun 12, 2023 at 04:28:41PM +0300, Vladimir Oltean wrote:
> > The sequence of operations is:
> > 
> > * device_shutdown() walks the devices_kset backwards, thus shutting down
> >   children before parents
> >   * .shutdown() method of child gets called
> >   * .shutdown() method of parent gets called
> >     * parent implements .shutdown() as .remove()
> >       * the parent's .remove() logic calls device_del() on its children
> >         * .remove() method of child gets called
> 
> But both child and parent are locked so they parent can't call to
> child's remove while child is performing shutdown.

Please view the call chain I've posted in an email client capable of
showing the indentation correctly. The 2 lines:

   * .shutdown() method of child gets called
   * .shutdown() method of parent gets called

have the same level of indentation because they occur sequentially
within the same function.

This means 2 things:

1. when the parent runs its .shutdown(), the .shutdown() of the child
   has already finished

2. device_shutdown() only locks "dev" and "dev->parent" for the duration
   of the "dev->driver->shutdown(dev)" procedure. However, the situation
   that you deem impossible due to locking is the dev->driver->shutdown(dev)
   of the parent device. That parent wasn't found through any dev->parent
   pointer, instead it is just another device in the devices_kset list.
   The logic of locking "dev" and "dev->parent" there won't help, since
   we would be locking the parent and the parent of the parent. This
   will obviously not prevent the original parent from calling any
   method of the original child - we're already one step higher in the
   hierarchy.

So your objection above does not really apply.

> BTW, I read the same device_shutdown() function before my first reply
> and came to different conclusions from you.

Well, you could try to experiment with putting ".shutdown = xxx_remove,"
in some bus drivers and see what happens.

Admittedly it was a few years ago, but I did study this problem and I
did have to fix real issues reported by real people based on the above
observations (which here are reproduced only from memory):
https://lore.kernel.org/all/20210920214209.1733768-2-vladimir.oltean@nxp.com/

