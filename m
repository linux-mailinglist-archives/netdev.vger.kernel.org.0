Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4C566AB6E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 13:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjANM7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 07:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjANM7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 07:59:52 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8E78A52
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:59:51 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id a9so8748975ybb.3
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vwPBvGonDjbcL7L3Mo+r/8DCr3kLAVmVmzvw4QQtvYM=;
        b=YXUDyyrpvBb1zaRp6niSOAYv2S0mGTBYElOlwbX9A4C1I4JHRrIE+hRUsckEmJTAPe
         Z1/m2X3i4N2JX510KUUuXy8wYQmkq0WINDmpHgmnZ9JRH0ZZ9xGoJ4vvv1plI6Pv/sdb
         GLoVxJzA9sCpABn5cU5dbY3l+H++TPNpjIzbMHIAb+bprJXuUAadLPuVnFlXxswvHGmD
         HZeldzNTTS5WeboW5GRHSD5F/3e8vip68T4rF13WKZOfH9GUiyyv9yY6iD/gWKDVaem6
         ASAajnhuH1H2uHdOPwV6X37NmTqPlS0TSl3WfSc/0ONBMbZYltbKee+PJhQbQoTFLZak
         MTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vwPBvGonDjbcL7L3Mo+r/8DCr3kLAVmVmzvw4QQtvYM=;
        b=NxNjY/nKrzPrFyvzEkdsHmTf6N990KRxTqlIS+vtjLBqBDDFnluSYOBw/f7qeaYwB8
         7sMYRjvl8/I0rta44ETkGX5UBIaX1zDVU9O7mf0UFiqcIwswMs/kOb4DxVvsBvEbnrO9
         vWEf3wvilT58eFzNgtz1Hf3aEPEXzNKWcMa/Q3DH43zntm36wVNals42vX6HXUxClOdk
         /irE+EmLQiIN/dEL8KczoBolF0c3TMCCFrgZmaj5/1tTpbX3jr/m1OAIHjg28RveOrfK
         ttJl5YSyMY61t0hlTlJHBBmTvsZNC8KCrB/nfmugYNzuir/WGzh4CobqwicADgaEtcvZ
         Je4g==
X-Gm-Message-State: AFqh2krKDEhUNE8FHEemaqKtPoA/lzRYwSZgU/ghMGCTSl0vxOdrf4Lr
        HmJQOB6C9jKUX/7oOvb9FkXeTuyin0sc7RHkmJ8vHg==
X-Google-Smtp-Source: AMrXdXvQSezWMJVIJx6wpSwzvH2lqQEKkw7opbaGGCfXNYmGEGwY0T5swOLZwB2CnY71lxbOPwxcbT9uW2vT+wk3htQ=
X-Received: by 2002:a25:9f0f:0:b0:7cf:c2e3:85f1 with SMTP id
 n15-20020a259f0f000000b007cfc2e385f1mr593848ybq.188.1673701191031; Sat, 14
 Jan 2023 04:59:51 -0800 (PST)
MIME-Version: 1.0
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230113034617.2767057-1-liuhangbin@gmail.com> <20230113034617.2767057-2-liuhangbin@gmail.com>
 <20230112203019.738d9744@hermes.local>
In-Reply-To: <20230112203019.738d9744@hermes.local>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 14 Jan 2023 07:59:39 -0500
Message-ID: <CAM0EoMmw+uQuXkVZprspDbqtoQLGHEM0An0ogzD5bFdOJEqWXg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not really an error IMO (and therefore doesnt belong in
stderr). If i send a request to add an
entry and ask that it is installed both in the kernel as well as
offloaded into h/w and half of that
worked (example hardware rejected it for some reason) then the event
generated (as observed by
f.e. tc mon) will appear in TCA_EXT_WARN_MSG and the consumer of that
event needs to see it
if they are using the json format.

cheers,
jamal

On Thu, Jan 12, 2023 at 11:30 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 13 Jan 2023 11:46:17 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> >       if (tb[TCA_EXT_WARN_MSG]) {
> > +             print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
> > +             print_nl();
> > +     }
> > +
>
> Errors should go to stderr, and not to stdout. And no JSON support please.
