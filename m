Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A5A42D1AF
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 06:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhJNEk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 00:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNEk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 00:40:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4336AC061570;
        Wed, 13 Oct 2021 21:38:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v17so15209655wrv.9;
        Wed, 13 Oct 2021 21:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wgv6cDEm6n/7wB+5ada4bNuNyCqeYPkJ/qfH7uQLwdw=;
        b=HBqlbpKTnGP1oBL4c0ock7YYEUfuEpFtHRG8LE+ycRa1fw1zk50ai68cRxyfJYnh/l
         7IJwcKjFpBMfNXGn6Llamu3+Ilj3b62xtTrj7ZVKHB8KgHhYoB4F+cWOFxOJSD/1vA+6
         I8gJhjd6CC6O/wwLOE50j1516nsaJyGOZeJgN2oiGd7kx5IbfCZ1NC4MStD3KeykJFZa
         c01/oFJBv1PeHZ3dR+iMLqP+CCRerN1T4T8HXur+tSFqK+ZaKx7cxsdwykpllKcdxACx
         3Y38aEnBDooF6RXWIfYjd0tB3owcclhpy7IksdPt9eP+Jpxx5mmslqlJtQm/HVghh8k4
         9vIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wgv6cDEm6n/7wB+5ada4bNuNyCqeYPkJ/qfH7uQLwdw=;
        b=rohoXRT51fJp4iGJkhStEceyTWlVTIHDHxeTN6ZJjZcZzs5W5bJzpIsU9he2K+VMaf
         uA0SG06t89BpYCg2I3cIJKoE/6+sBKACQ7a9KjLlSJKNno/fLuJ5NA2CLCfRGtVrfFpT
         PhrBrz19AIqNOR709nBcTW7Gd2FGAOnYO2RkIdpsIdATDP7LQcz0n6xWkVKbbr8nbY9K
         EAE3nffUThF5Kn56u0mot9L83K6h+glLq4CQPVtKVoE603Y0QKJiG8yuZWKvtNM9xQxS
         jComxQWKbd2wnGuSS1XZK1avx6E4KP3ZGxaJCCKstr2o4sf2k1a5IBWhkjD7g/IAzbAj
         j1tA==
X-Gm-Message-State: AOAM5308lw3xL731lLqOciviD9yyBDgMEHm9SC2vxe4OxIedxk7mwI8D
        6LghsQE5mJCAKc33UJVQm9enVKshM9y2XNUbcZnmIhpahn+TEw==
X-Google-Smtp-Source: ABdhPJxSelOiLlZl4FOTD/U2o55/uu/hebvyjCb43lohPc/vEuzmnHtnUYE1H2Ni2qUg7V+BGd/a0/W5Jw22+rJX2Is=
X-Received: by 2002:a05:6000:162f:: with SMTP id v15mr4098049wrb.118.1634186332786;
 Wed, 13 Oct 2021 21:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <b97c1f8b0c7ff79ac4ed206fc2c49d3612e0850c.1634156849.git.mleitner@redhat.com>
In-Reply-To: <b97c1f8b0c7ff79ac4ed206fc2c49d3612e0850c.1634156849.git.mleitner@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 14 Oct 2021 12:38:41 +0800
Message-ID: <CADvbK_dc0fuSuSdGihgL2Ms3_ZhQx0Jd5k+-wFR5fM7ss52r-w@mail.gmail.com>
Subject: Re: [PATCH net] sctp: account stream padding length for reconf chunk
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 4:27 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
>
> sctp_make_strreset_req() makes repeated calls to sctp_addto_chunk()
> which will automatically account for padding on each call. inreq and
> outreq are already 4 bytes aligned, but the payload is not and doing
> SCTP_PAD4(a + b) (which _sctp_make_chunk() did implicitly here) is
> different from SCTP_PAD4(a) + SCTP_PAD4(b) and not enough. It led to
> possible attempt to use more buffer than it was allocated and triggered
> a BUG_ON.
>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-sctp@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
> Reported-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
> ---
>  net/sctp/sm_make_chunk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index b8fa8f1a7277..c7503fd64915 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3697,7 +3697,7 @@ struct sctp_chunk *sctp_make_strreset_req(
>         outlen = (sizeof(outreq) + stream_len) * out;
>         inlen = (sizeof(inreq) + stream_len) * in;
>
> -       retval = sctp_make_reconf(asoc, outlen + inlen);
> +       retval = sctp_make_reconf(asoc, SCTP_PAD4(outlen) + SCTP_PAD4(inlen));
>         if (!retval)
>                 return NULL;
>
> --
> 2.31.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
