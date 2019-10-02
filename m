Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59401C45CF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 04:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfJBCHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 22:07:15 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:54553 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfJBCHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 22:07:15 -0400
X-Originating-IP: 209.85.222.49
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
        (Authenticated sender: pshelar@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id E2FC720004
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 02:07:13 +0000 (UTC)
Received: by mail-ua1-f49.google.com with SMTP id w7so5802107uag.4
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 19:07:13 -0700 (PDT)
X-Gm-Message-State: APjAAAUC9gveYXINKV79+Py8PkqUhYdduq4C5kauU+wv5Xx4QXF5P14k
        Gr8MOpvz8PWEJj0m8dLGmxvyzvtxRwbvJH2uOB8=
X-Google-Smtp-Source: APXvYqxLM4xaimub1wYHkRKyKELzgehuIRfp8QBov3ZJy/d8Qc8hWuc7L+JpWL72BYXZTobxg76dX+dwhb5YzE/U6Po=
X-Received: by 2002:ab0:6e2:: with SMTP id g89mr486879uag.124.1569982032626;
 Tue, 01 Oct 2019 19:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com> <1569777006-7435-8-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1569777006-7435-8-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 1 Oct 2019 19:11:02 -0700
X-Gmail-Original-Message-ID: <CAOrHB_COPWe2TERGPb_KS6W=Vt6vXzAmKKEUrdbf9q_gatJa8A@mail.gmail.com>
Message-ID: <CAOrHB_COPWe2TERGPb_KS6W=Vt6vXzAmKKEUrdbf9q_gatJa8A@mail.gmail.com>
Subject: Re: [PATCH net-next 7/9] net: openvswitch: add likely in flow_lookup
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 29, 2019 at 7:09 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The most case *index < ma->max, we add likely for performance.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/flow_table.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index c8e79c1..c21fd52 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -526,7 +526,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>         struct sw_flow_mask *mask;
>         int i;
>
> -       if (*index < ma->max) {
> +       if (likely(*index < ma->max)) {

After changes from patch 5, ma->count is the limit for mask array. so
why not use ma->count here.


>                 mask = rcu_dereference_ovsl(ma->masks[*index]);
>                 if (mask) {
>                         flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
> --
> 1.8.3.1
>
