Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7F55F40D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiF2DYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiF2DYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:24:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32111D8;
        Tue, 28 Jun 2022 20:24:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so14674240pjj.5;
        Tue, 28 Jun 2022 20:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fj7BbdljqsoGparCST0EyCcPUKNtLNBlk+LCRCpdJLw=;
        b=oFx79pTDKe/0K4DzWTg5WbhaY9GMAgsDaFSkH6r1vPW1HFdOJXqGQ5UZxgywHDM3Ir
         0equTGt8PyPlERIlnTf5/BcxXxzGITpucSE2VIl8CV1o9ehzFCMhzuOGmi45/AK6qG76
         /8w9TpCEjcwZrf18xju/rDZxtqGU8P6zQ25P+y1i5vCqEbFPPa98WvDxnH8cFtX3sIwJ
         junUVkx5AYbgAFw0eC61vARiqpw1IzYsntMTivQEIBdgIUJa+1mBXf7au2lMkxwOomRF
         Tq177jWJbMD53EgF/Vw9Bn+IKNlGCEHOCstQTlq+u9cuVkwNV5MjGVV2oNYBWWI67o+0
         Kprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fj7BbdljqsoGparCST0EyCcPUKNtLNBlk+LCRCpdJLw=;
        b=oXJlEWr9GORBnTsXKEBiPrTqXFmJCmxnu7Eo/itHVD/+d2QUCErNnoFyEEHD7Awpxd
         X9TDcjBEeJqDOZ4b9mHB0EZzkkwaWSfy5wEgTb80yGw+xSpQyjs4sQ3aYFlvrb8eoCad
         vkr6ZQUdt6PJz6i3XIwBvf0/Tv4YchtzS84riNvnquk7d8VL8etOhqXhDSqAVfAfjWF7
         q1yTgemMYx5XBdK4fAY7n9Egu3tZMM1sLyXueNBnNgeMpDMZi+SXaX5p87Ly+W+xvUpr
         asNXkkjYPrAUHA7GXXV4L/WprbOomuAK11H2VPyhlyZROLOJKoD5uaeQtZrPSE5eAU8P
         +pHw==
X-Gm-Message-State: AJIora/k8F4rc5Gm/NSxX7x+P6nAq2G1WPW/RjzZYOWwIhVq/ilMxMLm
        5ZeL2xU9DHpIJqvbZ9Usm0M=
X-Google-Smtp-Source: AGRyM1vsi7CgNn+hm6JA8nRBvn1UfsHiN+DuVQjG+D41n++oNdHScStsgrICm72S8/mDUKvSMDDq4A==
X-Received: by 2002:a17:902:a701:b0:16a:65b:f9f1 with SMTP id w1-20020a170902a70100b0016a065bf9f1mr8387462plq.73.1656473045455;
        Tue, 28 Jun 2022 20:24:05 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-13.three.co.id. [180.214.232.13])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709026b8900b0016372486febsm10011584plk.297.2022.06.28.20.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:24:04 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E4C29103832; Wed, 29 Jun 2022 10:23:59 +0700 (WIB)
Date:   Wed, 29 Jun 2022 10:23:58 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marco Elver <elver@google.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kasan-dev@googlegroups.com, linaro-mm-sig@lists.linaro.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-pm@vger.kernel.org, linux-sgx@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/22] Fix kernel-doc warnings at linux-next
Message-ID: <YrvFzoH61feRFoxV@debian.me>
References: <cover.1656409369.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1656409369.git.mchehab@kernel.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 10:46:04AM +0100, Mauro Carvalho Chehab wrote:
> As we're currently discussing about making kernel-doc issues fatal when
> CONFIG_WERROR is enable, let's fix all 60 kernel-doc warnings 
> inside linux-next:
> 

To be fair, besides triggering error on kernel-doc warnings, Sphinx
warnings should also be errors on CONFIG_WERROR.

-- 
An old man doll... just what I always wanted! - Clara
