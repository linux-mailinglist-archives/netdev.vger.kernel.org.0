Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDCF66546D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjAKGRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjAKGRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:17:20 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1017E0A1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:17:16 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id ay12-20020a05600c1e0c00b003d9ea12bafcso8181280wmb.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0RrLy7xqWg1RnasudUvZBWKEA1yRY0PzlYprkCqFjws=;
        b=GyeBjW22NyAmEp9Vg91TZBgMb+YTns5QP/d9s835LoybvRg1tPhifllP1C7p5zxyBb
         ri3iK8Sv/Ig9OLEC0QeGSguv1neXysmQAgH1d4FkVN+7GsyiU71OhbnygOD26+kw9il5
         vGIz9c+QwmJ5Rwu4VBhQBCGaaMn9rPRW9PCAYTOvk5duKfguUCprUHObQn3OZuSPkQ04
         mWoT5Fz9CL0RyWs5oUeSuHxFit3+MAd3fmgu1ZPig9w1C9RrNCWs2coh2K1laR+TUuwA
         ELQyaAzueWIzqzPn2QrI+rpOoOy2OOEaTUBTLF54lycLEi9jP9yAD3HnzRzKGjjwtHgq
         MkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0RrLy7xqWg1RnasudUvZBWKEA1yRY0PzlYprkCqFjws=;
        b=lwTD5o5nESRlGIEoDjZOQK5WsCXZKKwCyMOQch5RkKdQ/Ye93rovAgEAXxZUHIylFr
         Sl+dhe/Gb0fMOr+gmG/kopJ5FOeiEhZhrN1YaZOLiUcRG9XKStUbCLGZSfiRvOw3mkBo
         Gbuw4qPsCCL7tWrSZtGCB+1Nk018wWD83GMc36o+RVW17JMYcRMJPS5OTv57chxVZrBh
         9wG2NAzi4tUOwlLWv8m5oqq8j6tVi7pATZMZEGzoAvueTmIwdADaCshM3xe1Qxjnb9tz
         27HYH8gLauNcBM2KMELKtZJL6SGX2VeyQVFgSfO0SykvQtYwmZT6g5hmVEVBW7eXEqUC
         TyQA==
X-Gm-Message-State: AFqh2kodI0MJbqj6e1hkcK7l0TISVLqi5YNQnLClF4yFgQVJMqXaHPis
        XfK8Y+eFaWqF46Rhdn2CvLKVRiutdy16YhgbH2Yzsw==
X-Google-Smtp-Source: AMrXdXvUXG/20qDMqPMjWOCkbdTXLsSllvNMxCWx5sZ8AC8O46XC7jpKSDg4yZu1o5EclM9TlPxoJ/kkytPH8oBqtPM=
X-Received: by 2002:a05:600c:44d4:b0:3d1:fd95:a8f6 with SMTP id
 f20-20020a05600c44d400b003d1fd95a8f6mr3752705wmo.189.1673417835232; Tue, 10
 Jan 2023 22:17:15 -0800 (PST)
MIME-Version: 1.0
References: <20230110091356.1524-1-cuiyunhui@bytedance.com>
 <CANn89i+Wh2krOy4YFWvBsEx-s_JgQ0HixHAVJwGw18dVPeyiqw@mail.gmail.com>
 <20230110104419.67294691@gandalf.local.home> <CAEEQ3w=aU3siD-ubhPB3+Wv10ARfUeR=cUHmvdEp2q+y105vAw@mail.gmail.com>
 <20230110231201.5eddb889@gandalf.local.home>
In-Reply-To: <20230110231201.5eddb889@gandalf.local.home>
From:   =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Date:   Wed, 11 Jan 2023 14:17:04 +0800
Message-ID: <CAEEQ3wn7XbsjfQaUR_Ka_KZz-+sb-edcQUtipspnUZQQ3+Y4ig@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5] sock: add tracepoint for send recv length
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Dumazet <edumazet@google.com>, mhiramat@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dust.li@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 12:12 PM Steven Rostedt <rostedt@goodmis.org> wrote=
:
>
> On Wed, 11 Jan 2023 11:53:24 +0800
> =E8=BF=90=E8=BE=89=E5=B4=94 <cuiyunhui@bytedance.com> wrote:
>
> > Hi Steve, Based on your suggestion, can we use the following code
> > instead of using DEFINE_EVENT_PRINT =EF=BC=9F
>
> I only suggested it because you didn't have that logic for the
> sock_send_length trace event. But if you don't care about that one, then
> sure, use it for both.
>
> -- Steve
>

Ok, Thank you, I'll post v6 later.
