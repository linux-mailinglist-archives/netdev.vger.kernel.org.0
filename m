Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71277644D78
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLFUsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLFUsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:48:01 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A4C2614;
        Tue,  6 Dec 2022 12:47:59 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id fc4so9221686ejc.12;
        Tue, 06 Dec 2022 12:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GAFKa0B2H6/6w0dZm7aNy9JXnPwcNQKFrtyaRPOt4YU=;
        b=cG23+e+VAgZFD5pniBKKHjKlAS5M0vzmeBJ41ucPyhDlJYTX4Hf4aeq2rKXZcEuZxN
         aUu3KcITn/NFEA0V+nIHXAlaiFc9ZkhA55pdNlnbLq+9mgitglmcXYip8KUWzodPb+iD
         aopk7bBZaDs97BcSnMQPqx3ZH2w/bdjOB+zDYxRNOrIzPxacx29gY2GRc+5selB0ULbD
         gzmqmrOvN96mVCjlBcBjUyxiX8HeZhi7UanP6BfyMQpTzBmfqerYe8WVYpMrh3SUoya9
         8VZvdr4BtdJWIhF4+XoM833QkrQEPbGXgwnUavHnisi8WyPUsoQh/PLc2wgg2KVfRdfO
         nmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GAFKa0B2H6/6w0dZm7aNy9JXnPwcNQKFrtyaRPOt4YU=;
        b=Obtj5tNcZk5xiQE4XnwedPOTDU9UYauUFKAe+APKJWnchCtkZWgotTATb5mdr+6I9e
         k71yGPURmT+huhUd7kUTiXPhbbyCFFTPy59cevO+pES+ilsarvKNKYOHp8QhHxo/0yaJ
         ZNGZ9CJhyRBNLFjPksWDG6NSityyo+x3BFNA0tT1Dz6xoSdgFKe/Yg85pXf7GZJebVlq
         H6sgGUtGwFhd6yW/lfBq1ztgqnv5XoYFxlqpwa/tsmHv+6SPsGH2QEMZswjhF+N4PUlH
         YOQuma9MoCqjdKUX/1RFceSxfoBcZcRl2/DwOchtids/BZ0fnDerEVoB5YaSO7reEKn5
         RMyQ==
X-Gm-Message-State: ANoB5pnlSTHb2K5Vx2K5gBdJDcI/51HxgoVOGbA6b4AU/3oQzB6pGSS8
        AJagitBuZUuQCUgt23xfo1AD67WiRP7+0lHsvNE=
X-Google-Smtp-Source: AA0mqf5/CzGdIF2RvANNjyLWBnuvFbiOFe/om863zc7GXRF8WqatzYmvTX1GkO6cT99Qc/xoyAliP5jsh880a3rjtS8=
X-Received: by 2002:a17:906:fc5:b0:7c0:8b4c:e30f with SMTP id
 c5-20020a1709060fc500b007c08b4ce30fmr29322582ejk.502.1670359678327; Tue, 06
 Dec 2022 12:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com> <20221206145936.922196-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20221206145936.922196-2-benjamin.tissoires@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Dec 2022 12:47:47 -0800
Message-ID: <CAADnVQKTQMo3wvJWajQSgT5fTsH-rNsz1z8n9yeM3fx+015-jA@mail.gmail.com>
Subject: Re: [PATCH HID for-next v3 1/5] bpf: do not rely on
 ALLOW_ERROR_INJECTION for fmod_ret
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Tue, Dec 6, 2022 at 6:59 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> The current way of expressing that a non-bpf kernel component is willing
> to accept that bpf programs can be attached to it and that they can change
> the return value is to abuse ALLOW_ERROR_INJECTION.
> This is debated in the link below, and the result is that it is not a
> reasonable thing to do.
>
> Reuse the kfunc declaration structure to also tag the kernel functions
> we want to be fmodret. This way we can control from any subsystem which
> functions are being modified by bpf without touching the verifier.
>
>
> Link: https://lore.kernel.org/all/20221121104403.1545f9b5@gandalf.local.home/
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

BPF CI couldn't do its job because of a merge conflict.
CI only tries to apply the whole series.
But I tested the patch 1 manually.
Everything is green on x86-64 and the patch looks good.

Acked-by: Alexei Starovoitov <ast@kernel.org>

Please send the set during the merge window.
If not we can take just this patch,
since the series from Viktor Malik would need this patch too.
