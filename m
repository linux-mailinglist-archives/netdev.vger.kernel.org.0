Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1781462D532
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiKQImS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiKQImR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:42:17 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9051D67B
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:42:15 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id g10so971028plo.11
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LCgCIUse9eosejGui97oWoMcppy2Byk9qv5L6RlI4N8=;
        b=iEzftMQbGb97+CYKfC+lDx9u4RkvtpMlUFgatKtnCU525EHdGCHtYIDcJb634IgyQU
         YKFappgkVIsiBpx1pawX+Y9itx+dwOZtM6QscfoJKp7ou2a+IIrSsmP3bI/9pcZtHH8k
         F7XufHvHq3QEQ+HdkMactJG1TQAcBsEJYdC+ITyNWzjnn7mmXSBwieZ4hbdpIot3Ez3L
         9cewmJLEM0IrL33ZsBCj+nnECjvgT4LYY6l3QvcWESdAEn3DmkUoc4K6EERlO1/ovK2Z
         AzA6Q5JUXXcP+YZhCbVG3tl7BJYRzq8q1L5OMpELJ21V7tBhXW27LM8ZuIfGaEZ1cuUp
         XJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCgCIUse9eosejGui97oWoMcppy2Byk9qv5L6RlI4N8=;
        b=FyI2ui9rhGKCpveaoFnsdyc6afaCtK1V3vKDnnLu8FqdNPKMHfbpujmlsR3RzErpQE
         D43AjVFXaXpdSF+ywOUUIEXvBKMw3aakBv7/gtYG14M/UrsURqSHwAL3yA3InOm9W+6e
         9SYzW0xoxWggp8b+z3UaMQvQ8hENylXPIExnyy3yHMi9G7U8R4YmPdIdMfSv5VIJ29/k
         X7hR0ZwtkDlK1dIVikcL8OPP5h5RopK+I+lKubrdfslK2plL5qQfkYcLQRGKAyl1MRl5
         oKZTSQB/+PwI0mXXhaDTze2xrcAqUacdCmxzlxg0TtIXbluLMyB8yImeSQ9yHJkFzBuU
         7Nvw==
X-Gm-Message-State: ANoB5pl+IGDHm/dAb3ikkwufQkzaXUrL+3YIXdYbLMCO7+iJMSBmL9i1
        Z8A+zosrdha2y8s2EF6n/F4=
X-Google-Smtp-Source: AA0mqf7tcGALMmuv3A68HqXn8AMlDVyWy0LwGqRL/8xsgdlIjCe4Iobrm5YlqKhi2dFaeBARe97jbA==
X-Received: by 2002:a17:902:db02:b0:173:f3f:4a99 with SMTP id m2-20020a170902db0200b001730f3f4a99mr1826440plx.79.1668674534667;
        Thu, 17 Nov 2022 00:42:14 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902b40200b00177e5d83d3esm663719plr.88.2022.11.17.00.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 00:42:13 -0800 (PST)
Date:   Thu, 17 Nov 2022 16:42:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y3Xz4W0WotfLoaaC@Laptop-X1>
References: <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org>
 <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org>
 <Y3MCaaHoMeG7crg5@Laptop-X1>
 <20221114205143.717fd03f@kernel.org>
 <Y3OJucOnuGrBvwYM@Laptop-X1>
 <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com>
 <Y3Oa1NRF9frEiiZ3@Laptop-X1>
 <CAM0EoMk_LdcSLAeQ8kLTaWNDXFe7HgBcOxZpDPtk68+TdER-Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMk_LdcSLAeQ8kLTaWNDXFe7HgBcOxZpDPtk68+TdER-Zg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 11:26:54AM -0500, Jamal Hadi Salim wrote:
> Ok, I think i get what Jakub meant by "internal / netlink level attributes" now.
> i.e the problem is there is a namespace collision for attributes between
> the global NLMSG_ERROR and service local. It is more tricky than i thought.
> How were you thinking of storing the extack info into the message?

Not sure, I will have a try first. FYI, Next week I will be in vacation.
So there would be some delay on this...

> Note: I wouldnt touch netlink_ack() - maybe write a separate helper for events.

Hmm, OK, I will try not touch netlink_ack().

Thanks
Hangbin
