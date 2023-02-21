Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612F669E245
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 15:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjBUO1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 09:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBUO1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 09:27:43 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322F610269
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 06:27:41 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s26so17896659edw.11
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 06:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N0H9IouRLM5K3a/SnEEfZMtruvcZWhcuKfglAwbop4k=;
        b=KahLum3LcRQIxk4LHJojb0wrF6lCzXucNgO7RojcCYjPxydIgV9oeB+kbEDjQGa7E3
         35ZfoXfynKTeFKoxXQ9Gfx3LMlsQvD+k3/qcHbTSfvuk6ARsDHcKTmr38bZAZ9TRK/1B
         3l9XPkwu70HUshC6gu29+JSPt/GkAv6bmli3MgyND9ObZ8Bz9eKWZRGUw65gnYeyCAu8
         1t2AwDzaWh5apSfVhU/Q9FQy7ZILZ+c+qp+9FekGC6Zo9/Kf4SpbePcSmB1Vzi18GnMI
         3gE5inWvgneoE7jr5we2OdHCT6Suf/RBB1VuIsqQPPtiJ0voQBNXe+mdH8SxxJRPwm5f
         uJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0H9IouRLM5K3a/SnEEfZMtruvcZWhcuKfglAwbop4k=;
        b=z3Ub+qafBW1vv+O6nRIe75+np6Qn+56NBgVBpMqE4Fx1fViKvA+V1WKphltd0fOYf3
         zl5aXGKxARnv2spGc1gkQ7HRiyxYJVRShiRnbg9GtfE8LD4vAfWk3vrxoOWUlyFPokol
         1nGDp0/DK87M4fder4Z/TunZ4xS+epqhppsPznoW6vdsMS+dT0AfKuoMbfgcxz/xJGZP
         JMSDViKuJxP6hzHWsj6Mv55+wdtkJYnY5oWAZZhpggRxjsAtgJMKuJ4n9GRRSdZZwgTd
         3m0ohZYagf6RCJj+OwVDMwmI05+G7qUBq0Rg/b+1+zk9byBlBZ6eA97BPVkFnsq02Rvn
         mJLg==
X-Gm-Message-State: AO0yUKVC9vEGYBgfn90HU15YXL1jU8wWIXFuNdAUDhlWZeu9VhsKigwP
        gRGBlkTGGoX3JJJ0PlmYfGoBLQ==
X-Google-Smtp-Source: AK7set9QVVxB8CyVe0rkcVCCD0vgO8MbFhLkRGfhxWf8dFBXTMXk8/Hd1QGe9IbCWGDavh3bt1gUIA==
X-Received: by 2002:aa7:cace:0:b0:4ac:c4c2:1c51 with SMTP id l14-20020aa7cace000000b004acc4c21c51mr4878700edt.27.1676989659619;
        Tue, 21 Feb 2023 06:27:39 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z14-20020a05640240ce00b004accc54a9edsm1689425edb.93.2023.02.21.06.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 06:27:38 -0800 (PST)
Date:   Tue, 21 Feb 2023 15:27:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Vitaly Mireyno <vmireyno@marvell.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <Y/TU2W05FEIH5lGW@nanopsycho>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho>
 <20230217083915-mutt-send-email-mst@kernel.org>
 <Y/MwtAGru3yAY7r3@nanopsycho>
 <20230220074947-mutt-send-email-mst@kernel.org>
 <CAJs=3_BW+8xL9gvUvUpFwRM_tBVvK3HY5aAQsGboN933_br9Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs=3_BW+8xL9gvUvUpFwRM_tBVvK3HY5aAQsGboN933_br9Vg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 21, 2023 at 02:39:31PM CET, alvaro.karsz@solid-run.com wrote:
>Hi,
>
>Our device offers this feature bit as well.
>I don't have concrete numbers, but this feature will save our device a
>few cycles for every GSO packet.

Cool. I will try to include this into the patch description. Thanks!

