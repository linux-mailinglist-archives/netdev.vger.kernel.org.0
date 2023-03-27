Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04046CA227
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjC0LIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbjC0LIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:08:12 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8C459F9;
        Mon, 27 Mar 2023 04:07:47 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-544787916d9so162528617b3.13;
        Mon, 27 Mar 2023 04:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679915266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RnlG8EW/Y6v27XyheoThSlIrzCWXQvtjhpisnLHznMk=;
        b=eK2HE/XnQwP/UNazlTsLT+STq4LxZ4z467zoabUG41KnUDGUecspn0OYZ2STe2Cge1
         4uRacuZzBBC20AVtybGUtwrRN+MwDiwpseVwKrxuA/5LhNZs9r/dKsTzCQQ/GvssC+Mf
         doS1N2Zy4GQl4YAbMoatYXxYsiHtFq8PlAbD2IczChTOrx9XgvKj1JPyEvicl73kdQiz
         OFROyxbUmjHgFAjnzZx5vK6rSLGbqRnus2CvQcxU890A50bP4b6s3ebYct8SZH70rWkx
         7qqKx/+6mnv7yHHFsYY0cjmnAjm6K3WDRydcXj5JS2W6p/261zozs34C4JKYFZhkI1tR
         x+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679915266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RnlG8EW/Y6v27XyheoThSlIrzCWXQvtjhpisnLHznMk=;
        b=rzScrMt/QJEpj/Rxfw82fI6GCqQ2Hf9j9eRB7RVSFXAzslmJ3NDrOiQYYPjSHqr0lt
         10Yi7w+u5/Pd++zLgURaEr82Cfz9daawbiF7WHGuZ6L+5GwjywRfCuVCRA3VNTWDpNGu
         vWZI74T41CEQIOF4rjgvxJNXpznZ+M6aOxyeUgBUwaRAFB3l1DC/iJCSXVLy35tPNYcW
         r9KTz68BQa9824BPpfve8L4d/zuxs0S/K8q5uFS6i65O8jGCk1/Y//VuWkOA8bSWTIQN
         bGmlcIMWdZh1eA/RMmV4XHphHXGQ6Qn7ES1x9sIC9yTdxYOLwNz52JKaDKqnRiiPpZ9w
         HL3A==
X-Gm-Message-State: AAQBX9eTMzpuQJ9kcBfWXY+HNEUsMLXGoIM50EYLtOPxoFIUzTQ06SQQ
        AEp/1UvsrJkQWcUt9b9j/wE=
X-Google-Smtp-Source: AKy350YZMjhH7tb4pzL5/0rvgmO5yEYLCp3ZV9n6PhLVgcwQ1IaQMmz4B1OUopQ/wbC9XJrRag/KwQ==
X-Received: by 2002:a0d:d8c4:0:b0:542:7d6d:498a with SMTP id a187-20020a0dd8c4000000b005427d6d498amr12486299ywe.23.1679915265995;
        Mon, 27 Mar 2023 04:07:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p184-20020a81b1c1000000b00545a08184bbsm1879102ywh.75.2023.03.27.04.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 04:07:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 27 Mar 2023 04:07:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        davejwatson@fb.com, aviadye@mellanox.com, ilyal@mellanox.com,
        fw@strlen.de, sd@queasysnail.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <a03e3716-d708-4a38-9ce7-0cce7af46780@roeck-us.net>
References: <20230228023344.9623-1-hbh25y@gmail.com>
 <fdfa0099-481c-48d6-8ab8-0c84b260e451@roeck-us.net>
 <f3eb7ec0-99b0-0ed3-0ffc-5ea20436bd08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3eb7ec0-99b0-0ed3-0ffc-5ea20436bd08@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 05:05:37PM +0800, Hangyu Hua wrote:
> On 26/3/2023 22:12, Guenter Roeck wrote:
> > Hi,
> > 
> > On Tue, Feb 28, 2023 at 10:33:44AM +0800, Hangyu Hua wrote:
> > > ctx->crypto_send.info is not protected by lock_sock in
> > > do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
> > > and do_tls_setsockopt_conf() can cause a NULL point dereference or
> > > use-after-free read when memcpy.
> > > 
> > > Please check the following link for pre-information:
> > >   https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/
> > > 
> > > Fixes: 3c4d7559159b ("tls: kernel TLS support")
> > > Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> > 
> > This patch has been applied to v6.1.y. Should it be applied to older kernel
> > branches as well ? I know it doesn't apply cleanly, but the conflicts
> > should be easy to resolve. I'll be happy to send backports to stable@ if
> > needed.
> > 
> > Thanks,
> > Guenter
> 
> Look like Meena Shanmugam is doing this. Please check this:
> 
> https://lore.kernel.org/all/20230323005440.518172-2-meenashanmugam@google.com/
> 

Excellent. Thanks!

Guenter
