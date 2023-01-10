Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1D6663DE1
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjAJKTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbjAJKSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:18:45 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52D243A21
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:17:40 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id jl4so12676783plb.8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QWSkWPAwvPoqU8kiUmbpZICZDQ5OEIiV3b0u/3KhUI=;
        b=gMH9aTUOTD1nuFK8O2NvH3CBa//gr8ImZHR6SKW71+4sPunekIhUyfNAbnbUb6k2DO
         7+DSQyYGeY1fcwsd858sdgL5c02cRgsxmZdebs5wXQzFtN+ssAFkAvqtHTHcSy+hT88h
         gRb/0pUW5KgOVovM0ceTo3F8h4tVaEfWLuY8V1YFtgvqI9pIkFPC1hV5hnmhgOXOzvMd
         dhn1JSfYHiX69B4NG2/wgMBPCBpe5bufkiMqKkXM8er5jN9Zk95tvSJ9DHIJ4lqrM5Fh
         tbKpMdJh8bBakC1sjcQvExCcJdHmL/VJC5CLVHotFxYmzgS1pu8pywVDmbUMdkbh28b/
         mRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QWSkWPAwvPoqU8kiUmbpZICZDQ5OEIiV3b0u/3KhUI=;
        b=BK/sUJBXWEIfSGVj7J483wfJ7eJwRBqyl9nVJeQyMf9gnVNWgQKldpL4Yh6okH3iSi
         QHGkJ0kDegLdAKhLE3e9xMiE5nyjhiJ1XOeoxPwakEqU5p6/a/BK+rUi2qr4DXKoIKHg
         NF2ADS+wNKRmE0uxNRQkwBuR4jOVTqoPxRxrYcR2iNAgCXBoo9giYNahn8ERHiFC3bRd
         epRFM1PI7ZugeENC+bA/7grC7ZEN4rxYtoLF/eDbwF7nsze1mnNezaCbPEf4r3LZPnsH
         tchETAjUskLSY/lDREF3Lv+5cNratZV/sGvv3ZrtxgT0TEfs6R4H8csiy3gQ/mo1Bjir
         rISA==
X-Gm-Message-State: AFqh2kqmB9SSQmhEinEdx2jZaktUJHJNQ/+NV/SajV5RsB1dUddWZR0F
        8VgxICJqAvF9PqnjHAPPGVk=
X-Google-Smtp-Source: AMrXdXtihuTjD9SOz8GKRpwpIjAynvRAPB996fqFXBGqh6Vn/YeACzIqMz7NdHSyLdYIg4o1Ad+eyA==
X-Received: by 2002:a17:902:cad5:b0:193:12fd:a2e3 with SMTP id y21-20020a170902cad500b0019312fda2e3mr11523636pld.55.1673345860165;
        Tue, 10 Jan 2023 02:17:40 -0800 (PST)
Received: from Laptop-X1 ([2409:8a02:781c:2330:c2cc:a0ba:7da8:3e4b])
        by smtp.gmail.com with ESMTPSA id t7-20020a170902e84700b0019327a6abc2sm4915848plg.44.2023.01.10.02.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:17:38 -0800 (PST)
Date:   Tue, 10 Jan 2023 18:17:33 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv3 net-next] sched: multicast sched extack messages
Message-ID: <Y707Pa+U7LiJBER/@Laptop-X1>
References: <20230104091608.1154183-1-liuhangbin@gmail.com>
 <20230104200113.08112895@kernel.org>
 <Y7ail5Ta+OgMXCeh@Laptop-X1>
 <CAM0EoMkw8GA=KA_FXV8v4a-RKYCibK64ngp9hRQeT1UzXY4LCg@mail.gmail.com>
 <20230109114306.07d81e76@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109114306.07d81e76@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 11:43:06AM -0800, Jakub Kicinski wrote:
> On Mon, 9 Jan 2023 10:56:00 -0500 Jamal Hadi Salim wrote:
> > IMO the feature is useful. The idea of using a single tool to get the
> > details improves the operational experience.
> > And in this case this is a valid event (someone tried to add an entry to
> > hardware and s/ware and it worked for
> > one and not the other).
> > I think Jakub's objection is in the approach.
> 
> Right.
> 
> > Jakub, would  using specific attributes restricted to
> > just QDISC/FILTER/ACTION work for you?
> 
> Yes, specific attr to wrap the extack seems acceptable.

Looks we go back to the TCA_NTF_WARN_MSG approach[1], right?

[1] https://lore.kernel.org/all/Y3OJucOnuGrBvwYM@Laptop-X1/

Thanks
Hangbin
