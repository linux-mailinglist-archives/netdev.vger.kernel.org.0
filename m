Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE7D6BAAC2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjCOI3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCOI3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:29:18 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834AE2FCEE;
        Wed, 15 Mar 2023 01:29:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id cn21so42098216edb.0;
        Wed, 15 Mar 2023 01:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678868955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3YJQ7G2Y1Bq5IEPvjKg8xL3l8kSzXrXpjCsFCFMtpk=;
        b=geCe+Kc4/wlPBqFrZLSN5pHIXzurZqEwmpqD7aFR3LRnVVxY8p+MepwqJhFVzVN2Ev
         CAp+pA6D/2euZEc6NB1mNWhPV7QRRhGwLb3qQ8uA41jVpIc31yr0Pc2Qug1+QZKhQijB
         ZWICG4NhgCOYIcNQGRmTipCUVWF+RCOhkGwfD/Usg9PqJKuNl7BmC0+J2dky6O3BeiwY
         RBYQJcoTh9oEOMupKC8MJ4pY2+eU3AgB87Oem8lk9Ds85wIfDu1MX1o/eYlCqFR0RBXP
         Hlbc/s3brn6DA7PAVrZSZ9OD3yRbzy9ynl8TQuJe2u/XjKO6VVuX8V6BB6+jKrhWBboq
         Rlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678868955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3YJQ7G2Y1Bq5IEPvjKg8xL3l8kSzXrXpjCsFCFMtpk=;
        b=lUm8O40+bfOHnmZ57qb11gbGuUgMOt8Yebw0uSDlTMfB+ga9YwZhIJHK2OPOwUC/Ks
         cxJYQjtlZKtPfvE/q+V8rrfjdcBxZKuCBLtN1LhFwzJtStdW5EGen0qTsXbHMzvsM3bR
         snoZWodaFlhiLNUkk/Wd893Cz+0pwxqNplGmVpxZ3hxlIsQpO5qVod0QTXd27quqkJS8
         /chB4OCJE8aqUNuw1CskQKvihHrBSNIdAFGSa8H2XDSy65MeFm6SkmK2JrOA4wk9t5rr
         CN+U3BW7jjuxH31FJYOaYeOSHOs9rP56q0/6pxZF7U2j+CUUd3kWUSYyjYRul5NACCkl
         Efiw==
X-Gm-Message-State: AO0yUKUjgO9m1o5d8v+sf0LF65QqptAYePCopyCFNi0tr7cOzl000pRE
        uYZTYt+udBITqoXnmNrbaLw3noeOFU3fEbjNv2Y=
X-Google-Smtp-Source: AK7set8oOeqy1yFA3HoBF4clzdt8VbL3z2Es98Fx3qfkBseTEF3TuUWl/mm/SduX6LersBkxjGFZXQTlpIUBevJZH40=
X-Received: by 2002:a50:8d11:0:b0:4bb:e549:a2ad with SMTP id
 s17-20020a508d11000000b004bbe549a2admr1013316eds.4.1678868955010; Wed, 15 Mar
 2023 01:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230314131427.85135-1-kerneljasonxing@gmail.com>
 <20230314131427.85135-3-kerneljasonxing@gmail.com> <20230314220924.52dfb803@kernel.org>
In-Reply-To: <20230314220924.52dfb803@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 15 Mar 2023 16:28:38 +0800
Message-ID: <CAL+tcoCOKwR-xPNO2Pb9sFAujb_nb60saJHjvXS6tM-7uqimtA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, stephen@networkplumber.org,
        simon.horman@corigine.com, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
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

On Wed, Mar 15, 2023 at 1:09=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 14 Mar 2023 21:14:27 +0800 Jason Xing wrote:
> > When we encounter some performance issue and then get lost on how
> > to tune the budget limit and time limit in net_rx_action() function,
> > we can separately counting both of them to avoid the confusion.
>
[...]
> More details please, we can't tell whether your solution makes sense
> if we don't know what your problem is.

Roger that. I'll write more details into the commit message.

Thanks,
Jason
