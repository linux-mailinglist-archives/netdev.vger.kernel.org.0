Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E73F215253
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgGFGDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgGFGDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:03:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C42DC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 23:03:07 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o3so14508281ilo.12
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 23:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GQi6fR1n5Ap9D6D0dmwyXsonweIYgwpD8HigYfPDIi8=;
        b=GLlCCSdM1VY8PrXFZlBDfpth+tiDCAyyMhM73J8XyPQ874xzM7ZjSXB+LzLhrb4zko
         86lq+uNMT56VrpHjWSgHQdccYTUf/Yq9HXlHzVbt2jUQlsP6LQ/0utjUvmn6i6P7KOQN
         KhtXfOFeJiCW570mfVrd2juV4g+5Dx6uOcvG6kV6RPwNRZeg1pecqSLs2iQV4LfCelMx
         K15zBRkRRSosyq7onfXEM9sl8JyOCVHoICbOM+5XSWug5O55A3u0C3S5GUusQbss4o6k
         0xvyfruga2WrcwshOUZF768MulebNQMQieRtpEJ/BLdMzAIcrMam29yLHhtcGnba0AmN
         WPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GQi6fR1n5Ap9D6D0dmwyXsonweIYgwpD8HigYfPDIi8=;
        b=lX7sdwFPYSJaUZRzFlA3/gCgY3xmb1w0S584BRxZDNUB6RPRmMBY/Qpg3JUmz//an2
         TpDfXfb8LGQWW9Dj21m4y+OsejxLiW+C7Snkl9KQf4CkC21TCemHyvNpaQVUAGJ/T8Vq
         uQoRW1TwaY03uaO8eU7YRt473CxAp1Y/+5gVMH8F/qvft99TyURT4W3tnHLaheY805qi
         P8DzDDuuBabubzfCPZdLrSSNdp4d93U9LepaszSDQDNiF0Jr3pYm1bz69uUu8dh1MzaA
         BTLJJ0zGE6Djxb0rKD0wMWNK925YHynmwp6Fh3tRpteSltO95ihLYxlivEPTuSVXp28g
         2t8g==
X-Gm-Message-State: AOAM532yMk6c+iuHIOnGoSQG8/qa9Lt32+2tOXks9lSOK7G4o98NiUWE
        cnbl93QPMTUkNpl2lMleQ2VqWVZKDX8bTEyDg0YF8IeJ
X-Google-Smtp-Source: ABdhPJyNft1a3IiCsCJwFYE+yBs4/gGtQOTE5rd3IdwUrd1aIHCP7zkDSXJjHHrXWTicoy+zbwLSiQH5fjfRkjOqeQk=
X-Received: by 2002:a05:6e02:128d:: with SMTP id y13mr28223675ilq.305.1594015386505;
 Sun, 05 Jul 2020 23:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
 <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn> <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
 <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn> <20200702173228.GH74252@localhost.localdomain>
 <CAM_iQpUrRzOi-S+49jMhDQCS0jqOmwObY3ZNa6n9qJGbPTXM-A@mail.gmail.com>
 <20200703004727.GU2491@localhost.localdomain> <349bb25a-7651-2664-25bc-3f613297fb5c@ucloud.cn>
 <20200703175057.GV2491@localhost.localdomain> <7b7495bd-7d24-c30a-d0de-72bff6301506@ucloud.cn>
In-Reply-To: <7b7495bd-7d24-c30a-d0de-72bff6301506@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 5 Jul 2020 23:02:55 -0700
Message-ID: <CAM_iQpV2v7sAQx5hvCL4cacRu36m4WLAS4omvr0N7kuzhq926A@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 5, 2020 at 7:33 AM wenxu <wenxu@ucloud.cn> wrote:
> Thanks=EF=BC=8C I also think It is ok do fragment in the mirred output.

Please stop doing it. There is no way to make this acceptable.

You must be smart enough to find solutions elsewhere, possibly
not even in TC at all. It would be best if you can solve this L3 problem
at L3.

Thanks!
