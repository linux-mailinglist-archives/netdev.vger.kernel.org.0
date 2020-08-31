Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5552525784C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 13:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHaLZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 07:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgHaLXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 07:23:45 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F67CC0619C9;
        Mon, 31 Aug 2020 04:13:18 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q9so4996267wmj.2;
        Mon, 31 Aug 2020 04:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uX5Ly7ZqVaAQckCHREFfffv/fmmQxht5QxYuCQbtBCs=;
        b=RCQ8Y38IkEsRKfi7ilmBFtWJLuU8u0rog5ko6D5ad4AcsX59IjTVQdTgpPhcd1QRFO
         rlfGKhIt95EiYEd24U/OuT/9WSaJFDgeTigJp0s0GZKKNv1+evNi/Ay0whKe3TmGJGp2
         36gkIea694dwTpdn2a1M+yiVkE+TQGCcJdF6uxtbV2VKKVsBhQt7xLaiTc1ckSdaAxJT
         z8ABYOGTNww+gJarP1uf2aWnbpYEx9V/Tl9owDWyjgB7+4BPyYEhVPwKqqMpQaPvt8Ib
         GOBdlC4VN249tal7NfvacO7FloKwDk0bdLQiHCUIEdlCcMMlCn+7PHCTg4ICfRZ+Ad0z
         sItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uX5Ly7ZqVaAQckCHREFfffv/fmmQxht5QxYuCQbtBCs=;
        b=sAXtOBWAUkvFuP6rvLQE24/IlgWAXhF8xxfNQ8zBf6gtkMBFd5TWojQPvG+mgzjG4r
         ABX2BCsfsRHmf3VFyeB+z60DnGaqhatre+eT8ma5nbxYNKnaAWLgGb22Nbj2DkiXSxgV
         HFAvf1qNuzp1cRRMvGo66kNC1Lxq8Z5RMRc3TFn2G5tLsLf9Idmidq9n854y3HhlJlZT
         9kO91Vu+fkf/Hlu9peKZ9UKmif+TRlaHSwMaUmQoRwyuFHzjpTP3PmTciD8QzqD72sa2
         IV24hsec59cLQJ+aytZiGsJtxpSDvHsMhJYjIM8r+VvBQgOfCxYz27Y3Wi4yBEwl7tlE
         BZkQ==
X-Gm-Message-State: AOAM530MMMB/+gSThcYhiBm/1HArQLi/qeoDa12NGJs99e/yrpUw+D3S
        /A6cB895LNgGcy2Fy2iaMGMOZBvWbjts9ZN+/D8=
X-Google-Smtp-Source: ABdhPJyz4YJfhcMmmEjmx03mL8gMy9uDNs1OWGNAZnuoI5uc/4t/BfIU/xRp1W5iIK5K66/E+PYuiYgS6rwXR/8lSAY=
X-Received: by 2002:a7b:c1d4:: with SMTP id a20mr940532wmj.30.1598872397144;
 Mon, 31 Aug 2020 04:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200828161717.42705-1-weqaar.a.janjua@intel.com>
In-Reply-To: <20200828161717.42705-1-weqaar.a.janjua@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 31 Aug 2020 13:13:06 +0200
Message-ID: <CAJ+HfNjukM2SDFTHbiQcw=p9MGf4mBBhWMBhOhBX7RMvgjsxTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: fix to xdpsock to avoid recycling frames
To:     Weqaar Janjua <weqaar.a.janjua@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020 at 18:18, Weqaar Janjua <weqaar.a.janjua@intel.com> wro=
te:
>
[...]
> --
> 2.20.1
>
> --------------------------------------------------------------
> Intel Research and Development Ireland Limited
> Registered in Ireland
> Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
> Registered Number: 308263
>
>
> This e-mail and any attachments may contain confidential material for the=
 sole
> use of the intended recipient(s). Any review or distribution by others is
> strictly prohibited. If you are not the intended recipient, please contac=
t the
> sender and delete all copies.
>

Make sure this footer is removed for future commits.


Thanks,
Bj=C3=B6rn
