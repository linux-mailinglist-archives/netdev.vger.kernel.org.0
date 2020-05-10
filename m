Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099DD1CCC3E
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgEJQbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbgEJQbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:31:12 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06863C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 09:31:12 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id r2so6158137ilo.6
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 09:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R3Lh3zlbp+VgIx64Y0Z3m3xyvnLp02R3HuGaYMYp4Ho=;
        b=EUikPIJEHM2YJ4VeE4pfAoo+eMWjIT2fteHV/Cy22/B8M6snUOKJmiK81GX1KAN70e
         gnOWpOk6hQz1znkMRSTBQM5v3O5D2VGZcn4xW40bf42MQqfwika2KVOkweSwUJqZOOn2
         p6sgmTV4JJKXAldYSScCudwVX78zZRppN1IpKkIzR6+KLxi0Da8mS7ejEeKnkVN+ZNF6
         0IWZp8JuvpXfbi/aUJzPzJe1Gdp8HE9gNfkgwVfrq1hJbJV7oIfwxGy1ACcTTKSCWZBr
         tZ9nptawM+kbsheJSzmEvHdhPBB9y5LWyiFeQxw9Rjg2Z+Ht8Rk4DIeO7lwQlYLTv7Aa
         1N7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R3Lh3zlbp+VgIx64Y0Z3m3xyvnLp02R3HuGaYMYp4Ho=;
        b=ZTbriTudkjzZh3O0nbKU2DnFuJoiYLMzWuxXU/LoeLG/m9cWJb/3w7xgXEVK8DlktK
         4mw7UfqP+93SlTuYdtgE2tDzU6Fs36oHqXkmbkn92eRV7gskdZWusHUC1t6JSeF8F+0N
         Az/dyV3hlMJkI8CTWp83hn69SLdSnKww4O7NY0NJSbT4bGtIRP8It/1ykc59I/4/jJUa
         u5BkKQLlzp93SKB1D5uMBJ3yaCf+dlZ+HU6C7C23R5zR3omXi7f39bDdm5yFkdky2W+i
         qcMING6ZIqNHEVxPb/Ckpx3DGdLqaSbnYrGz1YHaJogXr2/GX10uE7qu+erCPea2LvO9
         paPQ==
X-Gm-Message-State: AGi0PubFpBwuzOE1f8KjLY/BWrnAad3dES96pjQGGelnePAkRktNLHCN
        x+UVgPmoaMSBLQHEoYzYXW6lls4ihkTxy0P4sCI=
X-Google-Smtp-Source: APiQypJH5HkG/gu/+M0KirfZOtIhOFZCVKtqlrgOHdbA9gA52oA1k3w61MTOCKNFJhxeoPnOB7ECWpd/PnyPnsok/UA=
X-Received: by 2002:a05:6e02:f81:: with SMTP id v1mr2242784ilo.246.1589128271280;
 Sun, 10 May 2020 09:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200501091449.GA25211@nanopsycho.orion> <20200510144557.GA7568@nanopsycho>
In-Reply-To: <20200510144557.GA7568@nanopsycho>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 10 May 2020 09:30:59 -0700
Message-ID: <CAA93jw7ROwOhZNS+dREeFurjn=YxUVWStL+WKZxHgZFLRX+X0w@mail.gmail.com>
Subject: Re: [RFC v2] current devlink extension plan for NICs
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca,
        Saeed Mahameed <saeedm@mellanox.com>, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com,
        Eran Ben Elisha <eranbe@mellanox.com>, vladbu@mellanox.com,
        kliteyn@mellanox.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, Tariq Toukan <tariqt@mellanox.com>,
        oss-drivers@netronome.com, Shannon Nelson <snelson@pensando.io>,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        markz@mellanox.com, jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 7:46 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Hello guys.
>
> Anyone has any opinion on the proposal? Or should I take it as a silent
> agreement? :)
>
> We would like to go ahead and start sending patchsets.

I gotta say that the whole thing makes my head really hurt, and while
this conversation is about how to go about configuring things,
I've been unable to get a grip on how flows will actually behave with
these offloads present.

My overall starting point for thinking about this stuff was described
in this preso to broadcom a few years back:
http://flent-fremont.bufferbloat.net/~d/broadcom_aug9.pdf

More recently I did what I think is my funniest talk ever on these
subjects: https://blog.apnic.net/2020/01/22/bufferbloat-may-be-solved-but-i=
ts-not-over-yet/

Make some popcorn, take a look. :) I should probably have covered
ecn's (mis)behaviors at the end, but I didn't.

Steven hemminger's lca talk on these subjects was also a riot...

so somehow going from my understanding of how stuff gets configured,
to the actual result, is needed, for me to have any opinion at all.
You
have this stuff basically running already? Can you run various
flent.org tests through it?

>
> Thanks!



--=20
"For a successful technology, reality must take precedence over public
relations, for Mother Nature cannot be fooled" - Richard Feynman

dave@taht.net <Dave T=C3=A4ht> CTO, TekLibre, LLC Tel: 1-831-435-0729
