Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1761A319
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiKDVRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiKDVQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:16:55 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9105159FD0
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 14:16:18 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id g7so9009828lfv.5
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 14:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IiSSvltbs+orEkhWCs/r/4iSzlaVVIMtCXQm0YR/1V8=;
        b=g1fth9mlR0rt5pZmy8BMiwtHESGKjYZuzHObgqko03PxdOdywMQeRPY0PUTY10DC9S
         dYcG+vpJPgZ3zM57o14UXupsvPSq0DZc+wLn8xH4pqbP7d8jCvWwhpEib9wKL8mC3uPw
         OVe3jOdYhy/qv/OITyC8lbJCBPATo869JpHNBYTSjdQgafBDKaAFzT8ZujbCuUdaK/81
         ZXWzZ2Qs97X/PM0hUIkDFY5vVf9xNO1e9s1txR1rZvTs/jJYxzZXfViVdVPISvWIdDI9
         gk+t8W3160dDpfecJMH/zoxnm8mX+qdCVJupJCdbKQc6kw/qlggmb7K1KzQ2MZ/wGs3H
         28ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IiSSvltbs+orEkhWCs/r/4iSzlaVVIMtCXQm0YR/1V8=;
        b=IPYTnKm3N85vgmNg2tJ1u7Ew98WLeS2rFcBsDFS3WH5xb39gAiIArYEVMup/ybXtJT
         UKlm+pdnNQQWw+IY4mQA07htDvDD6Tgjq1iT/wvCnU/9HIsN3OnqRAtLWYZ/cFeQEpoP
         X8L27n6lwVBP02FhDyMtpgYEkyvrjncpFpvoaypzk3EHK2q0e8GSrAfPF4va0mh/zyy6
         AWoS9uPlqPYMZMs2Q8/zX/D76iSGg2xyJ/QEgSnhupCsDPl84PGzGveGZbKh105/ra7h
         fP+klNLEARjLFA4zHbPLPggmthHwRVk9sCPUTcHktYAwaSZedwALxMLgiqyXyxSvE5X0
         66Kg==
X-Gm-Message-State: ACrzQf3jxmolKIzPAzPA3E6BVgguk+keY6M29xXZLrhH8JAOzJu+ZCA5
        bwofUyV4AoyOdz9wPfdCiElVs2IcZQ5L2Bejk+toKBNBYZI=
X-Google-Smtp-Source: AMsMyM6SipJ2K9ZJB5bhhr0FABi4rKI9XvIckYZtu03HI4u/oOGcpQsbXiiUVBm8q+hjBllGqsf/BphExZKzwXvTQiY=
X-Received: by 2002:a05:6512:c1b:b0:4a2:6e25:2844 with SMTP id
 z27-20020a0565120c1b00b004a26e252844mr13479486lfu.411.1667596576233; Fri, 04
 Nov 2022 14:16:16 -0700 (PDT)
MIME-Version: 1.0
From:   Yuval Kohavi <yuval.kohavi@gmail.com>
Date:   Fri, 4 Nov 2022 17:16:04 -0400
Message-ID: <CAFPmz75pz6KXFe0GXrCjsExywMWNEwpdszbtc7RS5wwLOCTWHQ@mail.gmail.com>
Subject: bpf: bpf_redirect_peer - Infinite Loop
To:     netdev@vger.kernel.org
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

Hello,

I found a scenario where one can use "bpf_redirect_peer" to create an
infinite loop.
To do so, just create a veth pair, and move one of them to a different netns.
the attach to **both** pairs the following program:

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>

SEC("ingress")
int tc_ingress(struct __sk_buff *ctx) {
return bpf_redirect_peer(ctx->ifindex, 0);
}

Any packet sent to the veth device will trigger an infinite loop:
Because bpf_redirect_peer moves a packet from ingress to ingress,
after it does so it triggers another_round in
__netif_receive_skb_core. And with this configuration another_round
will be triggered forever, creating an infinite loop.

I'm not sure if this is a real security issue, as it requires a user
to set this up in a faulty way, but as bpf is not suppose to allow
infinite loops, I figured that it is better to verify with Netdev

-- Yuval
