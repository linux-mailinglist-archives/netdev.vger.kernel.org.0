Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2CD533CBE
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiEYMf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiEYMf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:35:27 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7536D96A
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 05:35:26 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id v5so16275820qvs.10
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 05:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/A2wyDaNzDKlw/qvtJ6FS1LUC1S3cZ+h0mgvejXLlQ=;
        b=Xu0TlTNRdwdUzPc+JG7TdjcIcmHQVTnDdMtn2/xYgcHTdk79peQrh9W0ndYk8aiTtu
         4jdxFmD5UknvI88YVoWg8gKAOx8ED/n1yiBVPLl43W305r3CnALPVFcDqADWto0L3Z4O
         aWqLKq9rOV6xa2J/4s1V5lbBpOG02aXz3/f57Ch6VJLrXXbqf1t0p9XHjLdBBQ9Jg7Ww
         M9atpVK4WiZ5ELkuZyUTjaJ6v31f6uQs931T6ty9sbmfHjStLPGrh8+UvmrwLeI5QSwi
         p5gQvyw7udp0gDXeVIG7Myk1P2ccWwzOaLCU5YBChIs//ogjtKU9CAwb3Zan4xgLgpb+
         NCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/A2wyDaNzDKlw/qvtJ6FS1LUC1S3cZ+h0mgvejXLlQ=;
        b=Km0d+A5cCZSONF7Hg0gQXcct/fO6cY7gw6YEfhjEy8bKdOjgBJZLX+osnIMgv4Wpwg
         VzWQh/1w+wStbj1B1gXh1j95mc8bKF2GAaOAIK6rs86KPXsd1CvsCPlM1NbdEk6ZRDTZ
         TwRrffb7tfjvhLoGSAMLxEOBUSKkR5BxHn7DWf9sRPBbGS85i6hveXC2ZyOo0xmGN786
         djvi2nwcoe5HavFTzvFqgEfpj2Ad85hPk6WnaLDFbIJ5z4I3yE1092JXAFfVkYq3Lya0
         8ziTqEdgYqnDUfVOOVsr5SRtjwO+4GnUzbmZq8q2PWfbEckxPb8yYNfMoL7wbPRYf8sk
         ugqQ==
X-Gm-Message-State: AOAM533k7bl1pT3XZRts8kEfkIkspP7y/5lw1MtiIIACEItL8O/sxQp+
        oAQQRPzN/LDESgUcHNInXwPt9s6d7y4=
X-Google-Smtp-Source: ABdhPJwZLvX9UmMxzuWuaO1jrJ2HurnfDb2LKK3LxauzyWc6mU2V2eMbnSFJgzhQh/QZqoYhC9+6qA==
X-Received: by 2002:ad4:5ce8:0:b0:461:ebad:2abf with SMTP id iv8-20020ad45ce8000000b00461ebad2abfmr24941662qvb.20.1653482125750;
        Wed, 25 May 2022 05:35:25 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id d204-20020a379bd5000000b006a09515d012sm1153153qke.50.2022.05.25.05.35.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 05:35:25 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-3003cb4e064so40397207b3.3
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 05:35:25 -0700 (PDT)
X-Received: by 2002:a0d:db12:0:b0:300:55ea:66cc with SMTP id
 d18-20020a0ddb12000000b0030055ea66ccmr2046488ywe.348.1653482124711; Wed, 25
 May 2022 05:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220525031819.866684-1-luyun_611@163.com> <Yo3YoZWRkygFyqUc@Laptop-X1>
In-Reply-To: <Yo3YoZWRkygFyqUc@Laptop-X1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 May 2022 08:34:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeoy9v9omBOMyL=3NY8ayEz6gPaTcZXStCuTdmHWQtYHQ@mail.gmail.com>
Message-ID: <CA+FuTSeoy9v9omBOMyL=3NY8ayEz6gPaTcZXStCuTdmHWQtYHQ@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/net: enable lo.accept_local in psock_snd test
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Yun Lu <luyun_611@163.com>, davem@davemloft.net,
        edumazet@google.com, willemdebruijn.kernel@gmail.com,
        liuyun01@kylinos.cn, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 3:20 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Wed, May 25, 2022 at 11:18:19AM +0800, Yun Lu wrote:
> > From: luyun <luyun@kylinos.cn>
> >
> > The psock_snd test sends and recieves packets over loopback, and
> > the test results depend on parameter settings:
> > Set rp_filter=0,
> > or set rp_filter=1 and accept_local=1
> > so that the test will pass. Otherwise, this test will fail with
> > Resource temporarily unavailable:
> > sudo ./psock_snd.sh
> > dgram
> > tx: 128
> > rx: 142
> > ./psock_snd: recv: Resource temporarily unavailable
> >
> > For most distro kernel releases(like Ubuntu or Centos), the parameter
> > rp_filter is enabled by default, so it's necessary to enable the
> > parameter lo.accept_local in psock_snd test. And this test runs
> > inside a netns, changing a sysctl is fine.
> >
> > v2: add detailed description.
> >
> > Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Signed-off-by: luyun <luyun@kylinos.cn>
> > Reviewed-by: Jackie Liu <liuyun01@kylinos.cn>

Acked-by: Willem de Bruijn <willemb@google.com>

ps: I did not really suggest this fix, but no need to respin just to remove that
