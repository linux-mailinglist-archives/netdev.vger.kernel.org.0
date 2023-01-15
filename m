Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731BE66AF10
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 03:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjAOCUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 21:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAOCUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 21:20:33 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE28A241
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 18:20:32 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id a25so15054443qto.10
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 18:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mKHjc87JJv7e/wtZd4fASJF42yIudR/qk64l4pbNyk4=;
        b=e6PT0XY72OFwj/GIfnxFIVgc6bKUhsiU9rbcawsBkGZWf1M42CSvGb6RfsQosHR/E8
         Led1K9zuBRS34fIERQr9ud29Ll+CaDhkrzVrShaZ5GUMWS5ROm5Rnhh3LhkTA9upNmUB
         FDeciQ5IAf0O4aYgw6uZGrcEz/KHQbZ5OD6mOA6gqPqxMDvGlZ2kcBHBcGQARoAllR/d
         MspPpcElb2rPN+TvSTqFfLlHNMVo8bOrSGVkCNMti44koe8G22jbEHmlQY5Rm0tfX63I
         o6OUP9KMGfFSOSDyRO9pSOhSN0qIb71aQNP5Dn5j3lVlQ0FNEyxDxdKKuDfQPNQ91Xez
         w+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKHjc87JJv7e/wtZd4fASJF42yIudR/qk64l4pbNyk4=;
        b=mMcnnWpAbI9psS91bprNrsER6yovDEb7swDyI6s79H1ZrjNWBnfvdmdeQwnUwy3UWW
         SJDSYSSJioSGz7CtsRMSsO5AmAexJeQHD5cYodrIGEW6IYIfYZ8VU+mCpLfkZn5jvHN5
         /RhCyBTUFH3EYzKGn9dpZ2IwPIYF9prEomTshFX+vTouZxIhxOa4sIuABHqY1syXKfIx
         uTKzGCI/NOQjVKTnce0TIZhsNqbGKhDNYG4HJwAH7mye19AXLVIlzpKYRIVzQqA6FiIX
         WN8davjFDMTF2e7bVuMRaInI94HypxjM7KhPvl/g8jLJYIs9mV+kXt7tvtho8HsoWLGf
         FO6w==
X-Gm-Message-State: AFqh2kpslhhdcppcJJ0A0udLwsnuLcbK7O47/zoHYOTuIQs5FFheQJQ5
        TJiKezecNXw4yc1PVVuVxv0=
X-Google-Smtp-Source: AMrXdXtrhgQT/yQS+F6Dq9vRi1z7JaojDp7+GQUgFZjmYJ1Bno/I0rm7TGiES2uxUIShA2vjYwDzxA==
X-Received: by 2002:ac8:66d1:0:b0:3a5:9267:ee07 with SMTP id m17-20020ac866d1000000b003a59267ee07mr116997154qtp.63.1673749231167;
        Sat, 14 Jan 2023 18:20:31 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:7df3:7980:db4:ba17])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm9138944qtb.66.2023.01.14.18.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 18:20:30 -0800 (PST)
Date:   Sat, 14 Jan 2023 18:20:29 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        jhs@mojatatu.com, jiri@resnulli.us, john.hurley@netronome.com
Subject: Re: [PATCH net] net: sched: gred: prevent races when adding offloads
 to stats
Message-ID: <Y8Ni7XYRj5/feifn@pop-os.localdomain>
References: <20230113044137.1383067-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113044137.1383067-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 08:41:37PM -0800, Jakub Kicinski wrote:
> Naresh reports seeing a warning that gred is calling
> u64_stats_update_begin() with preemption enabled.
> Arnd points out it's coming from _bstats_update().


The stack trace looks confusing to me without further decoding.

Are you sure we use sch->qstats/bstats in __dev_queue_xmit() there
not any netdev stats? It may be a false positive one as they may end up
with the same lockdep class.

Thanks.
