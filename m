Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF773224624
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 00:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgGQWF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 18:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgGQWF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 18:05:56 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B94C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:05:53 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id z63so10155808qkb.8
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pcRLyIOuohgTZcHiW+G/hiOFzvQq7PxrG+wiAhJhvbI=;
        b=TtEd10LZJc+geLCqW7r7/Z+B1am62JXY0IERsARY6S5awC00yyTCDcoja7D7w8RVX1
         W2e1W68XJQjh6GE9RGFXFt+YnOzZ/DoQIHekv/WJKvRJdOwhxkX+XvOtfcNnzi7WoJ03
         TBF0ggLzYS43DfN11+rBdAaUq/pJGW77826vQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pcRLyIOuohgTZcHiW+G/hiOFzvQq7PxrG+wiAhJhvbI=;
        b=leEvqY4R25IBsIAwhJrmcuFEixGEulsCryaKIzQrRW+4wAHfi9Msdm53jPmtvcejK5
         NTg5DU5XVOQMYuNH33VIk15hSUzPGeYzrHumoJwqvekvM5q99tpIcKl/g9UqGUd5Yvli
         K080Smn0rehZnIzB2iy16GzrQV1CvwLIpTPzRDHZ2AAEOhlTdMDr+RiR4xohql0N+NCL
         +PbPamWauPA7BMp73W+P9qHFCh+9Jyp+WE4AWwVlR2iL0MAwd2Ht+B4WCWNP8/RmK2MX
         B336Ynr0U0d+/Kzpqqu2fmR9ncd3W63MDtjs4hp5bfOfe1FFpplpcvAh6UovRb5T8uC9
         zOHg==
X-Gm-Message-State: AOAM533Nn/jqliGyQRWNL1szipGReR+btgiZlQQPVGldv8bImSzV3VmM
        xVUZz/Tp4OrpoCxRHXWV8rkP9Y6iPvNC0NgVg7VJt2vf
X-Google-Smtp-Source: ABdhPJxQoxdDkrLXxe93gNGX9hf26R2R85uWTeyeVjJBPhpZFsXXbsoPQKXoRf9rd9XqHZUE/YliYoJGjhlOURN45Ko=
X-Received: by 2002:a37:4050:: with SMTP id n77mr10914898qka.431.1595023552837;
 Fri, 17 Jul 2020 15:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200717205958.163031-1-kuba@kernel.org>
In-Reply-To: <20200717205958.163031-1-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 17 Jul 2020 15:05:41 -0700
Message-ID: <CACKFLimsi2do2pzYqtZjm20jRa=L9nBeNFjgJBGz8ea5h-ecNg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bnxt: don't complain if TC flower can't be supported
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 2:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> The fact that NETIF_F_HW_TC is not set should be a sufficient
> indication to the user that TC offloads are not supported.
> No need to bother users of older firmware versions with
> pointless warnings on every boot.
>
> Also, since the support is optional, bnxt_init_tc() should not
> return an error in case FW is old, similarly to how error
> is not returned when CONFIG_BNXT_FLOWER_OFFLOAD is not set.
>
> With that we can add an error message to the caller, to warn
> about actual unexpected failures.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
