Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940C851E302
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 03:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392543AbiEGBa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 21:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiEGBa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 21:30:28 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849033AA49;
        Fri,  6 May 2022 18:26:43 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-ee1e7362caso4872692fac.10;
        Fri, 06 May 2022 18:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iDAhf762jxRhEv8fWwnY9wpSIpXGHrpFlmpaUo6C1zk=;
        b=F3gz8XL26fGIg5x4zHuPywcBt3scsTWHmrRlxUXkNEfEVYZl/M35+V+YGFWfo1lE+P
         yhotM6PX8de5M9NSCEYYSecqiOWoxVzkwSokt7PmQxJ834yfpEZne76p+bi2YybspM/P
         el4Lyw701k1uZ1l9gYwf3BUAbccvic8rYHyzGmcHgGXyyUe9LpH1NrLphqCE2YFQrUu2
         imT+3aMBlQzUZerRybx8SrUsoUBqjND8/NsQeokLI0WJ92ldvWKfU645zdimqXwxUIFn
         VR4hTGFntXAmxyuG51Drm0j3zyzGuNxV6Oaf8Joh+TF+4fZj2wkPtC75Hkl6w+/UeU7W
         dMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iDAhf762jxRhEv8fWwnY9wpSIpXGHrpFlmpaUo6C1zk=;
        b=HrC149XtE6741vFJqlJh5VtsY2uPrN52rL4BzEp4teFAK1liLyNsY9WldqpmHHHjRY
         v2Hph+6Nw4XS3PAYw4Ue2PvFRXRoV01AeUC0HHpuh82kqmghsG+gDN8ajnSfTYt3bMUX
         cLIyoKTjqHlUOpg3PpakF1gdrohOqAv02vuRGxPjWrfaQbFD40KLtlETkN2dGh6zfVkL
         R9IeY2wF/g56oZqPlcKZr8+IYTAFlky6kAZacfe/QFha28Jr9nIi1K3rZpGffnpsIV6R
         f7e2sZAHvuEGLE/9l9i7AmGaxchSUfdmweqOjGkcHnW/FNXHfDqK8H/817gl6IYUOY7x
         rWRQ==
X-Gm-Message-State: AOAM531xJirNqfDe9ZbL7a7ayfk9sUVHB60W2wHoj/0r+4mxQ6oktcvG
        wdCL2aKx2u6DhRp4H5pc2lAwRGTqSLzs0YEgFk3gzQkUMW0+WA==
X-Google-Smtp-Source: ABdhPJzyLNv+Q6ZAyNJ7GFtl4fwjM7lLihcjDwTRVz3yxuhErRy90ery7vxfFURM1YDzqoGEyqq1Pfrc60/WgfWMP1E=
X-Received: by 2002:a05:6870:1c7:b0:ed:b4b6:27a1 with SMTP id
 n7-20020a05687001c700b000edb4b627a1mr5626941oad.223.1651886802927; Fri, 06
 May 2022 18:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220505130826.40914-1-kerneljasonxing@gmail.com> <20220506185641.GA2289@bytedance>
In-Reply-To: <20220506185641.GA2289@bytedance>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 7 May 2022 09:26:07 +0800
Message-ID: <CAL+tcoBwQ2tijfzwOO6zb2MobCL27PcyN3foRcAw91MpyWg_VA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: use the %px format to display sock
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 7, 2022 at 2:56 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> Hi Jason,
>
> On Thu, May 05, 2022 at 09:08:26PM +0800, kerneljasonxing@gmail.com wrote:
> > -             pr_err("Attempt to release TCP socket in state %d %p\n",
> > +             pr_err("Attempt to release TCP socket in state %d %px\n",
>
> I think we cannot use %px here for security reasons?  checkpatch is also
> warning about it:
>

I noticed this warning before submitting. Since the %p format doesn't
print the real address, printing the address here will be helpless and
we cannot trace what exactly the bad socket is.

What do you suggest?

Thanks,
Jason

> WARNING: Using vsprintf specifier '%px' potentially exposes the kernel memory layout, if you don't really need the address please consider using '%p'.
> #21: FILE: net/ipv4/af_inet.c:142:
> +               pr_err("Attempt to release TCP socket in state %d %px\n",
>                        sk->sk_state, sk);
>
> Thanks,
> Peilin Ye
>
