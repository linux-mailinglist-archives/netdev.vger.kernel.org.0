Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E386DBB50
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDHN4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 09:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDHN4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 09:56:44 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C501EF88
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 06:56:43 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f080fc6994so754185e9.1
        for <netdev@vger.kernel.org>; Sat, 08 Apr 2023 06:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680962201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGyiiR3b2iJwkvoYLcBSzn304d/S2TrSbXOjAp0sIq0=;
        b=JjfNm8vstuJt2jw6lAklh6YiOgp3+XTOolSfr836S7uYeWBOc40X4ubrmuUneIqjqZ
         bcyDQDtVN+hhVZK7ZwzeZzWv0PuWH+KfPXuHHgqtq8UXys2vetFV3Na37J9xK3VoTknO
         4aFEMua6ju1F49xLy54Hy8+29qfoRPprd309ydaXwyUN6Jqhmh2iL4dr0upujEbfSNzV
         rg6KSKzdr/HkVi4C2GcydTNChd79cxut7hIE5lVqOPvdRnRzeIZ6sq2RHwMsYR3W20ej
         NKw5AJVIPOzZUCjS9ygR3Z6/jP07G04l+Ugca/xzXrvQX+brWCP75n7bIgI0sZj+xekm
         p5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680962201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGyiiR3b2iJwkvoYLcBSzn304d/S2TrSbXOjAp0sIq0=;
        b=7fFNQl38QnshJh4bVgpM3zKdNhJXcDisSM5RsM3qgdvENsrfEWJrAsZnoFSPEK5WJl
         /RqDcsC6dl5bE1TBQqTS+B9KR38O//mmDBXa2P6o2lMH/BtCZP/56DCJZSVbBo0igtd+
         uOwxxYP7ylT/nbtbsfk0qIfwFjnNAqfzRTmBbpmHoKI1leyOf31UkHZtA1bxDjwyBJ5T
         4Nk8hQ7OQwu9E3Ev2bxqxX9OT9efSkB1Mg3F4OpDdSyUo/kcTlCzt/j/CG/NmNoHzWDj
         RLXCMlLLaAwQmvwwnsZ+5qnKP7ClLVts4UDmwm17wG8ju1mMIDwtON2VsmlA353RIp4L
         ih8A==
X-Gm-Message-State: AAQBX9eOKoeUTvqt2lH8K7gkLr+LayaGiSIjU7/jqDCorsEdYOP+mF8d
        uHJnIFjLVRzaJ9XmzNBGRhE=
X-Google-Smtp-Source: AKy350aKEgWUxkBzv8vWKN3zoIcSFN+QKk6Gym7IozeY8+b6fNzS77CJP6HNJoFBxqDH+Aymgh6WMg==
X-Received: by 2002:a05:600c:3554:b0:3ed:d119:df36 with SMTP id i20-20020a05600c355400b003edd119df36mr1970621wmq.0.1680962201191;
        Sat, 08 Apr 2023 06:56:41 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id d4-20020a05600c3ac400b003ee8a1bc220sm11665052wms.1.2023.04.08.06.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 06:56:40 -0700 (PDT)
Date:   Sat, 8 Apr 2023 15:56:38 +0200
From:   Richard Cochran <richardcochran@gmail.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <ZDFylh_DM8XpmZM8@localhost>
References: <20230405063323.36270-1-glipus@gmail.com>
 <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf>
 <20230405101323.067a5542@kernel.org>
 <20230405172840.onxjhr34l7jruofs@skbuf>
 <20230405104253.23a3f5de@kernel.org>
 <20230405180121.cefhbjlejuisywhk@skbuf>
 <20230405170010.1c989a8f@kernel.org>
 <CAP5jrPGzrzMYmBBT+B6U5Oh6v_Tcie1rj0KqsWOEZOBR7JBoXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP5jrPGzrzMYmBBT+B6U5Oh6v_Tcie1rj0KqsWOEZOBR7JBoXA@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:21:37AM -0600, Max Georgiev wrote:

> It looks like there is a possibility that the returned hwtstamp_config structure
> will be copied twice to ifr and copied once from ifr on the return path
> in case if the underlying driver does not implement ndo_hwtstamp_get():
> - the underlying driver calls copy_to_user() inside its ndo_eth_ioctl()
>   implementation to return the data to generic_hwtstamp_get_lower();
> - then generic_hwtstamp_get_lower() calls copy_from_user() to copy it
>   back out of the ifr to kernel_hwtstamp_config structure;
> - then dev_get_hwtstamp() calls copy_to_user() again to update
>   the same ifr with the same data the ifr already contains.
> 
> Should we consider this acceptable?

This is a slow path so copying a small structure is not a concern.

Thanks,
Richard
