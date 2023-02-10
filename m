Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4B6925CD
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjBJSw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjBJSw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:52:57 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CF377B86;
        Fri, 10 Feb 2023 10:52:56 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id u27so7293784ljo.12;
        Fri, 10 Feb 2023 10:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aB/S456Dw8wRLid4uxm2PMqWgR4mR2mBzyOQ3Gakx9A=;
        b=iiP5QJTaif103hbVD5em2dZv3p9+UsDD7u7DBj71KO/5ggDGhCnnie5NuyA1utvlxJ
         BJ5Kb7W0wEQUXDjE5c6dlF3hNNTRgLr2gAB3JOQDUoiEQ48rcv20YJCBi3EL52z5kg7z
         T5MyqGVjZshQ0rPns59okvp3P1RTCYgLvDOh3HERIfkdmPBmwCapPk4i/53IAY9Uscag
         R0ghhkKO45YSAYbcXdq+Z9Y8o4vYNmqZWaseGroMc827ESHMn09E0jYKYehVxjz9xmPL
         Wqu8XcQIfUKd8lLSc8s6c2tVLbiEjvp6IdXrAhGd9PVqzaHDCisHJ/8OCFTKI9ZzpD63
         nTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aB/S456Dw8wRLid4uxm2PMqWgR4mR2mBzyOQ3Gakx9A=;
        b=luRODJtnKQV4mtabCsPLzxmvG1tKRR38jlGIHrBr0LB5XKWc27YuzhjtGPZaf5/oa/
         9SoaGUbrpKjEumamU6jWmUjbcMvjfkbZGTUUNjcFxLOLK2iVoaunznr43MBT2o86WNEd
         VoNWBh5ecCx1OS9i5YIRlpCS2stYDkTd/SDKVEW3r+cOnFZZqLuVVxxfAp2VdTPaChcX
         IrKR8oW+fblWrrWNOk/rSdl3ubRICGQYdVRZY7CkltO23TmdGcB+YIpzFdLDcTHNGAlJ
         8bMvG95Plx4PXCBl9DyioQh3JIRIq+uUZlhmnQgnoNRpLmQRzH3c7vfTEJi+GF8BVOvy
         peJA==
X-Gm-Message-State: AO0yUKWmgzP8FjVZQ4j0WVBwMcV10ZLTzN5t8ZuZoMDHQm5iFJ6OMjmg
        Xji4M8JTAhy2Zxoak7Cj1YU9fjuuUgWK8PdKqvE=
X-Google-Smtp-Source: AK7set+EzKpm78Yq7nAFsGM68quwoxWR8a1ccszAEu2N/r8WhYAko8id/HxAuAcrxrJXDL7eUFuK7AdnNgE8wo2r7VE=
X-Received: by 2002:a05:651c:200c:b0:28b:8956:9aea with SMTP id
 s12-20020a05651c200c00b0028b89569aeamr2662062ljo.166.1676055175217; Fri, 10
 Feb 2023 10:52:55 -0800 (PST)
MIME-Version: 1.0
References: <20230126074356.431306-1-francesco@dolcini.it> <Y+YC3Pka42SmtyvI@francesco-nb.int.toradex.com>
In-Reply-To: <Y+YC3Pka42SmtyvI@francesco-nb.int.toradex.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 10 Feb 2023 10:52:43 -0800
Message-ID: <CABBYNZLNFFUeZ1cb9xABhaymWnSiZjazwVT9N12qHyc7e0L6QQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
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

Hi Francesco,

On Fri, Feb 10, 2023 at 12:40 AM Francesco Dolcini <francesco@dolcini.it> wrote:
>
> Hello all,
>
> On Thu, Jan 26, 2023 at 08:43:51AM +0100, Francesco Dolcini wrote:
> > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> >
> > Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> > support for changing the baud rate. The command to change the baud rate is
> > taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> > interfaces) from NXP.
>
> Just a gently ping on this series, patches 1,2 with DT binding changes
> are reviewed/acked, patch 5 with the DTS change should just be on hold
> till patches 1-4 are merged.
>
> No feedback on patches 4 (and 3), with the BT serdev driver code
> changes, any plan on those?

bots have detected errors on these changes

> Thanks a lot!
> Francesco
>


-- 
Luiz Augusto von Dentz
