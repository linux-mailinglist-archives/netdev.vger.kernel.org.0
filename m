Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64406866DD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjBAN36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjBAN3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:29:54 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8173E098;
        Wed,  1 Feb 2023 05:29:22 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ud5so51433408ejc.4;
        Wed, 01 Feb 2023 05:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o5RAqFv4pYOa5JzrxZt0vZ4G4DAREm5CcDv+otFo5eA=;
        b=Al8L1qZd+si5urgDXLIkXeBFPnzdORNbH95yxab8hD1qvx8Eqal1NU6elIBc0ukEJH
         A98DrQRnm/qhYBbPDzwqu+jnGoUjm+DuxY0NI6p7QPpFvi/q9ZZebFtnfNwnTy3ryNlt
         883Fyb7evIY7lOs8klZOMcGfFVG+Pt1440+q6tzOwrzPYABFaCw0XqJFhpbtPZ/fYbGY
         SL1T8pm87YanZtk1jbAvHWFJLRPHIlmaBu0hN4rpJwPUP4fPwUJMGDeqTk2MtDkWWXVO
         U6vI+80In2Xqjb61seQlZwj1941d9/729RjerPjVboc17rKMH5RQokJ+0tqVMKlaQru6
         toOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5RAqFv4pYOa5JzrxZt0vZ4G4DAREm5CcDv+otFo5eA=;
        b=o18GNFdr2FxYr/ETHeRuV7QOFtc2hMpdP+O7xDCmjSnv7MjeP0iHRY8pZbwxA3eQpu
         EREPVMin1UG/zGAFHxbtB4ogZjRUrb+MG79DoApPZgraYyhaoILfOqmq4LE8OZAFoSiz
         vI+zEHiMZnPcz5vAdQVM8ecqKlxcBWvsloCv4BdCzrotLtiLTUU6tNYPKa4vqWBss+sj
         selgw077+WQ+DorwGxO1Hk5j3B/Stue3LpQ47e7SR7PrbmoO4cZhNLKGM5AVr7wFJTmP
         jEqClAUB1qnjXIEZaOlEkaifo3jo3PrPTbbqElWsbQsRsERQgFWh/K2PbLEDbRyFxFb/
         jeaw==
X-Gm-Message-State: AO0yUKWEwUhx4jkzleJTBZrhSitsw/Ba21353m0fsuZXEA99/8CsVS7a
        4R3ttWBzrTfUWYNmyHIA+ZIpM2MO1GXQOhFRHXk=
X-Google-Smtp-Source: AK7set/gpbqxFS5raSbdy7HY4cEfgXV09A04lh/3/z7GW6ctm3ocB6SlI8/7c9gvyGf3I/dbHmBnp9x96j2HSq+CpTw=
X-Received: by 2002:a17:906:560e:b0:86f:9fb1:30a8 with SMTP id
 f14-20020a170906560e00b0086f9fb130a8mr691205ejq.181.1675258160744; Wed, 01
 Feb 2023 05:29:20 -0800 (PST)
MIME-Version: 1.0
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
 <Y9fdRqHp7sVFYbr6@boxer> <CAL+tcoBbUKO5Y_dOjZWa4iQyK2C2O76QOLtJ+dFQgr_cpqSiyQ@mail.gmail.com>
 <192d7154-78a6-e7a0-2810-109b864bbb4f@intel.com> <CAL+tcoBtQSeGi5diwUeg1LryYsB2wDg1ow19F2eApjh7hYbcsA@mail.gmail.com>
 <af77ad0e-fde7-25da-dc3f-5d19133addba@intel.com>
In-Reply-To: <af77ad0e-fde7-25da-dc3f-5d19133addba@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 1 Feb 2023 21:28:44 +0800
Message-ID: <CAL+tcoD94KByy-Xz=ZiCt5gXZ0YhOjWU=vrOzRxezwRtuQmcJw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v2 net] ixgbe: allow to increase MTU to
 some extent with XDP enabled
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
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

On Wed, Feb 1, 2023 at 7:15 PM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Jason Xing <kerneljasonxing@gmail.com>
> Date: Tue, 31 Jan 2023 19:23:59 +0800
>
> > On Tue, Jan 31, 2023 at 7:08 PM Alexander Lobakin
> > <alexandr.lobakin@intel.com> wrote:
>
> [...]
>
> >>>> You said in this thread that you've done several tests - what were they?
> >>>
> >>> Tests against XDP are running on the server side when MTU varies from
> >>> 1500 to 3050 (not including ETH_HLEN, ETH_FCS_LEN and VLAN_HLEN) for a
> >>
> >
> >> BTW, if ixgbe allows you to set MTU of 3050, it needs to be fixed. Intel
> >> drivers at some point didn't include the second VLAN tag into account,
> >
> > Yes, I noticed that.
> >
> > It should be like "int new_frame_size = new_mtu + ETH_HLEN +
> > ETH_FCS_LEN + (VLAN_HLEN * 2)" instead of only one VLAN_HLEN, which is
> > used to compute real size in ixgbe_change_mtu() function.
> > I'm wondering if I could submit another patch to fix the issue you
> > mentioned because the current patch tells a different issue. Does it
> > make sense?
>

> Yes, please send as a separate patch. It's somewhat related to the
> topic, but better to keep commits atomic.
>

Roger that, I will write another patch with your suggestions (labeled
'suggested-by your email address').

Thanks,
Jason

> >
> > If you're available, please help me review the v3 patch I've already
> > sent to the mailing-list. Thanks anyway.
> > The Link is https://lore.kernel.org/lkml/20230131032357.34029-1-kerneljasonxing@gmail.com/
> > .
> >
> > Thanks,
> > Jason
>
> Thanks,
> Olek
>
