Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCCF61DBF9
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 17:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiKEQWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 12:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiKEQWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 12:22:08 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC88D1A3BD;
        Sat,  5 Nov 2022 09:22:07 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id e16so4162658vkm.9;
        Sat, 05 Nov 2022 09:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=juJI1leQJgEEsPDlgCFtJkYlUYqxPwlB2KwyADVJ3zM=;
        b=Z2dIcEwxNRcnAmDyvaUxsN879xRWIYDQbMl/GDjx26OVCw2IVs1yab/QuVR1MFBIF7
         6z43Bxo78CVvC/2FwHCK/jvtfKgaGQcrkdcdY0sWHLBJM6KQfNTgfa/R7/H5EIRfTZiF
         EZGOfBnLKVDHmZ4XF6P4+f06gbj60NhEoGvZQUSiw7KCf0zOt14y3k/2yaS4Zju2VpdA
         W9NJi0CSy/6Pi2UpsfI7Dp4KkrPV379cF0R7FsWEpquRHT2nNKkc/gEvERi9jEgK7apK
         VnlEWm5jke84JwFm8701+5QdwToDFFNME46gfbTQkZCdGO0qiB6ZTtaYkjsnC9Z9rKKP
         oHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=juJI1leQJgEEsPDlgCFtJkYlUYqxPwlB2KwyADVJ3zM=;
        b=ruDXl4VyxQvEMe3jWeRygm1bI58PyQnNgl98pZonvh1uiWX5LgGowpaIY75UBn/KJp
         NJ+18jFSFvodS+jj/60FbYoSTZXf9u8mMS/K9xvmIlTT+/lzD55hi0MxDWjZ6E3ygRbQ
         3BbzO3t5hUYc9m0yR5zeUbnBpcbR7TMtS0mUZ9h3iw28RCB9o4q/k9jSj+Z7rAxbVlpk
         +kbEyAKaIFkTKhy67zDdvnA9DadbITJx7LysxrKN6LoQze6Rq34zk0ebrvJEW3pWI5A1
         VtFjxQzov9jvN6EW9Sf7kQbD07r6XcloMU8rhdxeRkADeKTPU+ztqUuBYV3OQqKSQssN
         aGVA==
X-Gm-Message-State: ACrzQf1t/Xe0HTNXrcFsfwI0s6WPd/ZboqjMusoI3j4TFzi1UKpT5BVj
        RLRyMg7In1fYFLjS2oxeD0U46dh9wnJrN4FvUjI=
X-Google-Smtp-Source: AMsMyM47BeYUhk5THZie1/6wJiGSx1LUO9igtOoXyEt8OoiqtWw8FjyUTx7TOsT/aODJlvqqYdkrcQL+GjvYZl0KzjM=
X-Received: by 2002:a1f:19d0:0:b0:3b7:6a73:34d8 with SMTP id
 199-20020a1f19d0000000b003b76a7334d8mr22078723vkz.25.1667665326755; Sat, 05
 Nov 2022 09:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221105102552.80052-1-tegongkang@gmail.com> <e03209cb-00c7-e282-c2a6-9a2bab0b147f@infradead.org>
In-Reply-To: <e03209cb-00c7-e282-c2a6-9a2bab0b147f@infradead.org>
From:   Kang Minchul <tegongkang@gmail.com>
Date:   Sun, 6 Nov 2022 01:21:55 +0900
Message-ID: <CA+uqrQCGO6+XgDCCMd=v+Qn+tn2n6uaNDF9Uro+hByHnWT1DdQ@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/bpf: Fix unsigned expression compared with zero
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=EB=85=84 11=EC=9B=94 6=EC=9D=BC (=EC=9D=BC) =EC=98=A4=EC=A0=84 1:16, R=
andy Dunlap <rdunlap@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hi--
>
> On 11/5/22 03:25, Kang Minchul wrote:
> > Variable ret is compared with zero even though it was set as u32.
>
> It's OK to compare a u32 =3D=3D to zero, but 'ret' is compared to < 0,
> which it cannot be. Better explanation here would be good.
> Thanks.
> ~Randy

Thanks for your kind feedback!
I guess I have to change the message more precisely.
I'll send the amended patch (PATCH v3) as you mentioned.

Regards,

Kang Minchul
