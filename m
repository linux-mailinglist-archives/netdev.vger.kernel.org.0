Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18B62D581
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 09:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiKQIwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 03:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbiKQIwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 03:52:05 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3179CBC6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:52:05 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-39115d17f3dso6269677b3.1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j2G6VBye6lDfLZBX/Rq6Nfy8Zgdvty8GsJtEgoNE0HA=;
        b=rjUr5CoEUTXBpV7aP93AQn0oX1Gd3rBF/MKGrUpJJlz99hkwPIJpRisu1+uiwlXZzO
         3i4JG9z1rZROt46taUBHM9kVz+WkMWciD+WxOU3R2NE0sq286ArlkcumxasoduflsEH2
         IQTe4qGlMH+p9vu/YpdB3JCNssKIz+jDF8CKg7YSrrJdPyWGYDipm7O+7+4hRnZ7XV3J
         hj8u+qv36gApKMCkCgH+pUBICqIhmctekozkQUFInW4t1zj7w6ckWyFhsdh7En3BYJrP
         +v0+pZE1UWrbFA770uaTZVwQKKuY/I0ocZgQOSEfUCr/qIhDPPS3CWie5CAcuPCdTS74
         SnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j2G6VBye6lDfLZBX/Rq6Nfy8Zgdvty8GsJtEgoNE0HA=;
        b=W2feuXspRg751NScueBIRKL3+O/n0ApQ9iriuoZgaNog0Yfz7+FwVXVUxp16TduFw4
         cgeAcUed5/ImtjcEy5sz5iwNGA72z8ztMxI+QgHnCHrXvHRqSFf4zd5Bi5gILlIxTiRd
         Hw+9VTLv6Nux/1CVhighSq11SzhDvjXQEXEhjz3iu5BtGzAJgYJLUk6AG6KkKuahZoyo
         cRLZ6igCEUULkagywsLCbgD03Y//kPYyPx0A1pKSnhyl0kCtwb/UZg1Lil35G7tVYsjN
         yzZRTjvBHE6EtwZKOUJpkIlgIZcL56nc19g72+oZ/yjoSa8IH+DeeZevfvtsuIIIRIU/
         knDg==
X-Gm-Message-State: ANoB5pnzdR3zI8TuWTGkiZuVqOUGKZVRiA+If6xOY8eQp1vkeeh04Ek/
        Tuq6upNcSNbrYbB9R/SK5k5a336lgtKOcnoziCjjKp8C4jk=
X-Google-Smtp-Source: AA0mqf6Y1V66zw5MMGW4qwLYY9m3hKPynVMp6SDwKLFvSieTFR+rYli2nIOyCEB/lAlcUQN2jiM2KAsILaRWEUnm/48=
X-Received: by 2002:a0d:e601:0:b0:356:d0ed:6a79 with SMTP id
 p1-20020a0de601000000b00356d0ed6a79mr1056006ywe.489.1668675124095; Thu, 17
 Nov 2022 00:52:04 -0800 (PST)
MIME-Version: 1.0
References: <202211171520.UF5VyYSH-lkp@intel.com>
In-Reply-To: <202211171520.UF5VyYSH-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 00:51:53 -0800
Message-ID: <CANn89i+va1YaFBk=3WYX0Qt1FEfz8oSnuAx2N8OxKfcAWwE6HA@mail.gmail.com>
Subject: Re: [net-next:master 25/27] net/core/dev.c:6409 napi_disable() error:
 uninitialized symbol 'new'.
To:     Dan Carpenter <error27@gmail.com>
Cc:     oe-kbuild@lists.linux.dev, lkp@intel.com,
        oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 11:36 PM Dan Carpenter <error27@gmail.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> head:   d82303df06481235fe7cbaf605075e0c2c87e99b
> commit: 4ffa1d1c6842a97e84cfbe56bfcf70edb23608e2 [25/27] net: adopt try_cmpxchg() in napi_{enable|disable}()
> config: i386-randconfig-m021
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
>
> New smatch warnings:
> net/core/dev.c:6409 napi_disable() error: uninitialized symbol 'new'.

Thanks, I will take care of this.
