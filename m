Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475915E69C8
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiIVRlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiIVRlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:41:21 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33192E11B6;
        Thu, 22 Sep 2022 10:41:19 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id d14so4205986ilf.2;
        Thu, 22 Sep 2022 10:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=AsxpWsr5dzcIncNfx/+Sw1HyEwfMiBKVAKBEW7wNeQA=;
        b=HG1BCa9aD7EruuXSP8vfBpl2xSAcB9NgvDE4n3t4WegezK8iPhrhfTbs3Xxfdxp/aP
         0j4XfOQ90rYJJLxvR5Fxutq+CKSR+3NwG5g3gHNWC0rGeSJkCPwM1qeiyt5MoX9kie1E
         Ogc+09wvN660uSYqTrtW/DY7BHEKikOuBqjuMNkdFuICid58Qmi9sfyROy/V1LgkIpE7
         e2Nv1gEo4Vp0GQpWl3bRqM1059jceqcIcZbW6os/ZnPJ8J1PnWKNgSi8e2+WYP/WJpYk
         +8abyMsCFGIX1fgDuD8Pv5kCGUDjVFxUFNtnD5auEWqa0LNmLWv9bnrrUipYT443cCtB
         +LNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=AsxpWsr5dzcIncNfx/+Sw1HyEwfMiBKVAKBEW7wNeQA=;
        b=SILhDhsclPTFIm+N7bd9WIBU5yzLvANvhie9ePp8AY5zYqBcGEadNwbWw7l/Cs+S3q
         EvYaoF8Xsrt3ocT4iVCUPYlXg9z+U7rmD6Z1as2fV8F1evoRGxejjostj01Ap7cvSrjF
         w8az17etfgg8XmpOm5ttEBbPbaUNDy2mKkSHGsA0bWKO68SQTHev65IAxmqO9D4CEcTb
         TCEv7VIvgZIAt4ExPOKG9Nehhmv47XOr9JRDlSwkhdFzhwv1Bzz0cJjp0HEBwJr8pbsF
         s4wGk5lNoXdGtP1UlvzdMuAoApS2rfH7awQAzT63oukEmmNm26x6AIBEYB02sIcKDC6f
         Bo5g==
X-Gm-Message-State: ACrzQf3aUUJYVKFd6LpTLv/hbVKzpO6O9ne2ZCviMkpzHE0AZKe5JVJ0
        F1HhJu1TeBJbHISbmWMGvJrQwQvSKVNSZ67IoE4=
X-Google-Smtp-Source: AMsMyM5Iawxjt3SoOGTNllk8NVk3tyvcsl1U/lS7sz1j/GB7JoPgBuMEGvT0T6zJ1tbupUccXP7nLvzrv1dgRwQijjQ=
X-Received: by 2002:a05:6e02:152a:b0:2f6:58ae:ff0c with SMTP id
 i10-20020a056e02152a00b002f658aeff0cmr2429401ilu.237.1663868478589; Thu, 22
 Sep 2022 10:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220922031013.2150682-1-keescook@chromium.org>
 <20220922031013.2150682-12-keescook@chromium.org> <CANiq72=m9VngFH9jE3s0RV7MpjX0a=ekJN4pZwcDksBkSRR_1w@mail.gmail.com>
 <202209220855.B8DA16E@keescook>
In-Reply-To: <202209220855.B8DA16E@keescook>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 22 Sep 2022 19:41:07 +0200
Message-ID: <CANiq72=unhDJOGTg+ja4UdVRp8sG7Wc+_rqQhvJideA=WNjbFA@mail.gmail.com>
Subject: Re: [PATCH 11/12] slab: Remove __malloc attribute from realloc functions
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Hao Luo <haoluo@google.com>, Marco Elver <elver@google.com>,
        linux-mm@kvack.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 5:56 PM Kees Cook <keescook@chromium.org> wrote:
>
> I wasn't sure if this "composite macro" was sane there, especially since
> it would be using __malloc before it was defined, etc. Would you prefer
> I move it?

Hmm... On one hand, they end up being attributes, so it could make
sense to have them there (after all, the big advantage of that header
is that there is no `#ifdef` nest like in others, and that it is only
for attributes).

On the other hand, you are right that the file so far is intended to
be as simple as possible (`__always_inline` having an extra `inline`
and `fallthrough` would be closest outliers), so if we do it, I would
prefer to do so in an independent series that carries its own rationale.

So I would leave the patch as it is here.

Cheers,
Miguel
