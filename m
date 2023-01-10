Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2945663C18
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbjAJJBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbjAJJAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:00:17 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9F8544D7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:58:49 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so11230981wms.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3+knuQydFBSdXCzPBUm1wNWUOfzUCjvanxuabDgK1gw=;
        b=Vwsl/VitKXsjcFz1KYmcE983i6kgsxLO3q7CQ7b7PdZx3ibrn+X9o5JUrRrnrBHugy
         pzycvCwJ02EP/7RDyNObaKSV+y+uuYoK7cW8saBFKs1pds86xYXZ9QQQTifdYFX9VWp2
         1THyM/CrZw/izNVOqgh01Bnf04RZiZcd3ppMjfDC1B7/ppRKAJ6w13vX2qXMxZoNk75M
         NfSzaseLCJ+j5CZfN5geOd5+sq7qQySvQoGIEJN9efn2Rlm2Y3BePe7xpmbiX1M1D127
         KsZ2Zsk/xUp6QREU+YWGqJngQOaP9sW55fSGCDYZOfOfYN13Vw3svExxYl3TI9g+BSil
         5rbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3+knuQydFBSdXCzPBUm1wNWUOfzUCjvanxuabDgK1gw=;
        b=QRgYQJzKKBFD23+nUOdEaUGlcgi4PIFK2pEtVsgiItIsV3uxx5+jwB8SZr/K/A6k2a
         B3quTxCg3Rgcj3La9fdKmqgGxYeO0lBFapw3eEnT2xI9Gz1SJ//b0wXds8e6haDXhvtA
         ekkVRZUKXP6W22otabsA8Rym2LfKGjdRNQWwmPmglzpjw4Lq3ef+dEIHHFiGxt+CxWg2
         TtcrFnP4+brN0cB0GZzwxlBVORwb6uL5Pm8p9A8OcZKi9WEOVNJpFtYA05lHAUdz6IKB
         BzyGuB/6AQ/COtaV2oXY4T0b5LQbr96eLjIwccoQZ82DVKjbrPa6SmC8hG6/zdw3VhDu
         JKQQ==
X-Gm-Message-State: AFqh2krsPnpAPKhfuEJNiluK6/p2Xuq5+LvXQW0XhtngXdT5jN3R5hXW
        EBiRjssCVd0uqnnuKTiwKC+5JYq5ctrNrsV+UpMjSw==
X-Google-Smtp-Source: AMrXdXv8OA/a7Bzm1igJ9GaWS1l61b2HMCdSBanChN+V/gF0j2WiaQrSNFuB+mtRV3KwSXUhrLK8ux5RtUDldLL24DQ=
X-Received: by 2002:a05:600c:47cf:b0:3cf:ecdb:bcb7 with SMTP id
 l15-20020a05600c47cf00b003cfecdbbcb7mr2935722wmo.180.1673341127770; Tue, 10
 Jan 2023 00:58:47 -0800 (PST)
MIME-Version: 1.0
References: <20230108025545.338-1-cuiyunhui@bytedance.com> <CANn89i+W__5-jDUdM=_97jzQy9Wq+n9KBEuOGjUi=Fxe_ntqbg@mail.gmail.com>
 <CAEEQ3wnoKqN+uTmMmUDJ9pp+YVaLmKnv42RApzPbNOGg6CRmnA@mail.gmail.com>
 <CANn89iKY5gOC97NobXkhYv6d9ik=ks5ZEwVe=6H-VTwux=BwGQ@mail.gmail.com>
 <20230109100833.03f4d4b1@gandalf.local.home> <CANn89iJwBkCsuNH9vih30xy_Ur6+0dtbfs8wmsA4s7r8=J3cBw@mail.gmail.com>
 <20230109103922.656eb286@gandalf.local.home>
In-Reply-To: <20230109103922.656eb286@gandalf.local.home>
From:   =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Date:   Tue, 10 Jan 2023 16:58:36 +0800
Message-ID: <CAEEQ3w=ZyzamCKtYA76EksYiHM=-=mS5jaWwH5mk9nz-T0up4w@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v4] sock: add tracepoint for send recv length
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Dumazet <edumazet@google.com>, mhiramat@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dust.li@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 11:39 PM Steven Rostedt <rostedt@goodmis.org> wrote:

>
> But looking at this tracepoint again, I see a issue that can help with the
> dereferencing.
>
> Why is family and protocol passed in?
>
> +       trace_sock_send_length(sock->sk, sock->sk->sk_family,
> +                              sock->sk->sk_protocol, ret, 0);
>
>
> Where the TP_fast_assign() is:
>
> +       TP_fast_assign(
> +               __entry->sk = sk;
> +               __entry->family = sk->sk_family;
> +               __entry->protocol = sk->sk_protocol;
> +               __entry->length = ret > 0 ? ret : 0;
> +               __entry->error = ret < 0 ? ret : 0;
> +               __entry->flags = flags;
> +       ),
>
> The family and protocol is taken from the sk, and not the parameters. I bet
> dropping those would help.
>
> -- Steve
>

Many thanks to Eric and Steven for your discussions and suggestions, I
will update on v5.


Thanks,
Yunhui
