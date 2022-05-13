Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19675259C4
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 04:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376553AbiEMClY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 22:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376539AbiEMClX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 22:41:23 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A20A606CA;
        Thu, 12 May 2022 19:41:21 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id y21so8404144edo.2;
        Thu, 12 May 2022 19:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFB9cQ9noOBFGIiidp4HQrjNUAJsYZTV+Y0JhKPaQuQ=;
        b=RMHAZmSwXMmQK1OKkebepMMW329Xe+xv39LCPOg3gCwk5r5yEAjBSBHAYjJOqC9ODP
         vDKQtsCGzDSbBSPxE6xcCLaeYrCl5qQWPCHbxN8GmAsDrGbHI81mLzpd2KwkaIse2lAo
         ApfsdhcRvqU1S2U/grRDGw4tRJel8Ta0iAYI6GZvV0J4UjJW9O4t3G4Zv3B9z51KVJLg
         MPuYRmQVzkUUteThkJPsXnHR9sRDLIw5U9ozJcpDOqp29Py2MithQfhgrphJVFJrDYRP
         tOiB0OUdxgicvdvkgs0ASQ5i6S3EWJJx7JsfOFn6eKRKGijvdnCy/tCgyKsKw+f2kSeu
         F7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFB9cQ9noOBFGIiidp4HQrjNUAJsYZTV+Y0JhKPaQuQ=;
        b=QmD5hrjer3vHe8kYMie2uA+WaB7XNYRYWpNjstKnIPUp4JJa6VjZtgscB3fozSoUqO
         ZnrF627RFlClTIIsyOkzLwbeTGMgziIj5vvnQTWWJ3TawWcy9iZfhHXdUiq1X4C9e5Uy
         QM8ZkSfPr4fompKO7r4F3mdCFUGyiif8XQI+gvW8lNmsbyTdI5QvDa5MyRip8q12lzUD
         enLD2WLSzBfssByxPW6LQvOm+LjOoio4Ph47EX2h8fAsZ4i9pmFAVDCozPPx+ci9SKGz
         /jQiaWHMsFxUZI+RmZuclyObMyuHMdKNv+IfhKPujCtjBrjtYGna5NSt3n+8y9QJZo0W
         FtaQ==
X-Gm-Message-State: AOAM531ezt3ggw94NuZwoITxkNohOCH1GaBTDWL+6lEcNG462Oqx0P97
        AVe2W2h47w3i2IxcVJDlmi04YhafLw+9/E8FKRI=
X-Google-Smtp-Source: ABdhPJy+Ap6FzuUc3ioF762KIikeMnVImUI65GhwXhz3xdwyQIfZmsfrhbZk74wuellKGjJMgpj2ASE5uIf/p/D7wCo=
X-Received: by 2002:a05:6402:3326:b0:426:4883:60a with SMTP id
 e38-20020a056402332600b004264883060amr37299196eda.310.1652409679662; Thu, 12
 May 2022 19:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220512123313.218063-1-imagedong@tencent.com>
 <20220512123313.218063-3-imagedong@tencent.com> <20220512091558.350899ff@kernel.org>
In-Reply-To: <20220512091558.350899ff@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 13 May 2022 10:41:08 +0800
Message-ID: <CADxym3auygXR_p5xW1F81wX04SwKHAPPHiu_P94gT-w5vdi9Uw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/4] net: skb: check the boundrary of drop
 reason in kfree_skb_reason()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Martin Lau <kafai@fb.com>, Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>, asml.silence@gmail.com,
        Willem de Bruijn <willemb@google.com>,
        vasily.averin@linux.dev,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Fri, May 13, 2022 at 12:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 12 May 2022 20:33:11 +0800 menglong8.dong@gmail.com wrote:
> > +     if (unlikely(reason <= 0 || reason >= SKB_DROP_REASON_MAX)) {
> > +             DEBUG_NET_WARN_ON_ONCE(1);
> > +             reason = SKB_DROP_REASON_NOT_SPECIFIED;
> > +     }
>
> With drop_monitor fixes sending an invalid reason to the tracepoint
> should be a minor bug, right?
>
> Can we just have a:
>
>         DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
>
> and avoid having this branch on non-debug builds?

Yeah, it seems this way is more logical. I'll change it in the V3.
