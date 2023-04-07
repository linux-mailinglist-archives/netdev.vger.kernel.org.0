Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE36DA6DD
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjDGBVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjDGBVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:21:06 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3BBA24C;
        Thu,  6 Apr 2023 18:18:11 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id qb20so5346576ejc.6;
        Thu, 06 Apr 2023 18:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680830289; x=1683422289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtUzcz/2Jv4qKihqjsOa4WaQ+Hj4yPYyZeo/umOh554=;
        b=IfU491oXVxDi93JF9/TdQPjs06T2BgcG9r05v0xm/7L+qUPmbAhOdt26z0Z+oX0jhV
         gcHlW5dpGtCmg9lTv184EgEb8uJ9we+rbvqY3sb+fqY5f7bqN1nr1oYvLrhh772x/ptV
         X1VpR3EdfiJydYje02r1/G44sLxjg8V1p0WrIVW1H2jUVO9WunKXoGrOYs/oacWdrwW9
         WhXxs0SSZgPuBsX2vbPzQqc2RKDc6KLQrZtPlo54YO1g3M6z5FaLh1/AYgkuNDbeBONy
         MnIqk7BKL+VRcgHgUTPzwRWXXXP5Ks3f42qwOmWzaAaRgr1EX2lnXmTdDJt0P7MYHyGQ
         UU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680830289; x=1683422289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtUzcz/2Jv4qKihqjsOa4WaQ+Hj4yPYyZeo/umOh554=;
        b=hg/j5iAQ+Q/6rJb8rFIVWIfk6It9Cj8Gwq16DDZi/CStZk0oITK8iH2pL+cu1zowHe
         Yrf62BZpWRylcrruMEIWsPg8uZwgUKutA9sHe7wQOLtE7oGZh5hplIXLO3R6Nrmk9kAF
         TH5swBNxOmvRSYxyDPCQUR0M4K6vbugO2rIiDKsqxvZIedbid7FG/Auzl1ocW8+t22lx
         SRQ1Opfoq8d9/x7bzqLDdGZjWUMmGmjQiWincwgz2slkYmAQHctP3vfzjef9YnXOwg3L
         wifIdTx/fl022VXVh4a4OzK06LSIhnYo/4Il1gOTnMRkemwdeUWiudfyt9fgK7liN7S+
         YOZg==
X-Gm-Message-State: AAQBX9chj0IY/Z71rYldG+zW9+fXggteCuGoh9bN4B0oyl82OMKdRJfW
        EOpc7mjj5TwVf/P9URYQNuCx+jgwOwl2RiTeJwc=
X-Google-Smtp-Source: AKy350bfqIXaAapNpfpsz6SjuLi+OUHZ09lcBLXRbRchaFNEwQZAu1wwHPdIp5ueq4ipE9fBdzaE9SnvM4DzAM6fdao=
X-Received: by 2002:a17:907:20d5:b0:926:8f9:735d with SMTP id
 qq21-20020a17090720d500b0092608f9735dmr367021ejb.3.1680830289076; Thu, 06 Apr
 2023 18:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404145131.GB3896@maniforge> <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
 <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
 <20230404185147.17bf217a@kernel.org> <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
 <20230405111926.7930dbcc@kernel.org> <CAADnVQLhLuB2HG4WqQk6T=oOq2dtXkwy0TjQbnxa4cVDLHq7bg@mail.gmail.com>
 <20230406084217.44fff254@kernel.org>
In-Reply-To: <20230406084217.44fff254@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Apr 2023 18:17:57 -0700
Message-ID: <CAADnVQLOMa=p2m++uTH1i5odXrO5mF9Y++dJZuZyL3gC3MEm0w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 8:42=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 5 Apr 2023 22:13:26 -0700 Alexei Starovoitov wrote:
> > On Wed, Apr 5, 2023 at 11:19=E2=80=AFAM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > >
> > > On Wed, 5 Apr 2023 10:22:16 -0700 Andrii Nakryiko wrote:
> > > > So I'm exclusively using `pw-apply -c <patchworks-url>` to apply
> > > > everything locally.
> > >
> > > I think you can throw -M after -c $url? It can only help... :)
> >
> > Yeah. If only...
> > I'm exclusively using -c.
> > -M only works with -s, but I couldn't make -s -M work either.
> > Do you pass the series as a number?
>
> Yes, it copy just the numerical ID into the terminal.
>
> > but then series_json=3D$(curl -s $srv/series/$1/) line
> > doesn't look right, since it's missing "/mbox/" ?
>
> That's loading JSON from the patchwork's REST API.

This line still doesn't work for me.
curl -s https://patchwork.kernel.org/series/736654/
returns:
The page URL requested (<code>/series/736654/</code>) does not exist.

while
curl -s https://patchwork.kernel.org/series/736654/mbox/
returns proper mbox format.

> > User error on my side, I guess.
> > My bash skills were too weak to make -c and -M work,
> > but .git/hooks tip is great!
> > Thank you.
>
> FWIW I think the below may work for using -c instead of -s.
> But it is mixing "Daniel paths" and "Jakub paths" in the script.
> The output is still a bit different than when using -s.
>
> diff --git a/pw-apply b/pw-apply
> index 5fc37a24b027..c9cec94a4a8c 100755
> --- a/pw-apply
> +++ b/pw-apply
> @@ -81,17 +81,15 @@ accept_series()
>  }
>
>  cover_from_url()
>  {
>    curl -s $1 | gunzip -f -c > tmp.i
> -  series_num=3D`grep "href=3D\"/series" tmp.i|cut -d/ -f3|head -1`
> +  series=3D`grep "href=3D\"/series" tmp.i|cut -d/ -f3|head -1`
>    cover_url=3D`grep "href=3D\"/project/netdevbpf/cover" tmp.i|cut -d\" -=
f2`
>    if [ ! -z "$cover_url" ]; then
> -    curl -s https://patchwork.kernel.org${cover_url}mbox/ | gunzip -f -c=
 > cover.i
>      merge=3D"1"
>    fi
> -  curl -s https://patchwork.kernel.org/series/$series_num/mbox/ | gunzip=
 -f -c > mbox.i
>  }
>
>  edits=3D""
>  am_flags=3D""
>  branch=3D"mbox"
> @@ -118,18 +116,20 @@ while true; do
>      -h | --help ) usage; break ;;
>      -- ) shift; break ;;
>      * )  break ;;
>    esac
>  done
> +# Load the info from cover first, it may will populate $series and $merg=
e
> +[ ! -z "$cover" ]  && cover_from_url $cover
> +
>  [ ! -z "$auto_branch" ] && [ -z "$series" ] && usage
>  [ ! -z "$mbox" ]   && [ ! -z "$series" ] && usage
>  [   -z "$mbox" ]   && [   -z "$series" ] && [ -z "$cover" ] && usage
>  [ ! -z "$accept" ] && [ ! -z "$mbox" ]   && usage
>  [ ! -z "$series" ] && mbox_from_series $series
>  [ ! -z "$mbox" ]   && mbox_from_url $mbox
>  [ ! -z "$accept" ] && accept_series $series
> -[ ! -z "$cover" ]  && cover_from_url $cover

This part completely makes sense! Would be great to converge
on common usage, but json fetch doesn't work for me for some reason.
While mbox via original -c works fine.
