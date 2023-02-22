Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D451769F68B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 15:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjBVOZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 09:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjBVOZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 09:25:12 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928BB39BA6;
        Wed, 22 Feb 2023 06:25:11 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id ec43so30567873edb.8;
        Wed, 22 Feb 2023 06:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8FTKxI5GTkk6G+V8HdGQeQBIGx4Htz/By6GXYlaLPco=;
        b=bjYTIbRkGAS10bVTtw1VkAQJClHIfta8/6RM2+YwxS3LAx9xuV5wtntyCD1s7dyK5J
         h2NoS4l/Jgn1h+ruCTPvaicYTSbQFf1bBm+uCJnlAqc+jFNW+ojA7IBLTRy+tzZJPk3b
         7hUSiPM7LpioEb2id0BFs4ElcS2JclwodPaRO83stbTg0dISG6NimuX3e6rgrmSrFW2a
         0hEPcwByyJbczaf3oX9K7uNr98flSpBNLE3D6bvjOWBy17XcqZcoebRbRyLeh6H1OrLc
         dYYJdh1VHFHimgHZi/ldAQ2abs54HZt+xMM7jiNjSQ/0KOhNBGCE5joHgZHBKcrhe4Sn
         zUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FTKxI5GTkk6G+V8HdGQeQBIGx4Htz/By6GXYlaLPco=;
        b=Qy6ZIKkwtIN8OZDZE8I8+YRa8m08NuaQgTopkIxiwxluXtS+CJfrrG4JB4LqAB7cH3
         qwlejQuL7dDvmhZ4FP8XdxZbC/I5o7RSjOMMVkLdPJlXiTV09TbeT43xBmP3D6YSvqd8
         z7bFGQvmmtcUBrdVwjrdPQeQOuV1l6oExWB5eg9iEObE+68a0jId2pfqNpkH10CkYehy
         37qbIG/CZzqWEBVxNAv+QWt/2wE/7+ynnwkz6XyaoHVYr9V3RUP8+VOTtlFCmxTdpsmF
         +Ifk/tuNNVuU3N26lg05MU6EdE+LrN2JnOYe0w7P1gZw6nsuZ64D9u9oY5JPd2AEV3WZ
         a7hg==
X-Gm-Message-State: AO0yUKXJRs2OuzVaoZhEx9WMlOM8BSfQeP2xGGYEItHop9y69G/fpoch
        mh02+w7SIW8orxFKur+kGpo=
X-Google-Smtp-Source: AK7set+rCxeDuhHvx/K9eolv2F9Zu6Xy4q+5nCQxCX9nX4qIRj9kQ7yUxqIbR/fPG0isrOEhz+CuIw==
X-Received: by 2002:a17:907:75cf:b0:884:930:b017 with SMTP id jl15-20020a17090775cf00b008840930b017mr18023663ejc.60.1677075909844;
        Wed, 22 Feb 2023 06:25:09 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id kv7-20020a17090778c700b008e53874f8d8sm1178768ejc.180.2023.02.22.06.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:25:09 -0800 (PST)
Date:   Wed, 22 Feb 2023 16:25:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 net 2/2] net/sched: taprio: make qdisc_leaf() see the
 per-netdev-queue pfifo child qdiscs
Message-ID: <20230222142507.hapqjfhswhlq42ay@skbuf>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
 <20220915100802.2308279-3-vladimir.oltean@nxp.com>
 <874jrdvluv.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jrdvluv.fsf@kurt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Greg, Sasha.

Hi Kurt,

On Wed, Feb 22, 2023 at 03:03:04PM +0100, Kurt Kanzenbach wrote:
> This commit was backported to v5.15-LTS which results in NULL pointer
> dereferences e.g., when attaching an ETF child qdisc to taprio.
> 
> From what I can see is, that the issue was reported back then and this
> commit was reverted [1]. However, the revert didn't make it into
> v5.15-LTS? Is there a reason for it? I'm testing 5.15.94-rt59 here.
> 
> Thanks,
> Kurt
> 
> [1] - https://lore.kernel.org/all/20221004220100.1650558-1-vladimir.oltean@nxp.com/

You are right; the patchwork-bot clearly says that the revert was
applied to net.git as commit af7b29b1deaa ("Revert "net/sched: taprio:
make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs""), but
the revert never made it to stable.

OTOH, the original patch did make it to, and still is in, linux-stable.
I have backport notification emails of the original to 5.4, 5.10, 5.15, 5.19.

Greg, Sasha, can you please pick up and backport commit af7b29b1deaa
("Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue
pfifo child qdiscs"") to the currently maintained stable kernels?

Thanks.
