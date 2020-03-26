Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600A7194510
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 18:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgCZRHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 13:07:34 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:36133 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgCZRHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 13:07:34 -0400
Received: by mail-ot1-f49.google.com with SMTP id l23so6633277otf.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 10:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/dIsHmyN42YhqEmk6knYyBtFZRPBUjAoKTwwSH8+zCc=;
        b=XKYF/jzEHQnCYN82eLJlNsK8mO13O3uQLi+shWrn7BKqm9Tsb6tYn7zJAE92XWuCKm
         luZ3g6e/tuJtyBOeJTSUPX/CG2p0qz4tmMzLWapFlgwU5FlGtbyXV5bj2F7SHx4lnTgL
         UE5l6fg0RdLCTuG09BUGP760Mr+lu2J9W0v4SNkYcx2FFKF3mKcoJnHRiPv31EfoVoyK
         8+nECd9OoHIZ1J3xZPC9mS9TOsAZA/qL1zRIDbreI3enJvC0mxSojZNHzU3Sz/SAQbUG
         BpkUnOXub557QqVsxj0yB63FENKkZPOZruVM0F+tdBnTmN4pdvrHrk28NPzOu2tcS6PD
         ROiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/dIsHmyN42YhqEmk6knYyBtFZRPBUjAoKTwwSH8+zCc=;
        b=oDIxxBiZf354vVzwh+2k/wWvSHc6m6kBOiLqPD+3/vsjkVipn1EtkrLLWuwRHfcaOp
         GoDHnjvo1/4W/wZDoceqBkQDdBP3o9zUIlui7qx2uif1BSrdYsL/LPnRjU+UYTt7plt8
         UFUIU48bH7s3Zio+6pYgcL294MH78z3AgthCgkCXnmVa+s140TIzU5qjSqhTRl3KWsTn
         f1fwJ28iN9xWZGLQdxoHJb6EoNTlfab//ThKQALAIIUVUzA8bZWd5nKEw3Fo45sKFBWM
         WoBKANTVXwp7MgVb17fz8lh/8q/1Ga1mNNXiymAkuI7Fh3xPI0dgePK+/jHj3eb87yFw
         DCJA==
X-Gm-Message-State: ANhLgQ3hm3hWsk43yLAg63xN62TBiocO4a07AIqkxWzoPhDE0wT51AUV
        tiN/hxeM0nTOjIqAYMKp0/E3NfhSfNJasEafyEzRtKOZ
X-Google-Smtp-Source: ADFU+vvQiMFVNZRi8X4+rDhN8Qcf4LvrIbGMOWeMoP8zvGdZ5rwgNCe+Ui45ynuGiIEueerg/ZSty2RRNmiWbtdpEjU=
X-Received: by 2002:a05:6830:22e8:: with SMTP id t8mr5698395otc.48.1585242452950;
 Thu, 26 Mar 2020 10:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com> <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
In-Reply-To: <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 26 Mar 2020 10:07:21 -0700
Message-ID: <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 7:24 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> > On Wed, Mar 25, 2020 at 6:43 PM Cong Wang <xiyou.wangcong@gmail.com> wr=
ote:
> > > Are you able to test an experimental patch attached in this email?
> >
> > Sure. I'll compile new kernel tomorrow. Thank you for quick patch.
> > I'll let you know as soon as I have anything.
>
> I've compiled kernel with the patch you provided and tested it.
> However the problem is not solved. It behaves exactly the same way.
> I'm trying to put some printk into the fq_codel_reset() to test it
> more.

Are the stack traces captured by perf any different with unpatched?

Thanks.
