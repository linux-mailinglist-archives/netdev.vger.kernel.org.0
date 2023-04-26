Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19016EEC79
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 04:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbjDZCnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 22:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjDZCno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 22:43:44 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFD1A2;
        Tue, 25 Apr 2023 19:43:43 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a6684fd760so8555035ad.0;
        Tue, 25 Apr 2023 19:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682477022; x=1685069022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CvriiGhuafw4yBJ4KEQ9n3jTJZD+LjI3FuHyF1N25tg=;
        b=lx7jYNgfayAQ1yhzffckKXtuUtOGiWc8uMvMnXmmW6BQopJBXtQw6o9iDSQfh11t7C
         4ejgEsWnZU3MR97CQmHPYRE2XuxaiCfLwtcKhJW3KrwQUuK1hZsurd+ljqWTl9Jx++RZ
         jcLQ80mmaGN2O/PyCqU5ECSoQiSdvnglkr9g1DjVG50uIIiFbGhbvwfPuTucBQLVFaLo
         0AR+5v3z5l6J9vXzD3NhO1+6FmkfTVVFuw42JXz3bhiBySUjSNaFv6JStpzOJ6YKS34+
         uCcioUwFqEP0LEt2rfI0a2L0+FG3n+UwwIjbkV1UeyVqLsi8kdxfH2djkYEY8cOjxbfl
         zA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682477022; x=1685069022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvriiGhuafw4yBJ4KEQ9n3jTJZD+LjI3FuHyF1N25tg=;
        b=ktlm5qNJ18ELv0L8gaH55UwjHUUuO/xbfdm2aM6kIPR+n6p/0oUl8Y+TVdPhFyNiMD
         puKZgbyV7wQmZO2NULKOYH/ZVTO/hTW5ACj0a5bfVBtu3EochtpwI8n4VwF3BnjX89lj
         dT6xFVhR/f6Y4/JgLwRrZHzg+gY6I9seD/mvrpMZlTY2F7LG6O47kW0sOGLnCHZl2qTs
         PPS9N6H7bU6BarEHqlg1t+EJfHVmklZ3xt+1pZGD/X4OZVQOUOm4mR1Yl2nkrZNsRdst
         Kk04TI3Mkb440VRuIquAI2zqqgBIrke8x38DdxkDQ/Qp+0hZCy8PwNnk7ZEaA3tRmcxD
         p0vw==
X-Gm-Message-State: AC+VfDyX5xWq8jVZETBgkyIYhy6AIJP8wcXTRKKS32T1xuLrZdpVN9HH
        Omgh5jVdR+OJXP1/XqqsQ58=
X-Google-Smtp-Source: ACHHUZ40aHIzM0EldF12JcPmnvcghSxlCJN2n4tKyZsPRnKZXINPXmJJWKxljv6rtcp/klTWeVdY7Q==
X-Received: by 2002:a17:902:f543:b0:1a6:6edd:d143 with SMTP id h3-20020a170902f54300b001a66eddd143mr5182523plf.6.1682477022425;
        Tue, 25 Apr 2023 19:43:42 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ff0100b001a5059861adsm8857834plj.224.2023.04.25.19.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 19:43:41 -0700 (PDT)
Date:   Tue, 25 Apr 2023 19:43:40 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Stern, Avraham" <avraham.stern@intel.com>
Cc:     "Greenman, Gregory" <gregory.greenman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <ZEiP3LDTQ86c4HaN@hoboy.vegasvil.org>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org>
 <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
 <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
 <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
 <ZEb81aNUlmpKsJ6C@hoboy.vegasvil.org>
 <ZEctFm4ZreZ5ToP9@hoboy.vegasvil.org>
 <SN7PR11MB6996324EBF976C507D382C3AFF649@SN7PR11MB6996.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN7PR11MB6996324EBF976C507D382C3AFF649@SN7PR11MB6996.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 07:03:50AM +0000, Stern, Avraham wrote:

> Having the timestamps of the frames seemed like a basic capability that userspace will need to implement ptp over wifi, regardless of the selected approach.

Having time stamps on unicast PTP frames would be a great solution.
But I'm guessing that you aren't talking about that?

> Apparently you had other ways in mind, so I would love to have that discussion and hear about it.  

Let's back up a bit.  Since you would like to implement PTP over Wifi
in Linux, may I suggest that the first step is to write up and
publish your design idea so that everyone gets on the same page?

Your design might touch upon a number of points...

- Background
  - Difficulty of multicast protocols (like PTP) over WiFi.
  - What do the networking standards say?
    - IEEE Std 802.11-2016
      - Timing Measurement (TM)
      - Fine Timing Measurement (FTM)
    - IEEE 1588
      - Media-Dependent, Media-Independent MDMI
      - Special Ports
    - 802.1AS
      - Fine Timing Measurement Burst
  - Which of the above can be used for a practical solution?
    - What are the advantages/disadvantages of TM versus FTM?
    - What alternatives might we pursue?
      - unicast PTP without FTM
      - AP as transparent clock
- Existing Linux interfaces for time synchronization
  - What can be used as is?
  - What new interaces or extensions are needed, and why?
- Vendor support
  - How will we encourage broad acceptance/coverage?

IMO, the simplest way that will unlock many use cases is to provide
time stamps for single unicast frames, like in
ieee80211_rx_status.device_timestamp and expose an adjustable PHC
using timecounter/cyclecounter over the free running usec clock.  Then
you could synchronize client/AP over unicast IPv4 PTP (for example)
with no user space changes needed, AND it would work on all radios,
even those that don't implement FTM.

Thanks,
Richard
