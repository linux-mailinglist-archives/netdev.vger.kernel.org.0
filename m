Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D996E25E2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjDNOhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDNOhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:37:20 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788BA4ED5
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:37:19 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54fbee98814so99800927b3.8
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681483038; x=1684075038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iE4lpdJlf0o5v1x8VmZQicpOdZNGALIdQ6MIl+iaUc=;
        b=JcPMQsr2Js157cPMkV8RegkhnjQx3p/HP6BhpqrpzvK5mijZqI7dkWLSOQMzMqX7GM
         GQP4gImq3jD6B3YD8pz4Bgb/OEocICIAfbyvav9/7JphjKjd7CqvSKFzoJJnYog4y1ku
         I9jyT+yi88uW+15uh1jqT6zjs83D9eV3Ai+xcluUGKi28Qlcs1maSV/hZObA7RkCzd3f
         S2/grhhoKJhBE+KttJyBoQbPW+EjH1wC2UGwxR9DrXtiqRsCYnRvF74kGXLSxxagtOyJ
         llvlrooN8y/rA8gWfV8t8+gLutDoS9g+WyA2SBw7JxvGca7f7vclqKCN7sYAxaJHO/zt
         Mmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681483038; x=1684075038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7iE4lpdJlf0o5v1x8VmZQicpOdZNGALIdQ6MIl+iaUc=;
        b=CWU3S2I69+6jjVeiOoS+f+oaRgnrcimFdlKASALK3hSFFKmU7lbzlkvqebpJXK0Zx3
         a1JOb0ZEUe/p6juqNiWjxyC5S5ZKaUgzOC4lhZsgqBoLirhDKjpSSPua6Ie1oBEoi1di
         INqdYgO8A3j8ZdFbtFRxT38R1+oAhD1XRvt4brk/hn4EmFdb4qYQpc9MsFOyiQpC6vHw
         EiB1ErmpVrOaZriFaVimf4DY8HMKRVVc31VmR9IKqCbcydSWc58Vkdky0RvJSu+WGrJO
         o4a8EX6FslYk59y7tO9LUBqlX8CnfhNgk2wXmJaBqIgkV5S+eTjTPg1hskXxUUktg5oF
         oESg==
X-Gm-Message-State: AAQBX9e2Hbv3LqNz2eRAJ3qd0quXOXIlQLKW8knSsZ8RqXS78HQ0b+vf
        QmF2L3zKxGKl5dgRO5fF6Qz2XLXYfyNCpCigTzAC
X-Google-Smtp-Source: AKy350bAkOQQy6ClP5S+UPzobrBsRMJW7wvcE7e6V3gIgYt9xEga0aIAkaCermENOZKL/A3UNo+2qkZxBTpnkNmSyHs=
X-Received: by 2002:a81:ad0e:0:b0:545:6106:5334 with SMTP id
 l14-20020a81ad0e000000b0054561065334mr3811521ywh.8.1681483038647; Fri, 14 Apr
 2023 07:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info> <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
 <20230410054605.GL182481@unreal> <20230413075421.044d7046@kernel.org>
 <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
 <ZDhwUYpMFvCRf1EC@x130> <20230413152150.4b54d6f4@kernel.org>
 <ZDiDbQL5ksMwaMeB@x130> <20230413155139.22d3b2f4@kernel.org>
 <ZDjCdpWcchQGNBs1@x130> <20230413202631.7e3bd713@kernel.org>
In-Reply-To: <20230413202631.7e3bd713@kernel.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 14 Apr 2023 10:37:07 -0400
Message-ID: <CAHC9VhQrDSc65njFBQ8sJ_zr2AcP-qQEU-BcAk5h69XhC=H=dA@mail.gmail.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 11:26=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
> On Thu, 13 Apr 2023 20:03:18 -0700 Saeed Mahameed wrote:
> > On 13 Apr 15:51, Jakub Kicinski wrote:
> > >On Thu, 13 Apr 2023 15:34:21 -0700 Saeed Mahameed wrote:

...

> > >The question is who's supposed to be paying the price of mlx5 being
> > >used for old and new parts? What is fair to expect from the user
> > >when the FW Paul has presumably works just fine for him?
> > >
> > Upgrade FW when possible, it is always easier than upgrading the kernel=
.
> > Anyways this was a very rare FW/Arch bug, We should've exposed an
> > explicit cap for this new type of PF when we had the chance, now it's t=
oo
> > late since a proper fix will require FW and Driver upgrades and breakin=
g
> > the current solution we have over other OSes as well.
> >
> > Yes I can craft an if condition to explicitly check for chip id and FW
> > version for this corner case, which has no precedence in mlx5, but I pr=
efer
> > to ask to upgrade FW first, and if that's an acceptable solution, I wou=
ld
> > like to keep the mlx5 clean and device agnostic as much as possible.
>
> IMO you either need a fully fleshed out FW update story, with advanced
> warnings for a few releases, distributing the FW via linux-firmware or
> fwupdmgr or such.  Or deal with the corner cases in the driver :(
>
> We can get Paul to update, sure, but if he noticed so quickly the
> question remains how many people out in the wild will get affected
> and not know what the cause is?

I think it is that last bit which is the real issue, at least from a
regression standpoint.  I didn't see anything on the console or in the
logs to indicate that ancient/buggy FW was the issue, even once I
bisected the kernel (which your average user isn't going to do) it
wasn't clear that it was a FW problem.  Perhaps the mlx5 driver should
perform a simple FW version check on initialization and
pr_warn()/pr_err() if the loaded FW is below a support threshold?
Seeing a "mlx5: hey idiot, your FW is ancient, you need to upgrade!"
line on my console/dmesg would have sent me in the right direction and
likely avoided all of this ...

--=20
paul-moore.com
