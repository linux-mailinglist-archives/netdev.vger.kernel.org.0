Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6F66624B5
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjAILxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjAILxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:53:22 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372181A05D;
        Mon,  9 Jan 2023 03:53:12 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id g19-20020a05600c4ed300b003d9eb1dbc0aso3507600wmq.3;
        Mon, 09 Jan 2023 03:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yuo8pU7AP5RWR4z47Dmbosa4tCF1KJOtJvLB5VnQJDk=;
        b=NePZKS/LU6deDhfl4q3T9A2bzw8JNjbfqbDewCPREEgQG+/qDa/2vqP0G85lCYr89c
         s/6ReJN73fH5VHATtyvAc3dFk8+viTqT+CsDIGSYOqmvdJcFDeUqKkI5GNR+NTtPRdkg
         PVuwHUGjPOcO50mFY/70H5f8vOy5Hcnt+M4T/CBvcdvsmLRD++VFPRP6m9oMQ4zM4ovJ
         xzFkwrjXBB36zV9jhWJof6Up4zpr3kFKl4V1/Lxx/lHBCbVP9JT9LPI5weBHUVejkClD
         vfjcdRtocIVhQ/eJ0EbMf29tPkVW/Me1UxFAFgO0s/IDH+vIewDqDStEQmr7YYYUoye2
         Nmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuo8pU7AP5RWR4z47Dmbosa4tCF1KJOtJvLB5VnQJDk=;
        b=Y5tHfQyUbsFzz0unuLfyYw/So//oPP6IYP8NpRiPzCmuBga3ItskLO8Fo8HPyiX1nA
         ZDdmzQGnkzMoGmrJ6Oa02ztWA9jg48t3VUR+PIgfny15eGhXjAjQy7oRXEBkkOwJ2x2S
         Sb9HuKYZCMByRo3g6IZ9beLCV34LZsn0xydQxFD1IVQvasu3/pFRfQBYJG+dcmEhRh1m
         P64+wJgzWqLqgFsINuv3+FEbRVFK1Uic1cUtoTIJkEzM/QBOuJLH4Sr9fNbfzCp/YOl5
         s+VBjk9J6TdzaL0j3qa7ljR8CwBQD1tKhEryJ9HwumudpS1tfW8/aU4S5fXkeBOPoSOo
         an1w==
X-Gm-Message-State: AFqh2kp887vS/Y2s5aQ74Z7N6EObg6MjtfA47RhjkvfvEuGuogYe0Tjr
        PitcQFioWRP2yzihQniHXIA=
X-Google-Smtp-Source: AMrXdXu2FtPLas2GBP+AZnRW1vg8obTldiySVi7o/t8Z2F02hU7rv9DNG7gflx2nzKIlXRg/udXecA==
X-Received: by 2002:a05:600c:18a3:b0:3d6:b71c:117a with SMTP id x35-20020a05600c18a300b003d6b71c117amr56340271wmp.31.1673265190764;
        Mon, 09 Jan 2023 03:53:10 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c4f5200b003c71358a42dsm20628619wmq.18.2023.01.09.03.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 03:53:10 -0800 (PST)
Date:   Mon, 9 Jan 2023 14:53:05 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        linux-sparse@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        gnoack3000@gmail.com, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        artem.kuzin@huawei.com, Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Message-ID: <Y7wAITZ/Ae/SwH9m@kadam>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
 <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
 <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com>
 <Y7vXSAGHf08p2Zbm@kadam>
 <af0d7337-3a92-5eca-7d7c-cc09d5713589@huawei.com>
 <Y7vqdgvxQVNvu6AY@kadam>
 <0dab9d74-6a41-9cf3-58fb-9fbb265efdd0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0dab9d74-6a41-9cf3-58fb-9fbb265efdd0@huawei.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 02:39:36PM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 1/9/2023 1:20 PM, Dan Carpenter пишет:
> > On Mon, Jan 09, 2023 at 12:26:52PM +0300, Konstantin Meskhidze (A) wrote:
> > > 
> > > 
> > > 1/9/2023 11:58 AM, Dan Carpenter пишет:
> > > > These warnings seem like something I have seen before.  Maybe it was an
> > > > issue with _Generic() support?
> > > > > Are you really sure you're running the latest git version of
> > > Sparse?
> > > > > I tested this patch with the latest version of Sparse on my
> > > system and
> > > > it worked fine.
> > > 
> > >  Hi Dan,
> > > 
> > >  git is on the master branch now - hash ce1a6720 (dated 27 June 2022)
> > > 
> > >  Is this correct version?
> > 
> > Yes, that's correct.  What is your .config?
> 
>   What parameters do I need to check in .config?

I don't know.  I was hoping you could just email me the whole thing
and/or the results from make security/landlock/ruleset.i.  That way
we could see what line was making Sparse complain.

regards,
dan carpenter

