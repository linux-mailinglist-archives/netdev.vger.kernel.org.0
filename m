Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D726ED6AE
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 23:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjDXVTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 17:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjDXVTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 17:19:06 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911A855A8;
        Mon, 24 Apr 2023 14:19:05 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-b995f13cb89so3853081276.2;
        Mon, 24 Apr 2023 14:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682371145; x=1684963145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ELNYGHZIHKIFqJnEo8rrxCvQcGZL8aQd25lTdSNpTU=;
        b=WI1XsKYMpgoFidFg4IhkX3e7yhAD7vjHTBtPnW2dFXLaRH0nNpnghSEw5/otikrx8T
         hmY0Ty0T6EnnQ8G/InQB0UUTwbsnO0RnnwZwir5BMQtxj0wcIndwKMJGhJX5US5qQ89r
         DvI66B6LVvdHu7pKMbiuZfcbCfIUufQ1TjzxqQfB8ybEfByWvL1gzFqTQgF1uURlOAN6
         zFb5PkwiTJi4KLuiAOF6J6gfquGxErPE0y30MTrNcxS6hztoSqia14YX0zcn6HxroEvG
         KkdeoxqJP3m9y/KsOmLunn+brG+SGkhYrLClxoLb54KITdHIp/Bj/5A71br/IQcSXrmK
         5W7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682371145; x=1684963145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ELNYGHZIHKIFqJnEo8rrxCvQcGZL8aQd25lTdSNpTU=;
        b=klOo+XQpsdJKpCTW/mPx+QpHVufk05RaSynupWZ/kuDzJWrZKQ9xeMCgfFJInzkCPR
         0wa3JertD3K3TpKJCIgo/sCwb62ZxiHCfNcUKvNsrRzs5wB8QrKV4K7aV5ue7CsalNgb
         YVBKrlyzt/enuUNwSYchB83dh/G3v4TSCoq7AkOC56JcY6b/b9i178xT7vhleVuXrqaM
         rO2y9k00EqVdr1zZV2i08xRMwxlUSwXO1T7OlCDWNuyPCD6F3SHMoUuAtIsDRB5MIlLA
         iYLxZoqzK4Ulw0q55pBynk137QCLlSCL88h5Rzcsh2VUvriiZauYWuducEw43bapE0CU
         CYFw==
X-Gm-Message-State: AAQBX9fmdh0S4ITYFaGZCH7hOiuhakogxR4aBWx+gTQXbiNs/Ewvn4xA
        RNsc4vX0OW/kN+N3/1Hk99j9QoeQNqUFIqqvsVg=
X-Google-Smtp-Source: AKy350bIutNAx2s3uim7XhIGk4I/A1SpruAMfqxCi3BtHANN2gnfUfyRu2mDo2WKaDgILlZ4O/PjnkSdWyuqzRO1kL8=
X-Received: by 2002:a25:ccd6:0:b0:b95:72cf:8c80 with SMTP id
 l205-20020a25ccd6000000b00b9572cf8c80mr12196588ybf.51.1682371144597; Mon, 24
 Apr 2023 14:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
 <1681863018-28006-4-git-send-email-justinpopo6@gmail.com> <03dadae3-3a89-cdb0-7cd1-591d62735836@gmail.com>
 <932bb2c6-71ce-525f-fbb2-a0a742ee8e12@gmail.com>
In-Reply-To: <932bb2c6-71ce-525f-fbb2-a0a742ee8e12@gmail.com>
From:   Justin Chen <justinpopo6@gmail.com>
Date:   Mon, 24 Apr 2023 14:18:53 -0700
Message-ID: <CAJx26kXf0QOvOPRG+nPpJ2rfNcuX68oqejbzOG4awe6feTvMyg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: bcmasp: Add support for ASP2.0 Ethernet controller
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, linux@armlinux.org.uk, richardcochran@gmail.com,
        sumit.semwal@linaro.org, christian.koenig@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 9:33=E2=80=AFAM Florian Fainelli <f.fainelli@gmail.=
com> wrote:
>
> On 4/18/23 23:35, Heiner Kallweit wrote:
> > On 19.04.2023 02:10, Justin Chen wrote:
> >> Add support for the Broadcom ASP 2.0 Ethernet controller which is firs=
t
> >> introduced with 72165. This controller features two distinct Ethernet
> >> ports that can be independently operated.
> >>
> >> This patch supports:
> [snip]
> >> +    intf->tx_spb_index =3D spb_index;
> >> +    intf->tx_spb_dma_valid =3D valid;
> >> +    bcmasp_intf_tx_write(intf, intf->tx_spb_dma_valid);
> >> +
> >> +    if (tx_spb_ring_full(intf, MAX_SKB_FRAGS + 1))
> >> +            netif_stop_queue(dev);
> >> +
> >
> > Here it may be better to use the new macros from include/net/netdev_que=
ues.h.
> > It seems your code (together with the related part in tx_poll) doesn't =
consider
> > the queue restart case.
> > In addition you should check whether using READ_ONCE()/WRITE_ONCE() is =
needed,
> > e.g. in ring_full().
>
> Thanks Heiner. Can you trim the parts you are not quoting otherwise one
> has to scroll all the way down to where you responded. Thanks!
> --
> Florian
>

Hello Heiner,

The implementation is a locked single queue xmit. Not sure how
netdev_queues.h fits into the picture here. I believe I am handling
the queue restart here.
+static int bcmasp_tx_poll(struct napi_struct *napi, int budget)
+{
[snip]
+ if (released)
+ netif_wake_queue(intf->ndev);
+
+ return 0;
+}
Let me know if I am misunderstanding the feedback here.

Thanks,
Justin
