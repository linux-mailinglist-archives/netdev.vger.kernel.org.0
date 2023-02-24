Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C316A1F12
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBXP6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBXP6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:58:23 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A0D233CE
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:58:22 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so3367305pjh.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677254302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iUKHyOkCKni8K/OLg6hPvzXdi4yxOtONVOJAf/lrexo=;
        b=Sw68hUHynQI0NfyM5XKXFpEsqAR1Vq/bCymbjlB7wczpDsP5r0M/izpUs6bzxB2aut
         TPYVccx6aMcr9SS8QFAyBqQrTjWu88ykeqetHTfsCOs8MdIiQzAEo+fe7vuEofYDKrDz
         smWNBU5ZzOpUviZk4s1DZXfoFlU2bmZQ3iIZdp5JOzvoabx3TyPY36UC+dH5NXhJsj1W
         60hp2dm5lLnIxKvLNKH7acTCWPb2jI5bRBIpc3GkRap6cGvRqIrITZItUD7Qy+k6uhAC
         ILCgYEgYbWU94mskUdniA+34Cuy7BS5J/Al+B3xyCX0CdwSzZ6eZ9Dwo2BAUpRHHxW6s
         L5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677254302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUKHyOkCKni8K/OLg6hPvzXdi4yxOtONVOJAf/lrexo=;
        b=UTiP9Xi8THiAiGJjvkdwT9gsmRJUS3EP2diaYsGPyqfVLZFdKoTsW257x/nnTxG8bM
         5Z4nn3uwDZe9RurclDG5cXjPcdgbCKZiCHdVMa3OItLtc+qzr69Ga+tca8g6fhk0G07h
         silPcL2liASHJkmxMGs9ZYSpaVjnG6j7b+taerE/SPnZk8aWsE9dEva8TRkTmdnGnrzb
         +eYCEsVTlNSVLoYLIw5pK9RE4amNhCavLCVtGtMSWZnQ6WfYJ1DkBLDjTAvSkAiNlLHE
         Zo/YlU2M9hELNwjMacj/Qn2/p7D0uHSVmKfAi8d4vGpV/HEDyA4/gKu9EDyt3dUWEYO9
         +qAw==
X-Gm-Message-State: AO0yUKVgp8eCi9vgbhHWfmPR2JYauiMMbr1Ww/IewvffcTl7G3omJ1z7
        NMiRoZcl1A9yU8bCAXJftl0=
X-Google-Smtp-Source: AK7set+8Enzv5Rtm8qXY82mfiX12tAZTT9IcXHNcHwia6xBCh0M1h//sjB288Q6Ne180OTICnzGTaw==
X-Received: by 2002:a05:6a20:3d24:b0:cb:692e:6314 with SMTP id y36-20020a056a203d2400b000cb692e6314mr14733338pzi.6.1677254302319;
        Fri, 24 Feb 2023 07:58:22 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j23-20020aa783d7000000b0058d8f23af26sm5233853pfn.157.2023.02.24.07.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 07:58:21 -0800 (PST)
Date:   Fri, 24 Feb 2023 07:58:19 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>, habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next v4 3/4] sfc: support unicast PTP
Message-ID: <Y/jem/Z+AxDEScK8@hoboy.vegasvil.org>
References: <20230221125217.20775-1-ihuguet@redhat.com>
 <20230221125217.20775-4-ihuguet@redhat.com>
 <c5e64811-ba8a-58d3-77f6-6fd6d2ea7901@linux.dev>
 <CACT4oudpiNkdrhzq4fHgnNgNJf1dOpA7w5DfZqo6OX1kgNpcmQ@mail.gmail.com>
 <Y/ZIXRf1LEMBsV9r@hoboy.vegasvil.org>
 <Y/h8w80liiVmw3Ap@gmail.com>
 <Y/jbJ2lMShKZHh6Q@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/jbJ2lMShKZHh6Q@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 07:43:35AM -0800, Richard Cochran wrote:
> On Fri, Feb 24, 2023 at 09:01:59AM +0000, Martin Habets wrote:
> > On Wed, Feb 22, 2023 at 08:52:45AM -0800, Richard Cochran wrote:
> > > The user space PTP stack must be handle out of order messages correct
> > > (which ptp4l does do BTW).
> > 
> > This takes CPU time. If it can be avoided that is a good thing, as
> > it puts less pressure on the host. It is not just about CPU load, it
> > is also about latency.
> 
> It neither takes more CPU nor induces additional latency to handle
> messages out of order.  The stack simply uses an event based state
> machine.  In between events, the stack is sleeping on input.

If you are talking about CPU cycles and latency *in the driver* then,
by all means, choose your queues to implement the best solution.

But that wasn't the argument given in the original post.

Thanks,
Richard
