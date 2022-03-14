Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D11F4D85CD
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiCNNQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbiCNNQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:16:02 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD902AE11
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 06:14:52 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id v2so3805518qtc.5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 06:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rdm6WcHd2UZKtrYNzZbFzqUQd4NUiFFh3tDX3bGnuk=;
        b=ZJbPZTWCQpkBMpm4c7zzdBjLhFwYV5Mmfc7nb2sDKttaMgwlrxtZrnxy7dovr/2v0/
         R7bc9A/ZRWtKh+gulNgN0ahSlBP+/lSl74r26+9jiJ6zzV/p8bcMpLKK26YHSt0RfN4S
         wu90+G9FCm3YHHET0U9Q7ETPkMKtiQpTi48B4WOl0G0TagY82uK5UBvDGZvuAPE0EJmd
         nVmbJsp2oip/LD617ON0rPerhIk0rezkoUgc4XuehAnq433rX9zgk33HSVwpX6+6RjUU
         NnMCrfyYEMaornZoM7r/L5ZSursaVNYEoozJjvVCZpzCgUea7X12b3TmelNJ8s2QUzSN
         fkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rdm6WcHd2UZKtrYNzZbFzqUQd4NUiFFh3tDX3bGnuk=;
        b=rjmUFjH9ijVmVSUKLKZN3QeIhGhTIA+vtOd0Sb0/+HyHwmj1JyIDG8RyTHp4LtKH+U
         8Es0e08dhCGEo2pqAp7hthRbYKF4zILlbeePelwNmW/7keRZIfSLW57GsFBkWWJ9LblK
         uBXyKW1/f76Xdjyv7VeySb10m2mvGD8zV10vLjpGwcPtGybDe6f6uioproxPH5bYamrA
         DTItIQHDfpGm/1AKB47fqb7LqhQL8WsMshJVP+YslKD/4OdyeWmUNpJGMx0rQQ0OzeA4
         R4YWe1lGBiET06aEB+FYRNN+t3dBGzu5rJykgkl7VwkYGYmpPHxoeRIX33c/k0dqumnM
         BFBw==
X-Gm-Message-State: AOAM531AHntIsTKvXkFESWOSEpaoNfDAktAGfB4/QfgqkB2QSRQNYL4e
        LuOTarxe3gvaVnil+L7H6Ryl9OkCSFIEESU2P2ZtXA==
X-Google-Smtp-Source: ABdhPJzp+LJ7N9PBedtu0a94sxgYSVBoqLsNOYckDzrN4CCHX0/wxVuma4fRc3DM1r30N8emwMq+4JHJz0Tl2LgVavY=
X-Received: by 2002:ac8:5a84:0:b0:2e1:4f1d:36fb with SMTP id
 c4-20020ac85a84000000b002e14f1d36fbmr18471370qtc.54.1647263691295; Mon, 14
 Mar 2022 06:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211201000215.1134831-13-luiz.dentz@gmail.com>
 <20220125144639.2226-1-mike@fireburn.co.uk> <CAHbf0-FEVZZYg7U__YXqPmS=XETb2pObB-8CX+vh8=-HivppJA@mail.gmail.com>
 <20220312144512.GQ3315@kadam>
In-Reply-To: <20220312144512.GQ3315@kadam>
From:   Mike Lothian <mike@fireburn.co.uk>
Date:   Mon, 14 Mar 2022 13:14:40 +0000
Message-ID: <CAHbf0-GTexadb=Ypk+gn8_KfUHjHZW-Vtzh1V_M08Tv=nd0Xrw@mail.gmail.com>
Subject: Re: [PATCH 12/15] Bluetooth: hci_event: Use of a function table to
 handle HCI events
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, luiz.von.dentz@intel.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Mar 2022 at 14:45, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> It seems reasonable enought to remove a spammy error message.
>
> Can you resend your patch in the proper format with a proper subject,
> commit message and signed-off-by line?
>
> regards,
> dan carpenter
>

I've done that, but I'm not sure if I need to do anything else

The patch was based against 5.17-rc7, but just let me know if I need
to rebase it to a different tree

Cheers

Mike
